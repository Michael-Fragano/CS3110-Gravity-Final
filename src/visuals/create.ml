open Gravity
open Graphics
open Status
open Camera
open Visuals

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

let draw_status (status : Status.t) (system : Gravity.system) =
  moveto 0 0;
  set_color background;
  fill_rect 0 0 (size_x ()) 10;
  set_color black;
  let e = Graphics.mouse_pos () in
  let rec creates bods =
    match bods with
    | [] -> None
    | [ h ] -> if Gravity.create h = true then Some h else None
    | h :: t -> if Gravity.create h = true then Some h else creates t
  in
  let cs = creates (Gravity.bods system) in
  match Status.create_state status with
  | Location ->
      draw_string
        (Printf.sprintf "X Position : %n, Y Position : %n" (fst e)
           (snd e))
  | Delete ->
      draw_string
        (Printf.sprintf "X Position : %n, Y Position : %n" (fst e)
           (snd e))
  | Size -> (
      match cs with
      | None -> draw_string " "
      | Some b ->
          draw_string
            (Printf.sprintf "Radius : %f, Mass : %f" (Gravity.rad b)
               (Gravity.mass b)))
  | Velocity -> (
      let pyth x y = sqrt ((x ** 2.) +. (y ** 2.)) in
      match cs with
      | None -> draw_string " "
      | Some b ->
          draw_string
            (Printf.sprintf
               "X Velocity : %f, Y Velocity : %f, Total Velocity : %f"
               (Gravity.x_vel b) (Gravity.y_vel b)
               (pyth (Gravity.x_vel b) (Gravity.y_vel b))))

let rec draw_bodies clear = function
  | [] -> ()
  | h :: t -> (
      if clear then set_color background
      else set_color (Gravity.color h);
      match
        Camera.to_window Camera.default (Gravity.x_pos h)
          (Gravity.y_pos h)
      with
      | x, y ->
          fill_circle x y (int_of_float (Gravity.rad h));
          if clear then set_color background else set_color 000000;
          Graphics.draw_poly_line
            [|
              (x, y);
              ( int_of_float (Gravity.x_vel h) + x,
                int_of_float (Gravity.y_vel h) + y );
            |];
          draw_bodies clear t)

let clear_system system = draw_bodies true (Gravity.bods system)

let render (system : Gravity.system) (status : Status.t) =
  draw_bodies false (Gravity.bods system);
  draw_status status system;
  synchronize ();
  clear_system system

let poll (status : Status.t) (system : Gravity.system) =
  status |> Status.poll_input
  |> Status.update_body_num system
  |> Status.bind_mouse Pressed Status.new_cstate
  |> Status.bind_key ' ' Pressed Status.reset_cstate
  |> Status.bind_key 'k' Pressed (fun s ->
         Graphics.close_graph ();
         (try Visuals.start_window_from_create system
          with Sys_error str ->
            print_endline
              "\n~~Sorry, something broke. Please try again!\n");
         init ();
         s)
  |> Status.bind_key 'q' Pressed (fun _ ->
         raise @@ Graphics.Graphic_failure "Quit Window")
  |> Status.bind_key 'd' Pressed Status.cdelete
  |> Status.bind_key 'd' Released Status.reset_cstate

let seconds_per_frame : float = 1. /. 60.

let distance x1 y1 x2 y2 =
  let dx = x2 -. x1 in
  let dy = y2 -. y1 in
  sqrt ((dx *. dx) +. (dy *. dy))

let update_system system ostatus nstatus =
  let e = Graphics.mouse_pos () in
  let rec created bods =
    match bods with
    | [] -> []
    | [ h ] -> if Gravity.create h = true then [] else [ h ]
    | h :: t ->
        if Gravity.create h = true then created t else h :: created t
  in
  let rec creates bods =
    match bods with
    | [] -> None
    | [ h ] -> if Gravity.create h = true then Some h else None
    | h :: t -> if Gravity.create h = true then Some h else creates t
  in
  let cd = created (Gravity.bods system) in
  let cs = creates (Gravity.bods system) in
  if
    Status.create_state ostatus = Location
    && Status.create_state nstatus = Size
  then
    Gravity.make_s
      (Gravity.timestep system)
      (Gravity.g_const system)
      (Gravity.make_b
         (Gravity.make_p
            (float_of_int (fst e - (Graphics.size_x () / 2)))
            (float_of_int (snd e - (Graphics.size_y () / 2))))
         (Gravity.make_v 0.0 0.0)
         0.0 0xFF0000 true
      :: Gravity.bods system)
  else if Status.create_state ostatus = Size then
    Gravity.make_s
      (Gravity.timestep system)
      (Gravity.g_const system)
      (match cs with
      | None -> Gravity.bods system
      | Some b ->
          Gravity.make_b (Gravity.pos b)
            (Gravity.make_v 0.0 0.0)
            (distance (Gravity.x_pos b) (Gravity.y_pos b)
               (float_of_int (fst e - (Graphics.size_x () / 2)))
               (float_of_int (snd e - (Graphics.size_y () / 2)))
             ** 3.
            /. 10.)
            0xFF0000 true
          :: cd)
  else if Status.create_state ostatus = Velocity then
    Gravity.make_s
      (Gravity.timestep system)
      (Gravity.g_const system)
      (match cs with
      | None -> Gravity.bods system
      | Some b ->
          Gravity.make_b (Gravity.pos b)
            (Gravity.make_v
               (float_of_int (fst e - (Graphics.size_x () / 2))
               -. Gravity.x_pos b)
               (float_of_int (snd e - (Graphics.size_y () / 2))
               -. Gravity.y_pos b))
            (Gravity.mass b) 0xFF0000 true
          :: cd)
  else if Status.create_state nstatus = Location then
    Gravity.make_s
      (Gravity.timestep system)
      (Gravity.g_const system)
      (match cs with
      | None -> Gravity.bods system
      | Some b ->
          Gravity.make_b (Gravity.pos b) (Gravity.velocity b)
            (Gravity.mass b) 0xFF0000 false
          :: cd)
  else if Status.create_state nstatus = Delete then
    let rec nbods bods =
      match bods with
      | [] -> []
      | h :: t ->
          if
            distance
              (float_of_int (fst e - (Graphics.size_x () / 2)))
              (float_of_int (snd e - (Graphics.size_y () / 2)))
              (Gravity.x_pos h) (Gravity.y_pos h)
            <= Gravity.rad h
          then nbods t
          else h :: nbods t
    in
    Gravity.make_s
      (Gravity.timestep system)
      (Gravity.g_const system)
      (nbods (Gravity.bods system))
  else system

let rec create_loop
    (system : Gravity.system)
    (status : Status.t)
    (time : float) : unit =
  render system status;
  let new_status = poll status system in
  let new_system = update_system system status new_status in
  let new_time = Unix.gettimeofday () in
  let time_left = seconds_per_frame -. new_time +. time in
  if time_left > 0. then Unix.sleepf time_left;
  create_loop new_system new_status new_time

let start_window dt grav =
  let system = Gravity.make_s dt grav [] in
  try
    init ();
    create_loop system (Status.default ()) (Unix.gettimeofday ())
  with Graphics.Graphic_failure _ -> Graphics.close_graph ()

let start_window_from_json json =
  let system =
    "data/" ^ json ^ ".json"
    |> Yojson.Basic.from_file |> Gravity.from_json
  in
  try
    init ();
    create_loop system (Status.default ()) (Unix.gettimeofday ())
  with Graphics.Graphic_failure _ -> Graphics.close_graph ()
