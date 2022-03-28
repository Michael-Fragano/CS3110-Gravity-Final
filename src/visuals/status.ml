type input_state =
  | Idle
  | Pressed
  | Held
  | Released

type t = {
  mouse_state : input_state;
  space_state : input_state;
  camera_focus : Camera.focus;
  paused : bool;
  body_num : int;
}

let default () =
  {
    camera_focus = CenterOfMass;
    paused = false;
    mouse_state = Idle;
    space_state = Idle;
    body_num = 0;
  }

let update_input is_down = function
  | Idle -> if is_down () then Pressed else Idle
  | Pressed -> if is_down () then Held else Released
  | Held -> if is_down () then Held else Released
  | Released -> if is_down () then Pressed else Idle

let update_mouse = update_input Graphics.button_down

let update_space input =
  let new_space = ref false in
  let () =
    while Graphics.key_pressed () do
      if Graphics.read_key () = ' ' then new_space := true
    done
  in
  update_input (fun () -> !new_space) input

let poll_input (status : t) : t =
  {
    status with
    mouse_state = update_mouse status.mouse_state;
    space_state = update_space status.space_state;
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
