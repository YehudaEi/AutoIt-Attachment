#include-once
; #FUNCTION# ====================================================================================================================
; Name...........: _FileListTreeToArray
; Description ...: List all files from the wished directiry with all files from all subfolders to an array.
; Syntax.........: _FileListTreeToArray($pFolder[, $tPath = 1[, $tType = 0]])
; Parameters ....: $pFolder - Path to the directory that has to be listed
;                  $tPath   - Optional: Path return type, "0" = absolute (default), "1" = relative
;                  $tType   - Optional: Search type, see "cmd.exe /K dir /?" at subpoint attributes
;                                 Or see helptopic "FileGetAttrib"
;                           - Possible attributes: "RASHD"
;                                 R: Readonly
;                                 A: Archive
;                                 S: System
;                                 H: Hidden
;                                 D: Directory
;                           - Combine with using different operators together, it's like a logical "AND" operator
;                                 f.ex. "DR", will retrieve readonly directories
;                           - Exclude with a "-" before the operator, it's like a logical "AND NOT" operator
;                                 f.ex. "D-R" will retrieve non readonly directories
;                           - Default: "", all files
;                  $tSort   - Optional: Sort results, see "cmd.exe /K dir /?" at subpoint order
;                           - Possible orders:
;                                 N: Name, alphabetically
;                                 S: Size, smaller files first
;                                 E: Extension, alphabetically
;                                 D: Date/Time, older files first
;                                 G: Directories first
;                           - Not combineable
;                           - Turn over order by using a "-" before the operator
;                                 f.ex. "-S" will retrieve big files first
;                           - Default: "N", names sorted alphabetically
; Return values .: Success  - Array with $array[0] = Number of files\folders returned, $array[n] = path of file/folder
;				   Failure: - Returns 0 and sets @error to:
;							      0 if directory doen't exists
;							      1 if Flags are wrong
;							      2 if any other error occurs
;							  If @error = 2 then @extended will be set to:
;							      1 if an OemToChar error occurs
;							      2 if a Split error occurs
; Author ........: Jonas Neef, Thanks to bernd670 for Ascii help
; Remarks .......: Can take very long, needs CPU; Files with special chars may result in some other string, f.ex. "µ" -> "æ"
; Related .......: FileGetAttrib, FileSetAttrib, _FileListToArray
; Link ..........;                          
; Example .......; No
; ===============================================================================================================================
Func _FileListTreeToArray($pFolder, $tPath = 0, $tType = "", $tSort = "N")
	$wCheck = StringSplit(StringLeft($pFolder, 3), ":" )
	If $wCheck[0] <> 2 and StringLeft($pFolder, 1) <> "\" then $pFolder = @WorkingDir & "\" & $pFolder
	If $wCheck[0] <> 2 and StringLeft($pFolder, 1) = "\" then $pFolder = @WorkingDir & $pFolder
	If StringRight($pFolder, 1) = "\" then $pFolder = StringTrimRight($pFolder, 1)
	If Not FileExists($pFolder) then Return Seterror(0, 0, 0)
	if $tPath > 1 OR $tPath < 0 then return Seterror(1, 0, 0)
	$wSort = StringReplace($tSort, "-", "")
	If StringLen($wSort) <> 1 or $wSort <> "N" and $wSort <> "S" and $wSort <> "E" and $wSort <> "D" and $wSort <> "G" and _
		$wSort <> "" then return Seterror(1, 0, 0)
	If Stringreplace(Stringreplace(Stringreplace( Stringreplace(Stringreplace(Stringreplace($tType, "-", ""), "H", ""), "S", _
		""), "A", ""), "R", ""), "D", "") <> "" then return Seterror(1,0,0)
	local $uArray, $iStdout, $sTemp, $placeholder
	If $tType = "" Then
		$iStdout = Run(@comspec & ' /C cd ..\..\..\..\.. & dir "' & $pFolder & '" /A /B /O:' & $tSort & ' /S', @workingdir, _
			@SW_HIDE, 6)
	Else
		$iStdout = Run(@comspec & ' /C cd ..\..\..\..\.. & dir "' & $pFolder & '" /A:' & $tType & ' /B /O:' & $tSort & ' /S', _
			@workingdir, @SW_HIDE, 6)
	EndIF
	While 1
		$line = StdoutRead($iStdout)
		If @error Then ExitLoop
		If $line <> "" then $sTemp &= $line
	Wend
    For $i = 0 To StringLen($sTemp)
        $placeholder &= "  "
    Next
    $sTemp = DllCall("user32.dll", "long", "OemToChar", "str", $sTemp, "str", $placeholder)
	If Not Isarray($sTemp) or $sTemp[0] < 1 then return Seterror(2,1,0)
	$sTemp = $sTemp[2]
	$sTemp = StringReplace($sTemp, @crlf, @lf)
	$sTemp = StringReplace($sTemp, @cr, @lf)
	If StringRight($sTemp, 1) = @lf then $sTemp = StringTrimRight($sTemp, 1)
	If StringLeft($sTemp, 1) = @lf then $sTemp = StringTrimLeft($sTemp, 1)
	If Not StringInStr($sTemp, @lf) then
		If $sTemp = "" then
			local $return[1] = [0]
		Else
			local $return[2] = [1, $sTemp]
		EndIf
	Else
		local $return = StringSplit($sTemp, @lf)
	EndIF
	if not isarray($return) then
		Return Seterror(2,2,0)
	EndIF
	If $tPath = 1 Then
		For $dArray = 1 To $return[0] Step 1
			$return[$dArray] = StringReplace($return[$dArray], $pFolder & "\", "")
		Next
	EndIf
	return Seterror(0,0,$return)
EndFunc   ;==>_FileReadTreeInArray