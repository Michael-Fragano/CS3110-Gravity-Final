type shape
(** shape represents a geometric shape, either a circle or a rectangle *)

type t
(** A [t] is a piece of a path following the location of some body in a
    system space *)

val new_t : float -> float -> shape -> int -> ?hollow:bool -> unit -> t
(** [new_t x y s c ()] is a new [t] located at ([x], [y]) with shape
    [s], color [c], and optionally hollow *)

val new_circle :
  float -> float -> float -> int -> ?hollow:bool -> unit -> t
(** [new_circle x y r c ()] is a new circle with radius [r] located at
    ([x], [y]), with color [c] and optionally set to be hollow *)

val new_square :
  float -> float -> float -> int -> ?hollow:bool -> unit -> t
(** [new_square x y w c ()] is a new square with side length [w] located
    at ([x], [y]), with color [c] and optionally set to be hollow *)

val new_rectangle :
  float -> float -> float -> float -> int -> ?hollow:bool -> unit -> t
(** [new_rectangle x y w h c ()] is a new rectangle with width [w] and
    height [h] located at ([x], [y]), with color [c] and optionally set
    to be hollow *)

val draw : Camera.t -> t -> unit
(** [draw camera seg] draws the segment [seg] to the screen using
    [camera]. This should be called every frame, if paths are being
    shown *)

val clear : Camera.t -> t -> unit
(** [clear camera seg] clears [seg] from the screen. This should be
    called every frame, if paths are being shown *)
