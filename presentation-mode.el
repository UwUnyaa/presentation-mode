;;; presentation-mode.el --- temporary font size adjustment for presenting -*- lexical-binding: t; coding: utf-8 -*-
;; Version: 1.0.0
;; Author: UwUnyaa (https://github.com/UwUnyaa)
;; URL: https://github.com/UwUnyaa/presentation-mode
;; Package-Requires: ((emacs "24.4"))

;;; license: GPLv3 or newer

;; Copyright (C) 2019, 2020 UwUnyaa

;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation, either version 3 of the License, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
;; more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This file provides a global minor mode that temporarily adjusts font size
;; for all frames to facilitate presenting.
;;
;; `presentation-mode' toggles between the enlarged font size defined in
;; `presentation-mode-default-font-size' and the initial size. Font size can
;; be adjusted with `presentation-mode-increase-font-size' and
;; `presentation-mode-decrease-font-size' according to needs.

;;; Code:

(defgroup presentation '()
  "Global minor mode to enlarge font size for presentations."
  :group 'faces)

(defcustom presentation-mode-default-font-size 120
  "Default font size for function `presentation-mode' when enabled."
  :type 'number)

(defcustom presentation-mode-adjust-font-step 10
  "Step for font size adjustment.

Used by `presentation-mode-increase-font-size' and
`presentation-mode-decrease-font-size'."
  :type 'number)

(defun presentation-mode-get-font-size ()
  "Return the current font height."
  (face-attribute 'default :height))

(defvar presentation-mode--original-font-size
  (presentation-mode-get-font-size)
  "Original font size to revert to when disabling function `presentation-mode'.")

(defun presentation-mode-set-font-size (size)
  "Set the default font size to SIZE."
  (set-face-attribute 'default nil :height size))

(defun presentation-mode-adjust-font-size (offset)
  "Adjust font size by OFFSET."
  (presentation-mode-set-font-size
   (+ (presentation-mode-get-font-size) offset)))

(defun presentation-mode-increase-font-size (steps)
  "Increase font size by STEPS or 1 step.

Step size is defined in `presentation-mode-adjust-font-step'."
  (interactive "p")
  (presentation-mode-adjust-font-size
   (* steps presentation-mode-adjust-font-step)))

(defun presentation-mode-decrease-font-size (steps)
  "Decrease font size by STEPS or 1 step.

Step size is defined in `presentation-mode-adjust-font-step'."
  (interactive "p")
  (presentation-mode-adjust-font-size
   (* (- 0 steps) presentation-mode-adjust-font-step)))

;;;###autoload
(define-minor-mode presentation-mode
  "Enlarges all fonts to facilitate presenting where large font
size is needed for readability.

The mode toggles between a defined enlarged font size defined in
`presentation-mode-default-font-size' and the initial size when
enabled and disabled respectively.

Font size can be adjusted by using
`presentation-mode-increase-font-size' and
`presentation-mode-decrease-font-size'."
  :lighter " Presentation"
  :global t
  (presentation-mode-set-font-size
   ;; set font size to default or revert to initial value depending on whether
   ;; the mode is enabled or disabled
   (if presentation-mode
       presentation-mode-default-font-size
     presentation-mode--original-font-size))
  (when presentation-mode
    (message "Use +, = or - to adjust font size")
    (set-transient-map
     (let ((map (make-sparse-keymap)))
       (mapc
        (lambda (key)
          (define-key map (kbd key) #'presentation-mode-increase-font-size))
        '("+" "="))
       (define-key map (kbd "-") #'presentation-mode-decrease-font-size)
       map)
     t)))

(provide 'presentation-mode)
;;; presentation-mode.el ends here
