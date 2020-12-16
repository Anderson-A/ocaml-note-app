open Core
open Tyxml


let main_script =
  let open Html in
  script ~a:[a_src (Xml.uri_of_string "/static/main.js")] (txt "")


let main_header =
  let open Html in
  div ~a:[a_class ["header"]] [
    h1 [txt "OCaml Notes App"]
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
  div ~a:[a_class ["note"]; a_id (Int.to_string n.id); a_onclick "open_note(this);"] [
    p ~a:[a_class ["title"]] [txt (n.title)];
    p [txt (chop_content n.content)]
  ]


let all_notes_page (all_notes: Persistence.notes) =
  let note_divs = List.map all_notes ~f:gen_note_div in
  let open Html in
  let content_div =
    div ~a:[a_class ["content"]] ((button [txt "Create Note"]) :: note_divs)
  in
  layout [main_script; main_header; content_div]
