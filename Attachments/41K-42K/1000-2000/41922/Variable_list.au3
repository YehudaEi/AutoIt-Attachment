;~ http://www.autoitscript.com/forum/topic/22625-output-global-variables-on-exit

#include <array.au3>

If $CmdLine[0] = 1 Then
	ConsoleWrite('Variable_list: using file: ' & $CmdLine[1] & @CRLF)
	_ListOfGlobalVariables($CmdLine[1])
	_FunctionStartStop($CmdLine[1])
Else
	; only for testing
	Local $fFile = FileOpenDialog('Select Au3 File', @ScriptDir, 'Au3 File (*.au3)')
	_ListOfGlobalVariables($fFile)
	_FunctionStartStop($fFile)
EndIf

Func _ListOfGlobalVariables($fFile)
	Local $_sGlobalVariableList = ''
	Local $sFileContent = FileRead($fFile)
	Local $sFileContent_temp = StringRegExpReplace($sFileContent, '(*ANYCRLF)\s*;.*', '')
	$sFileContent_temp = StringRegExpReplace($sFileContent_temp, '(\s{2,})', ' ')
	$sFileContent_temp = StringRegExpReplace($sFileContent_temp, '(?is)(Func .*?EndFunc.*?\r\n', @CRLF)
	$sFileContent_temp = StringRegExpReplace($sFileContent_temp, '(?is)(\#ce.*?\#cs|\#comments-start.*?\#comments-end)', '')
	Local $aTempGlobalVariableList = StringRegExp($sFileContent_temp, '(?<=Global )(\$.*?)(?:\s|\[)', 3)
	If IsArray($aTempGlobalVariableList) = 0 Then
		ConsoleWrite('Variable_list: IsArray($aTempGlobalVariableList) =  ' & IsArray($aTempGlobalVariableList) & @CRLF)
		$_sGlobalVariableList = '$_sGlobalVariableList = ""'
	Else
		$aTempGlobalVariableList = _ArrayUnique($aTempGlobalVariableList)
		_ArrayDelete($aTempGlobalVariableList, 0)
		If _ArraySearch($aTempGlobalVariableList, '$_sGlobalVariableList') <> -1 Then _ArrayDelete($aTempGlobalVariableList, _ArraySearch($aTempGlobalVariableList, '$_sGlobalVariableList'))
		_ArraySort($aTempGlobalVariableList)
		$_sGlobalVariableList = 'Global $_sGlobalVariableList = ""' & @CRLF
		$_sGlobalVariableList &= '$_sGlobalVariableList &= "'
		ConsoleWrite('Variable_list:  _ArrayToString: START:' & @CRLF)
		ConsoleWrite(_ArrayToString($aTempGlobalVariableList) & @CRLF)
		ConsoleWrite('Variable_list:  _ArrayToString: END:' & @CRLF)
		For $iVar = 0 To (UBound($aTempGlobalVariableList) - 1)
			$_sGlobalVariableList &= $aTempGlobalVariableList[$iVar] & '|'
			If $iVar = (UBound($aTempGlobalVariableList) - 1) Then
				$_sGlobalVariableList = StringTrimRight($_sGlobalVariableList, 1) & '"' & @CRLF
			Else
				If Mod(Number($iVar + 1), 5) = 0 Then
					$_sGlobalVariableList &= '"' & @CRLF
					$_sGlobalVariableList &= '$_sGlobalVariableList &= "'
				EndIf
			EndIf
		Next
	EndIf
	Local $sGlobalVariableRegion = ''
	$sGlobalVariableRegion &= '#region Global and Local "Variable List Declaration"' & @CRLF
	$sGlobalVariableRegion &= $_sGlobalVariableList & @CRLF
	$sGlobalVariableRegion &= '#endregion Global and Local "Variable List Declaration"' & @CRLF
	ConsoleWrite('Adding:' & @CRLF)
	ConsoleWrite($sGlobalVariableRegion & @CRLF)
	; cleaning for old variable name $sVariableList
	$sFileContent = StringRegExpReplace($sFileContent, '(?is)\#region \$sVariableList.*?\#endregion \$sVariableList\r\n', '')
	; cleaning new variable name $_sGlobalVariableList
	$sFileContent = StringRegExpReplace($sFileContent, '(?is)\#region Global and Local \"Variable List Declaration\".*?\#endregion Global and Local \"Variable List Declaration\"\r\n', $sGlobalVariableRegion)
	If @extended = 0 Then $sFileContent = $sGlobalVariableRegion & @CRLF & $sFileContent
	FileMove($fFile, StringReplace($fFile, '.au3', '__VariableList_BackUp.au3'))
	FileWrite(@ScriptDir & 'VariableList_temp.au3', $sFileContent)
	FileMove(@ScriptDir & 'VariableList_temp.au3', $fFile, 1)
EndFunc   ;==>_ListOfGlobalVariables

Func _FunctionStartStop($fFile)
	Local $_sLocalVariableList = ''
	Local $sFunc_new = ''
	Local $aFuncName = ''
	Local $sFileContent = FileRead($fFile)
	$sFileContent = StringRegExpReplace($sFileContent, '(?i)\r\n\s*?_Func_start.*?\r\n', @CRLF)
	$sFileContent = StringRegExpReplace($sFileContent, '(?i)\r\n\s*?_Func_End.*?\r\n', @CRLF)
	$aFunctions = StringRegExp($sFileContent, '(?is)(Func .*?EndFunc.*?\r\n)', 3)
	For $sFunc In $aFunctions
		If _
				StringInStr($sFunc, 'Func Intercept_MessageBoxW(') = 0 And _
				StringInStr($sFunc, 'Func AddHookApi(') = 0 And _
				StringInStr($sFunc, 'Func VirtualProtect(') = 0 And _
				StringInStr($sFunc, 'Func ImageDirectoryEntryToData(') = 0 And _
				StringInStr($sFunc, 'Func _GetVariablesValue(') = 0 And _
				StringInStr($sFunc, '_Func_Start(') = 0 And _
				StringInStr($sFunc, '_Func_End(') = 0 _
				Then
			$sFunc_new = StringRegExpReplace($sFunc, '(?is)(Func )(.*?)(\(.*?\)\r\n)(.*?)(EndFunc.*?\r\n)', '$1$2$3	_Func_Start("$2")' & @CRLF & '$4	_Func_End("$2")' & @CRLF & '$5')
			$aFuncName = StringRegExp($sFunc_new, '(?i)(?:Func )(.*?)(?:\()', 3)
			$sFunc_new = StringRegExpReplace($sFunc_new, '(?i)(\r\n)(\s*?)(Return)', @CRLF & '$2_Func_End("' & $aFuncName[0] & '")$1$2$3')
			$sFunc_new = StringRegExpReplace($sFunc_new, '(?i)(_Func_End.*\r\n\s*?Return.*?)(\r\n\s*_Func_End\(.*?\))', '$1')
			$sFileContent = StringReplace($sFileContent, $sFunc, $sFunc_new)
		EndIf
	Next
	FileMove($fFile, StringReplace($fFile, '.au3', '__VariableList_BackUp.au3'))
	FileWrite(@ScriptDir & 'VariableList_temp.au3', $sFileContent)
	FileMove(@ScriptDir & 'VariableList_temp.au3', $fFile, 1)
EndFunc   ;==>_FunctionStartStop
