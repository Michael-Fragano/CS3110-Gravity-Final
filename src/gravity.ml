open Yojson.Basic.Util

type position = {
  x : float;
  y: float;
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
  g: float;
  bodies: body list;
}



let from_json json =
 {
   
 }
  
let move b =
  raise (Failure "Unimplemented: Gravity.move")



let rec frame s : system = 
  raise (Failure "Unimplemented: Gravity.frame")
