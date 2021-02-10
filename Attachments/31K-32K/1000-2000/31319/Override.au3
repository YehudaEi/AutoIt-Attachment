
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <file.au3>
#include <misc.au3>
#include <date.au3>

Opt("MustDeclareVars", 1)

;ReplaceFile("e:\dvd\com\edit.com","c:\test\com\edit.com")
;ReplaceFile("e:\dvd\harry\AUTOEXEC.BAT","c:\test\harry\AUTOEXEC.BAT")
;ReplaceFile("e:\dvd\harry\db1.mdb","c:\test\harry\db1.mdb")
;ReplaceFile("e:\dvd\test\300.cd1.mpg","c:\test\test\300.cd1.mpg")
;ReplaceFolder("e:\dvd","c:\test")

Global $debug = 0
Global $noerror = 0
Global $invalidChars = "/ : < > | " & chr(34)

Func GetFileTypeApp($file)
	Local $fext,$RegPath
	Local $val,$tmpval,$i = 1
	Local $HKCUPath  = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\"
	Local $HKCRPath = "HKCR\"
	Local $HKCRPathOpen = "\Shell\Open\Command\"
	Local $HKCRPathPlay = "\Shell\Play\Command\"
	$fext = StringLower(StringRight($file,StringLen($file) - StringInStr($file,".",0,-1)))
	$RegPath = $HKCUPath & "." & $fext & "\OpenWithProgids"
	If RegKeyExist($RegPath) Then
		While True
			$tmpval = RegEnumVal($RegPath, $i)
			If @error Then ExitLoop
			$val = $tmpval
			$i += 1
		WEnd
		$RegPath = ""
		If RegKeyExist($HKCRPath & $val & $HKCRPathOpen) Then $RegPath = $HKCRPath & $val & $HKCRPathOpen
		If RegKeyExist($HKCRPath & $val & $HKCRPathPlay) Then $RegPath = $HKCRPath & $val & $HKCRPathPlay
		if $RegPath <> "" Then
			$val = RegRead($RegPath,"")
			If @error then Return 0
			If StringLeft($val,1) = '"' Then
				$val = StringRight($val,StringLen($val)-1)
				$val = StringLeft($val,StringInStr($val,'"',0,1)-1)
			Else
				$val = StringLeft($val,StringInStr($val,' ',0,1)-1)
			EndIf
			Return $val
		Else
			;MsgBox(0,"Fehler","Kein HKCR Eintrag.")
			Return 0
		EndIf
	EndIf
	$RegPath = $HKCRPath & "." & $fext
	If RegKeyExist($RegPath) Then
		$val = RegRead($RegPath,"")
		$tmpval = $val
		$RegPath = ""
		If RegKeyExist($HKCRPath & $val & $HKCRPathOpen) Then $RegPath = $HKCRPath & $val & $HKCRPathOpen
		If RegKeyExist($HKCRPath & $val & $HKCRPathPlay) Then $RegPath = $HKCRPath & $val & $HKCRPathPlay
		if $RegPath <> "" Then
			$val = RegRead($RegPath,"")
			If @error then Return 0
			If StringLeft($val,1) = '"' Then
				$val = StringRight($val,StringLen($val)-1)
				$val = StringLeft($val,StringInStr($val,'"',0,1)-1)
			Else
				$val = StringLeft($val,StringInStr($val,' ',0,1)-1)
			EndIf
			If StringLen($val) > 3 Then
				If StringInStr($val,"%") Then
					$val = StringRight($val,StringLen($val)-StringInStr($val,"\",0,-1))
					Return $val
				Else
					Return $val
				EndIf
			Else
				$RegPath = $HKCRPath & $tmpval & "\DefaultIcon"
				If RegKeyExist($RegPath) Then
					$val = RegRead($RegPath,"")
					$val = StringRight($val,StringLen($val)-StringInStr($val,",",0,-1))
					if $val < 0 Then $val = $val * -1
					;msgbox(0,"","Shell32.dll:" & $val)
					Return $val
				EndIf
			EndIf
		Else
			;MsgBox(0,"Fehler","Kein HKCR Eintrag.")
			Return 0
		EndIf
	EndIf
EndFunc

Func RegKeyExist($key)
	RegRead($key,"")
	If @error > 0 Then
		Return False
	Else
		Return True
	EndIf
EndFunc

Func killproc($pid)
	; kills a process
	While (ProcessExists($pid))
		ProcessClose($pid)
	WEnd
EndFunc

Func getByteSuffix($bytes, ByRef $byteprefix, ByRef $bytesuffix)
	;Formatiert Byte Angaben
	Local $byte = 1
	Local $kilobyte = ($byte * 1024)
	Local $megabyte = ($kilobyte * 1024)
	Local $gigabyte = ($megabyte * 1024)
	Local $terabyte = ($gigabyte * 1024)
	Local $petabyte = ($terabyte * 1024)

	Select
	Case $bytes > $petabyte
		$byteprefix = Round($bytes / $petabyte,2)
		$bytesuffix = "PB"
	Case $bytes > $terabyte
		$byteprefix = Round($bytes / $terabyte,2)
		$bytesuffix = "TB"
	Case $bytes > $gigabyte
		$byteprefix = Round($bytes / $gigabyte,2)
		$bytesuffix = "GB"
	Case $bytes > $megabyte
		$byteprefix = Round($bytes / $megabyte,2)
		$bytesuffix = "MB"
	Case $bytes > $kilobyte
		$byteprefix = Round($bytes / $kilobyte,2)
		$bytesuffix = "KB"
	Case Else
		$byteprefix = $bytes
		$bytesuffix = "Byte"
	EndSelect
EndFunc

Func TimeFormat($time)
Local $hdif,$mdif,$sdif
	$time = $time / 1000
    $hdif = StringFormat('%02d', Int($time / 3600))
    $time = Mod($time, 3600)
    $mdif = StringFormat('%02d', Int($time / 60))
    $sdif = StringFormat('%02d', Int(Mod($time, 60)))
	Return $hdif & ":" & $mdif & ":" & $sdif
EndFunc

Func shortText($instring,$maxlen = 45)
	; shortens a line of text and places '...' in the middle
	; returns string result
	Local $resultstring = ""

	If (StringLen($instring) > $maxlen) Then
		$resultstring = StringLeft($instring, (Int($maxlen / 2) - 2))
		$resultstring = $resultstring & "..."
		$resultstring = $resultstring & StringRight($instring, (Int($maxlen / 2) - 1))
	Else
		$resultstring = $instring
	EndIf
	Return $resultstring
EndFunc

Func getDrive ($inpath)
	; returns the drive for a given path
	Local $tmp
	Local $returnstring
	_PathSplit($inpath, $returnstring, $tmp, $tmp, $tmp)
	Return $returnstring
EndFunc

Func getDirectory ($inpath)
	; returns the directory for a given path
	Local $tmp
	Local $returnstring
	_PathSplit($inpath, $tmp, $returnstring, $tmp, $tmp)
	Return $returnstring
EndFunc

Func getFilename ($inpath)
	; returns the filename for a given path
	Local $tmp
	Local $tmpfilename
	Local $tmpfileext
	Local $returnstring
	_PathSplit($inpath, $tmp, $tmp, $tmpfilename, $tmpfileext)
	$returnstring = $tmpfilename & $tmpfileext
	Return $returnstring
EndFunc

Func validPath ($input)
	; search through invalidChars against input
	Local $invalidCharArray = StringSplit($invalidChars, " ")
	For $x = 1 to $invalidCharArray[0]
		If (StringInStr($input, $invalidCharArray[$x])) Then
			Return 0
		EndIf
	Next
	Return 1
EndFunc

Func debugMsg ($inmsg)
	; show debug message
	If ($debug = 1) Then
		MsgBox(0, "Debug", $inmsg)
	EndIf
EndFunc

Func errorMsg($inmsg)
	; displays error message
	If ($noerror = 0) Then
		MsgBox(16, "Fehler", $inmsg)
	EndIf
EndFunc

Func _DateToMonthGER($iMonth,$ishort = 0)
	Local $MName
	Switch $iMonth
		Case 1
			$MName = "Januar"
		Case 2
			$MName = "Februar"
		Case 3
			$MName = "März"
		Case 4
			$MName = "April"
		Case 5
			$MName = "Mai"
		Case 6
			$MName = "Juni"
		Case 7
			$MName = "Juli"
		Case 8
			$MName = "August"
		Case 9
			$MName = "September"
		Case 10
			$MName = "Oktober"
		Case 11
			$MName = "November"
		Case 12
			$MName = "Dezember"
	EndSwitch
	If $ishort = 1 Then $MName = StringLeft($MName,3)
	Return $MName
EndFunc

Func _DateDayOfWeekGER($iDayNum,$ishort = 0)
	Local $DName
	Switch $iDayNum
		Case 1
			$DName = "Sonntag"
		Case 2
			$DName = "Montag"
		Case 3
			$DName = "Dienstag"
		Case 4
			$DName = "Mittwoch"
		Case 5
			$DName = "Donnerstag"
		Case 6
			$DName = "Freitag"
		Case 7
			$DName = "Samstag"
	EndSwitch
	If $ishort = 1 Then $DName = StringLeft($DName,3)
	Return $DName
EndFunc

Func ReplaceFile($sourcefile,$destfile)
	Local $FOverrideFile,$OverrideIcon,$L1,$L2,$L3,$L4,$L5,$ISourceFile,$IDestFile,$BYes,$BYesAll,$BNo,$BCancel,$nMsg
	Local $focus = 1,$dll,$value,$info,$Icon
	Local $SSize,$SSpre,$SSsuf,$SDate,$DSize,$DSpre,$DSsuf,$DDate

	$SSize = FileGetSize($sourcefile)
	$DSize = FileGetSize($destfile)
	getByteSuffix($SSize,$SSpre,$SSsuf)
	getByteSuffix($DSize,$DSpre,$DSsuf)
	$SDate = FileGetTime($sourcefile)
	$DDate = FileGetTime($destfile)

	#Region ### START Koda GUI section ### Form=E:\AXA\_FileCopyProgress\_Neu\foverridefile.kxf
	$FOverrideFile = GUICreate("Ersetzen von Dateien bestätigen", 451, 274, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
	$OverrideIcon  = GUICtrlCreateIcon("shell32.dll", -67, 16, 16, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
	$L1 = GUICtrlCreateLabel('Dieser Ordner enthält bereits eine Datei' & @CRLF & '"' & shortText($destfile,48) & '".', 72, 16, 281, 33)
	$L2 = GUICtrlCreateLabel("Möchten Sie die existierende Datei", 72, 56, 168, 17)
	$L3 = GUICtrlCreateLabel("Datei: " & shortText(getFilename($destfile)) & @CRLF & "Größe: " & $DSpre & " " & $DSsuf & @CRLF & "geändert: " & _DateDayOfWeekGER(_DateToDayOfWeek($DDate[0],$DDate[1],$DDate[2])) & ", " & $DDate[2] & ". " & _DateToMonthGER($DDate[1]) & " " & $DDate[0] & ", " & $DDate[3] & ":" & $DDate[4] & ":" & $DDate[5], 144, 83, 274, 50)
	$L4 = GUICtrlCreateLabel("mit dieser ersetzen?", 72, 136, 97, 17)
	$L5 = GUICtrlCreateLabel("Datei: " & shortText(getFilename($sourcefile)) & @crlf & "Größe: " & $SSpre & " " & $DSsuf & @CRLF & "geändert: " & _DateDayOfWeekGER(_DateToDayOfWeek($SDate[0],$SDate[1],$SDate[2])) & ", " & $SDate[2] & ". " & _DateToMonthGER($SDate[1]) & " " & $SDate[0] & ", " & $SDate[3] & ":" & $SDate[4] & ":" & $SDate[5], 144, 163, 274, 50)
	$ISourceFile = GUICtrlCreateIcon("shell32.dll", -116, 80, 80, 48, 48, BitOR($SS_NOTIFY,$WS_GROUP))
	$IDestFile   = GUICtrlCreateIcon("shell32.dll", -116, 80, 160, 48, 48, BitOR($SS_NOTIFY,$WS_GROUP))
	$BYes    = GUICtrlCreateButton("Ja", 72, 232, 75, 25, $WS_GROUP)
	$BYesAll = GUICtrlCreateButton("Ja Alle", 160, 232, 75, 25, $WS_GROUP)
	$BNo     = GUICtrlCreateButton("Nein", 248, 232, 75, 25, $WS_GROUP)
	$BCancel = GUICtrlCreateButton("Abbrechen", 336, 232, 75, 25, $WS_GROUP)

	GUICtrlSetState($BYes,$GUI_FOCUS)
	GUICtrlSetImage($ISourceFile,$sourcefile)
	$Icon = GUICtrlSetImage($IDestFile,$sourcefile)
	If $Icon = 0 Then
		$Icon = GetFileTypeApp($sourcefile)
		If (IsNumber($Icon)) and ($Icon = 0) Then
			GUICtrlSetImage($ISourceFile,"shell32.dll",0)
			GUICtrlSetImage($IDestFile,"shell32.dll",0)
		Else
			If $Icon <> 0 Then
				GUICtrlSetImage($ISourceFile,"shell32.dll",$Icon)
				GUICtrlSetImage($IDestFile,"shell32.dll",$Icon)
			Else
				GUICtrlSetImage($ISourceFile,$Icon)
				GUICtrlSetImage($IDestFile,$Icon)
			EndIf
		EndIf
	EndIf
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	$dll = DllOpen("user32.dll")

	While 1
		If _IsPressed("25",$dll) Then
			Sleep(120)
			$focus = $focus - 1
			If $focus < 0 Then $focus = 3
		EndIf
		If _IsPressed("27",$dll) Then
			Sleep(120)
			$focus = $focus + 1
			If $focus > 3 Then $focus = 0
		EndIf
		If _IsPressed("20",$dll) Then
			Sleep(120)
			Send("{ENTER}")
		EndIf
		$info = GUIGetCursorInfo($FOverrideFile)
		;If $info[4] > 0 Then ToolTip("Control: " & $info[4])
		Switch $info[4]
			Case $BCancel
				$focus = 0
			Case $BNo
				$focus = 3
			Case $BYesAll
				$focus = 2
			Case $BYes
				$focus = 1
		EndSwitch
		Switch $focus
			Case 0
				GUICtrlSetState($BCancel,$GUI_FOCUS)
			Case 1
				GUICtrlSetState($BYes,$GUI_FOCUS)
			Case 2
				GUICtrlSetState($BYesAll,$GUI_FOCUS)
			Case 3
				GUICtrlSetState($BNo,$GUI_FOCUS)
		EndSwitch
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE,$BCancel
				$value = 0
				ExitLoop
			Case $BYes
				$value = 1
				ExitLoop
			Case $BYesAll
				$value = 2
				ExitLoop
			Case $BNo
				$value = 3
				ExitLoop
		EndSwitch
	WEnd

	DllClose($dll)
	GUIDelete($FOverrideFile)
	Return $value
EndFunc

Func ReplaceFolder($sourcefolder,$destfolder,$first = 0)
	Local $FOverrideFolder,$OverrideIcon,$L1,$L2,$L3,$L4,$L5,$ISourceFolder,$IDestFolder,$BYes,$BYesAll,$BNo,$BCancel,$nMsg
	Local $Value,$focus = 1,$dll,$info
	Local $SSize,$SSpre,$SSsuf,$SDate,$DSize,$DSpre,$DSsuf,$DDate

	$SSize = DirGetSize($sourcefolder)
	$DSize = DirGetSize($destfolder)
	getByteSuffix($SSize,$SSpre,$SSsuf)
	getByteSuffix($DSize,$DSpre,$DSsuf)
	$SDate = FileGetTime($sourcefolder)
	$DDate = FileGetTime($destfolder)

	#Region ### START Koda GUI section ### Form=E:\AXA\_FileCopyProgress\_Neu\FOverrideFolder.kxf
	$FOverrideFolder = GUICreate("Ersetzen von Ordner bestätigen", 451, 274, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
	$OverrideIcon  = GUICtrlCreateIcon("shell32.dll", -67, 16, 16, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
	If $first = 1 Then
		$L1 = GUICtrlCreateLabel('Der Zielordner existiert bereits' & @CRLF & '"' & $destfolder & '".', 72, 16, 281, 33)
	Else
		$L1 = GUICtrlCreateLabel('Dieser Ordner enthält bereits einen Ordner' & @CRLF & '"' & $destfolder & '".', 72, 16, 281, 33)
	EndIf
	$L2 = GUICtrlCreateLabel("Möchten Sie den existierenden Ordner", 72, 56, 250, 17)
	$L3 = GUICtrlCreateLabel("Ordner: " & $destfolder & @crlf & "Größe: " & $DSpre & " " & $DSsuf & @CRLF & "geändert: " & _DateDayOfWeekGER(_DateToDayOfWeek($DDate[0],$DDate[1],$DDate[2])) & ", " & $DDate[2] & ". " & _DateToMonthGER($DDate[1]) & " " & $DDate[0] & ", " & $DDate[3] & ":" & $DDate[4] & ":" & $DDate[5], 144, 83, 274, 50)
	$L4 = GUICtrlCreateLabel("mit diesem ersetzen?", 72, 136, 250, 17)
	$L5 = GUICtrlCreateLabel("Ordner: " & $sourcefolder & @CRLF & "Größe: " & $SSpre & " " & $DSsuf & @CRLF & "geändert: " & _DateDayOfWeekGER(_DateToDayOfWeek($SDate[0],$SDate[1],$SDate[2])) & ", " & $SDate[2] & ". " & _DateToMonthGER($SDate[1]) & " " & $SDate[0] & ", " & $SDate[3] & ":" & $SDate[4] & ":" & $SDate[5], 144, 163, 274, 50)
	$ISourceFolder = GUICtrlCreateIcon("shell32.dll", -5, 80, 80, 48, 48, BitOR($SS_NOTIFY,$WS_GROUP))
	$IDestFolder   = GUICtrlCreateIcon("shell32.dll", -5, 80, 160, 48, 48, BitOR($SS_NOTIFY,$WS_GROUP))
	$BYes    = GUICtrlCreateButton("Ja", 72, 232, 75, 25, $WS_GROUP)
	$BYesAll = GUICtrlCreateButton("Ja Alle", 160, 232, 75, 25, $WS_GROUP)
	$BNo     = GUICtrlCreateButton("Nein", 248, 232, 75, 25, $WS_GROUP)
	$BCancel = GUICtrlCreateButton("Abbrechen", 336, 232, 75, 25, $WS_GROUP)

	GUICtrlSetState($BYes,$GUI_FOCUS)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	$dll = DllOpen("user32.dll")

	While 1
		If _IsPressed("25",$dll) Then
			Sleep(120)
			$focus = $focus - 1
			If $focus < 0 Then $focus = 3
		EndIf
		If _IsPressed("27",$dll) Then
			Sleep(120)
			$focus = $focus + 1
			If $focus > 3 Then $focus = 0
		EndIf
		If _IsPressed("20",$dll) Then
			Sleep(120)
			Send("{ENTER}")
		EndIf
		$info = GUIGetCursorInfo($FOverrideFolder)
		;If $info[4] > 0 Then ToolTip("Control: " & $info[4])
		Switch $info[4]
			Case $BCancel
				$focus = 0
			Case $BNo
				$focus = 3
			Case $BYesAll
				$focus = 2
			Case $BYes
				$focus = 1
		EndSwitch
		Switch $focus
			Case 0
				GUICtrlSetState($BCancel,$GUI_FOCUS)
			Case 1
				GUICtrlSetState($BYes,$GUI_FOCUS)
			Case 2
				GUICtrlSetState($BYesAll,$GUI_FOCUS)
			Case 3
				GUICtrlSetState($BNo,$GUI_FOCUS)
		EndSwitch
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE,$BCancel
				$Value = 0
				ExitLoop
			Case $BYes
				$Value = 1
				ExitLoop
			Case $BYesAll
				$Value = 2
				ExitLoop
			Case $BNo
				$Value = 3
				ExitLoop
		EndSwitch
	WEnd

	DllClose($dll)
	GUIDelete($FOverrideFolder)
	Return $Value
EndFunc
