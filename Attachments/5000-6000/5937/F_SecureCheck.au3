#Region Compiler directives section 
;** This is a list of compiler directives used by CompileAU3.exe.
;** comment the lines you don't need or else it will override the default settings
;#Compiler_Prompt=y              				;y=show compile menu   
;** AUT2EXE settings
;#Compiler_AUT2EXE=
#Compiler_Icon=			                  		;Filename of the Ico file to use
;#Compiler_OutFile=              				;Target exe filename.
#Compiler_Compression=4         				;Compression parameter 0-4  0=Low 2=normal 4=High
#Compiler_Allow_Decompile=n      				;y= allow decompile
;#Compiler_PassPhrase=           				;Password to use for compilation
;** Target program Resource info
#Compiler_Res_Comment=Check F-Secure antivirus updates. 
#Compiler_Res_Description=Check F-Secure antivirus updates. Receives from cmd-line the number of gap days allowed from the current date. In case of errors send an'email to the server Admin.
#Compiler_Res_Fileversion=1.0
#Compiler_Res_LegalCopyright=Giuseppe Criaco 
; free form resource fields ... max 15
#Compiler_Res_Field=Email|gcriaco@quipo.it   	;Free format fieldname|fieldvalue
#Compiler_Res_Field=Release Date|4/1/2006  	    ;Free format fieldname|fieldvalue
;#Compiler_Res_Field=Name|Value  				;Free format fieldname|fieldvalue
;#Compiler_Res_Field=Name|Value  				;Free format fieldname|fieldvalue
#Compiler_Run_AU3Check=y        				;Run au3check before compilation
; The following directives can contain:
;   %in% , %out%, %icon% which will be replaced by the fullpath\filename. 
;   %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.
#Compiler_Run_Before=           				;process to run before compilation - you can have multiple records that will be processed in sequence
#Compiler_Run_After=move "%out%" "%scriptdir%"  ;process to run After compilation - you can have multiple records that will be processed in sequence
#EndRegion
;===============================================================================
;
; Program Name:     F-SecureCheck()
; Description:      Check F-Secure anti-virus updates
; Parameter(s):     n. of gap days allowed 
; Requirement(s):   F-Secure anti-virus
; Return Value(s):  None
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;
#Include <date.au3>
#Include <INet.au3>
#Include <File.au3>;Function _FileWriteLog

AutoItSetOption("TrayIconDebug", 1) ;Debug: 0=no info, 1=debug line info

Dim $sFSDB

;Check command-line Parameter
If $CMDLINE[0] = 0 Then
	_ScriptErr('Antivirus Check: n. of gap days allowed not provided') 
	Exit
EndIf 

$sCmd = Chr(34) & @ProgramFilesDir &  "\F-Secure\Anti-Virus\fsav.exe" & Chr(34) & " /version"
$sFSDB=_RunOut($sCmd, @WorkingDir, @SW_HIDE)

;Parsing antivirus info to get updates date in format YYYY/MM/DD
$aFSDB = StringSplit(StringStripCR($sFSDB),@LF)
;~ consolewrite ($sFSDB)
;~ consolewrite ($aFSDB[0])

$sAVPDate = StringReplace(StringRight($aFSDB[2],10), "-", "/")
$sLibraDate = StringReplace(StringRight($aFSDB[3],10), "-", "/")
$sOrionDate = StringReplace(StringRight($aFSDB[4],10), "-", "/")
$sCurrDate = _NowCalcDate()

;Determine n. of gap days
$iAVPGap = _DateDiff("D", $sAVPDate, $sCurrDate)
If @error Then _ScriptErr('_DateDiff( "D", $sAVPDate, $sCurrDate)')
$iLibraGap = _DateDiff("D", $sLibraDate, $sCurrDate)
If @error Then _ScriptErr('_DateDiff( "D", $sLibraDate, $sCurrDate)')
$iOrionGap = _DateDiff("D", $sOrionDate, $sCurrDate)
If @error Then _ScriptErr('_DateDiff( "D", $sOrionDate, $sCurrDate)')

;$iRealGap = Minor Scanning Engines gap 
$iRealGap = $iAVPGap
$iLastUpdDate = $sAVPDate
If $iRealGap > $iLibraGap Then 
	$iRealGap = $iLibraGap
	$iLastUpdDate = $sLibraDate
EndIf
If $iRealGap > $iOrionGap Then 
	$iRealGap = $iOrionGap
	$iLastUpdDate = $sOrionDate
EndIf

;~ msgbox(0,"AVP Days Gap: " & $iAVPGap, $sAVPDate)
;~ msgbox(0,"Libra Days Gap: " & $iLibraGap, $sLibraDate)
;~ msgbox(0,"Orion Days Gap: " & $iOrionGap, $sOrionDate)
;~ msgbox(0,"Minor Scanning Engines Days Gap: " & $iRealGap, $sCurrDate)

If $iRealGap > $CMDLINE[1] Then
;~ 	Anti-virus updates out of date. We send an Email to the server Admin
	$s_SmtpServer = "mysmtpserver.com.au"
	$s_FromName = "FS-Check"
	$s_FromAddress = @ComputerName & "@MyDomain.it"
	$s_ToAddress = "To eMail Address"
	$s_Subject = "F-Secure Anti-virus out of date"
	Dim $s_Body[3]
	$s_Body[0] = "F-Secure Anti-virus out of date"
	$s_Body[1] = "Days Gap: " & $iRealGap
	$s_Body[2] = "Updates: " & $sFSDB
	$Response = _INetSmtpMail ($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject, $s_Body)
	$err = @error
	If $Response = 1 Then
		MsgBox(0, "Success!", "Mail sent")
	Else
		MsgBox(0, "Error!", "Mail failed with error code " & $err)
	EndIf

EndIf

;---------------------------------------------------------------------------------------------------------------------------

Func _ScriptErr($MSG)
	_FileWriteLog(@ScriptDir & "\FsCheckEmail_ERRORS.log", $MSG)
	Exit
EndFunc   ;==>ScriptErr

;**********************************************************************
; Run a command without showing any window.
; Returns the output of the command.
;**********************************************************************
Func _RunOut($sCommand, $sWorkDir = @WorkingDir, $iShowMode = @SW_HIDE)
	Local $sResult = ''
	$iPID = Run($sCommand, $sWorkDir, $iShowMode, 2)
	While Not @Error
		$sResult &= StdoutRead($iPID)
	Wend
	
	Return $sResult
EndFunc;==>_RunOut