(* This file is part of the Catala compiler, a specification language for tax and social benefits
   computation rules. Copyright (C) 2020 Inria, contributor: Nicolas Chataing
   <nicolas.chataing@ens.fr> Denis Merigoux <denis.merigoux@inria.fr>

   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
   in compliance with the License. You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software distributed under the License
   is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
   or implied. See the License for the specific language governing permissions and limitations under
   the License. *)

(** Builds a context that allows for mapping each name to a precise uid, taking lexical scopes into
    account *)

module Pos = Utils.Pos
module Errors = Utils.Errors

type ident = string

type typ = Dcalc.Ast.typ

type def_context = { var_idmap : Scopelang.Ast.Var.t Desugared.Ast.IdentMap.t }
(** Inside a definition, local variables can be introduced by functions arguments or pattern
    matching *)

type scope_context = {
  var_idmap : Scopelang.Ast.ScopeVar.t Desugared.Ast.IdentMap.t;
  sub_scopes_idmap : Scopelang.Ast.SubScopeName.t Desugared.Ast.IdentMap.t;
  sub_scopes : Scopelang.Ast.ScopeName.t Scopelang.Ast.SubScopeMap.t;
  definitions : def_context Desugared.Ast.ScopeDefMap.t;
      (** Contains the local variables in all the definitions *)
}
(** Inside a scope, we distinguish between the variables and the subscopes. *)

type context = {
  scope_idmap : Scopelang.Ast.ScopeName.t Desugared.Ast.IdentMap.t;
  scopes : scope_context Scopelang.Ast.ScopeMap.t;
  var_typs : typ Pos.marked Scopelang.Ast.ScopeVarMap.t;
}

let raise_unsupported_feature (msg : string) (pos : Pos.t) =
  Errors.raise_spanned_error (Printf.sprintf "unsupported feature: %s" msg) pos

let raise_unknown_identifier (msg : string) (ident : ident Pos.marked) =
  Errors.raise_spanned_error
    (Printf.sprintf "%s: unknown identifier %s" (Pos.unmark ident) msg)
    (Pos.get_position ident)

(** Get the type associated to an uid *)
let get_var_typ (ctxt : context) (uid : Scopelang.Ast.ScopeVar.t) : typ Pos.marked =
  Scopelang.Ast.ScopeVarMap.find uid ctxt.var_typs

(** Process a subscope declaration *)
let process_subscope_decl (scope : Scopelang.Ast.ScopeName.t) (ctxt : context)
    (decl : Ast.scope_decl_context_scope) : context =
  let name, name_pos = decl.scope_decl_context_scope_name in
  let subscope, s_pos = decl.scope_decl_context_scope_sub_scope in
  let scope_ctxt = Scopelang.Ast.ScopeMap.find scope ctxt.scopes in
  match Desugared.Ast.IdentMap.find_opt subscope scope_ctxt.sub_scopes_idmap with
  | Some use ->
      Errors.raise_multispanned_error "subscope name already used"
        [
          (Some "first use", Pos.get_position (Scopelang.Ast.SubScopeName.get_info use));
          (Some "second use", s_pos);
        ]
  | None ->
      let sub_scope_uid = Scopelang.Ast.SubScopeName.fresh (name, name_pos) in
      let original_subscope_uid =
        match Desugared.Ast.IdentMap.find_opt subscope ctxt.scope_idmap with
        | None -> raise_unknown_identifier "for a scope" (subscope, s_pos)
        | Some id -> id
      in
      let scope_ctxt =
        {
          scope_ctxt with
          sub_scopes_idmap =
            Desugared.Ast.IdentMap.add name sub_scope_uid scope_ctxt.sub_scopes_idmap;
          sub_scopes =
            Scopelang.Ast.SubScopeMap.add sub_scope_uid original_subscope_uid scope_ctxt.sub_scopes;
        }
      in
      { ctxt with scopes = Scopelang.Ast.ScopeMap.add scope scope_ctxt ctxt.scopes }

let process_base_typ ((typ, typ_pos) : Ast.base_typ Pos.marked) : Dcalc.Ast.typ Pos.marked =
  match typ with
  | Ast.Condition -> (Dcalc.Ast.TBool, typ_pos)
  | Ast.Data (Ast.Collection _) -> raise_unsupported_feature "collection type" typ_pos
  | Ast.Data (Ast.Optional _) -> raise_unsupported_feature "option type" typ_pos
  | Ast.Data (Ast.Primitive prim) -> (
      match prim with
      | Ast.Integer -> (Dcalc.Ast.TInt, typ_pos)
      | Ast.Decimal | Ast.Money | Ast.Date -> raise_unsupported_feature "value type" typ_pos
      | Ast.Boolean -> (Dcalc.Ast.TBool, typ_pos)
      | Ast.Text -> raise_unsupported_feature "text type" typ_pos
      | Ast.Named _ -> raise_unsupported_feature "struct or enum types" typ_pos )

let process_type ((typ, typ_pos) : Ast.typ Pos.marked) : Dcalc.Ast.typ Pos.marked =
  match typ with
  | Ast.Base base_typ -> process_base_typ (base_typ, typ_pos)
  | Ast.Func { arg_typ; return_typ } ->
      (Dcalc.Ast.TArrow (process_base_typ arg_typ, process_base_typ return_typ), typ_pos)

(** Process data declaration *)
let process_data_decl (scope : Scopelang.Ast.ScopeName.t) (ctxt : context)
    (decl : Ast.scope_decl_context_data) : context =
  (* First check the type of the context data *)
  let data_typ = process_type decl.scope_decl_context_item_typ in
  let name, pos = decl.scope_decl_context_item_name in
  let scope_ctxt = Scopelang.Ast.ScopeMap.find scope ctxt.scopes in
  match Desugared.Ast.IdentMap.find_opt name scope_ctxt.var_idmap with
  | Some use ->
      Errors.raise_multispanned_error "var name already used"
        [
          (Some "first use", Pos.get_position (Scopelang.Ast.ScopeVar.get_info use));
          (Some "second use", pos);
        ]
  | None ->
      let uid = Scopelang.Ast.ScopeVar.fresh (name, pos) in
      let scope_ctxt =
        { scope_ctxt with var_idmap = Desugared.Ast.IdentMap.add name uid scope_ctxt.var_idmap }
      in
      {
        ctxt with
        scopes = Scopelang.Ast.ScopeMap.add scope scope_ctxt ctxt.scopes;
        var_typs = Scopelang.Ast.ScopeVarMap.add uid data_typ ctxt.var_typs;
      }

(** Process an item declaration *)
let process_item_decl (scope : Scopelang.Ast.ScopeName.t) (ctxt : context)
    (decl : Ast.scope_decl_context_item) : context =
  match decl with
  | Ast.ContextData data_decl -> process_data_decl scope ctxt data_decl
  | Ast.ContextScope sub_decl -> process_subscope_decl scope ctxt sub_decl

(** Adds a binding to the context *)
let add_def_local_var (ctxt : context) (scope_uid : Scopelang.Ast.ScopeName.t)
    (def_uid : Desugared.Ast.ScopeDef.t) (name : ident Pos.marked) : context =
  let scope_ctxt = Scopelang.Ast.ScopeMap.find scope_uid ctxt.scopes in
  let def_ctx = Desugared.Ast.ScopeDefMap.find def_uid scope_ctxt.definitions in
  let local_var_uid = Scopelang.Ast.Var.make name in
  let def_ctx =
    { var_idmap = Desugared.Ast.IdentMap.add (Pos.unmark name) local_var_uid def_ctx.var_idmap }
  in
  let scope_ctxt =
    {
      scope_ctxt with
      definitions = Desugared.Ast.ScopeDefMap.add def_uid def_ctx scope_ctxt.definitions;
    }
  in
  { ctxt with scopes = Scopelang.Ast.ScopeMap.add scope_uid scope_ctxt ctxt.scopes }

(** Process a scope declaration *)
let process_scope_decl (ctxt : context) (decl : Ast.scope_decl) : context =
  let name, pos = decl.scope_decl_name in
  (* Checks if the name is already used *)
  match Desugared.Ast.IdentMap.find_opt name ctxt.scope_idmap with
  | Some use ->
      Errors.raise_multispanned_error "scope name already used"
        [
          (Some "first use", Pos.get_position (Scopelang.Ast.ScopeName.get_info use));
          (Some "second use", pos);
        ]
  | None ->
      let scope_uid = Scopelang.Ast.ScopeName.fresh (name, pos) in
      let ctxt =
        {
          ctxt with
          scope_idmap = Desugared.Ast.IdentMap.add name scope_uid ctxt.scope_idmap;
          scopes =
            Scopelang.Ast.ScopeMap.add scope_uid
              {
                var_idmap = Desugared.Ast.IdentMap.empty;
                sub_scopes_idmap = Desugared.Ast.IdentMap.empty;
                definitions = Desugared.Ast.ScopeDefMap.empty;
                sub_scopes = Scopelang.Ast.SubScopeMap.empty;
              }
              ctxt.scopes;
        }
      in
      List.fold_left
        (fun ctxt item -> process_item_decl scope_uid ctxt (Pos.unmark item))
        ctxt decl.scope_decl_context

let qident_to_scope_def (ctxt : context) (scope_uid : Scopelang.Ast.ScopeName.t)
    (id : Ast.qident Pos.marked) : Desugared.Ast.ScopeDef.t =
  let scope_ctxt = Scopelang.Ast.ScopeMap.find scope_uid ctxt.scopes in
  match Pos.unmark id with
  | [ x ] -> (
      match Desugared.Ast.IdentMap.find_opt (Pos.unmark x) scope_ctxt.var_idmap with
      | None -> raise_unknown_identifier "for a var of the scope" x
      | Some id -> Desugared.Ast.ScopeDef.Var id )
  | [ s; x ] -> (
      let sub_scope_uid =
        match Desugared.Ast.IdentMap.find_opt (Pos.unmark s) scope_ctxt.sub_scopes_idmap with
        | None -> raise_unknown_identifier "for a subscope of this scope" s
        | Some id -> id
      in
      let real_sub_scope_uid = Scopelang.Ast.SubScopeMap.find sub_scope_uid scope_ctxt.sub_scopes in
      let sub_scope_ctx = Scopelang.Ast.ScopeMap.find real_sub_scope_uid ctxt.scopes in
      match Desugared.Ast.IdentMap.find_opt (Pos.unmark x) sub_scope_ctx.var_idmap with
      | None -> raise_unknown_identifier "for a var of this subscope" x
      | Some id -> Desugared.Ast.ScopeDef.SubScopeVar (sub_scope_uid, id) )
  | _ -> raise_unsupported_feature "wrong qident" (Pos.get_position id)

let process_scope_use (ctxt : context) (use : Ast.scope_use) : context =
  let scope_uid =
    match Desugared.Ast.IdentMap.find_opt (Pos.unmark use.scope_use_name) ctxt.scope_idmap with
    | None -> raise_unknown_identifier "for a scope" use.scope_use_name
    | Some id -> id
  in
  List.fold_left
    (fun ctxt use_item ->
      match Pos.unmark use_item with
      | Ast.Definition def ->
          let scope_ctxt = Scopelang.Ast.ScopeMap.find scope_uid ctxt.scopes in
          let def_uid = qident_to_scope_def ctxt scope_uid def.definition_name in
          let def_ctxt = { var_idmap = Desugared.Ast.IdentMap.empty } in
          let scope_ctxt =
            {
              scope_ctxt with
              definitions = Desugared.Ast.ScopeDefMap.add def_uid def_ctxt scope_ctxt.definitions;
            }
          in
          { ctxt with scopes = Scopelang.Ast.ScopeMap.add scope_uid scope_ctxt ctxt.scopes }
      | _ -> raise_unsupported_feature "unsupported item" (Pos.get_position use_item))
    ctxt use.scope_use_items

(** Process a code item : for now it only handles scope decls *)
let process_use_item (ctxt : context) (item : Ast.code_item Pos.marked) : context =
  match Pos.unmark item with
  | ScopeDecl _ -> ctxt
  | ScopeUse use -> process_scope_use ctxt use
  | _ -> raise_unsupported_feature "item not supported" (Pos.get_position item)

(** Process a code item : for now it only handles scope decls *)
let process_decl_item (ctxt : context) (item : Ast.code_item Pos.marked) : context =
  match Pos.unmark item with ScopeDecl decl -> process_scope_decl ctxt decl | _ -> ctxt

(** Process a code block *)
let process_code_block (ctxt : context) (block : Ast.code_block)
    (process_item : context -> Ast.code_item Pos.marked -> context) : context =
  List.fold_left (fun ctxt decl -> process_item ctxt decl) ctxt block

(** Process a program item *)
let process_law_article_item (ctxt : context) (item : Ast.law_article_item)
    (process_item : context -> Ast.code_item Pos.marked -> context) : context =
  match item with CodeBlock (block, _) -> process_code_block ctxt block process_item | _ -> ctxt

(** Process a law structure *)
let rec process_law_structure (ctxt : context) (s : Ast.law_structure)
    (process_item : context -> Ast.code_item Pos.marked -> context) : context =
  match s with
  | Ast.LawHeading (_, children) ->
      List.fold_left (fun ctxt child -> process_law_structure ctxt child process_item) ctxt children
  | Ast.LawArticle (_, children) ->
      List.fold_left
        (fun ctxt child -> process_law_article_item ctxt child process_item)
        ctxt children
  | Ast.MetadataBlock (b, c) -> process_law_article_item ctxt (Ast.CodeBlock (b, c)) process_item
  | Ast.IntermediateText _ -> ctxt

(** Process a program item *)
let process_program_item (ctxt : context) (item : Ast.program_item)
    (process_item : context -> Ast.code_item Pos.marked -> context) : context =
  match item with Ast.LawStructure s -> process_law_structure ctxt s process_item

(** Derive the context from metadata, in two passes *)
let form_context (prgm : Ast.program) : context =
  let empty_ctxt =
    {
      scope_idmap = Desugared.Ast.IdentMap.empty;
      scopes = Scopelang.Ast.ScopeMap.empty;
      var_typs = Scopelang.Ast.ScopeVarMap.empty;
    }
  in
  let ctxt =
    List.fold_left
      (fun ctxt item -> process_program_item ctxt item process_decl_item)
      empty_ctxt prgm.program_items
  in
  List.fold_left
    (fun ctxt item -> process_program_item ctxt item process_use_item)
    ctxt prgm.program_items

(** Get the variable uid inside the scope given in argument *)
let get_var_uid (scope_uid : Scopelang.Ast.ScopeName.t) (ctxt : context)
    ((x, pos) : ident Pos.marked) : Scopelang.Ast.ScopeVar.t =
  let scope = Scopelang.Ast.ScopeMap.find scope_uid ctxt.scopes in
  match Desugared.Ast.IdentMap.find_opt x scope.var_idmap with
  | None -> raise_unknown_identifier "for a var of this scope" (x, pos)
  | Some uid -> uid

(** Get the subscope uid inside the scope given in argument *)
let get_subscope_uid (scope_uid : Scopelang.Ast.ScopeName.t) (ctxt : context)
    ((y, pos) : ident Pos.marked) : Scopelang.Ast.SubScopeName.t =
  let scope = Scopelang.Ast.ScopeMap.find scope_uid ctxt.scopes in
  match Desugared.Ast.IdentMap.find_opt y scope.sub_scopes_idmap with
  | None -> raise_unknown_identifier "for a subscope of this scope" (y, pos)
  | Some sub_uid -> sub_uid

(** Checks if the var_uid belongs to the scope scope_uid *)
let belongs_to (ctxt : context) (uid : Scopelang.Ast.ScopeVar.t)
    (scope_uid : Scopelang.Ast.ScopeName.t) : bool =
  let scope = Scopelang.Ast.ScopeMap.find scope_uid ctxt.scopes in
  Desugared.Ast.IdentMap.exists
    (fun _ var_uid -> Scopelang.Ast.ScopeVar.compare uid var_uid = 0)
    scope.var_idmap

let get_def_typ (ctxt : context) (def : Desugared.Ast.ScopeDef.t) : typ Pos.marked =
  match def with
  | Desugared.Ast.ScopeDef.SubScopeVar (_, x)
  (* we don't need to look at the subscope prefix because [x] is already the uid referring back to
     the original subscope *)
  | Desugared.Ast.ScopeDef.Var x ->
      Scopelang.Ast.ScopeVarMap.find x ctxt.var_typs