open OUnit2
open Gravity

let tst = Yojson.Basic.from_file "data/test_system.json"

let gravity_tests =
  [
    ( "Gravitational Constant" >:: fun t ->
      assert_equal 0.035830 (g_const (from_json tst)) );
  ]

let suite =
  "test suite for Gravity Sim" >::: List.flatten [ gravity_tests ]

let _ = run_test_tt_main suite
