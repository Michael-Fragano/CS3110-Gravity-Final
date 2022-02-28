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
let pos_json p : position = { x = hd p; y = tl p }
let vel_json v : velocity = { x = hd v; y = tl v }

let body_json j =
  {
    pos = pos_json (member "position" j);
    vel = vel_json (member "velocity" j);
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
