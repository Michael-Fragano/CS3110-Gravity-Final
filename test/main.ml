open OUnit2
open Gravity

let tst = Yojson.Basic.from_file "data/test_system.json"
let tsys = from_json tst
let b = bods tsys
let x = gx (grav_field tsys (bodies_ex b (List.hd b)) (List.hd b))
let y = gy (grav_field tsys (bodies_ex b (List.hd b)) (List.hd b))

let gravity_tests =
  print_float x;
  print_float y;
  [
    ( "Gravitational Constant" >:: fun t ->
      assert_equal 0.05 (g_const tsys) );
    ( "Gravitational Field x component" >:: fun t ->
      assert_equal 0.08
        (gx (grav_field tsys (bodies_ex b (List.hd b)) (List.hd b))) );
    ( "Gravitational Field y component" >:: fun t ->
      assert_equal ~-.0.06
        (gy (grav_field tsys (bodies_ex b (List.hd b)) (List.hd b))) );
  ]

let suite =
  "Test suite for Gravity Sim" >::: List.flatten [ gravity_tests ]

let _ = run_test_tt_main suite
