#include <ButtonConstants.au3>
#include <IE.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>

; #INDEX# =======================================================================================================================
; Title .........: Full-Screen IE-based Kiosk Web Browser w/ Virtual Keyboard
; AutoIt Version : 3.3.6
; Language ......: English
; Description ...: Kiosk software for touchscreens
; Author(s) .....: CanHasDIY, special thanks to Orion @ autoitscripts.com for the keyboard stuff!
; ===============================================================================================================================

;;;;;;;;;;;;;;;;;;;;;;;;;;Create Browser Window;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$GUI = GUICreate("TITLE OF WINDOW", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP)
_IECreateEmbedded( )
$object = ObjCreate("Shell.Explorer.2")
$object_ctrl = GUICtrlCreateObj($object, 1, 1, 1279, 670)
$Pic1 = GUICtrlCreatePic("board.bmp", 640, 670, 640, 355)
$Pic2 = GUICtrlCreatePic("board2.bmp", 0, 670, 640, 355)

_IENavigate($object, "http://www.example.com")
GUISetState()

;;;;;;;;;;;;;;;;;;;;;;;;;; Create Virtual Keyboard;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			$WS_EX_NOACTIVATE = 0x08000000
			$MA_NOACTIVATE = 3
			$MA_NOACTIVATEANDEAT = 4

			HotKeySet("{ESC}", "On_Exit")

			$hGUI = GUICreate("keyboard", 840, 350, 210, 673, $WS_POPUPWINDOW, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST, $WS_EX_NOACTIVATE))
			$dummy1 = GUICtrlCreateDummy()

			$1 = GUICtrlCreateButton("1", 0, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\1.bmp")
			$2 = GUICtrlCreateButton("2", 70, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\2.bmp")
			$3 = GUICtrlCreateButton("3", 140, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\3.bmp")
			$4 = GUICtrlCreateButton("4", 210, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\4.bmp")
			$5 = GUICtrlCreateButton("5", 280, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\5.bmp")
			$6 = GUICtrlCreateButton("6", 350, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\6.bmp")
			$7 = GUICtrlCreateButton("7", 420, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\7.bmp")
			$8 = GUICtrlCreateButton("8", 490, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\8.bmp")
			$9 = GUICtrlCreateButton("9", 560, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\9.bmp")
			$0 = GUICtrlCreateButton("0", 630, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\0.bmp")
			$Minus = GUICtrlCreateButton("-", 700, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\-.bmp")
			$Equal = GUICtrlCreateButton("=", 770, 0, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\=.bmp")
			$q = GUICtrlCreateButton("q", 0, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\Q.bmp")
			$w = GUICtrlCreateButton("w", 70, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\W.bmp")
			$e = GUICtrlCreateButton("e", 140, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\E.bmp")
			$r = GUICtrlCreateButton("r", 210, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\R.bmp")
			$t = GUICtrlCreateButton("t", 280, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\T.bmp")
			$y = GUICtrlCreateButton("y", 350, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\Y.bmp")
			$u = GUICtrlCreateButton("u", 420, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\U.bmp")
			$i = GUICtrlCreateButton("i", 490, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\I.bmp")
			$o = GUICtrlCreateButton("o", 560, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\O.bmp")
			$p = GUICtrlCreateButton("p", 630, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\P.bmp")
			$LeftBrackets = GUICtrlCreateButton("[", 700, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\[.bmp")
			$RightBrackets = GUICtrlCreateButton("]", 770, 70, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\].bmp")
			$a = GUICtrlCreateButton("a", 0, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\A.bmp")
			$s = GUICtrlCreateButton("s", 70, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\S.bmp")
			$d = GUICtrlCreateButton("d", 140, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\D.bmp")
			$f = GUICtrlCreateButton("f", 210, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\F.bmp")
			$g = GUICtrlCreateButton("g", 280, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\G.bmp")
			$h = GUICtrlCreateButton("h", 350, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\H.bmp")
			$j = GUICtrlCreateButton("j", 420, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\J.bmp")
			$k = GUICtrlCreateButton("k", 490, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\K.bmp")
			$l = GUICtrlCreateButton("l", 560, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\L.bmp")
			$Colon = GUICtrlCreateButton(";", 630, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\;.bmp")
			$Apostrophe = GUICtrlCreateButton("'", 700, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\'.bmp")
			$LeftSlash = GUICtrlCreateButton("\", 770, 140, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\LeftSlash.bmp")
			$z = GUICtrlCreateButton("z", 0, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\Z.bmp")
			$x = GUICtrlCreateButton("x", 70, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\X.bmp")
			$c = GUICtrlCreateButton("c", 140, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\C.bmp")
			$v = GUICtrlCreateButton("v", 210, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\V.bmp")
			$b = GUICtrlCreateButton("b", 280, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\B.bmp")
			$n = GUICtrlCreateButton("n", 350, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\N.bmp")
			$m = GUICtrlCreateButton("m", 420, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\M.bmp")
			$Comma = GUICtrlCreateButton(",", 490, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\,.bmp")
			$Dot = GUICtrlCreateButton(".", 560, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\..bmp")
			$bslash = GUICtrlCreateButton("/", 630, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\bslash.bmp")
			$back = GUICtrlCreateButton("back", 700, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\back.bmp")
			$enter = GUICtrlCreateButton("enter", 770, 210, 70, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\enter.bmp")
			$LeftShift = GUICtrlCreateButton("Shift", 0, 280, 140, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\Shift.bmp")
			$RightShift = GUICtrlCreateButton("Shift", 700, 280, 140, 70, $BS_BITMAP)
			GUICtrlSetImage(-1, "keys\Shift.bmp")
			GUICtrlCreateButton("space", 140, 280, 560, 70, $BS_BITMAP)
			$Space = GUICtrlSetImage(-1, "keys\space.bmp")


			$dummy2 = GUICtrlCreateDummy()
			GUISetState()

			GUIRegisterMsg($WM_MOUSEACTIVATE, 'WM_EVENTS')



			While 1
				$msg = GUIGetMsg()
				Switch $msg
					Case $GUI_EVENT_CLOSE
						Exit
					Case $dummy1 To $dummy2
						Local $sText = ControlGetText($hGUI, "", $msg)
						; Write key
						If $sText = "space" Then
							Send("{SPACE}")
						ElseIf $sText = "bslash" Then
							Send("/")
						ElseIf $sText = "back" Then
							Send("{Backspace}")
						ElseIf $sText = "enter" Then
							Send("{ENTER}")
						ElseIf $sText = "Shift" Then
							Send("{SHIFTDOWN}")
							GUICtrlDelete($LeftShift)
							GUICtrlDelete($RightShift)
							GUICtrlDelete($4)
							GUICtrlDelete($1)
							GUICtrlDelete($2)
							GUICtrlDelete($3)
							GUICtrlDelete($5)
							GUICtrlDelete($6)
							GUICtrlDelete($7)
							GUICtrlDelete($8)
							GUICtrlDelete($9)
							GUICtrlDelete($0)
							GUICtrlDelete($Minus)
							GUICtrlDelete($Equal)
							GUICtrlDelete($LeftBrackets)
							GUICtrlDelete($RightBrackets)
							GUICtrlDelete($LeftSlash)
							GUICtrlDelete($Apostrophe)
							GUICtrlDelete($Colon)
							GUICtrlDelete($Comma)
							GUICtrlDelete($Dot)
							GUICtrlDelete($bslash)
							$4 = GUICtrlCreateButton("4", 210, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\$.bmp")
							$1 = GUICtrlCreateButton("1", 0, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\!.bmp")
							$2 = GUICtrlCreateButton("2", 70, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\@.bmp")
							$3 = GUICtrlCreateButton("3", 140, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\#.bmp")
							$5 = GUICtrlCreateButton("5", 280, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\%.bmp")
							$6 = GUICtrlCreateButton("6", 350, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\^.bmp")
							$7 = GUICtrlCreateButton("7", 420, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\&.bmp")
							$8 = GUICtrlCreateButton("8", 490, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\star.bmp")
							$9 = GUICtrlCreateButton("9", 560, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\(.bmp")
							$0 = GUICtrlCreateButton("0", 630, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\).bmp")
							$Minus = GUICtrlCreateButton("-", 700, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\_.bmp")
							$Equal = GUICtrlCreateButton("=", 770, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\+.bmp")
							$LeftBrackets = GUICtrlCreateButton("[", 700, 70, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\{.bmp")
							$RightBrackets = GUICtrlCreateButton("]", 770, 70, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\}.bmp")
							$LeftSlash = GUICtrlCreateButton("\", 770, 140, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\slash2.bmp")
							$Apostrophe = GUICtrlCreateButton("'", 700, 140, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\par.bmp")
							$Colon = GUICtrlCreateButton(";", 630, 140, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\colon2.bmp")
							$Comma = GUICtrlCreateButton(",", 490, 210, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\,2.bmp")
							$Dot = GUICtrlCreateButton(".", 560, 210, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\.2.bmp")
							$bslash = GUICtrlCreateButton("/", 630, 210, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\question.bmp")
							$LeftShiftd = GUICtrlCreateButton("Shiftd", 0, 280, 140, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\Shiftd.bmp")
							$RightShiftd = GUICtrlCreateButton("Shiftd", 700, 280, 140, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\Shiftd.bmp")
						ElseIf $sText = "Shiftd" Then
							Send("{SHIFTUP}")
							GUICtrlDelete($LeftShiftd)
							GUICtrlDelete($RightShiftd)
							GUICtrlDelete($4)
							GUICtrlDelete($1)
							GUICtrlDelete($2)
							GUICtrlDelete($3)
							GUICtrlDelete($5)
							GUICtrlDelete($6)
							GUICtrlDelete($7)
							GUICtrlDelete($8)
							GUICtrlDelete($9)
							GUICtrlDelete($0)
							GUICtrlDelete($Minus)
							GUICtrlDelete($Equal)
							GUICtrlDelete($LeftBrackets)
							GUICtrlDelete($RightBrackets)
							GUICtrlDelete($LeftSlash)
							GUICtrlDelete($Apostrophe)
							GUICtrlDelete($Colon)
							GUICtrlDelete($Comma)
							GUICtrlDelete($Dot)
							GUICtrlDelete($bslash)
							$4 = GUICtrlCreateButton("4", 210, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\4.bmp")
							$1 = GUICtrlCreateButton("1", 0, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\1.bmp")
							$2 = GUICtrlCreateButton("2", 70, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\2.bmp")
							$3 = GUICtrlCreateButton("3", 140, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\3.bmp")
							$5 = GUICtrlCreateButton("5", 280, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\5.bmp")
							$6 = GUICtrlCreateButton("6", 350, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\6.bmp")
							$7 = GUICtrlCreateButton("7", 420, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\7.bmp")
							$8 = GUICtrlCreateButton("8", 490, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\8.bmp")
							$9 = GUICtrlCreateButton("9", 560, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\9.bmp")
							$0 = GUICtrlCreateButton("0", 630, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\0.bmp")
							$Minus = GUICtrlCreateButton("-", 700, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\-.bmp")
							$Equal = GUICtrlCreateButton("=", 770, 0, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\=.bmp")
							$LeftBrackets = GUICtrlCreateButton("[", 700, 70, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\[.bmp")
							$RightBrackets = GUICtrlCreateButton("]", 770, 70, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\].bmp")
							$LeftSlash = GUICtrlCreateButton("\", 770, 140, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\LeftSlash.bmp")
							$Apostrophe = GUICtrlCreateButton("'", 700, 140, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\'.bmp")
							$Colon = GUICtrlCreateButton(";", 630, 140, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\;.bmp")
							$Comma = GUICtrlCreateButton(",", 490, 210, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\,.bmp")
							$Dot = GUICtrlCreateButton(".", 560, 210, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\..bmp")
							$bslash = GUICtrlCreateButton("/", 630, 210, 70, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\bslash.bmp")
							$LeftShift = GUICtrlCreateButton("Shift", 0, 280, 140, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\Shift.bmp")
							$RightShift = GUICtrlCreateButton("Shift", 700, 280, 140, 70, $BS_BITMAP)
							GUICtrlSetImage(-1, "keys\Shift.bmp")

						Else
							Send($sText)
						EndIf

				EndSwitch
			WEnd

			Func WM_EVENTS($hWndGUI, $MsgID, $WParam, $LParam)
				Switch $hWndGUI
					Case $hGUI
						Switch $MsgID
							Case $WM_MOUSEACTIVATE
								; Check mouse position
								Local $aMouse_Pos = GUIGetCursorInfo($hGUI)
								If $aMouse_Pos[4] <> 0 Then
									Local $word = _WinAPI_MakeLong($aMouse_Pos[4], $BN_CLICKED)
									_SendMessage($hGUI, $WM_COMMAND, $word, GUICtrlGetHandle($aMouse_Pos[4]))
									SoundPlay("Type.wav")
								EndIf
								Return $MA_NOACTIVATEANDEAT
						EndSwitch
				EndSwitch
				Return $GUI_RUNDEFMSG
			EndFunc   ;==>WM_EVENTS

			Func On_Exit()
				Exit
			EndFunc   ;==>On_Exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;End Keyboard Script;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
	EndSelect
WEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;End Browser Script;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
