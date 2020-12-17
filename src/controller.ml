open Core
open Opium
open Tyxml.Html
open Persistence
open Content


let gen_html elem =
  (html
    (head
      (title
        (txt "Note app")
      )
      []
    )
    (body
      [ elem ])
  )


let get_note_handler req =
  let note_id = Router.param req "id" in
  let fetched_note = get_note note_id in
  let html_content = note_page fetched_note in
  Lwt.return (Response.of_html ~indent:true html_content)


let get_all_notes_handler _ =
  let all_notes = get_all_notes () in
  let html_content = all_notes_page all_notes in
  Lwt.return (Response.of_html ~indent:true html_content)


let delete_note_handler req =
  let note_id = Router.param req "id" in
  let deleted = delete_note note_id in
  let json_res =
    if deleted then (`Assoc [ "deleted", `Bool (true)])
    else (`Assoc [ "deleted", `Bool (false)])
  in
  Lwt.return (Response.of_json json_res)


let update_note_handler req =
  let note_id = Router.param req "id" in
  Response.of_json (`Assoc [ "message", `String ("Note "^note_id^" saved")])
  |> Lwt.return
