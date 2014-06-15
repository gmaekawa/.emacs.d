;; 色を設定する
;; http://d.hatena.ne.jp/aki77/20090506/1241609426
(setq term-default-fg-color "White"
      term-default-bg-color "Black"
      ansi-term-color-vector
      [unspecified "black" "#ff5555" "#55ff55" "#ffff55" "#5555ff"
                   "#ff55ff" "#55ffff" "white"])

;; タブ等を出している場合に、ターミナルの高さを合わせる
(add-hook 'term-mode-hook
          (lambda ()
            (setq term-height (- (window-height) 2))))

;; terminal 利用時の locale-coding-system を utf-8 とする（文字化け対策）
;;（ (setq locale-coding-system 'utf-8) の設定を避けたい場合に ）
(defadvice term-emulate-terminal (around ad-term-emulate-terminal activate)
  (let ((locale-coding-system 'utf-8))
    ad-do-it))

;; 漢字を含むディレクトリに cd できるようにする
(defadvice cd (around ad-cd activate)
  (let ((dir (decode-coding-string dir 'utf-8)))
    ad-do-it))

;; C-c a で ansi-term を起動する
(global-set-key (kbd "C-c a")
                (lambda ()
                  (interactive)
                  (ansi-term "bash")))
