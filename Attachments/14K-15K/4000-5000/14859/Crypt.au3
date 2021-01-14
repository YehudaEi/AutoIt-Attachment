#include <Array.au3>

;===============================================================================
;
; Function Name:    _Crypt($keyfile,$crypt,$innfile,$outfile)
; Description:      Encrypt or Decrypt's file.
; Parameter(s):     $keyfile      	- Key file, made with _CryptKeyGen()
;                   $crypt			- Either 1=Encrypt or 0=Decrypt.
;                   $innfile	  	- Input file.
;                   $outfile		- Output file.
; Requirement(s):   Array.au3
; Return Value(s):  On Success - Returns ms event used.
;                   On Failure - Message will tell what went wrong.
; @error handling:  0 - No error.
;					1 - Inn file not found.
;					2 - Key file not found.
;					3 - Unable to read innfile.
;					4 - Unable to write to outfile.
; Author(s):        j0kk3
;
; Date:				29.04.2007
; Uppdated:			17.05.2007
; Version:			V.1.05
;
;===============================================================================
Func _Crypt( $keyFile, $crypt, $innfile, $outfile )
	
	If FileExists($innfile) = 0 Then
		SetError(1)
		Return 'Innfile does not exist.'
	ElseIf FileExists($keyFile) = 0 Then
		SetError(2)
		Return 'Keyfile does not exist.'
	ElseIf FileOpen($innfile,0) = -1 Then
		SetError(3)
		Return 'Unable to read innfile.'
	ElseIf FileOpen($outfile,2) = -1 Then
		SetError(4)
		Return 'Unable to write to outfile.'
	EndIf
	
	$fread 		= FileOpen($innfile,0)
	$fwrite 	= FileOpen($outfile,2)
	$cryptKey 	= FileReadLine($keyFile,1)		
	$key 		= StringSplit($cryptKey,',',1)	
	Dim $decryptkey[256]
	_ArrayDelete($key,0)
	For $i = 0 To 255
		$decryptkey[$key[$i]] = $i	
	Next
	$begin = TimerInit()
	If $crypt = '1' Then
		While 1
			$chars = FileRead($fread, 1)
			If @error = -1 Then ExitLoop
			FileWrite($fwrite,Chr($key[Asc($chars)]))
		WEnd
	ElseIf $crypt = '0' Then
		While 1
			$chars = FileRead($fread, 1)
			If @error = -1 Then ExitLoop
			FileWrite($fwrite,Chr($decryptkey[Asc($chars)]))
		WEnd	
	EndIf
	$dif = TimerDiff($begin)
	
	FileClose($fread)
	FileClose($fwrite)
	SetError(0)
	Return $dif
EndFunc ;==> _Crypt()

;===============================================================================
;
; Function Name:    _CryptKeyGen($keyfile,$cryptlevel)
; Description:      Creates a keyfile neede for the _Crypt() function.
; Parameter(s):     $keyfile      	- Key file, made with _CryptKeyGen()
;                   $cryptlevel		- Feature not used.
; Requirement(s):   None.
; Return Value(s):  On Success - Crypt-Key file generated.
;                   On Failure - Message tells what went wrong.
; @error handling:  0 - No error.
;					1 - Key file not found.
; Author(s):        j0kk3
;
; Date:				29.04.2007
; Uppdated:			17.05.2007
; Version:			V.1.01
;
;===============================================================================
Func _CryptKeyGen($keyFile,$cryptlevel = 1)
	
	
	If FileOpen($keyFile,2) = -1 Then
		SetError(1)
		Return 'Unable to write to keyfile.'
	EndIf
	
	$tablelength 	= 255
	
	Dim $table[$tablelength + 1],$num
	FileOpen($keyFile,2)
	For $x = 1 To $cryptlevel
		$num = -1
		For $i = 0 To $tablelength 
			$num +=1
			$table[$i] = $num
		Next
		For $i = 0 To $tablelength
			$random	= Random(0,$tablelength,1)
			$tableold = $table[$i]
			$tablenew = $table[$random]
			
			$table[$random] = $tableold
			$table[$i] = $tablenew
		Next
		For $i = 0 To $tablelength
			If $i < $tablelength Then
				FileWrite($keyFile,$table[$i]&',')
			Else
				FileWrite($keyFile,$table[$i])
			EndIf
		Next
		FileWrite($keyFile,@CRLF)
	Next
	SetError(0)
	Return 'Crypt-Key file generated.'
EndFunc ;==> _CryptKeyGen()