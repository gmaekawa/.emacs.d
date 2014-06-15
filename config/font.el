; -*- coding: iso-2022-7bit; mode: lisp-interaction -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.6 $BI=<(!&Au>~$K4X$9$k@_Dj(B                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P95-96 $B%U%'%$%9(B
;; $B%j!<%8%g%s$NGX7J?'$rJQ99(B
;; (set-face-background 'region "darkgreen")

;; $B"'MW3HD%5!G=%$%s%9%H!<%k"'(B
;;; P96-97 $BI=<(%F!<%^$N@_Dj(B
;; http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz
;; (when (require 'color-theme nil t)
;;   ;; $B%F!<%^$rFI$_9~$`$?$a$N@_Dj(B
;;   (color-theme-initialize)
;;   ;; $B%F!<%^(Bhober$B$KJQ99$9$k(B
;;   (color-theme-hober))

(load-theme 'dichromacy t)

;;; P97-99 $B%U%)%s%H$N@_Dj(B
(when (eq window-system 'ns)
;; (when (eq window-system 'w32)
  ;; ascii$B%U%)%s%H$r(BMenlo$B$K(B
  (set-face-attribute 'default nil
                      :family "Menlo"
                      :height 120)
  ;; $BF|K\8l%U%)%s%H$r%R%i%.%NL@D+(B Pro$B$K(B
  (set-fontset-font
   nil 'japanese-jisx0208
   ;; $B1Q8lL>$N>l9g(B
   ;; (font-spec :family "Hiragino Mincho Pro"))
   (font-spec :family "$B%R%i%.%NL@D+(B Pro"))
  ;; $B$R$i$,$J$H%+%?%+%J$r%b%H%d%7!<%@$K(B
  ;; U+3000-303F	CJK$B$N5-9f$*$h$S6gFIE@(B
  ;; U+3040-309F	$B$R$i$,$J(B
  ;; U+30A0-30FF	$B%+%?%+%J(B
  (set-fontset-font
   nil '(#x3040 . #x30ff)
   (font-spec :family "NfMotoyaCedar"))
  ;; $B%U%)%s%H$N2#I}$rD4@a$9$k(B
  (setq face-font-rescale-alist
        '((".*Menlo.*" . 1.0)
          (".*Hiragino_Mincho_Pro.*" . 1.2)
          (".*nfmotoyacedar-bold.*" . 1.2)
          (".*nfmotoyacedar-medium.*" . 1.2)
          ("-cdac$" . 1.3))))

(when (eq window-system 'w32)
;; (when (eq system-type 'windows-nt)
  ;; ascii$B%U%)%s%H$r(BConsolas$B$K(B
  (set-face-attribute 'default nil
                      :family "Consolas"
                      ;; :height 120)
                      :height 110)
  ;; $BF|K\8l%U%)%s%H$r%a%$%j%*$K(B
  (set-fontset-font
   nil
   'japanese-jisx0208
   ;; (font-spec :family "$B%a%$%j%*(B"))
   (font-spec :family "MeiryoKe_Gothic"))
  ;; $B%U%)%s%H$N2#I}$rD4@a$9$k(B
  (setq face-font-rescale-alist
        '((".*Consolas.*" . 1.0)
          (".*$B%a%$%j%*(B.*" . 1.15)
          ("-cdac$" . 1.3))))
