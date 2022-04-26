type shape =
  | Circle
  | Square

module type Config = sig
  val max_length : int
  val size : int
  val shape : shape
end

let make ?(max_length = 10) ?(size = 10) ?(shape = Circle) () :
    (module Config) =
  (module struct
    let max_length = max_length
    let size = size
    let shape = shape
  end)
