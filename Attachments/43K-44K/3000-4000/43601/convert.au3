#include"Base64.au3"
#include <File.au3>
#include "_FindInFile.au3"


Global $szDrive
Global $szDir
Global $szFName
Global $szExt


$aArray = _FindInFile('src=\"image', @ScriptDir, '*.html*')
;_ArrayDisplay($aArray)



For $i = 1 To $aArray[0]
	$sFile = $aArray[$i]
	$hFile = FileOpen($sFile, 0)
	$sText = FileRead($hFile)
	FileClose($hFile)
	ConsoleWrite($sFile & @CRLF)
	Global $aMatch = StringRegExp($sText, 'src=\"([a-zA-Z0-9]*)/(\w*[-]*\s*\w*[.fw]*.[a-zA-Z0-9]{3})\"', 3)
	;_ArrayDisplay($aMatch)
	Local $howbigisit = UBound($aMatch)
	Local $imagesFound = $howbigisit / 2
	;MsgBox(0, 'Max Index String value', Ubound($aMatch))

	$iteration = 0
	Do
		;MsgBox(0, '$howbigisit', $howbigisit)
		;_ArrayDisplay($aMatch)
		$mutator = $iteration * 2
		;MsgBox(0, '$imagesFound', $imagesFound)
		$imageFolder = $aMatch[0 + $mutator]
		$imageFile = $aMatch[1 + $mutator]
		$imagePath = $imageFolder & "\" & $imageFile
		$imagetype = StringSplit($imageFile, ".")
		$imagetype = $imagetype[$imagetype[0]]
		_SplitPath($sFile, $szDrive, $szDir, $szFName, $szExt)
		$imageFullPath = $szDrive & $szDir & $imagePath
		;MsgBox(0, "$szDrive", $szDrive)
		;MsgBox(0, "$szDir", $szDir)
		;MsgBox(0, "$szFName", $szFName)
		;MsgBox(0, "$szExt", $szExt)
		;MsgBox(0, "$imageFullPath", $imageFullPath)

		;got the image, let's base 64 encode it!
		FileOpen($imageFullPath, 16)
		Local $sFiletoBase64 = FileRead($imageFullPath)
		$Encrypt = _Base64Encode($sFiletoBase64)
		FileClose($imageFullPath)
		$replacementText = 'src="data:image/' & $imagetype & ';base64,' & $Encrypt & '"'
		;ConsoleWrite ($replacementText & @CRLF)
		Local $texttoreplace = 'src="' & $imageFolder & "/" & $imageFile & '"'

		Local $iPosition = StringInStr($sText, $texttoreplace)

		ConsoleWrite($texttoreplace & @CRLF)

		;Local $finalText = StringReplace($sText, $texttoreplace, $replacementText)
		;ConsoleWrite($finalText & @CRLF)



		;replace the sucker
		Local $retval = _ReplaceStringInFile($sFile, $texttoreplace, $replacementText)

		$iteration = $iteration + 1
	Until $iteration = $imagesFound

	;MsgBox(0, "stuff", $aArray[$i])


Next





;===============================================================================
;
; Description:      Splits a path into the drive, directory, file name and file extension parts
; Parameter(s):     $szPath - IN - The path to be split (Can contain a UNC server or drive letter)
;                           $szDrive - OUT - String to hold the drive
;                           $szDir - OUT - String to hold the directory
;                           $szFName - OUT - String to hold the file name
;                           $szExt - OUT - String to hold the file extension
; Requirement(s):   None
; Return Value(s):  Array with 5 elements where 0 = original path, 1 = drive, 2 = directory, 3 = filename,
;                           4 = extension
; Note(s):              An empty string denotes a missing part
;
;===============================================================================
Func _SplitPath($szPath, ByRef $szDrive, ByRef $szDir, ByRef $szFName, ByRef $szExt)
	; Set local strings to null (We use local strings in case one of the arguments is the same variable)
	Local $drive = ""
	Local $dir = ""
	Local $fname = ""
	Local $ext = ""
	Local $i ; For Opt("MustDeclareVars", 1)

	; Create an array which will be filled and returned later
	Dim $array[5]
	$array[0] = $szPath; $szPath can get destroyed, so it needs set now

	; Get drive letter if present (Can be a UNC server)
	If StringMid($szPath, 2, 1) = ":" Then
		$drive = StringLeft($szPath, 2)
		$szPath = StringTrimLeft($szPath, 2)
	ElseIf StringLeft($szPath, 2) = "\\" Then
		$szPath = StringTrimLeft($szPath, 2) ; Trim the \\
		$pos = StringInStr($szPath, "\")
		If $pos = 0 Then $pos = StringInStr($szPath, "/")
		If $pos = 0 Then
			$drive = "\\" & $szPath; Prepend the \\ we stripped earlier
			$szPath = "" ; Set to null because the whole path was just the UNC server name
		Else
			$drive = "\\" & StringLeft($szPath, $pos - 1) ; Prepend the \\ we stripped earlier
			$szPath = StringTrimLeft($szPath, $pos - 1)
		EndIf
	EndIf

	; Set the directory and file name if present
	For $i = StringLen($szPath) To 0 Step -1
		If StringMid($szPath, $i, 1) = "\" Or StringMid($szPath, $i, 1) = "/" Then
			$dir = StringLeft($szPath, $i)
			$fname = StringRight($szPath, StringLen($szPath) - $i)
			ExitLoop
		EndIf
	Next

	; If $szDir wasn't set, then the whole path must just be a file, so set the filename
	If StringLen($dir) = 0 Then $fname = $szPath

	; Check the filename for an extension and set it
	For $i = StringLen($fname) To 0 Step -1
		If StringMid($fname, $i, 1) = "." Then
			$ext = StringRight($fname, StringLen($fname) - ($i - 1))
			$fname = StringLeft($fname, $i - 1)
			ExitLoop
		EndIf
	Next

	; Set the strings and array to what we found
	$szDrive = $drive
	$szDir = $dir
	$szFName = $fname
	$szExt = $ext
	$array[1] = $drive
	$array[2] = $dir
	$array[3] = $fname
	$array[4] = $ext
	Return $array
EndFunc   ;==>_SplitPath
