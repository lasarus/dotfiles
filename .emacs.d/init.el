;; Search paths

;; (require 'exwm)
;; (require 'exwm-config)
;; (exwm-config-default)

(setq gc-cons-threshold 800000000)

(add-to-list 'load-path "~/.emacs.d/exwm")
(add-to-list 'load-path "~/.emacs.d/xelb")
;; (add-to-list 'load-path "~/.emacs.d")


(when (getenv "EXWM")
  (require 'exwm)
  ;;(require 'exwm-config)
  (load-file "~/.emacs.d/init-exwm.el")
  (exwm-config-default))
  ;;(exwm-init))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Rainbow delimiters
(require 'rainbow-delimiters)
(add-hook 'c-mode-hook #'rainbow-delimiters-mode)
(add-hook 'c++-mode-hook #'rainbow-delimiters-mode)

;; Leader, must come before evil
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-key "e" 'find-file
  "b" 'switch-to-buffer
  "s" 'save-buffer
  "q" 'save-buffers-kill-terminal
  "k" 'jump-to-register
  "n" 'next-error
  "r" 'recompile
  "c" 'comment-region
  "d" 'xref-find-definitions)
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
(fringe-mode 0)

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

;; Backup fix
(setq backup-directory-alist `(("." . "~/.saves")))


;; Load .h files in c++ mode, should make it only temporary but I haven't bothered yet
;; (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-mode))

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
 '(package-selected-packages
   '(pdf-tools exwm-mff exwm cmake-mode rmsbolt org-download company-lsp ccls lsp-mode haskell-mode irony))
 '(warning-suppress-types '((comp))))
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

;; LSP config
(put 'upcase-region 'disabled nil)
(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
(setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)

(setq lsp-enable-on-type-formatting nil)
(setq-local indent-region-function nil) 
(setq lsp-enable-indentation nil)

(eval-after-load 'org
  '(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0)))

(load-theme 'zenburn t)
(setq org-startup-with-inline-images t)

(defun screenshot-insert ()
  (interactive)
  (let ((name (concat "image_" (md5 (mapconcat 'number-to-string (current-time) "")) ".png")))
	(shell-command (concat "scrot -s " name))
	(insert (concat "[[./" name "]]"))
	(org-display-inline-images t t)
			))

(evil-leader/set-key-for-mode 'org-mode
  "w" 'screenshot-insert
  "l" 'org-latex-preview
  "i" 'org-toggle-inline-images)

(add-hook 'prog-mode-hook
		  (lambda ()
			'display-line-numbers-mode
			(setq display-line-numbers 'relative)))


(add-hook 'prog-mode-hook
		  (lambda ()
			'display-line-numbers-mode
			(setq display-line-numbers 'relative)))

;; rmsbolt things.
(setq rmsbolt-asm-format "att")
; (add-hook 'c-mode-hook
		  ; (lambda ()
			; (setq rmsbolt-command "gcc -O3")
			; ))

(defun toggle-rmsbolt ()
  (interactive)
  (if (and (boundp 'rmsbolt-mode) rmsbolt-mode)
	  (rmsbolt-mode -1)
	(progn
	  (rmsbolt-mode)
	  (rmsbolt-compile))))
	
(evil-leader/set-key-for-mode 'c-mode
  "g" 'toggle-rmsbolt
  )

(evil-leader/set-key-for-mode 'c++-mode
  "g" 'toggle-rmsbolt
  )

(setq evil-leader/in-all-states t)


;; (member 'rmsbolt-mode 'test)

(global-set-key (kbd "C-x n")
				(lambda ()
				  (interactive)
				  (enlarge-window-horizontally 4)))

;; Compilation colors
(require 'xterm-color)
(setq compilation-environment '("TERM=xterm-256color"))
(defun my/advice-compilation-filter (f proc string)
  (funcall f proc (xterm-color-filter string)))
(advice-add 'compilation-filter :around #'my/advice-compilation-filter)
