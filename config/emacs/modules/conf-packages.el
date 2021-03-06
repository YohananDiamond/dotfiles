;;; -*- lexical-binding: t; -*-

(use-package bind-map
  :ensure t
  :config
  (bind-map conf-kb/leader-map
    :evil-keys ("SPC")))

(use-package auto-package-update
  :ensure t)

(use-package visual-regexp
  :ensure t)

(use-package esup
  :ensure t
  :defer t)

(use-package git-commit-message
  :ensure nil
  :defer t)

(use-package rainbow-delimiters
  :ensure t
  :config
  (inline-hook! 'after-change-major-mode-hook ()
                (pcase major-mode
                  ('fundamental-mode (rainbow-delimiters-mode-disable))
                  ('org-mode (rainbow-delimiters-mode-disable))
                  ('latex-mode (rainbow-delimiters-mode-disable))
                  ('markdown-mode (rainbow-delimiters-mode-disable))
                  (_ (rainbow-delimiters-mode-enable)))))

(use-package auto-complete
  :ensure t
  :config
  (setq ac-auto-start 2
        ac-auto-show-menu t
        ac-use-menu-map t
        ac-ignore-case nil)
  (ac-config-default)

  (define-key global-map (kbd "C-j") nil)
  (define-key global-map (kbd "C-l") nil)
  (define-key global-map (kbd "C-k") nil)

  (ac-set-trigger-key "TAB")
  (define-key global-map (kbd "C-j") nil)
  (define-key global-map (kbd "C-o") nil)

  (define-key ac-menu-map (kbd "C-j") #'ac-next)
  (define-key ac-menu-map (kbd "C-k") #'ac-previous)
  (define-key ac-menu-map (kbd "<backtab>") #'ac-previous)
  (define-key ac-menu-map (kbd "C-l") #'ac-complete)
  (define-key ac-menu-map (kbd "RET") nil)

  (inline-hook! 'rust-mode-hook ()
                (setq fill-column 120)
                (auto-complete-mode 1)))

(use-package magit
  :ensure t
  :config
  (define-key magit-mode-map (kbd "SPC") nil))

(use-package ivy
  :ensure t
  :config
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-extra-directories nil) ;; default value: '("../" "./")
  (ivy-mode 1)
  (define-key ivy-minibuffer-map (kbd "C-u") #'ivy-immediate-done)
  (define-key ivy-minibuffer-map (kbd "C-m") #'ivy-alt-done))

(use-package counsel
  :ensure t
  :after ivy
  :config
  (global-set-key (kbd "M-x") #'counsel-M-x))

(use-package ivy-rich
  :ensure t
  :after ivy
  :config
  (ivy-rich-mode))

(use-package try
  :ensure t
  :defer t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package format-all
  :ensure t
  :defer t)

(defface mode-line-highlight-1 nil
  "A face for the main modeline element highlight.")
(defface mode-line-highlight-2 nil
  "A face for the secondary modeline element highlight.")

(defun ml--propertize-list (elements properties)
  (mapcar (lambda (el)
            `(:propertize ,el
                          ,@properties))
          elements))

(defun ml--expand-list (&rest args)
  (let ((value nil))
    (dolist (item args)
      (if (listp item)
          (setq value (append value item))
        (setq value (append value (list item)))))
    value))

(setq-default
 mode-line-format
 (ml--expand-list
               ;; low memory warning
               "%e"

               ;; GUI or TTY?
               (ml--propertize-list
                '(" " (:eval (if (display-graphic-p) "GUI" "TTY")) " ")
                '(face mode-line-highlight-1))

               ;; weird infos (might change later)
               (ml--propertize-list
                '(" "
                  mode-line-mule-info
                  (:eval (if (frame-parameter nil 'client)
                             "C" "-"))
                  " ")
                '(face mode-line-highlight-2))

               ;; line and column
               (ml--propertize-list
                '(" %04l:%03c ")
                '(face mode-line-highlight-2))

               ;; buffer info
               (ml--propertize-list
                '(" "
                  ;; buffer name
                  "%b"
                  ;; mode name
                  " [" (:eval mode-name) "]"
                  ;; modification indicator
                  (:eval (if (buffer-modified-p)
                             " [+]" ""))
                  ;; read-only indicator
                  (:eval (if buffer-read-only
                             " [RO]" ""))
                  " ")
                '(face default))
               ))

(use-package origami
  :ensure t
  :config
  (with-eval-after-load 'evil
    (define-key evil-motion-state-map "zo" #'origami-open-node)
    (define-key evil-motion-state-map "zc" #'origami-close-node)
    (define-key evil-motion-state-map "za" #'origami-toggle-node)))

;; https://github.com/kaushalmodi/.emacs.d/blob/master/setup-files/setup-dired.el
(use-package dired
  :ensure nil
  :config
  (setq dired-listing-switches "-alGhvF")
  (inline-hook! 'dired-mode-hook ()
                (let ((name (buffer-name)))
                  (rename-buffer (concat "*Dired: " (replace-regexp-in-string "/$" "" name) "*")))
                (toggle-truncate-lines 1)))

(use-package xclip
  ;; Clipboard support in the terminal.
  ;; Works only if the `xclip' binary is installed.
  :ensure t
  :config
  (xclip-mode 1))

;; (use-package centaur-tabs ;; TODO: move & remake
;;   :ensure t
;;   :config
;;   (add-hook 'core-style-after-update-hook #'centaur-tabs-headline-match)
;;   (setq centaur-tabs-style "bar"
;;         centaur-tabs-set-close-button nil
;;         centaur-tabs-set-modified-marker t
;;         centaur-tabs-modified-marker "+"
;;         centaur-tabs-adjust-buffer-order t
;;         centaur-tabs-set-icons nil)
;;   ;; TODO: tab category titles
;;   (defun centaur-tabs-buffer-groups ()
;;     (list
;;      (cond
;;       ((derived-mode-p 'dired-mode) "Dired")
;;       (t "Main"))))
;;   (defun centaur-tabs-hide-tab (x)
;;     (let ((name (format "%s" x)))
;;       (or
;;        ;; Current window is not dedicated window.
;;        (window-dedicated-p (selected-window))

;;        ;; Buffer name not match below blacklist.
;;        (string-prefix-p "*epc" name)
;;        (string-prefix-p "*helm" name)
;;        (string-prefix-p "*Helm" name)
;;        (string-prefix-p "*Compile-Log*" name)
;;        (string-prefix-p "*lsp" name)
;;        (string-prefix-p "*company" name)
;;        (string-prefix-p "*Flycheck" name)
;;        (string-prefix-p "*tramp" name)
;;        (string-prefix-p " *Mini" name)
;;        (string-prefix-p "*help" name)
;;        (string-prefix-p "*straight" name)
;;        (string-prefix-p " *temp" name)
;;        (string-prefix-p "*Help" name)
;;        (string-prefix-p "*Completions" name)
;;        (string-prefix-p "*Backtrace*" name)
;;        (string-prefix-p "*Command Line*" name)
;;        (string-prefix-p "*eldoc for" name)

;;        ;; Is not magit buffer.
;;        (and (string-prefix-p "magit" name)
;;             (not (file-name-extension name))))))
;;   (centaur-tabs-mode t)
;;   (centaur-tabs-enable-buffer-reordering))

;; (use-package edwina
;;   :ensure t
;;   :config
;;   (setq display-buffer-base-action '(display-buffer-below-selected))
;;   (edwina-setup-dwm-keys)
;;   (edwina-mode 1))

;; (use-package smart-mode-line
;;   :ensure t
;;   :config
;;   (sml/setup))

;; (use-package spaceline
;;   :ensure t
;;   :config
;;   (spaceline-emacs-theme)
;;   (spaceline-define-segment tty-or-gui
;;     (if (display-graphic-p)
;;         "gui"
;;       "tty"))
;;   (spaceline-compile
;;     ;; Left Side
;;     '((anzu
;;        :priority 100)
;;       (evil-state
;;        :face highlight-face
;;        :priority 100)
;;       (tty-or-gui
;;        :face other-face
;;        :when active
;;        :priority 100)
;;       (buffer-id
;;        :face default-face)
;;       (major-mode
;;        :face other-face
;;        :priority 90)
;;       ((buffer-modified buffer-size)
;;        :face default-face
;;        :priority 80))

;;     ;; Right Side
;;     '((selection-info
;;        :face default-face
;;        :priority 95)
;;       (buffer-encoding-abbrev
;;        :face default-face
;;        :priority 96)
;;       ((point-position line-column)
;;        :face other-face
;;        :priority 96)
;;       (buffer-position
;;        :face highlight-face
;;        :priority 99))))


(provide 'conf-packages)









