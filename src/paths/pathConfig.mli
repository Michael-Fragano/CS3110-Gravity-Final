type shape =
  | Circle
  | Square

module type Config = sig
  val max_length : int
  val size : int
  val shape : shape
end

val make :
  ?max_length:int ->
  ?size:int ->
  ?shape:shape ->
  unit ->
  (module Config)
