;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(setq doom-font (font-spec :family "Consolas" :size 18)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org-roam/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Start Doom in fullscreen
(add-hook! 'window-setup-hook #'toggle-frame-fullscreen)

(add-hook! 'after-make-frame-functions #'toggle-frame-fullscreen)

;; Disable line numbers in Org-mode
(add-hook! 'org-mode-hook #'doom-disable-line-numbers-h)

;; Prettify symbols
(add-hook 'org-mode-hook (lambda ()
                           (push '("#+TITLE: " . "") prettify-symbols-alist)
                           (push '("#+ROAM_TAGS: " . "") prettify-symbols-alist)
                           (prettify-symbols-mode)))


(setq org-startup-folded t)

(use-package! org-roam
  :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
  :hook
  (after-init . org-roam-mode)
  :init
  (map! :leader
        :prefix "n"
        :desc "Org-roam" "l" #'org-roam
        :desc "Org-roam insert" "i" #'org-roam-insert
        :desc "Org-roam switch to buffer" "b" #'org-roam-switch-to-buffer
        :desc "Org-roam find file" "f" #'org-roam-find-file
        :desc "Org-roam insert" "i" #'org-roam-insert
        :desc "Org-roam capture" "c" #'org-roam-capture)
  (setq org-roam-directory (file-truename "~/org-roam/")
        org-roam-db-gc-threshold most-positive-fixnum
        org-roam-tag-sources '(prop last-directory)
        org-id-link-to-org-use-id t)
  (setq org-roam-capture-templates
   '(("d" "default" plain #'org-roam-capture--get-point "%?" :file-name "%<%Y%m%d%H%M%S>-${slug}" :head "#+TITLE: ${title}" :unnarrowed t))))

(after! org-roam
  (setq org-link-frame-setup '((file . find-file-other-window))))

(setq auto-save-timeout 2)

;; Auto save directly to file
(auto-save-visited-mode t)

;; Auto saving
(defadvice evil-window-down (before other-window-now activate)
  (org-save-all-org-buffers))

(defadvice evil-window-up (before other-window-now activate)
  (org-save-all-org-buffers))

(defadvice evil-window-left (before other-window-now activate)
  (org-save-all-org-buffers))

(defadvice evil-window-right (before other-window-now activate)
  (org-save-all-org-buffers))

(defadvice +org/dwim-at-point (before other-window-now activate)
  (org-save-all-org-buffers))

(defadvice evil-switch-to-windows-last-buffer (before save-buffer-now activate)
  (org-save-all-org-buffers))

(add-hook 'focus-out-hook 'org-save-all-org-buffers)

(use-package! mixed-pitch
  :hook
  (text-mode . mixed-pitch-mode))

(use-package! org-bullets
  :hook
  (org-mode . org-bullets-mode))

(use-package! typo
  :hook
  (text-mode . typo-mode))

(setq deft-directory "~/org-roam")

(setq org-hide-emphasis-markers t)

(use-package! org-table-wrap-functions
  :load-path "~/emacs-plugins"
  :after org
  :bind
  ("C-|" . org-table-column-wrap-to-point)
  ("C->" . org-table-unwrap-cell-region))

(use-package! title-case
  :commands (xah-title-case-region-or-line)
  :load-path "~/emacs-plugins"
  :init
  (map! :leader
        :prefix "e"
        :desc "title-case" "t" #'xah-title-case-region-or-line))


;; Change cursor colors
(setq evil-normal-state-cursor '(box "#CD96CD")
      evil-insert-state-cursor '(bar "#CD96CD")
      evil-visual-state-cursor '(box "#CD96CD")
      evil-operator-state-cursor '((hbar . 9) "#CD96CD")
      evil-replace-state-cursor '(hbar "#CD96CD"))

(use-package! org-delete-link
  :commands (org-delete-link)
  :load-path  "~/emacs-plugins"
  :init
  (map! :leader
        :desc "delete-link" "aod" #'org-delete-link))


;; Turn off auto completion in org-mode
(setq company-global-modes '(not org-mode))


;; Spell checking
(use-package! ispell
  :hook
  (after-init . ispell))

(after! ispell
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US,pl_PL")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,pl_PL"))

(use-package! flyspell
  :commands (add-word-to-personal-dictionary)
  :hook
  (text-mode . flyspell-mode)
  :init
  (map! :leader
        :prefix "S"
        :desc "add-word-to-dictionary" "a" #'add-word-to-personal-dictionary))

(defun add-word-to-personal-dictionary ()
  (interactive)
  (let ((current-location (point))
        (word (flyspell-get-word)))
    (when (consp word)
      (flyspell-do-correct 'save nil (car word) current-location (cadr word) (caddr word) current-location))))

(use-package! flyspell-correct
  :commands (flyspell-correct-at-point flyspell-correct-next flyspell-correct-previous)
  :after flyspell
  :bind (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper))
  :init
  (map! :n "]S" #'flyspell-correct-next
        :n "[S" #'flyspell-correct-previous)
  (map! :leader
        :prefix "S"
        :desc "correct-word" "s" #'flyspell-correct-at-point))

(use-package! flyspell-correct-ivy
  :after flyspell-correct)


(setq doom-org-special-tags nil)

(map! :leader
      :prefix "i"
      :desc "Insert line below" "j" #'+evil/insert-newline-below
      :desc "Insert line above" "k" #'+evil/insert-newline-above)

(map! :leader
      :desc "Switch to last buffer" "TAB" #'evil-switch-to-windows-last-buffer)

(setq +zen-text-scale 0)

(use-package! writeroom
  :hook
  (org-mode . writeroom-mode)
  (nov-mode . writeroom-mode))

(setq writeroom-extra-line-spacing 0.3)

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 2) ((control) . nil)))

(setq nov-text-width t)
(add-hook 'nov-mode-hook 'visual-line-mode)
(setq nov-unzip-program "C:\\Program Files\\Unzip\\unzip.exe")

(setq org-startup-with-inline-images t)

(setq org-pretty-entities t)

(custom-set-faces!
  '(org-level-1 :foreground "#AB9BD5" :weight bold :height 1.1)
  '(org-level-2 :foreground "#BC6EC5" :weight bold :height 1.1)
  '(org-level-3 :foreground "#C77DFF" :weight bold :height 1.1)
  '(org-level-4 :foreground "#DFF6FF" :weight bold :height 1.1)
  '(org-level-5 :foreground "#AB9BD5" :weight bold :height 1.1)

  '(org-list-dt :foreground "#DFF6FF")

  '(org-link :foreground "SteelBlue1" :underline nil)

  '(org-footnote :foreground "SteelBlue1")

  '(org-document-title :inherit bold :foreground "#BC6EC5" :underline nil :height 1.4)
  '(org-meta-line :inherit org-document-info-keyword :foreground "Seashell")

  '(hl-line :background "#383341")
  '(default :background "#1D1D26")

  '(org-drawer :foreground "SkyBlue1")

  '(org-tag :foreground "#C0C5CE")
  '(org-todo :background "#32322C" :foreground "SteelBlue1" :weight bold)

  '(org-table :background "#262633" :foreground "#B2B2B2" :height 1.0 :family "Consolas")

  '(org-indent :inherit (org-hide fixed-pitch)))
