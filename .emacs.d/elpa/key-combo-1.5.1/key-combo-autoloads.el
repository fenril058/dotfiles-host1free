;;; key-combo-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (key-combo-mode key-combo-load-default key-combo-define-hook)
;;;;;;  "key-combo" "key-combo.el" (20746 13966))
;;; Generated autoloads from key-combo.el

(autoload 'key-combo-define-hook "key-combo" "\


\(fn HOOKS NAME KEYS)" nil (quote macro))

(autoload 'key-combo-load-default "key-combo" "\


\(fn)" t nil)

(defvar key-combo-mode nil "\
Non-nil if Key-Combo mode is enabled.
See the command `key-combo-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `key-combo-mode'.")

(custom-autoload 'key-combo-mode "key-combo" nil)

(autoload 'key-combo-mode "key-combo" "\
Toggle key combo.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("key-combo-pkg.el") (20746 13966 171058))

;;;***

(provide 'key-combo-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; key-combo-autoloads.el ends here
