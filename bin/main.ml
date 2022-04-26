let rec run_sim () =
  print_endline
    "What system do you want to simulate? Or type 'Q' to quit, type \
     'new' if you wish yo create your own system.";
  let file = read_line () in
  if file = "Q" then
    print_endline "Thanks for using the gravity simulator!"
  else if file = "new" then (
    print_endline "To be implemented";
    run_sim ())
  else
    try
      Visuals.start_window_preset file;
      run_sim ()
    with Sys_error str ->
      print_endline
        "\n\
         ~~Sorry, we couldn't find a preset system with that name. \
         Please try again!\n";
      run_sim ()
in

run_sim ()