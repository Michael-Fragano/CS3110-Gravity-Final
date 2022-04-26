type create_state =
  | Location
  | Size
  | Velocity

let poll (status : Status.t) (system : Gravity.system) : Status.t =
  ( status |> Status.poll_input |> Status.update_body_num system
  |> fun s ->
    if s.mouse_state = Pressed then Status.toggle_pause s else s )
  |> fun s ->
  if s.space_state = Pressed then Status.cycle_focus s else s
