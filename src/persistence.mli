(* A note to be stored and retrieved from the database *)
type note = { id: string; title: string; content: string}

(* A list of notes *)
type notes = note list

(* Checks if Notes table already exists, creates it if it doesn't *)
val check_table : unit -> unit

(* Drops Notes table *)
val drop_table : unit -> unit

(* Retrieves a single note from the store *)
val get_note : string -> note option

(* Retrive notes from the database *)
val get_all_notes : unit -> notes

(* Creates a new note and stores it. Returns a bool representing if the note was created, and its id *)
val create_note : string -> string -> bool * int

(* Deletes a note from the store. Returns a bool representing if the note could be deleted. *)
val delete_note : string -> bool

(* Updates a note. Returns a bool representing if the note could be updated. *)
val update_note : string -> string -> string -> bool
