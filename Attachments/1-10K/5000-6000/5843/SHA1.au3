Func _StringHashSHA1($sString,$iRunErrorsFatal = -1, $vEXEPath = 0)
	Local $hPID
	If Not ($iRunErrorsFatal = 0 Or $iRunErrorsFatal = 1 Or $iRunErrorsFatal = -1) Then
		SetError(1)
		Return ""
	EndIf
	If $vEXEPath = 0 Then
		$sEXEPath = @ScriptDir & "\SHA1Deep.exe"
	Else
		$sEXEPath = $vEXEPath
	EndIf
	If $iRunErrorsFatal <> - 1 Then $iOPT = opt("RunErrorsFatal", $iRunErrorsFatal)
	$hPID = Run($sEXEPath, @SystemDir, @SW_SHOW, 3)
	If @error Then
		If $iRunErrorsFatal <> - 1 Then opt("RunErrorsFatal", $iOPT)
		SetError(2)
		Return ""
	EndIf
	StdInWrite($hPID,$sString)
	If @Error=-1 then
		SetError(3)
		Return ""
	EndIf
	StdInWrite($hPID)
	If @Error=-1 Then
		SetError(3)
		Return ""
	EndIf
	SetError(0)
	$sHash=StringTrimRight(StdOutRead($hPID),2)
	ClipPut($sHash)
	If Not StringIsXDigit($sHash) or StringLen($sHash)<>40 Then
		If $iRunErrorsFatal <> - 1 Then opt("RunErrorsFatal", $iOPT)
		SetError(4)
		Return ""
	EndIf
	SetError(0)
	Return $sHash
EndFunc
	
	
	
