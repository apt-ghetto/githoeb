;;; .init.el --- Summary  -*- coding: utf-8; lexical-binding: t; -*-

;;; Commentary:

;; Emacs configuration starting point of apt-ghetto, heavily inspired by others.
;; The main part of the configuration is in the ~/.emacs.d/config.org file.
(require 'org)

;;; Code:
(org-babel-load-file
 (expand-file-name "config.org"
		   user-emacs-directory))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes '(manoj-dark))
 '(doc-view-continuous t)
 '(erc-join-buffer 'window-noselect)
 '(erc-nick "apt-ghetto")
 '(erc-server "irc.libera.chat")
 '(global-display-line-numbers-mode 1)
 '(package-selected-packages
   '(clang-format nasm-mode yasnippet-snippets lsp-treemacs lsp-ivy lsp-ui lsp-mode company-ctags edit-server auctex company-auctex impatient-mode counsel-etags markdown-mode flycheck magit modern-cpp-font-lock elpy use-package))
 '(safe-local-variable-values '((TeX-close-quote . "\"'") (TeX-open-quote . "\"`"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
