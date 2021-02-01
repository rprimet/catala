open Catala.Runtime

[@@@ocaml.warning "-26"]

type garde_alternee =
  | OuiPartageAllocations of unit
  | OuiAllocataireUnique of unit
  | NonGardeUnique of unit


type prise_en_charge_service_sociaux =
  | OuiAllocationVerseeALaFamille of
  unit
  | OuiAllocationVerseeAuxServicesSociaux of unit
  | NonPriseEnChargeFamille of unit


type collectivite =
  | Guadeloupe of unit
  | Guyane of unit
  | Martinique of unit
  | LaReunion of unit
  | SaintBarthelemy of unit
  | SaintMartin of unit
  | Metropole of unit
  | SaintPierreEtMiquelon of unit
  | Mayotte of unit


type prise_en_compte_evaluation_montant =
  | Complete of unit
  | Partagee of unit


type versement_allocations =
  | Normal of unit
  | AllocationVerseeAuxServicesSociaux of unit


type age_alternatif =
  | Absent of unit
  | Present of integer


type element_prestations_familiales =
  | PrestationAccueilJeuneEnfant of unit
  | AllocationsFamiliales of unit
  | ComplementFamilial of unit
  | AllocationLogement of unit
  | AllocationEducationEnfantHandicape of unit
  | AllocationSoutienFamilial of unit
  | AllocationRentreeScolaire of unit
  | AllocationJournalierePresenceParentale of unit


type personne = {
  numero_securite_sociale: integer;
}

type enfant_entree = {
  d_identifiant: integer;
  d_remuneration_mensuelle: money;
  d_date_de_naissance: date;
  d_garde_alternee: garde_alternee;
  d_pris_en_charge_par_services_sociaux: prise_en_charge_service_sociaux;
}

type enfant = {
  identifiant: integer;
  fin_obligation_scolaire: date;
  remuneration_mensuelle: money;
  date_de_naissance: date;
  age: integer;
  garde_alternee: garde_alternee;
  pris_en_charge_par_services_sociaux: prise_en_charge_service_sociaux;
}

type stockage_enfant =
  | PasEnfant of unit
  | UnEnfant of enfant


type smic_out = {
  date_courante_out: date;
  residence_out: collectivite;
  brut_horaire_out: money;
}

type smic_in = {
  date_courante_in: unit -> date;
  residence_in: unit -> collectivite;
  brut_horaire_in: unit -> money;
}

type prestations_familiales_out = {
  droit_ouvert_out: enfant -> bool;
  conditions_hors_age_out: enfant -> bool;
  plafond_l512_3_2_out: money;
  age_l512_3_2_out: integer;
  age_l512_3_2_alternatif_out: age_alternatif;
  regime_outre_mer_l751_1_out: bool;
  date_courante_out: date;
  prestation_courante_out: element_prestations_familiales;
  residence_out: collectivite;
  base_mensuelle_out: money;
}

type prestations_familiales_in = {
  droit_ouvert_in: unit -> (enfant -> bool);
  conditions_hors_age_in: unit -> (enfant -> bool);
  plafond_l512_3_2_in: unit -> money;
  age_l512_3_2_in: unit -> integer;
  age_l512_3_2_alternatif_in:
  unit -> age_alternatif;
  regime_outre_mer_l751_1_in: unit -> bool;
  date_courante_in: unit -> date;
  prestation_courante_in:
  unit -> element_prestations_familiales;
  residence_in: unit -> collectivite;
  base_mensuelle_in: unit -> money;
}

type allocation_familiales_avril2008_out = {
  age_limite_alinea_1_l521_3_out: integer;
}

type allocation_familiales_avril2008_in = {
  age_limite_alinea_1_l521_3_in: unit -> integer;
}

type enfant_le_plus_age_out = {
  enfants_out: enfant array;
  le_plus_age_out: enfant;
}

type enfant_le_plus_age_in = {
  enfants_in: unit -> (enfant array);
  le_plus_age_in: unit -> enfant;
}

type allocations_familiales_out = {
  enfants_a_charge_out:
  enfant array;
  enfants_a_charge_droit_ouvert_prestation_familiale_out:
  enfant array;
  date_courante_out: date;
  residence_out: collectivite;
  ressources_menage_out: money;
  prise_en_compte_out:
  enfant -> prise_en_compte_evaluation_montant;
  versement_out: enfant -> versement_allocations;
  montant_verse_out: money;
  droit_ouvert_base_out: bool;
  droit_ouvert_majoration_out: enfant -> bool;
  montant_verse_base_out: money;
  montant_avec_garde_alternee_base_out: money;
  montant_initial_base_out: money;
  montant_initial_base_premier_enfant_out:
  money;
  montant_initial_base_deuxieme_enfant_out:
  money;
  montant_initial_base_troisieme_enfant_et_plus_out:
  money;
  rapport_enfants_total_moyen_out: decimal;
  nombre_moyen_enfants_out: decimal;
  nombre_total_enfants_out: decimal;
  droit_ouvert_forfaitaire_out: enfant -> bool;
  montant_verse_forfaitaire_out: money;
  montant_verse_majoration_out:
  money;
  montant_avec_garde_alternee_majoration_out:
  enfant -> money;
  montant_initial_majoration_out:
  enfant -> money;
  droit_ouvert_complement_out:
  bool;
  montant_verse_complement_pour_base_et_majoration_out:
  money;
  montant_base_complement_pour_base_et_majoration_out:
  money;
  montant_verse_complement_pour_forfaitaire_out:
  money;
  depassement_plafond_ressources_out: money -> money;
  conditions_hors_age_out: enfant -> bool;
  nombre_enfants_l521_1_out: integer;
  age_limite_alinea_1_l521_3_out:
  enfant -> integer;
  nombre_enfants_alinea_2_l521_3_out: integer;
  est_enfant_le_plus_age_out: enfant -> bool;
  plafond_I_d521_3_out: money;
  plafond_II_d521_3_out: money;
}

type allocations_familiales_in = {
  enfants_a_charge_in:
  unit -> (enfant array);
  enfants_a_charge_droit_ouvert_prestation_familiale_in:
  unit -> (enfant array);
  date_courante_in: unit -> date;
  residence_in: unit -> collectivite;
  ressources_menage_in: unit -> money;
  prise_en_compte_in:
  unit -> (enfant -> prise_en_compte_evaluation_montant);
  versement_in: unit -> (enfant -> versement_allocations);
  montant_verse_in: unit -> money;
  droit_ouvert_base_in: unit -> bool;
  droit_ouvert_majoration_in: unit -> (enfant -> bool);
  montant_verse_base_in: unit -> money;
  montant_avec_garde_alternee_base_in: unit -> money;
  montant_initial_base_in:
  unit -> money;
  montant_initial_base_premier_enfant_in:
  unit -> money;
  montant_initial_base_deuxieme_enfant_in:
  unit -> money;
  montant_initial_base_troisieme_enfant_et_plus_in:
  unit -> money;
  rapport_enfants_total_moyen_in: unit -> decimal;
  nombre_moyen_enfants_in: unit -> decimal;
  nombre_total_enfants_in: unit -> decimal;
  droit_ouvert_forfaitaire_in:
  unit -> (enfant -> bool);
  montant_verse_forfaitaire_in: unit -> money;
  montant_verse_majoration_in:
  unit -> money;
  montant_avec_garde_alternee_majoration_in:
  unit -> (enfant -> money);
  montant_initial_majoration_in:
  unit -> (enfant -> money);
  droit_ouvert_complement_in:
  unit -> bool;
  montant_verse_complement_pour_base_et_majoration_in:
  unit -> money;
  montant_base_complement_pour_base_et_majoration_in:
  unit -> money;
  montant_verse_complement_pour_forfaitaire_in:
  unit -> money;
  depassement_plafond_ressources_in:
  unit -> (money -> money);
  conditions_hors_age_in: unit -> (enfant -> bool);
  nombre_enfants_l521_1_in: unit -> integer;
  age_limite_alinea_1_l521_3_in:
  unit -> (enfant -> integer);
  nombre_enfants_alinea_2_l521_3_in:
  unit -> integer;
  est_enfant_le_plus_age_in: unit -> (enfant -> bool);
  plafond_I_d521_3_in: unit -> money;
  plafond_II_d521_3_in: unit -> money;
}

type interface_allocations_familiales_out = {
  date_courante_out: date;
  enfants_out: enfant_entree array;
  enfants_a_charge_out: enfant array;
  ressources_menage_out: money;
  residence_out: collectivite;
  montant_verse_out: money;
}

type interface_allocations_familiales_in = {
  date_courante_in: unit -> date;
  enfants_in: unit -> (enfant_entree array);
  enfants_a_charge_in: unit -> (enfant array);
  ressources_menage_in: unit -> money;
  residence_in: unit -> collectivite;
  montant_verse_in: unit -> money;
}



let smic =
  fun (smic_in: smic_in) ->
    let date_courante_ : unit -> date = (smic_in.date_courante_in)
    in
    let residence_ : unit -> collectivite = (smic_in.residence_in)
    in
    let brut_horaire_ : unit -> money = (smic_in.brut_horaire_in)
    in
    let date_courante_ : date =
      ((error_empty
          (handle_default ([|(fun (_: _) -> date_courante_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let residence_ : collectivite =
      ((error_empty
          (handle_default ([|(fun (_: _) -> residence_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let brut_horaire_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> brut_horaire_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((date_courante_ >=@ (date_of_numbers 2020 1 1))
                                &&
                                ((date_courante_ <=@
                                    (date_of_numbers 2020 12 31)) &&
                                   (residence_ = (Mayotte ())))))
                          (fun (_: _) -> money_of_cent_string "766"));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((date_courante_ >=@ (date_of_numbers 2020 1 1))
                                &&
                                ((date_courante_ <=@
                                    (date_of_numbers 2020 12 31)) &&
                                   ((residence_ = (Metropole ())) ||
                                      ((residence_ = (Guadeloupe ())) ||
                                         ((residence_ = (Guyane ())) ||
                                            ((residence_ = (Martinique ()))
                                               ||
                                               ((residence_ = (LaReunion ()))
                                                  ||
                                                  ((residence_ =
                                                      (SaintBarthelemy ()))
                                                     ||
                                                     ((residence_ =
                                                         (SaintMartin ())) ||
                                                        (residence_ =
                                                           (SaintPierreEtMiquelon
                                                              ()))))))))))))
                          (fun (_: _) -> money_of_cent_string "1015"));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((date_courante_ >=@ (date_of_numbers 2019 1 1))
                                &&
                                ((date_courante_ <=@
                                    (date_of_numbers 2019 12 31)) &&
                                   (residence_ = (Mayotte ())))))
                          (fun (_: _) -> money_of_cent_string "757"));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((date_courante_ >=@ (date_of_numbers 2019 1 1))
                                &&
                                ((date_courante_ <=@
                                    (date_of_numbers 2019 12 31)) &&
                                   ((residence_ = (Metropole ())) ||
                                      ((residence_ = (Guadeloupe ())) ||
                                         ((residence_ = (Guyane ())) ||
                                            ((residence_ = (Martinique ()))
                                               ||
                                               ((residence_ = (LaReunion ()))
                                                  ||
                                                  ((residence_ =
                                                      (SaintBarthelemy ()))
                                                     ||
                                                     ((residence_ =
                                                         (SaintMartin ())) ||
                                                        (residence_ =
                                                           (SaintPierreEtMiquelon
                                                              ()))))))))))))
                          (fun (_: _) -> money_of_cent_string "1003"))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    {date_courante_out = date_courante_; residence_out = residence_;
       brut_horaire_out = brut_horaire_}

let allocation_familiales_avril2008 =
  fun
    (allocation_familiales_avril2008_in: allocation_familiales_avril2008_in) ->
    let age_limite_alinea_1_l521_3_ : unit -> integer =
      (allocation_familiales_avril2008_in.age_limite_alinea_1_l521_3_in)
    in
    let age_limite_alinea_1_l521_3_ : integer =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> age_limite_alinea_1_l521_3_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) -> integer_of_string "16"))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    {age_limite_alinea_1_l521_3_out = age_limite_alinea_1_l521_3_}

let enfant_le_plus_age =
  fun (enfant_le_plus_age_in: enfant_le_plus_age_in) ->
    let enfants_ : unit -> (enfant array) =
      (enfant_le_plus_age_in.enfants_in)
    in
    let le_plus_age_ : unit -> enfant =
      (enfant_le_plus_age_in.le_plus_age_in)
    in
    let enfants_ : enfant array =
      ((error_empty
          (handle_default ([|(fun (_: _) -> enfants_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let le_plus_age_ : enfant =
      ((error_empty
          (handle_default ([|(fun (_: _) -> le_plus_age_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                             let predicate_ : _ =
                               (fun (potentiel_plus_age_: _) ->
                                  potentiel_plus_age_.age)
                             in
                             (Array.fold_left
                                (fun (acc_: _) (item_: _) ->
                                    if
                                     ((predicate_ acc_) >! (predicate_ item_))
                                     then acc_ else item_)
                                {identifiant = (~-! (integer_of_string "1"));
                                   fin_obligation_scolaire =
                                     (date_of_numbers 1900 1 1);
                                   remuneration_mensuelle =
                                     (money_of_cent_string "0");
                                   date_de_naissance =
                                     (date_of_numbers 1900 1 1);
                                   age = (integer_of_string "0");
                                   garde_alternee = (NonGardeUnique ());
                                   pris_en_charge_par_services_sociaux =
                                     (NonPriseEnChargeFamille ())} enfants_)))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    {enfants_out = enfants_; le_plus_age_out = le_plus_age_}

let prestations_familiales =
  fun (prestations_familiales_in: prestations_familiales_in) ->
    let droit_ouvert_ : unit -> (enfant -> bool) =
      (prestations_familiales_in.droit_ouvert_in)
    in
    let conditions_hors_age_ : unit -> (enfant -> bool) =
      (prestations_familiales_in.conditions_hors_age_in)
    in
    let plafond_l512_3_2_ : unit -> money =
      (prestations_familiales_in.plafond_l512_3_2_in)
    in
    let age_l512_3_2_ : unit -> integer =
      (prestations_familiales_in.age_l512_3_2_in)
    in
    let age_l512_3_2_alternatif_ : unit -> age_alternatif =
      (prestations_familiales_in.age_l512_3_2_alternatif_in)
    in
    let regime_outre_mer_l751_1_ : unit -> bool =
      (prestations_familiales_in.regime_outre_mer_l751_1_in)
    in
    let date_courante_ : unit -> date =
      (prestations_familiales_in.date_courante_in)
    in
    let prestation_courante_ : unit -> element_prestations_familiales =
      (prestations_familiales_in.prestation_courante_in)
    in
    let residence_ : unit -> collectivite =
      (prestations_familiales_in.residence_in)
    in
    let base_mensuelle_ : unit -> money =
      (prestations_familiales_in.base_mensuelle_in)
    in
    let age_l512_3_2_alternatif_ : age_alternatif =
      ((error_empty
          (handle_default ([|(fun (_: _) -> age_l512_3_2_alternatif_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) -> Absent ()))|]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let date_courante_ : date =
      ((error_empty
          (handle_default ([|(fun (_: _) -> date_courante_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let prestation_courante_ : element_prestations_familiales =
      ((error_empty
          (handle_default ([|(fun (_: _) -> prestation_courante_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let residence_ : collectivite =
      ((error_empty
          (handle_default ([|(fun (_: _) -> residence_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let base_mensuelle_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> base_mensuelle_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((date_courante_ >=@ (date_of_numbers 2020 4 1))
                                &&
                                (date_courante_ <@ (date_of_numbers 2021 4 1))))
                          (fun (_: _) -> money_of_cent_string "41404"));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((date_courante_ >=@ (date_of_numbers 2019 4 1))
                                &&
                                (date_courante_ <@ (date_of_numbers 2020 4 1))))
                          (fun (_: _) -> money_of_cent_string "41316"))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let age_l512_3_2_ : integer =
      ((error_empty
          (handle_default ([|(fun (_: _) -> age_l512_3_2_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) -> integer_of_string "20"));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((match age_l512_3_2_alternatif_
                                with
                                Absent _ -> false
                                | Present _ -> true) &&
                                ((prestation_courante_ =
                                    (ComplementFamilial ())) ||
                                   (prestation_courante_ =
                                      (AllocationLogement ())))))
                          (fun (_: _) -> match age_l512_3_2_alternatif_
                             with
                             Absent _ -> (integer_of_string "0")
                             | Present age_ -> age_))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let smic_dot_date_courante_ : unit -> date =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> date_courante_))|]) (fun (_: _) -> false)
            (fun (_: _) -> raise EmptyError)))
    in
    let smic_dot_residence_ : unit -> collectivite =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> residence_))|]) (fun (_: _) -> false)
            (fun (_: _) -> raise EmptyError)))
    in
    let result_ : smic_out =
      (((smic)
          {date_courante_in = smic_dot_date_courante_;
             residence_in = smic_dot_residence_;
             brut_horaire_in = (fun (_: unit) -> raise EmptyError)}))
    in
    let smic_dot_date_courante_ : date = (result_.date_courante_out)
    in
    let smic_dot_residence_ : collectivite = (result_.residence_out)
    in
    let smic_dot_brut_horaire_ : money = (result_.brut_horaire_out)
    in
    let regime_outre_mer_l751_1_ : bool =
      ((error_empty
          (handle_default ([|(fun (_: _) -> regime_outre_mer_l751_1_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((residence_ = (Guadeloupe ())) ||
                                ((residence_ = (Guyane ())) ||
                                   ((residence_ = (Martinique ())) ||
                                      ((residence_ = (LaReunion ())) ||
                                         ((residence_ = (SaintBarthelemy ()))
                                            ||
                                            (residence_ = (SaintMartin ()))))))))
                          (fun (_: _) -> true))|]) (fun (_: _) -> true)
                  (fun (_: _) -> false)))))
    in
    let plafond_l512_3_2_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> plafond_l512_3_2_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default
                          ([|(fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) -> regime_outre_mer_l751_1_)
                                  (fun (_: _) ->
                                     (smic_dot_brut_horaire_ *$
                                        (decimal_of_string "0.55")) *$
                                       (decimal_of_string "169.")))|])
                          (fun (_: _) -> true)
                          (fun (_: _) ->
                             (smic_dot_brut_horaire_ *$
                                (decimal_of_string "0.55")) *$
                               (decimal_of_string "169.")))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let conditions_hors_age_ : enfant -> bool =
      ((error_empty
          (handle_default ([|(fun (_: _) -> conditions_hors_age_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  ((date_courante_ <=@
                                      (param_.fin_obligation_scolaire)) ||
                                     ((param_.remuneration_mensuelle) <=$
                                        plafond_l512_3_2_)))
                               (fun (_: _) -> true))|]) (fun (_: _) -> true)
                       (fun (_: _) -> false))))))
    in
    let droit_ouvert_ : enfant -> bool =
      ((error_empty
          (handle_default ([|(fun (_: _) -> droit_ouvert_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  ((date_courante_ >@
                                      (param_.fin_obligation_scolaire)) &&
                                     (((((conditions_hors_age_) (param_))))
                                        && ((param_.age) <! age_l512_3_2_))))
                               (fun (_: _) -> true));
                          (fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  (date_courante_ <=@
                                     (param_.fin_obligation_scolaire)))
                               (fun (_: _) -> true))|]) (fun (_: _) -> true)
                       (fun (_: _) -> false))))))
    in
    {droit_ouvert_out = droit_ouvert_;
       conditions_hors_age_out = conditions_hors_age_;
       plafond_l512_3_2_out = plafond_l512_3_2_;
       age_l512_3_2_out = age_l512_3_2_;
       age_l512_3_2_alternatif_out = age_l512_3_2_alternatif_;
       regime_outre_mer_l751_1_out = regime_outre_mer_l751_1_;
       date_courante_out = date_courante_;
       prestation_courante_out = prestation_courante_;
       residence_out = residence_; base_mensuelle_out = base_mensuelle_}

let allocations_familiales =
  fun (allocations_familiales_in: allocations_familiales_in) ->
    let enfants_a_charge_ : unit -> (enfant array) =
      (allocations_familiales_in.enfants_a_charge_in)
    in
    let enfants_a_charge_droit_ouvert_prestation_familiale_ :
      unit -> (enfant array) =
      (allocations_familiales_in.enfants_a_charge_droit_ouvert_prestation_familiale_in)
    in
    let date_courante_ : unit -> date =
      (allocations_familiales_in.date_courante_in)
    in
    let residence_ : unit -> collectivite =
      (allocations_familiales_in.residence_in)
    in
    let ressources_menage_ : unit -> money =
      (allocations_familiales_in.ressources_menage_in)
    in
    let prise_en_compte_ :
      unit -> (enfant -> prise_en_compte_evaluation_montant) =
      (allocations_familiales_in.prise_en_compte_in)
    in
    let versement_ : unit -> (enfant -> versement_allocations) =
      (allocations_familiales_in.versement_in)
    in
    let montant_verse_ : unit -> money =
      (allocations_familiales_in.montant_verse_in)
    in
    let droit_ouvert_base_ : unit -> bool =
      (allocations_familiales_in.droit_ouvert_base_in)
    in
    let droit_ouvert_majoration_ : unit -> (enfant -> bool) =
      (allocations_familiales_in.droit_ouvert_majoration_in)
    in
    let montant_verse_base_ : unit -> money =
      (allocations_familiales_in.montant_verse_base_in)
    in
    let montant_avec_garde_alternee_base_ : unit -> money =
      (allocations_familiales_in.montant_avec_garde_alternee_base_in)
    in
    let montant_initial_base_ : unit -> money =
      (allocations_familiales_in.montant_initial_base_in)
    in
    let montant_initial_base_premier_enfant_ : unit -> money =
      (allocations_familiales_in.montant_initial_base_premier_enfant_in)
    in
    let montant_initial_base_deuxieme_enfant_ : unit -> money =
      (allocations_familiales_in.montant_initial_base_deuxieme_enfant_in)
    in
    let montant_initial_base_troisieme_enfant_et_plus_ : unit -> money =
      (allocations_familiales_in.montant_initial_base_troisieme_enfant_et_plus_in)
    in
    let rapport_enfants_total_moyen_ : unit -> decimal =
      (allocations_familiales_in.rapport_enfants_total_moyen_in)
    in
    let nombre_moyen_enfants_ : unit -> decimal =
      (allocations_familiales_in.nombre_moyen_enfants_in)
    in
    let nombre_total_enfants_ : unit -> decimal =
      (allocations_familiales_in.nombre_total_enfants_in)
    in
    let droit_ouvert_forfaitaire_ : unit -> (enfant -> bool) =
      (allocations_familiales_in.droit_ouvert_forfaitaire_in)
    in
    let montant_verse_forfaitaire_ : unit -> money =
      (allocations_familiales_in.montant_verse_forfaitaire_in)
    in
    let montant_verse_majoration_ : unit -> money =
      (allocations_familiales_in.montant_verse_majoration_in)
    in
    let montant_avec_garde_alternee_majoration_ : unit -> (enfant -> money) =
      (allocations_familiales_in.montant_avec_garde_alternee_majoration_in)
    in
    let montant_initial_majoration_ : unit -> (enfant -> money) =
      (allocations_familiales_in.montant_initial_majoration_in)
    in
    let droit_ouvert_complement_ : unit -> bool =
      (allocations_familiales_in.droit_ouvert_complement_in)
    in
    let montant_verse_complement_pour_base_et_majoration_ : unit -> money =
      (allocations_familiales_in.montant_verse_complement_pour_base_et_majoration_in)
    in
    let montant_base_complement_pour_base_et_majoration_ : unit -> money =
      (allocations_familiales_in.montant_base_complement_pour_base_et_majoration_in)
    in
    let montant_verse_complement_pour_forfaitaire_ : unit -> money =
      (allocations_familiales_in.montant_verse_complement_pour_forfaitaire_in)
    in
    let depassement_plafond_ressources_ : unit -> (money -> money) =
      (allocations_familiales_in.depassement_plafond_ressources_in)
    in
    let conditions_hors_age_ : unit -> (enfant -> bool) =
      (allocations_familiales_in.conditions_hors_age_in)
    in
    let nombre_enfants_l521_1_ : unit -> integer =
      (allocations_familiales_in.nombre_enfants_l521_1_in)
    in
    let age_limite_alinea_1_l521_3_ : unit -> (enfant -> integer) =
      (allocations_familiales_in.age_limite_alinea_1_l521_3_in)
    in
    let nombre_enfants_alinea_2_l521_3_ : unit -> integer =
      (allocations_familiales_in.nombre_enfants_alinea_2_l521_3_in)
    in
    let est_enfant_le_plus_age_ : unit -> (enfant -> bool) =
      (allocations_familiales_in.est_enfant_le_plus_age_in)
    in
    let plafond__i_d521_3_ : unit -> money =
      (allocations_familiales_in.plafond_I_d521_3_in)
    in
    let plafond__i_i_d521_3_ : unit -> money =
      (allocations_familiales_in.plafond_II_d521_3_in)
    in
    let enfants_a_charge_ : enfant array =
      ((error_empty
          (handle_default ([|(fun (_: _) -> enfants_a_charge_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let date_courante_ : date =
      ((error_empty
          (handle_default ([|(fun (_: _) -> date_courante_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let residence_ : collectivite =
      ((error_empty
          (handle_default ([|(fun (_: _) -> residence_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let ressources_menage_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> ressources_menage_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let prise_en_compte_ : enfant -> prise_en_compte_evaluation_montant =
      ((error_empty
          (handle_default ([|(fun (_: _) -> prise_en_compte_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default
                               ([|(fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          (match (param_.garde_alternee)
                                          with
                                          OuiPartageAllocations _ -> true
                                          | OuiAllocataireUnique _ ->
                                           false
                                          | NonGardeUnique _ -> false))
                                       (fun (_: _) -> Partagee ()));
                                  (fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          (match (param_.garde_alternee)
                                          with
                                          OuiPartageAllocations _ -> false
                                          | OuiAllocataireUnique _ ->
                                           true
                                          | NonGardeUnique _ -> false))
                                       (fun (_: _) -> Complete ()))|])
                               (fun (_: _) -> true)
                               (fun (_: _) -> Complete ()))|])
                       (fun (_: _) -> false) (fun (_: _) -> raise EmptyError))))))
    in
    let versement_ : enfant -> versement_allocations =
      ((error_empty
          (handle_default ([|(fun (_: _) -> versement_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default
                               ([|(fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          (match
                                             (param_.pris_en_charge_par_services_sociaux)
                                          with
                                          OuiAllocationVerseeALaFamille _ ->
                                           false
                                          | OuiAllocationVerseeAuxServicesSociaux _ ->
                                           true
                                          | NonPriseEnChargeFamille _ ->
                                           false))
                                       (fun (_: _) ->
                                          AllocationVerseeAuxServicesSociaux
                                            ()));
                                  (fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          (match (param_.garde_alternee)
                                          with
                                          OuiPartageAllocations _ -> true
                                          | OuiAllocataireUnique _ ->
                                           false
                                          | NonGardeUnique _ -> false))
                                       (fun (_: _) -> Normal ()));
                                  (fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          (match (param_.garde_alternee)
                                          with
                                          OuiPartageAllocations _ -> false
                                          | OuiAllocataireUnique _ ->
                                           true
                                          | NonGardeUnique _ -> false))
                                       (fun (_: _) -> Normal ()))|])
                               (fun (_: _) -> true) (fun (_: _) -> Normal ()))|])
                       (fun (_: _) -> false) (fun (_: _) -> raise EmptyError))))))
    in
    let nombre_enfants_l521_1_ : integer =
      ((error_empty
          (handle_default ([|(fun (_: _) -> nombre_enfants_l521_1_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) -> integer_of_string "3"))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let nombre_enfants_alinea_2_l521_3_ : integer =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> nombre_enfants_alinea_2_l521_3_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) -> integer_of_string "3"))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let result_ : allocation_familiales_avril2008_out =
      (((allocation_familiales_avril2008)
          {age_limite_alinea_1_l521_3_in =
             (fun (_: unit) -> raise EmptyError)}))
    in
    let version_avril_2008_dot_age_limite_alinea_1_l521_3_ : integer =
      (result_.age_limite_alinea_1_l521_3_out)
    in
    let enfant_le_plus_age_dot_enfants_ : unit -> (enfant array) =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> enfants_a_charge_))|])
            (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))
    in
    let result_ : enfant_le_plus_age_out =
      (((enfant_le_plus_age)
          {enfants_in = enfant_le_plus_age_dot_enfants_;
             le_plus_age_in = (fun (_: unit) -> raise EmptyError)}))
    in
    let enfant_le_plus_age_dot_enfants_ : enfant array =
      (result_.enfants_out)
    in
    let enfant_le_plus_age_dot_le_plus_age_ : enfant =
      (result_.le_plus_age_out)
    in
    let prestations_familiales_dot_date_courante_ : unit -> date =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> date_courante_))|]) (fun (_: _) -> false)
            (fun (_: _) -> raise EmptyError)))
    in
    let prestations_familiales_dot_prestation_courante_ :
      unit -> element_prestations_familiales =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> AllocationsFamiliales ()))|])
            (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))
    in
    let prestations_familiales_dot_residence_ : unit -> collectivite =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> residence_))|]) (fun (_: _) -> false)
            (fun (_: _) -> raise EmptyError)))
    in
    let result_ : prestations_familiales_out =
      (((prestations_familiales)
          {droit_ouvert_in = (fun (_: unit) -> raise EmptyError);
             conditions_hors_age_in = (fun (_: unit) -> raise EmptyError);
             plafond_l512_3_2_in = (fun (_: unit) -> raise EmptyError);
             age_l512_3_2_in = (fun (_: unit) -> raise EmptyError);
             age_l512_3_2_alternatif_in = (fun (_: unit) -> raise EmptyError);
             regime_outre_mer_l751_1_in = (fun (_: unit) -> raise EmptyError);
             date_courante_in = prestations_familiales_dot_date_courante_;
             prestation_courante_in =
               prestations_familiales_dot_prestation_courante_;
             residence_in = prestations_familiales_dot_residence_;
             base_mensuelle_in = (fun (_: unit) -> raise EmptyError)}))
    in
    let prestations_familiales_dot_droit_ouvert_ : enfant -> bool =
      (result_.droit_ouvert_out)
    in
    let prestations_familiales_dot_conditions_hors_age_ : enfant -> bool =
      (result_.conditions_hors_age_out)
    in
    let prestations_familiales_dot_plafond_l512_3_2_ : money =
      (result_.plafond_l512_3_2_out)
    in
    let prestations_familiales_dot_age_l512_3_2_ : integer =
      (result_.age_l512_3_2_out)
    in
    let prestations_familiales_dot_age_l512_3_2_alternatif_ : age_alternatif
      = (result_.age_l512_3_2_alternatif_out)
    in
    let prestations_familiales_dot_regime_outre_mer_l751_1_ : bool =
      (result_.regime_outre_mer_l751_1_out)
    in
    let prestations_familiales_dot_date_courante_ : date =
      (result_.date_courante_out)
    in
    let prestations_familiales_dot_prestation_courante_ :
      element_prestations_familiales = (result_.prestation_courante_out)
    in
    let prestations_familiales_dot_residence_ : collectivite =
      (result_.residence_out)
    in
    let prestations_familiales_dot_base_mensuelle_ : money =
      (result_.base_mensuelle_out)
    in
    let est_enfant_le_plus_age_ : enfant -> bool =
      ((error_empty
          (handle_default ([|(fun (_: _) -> est_enfant_le_plus_age_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default ([||]) (fun (_: _) -> true)
                               (fun (_: _) ->
                                  enfant_le_plus_age_dot_le_plus_age_ =
                                    param_))|]) (fun (_: _) -> false)
                       (fun (_: _) -> raise EmptyError))))))
    in
    let age_limite_alinea_1_l521_3_ : enfant -> integer =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> age_limite_alinea_1_l521_3_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  (((param_.date_de_naissance) +@
                                      (duration_of_numbers 11 0 0)) <=@
                                     (date_of_numbers 2008 4 30)))
                               (fun (_: _) ->
                                  version_avril_2008_dot_age_limite_alinea_1_l521_3_));
                          (fun (_: _) ->
                             handle_default
                               ([|(fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          prestations_familiales_dot_regime_outre_mer_l751_1_)
                                       (fun (_: _) -> integer_of_string "11"))|])
                               (fun (_: _) -> true)
                               (fun (_: _) -> integer_of_string "14"))|])
                       (fun (_: _) -> false) (fun (_: _) -> raise EmptyError))))))
    in
    let conditions_hors_age_ : enfant -> bool =
      ((error_empty
          (handle_default ([|(fun (_: _) -> conditions_hors_age_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  ((((prestations_familiales_dot_conditions_hors_age_)
                                       (param_))))) (fun (_: _) -> true))|])
                       (fun (_: _) -> true) (fun (_: _) -> false))))))
    in
    let enfants_a_charge_droit_ouvert_prestation_familiale_ : enfant array =
      ((error_empty
          (handle_default
             ([|(fun (_: _) ->
                   enfants_a_charge_droit_ouvert_prestation_familiale_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                             array_filter
                               (fun (enfant_: _) ->
                                  (((prestations_familiales_dot_droit_ouvert_)
                                      (enfant_)))) enfants_a_charge_))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let plafond__i_i_d521_3_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> plafond__i_i_d521_3_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default
                          ([|(fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) ->
                                     ((date_courante_ >=@
                                         (date_of_numbers 2021 1 1)) &&
                                        (date_courante_ <=@
                                           (date_of_numbers 2021 12 31))))
                                  (fun (_: _) ->
                                     (money_of_cent_string "8155800") +$
                                       ((money_of_cent_string "582700") *$
                                          (int_to_rat
                                             (array_length
                                                enfants_a_charge_droit_ouvert_prestation_familiale_)))));
                             (fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) ->
                                     ((date_courante_ >=@
                                         (date_of_numbers 2020 1 1)) &&
                                        (date_courante_ <=@
                                           (date_of_numbers 2020 12 31))))
                                  (fun (_: _) ->
                                     (money_of_cent_string "8083100") +$
                                       ((money_of_cent_string "577500") *$
                                          (int_to_rat
                                             (array_length
                                                enfants_a_charge_droit_ouvert_prestation_familiale_)))))|])
                          (fun (_: _) -> true)
                          (fun (_: _) ->
                             (money_of_cent_string "7830000") +$
                               ((money_of_cent_string "559500") *$
                                  (int_to_rat
                                     (array_length
                                        enfants_a_charge_droit_ouvert_prestation_familiale_)))))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let plafond__i_d521_3_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> plafond__i_d521_3_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default
                          ([|(fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) ->
                                     ((date_courante_ >=@
                                         (date_of_numbers 2021 1 1)) &&
                                        (date_courante_ <=@
                                           (date_of_numbers 2021 12 31))))
                                  (fun (_: _) ->
                                     (money_of_cent_string "5827900") +$
                                       ((money_of_cent_string "582700") *$
                                          (int_to_rat
                                             (array_length
                                                enfants_a_charge_droit_ouvert_prestation_familiale_)))));
                             (fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) ->
                                     ((date_courante_ >=@
                                         (date_of_numbers 2020 1 1)) &&
                                        (date_courante_ <=@
                                           (date_of_numbers 2020 12 31))))
                                  (fun (_: _) ->
                                     (money_of_cent_string "5775900") +$
                                       ((money_of_cent_string "577500") *$
                                          (int_to_rat
                                             (array_length
                                                enfants_a_charge_droit_ouvert_prestation_familiale_)))))|])
                          (fun (_: _) -> true)
                          (fun (_: _) ->
                             (money_of_cent_string "5595000") +$
                               ((money_of_cent_string "559500") *$
                                  (int_to_rat
                                     (array_length
                                        enfants_a_charge_droit_ouvert_prestation_familiale_)))))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let droit_ouvert_complement_ : bool =
      ((error_empty
          (handle_default ([|(fun (_: _) -> droit_ouvert_complement_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default
                          ([|(fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) ->
                                     (prestations_familiales_dot_regime_outre_mer_l751_1_
                                        &&
                                        ((array_length
                                            enfants_a_charge_droit_ouvert_prestation_familiale_)
                                           = (integer_of_string "1"))))
                                  (fun (_: _) -> false))|])
                          (fun (_: _) -> true) (fun (_: _) -> true))|])
                  (fun (_: _) -> true) (fun (_: _) -> false)))))
    in
    let droit_ouvert_forfaitaire_ : enfant -> bool =
      ((error_empty
          (handle_default ([|(fun (_: _) -> droit_ouvert_forfaitaire_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default
                               ([|(fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          (prestations_familiales_dot_regime_outre_mer_l751_1_
                                             &&
                                             ((array_length
                                                 enfants_a_charge_droit_ouvert_prestation_familiale_)
                                                = (integer_of_string "1"))))
                                       (fun (_: _) -> false))|])
                               (fun (_: _) ->
                                  (((array_length enfants_a_charge_) >=!
                                      nombre_enfants_l521_1_) &&
                                     (((param_.age) =
                                         prestations_familiales_dot_age_l512_3_2_)
                                        &&
                                        ((((conditions_hors_age_) (param_)))))))
                               (fun (_: _) -> true))|]) (fun (_: _) -> true)
                       (fun (_: _) -> false))))))
    in
    let nombre_total_enfants_ : decimal =
      ((error_empty
          (handle_default ([|(fun (_: _) -> nombre_total_enfants_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                             int_to_rat
                               (array_length
                                  enfants_a_charge_droit_ouvert_prestation_familiale_)))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let nombre_moyen_enfants_ : decimal =
      ((error_empty
          (handle_default ([|(fun (_: _) -> nombre_moyen_enfants_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                             Array.fold_left
                               (fun (acc_: decimal) (enfant_: _) ->
                                  acc_ +&
                                    (match ((((prise_en_compte_) (enfant_))))
                                    with
                                    Complete _ -> (decimal_of_string "1.")
                                    | Partagee _ -> (decimal_of_string "0.5")))
                               (decimal_of_string "0.")
                               enfants_a_charge_droit_ouvert_prestation_familiale_))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let droit_ouvert_majoration_ : enfant -> bool =
      ((error_empty
          (handle_default ([|(fun (_: _) -> droit_ouvert_majoration_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default
                               ([|(fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          (((array_length
                                               enfants_a_charge_droit_ouvert_prestation_familiale_)
                                              >=!
                                              nombre_enfants_alinea_2_l521_3_)
                                             &&
                                             ((param_.age) >=!
                                                ((((age_limite_alinea_1_l521_3_)
                                                     (param_)))))))
                                       (fun (_: _) -> true))|])
                               (fun (_: _) ->
                                  ((not
                                      ((((est_enfant_le_plus_age_) (param_)))))
                                     &&
                                     ((param_.age) >=!
                                        ((((age_limite_alinea_1_l521_3_)
                                             (param_)))))))
                               (fun (_: _) -> true))|]) (fun (_: _) -> true)
                       (fun (_: _) -> false))))))
    in
    let droit_ouvert_base_ : bool =
      ((error_empty
          (handle_default ([|(fun (_: _) -> droit_ouvert_base_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default
                          ([|(fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) ->
                                     (prestations_familiales_dot_regime_outre_mer_l751_1_
                                        &&
                                        ((array_length
                                            enfants_a_charge_droit_ouvert_prestation_familiale_)
                                           >=! (integer_of_string "1"))))
                                  (fun (_: _) -> true))|])
                          (fun (_: _) ->
                             ((array_length
                                 enfants_a_charge_droit_ouvert_prestation_familiale_)
                                >=! (integer_of_string "2")))
                          (fun (_: _) -> true))|]) (fun (_: _) -> true)
                  (fun (_: _) -> false)))))
    in
    let depassement_plafond_ressources_ : money -> money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> depassement_plafond_ressources_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: money) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default
                               ([|(fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          ((ressources_menage_ >$
                                              plafond__i_i_d521_3_) &&
                                             (ressources_menage_ <=$
                                                (plafond__i_i_d521_3_ +$
                                                   (param_ *$
                                                      (decimal_of_string "12."))))))
                                       (fun (_: _) ->
                                          plafond__i_i_d521_3_ +$
                                            ((param_ *$
                                                (decimal_of_string "12.")) -$
                                               ressources_menage_)));
                                  (fun (_: _) ->
                                     handle_default ([||])
                                       (fun (_: _) ->
                                          ((ressources_menage_ >$
                                              plafond__i_d521_3_) &&
                                             (ressources_menage_ <=$
                                                (plafond__i_d521_3_ +$
                                                   (param_ *$
                                                      (decimal_of_string "12."))))))
                                       (fun (_: _) ->
                                          plafond__i_d521_3_ +$
                                            ((param_ *$
                                                (decimal_of_string "12.")) -$
                                               ressources_menage_)))|])
                               (fun (_: _) -> true)
                               (fun (_: _) -> money_of_cent_string "0"))|])
                       (fun (_: _) -> false) (fun (_: _) -> raise EmptyError))))))
    in
    let montant_initial_base_troisieme_enfant_et_plus_ : money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) ->
                   montant_initial_base_troisieme_enfant_et_plus_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             (ressources_menage_ >$ plafond__i_i_d521_3_))
                          (fun (_: _) ->
                              if
                               ((array_length
                                   enfants_a_charge_droit_ouvert_prestation_familiale_)
                                  >=! (integer_of_string "3")) then
                               ((prestations_familiales_dot_base_mensuelle_
                                   *$ (decimal_of_string "0.1025")) *$
                                  (int_to_rat
                                     ((array_length
                                         enfants_a_charge_droit_ouvert_prestation_familiale_)
                                        -! (integer_of_string "2")))) else
                               (money_of_cent_string "0")));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((ressources_menage_ >$ plafond__i_d521_3_) &&
                                (ressources_menage_ <=$ plafond__i_i_d521_3_)))
                          (fun (_: _) ->
                              if
                               ((array_length
                                   enfants_a_charge_droit_ouvert_prestation_familiale_)
                                  >=! (integer_of_string "3")) then
                               ((prestations_familiales_dot_base_mensuelle_
                                   *$ (decimal_of_string "0.205")) *$
                                  (int_to_rat
                                     ((array_length
                                         enfants_a_charge_droit_ouvert_prestation_familiale_)
                                        -! (integer_of_string "2")))) else
                               (money_of_cent_string "0")));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             (ressources_menage_ <=$ plafond__i_d521_3_))
                          (fun (_: _) ->
                              if
                               ((array_length
                                   enfants_a_charge_droit_ouvert_prestation_familiale_)
                                  >=! (integer_of_string "3")) then
                               ((prestations_familiales_dot_base_mensuelle_
                                   *$ (decimal_of_string "0.41")) *$
                                  (int_to_rat
                                     ((array_length
                                         enfants_a_charge_droit_ouvert_prestation_familiale_)
                                        -! (integer_of_string "2")))) else
                               (money_of_cent_string "0")))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_initial_base_deuxieme_enfant_ : money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> montant_initial_base_deuxieme_enfant_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             (ressources_menage_ >$ plafond__i_i_d521_3_))
                          (fun (_: _) ->
                              if
                               ((array_length
                                   enfants_a_charge_droit_ouvert_prestation_familiale_)
                                  >=! (integer_of_string "2")) then
                               (prestations_familiales_dot_base_mensuelle_ *$
                                  (decimal_of_string "0.08")) else
                               (money_of_cent_string "0")));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((ressources_menage_ >$ plafond__i_d521_3_) &&
                                (ressources_menage_ <=$ plafond__i_i_d521_3_)))
                          (fun (_: _) ->
                              if
                               ((array_length
                                   enfants_a_charge_droit_ouvert_prestation_familiale_)
                                  >=! (integer_of_string "2")) then
                               (prestations_familiales_dot_base_mensuelle_ *$
                                  (decimal_of_string "0.32")) else
                               (money_of_cent_string "0")));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             (ressources_menage_ <=$ plafond__i_d521_3_))
                          (fun (_: _) ->
                              if
                               ((array_length
                                   enfants_a_charge_droit_ouvert_prestation_familiale_)
                                  >=! (integer_of_string "2")) then
                               (prestations_familiales_dot_base_mensuelle_ *$
                                  (decimal_of_string "0.32")) else
                               (money_of_cent_string "0")))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_initial_base_premier_enfant_ : money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> montant_initial_base_premier_enfant_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((ressources_menage_ >$ plafond__i_i_d521_3_) &&
                                ((array_length
                                    enfants_a_charge_droit_ouvert_prestation_familiale_)
                                   = (integer_of_string "1"))))
                          (fun (_: _) ->
                             (prestations_familiales_dot_base_mensuelle_ *$
                                (decimal_of_string "0.0588")) *$
                               (decimal_of_string "0.25")));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((ressources_menage_ >$ plafond__i_d521_3_) &&
                                ((ressources_menage_ <=$ plafond__i_i_d521_3_)
                                   &&
                                   ((array_length
                                       enfants_a_charge_droit_ouvert_prestation_familiale_)
                                      = (integer_of_string "1")))))
                          (fun (_: _) ->
                             (prestations_familiales_dot_base_mensuelle_ *$
                                (decimal_of_string "0.0588")) *$
                               (decimal_of_string "0.5")));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((ressources_menage_ <=$ plafond__i_d521_3_) &&
                                ((array_length
                                    enfants_a_charge_droit_ouvert_prestation_familiale_)
                                   = (integer_of_string "1"))))
                          (fun (_: _) ->
                             prestations_familiales_dot_base_mensuelle_ *$
                               (decimal_of_string "0.0588")));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((array_length
                                 enfants_a_charge_droit_ouvert_prestation_familiale_)
                                <> (integer_of_string "1")))
                          (fun (_: _) -> money_of_cent_string "0"))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_verse_forfaitaire_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> montant_verse_forfaitaire_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             (ressources_menage_ >$ plafond__i_i_d521_3_))
                          (fun (_: _) ->
                             (prestations_familiales_dot_base_mensuelle_ *$
                                (decimal_of_string "0.0559")) *$
                               (int_to_rat
                                  (Array.fold_left
                                     (fun (acc_: integer) (enfant_: _) ->
                                         if
                                          ((((droit_ouvert_forfaitaire_)
                                               (enfant_)))) then
                                          (acc_ +! (integer_of_string "1"))
                                          else acc_) (integer_of_string "0")
                                     enfants_a_charge_))));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((ressources_menage_ >$ plafond__i_d521_3_) &&
                                (ressources_menage_ <=$ plafond__i_i_d521_3_)))
                          (fun (_: _) ->
                             (prestations_familiales_dot_base_mensuelle_ *$
                                (decimal_of_string "0.1117")) *$
                               (int_to_rat
                                  (Array.fold_left
                                     (fun (acc_: integer) (enfant_: _) ->
                                         if
                                          ((((droit_ouvert_forfaitaire_)
                                               (enfant_)))) then
                                          (acc_ +! (integer_of_string "1"))
                                          else acc_) (integer_of_string "0")
                                     enfants_a_charge_))));
                     (fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             (ressources_menage_ <=$ plafond__i_d521_3_))
                          (fun (_: _) ->
                             (prestations_familiales_dot_base_mensuelle_ *$
                                (decimal_of_string "0.20234")) *$
                               (int_to_rat
                                  (Array.fold_left
                                     (fun (acc_: integer) (enfant_: _) ->
                                         if
                                          ((((droit_ouvert_forfaitaire_)
                                               (enfant_)))) then
                                          (acc_ +! (integer_of_string "1"))
                                          else acc_) (integer_of_string "0")
                                     enfants_a_charge_))))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let rapport_enfants_total_moyen_ : decimal =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> rapport_enfants_total_moyen_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                              if
                               (nombre_total_enfants_ =
                                  (decimal_of_string "0.")) then
                               (decimal_of_string "0.") else
                               (nombre_moyen_enfants_ /&
                                  nombre_total_enfants_)))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_initial_majoration_ : enfant -> money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> montant_initial_majoration_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  (not
                                     ((((droit_ouvert_majoration_) (param_))))))
                               (fun (_: _) -> money_of_cent_string "0"));
                          (fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  (((((droit_ouvert_majoration_) (param_))))
                                     &&
                                     (prestations_familiales_dot_regime_outre_mer_l751_1_
                                        &&
                                        ((array_length
                                            enfants_a_charge_droit_ouvert_prestation_familiale_)
                                           = (integer_of_string "1")))))
                               (fun (_: _) ->
                                  prestations_familiales_dot_base_mensuelle_
                                    *$
                                    ( if
                                       ((param_.age) >=! (integer_of_string
                                          "16")) then
                                       (decimal_of_string "0.0567") else
                                       (decimal_of_string "0.0369"))));
                          (fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  (((((droit_ouvert_majoration_) (param_))))
                                     &&
                                     ((ressources_menage_ >$
                                         plafond__i_i_d521_3_) &&
                                        ((array_length
                                            enfants_a_charge_droit_ouvert_prestation_familiale_)
                                           >=! (integer_of_string "2")))))
                               (fun (_: _) ->
                                  prestations_familiales_dot_base_mensuelle_
                                    *$ (decimal_of_string "0.04")));
                          (fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  (((((droit_ouvert_majoration_) (param_))))
                                     &&
                                     ((ressources_menage_ >$
                                         plafond__i_d521_3_) &&
                                        ((ressources_menage_ <=$
                                            plafond__i_i_d521_3_) &&
                                           ((array_length
                                               enfants_a_charge_droit_ouvert_prestation_familiale_)
                                              >=! (integer_of_string "2"))))))
                               (fun (_: _) ->
                                  prestations_familiales_dot_base_mensuelle_
                                    *$ (decimal_of_string "0.08")));
                          (fun (_: _) ->
                             handle_default ([||])
                               (fun (_: _) ->
                                  (((((droit_ouvert_majoration_) (param_))))
                                     &&
                                     ((ressources_menage_ <=$
                                         plafond__i_d521_3_) &&
                                        ((array_length
                                            enfants_a_charge_droit_ouvert_prestation_familiale_)
                                           >=! (integer_of_string "2")))))
                               (fun (_: _) ->
                                  prestations_familiales_dot_base_mensuelle_
                                    *$ (decimal_of_string "0.16")))|])
                       (fun (_: _) -> false) (fun (_: _) -> raise EmptyError))))))
    in
    let montant_initial_base_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> montant_initial_base_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default
                          ([|(fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) ->
                                     (prestations_familiales_dot_regime_outre_mer_l751_1_
                                        &&
                                        ((array_length
                                            enfants_a_charge_droit_ouvert_prestation_familiale_)
                                           = (integer_of_string "1"))))
                                  (fun (_: _) ->
                                     montant_initial_base_premier_enfant_))|])
                          (fun (_: _) -> true)
                          (fun (_: _) ->
                             montant_initial_base_deuxieme_enfant_ +$
                               montant_initial_base_troisieme_enfant_et_plus_))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_verse_complement_pour_forfaitaire_ : money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> montant_verse_complement_pour_forfaitaire_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                              if droit_ouvert_complement_ then
                               (((((depassement_plafond_ressources_)
                                     (montant_verse_forfaitaire_)))) *$
                                  ((decimal_of_string "1.") /&
                                     (decimal_of_string "12."))) else
                               (money_of_cent_string "0")))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_avec_garde_alternee_majoration_ : enfant -> money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> montant_avec_garde_alternee_majoration_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                fun (param_: enfant) ->
                  error_empty
                    (handle_default
                       ([|(fun (_: _) ->
                             handle_default ([||]) (fun (_: _) -> true)
                               (fun (_: _) ->
                                  ((((montant_initial_majoration_) (param_))))
                                    *$
                                    (match ((((prise_en_compte_) (param_))))
                                    with
                                    Complete _ -> (decimal_of_string "1.")
                                    | Partagee _ -> (decimal_of_string "0.5"))))|])
                       (fun (_: _) -> false) (fun (_: _) -> raise EmptyError))))))
    in
    let montant_avec_garde_alternee_base_ : money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) -> montant_avec_garde_alternee_base_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                             montant_initial_base_ *$
                               rapport_enfants_total_moyen_))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_verse_majoration_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> montant_verse_majoration_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                              if droit_ouvert_base_ then
                               (Array.fold_left
                                  (fun (acc_: money) (enfant_: _) ->
                                     acc_ +$
                                       ((((montant_avec_garde_alternee_majoration_)
                                            (enfant_)))))
                                  (money_of_cent_string "0")
                                  enfants_a_charge_) else
                               (money_of_cent_string "0")))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_verse_base_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> montant_verse_base_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                              if droit_ouvert_base_ then
                               montant_avec_garde_alternee_base_ else
                               (money_of_cent_string "0")))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_base_complement_pour_base_et_majoration_ : money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) ->
                   montant_base_complement_pour_base_et_majoration_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                             montant_verse_base_ +$ montant_verse_majoration_))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_verse_complement_pour_base_et_majoration_ : money =
      ((error_empty
          (handle_default
             ([|(fun (_: _) ->
                   montant_verse_complement_pour_base_et_majoration_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                              if droit_ouvert_complement_ then
                               (((((depassement_plafond_ressources_)
                                     (montant_base_complement_pour_base_et_majoration_))))
                                  *$
                                  ((decimal_of_string "1.") /&
                                     (decimal_of_string "12."))) else
                               (money_of_cent_string "0")))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let montant_verse_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> montant_verse_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                              if droit_ouvert_base_ then
                               (montant_verse_base_ +$
                                  (montant_verse_majoration_ +$
                                     (montant_verse_forfaitaire_ +$
                                        (montant_verse_complement_pour_base_et_majoration_
                                           +$
                                           montant_verse_complement_pour_forfaitaire_))))
                               else (money_of_cent_string "0")))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    {enfants_a_charge_out = enfants_a_charge_;
       enfants_a_charge_droit_ouvert_prestation_familiale_out =
         enfants_a_charge_droit_ouvert_prestation_familiale_;
       date_courante_out = date_courante_; residence_out = residence_;
       ressources_menage_out = ressources_menage_;
       prise_en_compte_out = prise_en_compte_; versement_out = versement_;
       montant_verse_out = montant_verse_;
       droit_ouvert_base_out = droit_ouvert_base_;
       droit_ouvert_majoration_out = droit_ouvert_majoration_;
       montant_verse_base_out = montant_verse_base_;
       montant_avec_garde_alternee_base_out =
         montant_avec_garde_alternee_base_;
       montant_initial_base_out = montant_initial_base_;
       montant_initial_base_premier_enfant_out =
         montant_initial_base_premier_enfant_;
       montant_initial_base_deuxieme_enfant_out =
         montant_initial_base_deuxieme_enfant_;
       montant_initial_base_troisieme_enfant_et_plus_out =
         montant_initial_base_troisieme_enfant_et_plus_;
       rapport_enfants_total_moyen_out = rapport_enfants_total_moyen_;
       nombre_moyen_enfants_out = nombre_moyen_enfants_;
       nombre_total_enfants_out = nombre_total_enfants_;
       droit_ouvert_forfaitaire_out = droit_ouvert_forfaitaire_;
       montant_verse_forfaitaire_out = montant_verse_forfaitaire_;
       montant_verse_majoration_out = montant_verse_majoration_;
       montant_avec_garde_alternee_majoration_out =
         montant_avec_garde_alternee_majoration_;
       montant_initial_majoration_out = montant_initial_majoration_;
       droit_ouvert_complement_out = droit_ouvert_complement_;
       montant_verse_complement_pour_base_et_majoration_out =
         montant_verse_complement_pour_base_et_majoration_;
       montant_base_complement_pour_base_et_majoration_out =
         montant_base_complement_pour_base_et_majoration_;
       montant_verse_complement_pour_forfaitaire_out =
         montant_verse_complement_pour_forfaitaire_;
       depassement_plafond_ressources_out = depassement_plafond_ressources_;
       conditions_hors_age_out = conditions_hors_age_;
       nombre_enfants_l521_1_out = nombre_enfants_l521_1_;
       age_limite_alinea_1_l521_3_out = age_limite_alinea_1_l521_3_;
       nombre_enfants_alinea_2_l521_3_out = nombre_enfants_alinea_2_l521_3_;
       est_enfant_le_plus_age_out = est_enfant_le_plus_age_;
       plafond_I_d521_3_out = plafond__i_d521_3_;
       plafond_II_d521_3_out = plafond__i_i_d521_3_}

let interface_allocations_familiales =
  fun
    (interface_allocations_familiales_in:
      interface_allocations_familiales_in) ->
    let date_courante_ : unit -> date =
      (interface_allocations_familiales_in.date_courante_in)
    in
    let enfants_ : unit -> (enfant_entree array) =
      (interface_allocations_familiales_in.enfants_in)
    in
    let enfants_a_charge_ : unit -> (enfant array) =
      (interface_allocations_familiales_in.enfants_a_charge_in)
    in
    let ressources_menage_ : unit -> money =
      (interface_allocations_familiales_in.ressources_menage_in)
    in
    let residence_ : unit -> collectivite =
      (interface_allocations_familiales_in.residence_in)
    in
    let montant_verse_ : unit -> money =
      (interface_allocations_familiales_in.montant_verse_in)
    in
    let date_courante_ : date =
      ((error_empty
          (handle_default ([|(fun (_: _) -> date_courante_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let enfants_ : enfant_entree array =
      ((error_empty
          (handle_default ([|(fun (_: _) -> enfants_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let ressources_menage_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> ressources_menage_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let residence_ : collectivite =
      ((error_empty
          (handle_default ([|(fun (_: _) -> residence_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let enfants_a_charge_ : enfant array =
      ((error_empty
          (handle_default ([|(fun (_: _) -> enfants_a_charge_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                             Array.map
                               (fun (enfant_: _) ->
                                  {identifiant = (enfant_.d_identifiant);
                                     fin_obligation_scolaire =
                                       ((enfant_.d_date_de_naissance) +@
                                          (duration_of_numbers 16 0 0));
                                     remuneration_mensuelle =
                                       (enfant_.d_remuneration_mensuelle);
                                     date_de_naissance =
                                       (enfant_.d_date_de_naissance);
                                     age =
                                       (get_year
                                          ((date_of_numbers 0 1 1) +@
                                             (date_courante_ -@
                                                (enfant_.d_date_de_naissance))));
                                     garde_alternee =
                                       (enfant_.d_garde_alternee);
                                     pris_en_charge_par_services_sociaux =
                                       (enfant_.d_pris_en_charge_par_services_sociaux)})
                               enfants_))|]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError)))))
    in
    let allocations_familiales_dot_enfants_a_charge_ : unit -> (enfant array)
      =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> enfants_a_charge_))|])
            (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))
    in
    let allocations_familiales_dot_date_courante_ : unit -> date =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> date_courante_))|]) (fun (_: _) -> false)
            (fun (_: _) -> raise EmptyError)))
    in
    let allocations_familiales_dot_residence_ : unit -> collectivite =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> residence_))|]) (fun (_: _) -> false)
            (fun (_: _) -> raise EmptyError)))
    in
    let allocations_familiales_dot_ressources_menage_ : unit -> money =
      (fun (_: unit) ->
         (handle_default
            ([|(fun (_: _) ->
                  handle_default ([||]) (fun (_: _) -> true)
                    (fun (_: _) -> ressources_menage_))|])
            (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))
    in
    let result_ : allocations_familiales_out =
      (((allocations_familiales)
          {enfants_a_charge_in = allocations_familiales_dot_enfants_a_charge_;
             enfants_a_charge_droit_ouvert_prestation_familiale_in =
               (fun (_: unit) -> raise EmptyError);
             date_courante_in = allocations_familiales_dot_date_courante_;
             residence_in = allocations_familiales_dot_residence_;
             ressources_menage_in =
               allocations_familiales_dot_ressources_menage_;
             prise_en_compte_in = (fun (_: unit) -> raise EmptyError);
             versement_in = (fun (_: unit) -> raise EmptyError);
             montant_verse_in = (fun (_: unit) -> raise EmptyError);
             droit_ouvert_base_in = (fun (_: unit) -> raise EmptyError);
             droit_ouvert_majoration_in = (fun (_: unit) -> raise EmptyError);
             montant_verse_base_in = (fun (_: unit) -> raise EmptyError);
             montant_avec_garde_alternee_base_in =
               (fun (_: unit) -> raise EmptyError);
             montant_initial_base_in = (fun (_: unit) -> raise EmptyError);
             montant_initial_base_premier_enfant_in =
               (fun (_: unit) -> raise EmptyError);
             montant_initial_base_deuxieme_enfant_in =
               (fun (_: unit) -> raise EmptyError);
             montant_initial_base_troisieme_enfant_et_plus_in =
               (fun (_: unit) -> raise EmptyError);
             rapport_enfants_total_moyen_in =
               (fun (_: unit) -> raise EmptyError);
             nombre_moyen_enfants_in = (fun (_: unit) -> raise EmptyError);
             nombre_total_enfants_in = (fun (_: unit) -> raise EmptyError);
             droit_ouvert_forfaitaire_in =
               (fun (_: unit) -> raise EmptyError);
             montant_verse_forfaitaire_in =
               (fun (_: unit) -> raise EmptyError);
             montant_verse_majoration_in =
               (fun (_: unit) -> raise EmptyError);
             montant_avec_garde_alternee_majoration_in =
               (fun (_: unit) -> raise EmptyError);
             montant_initial_majoration_in =
               (fun (_: unit) -> raise EmptyError);
             droit_ouvert_complement_in = (fun (_: unit) -> raise EmptyError);
             montant_verse_complement_pour_base_et_majoration_in =
               (fun (_: unit) -> raise EmptyError);
             montant_base_complement_pour_base_et_majoration_in =
               (fun (_: unit) -> raise EmptyError);
             montant_verse_complement_pour_forfaitaire_in =
               (fun (_: unit) -> raise EmptyError);
             depassement_plafond_ressources_in =
               (fun (_: unit) -> raise EmptyError);
             conditions_hors_age_in = (fun (_: unit) -> raise EmptyError);
             nombre_enfants_l521_1_in = (fun (_: unit) -> raise EmptyError);
             age_limite_alinea_1_l521_3_in =
               (fun (_: unit) -> raise EmptyError);
             nombre_enfants_alinea_2_l521_3_in =
               (fun (_: unit) -> raise EmptyError);
             est_enfant_le_plus_age_in = (fun (_: unit) -> raise EmptyError);
             plafond_I_d521_3_in = (fun (_: unit) -> raise EmptyError);
             plafond_II_d521_3_in = (fun (_: unit) -> raise EmptyError)}))
    in
    let allocations_familiales_dot_enfants_a_charge_ : enfant array =
      (result_.enfants_a_charge_out)
    in
    let
      allocations_familiales_dot_enfants_a_charge_droit_ouvert_prestation_familiale_
      : enfant array =
      (result_.enfants_a_charge_droit_ouvert_prestation_familiale_out)
    in
    let allocations_familiales_dot_date_courante_ : date =
      (result_.date_courante_out)
    in
    let allocations_familiales_dot_residence_ : collectivite =
      (result_.residence_out)
    in
    let allocations_familiales_dot_ressources_menage_ : money =
      (result_.ressources_menage_out)
    in
    let allocations_familiales_dot_prise_en_compte_ :
      enfant -> prise_en_compte_evaluation_montant =
      (result_.prise_en_compte_out)
    in
    let allocations_familiales_dot_versement_ :
      enfant -> versement_allocations = (result_.versement_out)
    in
    let allocations_familiales_dot_montant_verse_ : money =
      (result_.montant_verse_out)
    in
    let allocations_familiales_dot_droit_ouvert_base_ : bool =
      (result_.droit_ouvert_base_out)
    in
    let allocations_familiales_dot_droit_ouvert_majoration_ : enfant -> bool
      = (result_.droit_ouvert_majoration_out)
    in
    let allocations_familiales_dot_montant_verse_base_ : money =
      (result_.montant_verse_base_out)
    in
    let allocations_familiales_dot_montant_avec_garde_alternee_base_ : money
      = (result_.montant_avec_garde_alternee_base_out)
    in
    let allocations_familiales_dot_montant_initial_base_ : money =
      (result_.montant_initial_base_out)
    in
    let allocations_familiales_dot_montant_initial_base_premier_enfant_ :
      money = (result_.montant_initial_base_premier_enfant_out)
    in
    let allocations_familiales_dot_montant_initial_base_deuxieme_enfant_ :
      money = (result_.montant_initial_base_deuxieme_enfant_out)
    in
    let
      allocations_familiales_dot_montant_initial_base_troisieme_enfant_et_plus_
      : money = (result_.montant_initial_base_troisieme_enfant_et_plus_out)
    in
    let allocations_familiales_dot_rapport_enfants_total_moyen_ : decimal =
      (result_.rapport_enfants_total_moyen_out)
    in
    let allocations_familiales_dot_nombre_moyen_enfants_ : decimal =
      (result_.nombre_moyen_enfants_out)
    in
    let allocations_familiales_dot_nombre_total_enfants_ : decimal =
      (result_.nombre_total_enfants_out)
    in
    let allocations_familiales_dot_droit_ouvert_forfaitaire_ : enfant -> bool
      = (result_.droit_ouvert_forfaitaire_out)
    in
    let allocations_familiales_dot_montant_verse_forfaitaire_ : money =
      (result_.montant_verse_forfaitaire_out)
    in
    let allocations_familiales_dot_montant_verse_majoration_ : money =
      (result_.montant_verse_majoration_out)
    in
    let allocations_familiales_dot_montant_avec_garde_alternee_majoration_ :
      enfant -> money = (result_.montant_avec_garde_alternee_majoration_out)
    in
    let allocations_familiales_dot_montant_initial_majoration_ :
      enfant -> money = (result_.montant_initial_majoration_out)
    in
    let allocations_familiales_dot_droit_ouvert_complement_ : bool =
      (result_.droit_ouvert_complement_out)
    in
    let
      allocations_familiales_dot_montant_verse_complement_pour_base_et_majoration_
      : money =
      (result_.montant_verse_complement_pour_base_et_majoration_out)
    in
    let
      allocations_familiales_dot_montant_base_complement_pour_base_et_majoration_
      : money = (result_.montant_base_complement_pour_base_et_majoration_out)
    in
    let allocations_familiales_dot_montant_verse_complement_pour_forfaitaire_
      : money = (result_.montant_verse_complement_pour_forfaitaire_out)
    in
    let allocations_familiales_dot_depassement_plafond_ressources_ :
      money -> money = (result_.depassement_plafond_ressources_out)
    in
    let allocations_familiales_dot_conditions_hors_age_ : enfant -> bool =
      (result_.conditions_hors_age_out)
    in
    let allocations_familiales_dot_nombre_enfants_l521_1_ : integer =
      (result_.nombre_enfants_l521_1_out)
    in
    let allocations_familiales_dot_age_limite_alinea_1_l521_3_ :
      enfant -> integer = (result_.age_limite_alinea_1_l521_3_out)
    in
    let allocations_familiales_dot_nombre_enfants_alinea_2_l521_3_ : integer
      = (result_.nombre_enfants_alinea_2_l521_3_out)
    in
    let allocations_familiales_dot_est_enfant_le_plus_age_ : enfant -> bool =
      (result_.est_enfant_le_plus_age_out)
    in
    let allocations_familiales_dot_plafond__i_d521_3_ : money =
      (result_.plafond_I_d521_3_out)
    in
    let allocations_familiales_dot_plafond__i_i_d521_3_ : money =
      (result_.plafond_II_d521_3_out)
    in
    let montant_verse_ : money =
      ((error_empty
          (handle_default ([|(fun (_: _) -> montant_verse_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                             allocations_familiales_dot_montant_verse_))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))))
    in
    let _ : unit =
      (if 
         (not
            (Array.fold_left
               (fun (acc_: bool) (enfant_: _) ->
                  acc_ ||
                    (((enfant_.d_garde_alternee) <> (NonGardeUnique ())) &&
                       ((enfant_.d_pris_en_charge_par_services_sociaux) <>
                          (NonPriseEnChargeFamille ())))) false enfants_))
         then () else raise AssertionFailed)
    in
    {date_courante_out = date_courante_; enfants_out = enfants_;
       enfants_a_charge_out = enfants_a_charge_;
       ressources_menage_out = ressources_menage_;
       residence_out = residence_; montant_verse_out = montant_verse_}