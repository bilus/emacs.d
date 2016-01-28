;; Troubleshooting customization errors.
;(setq debug-on-error t)

;;;;
;; Packages
;;;;

;; Define package repositories
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;                         ("marmalade" . "http://marmalade-repo.org/packages/")
;                         ("melpa" . "http://melpa-stable.milkbox.net/packages/")))


;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(ag

    ;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit


    ;; Autocompletion
    company

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider
    cider-eval-sexp-fu
    clj-refactor

    ;; Basic interaction with a Clojure subprocess
    ;; Conflicts with CIDER C-c C-z
    ;; inf-clojure

    ;; formatting of let-like forms
    align-cljlet

    ;; Syntax checking
                                        ;    flycheck
    ;; flycheck-clojure
    flycheck-pos-tip

    ;; Semantic region expansion
    expand-region

    ;; HAML syntax highlighting and indentation
    haml-mode

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-ubiquitous

    ;; Allow to go to Java class source.
    javap

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; symbol search
    smartscan

    ;; Searching project files.
    find-file-in-project
    swiper

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; highlight word under point
    idle-highlight-mode

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit

    ;; better interface for grep
    wgrep

    ;; clipboard integration
    clipmon

    ;; Ruby
    enh-ruby-mode
    robe
    inf-ruby
    rubocop
    flycheck
    projectile-rails
    ruby-end
    rspec-mode
    mmm-mode           ; TODO: Configure for ruby and js in .erb files
    ruby-refactor

    ;; Dash integration
    dash-at-point

    ;; Go to last change
    goto-chg

    ;; Undo Tree
    undo-tree

    ;; Markdown
    markdown-mode
;;    websocket				;
;;    markdown-preview-mode

    floobits
    ))

(global-undo-tree-mode)

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;;
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")

;; Minor customizations
(tool-bar-mode -1)
;(setq nrepl-hide-special-buffers t)

(require 'expand-region)
(global-set-key (kbd "C--") 'er/expand-region)
(global-set-key (kbd "C-_") 'er/contract-region)

;; Switch between windows (C-x o).
;; (global-set-key (quote [C-tab]) (quote other-window))
(global-set-key (read-kbd-macro "<C-tab>") 'other-window)

(setq mac-command-modifier 'super) ; make opt key do Super
(global-set-key (kbd "C-c l") 'goto-last-change)
(global-set-key (kbd "C-c n") 'goto-last-change-reverse)

(define-key global-map (kbd "RET") 'newline-and-indent)

;; Put fname in title.
(setq-default frame-title-format '((:eval (if (buffer-file-name)
                                              (abbreviate-file-name (buffer-file-name)) "%f"))))
;; Handle Polish chars.
(setq ns-right-alternate-modifier nil)

;; Save all buffers on lost focus.
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

;; Always reload changed files.
(global-auto-revert-mode 1)

(require 'cider-eval-sexp-fu)

;; Support for refactorings and snippets.
(require 'clj-refactor)

(defun my-clojure-mode-hook ()
    (clj-refactor-mode 1)
    (yas-minor-mode 1) ; for adding require/use/import
    (cljr-add-keybindings-with-prefix "C-="))

(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"                 ;; personal snippets
))

(when (require 'yasnippet nil 'noerror)
  (progn
    (yas/load-directory "~/.emacs.d/snippets")))

;; Treat selection in a more standard way (e.g. typing kills it) even in paredit.
(delete-selection-mode 1)
(put 'paredit-forward-delete 'delete-selection 'supersede)
(put 'paredit-backward-delete 'delete-selection 'supersede)
(put 'paredit-newline 'delete-selection t)

;; Turn off line wrapping.
(set-default 'truncate-lines t)
(setq truncate-partial-width-windows nil)

;; Enable horizontal scrolling.
(global-set-key [double-wheel-right] 'scroll-right)
(global-set-key [double-wheel-left] 'scroll-left)
(put 'scroll-left 'disabled nil)
(setq hscroll-step 0.5)

;; Load flycheck on demand.
;(eval-after-load 'flycheck '(require 'setup-flycheck))

;; OS/X dir
(setq dired-use-ls-dired nil)

;; Autocomplete.
(global-set-key (kbd "TAB") #'company-indent-or-complete-common) ;; Use TAB for indenting AND for autocompletion.

;; Searching using Swiper+Ivy.
(autoload 'ivy-read "ivy")
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key "\C-r" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key [f6] 'ivy-resume)

;; wgrep
(require 'wgrep)

;; formatting of let-like forms
(require 'align-cljlet)

;; clipboard integration
(add-to-list 'after-init-hook 'clipmon-mode-start)

;; enable symbol search https://github.com/mickeynp/smart-scan
;; (require 'smartscan)
;; (add-to-list 'after-init-hook (lambda () (smartscan-mode 1)))

;; Go back to previous buffer.
(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd "C-c b") 'switch-to-previous-buffer)

(defun setup-progmode ()
;; Highlight word usages.
  (idle-highlight-mode t)
;; Symbol search
  (smartscan-mode 1))

(add-hook 'prog-mode-hook 'setup-progmode)

;; Start maximized.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Auto-revert unmodified buffers when they change on disk.
(global-auto-revert-mode t)

;; Ag results.
(setq ag-highlight-search t)
(setq ag-reuse-window 't)
(setq ag-reuse-buffers 't)

;; Go to java class
;; (load "~/.emacs.d/vendor/javap-mode.el")
;; (load "~/.emacs.d/vendor/javad.el")
;; (require 'javap-mode)

;; (defun javad-find-class (&rest args)
  ;; (interactive)
  ;; (if (not (string= ".class" (substring (buffer-file-name) -6 nil)))
      ;; nil
    ;; (message "Show class as: [b]ytecode, [d]ecompiled or [i]dentity?")
    ;; (let ((resp (read-char)))
      ;; (cond
       ;; ((= resp 98) (progn (javap-buffer) nil))
       ;; ((= resp 100) (progn (javad-buffer) nil))
       ;; (t nil))
      ;; (let ((buff (current-buffer)))
        ;; (switch-to-buffer buff)))))

;; (add-hook 'find-file-hook 'javad-find-class)

(add-hook 'after-init-hook #'global-flycheck-mode)
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))

;; Remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'haml-mode)
(defun haml-reindent ()
  (haml-reindent-region-by 0))
(add-hook 'haml-mode-hook
               (lambda ()
                 (setq indent-tabs-mode nil)
                 (define-key haml-mode-map (kbd "M-q") 'haml-reindent)))
;; Ruby
(add-hook 'ruby-mode-hook 'robe-mode)
;(eval-after-load 'company
;  '(push 'company-robe company-backends))
;(add-hook 'robe-mode-hook 'ac-robe-setup)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
(setq robe-turn-on-eldoc nil)
(require 'rubocop)
(add-hook 'ruby-mode-hook #'rubocop-mode)
(add-hook 'projectile-mode-hook 'projectile-rails-on)

(add-hook 'ruby-mode-hook 'ruby-refactor-mode-launch)
(setq ruby-refactor-add-parens 't)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(ruby-refactor-add-parens t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'after-init-hook 'global-company-mode)

;; Mark lines with TODO:

(defun annotate-todo ()
  "put fringe marker on TODO: lines in the curent buffer"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "TODO:" nil t)
      (let ((overlay (make-overlay (- (point) 5) (point))))
        (overlay-put overlay 'before-string (propertize "A"
                                                        'display '(left-fringe right-triangle)))))))
(add-hook 'find-file-hooks 'annotate-todo)
