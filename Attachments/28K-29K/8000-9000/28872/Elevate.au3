; *********************************************************************************************************
; This Tool Elevates a users permissions to be able to run an executable. The intended purpose of this tool
; it so that student can preform installations of software that are not msi based (i.e. setup.exe).
;
; Adam Seitz (aseitz@pps.k12.or.us) System Administrator II
; *********************************************************************************************************
; Elevate.exe accepts all required information from the command-line:
; Elevate.exe requires 6 arguments to function.
;  arg1 = <Local Elevated Account Name>
;  arg2 = <Local Elevated Account Password>
;  arg3 = <Network Account Name>
;  arg4 = <Network Account Password>
;  arg5 = <UNC Path of which to map>
;  arg6 = <Path From UNC to executable>
;
; Usage Looks Like This: elevate.exe arg1 arg2 arg3 arg4 arg5 arg6
;
; Usage Ssamples:
; 1.) elevate.exe Administrator password1 tech-staff-clev password2 \\nwclev1\zen\apps SOFTWARE_TITLE\setup.exe
; 2.) elevate.exe Superuser davepass superdaveguy superpassword \\server1\docroot gopher.exe
; *********************************************************************************************************
; Window Contents
Local $sTitle = "PPS Elevation Tool v1.0"

; *********************************************************************************************************
; Capture the Arguments From the Command Line.
; *********************************************************************************************************

Local $sUserName = $CmdLine[1]	;Local User Name
Local $sPassword = $CmdLine[2]	;Local Password

Local $sNetUserName = $CmdLine[3]	;Network User Name
Local $sNetPassword = $CmdLine[4]	;Network Password

Local $sNetPath = $CmdLine[5]	;Network Path
Local $sFilePath = $CmdLine[6]	;Excuatable Name

Local $sNetDrive = "U:"
Local $sWinDir = EnvGet( 'windir' )

; *********************************************************************************************************
; Error Checking and Reporting.
; *********************************************************************************************************
; Check validity of Local Account and Password by creating and removing a file in System32.
RunAsWait($sUserName, @ComputerName, $sPassword, 4, @ComSpec & " /c echo TEST>"& $sWinDir &"\system32\test.txt", "", @SW_HIDE)
; Verify File  Created
If FileExists( $sWinDir &"\system32\test.txt" ) = 1 Then
	; Created File Test Passed, now lets remove it.
	RunAsWait($sUserName, @ComputerName, $sPassword, 4, @ComSpec & " /c del /q "& $sWinDir &"\system32\test.txt", "", @SW_HIDE)
	; And test to see if remove worked.
	If FileExists( $sWinDir &"\system32\test.txt" ) = 1 Then
		MsgBox( 0,$sTitle, "Insufficient Privileges for Account: "& $sUserName &"")
		exit
	EndIf
Else
	MsgBox( 0,$sTitle, "Bad Local User Name or Password: "& $sUserName &"")
	exit
EndIf

; Remove previous mapping of U: drive.
RunAsWait($sUserName, @ComputerName, $sPassword, 4, @ComSpec & " /c net use /delete "& $sNetDrive &"", "", @SW_HIDE)

; Map U: Drive to Local Account and run the executable, then exit.
RunAsWait($sUserName, @ComputerName, $sPassword, 4, @ComSpec & " /k NET USE /PERSISTENT:YES "& $sNetDrive & " " & $sNetPath & " /USER:"& $sNetUserName &" """& $sNetPassword &""" && "& $sNetDrive &" && CD && START /WAIT """" "& $sNetDrive &"\"& $sFilePath &" && exit", "", @SW_SHOW)

; *********************************************************************************************************
; Clean Up
; *********************************************************************************************************
; Remove U: Mapping
RunAsWait($sUserName, @ComputerName, $sPassword, 4, @ComSpec & " /c net use /delete "& $sNetDrive &"", "", @SW_HIDE)
Exit
