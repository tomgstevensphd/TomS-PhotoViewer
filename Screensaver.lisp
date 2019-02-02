;; ************************** Screensaver.lisp *******************************

;;NOTES:
;;   TO-DO
;;LATER, MAKE WMPLAYER THE DEFAULT??, NEED TO CHANGE ARGS THOUGH
;; C:\Program Files (x86)\Windows Media Player\\wmplayer.exe
;;
;;   CAN GET DATA FOR TIFF FILES, SEE MY LIBRARY UNDER IMAGE
;;    ADJUST IMAGE SIZE TO FIT TVs

;; *** SCREENSAVER ADAPTED FROM:
;; -*- rcs-header: "$Header: /hope/lwhope1-cam/hope.0/compound/33/LISPcapi-examples/RCS/graphics:images.lisp,v 1.5.8.1 2009/08/21 21:13:01 davef Exp $" -*-
;;
(in-package "CL-USER")

;;put in all key files  (my-config-editor-after-start)

;;1-MUST LOAD U-files.lisp (or at least my-dos-copy and Seibel's files)

;;NOT USED IN DELIVER -- INSTEAD LOADED IN DELIVER FILE
(defun load-screensaver ()
;;  (defparameter *my-config-file* "C:\\3-TS\\LISP PROJECTS TS\\MyConfigFiles\\my-config.lisp"  "Path of config file for most of my projects--should be loaded in first loaded project file")
;;  (load *my-config-file*)
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-BASIC-functions.lisp")
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-files.lisp")
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-lists.lisp")
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-debug.lisp")
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-tstring.lisp") 
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-capi.lisp")
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-photo-info.lisp")
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-sequences.lisp")
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-photos.lisp")
  (load "C:\\3-TS\\LISP PROJECTS TS\\MyUtilities\\U-system.lisp")
  (load  "C:\\3-TS\\LISP PROJECTS TS\\video-playback-utility\\video-playback-utility.lisp")

  ;;for video
  
  )
;; (load-screensaver)


;;2-TO RUN TYPE (MTEST) AT PROMPT
;;
;;------------------------------ PARAMETERS --------------------------------
;

(defun initialize-screensaver ()
  ;;SHOW-DETAILS?
  ;;used selectively for calling show-text to make containers
  (defparameter *show-details nil)

  ;;SETTINGS PATH
  ;;note: ~/ writes to C:\\USERS\\SHERRY BENE STEVENS
  (defparameter *settings-filename "~/TomPhotoSettings.db")

  ;;FOR CAPI
  (defparameter *visible-border-p nil)
  ;;(defparameter *photo-transform-list '(1.0 0 0 1.0 0 0)   "used by GP for transforming photo dimensions")
  (defparameter *transform-correction-factor 1.0) ;;was 0.77)
  (defparameter *photo-viewer-interface-width 1200) 
  (defparameter *photo-viewer-interface-height 768) ;; error :maximize)
  (defparameter *photo-viewer-width  1200)
  (defparameter *photo-viewer-height  715)
  (defparameter *output-pane-width 1200 )  ;;was 1180)
  (defparameter *output-pane-height 715)  ;;was 680)
  (defparameter *rich-text-pane-height 35)
  (defparameter *pane-font-size 14)
  ;;sss start here eee to change color of text are to white on black
  (defparameter *rich-text-pane-foreground  :white )
  (defparameter *rich-text-pane-background  :black)  
  (defparameter *button-panel-background :white)
  ;;to change color (setf (capi:simple-pane-foreground self) color))

  ;; -------------- PHOTO ATTRIBUTES ----------------
  (defparameter *dir-sort-type :randomp
    "type of photo subdirectory sorting")
  (defparameter *all-or-photo-video :mix-all "Choices, mix-all, v-before, v-after, video-only, photo-only")
  *mix
  (defparameter *video-player-path "C:\\Program Files (x86)\\VideoLAN\\VLC\\vlc.exe")
  (defparameter *video-sleep-time  3)
  (defparameter *recursion-limit  50  "used in make-flat-dirs-list1 to limit max limit of recurssion calls. Enlarge number for very large directories")
  (defparameter *reverse-order-p nil "reverse order of photos and directories")
  (defparameter *main-photo-directory "C:\\Users\\Public\\Pictures")
  ;;was  "C:\\3-TS\\LISP PROJECTS TS\\screensaver")
  (defparameter *photo-directory *main-photo-directory "
    *photo-directory is changed by functions")
  (defparameter *photo-copy-dir "C:\\temp\\" "Accumulates copied photos")
  (defparameter *sort-type :randomp "Type of directory sort--default is :randomp")
  (defparameter *by-dir-or-file :dir "Sorting by sub-directory or by all individual files--dir is default")
  ;;not used??(defparameter *photo-sub-directory   "C:\\3-TS\\LISP PROJECTS TS\\MyProjects\\screensaver\\images")
  ;;was  ;; "C:\\3-TS\\LISP PROJECTS TS\\lispworks projects\\screensaver"
  (defparameter *current-photo-title "Current Photo")
  (defparameter *current-photo-file "Current photo file")
  (defparameter *current-photo-path-name "Current-photo-path-name")
  (defparameter *last-photo-path-name "Last-photo-path-name")
  (defparameter *current-photo-filename "Current-photo-filename")
  (defparameter *current-photo-date "Current photo date")
  (defparameter *current-photo-time "Current-photo-time")
  ;;
  (defparameter *current-photo-num  1)
  (defparameter *current-videos-in-dir 0)
  (defparameter *current-photos-in-dir 1)
  (defparameter *current-image nil)
  (defparameter *rich-text-pane-text "Photo information displayed here")
  (defparameter *rich-text-pane-font nil)
  (defparameter *photo-display-seconds 5)
  (defparameter *photo-display-hold nil)
  (defparameter *current-photo-info-list nil)
  (defparameter *hold-photo-seconds 30)

  (defun set-current-photo-info-list ()
    (setf *set-current-photo-info-list
          (list *current-photo-num *current-photo-path-name 
                *current-photo-date *current-photo-time 
                *current-photo-title)))

  (defparameter *image-file-filters* '("Bitmap" "*.bmp;*.dib" 
                                                "GIF"    "*.gif"  
                                                "JPEG"   "*.jpg;*.jpeg" 
                                                "PNG"    "*.png" 
                                                "TIFF"   "*.tif;*.tiff"))

  (defparameter *photo-file-types* '("bmp" "dib" "gif" "jpg" "jpeg" "png" "tif" "tiff" "BMP" "DIB" "GIF" "JPG" "JPEG" "PNG" "TIF" "TIFF"))
  ;;(defparameter *image-file-type-symbols* '(jpg jpeg tif tiff gif bmp dib png))
  (defparameter *video-file-types* '("VOB" "MOV" "MP4" "TS" ))

  ;;FOR MP
  (defparameter *default-height 200)
  (defparameter *lock nil)
  (defparameter *lock-timeout 60)
  (defparameter *lock-wait-reason "waiting-to be unlocked")
  (defparameter *condvar nil)
  (defparameter *condvar-timeout 10)
  (defparameter *condvar-timeout-reason "*pause-between-slides?")
  (defparameter *predicate 'equal)
  (defparameter *predicate-args '(2 5))
  (defparameter *return-function '+)
  (defparameter *return-function-args '(6 7 8))
  ;;moved to above (defparameter *current-photo-info-list nil)
  )
;;INITIALIZE SCREENSAVER
(initialize-screensaver)


;;SET-SCREEN-RESOLUTION
;;;;mmm
;;ddd  
(defun set-screen-resolution ()
  "In screensaverMP.lisp, checks screen size, then sets window and pane sizes"
  (let
      ((test-window-instance (make-instance 'size-test-interface))
       (width)
       (height)
       (screen-size-multiplier)
       (screen-size-multiplier-squ)
       )
    (capi:display test-window-instance)
    (setf  height (capi::pane-height test-window-instance)
           width (capi::pane-width test-window-instance))
    ;;set the global variables
    ;;ratio of actual display (TV etc) screen height to my standard computer screen
    (setf screen-size-multiplier ( / height *photo-viewer-interface-height))
#|     (setf screen-size-multiplier 0.95
           *photo-viewer-interface-height (* screen-size-multiplier  height))|#
           ;;was (* (/ height *photo-viewer-interface-height 1.0) 1.0))    
    ;; (setf screen-size-multiplier (* screen-size-multiplier screen-size-multiplier))
    ;; (show-text (format nil "height= ~A~%width= ~A~%screen-size-multiplier= ~A~%" height width screen-size-multiplier) 50 nil)
    ;;(afout 'out (format nil "height= ~A~%width= ~A~%screen-size-multiplier= ~A~%*photo-viewer-width= ~A~%" height width screen-size-multiplier *photo-viewer-width ))
    ;;according to my test, my XPS height= 746 width= 1211
    (screen-multiplier screen-size-multiplier)  ;;was screen-size-multiplier
    (sleep 2)
    (capi:destroy test-window-instance)
    ))
    

;;IF HIGH RESOLUTION SCREEN
;;ddd
;;mmm
(defun screen-multiplier (screen-size-multiplier)
  "In screensaverMP.lisp, must change screen sizes for higher resolution screens"
  (setf 
   *photo-viewer-width (round (* screen-size-multiplier *photo-viewer-width))
   *photo-viewer-height  (round (* screen-size-multiplier *photo-viewer-height))
   *output-pane-width   (round (* screen-size-multiplier *output-pane-width))
   *output-pane-height   (round (* screen-size-multiplier *output-pane-height))
   ;;no-too big *rich-text-pane-height  (round (* screen-size-multiplier *rich-text-pane-height))
   )
  ;;different formula for font size
  (if (<= screen-size-multiplier 1.4)
      (setf *pane-font-size (+ *pane-font-size 1)))

  ;;(afout 'out (format nil "AT End of SCREEN-MULTIPLIER, *photo-viewer-width=~A~%  *photo-viewer-height=~A~% *output-pane-width=~A~% *output-pane-height=~A~%" *photo-viewer-width  *photo-viewer-height  *output-pane-width *output-pane-height))
   

  ;;return values
  (values   *photo-viewer-width *photo-viewer-width *photo-viewer-height 
            *photo-viewer-height *output-pane-width  *output-pane-width
            *output-pane-height   *output-pane-height  *rich-text-pane-height
            *rich-text-pane-height *pane-font-size)
  )


#|(defun testin ()
  (let
      ((instance (make-instance 'size-test-interface))
       (width)
       (height)
       )
    (capi:display instance)
    (setf height (capi::pane-height instance)
          width (capi::pane-width instance))
    (show-text (format nil "height= ~A~%width= ~A~%" height width) 50 nil)
    ))
|#
;;SIZE-TEST-INTERFACE
;;ddd
(capi:define-interface size-test-interface ()
  ()
  (:panes
   (rich-text-pane1 
    capi:rich-text-pane
  
    :name "Tom's Photo Viewer and Screensaver"
    :external-min-height :screen-height
    :external-min-width :screen-width
    ;;  :internal-min-height 400
    :font (gp:make-font-description :size *pane-font-size  :weight :bold) ;; :slant :italic)
    :enabled nil ;;means USER can NOT edit the pane, set to t to edit
    :background *rich-text-pane-background
    ;; :foreground :red
    ;;      :visible-min-height *rich-text-pane-height
    ;;  :visible-max-height 30
    ;;error?   :visible-border nil
    :text (format nil "~%~%~%~%                                                                              TOM'S PHOTO VIEWER AND SCREENSAVER             ~%~%~%~%                                                                 ")

    ;;error?   :foreground *rich-text-pane-foreground
    ;;error?  :background *rich-text-pane-background
    )
   #|   (editor-pane-1
    capi:editor-pane)|#
   )
  (:layouts
   (column-layout-1
    capi:column-layout
    '(rich-text-pane1)))
  (:default-initargs
   :best-height    760 ;;1080 ;;  ;;not work :maximize
   :best-width    1160 ;;1900 ;; ;; not work :maximize
   :visible-min-height 400 ;; 600
   :title "size-test-interface"
   :display-state :maximized
   ;; :display-state :hidden
   ))


;;RESET-KEY-PARMETERS
;;ddd
(defun reset-key-parmeters ()
;;later unquote???  
 ;;cause problem with photo sizing (defparameter *photo-transform-list '(1.0 0 0 1.0 0 0))
  ;;  "used by GP for transforming photo dimensions"
  (setq *transform-correction-factor 0.77)     ;;was 0.77)
  (setq *current-photo-title "Current Photo")
  (setq *current-photo-file "Current photo file")
  (setq *current-photo-path-name "Current-photo-file-name")
  (setq *current-photo-date "Current photo date")
  (setq *current-photo-time "Current-photo-time")
  (setq *rich-text-pane-text "Photo information displayed here")
  (setq *current-image nil)
  (set-current-photo-info-list)
  )


;;THERE ARE 2 PROCESSES IN ADDITION TO THE INTERFACE. 
;;  1-See if new value is really being passed to main process/Interface process.
;;2-See if need to use some CAPI function to get it to the Interface properly
;; 3- Then try to merge with screensaver??



;; -------------------------------------------  INTERFACE -------------------------------

;;PHOTO-VIEWER  Interface
;;
;;ddd m
(capi:define-interface photo-viewer-interface ()
  ((image :initform nil))
  (:panes
   (output-pane1 capi:output-pane
                 ;;  :title "Current Photo"
                 ;;8-4-2013 was--may cause photos to disappear   :display-callback 'display-photo-viewer-callback eee
                 :horizontal-scroll nil
                 :vertical-scroll nil
                 :visible-min-width *output-pane-width  ;;must use or make it small
                 :visible-min-height *output-pane-height  ;;must use or make it small
                 :visible-border *visible-border-p
                 :background :black
                 ) 
   (rich-text-pane1
    capi:rich-text-pane
    :name "rich-text-pane"
    :internal-min-height *rich-text-pane-height
    :font (gp:make-font-description :size *pane-font-size  :weight :bold) ;; :slant :italic)
    :enabled nil ;;means USER can NOT edit the pane, set to t to edit
    :background *rich-text-pane-background
    :foreground *rich-text-pane-foreground
    :visible-min-height *rich-text-pane-height
    ;;  :visible-max-height 30
    ;;error?   :visible-border nil
    :text "Click SELECT for 1 photo; FILE or PHOTO-OPTIONS above, or SLIDESHOW to start"
    )
   (controller1 capi:push-button-panel
                :items '(:select... :close-image :Slideshow....) ;;was :copy-image  :hold-image) 
                :callbacks '(photo-viewer-change-image-callback
                             photo-viewer-close-image-callback 
                             photo-viewer-auto-select-callback
                             :foreground *rich-text-pane-foreground
                             :background *rich-text-pane-background
                             )
                :callback-type :interface
                :background *button-panel-background              
                :print-function 'string-capitalize)
   (controller2 capi:push-button-panel
                :items '( :hold-image :go-next :copy-image  :minimize  :close-all)  
                :callbacks '(photo-display-hold-callback photo-display-go-callback
                                   copy-display-image-file-callback   
                                   minimize-window-callback  close-photoviewer-callback)       
                :foreground *rich-text-pane-foreground
                :background *rich-text-pane-background                            
                :callback-type :interface
                :background *button-panel-background              
                :print-function 'string-capitalize)
  ;;end panes
   )

  (:layouts
   (main-layout 
    capi:column-layout 
    '(output-pane1  row-layout-1))  ;; editor-pane-1 display-pane-1 :divider))
   (row-layout-1 
    capi:row-layout
    '(rich-text-pane1 :divider   column-layout-2))  ;;     controller)))
   (column-layout-2
    capi:column-layout
    '(controller1 controller2)))

  ;;menus
  (:menu-bar file-menu  photo-order-menu video-playback-menu video-player-menu )
  (:menus
   (dir-or-file-order-menu
    ;;  "Order By Directories or All Files"
    :component
    (("Re-order Photo Directories Only"
      :data :by-dir)
     ("Re-order All Files--not Directories"
      :data :by-file)
     ("Take Directories in Order"
      :data :as-is)
     )
    :callback-type  :data-interface
    :selection-callback 'select-slide-order-type-callback
    :interaction :single-selection)
     
   #|  from rich-text-editor.lisp
   (alignment-menu-component
    :COMPONENT
    (("Align Left" :data :left)
     ("ALIGN RIGHT" :DATA :RIGHT)
     ("Align Center" :data :center))
    :interaction :SINGLE-SELECTION
    :selected-item-function #'(lambda (interface)
                                (with-slots (text-pane) interface
                                  (let ((values (capi:rich-text-pane-paragraph-format
                                                 text-pane `(:alignment :numbering))))
                                    (getf values :alignment :left))))
    :SELECTION-CALLBACK 'rich-text-editor-select-paragraph-attributes)
|#
   (photo-order-type-menu
    ;;no?   "Photo Options"
    :component
    (("Random Playback"
      :data :randomp)
     ("Descending Order Playback"
      :data :lessp)
     ("Ascending Order Playback"
      :data :greaterp)
     )
    :interaction :single-selection
    :callback-type :data-interface
    :callback 'select-slide-order-type-callback
    )
   ;;select-slide-order-type-callback (data-arg interface)
   ;;new
   (menu-display-time
    "Select SlideShow Display Time"
    (menu-display-time1))
   (menu-display-time1
    :component
    ;;If CHANGE THIS LIST, MUST CHANGE LIST IN 
    (("1" :data 1)("2" :data 2 )("3" :data 3  )("4" :data  4)("5" :data  5)("6" :data  6)("7" :data 7)("8" :data  8)("9" :data  9)("10":data 10)("12" :data  12)("14" :data  14)("16" :data 16 )("18" :data 18 )("20" :data  20)("25" :data  25)("30" :data  30)("45" :data  45)("60":data 60))
    :interaction :single-selection
    :selection-function 'get-display-seconds-index
    :callback-type :data-interface
    :selection-callback 'photo-display-seconds-callback
    )
   #| from capi-ref
   (setq list (capi:contain
               (make-instance 'capi:list-panel
                              :ITEMS '(:red :blue :green)
                              :SELECTED-ITEM :BLUE
                              :print-function
                              'string-capitalize))) 
;; USE THIS FUNCTION IN ARGLIST TO SET DEFAULT??
:selected-item-function  A setup callback function to dynamically
compute the selected item.
 |#

   (file-menu
    "File"
    (
#|     ("Copy Photo to SAVED-PHOTOS Directory"
      :callback 'copy-display-image-file-callback
      :callback-type :interface)|#

     ("Select SLIDESHOW Photo Directory"
      :callback 'select-slideshow-dir-callback
      :callback-type :interface)
     ("Select Saved-Photos Directory"
      :text "Slideshow photos played from this directory"
      :callback 'select-saved-dir-callback
      :callback-type :interface)
     ;;new
     ;;  menu-display-time
     ;;end new
     ("SAVE ALL SETTINGS"
      :callback 'save-settings-callback
      :callback-type :interface
      )
     ("Close Photoviewer"
      :callback 'close-photoviewer-callback
      :callback-type :interface
      )
     ;;   photo-order-menu
     ;;   dir-or-file-order-menu
     ))
   (photo-order-menu
    "Photo Time & Order"
    (menu-display-time
     photo-order-type-menu
     dir-or-file-order-menu
     ("SAVE ALL SETTINGS"
      :callback 'save-settings-callback
      :callback-type :interface)))
   (video-playback-menu 
    "Video Playback"
    (video-playback-menu1))
   (video-playback-menu1
    :component
    (("Playback videos in order taken"
      :data 'mix-all)
     ("Playback videos AFTER all photos"
      :data 'v-after)
     ("Playback videos BEFORE all photos"
      :data 'v-before)
     ("Do not play videos--only photos"
      :data 'photo-only)
     ("Play videos only--no photos"
      :data 'video-only)
     )
    :interaction :single-selection
    :callback-type :data-interface
    :callback 'video-play-callback
    )
   (video-player-menu 
     "TO PLAY VIDEOS Select Video-player file PATH" 
     ("SELECT VLC PATH: NOTE: VLC Video-player file PATH (eg. \"c:\\    \") ONLY ACCEPTABLE MEDIA PLAYER AT PRESENT")
      :callback 'select-video-player-callback
      :callback-type :interface)
;;(defparameter *video-player-path "C:\\Program Files (x86)\\VideoLAN\\VLC\\vlc.exe")
   )
  ;;end new menus
  (:default-initargs
   :title "Tom's Photo Viewer and Screensaver"
   :layout 'main-layout
   :best-width *photo-viewer-interface-width
   :best-height *photo-viewer-interface-height
   :window-styles '(:borderless :internal-borderless  :always-on-top)

   ;;   :visible-border *visible-border-p
   :default-display-state :maximized
   ;;added -- reduces size of outside borders a little?
   :external-border  -20
   :internal-border 0
   :display-state :maximized
   ;;error? :automatic-resize t
   ))



#|
;;may be needed to display photo??
(defmethod initialize-instance :after ((self photo-viewer-interface) &key
                                       &allow-other-keys)
  (update-photo-viewer-enabled self))
|#
;; FOLLOWING MAY BE USELESS FOR NOW--TRY NOT USING IT----
;;INITIALIZE-INSTANCE method for :after
;;ddd
#|(defmethod initialize-instance :after ((self photo-viewer-interface) &key
                                       &allow-other-keys)
  "In LwScreensaver, added to add panes so can modify them (can't if in original window slots, each call must make new instances of panes etc"
  (with-slots (viewer rich-text-pane1 controller) self
    (setf (CAPI:DISPLAY-PANE-TEXT rich-text-pane1)       ;;  "Display pane text"
          (make-photo-text self t))
    (update-photo-viewer-enabled self)
    ))|#

;;------------------------------------- MP PROCESS FUNCTIONS -------------------

;;MANAGE-PHOTO-PROCESSES function           
;;ddd
(defun manage-photo-processes ()  ;;no args for Deliver?  text height)
  "In ScreensaverMP, manages all processes makes the basic specific-instance elements"
  (let ((manager-mailbox (mp:ensure-process-mailbox))
        (text "Tom's Photoviewer and Screensaver")
        (height 100)
        ) 

    ;;xxxx
    ;;INITIALIZE SCREENSAVER (some may be overridden below)
    (initialize-screensaver)
    ;;bbb
    ;;READ IN FILE PARAMETER DEFAULTS TO OVERRIDE DEFPARAMETERS
    ;; IF *settings-filename is a real file that exists
    (load-eval-db *settings-filename :eval-value nil) 
    ;;(afout 'out (format nil "*PHOTO-DISPLAY-SECONDS= ~A~%" *PHOTO-DISPLAY-SECONDS))
    
    ;;SET SCREEN RESOLUTION
    ;;creates a test interface, measures it, then calculates sizes to set panes in photo interface
    (set-screen-resolution)
    ;;close the window

    ;;must I make these: lock and condvar global variables??
    ;;Step 1: make lock Do it here to refresh it with each initialization.
    (setf *lock (mp:make-lock :name "my-condvar-lock")
     *condvar (mp:make-condition-variable :name "my-manage-process-condvar") )
    ;;Step 2: make the interface instance
    (capi:display 
     (setf *photo-viewer-instance (make-instance  'photo-viewer-interface)))
    ;;Step 3: Start the "main process  AND Step 4: main-process-work-function
    ;; NOTE: currently this process is DOING NOTHING - just for possible future use
    ;;mmm
    ;;try setting the default display time in the menu here to *photo-display-seconds
    ;;doesn't work
    #|   (with-slots ( menu-display-time1)     *photo-viewer-instance
    (setf (capi:choice-selected-item "5") menu-display-time1))|#

    (setf *main-process
          (mp:process-run-function "main process" '(:mailbox "main-process-mailbox")
                                   'main-process-work-function "arg-text" ))
    ))

;;ddd
;;THIS IS CURRENTLY DOING NOTHING
(defun main-process-work-function (text)
  "Step 4: called by the process-run-function of the main process"
  (let ((x)
        )   
   ;;  (if *show-details  (show-text "Step 4: STARTING main-process-work-function" 100 'title ))
    ))

;;THE INTERFACE PROCESS AUTO-SELECT-CALLBACK 
;;This RUNS IN THE INTERFACE PROCESS, but CREATES THE CALCULATOR PROCESS
;;ddd
(defun photo-viewer-auto-select-callback (interface)
  " Step 5: calls my-lock-and-condition-variable-wait called by the interface-instance when "go" button pushed and Step 6: uses process-run-function to start calculator-process "
  (with-slots (image rich-text-pane1 output-pane1)   interface ;;*photo-viewer-instance
    (let ((x)
          )  
        (if *show-details  (afout 'out (format nil "STEP 5:IN START-CALLBACK, starting the CALCULATOR PROCESS")))
      ;;starting the calculator process
      ;;reset the *current-photo-info-list to default values
      (set-current-photo-info-list)
      (setf  *calculator-process
             (mp:process-run-function "calculator-process" '()
                                      'calculator-process-work-function interface))

      ;;locking the MP condition-variable so  process will wait and later interupt on signal
      (my-lock-and-condition-variable-wait 
       "Step 6: SETTING *return-function-value TO my-lock-and-condition-variable-wait result"
       *default-height *lock *lock-timeout *lock-wait-reason
      *condvar  *condvar-timeout *condvar-timeout-reason
       *predicate  *predicate-args  'get-current-photo-info-list 
       (list "FROM START-CALLBACK, my-lock-and-condition-variable-wait" NIL))
      ;;If the above function is held in a wait, then perhaps it won't execute the following until the
      ;;   global *current-photo-info-list has been set from the calculator

      ;;end of let, with-slots, defun
      )))
  

;;CALCULATOR-PROCESS-WORK-FUNCTION
;; MAIN IMAGE MANAGER
;;
;;ddd
(defun calculator-process-work-function (interface)
  "Step 7: MAIN IMAGE MANAGER--CALCULATOR-PROCESS-WORK-FUNCTION. CALCULATES photo info and uses mp:condition-variable-signal to send info"
  ;;(afout 'out (format nil ">>>>>> STARTING calculator-process-work-function~%"))
  (with-slots (output-pane1 image rich-text-pane1) interface
    ;;modified starts here
    (let ((organized-file-list)
          (dir-complete-flat-list)
          (photo-file-list)
          (video-file-list)
          (image-file-list)
          (all-image-file-list)
          (image-file-length)
          (temp-video-files)
          (condvar-signalled-p)
          (current-photo-info-list)
          (all-or-photo-video *all-or-photo-video)
          )
      ;;organized-file-list is a flat list of all subdirectory files (by dir or all files, random, etc)
      (multiple-value-setq (organized-file-list flat-subdirs-list dir-complete-flat-list)
          (organize-subdirs *photo-directory *sort-type *by-dir-or-file))
      ;; (afout 'out (format nil ">>>>>> PRE DOLIST calculator-process-work-function~%organized-file-list= ~a~% " organized-file-list))

       ;;must process each subdir individually
      (dolist (file-list organized-file-list)

        ;;old below this point--added above
        (setf *current-photo-num  0
              *current-photos-in-dir 0
              ;;was problem adding new photo files to list already viewed--so added this
              photo-file-list nil
              all-image-file-list nil
              video-file-list nil
              )
        ;;(afout 'out (format nil ">>>>>> PRE-SLEEP calculator-process-work-function~%"))
  
        ;;PRE-PHOTO-PROCESSING STATE (from MP)
       ;; (sleep 3)   
  ;;(afout 'out (format nil "*1.PRE-SET condvar-signalled-p= ~A~%"  condvar-signalled-p))
        ;;from old screensaver processing     
        (if *show-details (afout 'out (format nil "XXX=> START NEW SLIDE PRESENTATION~% 1 file-list= ~A~%" file-list)))

        ;;GET OVERALL DATA ON DIR AND MAKE ALL-IMAGE, PHOTO, VIDEO LISTS
        (dolist (file file-list)
          ;;below   (if *show-details (afout 'out (format nil "*current-photo-num= ~A~%file= ~A% pathname-type= ~A~%" *current-photo-num  file  (pathname-type file))))
          (cond
           ((member (pathname-type file) *photo-file-types* :test 'equal)
            (setf photo-file-list (append photo-file-list (list file))
                  all-image-file-list (append all-image-file-list (list file)))
            (incf *current-photos-in-dir)
            )
           ((member (pathname-type file) *video-file-types* :test 'equal)
            (setf video-file-list (append video-file-list (list file))
                   all-image-file-list (append all-image-file-list (list file)))
            (incf *current-videos-in-dir)
            )
           (t nil))
          ;;end dolist
          )
        
        ;;PROCESS ALL-IMAGE, PHOTO-ONLY, OR VIDEO-ONLY FILES
        ;; Choices are: 'mix-all, v-before, v-after, 'video-only, 'photo-only
        ;;Make the image-file-list 
        (cond
         ((equal all-or-photo-video :mix-all)
          (setf image-file-list all-image-file-list)
          (setf image-file-list 
                (nth-value 1  (sort-directory-filenames  nil :file-list all-image-file-list)))
          )
         ((equal all-or-photo-video :v-before)
          (setf image-file-list (append video-file-list photo-file-list)))
         ((equal all-or-photo-video :v-after)
          (setf image-file-list (append  photo-file-list video-file-list)))
         ((equal all-or-photo-video :photo-only)
          (setf image-file-list photo-file-list))
         ((equal all-or-photo-video :video-only)
          (setf image-file-list video-file-list)))

        (setf image-file-length (list-length image-file-list))

        ;;PROCESS EACH IMAGE (photo or video) FILE ------------------------------------
        (loop
         for file in image-file-list
         for n from 1 to image-file-length
         do      

         (if *show-details  (afout 'out (format nil  "~%2 all-image-file-list= ~A~%photo-file-list= ~A~%video-file-list= ~A~% *current-photos-in-dir= ~A~% " all-image-file-list photo-file-list video-file-list *current-photos-in-dir)))

         (cond
            ;;WHEN  EITHER END OF LIST or current file is photo, PROCESS VIDEO-FILES
             ((and temp-video-files 
                  (or (= n image-file-length)
                      (member (pathname-type file) *photo-file-types* :test 'equal)))

           ;;HOLD PROGRAM HERE & MINIMIZE WINDOW
           (capi:hide-interface *photo-viewer-instance)
           (sleep *video-sleep-time)
           ;;PUT CODE HERE TO HOLD ;;(MP:PROCESS-WAIT "Waiting for result" #'resultp)
           (mp:process-wait "Waiting for video" #'play-video *video-player-path  temp-video-files)
           (setf temp-video-files nil)
           ;;When returns, restart program
           (sleep *video-sleep-time) 

           (capi:show-interface *photo-viewer-instance)
           ;; (setf  *video-player-path "C:\\Program Files (x86)\\VideoLAN\\VLC\\vlc.exe" *video-sleep-time 4)

           ;;end when process video file list WHEN right time
           )

         ;;PHOTO or  VIDEO FILE [Process photo, just add video file to video-file-list]
          ((member (pathname-type file) *photo-file-types* :test 'equal)
           ;;PROCESS EACH PHOTO FILE -----------------------------------
           (incf *current-photo-num)
           (if *show-details  (afout 'out (format nil  "4 dolist file= ~a~%" (file-namestring file))))
           ;;WORK ON GP STATE HERE
           (when (and file (probe-file file))
             (let* ((external-image (gp:read-external-image file))
                    (photo-transform-list '(1.0 0 0 1.0 0 0))
                    (graphics-state ) ;; (gp:port-graphics-state output-pane1))
                    (graphics-state-transform)
                    )
               (cond
                (external-image  
                 (gp:with-graphics-state (output-pane1 :transform '(1.0 0 0 1.0 0 0))
                   ;;find current transform list --should be same as just set above -- redundant?
                   (setf photo-transform-list (gp:graphics-state-transform (gp:port-graphics-state output-pane1)))  

                   ;;1. DISPLAY-PHOTO-IMAGE is the real calculator work function 
                   ;;first clear the output-pane
                   (gp:invalidate-rectangle output-pane1)
                   (ignore-errors ;;added 10-2013
                     (multiple-value-setq (image photo-transform-list)
                         (display-photo-image interface file external-image photo-transform-list :photo-display-seconds *photo-display-seconds)))
                   (setf condvar-signalled-p  (mp:condition-variable-signal *condvar))
                   (if *show-details  (afout 'out (format nil  "2.POST-SET condvar-signalled-p= ~A~%"        condvar-signalled-p)))
                   ))
                (t 
                 (setf (capi:rich-text-pane-text rich-text-pane1) "PROBLEM WITH EXTERNAL-IMAGE")
                 ;;was  (show-text "PROBLEM WITH EXTERNAL-IMAGE" 100 NIL)
                 ))
               ;;END Original PHOTO-ONLY code --------------------------------------------------------
               )))
         
             ;;WHEN A VIDEO FILE, PUT ON LIST--NOT PROCESS YET
             ((member (pathname-type file) *video-file-types* :test 'equal)
             (setf temp-video-files (append temp-video-files (list file)))
             )      
          (t nil))

         ;;end loop for each image
         )
        ;;end dolist for all subdirs
        )
      ;;see if following takes care of problem of photo sizes being wrong next photo-show
      ;;testing (reset-key-parmeters)
    
     (setf (capi:rich-text-pane-text rich-text-pane1) (format nil "~%SLIDE SHOW COMPLETED FOR FILES=> ~A"  *photo-directory))
   ;;was
#|      (show-text (format nil "~%SLIDE SHOW COMPLETED FOR FILES=>~% ~A~%"  *photo-directory) 70 nil) |#   

      ;;end with-slots, let, calculator-process-work-function
      )))



;;GET-CURRENT-PHOTO-INFO-LIST  
;;ddd
(defun get-current-photo-info-list (text show-value-p) 
  "In my-callback used by my-lock-and-condition-variable-wait as return-function"
  (let ((current-photo-info-list *current-photo-info-list )
        )
    (if show-value-p
        (show-text (format nil "FROM= ~A~%In GET-CURRENT-PHOTO-INFO-LIST, 
   *current-photo-info-list= ~A~%" text   current-photo-info-list) 100 nil)
    *current-photo-info-list)))
  


;;MY-LOCK-AND-CONDITION-VARIABLE-WAIT  
;;ddd
(defun my-lock-and-condition-variable-wait 
       ( text height lock lock-timeout lock-wait-reason
              condvar condvar-timeout condvar-wait-reason
              predicate predicate-args 
              return-function return-function-args)
  (let ((text (format nil "PRE Function lock-and-condition-variable-wait, text= ~A~%height=~A~%
                lock= ~A lock-timeout=~A lock-wait-reason= ~A~% 
                condvar= ~A condvar-timeout= ~A condvar-timeout-reason= ~A~%
                predicate= ~A predicate-args= ~A~%
                return-function= ~A return-function-args= ~A~%"
                      text height lock lock-timeout lock-wait-reason
                      condvar condvar-timeout condvar-wait-reason
                      predicate predicate-args 
                      return-function return-function-args))
        )
   (if *show-details (afout 'out (format nil "text= ~A~% height= ~A~%" text height)))
    (mp:lock-and-condition-variable-wait lock condvar predicate :args predicate-args
                                         :return-function return-function
                                         :return-function-args return-function-args
                                         :lock-timeout lock-timeout :lock-wait-reason lock-wait-reason
                                         :condvar-timeout condvar-timeout
                                         :condvar-wait-reason condvar-wait-reason)
    ))

;;CCC--------------------------------- CAPI PHOTO PROCESSING FUNCTIONS ---------


;;DISPLAY-PHOTO-VIEWER-CALLBACK
;;ddd
(defun display-photo-viewer-callback (pane x y width height) ;;can't add more args? viewer-title)
  "in ScreensaverMP, "
  (let* ((image-width 0)
        ;;added
        ;;  (port-width width)
        (photo-transform-list (gp:graphics-port-transform pane))
        )
    (with-slots (image) (capi:top-level-interface pane)

      (cond
       ((and image 
             ;; gp:rectangle-overlap args are x1 y1 x2 y2  x3 y3  x4 y4 means 1=top/left 2=bot/R rectangle1; 3=top/L 4=bot/R rect2

             ;;sss what is this for -- test without it??
             (gp:rectangle-overlap x y (+ x width) (+ y height)
                                   0 0 (gp:image-width image) (gp:image-height image))
             )
        (setq image-width (gp:image-width image))
     ;;zzz test works w/o this
   ;; WRONG (setq image-width (round (* image-width (car photo-transform-list)))) 

        ;;(fout is placed inside (mtest) function-- run (fout out) - no quote in listener at end
        ;;(afout 'out (format nil "***>> In display-photo-viewer-callback, image= ~A~%~%" image))
        ;;(afout 'out (format nil "photo-transform-list= ~A~%" photo-transform-list))
        )        
       (t nil))
      )))


;;UPDATE-PHOTO-VIEWER
;;ddd
(defun update-photo-viewer (interface)
  (with-slots (output-pane1 image) interface
    (gp:invalidate-rectangle output-pane1)
   (capi:set-horizontal-scroll-parameters output-pane1 :min-range 0 :max-range (if image (gp:image-width image) 0))
  (capi:set-vertical-scroll-parameters output-pane1 :min-range 0 :max-range (if image (gp:image-height image) 0))
    ;;reset gp transform values to default 7-31-2013
   (setf photo-transform-list '(1.0 0 0 1.0 0 0))
    (gp:set-graphics-state  output-pane1 :transform photo-transform-list)
   (setf graphics-state-transform (gp:graphics-port-transform output-pane1))
  ;;  (setf graphics-state-transform (gp:set-graphics-state output-pane1 :transform 
    ;;                                                        photo-transform-list)) 
    ;zzz
    ;;(afout 'out (format nil "In update-photo-viewer, graphics-state-transform= ~A~%"                         graphics-state-transform ))
                        ;;or use (gp:port-graphics-state output-pane1)??
    (update-photo-viewer-enabled interface)))


;;UPDATE-PHOTO-VIEWER-ENABLED
;;ddd
(defun update-photo-viewer-enabled (interface)
  (with-slots (controller1 controller2 image) interface
    (capi:set-button-panel-enabled-items
     controller1 :set t)
    (capi:set-button-panel-enabled-items
     controller2 :set t)
    #|(if image
        (capi:set-button-panel-enabled-items
         controller
         :set t)
      (capi:set-button-panel-enabled-items
       controller
       :set t
       :disable '(:close)))|#
    ))


;;DISPLAY-PHOTO-IMAGE
;;ddd
(defun display-photo-image (interface file new-external-image gp-transform-list
                                      &key (photo-display-seconds  4)
                                      (new-transform-list '(1.0 0 0 1.0 0 0)) 
                                      (viewer-pane-height *photo-viewer-height))
  "LwScreensaver.lisp, used to display external images and modify them. Modify this function to assess input image and transform so it fits the output window."

  (with-slots (output-pane1 image rich-text-pane1) interface
    ;;moved to outside (gp:with-graphics-state (output-pane1 :transform '(1.0 0 0 1.0 0 0))

    ;;CLEAR THE OLD IMAGE IF THERE IS ONE  (not needed w/ local vars??)
    #|      (cond
       (image
        ;;following works--no need to close image manually to avoid a system crash
        (gp:free-image output-pane1 (shiftf image nil))
       ;;testing no longer needed w/ local values??? (update-photo-viewer interface)
        )
       (t nil))|#
    ;;(afout 'out (format nil  "~%****> BEGIN  display-photo-image~%--> file= ~A~% ~% " file))

    (setf  *current-photo-file file)
    (let*
        ((image new-external-image) ;;5-16 stopped flicker was  (gp:load-image output-pane1 new-external-image))
         ;;   (gp-transform-list) ;;was (gp:graphics-port-transform output-pane1))
         (image-width)
         (image-height)
         (output-pane-height *output-pane-height)
         (x-origin 0)
         (pane-image-height-ratio 1.0)
         (gp-x-transform) ;;was  (first gp-transform-list))
         (gp-y-transform) ;;was (fourth gp-transform-list))
         (new-x-transform (first new-transform-list)) ;;default value
         (new-y-transform (fourth new-transform-list)) ;;default value
         (graphics-state)
         (graphics-state-transform)
         ;;(transformed-image)
         )
      ;;wait or choose
      ;;(format t "  A-Time= ~A ~%" (get-decoded-time))

      ;;1. CLEAR OUTPUT-PANE1
     ;;closes photos prematurely  (gp:invalidate-rectangle output-pane1)
      #|  ;;5-16test don't need to do this now, also image no longer exists
      (capi:set-horizontal-scroll-parameters output-pane1 :min-range 0 :max-range 
                                             (if new-external-image (gp:image-width image) 0))
      (capi:set-vertical-scroll-parameters output-pane1 :min-range 0 :max-range 
                                           (if new-external-image (gp:image-height image) 0))
      |#
      
      ;;2. READY THE  OUTPUT-PANE1
      ;;NOT NEEDED??
     ;; (display-photo-viewer-callback output-pane1 0 0 *photo-viewer-width 
     ;;       *photo-viewer-height)

      ;;3. FIND IMAGE DIMENSIONS by PRE-LOADING but not displaying it
      ;;must load-image after display pane above
      (setf image (gp:load-image output-pane1 image))
      ;;then check the image parameters
      (setf gp-transform-list (gp:graphics-port-transform output-pane1))
      (setf gp-x-transform  (first gp-transform-list)
            gp-y-transform (fourth gp-transform-list))

      ;;get the image height-width (width seems to almost always be <= pane width)
      (setf image-height (gp:image-height image)
            image-width (gp:image-width image))
      (if *show-details  (afout 'out (format nil  "2 image= ~A~% image-height= ~A~%image-width= ~A~%" image image-height image-width)))

      ;;4. FIND NEW TRANSFORMS -- compare pane height to image height

;;eee START HERE-LOOK UP PANE HEIGHT
;; note difference between output-pane-height and viewer-pane-height
;;   which to use?? was using viewer-pane-height, try output-pane-height?
      (setf output-pane-height (capi::pane-height output-pane1))
      (setf pane-image-height-ratio (/ output-pane-height  image-height))
    ;;was  (setf pane-image-height-ratio (/ viewer-pane-height  image-height))
      (if *show-details  (afout 'out (format nil  "~%****> BEGIN  display-photo-image--> file= ~A~% PRE-TRANSFORMS:~%output-pane-height= ~A~% viewer-pane-height= ~A image-height= ~A~% pane-image-height-ratio= ~A~% " file output-pane-height viewer-pane-height image-height pane-image-height-ratio)))
      
      ;;set the new x and y transforms (for gp graphics port) based upon height ratio * correction factor
      ;;my original method -- not using apply-scale transform sx sy
      (setf new-x-transform (* pane-image-height-ratio *transform-correction-factor)
            new-y-transform (* pane-image-height-ratio *transform-correction-factor))
      (setf new-transform-list (list new-x-transform 0 0 new-y-transform 0 0))

      ;;CENTER PHOTO
      (setf pane-width (gp:port-width output-pane1))
 ;;BEST     (setf x-origin (round (* 1.2 (/ (-  pane-width  (* image-width new-x-transform (sqrt new-x-transform))) 2))))
;;  (setf x-origin (round (* 1.0 (/ (-  pane-width (* image-width new-x-transform) ) 2))))
  (setf x-origin (round (* 1.0 (/ (-  (* (/ 1.0 new-x-transform) pane-width) (* image-width 1.0) ) 2))))
;;      (setf x-origin (round (* 1.0 (/ (-  pane-width  (* image-width new-x-transform (/ 1.0 .77))) 2))))
;;aaa
;;(setf x-origin (round (* 0.55 (/ (- pane-width  (* image-width new-x-transform .65)) 2))))
;;   (setf x-origin (round (*-x-transform 2)  (/ (- pane-width image-width) 2))))
;;  (setf x-origin (round (* 1.0 (/ (- pane-width  (* image-width new-x-transform)) 2))))
;;  (setf x-origin (round (* 1.0 (/ (- pane-width  (* image-width  new-x-transform new-x-transform)) 2))))
#|  (setf x-origin  (round  (sqrt (/ (* 1.0 (- (* pane-width pane-width new-x-transform )  
                          (* image-width image-width   )))  2  ))))|#
       ;;(afout 'out (format nil "x-origin1= ~A~%" x-origin))
       (if (< x-origin 0)
           (setf x-origin 0))
  
      (if *show-details  (afout 'out (format nil "> STEP 1: TRANSFORMS: new-x-transform= ~A new-y-transform= ~A~% pane-image-height-ratio= ~A~%"            new-x-transform new-y-transform pane-image-height-ratio)))

#|      (if *show-details  (afout 'out (format nil "> STEP 2: TRANSFORMS: new-x-transform= ~A new-y-transform= ~A~%pane-width= ~A, image-width= ~A~%x-origin= ~A~%" new-x-transform new-y-transform pane-width image-width x-origin)))|#

      ;;CHECK -- get graphics state info
      ;; to check if it is at ORIGINAL DEFAULT 1.0 VALUES
      (setf graphics-state (gp:port-graphics-state output-pane1))
      (if *show-details  (afout 'out (format nil "G1 output-pane1= ~A~% image= ~A~% GRAPHICS STATE= ~a~%" output-pane1 image graphics-state)))

      ;;5. CHANGE GP TRANSFORM LIST
      (setf graphics-state-transform (gp:set-graphics-state output-pane1 :transform 
                                                            new-transform-list)) ;;works '(.5 0 0 .5 0 0))

      ;;CHECK GP TRANSFORM LIST etc TO SEE IF CHANGED FROM ABOVE
      (setf graphics-state (gp:port-graphics-state output-pane1))
              
      (if *show-details  (afout 'out (format nil "STEP 2:  AFTER NEW TRANSFORM, output-pane1= ~A~% external-image= ~A~% GRAPHICS STATE= ~a~%" output-pane1 image graphics-state)))

      ;;6. FIND-SHOW THE PHOTO-INFO
      (setf-photo-info *current-photo-num *current-photos-in-dir file image )
      (if *show-details  (afout 'out (format nil "*rich-text-pane-text= ~A~%"  *rich-text-pane-text)))
      (setf (capi:rich-text-pane-text rich-text-pane1)  *rich-text-pane-text)
      ;;wait or choose
      ;; (format t "  A-Time= ~A~%" (get-decoded-time))

      ;;7. LOAD AND DISPLAY THE IMAGE WITH NEW TRANSFORM LIST
      (setf image (gp:load-image output-pane1 image))
      (gp:draw-image output-pane1 image  x-origin 0)
                  
      ;;CHECKING FOR DEBUGGING BELOW
      (setf graphics-state-transform (gp:graphics-state-transform (gp:port-graphics-state output-pane1)))    
      (if *show-details  (afout 'out (format nil "G3 POST-DRAW IMAGE output-pane1= ~A~% image= ~A~% GRAPHICS STATE= ~a~% GP-state TRANSFORM= ~A~%" output-pane1 image graphics-state graphics-state-transform)))
  
      ;;8.SLEEP TIME IS LENGTH PHOTO SHOWS
     ;;     (sleep photo-display-seconds) ;;was  (sleep *photo-display-seconds)
     (dotimes (i photo-display-seconds)
       (sleep 1)
       (cond
        ((equal *photo-display-hold 'hold)
         (setf  *photo-display-hold nil)
         (sleep 10))
        ((equal *photo-display-hold 'go)
         (return (setf *photo-display-hold nil))))
       ;;end dotimes
       )
       ;;was--delete this?? 
       ;;8b. Additional sleep time if push button fff
     ;;  (hold-photo-display  *hold-photo-seconds)

      ;;end display-photo-image
      (values image gp-transform-list)
      )))


;;PHOTO-VIEWER-CHANGE-IMAGE-CALLBACK
;;ddd
(defun photo-viewer-change-image-callback (interface)
  (with-slots (output-pane1 image rich-text-pane1) interface  ;;*photo-viewer-instance
    (gp:with-graphics-state (output-pane1 :transform '(1.0 0 0 1.0 0 0))
      (gp:invalidate-rectangle output-pane1)

      (let ((file (capi:prompt-for-file "Choose a photo"
                                      :pathname (pathname-location #.(current-pathname))
                                      ;;was :filter (second *image-file-filters*) only .bmp files
                                      :filters *photo-file-filters*
                                      :ok-check #'(lambda (file)
                                                    (member (pathname-type file) *image-file-types* :test 'equalp))))) 

        (when (and file (probe-file file))
          (let ((external-image (gp:read-external-image file))
                (text1)
                (text2)
                (rich-text-pane-text)
                (graphics-state)
                (graphics-state-transform)
                )   
            ;;
            (setf *current-photo-filename (file-namestring file))
            ;;new
            (setf photo-transform-list (gp:graphics-port-transform output-pane1))
            (setf text1 (format nil "IN photo-viewer-change-image-callback:~%
                image= ~A~%file= ~A~%1 external-image= ~A~%
                1 photo-transform-list= ~A~%*current-photo-filename= ~A~%" image file external-image photo-transform-list *current-photo-filename))
            (if *show-details (afout 'out (format nil " text1= ~A~%" text1)))

            (cond
             (external-image   
              ;;DISPLAY THE PHOTO IMAGE
              (ignore-errors
                (multiple-value-setq (image photo-transform-list)
                    (display-photo-image interface file external-image photo-transform-list )))

              (if *show-details (afout 'out (format nil "In photo..callback, Text2 new-image= ~A~% photo-transform-list= ~A~%file= ~A~%" image photo-transform-list file)))
              ;; (update-photo-viewer interface)

              )
             (t 
              (if *show-details (show-text "=>EXTERNAL-IMAGE IS NIL" 200 nil))
              nil))
            ;;end let, when
            )))
      ;;end photo-viewer-change-image-callback
      )))



;;PHOTO-VIEWER-CLOSE-IMAGE-CALLBACK
;;ddd
(defun photo-viewer-close-image-callback (interface)
  "In LwScreensaverX.lisp, Starting function.  Notes: Must close image betw/ images if use the Change Photo button."
  (with-slots (output-pane1 image) interface
    (gp:free-image output-pane1 (shiftf image nil))
    (update-photo-viewer interface)))


;;SELECT-SLIDESHOW-DIR-CALLBACK
;;ddd
(defun select-slideshow-dir-callback (interface)  ;;works
  "In screensaverMP.lisp"
  (setf *photo-directory
        (capi:prompt-for-directory "Select Directory/Folder for Photo Slideshop"
                                   ;;:if-does-not-exist if-does-not-exist
                                   :pathname *photo-directory)
        *main-photo-directory *photo-directory)
  )


;;SELECT-SLIDE-ORDER-TYPE-CALLBACK
;;
;;ddd
(defun select-slide-order-type-callback (data-arg interface)
  "In screensaverMP.lisp"
  (cond
   ((equal data-arg :randomp)
    (setf *sort-type :randomp))   ;; "Type of directory sort--default is :randomp")
   ((equal data-arg :lessp)
    (setf *sort-type :lessp)) 
   ((equal data-arg :greaterp)
    (setf *sort-type :greaterp)) 
   ((equal data-arg :by-dir)
    (setf *by-dir-or-file :dir))
   ((equal data-arg :by-file)
    (setf *by-dir-or-file :file))
   ((equal data-arg :as-is)
    (setf *by-dir-or-file :as-is))
   (t nil))
  (show-text (format nil "*sort-type= ~A~%*by-dir-or-file= ~A~%" *sort-type *by-dir-or-file) 40 t)
  )

#| not needed???
;;SELECT-SLIDE-ORDER-BYDIR-FILE-CALLBACK
;;
;;ddd
(defun select-slide-order-type-callback (interface)
  "In screensaverMP.lisp"
|#



;;SELECT-SAVED-DIR-CALLBACK
;;ddd
(defun select-saved-dir-callback (interface)
  "In screensaverMP.lisp"
  (setf *photo-copy-dir
        (capi:prompt-for-directory "Select Directory/Folder for Photo Slideshop"
                                   ;;:if-does-not-exist if-does-not-exist
                                   :pathname *photo-copy-dir))
  )


;;SAVE-SETTINGS-CALLBACK
;;ddd
(defun save-settings-callback (interface)
  "In screensaverMP.lisp"
  ;;make *settings-db-list* saving (often reinitializing) all settings
   ;;Don't include SCREEN SIZES
  (setf *settings-db-list*
        `(
          ( *visible-border-p nil)
         ;; ( *photo-transform-list '(1.0 0 0 1.0 0 0)) ;; "used by GP for transforming photo dimensions")
          ( *transform-correction-factor 1.0) ;; 0.77)
          ( *video-player-path  ,*video-player-path)
          ( *all-or-photo-video  ,*all-or-photo-video)
         ;; ( *photo-viewer-width ,*photo-viewer-width)
         ;; ( *photo-viewer-height ,*photo-viewer-height)
         ;; ( *output-pane-width ,*output-pane-width)
          ;;( *output-pane-height ,*output-pane-height)
          ( *rich-text-pane-height ,*rich-text-pane-height)
          ( *pane-font-size  ,*pane-font-size)
          ( *rich-text-pane-foreground :white )
          ( *rich-text-pane-background  :black)  
          ;;FIX--find package? (make-rgb 0.0s0 1.0s0 0.0s0))  ;; :white)
          ( *button-panel-background :white) 
          ;;to change color (setf (capi:simple-pane-foreground self) color))
          ;; -------------- PHOTO ATTRIBUTES ----------------
          ( *dir-sort-type  ,*dir-sort-type) ;; "type of photo subdirectory sorting"
          ( *recursion-limit  50) ;; "used in make-flat-dirs-list1 to limit max limit of recurssion calls. Enlarge number for very large directories")
           ( *main-photo-directory ,(namestring *main-photo-directory))
          ( *photo-directory ,(namestring *main-photo-directory))
          ( *photo-copy-dir ,(namestring *photo-copy-dir))
          ( *sort-type ,*sort-type) ;; "Type of directory sort--default is :randomp")
          ( *by-dir-or-file ,*by-dir-or-file) 
          ( *photo-display-seconds ,*photo-display-seconds)
          (*reverse-order-p ,*reverse-order-p)
          ( *current-photo-info-list nil)
          ( *current-photo-title "Current Photo")
          ( *current-photo-file "Current photo file")
          ( *current-photo-path-name "Current-photo-path-name")
          ( *last-photo-path-name "Last-photo-path-name")
          ( *current-photo-filename "Current-photo-filename")
          ;; find photo date and time etc
          ( *current-photo-date "Current photo date")
          ( *current-photo-time "Current-photo-time")
          ( *current-photo-num  1)
          ;;( *current-photos-in-dir 1)
          ( *current-image nil)
          ( *rich-text-pane-text "Photo information displayed here")
          ( *rich-text-pane-font ,*rich-text-pane-font)
          ))
  (save-db *settings-db-list* *settings-filename)   
        )

(defun close-photoviewer-callback (interface)
      (capi:destroy interface))

(defun minimize-window-callback (interface)
  (setf (capi:top-level-interface-display-state interface) :iconic)
;;docs conflict LW says use :iconic, someplace else says use :iconify that :iconic --depreciated
  )

;;2016
;;VIDEO-PLAY-CALLBACK
;;
;;ddd
(defun video-play-callback (data-arg interface)
    (cond
     ;;Choices, 'mix-all, v-before, v-after, 'video-only, 'photo-only
     ((equal data-arg :mix-all )
      (setf  *all-or-photo-video :mix-all))
     ((equal data-arg :v-before )
      (setf  *all-or-photo-video :v-before))
     ((equal data-arg :v-after )
      (setf  *all-or-photo-video :v-after))
     ((equal data-arg :video-only )
      (setf  *all-or-photo-video :video-only))
     ((equal data-arg :photo-only )
      (setf  *all-or-photo-video :photo-only))
     )
  ;;end video-play-callback
  )


;;LATER, MAKE WMPLAYER THE DEFAULT??, NEED TO CHANGE ARGS THOUGH
;; C:\Program Files (x86)\Windows Media Player\\wmplayer.exe
;;
;;SELECT-VIDEO-PLAYER-CALLBACK
;;
;;ddd
(defun select-video-player-callback (interface)
  "In screensaverMP.lisp"
  (setf *video-player-path
        (capi:prompt-for-file "Select VIDEO-PLAYER to play videos [Default is C:\\Program Files (x86)\\VideoLAN\\VLC\\vlc.exe]"))
  )
    







;;----------------------------- SLIDESHOW-DISPLAY-SECONDS-INTERFACE --------

;;SLIDESHOW-DISPLAY-SECONDS-INTERFACE
;;ddd
;; no longer needed, bec stayed behind main window--used menus instead
#|
(capi:define-interface slideshow-display-seconds-interface ()
  ()
  (:panes
   (text-input-choice-1
    capi:text-input-choice
    :items '("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"  "12" "14" "16" "18" "20" "25" "30" "45" "60")
    :selection 0
    :message "Select Slideshow Disiplay Seconds"
    :title "SLIDESHOW-DISPLAY-SECONDS"
    :selection-callback 'photo-display-seconds-callback2
    :background :white
    :foreground :black
    :callback-type :interface
    :visible-border t))
  (:layouts
   (column-layout-1
    capi:column-layout
    '(text-input-choice-1)))
  (:default-initargs
   :best-height 70
   :best-width 300
   :layout 'column-layout-1
   :title "Select Slideshow Display Seconds"))
|#
;;PHOTO-DISPLAY-SECONDS-CALLBACK1
;;ddd
;;moved selection to the menu because this window stayed below main window
#|(defun photo-display-seconds-callback1 (interface)
 ;; (afout 'out "photo-display-seconds-callback1 fired")
    (capi:display 
     (setf slideshow-display-seconds-instance (make-instance 'slideshow-display-seconds-interface ))))|#


;;PHOTO-DISPLAY-SECONDS-CALLBACK
;; ddd
;;mmm
(defun photo-display-seconds-callback (seconds  interface)
           (show-text (format nil "Choice= ~A" seconds) 50 nil)
        (setf *photo-display-seconds seconds))
 

;;(get-display-seconds-index)
;;works w/o interface for test
;;ddd
(defun get-display-seconds-index (interface)
  "In Screensaver2013, gets current value of *photo-display-seconds and converts it to the INDEX OF THE SELECTED NUMBER OF SECONDS, returns (values index display-seconds)"
  (let
      ((index -1)
       (selected-index 3)
       (display-seconds-string  (format nil "~A" *photo-display-seconds))
       )
    (dolist ( item  '(("1" :data 1)("2" :data 2 )("3" :data 3  )("4" :data  4)("5" :data  5)("6" :data  6)("7" :data 7)("8" :data  8)("9" :data  9)("10":data 10)("12" :data  12)("14" :data  14)("16" :data 16 )("18" :data 18 )("20" :data  20)("25" :data  25)("30" :data  30)("45" :data  45)("60":data 60)))
      (incf index)
      (cond
       ((equal (car  item) display-seconds-string)
        (setf selected-index index)
        (return (values selected-index display-seconds-string)))
       (t nil)))
    ;;(values selected-index display-seconds-string)
    selected-index)) 

;;HELP
;; (setf choice-selection) is the accessor to set the choice for the menu list when :single-selection
    




#|(defun photo-display-seconds-callback (seconds-string  interface)
  (with-slots (menu-display-time) interface
    (let 
        ((seconds 3)
         )
      ;; (afout 'out "photo-display-seconds-callback fired")
      (cond
       ((null stringp seconds-string) nil)
       (t 
        (setf seconds (convert-string-to-integer seconds-string))
        ;;   (show-text (format nil "Choice= ~A" seconds) 50 nil)
        (setf *photo-display-seconds seconds)))
      (values seconds seconds-string))))|#

;; ----------------------------- end photo-display-seconds-callback1 and Interface ----------







;;OPTIONS FUNCTIONS MOVED TO SCREENSAVER-OPTIONS.LISP ----------------

;;UUU----------------------------- UTITLITY FUNCTIONS -------------------------------

;;SETF-PHOTO-INFO
;;ddd
(defun setf-photo-info (photo-num photos-in-dir file &optional image photo-transform-list)
  (setf *current-photo-file  file
        *current-photo-path-name (namestring file)
        *current-photo-file-name (file-namestring file)
        *current-photo-num photo-num 
        *current-photos-in-dir photos-in-dir)
;;added 7-2013
   (multiple-value-setq (*current-photo-date  *current-photo-time)
            ( find-exif-date-time  *current-photo-file  :delete-seconds t ))

  (if image (setf *current-image  image ))
  (if photo-transform-list (setf  photo-transform-list photo-transform-list))
  ;;vary whether forms newline depend on length of *current-photo-path-name
  (cond
   ((and (stringp *current-photo-path-name) (< (length *current-photo-path-name) 80))  
  (setf *rich-text-pane-text (format nil " ~A~%  Photo ~A of ~A  Date: ~A  Time: ~A~%" 
                                  *current-photo-path-name *current-photo-num *current-photos-in-dir
                                  *current-photo-date  *current-photo-time )))  
   (t (setf *rich-text-pane-text (format nil " ~A   || Photo ~A of ~A  Date: ~A  Time: ~A~%" 
                                  *current-photo-path-name *current-photo-num *current-photos-in-dir
                                  *current-photo-date  *current-photo-time ))))
  )

;;HOLD-PHOTO-DISPLAY-CALLBACK
;;ddd fff
(defun photo-display-hold-callback (interface)
    "In ScreensaverMP.lisp, holds photo hold-photo-seconds each time it is pushed"
    (setf *photo-display-hold 'hold))

(defun photo-display-go-callback (interface)
    "In ScreensaverMP.lisp, holds photo hold-photo-seconds each time it is pushed"
    (setf *photo-display-hold 'go))

  
;;works
#|(do ((i 0 (1+ i)))
((>= i 4))
(print i))|#
;;same as
;;(dotimes (i 4) (print i))

;;HOLD-PHOTO-DISPLAY
;;ddd
(defun hold-photo-display (hold-photo-seconds)
  "In ScreensaverMP.lisp, holds photo hold-photo-seconds each time *holresd-photo-display is reset by hold-photo-display-callback"
  (cond
       ((equal *photo-display-hold 'hold)
        (setf *photo-display-hold nil)
      ;;(afout 'out (format nil "1-In hold-photo-display, *photo-display-hold= ~A~%" *photo-display-hold))
        (sleep hold-photo-seconds))
       (t nil))
  ;;if button pushed again, recurse
      ;;(afout 'out (format nil "2-In hold-photo-display, *photo-display-hold= ~A~%" *photo-display-hold))
  (if *photo-display-hold (hold-photo-display hold-photo-seconds))
  )














;;SHOW-TEXT
;;ddd
(defun show-text (text height title-or-richtext)
  "For debugging etc: shows text in a container window (title or richtext=anything but 'title)."
  (let ((rich-text-pane-show)
        (title-pane-show)
        )   
    (cond
     ((equal title-or-richtext 'title)
      (capi:contain
       (setf title-pane-show (make-instance 'capi:title-pane :name "title-pane1"  :text
                                            (format nil "~A" text)))))
     (t
      (capi:contain
       (setf rich-text-pane-show (make-instance 'capi:rich-text-pane :name "rich-text-pane-show" :external-max-height height  :text (format nil "~A" text)))
       ) ))
    ))


;;COPY-DISPLAY-IMAGE-FILE-CALLBACK
;;dddd
(defun copy-display-image-file-callback (interface)
  "In screensaverMP.lisp"
  ;;note:  MUST HAVE EXTRA QUOTES OR DOS WON'T READ IT RIGHT
  (let ((command (format nil "copy \"~A\" \"~A\"" *last-photo-path-name *photo-copy-dir))
        )
    (show-text command 30 t)
    (sys:call-system command)))


#|
;;following doesn't work, maybe because of args to the gp save function. 
;;Instead substituted (possibly more efficient) a function to copy original photo file defined in U-files.lisp
(defun output-pane-save-as-file (interface)
  (with-slots (image) interface
    (let ((save-to-path (format nil "~A~A" *photo-copy-directory *current-photo-filename))
          )
    (cond
     (image
        (GP::GDIP-SAVE-IMAGE-TO-FILE image save-to-path nil nil)
      ;;arglist is (gp:image gp::filename gp::encoder gp::encoder-params)
      (show-text (format nil "Image saved to file=> ~A~%" save-to-path) 30 t)
      )))))
|#


;;ttt -----------------   TEST AREA -----------------------------------------
;;

;;MTEST
;;ddd
(defun mtest ()
 (setf out  nil)
  (manage-photo-processes)  ;; "This is the text to display" 100)
;;must after push buttons  (fout out)
  )


;;THIS WORKS TO RESET THE DISPLAY PANE AND RICH-TEXT-PANE TEXT
#|
(defun stest ()
  (capi:display (setf *photo-viewer-instance (make-instance  'photo-viewer-interface)))
  (SLEEP 3)
  ;; use the help below, then if this works apply it to start-callback function above
  (with-slots (output-pane1 rich-text-pane1)    *photo-viewer-instance  ;; Interface2
    ;;(CAPI:APPLY-IN-PANE-PROCESS-IF-ALIVE  ;;didn't make it work--need for 2 processes??

;;   (SETF (CAPI:DISPLAY-PANE-TEXT display-pane1)
 ;;   "NEW DISPLAY PANE TEXT" )
 ;;  (SETF (CAPI:RICH-TEXT-PANE-TEXT rich-text-pane1)
 ;;   "NEW EDITOR PANE TEXT" )

;;SHOULD I USE (see help section)
;; (CAPI:APPLY-IN-PANE-PROCESS
;; ed #'(setf capi:rich-text-pane-text) "New text" ed)
;;   (setf (CAPI:TITLED-OBJECT-MESSAGE *photo-viewer-instance)
;;               "New CAPI:TITLED-OBJECT-MESSAGE")  ;;has no visible effect
;;   (setf (CAPI:INTERFACE-MESSAGE-AREA *interface2-instance)
;;         "New INTERFACE-MESSAGE-AREA message")  ;;causes error (bec no such pane??)
;;    (SETF (CAPI:OUTPUT-PANE-CACHED-DISPLAY-USER-INFO output-pane-1)
;;          "New OUTPUT-PANE-CACHED-DISPLAY-USER-INFO") ;;no visible effect
|#
    

#|
  CAPI:DISPLAY-MESSAGE-FOR-PANE
Lambda List: (PANE FORMAT-STRING &REST FORMAT-ARGS)
(SETF::\"CAPI\"\ \"EDITOR-MESSAGE-DISPLAYER\"
Lambda List: (VALUE RICH-TEXT-PANE)
 SETF::\"CAPI\"\ \"INTERFACE-MESSAGE-AREA\" 
Lambda List: (VALUE INTERFACE)
SETF::\"CAPI\"\ \"MESSAGER-MESSAGE-PANE\" 
Lambda List: (VALUE MESSAGER)
SETF::\"CAPI\"\ \"TITLED-OBJECT-MESSAGE\" 
Lambda List: (VALUE INTERFACE)
SETF::\"CAPI\"\ \"TITLED-OBJECT-MESSAGE-FONT\" 
Lambda List: (FONT SELF)
SETF::\"CAPI\"\ \"TITLED-PANE-MESSAGE\")
Lambda List: (VALUE INTERFACE)
------------
 SETF "CAPI" "OUTPUT-PANE-CACHED-DISPLAY-USER-INFO"
Lambda List: (VALUE PANE)
|#
;;----------------------------------------------------- hhh HELP SECTION ----------------------------------
;;try this function copied from capi-user
#|(defun SET-TITLE (data interface)
  (SETF (INTERFACE-TITLE INTERFACE)
        (format nil "~A" (string-capitalize data))))|#

;;(setf (capi:choice-selected-item interface) index??)

;;------------------------------------- CAPI HELP -- CALLBACKS --------------------------------
#|  from Capi LW Examples capi choice
;;works -- PASSES THE :DATA "HERE IS SOME DATA" + INTERFACE 
;;                        TO CALLBACK FUNCTION ARGS (arg1 arg2)
;;
(defun show-callback-args (arg1 arg2)
  (capi:display-message "The arguments were ~S and ~S" arg1 arg2))
(setq example-button
      (make-instance 'capi:push-button
                     :text "Push Me"
                     :callback 'show-callback-args
                     :data "Here is some data"
                     :callback-type :data-interface))
(capi:contain example-button)
|#




;; -------------------------------------------- CAPI HELP - CHANGING TEXT ETC----------------------

;; This example demonstrates the uses of images in Graphics Ports.
;;   GP:READ-EXTERNAL-IMAGE to read an external-image from a file.
;;   GP:LOAD-IMAGE to convert an external-image to an image for drawing.
;;   GP:DRAW-IMAGE for drawing an image to an output-pane.
;;   GP:FREE-IMAGE for freeing an image.
;; Note that there is no need to free the image when the interface is
;; destroyed because the CAPI does this automatically.

  ;;use (CAPI:EXECUTE-WITH-INTERFACE or CAPI:APPLY-IN-PANE-PROCESS??
 ;; (CAPI:APPLY-IN-PANE-PROCESS-IF-ALIVE Lambda List: (PANE FUNCTION &REST ARGS)
;; *interface2-instance 
#|   (display-pane-1
    capi:display-pane
    :text "This is the text for Display-pane-1. This text could be a lot longer.N  Let's see what happens if I make it a lot longer."
    :message "Message for Display-pane-1"
    :title   "TITLE for display-pane-1"

;;FOR SETTING TEXT??
Name: (METHOD (SETF CAPI:DISPLAY-PANE-TEXT) (T CAPI:DISPLAY-PANE))
Function: #<STANDARD-WRITER-METHOD (SETF CAPI:DISPLAY-PANE-TEXT) NIL (T CAPI:DISPLAY-PANE) 20D9D417>
Lambda List: (VALUE DISPLAY-PANE)

;;for GETTING TEXT??
Name: (METHOD CAPI:DISPLAY-PANE-TEXT (CAPI:DISPLAY-PANE))
Function: #<STANDARD-READER-METHOD CAPI:DISPLAY-PANE-TEXT NIL (CAPI:DISPLAY-PANE) 20D9D2CF>
Lambda List: (DISPLAY-PANE)
|#
#|  (CAPI:APPLY-IN-PANE-PROCESS-IF-ALIVE  
                                       FUNCTION &REST ARGS) 

(defun make-text (self createdp)
  (multiple-value-bind (s m h dd mm yy)
      (decode-universal-time (get-universal-time))
    (format nil "Window ~S ~:[displayed~;created~] at
~2,'0D:~2,'0D:~2,'0D"
            self createdp h m s)))
(capi:define-interface dd () () (:panes (dp capi:display-pane)))
(defmethod capi:interface-display :before ((self dd))
  (with-slots (dp) self
    (setf (capi:display-pane-text dp)
          (make-text self t))))
(capi:contain (make-instance 'dd))

From capi:interface reference:
The class options :panes, :layouts and :menus add extra
slots to the class that will contain the CAPI object described
in their description. Within the scope of the extra options, the
slots themselves are available by referencing the name of the
slot, and the interface itself is available with the variable
capi:interface. Each of the slots can be made to have
readers, writers, accessors or documentation by passing the
appropriate defclass keyword as one of the optional arguments
in the description. THEREFORE, IF YOU NEED TO FIND A
PANE WITHIN AN INTERFACE INSTANCE, you can provide an accessor,
or SIMPLY USE WITH-SLOTS.

;;from p in capi ref manual:
(capi:contain (make-instance 'capi:rich-text-pane
:text "Hello world"))
(setq ed (capi:contain
          (make-instance 'capi:rich-text-pane
                         :text "Hello world"
                         :enabled nil)))
Note that you cannot type into the editor pane.
(capi:apply-in-pane-process
 ed #'(setf capi:rich-text-pane-enabled) t ed)
Now you can enter text into the editor pane interactively.
You can also change the text programmatically:
(capi:apply-in-pane-process
 ed #'(setf capi:rich-text-pane-text) "New text" ed)
In this example the callback modifies the buffer in the correct
editor context so you that see the editor update immediately:
|#
;;USE THIS AS A MODEL? EXCEPT NEEDS ANOTHER CALC PROCESS FOR PHOTOS
;;
#|
(defun uptest ()
  (capi:define-interface updating-editor ()
    ()
    (:panes
     (numbers capi:list-panel
              :items '(1 2 3)
              :selection-callback 'update-editor
              :callback-type :interface
              :visible-min-height '(:character 3))
     (editor capi:rich-text-pane
             :text
             "Select numbers in the list above."
             :visible-min-width
             (list :character 35))))
  (defun update-editor (interface)
    (with-slots (numbers editor) interface
      (editor:process-character
       (list #'(setf capi:rich-text-pane-text)
             (format nil "~R"
                     (capi:choice-selected-item numbers))
             editor)
       (capi:editor-window editor))))
  (capi:display (make-instance 'updating-editor))
  )
|#


;;following is example-- for ???
#|(capi:apply-in-pane-process
 layout #'(setf capi:layout-description)
 (list (make-instance 'capi:title-pane :text "Three")
       (make-instance 'capi:title-pane :text "Four")
       (make-instance 'capi:title-pane :text "Five"))
 layout)|#


#|
(defun change-text (win text)
  "From capiuser-w-6-1"
  (CAPI:APPLY-IN-PANE-PROCESS win
                         #'(setf capi:title-pane-text)
                         text win))

(defun send-with-result (process function)
  (let ((remote-result :none))
    ;;flet defines to local functions (resultp () (listp remote-result)) and
    ;;   (run-it () (setq remote-result (multiple-value-list (funcall function))))
    (flet ((resultp ()
             (listp remote-result))
           (run-it ()
             (setq remote-result
                   (multiple-value-list (funcall function)))))
      ;;then the following two processes USE these 2 functions below to send and receive
      (MP:PROCESS-SEND process (list #'run-it))
      (MP:PROCESS-WAIT "Waiting for result" #'resultp)
      (values-list remote-result))))

mailbox-count
mailbox-empty-p
mailbox-send
mailbox-peek
mailbox-read
make-mailbox

CAPI:DISPLAY-MESSAGE-FOR-PANE
Lambda List: (PANE FORMAT-STRING &REST FORMAT-ARGS)
(SETF::\"CAPI\"\ \"EDITOR-MESSAGE-DISPLAYER\"
Lambda List: (VALUE RICH-TEXT-PANE)
 SETF::\"CAPI\"\ \"INTERFACE-MESSAGE-AREA\" 
Lambda List: (VALUE INTERFACE)
SETF::\"CAPI\"\ \"MESSAGER-MESSAGE-PANE\" 
Lambda List: (VALUE MESSAGER)
SETF::\"CAPI\"\ \"TITLED-OBJECT-MESSAGE\" 
Lambda List: (VALUE INTERFACE)
SETF::\"CAPI\"\ \"TITLED-OBJECT-MESSAGE-FONT\" 
Lambda List: (FONT SELF)
SETF::\"CAPI\"\ \"TITLED-PANE-MESSAGE\")
Lambda List: (VALUE INTERFACE)

;; ------------------------------ xxx CONDITION-VARIABLES ----------------------------------
;;

xxx MP:MAKE-CONDITION-VARIABLE Function ------------------------------------
Summary Makes a condition variable. Package mp
Signature make-condition-variable &KEY NAME => condvar
Arguments NAME A string naming the condition variable.
(return)VALUES CONDVAR A condition variable.
Description The function make-condition-variable makes a condition
variable for use with condition-variable-wait, condition-
variable-signal and condition-variable-broadcast.
name is used when printing the condition variable, and is useful
for debugging. If name is omitted, then a DEFAULT NAME IS
GENERATED that is unique among all such default names.
869

==> ME-USE--> MP:LOCK-AND-CONDITION-VARIABLE-WAIT  bec more general.
;;
xxx MP:LOCK-AND-CONDITION-VARIABLE-WAIT Function
Summary LOCKS a lock and CALLS A PREDICATE. If this returns nil, performs
the equivalent of condition-variable-wait.
OPTIONALLY CALLS A FUNCTION ON RETURN.

SIGNATURE lock-and-condition-variable-wait lock condvar predicate
&key args return-function return-function-args lock-timeout lock-wait-
reason condvar-timeout condvar-wait-reason
Description 
1.The function lock-and-condition-variable-wait first
LOCKS the lock lock as in with-lock, using lock-wait-reason and
lock-timeout for the whostate and timeout arguments of withlock.
2-It then APPLIES THE FUNCTION PREDICATE TO THE ARGUMENTS ARGS. If
this call returns nil it performs the equivalent of a call to
condition-variable-wait, passing it the condvar, lock,
condvar-timeout and condvar-wait-reason.
3-If RETURN-FUNCTION is supplied, it is then applied to
 RETURNFUNCTION-ARGS, and the return value(s) are returned.
4-Before returning, the LOCK IS UNLOCKED (in an unwinding
form) as in with-lock.
lock-and-condition-variable-wait returns whatever
return-function returns if it is supplied. If return-function is not
supplied, lock-and-condition-variable-wait returns the
result of the predicate if this is not nil, otherwise it returns
the result of the equivalent call to condition-variablewait.
Notes 1. predicate and the return-function are called with the lock
held, so they should do as little as needed, and avoid
locking anything else.
2. lock-and-condition-variable-wait makes it much
easier to avoid errors when using condition variables.
3. When return-function is not supplied, lock-and-condition-
variable-wait does not lock on return, which
makes it it much more efficient than the equivalent code
using with-lock and condition-variable-wait.
4. When return-function is not needed, simple-lock-andcondition-
variable-wait may be more convenient.
5. All the four signalling functions (condition-variablesignal,
condition-variable-broadcast, lock-andcondition-
variable-signal, lock-and-conditionvariable-
broadcast) can be used to wake a process
855
waiting in lock-and-condition-variable-wait. The
non-locking one can be used without the lock when it is
useful.


xxx For condition-variable-wait there is also
MP: SIMPLE-LOCK-AND-CONDITION-VARIABLE-WAIT, ----------------------
 which is simpler to use.
The LOCK-AND-CONDITION-* functions perform the equivalent of locking and
in the scope of the lock doing something and calling the corresponding condition-*
function.
The lock-and-condition-* functions not only make it simpler to code, they
also make it easier to avoid mistakes, and can optimize some cases (in particular,
the quite common case when there is no need to lock on exit from condition-
variable-wait). They are the recommended interface.
The lock-and-condition-* functions can be used together with condition-
* functions on the same locks and condition variables.
Note: In cases WHEN ONLY ONE PROCESS WAITS FOR THE CONDITION,
 using PROCESSWAIT-LOCAL for waiting and PROCESS-POKE for signalling is easier, and
involves less overhead.

;;Use above more complex version with &keys for more flexibility
SIMPLE-LOCK-AND-CONDITION-VARIABLE-WAIT Function
Summary A variant of lock-and-condition-variable-wait with a
simpler lambda list.
Package mp
SIGNATURE simple-lock-and-condition-variable-wait   LOCK  LOCK-TIMEOUT
CONDVAR CONDVAR-TIMEOUT PREDICATE &REST ARGS
Description The function simple-lock-and-condition-variablewait
is a variant of lock-and-condition-variable-wait
that does not take keyword arguments. Also it takes the 
ARGUMENTS OF THE PREDICATE AS &REST. It interprets and ACTS on the
arguments just like lock-and-condition-variable-wait.
933
simple-lock-and-condition-variable-wait returns the
result of the predicate or the wait, like lock-and-conditionvariable-
wait when return-function is not supplied.
NOTES simple-lock-and-condition-variable-wait does not
take wait reason arguments, so you should give names to the
lock lock and the condition variable condvar for debugging
(by passing name in make-lock and make-condition-variable).
|#

#|
function MP:CONDITION-VARIABLE-WAIT  
ARGUMENTS
condvar=A condition variable
lock=A mp:lock
timeout=nil or a positive real
wait-reason=A string
VALUES
wakep=A generalized boolean

DESCRIPTION
The function condition-variable-wait waits at most timeout seconds for the condition variable condvar to be signalled. The lock lock is released while waiting and claimed again before returning. The caller must be holding the lock lock before calling this function.
The RETURN VALUE WAKEP is non-nil IF THE SIGNAL WAS RECEIVED or nil if there was a timeout. IF TIMEOUT IS NIL , CONDITION-VARIABLE-WAIT WAITS INDEFINITELY. If wait-reason is non-nil, it is used as the wait-reason while waiting for the signal.

It is RECOMMENDED that you use lock-and-condition-variable-wait or simple-lock-and-condition-variable-wait instead of condition-variable-wait . The locking functions make it easier to avoid mistakes, and can be more efficient.
Notes: timeout controls how long to wait for the signal: before returning, the function waits to claim the lock, possibly indefinitely.

See also condition-variable-wait
lock-and-condition-variable-wait
lock-and-condition-variable-signal
lock-and-condition-variable-broadcast
condition-variable-signal
condition-variable-broadcast

xxx LOCK-AND-CONDITION-VARIABLE-SIGNAL Function --------------------------------------
Summary: Locks, applies a setup function, calls condition-variable-signal and unlocks.
Package mp
Signature: lock-and-condition-variable-signal
     LOCK CONDVAR LOCK-TIMEOUT SETUP-FUNCTION &REST ARGS
Description: The function lock-and-condition-variable-signal
1. LOCKS THE LOCK LOCK ,
2. APPLIES THE SETUP-FUNCTION , 
3. calls condition-variable-signal and
4. unlocks.
lock-and-condition-variable-signal makes it easier to avoid mistakes in using a condition variable.
lock-and-condition-variable-signal performs the equivalent of: 
(mp:with-lock (lock
               nil lock-timeout
               )
  (apply setup-function
         args
         )
  (mp:condition-variable-signal condvar
                                ))
It RETURNS the RESULT OF THE CALL TO CONDITION-VARIABLE-SIGNAL.
See condition-variable-signal and with-lock for more details. 
NOTES: setup-function is called with the lock held, so it should do the minimum amount of work and avoid locking other locks. Normally setup-function should only set the cell that the process(es) that wait(s) on the condition variable condvar check with the predicate in lock-and-condition-variable-wait.

CONDITION-VARIABLE-SIGNAL Function
Summary
WAKES one thread waiting on a given condition variable. Package mp

Signature: condition-variable-signal CONDVAR => signalledp
ARGUMENTS
condvar=A condition variable
return VALUES
SIGNALLEDP= A generalized boolean

DESCRIPTION  The function condition-variable-signal WAKES EXACTLY ONE THREAD waiting on the condition variable condvar . In most uses of condition variables, the CALLER SHOULD BE HOLDING THE LOCK that the waiter used when calling condition-variable-wait for this condition variable, but this is NOT REQUIRED. When using the lock, you may prefer to use lock-and-condition-variable-signal.

The return value signalledp is non-nil if a process was signalled, or nil if there were no processes waiting.
See also
condition-variable-wait
make-condition-variable
lock-and-condition-variable-signal
lock-and-condition-variable-wait
simple-lock-and-condition-variable-wait
lock-and-condition-variable-broadcast
condition-variable-broadcast

xxx WITH-LOCK   Macro --------------------------------------
Summary: Executes a body of code while holding a lock.
Package: mp
SIGNATURE: with-lock ( lock &optional whostate timeout ) &body body => result
ARGUMENTS
LOCK=The lock.
WHOSTATE=The status of the process while the lock is locked, as seen in the Process Browser.
TIMEOUT=A timeout period, in seconds.
BODY=The forms to execute.
(return) VALUES= result The result of executing body .
Description: with-lock
1. EXECUTES BODY 
2.while holding the lock, and
3. unlocks the lock when body exits. 
This is the recommended way of using locks. The value of body is returned normally. body is not executed IF THE LOCK COULD NOT BE CLAIMED, in which case, WITH-LOCK RETURNS NIL .
See also:
make-lock
process-lock
process-unlock
with-exclusive-lock
with-sharing-lock

xxx MAKE-LOCK Function --------------------------
Summary: Makes a lock. Package mp
Signature: make-lock &key name important-p safep recursivep sharing => lock
ARGUMENTS
NAME= A string.
IMPORTANT-P= A generalized boolean.
SAFEP= A generalized boolean.
RECURSIVEP= A generalized boolean.
SHARING= A generalized boolean.

(return)VALUES= LOCK  The lock object.
Description: The function make-lock creates a lock object. See Locks for a general description of locks. 
NAME names the lock and can be queried with lock-name. The default value of name is "Anon".
IMPORTANT-P controls whether the lock is automatically freed when the holder process finishes. When important-p is true, the system notes that this lock is important, and AUTOMATICALLY FREES it when the holder process finishes. IMPORTANT-P SHOULD BE NIL FOR LOCKS WHICH ARE MANAGED COMPLETELY BY THE APPLICATION, as it is WASTEFUL to record all locks in a global list if there is no need to free them automatically. This might be appropriate when two processes sharing a lock must both be running for the system to be consistent. If one process dies, then the other one kills itself. Thus the system does not need to worry about freeing the lock because no process could be waiting on it forever after the first process dies. The default value of important-p is nil .

SAFEP controls whether the lock is safe. A SAFE LOCK GIVES AN ERROR IF PROCESS-UNLOCK IS CALLED ON IT WHEN IT IS NOT LOCKED BY THE CURRENT PROCESS, and potentially in other 'dangerous' circumstances. An unsafe lock does not signal these errors. 
TheDEFAULT VALUE OF SAFEP IS T .

RECURSIVEP , when true, ALLOWS THE LOCK TO BE LOCKED RECURSIVELY. Trying to lock a lock that is already locked by the current thread just INCREMENTS ITS LOCK COUNT. If the lock is created with RECURSIVEP NIL THEN TRYING TO LOCK AGAIN CAUSES AN ERROR. This is useful for debugging code where the lock is never expected to be claimed recursively. The DEFAULT VALUE OF RECURSIVEP IS T .

SHARING , when true, causes lock to be a "sharing" lock object, 
which supports SHARING AND EXCLUSIVE LOCKING. At any given time, an sharing lock may be free, or it MAY BE LOCKED FOR SHARING by any number of threads
 OR LOCKED FOR EXCLUSIVE USE BY A SINGLE THREAD. 
Sharing locks are handled by DIFFERENT FUNCTIONS and methods from non-sharing locks.
EXAMPLE
|#
#|
CL-USER 3 > (setq *my-lock* (mp:make-lock 
                             :name "my-lock")) ;;note: repeating this call makes NEW UNLOCKED LOCK
#<MP:LOCK "my-lock" Unlocked 2008CAC7>
CL-USER 4 > (mp:PROCESS-LOCK *my-lock*)
T
CL-USER 5 > *my-lock*
#<MP:LOCK "my-lock" Locked once by "CAPI Execution Listener 1" 2008CAC7>
CL-USER 6 > (mp:process-lock *my-lock*)
T
CL-USER 7 > *my-lock*
#<MP:LOCK "my-lock" Locked 2 times by "CAPI Execution Listener 1" 2008CAC7>
|#
#|
See also:
*current-process*
lock-recursive-p
process-lock
process-unlock
schedule-timer
with-lock
MP CONDITION-VARIABLE-BROADCAST
MP CONDITION-VARIABLE-ENSURE-WAIT-REASON
MP CONDITION-VARIABLE-NAME
MP CONDITION-VARIABLE-P
MP CONDITION-VARIABLE-RE-LOCK
MP CONDITION-VARIABLE-RE-LOCK-RECURSIVE
MP CONDITION-VARIABLE-SIGNAL
MP CONDITION-VARIABLE-WAIT
MP CONDITION-VARIABLE-WAIT-COUNT
MP INTERNAL-CONDITION-VARIABLE-WAIT
MP INTERNAL-LOCK-AND-CONDITION-VARIABLE-SIGNAL
MP LOCK-AND-CONDITION-VARIABLE-BROADCAST
MP LOCK-AND-CONDITION-VARIABLE-SIGNAL
MP LOCK-AND-CONDITION-VARIABLE-WAIT
MP SIMPLE-LOCK-AND-CONDITION-VARIABLE-WAIT
|#


;;integrate following
#|
>>>>> On Sun, 31 Mar 2013 22:57:14 +0200, Fabrice Popineau said:
> Thanks for your answers.
> There seems to be something wrong however.
> I'm running LWW 6.1 under Windows 8 and gp:draw-point is always 
> scaled, whatever I do.
> (defun test ()
>   (let ((pane (capi:contain (make-instance 'capi:output-pane
>                                            ;; :drawing-mode :compatible
>                                            ))))
>     (gp:set-graphics-port-coordinates pane :bottom -0.5 :left -1.5 
> :top 0.5 :right 1.5)
>     (gp:draw-line pane -0.2 -0.2 0.2 0.2)
>     (gp:draw-point pane -0.2 0.2
>     ;;                     :thickness .001
>     )))
> I get the picture below. I tried to fix it by using (gp:draw-line pane 
> x y x y) but that doesn't draw any point.
> Drawing in compatible mode doesn't draw the point at all.
That looks like a bug in gp:draw-point -- instead, try gp:draw-points with compatible mode:
(gp:draw-points pane '(-0.2 0.2))
Another couple of issues:
1. The point is drawn on top of the line in this example, so you can't see it (unless you use a different colour).
2. drawing to a pane immediately after creating it with capi:contain is not recommended, because it happs in the wrong thread and also might be erased by the window system.  Instead, put the drawing OPERATIONS IN THE :DISPLAY-CALLBACK OF THE PANE.
Martin Simmons; LispWorks Ltd;  http://www.lispworks.com/
|#

#|
;; --------------------------------- RELATED CAPI MP HELP INFO --------------------------------------
;;copied from elsewhere in my help
;;
OPERATIONS ON CAPI OBJECTS are not atomic in general. The same is true for
anything in the IDE. These OPERATIONS NEED TO BE INVOKED FROM THE THREAD THAT
OWNS THE OBJECT, for example by 
CAPI:EXECUTE-WITH-INTERFACE or
CAPI:APPLY-IN-PANE-PROCESS.

15.7.1 Timers and multiprocessing
TIMERS RUN IN UNPREDICTABLE THREADS, therefore it is 
NOT SAFE TO RUN (me-TIMER) CODE THAT INTERACTS WITH THE USER DIRECTLY. 
The recommended solution is something like
(mp:schedule-timer-relative
 (mp:make-timer 'capi:execute-with-interface
                interface
                'capi:display-message "Time's up")
 5)
or
(mp:schedule-timer
 (mp:make-timer 'capi:execute-with-interface
                interface
                'capi:display-message "Lunchtime")
 (* 4 60 60))
where interface is an EXISTING CAPI INTERFACE ON THE SCREEN.
Timers actually run in the process that is current when the scheduled time is
reached. This is likely to be The Idle Process in cases where LispWorks is
sleeping, but it is inherently unpredictable.

15.7.2 Input and output for timer functions
I/O streams default to the standard input and output of the process, which is
initially *terminal-io* in the case of The Idle Process.
15.8 Process properties
A "process property" is a pair of an indicator and a value that is associated
with it for a process.
190
LispWorks has TWO KINDS OF PROCESS PROPERTIES: GENERAL and PRIVATE. 
These two kinds of properties are stored separately, and the association of indicator/
value in each property kind is independent of any in the other property kind.

GENERAL PROPERTIES are stored in the process plist, and can be modified from
other processes.
PRIVATE PROPERTIES can ONLY BE MODIFIED BY THE CURRENT PROCESS. Private properties
are FASTER to modify, because the modification DOES NOT NEED TO BE
THREAD-SAFE.

Otherwise there is little difference between general and private properties.
PROCESS-PLIST and (SETF PROCESS-PLIST) are NOT THREAD SAFE. 
In Lisp-Works 5.1 and earlier the only interface to process properties is processplist,
but this does not work well in SMP LispWorks, and so it is deprecated.
There is no parallel to process-plist for the private properties.

The GENERAL properties are ACCESSED by: PROCESS-PROPERTY, (SETF PROCESSPROPERTY),
remove-process-property, pushnew-to-process-property
and remove-from-process-property.

The PRIVATE properties are accessed by: GET-PROCESS-PRIVATE-PROPERTY
(access from other processes), process-private-property,
(SETF PROCESSPRIVATE-PROPERTY), remove-process-private-property, 
pushnew-toprocess-private-property and 
remove-from-process-private-property.

COLORS ---------------------------------------------------
xxx
(make-rgb 0.0s0 1.0s0 0.0s0)  ;;LAST IS TRANSPARENCY VALUE

(apropos-color-names "RED") =>
(:ORANGERED3 :ORANGERED1 :INDIANRED3 :INDIANRED1
:PALEVIOLETRED :RED :INDIANRED :INDIANRED2
:INDIANRED4 :ORANGERED :MEDIUMVIOLETRED
:VIOLETRED :ORANGERED2 :ORANGERED4 :RED1 :RED2 :RED3
:RED4 :PALEVIOLETRED1 :PALEVIOLETRED2 :PALEVIOLETRED3
:PALEVIOLETRED4 :VIOLETRED3 :VIOLETRED1 :VIOLETRED2
:VIOLETRED4)



|#

#|
was in middle of calculator function
            ;;from change-photo code that works inserted here
            #|            (external-image  
             ;;display-photo-image is the real calculator work function
             (multiple-value-setq (image *photo-transform-list)
                 (display-photo-image interface file external-image *photo-transform-list ))|#
            ;;image updates the slot above in (with-slots 
            ;; (setf image (gp:load-image output-pane1 new-image))

            ;;update the info to be passed to the interface (later use MULTIPLE-VALUE-SETQ ??
            #|             (setf-photo-info photo-num photos-in-dir file image *photo-transform-list)
             (setf text2  (format nil "1b new-image= ~A~% *photo-transform-list= ~A~%file= ~A~%"
                                  image *photo-transform-list file))
             (if *show-details (show-text text2 200 nil))|#
            ;;do this in interface process?  (update-photo-viewer interface)
            ;;end of inserted


            #|TO QUERY THE DIMENSIONS BEFORE DISPLAYING ANYTHING you can create and "display"
an interface made with the :DISPLAY-STATE :HIDDEN INITARG. 
Call load-image with this hidden interface and your external-image object, and
then use the readers image-width and image-height.|#  
            ;;           (setf hidden-image (gp:
            ;;       (setf image-width (gp:image-height external-image))
            ;;(format t "1 output-pane1r= ~A~% GRAPHICS STATE= ~a~%" output-pane1 graphics-state)
            ;;this works for setting graphics state!!
            ;;(gp:set-graphics-state output-pane1 :transform *photo-transform-list);;works '(.5 0 0 .5 0 0))
            #|             (show-text (format nil "output-pane1= ~A~% external-image= ~A~% GRAPHICS STATE= ~a~%" output-pane1 external-image graphics-state) 200 nil)|#
            ;;XXX
            #|  4-7       (cond 
              (image 
               (gp:free-image output-pane1 image)
               (format t "~%IMAGE IS OK  ~%")                  
               (setf image (gp:load-image output-pane1 external-image))
               (if *show-details (show-text (format nil "4a IMAGE= ~a~%" IMAGE) 200 nil))
       |#
            ;;
            ;;make the photo-info INCLUDING THE *current-image
            ;;    later make these local variables passed by multiple-value-bind??
|#

      #|
;; THIS DOESN'T PRODUCE AN IMAGE
;;from change-photo code that works
#|(external-image     
            ;;THIS IS THE REAL CALCULATOR WORK
            (multiple-value-setq (image *photo-transform-list)
                (display-photo-image interface file external-image *photo-transform-list ))
            ;;image updates the slot above in (with-slots 
            ;; (setf image (gp:load-image output-pane1 new-image))  |#
            (setf text2  (format nil " *STEP 8: DISPLAY THE IMAGE~% current-image ~A~% *photo-transform-list= ~A~% *current-photo-file= ~A~%"
                                 *current-image *photo-transform-list *current-photo-file))
            (if *show-details (show-text text2 200 nil))
            ;;set the interface image slot-value 
            (setf image *current-image)
            (update-photo-viewer interface)
|#
      ;;(CAPI:APPLY-IN-PANE-PROCESS-IF-ALIVE  ;;didn't make it work--need for 2 processes??
      ;;     (SETF (CAPI:DISPLAY-PANE-TEXT display-pane-1)  "NEW DISPLAY PANE TEXT" )


#|
(capi:contain (make-instance
'capi:grid-layout
:description children
:x-adjust '(:right :left)
:y-adjust :center))|#