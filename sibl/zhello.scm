(define-module (sibl zhello)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix build-system zig)
  #:use-module (guix licenses))

(define-public zhello
  (package
    (name "zhello")
    (version "0.5")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/4zv4l/zhello/archive/refs/tags/" version ".tar.gz"))
        (sha256 (base32 "1v6r0i1p067xsdqypvyl7g4jv1z4gwy64nbxjs3bgzxwjkmn12cv"))))
    (build-system zig-build-system)
    (synopsis "My first guix package using the Zig build system :)")
    (description "Simple hello world in C")
    (home-page "https://github.com/4zv4l/zhello")
    (license gpl3+)))
