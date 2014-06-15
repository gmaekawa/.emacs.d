;; プラグマを挿入したい行に移動して insert-encoding-pragmaとする

(defun insert-encoding-pragma (charset)
  "Insert encoding pragma for each programming language"
  (interactive "sInput encoding: ")
  (let* ((extension (insert-encoding-get-file-extension (buffer-name)))
         (comment-char (insert-encoding-get-comment-char extension))
         (pragma (concat comment-char "-*- coding:" charset " -*-")))
    (progn (beginning-of-line)
           (insert-string pragma))))

(defun insert-encoding-get-comment-char (extension)
  (let ((sharp-langs '("sh" "pl" "t" "pm" "rb" "py"))
        (slash-langs '("c" "h" "cpp"))
        (semicolon-langs '("gosh" "el" "scm" "lisp")))
    (cond ((member extension sharp-langs) "#")
          ((member extension slash-langs) "//")
          ((member extension semicolon-langs) ";;")
          (t ""))))

(defun insert-encoding-get-file-extension (filename)
  (if (string-match "\\.\\([a-zA-Z0-9]+\\)$" filename)
      (substring filename (match-beginning 1) (match-end 1))))
