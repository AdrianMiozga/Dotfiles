;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! typo)
(package! mixed-pitch)
(package! org-superstar)
(package! benchmark-init)

;; Disable this package so I can easily change background color
;; through default face
(package! solaire-mode :disable t)

;; Normal ‘S’ key behavior
(package! evil-snipe :disable t)
