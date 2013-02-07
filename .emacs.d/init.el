(eval-when-compile (require 'cl))
;; left to right only
(setq-default bidi-display-reordering nil bidi-paragraph-direction (quote left-to-right))

;; language
(set-language-environment "Japanese")
;; encoding
(prefer-coding-system 'utf-8)

;; set load-path
(add-to-list 'load-path user-emacs-directory)
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
(add-to-load-path "elisp" "public_repos" "local-elisp")

;; auto-install
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/elisp//")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

;; package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

;; don't show menu-bar
(menu-bar-mode -1)

;; don't make backup-files
(setq make-backup-files nil)
(setq version-control nil)
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)
;; (setq auto-save-file-name-transforms
;;         `((".*" ,temporary-file-directory t)))
(setq kept-old-versions 1)
(setq kept-new-versions 2)
(setq trim-versions-without-asking nil)
(setq delete-old-versions t)
(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))

;; key-bind
;; (defalias 'exit 'save-buffers-kill-emacs)
(defalias 'exit 'save-buffers-kill-terminal)
(global-unset-key (kbd "C-x C-c"))
;; (global-set-key (kbd "C-x C-c") 'kill-this-buffer)
;; (global-set-key (kbd "C-h") 'delete-backward-char)
(keyboard-translate ?\C-h ?\C-?)
(delete-selection-mode t)
(require 'dired)
(define-key dired-mode-map (kbd "r") 'wdired-change-to-wdired-mode)
(global-set-key (kbd "C-c r") 'query-replace)
(global-set-key (kbd "C-c R") 'query-replace-regexp)
(require 'key-chord)
(setq key-chord-two-keys-delay 0.04)
(key-chord-mode 1)
(require 'smartrep)
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (if (>=  (window-body-width) 270)
        (split-window-horizontally-n 3)
      (split-window-horizontally)))
  (other-window 1))
(defun other-window-or-split-or-close (arg)
  "画面が1つなら分割、2つ以上なら移動。
C-uをつけるとウィンドウを閉じる。"
  (interactive "p")
  (case arg
    (4  (delete-other-windows))
    (16 (delete-window))
    (t  (other-window-or-split))))
(global-set-key (kbd "C-z") 'other-window-or-split-or-close)


;; window
(winner-mode)
(global-set-key (kbd "C-x <up>") 'winner-undo)
(global-set-key (kbd "C-x <down>") 'winner-redo)

;; expand-region
;; (require 'expand-region)
;; (global-set-key (kbd "C-@") 'er/expand-region)
;; (global-set-key (kbd "C-M-@") 'er/contract-region)

;; copy
(defun copy-whole-line (&optional arg)
  "Copy current line."
  (interactive "p")
  (or arg (setq arg 1))
  (if (and (> arg 0) (eobp) (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0) (bobp) (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (unless (eq last-command 'copy-region-as-kill)
    (kill-new "")
    (setq last-command 'copy-region-as-kill))
  (cond ((zerop arg)
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))))
        ((< arg 0)
         (save-excursion
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line (1+ arg))
                                       (unless (bobp) (backward-char))
                                       (point)))))
        (t
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line arg) (point))))))
  (message (substring (car kill-ring-yank-pointer) 0 -1)))
(global-set-key (kbd "M-W") 'copy-whole-line)

;; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))

;; tmux
(require 'emamux)

;; sudo
;; (require 'sudo-ext)

;; kill-ring
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; grep
(require 'grep)
(defvar grep-command-before-query "grep -nH -r -e ")
(defun grep-default-command ()
  (if current-prefix-arg
      (let ((grep-command-before-target
             (concat grep-command-before-query
                     (shell-quote-argument (grep-tag-default)))))
        (cons (if buffer-file-name
                  (concat grep-command-before-target
                          " *."
                          (file-name-extension buffer-file-name))
                (concat grep-command-before-target " ."))
              (+ (length grep-command-before-target) 1)))
    (car grep-command)))
(setq grep-command (cons (concat grep-command-before-query " .")
                         (+ (length grep-command-before-query) 1)))
(require 'wgrep)
(setq wgrep-enable-key "r")

;; undo/redo
;; (require 'redo+)
;; (global-set-key (kbd "C-M-_") 'redo)
;; (setq undo-no-redo)
(require 'undo-tree)
(define-key undo-tree-map (kbd "C-M-_") 'undo-tree-redo)
(global-undo-tree-mode 1)

;; emacs-lisp
(require 'auto-async-byte-compile)
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(find-function-setup-keys)
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ilem-mode-hook 'enable-paredit-mode)
(require 'lispxmp)
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

;; popwin
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(push '(" *auto-async-byte-compile*" :height 14 :position bottom :noselect t) popwin:special-display-config)
(push '("*VC-log*" :height 10 :position bottom) popwin:special-display-config)

;; junk
(require 'open-junk-file)
(setq open-junk-file-format "~/junk/%Y/%m-%d-%H%M%S.")
(global-set-key (kbd "C-c z") 'open-junk-file)

;; sequential-command
(require 'sequential-command-config)
(sequential-command-setup-keys)

;; flex-autopair
(setq flex-autopair-disable-modes
      '(emacs-lisp-mode lisp-interaction-mode lisp-mode ilem-mode yatex-mode))
(require 'flex-autopair)
(global-flex-autopair-mode 1)

;; key-combo
(require 'key-combo)
(key-combo-mode 1)
(key-combo-load-default)
(key-combo-define-global (kbd "{ RET") "{\n`!!'\n}")
(key-combo-define-global (kbd "{ C-j") "{\n`!!'\n}")
(key-combo-define-global (kbd "{ <SPC>") "{ `!!' }")
(key-combo-define-global (kbd "[ <SPC>") "[ `!!' ]")

;; recentf
(require 'recentf-ext)
(setq recentf-max-saved-items 100)
(setq recentf-exclude '(".recentf" "*.elc" "/TAGS$" "/var/tmp/"))
(setq recentf-auto-cleanup 'never)
(recentf-mode 1)
(global-set-key (kbd "C-c f") 'recentf-open-files)

;;  hippie-expand
(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))
(global-set-key (kbd "C-c i") 'hippie-expand)

;; iswitch-buffer
(iswitchb-mode 1)

;; mcomplete
(require 'mcomplete)
(turn-on-mcomplete-mode)

;; minibuf-isearch
(require 'minibuf-isearch)

;; org
(require 'org)
(setq org-activate-links '(date bracket radio tag date footnote angle))
(setq org-startup-truncated nil)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\)$" .  org-mode))
(setq org-directory "~/org/")		; default ~/org
(setq org-default-notes-file (concat org-directory "agenda.org"))
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(require 'org-agenda)
(setq org-log-done 'time)
(setq org-use-fast-todo-selection t)
(setq org-todo-keywords
      '((sequence "TASK(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(x)" "CANCELED(c)" "DEFERRED(f)")
        (sequence "APPT(a)" "|" "DONE(x)" "CANCEL(c)" "DEFERRED(f)")))
(require 'org-capture)
(setq org-capture-templates
      '(("t" "Task" entry
         (file+headline nil "Inbox")
         "** TASK %?\n   %i\n   %T\n   %a")
        ("b" "Bug" entry
         (file+headline nil "Inbox")
         "** TASK %?   :bug:\n   %i\n   %T\n   %a")
        ("i" "Idea" entry
         (file+headline nil "New Ideas")
         "** %?\n   %i\n   %T\n   %a")
	("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\n %i\n  Added: %U \n  From:  %a\n")))

;; guide-key
(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x r" "C-x 4"))
(setq guide-key/highlight-command-regexp "rectangle\\|register")
(setq guide-key/popup-window-position 'bottom)
(guide-key-mode 1)
(defun guide-key/my-hook-function-for-org-mode ()
  (guide-key/add-local-guide-key-sequence "C-c")
  (guide-key/add-local-guide-key-sequence "C-c C-x")
  (guide-key/add-local-highlight-command-regexp "org-"))
(add-hook 'org-mode-hook 'guide-key/my-hook-function-for-org-mode)


;; vc
(require 'vc)
(defun vc-status-dwim ()
  "If in CVS directory ,call cvs-status. If in SVN, call svn-status, if in others,  call magit-status."
  (interactive)
  (call-interactively
   (case (vc-backend buffer-file-name)
     (CVS 'cvs-status)
     (SVN 'svn-status)
     (t 'magit-status))))
(global-set-key (kbd "C-x v d") 'vc-status-dwim)

;; yanippet
;; (require 'yasnippet)
;; (require 'dropdown-list)
;; (yas-global-mode 1)

;; etc
(ffap-bindings)
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)
(require 'generic-x)
(defalias 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
