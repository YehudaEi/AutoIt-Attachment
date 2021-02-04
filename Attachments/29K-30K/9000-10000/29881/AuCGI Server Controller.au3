#include <Constants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
TraySetIcon(@ScriptDir & "\LightTPD.exe")
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1) ; Default tray menu items (Script Paused/Exit) will not be shown.
TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "gRestore")

$Form1 = GUICreate("auCGI Server Controller 1.01", 608, 426, 197, 121)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
$gEdit = GUICtrlCreateEdit("", 0, 64, 625, 377, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL))
GUICtrlSetData($gEdit, "Nothing Yet ....")
$gStart = GUICtrlCreateButton("Start", 8, 8, 113, 49)
GUICtrlSetOnEvent($gStart, "gStartClick")
$gEnd = GUICtrlCreateButton("End", 128, 8, 113, 49)
GUICtrlSetOnEvent($gEnd, "gEndClick")
$gRefresh = GUICtrlCreateButton("Refresh", 400, 8, 113, 49)
GUICtrlSetOnEvent($gRefresh, "gRefreshClick")
$gStatus = GUICtrlCreateLabel("Status: Disabled", 520, 40, 81, 17)
GUICtrlSetColor($gStatus, 0xFF0000)
GUISetState(@SW_SHOW)


Global $PID = 0
;~ Global $hAdlib

While 1
	Sleep(100)
WEnd

Func Form1Close()
	gEndClick()
	Exit
EndFunc   ;==>Form1Close
Func Form1Minimize()
	GUISetState(@SW_HIDE)

EndFunc   ;==>Form1Minimize
Func gRestore()
	GUISetState(@SW_SHOW)

EndFunc   ;==>gRestore
Func gEndClick()
	AdlibUnRegister("CheckStdOut")
	If $PID = 0 Then
		GUICtrlSetData($gEdit, GUICtrlRead($gEdit) & @CRLF & " Error: Server is not running... ")
	Else
		ProcessClose($PID)
		$PID = 0
		GUICtrlSetData($gEdit, GUICtrlRead($gEdit) & @CRLF & " ===================== SERVER STOPPED ===================== ")
		GUICtrlSetData($gStatus, "Status: Disabled")
		GUICtrlSetColor($gStatus, 0xFF0000)
	EndIf

	;AdlibUnRegister("CheckStdOut")
EndFunc   ;==>gEndClick

Func gRefreshClick()

EndFunc   ;==>gRefreshClick

Func gStartClick()
	$PID = Run("C:\LightTPD\lighttpd.exe -f conf\lighttpd-inc.conf -m lib -D", "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	AdlibRegister("CheckStdOut")
	GUICtrlSetData($gEdit, GUICtrlRead($gEdit) & @CRLF & " ===================== SERVER STARTED ===================== ")
	GUICtrlSetData($gStatus, "Status: Enabled")
	GUICtrlSetColor($gStatus, 0x00FF00)
EndFunc   ;==>gStartClick

Func CheckStdOut()
	Local $line1, $line2, $err = 0
	$line1 = StdoutRead($PID)
	If @error Then $err = $err + 1
	$line2 = StderrRead($PID)
	If @error Then $err = $err + 1
	If $err = 2 Then TerminateLib()


	If $line1 <> '' Then
		$line1 = StringReplace($line1, @CR, @CRLF)
		$line1 = StringReplace($line1, @LF, @CRLF)
		GUICtrlSetData($gEdit, GUICtrlRead($gEdit) & @CRLF & $line1)
	EndIf
	If $line2 <> '' Then
		$line2 = StringReplace($line2, @CR, @CRLF)
		$line2 = StringReplace($line2, @LF, @CRLF)
		GUICtrlSetData($gEdit, GUICtrlRead($gEdit) & @CRLF & $line2)
	EndIf


EndFunc   ;==>CheckStdOut
Func TerminateLib()
	MsgBox(0, "", "bye")
	GUICtrlSetData($gEdit, GUICtrlRead($gEdit) & @CRLF & " ===================== SERVER STOPPED ===================== ")
	GUICtrlSetData($gStatus, "Status: Disabled")
	GUICtrlSetColor($gStatus, 0xFF0000)
	AdlibUnRegister("CheckStdOut")
EndFunc   ;==>TerminateLib