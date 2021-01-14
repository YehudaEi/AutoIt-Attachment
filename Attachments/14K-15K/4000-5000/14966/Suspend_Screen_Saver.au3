#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.4.1
 Author:         Steve Bateman (MisterBates)

 Script Function: Suspend screen saver while specified windows/processes exist.
 
 Credits:
 * Jeff Owen (bettereyes1  a t  y a h o o  d o t  c o m) - for introducing me to AutoIt
 * Paul Campbell (PaulIA) - for the excellent Auto3Lib, and for the forum post about GETSCREENSAVEACTIVE
 * Hubertus72 and Zedna - for providing working examples of how to store and swicth between taskbar icons

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
AutoItSetOption("MustDeclareVars", 1)	
#NoTrayIcon

#include <Misc.au3>
#include <GUIConstants.au3>
#include <Math.au3>
#include <A3LConstants.au3> ; Thanks to Paul Campbell (PaulIA) for this!
#include <A3LWinAPI.au3> ; Thanks to Paul Campbell (PaulIA) for this!

Const $Help = _
"Purpose: Suspend screensaver while specified windows/processes exist. Suspend Screen Saver is intended for use in " & _
"environments where NetMeeting or similar desktop sharing programs or presentation programs like Powerpoint " & _
"are in use. It can be used to suspend the screensaver while another user's desktop is being viewed or a presentation is being " & _
"shown. Once the shared windows or the presentation slideshow is closed, the screensaver is reactivated." & @CRLF & _
@crlf & _ 
"Usage: SSS -title:""xx"" -class:""xx"" -process:""xx"" -minutes:n -registry:regoption -install -uninstall -?" & @crlf & _
"  -title:""xx""" & @tab & "Suspends screensaver when window exists with specified title" & @crlf & _
"  -class:""xx""" & @tab & "Suspends screensaver when window exists with specified classname" & @crlf & _
"  -process:""xx""" & @tab & "Suspends screensaver when specified process name exists" & @crlf & _
"  -minutes:n" & @tab & "Suspends screensaver for maximum n minutes (even if windows/processes still exist)" & @crlf & _
"  -showchange" & @tab & "Shows changes using taskbar icon popups (as well as taskbar icon changes)" & @crlf & _
"  -registry  " & @tab & "Uses or modifies registry for window/process names" & @crlf & _
@tab & @tab & "-registry by itself uses window/process names from the registry in addition to those given" & @crlf & _
@tab & @tab & "-registry:add adds the window/process names to the registry, then uses registry content" & @crlf & _
@tab & @tab & "-registry:replace replaces existing window/process names, then uses registry content" & @crlf & _
@tab & @tab & "-registry:clear clears registry content, uses command line window/process names if given" & @crlf & _
"  -install    " & @tab & "adds shortcut to startup folder and registry entries for NetMeeting/HP Virtual Rooms" & @crlf & _
"  -uninstall" & @tab & "removes shortcut and registry entries" & @crlf & _
"  -? or -help" & @tab & "displays usage information" & @crlf & _
@crlf & _
"Exit Codes:" & @crlf & _
"  0    Script completed successfully" & @crlf & _
"  1    Problem processing command line parameters" & @crlf & _
"  2    Internal problem with program" & @crlf & _
@crlf & _
"Notes:" & @crlf & _
"1) Parameters can be specified using - or / character (-title is the same as /title). " & _
"2) If no command-line window/process names given, and no -registry or -minutes parameters, script will display help " & _
"then ask whether to install, exiting after 5 minutes. " & _
"3) Parameters can be shortened to minimum necessary to uniquely identify the parameter e.g. -title can be " & _
"shortened to -t, -registry to -r and so on. " & _
"4) Title, class or process names given using double quotes ("") are matched using case insensitive partial " & _
"matches e.g. -title:""excel"" will match ""Microsoft Excel for Windows"". " & _
"5) Title, class or process names given using single quotes (') are matched using regular expression matching. " & _
"6) Quote marks within quoted strings are reduced to a single instance ("""" to "", '' to ')."

Const $ScriptName = "Suspend Screen Saver"
Const $VersionNum = "1.0.0.11" ; Release.Patch
Const $ScriptNameVersion = $ScriptName & " (" & $VersionNum & ")"

Const $RegKey = "HKEY_CURRENT_USER\Software\MisterBates\" & $ScriptName
Const $RegName = "Parm%03u-Name"
Const $RegValue = "Parm%03u-Value"
Const $RegShowChange = "Show Changes"

Const $CheckEverySeconds = 5 ; How often to check window/process names
Const $MaxHours = 24 ; Maximum number of hours the screensaver can be suspended
Const $TooltipTime = 5 ; How long to leave the tooltip showing

Global $SearchFor[1][1] ; Window titles/classes and process names to search for
Global $MaxMinutes ; Maximum number of user-specified minutes to suspend screensaver
Global $ShowChange ; Indicates whether or not to use taskbar popups to show changes to screensaver state
Global $RegAction ; Records whether registry parameter was specified - and if so, what it was
Global $DebugItem ; Records whether to provide more detailed "debugging" type messages

Global $Active ; Indicates whether screensaver should be reactivated on exit
Global $TimedOut ; Indicates that suspension timed-out due to -minutes parm
Global $SuspendedSince ; Time how long screensaver has been suspended
Global $TooltipSince ; Time how long tooltip has been displayed
Global $Uninstalled ; flags whether program has just been uninstalled

Global $ExitItem ; Tray menuitem
Global $AboutItem ; Tray menuitem
Global $UninstallItem ; Tray menuitem
Global $ShowChangeItem ; Tray menuitem
Global $AddItemMenu ; Tray menuitem
Global $AddItem_Title ; Tray menuitem
Global $AddItem_Class ; Tray menuitem
Global $AddItem_Process ; Tray menuitem

Const $Icon_Default = 3 ; Number of icons AutoIt adds to .exe
if @Compiled Then ; Icons are added to .EXE file
	Const $IconActive = $Icon_Default
	const	$IconSuspended = $IconActive + 1
Else
	Const $IconActive = @ScriptDir & "\" & $ScriptName & " - Active.ico"
	Const $IconSuspended = @ScriptDir & "\" & $ScriptName & " - Suspended.ico"
EndIf

; Process command line
$ShowChange = (RegRead($RegKey, $RegShowChange) = "1")
If $CmdLine[0] > 0 Then
	$SearchFor = GetParameters(StringMid($CmdLineRaw, StringInStr($CmdLineRaw, StringLeft($CmdLine[1],3))))
	$SearchFor = ValidateParameters($SearchFor)
Else
	$SearchFor[0][0] = 0
EndIf

if ($SearchFor[0][0] + $MaxMinutes) = 0 then ; no windows/processes and no minutes parms - see if should install ...
	if $Uninstalled Then
		MsgBox(64, $ScriptNameVersion & " - uninstalled", $ScriptName & " has been uninstalled.", 30)
		Exit
	Else
		$Response = MsgBox(4 + 32 + 256, $ScriptNameVersion & " - Install/Re-Install?", _
											"Run with -help option to get usage information." & @CRLF & @CRLF & _
											"Install/Re-Install in startup folder - with suspends for Powerpoint, NetMeeting and HP Virtual Rooms?", 60)
		if $Response = 7 Then Exit
		InstallMe()
		$SearchFor = GetParameters("-registry:add")
		$SearchFor = ValidateParameters($SearchFor)
	EndIf
EndIf

; Check if script already running - stop previous version if so ...
$SuspendedSince = TimerInit()
While WinExists($ScriptNameVersion) and (TimerDiff($SuspendedSince) < (30 * 1000))
	WinClose($ScriptNameVersion)
	Sleep(1000)
WEnd
If WinExists($ScriptNameVersion) Then
	MsgBox(16, "Error Exit", "There is another instance of this program already running. Unable to close it - this instance closing.", 5)
	Exit 2
EndIf
AutoItWinSetTitle($ScriptNameVersion)

; Check if screensaver enabled - cannot suspend if not enabled
$Active = IsSaverActive()
If Not $Active Then
	$Response = MsgBox(4 + 32 + 256, "Activate Screensaver?", "Screensaver is not currently turned on. " & $ScriptName & _
	          " cannot work correctly unless screensaver is turned on. Turn on now?", 30)
	if $Response = 7 then exit ; user chose No
	SuspendSaver(False, True)
	$Active = True
EndIf

; Setup tray icon
AutoItSetOption("TrayAutoPause", 0)	
AutoItSetOption("TrayMenuMode", 1)	
$AboutItem = TrayCreateItem("About")
TrayItemSetState($AboutItem, 512) ; Default item
$UninstallItem = TrayCreateItem("Uninstall")
TrayCreateItem("")
$AddItemMenu = TrayCreateMenu("Add item")
$AddItem_Title = TrayCreateItem("Window Title", $AddItemMenu)
$AddItem_Class = TrayCreateItem("Window Class", $AddItemMenu)
$AddItem_Process = TrayCreateItem("Process Name", $AddItemMenu)
$ShowChangeItem = TrayCreateItem("Show screensaver changes")
ShowChanges($ShowChange) ; Update menu/registry
TrayCreateItem("")
$ExitItem = TrayCreateItem("Exit")
SuspendSaver(False)
TraySetState(1)
TraySetToolTip($ScriptName)

; Main loop - scan for windows/processes, and respond to messages
$SuspendedSince = 0
$begin = TimerInit()
While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = 0 ; no event waiting - process active windows/processes (default once every 5 seconds)
			If TimerDiff($begin) > ($CheckEverySeconds * 1000) Then
				CheckSuspend()
				$begin = TimerInit() ; reset the timer to check windows/processes
			EndIf
			if timerdiff($TooltipSince) > ($TooltipTime * 1000) Then TrayTip("","",5)
		Case $msg = $AboutItem
			MsgBox(64, $ScriptNameVersion & " - About", $Help, 60)
		Case $msg = $UninstallItem
			$Response = MsgBox(4 + 32 + 256, "Uninstall?", "Uninstall" & $ScriptName & "?", 30)
			if $Response = 6 then UnInstallMe()
			ExitLoop
		Case $msg = $AddItem_Title
			AddItem("title")
		Case $msg = $AddItem_Class
			AddItem("class")
		Case $msg = $AddItem_Process
			AddItem("process")
		Case $msg = $ShowChangeItem
			ShowChanges(Not $ShowChange) ; Update menu/registry
		Case $msg = $ExitItem
			ExitLoop
	EndSelect
	if $TimedOut and ($SearchFor[0][0] = 0) and ($MaxMinutes > 0) then ExitLoop ; only minutes given - and timed out
WEnd

Exit

; make sure screensaver is enabled on exit
Func OnAutoItExit()
	$ShowChange = False
	If $Active then SuspendSaver(False)
EndFunc

; Suspend/resume & screensaver stuff
; *********************************************************************************************************************

; Check windows/processes for matches. If match found, suspend screensaver. If not, resume screensaver.
Func CheckSuspend()
	Local $windows, $processes, $classlist
	Local $found = False
	$windows = WinList()
	$processes = ProcessList()
	for $i = 1 to $SearchFor[0][0]
		Switch $SearchFor[$i][0]
			case "title"
				for $j = 1 to $windows[0][0]
					If $windows[$j][0] = "" then ContinueLoop
					switch StringLeft($SearchFor[$i][1], 1)
						case '"'
							if StringInStr($windows[$j][0], StringMid($SearchFor[$i][1], 2)) then
								$found = True
								if $DebugItem and $SuspendedSince = 0 Then MsgBox(64, "DEBUG", "Found window " & $SearchFor[$i][0] & " match for " & $SearchFor[$i][1] & @CRLF & $windows[$j][0], 10)
								ExitLoop
							EndIf
						case "'"
							$matched = StringRegExp($windows[$j][0], StringMid($SearchFor[$i][1], 2), 0)
              if @error <> 0 Then
								MsgBox(48, "Problem", "Trying to patternmatch using bad pattern " & StringMid($SearchFor[$i][1], 2) & "', pattern position " & @extended & ". Will delete pattern from monitoring.", 10)
								$SearchFor[$i][1] = ""
							ElseIf $matched > 0 then
								$found = True
								if $DebugItem and $SuspendedSince = 0 Then MsgBox(64, "DEBUG", "Found window " & $SearchFor[$i][0] & " regexp match for " & $SearchFor[$i][1] & @CRLF & $windows[$j][0], 10)
								ExitLoop
							EndIf
					EndSwitch
				next
			case "process"
				for $j = 1 to $processes[0][0]
					If $processes[$j][0] = "" then ContinueLoop
					switch StringLeft($SearchFor[$i][1], 1)
						case '"'
							if StringInStr($processes[$j][0], StringMid($SearchFor[$i][1], 2), 0) then
								$found = True
								if $DebugItem and $SuspendedSince = 0 Then MsgBox(64, "DEBUG", "Found window " & $SearchFor[$i][0] & " match for " & $SearchFor[$i][1] & @CRLF & $windows[$j][0], 10)
								ExitLoop
							EndIf
						case "'"
							$matched = StringRegExp($processes[$j], StringMid($SearchFor[$i][1], 2))
              if @error <> 0 Then
								MsgBox(48, "Problem", "Trying to patternmatch using bad pattern " & $SearchFor[$i][1] & "', pattern position " & @extended & ". Will delete pattern from monitoring.", 10)
								$SearchFor[$i][1] = ""
							ElseIf $matched > 0 then
								$found = True
								if $DebugItem and $SuspendedSince = 0 Then MsgBox(64, "DEBUG", "Found window " & $SearchFor[$i][0] & " regexp match for " & $SearchFor[$i][1] & @CRLF & $windows[$j][0], 10)
								ExitLoop
							EndIf
					EndSwitch
				next
			case "class"
				for $j = 1 to $windows[0][0]
					If $windows[$j][0] = "" then ContinueLoop
					$classlist = WinGetClassList($windows[$j][1])
					if $classlist = "" then ContinueLoop
					switch StringLeft($SearchFor[$i][1], 1)
						case '"'
							if StringInStr($classlist, StringMid($SearchFor[$i][1], 2)) then
								$found = True
								if $DebugItem and $SuspendedSince = 0 Then MsgBox(64, "DEBUG", "Found window " & $SearchFor[$i][0] & " match for " & $SearchFor[$i][1] & @CRLF & $windows[$j][0], 10)
								ExitLoop
							EndIf
						case "'"
							$matched = StringRegExp($classlist, StringMid($SearchFor[$i][1], 2), 0)
              if @error <> 0 Then
								MsgBox(48, "Problem", "Trying to patternmatch using bad pattern " & $SearchFor[$i][1] & "', pattern position " & @extended & ". Will delete pattern from monitoring.", 10)
								$SearchFor[$i][1] = ""
							ElseIf $matched > 0 then
								$found = True
								if $DebugItem and $SuspendedSince = 0 Then MsgBox(64, "DEBUG", "Found window " & $SearchFor[$i][0] & " regexp match for " & $SearchFor[$i][1] & @CRLF & $windows[$j][0], 10)
								ExitLoop
							EndIf
					EndSwitch
				next
		EndSwitch
		if $found then ExitLoop
	Next
	if $SearchFor[0][0] = 0 and $MaxMinutes > 0 then $found = True ; suspend if only parameter is minutes
	
	; If something found, then suspend (or continue to suspend) the screensaver. If not, resume it
	if $found and ($SuspendedSince = 0) Then ; suspend the screensaver
		$SuspendedSince = TimerInit()
		SuspendSaver(True)
	ElseIf ($found and ($MaxMinutes > 0) and ((TimerDiff($SuspendedSince) / 1000 / 60) > $MaxMinutes)) or _
				 ((not $found) and ($SuspendedSince > 0)) Then ; resume the screensaver
		if $found then
			$TimedOut = True ; indicate we resumed due to exceeding -minutes parameter
		Else
			$TimedOut = False ; indicate we resumed due to not finding window/process
			$SuspendedSince = 0
		EndIf
		SuspendSaver(False)
	EndIf
		
EndFunc
	
Func SuspendSaver($Suspend, $Permanent = False)
	if Not IsBool($Suspend) Then
		MsgBox(16, "Error Exit", "Expected boolean to suspend or resume the screensaver.", 5)
		Exit 2
	EndIf
	Dim $PermFlags
  If $Permanent Then $PermFlags	= $SPIF_UPDATEINIFILE + $SPIF_SENDCHANGE
	if $Suspend Then
		_API_SystemParametersInfo($SPI_SETSCREENSAVEACTIVE, False, 0, $PermFlags)
		TraySetToolTip($ScriptName & " - Screensaver suspended")
		if IsNumber($IconSuspended) then
			TraySetIcon(@ScriptFullPath, $IconSuspended)
		Else
			TraySetIcon($IconSuspended)
		EndIf
		if $ShowChange Then TrayTip($ScriptName, "Screensaver suspended", $TooltipTime)
	Else
		_API_SystemParametersInfo($SPI_SETSCREENSAVEACTIVE, True, 0, $PermFlags)
		TraySetToolTip($ScriptName & " - Screensaver active")
		if IsNumber($IconActive) then
			TraySetIcon(@ScriptFullPath, $IconActive)
		Else
			TraySetIcon($IconActive)
		EndIf
		if $ShowChange Then TrayTip($ScriptName, "Screensaver active", $TooltipTime)
	EndIf
	TraySetState(1)	
	$TooltipSince = TimerInit()
EndFunc

; Returns True if screensaver is active - note this is different than saver actually running ...
Func IsSaverActive()
	Local $pBool, $tBool
  $tBool = DllStructCreate("int Result")
	$pBool = DllStructGetPtr($tBool)
  _API_SystemParametersInfo($SPI_GETSCREENSAVEACTIVE, 0, $pBool)
  Return DllStructGetData($tBool, "Result")
EndFunc

; Keeps the program, interface and registry in sync for the "Show Changes" option
Func ShowChanges($ShowChanges, $UpdateMenu = True, $WriteReg = True)
	if IsBool($ShowChanges) Then
		$ShowChange = $ShowChanges
		if $UpdateMenu Then
			If $ShowChange Then
				TrayItemSetState($ShowChangeItem, 1) ; Checked
			Else
				TrayItemSetState($ShowChangeItem, 4) ; Unchecked
			EndIf
		EndIf
		if $WriteReg Then
			If $ShowChange Then
				RegWrite($RegKey, $RegShowChange, "REG_SZ", "1")
			Else
				RegWrite($RegKey, $RegShowChange, "REG_SZ", "0")
			EndIf
		EndIf
	EndIf
EndFunc

; Command line / Parameters
; *********************************************************************************************************************

; Process the command line and return the parameters and parameter values
Func GetParameters($CmdLineParameters)
	Enum $gpOther, $gpParm, $gpParmValue, $gpStrDq, $gpStrSq, $gpNum, $gpAlphaNum ; state values
	Local $parms[10][2]
	Local $parmName = "", $parmValue = ""
	Local $state = $gpOther
	Local $i = 1, $char = GetChar($CmdLineParameters, $i)
	$parms[0][0] = 0
	While $char <> ""
		Switch $state
			case $gpOther ; processing whitespace between parameters
				switch $char
					Case " ", @TAB
					Case "-", "/"
						$state = $gpParm
					Case Else
						MsgBox(16, "Error Exit", "Expecting parameter in command-line parameters '" & $CmdLineParameters & "' at character position " & $i & " (" & $char & ").", 5)
						Exit 1
				EndSwitch
			case $gpParm ; processing parameter name
				select
					Case StringIsLower(StringLower($char))
						$parmName &= StringLower($char)
					Case StringIsDigit($char)
						$parmName &= $char
					Case $char = ":"
						$state = $gpParmValue
					Case $char = "?"
						$parmName = "?"
						ContinueCase
					Case $char = " " Or $char = @TAB
						; parameter name with no value - add the parameter to results table
						AddParm($parms, $parmName, $parmValue)
						$state = $gpOther
					Case Else
						MsgBox(16, "Error Exit", "Expecting whitespace or parameter value in command-line parameters '" & $CmdLineParameters & "' at character position " & $i & " (" & $char & ").", 5)
						Exit 1
				EndSelect
			Case $gpParmValue ; processing parameter value
				switch $char
					Case '"'
						$parmValue = '"'
						$state = $gpStrDq
					case "'"
						$parmValue = "'"
						$state = $gpStrSq
					case "0" to "9"
						$state = $gpNum
						$parmValue &= $char
					case Else
						if StringIsLower(StringLower($char)) Then
							$state = $gpAlphaNum
							$parmValue &= $char
						Else
							MsgBox(16, "Error Exit", "Expecting parameter value following ':' in command-line parameters '" & $CmdLineParameters & "' at character position " & $i & " (" & $char & ").", 5)
							Exit 1
						EndIf
				EndSwitch
			Case $gpStrDq ; processing double-quoted string
				switch $char
					case '"'
						if GetChar($CmdLineParameters, $i + 1) = '"' Then ; double double quotes, skip past them
							$parmValue &= $char & $char
							$i += 1
						Else ; end of double quoted string ... add parameter and value to results table
							$parmValue = AdjustString($parmValue)
							AddParm($parms, $parmName, $parmValue)
							$state = $gpOther
						EndIf
					case Else
						$parmValue &= $char
				EndSwitch
			Case $gpStrSq ; processing single-quoted string
				switch $char
					case "'"
						if GetChar($CmdLineParameters, $i + 1) = "'" Then ; double single quotes, skip past them
							$parmValue &= $char & $char
							$i += 1
						Else ; end of single quoted string ... add parameter and value to results table
							$parmValue = AdjustString($parmValue)
							AddParm($parms, $parmName, $parmValue)
							$state = $gpOther
						EndIf
					case Else
						$parmValue &= $char
				EndSwitch
			Case $gpNum ; processing number (positive integer)
				Switch $char
					Case "0" to "9"
						$parmValue &= $char
					case Else
						Switch $char
							case " ", @TAB
								AddParm($parms, $parmName, $parmValue)
								$state = $gpOther
							case Else
								MsgBox(16, "Error Exit", "Expecting whitespace after numeric parameter value in command-line parameters '" & $CmdLineParameters & "' at character position " & $i & " (" & $char & ").", 5)
								Exit 1
						EndSwitch
				EndSwitch
			Case $gpAlphaNum ; processing alpha string
				Select
				  Case StringIsLower(StringLower($char))
						$parmValue &= $char
					Case StringIsDigit($char)
						$parmValue &= $char
					case Else
						switch $char
							case " ", @tab
								AddParm($parms, $parmName, $parmValue)
								$state = $gpOther
							case Else
								MsgBox(16, "Error Exit", "Expecting whitespace after alphanumeric parameter value in command-line parameters '" & $CmdLineParameters & "' at character position " & $i & " (" & $char & ").", 5)
								Exit 1
						EndSwitch
				EndSelect
		EndSwitch
		$i += 1
		$char = GetChar($CmdLineParameters, $i)
	WEnd

	; Check for any remaining parameter/value to add
	switch $state
		case $gpParm, $gpAlphaNum, $gpNum
			AddParm($parms, $parmName, $parmValue)
		case $gpStrDq, $gpStrSq
			MsgBox(16, "Error Exit", "Unterminated string in command-line parameters: " & $CmdLineParameters, 5)
			Exit 1
	EndSwitch
			
	; Return results table
	ReDim $parms[$parms[0][0] + 1][2]
	Return $parms
	
EndFunc

Func GetChar($CmdLineParameters, $i)
	if ($i < 1) or ($i > stringlen($CmdLineParameters)) Then
		Return ""
	Else
		return stringmid($CmdLineParameters, $i, 1)
	EndIf
EndFunc

Func AdjustString($parmValue)
	Local $char
	Switch StringLeft($parmValue, 1)
		Case '"', "'"
			$char = StringLeft($parmValue, 1)
			$parmValue = StringMid($parmValue, 2)
		Case Else
			$char = '"'
	EndSwitch
	if StringRight($parmValue, 1) = $char Then $parmValue = StringLeft($parmValue, StringLen($parmValue) - 1)
	$parmValue = $char & StringReplace($parmValue, $char & $char, $char)
	Return $parmValue
EndFunc

Func AddParm(ByRef $parms, ByRef $parmName, ByRef $parmValue)
	$parms[0][0] += 1
	if $parms[0][0] >= UBound($parms) then redim $parms[UBound($parms)+10][2]		
	$parms[$parms[0][0]][0] = $parmName
	if $parmValue <> "" then $parms[$parms[0][0]][1] = $parmValue
	$parmName = ""
	$parmValue = ""
EndFunc

; Reprocess and validate the parameters/values, using/updating registry if specified
Func ValidateParameters($parms)
	Local $i, $newParms[10][2], $parmName
	; Reprocess and validate parms 
	$newParms[0][0] = 0
	For $i = 1 to $parms[0][0]
		Select 
			case (StringInStr("title", StringLower($parms[$i][0]))) = 1
				$parmName = "title"
				Select
					Case $parms[$i][1] = ""
						MsgBox(16, "Error Exit", "Expecting parameter value for " & $parmName & " parameter.", 5)
						Exit 1
					Case StringLeft($parms[$i][1], 1) = "'"
					Case StringLeft($parms[$i][1], 1) = '"'
					Case Else
						$parms[$i][1] = '"' & $parms[$i][1]
				EndSelect
				AddParm($newParms, $parmName, $parms[$i][1])
			case (StringInStr("class", StringLower($parms[$i][0]))) = 1
				$parmName = "class"
				Select
					Case $parms[$i][1] = ""
						MsgBox(16, "Error Exit", "Expecting parameter value for " & $parmName & " parameter.", 5)
						Exit 1
					Case StringLeft($parms[$i][1], 1) = "'"
					Case StringLeft($parms[$i][1], 1) = '"'
					Case Else
						$parms[$i][1] = '"' & $parms[$i][1]
				EndSelect
				AddParm($newParms, $parmName, $parms[$i][1])
			case (StringInStr("process", StringLower($parms[$i][0]))) = 1
				$parmName = "process"
				Select
					Case $parms[$i][1] = ""
						MsgBox(16, "Error Exit", "Expecting parameter value for " & $parmName & " parameter.", 5)
						Exit 1
					Case StringLeft($parms[$i][1], 1) = "'"
					Case StringLeft($parms[$i][1], 1) = '"'
					Case Else
						$parms[$i][1] = '"' & $parms[$i][1] 
				EndSelect
				AddParm($newParms, $parmName, $parms[$i][1])
			case (StringInStr("minutes", StringLower($parms[$i][0]))) = 1
				$parmName = "minutes"
				If $parms[$i][1] = "" Then
					MsgBox(16, "Error Exit", "Expecting parameter value for " & $parmName & " parameter.", 5)
					Exit 1
				EndIf
				$MaxMinutes = _min(_max(Int($parms[$i][1]), 0), 24 * 60)
			case (StringInStr("showchange", StringLower($parms[$i][0]))) = 1
				$parmName = "showchange"
				ShowChanges(True, False) ; Update registry only
			case (StringInStr("registry", StringLower($parms[$i][0]))) = 1
				Select
					case $parms[$i][1] = ""
						$RegAction = "use"
					case (StringInStr("add", StringLower($parms[$i][1]))) = 1
						$RegAction = "add"
					case (StringInStr("replace", StringLower($parms[$i][1]))) = 1
						$RegAction = "replace"
					case (StringInStr("clear", StringLower($parms[$i][1]))) = 1
						$RegAction = "clear"
					case Else
						MsgBox(16, "Error Exit", "Unrecognised parameter value for registry parameter '" & $parms[$i][1] & "'.", 5)
						Exit 1
				EndSelect
			case (StringInStr("install", StringLower($parms[$i][0]))) = 1
				InstallMe()
			case (StringInStr("uninstall", StringLower($parms[$i][0]))) = 1
				UnInstallMe()
			case (StringInStr("?", StringLower($parms[$i][0]))) = 1
				ContinueCase
			case (StringInStr("help", StringLower($parms[$i][0]))) = 1
				MsgBox(64, $ScriptNameVersion & " - Usage Information", $Help, 60)
			case (StringInStr("debug", StringLower($parms[$i][0]))) = 1
				$DebugItem = True
			case Else
				MsgBox(16, "Error Exit", "Unrecognised command-line parameter '" & $parms[$i][0] & "'.", 5)
				Exit 1
		EndSelect
	Next
	
	; process any registry actions
	Switch $RegAction
		Case "use"
			ReadRegEntries($newParms)
		Case "add"
			WriteRegEntries($newParms)
			ReadRegEntries($newParms)
		Case "replace"
			DeleteRegEntries()
			WriteRegEntries($newParms)
			ReadRegEntries($newParms)
		Case "clear"
			DeleteRegEntries()
	EndSwitch

	; return validated parameters + parameters from registry (if specified)
	ReDim $newParms[$newParms[0][0] + 1][2]
	Return $newParms
	
EndFunc

; Add an item to monitor, and save in registry if registry parm was specified
Func AddItem($parmName)
	Local $parmValue
	$parmValue = InputBox("Add item", "Enter the window title/class or process name to watch for", "", "", -1, -1, -1, -1, 120)
	if $parmValue <> "" Then
		switch StringLeft($parmValue, 1)
			case '"', "'"
			case Else
				$parmValue = '"' & $parmValue
		EndSwitch
		$parmValue = AdjustString($parmValue)
		; Add to monitor list
		AddParm($SearchFor, $parmName, $parmValue)
		; Save to registry
		Switch $RegAction
			case "use", "add", "replace"
				WriteRegEntries($SearchFor)
		EndSwitch
	EndIf
EndFunc

; Registry stuff
; *********************************************************************************************************************

; Reads the registry entries into the $parms array
Func ReadRegEntries(ByRef $parms)
	Local $parmName, $parmValue, $parmCount
	$parmCount = RegRead($RegKey, "")
	for $i = 1 To int($parmCount)
		$parmName = RegRead($RegKey, StringFormat($RegName, $i))
		$parmValue = RegRead($RegKey, StringFormat($RegValue, $i))
		if $parmName <> "" Then AddParm($parms, $parmName, $parmValue)
	Next
EndFunc

; Saves the $parms array into the registry
Func WriteRegEntries($parms)
	Local $regParms[10][2], $regCount, $found
	ReadRegEntries($regParms)
	$regCount = $regParms[0][0]
	for $i = 1 To $parms[0][0]
		$found = False
		for $j = 1 to $regParms[0][0]
			if ($parms[$i][0] = $regParms[$j][0]) and _
				 ($parms[$i][1] = $regParms[$j][1]) then
			  $found = True
			  ExitLoop
		  EndIf
		Next 
		if not $found Then
			$regCount += 1
			RegWrite($RegKey, StringFormat($RegName, $regCount), "REG_SZ", $parms[$i][0])
			RegWrite($RegKey, StringFormat($RegValue, $regCount), "REG_SZ", $parms[$i][1])
			RegWrite($RegKey, "", "REG_SZ", $regCount)
		EndIf
	Next
EndFunc

; Delete registry entries
Func DeleteRegEntries()
	RegDelete($RegKey)
EndFunc

; Install/Uninstall
; *********************************************************************************************************************

; Install shortcut and add registry entries
Func InstallMe()
	; Create shortcut
	If FileExists(@StartupDir & "\" & $ScriptName & ".lnk") Then FileDelete(@StartupDir & "\" & $ScriptName & ".lnk")
	FileCreateShortcut(@ScriptFullPath, @StartupDir & "\" & $ScriptName & ".lnk", "", "-registry:add", $ScriptNameVersion)
	; Add registry entries
	Local $installParms[10][2], $parmName, $parmValue
	$parmName = "title"
	$parmValue = """PowerPoint Slide Show -"
	AddParm($installParms, $parmName, $parmValue) ; .PPT slideshow
	$parmName = "title"
	$parmValue = "'NetMeeting.+?Connection.*"
	AddParm($installParms, $parmName, $parmValue) ; NetMeeting - in a call
	$parmName = "process"
	$parmValue = """HPVirtualRooms.exe"
	AddParm($installParms, $parmName, $parmValue) ; HP Virtual Rooms - in a room
	; **** Check NetMeeting and add HP virtual classroom
	WriteRegEntries($installParms)
EndFunc

; Delete shortcut and registry entries
Func UnInstallMe()
	; Delete shortcut
	FileDelete(@StartupDir & "\" & $ScriptName & ".lnk")
	; Delete registry entries
	DeleteRegEntries()
	$Uninstalled = True
EndFunc