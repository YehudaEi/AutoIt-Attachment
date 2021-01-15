#include <GUIConstants.au3>
#include <GuiListView.au3>
#Include <GuiList.au3>
#include <inet.au3>
#include <ie.au3>
;OnClick()
AutoItSetOption("WinTitleMatchMode", 2)
HotKeySet('{f8}', '_SaveLink')
HotKeySet('{esc}', '_Exit')
Local $nItem, $total, $bytes_total, $URL, $DIF
Local $sav = 'C:\'
Local $Recent_URLS[1]
$hGUI = GUICreate("~Beege~ YouTube Download Manager", 517, 350, 213, 268)
$hList = GUICtrlCreateListView("", 8, 8, 497, 149)
_GUICtrlListViewInsertColumn($hList, 0, 'Save Name', 0, 233)
_GUICtrlListViewInsertColumn($hList, 1, 'Size', 0, 70)
_GUICtrlListViewInsertColumn($hList, 2, 'URL', 0, 200)
_GUICtrlListViewInsertColumn($hList, 3, '', 0, 1)
$File_Progress = GUICtrlCreateProgress(8, 192, 497, 17)
$Label1 = GUICtrlCreateLabel("Current File: ", 8, 216, 63, 17)
$Delete = GUICtrlCreateButton("Delete", 384, 160, 49, 25, 0)
$total = GUICtrlCreateLabel("Total Files:", 8, 168, 55, 17)
$Label4 = GUICtrlCreateLabel("Total Size:", 232, 168, 54, 17)
$Save_Dir = GUICtrlCreateInput("C:\", 88, 248, 337, 21)
$Total_Files = GUICtrlCreateLabel("0", 72, 168, 146, 17)
$tsize = GUICtrlCreateLabel("0", 296, 168, 74, 17)
$Browse = GUICtrlCreateButton("Browse", 440, 248, 57, 25, 0)
$Clear = GUICtrlCreateButton("Clear All", 456, 160, 49, 25, 0)
$Save = GUICtrlCreateLabel("Save Directory :", 8, 248, 80, 17)
$Exit = GUICtrlCreateButton("Exit", 408, 312, 81, 25, 0)
$Start = GUICtrlCreateButton("Download", 310, 312, 81, 25, 0)
$YouTube = GUICtrlCreateButton("YouTube", 114, 312, 81, 25, 0)
$Help = GUICtrlCreateButton("Help", 16, 312, 81, 25, 0)
$Checkbox1 = GUICtrlCreateCheckbox("", 16, 280, 17, 17)
$Label2 = GUICtrlCreateLabel("Start Downloading Automattically", 40, 280, 159, 17)
$CFProgress = GUICtrlCreateLabel("", 72, 216, 415, 17)
$Abort = GUICtrlCreateButton("Stop Download", 212, 312, 81, 25, 0)
$Checkbox2 = GUICtrlCreateCheckbox("Filecheck", 232, 280, 17, 17)
$Label3 = GUICtrlCreateLabel("Do Not Overwrite Previously Downloaded Files", 256, 280, 224, 17)
GUISetState(@SW_SHOW)
GUICtrlSetState($Checkbox1, $GUI_CHECKED)
GUICtrlSetState($Checkbox2, $GUI_CHECKED)
GUICtrlSetData($Save_Dir, $sav)
Do
	$GUI = GUIGetMsg()
	Select
		Case $GUI = $Browse
			$sav = FileSelectFolder('Select Save Directory', '::{20D04FE0-3AEA-1069-A2D8-08002B30309D}', 7)
			If @error = 1 Then ContinueLoop
			GUICtrlSetData($Save_Dir, $sav)
		Case $GUI = $Help
			_help()
		Case $GUI = $Delete
			$file = _GUICtrlListViewGetCurSel($hList)
			_Delete($file)
		Case $GUI = $Clear
			_GUICtrlListViewDeleteAllItems($hList)
			$bytes_total = 0
			GUICtrlSetData($Total_Files, _GUICtrlListViewGetItemCount($hList))
			GUICtrlSetData($tsize, $bytes_total)
		Case $GUI = $Abort
			GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
			InetGet('abort')
			GUICtrlSetData($File_Progress, 0)
			GUICtrlSetData($CFProgress, '')
		Case $GUI = $Start And _GUICtrlListViewGetItemCount($hList) > 0
			InetGet("abort")
			$Link = StringSplit( _GUICtrlListViewGetItemText($hList, 0), '|')
			InetGet($Link[3], $sav & $Link[1], 1, 1)
			$timer_start = TimerInit()
			Sleep(4000)
			If @InetGetActive = 0 Then
				InetGet("abort")
				_Delete(0)
			EndIf
		Case $GUI = $YouTube
			$oIE = _IECreate("www.youtube.com")
		Case $GUI = $Exit
			Exit
	EndSelect
	Select
		Case @InetGetActive = 1 And @InetGetBytesRead > 0
			$DIF = TimerDiff($timer_start)
			GUICtrlSetData($File_Progress, ((@InetGetBytesRead / $Link[4]) * 100))
			GUICtrlSetData($CFProgress, $Link[1] & '   ' & Round(((@InetGetBytesRead / $Link[4]) * 100), 1) & ' %    ' & Round((@InetGetBytesRead/ ($DIF / 1000)) / 1000, 1) & ' KB\Sec')
			Sleep(20)
		Case @InetGetActive = 0 And GUICtrlRead($File_Progress) >= 1 And _GUICtrlListViewGetItemCount($hList) >= 1
			_Delete(0)
			GUICtrlSetData($Total_Files, _GUICtrlListViewGetItemCount($hList))
			GUICtrlSetData($File_Progress, 0)
			GUICtrlSetData($CFProgress, '')
			If _GUICtrlListViewGetItemCount($hList) >= 1 Then
				$Link = StringSplit( _GUICtrlListViewGetItemText($hList, 0), '|')
				InetGet($Link[3], $sav & $Link[1], 1, 1)
				$timer_start = TimerInit()
			EndIf
			Sleep(15)
		Case @InetGetActive = 0 And GUICtrlRead($Checkbox1) = 1 And _GUICtrlListViewGetItemCount($hList) >= 1 And GUICtrlRead($CFProgress) = 0
			$Link = StringSplit( _GUICtrlListViewGetItemText($hList, 0), '|')
			InetGet($Link[3], $sav & $Link[1], 1, 1)
			Sleep(15)
			$timer_start = TimerInit()
		Case @InetGetActive = 1 And GUICtrlRead($Checkbox1) = 1 And _GUICtrlListViewGetItemCount($hList) >= 1 And @InetGetBytesRead = -1
			InetGet('abort')
			_Delete(0)
			TrayTip('Error Downloading File!!', $Link[1], 10, 2)
	EndSelect
Until $GUI = $GUI_EVENT_CLOSE

Func _SaveLink()
	$dwnlink = StatusbarGetText("Internet Explorer")
	$Link_valid = StringInStr($dwnlink, 'watch?v=')
	If Not $Link_valid = 1 Then
		TrayTip('Not a Valid Link!', '"watch?v=" Must be in the Link', 10, 1)
		Return
	EndIf
	$sCode = _INetGetSource($dwnlink)
	$title = StringRegExp($sCode, '<(?i)title>(.*?)</(?i)title>', 1)
	If Not IsArray($title) Then Return
	$title[0] = StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringTrimLeft($title[0], 10), '[', ''), ']', ''), '*', ''), '?', ''), ':', ''), '!', ''), '"', '') & '.flv'
	If StringLen($title[0]) > 250 Then
		$title[0] = StringLeft($title[0], 250) & '.flv'
	EndIf
	If _CheckDuplicate($title[0]) = 1 Then Return
	$s_t = StringRegExp($sCode, "&t=(.*?)&", 3)
	$s_v = StringMid($dwnlink, StringInStr($dwnlink, "v=") + 2)
	$URL = "http://youtube.com/get_video?video_id=" & $s_v & "&t=" & $s_t[0]
	$bytesize = InetGetSize($URL)
	$bytes_total = $bytesize + $bytes_total
	GUICtrlSetData($tsize, _Bytes_Convert($bytes_total))
	$nItem = GUICtrlCreateListViewItem($title[0] & '|' & _Bytes_Convert($bytesize) & '|' & $URL & '|' & $bytesize, $hList)
	TrayTip('Added Video :', $title[0], 10, 1)
	$traytimer = TimerInit()
	GUICtrlSetData($Total_Files, _GUICtrlListViewGetItemCount($hList))
EndFunc   ;==>_SaveLink

Func _CheckDuplicate(ByRef $filecheck)
	If GUICtrlRead($Checkbox2) = 1 And FileExists($sav & $filecheck) Then
		TrayTip('File Aready in Save Path!!', $sav & $filecheck, 10, 2)
		Return 1
	EndIf
	$Check_Duplicate = _GUICtrlListViewFindItem ($hList, $filecheck, -1, BitOR($LVFI_STRING, $LVFI_WRAP))
	If $Check_Duplicate <> $LV_ERR Then
		TrayTip('File Aready in List!!', 'Item ' & $filecheck + 1, 10, 2)
		Return 1
	EndIf
EndFunc   ;==>_CheckDuplicate

Func _Delete($item)
	If $item = -1 Then $item = 0
	$split = StringSplit(_GUICtrlListViewGetItemText($hList, $item), '|')
	$bytes_total = $bytes_total - $split[4]
	$total = _Bytes_Convert($bytes_total)
	_GUICtrlListViewDeleteItem($hList, $item)
	GUICtrlSetData($Total_Files, _GUICtrlListViewGetItemCount($hList))
	GUICtrlSetData($tsize, $total)
	GUICtrlSetData($CFProgress, '')
EndFunc   ;==>_Delete

Func _Help()
$HelpForm = GUICreate("Help", 887, 749, 176, 112)
GUISetIcon("D:\006.ico")
;$GroupBox1 = GUICtrlCreateGroup("", 24, 0, 625, 737)
$Pic1 = GUICtrlCreatePic("E:\AutoIt\pic.jpg", 40, 16, 601, 457, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Pic2 = GUICtrlCreatePic("E:\AutoIt\link_zoom2.jpg", 40, 488, 609, 249, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Close", 728, 576, 75, 25)
$Edit1 = GUICtrlCreateEdit("", 664, 160, 209, 393)
GUICtrlSetData(-1, StringFormat("Press Youtube Button to Lanch Internet \r\nExplorer and navigate to Youtube \r\nWebsite.\r\n\r\nPut Mouse Pointer over Video Link (NOT\r\nTHE FLASH PLAYER!)  and  Press F8 \r\nto add video to download list.\r\n\r\nPress ESC key to exit Program.\r\n\r\nIf you look at the status bar while mouse \r\npointer is over the video link, it should\r\nhave "&Chr(34)&"watch?v="&Chr(34)&" some where in it. If it \r\ndosent, it probebly wont be added.\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n---NOTE--Some File sizes will show \r\nup 0 bytes when they really are not. \r\nThis is a known bug and program \r\nshould still download the file.\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n"))
GUISetState(@SW_SHOW)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($HelpForm)
			Return
	Case $Button1
			GUIDelete($HelpForm)
			Return
	EndSwitch
WEnd
	;MsgBox(0,'How To Use', 'Press Youtube button to lanch Internet Explorer and take you to Youtube' & @CRLF & 'Place mouse pointer over Video Link (Not the Flash player!) and then press F8 to add Video to Download List' & @CRLF & 'Press ESC button to exit Program' & @CRLF & '---NOTE--Some File sizes will show up 0 bytes when they really are not. This is a known bug and program should still download the file.')
EndFunc

Func _Bytes_Convert($bytes)
	Select
		Case $bytes >= 1024000000
			Return Round($bytes / 1024000000, 2) & ' GB'
		Case $bytes >= 1024000
			Return Round($bytes / 1024000, 2) & ' MB'
		Case $bytes >= 1024
			Return Round($bytes / 1024, 2) & ' KB'
		Case Else
			Return $bytes & ' Bytes'
	EndSelect
EndFunc   ;==>_Bytes_Convert

Func _Exit()
	Exit
EndFunc   ;==>_Exit


;www.Funnyordie.com ---- Links are www2.funnyordie.com/video#.flv

