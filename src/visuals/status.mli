type input_state =
  | Idle
  | Pressed
  | Held
  | Released
  | Unmonitored

(** create_state is the current variable being edited for the system.
    Either the location of a new body, the size of an already placed
    body, or the velocity of an alcready placed body. *)
type create_state =
  | Location
  | Size
  | Velocity
  | Delete

type t

val default : unit -> t
(** [default ()] returns a status with the default values*)

val update_input : bool -> input_state -> input_state
(** [update_input is_down curr] outputs the new input state based on if
    [is_down ()] returns true or false*)

val update_mouse : input_state -> input_state
(** [update_mouse input] changes the mouse state based on if the button
    is down or up*)

val keys_down : unit -> char list
(** returns a list of keys which are down this frame*)

val poll_input : t -> t
(** updates the key states based on which keys are down*)

val change_focus : t -> Camera.focus -> t
(** [change_focus status focus] updates [status] with new focus [focus]*)

val cycle_focus : t -> t
(** [cycle_focus status] cycles to the next focus for the status*)

val pause : t -> t
(** [pause status] sets the paused flag for the status*)

val play : t -> t
(** [play status] unsets the paused flag*)

val toggle_pause : t -> t
(** [toggle_pause status] toggles the paused flag*)

val new_cstate : t -> t
(** [new_cstate status] updates the create state to the next state.*)

val reset_cstate : t -> t
(** [reset_cstate status] updates the create_state to the Location
    state.*)

val cdelete : t -> t
(** [celete status] updates the create_state to the Delete state, if the
    state is currently in the Location state.*)

val update_speed : bool -> t -> t
(** [update_speed f status] doubles the speed of the system playback if
    [f] is true, and halves it otherwise *)

val update_body_num : Gravity.system -> t -> t
(** [update_body_num system status] returns a new status with the number
    of bodies updated to the current number of bodies in [system]*)

val mouse_state : t -> input_state
(** [mouse_state status] returns the current state of the mouse*)

val create_state : t -> create_state
(** create_state status] returns the current create state of the system*)

val key_state : char -> t -> input_state
(** [key_state c status] returns the current state of the key [c]*)

val camera_focus : t -> Camera.focus
(** [camera_focus status] is the current focus of the camera*)

val is_paused : t -> bool
(** [is_paused status] returns true if the system is paused*)

val speed : t -> float
(** [speed status] returns the current speed of the system*)

val show_paths : t -> bool
(** [show_paths status] returns if the paths should be shown on the
    screen*)

val paths : t -> Paths.t
(** [paths status] returns the list of paths to be shown on the screen*)

val update_paths : Gravity.system -> t -> t
(** [update_paths system status] updates the paths in [status] based on
    the state of [system] *)

val toggle_paths : t -> t
(** [toggle_paths t] toggles whether the paths should be shown on the
    screen *)
