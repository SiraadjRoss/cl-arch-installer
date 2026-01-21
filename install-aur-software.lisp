#!/usr/bin/sbcl --script

;;;; Brave browser installer (conceptual, educational use only!)
(require :sb-posix)

(defpackage :brave-browser-install
  (:use :cl :sb-ext)
  (:import-from :sb-posix :chdir)
  (:export :main))
(in-package :brave-browser-install)


(defun run-command (cmd &key (output t) (error-output t))
  "Execute shell command. cmd is string"
  (let ((exit-code (sb-ext:process-exit-code
                    (sb-ext:run-program "/bin/sh"
                                        (list "-c" cmd)
                                        :output output
                                        :error error-output
                                        :wait t))))
    (unless (zerop exit-code)
      (error "Command failed: ~A (exit code ~A)" cmd exit-code))))

(defun run-user-command (cmd)
  (let ((preffix "su - siraadj -c"))
    (run-command (concatenate 'string preffix (format nil " ~s" cmd)))))

