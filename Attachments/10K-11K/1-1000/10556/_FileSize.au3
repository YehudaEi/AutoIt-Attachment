;===============================================================================
;
; Description:      Returns the file size in human readable format
; Syntax:           _FileSize( $sFilePath )
; Parameter(s):     $sFilePath 	- Path and filename of the file to be read
; Requirement(s):   None
; Return Value(s):  Array:	[0] = Filesize
;							[1] = 2 char abbreviated designation
;							[2] = full designation
; Author(s):        Ariana <amanda089 at gmail dot com>
; Note(s):          If $sFilePath is not specified, will use @AutoItExe
;===============================================================================
Func _FileSize($sFilePath = "")

;~ kilobyte 	kB 	1024
;~ megabyte 	MB 	1048576
;~ gigabyte 	GB 	1073741824
;~ terabyte 	TB 	1099511627776
;~ petabyte 	PB 	1125899906842624
;~ exabyte 		EB 	1152921504606846976
;~ zettabyte 	ZB 	1180591620717411303424
;~ yottabyte 	YB 	1208925819614629174706176
	If $sFilePath = "" Then
		;Set $sFilePath to @AutoItExe if empty
		$sFilePath = @AutoItExe
	EndIf
	Local $iFileSize = FileGetSize($sFilePath)
	Local $aSizeCalculations[4][3] = _
		[[1024,						"KB",  "Kilobyte"], _	;(KB) Kilobyte		(04 digits)
		[ 1048576,					"MB",  "Megabyte"], _	;(MB) Megabyte		(07 digits)
		[ 1073741824,				"GB",  "Gigabyte"], _	;(GB) Gigabyte		(10 digits)
		[ 1099511627776,			"TB",  "Terabyte"]] 	;(TB) Terabyte		(13 digits)

;===============================================================================
;The definitions below can not be used in AutoIt as of yet. (> 15 digit precision)
;-------------------------------------------------------------------------------
;~ 		[ 1125899906842624,			"PB",  "Petabyte"], _	;(PB) Petabyte		(16 digits)
;~ 		[ 1152921504606846976,		"EB",   "Exabyte"], _	;(EB) Exabyte		(19 digits)
;~ 		[ 1180591620717411303424,	"ZB", "Zettabyte"], _	;(ZB) Zettabyte		(22 digits)
;~ 		[ 1208925819614629174706176,"YB", "Yottabyte"]]		;(YB) Yottabyte		(25 digits)
;===============================================================================

	For $i = (UBound($aSizeCalculations)-1) To 0 Step -1
		If $iFileSize >= $aSizeCalculations[$i][0] Then 
			Local $aReturn[3] = [$iFileSize/$aSizeCalculations[$i][0],String($aSizeCalculations[$i][1]),String($aSizeCalculations[$i][2])]
			If ($iFileSize/$aSizeCalculations[$i][0]) > 1 Then $aReturn[2] &= "s" ;Pluralize as needed
			Return $aReturn
		EndIf
	Next
	;ConsoleWrite("File Size: "&$sFilePath&" = "&$aReturn[0]&$aReturn[1]&" | "&$aReturn[2]&@CRLF)
	;Return $aReturn
EndFunc