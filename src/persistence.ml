open Core

[@@@coverage off]
type note = { id: string; title: string; content: string } [@@deriving yojson]

type notes = note list [@@deriving yojson]
[@@@coverage on]


let (notes_db: Sqlite3.db) = Sqlite3.db_open "notes.db"


let exit_with_error (error: Sqlite3.Rc.t) (msg: string): unit =
  print_endline (Sqlite3.Rc.to_string error);
  print_endline (Sqlite3.errmsg notes_db);
  print_endline msg;
  let _ = Sqlite3.db_close notes_db in
  print_endline "Exiting";
  exit 1 [@@coverage off]


let create_notes_table (): unit =
  let create_table_sql = "CREATE TABLE Notes ( \
             NoteId INTEGER PRIMARY KEY, \
             Title TEXT NOT NULL, \
             Content TEXT NOT NULL \
             );"
  in
  match Sqlite3.exec notes_db create_table_sql with
  | Sqlite3.Rc.OK -> ()
  | r ->
    let msg = "Unable to create table Notes." in
    exit_with_error r msg


let check_table_cb (r: Sqlite3.row): unit =
  match r.(0) with
  | Some a ->
    if String.equal a "0" then
    begin
      print_endline "Creating Notes table";
      create_notes_table ()
    end
    else print_endline "Notes table already exists"
  | None -> ()


let check_table () =
  let check_table_sql = "SELECT COUNT(name) FROM sqlite_master WHERE type='table' AND name='Notes';" in
  match Sqlite3.exec_no_headers notes_db ~cb:check_table_cb check_table_sql with
  | Sqlite3.Rc.OK -> ()
  | r ->
    let msg = "Unable to check if the table Notes exists." in
    exit_with_error r msg


let drop_table () =
  let drop_table_sql = "DROP TABLE IF EXISTS Notes;" in
  match Sqlite3.exec notes_db drop_table_sql with
  | Sqlite3.Rc.OK -> ()
  | r ->
    let msg = "Unable to drop table Notes." in
    exit_with_error r msg


let gather_notes (l: notes) (data: Sqlite3.Data.t array): notes =
  let id = Sqlite3.Data.to_string_coerce data.(0) in
  let title = Sqlite3.Data.to_string_coerce data.(1) in
  let content = Sqlite3.Data.to_string_coerce data.(2) in
  let curr = {id=id; title=title; content=content} in
  l @ [curr]


let get_note (id: string): note option =
  let select_query = Sqlite3.prepare
    notes_db
    (Printf.sprintf "SELECT * FROM Notes WHERE NoteId=%s;" id)
  in
  let _, queried = Sqlite3.fold select_query ~f:gather_notes ~init:[] in
  List.hd queried


let get_all_notes (): notes =
  let select_query = Sqlite3.prepare notes_db "SELECT * FROM Notes;" in
  let _, queried = Sqlite3.fold select_query ~f:gather_notes ~init:[] in
  queried


let create_note (title: string) (content: string): bool * int =
  let insert_query = Printf.sprintf
    "INSERT INTO Notes (Title, Content) VALUES('%s', '%s');"
    title
    content
  in
  match Sqlite3.exec notes_db insert_query with
  | Sqlite3.Rc.OK ->
    print_endline "Inserted note";
    (true, Int64.to_int_exn (Sqlite3.last_insert_rowid notes_db))
  | r ->
    print_endline (Sqlite3.Rc.to_string r) [@coverage off];
    print_endline (Sqlite3.errmsg notes_db) [@coverage off];
    (false, -1) [@coverage off]


let delete_note (id: string): bool =
  let delete_query = Printf.sprintf "DELETE FROM Notes WHERE NoteId=%s;" id in
  match Sqlite3.exec notes_db delete_query with
  | Sqlite3.Rc.OK ->
    if Sqlite3.changes notes_db = 0 then (
      print_endline ("Note with id "^id^" does not exist");
      false
    ) else (
      print_endline ("Deleted note with id "^id);
      true
    )
  | r ->
    print_endline (Sqlite3.Rc.to_string r) [@coverage off];
    print_endline (Sqlite3.errmsg notes_db) [@coverage off]; 
    false [@coverage off]


let update_note (id: string) (title: string) (content: string): bool =
  let update_query = Printf.sprintf
    "UPDATE Notes SET Title='%s', Content='%s' WHERE NoteId=%s;"
    title
    content
    id
  in
  match Sqlite3.exec notes_db update_query with
  | Sqlite3.Rc.OK ->
    if Sqlite3.changes notes_db = 0 then (
      print_endline ("Note with id "^id^" does not exist");
      false
    ) else (
      print_endline ("Updated note with id "^id);
      true
    )
  | r ->
    print_endline (Sqlite3.Rc.to_string r) [@coverage off];
    print_endline (Sqlite3.errmsg notes_db) [@coverage off];
    false [@coverage off]
