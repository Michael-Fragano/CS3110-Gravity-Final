type data = {
  max_length : int;
  min_period : int;
}

type frame = Segment.t list
(** A [frame] represents the segments of paths for a single point in
    time. There are no duplciates, as two bodies cannot be in the same
    point in space *)

type queue = frame Queue.t
(** A [queue] is a capped linked list of frames *)

type t = data * queue
(** A Paths.t is a tuple of a Path.queue and a data struct. the data
    contains constants to control how frames are used in the queue *)

let is_empty ((_, q) : t) : bool = Queue.is_empty q
let is_full ((data, q) : t) : bool = Queue.length q >= data.max_length

let remove_frame ((data, q) : t) : t =
  ignore @@ Queue.pop q;
  (data, q)

let add_frame frame ((data, q) : t) : t =
  Queue.push frame q;
  (data, q)

let create ?(max_length = 50) ?(min_period = 20) () : t =
  ({ max_length; min_period }, Queue.create ())

let update =
  let frame_counter = ref ~-1 in
  (* [frame_counter] keeps track of how many times [update] has been
     called*)
  fun system ((data, q) as paths) : t ->
    frame_counter := !frame_counter + 1;
    if !frame_counter < 0 then frame_counter := 0;
    if !frame_counter mod data.min_period <> 0 then paths
    else
      let bods = Gravity.bods system in
      let new_frame : frame =
        List.fold_left
          (fun acc b ->
            if !frame_counter mod data.min_period <> 0 then acc
            else
              Segment.new_circle (Gravity.x_pos b) (Gravity.y_pos b)
                (Gravity.rad b *. 0.1)
                (Gravity.color b) ()
              :: acc)
          [] bods
      in
      (if is_full paths then remove_frame paths else paths)
      |> add_frame new_frame

let rec draw_or_clear f (q : queue) = Queue.iter (List.iter f) q
let draw camera (_, q) = draw_or_clear (Segment.draw camera) q
let clear camera (_, q) = draw_or_clear (Segment.clear camera) q
