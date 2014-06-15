;; ------------------------------------------------------------------
;;
;; helm を使うための設定
;;
;; ------------------------------------------------------------------
;; 候補を作って描写するまでのタイムラグを設定する（デフォルトは 0.1）
(setq helm-idle-delay 0.2)

(require 'helm-config)
(require 'helm-descbinds)
(require 'helm-migemo)
(require 'helm-gtags)

(helm-mode 1)

;; 文字列を入力してから検索するまでのタイムラグを設定する（デフォルトは 0.1）
(setq helm-input-idle-delay 0.2)

;; helm-source-buffers-list でバッファ名を表示する幅を調整する
(setq helm-buffer-max-length 50)

;; helm-source-locate でワードの and 検索ができるようにする
;; ・locate を使えない場合は、「locate ''」の部分を「cat ~/tmp/all.filelist」に置き換えてください。
;; 　そして、find 等を使って all.filelist（ファイル名が並んだファイル）を作成してください。
;; ・検索の高速化のために、検索件数を helm-candidate-number-limit までに head コマンドで絞っています。
;; 　helm-source-locate情報源 の candidate-number-limit設定値 を設定する方法もあります。
;; 　（後半の helm-before-initialize-hook の箇所でコメント化している部分となります。）
(setq helm-locate-command
      (concat "locate_case=$(echo '%s' | sed 's/-//'); locate '' |"
              "perl -ne \"$(echo %s | sed -r 's/^ +//' |"
                           "sed -r 's/ +$//' |"
                           "sed 's_/_\\\\/_g' |"
                           "sed -r 's_( |\\.\\*)+_/'$locate_case' \\&\\& /_g' |"
                           "sed 's_.*_$| = 1; print if (/&/'$locate_case')_')\" |"
                           "head -n " (number-to-string helm-candidate-number-limit)))

;; tramp で remote-directory を開いているときに、helm-for-files を起動すると反応が悪い
;; 原因は helm-source-files-in-current-dir だったので、この情報源の指定を削除する
;; また、一部表示順を変更する
(setq helm-for-files-preferred-list
      '(helm-source-buffers-list
        helm-source-bookmarks
        helm-source-recentf
        helm-source-file-cache
        ;; helm-source-files-in-current-dir
        helm-source-locate))

;; helm-follow-mode （C-c C-f で ON/OFF）の前回の状態を維持する
(setq helm-follow-mode-persistent t)

;; ミニバッファで C-k 入力時にカーソル以降を削除する（C-u C-k でも同様の動きをする）
(setq helm-delete-minibuffer-contents-from-point t)

;; http://fukuyama.co/nonexpansion
;; 自動補完を無効にする
(setq helm-ff-auto-update-initial-value nil)

;; C-h でバックスペースと同じように文字を削除できるようにする
;; (define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)

;; TAB で補完する
(define-key helm-read-file-map (kbd "<tab>") 'helm-execute-persistent-action)

;; C-o は ime変換用として使っているので、helm-next-source を C-l に変更する
(define-key helm-map (kbd "C-o") nil)
(define-key helm-map (kbd "C-l") 'helm-next-source)

;; http://d.hatena.ne.jp/sugyan/20120104/1325604433
;; プレフィックスキーを C-; に設定する
(custom-set-variables '(helm-command-prefix-key "C-;"))

;; キーバインドを設定する。コマンド起動後は、以下のキーが利用可能となる
;;  ・M-n     ：カーソル位置の単語を検索パターンに追加
;;  ・C-z     ：チラ見
;;  ・C-c C-f ：helm-follow-mode の ON/OFF
(global-set-key (kbd "C-x C-b") 'helm-for-files)
(global-set-key (kbd "C-x C-;") 'helm-for-files)
(define-key helm-command-map (kbd "C-;") 'helm-resume)
(define-key helm-command-map (kbd "y")   'helm-show-kill-ring)
(define-key helm-command-map (kbd "o")   'helm-occur)
(define-key helm-command-map (kbd "C-s") 'helm-occur-from-isearch)
(define-key helm-command-map (kbd "g")   'helm-do-grep) ; C-u 付で起動すると、recursive となる
(define-key helm-command-map (kbd "t")   'helm-gtags-find-tag)

;; helmコマンドで migemo を有効にする
(setq helm-migemize-command-idle-delay helm-idle-delay)
(helm-migemize-command helm-for-files)
(helm-migemize-command helm-firefox-bookmarks)

;; helm-occur コマンドの起動時に helm-maybe-use-default-as-input（helm コマンドに :input パラメータが
;; 指定されていなければ、:default の値を使って表示を更新する）を設定する
(defadvice helm-occur (around ad-helm-occur activate)
  (let ((helm-maybe-use-default-as-input t))
    ad-do-it))

;; 情報源 helm-source-occur と helm-source-grep について、利用開始時点から helm-follow-mode を ON にする
;; 情報源 helm-source-locate と helm-source-grep について、検索必要最低文字数を 2 とする。
;; helm-occur コマンドを使う際に migemo でマッチした箇所がハイライトするようにする
(add-hook 'helm-before-initialize-hook
          (lambda ()
            (when helm-source-locate
              ;; (setcdr (assq 'candidate-number-limit helm-source-locate) helm-candidate-number-limit)
              (setcdr (assq 'requires-pattern helm-source-locate) 2))
            (when helm-source-occur
              (helm-attrset 'follow 1 helm-source-occur)
              (delete '(nohighlight) helm-source-occur))
            (when helm-source-grep
              (helm-attrset 'follow 1 helm-source-grep)
              ;; (setcdr (assq 'candidate-number-limit helm-source-grep) helm-candidate-number-limit)
              (setcdr (assq 'requires-pattern helm-source-grep) 2))))

;; http://d.hatena.ne.jp/a666666/20100221/1266695355
;; エラーを抑制する対策（エラーが発生した際に設定してみてください）
;; (setq max-lisp-eval-depth 5000)
;; (setq max-specpdl-size 5000)

;; helm-delete-minibuffer-contents-from-point（ミニバッファで C-k 入力時にカーソル以降を
;; 削除する)を設定すると、pattern 文字入力後に action が表示されない症状が出ることの対策
(defadvice helm-select-action (around ad-helm-select-action activate)
  (let ((helm-delete-minibuffer-contents-from-point nil))
    ad-do-it))

;; helm と elscreen を一緒に使う際に helm の helm-follow-mode を使うと、カーソル制御が
;; おかしくなることの対策
(defadvice helm (around ad-helm-for-elscreen activate)
  (let ((elscreen-screen-update-hook nil))
    ad-do-it))

;;;
;; w32-ime-buffer-switch-p が t の場合に、ミニバッファで漢字を使えるようにする対策
(setq w32-ime-buffer-switch-p t) ; バッファ切り替え時にIME状態を引き継ぐ
(defadvice helm (around ad-helm-for-w32-ime activate)
  (let ((select-window-functions nil)
        (w32-ime-composition-window (minibuffer-window)))
    ad-do-it))

;; UNC や Tramp のパスに対して、helm-reduce-file-name が正しく機能しないことの対策
;; （ (helm-mode 1) として dired を動かした際に C-l（helm-find-files-down-one-level）
;; 　が正しく機能するようにする対策）
(defadvice helm-reduce-file-name (around ad-helm-reduce-file-name activate)
  (let ((fname (ad-get-arg 0))
        (level (ad-get-arg 1)))
    (while (> level 0)
      (setq fname (expand-file-name (concat fname "/../")))
      (setq level (1- level)))
    (setq ad-return-value fname)))

;; ffap を使っていて find-file-at-point を起動した場合に、カーソル位置の UNC が正しく
;; 取り込まれないことの対策
(defadvice helm-completing-read-default-1 (around ad-helm-completing-read-default-1 activate)
  (if (listp (ad-get-arg 4))
      (ad-set-arg 4 (car (ad-get-arg 4))))
  ;; (cl-letf (((symbol-function 'regexp-quote)
  (letf (((symbol-function 'regexp-quote)
          (symbol-function 'identity)))
    ad-do-it))

;; w32-symlinks を使っている場合に C-u 付きで helm-do-grep を起動すると、選択したファイルを
;; no conversion で開いてしまうことの対策
(defadvice find-file (around ad-find-file activate)
  (let ((current-prefix-arg nil))
    ad-do-it))

(require 'package)
(setq package-user-dir "~/.emacs.d/elisp/elpa/")
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; ------------------------------------------------------------------
;;
;; CMigemoを使うための設定
;;
;; ------------------------------------------------------------------

(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs" "-i" "\a"))
(setq migemo-dictionary (expand-file-name "~/.emacs.d/site-lisp/cmigemo-default-win64/dict/utf-8/migemo-dict"))
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-use-pattern-alist t)
(setq migemo-use-frequent-pattern-alist t)
(setq migemo-pattern-alist-length 1000)
(setq migemo-coding-system 'utf-8-unix)
(load-library "migemo")
(migemo-init)
(put 'set-goal-column 'disabled nil)

;; ------------------------------------------------------------------
;;
;; ストレスレスな設定
;;
;; ------------------------------------------------------------------

(when (require 'helm-config nil t)
  (helm-mode 1)

  (define-key global-map (kbd "M-x")     'helm-M-x)
  (define-key global-map (kbd "C-x C-f") 'helm-find-files)
  (define-key global-map (kbd "C-x C-r") 'helm-recentf)
  (define-key global-map (kbd "M-y")     'helm-show-kill-ring)
  (define-key global-map (kbd "C-c i")   'helm-imenu)
  (define-key global-map (kbd "C-x b")   'helm-buffers-list)

  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

  ;; Disable helm in some functions
  (add-to-list 'helm-completing-read-handlers-alist '(find-alternate-file . nil))

  ;; Emulate `kill-line' in helm minibuffer
  (setq helm-delete-minibuffer-contents-from-point t)
  (defadvice helm-delete-minibuffer-contents (before helm-emulate-kill-line activate)
    "Emulate `kill-line' in helm minibuffer"
    (kill-new (buffer-substring (point) (field-end))))

  (defadvice helm-ff-kill-or-find-buffer-fname (around execute-only-if-exist activate)
    "Execute command only if CANDIDATE exists"
    (when (file-exists-p candidate)
      ad-do-it))

  (defadvice helm-ff-transform-fname-for-completion (around my-transform activate)
    "Transform the pattern to reflect my intention"
    (let* ((pattern (ad-get-arg 0))
           (input-pattern (file-name-nondirectory pattern))
           (dirname (file-name-directory pattern)))
      (setq input-pattern (replace-regexp-in-string "\\." "\\\\." input-pattern))
      (setq ad-return-value
            (concat dirname
                    (if (string-match "^\\^" input-pattern)
                        ;; '^' is a pattern for basename
                        ;; and not required because the directory name is prepended
                        (substring input-pattern 1)
                      (concat ".*" input-pattern)))))))
