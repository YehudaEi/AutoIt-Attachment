#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\Project.ICONS\Key.ico
#AutoIt3Wrapper_outfile=checksum_verify_1.0.exe
#AutoIt3Wrapper_Res_Description=Checksum Verifier
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Checksum Verifier
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <File.au3>
#include <Array.au3>
#NoTrayIcon

$file_to_open = FileOpenDialog("Choose .sfv file to check for integrity?", @HomeDrive, "Checksum file (*.sfv)", 1)
If @error Then
	Exit
Else
	$check = _ChecksumVerify($file_to_open)
	If $check = 0 Then
		MsgBox(0, "Verification - Passed", "Verification of files OK.")
	ElseIf $check = 1 Then
		MsgBox(0, "Verification - Failed", "Verification of files was not possible. Probably file in wrong format or file doesn't exists!")
	Else
		Local $files
		If IsArray($check) Then
			For $a = 1 To $check[0]
				$files = $files & " " & $check[$a]
			Next
			$files = StringReplace($files, " ", ",")
			MsgBox(0, "Verification - Failed", "Verification of files failed. Following file(s) didn't pass veryfication: " & @CRLF & "[-] " & $files)
		Else
			MsgBox(0, "Verification - Failed", "Verification of files was not possible. Probably file in wrong format or file doesn't exists!")
		EndIf
		
	EndIf
EndIf

Func _ChecksumCreate($sDirectory, $exceptions = ".TXT|.NFO|.M3U|.SFV")
	Local $sfv_file_name = StringTrimLeft($sDirectory, StringInStr($sDirectory, "\", 1, -1)) & ".sfv"
	Local $file_list = _FileListToArray($sDirectory, "*.*", 1)
	Local $sfv_create[1]
	$exceptions = StringSplit($exceptions, "|", 1)
	If @error = 1 Then Return SetError(-1, 0, 1)
	For $a = 1 To $file_list[0]
		Local $exception_status = False
		For $b = 1 To $exceptions[0]
			If StringRight($file_list[$a], 4) = $exceptions[$b] Then
				$exception_status = True
				ExitLoop
			EndIf
		Next
		If $exception_status = False Then
			$checksum_return = _ChecksumGetInfo($sDirectory & "\" & $file_list[$a])
			_ArrayAdd($sfv_create, $file_list[$a] & " " & $checksum_return)
		EndIf
	Next
	$sfv_create[0] = UBound($sfv_create) - 1
	_ArrayInsert($sfv_create, 1, "; This file holds checksum for all the files in the directory.")
	_FileWriteFromArray($sDirectory & "\" & $sfv_file_name, $sfv_create, 1)
EndFunc   ;==>_ChecksumCreate
Func _ChecksumVerify($sFileSFV)
	; Returns 0 if success
	; Returns $array of failed files if there was at least one failure
	; Return 1 if file doesn't exists or something else is wrong with the file
	Local $sfv_file_list
	Local $sfv_failed[1], $sfv_passed[1]
	Local $sFileSFVDirectory = StringLeft($sFileSFV, StringInStr($sFileSFV, "\", 1, -1) - 1)
	Local $status = _FileReadToArray($sFileSFV, $sfv_file_list)
	If $status = 0 Then Return SetError(1, 0, -1)
	For $a = 1 To $sfv_file_list[0]
		If StringLeft($sfv_file_list[$a], 1) <> ";" And StringLeft($sfv_file_list[$a], 1) <> "" Then
			$sfv_line_split = StringSplit($sfv_file_list[$a], " ", 1)
			If $sfv_line_split[0] = 2 Then
				$checksum_return = _ChecksumGetInfo($sFileSFVDirectory & "\" & $sfv_line_split[1])
				If $checksum_return = $sfv_line_split[2] Then
					;ConsoleWrite(@CR & $sfv_line_split[1] & " -> PASSED")
					_ArrayAdd($sfv_passed, $sfv_line_split[1])
				Else
					;ConsoleWrite(@CR & $sfv_line_split[1] & " -> FAILED")
					_ArrayAdd($sfv_failed, $sfv_line_split[1])
				EndIf
			EndIf
		EndIf
	Next
	$sfv_failed[0] = UBound($sfv_failed) - 1
	$sfv_passed[0] = UBound($sfv_passed) - 1
	If $sfv_failed[0] = 0 Then
		Return 0
	Else
		Return $sfv_failed
	EndIf
EndFunc   ;==>_ChecksumVerify
Func _ChecksumGetInfo($sFile)
	Local $nBufSize = 16384 * 8
	Local $CRC32 = 0
	If $sFile = "" Then Return SetError(1, 0, -1)
	Local $hFile = FileOpen($sFile, 16)
	For $i = 1 To Ceiling(FileGetSize($sFile) / $nBufSize)
		$CRC32 = _FastCRC32(FileRead($hFile, $nBufSize), BitNOT($CRC32))
	Next
	FileClose($hFile)
	Return Hex($CRC32, 8)
EndFunc   ;==>_ChecksumGetInfo
Func _FastCRC32($vBuffer, $nCRC32 = 0xFFFFFFFF)
	Local $nLen, $vTemp
	If DllStructGetSize($vBuffer) = 0 Then ; String passed
		If IsBinary($vBuffer) Then
			$nLen = BinaryLen($vBuffer)
		Else
			$nLen = StringLen($vBuffer)
		EndIf
		$vTemp = DllStructCreate("byte[" & $nLen & "]")
		DllStructSetData($vTemp, 1, $vBuffer)
		$vBuffer = $vTemp
	EndIf

	; Machine code hex strings (created by Laszlo)
	Local $CRC32Init = "0x33C06A088BC85AF6C101740AD1E981F12083B8EDEB02D1E94A75EC8B542404890C82403D0001000072D8C3"
	Local $CRC32Exec = "0x558BEC33C039450C7627568B4D080FB60C08334D108B55108B751481E1FF000000C1EA0833148E403B450C89551072DB5E8B4510F7D05DC3"

	; Create machine code stubs
	Local $CRC32InitCode = DllStructCreate("byte[" & BinaryLen($CRC32Init) & "]")
	DllStructSetData($CRC32InitCode, 1, $CRC32Init)
	Local $CRC32ExecCode = DllStructCreate("byte[" & BinaryLen($CRC32Exec) & "]")
	DllStructSetData($CRC32ExecCode, 1, $CRC32Exec)

	; Structure for CRC32 Lookup table
	Local $CRC32LookupTable = DllStructCreate("int[" & 256 & "]")

	; CallWindowProc under WinXP can have 0 or 4 parameters only, so pad remain params with zeros
	; Execute stub for fill lookup table
	DllCall("user32.dll", "int", "CallWindowProc", "ptr", DllStructGetPtr($CRC32InitCode), _
			"ptr", DllStructGetPtr($CRC32LookupTable), _
			"int", 0, _
			"int", 0, _
			"int", 0)
	; Execute main stub
	Local $ret = DllCall("user32.dll", "uint", "CallWindowProc", "ptr", DllStructGetPtr($CRC32ExecCode), _
			"ptr", DllStructGetPtr($vBuffer), _
			"uint", DllStructGetSize($vBuffer), _
			"uint", $nCRC32, _
			"ptr", DllStructGetPtr($CRC32LookupTable))
	Return $ret[0]
EndFunc   ;==>_FastCRC32