(lang dune 2.7)
(generate_opam_files true)

(name notes_app)
(version 1.0)
(authors "Anderson Adon")
(maintainers "aadon1@jhu.edu")

(package
  (name notes_app)
  (synopsis "A note taking app")
  (description "A note taking app using a local server")
  (depends
    (dune (>= 2.7))
    (ocaml (>= 4.10.0))
    (core (>= v0.14.0))
    (opium (>= 0.20.0))
    (tyxml (>= 4.4.0))
    (ppx_deriving_yojson (>= 3.6.1))
    (sqlite3 (>= 5.0.2))


    (merlin :dev)
    (utop :dev)
    (ocp-indent :dev)
  )
)