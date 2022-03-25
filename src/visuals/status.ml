type input_state =
  | Idle
  | Pressed
  | Held
  | Released

type t = {
  mouse_state : input_state;
  camera_focus : Camera.focus;
  paused : bool;
}

let default () =
  { camera_focus = Origin; paused = false; mouse_state = Idle }

let update_mouse = function
  | Idle -> if Graphics.button_down () then Pressed else Idle
  | Pressed -> if Graphics.button_down () then Held else Released
  | Held -> if Graphics.button_down () then Held else Released
  | Released -> if Graphics.button_down () then Pressed else Idle

let poll_input (status : t) : t =
  { status with mouse_state = update_mouse status.mouse_state }

let change_focus status focus = { status with camera_focus = focus }
let pause status = { status with paused = true }
let play status = { status with paused = false }
let toggle_pause status = { status with paused = not status.paused }
