type input_state =
  | Idle
  | Pressed
  | Held
  | Released
  | Unmonitored

type t = {
  mouse_state : input_state;
  key_states : (char * input_state) list;
  camera_focus : Camera.focus;
  paused : bool;
  body_num : int;
  speed : float;
  show_paths : bool;
  paths : Path.CirclePath.t;
}

let default () =
  {
    mouse_state = Idle;
    key_states = [ (' ', Idle); (',', Idle); ('.', Idle) ];
    (* we can add any number of other keys here ^ *)
    camera_focus = Origin;
    paused = false;
    body_num = 0;
    speed = 1.;
    show_paths = false;
    paths = Path.CirclePath.empty;
  }

let update_input is_down = function
  | Idle -> if is_down then Pressed else Idle
  | Pressed -> if is_down then Held else Released
  | Held -> if is_down then Held else Released
  | Released | Unmonitored -> if is_down then Pressed else Idle

let update_mouse state = update_input (Graphics.button_down ()) state

let keys_down () =
  let keys = ref [] in
  let _ =
    while Graphics.key_pressed () do
      match Graphics.read_key () with
      | c -> keys := c :: !keys
    done
  in
  !keys

let poll_input (status : t) : t =
  let keys = keys_down () in
  {
    status with
    mouse_state = update_mouse status.mouse_state;
    key_states =
      List.map
        (fun (key, state) ->
          (key, update_input (List.mem key keys) state))
        status.key_states;
  }

let change_focus status focus = { status with camera_focus = focus }

let cycle_focus status =
  match status.camera_focus with
  | Origin -> change_focus status (Body 0)
  | Body n ->
      if n + 1 < status.body_num then change_focus status (Body (n + 1))
      else change_focus status CenterOfMass
  | CenterOfMass -> change_focus status Origin
  | Free -> change_focus status Origin

let pause status = { status with paused = true }
let play status = { status with paused = false }
let toggle_pause status = { status with paused = not status.paused }

let update_speed f status =
  if f = true then { status with speed = status.speed *. 2. }
  else { status with speed = status.speed /. 2. }

let update_body_num system status =
  let new_num = List.length (Gravity.bods system) in
  {
    status with
    body_num = new_num;
    camera_focus =
      (match status.camera_focus with
      | Body n -> if n >= new_num then Body 0 else Body n
      | f -> f);
  }

let mouse_state status = status.mouse_state

let key_state c status =
  match List.assoc_opt c status.key_states with
  | Some state -> state
  | None -> Unmonitored

let camera_focus status = status.camera_focus
let is_paused status = status.paused
let speed status = status.speed