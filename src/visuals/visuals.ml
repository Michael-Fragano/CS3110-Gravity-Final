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

let rec draw_bodies camera clear = function
  | [] -> ()
  | h :: t -> (
      if clear then set_color background
      else set_color (Gravity.color h);
      match
        Camera.to_window camera (Gravity.x_pos h) (Gravity.y_pos h)
      with
      | x, y ->
          fill_circle x y 10;
          draw_bodies camera clear t)

let clear_system camera system =
  draw_bodies camera true (Gravity.bods system)

let render
    (camera : Camera.t)
    (system : Gravity.system)
    (status : Status.t) : unit =
  draw_bodies camera false (Gravity.bods system);
  synchronize ();
  clear_system camera system

let seconds_per_frame : float = 1. /. 60.

let update (system : Gravity.system) (status : Status.t) :
    Gravity.system =
  Gravity.frame system
    (int_of_float (seconds_per_frame /. Gravity.timestep system))
(* <- gives ticks per frame*)

let adjust
    (camera : Camera.t)
    (system : Gravity.system)
    (status : Status.t) : Camera.t =
  match status.camera_focus with
  | Camera.Origin -> Camera.set_pos 0.0 0.0 camera
  | Camera.Body n ->
      let b = system |> Gravity.bods |> fun lst -> List.nth lst n in
      Camera.set_pos (Gravity.x_pos b) (Gravity.y_pos b) camera
  | _ -> camera

let get_status () = wait_next_event [ Poll ]

let rec main_loop camera system status time : unit =
  render camera system status;
  let new_status = status (*get_status eventually*) in
  let new_system = update system status in
  let new_camera = adjust camera system status in
  let new_time = Unix.gettimeofday () in
  let time_left = seconds_per_frame -. new_time +. time in
  if time_left > 0. then Unix.sleepf time_left;
  main_loop new_camera new_system new_status new_time

let start_window () =
  init ();
  draw_coords (wait_next_event [ Mouse_motion ])

let start_window_preset json =
  let system =
    "data/" ^ json ^ ".json"
    |> Yojson.Basic.from_file |> Gravity.from_json
  in
  try
    init ();
    main_loop Camera.default system (Status.default ())
      (Unix.gettimeofday ())
  with Graphics.Graphic_failure "fatal I/O error" ->
    Graphics.close_graph ()
