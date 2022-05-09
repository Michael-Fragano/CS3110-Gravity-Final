type shape =
  | Circle of float
  | Rectangle of float * float

type t = {
  x : float;
  y : float;
  s : shape;
  c : int;
  hollow : bool;
}

let new_t x y s c ?(hollow = false) () = { x; y; s; c; hollow }

let new_circle x y r c ?(hollow = false) () =
  new_t x y (Circle r) c ~hollow ()

let new_rectangle x y w h c ?(hollow = false) () =
  new_t x y (Rectangle (w, h)) c ~hollow ()

let new_square x y w c ?(hollow = false) () =
  new_rectangle x y w w c ~hollow ()

let draw camera seg =
  Graphics.set_color seg.c;
  let x, y = Camera.to_window camera seg.x seg.y in
  match seg.s with
  | Circle r ->
      let r = Camera.to_window_scale camera r in
      (if seg.hollow then Graphics.draw_circle
      else Graphics.fill_circle)
        x y r
  | Rectangle (w, h) ->
      let w = Camera.to_window_scale camera w in
      let h = Camera.to_window_scale camera h in
      (if seg.hollow then Graphics.draw_rect else Graphics.fill_rect)
        x y w h

let clear camera seg =
  Graphics.set_color Graphics.background;
  let x, y = Camera.to_window camera seg.x seg.y in
  match seg.s with
  | Circle r ->
      let r = Camera.to_window_scale camera r in
      (if seg.hollow then Graphics.draw_circle
      else Graphics.fill_circle)
        x y r
  | Rectangle (w, h) ->
      let w = Camera.to_window_scale camera w in
      let h = Camera.to_window_scale camera h in
      (if seg.hollow then Graphics.draw_rect else Graphics.fill_rect)
        x y w h
