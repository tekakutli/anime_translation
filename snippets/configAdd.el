

;; LanguageTool
(setq langtool-http-server-host "localhost"
      langtool-http-server-port 8081)
;; (setq langtool-http-server-stream-type 'tls)
(setq langtool-default-language "en-US")
(require 'langtool)



;; Subed
(add-to-list 'load-path "$PATH_TO_SUBED/subed/subed")
(require 'subed-autoloads)

(use-package! subed
  :ensure t
  :config
  ;; Disable automatic movement of point by default
  (add-hook 'subed-mode-hook 'subed-disable-sync-point-to-player)
  ;; Remember cursor position between sessions
  (add-hook 'subed-mode-hook 'save-place-local-mode)
  ;; Break lines automatically while typing
  (add-hook 'subed-mode-hook 'turn-on-auto-fill)
   ;; Break lines at 40 characters
  (add-hook 'subed-mode-hook (lambda () (setq-local fill-column 40))))


;; Subed Extra Section
;; DISABLE subed-adj-prev-next.el "DEFINE-KEY SUBED-MODE-MAP" PARTS
(load-file "~/code/emacs/d9a183795e5704d3f517878703407184/subed-adj-prev-next.el")

(global-set-key (kbd "C-M-]") (lambda () (interactive) (subed-increase-start-time-adjust-previous)))
(global-set-key (kbd "C-M-[") (lambda () (interactive) (subed-decrease-start-time-adjust-previous)))
(global-set-key (kbd "C-M-}") (lambda () (interactive) (subed-increase-stop-time-adjust-next)))
(global-set-key (kbd "C-M-{") (lambda () (interactive) (subed-decrease-stop-time-adjust-next)))
