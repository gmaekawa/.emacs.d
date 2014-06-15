;; ------------------------------------------------------------------
;;
;; dired でファイルやディレクトリの並び順等を調整する
;;
;; ------------------------------------------------------------------

(require 'dired)
(require 'ls-lisp)

;; ls-lisp を使う
(setq ls-lisp-use-insert-directory-program nil)

;; dired の並び順を explorer と同じにする
(setq ls-lisp-ignore-case t)         ; ファイル名の大文字小文字無視でソート
(setq ls-lisp-dirs-first t)          ; ディレクトリとファイルを分けて表示
(setq dired-listing-switches "-alG") ; グループ表示なし

;; ------------------------------------------------------------------
;;
;; dired の Wキーや Eキーで、カーソル位置のファイルや開いているディレクトリを OS で直接開く
;;
;; ------------------------------------------------------------------
;; OSタイプ を調べる function
(defun os-type ()
  (let ((os-type (shell-command-to-string "uname")))
    (cond ((string-match "CYGWIN" os-type)
           "win")
          ((string-match "Linux" os-type)
           "linux")
          ((string-match "Darwin" os-type)
           "mac"))))

;; OS でファイル、ディレクトリ、URL を直接開くためのコマンドを決定する function
(defun os-open-command-name ()
  (let ((os-type (os-type)))
    (if os-type
        (let ((command-name-list
               (cond ((string= "win" os-type)
                      '("cygstart"))
                     ((string= "linux" os-type)
                      '("xdg-open"))
                     ((string= "mac" os-type)
                      '("open")))))
          (dolist (command-name command-name-list)
            (if (not (string=  (shell-command-to-string
                                (concat "which " command-name " 2> /dev/null"))
                               ""))
                (return command-name)))))))

;; OS で直接、ファイル、ディレクトリ、URL を開く command
(defun os-open-command (filename)
  (interactive)
  (let* ((default-directory (if (file-regular-p filename)
                                (file-name-directory filename)
                              default-directory))
         (localname (if (file-remote-p filename)
                        (tramp-file-name-localname
                         (tramp-dissect-file-name filename))
                      filename))
         (os-open-command-name (os-open-command-name)))
    (when os-open-command-name
      (cond ((and (string= os-open-command-name "xdg-open")
                  (not (file-remote-p default-directory)))
             ;; 以下の URL の対策を行う
             ;; http://d.hatena.ne.jp/mooz/20100915/p1
             ;; http://i-yt.info/?date=20090829#p01
             (let (process-connection-type)
               (start-process "os-open-start" nil os-open-command-name localname)))
            (t
             (shell-command-to-string (concat os-open-command-name " "
                                              (shell-quote-argument localname) " &"))))
      (message "%s" (concat os-open-command-name " " localname)))))

;; dired で W 押下時に、カーソル位置のファイルを OS で直接起動する
(define-key dired-mode-map (kbd "W")
  (lambda ()
    (interactive)
    (os-open-command (dired-get-filename nil t))))

;; dired で E 押下時に、開いているディレクトリを OS で直接開く
(define-key dired-mode-map (kbd "E")
  (lambda ()
    (interactive)
    (os-open-command (dired-current-directory))))

