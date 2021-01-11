#region INFORMATIONS
;================ I N F O R M A T I O N S ======================
;Optimized for AutoIt versions: all AutoIt betas from v3.1.1.121 and better
;Optimized for/Created on platform: Windows XP Professional SP 1
;Can be used on following platforms: Windows 95, Windows 98, Windows 98 SE, Windows Millenium Edition,
;									 Windows 2000, Windows XP and better
;Program name: Windows Stopwatch
;Program version: 2006 (1.0, relase A)
;Author: i542
;Tools used: Koda FormDesigner, Tidy, AU3Check
;Author's e-mail: ivan_ostric@hotmail.com
;******Created with AutoIt******
;================================================================
#endregion
#region Preparing script for run
#NoTrayIcon
#include <GUIConstants.au3>
Global $started = False
Global $reseted = False
Global $finish = "Ready"
Global $stamp
#endregion
#region FIRST GUI
#region GUI created with Koda
$gui = GUICreate("Stopwatch", 185, 102, 172, 125)
$start = GUICtrlCreateButton("Start", 8, 40, 81, 25)
$stop = GUICtrlCreateButton("Stop", 8, 72, 81, 25)
$exit = GUICtrlCreateButton("Exit", 96, 72, 81, 25)
$count = GUICtrlCreateLabel("Ready", 48, 16, 127, 17, BitOR($SS_RIGHT, $SS_SUNKEN))
$back = GUICtrlCreateButton("Backgrouding", 96, 40, 81, 25)
#endregion
#region GUI Tooltips
GUICtrlSetTip($start, "Starts Stopwatch from the beginning")
GUICtrlSetTip($stop, "Stops Stopwatch so you can read result")
GUICtrlSetTip($exit, "Closes program")
GUICtrlSetTip($count, "Here you can read result of counting and, sometimes, messages")
GUICtrlSetTip($back, "Shows a second, little popup and hides this window")
#endregion
#region Last steps in preparing GUI
GUICtrlSetBkColor($count, 0xFFFFFF); White, so count label now look as Calculator label, only Calculator label is bigger
GUICtrlSetColor($count, 0x048041); Green (some stupid green)
Sleep(10)
GUISetState(@SW_SHOW)
#endregion
#endregion
#region SECOND GUI
#region GUI created with Koda
$bckGui = GUICreate("Stopwatch", 99, 54, 192, 125, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
$bckCount = GUICtrlCreateLabel("Preparing...", 8, 8, 81, 17, BitOR($SS_RIGHT, $SS_SUNKEN))
$bckStop = GUICtrlCreateButton("Stop", 56, 32, 41, 17)
$bckBack = GUICtrlCreateButton("Return", 5, 32, 43, 17)
GUISetState(@SW_HIDE)
#endregion
#region GUI Tooltips
GUICtrlSetTip($bckCount, "Here is showed only result")
GUICtrlSetTip($bckStop, "Stops Stopwatch")
GUICtrlSetTip($bckBack, "Returns to 'big' GUI without stopping")
#endregion
#region Last steps in preparing GUI
GUICtrlSetBkColor($bckCount, 0xFFFFFF); White, so count label now look as Calculator label, only Calculator label is very bigger
GUICtrlSetColor($bckCount, 0xFF0000); Red
Sleep(10)
#endregion
#endregion
#region GUI Loop
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $back
			If $started = True Then
				GUISetState(@SW_HIDE, $gui)
				GUISetState(@SW_SHOW, $bckGui)
			Else
				GUICtrlSetData($count, "Error in Stopwatch")
				GUICtrlSetColor($count, 0xFF0000)
				; Shows text Error in Stopwatch colored in red...
				MsgBox(16, "Error", "Stopwatch must be started if you want activate Backgrouding mode!")
				GUICtrlSetData($count, $finish); ...and when user press OK on MsgBox result is restored...
				GUICtrlSetColor($count, 0x048041); ...as color is.
			EndIf
		Case $msg = $bckStop
			AdlibDisable()
			$started = False
			$finish = TimerDiff($stamp)
			$finish = String($finish)
			$finish = StringSplit($finish, ".")
			$finish = Number($finish[1])
			$finish = $finish / 1000
			$finish = String($finish)
			$finish = $finish & " sec"
			GUICtrlSetData($count, $finish)
			GUICtrlSetColor($count, 0x048041)
			GUICtrlSetData($bckCount, $finish)
			GUICtrlSetColor($bckCount, 0x048041)
		Case $msg = $bckBack
			GUISetState(@SW_HIDE, $bckGui)
			GUISetState(@SW_SHOW, $gui)
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $exit
			If $started = False And MsgBox(36, "Windows Stopwatch", "Really exit?") = 6 Then ExitLoop
		Case $msg = $start
			If $started = True Then
				GUICtrlSetData($count, "Error in Stopwatch")
				MsgBox(16, "Error", "You are pressed START. But, Stopwatch is runned before!")
			Else
				$stamp = TimerInit()
				Global $started = True
				GUICtrlSetColor($count, 0xFF0000); Red (it means Stopwatch is busy)
				GUICtrlSetData($count, "Preparing...")
				AdlibEnable("_Refresh")
			EndIf
		Case $msg = $stop
			If $started = False And $reseted = true Then
				GUICtrlSetData($count, "Error in Stopwatch")
				GUICtrlSetColor($count, 0xFF0000)
				; Shows text Error in Stopwatch colored in red...
				MsgBox(16, "Error", "You are pressed STOP. But, Stopwatch has been stopped (and resetted) before!")
				If $reseted = false Then
					GUICtrlSetData($count, $finish); ...and when user press OK on MsgBox result is restored...
					GUICtrlSetColor($count, 0x048041); ...as color is...
				Else ;or if count is resetted...
					GUICtrlSetData($count, "Ready"); ... Ready status is returned
					GUICtrlSetColor($count, 0x048041); ...as color is.
				EndIf
			ElseIf $reseted = False And $started = False Then
				If MsgBox(36, "Windows Stopwatch", "Really reset?") = 6 Then
					GUICtrlSetData($count, "Ready")
					$reseted = true
				EndIf
			ElseIf $started = true Then
				AdlibDisable()
				$reseted = False
				$started = 0
				$finish = TimerDiff($stamp)
				$finish = String($finish)
				$finish = StringSplit($finish, ".")
				$finish = Number($finish[1])
				$finish = $finish / 1000
				$finish = String($finish)
				$finish = $finish & " sec"
				GUICtrlSetData($count, $finish)
				GUICtrlSetColor($count, 0x048041)
			EndIf
	EndSelect
WEnd
#endregion
#region User defined functions
;This function is used only for Adlib on line 54
Func _Refresh()
	$finish = TimerDiff($stamp)
	$finish = String($finish)
	$finish = StringSplit($finish, ".")
	$finish = Number($finish[1])
	$finish = $finish / 1000
	$finish = String($finish)
	$finish = $finish & " sec"
	GUICtrlSetData($count, $finish)
	GUICtrlSetData($bckCount, $finish)
EndFunc   ;==>_Refresh
#endregion
#endregion