(** logs.mli : signature pour les logs ogit *)

(**  NOTE: on suppose que quand les fonctions sont appellées le CWD du 
    programme est repo/ *)

(** la structure de données représentant un commit *)
type commit = {
    parents : Digest.t list; (** le commit ancêtre (ou les deux parents 
                                 s'il s'agit d'un merge) *)
    date : float;  (** la date du commit **)
    message : string; (** le message du commit **)
    content : Digest.t  (** le hash de l'objet correspondant au depot 
                            au moment du commit *)
}

(** la date au format HH:MM:SS-JJ/MM/AAAA
    ex: 16:08:40-07/11/2022 *)
val date_fm : float -> string

(** met à jour le fichier .ogit/HEAD *)
val set_head : Digest.t list -> unit

(** lit le fichier .ogit/HEAD *)
val get_head : unit -> Digest.t list

(** Crée la structure de données en se basant sur le message et le hash de
    l'objet correspondant au repo dans l'état actuel. Le ou les parents sont
    déterminés par un appel à get_head. La date courante est calculée par
    [Unix.time]. Aucun fichier n'est écrit. *)
val make_commit : string -> Digest.t -> commit

(** Crée la structure de données pour un commit initial.
    Le message est "init commit" et le contenu est l'objet renvoyé
    par Objects.store_work_directory *)
val init_commit : unit -> commit

(** écrit le fichier correspondant au commit dans .ogit/logs et renvoie le
    hash de ce commit *)
val store_commit : commit -> Digest.t

(** lit le fichier d'un commit dans ./ogit/logs et construit la structure de
    données associée *)
val read_commit : Digest.t -> commit