open Opium
open Controller

let app: App.t =
  App.empty
  |> App.get "/hello/:name" hello_world
  |> App.put "/notes/:id" update_note_handler
  |> App.get "/notes" get_all_notes_handler
  |> App.get "/notes/:id" get_note_handler

let () =
  Persistence.check_table ();
  App.run_command app
