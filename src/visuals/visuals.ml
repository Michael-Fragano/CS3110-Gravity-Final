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

let rec draw_bodies color = function
  | [] -> ()
  | h :: t ->
      set_color color;
      fill_circle
        ((h |> Gravity.x_pos |> Float.floor |> int_of_float)
        + (size_x () / 2))
        ((h |> Gravity.y_pos |> Float.floor |> int_of_float)
        + (size_y () / 2))
        10;
      draw_bodies color t

let clear_system system = draw_bodies background (Gravity.bods system)

let render system status =
  draw_bodies cyan (Gravity.bods system);
  synchronize ();
  clear_system system

let fps : float = 60.

let update system : Gravity.system =
  Gravity.frame system
    (int_of_float (1. /. Gravity.timestep system /. fps))

let get_status () = wait_next_event [ Poll ]

let rec main_loop system status : unit =
  render system status;
  main_loop (update system) status
(*get_status ()*)

let start_window () =
  init ();
  draw_coords (wait_next_event [ Mouse_motion ])

let start_window_preset json =
  let system =
    "data/" ^ json ^ ".json"
    |> Yojson.Basic.from_file |> Gravity.from_json
  in
  init ();
  main_loop system (get_status ())