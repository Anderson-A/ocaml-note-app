open Core
open OUnit2
open Persistence


let test_get_notes_empty _ =
  drop_table ();
  check_table ();
  let res = get_note "1" in
  assert_equal
    ~cmp:Bool.equal
    true
    (Option.is_none res)
  ;;

let database_tests =
  "Database Tests" >: test_list [
    "Get Notes Empty" >:: test_get_notes_empty;
  ]


let series =
  "Notes App Tests" >::: [
    database_tests;
  ]

let () = run_test_tt_main series
