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
  dt : float;
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
    dt = to_float (member "dt" json);
    g = to_float (member "g" json);
    bodies = List.map body_json (to_list (member "bodies" json));
  }

let make_g h v : g_field = { x = h; y = v }
let make_v h v : velocity = { x = h; y = v }
let make_b p v m : body = { pos = p; vel = v; mass = m }
let make_p h v : position = { x = h; y = v }

(**Helper Functions:*)

let timestep s = s.dt
let g_const s = s.g
let bods s = s.bodies

let rec bodies_ex bds (b : body) =
  match bds with
  | h :: t -> if h = b then t else bodies_ex t b
  | _ -> raise (Failure "Does not contain selected body")

let x_dist a b = b.pos.x -. a.pos.x
let y_dist a b = b.pos.y -. a.pos.y

let dist a b =
  let x = x_dist a b in
  let y = y_dist a b in
  sqrt ((x *. x) +. (y *. y))

let grav_force g a b = g *. (a.mass *. b.mass /. (dist a b *. dist a b))
let gx g = g.x
let gy g = g.y
let acc f m = f /. m
let x_pos b = b.pos.x
let y_pos b = b.pos.y

(**Main Functions:*)

let rec grav_field s (others : body list) (b : body) =
  let g = g_const s in
  match others with
  | [] -> make_g 0.0 0.0
  | [ h ] ->
      let grav = grav_force g b h in
      make_g
        (grav *. (x_dist b h /. dist b h))
        (grav *. (y_dist b h /. dist b h))
  | h :: t ->
      let grav = grav_force g b h in
      let field = grav_field s t b in
      make_g
        ((grav *. (x_dist b h /. dist b h)) +. field.x)
        ((grav *. (y_dist b h /. dist b h)) +. field.y)

let new_v b g t =
  make_v
    (b.vel.x +. (t *. acc g.x b.mass))
    (b.vel.y +. (t *. acc g.y b.mass))

let move s b =
  let v = new_v b (grav_field s (bodies_ex s.bodies b) b) s.dt in
  make_b
    (make_p (b.pos.x +. (v.x *. s.dt)) (b.pos.y +. (v.y *. s.dt)))
    v b.mass

let rec frame s : system =
  raise (Failure "Unimplemented: Gravity.frame")
