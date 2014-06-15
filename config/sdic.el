;;; sdic-mode 用の設定
(autoload 'sdic-describe-word "sdic" "英単語の意味を調べる" t nil)
(global-set-key "\C-cw" 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point "sdic" "カーソルの位置の英単語の意味を調べる" t nil)
(global-set-key "\C-cW" 'sdic-describe-word-at-point)


;; ;; 英和検索で使用する辞書
;; (setq sdic-eiwa-dictionary-list
;;       '(
;;         (sdicf-client
;;          "c:/cygwin/usr/local/share/dict/gene.sdic")
;;         ))
;; ;; 和英検索で使用する辞書
;; (setq sdic-waei-dictionary-list
;;       '(
;;         (sdicf-client
;;          "c:/cygwin/usr/local/share/dict/jedict.sdic")
;;         ))

(setq sdic-eiwa-dictionary-list '((sdicf-client "c:/cygwin/usr/local/share/dict/gene.sdic"))
      sdic-waei-dictionary-list '((sdicf-client "c:/cygwin/usr/local/share/dict/jedict.sdic"
						(add-keys-to-headword t))))

;;文字エンコード
;; (setq sdic-default-coding-system 'utf-8)
;; (setq sdic-default-coding-system 'euc-japan-unix)
(setq sdic-default-coding-system 'utf-8-unix)

;; ;; 文字色
(setq sdic-face-color "pink")

; 検索結果表示ウインドウの高さ
(setq sdic-window-height 20)

;検索結果表示ウインドウにカーソルを移動しないようにする
;(setq sdic-disable-select-window t)

;見出し語を表示するために使うフェイスと色
(setq sdic-face-style 'bold)
(setq sdic-face-color "firebrick4")

; キー設定
(global-set-key [insert]  'sdic-describe-word-at-point)
(global-set-key [home]    'sdic-describe-word)
(global-set-key [pause]   'sdic-describe-region)
(global-set-key [end]     'sdic-close-window)
(global-set-key [next]    'scroll-other-window)
(global-set-key [prior]   'scroll-other-window-down)

; 検索結果表示バッファで引いた単語をハイライト表示する
(defadvice sdic-search-eiwa-dictionary (after highlight-phrase (arg))
    (highlight-phrase arg "hi-yellow"))
(defadvice sdic-search-waei-dictionary (after highlight-phrase (arg))
    (highlight-phrase arg "hi-yellow"))

(ad-activate 'sdic-search-eiwa-dictionary)
(ad-activate 'sdic-search-waei-dictionary)
