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
    (QM : Queue.QueueMaker) : Path = struct
  module S = SM (Config)
  module Q = QM (Config)

  type segment = S.t
  type t = segment Q.t

  let empty = Q.empty
  let draw camera = Q.fold (fun () s -> S.draw camera s) ()
  let clear camera = Q.fold (fun () s -> S.clear camera s) ()
  let length path = Q.length path
  let add_segment x y path = Q.add (S.new_t x y) path
end

module CirclePath =
  Make
    ((val PathConfig.make ~max_length:10 ~size:10 ~shape:Circle ()))
    (Segment.Make)
    (CappedListQueue.Make)
