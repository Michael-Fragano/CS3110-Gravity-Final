
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

