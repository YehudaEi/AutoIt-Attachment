#include <File.au3>

Local $Const = 'Constants.au3', $Struct = 'StructureConstants.au3'
Local $path = 'C:\Program Files\AutoIt3\Include\'

$Const1 = 'Constants.au3'
$Const2 = 'EditConstants.au3'
$Const3 = 'GUIConstantsEx.au3'
$Const4 = 'WindowsConstants.au3'
$Const5 = 'ComboConstants.au3'
$Const6 = 'ListViewConstants.au3'

$Input = InputBox('Const Creator', '1. Create all Constants' & @CRLF & '2. Create main Constants', '2', '', 200, 125)


If $Input = 1 Then
	_CreateFile()
	_CreateInclude()
	$first = FileFindFirstFile('C:\Program Files\AutoIt3\Include\*.au3')
	If $first = -1 Then Exit
	
	While 1
		$next = FileFindNextFile($first)
		If @error Then ExitLoop
		If StringRight($next, 13) = $Const _
				And $next <> $Struct Then
			_ConstCreate($next)
		EndIf
	WEnd
	
	ProgressOff()
	MsgBox(64, 'Const Creator <d3montools>', 'Done ! Output Const.au3 saved to script directory.', 3)
ElseIf $Input = 2 Then
	_CreateFile()
	_CreateInclude()
	$first = FileFindFirstFile('C:\Program Files\AutoIt3\Include\*.au3')
	If $first = -1 Then Exit
	
	While 1
		$next = FileFindNextFile($first)
		If @error Then ExitLoop
;### Tidy Error: If/ElseIf statement without a then..
		If $next = $Const1 Or _
				$next = $Const2 Or _
				$next = $Const3 Or _
				$next = $Const4 Or _
				$next = $Const5 Or _
				$next = $Const6 Then
			_ConstCreate($next)
		EndIf
	WEnd
	
	ProgressOff()
	MsgBox(64, 'Const Creator <d3montools>', 'Done ! Output Const.au3 saved to script directory.', 3)
EndIf

Func _ConstCreate($next)
	$end = _FileCountLines($path & '\' & $next)
	For $line = 1 To $end
		ProgressSet($line / $end * 100, $line & ' / ' & $end, $next)
		$RConst = FileReadLine($path & '\' & $next, $line)
		$note = StringMid($RConst, StringInStr($RConst, ';'))
		If ($note <> '') Then
			$new = StringReplace($RConst, $note, '')
			$text = StringReplace(StringReplace(StringReplace(StringReplace($new, 'Global Const ', ''), '#include-once', ''), @TAB, ''), ' ', '')
		Else
			$text = StringReplace(StringReplace(StringReplace(StringReplace($RConst, 'Global Const ', ''), '#include-once', ''), @TAB, ''), ' ', '')
		EndIf
		If ($text <> '') Then
			FileWrite('Const.au3', $text & @CRLF)
		EndIf
	Next
EndFunc   ;==>_ConstCreate

Func _CreateInclude()
	$first = FileFindFirstFile('C:\Program Files\AutoIt3\Include\*.au3')
	While 1 ;-----Start--------
		$next = FileFindNextFile($first)
		If @error Then ExitLoop
		If StringRight($next, 13) = $Const Then
			If $next <> $Struct Then
				ProgressSet(100, 'Creating Constants Includes', $next)
				FileWrite('Include.au3', '#include <' & $next & '>' & @CRLF)
			EndIf
		EndIf
	WEnd ;---End----
EndFunc   ;==>_CreateInclude

Func _CreateFile()
	ProgressOn('Const Creator <d3montools>', 'Initializing...')
	If FileExists('Const.au3') Then FileDelete('Const.au3')
	FileWrite('Const.au3', '')
	If FileExists('Include.au3') Then FileDelete('Include.au3')
	FileWrite('Include.au3', '')
EndFunc   ;==>_CreateFile