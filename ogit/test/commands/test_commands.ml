open Ogitlib
open Commands

(* on se place dans le répertoire repo/ *)
let repo_root = "../../../../../repo"
let () = 
  Sys.chdir repo_root

(* on prepare le repertoire .ogit *)
let _ = Sys.command "rm -rf .ogit"


(* test de ogit_init *)
let () = Format.printf "@.EXECUTION DE ogit_init@."
let _ = ogit_init ()

let () = Format.printf "@.NOMBRE DE LOGS : %d@." (Array.length (Sys.readdir ".ogit/logs"))
let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL ls .ogit/objects@."
let _ = Sys.command "ls .ogit/objects"
let first_commit = (In_channel.with_open_text ".ogit/HEAD" In_channel.input_all)


(* test de ogit_commit *)
let () = Format.printf "@.AJOUT D'UN FICHIER VIDE ET EXECUTION de ogit_commit@."
let _ = Sys.command "echo >empty.txt"
let _ = ogit_commit "vide"

let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL tree@."
let _ = Sys.command "tree"

let () = Format.printf "@.NOMBRE DE LOGS : %d@." (Array.length (Sys.readdir ".ogit/logs"))
let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL ls .ogit/objects@."
let _ = Sys.command "ls .ogit/objects"

let second_commit = (In_channel.with_open_text ".ogit/HEAD" In_channel.input_all)

(* test de ogit_checkout *)
let () = Format.printf "@.EXECUTION DE ogit_checkout."
let _ = ogit_checkout first_commit

let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL tree@."
let _ = Sys.command "tree"

let () = Format.printf "@.NOMBRE DE LOGS : %d@." (Array.length (Sys.readdir ".ogit/logs"))
let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL ls .ogit/objects@."
let _ = Sys.command "ls .ogit/objects"

(* test de ogit_merge sans conflict  *)
let () = Format.printf "@.AJOUT D'UN FICHIER ET EXECUTION de ogit_commit@."
let _ = Sys.command "echo 42 >foo/rep.txt"

let () = Format.printf "@.EXECUTION de ogit_merge@."
let _ = ogit_merge second_commit

let () = Format.printf "@.NOMBRE DE LOGS : %d@." (Array.length (Sys.readdir ".ogit/logs"))
let () = Format.printf "@.NOMBRE HEAD : %d@." (List.length (Logs.get_head ()))
let () = Format.printf "@.NOMBRE PARENTS : %d@." (List.length (Logs.read_commit (List.hd (Logs.get_head ()))).parents)

let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL tree@."
let _ = Sys.command "tree"

let _ = Sys.command "rm -f empty.txt"
let _ = Sys.command "rm -f foo/rep.txt" 

(* test de ogit_merge avec conflict  *)
let _ = ogit_checkout first_commit
let () = Format.printf "@.CONFLIT SUR empty.txt@."
let _ = Sys.command "echo plein >empty.txt"

let () = Format.printf "@.EXECUTION de ogit_merge@."
let _ = ogit_merge second_commit

let () = Format.printf "@.NOMBRE DE LOGS : %d@." (Array.length (Sys.readdir ".ogit/logs"))
let () = Format.printf "@.NOMBRE HEAD : %d@." (List.length (Logs.get_head ()))
let () = Format.printf "@.NOMBRE PARENTS : %d@." (List.length (Logs.read_commit (List.hd (Logs.get_head ()))).parents)

let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL tree@."
let _ = Sys.command "tree"

let _ = Sys.command "rm -f empty.txt*"
let _ = Sys.command "rm -f foo/rep.txt*" 
