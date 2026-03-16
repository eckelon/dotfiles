;; ~/.emacs.d/init.el

(require 'package)
(package-initialize)

(setq user-emacs-directory (file-name-directory load-file-name))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-solo"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-solo/lisp"))

(load (expand-file-name "~/.emacs.d/emacs-solo/init.el"))

;; Load custom Lisp directories
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'autocomplete-tools)

(load (expand-file-name "user.el" user-emacs-directory) t)

;; Show hidden files in Dired by overriding the emacs-solo default.
;; This uses the `dired-omit-files` variable as specified in its documentation.
(setq dired-omit-files "^$")
(use-package markdown-ts-mode
  :vc (:url "https://github.com/LionyxML/markdown-ts-mode" :rev :newest)
  :mode ("\\.md\\'" . markdown-ts-mode)
  :defer t
  :config
  (add-to-list 'treesit-language-source-alist '(markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src"))
  (add-to-list 'treesit-language-source-alist '(markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))
