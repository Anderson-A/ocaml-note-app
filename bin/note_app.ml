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
  |> App.get "/notes/:id" get_note_handler
  |> App.get "/" get_all_notes_handler
  |> App.post "/" create_note_handler
  |> App.delete "/notes/:id" delete_note_handler
  |> App.put "/notes/:id" update_note_handler


let () =
  Persistence.check_table ();
  print_endline "Running at http://localhost:3000/";
  match App.run_command' app with
  | `Ok (app : unit Lwt.t ) -> Lwt_main.run app
  | `Error                  -> exit 1
  | `Not_running            -> exit 0

