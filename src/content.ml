open Core
open Tyxml


let main_script =
  let open Html in
  script ~a:[a_src (Xml.uri_of_string "/static/main.js")] (txt "")


let main_header =
  let open Html in
  div ~a:[a_class ["header"]] [
    h1 [a ~a:[a_href ("/")] [txt "OCaml Notes App"]]
  ]


let layout body_ =
  let open Html in
  (html
    (head
      (title (txt "OCaml Notes App"))
      [ meta ~a:[a_charset "UTF-8"] ()
      ; link ~rel:[`Stylesheet] ~href:"/static/style.css" () ]
    )
    (body body_)
  )


let chop_content (s: string): string =
  if String.length s >= 57 then ((String.prefix s 57) ^ "...")
  else String.prefix s 60


let gen_note_div (n: Persistence.note) =
  let open Html in
  div ~a:[a_class ["note"]; a_id n.id] [
    p ~a:[a_class ["title"]] [
      a ~a:[a_href ("/notes/"^n.id)] [txt n.title];
      button ~a:[a_class ["delete_btn"]; a_onclick "delete_note(this);"] [txt "x"]
    ];
    p [ txt (chop_content n.content) ]
  ]


let all_notes_page (all_notes: Persistence.notes) =
  let note_divs = List.map all_notes ~f:gen_note_div in
  let open Html in
  let content_div =
    div ~a:[a_class ["content"]] ((button ~a:[a_onclick "create_note()"] [txt "Create Note"]) :: note_divs)
  in
  layout [main_script; main_header; content_div]


let gen_editing_div (n: Persistence.note) =
  let open Html in
  div ~a:[a_id n.id] [
    label ~a:[a_label_for "title_input"] [txt "Title"];
    input ~a:[a_input_type `Text; a_name "title_input"; a_id "title_input"; a_maxlength 40; a_value n.title] ();
    br (); br ();
    textarea ~a:[a_id "content_input"; a_cols 50; a_rows 20] (txt n.content);
    br (); br ();
    button ~a:[a_class ["save_btn"]; a_onclick "save_note(this);"] [txt "Save Note"]
  ]


let note_page (n: Persistence.note) =
  let editing_div = gen_editing_div n in
  let open Html in
  let content_div =
    div ~a:[a_class ["content"]] [ editing_div ]
  in
  layout [main_script; main_header; content_div]

let page_404 _ =
  let open Html in
  let content_div =
    div ~a:[a_class ["content"]] [ txt "Note does not exist" ]
  in
  layout [main_script; main_header; content_div]