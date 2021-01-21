#include <Date.au3>

$hwnd = _OpenNotepad()
Sleep(1000)

$days = 3
$type = "*"
$drive = StringTrimRight(@ScriptDir, StringLen(@ScriptDir) - 2) & "\"


_NoteSend($hwnd, "Scanning...{ENTER 2}", 0)
$a = _FileSearch($drive & "*." & $type,1)
If $a[0] > 0 Then
	_NoteSend($hwnd, "Scan of drive " & $drive & " for files newer than " & $days & " days:{ENTER}------------------------------{ENTER 2}", 0)
	For $i = 1 to $a[0]
		If _IsNew($a[$i], $days) Then
			_NoteSend($hwnd, $a[$i], 1)
			_NoteSend($hwnd, "{ENTER}", 0)
		EndIf
	Next
EndIf
_NoteSend($hwnd, "{ENTER}------------------------------", 0)



;''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Func _OpenNotepad()
	Opt("WinTitleMatchMode", 4)
	Run("notepad.exe", @SystemDir, @SW_MAXIMIZE)
	WinWaitActive("Untitled - Notepad")
	Local $hwnd[2]
	$hwnd[0] = WinGetHandle("classname=Notepad", "")
	$hwnd[1] = ControlGetHandle($hwnd[0], "", "Edit1")
	ControlFocus($hwnd[0], "", $hwnd[1])
	Return $hwnd
EndFunc

Func _NoteSend($hwnd, $txt, $flag = 0)
	Return ControlSend($hwnd[0], "", $hwnd[1], $txt, $flag)
EndFunc
;''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


Func _IsNew($sFile, $iDays)
	Local $now = _DateNow()
	Local $f = _FileTime($sFile)
	Local $diff = _DateDiff("d", $f, $now)
	If $diff <= $iDays Then Return 1
	Return 0
EndFunc

Func _DateNow()
	Return @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
EndFunc

Func _FileTime($file)
	Local $d = FileGetTime($file)
	Return $d[0] & "/" & $d[1] & "/" & $d[2] & " " & $d[3] & ":" & $d[4] & ":" & $d[5]
EndFunc

Func _FileSearch($szMask,$nOption)
	$szRoot = ""
	$hFile = 0
	$szBuffer = ""
	$szReturn = ""
	$szPathList = "*"
	Dim $aNULL[1]

	If Not StringInStr($szMask,"\") Then
		 $szRoot = @SCRIPTDIR & "\"
	Else
		 While StringInStr($szMask,"\")
			  $szRoot = $szRoot & StringLeft($szMask,StringInStr($szMask,"\"))
			  $szMask = StringTrimLeft($szMask,StringInStr($szMask,"\"))
		 Wend
	EndIf
	If $nOption = 0 Then
		 _FileSearchUtil($szRoot, $szMask, $szReturn)
	Else
		 While 1
			  $hFile = FileFindFirstFile($szRoot & "*.*")
			  If $hFile >= 0 Then
				   $szBuffer = FileFindNextFile($hFile)
				   While Not @ERROR
						If $szBuffer <> "." And $szBuffer <> ".." And StringInStr(FileGetAttrib($szRoot & $szBuffer),"D") Then $szPathList = $szPathList & $szRoot & $szBuffer & "*"
						$szBuffer = FileFindNextFile($hFile)
				   Wend
				   FileClose($hFile)
			  EndIf
			  _FileSearchUtil($szRoot, $szMask, $szReturn)
			  If $szPathList == "*" Then ExitLoop
			  $szPathList = StringTrimLeft($szPathList,1)
			  $szRoot = StringLeft($szPathList,StringInStr($szPathList,"*")-1) & "\"
			  $szPathList = StringTrimLeft($szPathList,StringInStr($szPathList,"*")-1)
		 Wend
	EndIf
	If $szReturn = "" Then
		 $aNULL[0] = 0
		 Return $aNULL
	Else
		 Return StringSplit(StringTrimRight($szReturn,1),"*")
	EndIf
EndFunc

Func _FileSearchUtil(ByRef $ROOT, ByRef $MASK, ByRef $RETURN)
	$hFile = FileFindFirstFile($ROOT & $MASK)
	If $hFile >= 0 Then
		 $szBuffer = FileFindNextFile($hFile)
		 While Not @ERROR
			  If $szBuffer <> "." And $szBuffer <> ".." Then $RETURN = $RETURN & $ROOT & $szBuffer & "*"
			  $szBuffer = FileFindNextFile($hFile)
		 Wend
		 FileClose($hFile)
	EndIf
EndFunc