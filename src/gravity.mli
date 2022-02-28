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

val move : body -> body
(** [move b] takes a body and determines what its new position is after
    one frame*)

val frame : system -> system
(** [frame s] takes the currenty system and runs what will happen to all
    the bodies in it after one frame of simulaiton. *)
