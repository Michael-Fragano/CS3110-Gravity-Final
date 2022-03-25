type t = {
  input_status : Graphics.status;
  camera_focus : Camera.focus;
  paused : bool;
}

let default () =
  {
    input_status = Graphics.wait_next_event [ Poll ];
    camera_focus = Body 1;
    paused = false;
  }

let poll_input (status : t) : t =
  { status with input_status = Graphics.wait_next_event [ Poll ] }

let change_focus status focus = { status with camera_focus = focus }
let pause status = { status with paused = true }
let play status = { status with paused = false }
