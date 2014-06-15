;;
;; キーバインドのガイド表示
;;
(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x" "C-c"))
(setq guide-key/popup-window-position 'bottom)
(setq guide-key/idle-delay 2)
(guide-key-mode 1)
