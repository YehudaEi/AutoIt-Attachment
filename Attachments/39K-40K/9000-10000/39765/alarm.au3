#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("TrayMenuMode", 1)
Global $Var = fileopen(@AppDataDir & "\alarm.dat")
$info = FileReadLine ($var)
Opt ("TrayOnEventMode" , 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("ALARM !", 449, 221, 192, 146, $GUI_SS_DEFAULT_GUI)
$Input1 = GUICtrlCreateInput("", 120, 96, 66, 58, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetLimit(-1, 2)
GUICtrlSetFont(-1, 28, 400, 0, "Minion Pro")
$Input2 = GUICtrlCreateInput("", 208, 96, 66, 58, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetLimit(-1, 2)
GUICtrlSetFont(-1, 28, 400, 0, "Minion Pro")
$Label1 = GUICtrlCreateLabel("When should I wake you up ?", 24, 35, 397, 48)
GUICtrlSetFont(-1, 21.5, 800, 0, "Microsoft Sans Serif")
$Button1 = GUICtrlCreateButton("OK", 160, 176, 75, 25)
$Checkbox1 = GUICtrlCreateCheckbox("Use previous music", 300, 176)
GUICtrlSetState ($Checkbox1 , $GUI_CHECKED)
if $info =="" Then GUICtrlSetState ($Checkbox1 , $GUI_DISABLE)
$Label2 = GUICtrlCreateLabel(":", 192, 88, 15, 69)
GUICtrlSetFont(-1, 36, 400, 0, "Minion Pro")
$Label3 = GUICtrlCreateLabel("HRS", 288, 136, 40, 30)
GUICtrlSetFont(-1, 14, 400, 0, "Minion Pro")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Button1

			while 1

			$hrs = GUICtrlRead($Input1)
			$mins = GUICtrlRead ($Input2)
			if $hrs>23 Or $mins > 59 Then
				$MsgReturn = msgbox (17,"OOPS!", "Ha ha ha! that time will never come! Please enter a valid time and then press OK in this message")
				if $MsgReturn == 2 then $msg2 = MsgBox (4,"Are you ?", "Are you sure to cancel the alarm and exit?")
				if $msg2 == 6 then Exit
			ElseIf $hrs == "" Or $mins == "" Then
				$msg4 = msgbox (49,"OOPS!", "Please tell me when to wake you up and then hit ok in this message !")

				if $msg4 == 2 then exit
			Else
;~ 				GUISetState (@SW_disable)
				GUICtrlSetState ($Input1, $GUI_DISABLE)
				GUICtrlSetState ($Input2, $GUI_DISABLE)
				GUICtrlSetState ($Button1, $GUI_DISABLE)
				GUICtrlSetState ($Checkbox1, $GUI_DISABLE)
				ExitLoop
			EndIf

			WEnd
			goodToGo()


	EndSwitch
WEnd


func goodToGo ()
	$check =GUICtrlRead ($Checkbox1)
	global $msg3 = 0
	Global $file
	$savedFile = FileOpen (@AppDataDir & "\alarm.dat" )
	$file = FileReadLine (@AppDataDir & "\alarm.dat")
	FileClose ($savedFile)

	while $file == "" Or $check == 4
		Global $file = FileOpenDialog ("Please select the music you want to play", @DesktopDir , "Music (*.mp3;*.wma;*.wav)" , 1)
		if @error then  $msg3 = MsgBox (4, "Are you" , "Do you really want to cancel the alarm and quit?")
		if $msg3 == 6 then Exit
		$savedFile = FileOpen (@AppDataDir & "\alarm.dat",2 )
		FileWrite ($savedFile , $file)
	FileClose ($savedFile)
	if $file = Not "" Then ExitLoop
	WEnd
	GUISetState (@SW_HIDE)
			$traytip = "I will call you up at " & $hrs & ":" & $mins & "hrs"
			$traytext = "Alarm at "  & $hrs  &  ":" & $mins  & " hrs"
			TrayTip ("Okay Got it", $traytip ,5)
			TrayCreateItem ($traytext)
			TrayCreateItem ("Cancel Alarm")
			TrayItemSetOnEvent(-1, "ExitScript")

			alaram()
		EndFunc


func alaram ()
while 1
	$hour = @HOUR
	$min = @MIN

if $hour == $hrs then
	if $min == $mins then
		ShellExecute($file)
		;MsgBox (0,0,"DONE")
		Exit
	EndIf
EndIf
sleep (35000)
 Wend
 EndFunc

Func ExitScript()
	;MsgBox (0,0,"DONE")
    Exit
EndFunc
