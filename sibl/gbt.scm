(define-module (sibl gbt)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system go)
  #:use-module (guix licenses))

(define-public gbt
  (package
    (name "gbt")
    (version "0.1.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/4zv4l/gbt")
                    (commit "v0.1.0")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0z3p6flbjginh48f61fs5ilabp7ab6aa8w7a9q598zlmv6fnd4h6"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/4zv4l/gbt/cmd/gbt"
       #:unpack-path "github.com/4zv4l/gbt"))
    (home-page "https://github.com/4zv4l/gbt")
    (synopsis "GBT - Golang BitTorrent")
    (description "A Simple BitTorrent client made in Go for learning.")
    (license #f)))
