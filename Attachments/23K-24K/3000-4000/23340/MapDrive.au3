;===============================================================================
; Author(s):        Roger osborne
; Version:               1.0.0
; AutoItVer:          3.0.102.+
; Created               2008-12-2
;
; Description:      Maps a network drive
; Syntax:           _MapDrive ($driveletter, $servername, $servershare, $reporterror)
;
; Parameter(s):         $driveletter = Drive letter to assign for network share
;						$servername = Name of server 
;                       $servershare = Share name on server ($servername)
;						$reporterror = Should the function return a MsgBox if the drive mapping is not successful ("yes" or "no")
;
; Requirement(s):   None
;
; Example:                _MapDrive("X","Server1","Public", "no")
;
;===============================================================================

;Func _MapDrive($driveletter, $servername, $servershare, $reporterror)

Func _MapDrive($driveletter, $servername, $servershare, $reporterror) 

			If DriveMapGet($driveletter & ":") <> "\\" & $servername & "\" & $servershare Then
   			   DriveMapDel($driveletter & ":")
   			   sleep(250)
			EndIf
				DriveMapAdd($driveletter & ":", "\\" & $servername & "\" & $servershare)

			If $reporterror = "yes" Then
				If DriveMapGet($driveletter & ":") <> "\\" & $servername & "\" & $servershare Then
					MsgBox(16, "Error Mapping Drive", "There was an error mapping drive " & $driveletter & ": to the following UNC path: " & "\\" & $servername & "\" & $servershare)
				EndIf
			EndIf

			If $reporterror = "no" Then
				; Do nothing
			EndIf
			
EndFunc   ;==>_MapDrive

