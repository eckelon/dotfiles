;;; autocomplete-tools.el --- Modern completion ecosystem -*- lexical-binding: t -*-

;; --- Modern Ecosystem (Corfu, Vertico, etc.) ---

;; Corfu: In-buffer completion (Popups)
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-auto-delay 0.1)         ;; Show completions almost immediately (default 0.2)
  (corfu-auto-prefix 2)          ;; Show completions after 2 characters
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-quit-at-boundary 'separator) ;; Automatically quit at word boundary
  :init
  (global-corfu-mode))

;; Enable Corfu in the terminal (required for emacs -nw)
(use-package corfu-terminal
  :ensure t
  :init
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))

;; Vertico: Vertical interactive minibuffer
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; Orderless: Flexible search (type terms in any order)
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

;; Marginalia: Extra information in the minibuffer (docstrings, file info, etc.)
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Consult: Enhanced search and navigation commands
(use-package consult
  :ensure t
  :bind (;; Recommended replacements for standard commands
         ("C-s" . consult-line)          ;; Search in current buffer
         ("C-x b" . consult-buffer)      ;; Switch buffer with previews
         ("M-y" . consult-yank-pop)      ;; Kill-ring history
         ("M-g g" . consult-goto-line)   ;; Go to line
         ("M-s r" . consult-ripgrep)))   ;; Search in project (requires ripgrep)

;; Cape: Completion At Point Extensions (useful for combining completion sources)
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

;; Eglot integration with Corfu/Cape
(with-eval-after-load 'eglot
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (cape-capf-super
                                 #'eglot-completion-at-point
                                 #'cape-file))))))

(provide 'autocomplete-tools)
;;; autocomplete-tools.el ends here
