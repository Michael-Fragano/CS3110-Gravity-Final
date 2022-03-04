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

type g_field = {
  x : float;
  y : float;
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

let make_g g : g_field =
  match g with
  | [ h; t ] -> { x = h; y = t }
  | _ -> raise (Failure "Does not contain two floats")

let g_const s = s.g

let bodies_ex s b =
  let bodies = s.bodies in
  List.filter b bodies

let x_dist a b = b.pos.x -. a.pos.x
let y_dist a b = b.pos.y -. a.pos.y

let dist a b =
  let x = x_dist a b in
  let y = y_dist a b in
  sqrt ((x *. x) +. (y *. y))

let grav_force g a b = g *. (a.mass *. b.mass /. dist a b)

let rec grav_field s (others : body list) (b : body) =
  let g = g_const s in
  match others with
  | [] -> make_g [ 0.0; 0.0 ]
  | [ h ] ->
      let grav = grav_force g b h in
      make_g
        [
          grav *. (y_dist b h /. dist b h);
          grav *. (x_dist b h /. dist b h);
        ]
  | h :: t ->
      let grav = grav_force g b h in
      let field = grav_field s t b in
      make_g
        [
          (grav *. (y_dist b h /. dist b h)) +. field.x;
          (grav *. (x_dist b h /. dist b h)) +. field.y;
        ]

let move b = raise (Failure "Unimplemented: Gravity.move")

let rec frame s : system =
  raise (Failure "Unimplemented: Gravity.frame")
