#include <GUIConstants.au3>
#NoTrayIcon
Global $i=0, $Msg = "ProgressBar"
Global $Title, $Date

if $CmdLine[0] = 0 Then ; No Arguments passed to the script. Use Default Insformation.
	$Title = "Login Script"
	$Text1="Logon script is processing, one moment please..."
	$Text2="Powered By Information Technology"
Else
	If $CmdLine[0] <> 5 then; Script only accepts 3 parameters
		debug('Bad Paramters passed to the script' & @CRLF & 'Parameters are:' & @CRLF & 'Parameter1 Title' & @CRLF & 'Parameter2 Text1' & @CRLF & 'Parameter3 Text2' & @crlf)
		Exit
	EndIf
	$Title = $Cmdline[1]
	$Text1 = $Cmdline[2]
	$Text2 = $Cmdline[3]
EndIf

Select 
	Case $CmdLine[4] = 'Start'; Create GUI
		_CreateGui()
	Case $CmdLine[4] = 'Progress'; Sap Gui Installation complete
		_Progress($Cmdline[5])
EndSelect
;
Func _CreateGui()
	$Date = 'Today is ' & @MON & '-' & @MDAY & '-' & @YEAR
	$Server = StringTrimLeft(@LogonServer, 2)
	$Domain = @LogonDomain
	$User = @UserName
	;
	$Form1 = GUICreate($Title, 640, 190, -1, -1,$WS_EX_STATICEDGE)
	$Pic1 = GUICtrlCreatePic("U:\Privado\scripts\Iconos\OEMLOGO.BMP", 1, 1, 150, 100, BitOR($SS_NOTIFY,$WS_GROUP))
	$Date1 = GUICtrlCreateLabel ($Date ,160, 20)
	$User1 = GUICtrlCreateLabel ('Current User: ' & $User ,160, 40)
	$Server1 = GUICtrlCreateLabel ('Logon Server: ' & $Server ,160, 60)
	$Domain1 = GUICtrlCreateLabel ('Current Domain: ' & $Domain ,160, 40)

	$Label1 = GUICtrlCreateLabel($Text1, 160, 1, 500, 17)
	$Label2 = GUICtrlCreateLabel($Text2, 24, 130, 563, 17)
	$Progress1 = GUICtrlCreateProgress(24, 110, 569, 17)
	GUISetState(@SW_SHOW)
	While 1
	$i += 1
	If $i=100 then 
		$i=0 
	endif
	GUICtrlSetData($Progress1, $i)
	
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
	;Return
EndFunc
Func _Progress($Progress)
	GUICtrlSetData($Progress1, $Progress)
	Return
EndFunc


;=====================
; -- Debug --
;====================
; Show debug message
;
; Input:    none
; Output:   none
Func Debug ($msg)
   MsgBox (0, "ProgressBar", $msg, 600)
EndFunc
