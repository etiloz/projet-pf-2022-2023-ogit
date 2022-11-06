open Ogitlib
open Logs

(* on se place dans le répertoire repo/ *)
let repo_root = "../../../../../repo"
let () = 
  Sys.chdir repo_root;
  Format.printf "CWD : %s@." (Sys.getcwd ())


(* test de date_fm *)
let _ = Unix.time ()
let date_bidon = fst (Unix.mktime { 
  Unix.tm_hour = 16; 
  Unix.tm_min = 8; 
  Unix.tm_sec = 40;
  Unix.tm_mday = 7; 
  Unix.tm_mon = 10 (*11 - 1*); 
  Unix.tm_year = 122 (* 2022 - 1900 *);
  Unix.tm_wday = 0; Unix.tm_yday = 0; Unix.tm_isdst = false
})

let () = Format.printf "date_fm date_bidon = %s@."  (date_fm date_bidon)

(* test de get_head et set_head *)
let head_courant = get_head ()


let head_bidon = [
  Digest.string "hello";
  Digest.string "world"
]

let head_bidon2 = 
  set_head head_bidon;
  get_head ()

let () = set_head head_courant (** on remet la tête initiale en place **)

let () = Format.printf "head_bidon = head_bidon2 ? %b@." (head_bidon = head_bidon2)


(* test de read_commit et store_commit *)

let hash_bidon = Digest.string "bidon"
let commit_bidon = {
  parents = head_bidon;
  date = date_bidon;
  message = "ceci est un commit bidon";
  content = hash_bidon
}

let hash_du_fichier_log = store_commit commit_bidon
let commit_bidon2 = read_commit hash_du_fichier_log

let () = (* on "nettoie" le répertoire .ogit/logs *)
  Sys.remove (".ogit/logs/" ^ (Digest.to_hex hash_du_fichier_log))

let () = Format.printf "commit_bidon = commit_bidon2 ? %b@." (commit_bidon = commit_bidon2)