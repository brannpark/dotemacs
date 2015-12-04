;; Aliases commands
(defalias 'encoding 'revert-buffer-with-coding-system)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
	     '("marmalade" .  "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized/")
(load-theme 'solarized t)
(set-frame-parameter nil 'background-mode 'dark)
(set-terminal-parameter nil 'background-mode 'dark)

;; web-mode indentation hook
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)
(add-to-list 'auto-mode-alist '("\\.html?" . web-mode))

(defun scss-custom ()
  "scss-mode-hook"
  (set (make-local-variable 'css-indent-offset) 2))
(add-hook 'scss-mode-hook' scss-custom)

;; set coffeescript indent-width
(setq coffee-tab-width 2)


;; define GO System environments
(setenv "GOPATH" "/Users/brannpark/dev/go")


;; prevent creation backupfile when saving
(setq make-backup-files nil)
;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;; go-mode
(add-to-list 'load-path "~/.emacs.d/go-mode.el/")
(require 'go-mode-load)

;; go-doc
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$"
			  ""
			  (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

;; go-fmt automatically when saving go file
(setq exec-path (cons "/usr/local/go/bin" exec-path))
(add-to-list 'exec-path "/Users/brannpark/dev/go/bin")
(add-hook 'before-save-hook 'gofmt-before-save)

;; godef-jump shortcut
(defun my-go-mode-hook ()
  ;; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ;; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
	              "go generate && go build -v && go test -v && go vet"))
  ;; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; autocomplete
(add-to-list 'load-path "/Users/brannpark/.emacs.d/lisp")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/Users/brannpark/.emacs.d/lisp/ac-dict")
(ac-config-default)

;; go-autocomplete
(add-to-list 'load-path "/Users/brannpark/.emacs.d/go-autocomplete")
(require 'go-autocomplete)
(require 'auto-complete-config)

;; go-oracle
(load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el")


;; pbcopy for OSX
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))
(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; flymake-ruby - ruby syntax check
(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)
(setq ruby-deep-indent-paren nil)

;; Projectile
(projectile-global-mode)
(add-hook 'ruby-mode-hook 'projectile-on)

;; Projectile-rails
(add-hook 'projectile-mode-hook 'projectile-rails-on)

;; inf-ruby
(global-set-key (kbd "C-c r r") 'inf-ruby)

;; ido-mode
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
(defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
  (add-hook 'ido-setup-hook 'ido-define-keys)

;; robe
(add-hook 'ruby-mode-hook 'robe-mode)

;; company-mode
(global-company-mode t)
(push 'company-robe company-backends)

;; markdown
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
