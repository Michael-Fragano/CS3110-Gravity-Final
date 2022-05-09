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

val cbrt : float -> float
(** [cbrt f] returns the cube root of float [f].*)

val from_json : Yojson.Basic.t -> system
(** [from_json s] is the system that [s] represents. Requires: [s] is a
    valid JSON system representation*)

val make_g : float -> float -> g_field
(** [make_g h v] creates a g_field from two floats [h](horizontal) and
    [v](vertical)*)

val make_v : float -> float -> velocity
(** [make_v v] creates a new velocity from two floats [h](horizontal)
    and [v](vertical)*)

val make_b : position -> velocity -> float -> int -> bool -> body
(** [make_b p v m c cr] creates a new body from position [p], velocity
    [v], mass [m], and color [c], with a bool for if it is in the
    process of being created by the creator.*)

val make_p : float -> float -> position
(** [make_p h v] creates a new velocity from two floats [h](horizontal)
    and [v](vertical)*)

val make_s : float -> float -> body list -> system
(** [make_s t gr b] creates a new system from dt [t], gravitational
    constant [gr], and body list [b]*)

(**HELPER FUNCTIONS*)

val timestep : system -> float
(** [timestep s] returns the value of dt of system [s]*)

val g_const : system -> float
(** [g_const s] returns the value of the gravitational constant of
    system [s]*)

val bods : system -> body list
(** [bods s] takes a system [s] and returns the list of bodies for that
    system.*)

val rad : body -> float
(** [rad b] returns the radius of body [b]*)

val mass : body -> float
(** [mass b] returns the mass of body [b]*)

val velocity : body -> velocity
(** [velocity b] returns the velocity of body [b]*)

val create : body -> bool
(** [create b] returns if body [b] is in the create stage.*)

val bodies_ex : body list -> body -> body list
(** [bodies s b] returns a list of the bodies in system [s], excluding
    body [b]*)

val x_dist : body -> body -> float
(** [x_dist a b] returns the x component of the distance of body [b]
    from body [a]*)

val y_dist : body -> body -> float
(** [y_dist a b] returns the y component of the distance of body [b]
    from body [a]*)

val dist : body -> body -> float
(** [dist_sq a b] is the the distance between two bodies [a] and [b]*)

val grav_force : float -> body -> body -> float
(** [grav_force g a b] returns the gravitational force felt between
    bodies [a] and [b], with gravitaitonal constant [g]*)

val gx : g_field -> float
(** [gx g] returns x component of g_field [g]*)

val gy : g_field -> float
(** [gy g] returns y component of g_field [g]*)

val acc : float -> float -> float
(** [acc f m ] returns the acceleration of a force [f] and a mass [m]*)

val x_pos : body -> float
(** [x_pos b] returns the x position of body [b]*)

val y_pos : body -> float
(** [y_pos b] returns the y position of body [b]*)

val pos : body -> position
(** [pos b] returns the position of body [b]*)

val color : body -> int
(** [color b] returns the color of body [b] in RGB format*)

(**MAIN FUNCTIIONS*)

val grav_field : system -> body list -> body -> g_field
(** [grav_field s o b] is the total gravitational field experienced by
    [b] in [s] from the other bodies [o]*)

val new_v : body -> g_field -> float -> velocity
(** [new_v b g t] takes the velocity of a body [b] and gravitaitonal
    forces [g] applied to it to calculate the new velocity felt after
    [t] seconds of acceleration.*)

val move : system -> body -> body
(** [move s b] takes a body [b] of system [s] and determines what its
    new position is after one frame*)

val collide : body -> body -> body
(** [collide b1 b2] takes a bodies [b1] and [b2] and calculates a new
    body with a position, speed and velocity based on an inelastic
    collision*)

val collision_check : system -> system
(** [collision_check s] takes system [s] and removes any bodies that
    are within the radius of another body.*)

val frame : system -> int -> system
(** [frame s f] takes the current system and runs what will happen to
    all the bodies in it after one [f] frames of simulaiton. *)
