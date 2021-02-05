;;; exwm-config.el --- Predefined configurations  -*- lexical-binding: t -*-

;; Copyright (C) 2015-2020 Free Software Foundation, Inc.

;; Author: Chris Feng <chris.w.feng@gmail.com>

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This module contains typical (yet minimal) configurations of EXWM.

;;; Code:

(setq mouse-autoselect-window t
	  focus-follows-mouse t)

(require 'exwm)
;; (require 'ido)

(define-obsolete-function-alias 'exwm-config-default
  #'exwm-config-example "27.1")

(defun exwm-config-example ()
  "Default configuration of EXWM."
  ;; Set the initial workspace number.
  (unless (get 'exwm-workspace-number 'saved-value)
	(setq exwm-workspace-number 4))
  ;; Make class name the buffer name
  (add-hook 'exwm-update-class-hook
			(lambda ()
			  (exwm-workspace-rename-buffer exwm-class-name)))
  ;; Global keybindings.
  (unless (get 'exwm-input-global-keys 'saved-value)
	(setq exwm-input-global-keys
		  `(
			;; 's-r': Reset (to line-mode).
			([?\s-r] . exwm-reset)

			([?\s-k] . (lambda ()
						 (interactive)
						 (other-window 1)
						 ))
			([?\s-j] . (lambda ()
						 (interactive)
						 (other-window -1)
						 ))
			([?\s-h] . (lambda ()
						 (interactive)
						 (enlarge-window-horizontally 4)
						 ))
			([?\s-l] . (lambda ()
						 (interactive)
						 (shrink-window-horizontally 4)
						 ))
			([?\s-Q] . save-buffers-kill-terminal)
			([?\s-C] . kill-buffer-and-window)
			([?\s-s] . (lambda ()
						 (interactive)
						 (shell-command "setxkbmap se")
						 ))
			([?\s-u] . (lambda ()
						 (interactive)
						 (shell-command "setxkbmap us")
						 ))
			;; 's-w': Switch workspace.
			([?\s-w] . exwm-workspace-switch)
			;; 's-p': Launch application.
			(,(kbd "<s-S-return>") . (lambda ()
						 (interactive)
						 (start-process-shell-command "urxvt" nil "urxvt")))
								
			([?\s-p] . (lambda (command)
						 (interactive (list (read-shell-command "$ ")))
						 (start-process-shell-command command nil command)))
			;; 's-N': Switch to certain workspace.
			;; ,@(mapcar (lambda (i)
			;; 			`(,(kbd (format "s-%d" i)) .
			;; 			  (lambda ()
			;; 				(interactive)
			;; 				(exwm-workspace-switch-create ,i))))
			;; 		  (number-sequence 0 9))
			)))
  ;; Line-editing shortcuts
  (unless (get 'exwm-input-simulation-keys 'saved-value)
	(setq exwm-input-simulation-keys
		  '(([?\C-b] . [left])
			([?\C-f] . [right])
			([?\C-p] . [up])
			([?\C-n] . [down])
			([?\C-a] . [home])
			([?\C-e] . [end])
			([?\M-v] . [prior])
			([?\C-v] . [next])
			([?\C-d] . [delete])
			([?\C-k] . [S-end delete]))))
  ;; Enable EXWM
  (exwm-enable)
  ;; Other configurations
  (display-time-mode 1)
  )
;; (exwm-config-misc))


(provide 'exwm-config)

;;; exwm-config.el ends here
