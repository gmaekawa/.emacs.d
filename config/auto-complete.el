;; ac-helm

;; (require 'ac-helm) ;; Not necessary if using ELPA package
;; (global-set-key (kbd "C-:") 'ac-complete-with-helm)
;; (define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)

;; auto-complete

(require 'auto-complete)
;; (require 'auto-complete-config)    ; 必須ではないですが一応
;; (global-auto-complete-mode t)

;; ------------------------------------
;;; sasaki yohei .emacs

;; 読み込みと初期設定

(require 'auto-complete-config nil 'noerror)
(add-to-list 'ac-dictionary-directories
             (concat my:user-emacs-share-directory "ac-dict"))
(setq ac-comphist-file
      (concat my:user-emacs-temporary-directory "ac-comphist.dat"))
(ac-config-default)
(ac-flyspell-workaround)


;; 全てのモードで補完を有効に

(global-auto-complete-mode t)
;; 追加メジャーモード
(add-to-list 'ac-modes 'org-mode 'html-mode)

;; 起動/キー設定など

(setq ac-auto-start 2)                         ; 4 文字以上で起動
(setq ac-auto-show-menu 0.8)                   ; 0.8秒でメニュー表示
(setq ac-use-comphist t)                       ; 補完候補をソート
(setq ac-candidate-limit nil)                  ; 補完候補表示を無制限に
(setq ac-use-quick-help nil)                   ; tool tip 無し
(setq ac-use-menu-map t)                       ; キーバインド
(define-key ac-menu-map (kbd "C-n")         'ac-next)
(define-key ac-menu-map (kbd "C-p")         'ac-previous)
(define-key ac-completing-map (kbd "<tab>") 'nil)
;; (define-key ac-completing-map (kbd "<tab>") 'ac-complete)
(define-key ac-completing-map (kbd "M-/")   'ac-stop)
(define-key ac-completing-map (kbd "RET") nil) ; return での補完禁止
(setf (symbol-function 'yas-active-keys)
      (lambda ()
        (remove-duplicates
         (mapcan #'yas--table-all-keys (yas--get-snippet-tables)))))

