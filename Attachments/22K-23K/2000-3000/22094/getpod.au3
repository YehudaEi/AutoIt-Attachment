;extract iPod - torels
#include <Array.au3>
Dim $files[1]
Opt("TrayMenuMode", 1)
Global $drivep

_init()
Func _init()
	$drivep = InputBox("Drive", "Please Insert the Drive Path For Your iPod", "H:\", Default, Default, 100)
EndFunc   ;==>_init
If @error = 1 Then Exit
If StringLen($drivep) = 3 And _IsiPod($drivep) Then
	_Store($drivep)
	TrayTip("Elaboration Done", "Right-Click the icon for the menu", 20, 16)
	$all = TrayCreateItem("Extract All")
	$spec = TrayCreateItem("Extract Specific (by search)")
	TrayCreateItem("")
	$exit = TrayCreateItem("Exit")
	While 1
		Switch TrayGetMsg()
			Case $all
				_ExtractAll()
			Case $spec
				_ExtractSpecific()
			Case $exit
				_Exit()
		EndSwitch
	WEnd
Else
	MsgBox(0, "", $drivep & " Is not a Valid Drive")
	_init()
EndIf


Func _Store($drive)
	$dir = FileFindFirstFile($drive & "iPod_Control\Music\*.*")
	While 1
		$sch = FileFindNextFile($dir)
		If @error Then ExitLoop
		$fsc = FileFindFirstFile($drive & "iPod_Control\Music\" & $sch & "\*.*")
		If $fsc = -1 Then TrayTip("Elaborating", $drive & "iPod_Control\Music\" & $sch & "\Elaborating...", 20, 16)
		TrayTip("Elaborating", $drive & "iPod_Control\Music\" & $sch & "\*.*", 20, 16)
		While 1
			$file = FileFindNextFile($fsc)
			If @error Then
				TrayTip("Elaborating", $drive & "iPod_Control\Music\" & $sch & "\Elaborating...", 20, 16)
				ExitLoop
			EndIf
			_ArrayAdd($files, $drive & "iPod_Control\Music\" & $sch & "\" & $file)
		WEnd
		TrayTip("Elaborating", $drive & "iPod_Control\Music\" & $sch & "\Elaborating...", 10, 16)
		If @error Then ExitLoop
	WEnd
EndFunc   ;==>_Store

Func _ExtractAll()
	For $i = 1 To UBound($files) - 1
		TrayTip("Working...", "Copying: " & $files[$i], 20, 16)
		$info = Songinfo($files[$i])
		FileCopy($files[$i], "C:\Music\" & $info[2] & "\" & $info[1] & "\" & $info[3] & " - " & $info[1] & ".mp3", 8)
	Next
EndFunc   ;==>_ExtractAll

Func _ExtractSpecific()
	$v = 0
	$criteria = InputBox("Search", "Please Insert a Search Criteria." & @LF & "Order: Artist Title Album" & @LF & "eg. Metallica One" & @LF & "eg2. Duality" & @LF & _
			"If you enter two or more parameters they MUST follow the order or no file will be found")
	For $i = 1 To UBound($files) - 1
		$info = Songinfo($files[$i])
		TrayTip("Working...", "Analyzing: " & $files[$i], 20, 16)
		$line = $info[2] & " " & $info[3] & " " & $info[1]
		If StringInStr($line, $criteria) Then
			TrayTip("Copying...", "Copying: " & $files[$i], 20, 16)
			FileCopy($files[$i], "C:\Music\" & $info[2] & "\" & $info[3] & "\" & $info[2] & " - " & $info[1] & ".mp3", 8)
			$v += 1
		EndIf
	Next
	If $v = 0 Then
		TrayTip("GetPod", "No Tracks Found!", 20, 16)
	Else
		TrayTip("GetPod", $v & " Tracks Found!", 20, 16)
	EndIf
EndFunc   ;==>_ExtractSpecific

Func _IsiPod($drive)
	If DriveGetType($drive) = "removable" And FileExists($drive & "iPod_Control\iTunes\") Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_IsiPod

Func Songinfo($file) ;Finds Title|Author|Album for any media file
	Dim $return[5]
	$return[1] = _GetExtProperty($file, 10);name
	$return[2] = _GetExtProperty($file, 16);atrist
	$return[3] = _GetExtProperty($file, 17);album
	
	If $return[1] = "" Or $return[1] = "Unknown" Then $return[1] = "No_name_" & Floor(Random(0, 100))
	If $return[2] = "" Or $return[2] = "Unknown" Then $return[2] = "Unknown_Artist"
	If $return[3] = "" Or $return[3] = "Unknown" Then $return[3] = "Unknown_Album"
	
	Return $return
EndFunc   ;==>Songinfo

Func _GetExtProperty($sPath, $iProp)
	Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
	$iExist = FileExists($sPath)
	If $iExist = 0 Then
		SetError(1)
		Return 0
	Else
		$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
		$sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
		$oShellApp = ObjCreate("shell.application")
		$oDir = $oShellApp.NameSpace($sDir)
		$oFile = $oDir.Parsename($sFile)
		If $iProp = -1 Then
			Local $aProperty[35]
			For $i = 0 To 34
				$aProperty[$i] = $oDir.GetDetailsOf($oFile, $i)
			Next
			Return $aProperty
		Else
			$sProperty = $oDir.GetDetailsOf($oFile, $iProp)
			If $sProperty = "" Then
				Return "Unknown"
			Else
				Return $sProperty
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GetExtProperty

Func _Exit()
	Exit
EndFunc   ;==>_Exit