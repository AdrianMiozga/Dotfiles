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
;; + ‘doom-font’
;; + ‘oom-variable-pitch-font’
;; + ‘doom-big-font’ -- used for ‘doom-big-font-mode’; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(setq doom-font (font-spec :family "Consolas" :size 18)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set 'doom-theme' or manually load a theme with the
;; ‘load-theme’ function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to ‘nil’, line
;; numbers are disabled. For relative line numbers, set this to ‘relative’.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - ‘load!’ for loading external *.el files relative to this one
;; - ‘use-package!’ for configuring packages
;; - ‘after!’ for running code after a package has loaded
;; - ‘add-load-path!’ for adding directories to the ‘load-path’, relative to
;;   this file. Emacs searches the ‘load-path’ when you load packages with
;;   ‘require' or `use-package’.
;; - ‘map!’ for binding new keys
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

;; Don’t display hourglass cursor when Emacs is busy
(setq display-hourglass nil)

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
  :config
  (setq org-startup-folded t)
  (setq org-startup-with-inline-images t)
  (setq org-hide-emphasis-markers t)
  (setq org-pretty-entities t)
  (setq org-directory "~/org-roam/")
  (setq org-display-remote-inline-images 'skip)
  ;; Show timestamp when making task DONE
  (setq org-log-done 'time)
  ;; Show only today clock-in time for the task in modeline
  (setq org-clock-mode-line-total 'today)
  ;; Add D as another task priority
  (setq org-lowest-priority ?D)
  ;; Use C as default priority instead of B
  (setq org-default-priority ?C)
  (setq org-priority-start-cycle-with-default 'nil)
  (setq org-priority-faces '((65 . error)
                             (66 . warning)
                             (67 . success)
                             (68 :foreground "#51AFEF")))
  (setq org-ellipsis "  ")
  :hook (org-mode . doom-disable-line-numbers-h)
  :hook (org-mode . (lambda ()
                      (push '("#+TITLE: " . "") prettify-symbols-alist)
                      (push '("#+ROAM_TAGS: " . "") prettify-symbols-alist)
                      (prettify-symbols-mode))))

(use-package! org-agenda
  :defer
  :init
  (map! :prefix "C-c" "a"
        #'(lambda (&optional arg) (interactive "P")(org-agenda arg "c")))
  :config
  (defun go-to-last-clockout ()
    "Move cursor to the last clocked-in entry in agenda."
    (goto-char (point-max))
    (if (search-backward "Clocked:" nil t)
        (progn (beginning-of-line)
               (goto-char (+ (point) 7)))
      (goto-char (point-min))))

  (add-hook 'org-agenda-finalize-hook 'go-to-last-clockout)

  ;; Go further with clock report than 2 levels
  (setq org-agenda-clockreport-parameter-plist '(:link t :maxlevel 99))
  ;; Don’t show done entries
  (setq org-agenda-skip-scheduled-if-done t)
  ;; Show only clocked items. Default was clocked + closed
  (setq org-agenda-log-mode-items '(clock))
  ;; Don’t show headline tags
  (setq org-agenda-remove-tags t)
  (setq org-agenda-files '("~/org-roam/main.org"
                           "~/org-roam/todo.org"
                           "~/org-roam/getflow.org"))
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
  ;; Start agenda and calendar on Monday
  (setq org-agenda-start-on-weekday 1)
  (setq calendar-week-start-day 1)
  ;; Don’t draw weekend days in special color
  (setq org-agenda-weekend-days 'nil)
  ;; Don’t show sublevels of TODO entries
  (setq org-agenda-todo-list-sublevels 'nil)
  (setq org-agenda-start-day "+0d"))

(use-package! org-clock-convenience
  :after (org-agenda)
  :commands (org-clock-convenience-timestamp-up
             org-clock-convenience-timestamp-down
             org-clock-convenience-fill-gap
             org-clock-convenience-fill-gap-both)
  :init
  (map! :map org-agenda-mode-map
        "C-S-k" #'org-clock-convenience-timestamp-up
        "C-S-j" #'org-clock-convenience-timestamp-down
        "o" #'org-clock-convenience-fill-gap
        "C-S-o" #'org-clock-convenience-fill-gap-both)
  :config
  ;; Make this package work with my custom agenda display format
  ;; (‘org-agenda-prefix-format’) which doesn’t contain file name.
  (setq org-clock-convenience-clocked-agenda-fields
        '(d1-time d1-hours d1-minutes d2-time d2-hours d2-minutes duration))
  (setq org-clock-convenience-clocked-agenda-re
        (concat "^  \\(\\([ 	012][0-9]\\):\\([0-5][0-9]\\)\\)"
                "\\(?:-\\(\\([ 012][0-9]\\):\\([0-5][0-9]\\)\\)\\|.*\\)"
                "?[[:space:]]+Clocked:[[:space:]]+"
                "\\(([0-9]+:[0-5][0-9])\\|(-)\\)")))

(use-package! org-roam
  :commands (org-roam-insert
             org-roam-find-file
             org-roam-switch-to-buffer
             org-roam)
  :init
  (map! :leader
        :prefix "n"
        :desc "Org-roam" "l" #'org-roam
        :desc "Org-roam insert" "i" #'org-roam-insert
        :desc "Org-roam switch to buffer" "b" #'org-roam-switch-to-buffer
        :desc "Org-roam find file" "f" #'org-roam-find-file
        :desc "Org-roam insert" "i" #'org-roam-insert
        :desc "Org-roam capture" "c" #'org-roam-capture)
  :config
  (setq org-roam-directory (symbol-value 'org-directory))
  ;; Don’t delete org-roam buffer when using ‘delete-other-windows’
  (setq org-roam-buffer-window-parameters '((no-delete-other-windows . t)))
  (setq org-roam-tag-sources '(prop last-directory))
  (setq org-id-link-to-org-use-id t)
  (setq org-roam-capture-templates
        '(("d" "default" plain #'org-roam-capture--get-point "%?"
           :file-name "%<%Y%m%d%H%M%S>-${slug}"
           :head "#+TITLE: ${title}" :unnarrowed t)))
  ;; Open links in another window
  (setq org-link-frame-setup '((file . find-file-other-window))))

(use-package org-roam-bibtex
  :disabled
  :after org-roam
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (setq orb-templates
        `(("r" "ref" plain (function org-roam-capture--get-point) ""
           :file-name "${citekey}"
           :head ,(concat
                   "#+TITLE: ${title}\n"
                   "#+ROAM_KEY: ${citekey}\n\n"
                   "* Notes\n"
                   ":PROPERTIES:\n"
                   ":Custom_ID: ${citekey}\n"
                   ":NOTER_DOCUMENT: %(orb-process-file-field \"${citekey}\")\n"
                   ":END:\n")
           :unnarrowed t))))

(use-package org-ref
  :disabled
  :defer
  :init
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  (setq org-ref-default-bibliography
        (list "~/Documents/References/Zotero Library.bib"))
  :config
  (setq org-ref-get-pdf-filename-function
        'org-ref-get-pdf-filename-helm-bibtex)

  (setq org-ref-open-pdf-function 'my/org-ref-open-pdf-at-point)

  (defun my/org-ref-open-pdf-at-point ()
    "Open the pdf for bibtex key under point if it exists."
    (interactive)
    (let* ((results (org-ref-get-bibtex-key-and-file))
           (key (car results))
           (pdf-file (funcall org-ref-get-pdf-filename-function key))
           (pdf-other (bibtex-completion-find-pdf key)))
      (cond ((file-exists-p pdf-file)
             (org-open-file pdf-file))
            (pdf-other
             (org-open-file pdf-other))
            (message "No PDF found for %s" key))))

  ;; Open PDFs in default program set from OS
  (setq org-file-apps '((auto-mode . emacs)
                        (directory . emacs)
                        ("\\.mm\\'" . default)
                        ("\\.x?html?\\'" . default)
                        ("\\.pdf\\'" . system))))

(use-package! ivy-bibtex
  :disabled
  :commands (ivy-bibtex)
  :init
  (map! :leader
        :prefix "n"
        :desc "ivy-bibtex" "r" #'ivy-bibtex)
  :config
  (ivy-add-actions 'ivy-bibtex '(("n" ivy-bibtex-edit-notes "Edit notes"))))

(use-package! helm-bibtex
  :disabled
  :after ivy-bibtex
  :config
  (defun bibtex-completion-format-citation-org-ref (keys)
    "Formatter for org-ref references."
    (s-join ", " (--map (format "cite:%s" it) keys)))

  (setq bibtex-completion-format-citation-functions
        '((org-mode . bibtex-completion-format-citation-org-ref)
          (latex-mode . bibtex-completion-format-citation-cite)
          (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
          (python-mode . bibtex-completion-format-citation-sphinxcontrib-bibtex)
          (rst-mode . bibtex-completion-format-citation-sphinxcontrib-bibtex)
          (default . bibtex-completion-format-citation-default)))

  (setq ivy-bibtex-default-action 'ivy-bibtex-insert-citation)
  (setq bibtex-completion-pdf-field "File")
  (setq bibtex-completion-display-formats
        '((t . "${title:*} ${author:36} ${year:4} \
                ${=has-pdf=:1}${=has-note=:1} ${=type=:12}")))
  (setq bibtex-completion-library-path '("~/Documents/References/"))
  (setq bibtex-completion-bibliography
        '("~/Documents/References/Zotero Library.bib")))

(use-package! mixed-pitch
  :hook (text-mode . mixed-pitch-mode))

(use-package! org-superstar
   :hook (org-mode . org-superstar-mode)
   :config
   (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "◆")))

(use-package! org-pomodoro
  :defer
  :config
  (setq org-pomodoro-format "%s")
  (setq org-pomodoro-short-break-format "Short Break: %s")
  (setq org-pomodoro-long-break-format "Long Break: %s")
  (setq org-pomodoro-keep-killed-pomodoro-time t)
  (setq org-pomodoro-manual-break t)

  (defun org-pomodoro-prompt ()
    (interactive)
    (org-clock-goto)
    (if (y-or-n-p "Start a new pomodoro?")
        (progn
          (org-pomodoro))))

  (add-hook 'org-pomodoro-break-finished-hook 'org-pomodoro-prompt))

(use-package! typo
  :hook (text-mode . typo-mode)
  :init
  (typo-global-mode 1))

(use-package! deft
  :defer
  :config
  (setq deft-directory (symbol-value 'org-directory)))

(use-package! org-table-wrap-functions
  :after org
  :bind
  ("C-|" . org-table-column-wrap-to-point)
  ("C->" . org-table-unwrap-cell-region))

(use-package! title-capitalization
  :commands (title-capitalization)
  :init
  (map! :leader
        :prefix "e"
        :desc "title-case" "t" #'title-capitalization))

;; Turn off auto completion in org-mode
(use-package! company
  :defer
  :config
  (setq company-global-modes '(not org-mode)))

;; Spell checking
(use-package! ispell
  :config
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US,pl_PL")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,pl_PL"))

(use-package! flyspell
  :commands (add-word-to-personal-dictionary)
  :hook (text-mode . flyspell-mode)
  :init
  (map! :leader
        :prefix "S"
        :desc "add-word-to-dictionary" "a" #'add-word-to-personal-dictionary)
  :config
  (defun add-word-to-personal-dictionary ()
    (interactive)
    (let ((current-location (point))
          (word (flyspell-get-word)))
      (when (consp word)
        (flyspell-do-correct 'save nil (car word) current-location
                             (cadr word) (caddr word) current-location)))))

(use-package! flyspell-correct
  :commands (flyspell-correct-at-point
             flyspell-correct-next
             flyspell-correct-previous)
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

(use-package! pdf-tools
  :defer
  :config
  (setq pdf-view-resize-factor 1.1))

(use-package! nov
  :config
  (setq nov-text-width t)
  (setq nov-unzip-program "C:\\Program Files\\Unzip\\unzip.exe")
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
  (setq writeroom-mode-line t)
  (setq writeroom-extra-line-spacing 0.3)
  (setq +zen-text-scale 0))

(use-package! go-translate
  :commands (go-translate)
  :init
  (map! :leader
        :prefix "s"
        :desc "Google Translate" "g" #'go-translate)
  :config
  (setq go-translate-local-language "pl")
  (setq go-translate-target-language "en")
  (setq go-translate-buffer-follow-p t)
  (setq go-translate-token-current (cons 430675 2721866130)))

(use-package server
  :defer
  :config
  (server-start))

(use-package! evil
  :commands (evil-insert)
  :init
  (map! "C-S-i" #'evil-insert)
  :config
  ;; Change cursor colors
  (setq evil-normal-state-cursor '(box "#CD96CD"))
  (setq evil-insert-state-cursor '(bar "#CD96CD"))
  (setq evil-visual-state-cursor '(box "#CD96CD"))
  (setq evil-operator-state-cursor '((hbar . 9) "#CD96CD"))
  (setq evil-replace-state-cursor '(hbar "#CD96CD")))

(use-package! doom-modeline
  :defer
  :config
  (setq doom-modeline-column-zero-based nil))


(use-package! evil-multiedit
  :defer
  :config
  (setq evil-multiedit-follow-matches t))


(custom-set-faces!
  '(org-level-1 :foreground "#AB9BD5" :weight bold :height 1.1)
  '(org-level-2 :foreground "#BC6EC5" :weight bold :height 1.1)
  '(org-level-3 :foreground "#C77DFF" :weight bold :height 1.1)
  '(org-level-4 :foreground "#DFF6FF" :weight bold :height 1.1)
  '(org-level-5 :foreground "#AB9BD5" :weight bold :height 1.1)

  '(org-list-dt :foreground "#DFF6FF")

  '(org-link :foreground "SteelBlue1" :underline nil)

  '(org-footnote :foreground "SteelBlue1")

  '(org-document-title :inherit bold :foreground "#BC6EC5"
                       :underline nil :height 1.4)
  '(org-meta-line :inherit org-document-info-keyword :foreground "Seashell")

  '(org-ref-cite-face :foreground "SteelBlue1" :weight bold)

  '(hl-line :background "#383341")
  '(default :background "#1D1D26")

  '(org-drawer :foreground "SkyBlue1")

  '(org-tag :foreground "#C0C5CE")
  '(org-todo :background "#32322C" :foreground "SteelBlue1" :weight bold)

  '(org-table :background "#262633" :foreground "#BBC2CF"
              :height 1.0 :family "Consolas")

  '(org-indent :inherit (org-hide fixed-pitch))

  ;; :foreground nil makes ellipsis color same as the heading
  '(org-ellipsis :foreground nil :height 120)

  ;; Agenda
  '(org-agenda-done :foreground "#AB9BD5") ;; Done tasks + clocked items
  '(org-agenda-current-time :foreground "#BC6EC5")
  '(org-time-grid :foreground "#BBC2CF")
  '(org-agenda-dimmed-todo-face :foreground "#BBC2CF")
  '(org-upcoming-distant-deadline :foreground "#BBC2CF")
  '(org-upcoming-deadline :foreground "#BBC2CF")
  '(org-scheduled-today :foreground "#BBC2CF")
  '(org-warning :foreground "#FF6C6B")) ;; Deadline color
