(context 'window)

(define (import-list library flist)
    (dolist (fname flist) (import library (string fname))))

(define-macro (@setq %var %value)
    (set %var (eval %value))
    ;(println %var " " (eval %var))
    )

(import-list "kernel32" '(GetModuleHandleA FreeConsole))
(import-list "user32" '(PostQuitMessage DefWindowProcA))
(import-list "user32" '(LoadCursorA RegisterClassA CreateWindowExA))
(import-list "user32" '(ShowWindow UpdateWindow))
(import-list "user32" '(GetMessageA TranslateMessage DispatchMessageA))

(import-list "htmlayout.dll" '(HTMLayoutLoadFile HTMLayoutLoadHtml))
(import-list "htmlayout.dll" '(HTMLayoutSetCallback HTMLayoutProcND))

(FreeConsole)

(setq WM_CREATE 1 WM_DESTROY 2 WM_CHAR 0x102 WM_LBUTTONDOWN 0x201)
(setq IDC_ARROW 0x7F00 CS_VREDRAW 1 CS_HREDRAW 2 COLOR_WINDOW 5)
(setq WS_OVERLAPPEDWINDOW 0xCF0000 HWND_MESSAGE -3 SW_SHOWDEFAULT 10)
(setq WS_EX_LAYERED 0x80000)
(setq
    WS_POPUP        0x80000000
    WS_MAXIMIZEBOX  0x00010000
    WS_MINIMIZEBOX  0x00020000
    WS_SIZEBOX      0x00040000
    WS_SYSMENU      0x00080000
)

;create window
(define (create x y width height caption)
    (setq hwnd 
        (CreateWindowExA
            0;WS_EX_LAYERED           ; dwExStyle
            classname               ; lpClassName
            "newlisp window"        ; lpWindowName
            (| WS_POPUP
                WS_MAXIMIZEBOX
                WS_MINIMIZEBOX
                WS_SYSMENU
                WS_SIZEBOX
            )                       ; dwStyle
            x y width height        ; x y w h
            0                       ; hwndParent
            0                       ; hMenu
            hinstance               ; hInstance
            0
        )
    )
    ;(HTMLayoutSetCallback hWnd hltproc 0)
    (setq htmltext (read-file "F:/Downloads/HTMLayoutSDK/skin/res/index.htm"))
    (HTMLayoutLoadHtml hwnd htmltext (length htmltext))
    hwnd
)

;register_class
(define (register_class hinstance)
    (RegisterClassA
        (pack (dup "ld" 10)
            (| CS_HREDRAW CS_VREDRAW)   ; style
            wndproc                     ; lpfnWndProc
            0                           ; cbClsExtra
            0                           ; cbWndExtra
            hinstance                   ; hInstance
            0                           ; hIcon
            cursor                      ; hCursor
            (+ COLOR_WINDOW 1)          ; hbrBackground
            0                           ; lpszMenuName
            classname                   ; lpszClassName
        )
    )
)


(@setq hinstance (GetModuleHandleA 0))
(@setq cursor (LoadCursorA 0 IDC_ARROW))


(define (window-callback-function hwnd message wparam lparam)
    (setq bhandle 0x0000)
    (setq lresult (HTMLayoutProcND hwnd message wparam lparam (address bhandle)))
    (if (= bhandle 1)
        lresult
        (cond
            ((= message WM_CREATE) ;(println "created") 
                ;(HTMLayoutLoadFile hwnd "/default.htm")
                 0)
            ((= message WM_LBUTTONDOWN) 
                ;(println "click!")
                0)
            ((= message WM_CHAR) 
                ;(println (format "char %c" wparam))
                0)
            ((= message WM_DESTROY) 
                ;(println "destroyed") 
                (PostQuitMessage 0) 0)
            (true (DefWindowProcA hwnd message wparam lparam)))))

(define (htmlayout-callback-function umsg wparam lparam vparam)
    (println "htmlayout-callback-function") 0)


(setq wndproc (callback 0 'window-callback-function))
(setq hltproc (callback 1 'htmlayout-callback-function))

(setq classname "newlisp class")

(@setq hwc (register_class hinstance))
(@setq hwnd (create 80 60 640 480 "caption"))

; hconsole and HWND_MESSAGE are other useful values for hwndParent

(ShowWindow hwnd SW_SHOWDEFAULT)
(UpdateWindow hwnd)


(setq msg (pack "n28"))

(until (member (GetMessageA msg hwnd 0 0) '(0 -1))
    (TranslateMessage msg)
    (DispatchMessageA msg))

;(println "the end")

(exit)
