# OCaml Final Project

### Overview and Functionality

For my project, I will be creating a small note taking application that runs on
a local server. The user would run my project executable, which would start a
local server that the user could go to in the browser. My project would serve
the user the HTML pages, which allow the user to browse and edit their notes.
The notes will be saved locally in a file directory. 

Right now I have implemented a basic, working server that returns some basic
HTML pages. It can be compiled and run if you remove the note_app.mli file.

### Libraries

* Opium - A web micro-framework for creating a server. I will use this to create
the backend for my project.
* Tyxml - A library for building html using combinators. I will use this to
generate the HTML pages to serve.
* Yojson - JSON parser. The notes will be stored locally as JSON files. I will use
this library for reading and writing them.

### Mock Use

1. The user would start the application by running the executable, using
`dune exec src/note_app.exe`.
2. The user would open `localhost:3000` in their browser. This would take them to
the homepage.
3. From here, the user clicks on a link to `/notes`. Here, the user is shown all
of their notes. On the backend, I would have to read all of the users notes from
the filesystem and send it in HTML for the frontend.
4. The user can click on any of their notes or create a new note. They will be
taken to a page where they can edit/write a note. Once the user is done, they
will click save, and a request will be made to the backend to save the note and
its contents.

### Order of features

First, I will develop the backend that serves some basic HTML pages. Then, I will
implement the ability to display notes from a specific directory, basically
creating a simple file viewer on a web server. Lastly, I will implement the editing
and saving of notes. If I have enough time, I will store the notes in a database
like Postgres rather than storing them locally.

### Setup

Download the code and place it in a new folder. Within this folder, create an opam switch:

```bash
opam switch create . 4.10.0 --deps-only
```

Verify you're now working in this sandbox:

```bash
opam switch
```

Install dune on the switch:

```bash
opam install dune
```

Finally, install the project dependencies:

```bash
dune build @install
opam install . --deps-only
```

If you get an error saying some packages couldn't be installed due to a missing system
dependency from `libev-dev`, install it and try again:

```bash
sudo apt install libev-dev
opam install . --deps-only
```

To run the app, build and execute it and then go to `localhost:3000`

```bash
dune build
dune exec ./src/note_app.exe
```
