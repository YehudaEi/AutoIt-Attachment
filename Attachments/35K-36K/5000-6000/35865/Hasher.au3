#cs
Crypt.au3 Hasher v1.0 Example by money
Licensed under the public domain, use as you wish.
#ce

#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GUIListView.au3>
#include <GuiStatusBar.au3>
#include <Crypt.au3>
#include <Array.au3>

Opt("MustDeclareVars", 0)
Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 0)

Global $hGUI,$mnuFile,$mnuFile_Open,$mnuFile_Save,$mnuFile_Clear,$mnuFile_Exit,$mnuHelp,$mnuHelp_About,$hStatusBar,$hListView
Global $iStatusBarHeight

_Start()

While 1
	Sleep(100)
WEnd

Func _Start()
	_GUI_Create()
	_Crypt_Startup()
EndFunc

Func _End()
	GUIDelete($hGUI)
	_Crypt_Shutdown()
	Exit
EndFunc

Func _Open()
	Local $sFile = FileOpenDialog("Select files", "", "All files (*.*)", 1+2+4, "", $hGUI)
	If (@error = 0) Then
		If StringInStr($sFile, "|") Then
			Local $aFOD = StringSplit($sFile, "|")
			Local $aFiles[$aFOD[0]]
			$aFiles[0] = $aFOD[0]-1
			For $i = 2 To $aFOD[0] ; skipping array count and directory item
;~ 				ConsoleWrite("file: "& $aFOD[$i] &@lf)
				If StringRegExp($aFOD[$i], "(?i)[a-z]:\\.*", 0) Then ;shortcuts includes full paths
					$aFiles[$i-1] = $aFOD[$i]
				Else
					$aFiles[$i-1] = $aFOD[1] &"\"& $aFOD[$i]
				EndIf
			Next
		Else
			Local $aFiles[2] = [1, $sFile]
		EndIf
;~ 		_ArrayDisplay($aFiles)
		_GetHash($aFiles)
	EndIf
EndFunc

Func _GetHash($aFiles)
	Local $aHashAlgo[5] = [4,$CALG_MD2,$CALG_MD4,$CALG_MD5,$CALG_SHA1]
	Local $iItem, $sDigest
	_GUICtrlStatusBar_SetText($hStatusBar, "Busy", 0)
	For $i = 1 To $aFiles[0]
		$iItem = _GUICtrlListView_AddItem($hListView, $aFiles[$i])
		For $x = 1 To $aHashAlgo[0]
			$sDigest = Hex(_Crypt_HashFile($aFiles[$i], $aHashAlgo[$x]))
			_GUICtrlListView_SetItemText($hListView, $iItem, $sDigest, $x)
		Next
	Next
	_GUICtrlStatusBar_SetText($hStatusBar, "Ready", 0)
EndFunc

Func _Clear()
	_GUICtrlListView_BeginUpdate($hListView)
	_GUICtrlListView_DeleteAllItems($hListView)
	_GUICtrlListView_EndUpdate($hListView)
EndFunc

Func _Save()
	Local $iCount = _GUICtrlListView_GetItemCount($hListView)
	If $iCount < 1 Then Return MsgBox(48, "Warning", "No items to save")
	Local $iError, $sFile = FileSaveDialog("Save file to", "", "Text file (*.*)", 2 + 16, "", $hGUI)
	If (@error = 0) Then
		Local $hFile = FileOpen($sFile, 2 + 256)
		If @error Then Return MsgBox(16, "Error", "Could not open for writing. error-code: "&@error & @crlf)
		Local $sData = ""
		For $i = 0 To $iCount-1
			$sData &= _GUICtrlListView_GetItemTextString($hListView, $i) &@CRLF
		Next
		$sData = StringTrimRight($sData,2)
		FileWrite($hFile, $sData)
		$iError = @error
		FileClose($hFile)
		If $iError Then Return MsgBox(16, "Error", "Could not save data. error-code: "&$iError & @crlf)
	EndIf
EndFunc

Func _About()
	MsgBox(64, 'About', StringFormat('Crypt.au3 Hasher v1.0\r\n\r\nexample by money\r\nLicensed under the public domain'))
EndFunc

Func _GUI_Create()
	; gui
	$hGUI = GUICreate("Crypt.au3 Hasher v1.0", 793, 478, -1, -1, _
	BitOr($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), $WS_EX_ACCEPTFILES)

	; menu
	$mnuFile = GUICtrlCreateMenu("&File")
	$mnuFile_Open = GUICtrlCreateMenuItem("&Open", $mnuFile)
	$mnuFile_Save = GUICtrlCreateMenuItem("&Save", $mnuFile)
	$mnuFile_Clear = GUICtrlCreateMenuItem("&Clear", $mnuFile)
	GUICtrlCreateMenuItem("", $mnuFile)
	$mnuFile_Exit = GUICtrlCreateMenuItem("&Exit", $mnuFile)
	$mnuHelp = GUICtrlCreateMenu("&Help")
	$mnuHelp_About = GUICtrlCreateMenuItem("&About", $mnuHelp)

	; statusbar
	Local $aParts[4] = [75, 250]
	$hStatusBar = _GUICtrlStatusBar_Create($hGUI)
	_GUICtrlStatusBar_SetParts ($hStatusBar, $aParts)
	_GUICtrlStatusBar_SetText($hStatusBar, "Ready", 0)
	_GUICtrlStatusBar_SetMinHeight ($hStatusBar, 20)
	_GUICtrlStatusBar_SetUnicodeFormat($hStatusBar, True)
	$iStatusBarHeight = _GUICtrlStatusBar_GetHeight($hStatusBar) + 5

	; listview
	Local $aSize = WinGetClientSize($hGUI)
	$hListView = _GUICtrlListView_Create($hGUI, "", 0, 0, $aSize[0],($aSize[1] - $iStatusBarHeight), _
	BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT, $WS_BORDER), $WS_EX_CLIENTEDGE)
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP, $LVS_EX_DOUBLEBUFFER))
	_GUICtrlListView_SetItemCount($hListView, 1000)
	_GUICtrlListView_SetUnicodeFormat($hListView, True)
	_GUICtrlListView_AddColumn($hListView, "File", 260)
	_GUICtrlListView_AddColumn($hListView, "MD2", 120)
	_GUICtrlListView_AddColumn($hListView, "MD4", 120)
	_GUICtrlListView_AddColumn($hListView, "MD5", 120)
	_GUICtrlListView_AddColumn($hListView, "SHA1", 120)

	; accelerator
	Local $aAccel[3][2] = [["^o", $mnuFile_Open],["^w", $mnuFile_Clear],["{f1}", $mnuHelp_About]]
	GUISetAccelerators($aAccel, $hGUI)

	; events
	GUISetOnEvent($GUI_EVENT_CLOSE, "_End")
	GUICtrlSetOnEvent($mnuFile_Open, "_Open")
	GUICtrlSetOnEvent($mnuFile_Save, "_Save")
	GUICtrlSetOnEvent($mnuFile_Clear, "_Clear")
	GUICtrlSetOnEvent($mnuFile_Exit, "_End")
	GUICtrlSetOnEvent($mnuHelp_About, "_About")

	; messages
	Local $WM_DROPFILES = 0x233
	GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES")
	GUIRegisterMsg($WM_SIZE, "WM_SIZE")

	GUISetState(@SW_SHOW)
EndFunc

Func WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam
	If $hWnd = $hGUI Then
		Local $iW = BitAND($ilParam, 0xFFFF)
		Local $iH = BitShift($ilParam, 16)
		WinMove($hListView, "", 0, 0, ($iW), ($iH - $iStatusBarHeight) )
		_GUICtrlStatusBar_Resize ($hStatusBar)
	EndIf
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

Func WM_DROPFILES($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam
	Local $aFile = _WinAPI_DragQueryFileEx($iwParam, 1)
	If Not @error Then _GetHash($aFile)
	_WinAPI_DragFinish($iwParam)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WinAPI_DragQueryFileEx

;============================================================================================================
; The functions below are from WinAPIEx by Yashied: http://www.autoitscript.com/forum/topic/98712-winapiex-udf/
;============================================================================================================
Func _WinAPI_DragQueryFileEx($hDrop, $iFlag = 0)
	Local $Ret, $Count, $Dir, $File, $tData, $aData[1] = [0]
	$Ret = DllCall('shell32.dll', 'int', 'DragQueryFileW', 'ptr', $hDrop, 'uint', -1, 'ptr', 0, 'uint', 0)
	If (@error) Or (Not $Ret[0]) Then
		Return SetError(1, 0, 0)
	EndIf
	$Count = $Ret[0]
	ReDim $aData[$Count + 1]
	For $i = 0 To $Count - 1
		$tData = DllStructCreate('wchar[1024]')
		$Ret = DllCall('shell32.dll', 'int', 'DragQueryFileW', 'ptr', $hDrop, 'uint', $i, 'ptr', DllStructGetPtr($tData), 'uint', 1024)
		If Not $Ret[0] Then
			Return SetError(1, 0, 0)
		EndIf
		$File = DllStructGetData($tData, 1)
		$tData = 0
		If $iFlag Then
			$Dir = _WinAPI_PathIsDirectory($File)
			If Not @error Then
				If (($iFlag = 1) And ($Dir)) Or (($iFlag = 2) And (Not $Dir)) Then
					ContinueLoop
				EndIf
			EndIf
		EndIf
		$aData[$i + 1] = $File
		$aData[0] += 1
	Next
	If Not $aData[0] Then
		Return SetError(1, 0, 0)
	EndIf
	ReDim $aData[$aData[0] + 1]
	Return $aData
EndFunc   ;==>_WinAPI_DragQueryFileEx

Func _WinAPI_DragFinish($hDrop)
	DllCall('shell32.dll', 'none', 'DragFinish', 'ptr', $hDrop)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_WinAPI_DragFinish

Func _WinAPI_PathIsDirectory($sPath)
	Local $Ret = DllCall('shlwapi.dll', 'int', 'PathIsDirectoryW', 'wstr', $sPath)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $Ret[0]
EndFunc   ;==>_WinAPI_PathIsDirectory