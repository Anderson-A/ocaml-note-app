open Opium
open Persistence
open Content


let get_note_handler req =
  let note_id = Router.param req "id" in
  let fetched_note = get_note note_id in
  let html_content = note_page fetched_note in
  Lwt.return (Response.of_html ~indent:true html_content)


let get_all_notes_handler _ =
  let all_notes = get_all_notes () in
  let html_content = all_notes_page all_notes in
  Lwt.return (Response.of_html ~indent:true html_content)


let create_note_handler req =
  let note_title = Request.query_exn "title" req in
  let note_content = Request.query_exn "content" req in
  let created, row_id = create_note note_title note_content in
  let json_res =
    if created then (`Assoc [ ("created", `Bool (true)); ("id", `Int row_id)])
    else (`Assoc [ ("updated", `Bool (false)); ("id", `Int row_id)])
  in
  Lwt.return (Response.of_json json_res)


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
  let note_title = Request.query_exn "title" req in
  let note_content = Request.query_exn "content" req in
  let updated = update_note note_id note_title note_content in
  let json_res =
    if updated then (`Assoc [ "updated", `Bool (true)])
    else (`Assoc [ "updated", `Bool (false)])
  in
  Lwt.return (Response.of_json json_res)
