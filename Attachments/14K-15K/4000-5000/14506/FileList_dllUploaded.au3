#include <GUIConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <GuiListView.au3>
$GUI = GUICreate("Files", 633, 474)
$ListView = GUICtrlCreateListView("Name|Size|Version", 0, 30, 632, 424, BitOR($LVS_SINGLESEL, $LVS_ICON, $LVS_SHOWSELALWAYS, $WS_VSCROLL))
_GUICtrlListViewSetColumnWidth ($listview, 0, 120)
Dim $FileArray[1]
$FileArray[0] = 0
GUISetState()
$FileListArray = _FileListToArray(@SystemDir, "*.dll")
If Not @error Then
	For $i = 1 To $FileListArray[0]
		$file = $FileListArray[$i]
		If @error Then ExitLoop
		Local $filepath = @SystemDir & "\" & $file
		;Local $author = _GetExtProperty($filepath, 9)
		;If $author = "0" Then $author = ""
		_ArrayAdd($FileArray, GUICtrlCreateListViewItem ($file & "|" & _GetExtProperty ($filepath, 1) & "|" & _GetExtProperty ($filepath, 32), $ListView))
		$FileArray[0] += 1
	Next
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch

WEnd

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
		$oDir = $oShellApp.NameSpace ($sDir)
		$oFile = $oDir.Parsename ($sFile)
		If $iProp = -1 Then
			Local $aProperty[35]
			For $i = 0 To 34
				$aProperty[$i] = $oDir.GetDetailsOf ($oFile, $i)
			Next
			Return $aProperty
		Else
			$sProperty = $oDir.GetDetailsOf ($oFile, $iProp)
			If $sProperty = "" Then
				Return 0
			Else
				Return $sProperty
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GetExtProperty