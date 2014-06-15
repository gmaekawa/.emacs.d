;;; sdic-mode �Ѥ�����
(autoload 'sdic-describe-word "sdic" "��ñ��ΰ�̣��Ĵ�٤�" t nil)
(global-set-key "\C-cw" 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point "sdic" "��������ΰ��֤α�ñ��ΰ�̣��Ĵ�٤�" t nil)
(global-set-key "\C-cW" 'sdic-describe-word-at-point)


;; ;; ���¸����ǻ��Ѥ��뼭��
;; (setq sdic-eiwa-dictionary-list
;;       '(
;;         (sdicf-client
;;          "c:/cygwin/usr/local/share/dict/gene.sdic")
;;         ))
;; ;; �±Ѹ����ǻ��Ѥ��뼭��
;; (setq sdic-waei-dictionary-list
;;       '(
;;         (sdicf-client
;;          "c:/cygwin/usr/local/share/dict/jedict.sdic")
;;         ))

(setq sdic-eiwa-dictionary-list '((sdicf-client "c:/cygwin/usr/local/share/dict/gene.sdic"))
      sdic-waei-dictionary-list '((sdicf-client "c:/cygwin/usr/local/share/dict/jedict.sdic"
						(add-keys-to-headword t))))

;;ʸ�����󥳡���
;; (setq sdic-default-coding-system 'utf-8)
;; (setq sdic-default-coding-system 'euc-japan-unix)
(setq sdic-default-coding-system 'utf-8-unix)

;; ;; ʸ����
(setq sdic-face-color "pink")

; �������ɽ��������ɥ��ι⤵
(setq sdic-window-height 20)

;�������ɽ��������ɥ��˥���������ư���ʤ��褦�ˤ���
;(setq sdic-disable-select-window t)

;���Ф����ɽ�����뤿��˻Ȥ��ե������ȿ�
(setq sdic-face-style 'bold)
(setq sdic-face-color "firebrick4")

; ��������
(global-set-key [insert]  'sdic-describe-word-at-point)
(global-set-key [home]    'sdic-describe-word)
(global-set-key [pause]   'sdic-describe-region)
(global-set-key [end]     'sdic-close-window)
(global-set-key [next]    'scroll-other-window)
(global-set-key [prior]   'scroll-other-window-down)

; �������ɽ���Хåե��ǰ�����ñ���ϥ��饤��ɽ������
(defadvice sdic-search-eiwa-dictionary (after highlight-phrase (arg))
    (highlight-phrase arg "hi-yellow"))
(defadvice sdic-search-waei-dictionary (after highlight-phrase (arg))
    (highlight-phrase arg "hi-yellow"))

(ad-activate 'sdic-search-eiwa-dictionary)
(ad-activate 'sdic-search-waei-dictionary)
