
(defun testdi ()
 (capi:display (make-instance 'interface-2))
)

;;SSS START HERE TESTING TO INSERT FOR MENUS IN PHOTO-VIEWER

(capi:define-interface interface-2 ()
  ()
  (:menu-bar file-menu photo-order-menu  )
  (:menus
   (dir-or-file-order-menu
    "Order By Directories or All Files"
    ((:component
     (("Order Photo Directories Only"
      :callback 'order-by-dirs-callback
      :callback-type '( :interface :data))
      ("Order All Files--not Directories"
      :callback 'order-by-files-callback
      :callback-type '( :interface :data)))
     :interaction :single-selection)
    ))
   (photo-order-menu
    "Photo Order"
    ((:component
     (("Random Playback"
      :callback 'photo-order-random-callback
      :callback-type :interface)
      ("Descending Order Playback"
      :callback 'photo-order-descend-callback
      :callback-type :interface)
      ("Ascending Order Playback"
      :callback 'photo-order-ascend-callback
      :callback-type :interface))
      :interaction :single-selection)
      dir-or-file-order-menu
      ))
   (file-menu
    "File"
    (("Save Photo to Saved Directory"
      :callback 'copy-display-image-file-callback
      :callback-type :interface)
     ("Choose Slideshow Photo Directory"
      :text "Select SLIDESHOW Directory"
      :callback 'select-slideshow-dir-callback
      :callback-type :interface)
     ("Select SAVED Photo Directory"
      :text "Slideshow photos played from this directory"
      :callback 'select-saved-dir-callback
      :callback-type :interface)
     photo-order-menu
     dir-or-file-order-menu)))

  (:default-initargs
   :best-height nil
   :best-width nil
   :title "Interface-2"))
