module type Path = sig
  type segment
  type t

  val empty : t
  val draw : t -> unit
  val length : t -> int
  val add_segment : int -> int -> t -> t
end

module Make
    (Config : PathConfig.Config)
    (SM : Segment.SegmentMaker)
    (QM : Queue.QueueMaker) : Path
