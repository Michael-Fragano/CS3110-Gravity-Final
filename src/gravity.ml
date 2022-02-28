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

let move b = raise (Failure "Unimplemented: Gravity.move")

let rec frame s : system =
  raise (Failure "Unimplemented: Gravity.frame")
