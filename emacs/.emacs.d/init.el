;; ~/.emacs.d/init.el

(setq user-emacs-directory (file-name-directory load-file-name))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-solo"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-solo/lisp"))

(load (expand-file-name "~/.emacs.d/emacs-solo/init.el"))
(load (expand-file-name "user.el" user-emacs-directory) t)

;; Show hidden files in Dired by overriding the emacs-solo default.
;; This uses the `dired-omit-files` variable as specified in its documentation.
(setq dired-omit-files "^$")
