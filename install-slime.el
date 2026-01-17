;; Installing and setting SLIME by package.el
;; Init the package system
(require 'package)

;; Add the repository MELPA
(add-to-list 'package-archives '("melpa"."https://melpa.org/packages/") t)

;; Init package system
(package-initialize)

;; Check for update
(unless package-archive-contents
  (package-refresh-contents))

;; Install the SLIME if it is not installing
(unless (package-installed-p 'slime)
  (package-install 'slime))

;; Load the SLIME
(require 'slime)

;; Point to the LISP realisation
(setq inferior-lisp-programm "sbcl")

(message "SLIME installed and setted sucsessfull for SBCL!")
