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
    (QM : Queue.QueueMaker) : Path = struct
  module S = SM (Config)
  module Q = QM (Config)

  type segment = S.t
  type t = segment Q.t

  let empty = Q.empty
  let draw = Q.fold (fun () s -> S.draw s) ()
  let length path = Q.length path
  let add_segment x y path = Q.add (S.new_t x y) path
end

module CirclePath =
  Make ((val PathConfig.make ~max_length:10 ())) (Segment.Make)
    (CappedListQueue.Make)
