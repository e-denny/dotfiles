;;; package --- .emacs
;;; Commentary:

;;; Code:
(require 'package)
(setq package-archives
             '(("gnu" . "https://elpa.gnu.org/packages/")
               ("melpa" . "https://melpa.org/packages/")
               ; ("melpa-stable" . "https://stable.melpa.org/packages/")
               ))
(package-initialize)

(blink-cursor-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(show-paren-mode 1)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8)
(setq history-length t)
(setq history-delete-duplicates t)
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq-default tab-always-indent 'complete)
(setq initial-scratch-message "")
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(add-to-list 'default-frame-alist '(internal-border-width . 7))
(column-number-mode 1)
(global-display-line-numbers-mode)

;; smooth scrolling
(setq
  scroll-margin 2
  scroll-conservatively 10000
  scroll-conservatively scroll-margin
  scroll-step 1
  mouse-wheel-scroll-amount '(6 ((shift) . 1))
  mouse-wheel-progressive-speed nil
  scroll-preserve-screen-position t
  scroll-error-top-bottom t
  next-error-recenter (quote (4))
  fast-but-imprecise-scrolling nil
  jit-lock-defer-time 0)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(add-to-list 'load-path "~/.emacs.d/lisp/")

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
    backup-by-copying t    ; Don't delink hardlinks
    version-control t      ; Use version numbers on backups
    delete-old-versions t  ; Automatically delete excess backups
    kept-new-versions 20   ; how many of the newest versions to keep
    kept-old-versions 5    ; and how many of the old
    )

(use-package diminish
  :ensure t)

(use-package fringe
  :commands fringe-mode
  :config
  (set-fringe-mode '(8 . 0)))

(use-package which-key
  :ensure t
  :diminish t
  :config
  (which-key-mode +1))

(use-package neotree
  :ensure t
  :bind ("C-c t" . neotree-toggle))

(use-package flycheck
  :ensure t
  :diminish "✓"
  :commands global-flycheck-mode
  :init (add-hook 'prog-mode-hook 'global-flycheck-mode)
  :config
  (progn
    (setq-default flycheck-emacs-lisp-initialize-packages t
                  flycheck-highlighting-mode 'lines
                  flycheck-check-syntax-automatically '(save)
                  flycheck-disabled-checkers '(c/c++-clang c/c++-gcc))
     ;; Define fringe indicator / warning levels
    (define-fringe-bitmap 'flycheck-fringe-bitmap-ball
      (vector #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00011100
              #b00111110
              #b00111110
              #b00111110
              #b00011100
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000))
    (flycheck-define-error-level 'error
      :severity 2
      :overlay-category 'flycheck-error-overlay
      :fringe-bitmap 'flycheck-fringe-bitmap-ball
      :fringe-face 'flycheck-fringe-error)
    (flycheck-define-error-level 'warning
      :severity 1
      :overlay-category 'flycheck-warning-overlay
      :fringe-bitmap 'flycheck-fringe-bitmap-ball
      :fringe-face 'flycheck-fringe-warning)
    (flycheck-define-error-level 'info
      :severity 0
      :overlay-category 'flycheck-info-overlay
      :fringe-bitmap 'flycheck-fringe-bitmap-ball
      :fringe-face 'flycheck-fringe-info)
    (custom-set-variables
     '(flycheck-python-flake8-executable "python3")
     '(flycheck-python-pycompile-executable "python3")
     '(flycheck-python-pylint-executable "python3"))))

(use-package magit
  :ensure t
  :bind ("C-c m" . magit-status))

(use-package git-gutter
  :ensure t
  :diminish git-gutter-mode
  :init
  (progn
    (setq git-gutter:separator-sign " "
          git-gutter:lighter " GG"))
  :config
  (progn
    (set-face-background 'git-gutter:deleted "#990A1B")
    (set-face-foreground 'git-gutter:deleted "#990A1B")
    (set-face-background 'git-gutter:modified "#00736F")
    (set-face-foreground 'git-gutter:modified "#00736F")
    (set-face-background 'git-gutter:added "#546E00")
    (set-face-foreground 'git-gutter:added "#546E00")
    (global-git-gutter-mode 't))
  :bind (("C-x p" . git-gutter:previous-hunk)
         ("C-x n" . git-gutter:next-hunk)
         ("C-x v =" . git-gutter:popup-hunk)
         ("C-x v r" . git-gutter:revert-hunk)))

(use-package projectile
  :ensure t
  :config
  (projectile-mode))

(use-package company
  :ensure t
  :defer t
  :bind ("C-<tab>" . company-complete)
  :init (global-company-mode)
  :config
  (progn
    (bind-key [remap completion-at-point] #'company-complete company-mode-map)
    (setq company-tooltip-align-annotations t
          company-show-numbers t
          company-idle-delay 3
          company-minimum-prefix-length 3)
    (setq company-dabbrev-downcase nil))
  :diminish company-mode)

(use-package yasnippet
      :ensure t
      :diminish yas-minor-mode
      :config
      (add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets")
      (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
      (yas-global-mode)
      (global-set-key (kbd "M-/") 'company-yasnippet))

(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  (require 'lsp-clients)
  (setq lsp-auto-guess-root t
        lsp-prefer-flymake nil)
  :hook (prog-mode .lsp))

(use-package lsp-ui
  :ensure t
  :hook ((lsp-mode . lsp-ui-mode)
	 (lsp-after-open . (lambda ()
                             (lsp-ui-flycheck-enable 1))))
  :config
  (progn (require 'lsp-ui-flycheck)
         (setq lsp-ui-sideline-show-hover nil)
         (add-hook 'lsp-mode-hook 'lsp-ui-mode))
  :bind (:map lsp-ui-mode-map
	      ("C-c r ." . lsp-ui-peek-find-definitions)
	      ("C-c r ?" . lsp-ui-peek-find-references)
	      ("C-c r d" . lsp-ui-peek-find-definitions)
	      ("C-c r r" . lsp-ui-peek-find-references)
	      ("C-c r F" . lsp-ui-sideline-apply-code-actions)
              ("C-c r R" . lsp-rename)))

(use-package company-lsp
  :ensure t
  :commands company-lsp
  :after company lsp-mode
  :config
  (push 'company-lsp company-backends)
  (setq company-lsp-async t
        company-lsp-cache-candidates 'auto
        company-lsp-enable-recompletion t))

(use-package dap-mode
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))

(use-package markdown-mode
    :ensure t
    :commands (markdown-mode gfm-mode)
    :mode (("README\\.md\\'" . gfm-mode)
           ("\\.md\\'" . markdown-mode)
           ("\\.markdown\\'" . markdown-mode))
    :init (setq markdown-command "multimarkdown"))

(use-package gruvbox-theme
  :ensure t)

(load-theme 'gruvbox-dark-soft t)

(use-package exwm
  :ensure t
  :config
  (require 'exwm-config)
  (server-start)

  (unless (get 'exwm-workspace-number 'saved-value)
    (setq exwm-workspace-number 4))
  ;; Make class name the buffer name
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))
  (add-hook 'exwm-update-title-hook
            (lambda ()
              (when (or (not exwm-instance-name)
                        (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "gimp" exwm-instance-name))
                (exwm-workspace-rename-buffer exwm-title))))
    ;; Global keybindings.
  (unless (get 'exwm-input-global-keys 'saved-value)
    (setq exwm-input-global-keys
          `(
            ([?\s-r] . exwm-reset)
            ([?\s-w] . exwm-workspace-switch)
            ;; 's-&': Launch application.
            ([?\s-&] . (lambda (command)
		         (interactive (list (read-shell-command "$ ")))
		         (start-process-shell-command command nil command)))
            ;; 's-N': Switch to certain workspace.
            ,@(mapcar (lambda (i)
                        `(,(kbd (format "s-%d" i)) .
                          (lambda ()
                            (interactive)
                            (exwm-workspace-switch-create ,i))))
		      (number-sequence 0 9)))))

  (unless (get 'exwm-input-simulation-keys 'saved-value)
    (setq exwm-input-simulation-keys
          '(
            ;; movement
            ([?\C-b] . [left])
            ([?\M-b] . [C-left])
            ([?\C-f] . [right])
            ([?\M-f] . [C-right])
            ([?\C-p] . [up])    
            ([?\C-n] . [down])
            ([?\C-a] . [home])
            ([?\C-e] . [end])
            ([?\M-v] . [prior])
            ([?\C-v] . [next])
            ([?\C-d] . [delete])
            ([?\C-k] . [S-end delete])
            ;; cut/paste.
            ([?\C-w] . [?\C-x])
            ([?\M-w] . [?\C-c])
            ([?\C-y] . [?\C-v])
            ;; search
            ([?\C-s] . [?\C-f]))))

  (setq save-interprogram-paste-before-kill t)
  (exwm-enable)
  (exwm-config-ido)
  (exwm-config-misc)

  (defun my-change-screen-hook ()
  (let ((xrandr-output-regexp "\n\\([^ ]+\\) connected ")
        default-output)
    (with-temp-buffer
      (call-process "xrandr" nil t nil)
      (goto-char (point-min))
      (re-search-forward xrandr-output-regexp nil 'noerror)
      (setq default-output (match-string 1))
      (forward-line)
      (if (not (re-search-forward xrandr-output-regexp nil 'noerror))
          (call-process "xrandr" nil nil nil "--output" default-output "--auto")
        (call-process
         "xrandr" nil nil nil
         "--output" (match-string 1) "--primary" "--auto"
         "--output" default-output "--off")
        (setq exwm-randr-workspace-output-plist (list 0 (match-string 1)))))))

  (require 'exwm-randr)
  (setq exwm-randr-workspace-output-plist '(0 "eDP-1" 1 "DP-1"))
  (add-hook 'exwm-randr-screen-change-hook 'my-change-screen-hook)
  (exwm-randr-enable))

(use-package savehist
  :init
  (progn
    (setq savehist-file "~/.emacs.d/savehist")
    (setq savehist-save-minibuffer-history 1)
    (setq savehist-additional-variables
          '(kill-ring
            search-ring
            regexp-search-ring))
    (savehist-mode 1)))

(use-package eshell
  :init
  (add-hook 'eshell-mode-hook
	    (lambda ()
	      (eshell/alias "e" "find-file $1")
	      (eshell/alias "ll" "ls -ltra --color=always")
	      (eshell/alias "d" "dired $1"))))

(use-package helm
  :ensure t
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100)
    (setq helm-idle-delay 0.0
          helm-input-idle-delay 0.01
          helm-yas-display-key-on-candidate t
          helm-quick-update t
          helm-buffers-fuzzy-matching t
          helm-split-window-inside-p t
          helm-autoresize-min-height 20
          helm-autoresize-max-height 40
          helm-M-x-requires-pattern nil
          helm-ff-file-name-history-use-recentf t
          helm-move-to-line-cycle-in-source t
          helm-ff-skip-boring-files t)
;    (helm-autoresize-mode 1)
    (helm-mode))
  :bind (("C-c h" . helm-mini)
         ("C-h a" . helm-apropos)
         ("C-x C-b" . helm-buffers-list)
	 ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x c o" . helm-occur)
         ("C-x c s" . helm-swoop)
         ("C-x c y" . helm-yas-complete)
         ("C-x c Y" . helm-yas-create-snippet-on-region)
         ("C-x c SPC" . helm-all-mark-rings)))

(ido-mode -1)

(use-package helm-descbinds
  :defer t
  :bind (("C-h b" . helm-descbinds)
         ("C-h w" . helm-descbinds)))

(use-package helm-swoop
 :bind
 (("C-S-s" . helm-swoop)
  ("M-i" . helm-swoop)
  ("M-s s" . helm-swoop)
  ("M-s M-s" . helm-swoop)
  ("M-I" . helm-swoop-back-to-last-point)
  ("C-c M-i" . helm-multi-swoop)
  ("C-x M-i" . helm-multi-swoop-all))
 :config
 (progn
   (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
   (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)))

(use-package winum
  :ensure t
  :init
  (setq-default winum-keymap nil)
  :config
  (winum-mode))

(use-package windmove
  :config
  (windmove-default-keybindings))

(use-package recentf
  :init
  (progn
    (setq recentf-max-saved-items 200
          recentf-max-menu-items 15)
    (recentf-mode 1))
  :bind
  ("C-c f r" . recentf-files-open))

(bind-key "M-/" 'hippie-expand)

(use-package eldoc
  :diminish eldoc-mode
  :commands turn-on-eldoc-mode
  :defer t
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
    (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
    (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)))

(use-package paredit
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'paredit-mode)
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode))

(use-package rainbow-delimiters
  :ensure t
  :init
  (progn
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)))

(use-package spaceline
  :ensure t
  :init
  (setq powerline-default-separator 'arrow-fade)
  :config
  (progn (require 'spaceline-config)
	 (spaceline-spacemacs-theme)
	 (spaceline-helm-mode)))

(use-package highlight-parentheses
  :ensure t
  :diminish highlight-parentheses-mode
  :config
  (progn
    (set-face-attribute 'hl-paren-face nil :weight 'ultra-bold)
    (set-face-attribute 'hl-paren-face nil :background "gray25")
    (global-highlight-parentheses-mode)
    ;;make paren highlight update after stuff like paredit changes
    (add-to-list 'after-change-functions '(lambda (&rest x) (hl-paren-highlight)))))

(use-package free-keys
  :commands (free-keys)
  :bind ("C-~" . free-keys))

(use-package rainbow-mode
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-mode))

(use-package sx
    :ensure t
    :config
    (bind-keys :prefix "C-c s"
               :prefix-map my-sx-map
               :prefix-docstring "Global keymap for SX."
               ("q" . sx-tab-all-questions)
               ("i" . sx-inbox)
               ("o" . sx-open-link)
               ("u" . sx-tab-unanswered-my-tags)
               ("a" . sx-ask)
               ("s" . sx-search)))

(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb)
         ("C-c C-w" . org-refile)
         ("C-c j" . org-clock-goto)
         ("C-c C-x C-o" . org-clock-out))
  :config
  (progn
    ;; The GTD part of this config is heavily inspired by
    ;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
    (setq org-directory "~/org")
    (setq org-agenda-files
          (mapcar (lambda (path) (concat org-directory path))
                  '("/org.org"
                    "/gtd/gtd.org"
                    "/gtd/inbox.org"
                    "/gtd/tickler.org")))
    (setq org-log-done 'time)
    (setq org-src-fontify-natively t)
    (setq org-use-speed-commands t)
    (setq org-capture-templates
          '(("t" "Todo [inbox]" entry
             (file+headline "~/org/gtd/inbox.org" "Tasks")
             "* TODO %i%?")
            ("T" "Tickler" entry
             (file+headline "~/org/gtd/tickler.org" "Tickler")
             "* %i%? \n %^t")))
    (setq org-refile-targets
          '(("~/org/gtd/gtd.org" :maxlevel . 3)
            ("~/org/gtd/someday.org" :level . 1)
            ("~/org/gtd/tickler.org" :maxlevel . 2)))
    (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
    (setq org-agenda-custom-commands
          '(("@" "Contexts"
             ((tags-todo "@email"
                         ((org-agenda-overriding-header "Emails")))
              (tags-todo "@phone"
                         ((org-agenda-overriding-header "Phone")))))))
    (setq org-clock-persist t)
    (org-clock-persistence-insinuate)
    (setq org-time-clocksum-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))))

;; (use-package-core org-inlinetask
;;                   :bind (:map org-mode-map
;;                               ("C-c C-x t" . org-inlinetask-insert-task))
;;   :after (org)
;;   :commands (org-inlinetask-insert-task))

(use-package org-bullets
  :ensure t
  :commands (org-bullets-mode)
  :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(provide '.emacs)
;;; .emacs ends here
