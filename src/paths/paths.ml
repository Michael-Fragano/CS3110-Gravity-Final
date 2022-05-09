type data = {
  max_length : int;
  min_period : int;
}

type frame = Segment.t list
type queue = frame list
type t = data * queue

let empty_queue = []
let is_empty (_, q) = q = empty_queue

let is_full (data, q) =
  let rec full_aux acc q =
    if acc = data.max_length then true
    else
      match q with
      | [] -> false
      | h :: t -> full_aux (acc + 1) t
  in
  full_aux 0 q

let pop (data, q) =
  match q with
  | [] -> (data, [])
  | h :: t -> (data, t)

let push frame (data, q) =
  let rec push_aux = function
    | [] -> [ frame ]
    | h :: t -> h :: push_aux t
  in
  (data, push_aux q)

let create ?(max_length = 50) ?(min_period = 20) () : t =
  ({ max_length; min_period }, [])

let update =
  let frame_counter = ref ~-1 in
  (* [frame_counter] keeps track of how many times [update] has been
     called*)
  fun system ((data, q) as paths) : t ->
    frame_counter := !frame_counter + 1;
    if !frame_counter < 0 then frame_counter := 0;
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
    if !frame_counter mod data.min_period <> 0 then paths
    else (if is_full paths then pop paths else paths) |> push new_frame

let rec draw_or_clear f camera (q : queue) =
  match q with
  | [] -> ()
  | [] :: queue_tail -> draw_or_clear f camera queue_tail
  | (seg :: frame_tail) :: queue_tail ->
      f camera seg;
      draw_or_clear f camera (frame_tail :: queue_tail)

let draw camera (_, q) = draw_or_clear Segment.draw camera q
let clear camera (_, q) = draw_or_clear Segment.clear camera q
