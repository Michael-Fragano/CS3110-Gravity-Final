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

type g_field
(** The gravitational forces acting on a body*)

val from_json : Yojson.Basic.t -> system
(** [from_json s] is the system that [s] represents. Requires: [s] is a
    valid JSON system representation*)

val make_g : float * float -> g_field
(** [make_g g] creates a g_field from float list of two floats [g]*)

val g_const : system -> float
(** [g_const s] returns the value of the gravitational constant of
    system [s]*)

val bodies_ex : system -> body -> body list
(** [bodies s b] returns a list of the bodies in system [s], excluding
    body [b]*)

val x_dist : body -> body -> float
(** [x_dist a b] returns the x component of the distance of body [b]
    from body [a]*)

val y_dist : body -> body -> float
(** [y_dist a b] returns the y component of the distance of body [b]
    from body [a]*)

val dist_sq : body -> body -> float
(** [dist_sq a b] is the the distance between two bodies [a] and [b]*)

val grav_force : float -> body -> body -> float
(** [grav_force g a b] returns the gravitational force felt between
    bodies [a] and [b], with gravitaitonal constant [g]*)

val grav_field : system -> body list -> body -> g_field
(** [grav_field s o b] is the total gravitational field experienced by
    [b] in [s] from the other bodies [o]*)

val move : system -> body -> body
(** [move b] takes a body and determines what its new position is after
    one frame*)

val frame : system -> system
(** [frame s] takes the currenty system and runs what will happen to all
    the bodies in it after one frame of simulaiton. *)
