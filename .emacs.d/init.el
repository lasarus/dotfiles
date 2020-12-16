;; Search paths

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(add-to-list 'load-path "~/.emacs.d/evil")
(add-to-list 'load-path "~/.emacs.d/misc")
(add-to-list 'load-path "~/.emacs.d/rainbow-delimiters")
;;(add-to-list 'load-path "~/.emacs.d/haskell-mode")

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
(evil-leader/set-key "k" 'jump-to-register)
(evil-leader/set-key "n" 'next-error)
(evil-leader/set-key "r" 'recompile)
(evil-leader/set-key "c" 'comment-region)
(evil-leader/set-leader "<SPC>")

;; Evil
(require 'evil)
(evil-mode 1)
(setq inhibit-startup-message t)

;; Keybinding for up
(global-set-key (kbd "C-u") 'evil-scroll-up)

;; Keychords
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map  "jk" 'evil-normal-state)

;; Disable useless shit
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;; Make escape able to replace C-g
;; Doesn't work for some reason
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; (lookup-key (current-global-map) (kbd "C-x r j"))
;; jump-to-register
;; window-configuration-to-register

;;  Scratch message
(defun get-scratch-message ()
  (shell-command-to-string "fortune | cowsay;date;acpi"))

(defun comment-string ()
  (mapconcat (lambda (arg) (concat ";; " arg))
	     (split-string (get-scratch-message) "\n") "\n"))

(setq initial-scratch-message (concat (comment-string) "\n"))

;; Font
;;(set-face-attribute 'default nil :font "terminus")

;; -- Languages
;; Haskell
;; (require 'haskell-mode-autoloads)
;; (add-hook 'haskell-mode-hook 'haskell-indentation-mode)

;; Theming
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/zenburn-emacs")
;; (load-theme 'zenburn t)

;; Backup fix
(setq backup-directory-alist `(("." . "~/.saves")))


;; Load .h files in c++ mode, should make it only temporary but I haven't bothered yet
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; TeX count
(defun latex-word-count ()
  (interactive)
  (let* ((this-file (buffer-file-name))
	 (word-count
	  (with-output-to-string
	    (with-current-buffer standard-output
	      (call-process "texcount" nil t nil "-brief" this-file)))))
    (string-match "\n$" word-count)
    (message (replace-match "" nil nil word-count))))
;;(define-key LaTeX-mode-map "\C-cw" 'latex-word-count))

;; run lisp and replace
 (defun replace-last-sexp ()
    (interactive)
    (let ((value (eval (preceding-sexp))))
      (kill-sexp -1)
      (insert (format "%S" value))))

;; Increment number at cursor
(defun increment-number-at-point ()
      (interactive)
      (skip-chars-backward "0-9")
      (or (looking-at "[0-9]+")
          (error "No number at point"))
      (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))
(global-set-key (kbd "C-c +") 'increment-number-at-point)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (irony))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Configuration for irony
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(setq-default c-basic-offset 4
	      tab-width 4
	      indent-tabs-mode t
	      c-default-style "linux")
