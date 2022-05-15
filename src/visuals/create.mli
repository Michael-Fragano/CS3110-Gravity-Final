val start_window : float -> float -> unit
(** [start_window dt grav] Opens a window with full gui, ready to create
    a new system with time step [dt] and gravitational constant [grav]*)

val start_window_from_json : string -> unit
(** [start_window_from_json s] Opens a create mode window with a
    previously saved system loaded in.]*)
