(package-initialize)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(add-to-list 'package-archives
             '("melpa"     . "http://melpa.milkbox.net/packages/"))

(load-library "ido")
(ido-mode t)
(setq ido-enable-prefix nil
        ido-enable-flex-matching t
        ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-max-prospects 10)

(load-theme 'zenburn t)

;; (global-set-key "\C-m" 'newline-and-indent)
;; (add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))

(scroll-bar-mode 0)
(setq initial-scratch-message "")
(setq inhibit-startup-message t)
(setq visible-bell t)
(tool-bar-mode 0)
(menu-bar-mode 0)

(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq c-basic-offset 2)
;; (setq c-default-style "java" c-basic-offset 2)
(global-set-key "\C-m" 'newline-and-indent)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(windmove-default-keybindings)
(define-key input-decode-map "\e[1;2A" [S-up])

(require 'smartparens-config)
(require 'rainbow-delimiters)

(smartparens-global-mode t)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;; (global-rainbow-delimiters-mode)
