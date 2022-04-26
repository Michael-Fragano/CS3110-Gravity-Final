module Make (Config : PathConfig.Config) : Queue.Queue = struct
  type 'a t = 'a list

  let empty = []
  let length = List.length

  let rec append elt = function
    | [] -> [ elt ]
    | h :: t -> h :: append elt t

  let add elt = function
    | [] -> [ elt ]
    | _ :: t as q ->
        append elt (if length q = Config.max_length then t else q)

  let rec fold f init q = List.fold_left f init q
end
