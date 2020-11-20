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

;; Auto save after 2 seconds of idle
(setq auto-save-timeout 2)

;; Change scroll amount
(setq mouse-wheel-scroll-amount '(1 ((shift) . 2) ((control) . nil)))

(map! :leader
      :prefix "i"
      :desc "Insert line below" "j" #'+evil/insert-newline-below
      :desc "Insert line above" "k" #'+evil/insert-newline-above)

(map! :leader
      :desc "Switch to last buffer" "TAB" #'evil-switch-to-windows-last-buffer)

(setq doom-org-special-tags nil)

(use-package! org
  :init
  (setq org-startup-folded t)
  (setq org-startup-with-inline-images t)
  (setq org-hide-emphasis-markers t)
  (setq org-pretty-entities t)
  (setq org-directory "~/org-roam/")
  :config
  (setq org-display-remote-inline-images 'skip)
  :hook (org-mode . doom-disable-line-numbers-h)
  :hook (org-mode . (lambda ()
                      (push '("#+TITLE: " . "") prettify-symbols-alist)
                      (push '("#+ROAM_TAGS: " . "") prettify-symbols-alist)
                      (prettify-symbols-mode))))

(use-package! org-agenda
  :init
  (map! :prefix "C-c" "a" #'(lambda (&optional arg) (interactive "P")(org-agenda arg "c")))
  ;; Start agenda and calendar on Monday
  (setq org-agenda-start-on-weekday 1)
  (setq calendar-week-start-day 1)
  ;; Don't draw weekend days in special color
  (setq org-agenda-weekend-days 'nil)
  ;; Don't show sublevels of TODO entries
  (setq org-agenda-todo-list-sublevels 'nil)
  ;; Show timestamp when making task DONE
  (setq org-log-done 'time)
  ;; Add D as another task priority
  (setq org-lowest-priority ?D)
  ;; Use C as default priority instead of B
  (setq org-default-priority ?C)
  (setq org-priority-start-cycle-with-default 'nil)
  ;; Go further with clock report than 2 levels
  (setq org-agenda-clockreport-parameter-plist '(:link t :maxlevel 99))
  ;; Don't show done entries
  (setq org-agenda-skip-scheduled-if-done t)
  ;; Show only clocked items. Default was clocked + closed
  (setq org-agenda-log-mode-items '(clock))
  (setq org-agenda-files '("~/org-roam/main.org" "~/org-roam/todo.org"))
  (setq org-agenda-prefix-format '((agenda . " %i %?-12t% s")
                                   (todo . " %i ")
                                   (tags . " %i ")
                                   (search . " %i ")))
  (setq org-agenda-custom-commands
        '(("c" "Agenda + TODO"
           ((agenda "" ((org-agenda-span 'day)
                        (org-agenda-show-log t)
                        (org-agenda-skip-deadline-if-done t)
                        (org-agenda-time-grid nil)))
            (alltodo "")))
          ("d" "Incomplete deadlines"
           agenda "" ((org-agenda-span 'month)
                      (org-agenda-time-grid nil)
                      (org-agenda-show-all-dates nil)
                      (org-agenda-skip-deadline-if-done t)
                      (org-agenda-entry-types '(:deadline))
                      (org-deadline-warning-days 0)))))
  :config
  (setq org-priority-faces '((65 . error)
                             (66 . warning)
                             (67 . success)
                             (68 :foreground "#51AFEF")))
  (setq org-agenda-start-day "+0d"))

(use-package! org-roam
  :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
  :hook (after-init . org-roam-mode)
  :init
  (map! :leader
        :prefix "n"
        :desc "Org-roam" "l" #'org-roam
        :desc "Org-roam insert" "i" #'org-roam-insert
        :desc "Org-roam switch to buffer" "b" #'org-roam-switch-to-buffer
        :desc "Org-roam find file" "f" #'org-roam-find-file
        :desc "Org-roam insert" "i" #'org-roam-insert
        :desc "Org-roam capture" "c" #'org-roam-capture)
  (setq org-roam-directory (file-truename "~/org-roam/"))
  (setq org-roam-db-gc-threshold most-positive-fixnum)
  (setq org-roam-tag-sources '(prop last-directory))
  (setq org-id-link-to-org-use-id t)
  (setq org-roam-capture-templates
        '(("d" "default" plain #'org-roam-capture--get-point "%?"
           :file-name "%<%Y%m%d%H%M%S>-${slug}"
           :head "#+TITLE: ${title}" :unnarrowed t)))
  (after! org-roam
    (setq org-link-frame-setup '((file . find-file-other-window)))))

(use-package! mixed-pitch
  :hook (text-mode . mixed-pitch-mode))

(use-package! org-bullets
  :init
  (setq org-bullets-bullet-list '("◉" "○" "✸" "◆"))
  :hook (org-mode . org-bullets-mode))

(use-package! typo
  :hook (text-mode . typo-mode))

(use-package! deft
  :init
  (setq deft-directory "~/org-roam"))

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

(use-package! org-delete-link
  :commands (org-delete-link)
  :load-path  "~/emacs-plugins"
  :init
  (map! :leader
        :desc "delete-link" "aod" #'org-delete-link))

;; Turn off auto completion in org-mode
(use-package! company
  :init
  (setq company-global-modes '(not org-mode)))

;; Spell checking
(use-package! ispell
  :hook
  (after-init . ispell)
  :config
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

(use-package! nov
  :init
  (setq nov-text-width t)
  (setq nov-unzip-program "C:\\Program Files\\Unzip\\unzip.exe")
  :config
  (unbind-key "i" nov-mode-map)
  (unbind-key "<normal-state> i" nov-mode-map)
  :hook (nov-mode . visual-line-mode)
  :mode ("\\.\\(epub\\|mobi\\)\\'" . nov-mode))

(use-package! writeroom
  :hook
  (org-mode . writeroom-mode)
  (nov-mode . writeroom-mode)
  (org-agenda-mode . writeroom-mode)
  :init
  (setq writeroom-extra-line-spacing 0.3)
  (setq +zen-text-scale 0))

(require 'google-translate)
(defun google-translate--search-tkk () "Search TKK." (list 430675 2721866130))
(setq google-translate-backend-method 'curl)

(use-package! google-translate
  :commands (google-translate-query-translate google-translate-query-translate-reverse)
  :init
  (setq google-translate-default-source-language "en")
  (setq google-translate-default-target-language "pl")
  (setq google-translate-pop-up-buffer-set-focus t)
  (map! :leader
        :prefix "s"
        "g" #'google-translate-query-translate
        "G" #'google-translate-query-translate-reverse))

(use-package! translate-operator
  :load-path "~/emacs-plugins"
  :after google-translate)

;; Change cursor colors
(setq evil-normal-state-cursor '(box "#CD96CD")
      evil-insert-state-cursor '(bar "#CD96CD")
      evil-visual-state-cursor '(box "#CD96CD")
      evil-operator-state-cursor '((hbar . 9) "#CD96CD")
      evil-replace-state-cursor '(hbar "#CD96CD"))

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
