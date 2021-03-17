#include-once
#include <GUIConstants.au3>

;~ #####################################################
;~ ###												 ###
;~ ###					Webcam UDF					 ###
;~ ###												 ###
;~ ### Functions : _WebcamInit()					 ###
;~ ###			   _Webcam()						 ###
;~ ###			   _WebcamStop()					 ###
;~ ###			   _WebcamSnapShot()				 ###
;~ ###												 ###
;~ ###			      Made by L|M|TER				 ###
;~ ### --------------------------------------------- ###
;~ ###												 ###
;~ ###			 Copyright ©2008 - L|M|TER			 ###
;~ ###												 ###
;~ #####################################################

;~ Declaring Variables

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
$avi = DllOpen("avicap32.dll")
$user = DllOpen("user32.dll")
EndFunc

;~ ##########################################################
;~ Function Name : _Webcam($gui,$h,$w,$l,$t)
;~ Description : Creates a webcam preview window
;~ Parameter(s):
;~ 	$gui - The gui where the webcam window should be created
;~ 	$h - The height of the webcam window
;~ 	$w - The width of the webcam window
;~ 	$l - The left position of the webcam window
;~ 	$t - The top position of the webcam window
;~ NOTE : All parameters required !
;~ Author : L|M|TER
;~ ##########################################################

Func _Webcam($gui,$w,$h,$l,$t)
$cap = DllCall($avi, "int", "capCreateCaptureWindow", "str", "cap", "int", BitOR($WS_CHILD,$WS_VISIBLE), "int", $l, "int", $t, "int", $w, "int", $h, "hwnd", $gui, "int", 1)

DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_CONNECT, "int", 0, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_SCALE, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_OVERLAY, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEW, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEWRATE, "int", 1, "int", 0)

Return $cap
EndFunc

;~ ##########################################################
;~ Function Name : _WebcamStop()
;~ Description : Closes the webcam image capturing session
;~ Author : L|M|TER
;~ ##########################################################

Func _WebcamStop()
        DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_END, "int", 0, "int", 0)
        DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_DISCONNECT, "int", 0, "int", 0)
        DllClose($user)
		DllClose($avi)
EndFunc

;~ ##########################################################
;~ Function Name : _WebcamSnapShot($file)
;~ Description : Takes a snapshot
;~ Parameter(s):
;~ 	$file (Optional) - The path to the file where the snapshot will be saved (Default : @ScriptDir & "\snapshot.bmp")
;~ Author : L|M|TER
;~ ##########################################################

Func _WebcamSnapShot($file = $snapfile)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_GRAB_FRAME_NOSTOP, "int", 0, "int", 0)
    DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_FILE_SAVEDIBA, "int", 0, "str", $file)
EndFunc

Func GraphicsBlit($hWnd, ByRef $hHBMP)
    Local $hDC = 0, $tRect = 0

    $hDC = _WinAPI_GetDC($hWnd)

    $tRect = _WinAPI_GetClientRect($hWnd)

    Local $iLeft = DllStructGetData($tRect, "Left"), $iTop = DllStructGetData($tRect, "Top")
    Local $iRight = DllStructGetData($tRect, "Right"), $iBottom = DllStructGetData($tRect, "Bottom")

    Local $hDDC = _WinAPI_GetDC($hWnd)
    Local $hCDC = _WinAPI_CreateCompatibleDC($hDDC)
    $hHBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iRight - $iLeft, $iBottom - $iTop)

    _WinAPI_SelectObject($hCDC, $hHBMP)

    _WinAPI_BitBlt($hCDC, 0, 0, $iRight - $iLeft, $iBottom - $iTop, $hDDC, $iLeft, $iTop, $SRCCOPY)

    _WinAPI_ReleaseDC($hWnd, $hDDC)
    _WinAPI_DeleteDC($hCDC)
EndFunc   ;==>GraphicsBlitBetweenWindows

Func _GDIPlus_SaveImage2Binary($hBitmap, $iQuality = 60) ;Coded by Andreik, modified by UEZ
    Local $sImgCLSID = _GDIPlus_EncodersGetCLSID("jpg")
    Local $tGUID = _WinAPI_GUIDFromString($sImgCLSID)
    Local $pEncoder = DllStructGetPtr($tGUID)
    Local $tParams = _GDIPlus_ParamInit(1)
    Local $tData = DllStructCreate("int Quality")
    DllStructSetData($tData, "Quality", $iQuality) ;quality 0-100
    Local $pData = DllStructGetPtr($tData)
    _GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, $pData)
    Local $pParams = DllStructGetPtr($tParams)
    Local $hStream = DllCall("ole32.dll", "uint", "CreateStreamOnHGlobal", "ptr", 0, "bool", True, "ptr*", 0)
    $hStream = $hStream[3]
    DllCall($ghGDIPDll, "uint", "GdipSaveImageToStream", "ptr", $hBitmap, "ptr", $hStream, "ptr", $pEncoder, "ptr", $pParams)
;~  _GDIPlus_BitmapDispose($hBitmap)
    Local $hMemory = DllCall("ole32.dll", "uint", "GetHGlobalFromStream", "ptr", $hStream, "ptr*", 0)
    $hMemory = $hMemory[2]
    Local $iMemSize = _MemGlobalSize($hMemory)
    Local $pMem = _MemGlobalLock($hMemory)
    $tData = DllStructCreate("byte[" & $iMemSize & "]", $pMem)
    Local $bData = DllStructGetData($tData, 1)
    Local $tVARIANT = DllStructCreate("word vt;word r1;word r2;word r3;ptr data;ptr")
    DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "dword", 8 + 8 * @AutoItX64, "dword", 4, "dword", 23, "dword", 0, "ptr", 0, "ptr", 0, "ptr", DllStructGetPtr($tVARIANT))
    _MemGlobalFree($hMemory)
    Return $bData
EndFunc   ;==>__GDIPlus_SaveImage2Binary