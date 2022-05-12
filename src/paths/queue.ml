type 'a t = 'a list

let empty = []
let is_empty q = q = empty

let is_full cap q =
  let rec full_aux acc q =
    if acc = cap then true
    else
      match q with
      | [] -> false
      | h :: t -> full_aux (acc + 1) t
  in
  full_aux 0 q

let enqueue elt q =
  let rec push_aux = function
    | [] -> [ elt ]
    | h :: t -> h :: push_aux t
  in
  push_aux q

let dequeue = function
  | [] -> []
  | h :: t -> t

let rec iter f = function
  | [] -> ()
  | h :: t ->
      f h;
      iter f t
