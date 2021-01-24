
 ;#FUNCTION# ====================================================================================================================
; Name...........: _SBfpsplit
; Description ...: Splits a file path into Drive, path, filename, or extension.
; Syntax.........: _SBfpsplit($SBPath, $SBType) ;$SBpath (file path to evaluate) , $SBType (option) 
; Parameters ....:
;        		|1 = Drive 			ex. D:
;     	 		|2 = Path  			ex. D:\1111\dir\file.txt                
 ;				|3 = File name		ex. file.txt
;          	  	|4 = Extension		ex. txt
;            	|5 = Drive letter only ex. D
; Author ........: Scott E. Brown 
; Modified.......:04/03/2009
; Remarks .......: 
; Related .......:
; Link ..........;
; Example .......; _SBfpsplit("D:\1111\dir\file.txt, 1)
;
;$path = "D:\1111\dir\test.txt"
;ConsoleWrite(_SBfpsplit($path, 1) & @CRLF)
;ConsoleWrite(_SBfpsplit($path, 2) & @CRLF)
;ConsoleWrite(_SBfpsplit($path, 3) & @CRLF)
;ConsoleWrite(_SBfpsplit($path, 5) & @CRLF)
; ===============================================================================================================================
Func _SBfpsplit($SBPath, $SBType) ;$SBpath = file path to evaluate , $SBType = 1 for Drive, 2 for Path, 3 for File name, 4 for extension, 5 for drive letter only
	Local $SBfile, $SBSplit, $SBdrive, $SBfilepath, $SBnumber 
	$SBSplit = StringSplit($SBPath, "\"); split into array
	$SBnumber = $SBSplit[0] ; the number of strings returned 
	$SBfilepath = ""
	for $1 = 1 to $SBnumber -1
		$SBfilepath = $SBfilepath & $SBSplit[$1] & "\" ; path
	Next
	$SBfile = $SBSplit[($SBsplit[0])]; file
	$SBdrive = $SBSplit[1] ; drive
	$SBfs = StringSplit($SBPath, "."); split into array
	;MsgBox(4096, "Path", $SBSfs[0])
	if $SBfs[0] = 1 then 
		$SBExt = ""; no extension found
	Else
		$SBExt = $SBfs[($SBfs[0])]; last . extentsion
	EndIf

	If $SBType = 1 then Return $SBdrive
	If $SBType = 2 then Return $SBfilepath
	If $SBType = 3 then Return $SBfile
	If $SBType = 4 then Return $SBExt 
	If $SBType = 5 then Return StringLeft($SBdrive, 1) 
EndFunc
