;;DISPLAY AND ENCODING;;

(set-language-environment "UTF-8")

;;Put fonts customization in a separate file
(setq custom-file "~/.emacs-custom.el")
(load custom-file)

;;Hide useless bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;;Display column number and time in status bar
(column-number-mode t)
(display-time-mode t)


;;Indent with spaces and set default indent to 4
(setq indent-tab-mode nil)
(setq default-tab-width 4)


;;Start in fullscreen
(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
)
(toggle-fullscreen)

;;


;;GLOBAL PACKAGES AND THEMES;;

;;Load installers packages
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

;;Load el-get package manager
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))
(el-get 'sync)

;;Set default theme to zenburn
(load-theme 'zenburn t)

;;Save buffers when Emacs exits
(require 'desktop)
  (desktop-save-mode 1)
  (defun my-desktop-save ()
    (interactive)
    ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
    (if (eq (desktop-owner) (emacs-pid))
        (desktop-save desktop-dirname)))
  (add-hook 'auto-save-hook 'my-desktop-save)

;;Enable ido-mode for autocompletion
(require 'ido)
(ido-mode t)

;;


;;PYTHON;;

;;Indent settings
(setq python-indent 4)

;;Load Jedi.el
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:ac-setup)

;;Load flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;;Load autopair
(require 'autopair)
(autopair-global-mode)

;;Load auto-complete
(require 'auto-complete)
(auto-complete-mode)

;;Load fill-column-indicator
(require 'fill-column-indicator)
(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)

;;; Indentation for python

;; Ignoring electric indentation
(defun electric-indent-ignore-python (char)
  "Ignore electric indentation for python-mode"
  (if (equal major-mode 'python-mode)
      `no-indent'
    nil))
(add-hook 'electric-indent-functions 'electric-indent-ignore-python)

;; Enter key executes newline-and-indent
(defun set-newline-and-indent ()
  "Map the return key with `newline-and-indent'"
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'python-mode-hook 'set-newline-and-indent)

;;


;;MISCELLANOUS;;

;;Add colors to embedded shell
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;


;;W3M;;

;;Change default browser for 'browse-url' to w3m
(setq browse-url-browser-function 'w3m-goto-url-new-session)
 
;;Quick Wikipedia search
(defun wikipedia-search (search-term)
  "Search for SEARCH-TERM on wikipedia"
  (interactive
   (let ((term (if mark-active
                   (buffer-substring (region-beginning) (region-end))
                 (word-at-point))))
     (list
      (read-string
       (format "Wikipedia (%s):" term) nil nil term)))
   )
  (browse-url
   (concat
    "http://en.m.wikipedia.org/w/index.php?search="
    search-term ))
  )
 
;;Easier site typing
(defun w3m-open-site (site)
  "Opens site in new w3m session with 'http://' appended"
  (interactive
   (list (read-string "Enter website address(default: w3m-home):"
           nil nil w3m-home-page nil )))
  (w3m-goto-url-new-session
   (concat "http://" site)))
