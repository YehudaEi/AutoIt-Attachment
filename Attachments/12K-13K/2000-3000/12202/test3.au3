;	$var = Ping("ftp.sunet.se",250)
;	If $var Then ; also possible:  If @error = 0 Then ...
;	    Msgbox(0,"Status","Online, roundtrip was:" & $var)
;	Else
;	    Msgbox(0,"Status","An error occured with number: " & @error)
;	EndIf

#include <GUIConstants.au3>
#include <Date.au3>
; == GUI generated with Koda ==

Dim $var, $tooltip, $checkstatus, $control, $failedtime, $repeat, $resumed, $firsttime

$firsttime = 1
$failedtime = _NowTime()
$repeat = 1
$file = FileOpen(@scriptdir & "log.txt", 1)
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open log file.")
    Exit
EndIf

GUISetState(@SW_SHOW)

Func StartPing()
	$var = Ping("ftp.sunet.se",250)
	If $var Then
		If $firsttime = 1 Then
			FileWrite($file, "Connection was working at: " & _NowTime())
			$firsttime = 0
		EndIf
		$control = 0
		$status = 1
		$checkstatus = _NowTime()
		If $repeat = 0 Then
			$resumed = _NowTime()
			FileWrite($file, "Connection was resumed at: " & $resumed)
			$repeat = 1
		EndIf
		
		$repeat = 1
	Else
		If $firsttime = 1 Then
			FileWrite($file, "Connection was not working at: " & _NowTime())
			$firsttime = 0
		EndIf
		$control = 1
		$status = 0
		If $control = 1 Then
			$checkstatus = _NowTime()
			If $repeat = 1 Then
				$failedtime = _NowTime()
				FileWrite($file, "Connection was lost at: " & $failedtime)
				$repeat = 0
			Else
				$repeat = 0
			EndIf
		Else
			$control = 0
		EndIf
	EndIf
	
	If $status = 0 Then
		$tooltip = "Not Working"
	Else
		$tooltip = "Working"
	EndIf
	
	If $control = 1 Then
		$failed = "Connection dropped at " & $failedtime
	EndIf
	
EndFunc

Func ShowToolTip()
	If $control = 1 Then
		ToolTip("Status: " & $tooltip & ", Failed at: " & $failedtime, 0,0)
	Else
		ToolTip("Status: " & $tooltip & ", Time of event: " & $checkstatus, 0,0)
	EndIf
EndFunc

While 1
	StartPing()
	ShowToolTip()
	Sleep(100)
WEnd
Exit