;; HELP
;; Diff betweeen ; and ;; - http://emacs.stackexchange.com/questions/16647/previous-line-indenting-on-ret
;; better-defaults -> lists possible options in find-file in mini-buffer
;; ido mode (responsible for listing possible options in find-file in mini-buffer) must be diabled in order to create a new file using C-x C-f

(setq custom-file "~/custom-setup.el")
(load custom-file 'noerror)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

; default-directory
(setq default-directory "c:/Work/sandbox")

;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq c-default-style "bsd") ;; set style to "bsd"
(setq-default c-basic-offset 3) ;; set indentation width

;;;;;;;;;;;;;;;;
;; bash setup ;;
;;;;;;;;;;;;;;;;
; Make sure that the bash executable can be found
(setq explicit-shell-file-name "C:/cygwin/bin/bash.exe") 
(setq shell-file-name explicit-shell-file-name)

; grep NUL problem
(setq null-device "/dev/null")

; ctags
(setq path-to-ctags "/usr/bin/ctags")

(defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
     (format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name)))
)
(define-key global-map "\M-*" 'pop-tag-mark)

; exec-path-from-shell
;(exec-path-from-shell-initialize)

;;;;;;;;;;;;;;;;;;;;
;; xml yaml setup ;;
;;;;;;;;;;;;;;;;;;;;
; highlight tags mode
(add-to-list 'load-path "~/.emacs.d/hl-tags-mode-master")
(require 'hl-tags-mode)
(add-hook 'sgml-mode-hook (lambda () (hl-tags-mode 1)))
(add-hook 'nxml-mode-hook (lambda () (hl-tags-mode 1)))

; YAML mode
(require 'yaml-mode)
   (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

; MATLAB setup
(defun my-matlab-mode-hook ()
  (column-enforce-mode t)) 
(add-hook 'matlab-mode-hook 'my-matlab-mode-hook)

;;;;;;;;;;;;;;;;;;;
;; editor styles ;;
;;;;;;;;;;;;;;;;;;;
; rebox
(setq rebox-style-loop '(25))
(require 'rebox2)
(global-set-key [(meta q)] 'rebox-dwim)
(global-set-key [(shift meta q)] 'rebox-cycle)

; auto pair setup
(require 'autopair)
(autopair-global-mode)

;; ace window setup
;; HELP:
;; C-u M-p: to swap windows
(global-set-key (kbd "M-p") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

; auto complete
(add-to-list 'load-path "~/.emacs.d/popup-el-master")
;; auto-complete
(add-to-list 'load-path "~/.emacs.d/auto-complete-master")    
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;; enable auto-complete by default in all modes except in minibuffer
(defun auto-complete-mode-maybe ()
  "No maybe for you. Only AC!"
  (unless (minibufferp (current-buffer))
    (auto-complete-mode 1)))

;------------------------------
; max column width (prog mode)|
;------------------------------
(add-hook 'prog-mode-hook 'column-enforce-mode)

;; elpy Python
(elpy-enable)
(pyenv-mode)
;; Refer this video for details about the below key binding bug fixes
;; https://www.youtube.com/watch?v=0kuCeS-mfyc
;; fix a key binding bug in elpy
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
;; fix a key binding bug in iedit mode
(define-key global-map (kbd "C-c o") 'iedit-mode)
;; company-quickhelp to make documentation appear beside completion list (in python)
(company-quickhelp-mode 1)

;; highlight symbol at point
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

;; full path in frame title
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))
