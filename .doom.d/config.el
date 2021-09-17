;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Consolas" :size 18)
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
  :hook (org-agenda-mode . org-super-agenda-mode)
  :init
  (map! :prefix "C-c" "a"
        #'(lambda (&optional arg) (interactive "P")(org-agenda arg "c")))
  :config
  ;; Without this, when the cursor is on a org-super-agenda heading, I can’t
  ;; use j/k to move up and down. This is rather a workaround, as now I can’t
  ;; use q to exit the agenda when the cursor is on the aforementioned heading.
  (setq org-super-agenda-header-map (make-sparse-keymap))

  (defun go-to-last-clockout ()
    "Move cursor to the last clocked-in entry in agenda."
    (goto-char (point-max))
    (if (search-backward "Clocked:" nil t)
        (progn (beginning-of-line)
               (goto-char (+ (point) 7)))
      (goto-char (point-min))))

  (add-hook 'org-agenda-finalize-hook 'go-to-last-clockout)

  ;; Hide mode line in org-agenda
  (add-hook 'org-agenda-finalize-hook #'hide-mode-line-mode)

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
            ;; Show all TODOs under agenda and group them based on file they are
            ;; in.
            (alltodo "" ((org-super-agenda-groups
                          '((:name "Music" :tag "music" :order 5)
                            (:name "GetFlow" :file-path "getflow" :order 4)
                            (:name "Programming" :tag "programming" :order 3)
                            (:name "University" :tag "university" :order 2)
                            (:name "General" :file-path "main" :order 1)
                            (:auto-category t :order 100)))))))
          ("d" "Incomplete deadlines"
           agenda "" ((org-agenda-span 'month)
                      (org-agenda-time-grid nil)
                      (org-agenda-show-all-dates nil)
                      (org-agenda-skip-deadline-if-done t)
                      (org-agenda-entry-types '(:deadline))
                      (org-deadline-warning-days 0)))))

  ;; Don’t show TODOs in org-agenda to-do list when they have specified date.
  ;; That means scheduled TODOs or ones with a deadline will not be shown.
  (setq org-agenda-todo-ignore-with-date t)
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
  ;; Don’t show modeline in org-roam buffer
  (add-hook 'org-roam-buffer-prepare-hook #'hide-mode-line-mode)
  ;; Open links in another window
  (setq org-link-frame-setup '((file . find-file-other-window))))

(use-package! mixed-pitch
  :hook (text-mode . mixed-pitch-mode)
  :init
  (map! :leader
        :prefix "t"
        :desc "Mixed pitch mode" "m" #'mixed-pitch-mode))

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
  :hook (prog-mode . flyspell-prog-mode)
  :init
  (map! :leader
        :prefix "S"
        :desc "add-word-to-dictionary" "a" #'add-word-to-personal-dictionary)
  (map! :leader
        :prefix "t"
        :desc "Spell checking" "s" #'toggle-spell-check)
  :config
  (defun add-word-to-personal-dictionary ()
    (interactive)
    (let ((current-location (point))
          (word (flyspell-get-word)))
      (when (consp word)
        (flyspell-do-correct 'save nil (car word) current-location
                             (cadr word) (caddr word) current-location))))

  (defun toggle-spell-check ()
    (interactive
     (if (symbol-value 'flyspell-mode)
         (call-interactively 'flyspell-mode)
       (progn (call-interactively 'flyspell-prog-mode)
              (flyspell-buffer))))))

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

(use-package! whitespace
  :commands (whitespace-toggle-options)
  :init
  (map! :leader
        :prefix "t"
        :desc "Whitespace options" "W" #'whitespace-toggle-options)
  :config
  (defun my-update (column)
    "Keep ‘whitespace-line-column’ in sync with ‘set-fill-column’."
    (setq whitespace-line-column column))

  (advice-add 'set-fill-column :after 'my-update)

  (setq whitespace-line-column (symbol-value 'fill-column)))

(use-package! display-fill-column-indicator
  ;; Show fill column indicator but only in prog-mode
  :hook (prog-mode . display-fill-column-indicator-mode)
  :init
  (remove-hook! 'text-mode-hook '+fill-column-enable-h))

(use-package! writeroom
  :hook
  (org-mode . writeroom-mode)
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

  '(font-lock-comment-face :foreground "#83898d")

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
