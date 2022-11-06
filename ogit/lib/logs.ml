type commit = {
    parents : Digest.t list;
    date : float;
    message : string;
    content : Digest.t
}
    
let date_fm _d = failwith "TODO"

let set_head _l = failwith "TODO"

let get_head () = failwith "TODO" 

let make_commit _s  _h =  failwith "TODO"

let init_commit () = failwith "TODO"

let store_commit _c = failwith "TODO"

let read_commit _h = failwith "TODO" 