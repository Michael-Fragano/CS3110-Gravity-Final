(** This library contains the necessary functions to display orbital
    data*)

val start_window : unit -> unit
(** Final starting program. Will open window with full gui*)

val main_loop : Camera.t -> Gravity.system -> Status.t -> float -> unit
(** [main_loop camera system status time] starts the main rendering loop
    for gravity*)

val start_window_preset : string -> unit
(** [start_window_preset json b] opens a window with valid system json
    [json] loaded and running.*)

val start_window_from_create : Gravity.system -> unit
(** [start_window_preset system] opens a window with valid system
    [system] loaded and running.*)