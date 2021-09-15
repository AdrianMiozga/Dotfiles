;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Install version 1.2.1 of org-roam
(package! org-roam
  :recipe (:host github :repo "org-roam/org-roam")
  :pin "89e9121")

(package! org-table-wrap-functions
  :recipe (:host github :repo "analyticd/org-table-wrap-functions"))

(package! title-capitalization
  :recipe (:host github :repo "novoid/title-capitalization.el"))

(package! mixed-pitch)
(package! org-superstar)
(package! typo)
(package! go-translate)
(package! flyspell-correct)
(package! flyspell-correct-ivy)
(package! sound-wav)
(package! org-clock-convenience)
(package! benchmark-init)
(package! org-super-agenda)

;; Disable this package so I can easily change background color
;; through default face
(package! solaire-mode :disable t)

(package! evil-snipe :disable t)
