type t
(** This type represents the data required to show the paths of a system
    on the window *)

val create : ?max_length:int -> ?min_period:int -> unit -> t
(** [create ()] initializes a new variable of type [Paths.t]. Optional
    arguments can be used to tweak the paths' behavior *)

val update : Gravity.system -> t -> t
(** [update system paths] uses the bodies in [system] and returns an
    updated [Paths.t] based on [paths]. This should be called every
    frame *)

val draw : Camera.t -> t -> unit
(** [draw camera paths] draws [paths] to the screen, offset using
    [camera]. This should be called every frame, if paths are being
    shown *)

val clear : Camera.t -> t -> unit
(** [clear camera paths] clears the paths from the screen. This should
    be called every frame, if paths are being shown *)
