#include <GUIConstants.au3>
#include <WindowsConstants.au3>
Global $Area
Global $Paused
Global $DISPSIZE

HotKeySet("{ESC}", "Terminate")
HotKeySet("{TAB}", "TogglePause")


$WM_CAP_START = 0x400
$WM_CAP_UNICODE_START = $WM_CAP_START +100
$WM_CAP_PAL_SAVEA = $WM_CAP_START + 81
$WM_CAP_PAL_SAVEW = $WM_CAP_UNICODE_START + 81
$WM_CAP_UNICODE_END = $WM_CAP_PAL_SAVEW
$WM_CAP_ABORT = $WM_CAP_START + 69
$WM_CAP_DLG_VIDEOCOMPRESSION = $WM_CAP_START + 46
$WM_CAP_DLG_VIDEODISPLAY = $WM_CAP_START + 43
$WM_CAP_DLG_VIDEOFORMAT = $WM_CAP_START + 41
$WM_CAP_DLG_VIDEOSOURCE = $WM_CAP_START + 42
$WM_CAP_DRIVER_CONNECT = $WM_CAP_START + 10
$WM_CAP_DRIVER_DISCONNECT = $WM_CAP_START + 11
$WM_CAP_DRIVER_GET_CAPS = $WM_CAP_START + 14
$WM_CAP_DRIVER_GET_NAMEA = $WM_CAP_START + 12
$WM_CAP_DRIVER_GET_NAMEW = $WM_CAP_UNICODE_START + 12
$WM_CAP_DRIVER_GET_VERSIONA = $WM_CAP_START + 13
$WM_CAP_DRIVER_GET_VERSIONW = $WM_CAP_UNICODE_START + 13
$WM_CAP_EDIT_COPY = $WM_CAP_START + 30
$WM_CAP_END = $WM_CAP_UNICODE_END
$WM_CAP_FILE_ALLOCATE = $WM_CAP_START + 22
$WM_CAP_FILE_GET_CAPTURE_FILEA = $WM_CAP_START + 21
$WM_CAP_FILE_GET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 21
$WM_CAP_FILE_SAVEASA = $WM_CAP_START + 23
$WM_CAP_FILE_SAVEASW = $WM_CAP_UNICODE_START + 23
$WM_CAP_FILE_SAVEDIBA = $WM_CAP_START + 25
$WM_CAP_FILE_SAVEDIBW = $WM_CAP_UNICODE_START + 25
$WM_CAP_FILE_SET_CAPTURE_FILEA = $WM_CAP_START + 20
$WM_CAP_FILE_SET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 20
$WM_CAP_FILE_SET_INFOCHUNK = $WM_CAP_START + 24
$WM_CAP_GET_AUDIOFORMAT = $WM_CAP_START + 36
$WM_CAP_GET_CAPSTREAMPTR = $WM_CAP_START + 1
$WM_CAP_GET_MCI_DEVICEA = $WM_CAP_START + 67
$WM_CAP_GET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 67
$WM_CAP_GET_SEQUENCE_SETUP = $WM_CAP_START + 65
$WM_CAP_GET_STATUS = $WM_CAP_START + 54
$WM_CAP_GET_USER_DATA = $WM_CAP_START + 8
$WM_CAP_GET_VIDEOFORMAT = $WM_CAP_START + 44
$WM_CAP_GRAB_FRAME = $WM_CAP_START + 60
$WM_CAP_GRAB_FRAME_NOSTOP = $WM_CAP_START + 61
$WM_CAP_PAL_AUTOCREATE = $WM_CAP_START + 83
$WM_CAP_PAL_MANUALCREATE = $WM_CAP_START + 84
$WM_CAP_PAL_OPENA = $WM_CAP_START + 80
$WM_CAP_PAL_OPENW = $WM_CAP_UNICODE_START + 80
$WM_CAP_PAL_PASTE = $WM_CAP_START + 82
$WM_CAP_SEQUENCE = $WM_CAP_START + 62
$WM_CAP_SEQUENCE_NOFILE = $WM_CAP_START + 63
$WM_CAP_SET_AUDIOFORMAT = $WM_CAP_START + 35
$WM_CAP_SET_CALLBACK_CAPCONTROL = $WM_CAP_START + 85
$WM_CAP_SET_CALLBACK_ERRORA = $WM_CAP_START + 2
$WM_CAP_SET_CALLBACK_ERRORW = $WM_CAP_UNICODE_START + 2
$WM_CAP_SET_CALLBACK_FRAME = $WM_CAP_START + 5
$WM_CAP_SET_CALLBACK_STATUSA = $WM_CAP_START + 3
$WM_CAP_SET_CALLBACK_STATUSW = $WM_CAP_UNICODE_START + 3
$WM_CAP_SET_CALLBACK_VIDEOSTREAM = $WM_CAP_START + 6
$WM_CAP_SET_CALLBACK_WAVESTREAM = $WM_CAP_START + 7
$WM_CAP_SET_CALLBACK_YIELD = $WM_CAP_START + 4
$WM_CAP_SET_MCI_DEVICEA = $WM_CAP_START + 66
$WM_CAP_SET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 66
$WM_CAP_SET_OVERLAY = $WM_CAP_START + 51
$WM_CAP_SET_PREVIEW = $WM_CAP_START + 50
$WM_CAP_SET_PREVIEWRATE = $WM_CAP_START + 52
$WM_CAP_SET_SCALE = $WM_CAP_START + 53
$WM_CAP_SET_SCROLL = $WM_CAP_START + 55
$WM_CAP_SET_SEQUENCE_SETUP = $WM_CAP_START + 64
$WM_CAP_SET_USER_DATA = $WM_CAP_START + 9
$WM_CAP_SET_VIDEOFORMAT = $WM_CAP_START + 45
$WM_CAP_SINGLE_FRAME = $WM_CAP_START + 72
$WM_CAP_SINGLE_FRAME_CLOSE = $WM_CAP_START + 71
$WM_CAP_SINGLE_FRAME_OPEN = $WM_CAP_START + 70
$WM_CAP_STOP = $WM_CAP_START + 68



const $a = 110*4
const $c = 131*4
const $qn =(1000/4)



#include <GUIConstants.au3>
$avi = DllOpen("avicap32.dll")
$user = DllOpen("user32.dll")



; Load Camera
$Main = GUICreate("Camera",455,290,0,0, $WS_DLGFRAME)
$cap = DllCall($avi, "int", "capCreateCaptureWindow", "str", "cap", "int", BitOR($WS_CHILD,$WS_VISIBLE), "int", 0, "int", 0, "int", 320, "int", 240, "hwnd", $Main, "int", 1)
$track1 = GUICtrlCreateButton ("Set Tracking Color", 345,15,100)
$START = GUICtrlCreateButton ("Start Sections", 345,105,100)
$Quit = GUICtrlCreateButton ("Quit", 345,167.5,100)
$ABOUT = GUICtrlCreateButton ("About", 345,230,100)


AutoItSetOption ( "MouseCoordMode" ,0)
AutoItSetOption ( "PixelCoordMode" ,0)

DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_CONNECT, "int", 0, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_SCALE, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_OVERLAY, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEW, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEWRATE, "int", 1, "int", 0)

GUISetState(@SW_SHOW)

GUISetState ()
; Setup
Do
    $msg = GUIGetMsg()
    if $msg = $track1 then
MsgBox ( 0, "Instructions", "To set the tracking color, Place the mouse over the color you would like to track and press enter to exit this Message Box.")
$Mousecol = MouseGetPos ( )
$P1col = PixelGetColor ( $Mousecol[0] , $Mousecol[1] )
MsgBox(0,"Tracking color is", Hex($P1col, 6))
GUICtrlDelete ( $track1 )
    endif
        
    if $msg = $ABOUT then
MsgBox ( 0, "About", "Tracking Program and GUI programmed by MikeFez. Camera script by rysiora.")
    endif
	
	if $msg = $Quit then
Terminate()
    endif
Until $msg = $START
WinSetOnTop("Camera", "", 1)
GUICtrlDelete ( $START )
GUICtrlDelete ( $Quit )
GUICtrlDelete ( $ABOUT)
GUISetState()

; Find Players
While 1
; Find Sector1
$coord1 = PixelSearch( 0, 0, 106.6, 80, $P1col, 5 )
If Not @error Then
MouseMove($coord1[0], $coord1[1], 0)
$Area = 1
EndIf    

; Find Sector2
$coord2 = PixelSearch( 106.6, 0, 213.2, 80, $P1col, 5 )
If Not @error Then
MouseMove($coord2[0], $coord2[1], 0)
$Area = 2
EndIf    

; Find Sector3
$coord3 = PixelSearch( 213.2, 0, 320, 80, $P1col, 5 )
If Not @error Then
MouseMove($coord3[0], $coord3[1], 0)
$Area = 3
EndIf   

; Find Sector4
$coord4 = PixelSearch( 0, 80, 106.6, 160, $P1col, 5 )
If Not @error Then
MouseMove($coord4[0], $coord4[1], 0)
$Area = 4
EndIf   

; Find Sector5
$coord5 = PixelSearch( 106.6, 80, 160, 160, $P1col, 5 )
If Not @error Then
MouseMove($coord5[0], $coord5[1], 0)
$Area = 5
EndIf   

; Find Sector6
$coord6 = PixelSearch( 213.2, 80, 320, 160, $P1col, 5 )
If Not @error Then
MouseMove($coord6[0], $coord6[1], 0)
$Area = 6
EndIf   

; Find Sector7
$coord7 = PixelSearch( 0, 160, 106.6, 240, $P1col, 5 )
If Not @error Then
MouseMove($coord7[0], $coord7[1], 0)
$Area = 7
 EndIf   

; Find Sector8
$coord8 = PixelSearch( 106.6, 160, 213.2, 240, $P1col, 5 )
If Not @error Then
MouseMove($coord8[0], $coord8[1], 0)
$Area = 8
EndIf   

; Find Sector9
$coord9 = PixelSearch( 213.2, 160, 320, 240, $P1col, 5 )
If Not @error Then
MouseMove($coord9[0], $coord9[1], 0)
$Area = 9
EndIf   

Tooltip ("Area #" & $Area)
WEnd


; ----------- Pause and Exit
Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('Pong is "Paused"',0,0)
    WEnd
    ToolTip("")
EndFunc
Func Terminate()
       
       ;DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_CALLBACK_FRAME, "int", 0, "int", 0)
        DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_END, "int", 0, "int", 0)
        DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_DISCONNECT, "int", 0, "int", 0)
   ;DllClose($avi)
        DllClose($user)
    Exit 0
EndFunc