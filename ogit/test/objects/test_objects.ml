open Ogitlib
open Objects


(* on place le programme dans repo *)
let repo_root = "../../../../../repo"
let () = 
  Sys.chdir repo_root

(* on prepare le repertoire .ogit *)
let _ = Sys.command "rm -rf .ogit"
let _ = Sys.command "cp -r ../repo.origin/.ogit ."


(* test de la fonction hash sur des objets texte *)
let obj1 = Text "hello, world!"
let () = Format.printf "hash de obj1 : %s@." (Digest.to_hex (hash obj1))


(* test de la fonction hash sur des objets directory *)
let obj2 = Text "salut, le monde!"
let obj3 = Directory []
let obj4 = Directory [
  ("obj1", false, (hash obj1), obj1);
  ("obj2", false, (hash obj2), obj2);
  ("obj3", true, (hash obj3), obj3)
]
let () = Format.printf "hash de obj4 : %s@." (Digest.to_hex (hash obj4))


(* test de is_known *)
let hash_de_toto_txt = Digest.from_hex "1e423d8532170b358868e1af76688c4a"
let hash_bidon = Digest.from_hex "2f423d8532170b358868e1af76688c4a"

let () = Format.printf "is_known %s? %b@." (Digest.to_hex hash_de_toto_txt) (is_known hash_de_toto_txt) 
let () = Format.printf "is_known %s? %b@." (Digest.to_hex hash_bidon) (is_known hash_bidon)


(* test de store_object et read_text_object *)
let hash_obj4 = store_object obj4 
let text_obj4 = read_text_object hash_obj4
let () = Format.printf "@.CONTENU DU FICHIER REPRESENTANT L'OBJET obj4: @.%s@." text_obj4

(* on supprime obj4 *)
let _ = Sys.command ("rm -f .ogit/objects/" ^ (Digest.to_hex hash_obj4))

(* test de store_work_directory et read_directory_object *)
(* on suppose que le répertoire repo est dans l'état initial (celui fourni dans l'archive), à savoir 
.
├── foo
│   ├── bar
│   │   └── tata.txt
│   ├── titi.txt
│   └── toto.txt
└── toto.txt
avec les contenus des fichiers inchangés par rapport à ce qui était dans l'archive
On efface au début le contenu du répertoire .ogit/objects pour vérifier que store_work_directory fait bien son travail
Si le test échoue, il faudra restaurer ce répertoire en se basant sur l'archive fournie pour que les tests du début
passent à nouveau
*)
let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL tree@."
let _ = Sys.command "tree"
let hash_repo = store_work_directory ()
let () = Format.printf "@.hash_repo = %s@." (Digest.to_hex hash_repo)
let () = Format.printf "@.CONTENU DU FICHIER %s:@.%s@." (Digest.to_hex hash_repo) (read_text_object hash_repo)
let rec pp_object = function
| Text s -> Format.sprintf "Text(\"%s\")" s
| Directory(l) -> 
  l |> List.sort compare |> List.map (fun (s,d,h,obj) -> Format.sprintf "(\"%s\",%b,%s,%s)" s d (Digest.to_hex h) (pp_object obj))
  |> String.concat ";" 
  |> Format.sprintf "Directory[%s]"
let () = Format.printf "@.OBJET CORRESPONDANT AU REPO:@.%s@." (pp_object (read_directory_object hash_repo))


(* test de clean_work_directory et restore_work_directory *)
let () = Format.printf "@.EXECUTION DE clean_work_directory@."
let () = clean_work_directory ()
let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL tree -a@."
let _ = Sys.command "tree -a"
let () = Format.printf "@.EXECUTION DE restore_work_directory@."
let () = restore_work_directory (read_directory_object hash_repo)
let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL tree -a@."
let _ = Sys.command "tree -a"
let () = Format.printf "@.EXECUTION DE LA COMMANDE SHELL cat toto.txt@."
let _ = Sys.command "cat toto.txt"
