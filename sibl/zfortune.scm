(define-module (zfortune)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system zig)
  #:use-module (guix licenses))

(define-public zfortune
  (package
    (name "zfortune")
    (version "0.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
	      (url "https://github.com/4zv4l/zfortune")
	      (commit "main")))
        (sha256 (base32 "19cbmy4azrw7lc3ckikl0vz8z0y9zzmkl8gyr04wblrzs21b138m"))))
    (build-system zig-build-system)
    (arguments '(#:tests? #f
                 #:zig-release-type "safe"))
    (synopsis "A basic fortune like program in Zig")
    (description "Zfortune is a very basic fortune like program, it just find a random <file>.dat from the env var FORTUNE_PATH and show a random fortune.")
    (home-page "https://github.com/4zv4l/zfortune")
    (license gpl3+)))
