#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icos\pplayer.ico
#AutoIt3Wrapper_outfile=pplayer.exe
#AutoIt3Wrapper_Res_Comment=More details at pplayer.net.ms
#AutoIt3Wrapper_Res_Description=PPlayer Beta
#AutoIt3Wrapper_Res_Fileversion=0.9.3
#AutoIt3Wrapper_Res_LegalCopyright=Pascal Kuehne
#AutoIt3Wrapper_Res_Field=Email|pascal.kuehne at googlemail dot com
#AutoIt3Wrapper_Res_Field=Compile Date|%date% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs
	PPlayer is a media player offering many amazing features. It combines Podcasts,Streaming and an intuitive musicsearch in a user designed interface.
	Copyright (C) 2007 Pascal Kühne
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
	For a list of contributors please visit:
	http://pplayer.wiki.sourceforge.net/Contributors
#ce

#region Includes
#include"include\WMP.au3"
#include"include\XSkin.au3"
#include"include\ListView.au3"
#include"include\default\SQLite.au3"
#include"include\default\SQLite.dll.au3"
#include"include\default\GuiStatusBar.au3"
#include"include\default\GUIConstants.au3"
#include"include\default\GuiComboBox.au3"
#endregion

Global $PP_Dir = @ScriptDir & "\"
FileChangeDir($PP_Dir)

Global $Delimiters = '|-|'
If _Singleton("pplayermutex", 1) == 0 Then
	If $CmdLine[0] > 0 Then
		While Not WinExists("PPlayer")
			Sleep(50)
		WEnd
		WinWaitActive("PPlayer - V")
		_AU3COM_SendData("PPlayerPath" & $Delimiters & $CmdLine[1], "PPlayer")
	EndIf
	Exit 0
EndIf

If LoadSetting("infos", "crash", 0) == 1 Then
	$Form2 = GUICreate("PPlayer - Crashsystem", 413, 298, 273, 186)
	$Label1 = GUICtrlCreateLabel( _
	"A problem occured crashing PPlayer." & @CRLF & _
	"If this happened more than once you might consider downloading the latest version. This should fix the problem." & @CRLF & _
	"If you already downloaded the latest version you might consider submitting the problem you're confrontated with to help the development of PPlayer." & @CRLF & _
	"Choose an option below for further action", 8, 8, 404, 193)
	$Combo1 = GUICtrlCreateCombo("", 8, 208, 290, 25)
	GUICtrlSetData(-1,"Submit BugReport|Download Installer|Reset Windowpositions|Disable Plugins")
	$Button1 = GUICtrlCreateButton("Run", 312, 208, 97, 25)
	$Button2 = GUICtrlCreateButton("Continue PPlayer", 8, 240, 185, 49)
	$Button3 = GUICtrlCreateButton("Close PPlayer", 224, 240, 185, 49)
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case - 3
				ExitLoop
			Case $Button1
				debug(GUICtrlRead($Combo1))
				Switch GUICtrlRead($Combo1)
					Case "Submit BugReport"
						ShellExecute("https://sourceforge.net/tracker/?group_id=206085&atid=996243")
					Case "Download Installer"
						ShellExecute("https://sourceforge.net/project/showfiles.php?group_id=206085")
					Case "Reset Windowpositions"
						IniDelete("db\settings.ini","window")
					Case "Disable Plugins"
						FileDelete("Plugins\Plugins.au3")
						FileClose(FileOpen("Plugins\Plugins.au3",1))
						Run("pplayer.exe")
						Exit 0
				EndSwitch
			Case $Button2
				ExitLoop
			Case $Button3
				Exit 0
		EndSwitch
	WEnd
	GUIDelete($Form2)
	SaveSetting("infos", "crash", 1)
Else
	SaveSetting("infos", "crash", 1)
EndIf

Global $Begin = TimerInit()
#region Opts
Global $version = "0.9.5"
Global $releasetimestamp = 1198445371
Global $dbversion = "0.9"
Global $backup = True

If LoadSetting("infos","version","0.9.4") <> $version Then
	SaveSetting("infos","version",$version)
Else
	If $releasetimestamp + 2592000 < _TimeGetStamp() And Info("The support of your version of PPlayer expired. That means its possible that many problems occur due to the Backend is always changed. You might download the latest version of PPlayer to get the recent changes. Do you want to download the latest version?",$MsgBox_YesNo) == $MSGBox_Yes Then DownloadPPlayer()
EndIf
	
If Not @Compiled Then
	If $backup Then
		$file = "backup\pplayer-" & $version & "-" & @MDAY & @MON & @YEAR & @HOUR & @MIN & @SEC & ".au3"
		FileCopy("pplayer.au3", $file)
		If IniRead("backup\bak.ini", $version, IniRead("backup\bak.ini", $version, 0, 1), 0) == FileGetSize($file) Then
			FileDelete($file)
		Else
			IniWrite("backup\bak.ini", $version, 0, IniRead("backup\bak.ini", $version, 0, 1) + 1)
			IniWrite("backup\bak.ini", $version, IniRead("backup\bak.ini", $version, 0, 1), FileGetSize($file))
		EndIf
	EndIf
EndIf

Opt("GUIOnEventMode", 1)
Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)

Global $PP_HP = "http://pplayer.sourceforge.net/access/"

Folders()
; Analysing Plugins
$plugininput = FileRead("Plugins\Plugins.au3")
$sec = IniReadSection("db\settings.ini","Pluginact")
If Not @Error Then
	For $i = 1 To $sec[0][0]
		If $sec[$i][1] == True And Not StringInStr($plugininput,$Sec[$i][0]) Then SaveSetting("Pluginact",$sec[$i][0],False)
	Next
EndIf
$input = StringSplit($plugininput,@CRLF)
If Not @Error Then
	For $i = 1 To $input[0]
		$plugininput = _StringBetween($Input[$i],'"',"\")
		If Not @Error Then SaveSetting("Pluginact",$plugininput[0],True)
	Next
EndIf

Global $Plugins[1]
Global $PluginMenus[1][2]
Global $PluginSettingsTabs[1]

#include "Plugins\Plugins.au3"

PluginTrigger("OnPluginsRegistered")

$Skin_Folder = $PP_Dir & "Skins\" & GetOpt("skin")
If Not FileExists($Skin_Folder) Then DownloadSkin(GetOpt("skin"))
$Icon_Folder = $PP_Dir & "Skins\Default"
$PP_IcoFolder = "resource\" & LoadSetting("settings", "icos", "Metal") & "icos.dll"

If IniRead("db\settings.ini", "settings", "skin", "") == "" Then
	IniWrite("db\settings.ini", "settings", "BkColor", StringTrimLeft(IniRead($Skin_Folder & "\Skin.dat", "color", "background", ""), 2))
	IniWrite("db\settings.ini", "settings", "TextColor", StringTrimLeft(IniRead($Skin_Folder & "\Skin.dat", "color", "fontcolor", ""), 2))
	IniWrite("db\settings.ini", "settings", "skin", GetOpt("skin"))
EndIf

#endregion

Startup()
Player()

#region MAIN (Player(),Playing($id,$DND = False),PlayStream($id,$Filepath),UnknownAll(ByRef $Tag,ByRef $Similar,$Filepath)

Func Player()
	While 1
		If $Playing And UBound($liste) > $activelistid Then
			If GUICtrlRead($ModeCheck[2]) == "Repeat All"  And $activelistid == UBound($liste) - 1 Then
				$activelistid = 0 ;Repeat All
			EndIf
			UpdateLabelAction("Loading " & $liste[$activelistid])
			$Ret = Playing($activelistid) ;Play song
			If $Ret == "Failed"  Then ;Playing returns "Failed" in some cases
				$Ret = Playing($activelistid, True) ;Playing restarted without starting song a second time
				If $Ret == "Failed"  Or $Ret = "Unable"  Then $activelistid += 1
			ElseIf $Ret == "Unable"  Then
				$activelistid += 1 ;Set next id if unable to play
			EndIf
			UpdateLabelAction("")
		Else
			Sleep(50)
		EndIf
	WEnd
EndFunc   ;==>Player

Func Playing($id, $DND = False)
	$Filepath = $liste[$id]
	PluginTrigger("SongType" & StringTrimLeft($Filepath, StringInStr($Filepath, ".", 1, -1)), $id, $Filepath)
	If StringInStr("http|mms", StringLeft($Filepath, 4)) Then PluginTrigger("SongIsStream", $id, $Filepath)
	If $SongCapturedByPlugin Then
		If Not $LeaveWhile And $Playing Then $activelistid += 1
		$SongCapturedByPlugin = False
		Return True
	EndIf
	Dim $tag[9]
	$LeaveWhile = False
	Dim $similar[GUICtrlRead($SettingsPlayModeSlider1) + 1]
	If (Not FileExists($Filepath)) And Not StringInStr($Filepath, "://") Then
		Error("Unable to play song",0,5)
		Return "Unable"
	EndIf
	If Not $DND Then
		If $next_sound <> 0 Then
			$active_sound = $next_sound
		Else
			Stop()
			$active_sound = Play($Filepath)
		EndIf
		PluginTrigger("SongPlayStarted", $id, $Filepath)
		$Playing = True
		$next_sound = 0
		If WMGetState() == "Paused"  Then Pause()
	EndIf
	PluginTrigger("SongLoadingInformation", $id, $Filepath)
	$Dur = Int(WMGetDuration($active_sound))
	If $Dur == 0 Then Return "Failed"
	$activelistid = $id
	CalcPos($active_sound)
	Focus($id)
	If WMGetState() == "Ready"  Then $active_sound = Play($Filepath) ;If not yet play: play!
	If LoadSongInfo($Filepath, $tag, $id) Then ; Load Song Information and display
		LoadSongSimilar($Filepath, $tag, $similar, $id)
		LastPlayed($tag[3], $tag[1])
		UpdateList($id, $tag[3], $tag[1])
	EndIf
	UpdateLabelInfo($tag, $similar)
	If GUICtrlRead($PlayMode[1]) == $GUI_CHECKED Then ; Search for next Song (if selected)
		If GUICtrlRead($PlayMode[2]) == $GUI_CHECKED > 0 Then
			Research()
		Else
			SetNext($similar, $tag)
		EndIf
		PluginTrigger("SongSearched", $id, $tag)
	EndIf
	Showcover($tag)
	Outqueue($tag[3], $tag[1]); Song is no longer in queue
	Focus($id)
	$ActiveSongSimilar = $similar
	$ActiveSongInfo = $tag
	UpdateLabelAction(WMGetState()) ; Set songstate
	WebAnnounce($tag) ;
	Tray_info() ; Display trayinfo
	$Rated = False
	UpdateLabelAction(WMGetState()) ; Set songstate
	PluginTrigger("SongInformationLoaded", $id, $tag)
	Do
		$Pos = WMGetPosition()
		Sleep(50)
	Until WMGetState() = "stopped"  Or $LeaveWhile
	If Not $Playing Then
		UpdateLabelAction(WMGetState())
		While WMGetState() = "stopped"  Or $LeaveWhile
			If $Playing = True Then ExitLoop
			Sleep(10)
		WEnd
	EndIf
	If UBound($liste) - 2 > $activelistid Then
		PluginTrigger("NextSongAvailable")
		If $next_sound = 0 Then
			$oldlistid = $activelistid
			If GUICtrlRead($ModeCheck[2]) == "Repeat"  Then
				$next_sound = Play($liste[$activelistid])
				UpdateLabelAction("Loading " & $liste[$activelistid])
			ElseIf GUICtrlRead($ModeCheck[2]) == "Shuffle"  Then
				Play_active()
			Else
				$next_sound = Play($liste[$activelistid + 1])
				UpdateLabelAction("Loading " & $liste[$activelistid + 1])
			EndIf
			ChangeVol()
		EndIf
	Else
		PluginTrigger("NextSongNotAvailable")
		WMStop()
		GUICtrlSetImage($pause_button, $PP_IcoFolder, 7)
		GUICtrlSetState($ShowAlbum, $GUI_HIDE)
		UpdateLabelInfo(StringSplit("||||||-1|", "|"), StringSplit("|", "|"))
		WebAnnounce()
	EndIf
	If $Pos > $Dur * (LoadSetting("settings","ratetime",90)/100) Then
		PluginTrigger("SongRatingIncreased", $id, $tag, $Dur)
		Rate($Filepath, "1")
		SongHeard($tag, $Dur)
	Else
		PluginTrigger("SongRatingDecreased", $id, $tag)
		Rate($liste[$oldlistid], "-1")
	EndIf
	If GUICtrlRead($ModeCheck[2]) <> "Repeat"  And Not $LeaveWhile Then $activelistid += 1
	PluginTrigger("SongPlayed", $id, $tag)
	UnFocus($id)
	Return True
EndFunc   ;==>Playing

Func ShowCover($tag)
	If LoadSetting("settings","coverload",$GUI_CHECKED) == $GUI_UNCHECKED Then Return ""
	If FileExists(debug(StringLeft($tag[6],StringInStr($tag[6],"\",0,-1)) & "Folder.jpg")) Then
		GUICtrlSetImage($ShowAlbum, StringLeft($tag[6],StringInStr($tag[6],"\",0,-1)) & "Folder.jpg")
		GUICtrlSetState($ShowAlbum, $GUI_SHOW)
		PluginTrigger("SongCoverLoaded")
	ElseIf FileExists("covers\" & $tag[1] & "-" & $tag[2] & ".jpg") Then ; Load Cover if not exists
		GUICtrlSetImage($ShowAlbum, "covers\" & $tag[1] & "-" & $tag[2] & ".jpg")
		GUICtrlSetState($ShowAlbum, $GUI_SHOW)
		PluginTrigger("SongCoverLoaded")
	EndIf
EndFunc

Func LoadSongInfo($Filepath, ByRef $tag, $id = -1)
	$InDB = False
	$tag = QueryDB($Filepath)
	If @error Then
		If $id > -1 Then PluginTrigger("SongNotInDB", $id, $Filepath)
		If Not AddToDB($Filepath) Then
			If $id > -1 Then PluginTrigger("SongNotAddableToDB", $id, $Filepath)
			Dim $tag[9]
			Dim $similar[1]
			UnknownAll($tag, $similar, $Filepath)
		Else
			If $id > -1 Then PluginTrigger("SongAddedToDB", $id, $Filepath)
			LoadSongInfo($Filepath, $tag)
		EndIf
	Else
		If $id > -1 Then PluginTrigger("SongInDB", $id, $tag)
		$InDB = True
	EndIf
	Return $InDB
EndFunc   ;==>LoadSongInfo

Func LoadSongSimilar($Filepath, ByRef $tag, ByRef $similar, $id = -1)
	$similar = LoadSimilar($tag[1])
	If Not IsArray($similar) Then
		If $id > -1 Then PluginTrigger("SongNoSimilarBands", $id, $tag)
		Dim $similar[1]
		UnknownAll($tag, $similar, $Filepath)
	EndIf
EndFunc   ;==>LoadSongSimilar

Func UnknownAll(ByRef $tag, ByRef $similar, $Filepath)
	$tag = ReadFileInfo($Filepath)
	If @error And FileExists($Filepath) Then
		$tag[1] = WMGetArtist($active_sound)
		$tag[2] = WMGetAlbum($active_sound)
		$tag[3] = WMGetTitle($active_sound)
		$tag[4] = WMGetGenre($active_sound)
		$tag[5] = WMGetFileType($active_sound)
	EndIf
	ReDim $tag[9]
	$tag[6] = $Filepath
	$tag[7] = 0
	$tag[8] = 10
	If StringLen($tag[1]) = 0 Then $tag[1] = "Unknown Artist"
	If StringLen($tag[2]) = 0 Then $tag[2] = "Unknown Album"
	If StringLen($tag[3]) = 0 Then $tag[3] = StringTrimLeft($Filepath, StringInStr($Filepath, "\", 1, -1))
	If StringLen($tag[4]) = 0 Then $tag[4] = "Unknown Genre"
	If StringLen($tag[5]) = 0 Then $tag[5] = "Unknown Filetype"
	ReDim $similar[2]
	$similar[1] = "Unknown"
	$similar[0] = 0
	Return True
EndFunc   ;==>UnknownAll

#endregion


#region Play / Playlist (NextInList(),PrevInList(),Play_active(),Play(Filename),Stop(),Pause(),HookPlayPause(),SetNext(Similar,Info,Retry),Research-funcs,Queue-funcs

Func NextInList()
	_GUICtrlListView_SetItemSelected($lieder, $activelistid, False)
	If GUICtrlRead($ModeCheck[2]) <> "Shuffle"  Then _GUICtrlListView_SetItemSelected($lieder, $activelistid + 1)
	Play_active()
EndFunc   ;==>NextInList

Func PrevInList()
	_GUICtrlListView_SetItemSelected($lieder, $activelistid, False)
	If GUICtrlRead($ModeCheck[2]) <> "Shuffle"  Then _GUICtrlListView_SetItemSelected($lieder, $activelistid - 1)
	Play_active()
EndFunc   ;==>PrevInList

Func Play_active()
	$oldlistid2 = $activelistid
	Stop()
	$LeaveWhile = True
	If GUICtrlRead($ModeCheck[2]) == "Shuffle"  Then ;Shuffle
		$Done = False
		For $i = 1 To UBound($liste) - 1
			$activelistid = Random(0, UBound($liste) - 1, 1)
			If StringLen($liste[$activelistid]) > 0 Then
				$tag = QueryDB($liste[$activelistid])
				If IsArray($tag) And $tag[7] + ((UBound($liste) - 2) * 3) * 60 < _TimeGetStamp() Then
					$Done = True
					ExitLoop
				EndIf
			EndIf
		Next
		If Not $Done Then $activelistid = Random(0, UBound($liste) - 1, 1)
		If UBound($liste) - 1 == 0 Then Return ""
	ElseIf GUICtrlRead($ModeCheck[2]) == "Repeat"  Then
		$activelistid = $oldlistid
	ElseIf GUICtrlRead($ModeCheck[2]) == "Repeat All"  And $activelistid == UBound($liste) - 1 Then
		$activelistid = 0 ;Repeat All
	Else
		$dClicked = True
	EndIf
	UnFocus($oldlistid2) ; Next song select - old one unfocused so GetIndices works
	If $dClicked Then
		$ItemSel = _GUICtrlListView_GetSelectedIndices($lieder, True)
		If $ItemSel[0] == 0 Then
			Return ""
		Else
			$activelistid = $ItemSel[1]
		EndIf
	EndIf
	If UBound($liste) - 1 < $activelistid Then Return ""
	$oldlistid = $oldlistid2
	$Playing = True
	$dClicked = False
	Focus($activelistid)
	$next_sound = Play($liste[$activelistid])
	If FileExists($liste[$activelistid]) Then CalcPos($next_sound)
	ChangeVol()
	Dim $tag[9], $similar[1]
	If LoadSongInfo($liste[$activelistid], $tag, $activelistid) Then ; Load Song Information and display
		LoadSongSimilar($liste[$activelistid], $tag, $similar, $activelistid)
		LastPlayed($tag[3], $tag[1])
		UpdateList($activelistid, $tag[3], $tag[1])
	EndIf
	UpdateLabelInfo($tag, $similar)
	PluginTrigger("SongInformationLoaded", $activelistid, $tag)
	ShowCover($tag)
EndFunc   ;==>Play_active

Func Play($filename)
	$active_sound = WMOpenFile($filename)
	If LoadSetting("infos","lastsongpos",0) > 0 Then
		WMSetPosition(LoadSetting("infos","lastsongpos",0))
		SaveSetting("infos","lastsongpos",0)
		UpdateLabelPos($active_sound)
	EndIf
	WMPlay($filename)
	GUICtrlSetImage($pause_button, $PP_IcoFolder, 6)
	Return $active_sound
EndFunc   ;==>Play

Func Stop()
	$Playing = False
	$activelistid = 0
	PluginTrigger("SongPlayStopped")
	WMStop()
	GUICtrlSetImage($pause_button, $PP_IcoFolder, 7)
	GUICtrlSetState($ShowAlbum, $GUI_HIDE)
	UpdateLabelInfo(StringSplit("||||||-1|", "|"), StringSplit("|", "|"))
EndFunc   ;==>Stop

Func Pause()
	Switch WMGetState()
		Case "Playing"
			TrayItemSetText($Tray_Pause, "Resume")
			WMPause()
			PluginTrigger("SongPlayPaused")
			GUICtrlSetImage($pause_button, $PP_IcoFolder, 7)
		Case "Paused"
			TrayItemSetText($Tray_Pause, "Pause")
			GUICtrlSetImage($pause_button, $PP_IcoFolder, 6)
			PluginTrigger("SongPlayResumed")
			WMResume()
		Case Else
			Play_active()
	EndSwitch
EndFunc   ;==>Pause

Func HookPlayPause()
	If $Playing Then
		Pause()
	Else
		Play_active()
	EndIf
EndFunc   ;==>HookPlayPause

Func SetNext($similar, $Info, $Retry = False, $RetryTime = 0)
	If Not IsArray($similar) And Not IsArray($Info) Then Return False
	If GUICtrlRead($ModeCheck[1]) == "Similar Band"  Then
		$Similars = GUICtrlRead($SettingsPlayModeSlider1)
		If UBound($similar) - 1 < $Similars Then $Similars = UBound($similar) - 1
		ReDim $similar[$Similars + 1]
		If $similar[0] == 0 Then
			For $i = 1 To $Similars
				$similar[$i] = $Info[1]
			Next
		EndIf
		$similar[0] = $Info[1]
		$GetSimilar = True
	Else
		$GetSimilar = False
	EndIf
	Local $NextSongs[1]
	Dim $tag[8]
	$msg = 'SELECT * FROM Songs WHERE ' 
	Switch GUICtrlRead($ModeCheck[1])
		Case "Similar Band"
			$msg2 = ''
			For $i = 1 To $Similars
				$msg2 &= 'Artist = "' & $similar[$i] & '" OR '
			Next
			$msg &= StringTrimRight($msg2, 3)
		Case "Genre"
			$msg &= 'Genre = "' & $Info[4] & '"'
		Case "Band"
			$msg &= 'Artist = "' & $Info[1] & '"'
		Case "Album"
			$msg &= 'Album = "' & $Info[2] & '"'
	EndSwitch
	If StringLen(LoadSetting("settings","ExcludedTags","")) > 0 Then
		$Keyword = StringSplit(LoadSetting("settings","ExcludedTags","")," ")
		$msg2 = ""
		For $i = 1 To $Keyword[0]
			$msg2 &= ' AND NOT (Artist LIKE "%' & $Keyword[$i] & '%" OR Genre LIKE "%' & $Keyword[$i] & '%" OR Track LIKE "%' & $Keyword[$i] & '%" OR Album LIKE "%' & $Keyword[$i] & '%" OR Path LIKE "%' & $Keyword[$i] & '%")'
		Next
		$msg &= $msg2
	EndIf
	_SQLite_Query(-1,$msg & ";",$hQuery)
	While _SQLite_FetchData($hQuery, $tag) = $SQLITE_OK
		If FileExists($tag[5]) And Not CheckQueue($tag[2], $tag[0]) And _
				($tag[7] > 1 And ($Retry Or Random(0, 100) > $tag[7] * 4.5)) And _
				(($RetryTime > 6 And $tag[6] + GetOpt("MinLastPlayed") / ($RetryTime * 2) * 60 < _TimeGetStamp()) Or $tag[6] + GetOpt("MinLastPlayed") * 60 < _TimeGetStamp()) Then
			ReDim $NextSongs[UBound($NextSongs) + 1]
			$NextSongs[UBound($NextSongs) - 1] = $tag[5] & "|" & $tag[2] & "|" & $tag[0]
		EndIf
	WEnd
	_SQLite_QueryFinalize($hQuery)
	If UBound($NextSongs) == 1 Then
		If Not $Retry Then
			ErrorWrite("Retry Nr. 1 bei 1")
			SetNext($similar, $Info, True)
			Return False
		ElseIf $RetryTime < 5 Then
			ErrorWrite("Retry Nr. 2 bei 1")
			SetNext($similar, $Info, True, $RetryTime + 1)
			Return False
		Else
			Return False
		EndIf
	EndIf
	$split = StringSplit($NextSongs[Random(1, UBound($NextSongs) - 1, 1)], "|")
	If @error Then
		If Not $Retry Then
			ErrorWrite("Retry Nr. 1 bei 2")
			SetNext($similar, $Info, True)
			Return False
		ElseIf $RetryTime < 5 Then
			ErrorWrite("Retry Nr. 2 bei 2")
			SetNext($similar, $Info, True, $RetryTime + 1)
			Return False
		Else
			Return False
		EndIf
	EndIf
	SetList($split[1])
	UpdateList(UBound($liste) - 1, $split[2], $split[3])
EndFunc   ;==>SetNext

Func Research()
	If $SearchGUI = 0 Then
		$Keyword = GUICtrlRead($PlayModeKeyword)
		If StringLen($Keyword) > 0 Then
			If StringInStr(IniRead("db\settings.ini", "PlayMode", "Combo", ""), $Keyword) == 0 Then
				IniWrite("db\settings.ini", "PlayMode", "Combo", IniRead("db\settings.ini", "PlayMode", "Combo", "") & "|" & $Keyword)
				_GUICtrlComboBox_AddString($PlayModeKeyword, $Keyword)
			EndIf
			$Keyword = StringSplit($Keyword, " ")
			$NoGUI = True
			If GUICtrlRead($PlayMode[2]) == $GUI_UNCHECKED Then
				$SearchWait = False
				Global $SearchGUI = GUICreate("PPlayer - Search", 500, 500, -1, -1, -1, -1, $PlaymodeGUI)
				Global $Searchview = _GUICtrlCreateListView("Track                          |Artist    |Album      |Genre |Rating   |Filepath", 0, 0, 500, 480)
				GUICtrlSetOnEvent(-1, "SearchView")
				__GUICtrlListView_DeleteAllItems($Searchview)
				$Label = GUICtrlCreateLabel("Searching", 10, 480, 480, 20)
				GUISetOnEvent($GUI_EVENT_CLOSE, "SearchEnd")
				GUISetState()
				$NoGUI = False
			EndIf
			$Suc = 0
			Global $SearchResult[1]
			$msg = ""
			For $i = 1 To $Keyword[0]
				If StringLeft($Keyword[$i], 1) == "-"  Then
					$Keyword[$i] = StringTrimLeft($Keyword[$i], 1)
					$msg &= "NOT "
				EndIf
				$msg &= '(Artist LIKE "%' & $Keyword[$i] & '%" OR Genre LIKE "%' & $Keyword[$i] & '%" OR Track LIKE "%' & $Keyword[$i] & '%" OR Album LIKE "%' & $Keyword[$i] & '%" OR Path LIKE "%' & $Keyword[$i] & '%") AND '
			Next
			$msg = StringTrimRight($msg, 4)
			Dim $Query
			_SQLite_Query(-1, "SELECT * FROM Songs WHERE " & $msg & ";", $hQuery) ; the query
			While _SQLite_FetchData($hQuery, $Query) = $SQLITE_OK
				If FileExists($Query[5]) Then
					$Suc += 1
					If GUICtrlRead($PlayMode[2]) == $GUI_UNCHECKED Then _GUICtrlCreateListViewItem($Query[2] & "|" & $Query[0] & "|" & $Query[1] & "|" & $Query[3] & "|" & $Query[7] & "|" & $Query[5], $Searchview)
					ReDim $SearchResult[$Suc + 1][6]
					$SearchResult[$Suc][0] = $Query[5]
					$SearchResult[$Suc][1] = $Query[2]
					$SearchResult[$Suc][2] = $Query[0]
					$SearchResult[$Suc][3] = $Query[1]
					$SearchResult[$Suc][4] = $Query[3]
					$SearchResult[$Suc][5] = $Query[7]
				EndIf
			WEnd
			_SQLite_QueryFinalize($hQuery)
			If Not $NoGUI Then
				$Lol = False
				__GUICtrlListView_Sort($Searchview, $Lol, 0)
				GUICtrlSetData($Label, "Done -- Found " & $Suc & " songs.")
				$SearchWait = True
			Else
				$Number = Random(1, $Suc, 1)
				For $i = 1 To $Suc
					$Number = Random(1, $Suc, 1)
					If FileExists($SearchResult[$Number][0]) And Not CheckQueue($SearchResult[$Number][1], $SearchResult[$Number][2]) And _
							($SearchResult[$Number][5] > 1 And Random(0, (100 - (($i - 1) / $Suc))) > $SearchResult[$Number][5] * 4.5) Then ExitLoop
				Next
				If $Suc > 0 Then SetList($SearchResult[$Number][0])
			EndIf
		Else
			SetNext($ActiveSongSimilar, $ActiveSongInfo)
		EndIf
	EndIf
EndFunc   ;==>Research

Func SearchEnd()
	GUIDelete($SearchGUI)
	$SearchGUI = 0
EndFunc   ;==>SearchEnd

Func SearchView()
	$Lol = False
	If $oldstate == GUICtrlGetState($Searchview) Then $Lol = Not $Lol
	$oldstate = GUICtrlGetState($Searchview)
	__GUICtrlListView_Sort($Searchview, $Lol, GUICtrlGetState($Searchview))
EndFunc   ;==>SearchView

Func Inqueue($Title, $interpret)
	_IniWrite("db\MainDB.ini", $Title & "-" & $interpret, "inqueue", 1)
EndFunc   ;==>Inqueue

Func Outqueue($Title, $interpret)
	IniDelete("db\MainDB.ini", $Title & "-" & $interpret)
EndFunc   ;==>Outqueue

Func CheckQueue($Title, $interpret)
	If IniRead("db\MainDB.ini", $Title & "-" & $interpret, "inqueue", 0) == 0 Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>CheckQueue

#endregion

#region GUIs (Rate,PlayMode,Podcast,Stream,Transfer,Settings,Stat,BugReport)

Func BuildGUIs()
	PlaymodeBuild()
	SettingsBuild()
	StatBuild()
	RateBuild()
EndFunc   ;==>BuildGUIs

#region -> Rate

Func RateBuild()
	Global $RateIcon[22]
	Global $RateGUI = XSkinGUICreate("PPlayer - Rate", 339+$factorX*2, 197+$factorY*2, $Skin_Folder,1,25,-1,-1,-1,$MainGUI)
	XSkinIcon($RateGUI,3,StringSplit("RateClose|RateClose|RateHelp","|"))
	$nr = 0
	For $x = 8 To 296 Step 32
		$nr += 1
		$RateIcon[$nr] = GUICtrlCreateIcon($PP_IcoFolder,12, $x+$factorX, 88+$factorY, 32, 32)
		GUICtrlSetOnEvent(-1,"RateOnClick")
		GUICtrlSetOnHover($RateIcon[$nr],"RateOnHover","RateOffHover")
	Next
	For $x = 8 To 296 Step 32
		$nr += 1
		$RateIcon[$nr] = GUICtrlCreateIcon($PP_IcoFolder,12, $x+$factorX, 120+$factorY, 32, 32)
		GUICtrlSetOnEvent(-1,"RateOnClick")
		GUICtrlSetOnHover($RateIcon[$nr],"RateOnHover","RateOffHover")
	Next
	Global $RateButton1 = GUICtrlCreateButton("Save", 104+$factorX, 160+$factorY, 113, 33, 0)
	GUICtrlSetOnEvent(-1,"RateSave")
	Global $RateLabel1 = GUICtrlCreateLabel("", 8+$factorX, 8+$factorY, 316, 76)
EndFunc   ;==>Rate_GUI

Func RateOnHover($Control)
	$Hover = True
	For $i = 1 To 20
		If $Hover Then
			GUICtrlSetImage($RateIcon[$i],$PP_IcoFolder,12)
		Else
			GUICtrlSetImage($RateIcon[$i],$PP_IcoFolder,13)
		EndIf
		If $Control == $RateIcon[$i] Then $Hover = False
	Next
EndFunc

Func RateOffHover($Control)
	For $i = 1 To $CurrentRating
		GUICtrlSetImage($RateIcon[$i],$PP_IcoFolder,12)
	Next
	For $i = $CurrentRating+1 To 20
		GUICtrlSetImage($RateIcon[$i],$PP_IcoFolder,13)
	Next
EndFunc

Func Rate_GUI()
	$ItemSel = _GUICtrlListView_GetSelectedIndices($lieder, True)
	If $ItemSel[0] == 0 Then
		Error("No song selected!")
		Return ""
	EndIf
	$tag = QueryDB($liste[$ItemSel[1]])
	If Not @Error Then
		$Rating = $tag[8]
	Else
		Error("Song not in DB")
		Return ""
	EndIf
	For $i = 1 To $Rating
		GUICtrlSetImage($RateIcon[$i],$PP_IcoFolder,12)
	Next
	For $i = $Rating+1 To 20
		GUICtrlSetImage($RateIcon[$i],$PP_IcoFolder,13)
	Next
	Global $CurrentRating = $Rating
	Global $CurrentRatingFile = $liste[$ItemSel[1]]
	GUICtrlSetData($RateLabel1,"Artist: " & @tab & @tab & $tag[1] & @CRLF & "Album: " & @tab & @tab & $tag[2] & @CRLF & "Track: " & @tab & @tab & $tag[3] & @CRLF & "Current rating: " & @tab & $tag[8])
	GUISetState(@SW_SHOW,$RateGUI)
EndFunc
	
Func RateClose()
	GUISetState(@SW_Hide,$RateGUI)
EndFunc

Func RateSave()
	_SQLite_Exec(-1, 'UPDATE Songs SET Rating = "' & $CurrentRating & '" WHERE Path = "' & $CurrentRatingFile & '";')
	RateClose()
EndFunc

Func RateHelp()
	ShellExecute("http://pplayer.wiki.sourceforge.net/Rating")
EndFunc

Func RateOnClick()
	$Hover = True
	For $i = 1 To 20
		If $Hover Then
			GUICtrlSetImage($RateIcon[$i],$PP_IcoFolder,12)
			$CurrentRating = $i
		Else
			GUICtrlSetImage($RateIcon[$i],$PP_IcoFolder,13)
		EndIf
		If @GUI_CtrlId == $RateIcon[$i] Then $Hover = False
	Next
EndFunc

#endregion
#region -> Settings

Func SettingsBuild()
	Global $Settings_GUI = GUICreate("PPlayer - Settings", 494, 447, -1, -1, -1, -1, $MainGUI)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Settings_close", $Settings_GUI)
	Global $SettingsButton1 = GUICtrlCreateButton("OK", 232, 400, 81, 41, 0)
	GUICtrlSetOnEvent(-1, "Settings_ok")
	Global $SettingsTab1 = GUICtrlCreateTab(5, 5, 484, 388)
	; - General
	Global $SettingsTabSheet1 = GUICtrlCreateTabItem("General")
	GUICtrlSetState(-1, $GUI_SHOW)
	; General - Design
	Global $SettingsGroup1 = GUICtrlCreateGroup("Design", 8, 32, 473, 282)
	Global $SettingsLabel1 = GUICtrlCreateLabel("Backgroundcolor", 16, 56, 85, 17)
	Global $SettingsLabel2 = GUICtrlCreateLabel("Textcolor", 16, 88, 48, 17)
	Global $SettingsInput1 = GUICtrlCreateInput(GetOpt("BkColor"), 264, 56, 137, 21, $ES_WANTRETURN)
	Global $SettingsButton4 = GUICtrlCreateButton("Choose", 408, 56, 65, 25, 0)
	GUICtrlSetOnEvent(-1, "SettingsChooseColor")
	Global $SettingsInput2 = GUICtrlCreateInput(GetOpt("TextColor"), 264, 88, 137, 21)
	Global $SettingsButton5 = GUICtrlCreateButton("Choose", 408, 88, 65, 25, 0)
	GUICtrlSetOnEvent(-1, "SettingsChooseColor")
	Global $SettingsLabel3 = GUICtrlCreateLabel("Transparency", 16, 120, 69, 17)
	Global $SettingsSlider1 = GUICtrlCreateSlider(264, 120, 209, 25)
	GUICtrlSetLimit(-1, 255, 50)
	GUICtrlSetData(-1, GetOpt("Trans"))
	GUICtrlSetOnEvent(-1, "Settings_Change")
	Global $SettingsLabel4 = GUICtrlCreateLabel("On/Off-Animation", 16, 152, 86, 17)
	Global $SettingsCheckbox1 = GUICtrlCreateCheckbox("", 264, 152, 209, 25)
	GUICtrlSetState(-1, GetOpt("Ani"))
	GUICtrlSetOnEvent(-1, "Settings_Change")
	
	$Files = _FileSearch($PP_Dir & "resource", "*icos.dll", 0, '', True)
	If @Error Then
		If Error("Your Installation misses icons." & @CRLF & "You have to reinstall PPlayer." & @CRLF & "Do you want to get redirected to the download?",4) == 6 Then DownloadPPlayer()
	Else
		GUICtrlCreateLabel("Iconset", 16, 184, 48, 17)
		Global $SettingsCombo3 = GUICtrlCreateCombo("", 264, 184, 209, 25)
		$Text = ""
		For $i = 1 To $Files[0]
			$String = StringTrimLeft($Files[$i], StringInStr($Files[$i], "\", 0, -1))
			$Text &= StringTrimRight($String, 8) & "|"
		Next
		$Text = StringTrimRight($Text, 1)
		GUICtrlSetData(-1, $Text)
		GUICtrlSetOnEvent(-1, "Settings_Change")
		$Text = StringSplit($Text, "|")
		For $i = 1 To $Text[0]
			If $Text[$i] == IniRead("db\settings.ini", "settings", "icos", "Metal") Then _GUICtrlComboBox_SetCurSel($SettingsCombo3, $i - 1)
		Next
	EndIf
	
	$Files = _FileSearch($PP_Dir & "resource", "*PPlayer.kxf", 0, '', True)
	If @Error Then
		If Error("Your Installation misses positionfiles." & @CRLF & "You have to reinstall PPlayer." & @CRLF & "Do you want to get redirected to the download?",4) == 6 Then DownloadPPlayer()
		logoff()
	Else
		GUICtrlCreateLabel("Design for MainGUI", 16, 216, 150, 17)
		Global $SettingsCombo4 = GUICtrlCreateCombo("", 264, 216, 209, 25)
		$Text = ""
		For $i = 1 To $Files[0]
			$String = StringTrimLeft($Files[$i], StringInStr($Files[$i], "\", 0, -1))
			$Text &= StringTrimRight($String, 11) & "|"
		Next
		$Text = StringTrimRight($Text, 1)
		GUICtrlSetData(-1, $Text)
		GUICtrlSetOnEvent(-1, "Settings_Change")
		$Text = StringSplit($Text, "|")
		For $i = 1 To $Text[0]
			If $Text[$i] == IniRead("db\settings.ini", "settings", "PPlayerkxf", "Default") Then _GUICtrlComboBox_SetCurSel($SettingsCombo4, $i - 1)
		Next
	EndIf
	
	$Files = _FileSearch($PP_Dir & "resource", "*PlayMode.kxf", 0, '', True)
	If @Error Then
		If Error("Your Installation misses positionfiles." & @CRLF & "You have to reinstall PPlayer." & @CRLF & "Do you want to get redirected to the download?",4) == 6 Then DownloadPPlayer()
		logoff()
	Else
		GUICtrlCreateLabel("Design for PlayMode", 16, 248, 150, 17)
		Global $SettingsCombo5 = GUICtrlCreateCombo("", 264, 248, 209, 25)
		$Text = ""
		For $i = 1 To $Files[0]
			$String = StringTrimLeft($Files[$i], StringInStr($Files[$i], "\", 0, -1))
			$Text &= StringTrimRight($String, 12) & "|"
		Next
		$Text = StringTrimRight($Text, 1)
		GUICtrlSetData(-1, $Text)
		GUICtrlSetOnEvent(-1, "Settings_Change")
		$Text = StringSplit($Text, "|")
		For $i = 1 To $Text[0]
			If $Text[$i] == IniRead("db\settings.ini", "settings", "PlayModekxf", "Default") Then _GUICtrlComboBox_SetCurSel($SettingsCombo5, $i - 1)
		Next
	EndIf
	
	GUICtrlCreateLabel("Statusbar", 16, 280, 86, 17)
	Global $SettingsCheckbox4 = GUICtrlCreateCheckbox("", 264, 280, 209, 25)
	GUICtrlSetState(-1, LoadSetting("settings", "Statusbar", $GUI_UNCHECKED))
	GUICtrlSetOnEvent(-1, "Settings_Change")
	
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#Region PlayMode
	Global $SettingsTabSheet2 = GUICtrlCreateTabItem("PlayMode")
	Global $SettingsPlayModeGroup1 = GUICtrlCreateGroup("General", 8, 32, 473, 281)
	Global $SettingsPlayModeSlider1 = GUICtrlCreateSlider(16, 144, 457, 25)
	GUICtrlSetLimit(-1, 10, 1)
	GUICtrlSetData(-1, GetOpt("SimilarBands"))
	GUICtrlSetOnEvent(-1, "SimilarSliderChange")
	Global $SettingsPlayModeLabel3 = GUICtrlCreateLabel("Similar bands available for search", 16, 120, 161, 17)
	Global $SettingsPlayModeCheckbox2 = GUICtrlCreateCheckbox("", 264, 184, 201, 25)
	GUICtrlSetState(-1,LoadSetting("settings","coverload",$GUI_CHECKED))
	GUICtrlSetOnEvent(-1, "Settings_Change")
	Global $SettingsPlayModeLabel4 = GUICtrlCreateLabel("Load Covers", 16, 184, 64, 17)
	Global $SettingsPlayModeLabel6 = GUICtrlCreateLabel("Time to block a song until its played again (min)", 16, 56, 226, 17)
	Global $SettingsPlayModeLabel7 = GUICtrlCreateLabel("Time a song should be played until its rated (%)", 16, 248, 224, 17)
	Global $SettingsPlayModeLabel8 = GUICtrlCreateLabel("Load last song(s) on start", 16, 216, 122, 17)
	Global $SettingsPlayModeCheckbox3 = GUICtrlCreateCheckbox("", 264, 216, 201, 25)
	GUICtrlSetState(-1,LoadSetting("settings","loadsongs",$GUI_UNCHECKED))
	GUICtrlSetOnEvent(-1, "Settings_Change")
	Global $SettingsPlayModeInput1 = GUICtrlCreateInput(GetOpt("MinLastPlayed"), 264, 56, 209, 21)
	Global $SettingsPlayModeInput2 = GUICtrlCreateInput(LoadSetting("settings","ratetime",90), 264, 248, 209, 21)
	Global $SettingsPlayModeInput3 = GUICtrlCreateInput(LoadSetting("settings","ExcludedTags",""), 264, 280, 209, 21)
	Global $SettingsPlayModeLabel11 = GUICtrlCreateLabel("Songs (Keywords) that should be excluded from AutoSearch (seperated by ',')", 16, 280, 232, 25)
	Global $SettingsPlayModeLabel1 = GUICtrlCreateLabel("Song-Popup (Notification)", 16, 88, 125, 17)
	Global $SettingsPlayModeCheckbox1 = GUICtrlCreateCheckbox("", 264, 88, 201, 25)
	GUICtrlSetState(-1, GetOpt("Popup"))
	GUICtrlSetOnEvent(-1, "Settings_Change")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#endregion
	; - SongView
	Global $SettingsTabSheet3 = GUICtrlCreateTabItem("SongView")
	$id = _GetCPUID()
	; SongView - URLs
	Global $SettingsGroup4 = GUICtrlCreateGroup("URLs", 8, 32, 473, 190)
	GUICtrlCreateLabel("Direct-URL:", 16, 56, 60, 17)
	GUICtrlCreateInput($PP_HP & "images/" & $id & ".gif", 16, 80, 441, 21, $ES_READONLY)
	GUICtrlCreateLabel("BBCode: (Forum)", 16, 114, 108, 17)
	GUICtrlCreateInput("[url=                     ][img]" & $PP_HP & "images/" & $id & ".gif[/img][/url]", 16, 136, 441, 21, $ES_READONLY)
	GUICtrlCreateLabel("HTMLCode: (Blog/Website etc)", 16, 168, 154, 17)
	GUICtrlCreateInput("<a href='                     '><img src='" & $PP_HP & "images/" & $id & ".gif'></a>", 16, 192, 441, 21, $ES_READONLY)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $SettingsGroup4 = GUICtrlCreateGroup("Settings", 8, 226, 473, 74)
	GUICtrlCreateLabel("Nickname:", 16, 250, 55, 17)
	Global $SongViewNickNameInput = GUICtrlCreateInput(IniRead("db\settings.ini", "SongView", "name", $id), 80, 250, 193, 21)
	GUICtrlCreateLabel("Text: (currently disabled)", 16, 274, 28, 17)
	Global $SongViewTextInput = GUICtrlCreateInput(IniRead("db\settings.ini", "SongView", "text", "I am listening to: %i - %a - %t"), 80, 274, 193, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $SettingsGroup5 = GUICtrlCreateGroup("Info", 8, 305, 473, 82)
	GUICtrlCreateLabel("", 16, 318, 465, 69)
	GUICtrlSetData(-1, "PPlayer Songview publishes the song you're actually listening to. " & _
			"Just copy one of the adresses into your Forumsignature (BBCode) or onto a Blogpost (HTML or BBCode) " & _
			"Your friends will then be able to see what you're actually listening to. " & _
			"You should specify your Username so everbody understands who you are." & @CRLF & _
			"Tags: %i = Artist, %t = Track, %a = Album")
	GUICtrlCreateTabItem("Skin")
	GUICtrlCreateGroup("Skin", 8, 32, 473, 355)
	GUICtrlCreateLabel("Here you can select a new skin for PPlayer", 16, 46, 220, 121)
	Global $SettingsCombo1 = GUICtrlCreateCombo("", 16, 174, 217, 25)
	GUICtrlSetOnEvent(-1, "SettingsSkinChange")
	Global $SettingsPic1 = GUICtrlCreatePic("", 240, 46, 233, 337)
	Global $SettingsLabel10 = GUICtrlCreateLabel("Select a skin above to get more information about it." & @CRLF & "Press apply to save the skin.", 16, 206, 220, 157)
	GUICtrlCreateButton("Rate this skin", 16, 363, 80, 20)
	GUICtrlSetOnEvent(-1, "RateSkin")
	GUICtrlCreateButton("Upload skin", 100, 363, 80, 20)
	GUICtrlSetOnEvent(-1, "UploadSkin")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	Global $PluginsListViewItems[1]
	Global $SettingsTabSheet5 = GUICtrlCreateTabItem("Plugins")
	Global $PluginsListView = GUICtrlCreateListView("Name|Author|Quick Description|Version|Rating", 8, 32, 473, 169, -1, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES))
	GUICtrlSendMsg(-1, 0x101E, 0, 100)
	GUICtrlSendMsg(-1, 0x101E, 1, 50)
	GUICtrlSendMsg(-1, 0x101E, 2, 200)
	GUICtrlSendMsg(-1, 0x101E, 3, 60)
	GUICtrlSendMsg(-1, 0x101E, 4, 50)
	Global $PluginsEdit = GUICtrlCreateEdit("", 8, 208, 473, 153, BitOR($ES_AUTOVSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL))
	If $PluginSettingsTabs[0] > 0 Then
		For $i = 1 To $PluginSettingsTabs[0]
			PluginTriggerWithNr("CreateSettingsTab", $PluginSettingsTabs[$i])
		Next
	EndIf
	GUICtrlCreateTabItem("")
	Global $SettingsButton2 = GUICtrlCreateButton("Apply", 320, 400, 81, 41, 0)
	GUICtrlSetOnEvent(-1, "Settings_save")
	GUICtrlSetState(-1, $GUI_DISABLE)
	Global $SettingsButton3 = GUICtrlCreateButton("Cancel", 408, 400, 81, 41, 0)
	GUICtrlSetOnEvent(-1, "Settings_close")
	If IniRead("db\settings.ini", "GUIStati", "Settings", "Close") == "Open"  Then Settings()
EndFunc   ;==>SettingsBuild

Func Settings()
	GUISetState(@SW_SHOW, $Settings_GUI)
	GUISetState(@SW_RESTORE, $Settings_GUI)
	SkinList(IniRead("db\settings.ini", "settings", "skin", "Carbon"))
	SettingsPluginList()
	SettingsSkinChange()
	_IniWrite("db\settings.ini", "GUIStati", "Settings", "Open")
	PluginTrigger("OnSettingsOpen")
EndFunc   ;==>Settings

Func SettingsPluginList()
	_GUICtrlListView_DeleteAllItems($PluginsListView)
	$Input = Request($PP_HP & "plugin.php")
	If StringLen($Input) > 0 Then
		SaveSetting("Plugins", "list", $Input)
	Else
		$Input = LoadSetting("Plugins", "list", "BugReport|Pascal|Help PPlayer development|0.1|0||ChangeMSN|Pascal|Changes the MSN-Message|0.5|0||Lyrics|Pascal|Displays Lyrics|0.1|0||Podcast|Pascal|Plays Podcasts|0.1|0||Stream|Pascal|Plays Streams|0.1|0||Updater|Pascal|Updates PPlayer|0.1|0||")
	EndIf
	$Input = StringSplit($Input, "||", 1)
	For $i = 1 To $Input[0] - 1
		If StringLen($Input[$i]) > 0 Then
			$PluginInfo = StringSplit($Input[$i], "|")
			ReDim $PluginsListViewItems[UBound($PluginsListViewItems) + 1]
			If $PluginInfo[5] == 0 Then $PluginInfo[5] = "Unrated"
			$PluginsListViewItems[UBound($PluginsListViewItems) - 2] = GUICtrlCreateListViewItem($PluginInfo[1] & "|" & $PluginInfo[2] & "|" & $PluginInfo[3] & "|" & $PluginInfo[4] & "|" & $PluginInfo[5], $PluginsListView)
			GUICtrlSetOnEvent(-1, "Settings_PluginChange")
			If $PluginInfo[2] == "Pascal"  Then
				If LoadSetting("Pluginact", $PluginInfo[1], True) == True Then _GUICtrlListView_SetItemChecked($PluginsListView, $i - 1)
			Else
				If LoadSetting("Pluginact", $PluginInfo[1], False) == True Then _GUICtrlListView_SetItemChecked($PluginsListView, $i - 1)
			EndIf
		EndIf
	Next
EndFunc   ;==>SettingsPluginList

Func Settings_close()
	GUISetState(@SW_HIDE, $Settings_GUI)
	_IniWrite("db\settings.ini", "GUIStati", "Settings", "Close")
	GUICtrlSetData($SettingsInput1, GetOpt("BkColor"))
	GUICtrlSetData($SettingsInput2, GetOpt("TextColor"))
	GUICtrlSetData($SettingsSlider1, GetOpt("Trans"))
	GUICtrlSetState($SettingsCheckbox1, GetOpt("Ani"))
	
	; PlayMode
	GUICtrlSetState($SettingsPlayModeCheckbox1, GetOpt("PopUp"))
	GUICtrlSetData($SettingsPlayModeInput1, GetOpt("MinLastPlayed"))
	GUICtrlSetState($SettingsPlayModeCheckbox2,LoadSetting("settings", "CoverLoad",$GUI_CHECKED))
	GUICtrlSetState($SettingsPlayModeCheckbox3,LoadSetting("settings", "LoadSongs",$GUI_UNCHECKED))
	GUICtrlSetData($SettingsPlayModeInput2,LoadSetting("settings", "Ratetime",90))
	GUICtrlSetData($SettingsPlayModeInput3,LoadSetting("settings", "ExcludedTags",""))
	
	PluginTrigger("OnSettingsClose")
EndFunc   ;==>Settings_close

Func Settings_OK()
	Settings_save()
	Settings_close()
EndFunc   ;==>Settings_OK

Func SettingsChooseColor()
	GUICtrlSetState($SettingsButton2, $GUI_ENABLE)
	If @GUI_CtrlId == $SettingsButton4 Then
		$Input = StringTrimLeft(_ChooseColor(2, "0x" & GetOpt("BkColor"), 2), 2)
		If StringLen($Input) > 0 Then GUICtrlSetData($SettingsInput1, $Input)
	ElseIf @GUI_CtrlId == $SettingsButton5 Then
		$Input = StringTrimLeft(_ChooseColor(2, "0x" & GetOpt("TextColor"), 2), 2)
		If StringLen($Input) > 0 Then GUICtrlSetData($SettingsInput2, $Input)
	EndIf
EndFunc   ;==>SettingsChooseColor

Func Settings_save()
	#region Restart?
	$Restart = False
	If GetOpt("BkColor") <> GUICtrlRead($SettingsInput1) Then $Restart = True
	If GetOpt("TextColor") <> GUICtrlRead($SettingsInput2) Then $Restart = True
	If LoadSetting("settings", "PPlayerkxf", "Default") <> GUICtrlRead($SettingsCombo4) Then
		CreateGUIIni("resource\" & GUICtrlRead($SettingsCombo4) & "PPlayer.kxf")
		$Restart = True
	EndIf
	If LoadSetting("settings", "PlayModekxf", "Default") <> GUICtrlRead($SettingsCombo5) Then
		CreateGUIIni("resource\" & GUICtrlRead($SettingsCombo5) & "PlayMode.kxf")
		$Restart = True
	EndIf
	#endregion
	#region SongView-Tab
	SaveSetting("SongView", "name", GUICtrlRead($SongViewNickNameInput))
	SaveSetting("SongView", "text", GUICtrlRead($SongViewTextInput))
	#endregion
	#region General-Tab
	SaveSetting("settings", "BkColor", GUICtrlRead($SettingsInput1))
	SaveSetting("settings", "TextColor", GUICtrlRead($SettingsInput2))
	SaveSetting("settings", "Trans", GUICtrlRead($SettingsSlider1))
	SaveSetting("settings", "Ani", GUICtrlRead($SettingsCheckbox1))
	SaveSetting("settings", "PPlayerkxf", GUICtrlRead($SettingsCombo4))
	SaveSetting("settings", "PlayModekxf", GUICtrlRead($SettingsCombo5))
	SaveSetting("settings", "icos", GUICtrlRead($SettingsCombo3))
	SaveSetting("settings", "Statusbar", GUICtrlRead($SettingsCheckbox4))
	#endregion
	#region PlayMode-Tab
	SaveSetting("settings", "MinLastPlayed", GUICtrlRead($SettingsPlayModeInput1))
	SaveSetting("settings", "PopUp", GUICtrlRead($SettingsPlayModeCheckbox1))
	SaveSetting("settings", "CoverLoad", GUICtrlRead($SettingsPlayModeCheckbox2))
	SaveSetting("settings", "LoadSongs", GUICtrlRead($SettingsPlayModeCheckbox3))
	SaveSetting("settings", "Ratetime", GUICtrlRead($SettingsPlayModeInput2))
	SaveSetting("settings", "ExcludedTags", GUICtrlRead($SettingsPlayModeInput3))
	#endregion
	#region Plugins
	$FH = FileOpen("Plugins\Plugins.au3", 2)
	For $i = 0 To _GUICtrlListView_GetItemCount($PluginsListView) - 1
		If _GUICtrlListView_GetItemChecked($PluginsListView, $i) == True Then
			$Plugin = _GUICtrlListView_GetItemText($PluginsListView, $i)
			If Not FileExists("Plugins\" & $Plugin & "\Main.au3") Then
				ProgressOn("PPlayer - Settings", "Downloading Plugins", $Plugin)
				FileDelete(@TempDir & "PPlayerDownload")
				InetGet($PP_HP & "downloads/Plugins/" & $Plugin & "/Main.au3", @TempDir & "PPlayerDownload", 1, 1)
				$Size = InetGetSize($PP_HP & "downloads/Plugins/" & $Plugin & "/Main.au3")
				$Timer = TimerInit()
				While @InetGetActive Or TimerDiff($Timer) < $Size * 2
					ProgressSet(@InetGetBytesRead / $Size * 100)
					Sleep(10)
				WEnd
				ProgressOff()
				If FileGetSize(@TempDir & "PPlayerDownload") > 0 Then
					FileCopy(@TempDir & "PPlayerDownload", "Plugins\" & $Plugin & "\Main.au3", 9)
					FileWriteLine($FH, '#include "' & $Plugin & '\Main.au3"')
					SaveSetting("Pluginact", $Plugin, True)
				Else
					Error("Unable to download Plugin!")
				EndIf
			Else
				FileWriteLine("Plugins\Plugins.au3", '#include "' & $Plugin & '\Main.au3"')
				SaveSetting("Pluginact", $Plugin, True)
			EndIf
		Else
			SaveSetting("Pluginact", _GUICtrlListView_GetItemText($PluginsListView, $i), False)
		EndIf
	Next
	FileClose($FH)
	#endregion
	#region Skin
	$Skin = GUICtrlRead($SettingsCombo1)
	If StringLen($Skin) > 0 And GetOpt("skin") <> $Skin Then
		Request($PP_HP & "skin.php?skin=" & $Skin & "&select=true")
		DownloadSkin($Skin)
		GUICtrlSetData($SettingsInput1, StringTrimLeft(IniRead("Skins\" & $Skin & "\Skin.dat", "color", "background", 0), 2))
		GUICtrlSetData($SettingsInput2, StringTrimLeft(IniRead("Skins\" & $Skin & "\Skin.dat", "color", "fontcolor", 0), 2))
		$Restart = True
	EndIf
	#endregion
	
	GUICtrlSetState($SettingsButton2, $GUI_DISABLE)
	PluginTrigger("OnSettingsSave")
	If $Restart And MsgBox(4, "PPlayer - Settings", "Do you want to restart PPlayer?") == 6 Then
		logoff()
	Else
		$Restart = False
	EndIf
EndFunc   ;==>Settings_save

Func Settings_Change()
	If GUICtrlRead($SettingsSlider1) <> $SettingsSlider1Old Then
		WinSetTrans("PPlayer - V", "", GUICtrlRead($SettingsSlider1))
		$SettingsSlider1Old = GUICtrlRead($SettingsSlider1)
	EndIf
	If GUICtrlRead($SettingsCheckbox2) == $GUI_UNCHECKED Then
		GUICtrlSetState($SettingsInput3, $GUI_DISABLE)
		GUICtrlSetState($SettingsLabel6, $GUI_DISABLE)
	Else
		GUICtrlSetState($SettingsInput3, $GUI_ENABLE)
		GUICtrlSetState($SettingsLabel6, $GUI_ENABLE)
	EndIf
	GUICtrlSetState($SettingsButton2, $GUI_ENABLE)
EndFunc   ;==>Settings_Change

Func Settings_PluginChange()
	$Sel = _GUICtrlListView_GetSelectedIndices($PluginsListView, 1)
	If $Sel[0] > 0 Then
		$Input = StringSplit(Request($PP_HP & "plugin.php?plugin=" & _GUICtrlListView_GetItemText($PluginsListView, $Sel[1])), "<info>", 1)
		GUICtrlSetData($PluginsEdit, $Input[1])
	EndIf
	$Changed = False
	For $i = 0 To UBound($PluginsListViewItems) - 1
		If @GUI_CtrlId == $PluginsListViewItems[$i] And Not (_GUICtrlListView_GetItemChecked($PluginsListView, $i) == LoadSetting("Pluginact", _GUICtrlListView_GetItemText($PluginsListView, $i), False)) Then $Changed = True
	Next
	If $Changed Then GUICtrlSetState($SettingsButton2, $GUI_ENABLE)
EndFunc   ;==>Settings_PluginChange

Func SettingsSkinChange()
	$Skin = GUICtrlRead($SettingsCombo1)
	If StringLen($Skin) > 0 Then
		GUICtrlSetImage($SettingsPic1, "")
		InetGet($PP_HP & "skins/Screens/" & $Skin & ".JPG", "skin.jpg")
		GUICtrlSetImage($SettingsPic1, "skin.jpg")
		FileDelete("skin.jpg")
		If $Skin <> $OldSkin Then
			$Input = Request($PP_HP & "skin.php?skin=" & $Skin & "&show=really")
		Else
			$Input = Request($PP_HP & "skin.php?skin=" & $Skin)
		EndIf
		If StringLen($Input) > 0 Then
			SaveSetting("Skins", $Skin, $Input)
		Else
			$Input = LoadSetting("Skins", $Skin, "Unable to query Skindatabase<br>No information available<br>Try it later!")
		EndIf
		
		GUICtrlSetData($SettingsLabel10, StringReplace(StringReplace(StringLeft($Input, StringInStr($Input, "<info>") - 1), "<tab>", @TAB), "<br>", @CRLF))
		If IniRead("db\settings.ini", "settings", "skin", "Carbon") <> $Skin Then Settings_Change()
		$OldSkin = $Skin
	EndIf
EndFunc   ;==>SettingsSkinChange

Func RateSkin()
	$Skin = GUICtrlRead($SettingsCombo1)
	If Not StringInStr(IniRead("settings.ini", "infos", "skinsrated", ""), $Skin) Then
		$Rating = InputBox("PPlayer - Settings", "Please enter a rating from 0-5 (worst-best) for " & $Skin)
		If @error Then Return ""
		If Int($Rating) > -1 And Int($Rating) < 6 Then
			$Input = Request($PP_HP & "skin.php?skin=" & $Skin & "&rating=" & $Rating)
			If StringLen($Input) > 0 Then
				SettingsSkinChange()
				IniWrite("db\settings.ini", "infos", "skinsrated", IniRead("db\settings.ini", "infos", "skinsrated", "") & "|" & $Skin)
				Info("You successfully rated " & $Skin & " with " & $Rating)
			Else
				Error("Unable to rate skin:" & @CRLF & "Skindatabase does not respond" & @CRLF & "Please try it later")
			EndIf
		Else
			Error("Your rating is invalid!")
		EndIf
	Else
		Error("You already rated this skin")
	EndIf
EndFunc   ;==>RateSkin

Func SkinList($Skin)
	_GUICtrlComboBox_ResetContent($SettingsCombo1)
	$Input = Request($PP_HP & "skin.php")
	If StringLen($Input) > 0 Then
		SaveSetting("Skins", "list", $Input)
	Else
		$Input = LoadSetting("Skins", "list", "Gray-electric-1|Lizondo|Dock Skin|SteelStyle|DarkRed|Black-Yellow|Blackhole|Blue-Metal|PDA-Game|Universal|AzuriX|Carbon|Light-Green|Skilled|Red-Black|XP-Shutdown|Leadore|Silver-Blue|Rezak|Blue-Gray|Gray-bar|Sand-desert|Blue-box-H|Blue-box-V|Hard-Steel|Light-Blue|Gray-electric-2|Misty-Blue|Noir|BlackJack|mci_01|HeavenlyBodies|Sand-Paper|Silent-green|Blue-line|mci-03|mci_02|mci_04|Sleek|DeFacto|")
	EndIf
	$Skins = StringSplit($Input, "|")
	For $i = 1 To $Skins[0] - 1
		If StringLen($Skins[$i]) > 0 Then
			_GUICtrlComboBox_AddString($SettingsCombo1, $Skins[$i])
			If $Skins[$i] == $Skin Then _GUICtrlComboBox_SetCurSel($SettingsCombo1, $i - 1)
		EndIf
	Next
EndFunc   ;==>SkinList

Func UploadSkin()
	ShellExecute("http://pplayer.sourceforge.net/access/upload.php")
EndFunc   ;==>UploadSkin

Func DownloadSkin($Skin)
	If Not FileExists("Skins\" & $Skin & "\Skin.dat") Then
		ProgressOn("PPlayer - Settings", "Downloading Skin")
		DirCreate("Skins")
		DirCreate("Skins\" & $Skin)
		DirCreate("Skins\Default")
		For $i = 0 To 7
			InetGet($PP_HP & "skins/" & $Skin & "/" & $i & ".bmp", "Skins\" & $Skin & "\" & $i & ".bmp")
			ProgressSet($i * 10)
		Next
		InetGet($PP_HP & "skins/" & $Skin & "/Skin.dat", "Skins\" & $Skin & "\Skin.dat")
		ProgressSet(80)
		InetGet($PP_HP & "skins/Default/" & $Skin & "1.bmp", "Skins\Default\" & $Skin & "1.bmp")
		ProgressSet(90)
		InetGet($PP_HP & "skins/Default/" & $Skin & "2.bmp", "Skins\Default\" & $Skin & "2.bmp")
		For $i = 1 To 3
			If Not FileExists("Skins\Default\Standard" & $i & ".bmp") Then InetGet($PP_HP & "skins/Default/Standard" & $i & ".bmp", "Skins\Default\Standard" & $i & ".bmp")
		Next
		ProgressOff()
	EndIf
	_IniWrite("db\settings.ini", "settings", "skin", $Skin)
	_IniWrite("db\settings.ini", "settings", "BkColor", StringTrimLeft(IniRead("Skins\" & $Skin & "\Skin.dat", "color", "background", 0), 2))
	_IniWrite("db\settings.ini", "settings", "TextColor", StringTrimLeft(IniRead("Skins\" & $Skin & "\Skin.dat", "color", "fontcolor", 0), 2))
EndFunc   ;==>DownloadSkin

Func SettingsChangeLanguage()
	$lang = GUICtrlRead($SettingsCombo2)
	If StringLen($lang) > 0 And IniRead("db\settings.ini", "settings", "lang", "English") <> $lang Then
		TranslateLangIni($lang)
		IniWrite("db\settings.ini", "settings", "lang", $lang)
		Settings_Change()
	EndIf
EndFunc   ;==>SettingsChangeLanguage

Func GetOpt($opt, $default = 0)
	If $default = 0 Then
		Switch $opt
			Case "SimilarBands"
				$default = 5
			Case "MinLastPlayed"
				$default = 60
			Case "DriveLetter"
				$default = "K:"
			Case "Trans"
				$default = 255
			Case "Ani"
				$default = 1
			Case "BkColor"
				$default = StringTrimLeft(IniRead("Skins\" & GetOpt("skin") & "\Skin.dat", "color", "background", 0), 2)
			Case "TextColor"
				$default = StringTrimLeft(IniRead("Skins\" & GetOpt("skin") & "\Skin.dat", "color", "fontcolor", 0), 2)
			Case "MSNAct"
				$default = $GUI_CHECKED
			Case "PopUp"
				$default = $GUI_UNCHECKED
			Case "skin"
				$default = "NoSkin"
		EndSwitch
	EndIf
	$Return = IniRead("db\settings.ini", "settings", $opt, $default)
	If $Return == "NoSkin"  Then
		$Input = Request($PP_HP & "skin.php")
		$Input = StringLeft($Input, StringInStr($Input, "|") - 1)
		If StringLen($Input) > 0 Then
			$Return = $Input
		Else
			$Return = "Carbon"
		EndIf
	EndIf
	Return $Return
EndFunc   ;==>GetOpt

#endregion
#region -> Playmode

Func PlaymodeBuild()
	Global $PlayMode[3]
	Global $ModeCheck[3]
	$GUI = "resource\" & LoadSetting("settings", "PlayModekxf", "Default") & "PlayMode.kxf"
	If IniRead("db\GUI.ini", "created", $GUI, 0) <> FileGetSize($GUI) Then CreateGUIIni($GUI)
	Global $PlaymodeGUI = XSkinGUICreate("PPlayer - PlayMode", GIR("PlayMode", "width") + $factorX * 2, GIR("PlayMode", "height") + $factorY * 2, $Skin_Folder, 1, 25, IniRead("db\settings.ini", "window", "playx", -1), IniRead("db\settings.ini", "window", "playy", -1), -1, $MainGUI)
	XSkinIcon($PlaymodeGUI, 3, StringSplit("PlaymodeClose|PlaymodeClose|PlaymodeHelp", "|"))
	$PlInfoLabel1 = GUICtrlCreateLabel("Enter a Keyword and click on Search to get a list of matching songs", GIR("PlInfoLabel1", "left"), GIR("PlInfoLabel1", "top"), GIR("PlInfoLabel1", "width"), GIR("PlInfoLabel1", "height"))
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	$PlInfoLabel2 = GUICtrlCreateLabel("Select AutoSelect if you want a random song when you click on Search", GIR("PlInfoLabel2", "left"), GIR("PlInfoLabel2", "top"), GIR("PlInfoLabel2", "width"), GIR("PlInfoLabel2", "height"))
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	Global $PlayModeKeyword = GUICtrlCreateCombo("", GIR("PlayModeKeyword", "left"), GIR("PlayModeKeyword", "top"), GIR("PlayModeKeyword", "width"), GIR("PlayModeKeyword", "height"))
	$Insert = StringSplit(IniRead("db\settings.ini", "PlayMode", "Combo", ""), "|")
	For $i = 1 To $Insert[0]
		If StringLen($Insert[$i]) > 0 Then _GUICtrlComboBox_AddString($PlayModeKeyword, $Insert[$i])
	Next
	GUICtrlCreateButton(GIR("PlSearch", "caption"), GIR("PlSearch", "left"), GIR("PlSearch", "top"), GIR("PlSearch", "width"), GIR("PlSearch", "height"))
	GUICtrlSetOnEvent(-1, "Research")
	$PlInfoLabel3 = GUICtrlCreateLabel("Select AutoSearch if you want that PPlayer searches automatically for a new song everytime a song begins." & @CRLF & "You must choose an item in the Box to specify the search", GIR("PlInfoLabel3", "left"), GIR("PlInfoLabel3", "top"), GIR("PlInfoLabel3", "width"), GIR("PlInfoLabel3", "height"))
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	$ModeCheck[1] = GUICtrlCreateCombo("", GIR("PlCombo1", "left"), GIR("PlCombo1", "top"), GIR("PlCombo1", "width"), GIR("PlCombo1", "height"))
	$Text = "Similar Band|Genre|Band|Album| "
	GUICtrlSetData(-1, $Text)
	GUICtrlSetOnEvent(-1, "ModeChange")
	$Text = StringSplit($Text, "|")
	For $i = 1 To 4
		If $Text[$i] == IniRead("db\settings.ini", "ModeCheck", 1, "") Then _GUICtrlComboBox_SetCurSel(-1, $i - 1)
	Next
	$ModeCheck[2] = GUICtrlCreateCombo("", GIR("PlCombo2", "left"), GIR("PlCombo2", "top"), GIR("PlCombo2", "width"), GIR("PlCombo2", "height"))
	$Text = "Shuffle|Repeat|Repeat All| "
	GUICtrlSetData(-1, $Text)
	GUICtrlSetOnEvent(-1, "ModeChange")
	$Text = StringSplit($Text, "|")
	For $i = 1 To 3
		If $Text[$i] == IniRead("db\settings.ini", "ModeCheck", 2, "") Then _GUICtrlComboBox_SetCurSel(-1, $i - 1)
	Next
	$PlayMode[2] = GUICtrlCreateCheckbox(GIR("PlayMode1", "caption"), GIR("PlayMode1", "left"), GIR("PlayMode1", "top"), GIR("PlayMode1", "width"), GIR("PlayMode1", "height"), BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP))
	GUICtrlSetState(-1, IniRead("db\settings.ini", "PlayMode", 2, $GUI_UNCHECKED))
	GUICtrlSetOnEvent(-1, "PlaymodeChange")
	$PlayMode[1] = GUICtrlCreateCheckbox(GIR("PlayMode2", "caption"), GIR("PlayMode2", "left"), GIR("PlayMode2", "top"), GIR("PlayMode2", "width"), GIR("PlayMode2", "height"), BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP))
	GUICtrlSetState(-1, IniRead("db\settings.ini", "PlayMode", 1, $GUI_UNCHECKED))
	GUICtrlSetOnEvent(-1, "PlaymodeChange")
	GUICtrlCreateButton(GIR("PlAutoSearch", "caption"), GIR("PlAutoSearch", "left"), GIR("PlAutoSearch", "top"), GIR("PlAutoSearch", "width"), GIR("PlAutoSearch", "height"))
	GUICtrlSetOnEvent(-1, "PlayModeAutoSearch")
	$PlInfoLabel4 = GUICtrlCreateLabel("Start the autosearch manually:", GIR("PlInfoLabel4", "left"), GIR("PlInfoLabel4", "top"), GIR("PlInfoLabel4", "width"), GIR("PlInfoLabel4", "height"))
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	If IniRead("db\settings.ini", "GUIStati", "Playmode", "Open") == "Open"  Then Playmode()
EndFunc   ;==>PlaymodeBuild

Func Playmode()
	GUISetState(@SW_SHOW, $PlaymodeGUI)
	GUISetState(@SW_RESTORE, $PlaymodeGUI)
	_IniWrite("db\settings.ini", "GUIStati", "Playmode", "Open")
EndFunc   ;==>Playmode

Func PlaymodeClose()
	GUISetState(@SW_HIDE, $PlaymodeGUI)
	_IniWrite("db\settings.ini", "GUIStati", "Playmode", "Close")
EndFunc   ;==>PlaymodeClose

Func PlayModeAutoSearch()
	SetNext($ActiveSongSimilar, $ActiveSongInfo)
EndFunc   ;==>PlayModeAutoSearch

Func PlaymodeChange()
	For $i = 1 To 2
		_IniWrite("db\settings.ini", "PlayMode", $i, GUICtrlRead($PlayMode[$i]))
	Next
EndFunc   ;==>PlaymodeChange

Func PlaymodeHelp()
	ShellExecute("http://pplayer.wiki.sourceforge.net/PlayMode")
EndFunc   ;==>PlaymodeHelp

#endregion

#region -> Stat


Func StatBuild()
	Global $StatGUI = XSkinGUICreate("PPlayer - Statistic", 563 + $factorX * 2, 386 + $factorY * 2, $Skin_Folder, 1, 25, -1, -1, -1, $MainGUI)
	GUISetBkColor("0x" & GetOpt("BkColor"))
	XSkinIcon($StatGUI, 3, StringSplit("StatClose|StatClose|StatHelp", "|"))
	Global $StatListView1 = _GUICtrlCreateListView("Artist                    |Album                  |Track                 |Genre|Duration", 0 + $factorX, 72 + $factorY, 563, 310)
	GUICtrlSetOnEvent(-1, "StatSort")
	GUICtrlSetStyle($StatListView1, -1, $LVS_EX_HEADERDRAGDROP)
	Global $StatRadio[9]
	Global $StatLabel[11]
	GUIStartGroup()
	$StatRadio[1] = GUICtrlCreateRadio("", 96 + $factorX, 8 + $factorY, 17, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$StatRadio[2] = GUICtrlCreateRadio("", 208 + $factorX, 8 + $factorY, 17, 17)
	$StatRadio[3] = GUICtrlCreateRadio("", 328 + $factorX, 8 + $factorY, 17, 17)
	$StatRadio[4] = GUICtrlCreateRadio("", 448 + $factorX, 8 + $factorY, 17, 17)
	GUIStartGroup()
	$StatRadio[5] = GUICtrlCreateRadio("", 96 + $factorX, 40 + $factorY, 17, 17)
	$StatRadio[6] = GUICtrlCreateRadio("", 208 + $factorX, 40 + $factorY, 17, 17)
	$StatRadio[7] = GUICtrlCreateRadio("", 328 + $factorX, 40 + $factorY, 17, 17)
	$StatRadio[8] = GUICtrlCreateRadio("", 448 + $factorX, 40 + $factorY, 17, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	For $i = 1 To 8
		GUICtrlSetOnEvent($StatRadio[$i], "StatCalc")
	Next
	$StatLabel[3] = GUICtrlCreateLabel("Lifetime", 120 + $factorX, 40 + $factorY, 60, 24)
	$StatLabel[4] = GUICtrlCreateLabel("Week", 352 + $factorX, 40 + $factorY, 45, 24)
	$StatLabel[1] = GUICtrlCreateLabel("Most heard", 8 + $factorX, 8 + $factorY, 57, 25)
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	$StatLabel[2] = GUICtrlCreateLabel("Timespan", 8 + $factorX, 40 + $factorY, 66, 25)
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	$StatLabel[5] = GUICtrlCreateLabel("Day", 472 + $factorX, 40 + $factorY, 32, 24)
	$StatLabel[6] = GUICtrlCreateLabel("Month", 232 + $factorX, 40 + $factorY, 49, 24)
	$StatLabel[7] = GUICtrlCreateLabel("Artist", 120 + $factorX, 8 + $factorY, 41, 24)
	$StatLabel[8] = GUICtrlCreateLabel("Album", 232 + $factorX, 8 + $factorY, 49, 24)
	$StatLabel[9] = GUICtrlCreateLabel("Genre", 352 + $factorX, 8 + $factorY, 49, 24)
	$StatLabel[10] = GUICtrlCreateLabel("Track", 472 + $factorX, 8 + $factorY, 43, 24)

	For $i = 3 To 10
		GUICtrlSetFont($StatLabel[$i], 12, 400, 0, "MS Sans Serif")
		GUICtrlSetColor($StatLabel[$i], "0x" & GetOpt("TextColor"))
	Next
EndFunc   ;==>StatBuild

Func StatSort()
	$Lol = False
	If $oldstate == GUICtrlGetState($StatListView1) Then $Lol = Not $Lol
	$oldstate = GUICtrlGetState($StatListView1)
	;_ArraySort($StatInfo, $Lol, 1, 0, 6, GUICtrlGetState($StatListView1) + 1)
	__GUICtrlListView_Sort($StatListView1, $Lol, GUICtrlGetState($StatListView1))
EndFunc   ;==>StatSort

Func Stat()
	StatCalc()
	GUISetState(@SW_SHOW, $StatGUI)
	GUISetState(@SW_RESTORE, $StatGUI)
	_IniWrite("db\settings.ini", "GUIStati", "Stat", "Open")
EndFunc   ;==>Stat

Func StatClose()
	GUISetState(@SW_HIDE, $StatGUI)
	_IniWrite("db\settings.ini", "GUIStati", "Stat", "Close")
EndFunc   ;==>StatClose

Func StatHelp()
	ShellExecute("http://pplayer.wiki.sourceforge.net/Statistic")
EndFunc   ;==>StatHelp

Func StatCalc()
	__GUICtrlListView_DeleteAllItems($StatListView1)
	If GUICtrlRead($StatRadio[1]) == $GUI_CHECKED Then
		$msg = "Artist"
	ElseIf GUICtrlRead($StatRadio[2]) == $GUI_CHECKED Then
		$msg = "Album"
	ElseIf GUICtrlRead($StatRadio[3]) == $GUI_CHECKED Then
		$msg = "Genre"
	Else
		$msg = "Track"
	EndIf
	If GUICtrlRead($StatRadio[5]) == $GUI_CHECKED Then
		$time = 0
	ElseIf GUICtrlRead($StatRadio[6]) == $GUI_CHECKED Then
		$time = _TimeGetStamp() - 60 * 60 * 24 * 30
	ElseIf GUICtrlRead($StatRadio[7]) == $GUI_CHECKED Then
		$time = _TimeGetStamp() - 60 * 60 * 24 * 7
	Else
		$time = _TimeGetStamp() - 60 * 60 * 24
	EndIf
	$message1 = ""
	$message2 = ""
	$StatInfo = StatCalculate($msg, $time)
	For $i = 1 To UBound($StatInfo) - 1
		_GUICtrlCreateListViewItem($StatInfo[$i][1] & "|" & $StatInfo[$i][2] & "|" & $StatInfo[$i][3] & "|" & $StatInfo[$i][4] & "|" & $StatInfo[$i][5] & " min", $StatListView1)
	Next
EndFunc   ;==>StatCalc

Func StatCalculate($msg, $time)
	Dim $Query[1]
	$Artists = ""
	Dim $Info[1][7]
	_SQLite_Query(-1, 'SELECT DISTINCT ' & $msg & ' FROM SongView WHERE Played > "' & $time & '";', $hQuery)
	While _SQLite_FetchData($hQuery, $Query) = $SQLITE_OK
		$Artists &= $Query[0] & "|"
	WEnd
	_SQLite_QueryFinalize($hQuery)
	$Artists = StringSplit(StringTrimRight($Artists, 1), "|")
	For $i = 1 To $Artists[0]
		Dim $Query[1]
		_SQLite_Query(-1, 'SELECT Artist,Album,Track,Genre,Count(*) As Durations,Duration FROM SongView WHERE Played > "' & $time & '" AND ' & $msg & ' = "' & $Artists[$i] & '";', $hQuery)
		While _SQLite_FetchData($hQuery, $Query) = $SQLITE_OK
			If UBound($Query) > 4 And $Query[4] > 0 Then
				ReDim $Info[UBound($Info) + 1][7]
				For $i2 = 1 To 4
					$Info[UBound($Info) - 1][$i2] = $Query[$i2 - 1]
				Next
				$Info[UBound($Info) - 1][5] = Round(($Query[4] * $Query[5]) / 60)
			EndIf
		WEnd
	Next
	_SQLite_QueryFinalize($hQuery)
	_ArraySort($Info, 1, 1, 0, 7, 5)
	Return $Info
EndFunc   ;==>StatCalculate

Func SongHeard($tag, $Dur)
	$message = ""
	$tag[0] = _TimeGetStamp()
	$tag[5] = $Dur
	For $i = 0 To 5
		$message &= '"' & $tag[$i] & '",'
	Next
	$message = StringTrimRight($message, 1)
	_SQLite_Exec(-1, "INSERT INTO SongView (Played,Artist,Album,Track,Genre,Duration) VALUES (" & $message & ");") ; INSERT Data
EndFunc   ;==>SongHeard

Func WebAnnounce($tag = "")
	$bck = 1
	$Verified = True
	$textcolor = Dec(StringLeft(IniRead("db\settings.ini", "settings", "TextColor", ""), 2)) & "." & Dec(StringMid(IniRead("db\settings.ini", "settings", "TextColor", ""), 3, 2)) & "." & Dec(StringRight(IniRead("db\settings.ini", "settings", "TextColor", ""), 2))
	$backcolor = Dec(StringLeft(IniRead("db\settings.ini", "settings", "BkColor", ""), 2)) & "." & Dec(StringMid(IniRead("db\settings.ini", "settings", "BkColor", ""), 3, 2)) & "." & Dec(StringRight(IniRead("db\settings.ini", "settings", "BkColor", ""), 2))
	$msg = $PP_HP & "web.php?tc=" & $textcolor & "&bc=" & $backcolor & "&user=" & _GetCPUID() & "&username=" & IniRead("db\settings.ini", "SongView", "name", "No Nickname set") & "&Status="
	If IsArray($tag) Then
		$msg &= "Listening to|Track:  " & $tag[3] & "|Artist: " & $tag[1] & "|Album:  " & $tag[2]
	ElseIf $tag == "Offline"  Then
		$msg &= "Offline"
		$bck = 0
	Else
		$msg &= "Online"
	EndIf
	If IniRead("db\settings.ini", "SongView", "lastupdate", 0) <> @HOUR Then
		IniWrite("db\settings.ini", "SongView", "lastupdate", @HOUR)
		$msger = ""
		$Info = StatCalculate("Track", 0)
		If UBound($Info, 1) == 1 Then Return False
		$msger &= "&TopTrack=" & StringReplace($Info[1][1], "&", "+") & " - " & StringReplace($Info[1][2], "&", "+") & " - " & StringReplace($Info[1][3], "&", "+") & "&TopTrackTime=" & $Info[1][5]
		$Info = StatCalculate("Artist", 0)
		If UBound($Info, 1) == 1 Then Return False
		$msger &= "&TopArtist=" & StringReplace($Info[1][1], "&", "+") & "&TopArtistTime=" & $Info[1][5]
		$Info = StatCalculate("Album", 0)
		If UBound($Info, 1) == 1 Then Return False
		$msger &= "&TopAlbum=" & StringReplace($Info[1][1], "&", "+") & " - " & StringReplace($Info[1][2], "&", "+") & "&TopAlbumTime=" & $Info[1][5]
		IniWrite("db\settings.ini", "SongView", "msg", $msger)
	EndIf
	$msg &= IniRead("db\settings.ini", "SongView", "msg", "")
	InetGet($msg, "", 1, 1)
	If $bck == 0 Then
		$Timer = TimerInit()
		While @InetGetActive And TimerDiff($Timer) < 5000
			Sleep(10)
		WEnd
	EndIf
EndFunc   ;==>WebAnnounce

#endregion

#endregion
#region Window / MAINGUI (Hide,Show,Tray_info)

Func Hide()
	$hidden = True
	GUISetState(@SW_HIDE, $MainGUI)
	TraySetState()
	TraySetToolTip("PPlayer V" & $version & ": Simply click on the tray to reopen the window")
	If IniRead("db\settings.ini", "infos", "hide", 0) == 0 Then
		TrayTip("Versteckt", "Your Player is now in Tray" & @CRLF & "Click on it and it will reopen", 10, 1)
		_IniWrite("db\settings.ini", "infos", "hide", 1)
	EndIf
	PluginTrigger("OnPPlayerMinimized")
EndFunc   ;==>Hide

Func Show()
	$hidden = False
	TraySetState(2)
	If GetOpt("Ani") == 1 Then
		XSkinAnimate($MainGUI, 1, (Random(0, 9, 1) * 2) + 1, GetOpt("Trans"))
	Else
		WinSetTrans($Title, "", GetOpt("Trans"))
		GUISetState(@SW_SHOW, $MainGUI)
		GUISetState(@SW_RESTORE, $MainGUI)
	EndIf
	PluginTrigger("OnPPlayerMaximized")
EndFunc   ;==>Show

Func Tray_info()
	If GetOpt("PopUp") == $GUI_CHECKED Then XSkinTrayBox("PPlayer", "Now playing: " & _GUICtrlListView_GetItemText($lieder, $activelistid))
EndFunc   ;==>Tray_info
#endregion

#region Label Updates (UpdateLabelInfo,UpdateLabelAction[Statusbar],UpdateLabelPos)

Func UpdateLabelInfo($tag, $similar)
	If Not IsArray($tag) Or Not IsArray($similar) Then Return False
	If $tag[7] == 0 Then
		$tag[7] = "never"
	ElseIf $tag[7] == -1 Then
		$tag[7] = ""
	Else
		$tag[7] = _TimeGetStamp() - $tag[7]
		$days = Int($tag[7] / 86400)
		$h = Int($tag[7] / 3600) - $days * 24
		$min = Int($tag[7] / 60) - $h * 60 - $days * 1440
		$tag[7] = ""
		If $days > 1 Then
			$tag[7] = $tag[7] & $days & " days "
		ElseIf $days > 0 Then
			$tag[7] = $tag[7] & $days & " day "
		EndIf
		If $h > 1 Then
			$tag[7] = $tag[7] & $h & " hours and "
		ElseIf $h > 0 Then
			$tag[7] = $tag[7] & $h & " hour and "
		EndIf
		If $min <> 1 Then
			$tag[7] = $tag[7] & $min & " minutes"
		Else
			$tag[7] = $tag[7] & $min & " minute"
		EndIf
		$tag[7] &= " ago"
	EndIf
	For $i = 0 To 5
		If StringLen($tag[$i]) > GIR("info_label", "Width") / 5.6 Then $tag[$i] = StringLeft($tag[$i], GIR("info_label", "Width") / 5.6) & "..."
	Next
	$message = $tag[3] & @CRLF & $tag[1] & @CRLF & $tag[2] & @CRLF & $tag[4] & @CRLF & $tag[5] & @CRLF & $tag[7] & @CRLF & $tag[8] & @CRLF
	$Similars = GUICtrlRead($SettingsPlayModeSlider1)
	If $Similars > 6 Then $Similars = 6
	If $Similars > $similar[0] Then $Similars = $similar[0]
	If $Similars > 0 Then
		For $i = 1 To $Similars
			$message &= $similar[$i] & @CRLF
		Next
		If GUICtrlRead($SettingsPlayModeSlider1) > 6 Then $message &= "..."
	Else
		$message &= "No similar bands in Database"
	EndIf
	GUICtrlSetData($info_label, $message)
EndFunc   ;==>UpdateLabelInfo

Func UpdateLabelAction($message)
	If LoadSetting("settings", "Statusbar", $GUI_UNCHECKED) == $GUI_UNCHECKED Then Return ""
	_GUICtrlStatusBar_SetText($StatusBar, $message)
EndFunc   ;==>UpdateLabelAction

Func UpdateLabelPos($active_sound)
	Dim $Save[5]
	$Pos = WMGetPosition()
	$time = WMGetDuration($active_sound)
	$Save[1] = Int(Int($time) / 60)
	$Save[2] = Int($time) - $Save[1] * 60
	$Save[3] = Int($Pos / 60)
	$Save[4] = Int($Pos) - $Save[3] * 60
	For $i = 1 To 4
		If StringLen($Save[$i]) = 1 Then $Save[$i] = "0" & $Save[$i]
	Next
	GUICtrlSetData($pos_label, $Save[3] & ":" & $Save[4] & "/" & $Save[1] & ":" & $Save[2])
	If $SliderChange Then GUICtrlSetData($Pos_Slider, Int($Pos))
EndFunc   ;==>UpdateLabelPos

#endregion

#region Slider (ChangePos,ChangeVol,CalcPos,SimilarSliderChange)

Func ChangePos()
	WMSetPosition(GUICtrlRead($Pos_Slider))
	GUICtrlSendMsg($Pos_Slider, $WM_ENABLE, 1, 0)
EndFunc   ;==>ChangePos

Func ChangeVol()
	$Vol = GUICtrlRead($Vol_Slider)
	If Not $Muted Or $Muted And $Vol <> IniRead("db\settings.ini", "infos", "vol", $Vol) Then
		WMSetVolume($Vol)
		_IniWrite("db\settings.ini", "infos", "vol", $Vol)
		$Muted = False
	EndIf
	GUICtrlSetTip($Vol_Slider, $Vol)
EndFunc   ;==>ChangeVol

Func MuteVol()
	If $Muted Then
		WMSetVolume(GUICtrlRead($Vol_Slider))
		$Muted = False
		GUICtrlSetImage($Vol_Muter, $PP_IcoFolder, 10)
	Else
		WMSetVolume(0)
		$Muted = True
		GUICtrlSetImage($Vol_Muter, $PP_IcoFolder, 4)
	EndIf
EndFunc   ;==>MuteVol

Func CalcPos($active_sound)
	GUICtrlSetLimit($Pos_Slider, Int(WMGetDuration($active_sound)), 0)
	GUICtrlSetState($Pos_Slider, $GUI_ENABLE)
	$Changing = 0
EndFunc   ;==>CalcPos

Func SimilarSliderChange()
	Settings_Change()
	_IniWrite("db\settings.ini", "settings", "SimilarBands", GUICtrlRead($SettingsPlayModeSlider1))
EndFunc   ;==>SimilarSliderChange

#endregion

#region Datenbank / File (Rate,LastPlayed,QueryDB,AddToDB,_GetInterpret,SecureCheck,ReadFileInfo,Database)

Func Rate($Filepath, $rate)
	If StringLen($Filepath) > 0 Then
		Dim $Query[1]
		_SQLite_Query(-1, 'SELECT * FROM Songs WHERE Path = "' & $Filepath & '";', $hQuery) ; the query
		_SQLite_FetchData($hQuery, $Query)
		If @error Then
			_SQLite_QueryFinalize($hQuery)
			Return ""
		EndIf
		If $Query[7] + $rate > 20 Then
			$rate = 20 - $Query[7]
		ElseIf $Query[7] + $rate < 1 Then
			$rate = ($Query[7] - 1) * - 1
		EndIf
		_SQLite_Exec(-1, 'UPDATE Songs SET Rating = "' & $Query[7] + $rate & '" WHERE Path = "' & $Filepath & '";')
		_SQLite_QueryFinalize($hQuery)
	EndIf
EndFunc   ;==>Rate

Func LastPlayed($titel, $interpret)
	_SQLite_Exec(-1, 'UPDATE Songs SET LastPlayed = "' & _TimeGetStamp() & '" WHERE Artist = "' & $interpret & '" AND Track = "' & $titel & '";')
EndFunc   ;==>LastPlayed

Func QueryDB($Filepath)
	Dim $Query[1]
	_SQLite_Query(-1, 'SELECT * FROM Songs WHERE Path = "' & $Filepath & '";', $hQuery) ; the query
	Dim $tag[9]
	_SQLite_FetchData($hQuery, $Query)
	_SQLite_QueryFinalize($hQuery)
	If StringLen($Query[0]) > 0 Then
		For $i = 0 To 7
			$tag[$i + 1] = $Query[$i]
		Next
	Else
		Return SetError(1, 0, False)
	EndIf
	Return $tag
EndFunc   ;==>QueryDB

Func AddToDB($Filepath,$FullLoad = True)
	$tag = ReadFileInfo($Filepath)
	If @error > 0 Then Return SetError(1, 0, False)
	If $FullLoad Then
		$genre = UpdateGenre($tag[1], $tag[3])
		If Not @error Then $tag[4] = $genre
	EndIf
	If LoadSetting("settings","coverload",$GUI_CHECKED) == $GUI_CHECKED And Not FileExists(StringLeft($tag[6],StringInStr($tag[6],"\",0,-1)) & "Folder.jpg") And Not FileExists("covers\" & $tag[1] & "-" & $tag[2] & ".jpg") And $FullLoad Then LoadCover($tag[1], $tag[2])
	ReDim $tag[9]
	$message = ""
	$tag[6] = $Filepath
	$tag[7] = 0
	$tag[8] = 10
	For $i = 1 To 8
		$message &= '"' & StringReplace($tag[$i], '"', "'") & '",'
	Next
	$message = StringTrimRight($message, 1)
	_SQLite_Exec(-1, 'INSERT INTO Songs (Artist,Album,Track,Genre,Filetype,Path,LastPlayed,Rating) VALUES (' & $message & ');') ; INSERT Data
	Return True
EndFunc   ;==>AddToDB

Func _GetInterpret($path)
	If @OSVersion == "WIN_VISTA"  Then
		Return _GetExtProperty($path, 13)
	Else
		Return _GetExtProperty($path, 16)
	EndIf
EndFunc   ;==>_GetInterpret

Func SecureCheck($file)
	$Secured = _GetExtProperty($file, 23)
	If $Secured = "Yes"  Or $Secured = "Ja"  Then Return False
	Return True
EndFunc   ;==>SecureCheck

Func ReadFileInfo($file)
	Local $tag[8]
	If @OSVersion == "WIN_XP"  Then
		$tag[1] = _GetExtProperty($file, 16)
		$tag[2] = _GetExtProperty($file, 17)
		$tag[3] = _GetExtProperty($file, 10)
		$tag[4] = _GetExtProperty($file, 20)
	ElseIf @OSVersion == "WIN_VISTA"  Then
		$tag[1] = _GetExtProperty($file, 13)
		$tag[2] = _GetExtProperty($file, 14)
		$tag[3] = _GetExtProperty($file, 21)
		$tag[4] = _GetExtProperty($file, 16)
	EndIf
	$tag[5] = _GetExtProperty($file, 2)
	If $tag[2] == 0 Then $tag[2] = "Unknown"
	If $tag[3] == 0 Or $tag[1] == 0 Then SetError(1)
	Return $tag
EndFunc   ;==>ReadFileInfo

Func Database()
	_SQLite_QueryFinalize($hQuery)
	_SQLite_Close()
	_SQLite_Shutdown()
	RunWait("resource\database.exe")
	_SQLite_Startup()
	_SQLite_Open("db\PPlayer.db")
EndFunc   ;==>Database

#endregion

#region Startup / Quit (Startup,StartTray,StartGUI,logoff)

Func Startup()
	Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
	#region Globals *************************************************************************
	Global $hDragImageList, $h_ListView, $bDragging = False, $StatusBar1, $LV_Height
	Global $a_index[2]
	Global Const $WM_LBUTTONUP = 0x202
	Global Const $WM_MOUSEMOVE = 0x200
	Global Enum $LVI_MASK = 1, $LVI_IITEM, $LVI_ISUBITEM, $LVI_STATE, $LVI_STATEMASK, $LVI_PSZTEXT, _
			$LVI_CCHTEXTMAX, $LVI_IIMAGE, $LVI_LPARAM, $LVI_IINDENT
	Global Const $DebugIt = 1
	Global Const $NM_LAST = (-99)
	Global Const $LVM_SETITEM = ($LVM_FIRST + 6)
	Global Const $LVIF_NORECOMPUTE = 0x0800
	Global $Delimiters = '|-|'
	Global $HOVER_CONTROLS_ARRAY[1][1]
	Global $LAST_HOVERED_ELEMENT[2] = [-1, -1]
	Global $LAST_HOVERED_ELEMENT_MARK = -1
	Global $pTimerProc = DllCallbackRegister("CALLBACKPROC", "none", "hwnd;uint;uint;dword")
	Global $uiTimer = DllCall("user32.dll", "uint", "SetTimer", "hwnd", 0, "uint", 0, "int", 10, "ptr", DllCallbackGetPtr($pTimerProc))
	$uiTimer = $uiTimer[0]
	Global $liste[1], $ActiveSongInfo[9], $ActiveSongSimilar[100], $DroppedFiles[1], $Playing = False, $check = 1, $oldstate = ""
	Global $OldSkin = GetOpt("skin"),$SliderChange = True, $dClicked = False, $SearchWait = False, $SongCapturedByPlugin = False, $Notify_WM = True, $hidden = False, $Pod_Notified = False, $Muted = False, $DB_Notified = False, $LeaveWhile = False, $Version_Notified = False, $Verified = False, $Verify_Notified = False, $Exit = False, $Restart = False
	Global $StatListView1 = 0, $Changing = 0, $Searchview = 0, $SettingsSlider1Old = 0, $oldpos = 0, $active_sound = 0, $pObj = 0, $count = 0, $activelistid = -1, $oldlistid = 0, $SearchGUI = 0, $WM_DROPFILES = 0x233, $WM_List = 0x0111, $next_sound = 0
	Global $hQuery, $sMsg
	Global $factorY = _GetExtProperty($Skin_Folder & "\1.bmp", 28)
	$factorY = StringLeft($factorY, StringInStr($factorY, " ") - 1)
	If $factorY < IniRead($Skin_Folder & "\Skin.dat", "settings", "size", 20) Then $factorY = IniRead($Skin_Folder & "\Skin.dat", "settings", "size", 20)
	Global $factorX = _GetExtProperty($Skin_Folder & "\3.bmp", 27)
	$factorX = StringLeft($factorX, StringInStr($factorX, " ") - 1)
	If $factorX < IniRead($Skin_Folder & "\Skin.dat", "settings", "size", 20) Then $factorX = IniRead($Skin_Folder & "\Skin.dat", "settings", "size", 20)
	#endregion End Global variables
	_SQLite_Startup()
	_SQLite_Open("db\PPlayer.db")
	FileDelete("db\MainDB.ini")
	If IniRead("db\settings.ini", "infos", "dbversion", 0) == 0 Then
		If Info("Congratulations! You just installed PPlayer. It's recommended to create a database containing your songs to get the full power of PPlayer. Do you want to create a database?", 4) == 6 Then
			Database()
		Else
			IniWrite("db\settings.ini", "infos", "dbversion", $dbversion)
			Info("Your database will now be filled with every song you hear. But you're only able to search for songs you already heard. If you want to create a database click 'Menu->Database")
		EndIf
	EndIf
	WMStartPlayer()
	$pObj.settings.enableErrorDialogs = False
	ObjEvent($pObj,"TestEvent")
	StartGUI()
	PluginTrigger("MainGUICreated")
	BuildGUIs()
	PluginTrigger("CreateCustomGUI")
	Show()
	If $CmdLine[0] > 0 Then SetList($CmdLine[1])
	If LoadSetting("settings","loadsongs",$GUI_UNCHECKED) == $GUI_CHECKED Then
		$Playing = True
		$msg = StringSplit(LoadSetting("infos","lastsong",""),"|")
		For $i = 1 To $msg[0]
			SetList($msg[$i])
		Next
		$msg = LoadSetting("infos","lastsongid",0)
		Focus($msg)
		Play_active()
	EndIf
	StartTray()
	Opt("OnExitFunc", "logoff")
	GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC")
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY") ; Very slowing...
	GUIRegisterMsg($WM_COPYDATA, "_GUIRegisterMsgProc")
	GUIRegisterMsg($WM_LBUTTONUP, "WM_LButtonUp_Events")
	GUIRegisterMsg($WM_MOUSEMOVE, "WM_MouseMove_Events")
	HotKeySet("{MEDIA_NEXT}", "NextInList")
	HotKeySet("{MEDIA_PREV}", "PrevInList")
	HotKeySet("{MEDIA_PLAY_PAUSE}", "HookPlayPause")
	HotKeySet("{MEDIA_STOP}", "Pause")
	AdlibEnable("global_check", 500)
	db_check()
	XSkinTrayBox("PPlayer Info", "Up and running")
	ErrorWrite("Startup took " & Round(TimerDiff($Begin) / 1000, 4) & " sec")
	PluginTrigger("OnPPlayerLoaded")
EndFunc   ;==>Startup

Func TestEvent($Event)
	debug("Event called: " & $Event)
	If $Event == "Buffering" Then
		debug($pobj.network.bufferingProgress)
	ElseIf $Event == "MediaChange" Then
		debug($pObj.currentMedia.name)
		debug(WMGETArtist($pObj.currentMedia))
		debug(WMGetAlbum($pObj.currentMedia))
		debug(WMGetGenre($pObj.currentMedia))
		debug(WMGetTitle($pObj.currentMedia))
	EndIf
EndFunc

Func StartTray()
	TraySetOnEvent(-13, "Show")
	TraySetClick(8)
	TraySetToolTip("PPlayer V" & $version & ": Simply click on the tray to reopen the window")
	TraySetIcon("resource\pplayer.ico")
	TrayCreateItem("Open")
	TrayItemSetOnEvent(-1, "show")
	$Tray_Media = TrayCreateMenu("Media")
	TrayCreateItem("Add Song", $Tray_Media)
	TrayItemSetOnEvent(-1, "AddWithDialog")
	TrayCreateItem("Play", $Tray_Media)
	TrayItemSetOnEvent(-1, "Play_active")
	Global $Tray_Pause = TrayCreateItem("Pause", $Tray_Media)
	TrayItemSetOnEvent(-1, "Pause")
	TrayCreateItem("Next", $Tray_Media)
	TrayItemSetOnEvent(-1, "nextinlist")
	TrayCreateItem("Prev", $Tray_Media)
	TrayItemSetOnEvent(-1, "previnlist")
	TrayCreateItem("Stop", $Tray_Media)
	TrayItemSetOnEvent(-1, "Stop")
	TrayCreateItem("Exit")
	TrayItemSetOnEvent(-1, "logoff")
	TraySetState(2)
EndFunc   ;==>StartTray

Func StartGUI()
	Global $Title = "PPlayer - V" & $version & " " & Chr(169) & " Pascal"
	$y = IniRead("db\settings.ini", "window", "y", @DesktopHeight / 2 - 250)
	If $y + 1 > @DesktopHeight Then
		$y = @DesktopHeight / 2 - 250
		_IniWrite("db\settings.ini", "window", "y", $y)
	EndIf
	$GUI = "resource\" & LoadSetting("settings", "PPlayerkxf", "Default") & "PPlayer.kxf"
	If IniRead("db\GUI.ini", "created", $GUI, 0) <> FileGetSize($GUI) Then CreateGUIIni($GUI)
	Global $MainGUI = XSkinGUICreate($Title, GIR("PPlayer", "width") + $factorX * 2, GIR("PPlayer", "height") + $factorY * 2, $Skin_Folder, 1, 25, IniRead("db\settings.ini", "window", "x", @DesktopWidth / 2 - 250), $y, $WS_EX_ACCEPTFILES)
	GUISetOnEvent($GUI_EVENT_DROPPED, "AddToList", $MainGUI)
	GUISetStyle(-1, $WS_EX_ACCEPTFILES, $MainGUI)
	XSkinIcon($MainGUI, 3, StringSplit("logoff|Hide|Help", "|"))
	GUISetIcon("icos\pplayer.ico")
	Global $lieder = GUICtrlCreateListView("", GIR("lieder", "left"), GIR("lieder", "top"), GIR("lieder", "width"), GIR("lieder", "height"), $LVS_NOCOLUMNHEADER + $LVS_SHOWSELALWAYS)
	GUICtrlSetBkColor(-1, "0x" & GetOpt("BkColor"))
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	_GUICtrlListView_InsertColumn($lieder, 0, "Text", GIR("lieder", "width") - 5, 2)
	$LV_Height = GIR("lieder", "height") - GIR("lieder", "top")
	$h_ListView = ControlGetHandle($MainGUI, "", $lieder)
	$CM = GUICtrlCreateContextMenu($lieder)
	GUICtrlCreateMenuItem("Play",$CM )
	GUICtrlSetOnEvent(-1, "Play_active")
	GUICtrlCreateMenuItem("Add",$CM )
	GUICtrlSetOnEvent(-1, "AddWithDialog")
	GUICtrlCreateMenuItem("Delete",$CM )
	GUICtrlSetOnEvent(-1, "DelFromList")
	GUICtrlCreateMenuItem("Rate",$CM )
	GUICtrlSetOnEvent(-1, "Rate_GUI")
	Global $pause_button = GUICtrlCreateIcon($PP_IcoFolder, 7, GIR("play", "left"), GIR("play", "top"), GIR("play", "width"), GIR("play", "height"))
	GUICtrlSetOnEvent(-1, "Pause")
	GUICtrlCreateIcon($PP_IcoFolder, 11, GIR("stop", "left"), GIR("stop", "top"), GIR("stop", "width"), GIR("stop", "height"))
	GUICtrlSetOnEvent(-1, "Stop")
	GUICtrlCreateIcon($PP_IcoFolder, 5, GIR("next", "left"), GIR("next", "top"), GIR("next", "width"), GIR("next", "height"))
	GUICtrlSetOnEvent(-1, "NextInList")
	GUICtrlCreateIcon($PP_IcoFolder, 8, GIR("prev", "left"), GIR("prev", "top"), GIR("prev", "width"), GIR("prev", "height"))
	GUICtrlSetOnEvent(-1, "PrevInList")
	GUICtrlCreateIcon($PP_IcoFolder, 9, GIR("del", "left"), GIR("del", "top"), GIR("del", "width"), GIR("del", "height"))
	GUICtrlSetOnEvent(-1, "DelFromList")
	GUICtrlCreateIcon($PP_IcoFolder, 2, GIR("rate", "left"), GIR("rate", "top"), GIR("rate", "width"), GIR("rate", "height"))
	GUICtrlSetOnEvent(-1, "Rate_GUI")
	GUICtrlCreateIcon($PP_IcoFolder, 1, GIR("add", "left"), GIR("add", "top"), GIR("add", "width"), GIR("add", "height"))
	GUICtrlSetOnEvent(-1, "AddWithDialog")
	$MenuButton = GUICtrlCreateIcon($PP_IcoFolder, 3, GIR("menu", "left"), GIR("menu", "top"), GIR("menu", "width"), GIR("menu", "height"))
	GUICtrlSetOnEvent(-1, "NotifyMenu")
	$Menu = GUICtrlCreateContextMenu($MenuButton)
	
	GUICtrlCreateMenuItem("Database", $Menu)
	GUICtrlSetOnEvent(-1, "Database")
	GUICtrlCreateMenuItem("Help", $Menu)
	GUICtrlSetOnEvent(-1, "Help")
	GUICtrlCreateMenuItem("PlayMode", $Menu)
	GUICtrlSetOnEvent(-1, "Playmode")
	GUICtrlCreateMenuItem("Settings", $Menu)
	GUICtrlSetOnEvent(-1, "Settings")
	GUICtrlCreateMenuItem("Statistic", $Menu)
	GUICtrlSetOnEvent(-1, "Stat")
	If $PluginMenus[0][0] > 0 Then
		$PluginMenu = GUICtrlCreateMenuItem("", $Menu)
		For $i = 1 To $PluginMenus[0][0]
			GUICtrlCreateMenuItem($PluginMenus[$i][1], $Menu)
			GUICtrlSetOnEvent(-1, $PluginMenus[$i][0])
		Next
	EndIf
	If LoadSetting("settings", "Statusbar", $GUI_UNCHECKED) == $GUI_CHECKED Then Global $StatusBar = _GUICtrlStatusBar_Create($MainGUI, 500, "")
	Global $ShowAlbum = GUICtrlCreatePic("", GIR("showalbum", "left"), GIR("showalbum", "top"), GIR("showalbum", "width"), GIR("showalbum", "height"))
	GUICtrlCreateLabel("Track:" & @CRLF & "Artist:" & @CRLF & "Album:" & @CRLF & "Genre:" & @CRLF & "Filetype:" & @CRLF & "Last time played" & @CRLF & "Rating:" & @CRLF & "Similar Bands:", GIR("info_label2", "left"), GIR("info_label2", "top"), GIR("info_label2", "width"), GIR("info_label2", "height"))
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	Global $info_label = GUICtrlCreateLabel("", GIR("info_label", "left"), GIR("info_label", "top"), GIR("info_label", "width"), GIR("info_label", "height"), $SS_LEFTNOWORDWRAP)
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	Global $pos_label = GUICtrlCreateLabel("00:00/00:00", GIR("pos_label", "left"), GIR("pos_label", "top"), GIR("pos_label", "width"), GIR("pos_label", "height"))
	GUICtrlSetColor(-1, "0x" & GetOpt("TextColor"))
	Global $Pos_Slider = GUICtrlCreateSlider(GIR("pos_slider", "left"), GIR("pos_slider", "top"), GIR("pos_slider", "width"), GIR("pos_slider", "height"), BitOR($TBS_BOTH, $TBS_NOTICKS, $TBS_FIXEDLENGTH))
	GUICtrlSetData(-1, 0)
	GUICtrlSetOnEvent(-1, "ChangePos")
	GUICtrlSetLimit(-1, 1000, 0)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, "0x" & GetOpt("BkColor"))
	GUICtrlSetOnHover($Pos_slider,"OnSliderHover","OnSliderHoverOff")
	Global $Vol_Slider = GUICtrlCreateSlider(GIR("vol_slider", "left"), GIR("vol_slider", "top"), GIR("vol_slider", "width"), GIR("vol_slider", "height"))
	GUICtrlSetLimit(-1, 100, 0)
	GUICtrlSetData(-1, IniRead("db\settings.ini", "Infos", "Vol", 100))
	GUICtrlSetOnEvent(-1, "ChangeVol")
	GUICtrlSetBkColor(-1, "0x" & GetOpt("BkColor"))
	ChangeVol()
	Global $Vol_Muter = GUICtrlCreateIcon($PP_IcoFolder, 4, GIR("mute", "left"), GIR("mute", "top"), GIR("mute", "width"), GIR("mute", "height"))
	GUICtrlSetOnEvent(-1, "MuteVol")
	GUICtrlSetImage(-1, $PP_IcoFolder, 10)
EndFunc   ;==>StartGUI

Func OnSliderHover($Control)
	$SliderChange = False
EndFunc

Func OnSliderHoverOff($Control)
	$SliderChange = True
EndFunc

Func CreateGUIIni($GUI)
	$GF = StringSplit(FileRead($GUI), @CRLF)
	For $i = 1 To $GF[0]
		If StringInStr($GF[$i], "object") > 0 And StringInStr($GF[$i], "name") > 0 Then
			$LookUp = _StringBetween($GF[$i], '"', '"')
		ElseIf StringInStr($GF[$i], "property") > 0 Then
			$Read = _StringBetween($GF[$i], ">", "<")
			If Not @error Then
				$Name = _StringBetween($GF[$i], '"', '"')
				IniWrite("db\GUI.ini", $LookUp[1], StringLower($Name[0]), $Read[0])
			EndIf
		EndIf
	Next
	IniWrite("db\GUI.ini", "created", $GUI, FileGetSize($GUI))
EndFunc   ;==>CreateGUIIni

Func GIR($ob, $in)
	If StringInStr("left", $in) Then
		Return IniRead("db\GUI.ini", $ob, $in, "") + $factorX
	ElseIf StringInStr("top", $in) Then
		Return IniRead("db\GUI.ini", $ob, $in, "") + $factorY
	Else
		Return IniRead("db\GUI.ini", $ob, $in, "")
	EndIf
EndFunc   ;==>GIR

Func logoff()
	If Not $Exit Then
		$check = 0
		$Exit = True
		If $hidden Then
			GUISetState(@SW_SHOW, $MainGUI)
			GUISetState(@SW_RESTORE, $MainGUI)
		EndIf
		If GetOpt("Ani") == 1 Then XSkinAnimate($MainGUI, 2, 1) ; Does not work: Shuts down GUI
		GUIRegisterMsg($WM_DROPFILES, "")
		GUIRegisterMsg($WM_List, "")
		GUIRegisterMsg($WM_NOTIFY, "") ; Very slowing...
		GUIRegisterMsg($WM_COPYDATA, "")
		If LoadSetting("settings","Loadsongs",$GUI_UNCHECKED) == $GUI_CHECKED And UBound($liste) > 1 Then
			$msg = ""
			For $i = 0 To UBound($liste) - 1
				$msg &= $liste[$i] & "|"
			Next
			SaveSetting("infos","lastsong",StringTrimRight($msg,1))
			SaveSetting("infos","lastsongpos",Int(WMGetPosition()))
			SaveSetting("infos","lastsongid",$activelistid)
		EndIf
		WMClosePlayer()
		_SQLite_QueryFinalize($hQuery)
		_SQLite_Close()
		_SQLite_Shutdown()
		DllCallbackFree($pTimerProc)
		DllCall("user32.dll", "int", "KillTimer", "hwnd", 0, "uint", $uiTimer)
		$Pos = WinGetPos($Title)
		If Not @error Then
			_IniWrite("db\settings.ini", "window", "x", $Pos[0])
			_IniWrite("db\settings.ini", "window", "y", $Pos[1])
		EndIf
		If IniRead("db\settings.ini", "GUIStati", "Playmode", "Close") == "Open"  Then
			$Pos = WinGetPos("PPlayer - PlayMode")
			If Not @error Then
				_IniWrite("db\settings.ini", "window", "playx", $Pos[0])
				_IniWrite("db\settings.ini", "window", "playy", $Pos[1])
			EndIf
		EndIf
		GUIDelete($PlaymodeGUI)
		GUIDelete($Settings_GUI)
		GUIDelete($MainGUI)
		PluginTrigger("OnExit")
		WebAnnounce("Offline")
		SaveSetting("infos", "crash", 0)
		If $Restart Then Run("pplayer.exe")
		Exit 0
	EndIf
EndFunc   ;==>logoff

Func Folders()
	DirCreate("db")
	DirCreate("covers")
	DirCreate("Radio")
	DirCreate("Skins")
	DirCreate("Skins\Default")
	DirCreate("Plugins")
EndFunc   ;==>Folders

Func NotifyMenu()
	MouseClick("right")
EndFunc   ;==>NotifyMenu

#endregion

#region Checks

Func global_check()
	If $check == 1 Then
		$check = 0
		If Not $Verified Then WebAnnounce()
		If IsObj($active_sound) Then UpdateLabelPos($active_sound)
		$check = 1
	EndIf
EndFunc   ;==>global_check

Func db_check()
	_SQLite_Exec(-1, "CREATE TABLE IF NOT EXISTS Songs (Artist,Album,Track,Genre,Filetype,Path,LastPlayed,Rating);") ; CREATE a Table
	_SQLite_Exec(-1, "CREATE TABLE IF NOT EXISTS SongView (Played,Artist,Album,Track,Genre,Duration);") ; CREATE a Table
	$msg = '%"%'
	Dim $Query[1]
	Dim $Changed[1][6]
	_SQLite_Query(-1, "SELECT * FROM Songs WHERE Track LIKE '" & $msg & "' OR Artist LIKE '" & $msg & "' OR Album LIKE '" & $msg & "' OR Genre LIKE '" & $msg & "' OR Filetype LIKE '" & $msg & "';", $hQuery)
	While _SQLite_FetchData($hQuery, $Query) == $SQLITE_OK
		ReDim $Changed[UBound($Changed) + 1][7]
		For $i = 0 To 5
			If StringLen($Query[$i]) > 0 Then
				$Changed[UBound($Changed) - 1][$i] = StringReplace($Query[$i], '"', "'")
			Else
				$Changed[UBound($Changed) - 1][0] = "Error"
				ExitLoop
			EndIf
		Next
		$Changed[UBound($Changed) - 1][6] = $Query[5]
	WEnd
	_SQLite_QueryFinalize($hQuery)
	For $i = 1 To UBound($Changed) - 1
		If $Changed[$i][0] <> "Error"  Then
			If StringInStr($Changed[$i][6], '"') Then
				$msg = "WHERE Path = '" & $Changed[$i][6] & "'"
			Else
				$msg = 'WHERE Path = "' & $Changed[$i][6] & '"'
			EndIf
			_SQLite_Exec(-1, 'UPDATE Songs SET Artist = "' & $Changed[$i][0] & '", Album = "' & $Changed[$i][1] & '", Track = "' & $Changed[$i][2] & '", Genre = "' & $Changed[$i][3] & '", Filetype = "' & $Changed[$i][4] & '", Path = "' & $Changed[$i][5] & '" ' & $msg & ';')
		EndIf
	Next
	$msg = '%"%'
	Dim $Query[1]
	Dim $Changed[1][6]
	_SQLite_Query(-1, "SELECT * FROM SongView WHERE Track LIKE '" & $msg & "' OR Artist LIKE '" & $msg & "' OR Album LIKE '" & $msg & "' OR Genre LIKE '" & $msg & "';", $hQuery)
	While _SQLite_FetchData($hQuery, $Query) == $SQLITE_OK
		ReDim $Changed[UBound($Changed) + 1][7]
		For $i = 0 To 3
			If StringLen($Query[$i]) > 0 Then
				$Changed[UBound($Changed) - 1][$i] = StringReplace($Query[$i + 1], '"', "'")
			Else
				$Changed[UBound($Changed) - 1][0] = "Error"
				ExitLoop
			EndIf
		Next
		$Changed[UBound($Changed) - 1][4] = $Query[0]
	WEnd
	_SQLite_QueryFinalize($hQuery)
	For $i = 1 To UBound($Changed) - 1
		If $Changed[$i][0] <> "Error"  Then
			_SQLite_Exec(-1, 'UPDATE SongView SET Artist = "' & $Changed[$i][0] & '", Album = "' & $Changed[$i][1] & '", Track = "' & $Changed[$i][2] & '", Genre = "' & $Changed[$i][3] & '" WHERE Played = "' & $Changed[$i][4] & '";')
		EndIf
	Next
	_SQLite_Exec(-1, "CREATE TABLE IF NOT EXISTS SongView (Played,Artist,Album,Track,Genre,Duration);") ; CREATE a Table
EndFunc   ;==>db_check

Func CheckUDP()
	While 1
		$data = UDPRecv($Socket, 1000)
		If $data <> "" Then
			SetList($data)
		Else
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>CheckUDP

#endregion

#region Playlist

Func AddWithDialog()
	$check = 0
	$file = FileOpenDialog("Choose Song to add", IniRead("db\settings.ini", "infos", "lastdir", ""), "PPlayer Media Files (*.mp3;*.wma;*.ogg)|All (*.*)", 5)
	FileChangeDir($PP_Dir)
	If StringLen($file) > 0 Then
		If StringInStr($file, "|") > 0 Then
			$file = StringSplit($file, "|")
			$dir = $file[1]
			For $i = 2 To $file[0]
				SetList($dir & "\" & $file[$i])
			Next
		Else
			SetList($file)
		EndIf
	EndIf
	$check = 1
EndFunc   ;==>AddWithDialog

Func AddToList() 
	For $i = 0 To UBound($DroppedFiles) - 1 
		SetList($DroppedFiles[$i])
	Next 
EndFunc ;==>AddToList 

Func SetList($filename)
	If StringLen($filename) > 0 Then
		If StringLeft($filename, 10) = "pplayer://"  Then
			$Line = StringTrimLeft($filename, 10)
			If StringLeft($Line, 7) <> "http://"  Then $Line = "http://" & $Line
			$filename = $Line
		EndIf
		If StringInStr(FileGetAttrib($filename),"D") Then
			$Files = _FileSearch($filename,"*.mp3;*.wma;*.ogg;*.wav",0,"",True) 
			If IsArray($Files) Then
				For $i = 1 To $Files[0]
					SetList(debug($Files[$i]))
				Next
			EndIf
			Return ""
		ElseIf StringLen(_GetExtProperty($filename,21)) == 0 And FileExists($filename) Then
			Return ""
		EndIf
		$tag = QueryDB($Filename)
		If Not @error Then
			$show = $tag[3] & " - " & $tag[1]
			Inqueue($tag[3], $tag[1])
		Else
			$tag = ReadFileInfo($filename)
			If Not @error Then
				$show = $tag[3] & " - " & $tag[1]
				Inqueue($tag[3], $tag[1])
				AddToDB($filename,False)
			Else
				$show = StringTrimLeft($filename, StringInStr($filename, "\", 1, -1))
			EndIf
		EndIf
		$id = _GUICtrlListView_AddItem($lieder, $show)
		If $id > 0 Then ReDim $liste[UBound($liste) + 1]
		$liste[$id] = $filename
		If Not $Playing Then
			Focus($id)
			Play_active()
		EndIf
	EndIf
EndFunc   ;==>SetList

Func ScrollList()
	_GUICtrlListView_Scroll($lieder, 0, $activelistid - $oldlistid)
EndFunc   ;==>ScrollList

Func DelFromList()
	$ItemSel = _GUICtrlListView_GetSelectedIndices($lieder, True)
	If $ItemSel[0] > 0 Then
		$PlayNext = False
		For $i = 1 To $ItemSel[0]
			$tag = ReadFileInfo($liste[$ItemSel[$i]])
			Outqueue($tag[3], $tag[1])
			If $activelistid == $ItemSel[$i] Then
				$activelistid -= 1
				$PlayNext = True
			EndIf
			If $ItemSel[$i] < $activelistid Then $activelistid -= 1
			Focus($ItemSel[$i])
		Next
		For $i = 1 To $ItemSel[0]
			_ArrayDelete($liste, $ItemSel[$i])
		Next
		_GUICtrlListView_DeleteItemsSelected($lieder)
		If $PlayNext Then
			NextInList()
		ElseIf UBound($liste) == 1 And StringLen($liste[0]) == 0 Then
			Stop()
		Else
			Focus($activelistid)
		EndIf
	Else
		Error("No item(s) selected")
	EndIf
EndFunc   ;==>DelFromList

Func Focus($id)
	_GUICtrlListView_SetItemSelected($lieder, $id)
	ScrollList()
EndFunc   ;==>Focus

Func UnFocus($id)
	_GUICtrlListView_SetItemSelected($lieder, $id, False)
EndFunc   ;==>UnFocus

Func UpdateList($id, $titel, $interpret)
	_GUICtrlListView_SetItemText($lieder, $id, $titel & " - " & $interpret)
EndFunc   ;==>UpdateList

#endregion

#region UDFs

Func GUICtrlSetOnHover($CtrlID, $HoverFuncName, $LeaveHoverFuncName=-1)
	Local $Ubound = UBound($HOVER_CONTROLS_ARRAY)
	ReDim $HOVER_CONTROLS_ARRAY[$Ubound+1][3]
	$HOVER_CONTROLS_ARRAY[$Ubound][0] = GUICtrlGetHandle($CtrlID)
	$HOVER_CONTROLS_ARRAY[$Ubound][1] = $HoverFuncName
	$HOVER_CONTROLS_ARRAY[$Ubound][2] = $LeaveHoverFuncName
	$HOVER_CONTROLS_ARRAY[0][0] = $Ubound
EndFunc

;CallBack function to handle the hovering process
Func CALLBACKPROC($hWnd, $uiMsg, $idEvent, $dwTime)
	If UBound($HOVER_CONTROLS_ARRAY)-1 < 1 Then Return
	Local $ControlGetHovered = _ControlGetHovered()
	Local $sCheck_LHE = $LAST_HOVERED_ELEMENT[1]
	
	If $ControlGetHovered = 0 Or ($sCheck_LHE <> -1 And $ControlGetHovered <> $sCheck_LHE) Then
		If $LAST_HOVERED_ELEMENT_MARK = -1 Then Return
		If $LAST_HOVERED_ELEMENT[0] <> -1 Then Call($LAST_HOVERED_ELEMENT[0], $LAST_HOVERED_ELEMENT[1])
		$LAST_HOVERED_ELEMENT[0] = -1
		$LAST_HOVERED_ELEMENT[1] = -1
		$LAST_HOVERED_ELEMENT_MARK = -1
	Else
		For $i = 1 To $HOVER_CONTROLS_ARRAY[0][0]
			If $HOVER_CONTROLS_ARRAY[$i][0] = GUICtrlGetHandle($ControlGetHovered) Then
				If $LAST_HOVERED_ELEMENT_MARK = $HOVER_CONTROLS_ARRAY[$i][0] Then ExitLoop
				$LAST_HOVERED_ELEMENT_MARK = $HOVER_CONTROLS_ARRAY[$i][0]
				Call($HOVER_CONTROLS_ARRAY[$i][1], $ControlGetHovered)
				If $HOVER_CONTROLS_ARRAY[$i][2] <> -1 Then
					$LAST_HOVERED_ELEMENT[0] = $HOVER_CONTROLS_ARRAY[$i][2]
					$LAST_HOVERED_ELEMENT[1] = $ControlGetHovered
				EndIf
				ExitLoop
			EndIf
		Next
	EndIf
EndFunc

;Thanks to amel27 for that one!!!
Func _ControlGetHovered()
	Local $Old_Opt_MCM = Opt("MouseCoordMode", 1)
	Local $iRet = DllCall("user32.dll", "int", "WindowFromPoint", _
		"long", MouseGetPos(0), _
		"long", MouseGetPos(1))
	$iRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $iRet[0])
	Opt("MouseCoordMode", $Old_Opt_MCM)
	Return $iRet[0]
EndFunc

Func _TimeGetStamp()
	Local $av_Time
	$av_Time = DllCall('CrtDll.dll', "long", 'time')
	If @error Then Return ""
	Return $av_Time[0]
EndFunc   ;==>_TimeGetStamp

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
				Return 0
			Else
				Return $sProperty
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GetExtProperty

Func _GetCPUID()
	If Not (IsDeclared("$cI_CompName")) Then
		Global $cI_CompName = @ComputerName
	EndIf
	Global $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20 	;DO NOT CHANGE _	;DO NOT CHANGE
	
	Local $colItems, $objWMIService, $objItem
	$objWMIService = ObjGet("winmgmts:\\" & $cI_CompName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) Then
		For $objItem In $colItems
			Return $objItem.ProcessorID
		Next
	EndIf
EndFunc   ;==>_GetCPUID

Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
	$objEmail = ObjCreate("CDO.Message")
	If IsObj($objEmail) Then
		$objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
		$objEmail.To = $s_ToAddress
		$objEmail.Subject = $s_Subject
		If StringInStr($as_Body, "<") And StringInStr($as_Body, ">") Then
			$objEmail.HTMLBody = $as_Body
		Else
			$objEmail.Textbody = $as_Body & @CRLF
		EndIf
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
		;Authenticated SMTP
		If $s_Username <> "" Then
			$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
			$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
			$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
		EndIf
		If $ssl Then
			$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
		EndIf
		;Update settings
		$objEmail.Configuration.Fields.Update
		; Sent the Message
		$objEmail.Send
		If @error Then
			Return False
		Else
			Return True
		EndIf
	Else
		Return False
	EndIf
EndFunc   ;==>_INetSmtpMailCom


Func GenKey()
	$_GUID = DllStructCreate("uint;ushort;ushort;ubyte[8]")
	If @error Then Exit
	$Ret = DllCall("Rpcrt4.dll", "ptr", "UuidCreate", "ptr", DllStructGetPtr($_GUID))
	If Not @error And $Ret[0] == 0 Then
		$uuid = Hex(DllStructGetData($_GUID, 1), 8) & "-" & _
				Hex(DllStructGetData($_GUID, 2), 4) & "-" & _
				Hex(DllStructGetData($_GUID, 3), 4) & "-" & _
				Hex(DllStructGetData($_GUID, 4, 1), 2) & Hex(DllStructGetData($_GUID, 4, 2), 2) & "-"
		For $x = 3 To 8
			$uuid = $uuid & Hex(DllStructGetData($_GUID, 4, $x), 2)
		Next
		Return $uuid
	EndIf
EndFunc   ;==>GenKey

Func _StringBetween($sString, $sStart, $sEnd, $vCase = -1, $iSRE = -1)
	If $iSRE = -1 Or $iSRE = Default Then
		If $vCase = -1 Or $vCase = Default Then
			$vCase = 0
		Else
			$vCase = 1
		EndIf
		Local $sHold = '', $sSnSStart = '', $sSnSEnd = ''
		While StringLen($sString) > 0
			$sSnSStart = StringInStr($sString, $sStart, $vCase)
			If Not $sSnSStart Then ExitLoop
			$sString = StringTrimLeft($sString, ($sSnSStart + StringLen($sStart)) - 1)
			$sSnSEnd = StringInStr($sString, $sEnd, $vCase)
			If Not $sSnSEnd Then ExitLoop
			$sHold &= StringLeft($sString, $sSnSEnd - 1) & Chr(1)
			$sString = StringTrimLeft($sString, $sSnSEnd)
		WEnd
		If Not $sHold Then Return SetError(1, 0, 0)
		$sHold = StringSplit(StringTrimRight($sHold, 1), Chr(1))
		Local $avArray[UBound($sHold) - 1]
		For $iCC = 1 To UBound($sHold) - 1
			$avArray[$iCC - 1] = $sHold[$iCC]
		Next
		Return $avArray
	Else
		If $vCase = Default Or $vCase = -1 Then
			$vCase = '(?i)'
		Else
			$vCase = ''
		EndIf
		Local $aArray = StringRegExp($sString, '(?s)' & $vCase & $sStart & '(.*?)' & $sEnd, 3)
		If IsArray($aArray) Then Return $aArray
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_StringBetween

Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $DroppedFiles[$i + 1]
		$DroppedFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
		;Info($DroppedFiles[$i])
	Next
EndFunc   ;==>WM_DROPFILES_FUNC

Func _LVInsertItem($i_FromItem, $i_ToItem)
	Local $struct_LVITEM = DllStructCreate("int;int;int;int;int;ptr;int;int;int;int")
	If @error Then Return SetError(-1, -1, -1)
	Local $struct_String = DllStructCreate("char[4096]")
	If @error Then Return SetError(-1, -1, -1)
	Local $sBuffer_pointer = DllStructGetPtr($struct_String)
	Local $LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
	DllStructSetData($struct_LVITEM, $LVI_MASK, BitOR($LVIF_STATE, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_TEXT))
	DllStructSetData($struct_LVITEM, $LVI_STATEMASK, $LVIS_STATEIMAGEMASK)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_FromItem)
	DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, 0)
	DllStructSetData($struct_LVITEM, $LVI_CCHTEXTMAX, 4096)
	DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $sBuffer_pointer)
	_SendMessage($h_ListView, $LVM_GETITEMA, 0, $LVITEM_pointer)
	If @error Then Return SetError(-1, -1, -1)
	Local $item_state = DllStructGetData($struct_LVITEM, $LVI_STATE)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_ToItem)
	Local $i_newIndex = _SendMessage($h_ListView, $LVM_INSERTITEMA, 0, DllStructGetPtr($struct_LVITEM))
	If @error Then Return SetError(-1, -1, -1)
	If $DebugIt Then debug("$i_newIndex = " & $i_newIndex)
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_STATE)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_newIndex)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $item_state)
	DllStructSetData($struct_LVITEM, $LVI_STATEMASK, $LVIS_STATEIMAGEMASK)
	Local $iResult = _SendMessage($h_ListView, $LVM_SETITEMSTATE, $i_newIndex, DllStructGetPtr($struct_LVITEM))
	If @error Then Return SetError(-1, -1, -1)
	Return $i_newIndex
EndFunc   ;==>_LVInsertItem

Func WM_NOTIFY($hWnd, $msgID, $wParam, $lParam)
	Local $LocalNMHDR = DllStructCreate("int;int;int", $lParam)
	If @error Then Return $GUI_RUNDEFMSG
	If $wParam <> BitAND($wParam, 0xFFFF) Then debug($wParam & " " & BitAND($wParam, 0xFFFF))
	Switch $wParam
		Case $Searchview
			If $SearchWait And DllStructGetData($LocalNMHDR, 3) = -3 Then SetList(__GUICtrlListView_GetItemText($Searchview, _GUICtrlListView_GetNextItem($Searchview), 5))
		Case $StatListView1
			If DllStructGetData($LocalNMHDR, 3) = -3 Then
				Dim $Query[1]
				$StatInfo = StringSplit(__GUICtrlListView_GetItemText($StatListView1, _GUICtrlListView_GetNextItem($StatListView1)), "|")
				_SQLite_Query(-1, 'SELECT Path FROM Songs WHERE Artist = "' & $StatInfo[1] & '" AND Track = "' & $StatInfo[3] & '" AND Album = "' & $StatInfo[2] & '";', $hQuery)
				_SQLite_FetchData($hQuery, $Query)
				_SQLite_QueryFinalize($hQuery)
				SetList($Query[0])
			EndIf
		Case $lieder
			Switch DllStructGetData($LocalNMHDR, 3)
				Case - 3
					$dClicked = True
					Play_active()
				Case $LVN_BEGINDRAG
					Local $x = BitAND($lParam, 0xFFFF)
					Local $y = BitShift($lParam, 16)
					Local $struct_Point = DllStructCreate("int;int")
					DllStructSetData($struct_Point, 1, 8)
					DllStructSetData($struct_Point, 2, 8)
					Local $struct_tagNMLISTVIEW = DllStructCreate("int;uint;uint;int;int;uint;uint;uint;int;int;int", $lParam)
					$a_index[0] = DllStructGetData($struct_tagNMLISTVIEW, 4)
					$hDragImageList = _SendMessage($h_ListView, $LVM_CREATEDRAGIMAGE, $a_index[0], DllStructGetPtr($struct_Point))
					Local $struct_ImageInfo = DllStructCreate("int;int;int;int;int;int;int;int")
					If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
					Local $struct_ImageInfo_pointer = DllStructGetPtr($struct_ImageInfo)
					Local $aResult = DllCall("ComCtl32.dll", "int", "ImageList_GetImageInfo", "hwnd", $hDragImageList, "int", 0, _
							"ptr", $struct_ImageInfo_pointer)
					If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
					DllCall("ComCtl32.dll", "int", "ImageList_BeginDrag", "hwnd", $hDragImageList, "int", 0, "int", 0, "int", 0)
					If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
					If $DebugIt Then debug("From = " & $a_index[0])
					Local $hDesktopWindow = DllCall("user32.dll", "int", "GetDesktopWindow")
					$hDesktopWindow = $hDesktopWindow[0]
					DllCall("ComCtl32.dll", "int", "ImageList_DragEnter", "hwnd", $hDesktopWindow, "int", $x, "int", $y)
					DllCall("user32.dll", "int", "SetCapture", "hwnd", $hWnd)
					$bDragging = True
			EndSwitch
		Case $Vol_Slider
			ChangeVol()
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _LVCopyItem($i_FromItem, $i_ToItem, $i_SubItem = 0)
	Local $struct_LVITEM = DllStructCreate("int;int;int;int;int;ptr;int;int;int;int")
	Local $struct_String = DllStructCreate("char[4096]")
	Local $sBuffer_pointer = DllStructGetPtr($struct_String)
	Local $LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
	; get from item info
	DllStructSetData($struct_LVITEM, $LVI_MASK, BitOR($LVIF_STATE, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_TEXT))
	DllStructSetData($struct_LVITEM, $LVI_STATEMASK, $LVIS_STATEIMAGEMASK)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_FromItem)
	DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, $i_SubItem)
	DllStructSetData($struct_LVITEM, $LVI_CCHTEXTMAX, 4096)
	DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $sBuffer_pointer)
	_SendMessage($h_ListView, $LVM_GETITEMA, 0, $LVITEM_pointer)
	; set to
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_ToItem)
	; set text
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_TEXT)
	DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $sBuffer_pointer)
	DllStructSetData($struct_LVITEM, $LVI_CCHTEXTMAX, 4096)
	Local $iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	If @error Then Return SetError(@error, @error, @error)
	; set status
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_STATE)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	; set image
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_IMAGE)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $LVIF_IMAGE)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	; set state
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_STATE)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $LVIF_STATE)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	; set indent
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_INDENT)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $LVIF_INDENT)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	; set Param
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_PARAM)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $LVIF_PARAM)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
EndFunc   ;==>_LVCopyItem

Func WM_MouseMove_Events($hWndGUI, $msgID, $wParam, $lParam)
	If $bDragging = False Then Return $GUI_RUNDEFMSG
	Local $lpos = ControlGetPos($hWndGUI, "", $lieder)
	Local $x = BitAND($lParam, 0xFFFF) - $lpos[0]
	Local $y = BitShift($lParam, 16) - $lpos[1]
	If $y > $LV_Height Then
		_GUICtrlListView_Scroll($lieder, 0, $y)
	ElseIf $y < 20 Then
		_GUICtrlListView_Scroll($lieder, 0, $y * - 1)
	EndIf
	DllCall("ComCtl32.dll", "int", "ImageList_DragMove", "int", $x, "int", $y)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MouseMove_Events

Func WM_LButtonUp_Events($hWndGUI, $msgID, $wParam, $lParam)
	$bDragging = False
	Local $lpos = ControlGetPos($hWndGUI, "", $lieder)
	If @error Then Return $GUI_RUNDEFMSG
	Local $x = BitAND($lParam, 0xFFFF) - $lpos[0]
	Local $y = BitShift($lParam, 16) - $lpos[1]

	DllCall("ComCtl32.dll", "int", "ImageList_DragLeave", "hwnd", $h_ListView)
	DllCall("ComCtl32.dll", "int", "ImageList_EndDrag")
	DllCall("ComCtl32.dll", "int", "ImageList_Destroy", "hwnd", $hDragImageList)
	DllCall("user32.dll", "int", "ReleaseCapture")
	
	Local $struct_LVHITTESTINFO = DllStructCreate("int;int;uint;int;int;int")
	
	DllStructSetData($struct_LVHITTESTINFO, 1, $x)
	DllStructSetData($struct_LVHITTESTINFO, 2, $y)
	$a_index[1] = GUICtrlSendMsg($lieder, $LVM_HITTEST, 0, DllStructGetPtr($struct_LVHITTESTINFO))
	Local $flags = DllStructGetData($struct_LVHITTESTINFO, 2)
;~ 	// Out of the ListView?
	If $a_index[1] == -1 Then Return $GUI_RUNDEFMSG
;~ 	// Not in an item?
	If BitAND($flags, $LVHT_ONITEMLABEL) == 0 And BitAND($flags, $LVHT_ONITEMSTATEICON) == 0 Then Return $GUI_RUNDEFMSG
	If $a_index[0] <> $a_index[1] Then
		If $DebugIt Then debug("To = " & $a_index[1])
		If ($a_index[0] <> $a_index[0] + 1) Then
			Local $i_newIndex = _LVInsertItem($a_index[0], $a_index[1])
			If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
			Local $From_index = $a_index[0]
			If $a_index[0] > $a_index[1] Then $From_index = $a_index[0] + 1
			For $x = 1 To _GUICtrlListView_GetColumnCount($lieder) - 1
				_LVCopyItem($From_index, $i_newIndex, $x)
				If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
			Next
			_GUICtrlListView_DeleteItem($lieder, $From_index)
			
			If $From_index > $i_newIndex Then
				$Step = -1
				$From_index -= 1
			Else
				$Step = 1
				$i_newIndex -= 1
			EndIf
			If $From_index == $activelistid Then $activelistid = $i_newIndex
			$tempIndex = $liste[$From_index]
			For $i = $From_index To $i_newIndex + ($Step * - 1) Step $Step
				$liste[$i] = $liste[$i + $Step]
			Next
			$liste[$i_newIndex] = $tempIndex
			debug("Now activelistid = " & $activelistid)
			Focus($activelistid)
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_LButtonUp_Events

Func _AU3COM_SendData($acsd_InfotoSend, $acsd_RecvWinTitle)
	Local $StructDef_COPYDATA = "dword var1;dword var2;ptr var3";I have changed piccaso's structure
	Local $CDString = DllStructCreate("char var1[256];char var2[256]");the array to hold the string we are sending
	If @error Then SetError(0, @error, 0)
	DllStructSetData($CDString, 1, $acsd_InfotoSend)
	Local $pCDString = DllStructGetPtr($CDString);the pointer to the string
	If @error Then SetError(1, @error, 0)

	Local $vs_cds = DllStructCreate($StructDef_COPYDATA);create the message struct
	If @error Then SetError(2, @error, 0)
	DllStructSetData($vs_cds, "var1", 0);0 here indicates to the receiving program that we are sending a string
	If @error Then SetError(3, @error, 0)
	DllStructSetData($vs_cds, "var2", String(StringLen($acsd_InfotoSend) + 1));tell the receiver the length of the string
	If @error Then SetError(4, @error, 0)
	DllStructSetData($vs_cds, "var3", $pCDString);the pointer to the string
	If @error Then SetError(5, @error, 0)
	Local $pStruct = DllStructGetPtr($vs_cds)
	If @error Then SetError(6, @error, 0)
	_SendMessage(WinGetHandle($acsd_RecvWinTitle), $WM_COPYDATA, 0, $pStruct)
	$vs_cds = 0;free the struct
	$CDString = 0;free the struct
	Return 1
EndFunc   ;==>_AU3COM_SendData

Func _AU3COM_RecvData($acomrd_LParam)
	; $acomrd_LParam = Poiter to a COPYDATA Struct
	Local $STRUCTDEF_AU3MESSAGE = "char var1[256];int"
	Local $StructDef_COPYDATA = "dword var1;dword var2;ptr var3"
	Local $vs_cds = DllStructCreate($StructDef_COPYDATA, $acomrd_LParam)
	; Member No. 3 of COPYDATA Struct (PVOID lpData;) = Pointer to Costum Struct
	Local $vs_msg = DllStructCreate($STRUCTDEF_AU3MESSAGE, DllStructGetData($vs_cds, 3))
	Return $vs_msg
EndFunc   ;==>_AU3COM_RecvData

Func _GUIRegisterMsgProc($hWnd, $msgID, $wParam, $lParam)
	Local $vs_msg = _AU3COM_RecvData($lParam)
	Local $MSGRECVD = DllStructGetData($vs_msg, 1)
	Local $MSGRECVD_SplitArray = StringSplit($MSGRECVD, $Delimiters, 1)
	If $MSGRECVD_SplitArray[1] = 'PPlayerPath'  Then SetList($MSGRECVD_SplitArray[2])
EndFunc   ;==>_GUIRegisterMsgProc

Func _FileSearch($sPath, $sFilter = '*.*', $iFlag = 0, $sExclude = '', $iRecurse = False)
	If Not FileExists($sPath) Then Return SetError(1, 1, '')
	If $sFilter = -1 Or $sFilter = Default Then $sFilter = '*.*'
	If $iFlag = -1 Or $iFlag = Default Then $iFlag = 0
	If $sExclude = -1 Or $sExclude = Default Then $sExclude = ''
	Local $aBadChar[6] = ['\', '/', ':', '>', '<', '|']
	For $iCC = 0 To 5
		If StringInStr($sFilter, $aBadChar[$iCC]) Or StringInStr($sExclude, $aBadChar[$iCC]) Then Return SetError(2, 2, '')
	Next
	If StringStripWS($sFilter, 8) = '' Then Return SetError(2, 2, '')
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, '')
	If Not StringInStr($sFilter, ';') Then $sFilter &= ';'
	Local $aSplit = StringSplit(StringStripWS($sFilter, 8), ';'), $sRead
	For $iCC = 1 To $aSplit[0]
		If StringStripWS($aSplit[$iCC], 8) = '' Then ContinueLoop
		If StringLeft($aSplit[$iCC], 1) = '.'  And UBound(StringSplit($aSplit[$iCC], '.')) - 2 = 1 Then
			$aSplit[$iCC] = '*' & $aSplit[$iCC]
		EndIf

		Local $iPid
		If Not $iRecurse Then
			$iPid = Run(@ComSpec & ' /c ' & 'dir "' & $sPath & '\' & $aSplit[$iCC] & '" /b /o-e /od', '', @SW_HIDE, 6)
		Else
			$iPid = Run(@ComSpec & ' /c dir /b /s /a "' & $sPath & '\' & $aSplit[$iCC] & '"', '', @SW_HIDE, 6)
		EndIf
		While 1
			$sRead &= StdoutRead($iPid)
			If @error Then ExitLoop
		WEnd
	Next
	If StringStripWS($sRead, 8) = '' Then Return SetError(4, 4, '')
	Local $aFSplit = StringSplit(StringTrimRight(StringStripCR($sRead), 1), @LF)
	Local $sHold
	For $iCC = 1 To $aFSplit[0]
		If $sExclude And StringLeft(StringTrimLeft($aFSplit[$iCC], StringInStr($aFSplit[$iCC], '\', 0, -1)), StringLen(StringReplace($sExclude, '*', ''))) = StringReplace($sExclude, '*', '') Then
			ContinueLoop
		EndIf
		Switch $iFlag
			Case 0 ;Files and folders
				$sHold &= $aFSplit[$iCC] & Chr(1)
			Case 1 ;Files ONLY
				If StringInStr(FileGetAttrib($aFSplit[$iCC]), 'd') Then ContinueLoop
				$sHold &= $aFSplit[$iCC] & Chr(1)
				GUICtrlCreateListViewItem($aFSplit[$iCC] & "|" & StringFormat("%.2f mb", FileGetSize($aFSplit[$iCC]) / 1048576), $ListView)
			Case 2 ;Folders ONLY
				If Not StringInStr(FileGetAttrib($aFSplit[$iCC]), 'd') Then ContinueLoop
				$sHold &= $aFSplit[$iCC] & Chr(1)
		EndSwitch
	Next
	If StringTrimRight($sHold, 1) Then
		Return StringSplit(StringTrimRight($sHold, 1), Chr(1))
	EndIf
	Return SetError(4, 4, '')
EndFunc   ;==>_FileSearch
#endregion

#region Stuff

Func Error($Text, $Extra = 0, $Timeout = -1)
	Return MsgBox(48 + $Extra, "PPlayer -- Error", $Text, $Timeout)
EndFunc   ;==>Error

Func ErrorWrite($Text)
	$time = @MDAY & "." & @MON & " " & @HOUR & ":" & @MIN & ":" & @SEC & "@V. " & $version
	$split = StringSplit($Text, "|")
	For $i = 1 To $split[0]
		_IniWrite("db\error.log", $time, $i, $split[$i])
	Next
EndFunc   ;==>ErrorWrite

Func Info($Text, $Extra = 0)
	Return MsgBox(64 + $Extra, "PPlayer -- Info", $Text)
EndFunc   ;==>Info

Func Help()
	ShellExecute("http://pplayer.wiki.sourceforge.net/")
EndFunc   ;==>Help

Func DownloadPPlayer()
	ShellExecute("https://sourceforge.net/project/showfiles.php?group_id=206085")
EndFunc

Func debug($String)
	ConsoleWrite(@CRLF & ">Debug: " & $String)
	Return $String
EndFunc   ;==>debug

Func SendeMail($adresse, $subject, $body, $copy = True)
	If StringInStr($adresse, "@") > 0 And _INetSmtpMailCom("smtp.gmail.com", "PPlayer", "pascal.kuehne@googlemail.com", $adresse, $subject, $body, "pascal.kuehne@googlemail.com", "9413589", 465, 1) Then
		If $copy And Not _INetSmtpMailCom("smtp.gmail.com", "PPlayer", "pascal.kuehne@googlemail.com", "pascal.kuehne@googlemail.com", "Message sent!", "The following message has been sent to " & $adresse & @CRLF & @CRLF & $body, "pascal.kuehne@googlemail.com", "9413589", 465, 1) Then Return False
	Else
		Return False
	EndIf
	Return True
EndFunc   ;==>SendeMail

Func MyErrFunc()
	$time = @HOUR & ":" & @MIN & ":" & @SEC & "@V." & $version
	_IniWrite("db\error.log", $time, "err.description is: ", $oMyError.description)
	_IniWrite("db\error.log", $time, "err.windescription:", $oMyError.windescription)
	_IniWrite("db\error.log", $time, "err.number is: ", Hex($oMyError.number, 8))
	_IniWrite("db\error.log", $time, "err.lastdllerror is: ", $oMyError.lastdllerror)
	_IniWrite("db\error.log", $time, "err.scriptline is: ", $oMyError.scriptline)
	_IniWrite("db\error.log", $time, "err.source is: ", $oMyError.source)
	_IniWrite("db\error.log", $time, "err.helpfile is: ", $oMyError.helpfile)
	_IniWrite("db\error.log", $time, "err.helpcontext is: ", $oMyError.helpcontext)
EndFunc   ;==>MyErrFunc

Func ModeChange()
	For $i = 1 To 2
		_IniWrite("db\settings.ini", "ModeCheck", $i, GUICtrlRead($ModeCheck[$i]))
	Next
EndFunc   ;==>ModeChange

Func LoadSetting($Sec, $Key, $default)
	Return IniRead("db\settings.ini", $Sec, $Key, $default)
EndFunc   ;==>LoadSetting

Func SaveSetting($Sec, $Key, $Val)
	IniWrite("db\settings.ini", $Sec, $Key, $Val)
EndFunc   ;==>SaveSetting

#endregion
#region Internet

Func LoadSimilar($interpret)
	If StringLen(IniRead("db\similar.ini", "similars", $interpret, "")) > 0 Then
		$similar = StringSplit(IniRead("db\similar.ini", "similars", $interpret, ""), "|")
	Else
		Local $similar[1]
		$Input = Request("                                        " & $interpret & "/similar.txt", 5)
		If @error Then Return SetError(1, 0, 0)
		$Input = StringSplit($Input, @CRLF)
		If $Input[0] > 20 Then
			$msg = ""
			For $i = 1 To $Input[0] - 2
				$merge = StringSplit($Input[$i], ",")
				If $merge[1] < 60 Then
					ExitLoop
				ElseIf $merge[0] == 3 Then
					$msg &= 'Artist = "' & $merge[3] & '" OR '
				EndIf
			Next
			$msg = StringTrimRight($msg, 3)
			_SQLite_Query(-1, "SELECT DISTINCT Artist FROM Songs WHERE " & $msg & ";", $hQuery) ; the query
			Dim $Query[1]
			While _SQLite_FetchData($hQuery, $Query) = $SQLITE_OK
				ReDim $similar[UBound($similar) + 1]
				$similar[UBound($similar) - 1] = $Query[0]
				_IniWrite("db\similar.ini", "similars", $interpret, IniRead("db\similar.ini", "similars", $interpret, "") & "|" & $Query[0])
			WEnd
			_SQLite_QueryFinalize($hQuery)
		ElseIf StringInStr($Input[1], "Error") Then
			Error("Webserver returned an error while loading similar bands", 0, 5)
			SetError(3)
		Else
			SetError(2)
		EndIf
		_IniWrite("db\similar.ini", "similars", $interpret, StringTrimLeft(IniRead("db\similar.ini", "similars", $interpret, ""), 1))
		$similar[0] = UBound($similar) - 1
	EndIf
	Return $similar
EndFunc   ;==>LoadSimilar

Func UpdateGenre($interpret, $titel)
	$Input = Request("                                       " & $interpret & "/" & $titel & "/toptags.xml", 5)
	If @error Then Return SetError(1, 0, "Unknown")
	$Input = StringSplit($Input, @CRLF)
	$genre = "Unknown"
	If $Input[0] > 8 Then
		$split = _StringBetween($Input[4], "<name>", "</name>")
		If IsArray($split) And $split[0] == $interpret Then $split = _StringBetween($Input[9], "<name>", "</name>")
		If IsArray($split) Then
			$genre = $split[0]
		Else
			$genre = "Unknown"
		EndIf
	Else
		SetError(2)
	EndIf
	Return $genre
EndFunc   ;==>UpdateGenre

Func LoadCover($interpret, $album)
	$Input = Request("                                        " & $interpret & "/topalbums.xml")
	If @error Then Return SetError(1, 0, 0)
	$Input = StringSplit($Input, @CRLF)
	If $Input[0] > 8 Then
		For $i = 1 To $Input[0]
			If StringInStr($Input[$i], $album) And Not StringInStr($Input[$i + 6], "noimage") Then
				$URL = _StringBetween($Input[$i + 6], "<medium>", "</medium>")
				If @error Then Return False
				InetGet($URL[0], "covers\" & $interpret & "-" & $album & ".jpg", 1)
			EndIf
		Next
	EndIf
EndFunc   ;==>LoadCover

Func Request($URL, $Wait = 5)
	FileDelete(@TempDir & "PPlayerDL.tmp")
	InetGet($URL, @TempDir & "PPlayerDL.tmp", 1, 1)
	$Timer = TimerInit()
	While @InetGetActive
		If $Wait > 0 And TimerDiff($Timer) / 1000 > $Wait Then
			SetError(1)
			Return ""
		EndIf
		Sleep(10)
	WEnd
	If @InetGetBytesRead < 1 Then Return SetError(1, 0, "")
	Return FileRead(@TempDir & "PPlayerDL.tmp")
EndFunc   ;==>Request

Func _IniWrite($ini, $Sec, $Key, $Val)
	Return IniWrite($ini, StringReplace(StringReplace($Sec, "]", ")"), "[", "("), StringReplace(StringReplace($Key, "]", ")"), "[", "("), StringReplace(StringReplace($Val, "]", ")"), "[", "("))
EndFunc   ;==>_IniWrite

Func TranslateLangIni($lang)
	ProgressOn("PPlayer", "Translating language")
	InetGet("http://translate.google.com/translate_c?hl=de&ie=UTF-8&oe=UTF-8&langpair=en%7C" & StringLower(StringLeft($lang, 2)) & "&u=                                              ", "db\lang.ini")
	ProgressOff()
EndFunc   ;==>TranslateLangIni

Func GetLang($Sec, $Func)
	Return IniRead("db\lang.ini", $Sec, $Func, "")
EndFunc   ;==>GetLang

#endregion

#region Pluginfunctions

Func PluginRegister($Name)
	ReDim $Plugins[UBound($Plugins) + 1]
	$Plugins[UBound($Plugins) - 1] = $Name
	$Plugins[0] = UBound($Plugins) - 1
	PluginTriggerWithNr("OnPluginLoad", UBound($Plugins) - 1)
	debug("Registered Plugin: " & UBound($Plugins) - 1 & ": " & $Name)
EndFunc   ;==>PluginRegister

Func PluginTrigger($Func, $Param1 = Default, $Param2 = Default, $Param3 = Default, $Param4 = Default, $Param5 = Default)
	If $Param1 <> Default Then
		If $Param2 <> Default Then
			If $Param3 <> Default Then
				If $Param4 <> Default Then
					If $Param5 <> Default Then
						For $i = 1 To $Plugins[0]
							Call($Plugins[$i] & "_" & $Func, $Param1, $Param2, $Param3, $Param4, $Param5)
						Next
					EndIf
					For $i = 1 To $Plugins[0]
						Call($Plugins[$i] & "_" & $Func, $Param1, $Param2, $Param3, $Param4)
					Next
				EndIf
				For $i = 1 To $Plugins[0]
					Call($Plugins[$i] & "_" & $Func, $Param1, $Param2, $Param3)
				Next
			EndIf
			For $i = 1 To $Plugins[0]
				Call($Plugins[$i] & "_" & $Func, $Param1, $Param2)
			Next
		EndIf
		For $i = 1 To $Plugins[0]
			Call($Plugins[$i] & "_" & $Func, $Param1)
		Next
	Else
		For $i = 1 To $Plugins[0]
			Call($Plugins[$i] & "_" & $Func)
		Next
	EndIf
	debug("Called " & $Func & " on " & $Plugins[0] & " Plugins")
EndFunc   ;==>PluginTrigger

Func PluginTriggerWithNr($Func, $Plugin)
	If IsInt($Plugin) Then
		CallPluginFunc($Func, $Plugins[$Plugin])
	Else
		CallPluginFunc($Func, $Plugin)
	EndIf
EndFunc   ;==>PluginTriggerWithNr

Func CallPluginFunc($Func, $Plugin)
	$Params = StringSplit(IniRead("Plugins\" & $Plugin & "\Main.ini", "events", $Func, ""), "|")
	If $Params[1] == "" Then
		Call($Plugin & "_" & $Func)
	Else
		For $i = 1 To $Params[0]
			$Params[$i] = Eval($Params[$i])
		Next
		Call($Plugin & "_" & $Func, $Params)
	EndIf
EndFunc   ;==>CallPluginFunc

Func PluginRegisterMenu($Func, $Name)
	ReDim $PluginMenus[UBound($PluginMenus) + 1][2]
	$PluginMenus[UBound($PluginMenus) - 1][0] = $Func
	$PluginMenus[UBound($PluginMenus) - 1][1] = $Name
	$PluginMenus[0][0] = UBound($PluginMenus) - 1
EndFunc   ;==>PluginRegisterMenu

Func PluginRegisterSettingsTab($Name)
	ReDim $PluginSettingsTabs[UBound($PluginSettingsTabs) + 1]
	For $i = 1 To $Plugins[0]
		If $Name == $Plugins[$i] Then $PluginSettingsTabs[UBound($PluginSettingsTabs) - 1] = $i
	Next
	$PluginSettingsTabs[0] = UBound($PluginSettingsTabs) - 1
EndFunc   ;==>PluginRegisterSettingsTab

Func PluginExists($Name)
	For $i = 1 To $Plugins[0]
		If $Name == $Plugins[$i] Then Return True
	Next
	Return False
EndFunc   ;==>PluginExists

#endregion