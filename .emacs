;;; package --- .emacs  -*- lexical-binding: t -*-
;;; Commentary:



;;; Code:
(require 'package)
(setq package-archives
             '(("gnu" . "https://elpa.gnu.org/packages/")
               ("melpa" . "https://melpa.org/packages/")
               ; ("melpa-stable" . "https://stable.melpa.org/packages/")
               ))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

(setq package-enable-at-startup nil
      message-log-max 16384
      gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      auto-window-vscroll nil)

(add-hook 'after-init-hook
          `(lambda ()
             (setq gc-cons-threshold 800000
                   gc-cons-percentage 0.1)
             (garbage-collect)) t)

;; start maximized
;; (setq frame-resize-pixelwise t
;;       x-frame-normalize-before-maximize t)
(add-to-list 'initial-frame-alist '(fullscreen . fullheight))

(blink-cursor-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(show-paren-mode 1)
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
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

;; save place -- move to the place I was last time I visited this file
(save-place-mode t)

(defadvice load-theme (before clear-previous-themes activate)
  "Clear existing theme settings instead of layering them."
  (mapc #'disable-theme custom-enabled-themes))

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

; don't load old bype code
(setq load-prefer-newer t)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)

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
  :diminish which-key-mode
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
    (flycheck-define-error-level 'infoq
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
    (add-hook 'prog-mode-hook 'git-gutter-mode)
    (add-hook 'org-mode-hook 'git-gutter-mode))
  :config
  (progn
    (custom-set-variables
     '(git-gutter:modified-sign ">")
     '(git-gutter:added-sign "+")
     '(git-gutter:deleted-sign "-"))
    (set-face-foreground 'git-gutter:deleted "#990A1B")
    (set-face-foreground 'git-gutter:modified "#00736F")
    (set-face-foreground 'git-gutter:added "#546E00")
    (set-face-background 'git-gutter:modified "none")
    (set-face-background 'git-gutter:added "none")
    (set-face-background 'git-gutter:deleted "none"))
  :bind (("C-x p" . git-gutter:previous-hunk)
         ("C-x n" . git-gutter:next-hunk)
         ("C-x v =" . git-gutter:popup-hunk)
         ("C-x v r" . git-gutter:revert-hunk)))

(use-package projectile
  :ensure t
  :config
  (defun projectile-short-mode-line ()
    "Short version of the default projectile mode line."
    (format " P[%s]" (projectile-project-name)))
  (setq projectile-mode-line-function 'projectile-short-mode-line)
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
    (setq company-dabbrev-downcase nil)
    (let ((map company-active-map))
      (define-key map (kbd "TAB") 'company-complete-selection)
      (define-key map (kbd "C-/") 'company-search-candidates)
      (define-key map (kbd "C-M-/") 'company-filter-candidates)
      (define-key map (kbd "C-d") 'company-show-doc-buffer)))
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

(use-package dashboard
  :diminish
  (dashboard-mode page-break-lines-mode)
  :custom
  (dashboard-center-content t)
;  (dashboard-startup-banner 4)
  (dashboard-items '((recents . 15)
                     (projects . 5)
                     (bookmarks . 5)))
  :custom-face
  (dashboard-heading ((t (:foreground "#f1fa8c" :weight bold))))
  :hook
  (after-init . dashboard-setup-startup-hook))
 
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

;; (use-package leuven-theme
;;   :ensure t)
;; (load-theme 'leuven t)

;; (use-package zenburn-theme
;;   :ensure t)
;; (load-theme 'zenburn t)

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
            (lambda () (exwm-workspace-rename-buffer exwm-title)))
  (add-hook 'exwm-exit-hook
            (lambda ()
              (shell-command "killall xfce-session")))
    ;; Global keybindings.
  (unless (get 'exwm-input-global-keys 'saved-value)
    (setq exwm-input-global-keys
          `(
            ([?\s-r] . exwm-reset)
            ([?\s-w] . exwm-workspace-switch)
            ;; Launch application.
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
  (exwm-input-set-key (kbd "s-<left>") #'windmove-left)
  (exwm-input-set-key (kbd "s-<down>") #'windmove-down)
  (exwm-input-set-key (kbd "s-<up>") #'windmove-up)
  (exwm-input-set-key (kbd "s-<right>") #'windmove-right)
  (exwm-input-set-key (kbd "s-t") #'exwm-floating-toggle-floating)
  ;; Firefox: open everything in new windows
  ;; 1: about:config -> browser.tabs.opentabfor.middleclick -> false
  ;; 2: place the following in chrome/userChrome.css in your FF profile:
  ;;    #tabbrowser-tabs { visibility: collapse !important; }
  (unless (get 'exwm-input-simulation-keys 'saved-value)
    (setq exwm-input-simulation-keys
          '(
            ;; movement - firefox
            ([?\C-b] . [left])
            ; ([?\M-b] . [C-left])
            ([?\C-f] . [right])
            ; ([?\M-f] . [C-right])
            ([?\C-p] . [up])
            ([?\C-n] . [down])
            ([?\C-a] . [home]) ; top of page
            ([?\C-e] . [end]) ; bottom of page
            ([?\M-v] . [prior])
            ([?\C-v] . [next])
            ([?\C-d] . [delete])
            ([?\C-k] . [S-end delete])
            ;; ([?\M-b] . [?\M-left]) ; back to previous page
            ;; ([?\M-f] . [?\M-right]) ; forward to next page
            ;; cut/paste.
            ([?\C-w] . [?\C-x])
            ([?\M-w] . [?\C-c])
            ([?\C-y] . [?\C-v])
            ([?\C-s] . [?\C-f]) ; search
            ([?\C-g] . [?\C-g]) ; search again
            ([?\C-r] . [?\C-\M-r]) ; reader mode
            ([?\C-j] . [?\C-d]) ; toggle search bar / page
            ([?\C-W] . [?\C-\S-w]) ; close window
            ([?\M-n] . [?\C-n]) ; new window
            ;; Firefox extension - (Saka Key) - link hints
            ;;  - always open in new window 'fn' (not tab)
            ;; Firefox: focus search bar: C-l
            )))
  (setq save-interprogram-paste-before-kill t)
  (exwm-enable)
  (exwm-config-misc)

  (require 'exwm-randr)
;  (setq exwm-randr-workspace-output-plist '(0 "eDP-1" 1 "DP-1"))
;  (add-hook 'exwm-randr-screen-change-hook 'my-change-screen-hook)
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
	      (eshell/alias "d" "dired $1")))
  (add-hook 'eshell-mode-hook
            (lambda()
              ;; programs that don't work well in eshell and should be run in visual mode
              (add-to-list 'eshell-visual-commands "ssh")
              (add-to-list 'eshell-visual-commands "tail")
              (add-to-list 'eshell-visual-commands "htop"))))

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :config
  (add-to-list
   'ivy-sort-matches-functions-alist
   '(read-file-name-internal . ivy--sort-files-by-date))

  ;; puts ivy in the window instead of the minibuffer
  (defun ivy-display-function-window (text)
    (let ((buffer (get-buffer-create "*ivy-candidate-window*"))
          (str (with-current-buffer (get-buffer-create " *Minibuf-1*")
                 (let ((point (point))
                       (string (concat (buffer-string) "  " text)))
                   (ivy-add-face-text-property
                    (- point 1) point 'ivy-cursor string t)
                   string))))
      (with-current-buffer buffer
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert str)))
      (with-ivy-window
        (display-buffer
         buffer
         `((display-buffer-reuse-window
            display-buffer-below-selected)
           (window-height . ,(1+ (ivy--height (ivy-state-caller ivy-last)))))))))
  ;; FIXME: this no longer works
  (setq ivy-display-function #'ivy-display-function-window)
  
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-use-virtual-buffers t)
  (setq ivy-display-style 'fancy)
  (setq ivy-height 20)
  (setq ivy-initial-inputs-alist nil)
  (ivy-mode 1)
  (define-key ivy-minibuffer-map (kbd "C-c o") 'ivy-occur))

;; (use-package ivy-rich
;;   :after ivy
;;   :custom
;;   (ivy-virtual-abbreviate 'full
;;                           ivy-rich-switch-buffer-align-virtual-buffer t
;;                           ivy-rich-path-style 'abbrev)
;;   :config
;;   (ivy-set-display-transformer 'ivy-switch-buffer
;;                                'ivy-rich-switch-buffer-transformer)
;;   (ivy-rich-mode 1))

(use-package anzu
  :diminish
  :bind
  ("C-r"   . anzu-query-replace-regexp)
  ("C-M-r" . anzu-query-replace-at-cursor-thing)
  :hook
  (after-init . global-anzu-mode))


(use-package smex
  :config (smex-initialize))

(use-package counsel
  :after ivy
  :diminish
  :bind (("M-x"     . counsel-M-x)
         ("C-s"     . counsel-grep-or-swiper)
;;         ("C-x C-f" . counsel-file-jump)
         ("C-x C-f" . counsel-find-file)
         ("C-x C-r" . counsel-recentf)  ; search for recently edited
         ("C-c g"   . counsel-git)      ; search for files in git repo
         ("C-c j"   . counsel-git-grep) ; search for regexp in git repo
         ("C-c /"   . counsel-ag)       ; Use ag for regexp
         ("C-x l"   . counsel-locate)
         ("C-h b"   . counsel-descbinds)
;;         ("M-y"     . counsel-yank-pop)
;;         ("C-k"     . ivy-kill-line)
         ("<f1> f"  . counsel-describe-function)
         ("<f1> v"  . counsel-describe-variable)
         ("<f1> l"  . counsel-find-library)
         ("<f2> i"  . counsel-info-lookup-symbol)
         ("<f2> u"  . counsel-unicode-char)
         ("C-c C-r" . ivy-resume))
  :preface
  (defun ivy-format-function-pretty (cands)
    "Transform CANDS into a string for minibuffer."
    (ivy--format-function-generic
     (lambda (str)
       (concat
        (all-the-icons-faicon "hand-o-right" :height .85 :v-adjust .05 :face 'font-lock-constant-face)
        (ivy--add-face str 'ivy-current-match)))
     (lambda (str)
       (concat "  " str))
     cands
     "\n"))
  :custom (counsel-find-file-ignore-regexp
           (concat "\\(\\`\\.[^.]\\|"
                   (regexp-opt completion-ignored-extensions)
                   "\\'\\)"))
  :commands counsel-minibuffer-history
  :config
  (use-package flx
    :ensure t)
  (add-to-list 'ivy-sort-matches-functions-alist
               '(counsel-find-file . ivy--sort-files-by-date))
  (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  (counsel-mode 1))

;; (use-package all-the-icons-ivy
;;   :ensure t
;;   :config
;;   (all-the-icons-ivy-setup))

(use-package swiper
  :after ivy
  :bind (
        ; ("C-s" . swiper)
         ("C-r" . swiper))
  :config
  (setq ivy-display-style 'fancy))

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
  :config
  (setq recentf-max-saved-items 50
        recentf-max-menu-items 50
        recentf-exclude '("^/var/folders\\.*"
                          "COMMIT_EDITMSG\\'"
                          "/\\.git/.*\\'"
                          ".*-autoloads\\.el\\'"
                          "[/\\]\\.elpa/"))
  (recentf-mode 1)
  :bind
;  ("C-x c-r" . recentf-open-files)
  )

(use-package hippie-exp
  :bind (("M-/" . hippie-expand))
  :config
  (setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                           try-expand-dabbrev-all-buffers
                                           try-expand-dabbrev-from-kill
                                           try-complete-file-name-partially
                                           try-complete-file-name
                                           try-expand-all-abbrevs
                                           try-expand-list
                                           try-expand-line
                                           try-complete-lisp-symbol-partially
                                           try-complete-lisp-symbol)))

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
  :diminish paredit-mode
  :config
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'paredit-mode)
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode))

(use-package rainbow-delimiters
  :ensure t
  :commands rainbow-delimiters-mode
  :diminish rainbow-delimiters-mode
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  :config
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :foreground "red"
                      :inherit 'error
                      :box t))


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
  :diminish rainbow-mode
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
    (setq org-agenda-files (list "~/Org/project.org"
                             "~/Org/home.org"
                             "~/Org/project-complete.org"
                             "~/Org/someday.org"
                             "~/Org/tickler.org"))
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
    (setq org-refile-targets '((nil :maxlevel . 9)
                           (org-agenda-files :maxlevel . 9)))
    (setq org-refile-use-outline-path t)
    (setq org-tags-column -90)
    (setq org-todo-keywords '((sequence "TODO(t)" "IN-PROGRESS(p)" "WAITING(w)" "|" "DONE(d)")))
    (add-hook 'org-mode-hook (lambda () (setq fill-column 100)))
    (setq org-todo-keyword-faces
          '(("TODO" . org-warning)
            ("IN-PROGRESS" . "green")
            ("WAITING" . "yellow")
            ("COMPLETE" . "blue")))
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
  ;; Bullet examples
  ;; "●" "◉" "→"
  ;; ("◉" "◎" "⚫" "○" "►" "◇")
  ;;  "∙" "∶" "∵" "∷" "∺" )))
  ;; (setq org-bullets-bullet-list '("❂" "⁑" "⁂" "❖" "✮" "✱" "✵")))
  :ensure t
  :commands (org-bullets-mode)
  :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package smtpmail
  :ensure nil
  :init
  (setq message-send-mail-function 'smtpmail-send-it
        smtpmail-starttls-credentials
        '(("smtp.gmail.com" 587 nil nil))
        smtpmail-default-smtp-server "smtp.gmail.com"
        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587
        smtpmail-debug-info t))

(use-package mu4e
  :ensure nil
  :config
  (progn
    (setq mu4e-maildir (expand-file-name "~/.mail")
          mu4e-attachment-dir "~/Downloads"
          mu4e-compose-signature-auto-include nil
          ;; mu4e-drafts-folder "/Drafts"
          ;; mu4e-trash-folder "/Trash"
          ;; mu4e-sent-folder "/SentMail"
          
          mu4e-get-mail-command "mbsync -c ~/.mbsyncrc home-inbox"
          mu4e-html2text-command "w3m -T text/html"
          
          mu4e-maildir-shortcuts
          '(("/inbox" . ?i)
            ("/Drafts" . ?D)
            ("/SentMail" . ?s))

          mu4e-update-interval 300
          mu4e-headers-visible-lines 30
          mu4e-headers-auto-update t
          mu4e-view-show-addresses t
          mu4e-view-show-images t
          mu4e-headers-skip-duplicates t
          mu4e-compose-signature-auto-include nil
          mu4e-sent-messages-behavior 'delete)
    (setq mu4e-use-fancy-chars t
          mu4e-headers-draft-mark '("D" . "⚒ ") ; draft
          mu4e-headers-seen-mark '("S" . "☑ ") ; seen
          mu4e-headers-unseen-mark '("u" . "☐ ") ; unseen
          mu4e-headers-flagged-mark '("F" . "⚵ ") ; flagged
          mu4e-headers-new-mark '("N" . "✉ ") ; new
          mu4e-headers-replied-mark '("R" . "↵ ") ; replied
          mu4e-headers-passed-mark '("P" . "⇉ ") ; passed
          mu4e-headers-encrypted-mark '("x" . "⚷ ") ; encrypted
          mu4e-headers-signed-mark '("s" . "✍ ") ; signed
          ;; thread prefix marks
          mu4e-headers-has-child-prefix '("+" . "◼")
          mu4e-headers-empty-parent-prefix '("-" . "◽")
          mu4e-headers-first-child-prefix '("\\" . "┗▶")
          mu4e-headers-duplicate-prefix '("=" . "⚌")
          mu4e-headers-default-prefix '("|" . "┃"))
    (when (fboundp 'imagemagick-register-types)
      (imagemagick-register-types))
    (setq mu4e-headers-fields
          '((:date .  25)
	    (:flags .  6)
	    (:from-or-to . 22)
	    (:mailing-list . 10)
	    (:size . 7)
            (:thread-subject . nil))
          mu4e-headers-from-or-to-prefix nil)
    ;; view in Firefox with 'aV'
    (add-to-list 'mu4e-view-actions
                 '("ViewInBrowser" . mu4e-action-view-in-browser) t)
    (add-hook 'mu4e-compose-mode-hook
              (lambda ()
                (set-fill-column 76)
                (flyspell-mode)))))

(use-package elfeed
  :defer t
  :ensure t
  :preface
  (progn
    (setq elfeed-db-directory
          (let* ((db-dir-name (format "elfeed_db_%s" "2.6.1"))
                 (dir (file-name-as-directory (expand-file-name db-dir-name user-emacs-directory))))
            (make-directory dir :parents)
            dir)))
  :config
  (progn
    (setq elfeed-feeds
          '(;; emacs
            ("http://stackexchange.com/feeds/tagsets/152198/emacs?sort=active" emacs)
            ("http://nullprogram.com/feed/" emacs)
            ("http://planet.emacsen.org/atom.xml" emacs)))
    ;; Entries older than 4 weeks are marked as read
    (add-hook 'elfeed-new-entry-hook
              (elfeed-make-tagger :before "4 weeks ago"
                                  :remove 'unread))))


(use-package elfeed-goodies
  :ensure t
  :config
  ;; (elfeed-goodies/set)
  )

;; (setq browse-url-browser-function 'eww-browse-url)

(setq gnus-button-url 'browse-url-generic
      browse-url-generic-program "qutebrowser"
      browse-url-browser-function gnus-button-url)


(use-package use-package-hydra
  :ensure t)

(use-package dired
  :ensure nil
  :commands (dired dired-jump dired-jump-other-window)
  :config
  (setq dired-listing-switches "-laGh1v --group-directories-first")
  (setq dired-clean-confirm-killing-deleted-buffers t)
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always))


(defun dired-dotfiles-toggle ()
  "Show/hide dot-files."
  (when (equal major-mode 'dired-mode)
    (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p) ; if currently showing
	(progn
	  (set (make-local-variable 'dired-dotfiles-show-p) nil)
	  (message "h")
	  (dired-mark-files-regexp "^\\\.")
	  (dired-do-kill-lines))
      (progn (revert-buffer) ; otherwise just revert to re-show
	     (set (make-local-variable 'dired-dotfiles-show-p) t)))))

; show subdirectory as tree within existing directory
(use-package dired-subtree
  :config
  (bind-keys :map dired-mode-map
             ("i" . dired-subtree-insert)
             (";" . dired-subtree-remove)))

; narrow dired to match filter
(use-package dired-narrow
  :ensure t
  :bind (:map dired-mode-map
              ("/" . dired-narrow)))

(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir            _v_iew             _m_ark                _(_ toggle details   _i_nsert-subdir      wdired
_C_opy               _O_ view other     _U_nmark all          _)_ omit-mode        _;_ hide-subdir      C-x C-q : edit
_D_elete             _o_pen other       _u_nmark             _l_ redisplay         _w_ kill-subdir      C-c C-c : commit
_R_ename             _M_ chmod          _t_oggle             _g_ revert buf        _e_ ediff            C-c ESC : abort
_Y_ rel symlink      _G_ chgrp          _E_xtension mark     _s_ort                _=_ pdiff
_S_ymlink            ^ ^                _F_ind marked        _._ toggle hydra      \\ flyspell
_r_sync              ^ ^                ^ ^                  ^ ^                   _?_ summary
_z_ compress-file    _A_ find regexp    ^ ^                  ^ ^                   _b_ toggle-dotfiles
_Z_ compress         _Q_ repl regexp    ^ ^                  ^ ^                   _/_ narrow

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  (";" dired-subtree-remove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-subtree-insert)
  ("l" dired-do-redisplay)   ;; relist the marked or single directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("b" dired-dotfiles-toggle)
  ("/" dired-narrow)
  ("q" nil)
  ("." nil :color blue))
(define-key dired-mode-map "." 'hydra-dired/body)


(use-package paradox
  :defer t
  :config
  (progn
    (setq paradox-spinner-type 'progress-bar
          paradox-execute-asynchronously t)
    (setq paradox-github-token "56f78f2809f8c42ece61e27b7061a5f72e9efd20")
;;    (load (locate-user-emacs-file "paradox-token") :noerror :nomessage)
    (setq paradox-lines-per-entry 1)
    (setq paradox-automatically-star t)
    (paradox-enable)))


(use-package beacon
  :diminish beacon-mode
  :config
  (progn
    (setq beacon-blink-when-point-moves-vertically nil)
    (setq beacon-blink-when-point-moves-horizontally nil)
    (setq beacon-blink-when-buffer-changes t)
    (setq beacon-blink-when-window-scrolls t)
    (setq beacon-blink-when-window-changes t)
    (setq beacon-blink-when-focused nil)

    (setq beacon-blink-duration 0.3)
    (setq beacon-blink-delay 0.3)
    (setq beacon-size 20)
    (setq beacon-color "orange")
    (add-to-list 'beacon-dont-blink-major-modes 'shell-mode)
    (add-to-list 'beacon-dont-blink-major-modes 'inferior-python-mode)
    (beacon-mode 1)))


(use-package dimmer
  :ensure
  :config
  (setq dimmer-fraction 0.25)
  (dimmer-activate))


(use-package flyspell
  :commands (flyspell-auto-correct-previous-word flyspell-correct-word-generic)
  :init
  ;; Below variables need to be set before `flyspell' is loaded.
  (setq flyspell-use-meta-tab nil)
  :custom
  (flyspell-abbrev-p t)
  (flyspell-use-global-abbrev-table-p t)
  (flyspell-issue-message-flag nil)
  (flyspell-issue-welcome-flag nil)
  :config
  ;; Use mouse
  (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
  (define-key flyspell-mouse-map [mouse-3] #'undefined))
  (add-hook 'flyspell-mode-hook 'flyspell-buffer) ; show misspelled

(use-package flyspell-correct-ivy
  :general
  (:states '(normal insert emacs) :keymaps 'flyspell-mode-map
   "C-;" 'flyspell-auto-correct-previous-word
   "C-:" 'flyspell-correct-word-generic)
  :custom (flyspell-correct-interface 'flyspell-correct-ivy))

(with-eval-after-load 'hydra
  (defhydra hydra-spelling (:color blue)
  "
  ^
  ^Spelling^          ^Errors^            ^Checker^
  ^────────^──────────^──────^────────────^───────^───────
  _q_ quit            _<_ previous        _c_ correction
  ^^                  _>_ next            _d_ dictionary
  ^^                  _f_ check           _m_ mode
  ^^                  ^^                  ^^
  "
  ("q" nil)
  ("<" flyspell-correct-previous :color pink)
  (">" flyspell-correct-next :color pink)
  ("c" ispell)
  ("d" ispell-change-dictionary)
  ("f" flyspell-buffer :color pink)
  ("m" flyspell-mode)))

(use-package eshell-git-prompt
  :ensure
  :after eshell
  :config
  (eshell-git-prompt-use-theme 'powerline))

(add-hook 'prog-mode-hook
               (lambda ()
                (font-lock-add-keywords nil
                 '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; TODO: look at eval-in-repl
;; TODO: start emacs as server using systemd
;; TODO: switch windows left/right up/down

(provide '.emacs)
;;; .emacs ends here
