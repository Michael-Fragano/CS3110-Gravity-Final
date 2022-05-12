type 'a t

val empty : 'a t
(** the empty queue *)

val is_empty : 'a t -> bool
(** [is_empty q] is if [q] is empty *)

val is_full : int -> 'a t -> bool
(** [is_full cap q] is whether [q]'s length is greater or equal to [cap] *)

val enqueue : 'a -> 'a t -> 'a t
(** [enqueue elt q] adds [elt] to the end of [q] *)

val dequeue : 'a t -> 'a t
(** [dequeue q] returns [q] with its head removed *)

val iter : ('a -> unit) -> 'a t -> unit
(** [iter f q] applies [f] to each element of [q] and returns unit *)