;;; .init.el --- Summary -*- coding: utf-8; lexical-binding: t; -*-

;;; Commentary:

;; Emacs configuration starting point of apt-ghetto, heavily inspired by others.
;; The main part of the configuration is in the ~/.emacs.d/config.org file.
(require 'org)

;;; Code:
(org-babel-load-file
 (expand-file-name "config.org"
		   user-emacs-directory))

(provide 'init)
;;; init.el ends here
