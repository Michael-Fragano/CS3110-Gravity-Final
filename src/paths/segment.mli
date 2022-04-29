module type Segment = sig
  type t

  val new_t : float -> float -> t
  val draw : Camera.t -> t -> unit
  val clear : Camera.t -> t -> unit
end

module type SegmentMaker = functor (Config : PathConfig.Config) ->
  Segment

module Make (Config : PathConfig.Config) : Segment