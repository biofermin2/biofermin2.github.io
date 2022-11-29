(defpackage :unix-cmd
  (:nicknames :cmd)
  (:use :cl)
  (:export :directory-stack
   :pwd :cd :ls :cat :rm :touch :rmdir :pushd :popd
   :date :cp :mkdir :echo :wc :seq))    ; =>#<PACKAGE "UNIX-CMD"> 
(in-package :unix-cmd)                  ; =>#<PACKAGE "UNIX-CMD"> 

(defvar directory-stack ())             ; =>DIRECTORY-STACK 

(defun split (dt str)                  
  (let ((pos (search dt str))
        (size (length dt)))
    (if pos
	(cons (subseq str 0 pos)
	      (split dt (subseq str (+ pos size))))
      (list  str))))                    ; =>SPLIT 
;; asdf.lisp内での定義
  ;; (defun getcwd ()
  ;;   "Get the current working directory as per POSIX getcwd(3), as a pathname object"
  ;;   (or #+(or abcl genera mezzano xcl) (truename *default-pathname-defaults*) ;; d-p-d is canonical!
  ;;       #+allegro (excl::current-directory)
  ;;       #+clisp (ext:default-directory)
  ;;       #+clozure (ccl:current-directory)
  ;;       #+(or cmucl scl) (#+cmucl parse-unix-namestring* #+scl lisp::parse-unix-namestring
  ;;                       (strcat (nth-value 1 (unix:unix-current-directory)) "/"))
  ;;       #+cormanlisp (pathname (pl::get-current-directory)) ;; Q: what type does it return?
  ;;       #+(or clasp ecl) (ext:getcwd)
  ;;       #+gcl (let ((*default-pathname-defaults* #p"")) (truename #p""))
  ;;       #+lispworks (hcl:get-working-directory)
  ;;       #+mkcl (mk-ext:getcwd)
  ;;       #+sbcl (sb-ext:parse-native-namestring (sb-unix:posix-getcwd/))
  ;;       #+xcl (extensions:current-directory)
  ;;       (not-implemented-error 'getcwd)))

  ;; (defun chdir (x)
  ;;   "Change current directory, as per POSIX chdir(2), to a given pathname object"
  ;;   (if-let (x (pathname x))
  ;;     #+(or abcl genera mezzano xcl) (setf *default-pathname-defaults* (truename x)) ;; d-p-d is canonical!
  ;;     #+allegro (excl:chdir x)
  ;;     #+clisp (ext:cd x)
  ;;     #+clozure (setf (ccl:current-directory) x)
  ;;     #+(or cmucl scl) (unix:unix-chdir (ext:unix-namestring x))
  ;;     #+cormanlisp (unless (zerop (win32::_chdir (namestring x)))
  ;;                    (error "Could not set current directory to ~A" x))
  ;;     #+ecl (ext:chdir x)
  ;;     #+clasp (ext:chdir x t)
  ;;     #+gcl (system:chdir x)
  ;;     #+lispworks (hcl:change-directory x)
  ;;     #+mkcl (mk-ext:chdir x)
  ;;     #+sbcl (progn (require :sb-posix) (symbol-call :sb-posix :chdir (sb-ext:native-namestring x)))
  ;;     #-(or abcl allegro clasp clisp clozure cmucl cormanlisp ecl gcl genera lispworks mkcl sbcl scl xcl)
  ;;     (not-implemented-error 'chdir))))


(defun pwd ()
  (let* ((pwd (uiop:getcwd))
	 (current-dir-name (car (last (pathname-directory pwd)))))
    (values pwd current-dir-name)))     ; =>PWD 

;; (pwd)                                   ; => #P"/home/hiro/howm/junk/"
;; "junk"
;; (truename ".")                          ; => #P"/home/hiro/howm/junk/"

;; (cd)                                    ; => 0
;; (pwd)                                   ; => #P"/home/hiro/"
;; "hiro"
;; (truename ".")                          ; => #P"/home/hiro/howm/junk/"
;; (user-homedir-pathname)                 ; => #P"/home/hiro/"

;; (defun cd (&optional dir)
;;   (let ((d (if dir
;; 	       (truename (merge-pathnames (make-pathname :directory `(:relative ,dir))
;; 					  (pwd)))
;; 	       (user-homedir-pathname))))
;;     (uiop:chdir d)))                    ; =>CD 


;; [2022-10-17 16:13:00]
(defun cd (&optional (dir (user-homedir-pathname)))
  (let ((d (merge-pathnames dir (pwd))))
    (uiop:chdir d)
    (pwd)))                             ; =>CD 

 (sb-ext:parse-native-namestring (sb-unix:posix-getcwd/)) ; =>#P"/home/"
 (sb-unix:posix-getcwd/)                                  ; =>"/home/" 
6 
(pwd)                            ; => #P"/home/"
"home"
*default-pathname-defaults*      ; => #P"/home/hiro/howm/junk/"
;; (defun ls (&optional (path (pwd)))
;;   (let ((files (mapcar #'file-namestring
;;                        (uiop:directory-files path)))
;;         (dirs (mapcar #'(lambda (x) (enough-namestring x (truename path)))
;;                       (uiop:subdirectories path))))
;;   (format t "~{~a~%~}" (append files dirs)))) ; =>LS 

;; (defun ls (&optional (path (pwd)))
;;   (let ((files (mapcar #'file-namestring
;;                        (uiop:directory-files path)))
;;         (dirs (mapcar #'(lambda (x) (enough-namestring x (merge-pathnames path (pwd))))
;;                       (uiop:subdirectories path))))
;;   (format t "~{~a~%~}" (append files dirs)))) ; =>LS 

;; (defun ls (&optional (path "*.*"))
;;   (let* ((file+dir (directory path)))
;;     (mapcar #'(lambda (x) (enough-namestring x (merge-pathnames path (pwd)))) file+dir))) ; => LS
;; (cd "howm/junk/test")                   ; =>0 
;; (pwd)                                   ; => #P"/home/hiro/howm/junk/test/"
;; (ls (pwd))                              ; => ("")

;; (defun ls (&optional (path (pwd)))
;;   (format t "~{~a~%~}"
;;           (mapcar #'(lambda (x) (enough-namestring x path))
;;                   (directory (merge-pathnames "*.*" path))))) ; =>LS 

(defun ls (&optional (path "*"))
  (format t "~{~a~%~}"
          (mapcar #'(lambda (x) (enough-namestring x (pwd)))
                  (cond ((or (equal path ".") (equal path "*"))
                         (directory (merge-pathnames "*.*" (pwd))))
                        ((equal path "*.*")
                         (set-difference
                          (directory (merge-pathnames "*.*" (pwd)))
                          (directory (merge-pathnames "*" (pwd)))))
                        ((equal path "-d")
                         (directory (merge-pathnames "*" (pwd))))
                        ((equal path "..")
                         (directory (merge-pathnames "*.*" (cd path))))
                        (t (directory (merge-pathnames path (pwd)))))))) ; =>LS 
(ls "~/howm/junk/test/*")               ; => test1/
test2/
NIL
test2/
NIL
b.lisp
c.lisp
test1/
test2/
NIL
test2/
NIL
(pwd)                                   ; => #P"/home/hiro/howm/junk/test/"
"test"
(ls "*")                                ; => a.lisp
b.lisp
c.lisp
test1/
test2/
NIL
hiro/howm/junk/test/test2/
NIL
(cd "~/howm/junk/test/test1")           ; => #P"/home/hiro/howm/junk/test/test1/"
"test1"
(ls "..")                               ; => a.lisp
b.lisp
c.lisp
test1/
test2/
NIL
NIL
NIL 
(ls)                                    ; => hiro/
linuxbrew/
NIL
(pwd)                                   ; => #P"/home/"
"home"
(cd "~/howm/jun")
(pwd)                                   ; =>#P"/home/"
"home" 
"hiro"
NIL 
NIL 
(cd "..")                               ; => #P"/home/hiro/howm/"
"howm"
NIL
b.lisp
c.lisp
test1/
test2/
NIL
b.lisp
c.lisp
test1/
test2/
NIL 
NIL
(ls "*.*")                              ; =>c.lisp
(ls "*.lisp")                           ; =>a.lisp
(cd "~/howm/junk/test")                                       ; => #P"/home/hiro/howm/junk/test/"
"test"
(pathname "/home/hiro")                 ; => #P"/home/hiro"
(ls "*")                                ; =>a.lisp
b.lisp
c.lisp
test1/
test2/
NIL 
b.lisp
c.lisp
test1/
test2/
NIL 
b.lisp
c.lisp
test1/
test2/
(set-difference (directory "*.*") (ls "*"))    ; =>a.lisp
b.lisp
c.lisp
test1/
test2/
test1/
test2/
NIL 
(ls "~/howm/junk/test/test1/*.*")       ; => test1/a.txt
test1/b.txt
test1/test3/
NIL
NIL
NIL 
NIL 
NIL 
NIL
NIL
linuxbrew/
NIL

(defun cat (&rest files)
  (dolist (f (apply #'directory files))
    (with-open-file (in f :direction :input)
      (loop :for line = (read-line in nil nil)
	    :while line
	    :do (format t "~a~%" line))))) ; =>CAT 

(defun touch (file)
  (with-open-file (out file
		       :if-does-not-exist :create))) ; =>TOUCH 

(defun rm (file)
  (let ((f (merge-pathnames file (pwd))))
    (delete-file f)))                   ; =>RM 

(defun mkdir (dir)
  (let ((d (if (zerop (mismatch "/" dir :from-end t))
	       dir
	       (format nil "~a/" dir))))
    (ensure-directories-exist
     (merge-pathnames (directory-namestring d)
		      (pwd)))))         ; =>MKDIR 


(defun rmdir (dir)
  (uiop:delete-empty-directory
   (merge-pathnames dir
		    (pwd))))            ; =>RMDIR 

(defun cp (in-file out-file)
  (uiop:copy-file (merge-pathnames in-file
				   (pwd))
		  (merge-pathnames out-file
				   (pwd)))) ; =>CP 

(defun pushd (dir)
  (push (pwd) directory-stack)
  (let ((d (merge-pathnames dir
			    (pwd))))
    (cd d)))                            ; =>PUSHD 

(defun popd ()
  (cd (pop directory-stack)))           ; =>POPD 

(defun date ()
  (multiple-value-bind (sec min hr date mon yr dow)
      (decode-universal-time (get-universal-time))
    (let ((jdow (nth dow '("月" "火" "水" "木" "金" "土" "日"))))
      (format t "~d年 ~d月 ~d日 ~a曜日 ~2,'0d:~2,'0d:~2,'0d " yr mon date jdow hr min sec)))) ; =>DATE 

(defun echo (x)
  (format t "~a" x))                    ; =>ECHO 

(defun head (file &key (n 10))
  (with-open-file (in file :direction :input)
    (loop :repeat n :for line = (read-line in nil nil)
	  :while line
	  :do (format t "~a~%" line)))) ; =>HEAD 

(defun wc (&rest files)
  (dolist (f (apply #'directory files))
    (with-open-file (in f :direction :input)
      (loop :for l = (read-line in nil nil)
	    :while l
	    :count l :into line
	    :sum (length (split " " l)) :into word
	    :sum (length l) :into char
	    :finally (format t "~d ~d ~d ~a~%" line word char f))))) ; =>WC 

(defun seq (&rest arg)
  ;; seq [OPTION]... LAST
  ;; seq [OPTION]... FIRST LAST
  ;; seq [OPTION]... FIRST INCREMENT LAST
  (let ((end (car arg))
        (start 1)
        (inc 1)
        (len (length arg)))
    (case len
      (2 (setq start end
               end (second arg)))
      (3 (setq start end
               inc (second arg)
               end (third arg))))
    (loop :for i :from start :to end :by inc
          :do (print i))))              ; =>SEQ 
