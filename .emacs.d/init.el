(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(require 'evil)
(evil-mode 1)
(evil-set-undo-system 'undo-redo)
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(add-hook 'agda2-mode-hook
    (lambda ()
        (display-line-numbers-mode)
        (define-key agda2-mode-map (kbd "C-c C-g") 'agda2-show-constraints)))
(setq display-line-numbers-type 'relative)
(menu-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("ccdc42b444da0b62c25850da75f59186319ee22ddfd153ffc9f7eb4e59652fc9" default))
 '(package-selected-packages '(the-matrix-theme evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(agda2-highlight-catchall-clause-face ((t (:background "#001e2e"))))
 '(agda2-highlight-coinductive-constructor-face ((t nil)))
 '(agda2-highlight-confluence-problem-face ((t (:background "#30000c"))))
 '(agda2-highlight-coverage-problem-face ((t (:background "#30000c"))))
 '(agda2-highlight-datatype-face ((t nil)))
 '(agda2-highlight-deadcode-face ((t (:background "#001e2e"))))
 '(agda2-highlight-error-face ((t (:foreground "#cc0037"))))
 '(agda2-highlight-error-warning-face ((t (:background "#30000c"))))
 '(agda2-highlight-field-face ((t nil)))
 '(agda2-highlight-function-face ((t nil)))
 '(agda2-highlight-inductive-constructor-face ((t nil)))
 '(agda2-highlight-keyword-face ((t nil)))
 '(agda2-highlight-macro-face ((t nil)))
 '(agda2-highlight-missing-definition-face ((t (:background "#30000c"))))
 '(agda2-highlight-module-face ((t nil)))
 '(agda2-highlight-number-face ((t nil)))
 '(agda2-highlight-positivity-problem-face ((t (:background "#30000c"))))
 '(agda2-highlight-postulate-face ((t nil)))
 '(agda2-highlight-primitive-face ((t nil)))
 '(agda2-highlight-primitive-type-face ((t nil)))
 '(agda2-highlight-record-face ((t nil)))
 '(agda2-highlight-shadowing-in-telescope-face ((t (:background "#001e2e"))))
 '(agda2-highlight-string-face ((t nil)))
 '(agda2-highlight-symbol-face ((t nil)))
 '(agda2-highlight-termination-problem-face ((t (:background "#30000c"))))
 '(agda2-highlight-typechecks-face ((t (:background "#001e2e"))))
 '(agda2-highlight-unsolved-constraint-face ((t (:background "#30000c"))))
 '(agda2-highlight-unsolved-meta-face ((t (:background "#30000c")))))

(load-theme 'the-matrix)
