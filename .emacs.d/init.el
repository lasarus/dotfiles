;; Search paths
(add-to-list 'load-path "~/.emacs.d/evil")
(add-to-list 'load-path "~/.emacs.d/misc")
(add-to-list 'load-path "~/.emacs.d/rainbow-delimiters")
(add-to-list 'load-path "~/.emacs.d/haskell-mode")

;; Rainbow delimiters
(require 'rainbow-delimiters)
(add-hook 'c-mode-hook #'rainbow-delimiters-mode)
(add-hook 'c++-mode-hook #'rainbow-delimiters-mode)

;; Leader, must come before evil
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-key "e" 'find-file)
(evil-leader/set-key "b" 'switch-to-buffer)
(evil-leader/set-key "s" 'save-buffer)
(evil-leader/set-key "q" 'save-buffers-kill-terminal)
(evil-leader/set-leader "<SPC>")

;; Evil
(require 'evil)
(evil-mode 1)
(setq inhibit-startup-message t)

;; Keychords
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map  "jk" 'evil-normal-state)

;; Disable useless shit
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;; Make escape able to replace C-g
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; (lookup-key (current-global-map) (kbd "C-u"))
;; minibuffer-keyboard-quit

(defun put-the-date ()
  (shell-command-to-string "fortune | cowsay;date"))

(defun comment-string ()
  (mapconcat (lambda (arg) (concat ";; " arg))
	     (split-string (put-the-date) "\n") "\n"))

(setq initial-scratch-message (concat (comment-string) "\n"))

;; -- Languages
;; Haskell
(require 'haskell-mode-autoloads)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)