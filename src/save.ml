open Yojson.Basic
open Gravity

let rec save system =
  print_endline
    "What do you want to save the system as? NOTE: Cannot be named \
     'new', or 'edit'. If a file already exists with the chosen name, \
     it WILL be overwritten. Enter 'Q' to cancel saving.";
  let sys_name = read_line () in
  if sys_name = "new" || sys_name = "edit" then (
    print_endline "The system can't be named that!\n";
    save system)
  else if sys_name = "Q" then ()
  else if String.trim sys_name = "" then (
    print_endline "You need to put actual text to save it!\n";
    save system)
  else
    try
      Yojson.Basic.to_file
        ("data/" ^ String.trim sys_name ^ ".json")
        (Gravity.to_json system);
      print_endline ("Saved file as " ^ String.trim sys_name ^ ".json")
    with Failure str ->
      print_endline "The system can't be named that!\n\n";
      save system
