;; ------------------------------------------------------------------
;;
;; shell-mode を正しく動作させるための設定
;; 
;; ------------------------------------------------------------------
(require 'shell)

(setq explicit-shell-file-name "bash")
(setq shell-command-switch "-c")
(setq shell-file-name "bash")

;; gnupack の init.el 設定では、process-coding-system-alist 連想リストに shell関係の設定が
;; してあるので削除する
(setq process-coding-system-alist
      (delq (assoc "bash" process-coding-system-alist) process-coding-system-alist))
(setq process-coding-system-alist
      (delq (assoc ".*sh\\.exe" process-coding-system-alist) process-coding-system-alist))

;; gnupack の init.el 内で設定している shell-mode-hook の設定をクリアする
(setq shell-mode-hook nil)

;; shell の割り込みを機能させる
(defadvice comint-interrupt-subjob (around ad-comint-interrupt-subjob activate)
  (process-send-string nil (kbd "C-c")))
(defadvice comint-stop-subjob (around ad-comint-stop-subjob activate)
  (process-send-string nil (kbd "C-z")))
(defadvice comint-quit-subjob (around ad-comint-quit-subjob activate)
  (process-send-string nil (kbd "C-\\")))
(defadvice comint-send-eof (around ad-comint-send-eof activate)
  (process-send-string nil (kbd "C-d")))

;; カレントバッファが shellバッファのときに、動いている process の coding-system の DECODING の
;; 設定を undecided にする function
(defun set-shell-buffer-process-coding-system ()
  (let ((process (get-buffer-process (buffer-name))))
    (if (and process
             (string-match "^shell" (process-name process)))
        (let ((coding-system (process-coding-system process)))
          (set-process-coding-system process
                                     (coding-system-change-text-conversion
                                      (car coding-system) 'undecided)
                                     (cdr coding-system))))))

;; shellバッファで、コマンド実行結果出力前に set-shell-buffer-process-coding-system を実行する。
;; この設定により、shellバッファで utf-8 の出力をする cygwin コマンドと、cp932 の出力をする
;; windowsコマンドの漢字の文字化けが回避される。また、漢字を含むプロンプトが文字化けする場合には、
;; .bashrc の PS1 の設定の後に「export PS1="$(sleep 0.1)$PS1"」を追加すれば、回避できる模様。
(defadvice comint-output-filter (before ad-comint-output-filter activate)
  (set-shell-buffer-process-coding-system))

;; C-c s で shell を起動する
;; C-u C-c s で shell を追加起動する
(global-set-key (kbd "C-c s")
             (lambda ()
               (interactive)
               (if current-prefix-arg
                   (shell (generate-new-buffer-name "*shell*"))
                 (shell))))

;; ------------------------------------------------------------------
;;
;; 利用するShellの設定
;;
;; ------------------------------------------------------------------

;; shell の存在を確認
(defun skt:shell ()
  (or (executable-find "zsh")
      (executable-find "bash")
      ;; (executable-find "f_zsh") ;; Emacs + Cygwin を利用する人は Zsh の代りにこれにしてください
      ;; (executable-find "f_bash") ;; Emacs + Cygwin を利用する人は Bash の代りにこれにしてください
      (executable-find "cmdproxy")
      (error "can't find 'shell' command in PATH!!")))

;; Shell 名の設定
(setq shell-file-name (skt:shell))
(setenv "SHELL" shell-file-name)
(setq explicit-shell-file-name shell-file-name)
