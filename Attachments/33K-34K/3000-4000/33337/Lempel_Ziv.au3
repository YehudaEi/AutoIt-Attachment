#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Constants.au3>

$ipfile = FileOpen("ip.t", 16)
$opfile = FileOpen("op.t", 17)

Dim $address[4096]
Dim $phrase[4096]
Dim $code[4096]

$address[0] = 0
$phrase[0] = ""
$code[0] = "000000000000"


; Check if file opened for writing OK
If $opfile = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

; Check if file opened for reading OK
If $ipfile = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

;Start reading in the file
$arraypos = 1;
$j = 1;
$k = 0;
$offset = 0;
$justread = ""
$string = "";
$previous = ""
$notfound = 0
$padd = 1
While 1

	FileSetPos($ipfile,$offset,0)									;	offset measured from origin, variable origin
	$justread = FileRead($ipfile,1)									;	read in 1 bit from the origin
	$previous = $string
	$string &= $justread ;

	For $k=0 To 4095 Step 1
		If $phrase[$k] == "1" Then
			$address[1] = "000000000001"
			$arraypos += 1

		ElseIf $phrase[$k] == "0" Then
			$address[1] = "000000000000"
			$arraypos += 1

		ElseIf $phrase[$k] == $string Then
			$offset += 1
			$justread = FileRead($ipfile,1)							;	read in 1 more bit, from new origin
			$previous = $string
			$string &= $justread ;
			#cs If $k = 4095 Then
				$string[$arraypos] = $string
				$code[$arraypos] =
				$arraypos += 1
			#ce
		Else
			If $k=4095 Then
				$notfound = 1;
			EndIf
		EndIf
	Next															;	For loop ends here

	If $notfound = 1 Then
		For $k=0 To 4095
			If $phrase == $previous Then
				$padd = $k
			EndIf
		Next
	EndIf

	$notfound = 1													;	Reset the flag. Else will keep getting errors
	$newcode = $address[$padd] & $justread							;	Generating the new code

	;FileWrite($opfile,$newcode)									;	Writing the encoded file

	$address[$arraypos] = $arraypos									;	Updating counters and arrays
	$phrase[$arraypos] = $string
	$code[$arraypos] = $newcode
	$arraypos += 1

	If $arraypos == 4096 Then
		MsgBox(0, "Error", "Dictionary size exceeded limits")
		ExitLoop
	EndIf

WEnd

For $k=0 To 4095													;	Writing the table for troubleshooting
	FileWrite($opfile,$address[$k] & @TAB & $code[$k] & @CRLF)
	Next