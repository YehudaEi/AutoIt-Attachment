Func _DeleteFiles($sPath, $sFilter, $iRemDir = 0)
	Local $hSearch, $sFile
	$hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
	If $hSearch = -1 Then
		If $iRemDir = 1 Then DirRemove($sPath)
		SetError(1)
		Return 0
	EndIf
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error = 1 Then
			If $iRemDir = 1 Then DirRemove($sPath, 0)
			SetError(0)
			Return 1
		EndIf
		If $sFile = ".." Or $sFile = "." Then ContinueLoop
		$sFile = $sPath & "\" & $sFile
		If StringInStr(FileGetAttrib($sFile), "D") Then
			_DeleteFiles($sFile, "*", 1)
			ContinueLoop
		EndIf
		FileDelete($sFile)
	WEnd
EndFunc   ;==>_DeleteFiles

