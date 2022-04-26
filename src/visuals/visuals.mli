(** This library contains the necessary functions to display orbital
    data*)

module Camera = Camera
module Status = Status

val start_window : unit -> unit
(** Final starting program. Will open window with full gui*)

val start_window_preset : string -> unit
(** [start_window_preset json] opens a window with valid system json
    [json] loaded and running *)
