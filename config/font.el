; -*- coding: iso-2022-7bit; mode: lisp-interaction -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.6 表示・装飾に関する設定                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P95-96 フェイス
;; リージョンの背景色を変更
;; (set-face-background 'region "darkgreen")

;; ▼要拡張機能インストール▼
;;; P96-97 表示テーマの設定
;; http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz
;; (when (require 'color-theme nil t)
;;   ;; テーマを読み込むための設定
;;   (color-theme-initialize)
;;   ;; テーマhoberに変更する
;;   (color-theme-hober))

(load-theme 'dichromacy t)

;;; P97-99 フォントの設定
(when (eq window-system 'ns)
;; (when (eq window-system 'w32)
  ;; asciiフォントをMenloに
  (set-face-attribute 'default nil
                      :family "Menlo"
                      :height 120)
  ;; 日本語フォントをヒラギノ明朝 Proに
  (set-fontset-font
   nil 'japanese-jisx0208
   ;; 英語名の場合
   ;; (font-spec :family "Hiragino Mincho Pro"))
   (font-spec :family "ヒラギノ明朝 Pro"))
  ;; ひらがなとカタカナをモトヤシーダに
  ;; U+3000-303F	CJKの記号および句読点
  ;; U+3040-309F	ひらがな
  ;; U+30A0-30FF	カタカナ
  (set-fontset-font
   nil '(#x3040 . #x30ff)
   (font-spec :family "NfMotoyaCedar"))
  ;; フォントの横幅を調節する
  (setq face-font-rescale-alist
        '((".*Menlo.*" . 1.0)
          (".*Hiragino_Mincho_Pro.*" . 1.2)
          (".*nfmotoyacedar-bold.*" . 1.2)
          (".*nfmotoyacedar-medium.*" . 1.2)
          ("-cdac$" . 1.3))))

(when (eq window-system 'w32)
;; (when (eq system-type 'windows-nt)
  ;; asciiフォントをConsolasに
  (set-face-attribute 'default nil
                      :family "Consolas"
                      ;; :height 120)
                      :height 110)
  ;; 日本語フォントをメイリオに
  (set-fontset-font
   nil
   'japanese-jisx0208
   ;; (font-spec :family "メイリオ"))
   (font-spec :family "MeiryoKe_Gothic"))
  ;; フォントの横幅を調節する
  (setq face-font-rescale-alist
        '((".*Consolas.*" . 1.0)
          (".*メイリオ.*" . 1.15)
          ("-cdac$" . 1.3))))
