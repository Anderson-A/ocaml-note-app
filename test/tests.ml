open Core
open OUnit2
open Persistence


let test_server_and_db _ =
  (* Start with a clean table *)
  drop_table ();
  check_table ();
  check_table ();

  (* Getting a note that doesn't exist *)
  let res1 = get_note "1" in
  assert_equal
    ~cmp:Bool.equal
    true
    (Option.is_none res1);

  (* Retrieving notes from an empty table *)
  let res2 = get_all_notes () in
  assert_equal
    ~cmp:Bool.equal
    true
    (List.is_empty res2);

  (* Deleting a note that doesn't exist *)
  let res3 = delete_note "1" in
  assert_equal
    ~cmp:Bool.equal
    false
    (res3);

  (* Updating a note that doesn't exist *)
  let res4 = update_note "1" "title" "content" in
  assert_equal
    ~cmp:Bool.equal
    false
    (res4);

  (* Creating a note *)
  let res5, note_id1 = create_note "title" "content" in
  assert_equal
    ~cmp:Bool.equal
    true
    res5;

  let note_id1 = Int.to_string note_id1 in

  (* Get a note *)
  let res6 = get_note note_id1 in
  let res6 = Option.value_exn res6 in
  assert_equal
    ~cmp:String.equal
    note_id1
    res6.id;
  assert_equal
    ~cmp:String.equal
    "title"
    res6.title;
  assert_equal
    ~cmp:String.equal
    "content"
    res6.content;

  (* Creating a second note *)
  let res7, note_id2 = create_note "OCaml" "Program" in
  assert_equal
    ~cmp:Bool.equal
    true
    res7;

  let note_id2 = Int.to_string note_id2 in

  (* Getting all notes *)
  let res8 = get_all_notes () in
  assert_equal 2 (List.length res8);

  (* Get a note *)
  let res9 = get_note note_id2 in
  let res9 = Option.value_exn res9 in
  assert_equal
    ~cmp:String.equal
    note_id2
    res9.id;
  assert_equal
    ~cmp:String.equal
    "OCaml"
    res9.title;
  assert_equal
    ~cmp:String.equal
    "Program"
    res9.content;

  (* Update Note *)
  let res10 = update_note note_id2 "Functional" "Programming" in
  assert_equal
    ~cmp:Bool.equal
    true
    res10;

  (* Get updated note *)
  let res11 = get_note note_id2 in
  let res11 = Option.value_exn res11 in
  assert_equal
    ~cmp:String.equal
    note_id2
    res11.id;
  assert_equal
    ~cmp:String.equal
    "Functional"
    res11.title;
  assert_equal
    ~cmp:String.equal
    "Programming"
    res11.content;

  (* Delete note *)
  let res12 = delete_note note_id2 in
  assert_equal
    ~cmp:Bool.equal
    true
    res12;

  (* Get all notes, there should only be one *)
  let res13 = get_all_notes () in
  assert_equal 1 (List.length res13)
  ;;

let database_tests =
  "Database Tests" >: test_list [
    "Database Tests" >:: test_server_and_db;
  ]


let series =
  "Notes App Tests" >::: [
    database_tests;
  ]

let () = run_test_tt_main series
