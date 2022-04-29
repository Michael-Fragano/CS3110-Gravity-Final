module type Segment = sig
  type t

  val new_t : float -> float -> t
  val draw : Camera.t -> t -> unit
  val clear : Camera.t -> t -> unit
end

module type SegmentMaker = functor (Config : PathConfig.Config) ->
  Segment

module Make (Config : PathConfig.Config) : Segment = struct
  type t = {
    x : float;
    y : float;
    r : int;
    c : int;
  }

  let new_t x y = { x; y; r = Config.size; c = 0xFF0000 }

  let draw camera seg =
    Graphics.set_color seg.c;
    let x, y = Camera.to_window camera seg.x seg.y in
    Graphics.draw_circle x y seg.r

  let clear camera seg =
    Graphics.set_color Graphics.background;
    let x, y = Camera.to_window camera seg.x seg.y in
    Graphics.draw_circle x y seg.r
end
