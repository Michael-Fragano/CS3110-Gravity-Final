type frame = Segment.t list
(** [frame] represents a snapshot of all paths at a point in time *)

type t
(** This type represents the data required to show the paths of a system
    on the window *)

val is_empty : t -> bool
(** [is_empty p] is whether p is empty *)

val is_full : t -> bool
(** [is_full p] is whether p is full *)

val remove_frame : t -> t
(** [pop p] returns [p] with is head removed *)

val add_frame : frame -> t -> t
(** [push p] returns [p] with [frame] included at its tail.
    Precondition: p is not full *)

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
