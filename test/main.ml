open OUnit2
open Gravity

let tst = Yojson.Basic.from_file "data/test_system.json"
let tsys = from_json tst
let b = bods tsys
let bod = List.hd b
let x = gx (grav_field tsys (bodies_ex b bod) bod)
let y = gy (grav_field tsys (bodies_ex b bod) bod)
let tsysfin = frame tsys 100
let bfin = bods tsysfin
let bodfin = List.hd bfin

let gravity_tests =
  print_endline "X before: ";
  print_float (x_pos bod);
  print_endline " ";
  print_endline "Y before: ";
  print_float (y_pos bod);
  print_endline " ";
  print_endline "X after: ";
  print_float (x_pos bodfin);
  print_endline " ";
  print_endline "Y after: ";
  print_float (y_pos bodfin);
  print_endline " ";
  [
    ("dt" >:: fun t -> assert_equal 0.01 (timestep tsys));
    ( "Gravitational Constant" >:: fun t ->
      assert_equal 0.05 (g_const tsys) );
    ( "Gravitational Field x component greater than" >:: fun t ->
      assert_equal true
        (gx (grav_field tsys (bodies_ex b bod) bod) > 0.079) );
    ( "Gravitational Field x component less than" >:: fun t ->
      assert_equal true
        (gx (grav_field tsys (bodies_ex b bod) bod) < 0.081) );
    ( "Gravitational Field y component" >:: fun t ->
      assert_equal ~-.0.06 (gy (grav_field tsys (bodies_ex b bod) bod))
    );
    ( "Move one frame" >:: fun t ->
      assert_equal 17.9999994 (y_pos (move tsys bod)) );
  ]

let suite =
  "Test suite for Gravity Sim" >::: List.flatten [ gravity_tests ]

let _ = run_test_tt_main suite
