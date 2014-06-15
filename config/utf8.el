;; ------------------------------------------------------------------
;;
;; UTF-8 をベースとして利用するための設定
;;
;; ------------------------------------------------------------------

(setenv "LANG" "ja_JP.UTF-8") 

;; IME の設定をした後には実行しないこと
;; (set-language-environment 'Japanese) 

(prefer-coding-system 'utf-8-unix)
(set-file-name-coding-system 'cp932)

;; プロセスが出力する文字コードを判定して、process-coding-system の DECODING の設定値を決定する
(setq default-process-coding-system '(undecided-dos . utf-8-unix))

;; サブプロセスに渡すパラメータの文字コードを cp932 にする
(defmacro set-process-args-coding-system (function args-number)
  `(defadvice ,function (before ,(intern (concat
                                          "ad-"
                                          (symbol-name function)
                                          "-to-set-process-args-coding-sytem"))
                                activate)
     (ad-set-args ,args-number
                  (mapcar (lambda (arg)
                            (if (multibyte-string-p arg)
                                (encode-coding-string arg 'cp932)
                              arg))
                          (ad-get-args ,args-number)))))

(set-process-args-coding-system call-process 4)
(set-process-args-coding-system call-process-region 6)
(set-process-args-coding-system start-process 3)

