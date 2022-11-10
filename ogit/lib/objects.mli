(** objects.mli : signature pour les objets versionnés ogit **)

(**  NOTE: on suppose que quand les fonctions sont appellées le CWD du programme est repo/ **)

(** le type des objets versionnés **)
type t =
| Text of string 
| Directory of (string * bool * Digest.t * t) list

(** calcule le hash d'un objet versionné, attention pas de \n ajouté à la fin des réprésentation des répertoires **)
val hash : t -> Digest.t

(** teste si un objet, identifié par son hash, est présent dans .ogit/objects/ **)
val is_known : Digest.t -> bool

(** écrit l'objet dans un fichier dans .ogit/objects/ renvoie le hash de cet objet **)
val store_object : t -> Digest.t

(** charge le texte du fichier dans .ogit/objects/ dont le hash est donné *)
val read_text_object : Digest.t -> string

(** crée dans .ogit/objects l'objet correspondant au répertoire repo/ et tous ceux qu'il contient récursivement, renvoie le hash de cet objet **)
val store_work_directory : unit -> Digest.t 

(** lit le fichier de .ogit/objects identifié par le hash, et correspondant à un objet répertoire, et renvoie cet objet répertoire **)
val read_directory_object : Digest.t -> t

(** efface tous les fichiers "versionnés" de repo/ et ses sous-répertoires 
    les fichiers "versionnés" sont ceux ne commençant pas par un "."        **)
val clean_work_directory : unit -> unit

(** écrit dans repo/ tous les fichiers mentionnés dans l'objet passé en paramètre **)
val restore_work_directory : t -> unit

(** met à jour repo/ en applicant la règle Merge 1 **)
val merge_work_directory_I : t -> bool