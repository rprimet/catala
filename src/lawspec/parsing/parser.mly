(*
  This file is part of the Lawspec compiler, a specification language for tax and social benefits
  computation rules.
  Copyright (C) 2019 Inria, contributor: Denis Merigoux <denis.merigoux@inria.fr>

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*)

%{
  open Ast
%}

%token EOF
%token<string> LAW_ARTICLE
%token<string> LAW_CODE
%token<string> LAW_TEXT
%token<string> CONSTRUCTOR IDENT
%token<string> END_CODE
%token<int> INT_LITERAL
%token BEGIN_CODE
%token COLON ALT DATA
%token OF INTEGER COLLECTION
%token RULE CONDITION DEFINED_AS
%token EXISTS IN SUCH THAT NOW LESSER GREATER
%token DOT AND OR LPAREN RPAREN OPTIONAL EQUAL
%token COMMA CARDINAL LESSER_EQUAL GREATER_EQUAL
%token ASSERTION FIXED BY YEAR
%token PLUS MINUS MULT DIV MATCH WITH VARIES_WITH
%token FORALL WE_HAVE INCREASING DECREASING
%token NOT BOOLEAN
%token FIELD FILLED IFF EURO NOT_EQUAL DEFINITION
%token STRUCT CONTENT IF THEN DEPENDS DECLARATION
%token CONTEXT INCLUDES

%type <Ast.source_file> source_file

%start source_file

%%

typ_base:
| IDENT {}
| INTEGER {}
| BOOLEAN {}
| CONSTRUCTOR {}

typ:
| typ_base option(OPTIONAL) {}

qident:
| IDENT {}
| IDENT DOT IDENT {}

primitive_expression:
| NOW {}
| qident {}

date_qualifier:
| YEAR {}

constructor_payload:
| OF base_expression {}

literal:
| INT_LITERAL {}
| INT_LITERAL EURO {}
| INT_LITERAL date_qualifier {}
| CONSTRUCTOR option(constructor_payload) {}

compare_op:
| LESSER {}
| LESSER_EQUAL {}
| GREATER {}
| GREATER_EQUAL {}
| EQUAL {}
| NOT_EQUAL {}

func:
| CARDINAL {}
| qident {}

base_expression:
| primitive_expression {}
| literal {}
| func OF separated_nonempty_list(COMMA, primitive_expression) {}
| LPAREN expression RPAREN {}

mult_op:
| MULT {}
| DIV {}

mult_expression:
| base_expression {}
| base_expression mult_op mult_expression {}

sum_op:
| PLUS {}
| MINUS {}

sum_expression:
| mult_expression {}
| mult_expression sum_op sum_expression {}

logical_op:
| AND {}
| OR {}
| IFF {}

logical_unop:
| NOT {}

compare_expression:
| sum_expression {}
| sum_expression compare_op compare_expression {}

logical_expression:
| compare_expression {}
| logical_unop compare_expression {}
| compare_expression logical_op logical_expression {}

optional_binding:
| {}
| OF IDENT {}
| OF LPAREN constructor_binding RPAREN {}

constructor_binding:
| CONSTRUCTOR optional_binding {}

match_arm:
| constructor_binding COLON logical_expression {}

match_arms:
| ALT match_arm match_arms {}
| {}

forall_prefix:
| FORALL separated_nonempty_list(COMMA,IDENT) IN separated_nonempty_list(COMMA,qident) WE_HAVE {}

exists_prefix:
| EXISTS IDENT IN qident SUCH THAT {}

expression:
| exists_prefix expression {}
| forall_prefix expression {}
| MATCH expression WITH  match_arms {}
| logical_expression {}

condition:
| IF expression THEN {}


rule:
| option(condition) option(forall_prefix) qident FILLED {}

definition_parameters:
| OF separated_nonempty_list(COMMA, IDENT) {}

definition:
| option(forall_prefix) qident option(definition_parameters) option(condition) DEFINED_AS expression {}

variation_type:
| INCREASING {}
| DECREASING {}

assertion:
| logical_expression {}
| qident FIXED BY IDENT {}
| qident VARIES_WITH base_expression option(variation_type) {}
| exists_prefix assertion {}
| forall_prefix assertion {}

application_field_item:
| RULE option(OPTIONAL) rule {}
| DEFINITION option(OPTIONAL) definition {}
| ASSERTION option(condition) assertion {}

struct_field_base:
| DATA IDENT option(COLLECTION) CONTENT typ {}
| CONDITION IDENT {}

struct_field_func:
| DEPENDS OF typ {}

struct_field:
| struct_field_base option(struct_field_func) {}

field_decl_item:
| CONTEXT IDENT STRUCT CONSTRUCTOR {}

field_decl_include:
| CONSTRUCTOR DOT IDENT EQUAL IDENT {}

field_decl_includes:
| INCLUDES FIELD CONSTRUCTOR CONTEXT nonempty_list(field_decl_include) {}

code_item:
| FIELD CONSTRUCTOR COLON nonempty_list(application_field_item) { }
| DECLARATION STRUCT CONSTRUCTOR COLON nonempty_list(struct_field) {}
| DECLARATION FIELD CONSTRUCTOR COLON nonempty_list(field_decl_item) option(field_decl_includes) {}

code:
| code_item code {}
| {}

source_file_item:
| title = LAW_ARTICLE { LawArticle title }
| code = LAW_CODE { LawCode code }
| text = LAW_TEXT { LawText text }
| BEGIN_CODE code text = END_CODE { CodeBlock text }

source_file:
| i = source_file_item f = source_file { i::f }
| EOF { [] }
