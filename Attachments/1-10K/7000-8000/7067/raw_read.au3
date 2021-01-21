#NoTrayIcon

_Exist()

Global Const $WS_EX_TOOLWINDOW			= 0x00000080
Global Const $ES_NUMBER				= 0x00002000
Global Const $BS_DEFPUSHBUTTON			= 0x00000001
Global Const $GUI_EVENT_CLOSE			= -3
Global Const $GUI_CHECKED			= 1



$gui = GUICreate("#  Raw Read", 363, 21, Default, Default, Default, $WS_EX_TOOLWINDOW)
$combo = GUICtrlCreateCombo("A:", 0, 0, 40, 20)
GUICtrlSetData($combo, _FillCombo())
$size = GUICtrlCreateInput("512", 40, 0, 40, 21, $ES_NUMBER)
$dest = GUICtrlCreateInput(@ScriptDir & "\out.bin", 80, 0, 180, 21)
$start = GUICtrlCreateButton("Start", 260, 0, 40, 21, $BS_DEFPUSHBUTTON)
$compress = GUICtrlCreateCheckBox("Compress", 300, 4, 63, 13)

GUICtrlSetState($compress, $GUI_CHECKED)
GUISetState()

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $start
			_RawRW(GUICtrlRead($dest), GUICtrlRead($combo), GUICtrlRead($size), (GUICtrlRead($compress) = $GUI_CHECKED))
			Switch @error
				Case 0
					MsgBox(0, "Raw Read", "Read Complete!")
				Case 1
					mError("Invalid destination path.")
				Case 2
					mError("Read error. Drive " & GUICtrlRead($combo) & " not ready.")
				Case 3
					mError("Write error. Drive " & StringUpper(StringLeft(GUICtrlRead($dest), 2)) & " not ready.")
				Case 4
					mError("Error creating zip.")
				Case 5
					mError("Error compressing image.")
				Case Else
					mError("Internal error.", 1)
			EndSwitch
	EndSwitch
	Sleep(10)
WEnd

Func _Exist( $f = 0 )
	Local $h = DllCall("kernel32.dll", "int", "CreateMutex", "int", 0, "long", 1, "str", StringReplace(@ScriptFullPath & ":" & @ComputerName, "\", "..")), $l = DllCall("kernel32.dll", "int", "GetLastError")
	If $l[0] = 183 and $f = 0 Then Exit
	SetError($l[0])
	Return $h[0]
EndFunc

Func _FillCombo()
	Local $sRet = "", $i
	For $i = 66 To 90
		$sRet &= Chr($i) & ":|"
	Next
	Return StringTrimRight($sRet, 1)
EndFunc

Func _RawRW( $sDestination, $sDriveLetter, $iSectorSize, $bCompress )
	If StringLen($sDestination) < 4 Then
		SetError(1)
		Return ""
	EndIf
	If StringMid($sDestination, 2, 2) <> ":\" Then
		SetError(1)
		Return ""
	EndIf
	If DriveStatus($sDriveLetter) <> "READY" Then
		SetError(2)
		Return ""
	EndIf
	If DriveStatus(StringLeft($sDestination, 2)) <> "READY" Then
		SetError(3)
		Return ""
	EndIf
	Local $sData = "", $hFile = FileOpen("\\.\" & $sDriveLetter, 4)
	While not @error
		$sData &= FileRead($hFile, $iSectorSize)
	WEnd
	FileClose($hFile)
	If $sData = "" Then
		SetError(3)
		Return ""
	EndIf
	$hFile = FileOpen($sDestination, 2)
	If @error Then
		SetError(3)
		Return ""
	EndIf
	FileWrite($hFile, $sData)
	FileClose($hFile)
	If not $bCompress Then Return ""
	_ZipCreate($sDestination & ".zip")
	If @error Then
		FileDelete($sDestination & ".zip")
		SetError(4)
		Return ""
	EndIf
	_ZipAdd($sDestination & ".zip", $sDestination)
	If @error Then
		FileDelete($sDestination & ".zip")
		SetError(5)
		Return ""
	EndIf
	FileDelete($sDestination)
	Return 1
EndFunc

Func _ZipCreate( $sZip )
	If not StringLen(Chr(0)) Then Return SetError(1)
	Local $sHeader = Chr(80) & Chr(75) & Chr(5) & Chr(6), $hFile
	For $i = 1 to 18
		$sHeader &= Chr(0)
	Next
	$hFile = FileOpen($sZip, 2)
	FileWrite($hFile, $sHeader)
	FileClose($hFile)
EndFunc

Func _ZipAdd( $sZip, $sFile )
	If not StringLen(Chr(0)) Then Return SetError(1)
	If not FileExists($sZip) or not FileExists($sFile) Then Return SetError(2)
	Local $oShell = ObjCreate("Shell.Application")
	If @error or not IsObj($oShell) Then Return SetError(3)
	Local $oFolder = $oShell.NameSpace($sZip)
	If @error or not IsObj($oFolder) Then Return SetError(4)
	$oFolder.CopyHere($sFile)
	Sleep(500)
EndFunc

Func mError($sText, $iFatal = 0, $sTitle = "Error", $iOpt = 0)
	Local $ret = MsgBox(48 + 4096 + 262144 + $iOpt, $sTitle, $sText)
	If $iFatal Then Exit
	Return $ret
EndFunc