open OUnit2
open Final.Gravity

(** test_system.json*)
let tst = Yojson.Basic.from_file "data/test_system.json"

let tsys = from_json tst
let b = bods tsys
let bod = List.hd b
let x = gx (grav_field tsys (bodies_ex b bod) bod)
let y = gy (grav_field tsys (bodies_ex b bod) bod)
let tsysfin = frame tsys 100
let bfin = bods tsysfin
let bodfin = List.hd bfin

(** binary.json*)

let bin = Yojson.Basic.from_file "data/binary.json"
let bsys = from_json bin
let bb = bods bsys
let bbod = List.hd bb
let tail = List.tl bb
let obod = List.hd tail
let bsysfin = frame bsys 15707
let bbfin = bods bsysfin
let bbodfin = List.hd bbfin
let tailfin = List.tl bbfin
let obodfin = List.hd tailfin

(** collision_test.json *)
let col = Yojson.Basic.from_file "data/collision_test.json"

let csys = from_json col
let blist = bods csys
let bod1 = List.hd blist
let tail1 = List.tl blist
let bod2 = List.hd tail1
let tail2 = List.tl tail1
let expect1 = List.hd tail2
let tail3 = List.tl tail2
let bod3 = List.hd tail3
let tail4 = List.tl tail3
let bod4 = List.hd tail4
let tail5 = List.tl tail4
let expect2 = List.hd tail5


let gravity_tests =
  [
    ("cube root" >:: fun t -> assert_equal 5.0 (cbrt 125.0));
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
    ( "Move one step y pos" >:: fun t ->
      assert_equal 17.9999994 (y_pos (move tsys bod)) );
    ( "X position check" >:: fun t ->
      assert_equal (x_pos expect1) (x_pos (collide bod1 bod2)) );
    ( "Y position check" >:: fun t ->
      assert_equal (y_pos expect1) (y_pos (collide bod1 bod2)) );
    ( "X velocity check" >:: fun t ->
      assert_equal (x_vel expect1) (x_vel (collide bod1 bod2)) );
    ( "Y velocity check" >:: fun t ->
      assert_equal (y_vel expect1) (y_vel (collide bod1 bod2)) );
    ( "Mass check" >:: fun t ->
      assert_equal (mass expect1) (mass (collide bod1 bod2)) );
    ( "Color check" >:: fun t ->
      assert_equal (color expect1) (color (collide bod1 bod2)) );
    ( "Radius check" >:: fun t ->
      assert_equal (cbrt 2000.0) (rad (collide bod1 bod2)) );
    ( "X position check" >:: fun t ->
      assert_equal (x_pos expect2) (x_pos (collide bod3 bod4)) );
    ( "Y position check" >:: fun t ->
      assert_equal (y_pos expect2) (y_pos (collide bod3 bod4)) );
    ( "X velocity check" >:: fun t ->
      assert_equal (x_vel expect2) (x_vel (collide bod3 bod4)) );
    ( "Y velocity check" >:: fun t ->
      assert_equal (y_vel expect2) (y_vel (collide bod3 bod4)) );
    ( "Mass check" >:: fun t ->
      assert_equal (mass expect2) (mass (collide bod3 bod4)) );
    ( "Color check" >:: fun t ->
      assert_equal (color expect2) (color (collide bod3 bod4)) );
    ( "Radius check" >:: fun t ->
      assert_equal (cbrt 1500.0) (rad (collide bod3 bod4)) );
  ]

let suite =
  "Test suite for Gravity Sim" >::: List.flatten [ gravity_tests ]

let _ = run_test_tt_main suite
