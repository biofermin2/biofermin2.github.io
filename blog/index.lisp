#+BEGIN_SRC lisp
(defstruct blog title author since license) 
(defvar blog (make-blog :title "(peek-char t *sexp-life*)"
                            :author "biofermin2"
                            :since "2022"
                            :license "©biofermin2"))
(defstruct menu first lisp agri others) 
(defvar menu1 (make-menu)) 
(defvar menu-lisp (make-menu))
(defvar menu-agri (make-menu))
(defvar menu-others (make-menu))
(defstruct article title date text link)
(defun make-blog-menu ()
  (let ((a1 (make-article :title "first"
                          :link "./first.html"))
        (a2 (make-article :title "lisp"
                          :link "./lisp-menu.lisp.html"))
        (a3 (make-article :title "agriculture"
                          :link "./agri-menu.lisp.html"))
        (a4 (make-article :title "others"
                          :link "./others-menu.lisp.html")))
    (setf (menu-first menu1) a1
          (menu-lisp menu1) a2
          (menu-agri menu1) a3
          (menu-others menu1) a4)
    (format t "(:menu ~{[[~a][~a]]~^ ~})"
            (list (article-link a1) (article-title a1)
                  (article-link a2) (article-title a2)
                  (article-link a3) (article-title a3)
                  (article-link a4) (article-title a4))))) ; =>MAKE-BLOG-MENU 
(make-blog-menu)                                           ; =>
#+END_SRC

#+RESULTS:
(:menu [[./first.html][first]] [[./lisp-menu.lisp.html][lisp]] [[./agri-menu.lisp.html][agriculture]] [[./others-menu.lisp.html][others]])NIL
