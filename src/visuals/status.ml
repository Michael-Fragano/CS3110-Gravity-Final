type t = { status : Graphics.status }

let default () = { status = Graphics.wait_next_event [ Poll ] }
