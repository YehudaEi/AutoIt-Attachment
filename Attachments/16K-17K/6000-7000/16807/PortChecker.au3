; Check if port open and try and open it
; 
; Based on technique found at                                                                               

; OPTIONS
#RequireAdmin				; Must run as administrator

Opt("RunErrorsFatal", 1)	; 1=fatal, 0=silent set @error

; CONSTANTS
Const $PORT			= 1024	; Port we're interested in
Const $PORT_OPEN	= 1
Const $PORT_NOTOPEN	= 3

; MsgBox Constants
Const $INFO_ICON	= 64	; Info icon in MsgBox
Const $QUEST_ICON	= 32	; Question icon in MsgBox
Const $OPT_YESNO	= 4		; Give Yes and No buttons in MsgBox
Const $NO			= 7		; Value returned by MsgBox
Const $YES			= 6		; Value returned by MsgBox

; ENTRY POINT

$port_status = GetPortStatus($PORT)
If $port_status = $PORT_OPEN Then
	MsgBox($INFO_ICON, "Port already open",	"Windows Firewall already has port 1024 open, no futher action is necessary. " & _
											"Note that if you are using any other firewalls port 1024 will need opening manually.")
	Exit
Else
	$ret = MsgBox($QUEST_ICON + $OPT_YESNO, "Port not open",	"Windows Firewall does not have port 1024 open, would you like to attempt to open it now?")
	If $ret = $YES Then
		RunWait(@ComSpec & " /c netsh firewall add portopening TCP 1024 WM5PPCTT" & ' > "' & @TempDir & '\openports.txt"', "", @SW_HIDE)
		; Check we have an OK message
		$handle = FileOpen(@TempDir & "\openports.txt", 0)
		$temp = FileReadLine($handle)
		If $temp = "Ok." Then
			; Success
			MsgBox($INFO_ICON, "Port Opened", "The port was opened successfully, note that any other firewalls being used may have to have port 1024 opened manually.")
			Exit
		Else
			$ret = MsgBox($QUEST_ICON + $OPT_YESNO, "Port Not Opened!", "The command to open the port was not successful, would you like to check the logfile " & _
				" (it will open in notepad)?")
			If $ret = $YES Then
				ShellExecute(@TempDir & '\openports.txt')
			EndIf
		EndIf
	EndIf
EndIf

; GET PORT STATUS
Func GetPortStatus($my_port)
	RunWait(@ComSpec & " /c netsh firewall show state" & ' > "' & @TempDir & '\ports.txt"', "", @SW_HIDE)
	$handle = FileOpen(@TempDir & "\ports.txt", 0)
	Do
		$temp = FileReadLine($handle)
		$eof = @error							; Store the error (-1 if EOF)
		$strings = StringSplit($temp, " ")
		If $strings[1] = $PORT Then
			Return($PORT_OPEN)
		EndIf
	Until $eof = -1
	Return($PORT_NOTOPEN)
EndFunc
