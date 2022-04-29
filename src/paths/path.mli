module type Path = sig
  type segment
  type t

  val empty : t
  val draw : Camera.t -> t -> unit
  val clear : Camera.t -> t -> unit
  val length : t -> int
  val add_segment : float -> float -> t -> t
end

module Make
    (Config : PathConfig.Config)
    (SM : Segment.SegmentMaker)
    (QM : Queue.QueueMaker) : Path

module CirclePath : Path
