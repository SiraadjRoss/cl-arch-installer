#!/usr/bin/sbcl --script

;;;; AUR software installer (conceptual, educational use only!)

(defpackage :aur-software-installer
  (:use :cl :sb-ext)
  (:export :install))
(in-package :aur-software-installer)

(defvar *software-list* '(("brave-bin" . "https://aur.archlinux.org/brave-bin.git")
			 ("google-chrome" . "https://aur.archlinux.org/google-chrome.git")))

(defun run-shell-command (cmd &key (output t) (error-output t))
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
    (run-shell-command (concatenate 'string preffix (format nil " ~s" cmd)))))

(defun install (lst)
  (run-shell-command "sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/  %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers")
  (dolist (soft lst)
    (format t ">>> Starting ~A installer (SBCL script)...~%" (car soft))
    (run-user-command (format nil "cd /home/siraadj && git clone ~A" (cdr soft)))
    (run-user-command (format nil "cd /home/siraadj/~A && makepkg -si --noconfirm" (car soft)))
    (format t "[ DONE ] ~A installed!~%" (car soft)))
  (run-shell-command "sed -i 's/  %wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers"))

;;; Run if executed as script
(install)

