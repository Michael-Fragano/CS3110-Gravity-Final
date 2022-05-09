(** This type represents what the camera should focus on in a system. *)
type focus =
  | Origin
  | Body of int
  | Free
  | CenterOfMass

type t
(** This type represents a camera that translates system space to screen
    space *)

val default : t
(** Returns a camera initialized with default values (centered on middle
    of window) *)

val set_scale : float -> t -> t
(** [set_scale sx sy cam] updates [cam] with new [sx] and [sy] values. 1
    is the default value *)

val zoom : float -> t -> t
(** [zoom k cam] is [cam] zoomed in by a factor of [k] *)

val set_pos : float -> float -> t -> t
(** [set_pos x y cam] centers the camera on ([x], [y]) in the system
    space *)

val move : float -> float -> t -> t
(** [move x y cam] is [cam] moved horizontally by [x] and vertically by
    [y] *)

val to_window : t -> float -> float -> int * int
(** [to_window cam x y] returns a tuple representing the window
    coordinates of the point ([x], [y]) in the system space *)

val to_window_scale : t -> float -> int
(** [to_window_scale s] returns the value transformed to the window
    coordinates without translation *)
