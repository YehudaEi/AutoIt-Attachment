#CS ==========================================================================================
; Name...........: First UDF GDIPlus.au3 UDF
; Description ...: Skin Your GUI With GDIPlus.au3, Fast & Easy
;
; Syntax ........:
                _UDF_SKINGUI_MAKE($GUI_NAME)
                _UDF_SKINGUI_label($TEXT_COLOR,$TEXT,$LEFT,$TOP,$WIDTH,$HEIGHT)
                _UDF_SKINGUI_BUTTON($TEXT_COLOR,$TEXT_BKCOLOR,$TEXT,$LEFT,$TOP,$WIDTH,$HEIGHT)
                _UDF_SKINGUI_Checkbox($TEXT_COLOR,$TEXT_BKCOLOR,$TEXT,$LEFT,$TOP,$WIDTH,$HEIGHT,$STATE)
                _UDF_SKINGUI_RADIO($TEXT_COLOR,$TEXT_BKCOLOR,$TEXT,$LEFT,$TOP,$WIDTH,$HEIGHT,$STATE)
                _UDF_SKINGUI_DELETE($Form1_GUI)
                   
               
                $MY_GUIIMAGE = 'testgui.png'
                $MY_GUIIMAGE2 = 'grey.gif'
               
                FileInstall('testgui.png', "testgui.png",0) ; use this To install ur GUI Image When you compile ur Script
                FileInstall('grey.gif', "grey.gif",0)     ; use this To install ur GUI Image When you compile ur Script

; Remarks .......:
                Fore some Reason you cant make the Checkbox & Radio Background Transparent, so you will h ave to set the color manually.
				the $GUI_BKCOLOR_TRANSPARENT Does not work, Bites me Why.

; Author ........: Goldenix
; AutoIt Version.: 3.2.12.0
#ce ==========================================================================================
#include <GDIPlus.au3>; this is where the magic happens, people
#include <WindowsConstants.au3>

Opt("MustDeclareVars", 0)

		Global Const $AC_SRC_ALPHA = 1
		;~ Global Const $ULW_ALPHA         = 2
		Global $old_string = "", $runthis = ""

		; Load PNG file as GDI bitmap
		_GDIPlus_Startup()
		$hImage = _GDIPlus_ImageLoadFromFile($MY_GUIIMAGE) ; This is UR GUI IMAGE

		; Extract image width and height from PNG
		$width = _GDIPlus_ImageGetWidth($hImage)
		$height = _GDIPlus_ImageGetHeight($hImage)

		; Create layered window
		$GUI = GUICreate("The Main Gui pic", $width, $height, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
		SetBitmap($GUI, $hImage, 0)
		; Register notification messages
		GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
		GUISetState()
		;fade in png background
		For $i = 0 To 255 Step 10
			SetBitmap($GUI, $hImage, $i)
		Next
		
		
;~ ==========================================
;~ UDF MAKE GUI
;~ $Form1 = _UDF_SKINGUI_MAKE('My Gui')
;~ ==========================================
Func _UDF_SKINGUI_MAKE($GUI_NAME)	
	; create child MDI gui window to hold controls
	; this part could use some work - there is some flicker sometimes...
	$GUI_NAME = GUICreate($GUI_NAME, $width, $height, 4, 0, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $GUI)

	; child window transparency is required to accomplish the full effect, so $WS_EX_LAYERED above, and
	; I think the way this works is the transparent window color is based on the image you set here:
	GUICtrlCreatePic($MY_GUIIMAGE2, 0, 0, $width, $height)
	GUICtrlSetState(-1, $GUI_DISABLE)

	Return $GUI_NAME
EndFunc

;~ ==========================================
;~ UDF _LABEL
;~ $MyLabe = _UDF_SKINGUI_label("Some Text",0x000000, 8, 504, 200, 17)
;~ ==========================================
Func _UDF_SKINGUI_label($TEXT_COLOR,$TEXT,$LEFT,$TOP,$WIDTH,$HEIGHT)
		
	$Label_Create = GUICtrlCreateLabel($TEXT, $LEFT, $TOP, $WIDTH, $HEIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, $TEXT_COLOR)

	Return $Label_Create
EndFunc

;~ ==========================================
;~ UDF _BUTTON
;~ [T_Color],[BG_Color],[Text],[LEFT],[TOP],[WIDTH],[HEIGHT]
;~ $Button4_Filter = _UDF_SKINGUI_BUTTON(0x000000,0xEAF3FA,"Edit Filter", 488, 468, 75, 25, 0)
;~ ==========================================
Func _UDF_SKINGUI_BUTTON($TEXT_COLOR,$TEXT_BKCOLOR,$TEXT,$LEFT,$TOP,$WIDTH,$HEIGHT)
		
	$Button_Create = GUICtrlCreateButton($TEXT, $LEFT, $TOP, $WIDTH, $HEIGHT)		
		GUICtrlSetBkColor(-1, $TEXT_BKCOLOR)
		GUICtrlSetColor(-1, $TEXT_COLOR)
		
	Return $Button_Create
EndFunc

;~ ==========================================
;~ UDF _Checkbox
;~ ;[Text],[T_Color],[BG_Color],[LEFT],[TOP],[WIDTH],[HEIGHT],[State -1 = Checkked / State 0 = UNCheckked ]
;~ $Checkbox1 = _UDF_SKINGUI_Checkbox("Filter Enabled",0x000000,0xEAF3FA, 488, 446, 97, 17,-1) 
;~ ==========================================
Func _UDF_SKINGUI_Checkbox($TEXT_COLOR,$TEXT_BKCOLOR,$TEXT,$LEFT,$TOP,$WIDTH,$HEIGHT,$STATE)
		
	$Checkbox_Create = GUICtrlCreateCheckbox($TEXT, $LEFT, $TOP, $WIDTH, $HEIGHT)		
		GUICtrlSetBkColor(-1, $TEXT_BKCOLOR)
		GUICtrlSetColor(-1, $TEXT_COLOR)
		If $STATE = -1 Then GUICtrlSetState(-1, $GUI_CHECKED)
			
	Return $Checkbox_Create
EndFunc

;~ ==========================================
;~ UDF _RADIO
;~ ;[Text],[T_Color],[BG_Color],[LEFT],[TOP],[WIDTH],[HEIGHT],[State -1 = Checkked / State 0 = UNCheckked ]
;~ $Radio_ = _UDF_SKINGUI_RADIO("Radio1",0x000000,0xEAF3FA, 488, 446, 97, 17,-1) 
;~ ==========================================
Func _UDF_SKINGUI_RADIO($TEXT_COLOR,$TEXT_BKCOLOR,$TEXT,$LEFT,$TOP,$WIDTH,$HEIGHT,$STATE)
		
	$Radio_Create = GUICtrlCreateRadio($TEXT, $LEFT, $TOP, $WIDTH, $HEIGHT)		
		GUICtrlSetBkColor(-1, $TEXT_BKCOLOR)
		GUICtrlSetColor(-1, $TEXT_COLOR)
		If $STATE = -1 Then GUICtrlSetState(-1, $GUI_CHECKED)
			
	Return $Radio_Create
EndFunc

;~ ==========================================
;~ UDF DELETE GUI - Will only Delete GUI
;~ _UDF_SKINGUI_DELETE($Form1)
;~ ==========================================
Func _UDF_SKINGUI_DELETE($Form1_GUI)
	
	GUIDelete($Form1_GUI)
	;fade out png background
	For $i = 255 To 0 Step -10
		SetBitmap($GUI, $hImage, $i)
	Next

	; Release resources
	_WinAPI_DeleteObject($hImage)
	_GDIPlus_Shutdown()

	FileDelete($MY_GUIIMAGE)
EndFunc


; ====================================================================================================
; Handle the WM_NCHITTEST for the layered window so it can be dragged by clicking anywhere on the image.
; ====================================================================================================
Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
    If ($hWnd = $GUI) And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
EndFunc   ;==>WM_NCHITTEST

; ====================================================================================================
; SetBitMap
; ====================================================================================================
Func SetBitmap($hGUI, $hImage, $iOpacity)
    Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

    $hScrDC = _WinAPI_GetDC(0)
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSize = DllStructCreate($tagSIZE)
    $pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
    DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
    $tSource = DllStructCreate($tagPOINT)
    $pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    $pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $iOpacity)
    DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap


; I don't like AutoIt's built in ShellExec. I'd rather do the DLL call myself.
Func _ShellExecute($sCmd, $sArg = "", $sFolder = "", $rState = @SW_SHOWNORMAL)
    $aRet = DllCall("shell32.dll", "long", "ShellExecute", _
            "hwnd", 0, _
            "string", "", _
            "string", $sCmd, _
            "string", $sArg, _
            "string", $sFolder, _
            "int", $rState)
    If @error Then Return 0

    $RetVal = $aRet[0]
    If $RetVal > 32 Then
        Return 1
    Else
        Return 0
    EndIf
EndFunc   ;==>_ShellExecute