open Yojson.Basic.Util

type position = {
  x : float;
  y : float;
}

type velocity = {
  x : float;
  y : float;
}

type body = {
  pos : position;
  vel : velocity;
  mass : float;
}

type system = {
  g : float;
  bodies : body list;
}

(*helper functions for from_json*)
let pos_json p : position =
  match p with
  | [ h; t ] -> { x = to_float h; y = to_float t }
  | _ -> raise (Failure "Does not contain two floats")

let vel_json v : velocity =
  match v with
  | [ h; t ] -> { x = to_float h; y = to_float t }
  | _ -> raise (Failure "Does not contain two floats")

let body_json j =
  {
    pos = pos_json (to_list (member "position" j));
    vel = vel_json (to_list (member "velocity" j));
    mass = to_float (member "mass" j);
  }

let from_json json =
  {
    g = to_float (member "g" json);
    bodies = List.map body_json (to_list (member "bodies" json));
  }

let g_const s = s.g
let bodies_ex s a = raise (Failure "Unimplemented: Gravity.bodies_ex")
let dist_sq a b = raise (Failure "Unimplemented: Gravity.dist_sq")
let grav_field s b = raise (Failure "Unimplemented: Gravity.grav_field")
let move b = raise (Failure "Unimplemented: Gravity.move")

let rec frame s : system =
  raise (Failure "Unimplemented: Gravity.frame")
