open Opium

(* Handles requests for getting a single note *)
val get_note_handler : Request.t -> Response.t Lwt.t

(* Handles requests for getting all notes *)
val get_all_notes_handler : 'a -> Response.t Lwt.t

(* Handles requests for creating notes *)
val create_note_handler : Request.t -> Response.t Lwt.t

(* Handles requests for deleting notes *)
val delete_note_handler : Request.t -> Response.t Lwt.t

(* Handles requests for updating notes *)
val update_note_handler : Request.t -> Response.t Lwt.t
