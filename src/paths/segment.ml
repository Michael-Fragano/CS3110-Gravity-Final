module type Segment = sig
  type t

  val new_t : int -> int -> t
  val draw : t -> unit
end

module type SegmentMaker = functor (Config : PathConfig.Config) ->
  Segment

module Make (Config : PathConfig.Config) : Segment = struct
  type t = {
    x : int;
    y : int;
    r : int;
    c : int;
  }

  let new_t x y = { x; y; r = Config.size; c = 0xFF0000 }

  let draw seg =
    Graphics.set_color seg.c;
    Graphics.draw_circle seg.x seg.y seg.r
end