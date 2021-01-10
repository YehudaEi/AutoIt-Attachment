; Version 3.2.12.0
#include<ProgressConstants.au3>
#include<StaticConstants.au3>
#include<EditConstants.au3>
#include<GUIConstantsEx.au3>
#include<WindowsConstants.au3>
#include<File.au3>
Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)
Global $Skript, $Form1, $Group1, $Input1, $Button1, $Button2, $check, $checked = False, $step, $prog_val = 0, $progress, $lbl

$Form1 = GUICreate('Declare Vars, Opt("MustDeclareVars", 1)', 634, 125, -1, 120)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Group1 = GUICtrlCreateGroup(" au3 - File ", 8, 16, 617, 57)
$Input1 = GUICtrlCreateInput("", 24, 38, 393, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Button1 = GUICtrlCreateButton("Choose", 429, 38, 85, 21, 0)
GUICtrlSetOnEvent(-1, "Button1Click")
$Button2 = GUICtrlCreateButton("Start", 527, 38, 85, 21, 0)
GUICtrlSetOnEvent(-1, "Button2Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$check = GUICtrlCreateCheckbox('Script uses Beta', 8, 76, 150)
GUICtrlSetOnEvent(-1, 'checkClicked')
$lbl = GUICtrlCreateLabel('', 287, 79, 60, 17, $SS_CENTER)
$progress = GUICtrlCreateProgress(7, 98, 620, 20, $PBS_SMOOTH)
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
WEnd

Func Button1Click()
	GUICtrlSetData($progress, 0)
	GUICtrlSetData($lbl, '')
	$prog_val = 0
	$Skript = FileOpenDialog('Choose an au3-File', @MyDocumentsDir, '(*.au3)')
	If $Skript = '' Then Return
	GUICtrlSetData($Input1, $Skript)
EndFunc
Func Button2Click()
	GUICtrlSetData($progress, 0)
	GUICtrlSetData($lbl, '')
	$prog_val = 0
	If $Skript = '' Then Return
	If _SetVarsDeclared($Skript, $checked) = 0 Then 
		WinSetTitle($Form1, '', '  << Variables successful declared. >>')
	Else
		WinSetTitle($Form1, '', '  << All variables already declared! >>')
	EndIf
EndFunc
Func checkClicked()
	If BitAND(GUICtrlRead($check), $GUI_CHECKED) Then
		$checked = True
	Else
		$checked = False
	EndIf
EndFunc
Func Form1Close()
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