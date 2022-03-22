type focus =
  | Origin
  | Body of int
  | Free
  | CenterOfMass

type t = {
  dx : float;
  dy : float;
  sx : float;
  sy : float;
}
(** (dx, dy) is the point in the system space that the camera is
    centered over. sx and sy are respective distances that map to 1
    pixel in the window. *)

let default : t = { dx = 0.; dy = 0.; sx = 1.; sy = 1. }

let set_scale (sx : float) (sy : float) (cam : t) : t =
  { cam with sx; sy }

let zoom (k : float) (cam : t) : t =
  set_scale (cam.sx *. k) (cam.sy *. k) cam

let set_pos (dx : float) (dy : float) (cam : t) : t =
  { cam with dx; dy }

let move (dx : float) (dy : float) (cam : t) : t =
  set_pos (cam.dx +. dx) (cam.dy +. dy) cam

let to_window_indiv (cam : t) (x : float) : int =
  int_of_float @@ ((x -. cam.dx) /. cam.sx)

let to_window (cam : t) ((x, y) : float * float) : int * int =
  (to_window_indiv cam x, to_window_indiv cam y)
