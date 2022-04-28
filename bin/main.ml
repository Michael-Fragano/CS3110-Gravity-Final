let rec create () =
  print_endline
    "How many seconds do you want per step of the simulation?";
  let dt_str = read_line () in
  if dt_str = "Q" then print_endline " "
  else
    try
      let dt = float_of_string dt_str in
      print_endline "What do you want the gravitational constant to be?";
      let grav_str = read_line () in
      if grav_str = "Q" then print_endline " "
      else
        try
          let grav = float_of_string grav_str in
          Final.Visuals.Create.start_window dt grav
        with Failure str ->
          print_endline
            "Sorry, the gravitatinoal constant needs to be a float! \
             Please try again!\n";
          create ()
    with Failure str ->
      print_endline
        "Sorry, the time per step has to be a float! Please try again! \n";
      create ()
in

let rec run_sim () =
  print_endline
    "What system do you want to simulate? Or type 'Q' to quit, type \
     'new' if you wish to create your own system.";
  let file = read_line () in
  if file = "Q" then
    print_endline "Thanks for using the gravity simulator!"
  else if file = "new" then (
    try
      create ();
      run_sim ()
    with Sys_error str ->
      print_endline "\n~~Sorry, something broke. Please try again!\n";
      run_sim ())
  else
    try
      Final.Visuals.start_window_preset file;
      run_sim ()
    with Sys_error str ->
      print_endline
        "\n\
         ~~Sorry, we couldn't find a preset system with that name. \
         Please try again!\n";
      run_sim ()
in

run_sim ()
