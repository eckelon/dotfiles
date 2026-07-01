;; Set the Meta key to Option/Alt on macOS (GUI Emacs)
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super))

(setq display-line-numbers-type t)
(set-face-attribute 'default nil :height 180)

(setq insert-directory-program "ls")
(setq dired-listing-switches "-alh")
