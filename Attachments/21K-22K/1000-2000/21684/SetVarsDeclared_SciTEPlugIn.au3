#cs
Hi,
everyone knows this situation: you write only a "little" script and you mean, that these few vars don't need a declaration. But urgently your script starts to increase :D .
Now it's better to declare your vars, to keep track of this. 
The following script scans your currently in SciTE opened file. (For non-SciTE-users, i've made a stand-alone version.)
Opt("MustDeclareVars", 1) will set and Variables will declared as Global if they:
- no parameter in functions
- not declared in Local scope
- not already declared with "Dim" or "Global"
- no AutoIt-constants (you can change between Prod or Beta -Includes)
- not inside comments
After your last "#include.." or if exists after last "Opt(..)" will be written: Opt("MustDeclareVars", 1) and the declaration of all matched vars.
By default are counter-vars in an loop are Local. But all vars, that are not declared as Local inside an function, will declared as Global. It's unnecessary for these counter-vars, but i think that does no harm.

To start the script in SciTE you need an entry in [b]SciTEUser.properties[/b]. The script runs with one or two parameters. Parameter1 is "$(FilePath)" and includes automatically the current opened au3-file. Parameter2 is "Beta" (optional) and only needed, if you use the Beta.
Copy the script in an path you want. In my example it's: "$(SciteDefaultHome)\OtherTools\SetVarsDeclared_SciTEPlugIn.au3". Insert here your own path.
Choose an shortcut (i.e. Ctrl+Alt+V) and insert all in SciTEUser.properties. I've used number [b]42[/b] here. If you haven't own entries you can use number [b]36[/b], otherwise use next number.
[b]# 42 DeclareVars
command.42.*.au3="$(autoit3dir)\AutoIt3.exe" "$(SciteDefaultHome)\OtherTools\SetVarsDeclared_SciTEPlugIn.au3" "$(FilePath)" "Beta"
command.name.42.*.au3=Declare Vars
command.save.before.42.*.au3=1
command.is.filter.42.*.au3=1
command.shortcut.42.*.au3=Ctrl+Alt+V[/b]

For non-SciTE-users are the script "SetVarsDeclared_alone.au3". 
The script starts with an small GUI to choose the file to scan and select "Beta", if in use. By hit button "Start" will selected file scanned and vars declared like in SciTE-PlugIn before.
#ce
; Version 3.2.12.0
#include<ProgressConstants.au3>
#include<StaticConstants.au3>
#include<GUIConstantsEx.au3>
#include<WindowsConstants.au3>
#include<File.au3>
Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)

Global $aLang[4][2] = [ _
['Fehler', 'Error'], _
['SciTE nicht aktiv!', 'SciTE not active!'], _
['  << Variablendeklaration erfolgreich beendet. >>', '  << Variables successful declared. >>'], _
['  << Alle Variablen bereits deklariert! >>', '  << All variables already declared! >>']], $iLang = 0
If Not StringInStr("0407,0807,0c07,1007,1407", @OSLang) Then $iLang = 1

If Not ProcessExists('SciTE.exe') Then Exit MsgBox(262192, $aLang[0][$iLang], $aLang[1][$iLang])
If $CmdLine[0] Then  
	Global $File2Scan = $CmdLine[1]
	If $CmdLine[0] > 1 Then
		If $CmdLine[2] = 'Beta' Then
			Global $BetaUse = True
		Else
			Global $BetaUse = False
		EndIf
	Else
		Global $BetaUse = False
	EndIf
Else
	Exit
EndIf
Global $GUI, $progress, $lbl, $prog_val = 0, $step

$GUI = GUICreate($File2Scan, 640, 100, -1, 120)
$progress = GUICtrlCreateProgress(10, 15, 620, 20, $PBS_SMOOTH)
$lbl = GUICtrlCreateLabel('', 290, 50, 60, 17, $SS_CENTER)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIClose")
GUISetState(@SW_SHOW)

If _SetVarsDeclared($File2Scan, $BetaUse) = 0 Then 
	WinSetTitle($GUI, '', $aLang[2][$iLang])
Else
	WinSetTitle($GUI, '', $aLang[3][$iLang])
EndIf

While 1
	Sleep(100)
WEnd

Func GUIClose()
	Exit
EndFunc

Func _SetVarsDeclared($FILE, $BETA=False)
	Local $oVars     = ObjCreate('System.Collections.ArrayList')
	Local $oFuncVars = ObjCreate('System.Collections.ArrayList')
	Local $oConst    = ObjCreate('System.Collections.ArrayList')
	Local $oDeclared = ObjCreate('System.Collections.ArrayList')
	Local $skip = False, $PathInclude, $1stChar, $inFunc = False, $aFile, $aMatch, $var, $strKey, $lastInclude = 1
	Local $str0 = 'Opt("MustDeclareVars", 1)', $str1 = 'Global ', $sLen, $len = 130, $tmp, $keys, $lastOpt = 1, $declare = 0
	If $BETA Then
		$PathInclude = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt', 'betaInstallDir') & '\Include\'
	Else
		$PathInclude = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt', 'InstallDir') & '\Include\'
	EndIf
	Local $aConst_au3 = _FileListToArray($PathInclude, '*.au3', 1)
	$step = 33/UBound($aConst_au3)
	For $i = 1 To UBound($aConst_au3) -1
		$prog_val += $step
		GUICtrlSetData($progress, Int($prog_val))
		GUICtrlSetData($lbl, StringFormat('%3.2f', $prog_val) & '%')
		If Not StringInStr($aConst_au3[$i], 'constants') Then ContinueLoop
		_FileReadToArray($PathInclude & $aConst_au3[$i], $aFile)
		For $k = 1 To UBound($aFile) -1
			$aMatch = StringRegExp($aFile[$k], '\$[\d\w]+', 3)
			If Not IsArray($aMatch) Then ContinueLoop
			For $l = 0 To UBound($aMatch) -1
				If Not $oConst.Contains($aMatch[$l]) Then $oConst.Add($aMatch[$l])
			Next
		Next
	Next
	GUICtrlSetData($progress, 33)
	GUICtrlSetData($lbl, '33.00%')
	_FileReadToArray($FILE, $aFile)
	$tmp = FileRead($FILE)
	Local $pos_incl, $pos_opt, $before_str
	If (StringInStr($tmp, '#include')) Or (StringInStr($tmp, 'Opt')) Then
		For $i = 1 To UBound($aFile) -1
			$1stChar = StringLeft(StringStripWS($aFile[$i],1), 1)
			If ($1stChar <> ';') And (StringInStr($aFile[$i], '#cs') Or StringInStr($aFile[$i], '#comments-start')) Then $skip = True
			If ($1stChar <> ';') And (StringInStr($aFile[$i], '#ce') Or StringInStr($aFile[$i], '#comments-end')) Then $skip = False
			If $skip Then ContinueLoop
			If StringRegExp($aFile[$i], "(?i)#include") Then
				$pos_incl = StringInStr($aFile[$i], '#include')
				If $pos_incl > 1 Then
					$before_str = StringLeft($aFile[$i], $pos_incl-1) ; maybe quoted - don't use then
					If StringInStr($before_str, '"') Or StringInStr($before_str, "'") Then ContinueLoop
				EndIf
				$lastInclude = $i
			ElseIf StringRegExp($aFile[$i], "(?i)opt") Then
				$pos_opt = StringInStr($aFile[$i], 'opt')
				If $pos_opt > 1 Then
					$before_str = StringLeft($aFile[$i], $pos_opt-1) ; maybe quoted - don't use then
					If StringInStr($before_str, '"') Or StringInStr($before_str, "'") Then ContinueLoop
				EndIf
				$lastOpt = $i
			EndIf
		Next
		If $lastOpt > $lastInclude Then $lastInclude = $lastOpt
	EndIf
	$step = 67/UBound($aFile)
	For $i = 1 To UBound($aFile) -1
		$prog_val += $step
		GUICtrlSetData($progress, Int($prog_val))
		GUICtrlSetData($lbl, StringFormat('%3.2f', $prog_val) & '%')
		$1stChar = StringLeft(StringStripWS($aFile[$i],1), 1)
		If $1stChar = ';' Then ContinueLoop
		If StringInStr($aFile[$i], 'Dim') Or StringInStr($aFile[$i], 'Global') Then
			$aMatch = StringRegExp($aFile[$i], '\$[\d\w]+', 3)
			If Not IsArray($aMatch) Then ContinueLoop
			For $k = 0 To UBound($aMatch) -1
				If Not $oDeclared.Contains($aMatch[$k]) Then $oDeclared.Add($aMatch[$k])
			Next
			ContinueLoop
		EndIf
		If StringInStr($aFile[$i], '#cs') Or StringInStr($aFile[$i], '#comments-start') Then $skip = True
		If StringInStr($aFile[$i], '#ce') Or StringInStr($aFile[$i], '#comments-end') Then $skip = False
		If $skip Or ($1stChar = '#') Then ContinueLoop
		If StringLeft(StringStripWS($aFile[$i],1),4) = 'Func' Then 
			$inFunc = True
			If $oFuncVars.Count > 0 Then $oFuncVars.Clear
			$aMatch = StringRegExp($aFile[$i], '\$[\d\w]+', 3)
			If Not IsArray($aMatch) Then ContinueLoop
			For $k = 0 To UBound($aMatch) -1
				If Not $oFuncVars.Contains($aMatch[$k]) Then $oFuncVars.Add($aMatch[$k])
			Next
			ContinueLoop
		EndIf
		If $inFunc And (StringLeft(StringStripWS($aFile[$i],1),7) = 'EndFunc') Then $inFunc = False
		$aMatch = StringRegExp($aFile[$i], '\$[\d\w]+', 3)
		If Not IsArray($aMatch) Then ContinueLoop
		If $inFunc And StringInStr($aFile[$i], 'Local') Then
			For $k = 0 To UBound($aMatch) -1
				$oFuncVars.Add($aMatch[$k])
			Next
			ContinueLoop
		EndIf
		For $k = 0 To UBound($aMatch) -1
			If (Not $oVars.Contains($aMatch[$k])) And _
			   (Not $oFuncVars.Contains($aMatch[$k])) Then $oVars.Add($aMatch[$k])
		Next
	Next
	GUICtrlSetData($progress, 98)
	GUICtrlSetData($lbl, '98.00%')
	For $strKey In $oConst
		If $oVars.Contains($strKey) Then $oVars.Remove($strKey)
	Next
	For $strKey In $oDeclared
		If $oVars.Contains($strKey) Then $oVars.Remove($strKey)
	Next
	$oVars.Sort
	If $oVars.Count > 0 Then 
		For $strKey In $oVars
			$sLen = StringLen($str1 & $strKey & ', ')
			If $sLen < $len Then
				$str1 &= $strKey & ', '
			Else
				$str1 = StringTrimRight($str1, 2) & @LF & 'Global '
				$len += 130
			EndIf
		Next
		If StringRight($str1, 2) = ', ' Then $str1 = StringTrimRight($str1, 2)
		If StringRight($str1, 7) = 'Global ' Then $str1 = StringTrimRight($str1, 7)
		If $declare = 0 Then
			_FileWriteToLine($FILE, $lastInclude +1, $str0 & @CRLF & $str1)
		Else
			_FileWriteToLine($FILE, $declare, $str0, 1)
			_FileWriteToLine($FILE, $lastInclude +1, $str1)
		EndIf
		GUICtrlSetData($progress, 100)
		GUICtrlSetData($lbl, '100.00%')
		Return 0
	Else
		GUICtrlSetData($progress, 100)
		GUICtrlSetData($lbl, '100.00%')
		Return -1
	EndIf
EndFunc  ;==> _SetVarsDeclared
