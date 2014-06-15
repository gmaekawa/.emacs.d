;; ------------------------------------------------------------------
;;
;; Packageを使うための設定
;;
;; ------------------------------------------------------------------
;;; 職場用プロキシ設定
;; 2014-02-07
;; (setq url-proxy-services 
;;       '(("http" . "proxygate2.nic.nec.co.jp:8080")
;; 	("https" . "proxygate2.nic.nec.co.jp:8080")))

(require 'package)
(setq package-user-dir "~/.emacs.d/elisp/elpa/")
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
