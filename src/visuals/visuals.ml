open Graphics

let init () =
  open_graph " 800x600";
  set_window_title "CS3110 Final: Gravity!";
  auto_synchronize false

let rec draw_coords status =
  clear_graph ();
  moveto 0 0;
  draw_string
    (Printf.sprintf "x : %n, y : %n" status.mouse_x status.mouse_y);
  draw_coords (wait_next_event [ Mouse_motion ])

let rec draw_bodies clear = function
  | [] -> ()
  | h :: t ->
      if clear then set_color background
      else set_color (Gravity.color h);
      fill_circle
        ((h |> Gravity.x_pos |> Float.floor |> int_of_float)
        + (size_x () / 2))
        ((h |> Gravity.y_pos |> Float.floor |> int_of_float)
        + (size_y () / 2))
        10;
      draw_bodies clear t

let clear_system system = draw_bodies true (Gravity.bods system)

let render system status =
  draw_bodies false (Gravity.bods system);
  synchronize ();
  clear_system system

let seconds_per_frame : float = 1. /. 60.

let update system : Gravity.system =
  Gravity.frame system
    (int_of_float (seconds_per_frame /. Gravity.timestep system))
(* <- gives ticks per frame*)

let get_status () = wait_next_event [ Poll ]

let rec main_loop system status time : unit =
  render system status;
  let new_system = update system in
  let new_status = status (*get_status eventually*) in
  let new_time = Unix.gettimeofday () in
  let time_left = seconds_per_frame -. new_time +. time in
  if time_left > 0. then Unix.sleepf time_left;
  main_loop new_system new_status new_time

let start_window () =
  init ();
  draw_coords (wait_next_event [ Mouse_motion ])

let start_window_preset json =
  let system =
    "data/" ^ json ^ ".json"
    |> Yojson.Basic.from_file |> Gravity.from_json
  in
  init ();
  main_loop system (get_status ()) (Unix.gettimeofday ())