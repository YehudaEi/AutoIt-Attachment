#include <GUIConstants.au3>
#include <IE.au3>
_IEErrorHandlerRegister()
$2speed = 0
$oIE = _IECreateEmbedded()
GUICreate("Myspace Comment Spammer", 440, 400, _
		(@DesktopWidth - 640) / 2, (@DesktopHeight - 580) / 2, _
		$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$GUIActiveX = GUICtrlCreateObj($oIE, 0, 0, 440, 360)
$GUI_Button_Back = GUICtrlCreateButton("Back", 10, 360, 100, 30)
$GUI_Button_Forward = GUICtrlCreateButton("Forward", 120, 360, 100, 30)
$GUI_Button_Home = GUICtrlCreateButton("About", 230, 360, 100, 30)
$GUI_Button_Stop = GUICtrlCreateButton("Spam", 340, 360, 100, 30)
$filemenu = GUICtrlCreateMenu("Options")
$fileitem1 = GUICtrlCreateMenuitem("Turbo", $filemenu)
GUISetState()       ;Show GUI

_IENavigate($oIE, "                      ")
WinSetTrans("Myspace Comment Spammer", "", 200)
TrayTip("MySpace Auto Spammer", "Coded By Kyle Moy" & @CRLF & "Status: Bug Free" & @CRLF & "Time: 43 min" & @CRLF & "Lines of Code:52", 10, 1)
; Waiting for user to close the window
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $fileitem1
			If $2speed = 1 Then
				$2speed = 0
				GUICtrlSetState($fileitem1, $GUI_UNCHECKED)
			Else
				$2speed = 1
				GUICtrlSetState($fileitem1, $GUI_CHECKED)
			EndIf
			MsgBox(0, "Warning", "Warning: if your computer is slow, not ALL comments may be sent, turbo is for use with faster internet connections, but will not cause harm")
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $GUI_Button_Home
			_IENavigate($oIE, "                                   ")
		Case $msg = $GUI_Button_Back
			_IEAction($oIE, "back")
		Case $msg = $GUI_Button_Forward
			_IEAction($oIE, "forward")
		Case $msg = $GUI_Button_Stop
			$oForm = _IEFormGetObjByName($oIE, "aspnetForm")
			$oText = _IEFormElementGetObjByName($oForm, "ctl00$Main$postComment$ConfirmPostButton")
			_IEFormElementSetValue($oText, "!! CONTROLLED !!")
			$time = InputBox("Repeat!", "Send How Many Comments?")
			$res = 0
			$timer = TimerInit()
			If $2speed = 0 Then
				Do
					TrayTip("Status", "Comments sent: " & $res & " of:" & $time & @CRLF & "Time Elapsed: " & Round(TimerDiff($timer) / 1000, 0) & " Secs.", 1, 1)
					_IEAction($oText, "click")
					Sleep(150)
					$res = $res + 1
				Until $res = $time
			Else
				Do
					TrayTip("Status", "Comments sent: " & $res & " of:" & $time & @CRLF & "Time Elapsed: " & Round(TimerDiff($timer) / 1000, 0) & " Secs.", 1, 1)
					_IEAction($oText, "click")
					Sleep(20)
					$res = $res + 1
					TrayTip("Status", "Comments sent: " & $res & " of:" & $time & @CRLF & "Time Elapsed: " & Round(TimerDiff($timer) / 1000, 0) & " Secs.", 1, 1)
					_IEAction($oText, "click")
					Sleep(150)
					$res = $res + 1
				Until $res > $time
			EndIf
			MsgBox(0, "Thanks", "Thanks for using one of my programs, now you can visit my lovely myspace! =D" & @CRLF & "Comments sent: " & $res & @CRLF & "Time Elapsed: " & Round(TimerDiff($timer) / 1000, 0) & " Secs.")
			_IECreate("                                   ")
	EndSelect
WEnd

GUIDelete()

Exit