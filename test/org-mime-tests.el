;; counsel-etags-tests.el --- unit tests for counsel-etags -*- coding: utf-8 -*-

;; Author: Chen Bin <chenbin DOT sh AT gmail DOT com>

;;; License:

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

(require 'ert)
(require 'org-mime)
(require 'message)

(defconst mail-header '("To: myname@mail.com\n"
                       "Subject: test subject\n"
                       "From: My Name <myname@yahoo.com>\n"
                       "--text follows this line--\n"))
(defconst mail-footer '("--\n"
                        "Yous somebody\n\n"
                        "--\n"
                        "Some quote\n"))

(ert-deftest test-org-mime-htmlize ()
  (let* (str)
    (with-temp-buffer
      (apply #'insert mail-header)
      (insert "* hello\n"
              "** world\n"
              "#+begin_src javascript\n"
              "console.log('hello world');"
              "#+end_src\n")
      (apply #'insert mail-footer)
      (message-mode)
      (goto-char (point-min))
      (org-mime-htmlize)
      (setq str (buffer-string)))
    (should (string-match "<#multipart" str))))

(ert-deftest test-org-mime-org-subtree-htmlize ()
  (let* (str opts)
    (with-temp-buffer
      (insert "* hello\n"
              "** world\n"
              "#+begin_src javascript\n"
              "console.log('hello world');"
              "#+end_src\n")
      (org-mode)
      (goto-char (point-min))
      (setq opts (org-mime-get-export-options t))
      (should opts)
      (org-mime-org-subtree-htmlize)
      (switch-to-buffer (car (message-buffers)))
      (setq str (buffer-string)))
    (should (string-match "Subject: hello" str))
    (should (string-match "<#multipart" str))))

(ert-deftest test-org-mime-org-buffer-htmlize ()
  (let* (str opts)
    (with-temp-buffer
      (insert "* hello\n"
              "** world\n"
              "#+begin_src javascript\n"
              "console.log('hello world');"
              "#+end_src\n")
      (org-mode)
      (goto-char (point-min))
      (setq opts (org-mime-get-export-options t))
      (should opts)
      (org-mime-org-buffer-htmlize)
      (switch-to-buffer (car (message-buffers)))
      (setq str (buffer-string)))
    (should (string-match "<#multipart" str))))

(ert-run-tests-batch-and-exit)