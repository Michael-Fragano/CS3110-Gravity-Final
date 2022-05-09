type focus =
  | Origin
  | Body of int
  | Free
  | CenterOfMass

type t = {
  dx : float;
  dy : float;
  s : float;
}
(** (dx, dy) is the point in the system space that the camera is
    centered over. s is the distance that map to 1 pixel in the window. *)

let default : t = { dx = 0.; dy = 0.; s = 1. }
let set_scale (s : float) (cam : t) : t = { cam with s }
let zoom (k : float) (cam : t) : t = set_scale (cam.s *. k) cam

let set_pos (dx : float) (dy : float) (cam : t) : t =
  { cam with dx; dy }

let move (dx : float) (dy : float) (cam : t) : t =
  set_pos (cam.dx +. dx) (cam.dy +. dy) cam

(** [center (x, y)] returns a tuple with [x] and [y] translated such
    that the origin is the center of the window, instead of the lower
    left corner *)
let center ((x, y) : int * int) : int * int =
  (x + (Graphics.size_x () / 2), y + (Graphics.size_y () / 2))

let to_window (cam : t) (x : float) (y : float) : int * int =
  center
    ( int_of_float @@ ((x -. cam.dx) /. cam.s),
      int_of_float @@ ((y -. cam.dy) /. cam.s) )

let to_window_scale (cam : t) (s : float) : int =
  int_of_float @@ Float.ceil @@ (s /. cam.s)