;; 名前とメールアドレス
(setq user-full-name (concat (getenv "DEBFULLNAME")))
(setq user-mail-address (concat (getenv "DEBEMAIL")))
;; Emacs の種類/バージョンの判定
(defvar oldemacs-p (<= emacs-major-version 22)) ; 22 以下
(defvar emacs23-p (<= emacs-major-version 23))  ; 23 以下
(defvar emacs24-p (>= emacs-major-version 24))  ; 24 以上
(defvar darwin-p (eq system-type 'darwin))      ; Mac OS X 用
(defvar nt-p (eq system-type 'windows-nt))      ; Windows 用
;;ディレクトリ構成を決めるための変数
(when oldemacs-p
  (defvar user-emacs-directory
    (expand-file-name (concat (getenv "HOME") "/.emacs.d/"))))
(defconst my:user-emacs-config-directory
  (expand-file-name (concat user-emacs-directory "config/")))
(defconst my:user-emacs-temporary-directory
  (expand-file-name (concat user-emacs-directory "tmp/")))
(defconst my:user-emacs-share-directory
  (expand-file-name (concat user-emacs-directory "share/")))
;; 
;; キーバインド
;; 
;; 基本
;; 
(define-key global-map (kbd "M-?") 'help-for-help)        ; ヘルプ
(define-key global-map (kbd "C-c C-i") 'hippie-expand)    ; 補完
(define-key global-map (kbd "C-c ;") 'comment-dwim)       ; コメントアウト
(define-key global-map (kbd "M-C-g") 'grep)               ; grep
(define-key global-map (kbd "C-[ M-C-g") 'goto-line)      ; 指定行へ移動
(define-key global-map "\C-cd" `insert-current-time)      ; 日付挿入
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)


;; (keyboard-translate ?\C-h ?\C-?)                       ; C-hでバックスペース
;; (define-key global-map (kbd "C-z") 'undo)              ; undo

;; Windows デフォルトWEBブラウザ
(setq browse-url-browser-function 'browse-url-default-windows-browser)


;; 日付挿入
(defun insert-current-time()
  (interactive)
  (insert (format-time-string "%Y-%m-%d(%a)" (current-time))))
  ;; (insert (format-time-string "%Y-%m-%d(%a) %H:%M:%S" (current-time))))


(setq auto-image-file-mode t)		; 画像ファイルを表示
(toggle-scroll-bar t)			; 縦スクロールバーを表示
(menu-bar-mode 0)			; メニューバーを消す
(tool-bar-mode 0)			; ツールバーを消す
(blink-cursor-mode 0)			; カーソルの点滅を止める
(setq eval-expression-print-length nil)	; evalした結果を全部表示
(show-paren-mode 1)			; 対応する括弧を光らせる。
(setq show-paren-style 'mixed)		; ウィンドウ内に収まらないときだけ括弧内も光らせる。
(require 'whitespace)	                ; 空白や長すぎる行を視覚化する。
(setq whitespace-line-column 80)        ; 1行が80桁を超えたら長すぎると判断する。
(setq whitespace-style '(face              ; faceを使って視覚化する。
                         trailing          ; 行末の空白を対象とする。
                         lines-tail        ; 長すぎる行のうち
                                           ; whitespace-line-column以降のみを
                                           ; 対象とする。
                         indentation       ; indent-tabs-modeと逆のインデントを
                                           ; 対象とする。
                                           ; 2013-05-03
                         space-before-tab  ; タブの前にあるスペースを対象とする。
                         space-after-tab)) ; タブの後にあるスペースを対象とする。
;;(global-whitespace-mode 1)		   ; デフォルトで視覚化を有効にする。
(global-whitespace-mode 0)	           ; デフォルトで視覚化を無効にする。
(define-key global-map (kbd "<f5>") 'global-whitespace-mode) ; F5 で whitespace-mode をトグル

(setq hl-line-face 'underline)	        ; アンダーラインを引く
(global-hl-line-mode)	                ; 現在行を目立たせる
(column-number-mode t)		        ; カーソルの位置が何文字目かを表示する
(line-number-mode t)			; カーソルの位置が何行目かを表示する
(require 'saveplace)
(setq-default save-place t)		; カーソルの場所を保存する
(setq kill-whole-line t)		; 行の先頭でC-kを一回押すだけで行全体を消去する
(setq require-final-newline t)		; 最終行に必ず一行挿入する
(setq next-line-add-newlines nil)	; バッファの最後でnewlineで新規行を追加するのを禁止する
(setq backup-inhibited t)	        ; バックアップファイルを作らない
(setq delete-auto-save-files t)		; 終了時にオートセーブファイルを消す
(setq completion-ignore-case t)		; 補完時に大文字小文字を区別しない
(setq read-file-name-completion-ignore-case t)

;; 部分一致の補完機能を使う
;; p-bでprint-bufferとか
;; 2012-08-08
;; Emacs 24ではデフォルトで有効になっていて、`partial-completion-mode'は
;; なくなっている。カスタマイズする場合は以下の変数を変更する。
;;   * `completion-styles'
;;   * `completion-pcm-complete-word-inserts-delimiters'
(if (fboundp 'partial-completion-mode)
    (partial-completion-mode t))
;; 補完可能なものを随時表示
;; 少しうるさい
(icomplete-mode 1)

(setq history-length 10000)	        ; 履歴数を大きくする
(savehist-mode 1)	                ; ミニバッファの履歴を保存する
(setq recentf-max-saved-items 10000)	; 最近開いたファイルを保存する数を増やす
(auto-compression-mode t)		; gzファイルも編集できるようにする

(setq ediff-window-setup-function 'ediff-setup-windows-plain) ; ediffを1ウィンドウで実行
(setq diff-switches '("-u" "-p" "-N"))	; diffのオプション

(require 'dired-x)                      ; diredを便利にする
(require 'wdired)			; diredから"r"でファイル名をインライン編集する

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets) ; ファイル名が重複していたらディレクトリ名を追加する。
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p) ; shebangがあるファイルを保存すると実行権をつける。

;;; リージョンの大文字小文字変換を有効にする。
;; C-x C-u -> upcase
;; C-x C-l -> downcase
;; 2011-03-09
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;; kill
;; 2012-09-01
;; Emacs 24からクリップボードだけ使うようになっているので
;; Emacs 23のようにprimary selectionを使うように変更
;;   * killしたらprimary selectionにだけ入れる（Xの場合のみ）
;;   * yankするときはprimary selectionのものを使う
(setq x-select-enable-primary t)
(when (eq window-system 'x)
  (setq x-select-enable-clipboard nil))

(which-function-mode 1)			; 現在の関数名をウィンドウ上部に表示する。
(server-start)				; emacsclientで接続できるようにする。
