# -*- coding: utf-8 -*-
(ql:quickload '(:unix-cmd) :silent t)   ; =>(:UNIX-CMD) 
(defpackage :myapp                      ; =>:MYAPP 
  (:use :cl :unix-cmd)
  (:export :main))                      ; =>#<PACKAGE "MYAPP"> 
(in-package :myapp)                     ; =>#<PACKAGE "MYAPP"> 

(defvar blog-homedir "~/biofermin2.github.io/docs/") ; => BLOG-HOMEDIR
(cd blog-homedir)                                    ; => #P"/home/hiro/biofermin2.github.io/docs/"

(ls "*.html")                           ; => 2022-0907-2.html
2022-0908-2.html
2022-0909-2.org.html
2022-0910-2.org.html
2022-0913-2.org.html
2022-0914-2.org.html
2022-0916-2.org.html
2022-0927-2.org.html
2022-0930-2.org.html
2022-1019-2.org.html
2022-1024-2.org.html
2022-1026-2.org.html
2022-1026-4.org.html
2022-1030-3.org.html
2022-1115-2.org.html
404.html
ChangeLog.org.html
agri-menu.lisp.html
first.html
footer.html
googlefbe2be1e2f0fd48d.html
header.html
index.html
index.lisp.html
lisp-menu.lisp.html
others-menu.lisp.html
NIL

(defun main ()

  )
