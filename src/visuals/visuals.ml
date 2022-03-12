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

let render system status =
  let rec render_bodies = function
    | [] -> ()
    | h :: t ->
        set_color cyan;
        fill_circle
          (((h |> Gravity.x_pos |> Float.floor |> int_of_float) * 5)
          + (size_x () / 2))
          (((h |> Gravity.y_pos |> Float.floor |> int_of_float) * 5)
          + (size_y () / 2))
          10;
        render_bodies t
  in
  clear_graph ();
  render_bodies (Gravity.bods system);
  synchronize ()

let update system : Gravity.system = Gravity.frame system 1
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