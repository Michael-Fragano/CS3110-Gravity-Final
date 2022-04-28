(** This library contains the necessary functions to display orbital
    data*)

module Camera = Camera
module Status = Status
module Create = Create

val start_window : unit -> unit
(** Final starting program. Will open window with full gui*)

val main_loop : Camera.t -> Gravity.system -> Status.t -> float -> unit
(** [main_loop camera system status time] starts the main rendering loop
    for gravity*)

val start_window_preset : string -> unit
(** [start_window_preset json b] opens a window with valid system json
    [json] loaded and running.*)
