type position
(** The x and y position of a body*)

type velocity
(** The x and y components of a body's velocity*)

type body
(** The abstract type of floats representing the mass, position, and
    velocity of a body in the system. *)

type system
(** The gravitational constant and n number of bodies for this
    simulation*)

val from_json : Yojson.Basic.t -> system
(** [from_json s] is the system that [s] represents. Requires: [s] is a
    valid JSON system representation*)

val dist_sq : body -> body -> float
(** [dist_sq a b] is the square of the distance between two bodies [a]
    and [b]*)

val grav_field : system -> body -> float
(** [grav_field s b] is the total gravitational field experienced by [b]
    in [s] from the other bodies in [s]*)

val move : system -> body -> body
(** [move b] takes a body and determines what its new position is after
    one frame*)

val frame : system -> system
(** [frame s] takes the currenty system and runs what will happen to all
    the bodies in it after one frame of simulaiton. *)
