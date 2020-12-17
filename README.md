# OCaml Final Project

### Overview

This is a small note taking application that runs on a local server. When the
executable is run, a local server is started that you can visit in the browser.
From there, you can create, edit, delete, and view notes. The notes are saved in
a local sqlite database.

### External Libraries

* Opium - A web micro-framework for creating a server. I will use this to create
the backend for my project.
* Tyxml - A library for building html using combinators. I will use this to
generate the HTML pages to serve.
* Sqlite3 - Sqlite database used for storing and retrieving the notes.

### Setup

Before beginning, install sqlite3:

```bash
sudo apt install sqlite3
```

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
dependency from `libev-dev` or from `libsqlite3-dev`, install them and try again:

```bash
sudo apt install libev-dev libsqlite3-dev
opam install . --deps-only
```

If you'd like to be able to run the tests, then do:

```bash
opam install . --deps-only --with-test
```

To run the app, build and execute it and then go to `localhost:3000`

```bash
dune build
dune exec ./bin/note_app.exe
```

### Known Issues

* Due to difficulties trying to parse an request made to my server using JSON, I
had to use query parameters sent over the url instead. This means that notes
cannot contain the following characters: & $ + , / : ; = ? @ #.
* Due to the way my sql queries are formatted, notes cannot contain apostrophes
('). This would have to be solved by sanitizing the queries or using an object
relation mapper such as the one provided by the `orm` library.
* I am not sure exactly why, but newlines are not properly processed in a notes
contents. This is either because of how I make requests to my backend containing
the contents or is because text in sqlite cannot contain newlines.
