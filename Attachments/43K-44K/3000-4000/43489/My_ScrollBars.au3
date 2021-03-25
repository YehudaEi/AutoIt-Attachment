#cs ----------------------------------------------------------------------------

    AutoIt Version: 3.3.10.2
    Author:         myName

    Script Function:
    Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIScrollBars.au3>
#include <WinAPIShellEx.au3>
#include <WinAPI.au3>
#include <Misc.au3>

Global Const $__BTNARROW_SIZE = 22, $__BTNPAGE_SIZE = 50

Global Enum $__MSB_PAGELEFT, $__MSB_PAGERIGHT, $__MSB_PAGEUP, $__MSB_PAGEDOWN

Global $__MSB_aPos[2] = [0, 0], $__MSB_aPos2[2] = [0, 0]

Global $__MSB_aBtn[6]
Global Enum $__MSB_BTNH_LEFT, $__MSB_BTNH_PAGE, $__MSB_BTNH_RIGHT, $__MSB_BTNV_UP, $__MSB_BTNV_PAGE, $__MSB_BTNV_DOWN

Global $__MSB_aSize[4]
Global Enum $__SIZE_WIDTH, $__SIZE_HEIGHT, $__SIZE_EXWIDTH, $__SIZE_EXHEIGHT

Global $__MSB_iScrollStep = 20

Global Const $__MSB_LONGCLK = 300

;Global $__MSB_iPrevF = 0

Opt("GUIOnEventMode", 1)
OnAutoItExitRegister("__MyScrollBars_OnAutoItExit")

Global $__MSB_hBtnProc = DllCallbackRegister("__MyScrollBars_BtnProc", "lresult", "hwnd;uint;wparam;lparam;uint_ptr;dword_ptr")
Global $__MSB_pBtnProc = DllCallbackGetPtr($__MSB_hBtnProc)

Local $hGUI = GUICreate("MyGUI")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

#Region Horz scrollbar
;left arrow
$__MSB_aBtn[$__MSB_BTNH_LEFT] = GUICtrlCreateButton(ChrW(706), 0, 378, $__BTNARROW_SIZE, $__BTNARROW_SIZE)
_WinAPI_SetWindowSubclass(GUICtrlGetHandle($__MSB_aBtn[$__MSB_BTNH_LEFT]), $__MSB_pBtnProc, $__MSB_aBtn[$__MSB_BTNH_LEFT], 0)

;background
GUICtrlCreateLabel("", 22, 379, 400 - $__BTNARROW_SIZE * 2, 20)
GUICtrlSetBkColor(-1, 0xD2D2D2)
GUICtrlSetState(-1, $GUI_DISABLE)

;PAGE button
$__MSB_aBtn[$__MSB_BTNH_PAGE] = GUICtrlCreateButton(ChrW(8801), 22, 378, $__BTNPAGE_SIZE, $__BTNARROW_SIZE)
_WinAPI_SetWindowSubclass(GUICtrlGetHandle($__MSB_aBtn[$__MSB_BTNH_PAGE]), $__MSB_pBtnProc, $__MSB_aBtn[$__MSB_BTNH_PAGE], 0)

;right arrow
$__MSB_aBtn[$__MSB_BTNH_RIGHT] = GUICtrlCreateButton(ChrW(707), 400 - $__BTNARROW_SIZE * 2, 378, $__BTNARROW_SIZE, $__BTNARROW_SIZE)
_WinAPI_SetWindowSubclass(GUICtrlGetHandle($__MSB_aBtn[$__MSB_BTNH_RIGHT]), $__MSB_pBtnProc, $__MSB_aBtn[$__MSB_BTNH_RIGHT], 0)
#EndRegion Horz scrollbar

#Region Vert scrollbar
;up arrow
$__MSB_aBtn[$__MSB_BTNV_UP] = GUICtrlCreateButton(ChrW(708), 378, 0, $__BTNARROW_SIZE, $__BTNARROW_SIZE)
_WinAPI_SetWindowSubclass(GUICtrlGetHandle($__MSB_aBtn[$__MSB_BTNV_UP]), $__MSB_pBtnProc, $__MSB_aBtn[$__MSB_BTNV_UP], 0)

;background
GUICtrlCreateLabel("", 400 - $__BTNARROW_SIZE, $__BTNARROW_SIZE, $__BTNARROW_SIZE, 400 - $__BTNARROW_SIZE * 2)
GUICtrlSetBkColor(-1, 0xD2D2D2)
GUICtrlSetState(-1, $GUI_DISABLE)

;PAGE button
$__MSB_aBtn[$__MSB_BTNV_PAGE] = GUICtrlCreateButton(ChrW(8801), 378, $__BTNARROW_SIZE, $__BTNARROW_SIZE, $__BTNPAGE_SIZE)
_WinAPI_SetWindowSubclass(GUICtrlGetHandle($__MSB_aBtn[$__MSB_BTNV_PAGE]), $__MSB_pBtnProc, $__MSB_aBtn[$__MSB_BTNV_PAGE], 0)

;down arrow
$__MSB_aBtn[$__MSB_BTNV_DOWN] = GUICtrlCreateButton(ChrW(709), 400 - $__BTNARROW_SIZE, 400 - $__BTNARROW_SIZE * 2, $__BTNARROW_SIZE, $__BTNARROW_SIZE)
_WinAPI_SetWindowSubclass(GUICtrlGetHandle($__MSB_aBtn[$__MSB_BTNV_DOWN]), $__MSB_pBtnProc, $__MSB_aBtn[$__MSB_BTNV_DOWN], 0)
#EndRegion Vert scrollbar

$__MSB_aSize[$__SIZE_WIDTH] = 400
$__MSB_aSize[$__SIZE_HEIGHT] = 400
$__MSB_aSize[$__SIZE_EXWIDTH] = 800
$__MSB_aSize[$__SIZE_EXHEIGHT] = 800

Global $hGUIChild = GUICreate("", $__MSB_aSize[$__SIZE_WIDTH] - $__BTNARROW_SIZE, $__MSB_aSize[$__SIZE_HEIGHT] - $__BTNARROW_SIZE, 0, 0, $WS_CHILD, -1, $hGUI)
GUISetBkColor(0xFF0000)

GUICtrlCreateButton("toto", 50, 50, 80, 23)
GUICtrlSetState(-1, $GUI_FOCUS)

GUICtrlCreateLabel("toto0", 0, 0, 60, 400)
GUICtrlSetBkColor(-1, 0x00FF00)

GUICtrlCreateLabel("toto400", 400, 0, 60, 400)
GUICtrlSetBkColor(-1, 0x00FF00)

GUICtrlCreateLabel("toto740", 700, 0, 60, 400)
GUICtrlSetBkColor(-1, 0x00FF00)

GUICtrlCreateLabel("toto800", 800, 0, 60, 400)
GUICtrlSetBkColor(-1, 0x00FF00)

GUICtrlCreateLabel("c", 760, 760, 40, 40)
GUICtrlSetBkColor(-1, 0x0000FF)

GUISetState(@SW_SHOWNOACTIVATE, $hGUIChild)

GUISetState(@SW_SHOW, $hGUI)

While 1
	Sleep(100)
WEnd

Func _Exit()
;~ 	GUIDelete($hGUI)
	Exit
EndFunc   ;==>_Exit

#Region UDF
Func _MyScrollBars_Move($iDirection)
	;debug--------------------------
	Switch $iDirection
		Case $__MSB_PAGELEFT
			ConsoleWrite("left:")
		Case $__MSB_PAGERIGHT
			ConsoleWrite("right:")
		Case $__MSB_PAGEUP
			ConsoleWrite("up:")
		Case $__MSB_PAGEDOWN
			ConsoleWrite("down:")
	EndSwitch
	;-------------------------------

	Local $iBar = (($iDirection = $__MSB_PAGELEFT Or $iDirection = $__MSB_PAGERIGHT) ? $SB_HORZ : $SB_VERT)
	Local $fForward = (($iDirection = $__MSB_PAGELEFT Or $iDirection = $__MSB_PAGEUP) ? False : True)

	$__MSB_aPos[$iBar] += ($fForward ? $__MSB_iScrollStep : -$__MSB_iScrollStep)
ConsoleWrite($__MSB_aPos[$iBar] & @LF)

	If Not $fForward And $__MSB_aPos[$iBar] < 0 Then
		$__MSB_aPos[$iBar] = 0
	ElseIf $fForward And $__MSB_aPos[$iBar] > ($__MSB_aSize[(($iBar = $SB_HORZ) ? $__SIZE_EXWIDTH : $__SIZE_EXHEIGHT)] - $__MSB_aSize[(($iBar = $SB_HORZ) ? $__SIZE_WIDTH : $__SIZE_HEIGHT)]) + $__BTNARROW_SIZE Then ;+ $__BTNARROW_SIZE pour la barre horz
		$__MSB_aPos[$iBar] = $__MSB_aSize[(($iBar = $SB_HORZ) ? $__SIZE_WIDTH : $__SIZE_HEIGHT)] + $__MSB_iScrollStep ;$__MSB_iScrollStep pour la barre horz
	Else
		_GUIScrollBars_ScrollWindow($hGUIChild, (($iBar = $SB_HORZ) ? ($fForward ? -$__MSB_iScrollStep : $__MSB_iScrollStep) : 0), (($iBar = $SB_VERT) ? ($fForward ? -$__MSB_iScrollStep : $__MSB_iScrollStep) : 0))

		Local $barlength = $__MSB_aSize[$__SIZE_HEIGHT] - $__BTNARROW_SIZE * 3 + 2 ;*3 au lieu de *2 car coin en bas à droite, +2 pour l'écart lorsque la barre atteint le max
		Local $adefiler = $__MSB_aSize[$__SIZE_EXHEIGHT] - $__MSB_aSize[$__SIZE_HEIGHT] + $__BTNARROW_SIZE ;+ $__BTNARROW_SIZE car barre verticale
		Local $ratio = $adefiler / ($barlength - $__BTNPAGE_SIZE)

		If $iBar = $SB_HORZ Then
			GUICtrlSetPos($__MSB_aBtn[$__MSB_BTNH_PAGE], $__BTNARROW_SIZE + $__MSB_aPos[$iBar] / $ratio)
		Else
			GUICtrlSetPos($__MSB_aBtn[$__MSB_BTNV_PAGE], Default, $__BTNARROW_SIZE + $__MSB_aPos[$iBar] / $ratio)
		EndIf
	EndIf
EndFunc   ;==>_MyScrollBars_Move

Func _MyScrollBars_PageMove($iBar, $iPos)
	If $iPos = $__MSB_aPos2[$iBar] Then Return 0

	If $__MSB_aPos2[$iBar] = 0 Then
		$__MSB_aPos2[$iBar] = $iPos
		Return 0
	EndIf

	Local $barlength = $__MSB_aSize[$__SIZE_HEIGHT] - $__BTNARROW_SIZE * 3 + 2 ;*3 au lieu de *2 car coin en bas à droite, +2 pour l'écart lorsque la barre atteint le max
	Local $adefiler = $__MSB_aSize[$__SIZE_EXHEIGHT] - $__MSB_aSize[$__SIZE_HEIGHT] + $__BTNARROW_SIZE ;+ $__BTNARROW_SIZE car barre verticale
	Local $ratio = $adefiler / ($barlength - $__BTNPAGE_SIZE)

	$__MSB_aPos[$iBar] += $iPos - $__MSB_aPos2[$iBar]

	Local $fForward = ($iPos - $__MSB_aPos2[$iBar]) > 0
	Local $iScrollStep = -($iPos - $__MSB_aPos2[$iBar]) * $ratio
;ConsoleWrite($__MSB_aPos[$iBar] & ">" & $__MSB_aSize[$__SIZE_EXWIDTH] & @crlf)
	If Not $fForward And $__MSB_aPos[$iBar] < 0 Then
		$__MSB_aPos[$iBar] = 0
	ElseIf $fForward And $__MSB_aPos[$iBar] > ($__MSB_aSize[(($iBar = $SB_HORZ) ? $__SIZE_EXWIDTH : $__SIZE_EXHEIGHT)] - $__MSB_aSize[(($iBar = $SB_HORZ) ? $__SIZE_WIDTH : $__SIZE_HEIGHT)]) + $__BTNARROW_SIZE Then ;+ $__BTNARROW_SIZE pour la barre horz
		$__MSB_aPos[$iBar] = $__MSB_aSize[(($iBar = $SB_HORZ) ? $__SIZE_WIDTH : $__SIZE_HEIGHT)] + $__MSB_iScrollStep ;$__MSB_iScrollStep pour la barre horz
		;ConsoleWrite("toto" & @crlf)
	Else
		_GUIScrollBars_ScrollWindow($hGUIChild, (($iBar = $SB_HORZ) ? $iScrollStep : 0), (($iBar = $SB_VERT) ? $iScrollStep : 0))
	EndIf

	;check borders

	$__MSB_aPos2[$iBar] += $iScrollStep

	If $iBar = $SB_HORZ Then
		GUICtrlSetPos($__MSB_aBtn[$__MSB_BTNH_PAGE], $__BTNARROW_SIZE + $__MSB_aPos[$iBar] / $ratio)
	Else
		GUICtrlSetPos($__MSB_aBtn[$__MSB_BTNV_PAGE], Default, $__BTNARROW_SIZE + $__MSB_aPos[$iBar] / $ratio)
	EndIf
EndFunc

Func __MyScrollBars_BtnProc($hWnd, $iMsg, $wParam, $lParam, $ID, $pData)
	#forceref $pData, $ID

	Local $iRes = 0
#cs
;~ ConsoleWrite("btnproc:" & $uMsg & "," & @MSEC &@lf)
	Switch $iMsg
		Case $WM_LBUTTONDOWN, $WM_LBUTTONDBLCLK
			;Local $hPrevF = _WinAPI_GetFocus()

;~ 			$iRes = _WinAPI_DefSubclassProc($hWnd, $iMsg, $wParam, $lParam)

			Local $iDirection = -1, $iBar = -1

			Switch $ID
				Case $__MSB_aBtn[$__MSB_BTNH_LEFT]
					$iDirection = $__MSB_PAGELEFT
				Case $__MSB_aBtn[$__MSB_BTNH_PAGE]
					$iBar = $SB_HORZ
				Case $__MSB_aBtn[$__MSB_BTNH_RIGHT]
					$iDirection = $__MSB_PAGERIGHT
				Case $__MSB_aBtn[$__MSB_BTNV_UP]
					$iDirection = $__MSB_PAGEUP
				Case $__MSB_aBtn[$__MSB_BTNV_PAGE]
					$iBar = $SB_VERT
				Case $__MSB_aBtn[$__MSB_BTNV_DOWN]
					$iDirection = $__MSB_PAGEDOWN
			EndSwitch

ConsoleWrite("begin" & @LF)
			If $iBar <> -1 Then
				Local $tPoint = DllStructCreate("int X;int Y")

				Local $hPage = GUICtrlGetHandle($__MSB_aBtn[(($iBar = $SB_HORZ) ? $__MSB_BTNH_PAGE : $__MSB_BTNV_PAGE)])

				Local $iPrevMcm = Opt("MouseCoordMode", 1)
				Local $aMPos = 0

				While _IsPressed(0x01) ;LCLICK
					Sleep(10)

					$aMPos = MouseGetPos()

					DllStructSetData($tPoint, "X", $aMPos[0])
					DllStructSetData($tPoint, "Y", $aMPos[1])

					If _WinAPI_WindowFromPoint($tPoint) <> $hPage Then ExitLoop

					_MyScrollBars_PageMove($iBar, $aMPos[0])
				WEnd

				Opt("MouseCoordMode", $iPrevMcm)

				Dim $__MSB_aPos2[2]
			Else
				Local $hTimer = TimerInit()
				Local $fLooped = False
				Do
					If $fLooped And TimerDiff($hTimer) < $__MSB_LONGCLK Then
						Sleep(10)
						ContinueLoop
					EndIf

					_MyScrollBars_Move($iDirection)
					$fLooped = True

					Sleep(100)
				Until (_IsPressed(0x01) = 0) ;LCLICK
			EndIf

			;_WinAPI_SetFocus($hPrevF)
ConsoleWrite("end" & @LF)
		Case $WM_LBUTTONUP

			;
	EndSwitch
#ce
	Return ($iRes = 0 ? _WinAPI_DefSubclassProc($hWnd, $iMsg, $wParam, $lParam) : $iRes)
EndFunc   ;==>__MyScrollBars_BtnProc

Func __MyScrollBars_OnAutoItExit()
	For $i = 0 To UBound($__MSB_aBtn) -1
		_WinAPI_RemoveWindowSubclass(GUICtrlGetHandle($__MSB_aBtn[$i]), $__MSB_pBtnProc, $__MSB_aBtn[$i])
	Next
    DllCallbackFree($__MSB_hBtnProc)
EndFunc   ;==>__MyScrollBars_OnAutoItExit
#EndRegion UDF
