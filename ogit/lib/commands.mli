(** objects.mli : signature pour les commandes ogit de haut niveau **)

(**  NOTE: on suppose que quand les fonctions - sauf init - sont appellées dans un repo valable, 
    i.e. contenant un répertoire .ogit **)

(** initialise un dépot ogit. Crée un premier commit à l'état actuel du dépot.
    Une exception est levée si répertoire .ogit existe déjà **) 
val ogit_init : unit -> unit  
  
(** produit et enregistre un commit basé sur l'état actuel du repo avec le message indiqué. 
    Une exception est levée si un conflit est présent. **) 
val ogit_commit : string -> unit

(** restaure le repo dans l'état indiqué (hash hexadécimal).
    Une exception est levée si le hash est inconnu. **) 
val ogit_checkout : string -> unit
  
(** affiche les information concernant tous les commit ancètre de l'état actuel, du plus ancien au plus récent. **) 
val ogit_log : unit -> unit 

(** fusione l'état actuel du repo avec l'état indiqué (hash hexadécimal).
    Une exception est levée si un conflit est présent, si le hash est inconnu ou 
    si l'état fuisionné est ancêtre de l'état actuel (ou inversement). **) 
val ogit_merge : string -> unit
