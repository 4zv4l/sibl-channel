(define-module (sibl wkhtmltopdf)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages image)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages xorg))

;; Arch Linux's wkhtmltopdf binary requires libjpeg.so.8 with LIBJPEG_8.0 symbol versioning.
;; Guix's default libjpeg-turbo package builds libjpeg.so.62.
;; We define a lightweight variant of libjpeg-turbo compiled with JPEG 8 ABI support.
(define libjpeg-v8
  (package
   (inherit libjpeg-turbo)
   (name "libjpeg-v8")
   (arguments
    '(#:configure-flags '("-DWITH_JPEG8=ON" "-DENABLE_STATIC=OFF")))))

(define-public wkhtmltopdf
  (package
   (name "wkhtmltopdf-bin")
   (version "0.12.6")
   (source (origin
            (method url-fetch)
            (uri "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-3/wkhtmltox-0.12.6-3.archlinux-x86_64.pkg.tar.xz") 
            (sha256 (base32 "0hkj652p9ssqxbwa9g7ycvx0v4b2a0crifrxbbcanvniqgr2wk78"))))
   (build-system copy-build-system)
   
   (native-inputs
    `(("patchelf" ,patchelf)))
   
   (inputs
    `(("fontconfig" ,fontconfig)
      ("freetype" ,freetype)
      ("gcc:lib" ,gcc "lib")
      ("glibc" ,glibc)
      ("libjpeg" ,libjpeg-v8)  ;; <-- Uses our custom JPEG 8 ABI build
      ("libpng" ,libpng)
      ("libx11" ,libx11)
      ("libxext" ,libxext)
      ("libxrender" ,libxrender)
      ("openssl" ,openssl-1.1)
      ("zlib" ,zlib)))
   
   (arguments
    `(#:install-plan
      '(("bin" "bin")
	("lib" "lib")
	("include" "include")
	("share" "share"))
      #:phases
      (modify-phases %standard-phases
		     (add-before 'install 'patch-elf
				 (lambda* (#:key inputs #:allow-other-keys)
				   (let* ((libc (assoc-ref inputs "glibc"))
					  (ld-so (string-append libc "/lib/ld-linux-x86-64.so.2"))
					  (rpath (string-join
						  (list (string-append (assoc-ref inputs "fontconfig") "/lib")
							(string-append (assoc-ref inputs "freetype") "/lib")
							(string-append (assoc-ref inputs "gcc:lib") "/lib")
							(string-append libc "/lib")
							(string-append (assoc-ref inputs "libjpeg") "/lib")
							(string-append (assoc-ref inputs "libpng") "/lib")
							(string-append (assoc-ref inputs "libx11") "/lib")
							(string-append (assoc-ref inputs "libxext") "/lib")
							(string-append (assoc-ref inputs "libxrender") "/lib")
							(string-append (assoc-ref inputs "openssl") "/lib")
							(string-append (assoc-ref inputs "zlib") "/lib")
							"$ORIGIN"
							"$ORIGIN/../lib")
						  ":")))

				     ;; Patch executables
				     (for-each (lambda (file)
						 (invoke "patchelf" "--set-interpreter" ld-so file)
						 (invoke "patchelf" "--set-rpath" rpath file))
					       '("bin/wkhtmltopdf" "bin/wkhtmltoimage"))
				     
				     ;; Patch shared library
				     (invoke "patchelf" "--set-rpath" rpath "lib/libwkhtmltox.so")
				     #t))))))
   
   (synopsis "Command line tools to render HTML into PDF (Binary)")
   (description "Pre-compiled binary for wkhtmltopdf 0.12.6 to satisfy Odoo requirements.")
   (home-page "https://wkhtmltopdf.org/")
   (license license:gpl3+)))
