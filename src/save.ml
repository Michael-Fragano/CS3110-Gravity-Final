open Yojson.Basic
open Gravity

let rec save system =
  print_endline
    "What do you want to save the system as? NOTE: Cannot be named \
     'Q', 'new', or 'edit'. If a file already exists with the chosen \
     name, it WILL be overwritten.";
  let sys_name = read_line () in
  if sys_name = "Q" || sys_name = "new" || sys_name = "edit" then (
    print_endline "The system can't be named that!";
    save system)
  else if String.trim sys_name = "" then (
    print_endline "You need to put actual text to save it!";
    save system)
  else
    Yojson.Basic.to_file
      ("data/" ^ sys_name ^ ".json")
      (Gravity.to_json system);
  print_endline ("Saved file as " ^ sys_name ^ ".json")
