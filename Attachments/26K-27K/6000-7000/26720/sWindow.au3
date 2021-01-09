#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

;===============================================================================
; Function Name:    _makeWindow()
; Description:      Generate a steam window with independant controls
; Parameter(s):      $sWINDOW_TITLE = ""             Title of Window
; 					 $MainSectionText = "Content"    Content Area Header
; 					 $iWINDOW_WIDTH = 200			 Window Width
; 					 $iWINDOW_HEIGHT = 200			 Window Height
;					 $iWINDOW_X = -1			     Window X Position
; 					 $iWINDOW_Y = -1			     Window Y Position
;				     $iwinShow = True			     Window is visible
; 					 $iWINDOW_STYLE = ""			 Window Style
; 					 $iWINDOW_xSTYLE = ""			 Window Extended Style
;				     $iParent = ""					 Window Parent
;				     $iPath = ""				     Image Path


; Requirement(s):   n/a
; Return Value(s):  On Success - Returns Array containing:
;							   -  Window Handle,           element 0
;							   -  Left Panel Width,        element 1
;							   -  Content Area Start,      element 2
;							   -  Window Header,           element 3
;							   -  Content Area Header,     element 4
;							   -  Window Close Handle,     element 5
;                   On Failure - Returns -1 and sets @error:
; 							   - 1 = Missing hdr.bmp
; 							   - 2 = Missing cls.bmp
;                              - 3 = Missing cnr.bmp
;							   - 4 = Invalid Parent Window
;							   - 5 = Could not create window
; Remarks:          It's best to use the GuiGetMsg(1) array to process
;                     windows created with this command.  If you process
;                     the initial array [0], for example, to check if a window
;                     is to be closed, then you can parse the [1] array to see
;                     if the close window command is comming from a specific
;                     window, or the application in whole.  It stops making
;                     you close a window, and exit the entire app at the same
;                     time.  See the UDF post on AutoIT Forums for the proper
;                     use of the while/wend/message loop :)
; Link: 
; Authors:        	Initial Script (not independant controls)  - Dreamfire
;					Edit for UDF and Code	  			       - zackrspv
;===============================================================================
Func _makeWindow($sWINDOW_TITLE = "", $MainSectionText = "Content", $iWINDOW_WIDTH = 200, $iWINDOW_HEIGHT = 200, $iWINDOW_X = -1, $iWINDOW_Y = -1, $iwinShow = True, $iWINDOW_STYLE = "", $iWINDOW_xSTYLE = "", $iParent = "", $iPath = "")
	If $iPath = "" Then $iPath = @ScriptDir
	If Not FileExists($iPath & '\hdr.bmp') Then
		SetError(1)
		Return -1
	EndIf
	If Not FileExists($iPath & '\cls.bmp') Then
		SetError(2)
		Return -1
	EndIf
	If Not FileExists($iPath & '\cnr.bmp') Then
		SetError(3)
		Return -1
	EndIf
	If $iParent <> "" And Not IsHWnd($iParent) Then
		SetError(4)
		Return -1
	EndIf
	If $iWINDOW_STYLE = "" Then $iWINDOW_STYLE = BitOR($WS_POPUP, $WS_SYSMENU, $WS_MINIMIZEBOX)
	If $iWINDOW_xSTYLE = "" Then $iWINDOW_xSTYLE = $WS_EX_LAYERED
	$lDiff = $iWINDOW_WIDTH / 4
	$mDiff = $iWINDOW_WIDTH - $lDiff
	$iWindowName = GUICreate($sWINDOW_TITLE, $iWINDOW_WIDTH, $iWINDOW_HEIGHT, $iWINDOW_X, $iWINDOW_Y, $iWINDOW_STYLE, $iWINDOW_xSTYLE, $iParent)
	If $iWindowName = 0 Then
		SetError(5)
		Return -1
	EndIf
	GUISetFont(8, 400, 0, 'Tahoma')
	GUISetBkColor(0x494E49)
	GUICtrlCreatePic('hdr.bmp', 0, 0, $iWINDOW_WIDTH - 16, 20, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('hdr.bmp', $iWINDOW_WIDTH - 16, 0, 11, 5, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('hdr.bmp', $iWINDOW_WIDTH - 16, 16, 11, 4, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('hdr.bmp', $iWINDOW_WIDTH - 5, 0, 5, 20, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreateGraphic(0, 20, 1, $iWINDOW_HEIGHT)
	GUICtrlSetColor(-1, 0x686A65)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGraphic($iWINDOW_WIDTH - 1, 20, 1, $iWINDOW_HEIGHT)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetColor(-1, 0x686A65)
	GUICtrlCreateGraphic(0, $iWINDOW_HEIGHT - 1, $iWINDOW_WIDTH, 1)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetColor(-1, 0x686A65)
	$oCLOSE = GUICtrlCreatePic('cls.bmp', $iWINDOW_WIDTH - 16, 5, 11, 11, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	$oLABELHEADER = GUICtrlCreateLabel($sWINDOW_TITLE, 6, 0, $iWINDOW_WIDTH - 22, 20, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0xD8DED3)
	GUICtrlSetBkColor(-1, 0x5A6A50)
	GUICtrlCreateGraphic(1, 20, $lDiff, $iWINDOW_HEIGHT - 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetColor(-1, 0x464646)
	GUICtrlSetBkColor(-1, 0x464646)
	GUICtrlCreateGraphic($lDiff + 2, 20, 1, $iWINDOW_HEIGHT - 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetColor(-1, 0x3D423D)
	GUICtrlCreateGraphic($lDiff + 1, 20, 1, $iWINDOW_HEIGHT - 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetColor(-1, 0x424742)
	GUICtrlCreateGraphic($lDiff, 20, 1, $iWINDOW_HEIGHT - 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetColor(-1, 0x454A45)
	$oLABELTOP = GUICtrlCreateLabel($MainSectionText, $lDiff + 20, 31, $mDiff - 40, 20, $SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 8, 800, 0, 'Tahoma')
	GUICtrlSetColor(-1, 0xC4B550)
	GUICtrlCreateGraphic($lDiff + 10, 51, $mDiff - 20, 1)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetColor(-1, 0x636763)
	;make this the last graphic drawn in the main graphics section
	GUICtrlCreateGraphic($lDiff + 10, 30, $mDiff - 20, $iWINDOW_HEIGHT - 40)
	GUICtrlSetColor(-1, 0x686A65)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic('cnr.bmp', 0, 0, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('cnr.bmp', $iWINDOW_WIDTH - 1, 0, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('cnr.bmp', 0, $iWINDOW_HEIGHT - 1, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic('cnr.bmp', $iWINDOW_WIDTH - 1, $iWINDOW_HEIGHT - 1, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	If $iwinShow = True Then
		GUISetState(@SW_SHOW)
	EndIf
	Local $rWindows[7] = [$iWindowName, $lDiff, $mDiff, $oLABELHEADER, $oLABELTOP, $oCLOSE, $iwinShow]
	Return $rWindows
EndFunc   ;==>_makeWindow
