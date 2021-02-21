#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Alexander Samuelsson (AdmiralAlkex)

 Script Function:
	Create hashes for subfolders

#ce ----------------------------------------------------------------------------

#Include <Crypt.au3>
#Include <File.au3>
#Include <Array.au3>

Global $asFileList[1], $iCurrentFile = 0

_ListFolders(@ScriptDir, StringLen(@ScriptDir))
ReDim $asFileList[$iCurrentFile]
_ArrayReverse($asFileList)
_FileWriteFromArray(@ScriptDir & "\FileHashes.txt", $asFileList)
ShellExecute(@ScriptDir & "\FileHashes.txt")


Func _ListFolders($sDir, $iSkipXChars)
	$hSearch = FileFindFirstFile($sDir & "/*")

	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If @extended <> 1 Then ContinueLoop

		_ListFiles($sDir & "\" & $sFile, $iSkipXChars)

		$iUBound = UBound($asFileList)
		If $iCurrentFile >= $iUBound -1 Then ReDim $asFileList[$iUBound *2]
		$asFileList[$iCurrentFile] = $sFile
		$iCurrentFile += 1
	WEnd

	FileClose($hSearch)
EndFunc

Func _ListFiles($sDir, $iSkipXChars)

	$hSearch = FileFindFirstFile($sDir & "/*.*")

	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop

		$iUBound = UBound($asFileList)
		If $iCurrentFile >= $iUBound -1 Then ReDim $asFileList[$iUBound *2]
		$asFileList[$iCurrentFile] = _Crypt_HashFile($sDir & "\" & $sFile, $CALG_MD5)
		$iCurrentFile += 1
		$asFileList[$iCurrentFile] = StringTrimLeft($sDir & "\" & $sFile, $iSkipXChars)
		$iCurrentFile += 1
	WEnd

	FileClose($hSearch)
EndFunc