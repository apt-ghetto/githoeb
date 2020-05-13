;;; .emacs --- Summary

;; -*- coding: utf-8; lexical-binding: t -*

;;; Commentary:

;; Emacs configuration of apt-ghetto

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (manoj-dark)))
 '(erc-nick "apt-ghetto")
 '(global-linum-mode t)
 '(column-number-mode 1)
 '(package-selected-packages
   (quote
    (counsel-etags flycheck-ycmd flycheck company-ycmd ycmd magit modern-cpp-font-lock elpy))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Increment Garbage collection during initialisation
(setq gc-cons-threshold 64000000)
(add-hook 'after-init-hook #'(lambda ()
                               ;; restore after startup
                               (setq gc-cons-threshold 800000)))

;; Perl Development Environment
(add-to-list 'load-path "~/.emacs.d/pde/lisp")
(load "pde-load")

;; Use-package
(eval-when-compile
  (require 'use-package))


;; Elpy and Magit
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3"))

;;
;; C++
;;
(require 'modern-cpp-font-lock)
(modern-c++-font-lock-global-mode t)
(require 'clang-format)
(global-set-key (kbd "C-c C-f") 'clang-format-region)
(use-package swiper)
(use-package ivy
  :config
  (ivy-mode 1))
;; counsel-etags
(use-package counsel-etags)

;; Snippets
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :init (yas-global-mode t))

;; On-the-fly syntax checking
(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :init (global-flycheck-mode t)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

;; Autocomplete
(use-package company
  :commands (global-company-mode company-mode)
  :diminish company-mode
  :bind (:map company-active-map
              ("M-j" . company-select-next)
              ("M-k" . company-select-previous))
  :custom
  ;; no delay no autocomplete
  (company-idle-delay 0)
  (company-minimum-prefix-length 2)
  (company-tooltip-limit 20)
  
  :preface
  ;; enable yasnippet everywhere
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or
         (not company-mode/enable-yas)
         (and (listp backend) (member 'company-yasnippet backend)))
        backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))

  :init (global-company-mode t)
  :config
)

;; Code-comprehensive server
(use-package ycmd
  :commands ycmd-mode
  :init (add-hook 'c++-mode-hook #'ycmd-mode)
  :config
  (set-variable 'ycmd-server-command '("python3" "/home/gerry/ycmd/ycmd/"))
  (set-variable 'ycmd-global-config (expand-file-name "~/.ycm_extra_conf.py"))
  (set-variable 'ycmd-extra-conf-whitelist '("~/.ycm_extra_conf.py")))

(use-package flycheck-ycmd
  :after (ycmd flycheck)
  :commands (flycheck-ycmd-setup)
  :init (add-hook 'ycmd-mode-hook 'flycheck-ycmd-setup))

(use-package company-ycmd
  :after(ycmd company)
  :commands (company-ycmd-setup)
  :config (add-to-list 'company-backends (company-mode/backend-with-yas 'company-ycmd)))

;; Show argument list in echo area
(use-package eldoc
  :diminish eldoc-mode
  :init (add-hook 'ycmd-mode-hook 'ycmd-eldoc-setup))


;;; .emacs ends here
