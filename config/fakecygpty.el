;; ------------------------------------------------------------------
;;
;; fakecygpty を使うための設定
;; 
;; ------------------------------------------------------------------
;; start-process での起動時に、fakecygpty.exe を経由させたいプログラム名を列挙する
;; suffix に .exe が付くコマンドは、その suffix を記載しないこと
(setq fakecygpty-program-list '("sh" "bash" "zsh" "ssh" "scp" "rsync" "sftp" "irb" "psql" "sqlite3"))

;; start-process での起動時に、fakecygpty.exe を経由させたくないプロセスが走るバッファ名を列挙する
(setq fakecygpty-exclusion-buffer-name-list '("*grep*"))

;; fakecygpty-program-list に登録されているプログラムを fakecygpty.exe 経由で起動する
(defadvice start-process (around ad-start-process-to-fake last activate)
  (let ((buffer-name (if (bufferp (ad-get-arg 1))
                         (buffer-name (ad-get-arg 1))
                       (ad-get-arg 1))))
    (if (and (member (replace-regexp-in-string "\\.exe$" "" (file-name-nondirectory (ad-get-arg 2)))
                     fakecygpty-program-list)
             (not (member buffer-name fakecygpty-exclusion-buffer-name-list)))
        (progn
          (ad-set-args 3 (cons (ad-get-arg 2) (ad-get-args 3)))
          (ad-set-arg 2 "fakecygpty")
          ad-do-it)
      ad-do-it)))

