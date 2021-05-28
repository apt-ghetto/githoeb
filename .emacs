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
 '(column-number-mode t)
 '(custom-enabled-themes '(manoj-dark))
 '(doc-view-continuous nil)
 '(erc-nick "apt-ghetto")
 '(global-linum-mode t)
 '(package-selected-packages
   '(company-auctex flycheck-ycmd impatient-mode counsel-etags markdown-mode flycheck company-ycmd ycmd magit modern-cpp-font-lock elpy))
 '(safe-local-variable-values '((TeX-close-quote . "\"'") (TeX-open-quote . "\"`"))))

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

;; MELPA
(require 'package)
(setq package-archives
      '(("gnu"             . "https://elpa.gnu.org/packages/")
        ("melpa-stable"    . "https://stable.melpa.org/packages/")
        ("melpa"           . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("gnu"             . 10)
        ("melpa-stable"    . 5)
        ("melpa"           . 0)))

;;(add-to-list 'package-archives
;;             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; Perl Development Environment
(add-to-list 'load-path "~/.emacs.d/pde/lisp")
(load "pde-load")

;; Use-package
(eval-when-compile
  (require 'use-package))

;; Ivy
(use-package ivy
  :config
  (ivy-mode 1))

;; Elpy
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3"))

;; Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Für Markdown: M-x package-install RET impatient-mode RET
;; Starte webserver: M-x httpd-start
;; In Buffer mit Markdown: M-x impatient-mode
;; In Browser: localhost:8080/imp
;; In Buffer: M-x imp-set-user-filter RET markdown-html RET
(defun markdown-html (buffer)
  "Convert markdown to html.
Use BUFFER"
  (princ (with-current-buffer buffer
           (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://strapdownjs.com/v/0.2/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

;;
;; C++
;;
(require 'modern-cpp-font-lock)
(modern-c++-font-lock-global-mode t)
;;(require 'clang-format)
(global-set-key (kbd "C-c C-f") 'clang-format-region)
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
;;  ;;:init (add-hook 'c++-mode-hook #'ycmd-mode)
  :init (add-hook 'after-init-hook #'global-ycmd-mode)
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

;; Company mode auto-completion for AUCTeX
(use-package company-auctex
  :after (auctex company)
  :config (company-auctex-init))


;;; .emacs ends here
