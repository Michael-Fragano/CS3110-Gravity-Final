let rec run_sim () =
  print_endline
    "What system do you want to simulate? Or type 'Q' to quit.";
  let file = read_line () in
  if file = "Q" then
    print_endline "Thanks for using the gravity simulator!"
  else
    try Visuals.start_window_preset file
    with Graphics.Graphic_failure "fatal I/O error" ->
      Graphics.close_graph ();
      run_sim ()
in
run_sim ()