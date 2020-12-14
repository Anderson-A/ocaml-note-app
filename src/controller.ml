open Core
open Opium
open Tyxml.Html


type note = { id: int; title: string; content: string; path: string} [@@deriving yojson]


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


let get_all_notes_handler _ =
  let notes = ["Class notes"; "Shopping list"; "Journal"] in
  let content = gen_html
    (div
      (List.map notes ~f:(fun x -> div [txt x]))
    )
  in
  Lwt.return (Response.of_html ~indent:true content)


let get_note_handler req =
  let note_id = Router.param req "id" in
  let content = gen_html
    (div [txt ("This is note "^note_id)])
  in
  Lwt.return (Response.of_html ~indent:true content)


let update_note_handler req =
  let note_id = Router.param req "id" in
  Response.of_json (`Assoc [ "message", `String ("Note "^note_id^" saved")])
  |> Lwt.return


let hello_world req =
  let name = Router.param req "name" in
  let content = gen_html
    (h1 [ txt ("Hello, "^name) ])
  in
  Lwt.return (Response.of_html content)


let run_server _ =
  App.empty
  |> App.get "/hello/:name" hello_world
  |> App.put "/notes/:id" update_note_handler
  |> App.get "/notes" get_all_notes_handler
  |> App.get "/notes/:id" get_note_handler
  |> App.run_command
