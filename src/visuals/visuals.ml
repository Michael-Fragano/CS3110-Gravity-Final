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
    match status.camera_focus with
    | Origin -> "Origin"
    | Body n -> "Body " ^ string_of_int n
    | CenterOfMass -> "Center Of Mass"
    | Free -> "Free"
  in
  draw_string (Printf.sprintf "focus : " ^ focus_str);
  draw_string (Printf.sprintf "  speed : %f" status.speed)

let rec draw_bodies camera clear = function
  | [] -> ()
  | h :: t -> (
      if clear then set_color background
      else set_color (Gravity.color h);
      match
        Camera.to_window camera (Gravity.x_pos h) (Gravity.y_pos h)
      with
      | x, y ->
          fill_circle x y (int_of_float (Gravity.rad h));
          draw_bodies camera clear t)

let clear_system camera system =
  draw_bodies camera true (Gravity.bods system)

let render
    (camera : Camera.t)
    (system : Gravity.system)
    (status : Status.t) : unit =
  draw_bodies camera false (Gravity.bods system);
  draw_focus status;
  synchronize ();
  clear_system camera system

let poll (status : Status.t) (system : Gravity.system) : Status.t =
  status |> Status.poll_input |> Status.update_body_num system
  |> fun s ->
  if s.mouse_state = Pressed then Status.toggle_pause s
  else
    s |> fun s ->
    if s.space_state = Pressed then Status.cycle_focus s
    else
      s |> fun s ->
      if s.l_arrow_state = Pressed then Status.update_speed false s
      else
        s |> fun s ->
        if s.r_arrow_state = Pressed then Status.update_speed true s
        else s

let seconds_per_frame : float = 1. /. 60.

let update (system : Gravity.system) (status : Status.t) :
    Gravity.system =
  Gravity.frame system
    (int_of_float
       (seconds_per_frame *. status.speed /. Gravity.timestep system))
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
  | _ -> camera

let rec main_loop
    (camera : Camera.t)
    (system : Gravity.system)
    (status : Status.t)
    (time : float) : unit =
  render camera system status;
  let new_system =
    if status.paused then system else update system status
  in
  let new_status = poll status new_system in
  let new_camera = adjust camera new_system new_status in
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
