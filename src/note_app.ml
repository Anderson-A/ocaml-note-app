open Opium
open Controller


let static =
  Middleware.static_unix
    ~local_path:"./static"
    ~uri_prefix:"/static"
    ()


let app: App.t =
  App.empty
  |> App.middleware static
  |> App.get "/hello/:name" hello_world
  |> App.delete "/notes/:id" delete_note_handler
  |> App.put "/notes/:id" update_note_handler
  |> App.get "/" get_all_notes_handler
  |> App.get "/notes/:id" get_note_handler


let () =
  Persistence.check_table ();
  print_endline "Running at http://localhost:3000/";
  App.run_command app
