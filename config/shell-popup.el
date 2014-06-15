;; ------------------------------------------------------------------
;;
;; shellバッファ を簡単にポップアップするための設定
;;
;; ------------------------------------------------------------------
(require 'cl)
(require 'shell)
(require 'tramp)

;; http://d.hatena.ne.jp/rubikitch/20100210/emacs
;; other-window がなければ開き、その window に移動する
(defun other-window-or-split ()
  (interactive)
  (if (one-window-p)
    (if (> (window-width) 160)
        (split-window-horizontally)
      (split-window-vertically)))
  (other-window 1))

;; ロケーションが同じ shellバッファ を other-window に表示する
(defun shell-popup ()
  (interactive)
  ;; (cl-flet* ((dissect-file-name (name)
  (flet ((dissect-file-name (name)
                            (cond ((file-remote-p name)
                                   (tramp-dissect-file-name name))
                                  (t
                                   (tramp-dissect-file-name
                                    (tramp-make-tramp-file-name "" "" "" name)))))
         (shell-other-window (buffer-name)
                             (let ((current-directory default-directory))
                               (other-window-or-split)
                               (let ((default-directory current-directory))
                                 (shell buffer-name))
                               (comint-goto-process-mark)
                               (unless (string= (expand-file-name default-directory)
                                                (expand-file-name current-directory))
                                 (comint-delete-input)
                                 (insert (concat "cd " (tramp-file-name-localname
                                                         (dissect-file-name current-directory))))
                                 (comint-send-input)
                                 (sit-for 0))))
         ;; process-mark のある行に comint-prompt-regexp にマッチする文字列があるかだけの簡易な判定をしている
         (shell-prompt-p (buffer-name)
                         (save-excursion
                           (set-buffer buffer-name)
                           (comint-goto-process-mark)
                           (forward-line 0)
                           (looking-at comint-prompt-regexp))))
    (cond (current-prefix-arg
           (shell-other-window (generate-new-buffer-name "*shell*")))
          (t
           (cond ((and (string-match "^\\*shell\\*" (buffer-name))
                       (not (one-window-p)))
                  (delete-window))
                 (t
                  (let ((current-buffer-v (dissect-file-name default-directory)))
                    (loop for buffer in (buffer-list)
                          if (and (string-match "^\\*shell\\*" (buffer-name buffer))
                                  (let ((shell-buffer-v
                                         (dissect-file-name (buffer-local-value 'default-directory buffer))))
                                    (and (string= (tramp-file-name-method current-buffer-v)
                                                  (tramp-file-name-method shell-buffer-v))
                                         (string= (tramp-file-name-user current-buffer-v)
                                                  (tramp-file-name-user shell-buffer-v))
                                         (string= (tramp-file-name-host current-buffer-v)
                                                  (tramp-file-name-host shell-buffer-v))))
                                  (or (not (get-buffer-process buffer))
                                      (shell-prompt-p (buffer-name buffer))))
                          return (shell-other-window (buffer-name buffer))
                          finally return (shell-other-window (generate-new-buffer-name "*shell*"))))))))))

;; キーバインドを設定する
(global-set-key (kbd "C-c s") 'shell-popup)

;; 以下は、必要であれば設定してください
;; (global-set-key (kbd "C-x o") 'other-window-or-split)
(global-set-key (kbd "C-t") 'other-window-or-split)

;; NTEmacsのみの設定

(defadvice comint-substitute-in-file-name (around ad-comint-substitute-in-file-name activate)
  (if (file-remote-p default-directory)
      (letf (((symbol-function 'substitute-in-file-name)
              (symbol-function 'identity)))
        ad-do-it)
    ad-do-it))
