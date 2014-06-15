;;
;; org-mode設定
;;
(require 'org-install)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-hide-leading-stars t)						; 見出しの余分な*を消す
(setq org-directory "~/org/")						; org-default-notes-fileのディレクトリ
(setq org-default-notes-file (quote ("~/org/birthday.org" "~/org/newgtd.org")))
(setq org-agenda-files (quote ("~/org/birthday.org" "~/org/newgtd.org")))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

;; (add-hook 'org-mode-hook 'turn-on-font-lock)				; org-modeでの強調表示を可能にする

(setq org-default-notes-file "~/.notes")
;; (setq org-default-notes-file "notes.org")				; org-default-notes-fileのファイル名
;;(setq calendar-holidays nil)						; 標準の祝日を利用しない
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))		; アジェンダ表示で下線を用いる
(setq hl-line-face 'underline)


(setq org-capture-templates
      '(("t" "Todo" entry
	 (file+headline "~/org/newgtd.org" "タスク")
	 "** TODO <%<%Y-%m-%d>> %?\n  %i\n  %a\n"
	 )
        ("j" "Journal" entry
	 (file+datetree "~/org/journal.org")
	 "* %?\n%U\n %i %a"
	 )
        ("n" "Note" entry
	 (file+headline "~/org/notes.org" "Notes")
	 "* %?\n %U\n %i\n"
	 )
	))

;; (setq org-capture-templates
;;       '(("t" "Todo" entry
;;          (file+headline nil "Inbox")
;;          "** TODO %?\n   %i\n   %a\n   %t")
;;         ("b" "Bug" entry
;;          (file+headline nil "Inbox")
;;          "** TODO %?   :bug:\n   %i\n   %a\n   %t")
;;         ("i" "Idea" entry
;;          (file+headline nil "New Ideas")
;;          "** %?\n   %i\n   %a\n   %t")))
