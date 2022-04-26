module type Segment = sig
  type t

  val new_t : int -> int -> t
  val draw : t -> unit
end

module type SegmentMaker = functor (Config : PathConfig.Config) ->
  Segment

module Make (Config : PathConfig.Config) : Segment