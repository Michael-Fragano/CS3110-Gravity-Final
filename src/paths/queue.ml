module type Queue = sig
  type 'a t

  val empty : 'a t
  val add : 'a -> 'a t -> 'a t
  val length : 'a t -> int
  val fold : ('acc -> 'a -> 'acc) -> 'acc -> 'a t -> 'acc
end

module type QueueMaker = functor (Config : PathConfig.Config) -> Queue