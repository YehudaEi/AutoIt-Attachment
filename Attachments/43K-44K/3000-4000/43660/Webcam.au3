#include-once
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <Date.au3>


;~ #####################################################
;~ ###                                               ###
;~ ###                  Webcam UDF                   ###
;~ ###                                               ###
;~ ### Functions : _WebcamInit()                     ###
;~ ###             _Webcam()                         ###
;~ ###             _WebcamStop()                     ###
;~ ###             _WebcamSnapShot()                 ###
;~ ###                                               ###
;~ ###              Made by L|M|TER          ###
;~ ### --------------------------------------------- ###
;~ ###                                               ###
;~ ###           Copyright ©2008 - L|M|TER          ###
;~ ###      Updated and modified - BinaryBrother             ###
;~ #####################################################

;~ Declaring Variables

$WM_CAP_START = 0x400
$WM_CAP_UNICODE_START = $WM_CAP_START + 100
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
$cap = ""
$avi = ""
$user = ""
$snapfile = @ScriptDir & "\snapshot.bmp"

;~ ##########################################################
;~ Function Name : _WebcamInit()
;~ Description : Starts the webcam image capturing session
;~ Author : L|M|TER
;~ ##########################################################

Func _WebcamInit()
    $avi = DllOpen("C:\Windows\System32\avicap32.dll")
    $user = DllOpen("C:\Windows\System32\user32.dll")
EndFunc   ;==>_WebcamInit

;~ ##########################################################
;~ Function Name : _Webcam($gui,$h,$w,$l,$t)
;~ Description : Creates a webcam preview window
;~ Parameter(s):
;~  $gui - The gui where the webcam window should be created
;~  $h - The height of the webcam window
;~  $w - The width of the webcam window
;~  $l - The left position of the webcam window
;~  $t - The top position of the webcam window
;~ NOTE : All parameters required !
;~ Author : L|M|TER
;~ ##########################################################

Func _Webcam($gui, $w, $h, $l, $t)
    $cap = DllCall($avi, "int", "capCreateCaptureWindow", "str", "cap", "int", BitOR($WS_CHILD, $WS_VISIBLE), "int", $l, "int", $t, "int", $w, "int", $h, "hwnd", $gui, "int", 1)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_CONNECT, "int", 0, "int", 0)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_SCALE, "int", 1, "int", 0)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_OVERLAY, "int", 1, "int", 0)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEW, "int", 1, "int", 0)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEWRATE, "int", 1, "int", 0)
EndFunc   ;==>_Webcam

;~ ##########################################################
;~ Function Name : _WebcamStop()
;~ Description : Closes the webcam image capturing session
;~ Author : L|M|TER
;~ ##########################################################

Func _WebcamStop()
	DllClose($user)
    DllClose($avi)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_END, "int", 0, "int", 0)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_DISCONNECT, "int", 0, "int", 0)
    DllClose($user)
    DllClose($avi)
EndFunc   ;==>_WebcamStop

;~ ##########################################################
;~ Function Name : _WebcamSnapShot($file)
;~ Description : Takes a snapshot
;~ Parameter(s):
;~  $file (Optional) - The path to the file where the snapshot will be saved (Default : @ScriptDir & "\snapshot.bmp")
;~ Author : L|M|TER
;~ ##########################################################

Func _WebcamSnapShot($Dest = $snapfile, $AddTimeStamp = false)
    $RandomFileName = Random(9000, 99999, 1) & ".bmp"
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_GRAB_FRAME_NOSTOP, "int", 0, "int", 0)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_FILE_SAVEDIBA, "int", 0, "str", $RandomFileName)
    _ConvertImage($RandomFileName, $Dest, $AddTimeStamp)
    FileDelete($RandomFileName)
EndFunc   ;==>_WebcamSnapShot

;~ ##########################################################
;~ Function Name : _ConvertImage($file)  (Handles Timestamping as well)
;~ Description : Converts image
;~ Parameter(s):
;~  $Src - The path to the file where the snapshot was saved in BMP
;~  $Dest - Destination file path with preferred extension
;~  $AddTimeStamp - Bool add timestamp
;~ Author : BinaryBrother (Internal use only)
;~ ##########################################################

Func _ConvertImage($Src, $Dest, $AddTimeStamp = False)
    _GDIPlus_Startup()
    $hImage = _GDIPlus_ImageLoadFromFile($Src)
    If $AddTimeStamp Then
        $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)
        $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
        $hFormat = _GDIPlus_StringFormatCreate()
        $hFamily = _GDIPlus_FontFamilyCreate("Arial")
        $hFont = _GDIPlus_FontCreate($hFamily, 16, 1)
        $tLayout = _GDIPlus_RectFCreate(500, 415, 150, 100)
        _GDIPlus_GraphicsDrawStringEx($hGraphic, _NowDate() & @CRLF & _NowTime(), $hFont, $tLayout, $hFormat, $hBrush)
        _GDIPlus_FontDispose($hFont)
        _GDIPlus_FontFamilyDispose($hFamily)
        _GDIPlus_StringFormatDispose($hFormat)
        _GDIPlus_BrushDispose($hBrush)
        _GDIPlus_GraphicsDispose($hGraphic)
    EndIf
    _GDIPlus_ImageSaveToFile($hImage, $Dest)
    _GDIPlus_ImageDispose($hImage)
    _GDIPlus_Shutdown()
EndFunc   ;==>_ConvertImage