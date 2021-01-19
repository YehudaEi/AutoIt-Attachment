#include <GUIConstants.au3>
#include <GUIComboBox.au3>
#include <Array.au3>
#include <GuiListView.au3>
#include <Misc.au3>
#include <GDIPlus.au3>
#include <IE.au3>
#include <String.au3>
#NoTrayIcon
_Singleton("Image Converter")
Opt("GUIOnEventMode", 1)
Global $WM_DROPFILES = 0x233
Global $Valid
Dim $oTypes, $hFiles[1], $oInvalid, $DropFiles[1]
_IEErrorHandlerRegister()
$oIE = _IECreateEmbedded()
$mainfrm = GUICreate("Fast Image Converter - Ready", 540, 380, 200, 200, $WS_MINIMIZEBOX + $WS_CAPTION + $WS_SYSMENU, $WS_EX_ACCEPTFILES + $WS_EX_CLIENTEDGE + $WS_EX_TOPMOST)
$Dirinput = GUICtrlCreateInput(@DesktopDir & "\", 8, 8, 425, 25, $ES_READONLY)
$Browse = GUICtrlCreateButton("Browse", 440, 8, 97, 25, 0)
$FileList = GUICtrlCreateListView("Image Name|Image Size|File Size|Image Directory", 8, 40, 249, 273, $LVS_SHOWSELALWAYS, $LVS_EX_CHECKBOXES + $LVS_EX_FULLROWSELECT + $WS_EX_ACCEPTFILES)
$FileType = GUICtrlCreateCombo("", 264, 40, 273, 30, $CBS_DROPDOWNLIST)
GUICtrlSetData($FileType, "PNG|JPG|BMP|TIF|GIF", "PNG")
_GUICtrlComboBox_SetCurSel($FileType, 0)
$Group = GUICtrlCreateGroup("Image Preview", 264, 64, 273, 248)
$Image = GUICtrlCreateObj($oIE, 272, 80, 257, 220)
$Convert = GUICtrlCreateButton("Convert Images Now", 8, 352, 249, 25, 0)
$Progress = GUICtrlCreateProgress(264, 320, 273, 25)
$Overall = GUICtrlCreateProgress(264, 352, 273, 25)
$Select = GUICtrlCreateButton("Check All", 8, 320, 57, 25)
GUICtrlSetOnEvent(-1, "_Selection")
GUICtrlSetFont(-1, 9, 400, 0, "Tahoma")
$UnSelect = GUICtrlCreateButton("UnCheck All", 72, 320, 73, 25)
GUICtrlSetOnEvent(-1, "_Selection")
GUICtrlSetFont(-1, 9, 400, 0, "Tahoma")
$Remove = GUICtrlCreateButton("Remove Checked", 152, 320, 105, 25, 0)
GUICtrlSetOnEvent(-1, "_Selection")
GUICtrlSetFont(-1, 9, 400, 0, "Tahoma")
GUICtrlSetFont($Dirinput, 9, 400, 0, "Tahoma")
GUICtrlSetFont($Browse, 9, 400, 0, "Tahoma")
GUICtrlSetFont($FileType, 9, 400, 0, "Tahoma")
GUICtrlSetFont($Convert, 9, 400, 0, "Tahoma")
GUICtrlSetOnEvent($Browse, "_Browse")
GUISetOnEvent($GUI_EVENT_DROPPED, "_DropFile")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Bye")
GUICtrlSetState($FileList, $GUI_DROPACCEPTED)
GUICtrlSetState($Image, $GUI_NODROPACCEPTED)
GUICtrlSetOnEvent($Convert, "_Convert")
GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC")
GUISetState()
$oTypes = _ArrayCreate("PNG", "JPG", "BMP", "TIF", "GIF", "ICO")
$oInvalid = _ArrayCreate("TIF", "ICO")
_IENavigate($oIE, "about:")
_IEHeadInsertEventScript($oIE, "document", "oncontextmenu", "alert('No Context Menu');return false")
_GDIPlus_Startup()
While 1
	Sleep(1)
WEnd
Func _Browse()
	Local $savedir = FileSelectFolder("", "", 1)
	If @error = 1 Then
		Return
	Else
		GUICtrlSetData($Dirinput, $savedir & "\")
	EndIf
EndFunc   ;==>_Browse
Func _DropFile()
	If @GUI_DropId = $FileList Then
		For $i = 0 To UBound($DropFiles) - 1
			If Not StringInStr(FileGetAttrib($DropFiles[$i]), "D") And $DropFiles[$i] = _GetFileData($DropFiles[$i]) Then
				Local $hImage = _GDIPlus_ImageLoadFromFile($DropFiles[$i])
				GUICtrlCreateListViewItem(StringTrimLeft($DropFiles[$i], StringInStr($DropFiles[$i], "\", 0, -1)) & _
						"|" & _GDIPlus_ImageGetWidth($hImage) & " x " & _GDIPlus_ImageGetHeight($hImage) & _
						"|" & _StringAddComma(Round(FileGetSize($DropFiles[$i]) / 1024)) & " KB" & _
						"|" & StringLeft($DropFiles[$i], StringInStr($DropFiles[$i], "\", 0, -1)), $FileList)
				GUICtrlSetOnEvent(-1, "_Preview")
				_GDIPlus_ImageDispose($hImage)
			Else
				If StringInStr(FileGetAttrib(@GUI_DragFile), "D") Then GUICtrlSetData($Dirinput, @GUI_DragFile & "\")
			EndIf
		Next
	EndIf
EndFunc   ;==>_DropFile
Func _GetFileData($oCheck)
	For $i = 0 To UBound($oTypes) - 1
		If StringUpper(StringRight($oCheck, 4)) = "." & $oTypes[$i] And (_GUICtrlListView_GetItemCount($FileList) > 0) Then
			For $ii = 0 To _GUICtrlListView_GetItemCount($FileList) - 1
				If $oCheck = (_GUICtrlListView_GetItemText($FileList, $ii, 3) & _GUICtrlListView_GetItemText($FileList, $ii, 0)) Then Return ""
			Next
			Return $oCheck
		ElseIf (StringRight($oCheck, 4) = "." & $oTypes[$i]) And (_GUICtrlListView_GetItemCount($FileList) = 0) Then
			Return $oCheck
		EndIf
	Next
	Return ""
EndFunc   ;==>_GetFileData
Func _Preview()
	Local $iSelect = _GUICtrlListView_GetHotItem($FileList)
	Local $oImage = String( _GUICtrlListView_GetItemText($FileList, $iSelect, 3) & _GUICtrlListView_GetItemText($FileList, $iSelect, 0))
	If Not FileExists($oImage) Then
		Return
	Else
		For $i = 0 To UBound($oInvalid) - 1
			If $oInvalid[$i] = StringUpper(StringTrimLeft($oImage, StringLen($oImage) - 3)) Then
				_IEBodyWriteHTML($oIE, '<span style = "font-family:tahoma"><left><b>Preview Not Available</b></left></span>')
				Return
			EndIf
		Next
		_IENavigate($oIE, $oImage)
		_IEHeadInsertEventScript($oIE, "document", "oncontextmenu", "alert('No Context Menu');return false")
	EndIf
EndFunc   ;==>_Preview
Func _Bye()
	_GDIPlus_ShutDown()
	Exit
EndFunc   ;==>_Bye
Func _Convert()
	If _GUICtrlListView_GetItemCount($FileList) = 0 Then Return
	Local $xCounter = 0
	For $i = 0 To _GUICtrlListView_GetItemCount($FileList)
		If _GUICtrlListView_GetItemChecked(GUICtrlGetHandle($FileList), $i) Then $xCounter += 1
	Next
	If $xCounter = 0 Then Return
	GUICtrlSetState($Convert, $GUI_DISABLE)
	GUICtrlSetState($Select, $GUI_DISABLE)
	GUICtrlSetState($UnSelect, $GUI_DISABLE)
	GUICtrlSetState($Remove, $GUI_DISABLE)
	GUICtrlSetState($FileList, $GUI_DISABLE)
	GUICtrlSetData($Convert, "Convert processing..Please Wait")
	If Not FileExists(GUICtrlRead($Dirinput)) And StringInStr(FileGetAttrib(GUICtrlRead($Dirinput)), "D") Then DirCreate(GUICtrlRead($Dirinput))
	Local $Ext = _GDIPlus_EncodersGetCLSID($oTypes[_GUICtrlComboBox_GetCurSel($FileType)])
	WinSetTitle($mainfrm, "", "Fast Image Converter - Loading Images from Files")
	GUICtrlSetData($Overall, (100 / 3))
	For $i = 0 To _GUICtrlListView_GetItemCount($FileList)
		If _GUICtrlListView_GetItemChecked(GUICtrlGetHandle($FileList), $i) Then
			$hFiles[UBound($hFiles) - 1] = _GDIPlus_ImageLoadFromFile(_GUICtrlListView_GetItemText($FileList, $i, 3) & _GUICtrlListView_GetItemText($FileList, $i, 0))
			ReDim $hFiles[UBound($hFiles) + 1]
			Sleep(500)
			GUICtrlSetData($Progress, UBound($hFiles) * (100 / $xCounter))
		EndIf
	Next
	GUICtrlSetData($Overall, (100 / 3 * 2))
	WinSetTitle($mainfrm, "", "Fast Image Converter - Converting")
	For $i = 0 To UBound($hFiles) - 1
		GUICtrlSetData($Progress, UBound($hFiles) * (100 / $xCounter))
		_GDIPlus_ImageSaveToFileEx($hFiles[$i], GUICtrlRead($Dirinput) & _GUICtrlListView_GetItemText($FileList, $i, 0) & "." & StringLower($oTypes[_GUICtrlComboBox_GetCurSel($FileType)]), $Ext, 0)
		Sleep(500)
	Next
	GUICtrlSetData($Overall, 100)
	For $i = 0 To UBound($hFiles) - 1
		_GDIPlus_ImageDispose($hFiles[$i])
	Next
	While UBound($hFiles) > 1
		_ArrayPop($hFiles)
	WEnd
	GUICtrlSetState($Select, $GUI_ENABLE)
	GUICtrlSetState($UnSelect, $GUI_ENABLE)
	GUICtrlSetState($Remove, $GUI_ENABLE)
	GUICtrlSetState($FileList, $GUI_ENABLE)
	GUICtrlSetState($Convert, $GUI_ENABLE)
	GUICtrlSetData($Overall, 0)
	GUICtrlSetData($Progress, 0)
	GUICtrlSetData($Convert, "Convert Images Now")
	WinSetTitle($mainfrm, "", "Fast Image Converter - Ready")
EndFunc   ;==>_Convert
Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $DropFiles[$i + 1]
		$DropFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
EndFunc   ;==>WM_DROPFILES_FUNC
Func _Selection()
	Switch @GUI_CtrlId
		Case $Select
			For $i = 0 To _GUICtrlListView_GetItemCount($FileList) - 1
				_GUICtrlListView_SetItemChecked($FileList, $i, True)
			Next
		Case $UnSelect
			For $i = 0 To _GUICtrlListView_GetItemCount($FileList) - 1
				_GUICtrlListView_SetItemChecked($FileList, $i, False)
			Next
		Case $Remove
			Local $oTemp = ""
			For $i = 0 To _GUICtrlListView_GetItemCount($FileList) - 1
				If _GUICtrlListView_GetItemChecked($FileList, $i) Then $oTemp &= _GUICtrlListView_GetItemParam($FileList, $i) & "|"
			Next
			If StringTrimRight($oTemp, 1) <> "" Then
				Dim $SP = StringSplit(StringTrimRight($oTemp, 1), "|")
				For $i = 1 To $SP[0]
					GUICtrlDelete($SP[$i])
				Next
			EndIf
	EndSwitch
EndFunc   ;==>_Selection