(define-module (sibl zisp)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix build-system zig)
  #:use-module (guix licenses))

(define-public zisp
  (package
    (name "zisp")
    (version "0.1")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/4zv4l/zisp/archive/refs/tags/" version ".tar.gz"))
        (sha256 (base32 "16s62d72a8c0lkllzcy1dfpqkicb9bxr7p13b9i7069b3hqackfk"))))
    (build-system zig-build-system)
    (arguments '(#:zig "zig@0.14.0"
                 #:zig-release-type "safe"))
    (synopsis "A basic lisp interpreter in Zig")
    (description "Zisp is a very basic Lisp like language interpreter, made for learning purposes.
@itemsize
@ no memory handling (doesnt free any allocated memory)
@ basic tail call optimization (broken due to memory not being freed)
@ error message are only useful in Debug or Safe release
@end itemsize")
    (home-page "https://github.com/4zv4l/zisp")
    (license gpl3+)))
