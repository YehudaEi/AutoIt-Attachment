;===============================================================================
; Author(s):        Roger Osborne
; Version:               1.0.0
; AutoItVer:          3.0.102.+
; Created               2008-12-2
;
; Description:      Maps a network drive using a specified username and password
; 
; IMPORTANT NOTE:   This function will NOT allow you to map to a server -- using different credentials -- if you already have mapped drives
;                   to the SAME server (with a different credential). 
;                   In other words, ONLY ONE user credential can be used for EACH server you are connecting to.
;
; Syntax:           _MapDriveDiffUser ($driveletter, $servername, $servershare, $serverusrname, $serverusrpasswd, $reporterror)
;
; Parameter(s):         $driveletter = Drive letter to assign for network share
;						$servername = Name of server 
;                       $servershare = Share name on server ($servername)
;						$serverusrname = User name to use for mapping drive
;						$serverusrpasswd = Password to use for mapping drive
;						$reporterror = Should the function return a MsgBox if the drive mapping is not successful ("yes" or "no")
;
; Requirement(s):   None
;
; Example:                _MapDriveDiffUser("X","ServerNameHere","ShareNameHere", "DomainName\administrator", "AdministratorPasswordHere", "yes")
;
;===============================================================================

Func _MapDriveDiffUser($driveletter, $servername, $servershare, $serverusrname, $serverusrpasswd, $reporterror) 

			If DriveMapGet($driveletter & ":") <> "\\" & $servername & "\" & $servershare Then
   			   DriveMapDel($driveletter & ":")
   			   sleep(250)
			EndIf

			DriveMapAdd($driveletter & ":", "\\" & $servername & "\" & $servershare, 0, $serverusrname, $serverusrpasswd)

			If $reporterror = "yes" Then
				If DriveMapGet($driveletter & ":") <> "\\" & $servername & "\" & $servershare Then
					MsgBox(16, "Error Mapping Drive", "There was an error mapping drive " & $driveletter & ": to the following UNC path: " & "\\" & $servername & "\" & $servershare)
				EndIf
			EndIf

			If $reporterror = "no" Then
				; Do nothing
			EndIf
			
EndFunc   ;==>_MapDriveDiffUser
