#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\icons\shell32_329.ico
#AutoIt3Wrapper_outfile=UptimeCalc.exe
#AutoIt3Wrapper_Res_Comment=Uptime Calculator, Watches uptime of a PC and warns user to reboot their PC after 6 days.
#AutoIt3Wrapper_Res_Description=Uptime Calculator, Watches uptime of a PC and warns user to reboot their PC after 6 days.
#AutoIt3Wrapper_Res_Fileversion=1.2.3.4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#NoTrayIcon
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <SendMessage.au3>
#include <Date.au3>
#include <Constants.au3>
#include <MsgBoxEx.au3>
#include <Misc.au3>


; Checks if it is already running and exits if so.
If _Singleton("UptimeCalc", 0) = 0 Then Exit

;Define Hotkeys
HotKeySet("^+!X", "_exit") ; Ctrl-Shift-Alt-X to exit
HotKeySet("^+!x", "_exit") ; Ctrl-Shift-Alt-x to exit



AutoItSetOption("TrayMenuMode", 9) ; Default tray menu items (Script Paused/Exit) will not be shown.\

; define trayicon menu options
$guiitem = TrayCreateItem("Show All")
$dayssitem = TrayCreateItem("Power")
$aboutitem = TrayCreateItem("About")
TrayCreateItem("")
$rebootitem = TrayCreateItem("Reboot")

TraySetState()


;Define variables
Global Const $SC_DRAGMOVE = 0xF012
Local $iHours, $iMins, $iSecs
Local $tMsg, $tItem1, $iCurrDays
Dim $iDays, $openfromtray
$iCurrSecs = 0
$iCurrMins = 0
$iCurrHrs = 0
$iCurrDays = 0
$iPostPone = IniRead(@TempDir & "\" & @ScriptName & ".INI", "General", "Postponed", "0")
$iloop = 0




;Function _exit exits the script.
Func _exit()
	Exit
EndFunc   ;==>_exit


;Define the GUI
$frmMain = GUICreate("System :: Uptime", 300, 200, @DesktopWidth / 2 - 145, @DesktopHeight / 2 - 160, BitOR($WS_POPUP, $WS_BORDER))
$lblDays = GUICtrlCreateLabel("00", 8, 8, 15, 15)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$lblSep1 = GUICtrlCreateLabel(":", 23, 8, 10, 15)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$lblHours = GUICtrlCreateLabel("00", 28, 8, 15, 15)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$lblSep2 = GUICtrlCreateLabel(":", 42, 8, 10, 15)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$lblMinutes = GUICtrlCreateLabel("00", 47, 8, 15, 15)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$lblSep3 = GUICtrlCreateLabel(":", 62, 8, 10, 15)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$lblSeconds = GUICtrlCreateLabel("00", 68, 8, 15, 15)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$about = GUICtrlCreateButton("About", 245, 10, 45, 25, $BS_FLAT)
$btnWait = GUICtrlCreateButton("Reboot later ...", 10, 130, 280, 25, $BS_FLAT)
$Reboot = GUICtrlCreateButton("Reboot Now !", 10, 165, 280, 25, $BS_FLAT)
$label4 = GUICtrlCreateLabel("Your computer has been running for more than 0 days" & @CRLF & "", 8, 45, 300, 26)
$label1 = GUICtrlCreateLabel("If your computer has been running for more than 6 days" & @CRLF & "you can postpone the reboot only 3 times.(1 hour each time)", 8, 75, 300, 26)
$label2 = GUICtrlCreateLabel("", 8, 105, 200, 12)




; Check the GUI for input
While 1

	; Move to center if moved
	WinMove("System :: Uptime", "", @DesktopWidth / 2 - 145, @DesktopHeight / 2 - 160)

	WinSetOnTop("System :: Uptime", "", 1)
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_PRIMARYDOWN
			_SendMessage($frmMain, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0)
		Case $GUI_EVENT_CLOSE
			IniWrite(@TempDir & "\" & @ScriptName & ".ini", "General", "Postponed", $iPostPone)
			For $i = 255 To 0 Step -2
				WinSetTrans("System :: Uptime", "", $i)
			Next
			GUISetState(@SW_HIDE)
			Run(@ScriptFullPath)
			Exit
		Case $Reboot
			For $i = 255 To 0 Step -2
				WinSetTrans("System :: Uptime", "", $i)
			Next

			GUISetState(@SW_HIDE)
			$ls = "The computer will reboot in <##> seconds. Click OK for an immediate reboot."
			$liRtnVal = _MsgBoxEx(1 + 48 + 1024, "Reboot", $ls, 30)
			Select
				Case $liRtnVal = 1 ;OK
					FileDelete(@TempDir & "\" & @ScriptDir & ".ini")
					Shutdown(3)
				Case $liRtnVal = -1 ;OK
					FileDelete(@TempDir & "\" & @ScriptDir & ".ini")
					Shutdown(3)
				Case $liRtnVal = 2 ;Cancel

			EndSelect

		Case $btnWait
			For $i = 255 To 0 Step -2
				WinSetTrans("System :: Uptime", "", $i)

			Next
			GUISetState(@SW_HIDE)

			If $iDays >= 6 Then
				$iPostPone = $iPostPone + 1
			Else
				$iPostPone = 0
			EndIf

			If $iPostPone <> 0 Then
				GUICtrlSetData($label2, "You have postponed the reboot " & $iPostPone & " time(s)")
				GUICtrlSetState($Reboot, BitOR($GUI_DEFBUTTON, $GUI_FOCUS))
			EndIf
			If $iPostPone >= 3 Then
				GUICtrlSetState($btnWait, $GUI_DISABLE)

			EndIf

			If $openfromtray = 1 Then
				$openfromtray = 0
			Else
				TraySetToolTip("Sleeping : Your computer has been running for " & $iDays & " days.")
				Sleep(3600000)
			EndIf

		Case $about

			;GUISetState(@SW_HIDE)
			GUISetState(@SW_DISABLE)
			WinSetOnTop("System :: Uptime", "", 0)
			If FileExists(@WindowsDir & "\Media\chord.wav") Then SoundPlay(@WindowsDir & "\Media\chord.wav")
			$ls = "This program enforces regular reboots for user PC's to ensure the latest updates en software versions are deployed." & @CRLF & @CRLF & "Contact the ICT Helpdesk Boxmeer for support." & @CRLF & @CRLF
			$liRtnVal = _MsgBoxEx(0 + 64 + 1024, "About:", $ls, 30)


			GUISetState(@SW_ENABLE)
			WinActivate("System :: Uptime")
			WinSetOnTop("System :: Uptime", "", 1)


	EndSwitch

	; Do the time calculation stuff

	$GTC = DllCall("kernel32.dll", "long", "GetTickCount")

	$TSB = $GTC[0]

	_TicksToTime($TSB, $iHours, $iMins, $iSecs)
	$iDays = Int($iHours / 24)
	$iHours = $iHours - ($iDays * 24)

	If $iSecs <> $iCurrSecs Then
		If $iDays <> $iCurrDays Then
			GUICtrlSetData($lblDays, StringFormat("%02i", $iDays))
			If $iDays >= 6 Then
				GUICtrlSetData($label4, "Your computer has been running for more than " & $iDays & " days" & @CRLF & "and requires a reboot.")
			Else
				GUICtrlSetData($label4, "Your computer has been running for more than " & $iDays & " days" & @CRLF & "")
			EndIf
			$iCurrDays = $iDays
		EndIf
		If $iCurrHrs <> $iHours Then
			GUICtrlSetData($lblHours, StringFormat("%02i", $iHours))
			$iCurrHrs = $iHours
		EndIf
		If $iCurrMins <> $iMins Then
			GUICtrlSetData($lblMinutes, StringFormat("%02i", $iMins))
			$iCurrMins = $iMins
		EndIf
		GUICtrlSetData($lblSeconds, StringFormat("%02i", $iSecs))
		$iCurrSecs = $iSecs
	EndIf


	If $iDays >= 6 Then
		WinSetTrans("System :: Uptime", "", 0)
		GUISetState(@SW_SHOW)
		For $i = 0 To 255 Step 2
			WinSetTrans("System :: Uptime", "", $i)

		Next
	EndIf


	; Check the trayicon menu for input
	$msg = TrayGetMsg()

	TrayItemSetText($dayssitem, "Your computer has been running for " & $iDays & " days.")
	TrayItemSetState($rebootitem, 4)
	TrayItemSetState($dayssitem, 4)
	TrayItemSetState($aboutitem, 4)
	TrayItemSetState($guiitem, 4)

	TraySetToolTip("Your computer has been running for " & $iDays & " days.")
	Select
		Case $msg = $rebootitem
			GUISetState(@SW_HIDE)
			If FileExists(@WindowsDir & "\Media\chord.wav") Then SoundPlay(@WindowsDir & "\Media\chord.wav")
			$ls = "The computer will reboot in <##> seconds. Click OK for an immediate reboot."
			$liRtnVal = _MsgBoxEx(1 + 48 + 1024, "Reboot", $ls, 30)
			Select
				Case $liRtnVal = 1 ;OK
					Shutdown(3)
				Case $liRtnVal = -1 ;OK
					Shutdown(3)
				Case $liRtnVal = 2 ;Cancel
			EndSelect
		Case $msg = $aboutitem
			;GUISetState(@SW_HIDE)
			GUISetState(@SW_DISABLE)
			WinSetOnTop("System :: Uptime", "", 0)
			If FileExists(@WindowsDir & "\Media\chord.wav") Then SoundPlay(@WindowsDir & "\Media\chord.wav")
			$ls = "This program enforces regular reboots for user PC's to ensure the latest updates en software versions are deployed." & @CRLF & @CRLF & "Contact the ICT Helpdesk Boxmeer for support." & @CRLF & @CRLF
			$liRtnVal = _MsgBoxEx(0 + 64 + 1024, "About:", $ls, 30)


			GUISetState(@SW_ENABLE)
			WinActivate("System :: Uptime")
			WinSetOnTop("System :: Uptime", "", 1)

		Case $msg = $dayssitem
			; do nothing
		Case $msg = $guiitem
			GUISetState(@SW_ENABLE)
			WinSetTrans("System :: Uptime", "", 0)
			GUISetState(@SW_SHOW)
			For $i = 0 To 255 Step 2
				WinSetTrans("System :: Uptime", "", $i)

			Next
			$openfromtray = 1
	EndSelect
WEnd