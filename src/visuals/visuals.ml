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

let draw_focus (status : Status.t) =
  moveto 0 0;
  set_color background;
  fill_rect 0 0 (size_x ()) 10;
  set_color black;
  let focus_str =
    match Status.camera_focus status with
    | Origin -> "Origin"
    | Body n -> "Body " ^ string_of_int n
    | CenterOfMass -> "Center Of Mass"
    | Free -> "Free"
  in
  draw_string (Printf.sprintf "focus : " ^ focus_str);
  draw_string (Printf.sprintf "  speed : %f" (Status.speed status))

let rec draw_bodies camera clear = function
  | [] -> ()
  | h :: t -> (
      if clear then set_color background
      else set_color (Gravity.color h);
      match
        Camera.to_window camera (Gravity.x_pos h) (Gravity.y_pos h)
      with
      | x, y ->
          fill_circle x y
            (Camera.to_window_scale camera (Gravity.rad h));
          draw_bodies camera clear t)

let rec draw_paths camera clear paths =
  (if clear then Paths.clear else Paths.draw) camera paths

let clear_screen camera system status =
  draw_bodies camera true (Gravity.bods system);
  if Status.show_paths status then
    draw_paths camera true (Status.paths status)

let render
    (camera : Camera.t)
    (system : Gravity.system)
    (status : Status.t) : unit =
  draw_bodies camera false (Gravity.bods system);
  if Status.show_paths status then
    draw_paths camera false (Status.paths status);
  draw_focus status;
  synchronize ();
  clear_screen camera system status

let update_status (status : Status.t) (system : Gravity.system) :
    Status.t =
  status |> Status.poll_input
  |> Status.update_body_num system
  |> Status.bind_mouse Pressed Status.toggle_pause
  |> Status.bind_key ' ' Pressed Status.cycle_focus
  |> Status.bind_key ',' Pressed (Status.update_speed false)
  |> Status.bind_key '.' Pressed (Status.update_speed true)
  |> Status.bind_key 'p' Pressed Status.toggle_paths
  |> Status.bind_key 'q' Pressed (fun _ ->
         raise @@ Graphics.Graphic_failure "Quit Window")

let update_paths (system : Gravity.system) (status : Status.t) =
  Status.update_paths system status

let seconds_per_frame : float = 1. /. 60.

let update_system (system : Gravity.system) (status : Status.t) :
    Gravity.system =
  Gravity.frame system
    (int_of_float
       (seconds_per_frame *. Status.speed status
      /. Gravity.timestep system))
(* <- gives ticks per frame*)

let adjust
    (camera : Camera.t)
    (system : Gravity.system)
    (status : Status.t) : Camera.t =
  (match Status.camera_focus status with
  | Camera.Origin -> Camera.set_pos 0.0 0.0 camera
  | Camera.Body n ->
      let b = system |> Gravity.bods |> fun lst -> List.nth lst n in
      Camera.set_pos (Gravity.x_pos b) (Gravity.y_pos b) camera
  | CenterOfMass ->
      let b = Gravity.bods system in
      let rec bm bods =
        match bods with
        | [] -> 0.0
        | [ n ] -> Gravity.mass n
        | h :: t -> Gravity.mass h +. bm t
      in
      let m = bm b in
      let cx =
        let rec bx bods =
          match bods with
          | [] -> 0.0
          | [ n ] -> Gravity.x_pos n *. Gravity.mass n
          | h :: t -> (Gravity.x_pos h *. Gravity.mass h) +. bx t
        in
        if List.length b > 0 then bx b /. m else bx b
      in
      let cy =
        let rec by bods =
          match bods with
          | [] -> 0.0
          | [ n ] -> Gravity.y_pos n *. Gravity.mass n
          | h :: t -> (Gravity.y_pos h *. Gravity.mass h) +. by t
        in
        if List.length b > 0 then by b /. m else by b
      in
      Camera.set_pos cx cy camera
  | _ -> camera)
  |> (if Status.key_state 'w' status = Pressed then Camera.zoom 0.8
     else Fun.id)
  |>
  if Status.key_state 's' status = Pressed then Camera.zoom 1.25
  else Fun.id

let rec main_loop
    (camera : Camera.t)
    (system : Gravity.system)
    (status : Status.t)
    (time : float) : unit =
  render camera system status;
  let new_system =
    if Status.is_paused status then system
    else update_system system status
  in
  let new_status =
    update_status status new_system |> update_paths new_system
  in
  let new_camera = adjust camera new_system new_status in
  let new_time = Unix.gettimeofday () in
  let time_left = seconds_per_frame -. new_time +. time in
  if time_left > 0. then Unix.sleepf time_left;
  main_loop new_camera new_system new_status (new_time +. time_left)

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
  with Graphics.Graphic_failure _ -> Graphics.close_graph ()

let start_window_from_create system =
  try
    init ();
    main_loop Camera.default system (Status.default ())
      (Unix.gettimeofday ())
  with Graphics.Graphic_failure _ -> Graphics.close_graph ()
