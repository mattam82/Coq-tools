;; Customization for Proof General
;;
;; C-c C-f toggles [Printing All]
;; 
;; Modifying set-*-coq* to your liking and the set-coqtop function as well
;; will set up the correct environment for each coq version, built from source with -local
;; It sets PATH, COQBIN, TAGS, coq-prog-args/name with the .coqrc, the toplevel module name
;; if in "theories/Init", and correct emacs flags.
;; The compilation command is also set to "make -k" with the toplevel Coq Makefile
;; Use set-make-coqbyte to build bytecode coq instead, set-make-timed to get timing 
;; info on each .v
;;
;;
;; Coq Debugging
;; Requires a "dev/myinclude" file with at least a [#use "include";;] in it.
;; Debugging mode: C-c C-d opens the *coq* buffer where traces appear
;; Interactive coq-trace to trace a specific function, coq-untrace to stop tracing it
;;
;;
;;(load-file "~/research/coq/contribs/coqfingroups/ssreflect/ssreflect1.3_v8.4/pg-ssr.el")

(setq
 coq-utf-safe t
 coq-x-symbol-enable nil
 proof-shell-unicode t
 proof-electric-terminator-enable t
 proof-three-window-enable t)

(defvar coqrc-path "/Users/mat/")
(defvar coq-root "/Volumes/Dev/coq/")

(defun coq-cmd (cmd)
  (save-current-buffer
    (set-buffer "*coq*")
    (goto-char (point-max))
    (insert (concat cmd "\n"))
    (comint-send-input)))

(defun toggle-explicit ()
  (interactive)
  (progn (coq-print-fully-explicit-toggle (not coq-print-fully-explicit))))

(defun coq-debug-mode ()
  (interactive)
  (progn (split-window-vertically) 
	 (other-window 1)
	 (switch-to-buffer "*coq*")
	 (other-window 3)))

(defun coq-keybindings ()
  (interactive)
  (local-set-key "\C-c\C-f" 'toggle-explicit)
  (local-set-key "\C-c\C-d" 'coq-debug-mode))

(add-hook 'coq-mode-hook 'coq-keybindings)

(setq 
 coq-user-tactics-db
 '(("funelim" "funelim" "funelim" t "funelim")
   ("simp" "simp" "simp" t "simp")))

(defun find-makefile ()
  (interactive)
  (if (file-exists-p "Makefile")
      ""
    (if (file-exists-p "../Makefile")
	"-C .."
      (if (file-exists-p "../../Makefile")
	  "-C ../.."
	""))))

(defun set-make-coqbyte ()
  (interactive)
  (progn
    (setq arg (find-makefile))
    (set (make-local-variable 'compile-command)
	 (setq compile-command (concat "make " arg " bin/coqtop.byte TIMECMD=\"/usr/bin/time\"")))))

(defun set-make ()
  (interactive)
  (progn
    (setq arg (find-makefile))
    (set (make-local-variable 'compile-command)
	 (setq compile-command (concat "make " arg)))))

(defun set-make-timed ()
  (interactive)
  (progn
    (setq arg (find-makefile))
    (set (make-local-variable 'compile-command)
	 (setq compile-command (concat "make " arg " TIMECMD=\"/usr/bin/time\"")))))

(defun set-coqenv (path byteoropt coqrc)
  (progn
    (set (make-local-variable 'coq-prog-name)
	 (setq coq-prog-name (concat path "bin/" (if byteoropt "coqtop.byte" "coqtop"))))
    (let ((args (cons "-emacs" 
		      (cons "-init-file" 
			    (cons (concat coqrc-path coqrc) 
				  (if (string-match ".*theories/Init.*" buffer-file-name)
				      (cons "-nois" (cons "-coqlib" (cons path nil)))
				    nil))))))
      (progn
	(set (make-local-variable 'coq-prog-args)
	     (setq coq-prog-args args))
	(setenv "COQBIN" (concat path "bin/"))
	(setenv "PATH" (concat path "bin/:" (getenv "PATH")))
	(set-variable 'tags-file-name (concat path "TAGS"))))))

(defun set-coqbyte ()
  (interactive)
  (set-coqenv (concat coq-root "git/") t ".coqrc"))

(defun set-coqopt ()
  (interactive)
  (set-coqenv (concat coq-root "git/") nil ".coqrc"))

(defun set-8.2-coqbyte ()
  (interactive)
  (set-coqenv (concat coq-root "v8.2/") t ".coqrc-8.2"))

(defun set-8.2-coqopt ()
  (interactive)
  (set-coqenv (concat coq-root "v8.2/") nil ".coqrc-8.2"))

(defun set-8.3-coqbyte ()
  (interactive)
  (set-coqenv (concat coq-root "v8.3/") t ".coqrc-8.3"))

(defun set-8.3-coqopt ()
  (interactive)
  (set-coqenv (concat coq-root "v8.3/") nil ".coqrc-8.3"))

(defun set-pi-coqbyte ()
  (interactive)
  (set-coqenv (concat coq-root "pi/") t ".coqrc-pi"))

(defun set-pi-coqopt ()
  (interactive)
  (set-coqenv (concat coq-root "pi/") nil ".coqrc-pi"))

(defun set-hott-coqbyte ()
  (interactive)
  (set-coqenv "/Volumes/Dev/HoTT/coq/" t ".coqrc-HoTT"))

(defun set-hott-coqopt ()
  (interactive)
  (set-coqenv "/Volumes/Dev/HoTT/coq/" nil ".coqrc-HoTT"))

(defun set-8.4-coqbyte ()
  (interactive)
  (set-coqenv (concat coq-root "v8.4/") t ".coqrc-8.4"))

(defun set-8.4-coqopt ()
  (interactive)
  (set-coqenv (concat coq-root "v8.4/") nil ".coqrc-8.4"))

(defun set-git-coqbyte ()
  (interactive)
  (set-coqenv (concat coq-root "git/") t ".coqrc-git")
  (set-make-coqbyte))

(defun set-git-coqopt ()
  (interactive)
  (set-coqenv (concat coq-root "git/") nil ".coqrc-git"))

(defun set-trunk-coqbyte ()
  (interactive)
  (set-coqenv (concat coq-root "trunk/") t ".coqrc"))

(defun set-trunk-coqopt ()
  (interactive)
  (set-coqenv (concat coq-root "trunk/") nil ".coqrc"))

(defun set-ssr-coqbyte ()
  (interactive)
  (set-coqenv "/Volumes/Free/contribs/Saclay/Ssreflect/" t ".coqrc-ssr"))

(defun set-ssr-coqopt ()
  (interactive)
  (set-coqenv "/Volumes/Free/contribs/Saclay/Ssreflect/" nil ".coqrc-ssr"))

(defun set-coqtop ()
  (interactive)
  (progn
    (set (make-local-variable 'coq-prog-args)
	 (setq coq-prog-args nil))
    (if (string-match ".*coq/equations.*" buffer-file-name)
	(set-coqbyte)
    (if (string-match ".*coq/SFI.*" buffer-file-name)
	(set-8.3-coqopt)
      (if (string-match ".*coq/trunk.*" buffer-file-name)
	  (set-trunk-coqbyte)
	(if (string-match ".*coq/v8.3.*" buffer-file-name)
	    (set-8.3-coqbyte)
	  (if (string-match ".*coq/v8.4.*" buffer-file-name)
	      (set-8.4-coqbyte)
	  (if (string-match ".*coq/git/.*" buffer-file-name)
	      (set-git-coqbyte)
	  (if (string-match ".*coq/pi/.*" buffer-file-name)
	      (set-pi-coqbyte)
	    (if (string-match ".*Ssreflect.*" buffer-file-name)
		(set-ssr-coqopt) ;; "-R . Ssreflect"
	      (set-coqbyte)
	      ))))))))))

(add-hook 'coq-mode-hook 'set-coqtop)
(add-hook 'coq-mode-hook 'set-make)
(add-hook 'tuareg-mode-hook 'set-make)

(defvar coq-debug-loaded nil
  "If the debug environment was already loaded")

(defun coq-debug-initialize ()
  (interactive)
  (setq coq-debug-loaded nil))

(add-hook 'proof-activate-scripting-hook 'coq-debug-initialize)

(defun coq-debug-cmd (cmd)
  (save-current-buffer
    (set-buffer "*coq*")
    (goto-char (point-max))
    (insert "Drop.\n")
    (if (not coq-debug-loaded)
	(progn (insert "#use \"myinclude\";;\n")
	       (setq coq-debug-loaded t)))
    (insert (concat cmd "\n"))
    (insert "go();;\n\n")
    (scomint-send-input)))

(defun coq-trace ()
  (interactive)
  (let ((trace (read-string "function to trace: " "")))
    (coq-debug-cmd (concat "#trace " trace ";;"))))

(defun coq-untrace ()
  (interactive)
  (let ((trace (read-string "function to trace: " "")))
    (coq-debug-cmd (concat "#untrace " trace ";;"))))

(add-hook 'coq-mode-hook
  (lambda ()
    (setq coq-debug-loaded nil)))
