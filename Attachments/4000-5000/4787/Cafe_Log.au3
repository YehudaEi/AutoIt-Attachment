;=========================================================================================
; Camp Bucca Internet Caffe' timer created by TSgt Scott A. Farrell (Supa.Snarg@gmail.com)
; Created with AutoIt 3 version 3.1.1.83 beta
;=========================================================================================
#include <GUIConstants.au3>
#include <Date.au3>

Dim $Header_1 = "Computer"
Dim $Header_2 = "Phone"
Dim $Header_3 = "PC"
Dim $Name, $TotalTime, $Unit, $count = 0
Dim $TimerActive_[52], $Time_[52], $Timer_[52], $sTime_[52], $xk, $ck, $tk, $pk, $A, $Radx, $Rad_[11]
Dim $Left = 10, $Top = 20
Dim $Label_[52], $TButton_[52], $SButton_[53], $Input1_[52], $Input2_[52]

$Today_File = @MON & "-" & @MDAY & "-" & @YEAR & ".txt"
$Log = FileOpen($Today_File, 1)
FileWriteLine($Log, "Logfile started: " & _DateTimeFormat( _NowCalc(), 0) & @CRLF & @CRLF)
FileClose($Log)

AdlibEnable("AllTimers", 500)

GUICreate("Net Cafe' Log by TSgt Farrell", 1000, 370)

$tab=GUICtrlCreateTab (5,0, 990,370)
$tab0=GUICtrlCreateTabitem ("Computers")

GUICtrlSetState(-1,$GUI_SHOW)

; Tab 1 - Computers

For $A = 1 To 28
	
	If $A = 28 Then ExitLoop

	If $A = 10 Then
		$Left = 10
		$Top = 135
	EndIf
	If $A = 19 Then
		$Left = 10
		$Top = 250
	EndIf

    GUICtrlCreateLabel($Header_1 & " " & $A, $Left, $Top, 100, 20, $SS_CENTER)
    $Label_[$A] = GUICtrlCreateLabel("00:00:00", $Left, $Top + 20, 100, 30, 0x1000)
    GUICtrlSetFont($Label_[$A], 18)
    $TButton_[$A] = GUICtrlCreateButton("Start", $Left, $Top + 50, 50, 20)
    $SButton_[$A] = GUICtrlCreateButton("Stop", $Left + 50, $Top + 50, 50, 20)
    $Input1_[$A] = GUICtrlCreateInput("Name", $Left, $Top + 70, 100, 20, 0x1000)
	$Input2_[$A] = GUICtrlCreateInput("Unit", $Left, $Top + 90, 100, 20, 0x1000)
	$Left = $Left + 110

Next

; Tab 2 - Phones

$tab=GUICtrlCreateTab (5,0, 990,370)
$tab1=GUICtrlCreateTabitem ("Phones")

$Left = 10
$Top = 20

For $A = 28 To 46

	If $A = 46 Then ExitLoop
		
	If $A = 37 Then
		$Left = 10
		$Top = 135
	EndIf

    GUICtrlCreateLabel($Header_2 & " " & $A - 27, $Left, $Top, 100, 20, $SS_CENTER)
    $Label_[$A] = GUICtrlCreateLabel("00:00:00", $Left, $Top + 20, 100, 30, 0x1000)
    GUICtrlSetFont($Label_[$A], 18)
    $TButton_[$A] = GUICtrlCreateButton("Start", $Left, $Top + 50, 50, 20)
    $SButton_[$A] = GUICtrlCreateButton("Stop", $Left + 50, $Top + 50, 50, 20)
    $Input1_[$A] = GUICtrlCreateInput("Name", $Left, $Top + 70, 100, 20, 0x1000)
	$Input2_[$A] = GUICtrlCreateInput("Unit", $Left, $Top + 90, 100, 20, 0x1000)
	$Left = $Left + 110

Next

; Tab 3 - PC's

$tab=GUICtrlCreateTab (5,0, 990,370)
$tab2=GUICtrlCreateTabitem ("PC's")

$Left = 10
$Top = 20

For $A = 46 To 51

	GUICtrlCreateLabel($Header_3 & " " & $A - 45, $Left, $Top, 100, 20, $SS_CENTER)
    $Label_[$A] = GUICtrlCreateLabel("00:00:00", $Left, $Top + 20, 100, 30, 0x1000)
    GUICtrlSetFont($Label_[$A], 18)
    $TButton_[$A] = GUICtrlCreateButton("Start", $Left, $Top + 50, 50, 20)
    $SButton_[$A] = GUICtrlCreateButton("Stop", $Left + 50, $Top + 50, 50, 20)
    $Input1_[$A] = GUICtrlCreateInput("Name", $Left, $Top + 70, 100, 20, 0x1000)
	$Input2_[$A] = GUICtrlCreateInput("Unit", $Left, $Top + 90, 100, 20, 0x1000)
	$Left = $Left + 110

Next
    
GUICtrlCreateTabitem ("")

GUISetState()

While 1
    $msg = GUIGetMsg()
    
    For $xk = 1 To UBound($TButton_) - 1
        If $msg = $TButton_[$xk] And GUICtrlRead($Input1_[$xk]) > "" And GUICtrlRead($Input2_[$xk]) > "" Then
            GUICtrlSetState($TButton_[$xk], $GUI_DISABLE)
            GUICtrlSetState($Input1_[$xk], $GUI_DISABLE)
			GUICtrlSetState($Input2_[$xk], $GUI_DISABLE)
            $TimerActive_[$xk] = 1
            $Timer_[$xk] = TimerInit()
        ElseIf $msg = $TButton_[$xk] Then
            MsgBox(64, "User Error:  " & $xk, "Please Type in a User Name and/or Unit   ", 3)
        EndIf
        If $msg = $SButton_[$xk] Then
			$TimerActive_[$xk] = 0
			RecordStuff()
            GUICtrlSetData($Input1_[$xk], "Name")
			GUICtrlSetData($Input2_[$xk], "Unit")
            GUICtrlSetState($TButton_[$xk], $GUI_ENABLE)
            GUICtrlSetState($Input1_[$xk], $GUI_ENABLE)
			GUICtrlSetState($Input2_[$xk], $GUI_ENABLE)
			GUICtrlSetColor($Label_[$xk], 0x000000)
			GUICtrlSetData($Label_[$xk], "00:00:00")
        EndIf
    Next
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd

Func AllTimers()
    Local $Secs, $Mins, $Hour
	
    For $ck = 1 To UBound($TButton_) - 1
        
        If $TimerActive_[$ck] Then
            _TicksToTime(Int(TimerDiff($Timer_[$ck])), $Hour, $Mins, $Secs)
            $Time_[$ck] = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
            If $sTime_[$ck] <> $Time_[$ck] Then GUICtrlSetData($Label_[$ck], $Time_[$ck])
			If $Mins = 30 And $ck <= 27 Then
				GUICtrlSetColor($Label_[$ck], 0xff0000)
			EndIf
            If $Mins = 20 And $ck > 27 And $ck < 46 Then
				GUICtrlSetColor($Label_[$ck], 0xff0000)
			EndIf
			If $Mins = 30 And $ck >= 46 Then
				GUICtrlSetColor($Label_[$ck], 0xff0000)
			EndIf
        EndIf
	Next
EndFunc

Func RecordStuff()
    $LogStuff = FileOpen($Today_File, 1)
	
	If $xk <= 27 Then
        $Unit = $Header_1 & "  " & $xk
    EndIf
    If $xk >= 28 And $xk <= 45 Then
        $Unit = $Header_2 & "   " & $xk - 27
    EndIf
    If $xk >= 46 Then
        $Unit = $Header_3 & "   " & $xk - 45
    EndIf

    FileWriteLine($LogStuff, "Station: " & $Unit & @CRLF)
    FileWriteLine($LogStuff, "Name: " & (GUICtrlRead($Input1_[$xk])) & @CRLF)
	FileWriteLine($LogStuff, "Unit: " & (GUICtrlRead($Input2_[$xk])) & @CRLF)
    FileWriteLine($LogStuff, "Total time: " & (GUICtrlRead($Label_[$xk])) & @CRLF & @CRLF)
    FileClose($LogStuff)
EndFunc