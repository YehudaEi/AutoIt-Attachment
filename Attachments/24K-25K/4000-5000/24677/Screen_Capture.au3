;
;Screen Capture
;v.0.1
;written by Jared Epstein
#include <GUIConstants.au3>
#include <GUIListView.au3>
#include <ScreenCapture.au3>

main()

Func main()
	Local $name = "Screen Capture"
	Dim $handles[50], $titles[50]
	Local $main, $listview, $desktop, $winpid, $winpath, $capture, $msg, $index, $handle
	$main = GUICreate($name, 295, 210)
	$listview = GUICtrlCreateListView("Window Title", 10, 10, 275, 155, BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
	$desktop = _WinAPI_GetDesktopWindow ()
	$windows = WinList()
	GUICtrlCreateListViewItem("Desktop", $listview)
	GUICtrlSetImage(-1, "shell32.dll", 35)
	$x = 1
	For $i = 1 To $windows[0][0]
		$winpid = WinGetProcess($windows[$i][0], "")
		If $windows[$i][0] <> "" And IsVisible($windows[$i][1]) Then
			$winpath = _ProcessGetPath($winpid)
			GUICtrlCreateListViewItem($windows[$i][0], $listview)
			GUICtrlSetImage(-1, "shell32.dll", 3)
			GUICtrlSetImage(-1, $winpath, 1)
			$handles[$x] = $windows[$i][1]
			$titles[$x] = $windows[$i][0]
			$x = $x + 1
		EndIf
	Next
	_GUICtrlListView_SetColumnWidth ($listview, 0, $LVSCW_AUTOSIZE)
	$capture = GUICtrlCreateButton("Capture", 110, 175, 75, 25)
	GUISetState()
	Do
		$msg = GUIGetMsg()
		
		If $msg = $capture Then
			$index = _GuiCtrlListView_GetSelectedIndices ($listview)
			If $index = 0 Then
				$handle = $desktop
				$title = "Desktop"
			Else
				$handle = $handles[$index]
				$title = $titles[$index]
			EndIf
			_Capture($main, $handle, $title)
		EndIf
	Until $msg = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>main

Func _Capture($hGui, $hWnd, $sTitle)
	Local $savepath, $image, $errorcheck, $open
	$savepath = FileSaveDialog("Save Screenshot", @HomeDrive, "Images (*.bmp;*.gif;*.jpg;*.png;*.tif)", 18, "", $hGui)
	If @error <> 1 Then
		GUISetState(@SW_HIDE, $hGui)
		If $sTitle <> "Desktop" Then
			WinSetState($sTitle, "", @SW_SHOW)
			WinSetState($sTitle, "", @SW_RESTORE)
		EndIf
		$image = _ScreenCapture_CaptureWnd ("", $hWnd, 0, 0, -1, -1, False)
		$errorcheck = _ScreenCapture_SaveImage ($savepath, $image, True)
		GUISetState(@SW_SHOW, $hGui)
		If $errorcheck = False Then
			_WinAPI_DeleteObject ($image)
		Else
			$open = MsgBox(36, "Open Image?", "Would you like to open the image?")
			If $open = 6 Then
				ShellExecute($savepath)
			Else
			EndIf
		EndIf
	Else
	EndIf
EndFunc   ;==>_Capture

Func _ProcessGetPath($pid)
	If IsString($pid) Then $pid = ProcessExists($pid)
	$Path = DllStructCreate("char[1000]")
	$dll = DllOpen("Kernel32.dll")
	$handle = DllCall($dll, "int", "OpenProcess", "dword", 0x0400 + 0x0010, "int", 0, "dword", $pid)
	$ret = DllCall("Psapi.dll", "long", "GetModuleFileNameEx", "long", $handle[0], "int", 0, "ptr", DllStructGetPtr($Path), "long", DllStructGetSize($Path))
	$ret = DllCall($dll, "int", "CloseHandle", "hwnd", $handle[0])
	DllClose($dll)
	Return DllStructGetData($Path, 1)
EndFunc   ;==>_ProcessGetPath

Func IsVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible