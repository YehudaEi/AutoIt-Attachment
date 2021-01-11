;===============================================================================
;
; Program Name:    Lyrics Syncer
; Description::    Edits and displays lyrics synced to the music
; Requirement(s):  AutoIt Beta v3.2.1.2++
; Author(s):	   RazerM
;
;===============================================================================
;
#NoTrayIcon
#include <GUIConstants.au3>
#include <Sound.au3>
#include <GUILIstView.au3>
#include <GuiStatusBar.au3>
#include <file.au3>
#include <array.au3>

Opt("GUIOnEventMode", 1)
$main = GUICreate("Lyrics Syncer", 650, 470)
GUICtrlCreateLabel("Sound File:", 10, 13)
$FileInput = GUICtrlCreateInput("Click Browse", 70, 10, 435)
$browse = GUICtrlCreateButton("Browse", 510, 10, 60, 21)
GUICtrlSetOnEvent(-1, "_EventHandler")
$load = GUICtrlCreateButton("Load", 575, 10, 60, 21)
GUICtrlSetOnEvent(-1, "_EventHandler")
$lyrics = GUICtrlCreateListView("Time|Lyrics", 10, 40, 630, 200, $LVS_SHOWSELALWAYS, $LVS_EX_HEADERDRAGDROP + $LVS_EX_FULLROWSELECT)
_GUICtrlListViewSetColumnWidth($lyrics, 0, 60)
_GUICtrlListViewSetColumnWidth($lyrics, 1, $LVSCW_AUTOSIZE_USEHEADER)
$addMin = GUICtrlCreateInput("0", 10, 245, 40, 20)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 59, 0)
GUICtrlCreateLabel(":", 51, 245)
$addSec = GUICtrlCreateInput("0", 55, 245, 40, 20)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 59, 0)
$addText = GUICtrlCreateInput("", 100, 245, 435, 20)
$addLyric = GUICtrlCreateButton("Add Lyric At 00:00", 540, 245, 100, 20)
GUICtrlSetOnEvent(-1, "_EventHandler")

GUICtrlCreateLabel("From:", 10, 280)
$minFrom = GUICtrlCreateInput(0, 10, 300, 40, 20)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 59, 0)
GUICtrlCreateLabel(":", 51, 300)
$secFrom = GUICtrlCreateInput(0, 55, 300, 40, 20)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 59, 0)

GUICtrlCreateLabel("To:", 10, 330)
$minTo = GUICtrlCreateInput(0, 10, 350, 40, 20)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 59, 0)
GUICtrlCreateLabel(":", 51, 350)
$secTo = GUICtrlCreateInput(0, 55, 350, 40, 20)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 59, 0)

$endTo = GUICtrlCreateButton("End", 100, 350, 50, 20)
GUICtrlSetOnEvent(-1, "_EventHandler")
$play = GUICtrlCreateButton("Play 00:00 to 00:00", 10, 380, 140, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$pause = GUICtrlCreateButton("Pause", 10, 410, 67, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$resume = GUICtrlCreateButton("Resume", 83, 410, 67, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$lyricDisplay = GUICtrlCreateLabel("", 115, 280, 520, 25, $SS_CENTER)
GUICtrlSetFont(-1, 14)
$border = GUICtrlCreateGraphic(110, 275, 530, 35)
GUICtrlSetColor(-1, 0x000000)
Local $panelWidth[3] = [100, 400, 650]
Local $panelText[3] = ["Idle", "00:00/00:00", ""]
If StringInStr(@OSTYPE, "WIN32_NT") Then
	$prev = DllCall("uxtheme.dll", "int", "GetThemeAppProperties");, "int", 0)
	DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
EndIf
$statusBar = _GuiCtrlStatusBarCreate($main, $panelWidth, $panelText)
_GuiCtrlStatusBarSetBKColor($statusBar, 0x1993cb)
$Progress = _GUICtrlStatusBarCreateProgress($statusBar, 2, $PBS_SMOOTH)
GUICtrlSetBkColor($Progress, 0x1993cb)
GUICtrlSetColor($Progress, 0xff9c01)
If StringInStr(@OSTYPE, "WIN32_NT") Then
	DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", $prev[0])
EndIf

GUICtrlCreateGroup("ListView", 160, 320, 235, 85)
$removeLyric = GUICtrlCreateButton("Delete Selected Lyrics", 165, 340, 130, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$deleteAllLyrics = GUICtrlCreateButton("Delete All Lyrics", 300, 340, 90, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$sortLyric = GUICtrlCreateButton("Sort List", 165, 370, 80, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$loadText = GUICtrlCreateButton("Load Lyrics From Text File", 250, 370, 140, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")

$editMin = GUICtrlCreateInput(0, 160, 410, 40, 20)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 59, 0)
GUICtrlCreateLabel(":", 201, 410)
$editSec = GUICtrlCreateInput(0, 205, 410, 40, 20)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 59, 0)
$editText = GUICtrlCreateInput("", 250, 410, 275, 20)
$editLyric = GUICtrlCreateButton("Edit Selected Lyric", 530, 410, 110, 21)
GUICtrlSetOnEvent(-1, "_EventHandler")

GUICtrlCreateGroup("Lyrics", 400, 320, 235, 85)
$save = GUICtrlCreateButton("Save To File", 405, 340, 80, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$open = GUICtrlCreateButton("Open From File", 490, 340, 90, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")

GUISetOnEvent($GUI_EVENT_CLOSE, "_EventHandler")
GUISetState()

Global $sndID = 0, $playing = 0, $paused = 0
Global $lyricPos = 0, $skip = 0
Global $dispLyric[1][2]
Global Const $MYDOCUMENTS = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}"

AdlibEnable("Update", 500)

Global $selected = 0, $oldselected = -2
While 1
	$selected = _GUICtrlListViewGetCurSel($lyrics)
	If $selected <> $oldselected Then
		If $selected >= 0 Then
			$parts = StringSplit(_GUICtrlListViewGetItemText($lyrics, $selected, 0), ":")
			GUICtrlSetData($editMin, $parts[1])
			GUICtrlSetData($editSec, $parts[2])
			GUICtrlSetData($editText, _GUICtrlListViewGetItemText($lyrics, $selected, 1))
		EndIf
		$oldselected = $selected
	EndIf
	Sleep(700)
WEnd

Func _EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			_SoundClose ($sndID)
			Exit
		Case $browse
			$sndFile = FileOpenDialog("Open", $MYDOCUMENTS, "Sound Files (*.mp3;*.wav)")
			If Not @error Then
				GUICtrlSetData($FileInput, $sndFile)
			EndIf
		Case $load
			If FileExists(GUICtrlRead($FileInput)) Then
				If Not $sndID = 0 Then
					_SoundStop ($sndID)
					_SoundClose ($sndID)
				EndIf
				$sndID = _SoundOpen (GUICtrlRead($FileInput), "LyricsSyncer")
				If @extended <> 0 And @extended <> 1 Then
					MsgBox(262144 + 16, "Error", mciGetErrorString(@extended))
				Else
					MsgBox(262144, "Sound Opened", "The sound has been opened successfully")
				EndIf
			Else
				MsgBox(262144 + 16, "Error", "Cannot Open Sound" & @CRLF & "The file does not exist")
			EndIf
		Case $play
			If Not $sndID = 0 Then
				If _FormatToMs(StringFormat("00:%.2i:%.2i", GUICtrlRead($minTo), GUICtrlRead($secTo))) > _SoundLength ($sndID, 2) Then
					MsgBox(262144 + 16, "Error", "The 'To' fields are greater than the length of the sound")
					For $i = 1 To 2
						GUICtrlSetBkColor($minTo, 0xFF9C01)
						GUICtrlSetBkColor($secTo, 0xFF9C01)
						Sleep(500)
						GUICtrlSetBkColor($minTo, 0xFFFFFF)
						GUICtrlSetBkColor($secTo, 0xFFFFFF)
						Sleep(500)
					Next
				ElseIf _FormatToMs(StringFormat("00:%.2i:%.2i", GUICtrlRead($minTo), GUICtrlRead($secTo))) < _FormatToMs(StringFormat("00:%.2i:%.2i", GUICtrlRead($minFrom), GUICtrlRead($secFrom))) Then
					MsgBox(262144 + 16, "Error", "The 'To' fields are greater than the 'From' fields")
					For $i = 1 To 2
						GUICtrlSetBkColor($minTo, 0xFF9C01)
						GUICtrlSetBkColor($secTo, 0xFF9C01)
						GUICtrlSetBkColor($minFrom, 0xFF9C01)
						GUICtrlSetBkColor($secFrom, 0xFF9C01)
						Sleep(500)
						GUICtrlSetBkColor($minTo, 0xFFFFFF)
						GUICtrlSetBkColor($secTo, 0xFFFFFF)
						GUICtrlSetBkColor($minFrom, 0xFFFFFF)
						GUICtrlSetBkColor($secFrom, 0xFFFFFF)
						Sleep(500)
					Next
				Else
					$tempUBound = _GUICtrlListViewGetItemCount($lyrics)
					If $tempUBound = 0 Then $tempUBound = 1
					ReDim $dispLyric[$tempUBound][2]
					For $i = 0 To _GUICtrlListViewGetItemCount($lyrics) - 1
						If _GUICtrlListViewGetItemText($lyrics, $i, 0) <> "00:00" Then
							$dispLyric[$i][0] = _GUICtrlListViewGetItemText($lyrics, $i, 0)
							$dispLyric[$i][1] = _GUICtrlListViewGetItemText($lyrics, $i, 1)
						EndIf
					Next
					_ArraySort($dispLyric, 0, 0, _GUICtrlListViewGetItemCount($lyrics) - 1, 2)
					_SoundStop($sndID)
					_SoundSeek ($sndID, 0, GUICtrlRead($minFrom), GUICtrlRead($secFrom))
					_SoundPlay ($sndID)
;~ 					Local $iMin = 0, $iSec = 1
;~ 					$tempPos = _Array2DSearch($dispLyric, StringFormat("%.2i:%.2i", GUICtrlRead($minFrom), GUICtrlRead($secFrom)))
;~ 					$temp = _SoundLength ($sndID)
;~ 					$parts = StringSplit($temp, ":")
;~ 					$tempMin = $parts[2]
;~ 					$tempSec = $parts[3]
;~ 					While $tempPos[0] = -1
;~ 						If $iSec = 59 Then
;~ 							$iSec = 0
;~ 							$iMin += 1
;~ 						EndIf
;~ 						If $iMin >= $tempMin And $iSec >= $tempSec Then
;~ 							$tempPos[0] = UBound($dispLyric)
;~ 							ExitLoop
;~ 						EndIf
;~ 						$tempPos = _Array2DSearch($dispLyric, StringFormat("%.2i:%.2i", GUICtrlRead($minFrom) + $iMin, GUICtrlRead($secFrom) + $iSec))
;~ 						$iSec += 1
;~ 					WEnd
;~ 					$lyricPos = $tempPos[0]
					$playing = 1
					$paused = 0
					GUICtrlSetData($lyricDisplay, "")
					
				EndIf
			Else
				MsgBox(262144 + 16, "Error", "No sound has been opened" & @CRLF & "Please browse to a file and click 'Load'")
			EndIf
		Case $endTo
			If Not $sndID = 0 Then
				$length = _SoundLength ($sndID)
				$parts = StringSplit($length, ":")
				GUICtrlSetData($minTo, $parts[2])
				GUICtrlSetData($secTo, $parts[3])
			Else
				MsgBox(262144 + 16, "Error", "No sound has been opened" & @CRLF & "Please browse to a file and click 'Load'")
			EndIf
		Case $pause
			If Not $sndID = 0 Then
				_SoundPause ($sndID)
				$paused = 1
				_GuiCtrlStatusBarSetText($statusBar, "Paused", 0)
			EndIf
		Case $resume
			If Not $sndID = 0 Then
				_SoundResume ($sndID)
				$paused = 0
				_GuiCtrlStatusBarSetText($statusBar, "Playing", 0)
			EndIf
		Case $addLyric
			If GUICtrlRead($addText) = "" Then
				MsgBox(262144 + 16, "Error", "Lyric cannot be blank!")
			Else
				$text = StringFormat("%.2i:%.2i|%s", GUICtrlRead($addMin), GUICtrlRead($addSec), GUICtrlRead($addText))
				GUICtrlCreateListViewItem($text, $lyrics)
			EndIf
		Case $removeLyric
			_GUICtrlListViewDeleteItemsSelected($lyrics)
		Case $sortLyric
			$descending = 0
			_GUICtrlListViewSort($lyrics, $descending, 0)
		Case $deleteAllLyrics
			$ret = MsgBox(262144 + 4 + 48, "Delete All", "This will delete all lyrics from the listview" & @CRLF & "Are you sure?")
			If $ret = 6 Then _GUICtrlListViewDeleteAllItems($lyrics)
		Case $loadText
			$textFile = FileOpenDialog("Open", $MYDOCUMENTS, "Text Files (*.txt)", 1)
			If Not @error Then
				Local $lines
				_FileReadToArray($textFile, $lines)
				If Not @error Then
					For $i = 1 To $lines[0]
						If $lines[$i] <> "" Then GUICtrlCreateListViewItem("00:00" & "|" & $lines[$i], $lyrics)
					Next
				Else
					MsgBox(262144 + 16, "Error", "The file is not valid")
				EndIf
			EndIf
		Case $editLyric
			$text = StringFormat("%.2i:%.2i", GUICtrlRead($editMin), GUICtrlRead($editSec))
			_GUICtrlListViewSetItemText($lyrics, _GUICtrlListViewGetCurSel($lyrics), 0, $text)
			_GUICtrlListViewSetItemText($lyrics, _GUICtrlListViewGetCurSel($lyrics), 1, GUICtrlRead($editText))
		Case $open
			$file = FileOpenDialog("Open", $MYDOCUMENTS, "Ini Files (*.ini)", 1)
			If FileExists($file) Then
				$ini = IniReadSection($file, "Lyrics")
				If @error Then 
					MsgBox(262144 + 16, "Error", "Not a valid lyrics file")
				Else
				For $i = 1 To $ini[0][0]
					GUICtrlCreateListViewItem($ini[$i][0] & "|" & $ini[$i][1], $lyrics)
				Next
				EndIf
			Else
				MsgBox(262144 + 16, "Error", "Error opening file" & @CRLF & "File does not exist")
			EndIf
		Case $save
			Local $error = 0
			$file = FileSaveDialog("Save", $MYDOCUMENTS, "Ini Files (*.ini)", 16, "MyLyrics.ini")
			_CheckExt($file, ".ini")
			FileDelete($file)
			For $i = 0 To _GUICtrlListViewGetItemCount($lyrics) - 1
				If _GUICtrlListViewGetItemText($lyrics, $i, 0) <> "00:00" Then
					If IniWrite($file, "Lyrics", _GUICtrlListViewGetItemText($lyrics, $i, 0), _GUICtrlListViewGetItemText($lyrics, $i, 1)) = 0 Then
						MsgBox(262144 + 16, "Error", "Error saving file" & @CRLF & "File is read only")
						$error = 1
					EndIf
				EndIf
			Next
			FileWriteLine($file, "-Lyric Syncer- by RazerM")
			If $error = 0 Then MsgBox(262144, "Saved", "The lyrics have been saved successfully")
;~ 		Case
;~ 		Case
	EndSwitch
EndFunc   ;==>_EventHandler

Func _CheckExt(ByRef $s_file, $s_ext)
	If StringRight($s_file, StringLen($s_ext)) <> $s_ext Then $s_file = $s_file & $s_ext
EndFunc   ;==>_CheckExt

Func _IsValidTime($sTime)
	$parts = StringSplit($sTime, ":")
	If $parts[0] <> 2 Then Return 0
	If IsInt(Number($parts[1])) = 0 Then Return 0
	If IsInt(Number($parts[2])) = 0 Then Return 0
	If StringLen($parts[1]) > 2 Then Return 0
	If StringLen($parts[2]) > 2 Then Return 0
	Return 1
EndFunc   ;==>_IsValidTime

Func mciGetErrorString($iErr)
	Local $ret = DllCall("winmm.dll", "int", "mciGetErrorStringA", "str", $iErr, "str", "", "int", 65534, "hwnd", 0)
	If IsArray($ret) Then Return $ret[2]
EndFunc   ;==>mciGetErrorString

Func Update()
	Local $text = StringFormat("Play %.2i:%.2i to %.2i:%.2i", GUICtrlRead($minFrom), GUICtrlRead($secFrom), GUICtrlRead($minTo), GUICtrlRead($secTo))
	GUICtrlSetData($play, $text)
	Local $text = StringFormat("Add Lyric At %.2i:%.2i", GUICtrlRead($addMin), GUICtrlRead($addSec))
	GUICtrlSetData($addLyric, $text)
	$skip = 0
	If $playing = 1 And $paused = 0 Then
		If _SoundPos ($sndID) = StringFormat("00:%.2i:%.2i", GUICtrlRead($minTo), GUICtrlRead($secTo)) Then
			_SoundStop ($sndID)
			_GuiCtrlStatusBarSetText($statusBar, "Idle", 0)
			GUICtrlSetData($Progress, 0)
			$playing = 0
			$skip = 1
		EndIf
;~ 		If $lyricPos = UBound($dispLyric, 1) Then $skip = 2
		If $skip = 0 Or $skip = 2 Then
			$descending = 0
			If $skip = 0 Then
				$iPos = _Array2DSearch($dispLyric, StringTrimLeft(_SoundPos ($sndID), 3))
				If $iPos[0] <> -1 Then
					GUICtrlSetData($lyricDisplay, $dispLyric[$iPos[0]][1])
;~ 					$lyricPos += 1
				EndIf
			EndIf
			$text = StringFormat("%s/%s", StringTrimLeft(_SoundPos ($sndID), 3), StringTrimLeft(_SoundLength ($sndID), 3))
			_GuiCtrlStatusBarSetText($statusBar, "Playing", 0)
			_GuiCtrlStatusBarSetText($statusBar, $text, 1)
			GUICtrlSetData($Progress, _SoundPos ($sndID, 2) / _SoundLength ($sndID, 2) * 100)
		EndIf
	EndIf
EndFunc   ;==>Update

Func _FormatToMs($sFormat)
	Local $parts, $ms
	$parts = StringSplit($sFormat, ":")
	$ms += $parts[2] * 60 * 1000
	$ms += $parts[3] * 1000
	Return $ms
EndFunc   ;==>_FormatToMs

Func _Array2DSearch(ByRef $avArray, $vWhatToFind, $iElement1Start = -1, $iElement1End = -1, $iElement2Start = -1, $iElement2End = 1)
	Local $iElement1Ubound, $iElement2Ubound, $iElement1, $iElement2, $ret[2]
	$iElement1Ubound = UBound($avArray, 1) - 1
	$iElement2Ubound = UBound($avArray, 2) - 1
	If Not IsArray($avArray) Then
		Return SetError(1, 0, 0)
	EndIf
	If $iElement1Start <> -1 Then
		If $iElement1Start < 0 Or $iElement1Start > $iElement1Ubound Then
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	If $iElement1Start = -1 Then
		$iElement1Start = 0
	EndIf
	If $iElement2Start = -1 Then
		$iElement2Start = 0
	EndIf
	If $iElement2Start <> -1 Then
		If $iElement2Start < 0 Or $iElement2Start > $iElement2Ubound Then
			Return SetError(3, 0, 0)
		EndIf
	EndIf
	If $iElement1End = -1 Then
		$iElement1End = $iElement1Ubound
	EndIf
	If $iElement2End = -1 Then
		$iElement2End = $iElement2Ubound
	EndIf
	If $iElement1End > $iElement1Ubound Or $iElement1End < 0 Then
		Return SetError(4, 0, 0)
	EndIf
	If $iElement2End > $iElement2Ubound Or $iElement2End < 0 Then
		Return SetError(5, 0, 0)
	EndIf
	If $iElement2Ubound = 0 Then
		Return SetError(6, 0, 0)
	EndIf
	For $iElement1 = $iElement1Start To $iElement1End
		For $iElement2 = $iElement2Start To $iElement2End
			If $avArray[$iElement1][$iElement2] = $vWhatToFind Then
				$ret[0] = $iElement1
				$ret[1] = $iElement2
				Return $ret
			EndIf
		Next
	Next
	$ret[0] = -1
	$ret[1] = -1
	SetError(1)
	Return $ret
EndFunc   ;==>_Array2DSearch