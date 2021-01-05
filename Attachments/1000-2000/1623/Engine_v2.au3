; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Code Junkie
;
; Script Function:
;	WinNT Tweaker Engine v2
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

$TweakerEngineVersionMajor=2
$TweakerEngineVersionMinor=000
$TweakerEngineV2Build=1

$TweakerTweakListVersion=""
$TweakerTweakListBuild=""

$iniFileName = "cust_winnt.ini"
$iniFileLoc = @ScriptDir & "\"

CheckFileExists($iniFileLoc & $iniFileName)

$RegWriteSuccessful = 0
$RegDelValSuccessful = 0
$RegDelKeySuccessful = 0 
$RegEditSuccessful = 0

$RegWriteFailed = 0
$RegDelValFailed = 0
$RegDelKeyFailed = 0 
$RegEditFailed = 0

$Tweaks = 0
$Implomented = 0
$NotImplomented = 0
$NotImplomentedReason1 = 0 ; Not listed in ini
$NotImplomentedReason2 = 0 ; Invalid value in ini
$NotImplomentedReasonInvalid = 0
$OSVersion = @OSVersion

$LastTweak = ""
$CurrentTweakNum=0
$CurrentRegEdit=0

$ErrorMessages = 0

$CurrentUserOnly = IniRead(iniLoc(),"Tweaker_debug","current_user_only",0)
$LogNotImplomentedReasoning = IniRead(iniLoc(),"Tweaker_debug","log_not_implomented_reasons",0)
$ErrorMessages = IniRead(iniLoc(),"Tweaker_debug","error_messages",0)
$GenLogFile = IniRead(iniLoc(),"Tweaker_debug","create_log",0)
$ShowGuiEndSummary = IniRead(iniLoc(),"tweaker_debug","gui_end_summary",0)
$EndSummaryTimeOut = IniRead(iniLoc(),"tweaker_debug","gui_end_summary_timeout",60)
$LogFileLoc = FileLoc(iniLoc(),"tweaker_debug","log_file_loc",@TempDir)
$LogFileName = IniRead(iniLoc(),"tweaker_debug","log_file_name","WinNT Tweaker " & Version() & ".log")
$GenRegUndoFile = IniRead(iniLoc(),"Tweaker_debug","create_reg_undo",0)
$RegUndoFileLoc = FileLoc(iniLoc(),"tweaker_debug","reg_undo_file_loc",@TempDir)
$RegUndoFileName = IniRead(iniLoc(),"tweaker_debug","reg_undo_name","WinNT Tweaker " & Version() & "- Undo.reg")

$LogFile = ""
$RegUndoFile = ""
;---------------------------Common Functions--------------------------------------------------------------

Func Implomented_YesNo($YesNo,$ReasonCode,$TweakName) ;ToDo! NotImplomented LogReasonCodes
	$Tweaks = $Tweaks + 1
	Select
		Case $YesNo = 1
			$Implomented = $Implomented+1
		Case $YesNo = 0
			$NotImplomented = $NotImplomented+1
			Select
				Case $ReasonCode = 1
					$NotImplomentedReason1 = $NotImplomentedReason1+1
				Case $ReasonCode = 2
					$NotImplomentedReason2 = $NotImplomentedReason2+1
					;If $LogNotImplomentedReasoning = 1 then
				Case Else
					$NotImplomentedReasonInvalid = $NotImplomentedReasonInvalid+1
					;If $LogNotImplomentedReasoning = 1 then
			EndSelect
	EndSelect
EndFunc ;Implomented_YesNo

Func TweakerRegEdit($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	Select
		Case $Action = "RegWrite"
			$i = 0
			For $i = 0 to 3 Step 1
				$Result = RegWrite($KeyName,$Valname,$ValType,$NewValue)
				If $Result = 1 then
					$RegWriteSuccessful = $RegWriteSuccessful + 1
					Return "Successful"
				EndIf
			Next
				$RegWriteFailed = $RegWriteFailed + 1
				Return "Error - error writing registry key or value"
		Case $Action = "RegDeleteVal"
			$i = 0
			For $i = 0 to 3 Step 1
				$Result = RegDelete($KeyName,$Valname)
				If $Result = 1 then
					$RegDelValSuccessful = $RegDelValSuccessful + 1
					Return "Successful"
				EndIf
			Next
			$RegDelValFailed = $RegDelValFailed + 1
			Select
				Case $Result = 0
					Return "Error - key/value does not exists"
				Case $Result = 2
					Return "Error - error deleting key/value"
			EndSelect
		Case $Action = "RegDeleteKey"
			$i = 0
			For $i = 0 to 3 Step 1
				$Result = RegDelete($KeyName)
				If $Result = 1 then 
					$RegDelKeySuccessful = $RegDelKeySuccessful + 1
					Return "Successful"
				EndIf
			Next
			$RegDelKeyFailed = $RegDelKeyFailed + 1
			Select
				Case $Result = 0
					Return "Error - key/value does not exists"
				Case $Result = 2
					Return "Error - error deleting key/value"
			EndSelect
		Case $Action = "RegEditVal"
			$CurrentRegStringVal = RegRead($KeyName,$Valname)
			Select
				case @error = 0
					$ReplacementStringLen = StringLen($NewValue)
					$CurrentRegStringLen = StringLen($CurrentRegStringVal)
					
					$TrimXCharsOfEnd = $CurrentRegStringVal - ($ReplacementStringLen + $EditStart)
					
					$TrimedRegStringBeg = StringLeft($CurrentRegStringVal,$EditStart)
					$TrimedRegStringEnd = StringRight($CurrentRegStringVal,$TrimXCharsOfEnd)
					
					$EditedVal = $TrimedRegStringBeg & $NewValue & $TrimedRegStringEnd
					
					;msgbox(64,"","Old Value = " & $CurrentRegStringVal & chr(13) & "New Value = " & $EditedVal)
					
					;RegWrite($KeyName,$Valname,$ValType,$EditedVal)
					$i = 0
					For $i = 0 to 3 Step 1
						$Result = RegWrite($KeyName,$Valname,$ValType,$EditedVal)
						If $Result = 1 Then
							$RegEditSuccessful = $RegEditSuccessful+ 1
							Return "Successful"
						EndIf
					Next
					$RegEditFailed = $RegEditFailed + 1
				Case @error = 1
					Return "Error - unable to open requested key"
				case @error = -1
					Return "Error - unable to open requested value"
				case @error = -2
					Return "Error - value type not supported"
			EndSelect
			
		Case Else
			Return "Error - Invalid Action"
	EndSelect
EndFunc ;TweakerRegEdit

Func CheckFileExists($FileLoc)
	If FileExists($FileLoc) = 0 then 
		$Result = MsgBox(16+5,"Critical Error","There is no cust_winnt.ini file to load the settings from!" & @lf & "The cust_winnt.ini must be in the same dir as this .exe")
		Select
			Case $Result = 2
				CheckFileExists($FileLoc)
			Case $Result = 4
				Exit
		EndSelect
	EndIf
EndFunc ;CheckFileExists

Func RegEditUndo($Key,$Name,$ValType,$Action) ;ToDo!
;Actions - RegWrite,RegDeleteVal,RegDeleteKey,RegEditVal
;ValTypes - Reg Val Type just like youd use with RegWrite...
;Name - RegValName is applicable
;Key - RegKeyName
	Select
		Case $Action = "RegWrite"
			$CurrentVal = RegRead($Key,$Name)
			If $CurrentVal = "" Then
				;ToDo!
				;If Val doesnt exist and del val command to REG file
			Else
				RegEditUndoAddToFile($Key,$Name,$CurrentVal)
			EndIf
		Case $Action = "RegDeleteVal"
			$CurrentVal = RegRead($Key,$Name)
			RegEditUndoAddToFile($Key,$Name,$CurrentVal)
		Case $Action = "RegDeleteKey"
			;ToDo!
		Case $Action = "RegEditVal"
			$CurrentVal = RegRead($Key,$Name)
			RegEditUndoAddToFile($Key,$Name,$CurrentVal)
		Case Else
			ErrorMessage(48,"RegUndo Error","Error - Invalid Action")
	EndSelect
EndFunc ;RegEditUndo

Func RegEditUndoStart()
	Select
		case $GenRegUndoFile = 1
			$RegUndoFile = FileOpen($RegUndoFileLoc & "\" & $RegUndoFileName, 1)
			If $RegUndoFile = -1 Then
				ErrorMessage(48, "I/O Error", "Unable to open file." & @lf & "Logging as been disabled")
				$logging="0"
			Else
				FileWriteLine($RegUndoFile,"Windows Registry Editor Version 5.00")
				FileWriteLine($RegUndoFile,"")
			EndIf
		case $GenRegUndoFile = 0
			;-
		case Else
			ErrorMessage(48,"Invalid ini entry","tweaker_debug - create_reg_undo is invalid")
	EndSelect
EndFunc ;RegEditUndoStart

Func RegEditUndoAddToFile($Key,$Section,$Value)
	Select
		case $GenRegUndoFile = 1
			IniWrite($RegUndoFile,$Key,$Section,$Value)
		case $GenRegUndoFile = 0
			;-
		case Else
			;-
	EndSelect
EndFunc ;RegEditUndoAddToFile

Func RegEditUndoStop()
	Select
		case $GenRegUndoFile = 1
			FileClose($RegUndoFile)
		case $GenRegUndoFile = 0
			;-
		case Else
			;-
	EndSelect
EndFunc ;RegEditUndoStop

Func GUIEndSummary() ;ToDo! may still need changing
	If 	$ShowGuiEndSummary = 1 then
		Dim $Line[7]
		$Line[0] = "----End Summary-----"
		$Line[1] = ""
		$Line[2] = "Error Messages = " & $ErrorMessages
		$Line[3] = "Tweaks Implomented = " & $Implomented & "/" & $Tweaks
		$Line[4] = "Tweaks Not Implomented" & $NotImplomented & "/" & $Tweaks 
		$Line[5] = ""
		$Line[6] = ""
		
		For $LineNum = 0 to UBound($Line) - 1
			$EndSummary = $Line[$LineNum] & @lf
		Next
		
		Select
			Case $EndSummaryTimeOut = "none"
				MsgBox(64,"End Summary",$EndSummary)
			Case IsNumber($EndSummaryTimeOut) = 1
				MsgBox(64,"End Summary",$EndSummary,$EndSummaryTimeOut)
			Case Else
				ErrorMessage(48,"Invalid ini entry","tweaker_debug - gui_end_summary_timeout is invalid")
		EndSelect
	EndIf		
EndFunc ;GUIEndSummary

Func iniLoc()
	return($iniFileLoc & $iniFileName)
EndFunc ;iniLoc

Func Read_ini_for_tweaks($TweakSection,$TweakKey)
	return (IniRead(iniLoc(),$TweakSection,$TweakKey,-1))
EndFunc ;Read_ini_for_tweaks

Func ErrorMessage($Type,$Title,$Message)
	$ErrorMessages = $ErrorMessages + 1
	;Todo - Log error to file
	If $ErrorMessages = 1 Then MsgBox($Type,$Title,$Message,180)
EndFunc ;ErrorMessage
	
Func TweakerRegEditLogged($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	$Result = TweakerRegEdit($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	
	Select
		case $GenLogFile = 1
			If $TweakName = $LastTweak Then
				$NewTweak=0
				$CurrentRegEdit=$CurrentRegEdit+1
			Else
				$NewTweak=1
				$CurrentTweakNum=$CurrentTweakNum+1
				$CurrentRegEdit=0
				AddLineToLog("")
				AddLineToLog($TweakName)
			EndIf
			
			Select
				Case $Result = "Successful"
					AddLineToLog($Result & " --- TweakNum " & $CurrentTweakNum & " RegEdit " & $CurrentRegEdit)
				Case StringInStr($Result,"Error") >= 1
					AddLineToLog($Result & " --- TweakNum " & $CurrentTweakNum & " RegEdit " & $CurrentRegEdit)
				Case Else
					ErrorMessage(48,"RegTweaker Error","The value returned by RegTweaker was invalid")
					AddLineToLog("--- Error - The value returned by RegTweaker was invalid --- TweakNum " & $CurrentTweakNum & " RegEdit " & $CurrentRegEdit)
			EndSelect
		case $GenLogFile = 0
			;-
		case Else
			;-
	EndSelect
	
EndFunc ;TweakerRegEditLogged

Func TweakerRegEditComplete($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	RegEditUndo($KeyName,$KeyName,$ValType,$Action)
	
	$Result = TweakerRegEdit($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	
	Select
		case $GenLogFile = 1
			If $TweakName = $LastTweak Then
				$NewTweak=0
				$CurrentRegEdit=$CurrentRegEdit+1
			Else
				$NewTweak=1
				$CurrentTweakNum=$CurrentTweakNum+1
				$CurrentRegEdit=0
				AddLineToLog("")
				AddLineToLog($TweakName)
			EndIf
			
			Select
				Case $Result = "Successful"
					AddLineToLog($Result & " --- TweakNum " & $CurrentTweakNum & " RegEdit " & $CurrentRegEdit)
				Case StringInStr($Result,"Error") >= 1
					AddLineToLog($Result & " --- TweakNum " & $CurrentTweakNum & " RegEdit " & $CurrentRegEdit)
				Case Else
					ErrorMessage(48,"RegTweaker Error","The value returned by RegTweaker was invalid")
					AddLineToLog("--- Error - The value returned by RegTweaker was invalid --- TweakNum " & $CurrentTweakNum & " RegEdit " & $CurrentRegEdit)
			EndSelect
		case $GenLogFile = 0
			;-
		case Else
			;-
	EndSelect
EndFunc ;TweakerRegEditComplete

Func TweakerRedGeditUndoOnly($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	RegEditUndo($KeyName,$KeyName,$ValType,$Action)
	
	$Result = TweakerRegEdit($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
EndFunc ;TweakerRedGeditUndoOnly

Func TweakListVersion($Version,$Build)
	$TweakerTweakListVersion = $Version
	$TweakerTweakListBuild = $Build
EndFunc ;TweakListVersion

Func StartLogging()
	Select
		case $GenLogFile = 1
			$LogFile = FileOpen($LogFileLoc & "\" & $LogFileName, 1)
			If $LogFile = -1 Then
				ErrorMessage(48, "I/O Error", "Unable to open file." & @lf & "Logging as been disabled")
				$GenLogFile="0"
			EndIf
		case $GenLogFile = 0
			;-
		case Else
			ErrorMessage(48,"Invalid ini entry","tweaker_debug - create_log is invalid")
	EndSelect
EndFunc ;StartLogging

Func StopLogging()
	Select
		case $GenLogFile = 1
			FileClose($LogFile)
		case $GenLogFile = 0
			;-
		case Else
			;-
	EndSelect
EndFunc ;StopLogging

Func AddLineToLog($String)
	Select
		case $GenLogFile = 1
			FileWriteLine($LogFile,$String)
		case $GenLogFile = 0
			;-
		case Else
			;-
	EndSelect
EndFunc ;AddLineToLog

Func LogEndSummary() ;ToDo! may still need changing
	Dim $EndSummary[7]
	$EndSummary[0] = "End Summary"
	$EndSummary[1] = ""
	$EndSummary[2] = "Error Messages = " & $ErrorMessages
	$EndSummary[3] = "Tweaks Implomented = " & $Implomented & "/" & $Tweaks
	$EndSummary[4] = "Tweaks Not Implomented" & $NotImplomented & "/" & $Tweaks 
	$EndSummary[5] = ""
	$EndSummary[6] = "Created By Code Junkie"
		
	For $Line = 0 to UBound($EndSummary) - 1
		AddLineToLog($EndSummary[$Line])
	Next
EndFunc ;EndSummary

Func Version()
	Return "v" & $TweakerEngineVersionMajor & "." & $TweakerEngineVersionMinor & "." & $TweakerTweakListVersion & "(" & $TweakerEngineV2Build & "." & $TweakerTweakListBuild & ")"
EndFunc ;Version

Func LogIntro()
	Dim $LogIntro[7]
	$LogIntro[0] = "WinNT Tweaker " & Version()
	$LogIntro[1] = ""
	$LogIntro[2] = "Error Messages = " & $ErrorMessages
	$LogIntro[3] = "Tweaks Implomented = " & $Implomented & "/" & $Tweaks
	$LogIntro[4] = "Tweaks Not Implomented" & $NotImplomented & "/" & $Tweaks 
	$LogIntro[5] = ""
	$LogIntro[6] = "Created By Code Junkie"
		
	For $Line = 0 to UBound($LogIntro) - 1
		AddLineToLog($LogIntro[$Line])
	Next
EndFunc ;LogIntro

Func FileLoc($iniFile,$Section,$Key,$Default)
	$Result = IniRead($iniFile,$Section,$Key,$Default)
	Select
		Case $Result = $Default
			Return $Default
		Case $Result = "temp"
			Return @TempDir
		Case $Result = "desktop"
			Return @DesktopCommonDir
		Case $Result = "my_docs"
			Return @DocumentsCommonDir
	EndSelect
EndFunc ;LogFileLoc