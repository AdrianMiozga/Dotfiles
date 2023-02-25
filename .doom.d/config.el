;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Consolas" :size 18)
      doom-unicode-font (font-spec :family "DejaVu Sans")
      doom-variable-pitch-font (font-spec :family "DejaVu Sans"))

(setq doom-theme 'doom-one)

(setq display-line-numbers-type 'relative)

;; Start Doom in fullscreen
(add-hook! 'window-setup-hook #'toggle-frame-fullscreen)
(add-hook! 'after-make-frame-functions #'toggle-frame-fullscreen)

;; Don’t display hourglass cursor when Emacs is busy
(setq display-hourglass nil)

;; Auto save after 2 seconds of idle
(setq auto-save-timeout 2)

;; Change scroll amount
(setq mouse-wheel-scroll-amount '(1 ((shift) . 2) ((control) . nil)))

(setq doom-org-special-tags nil)

(use-package! org
  :config
  (setq org-startup-folded t
        org-startup-with-inline-images t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-directory "~/org-roam/"
        org-ellipsis "…")
      ;;   org-ellipsis "  ")
  :hook (org-mode . doom-disable-line-numbers-h)
  :hook (org-mode . (lambda ()
                      (push '("#+TITLE: " . "") prettify-symbols-alist)
                      (push '("#+ROAM_TAGS: " . "") prettify-symbols-alist)
                      (prettify-symbols-mode))))

(use-package! org-roam
  :commands (org-roam
             org-roam-insert
             org-roam-switch-to-buffer
             org-roam-find-file
             org-roam-capture)
  :init
  (map! :leader
        :prefix "n"
        :desc "Org-roam" "l" #'org-roam
        :desc "Org-roam insert" "i" #'org-roam-insert
        :desc "Org-roam switch to buffer" "b" #'org-roam-switch-to-buffer
        :desc "Org-roam find file" "f" #'org-roam-find-file
        :desc "Org-roam capture" "c" #'org-roam-capture)
  :config
  (setq +org-roam-open-buffer-on-find-file nil
        org-roam-directory "~/org-roam"))

(use-package! org-superstar
   :hook (org-mode . org-superstar-mode)
   :config
   (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "◆")))

(use-package! mixed-pitch
  :hook (text-mode . mixed-pitch-mode)
  :init
  (map! :leader
        :prefix "t"
        :desc "Mixed pitch mode" "m" #'mixed-pitch-mode))

(use-package! typo
  :hook (text-mode . typo-mode)
  :init
  (typo-global-mode 1))

(use-package! writeroom
  :hook (org-mode . writeroom-mode)
  :init
  (setq writeroom-mode-line t
        writeroom-extra-line-spacing 0.3
        +zen-text-scale 0))

;; Spell checking
(use-package! ispell
  :config
  (setq ispell-dictionary "en_US,pl_PL")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,pl_PL")
  (setq ispell-personal-dictionary "~/.hunspell_personal"))

(use-package! evil
  :config
  ;; Change cursor colors
  (setq evil-normal-state-cursor '(box "#CD96CD")
        evil-insert-state-cursor '(bar "#CD96CD")
        evil-visual-state-cursor '(box "#CD96CD")
        evil-operator-state-cursor '((hbar . 9) "#CD96CD")
        evil-replace-state-cursor '(hbar "#CD96CD")))

(use-package! doom-modeline
  :defer
  :config
  (setq doom-modeline-column-zero-based nil))

(custom-set-faces!
  ;; Org headings
  '(org-level-1 :foreground "#AB9BD5" :weight bold :height 1.1)
  '(org-level-2 :foreground "#BC6EC5" :weight bold :height 1.1)
  '(org-level-3 :foreground "#C77DFF" :weight bold :height 1.1)
  '(org-level-4 :foreground "#DFF6FF" :weight bold :height 1.1)
  '(org-level-5 :foreground "#AB9BD5" :weight bold :height 1.1)

  ;; ‘- source ::’ face
  '(org-list-dt :foreground "#DFF6FF")

  ;; Remove underline from links
  '(org-link :foreground "SteelBlue1" :underline nil)

  '(org-document-title :inherit bold :foreground "#BC6EC5"
                       :underline nil :height 1.4)
  '(org-meta-line :inherit org-document-info-keyword :foreground "Seashell")

  '(hl-line :background "#383341")
  '(default :background "#1D1D26")

  '(org-drawer :foreground "SkyBlue1")

  '(org-indent :inherit (org-hide fixed-pitch))

  ;; :foreground nil makes ellipsis color same as the heading
  '(org-ellipsis :foreground nil :height 120))
