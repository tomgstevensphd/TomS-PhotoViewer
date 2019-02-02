;;*****************  TomsPhotoviewerScreensaver.lisp *********************
;;
;;
(in-package "CL-USER")
(load-all-patches)

;;; Where we are going to save the application (except on Cocoa)
(defvar *delivered-image-name*  "C:\\3-TS\\LISP PROJECTS TS\\screensaver\\TomsPhotoviewerScreensaver")       ;; "~/hello")

;;; Load the application code.
;;; We compile the file to the temporary directory
;;;  because the current directory is not necessarily writable. #|  (defparameter *my-config-file* "C:\\3-TS\\LISP PROJECTS TS\\MyConfigFiles\\my-config.lisp"  "Path of config file for most of my projects--should be loaded in first loaded project file")|#
;;  (compile-file (current-pathname *my-config-file*)  :load t)
  (compile-file (current-pathname  "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-BASIC-functions.lisp") :load t)
  (compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-files.lisp")  :load t)
  (compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-lists.lisp")  :load t)
  (compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-debug.lisp")  :load t)
  (compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-tstring.lisp")  :load t)
  (compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-capi.lisp")  :load t)
  (compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-photo-info.lisp")  :load t)
  (compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-sequences.lisp")  :load t)
  (compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-photos.lisp")  :load t)
 (compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\video-playback-utility\\video-playback-utility.lisp")  :load t)
  ;;NOTE THIS IS THE MPrun file VERSION OF SCREENSAVERMP
#|(compile-file (current-pathname "C:\\3-TS\\LISP PROJECTS TS\\screensaver\\screensaverMPrun.lisp")   ;; :output-file :temp 
             :load t)|#
(compile-file (current-pathname 
               "C:\\3-TS\\LISP PROJECTS TS\\screensaver\\screensaver.lisp")   ;; :output-file :temp 
             :load t)
;;; On Cocoa it is a little bit more complicated, because we need to
;;; create an application bundle.  We load the bundle creation code
;;; that is supplied with LispWorks, create the bundle and set
;;; *DELIVERED-IMAGE-NAME* to the value that this returns. We avoid
;;; copying the LispWorks file type associations by passing
;;; :DOCUMENT-TYPES NIL.  When the script is used to create a
;;; universal binary, it is called more than once. To avoid creating
;;; the bundle more than once, we check the result of
;;; SAVE-ARGUMENT-REAL-P before creating the bundle.

#|
#+cocoa
(when (save-argument-real-p)
  (compile-file (example-file "configuration/macos-application-bundle")
                :output-file :temp
                :load t)
  (setq *delivered-image-name*
        (write-macos-application-bundle "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\TomsPhotoviewerScreensaver.app"  
            :document-types nil)))  
|#
;;; Deliver the application

 (deliver   'manage-photo-processes        ;;function starting screensaver frame? 'TomsPhotoviewerScreensaver 
          *delivered-image-name* 0 :interface :capi :multiprocessing t)
;;(deliver 'hello-world *delivered-image-name* 5 :interface :capi)