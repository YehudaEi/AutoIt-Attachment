#Region ;**** Copyright notice section ****
#cs
	Copyright notice

	Copyright © 2010 All rights reserved Robert Marotte

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

	Contact: bobmarotte@gmail.com

	Notice that the above copyright does not apply to any of the following
	functions and/or other UDFs, it only applies to original code written by
	myself.

	Bass.au3			by BrettF 		http://www.autoitscript.com/forum/index.php?showtopic=83481
	ID3.au3				by joeyb1275	http://www.autoitscript.com/forum/index.php?showtopic=43950
	RecFileListToArray	by Melba23		http://www.autoitscript.com/forum/index.php?showtopic=120154&view=findpost&p=835800
	ExtMsgBox			by Melba23		http://www.autoitscript.com/forum/index.php?showtopic=109096

#ce
#EndRegion ;**** Copyright notice section ****
#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=E:AutoIt3\Icons\au3.ico
#AutoIt3Wrapper_Outfile=Compiled\BMP.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=BMP - Bob's Media Player
#AutoIt3Wrapper_Res_Description=Bob's Media Player
#AutoIt3Wrapper_Res_Fileversion=1.7.1
#AutoIt3Wrapper_Res_ProductVersion=1.7.1
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2010 Robert Marotte
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Company|Bob's Computer Services of NH
#AutoIt3Wrapper_Res_Field=Product Name|BMP - Bob's Media Player
#AutoIt3Wrapper_Au3Check_Parameters=-d -v 1
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/gd /rel 1
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/om /striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~#include <Array.Au3>
#include <Bass.Au3>
#include <BassTags.Au3>
#include <ButtonConstants.Au3>
#include <ComboConstants.Au3>
#include <EditConstants.Au3>
#include "ExtMsgBox.au3"
#include <File.Au3>
#include <GUIConstants.Au3>
#include <GUIConstantsEx.Au3>
#include <GUIListView.Au3>
#include <GUIMenu.Au3>
#include <GUIStatusBar.Au3>
#include <ID3.au3>
#include <ListBoxConstants.au3>
#include <ListViewConstants.au3>
#include <ProgressConstants.Au3>
#include "RecFileListToArray.Au3"
#include <SliderConstants.Au3>
#include <StaticConstants.Au3>
#include <StructureConstants.au3>
#include <WindowsConstants.Au3>
$FilesDir = @ScriptDir & "\Files"
DirCreate($FilesDir)
FileInstall("BassTags.dll", $FilesDir & "\BassTags.dll")
FileInstall("Bass.dll", $FilesDir & "\Bass.dll")
FileInstall("Basswma.dll", $FilesDir & "\Basswma.dll")
FileInstall("Bassflac.dll", $FilesDir & "\Bassflac.dll")
FileInstall("CD.gif", $FilesDir & "\CD.gif")
FileInstall("Option.jpg", $FilesDir & "\Option.jpg")
FileInstall("Option_black.jpg", $FilesDir & "\Option_black.jpg")
FileInstall("Option_yellow.jpg", $FilesDir & "\Option_yellow.jpg")
FileInstall("Option_blue.jpg", $FilesDir & "\Option_blue.jpg")
FileInstall("Option_red.jpg", $FilesDir & "\Option_red.jpg")
FileInstall("Option_purple.jpg", $FilesDir & "\Option_purple.jpg")
FileInstall("Option_green.jpg", $FilesDir & "\Option_green.jpg")
FileInstall("folder_music.jpg", $FilesDir & "\folder_music.jpg")
FileInstall("folder_music_blue.jpg", $FilesDir & "\folder_music_blue.jpg")
FileInstall("folder_music_red.jpg", $FilesDir & "\folder_music_red.jpg")
FileInstall("folder_music_yellow.jpg", $FilesDir & "\folder_music_yellow.jpg")
FileInstall("folder_music_white.jpg", $FilesDir & "\folder_music_white.jpg")
FileInstall("folder_music_green.jpg", $FilesDir & "\folder_music_green.jpg")
FileInstall("folder_music_purple.jpg", $FilesDir & "\folder_music_purple.jpg")
FileInstall("gpl.txt", $FilesDir & "\gpl.txt")
_Bass_Startup($FilesDir & "\Bass.dll")
_Bass_Tags_Startup($FilesDir & "\BassTags.dll")
_Bass_PluginLoad($FilesDir & "\basswma.dll")
_Bass_PluginLoad($FilesDir & "\bassflac.dll")
_BASS_Init(0, -1, 44100, 0, "")
Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 0)
HotKeySet("^+a", "Play")
HotKeySet("^!{Right}", "HotKeySkipFwd")
HotKeySet("^!{Left}", "HotKeySkipBack")
HotKeySet("^{DOWN}", "VolumeDown")
HotKeySet("^{UP}", "VolumeUp")
HotKeySet("^{NumpadAdd}", "Next1")
HotKeySet("^{NumpadSub}", "Previous")
HotKeySet("{F8}", "ShowLV")
;~ #############################################################################
;~
Global $aColOrder[7] = [1, 1, 1, 1, 1, 1, 1]
Global $aLV_Content[1][7]
Global $aLV_Items[1]
$SF3 = False
;~
;~ #############################################################################
Global $aSelection[7]
Global $Built = False
Global $CSOut = 0
Global $Color
Global $Count
Global $Counter
Global $Current = 1
Global $DesktopSize = WinGetPos("Program Manager")
Global $EditBox
Global $FileTypes
Global $FileTypesRead
Global $File[3]
Global $Form1
Global $IniFile = @ScriptDir & "\BMP.ini"
Global $InitLoad = True
Global $LVPrimary
Global $LVSecondary
Global $LVpTextColor
Global $LVsTextColor
Global $MsgText
Global $Musiclisting
Global $NotPaused = True
Global $NowPlaying = "Idle"
Global $OpenAs
Global $Options1 = 0
Global $PauseNext1 = TimerInit()
Global $PausePrevious = TimerInit()
Global $Playing = False
Global $PosState
Global $PosState1
Global $Pri
Global $RandomSong = False
Global $ReadScheme
Global $Rebuild = False
Global $SaveColors
Global $SaveState
Global $SaveState1
Global $SaveVolume
Global $SaveVolume1
Global $Saved = False
Global $Scheme
Global $Scheme1
Global $SchemeIn
Global $SchemeSet
Global $Sec
Global $Seconds1
Global $Selection = "a"
Global $Set
Global $SetOpt = False
Global $SetTime
Global $Skip
Global $Start
Global $String
Global $TD = True
Global $Temp
Global $Timer1
Global $VolumeTest
Global $VolumeTest1
Global $XPos
Global $YPos
Global $aMusicList[10000]
Global $bShowLV
Global $szDir
Global $szDrive
Global $szExt
Global $szFName, $Pos
Global $URL[4]
Global Const $Yellow = "0x0EAE70E"
Global Const $Black = "0x0000000"
Global Const $Blue = "0x0192CD3"
Global Const $Red = "0x0E70215"
Global Const $Green = "0x01F9F0B"
Global Const $Purple = "0x07C20BD"
Global Const $White = "0x0FFFFFF"
Global $f_HotKeyEnabled = False
GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")
GUIRegisterMsg($WM_NCHITTEST, "_MY_NCHITTEST")
#Region ; ### START Koda GUI section ### Form=
$XPos = IniRead($IniFile, "Main GUI", "XPos", 300)
$YPos = IniRead($IniFile, "Main GUI", "YPos", 20)
If $XPos > @DesktopHeight Then $XPos = 300
If $YPos > @DesktopWidth Then $YPos = 20
$Form1 = GUICreate("Bob's Media Player", 600, 220, $XPos, $YPos)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
Global Const $Timer = GUICtrlCreateLabel(" 00:00 ", 200, 34, 200, 55, BitOR($GUI_SS_DEFAULT_LABEL, $SS_CENTER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
GUICtrlSetFont(-1, 35, 800, 0, "Lucida Console")
GUICtrlSetColor(-1, 0x0FCFF23)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetOnEvent(-1, "TimerSet")
GUICtrlSetResizing(-1, 768)
Global Const $Label1 = GUICtrlCreateLabel("", 10, 130, 580, 20, BitOR($GUI_SS_DEFAULT_LABEL, $SS_CENTER)) ;~ Used for the scrolling marquee
GUICtrlSetFont(-1, 12, 800, 0, "Lucida Console")
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetResizing(-1, 768)
GUICtrlCreateLabel("", 10, 125, 580, 5)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateLabel("", 10, 152, 580, 20)
GUICtrlSetOnEvent(-1, "ProgressClick")
GUICtrlSetResizing(-1, 768)
Global Const $Progress = GUICtrlCreateProgress(10, 152, 580, 15, BitOR($PBS_SMOOTH, $GUI_SS_DEFAULT_PROGRESS), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
GUICtrlSetBkColor(-1, 0x0DB0D22)
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetResizing(-1, 768)
Global Const $Volume = GUICtrlCreateSlider(10, 170, 270, 27)
GUICtrlSetTip(-1, "Volume")
GUICtrlSetOnEvent(-1, "Volume")
GUICtrlSetLimit(-1, 100, 0)
GUICtrlSetData(-1, IniRead($IniFile, "Controls", "Volume", 80))
GUICtrlSetBkColor(-1, 0x0008000)
GUICtrlSetResizing(-1, 8)
Global Const $Input = GUICtrlCreateInput(IniRead($IniFile, "Controls", "Volume", 80) / 10, 286, 173, 30, 21, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
GUICtrlSetResizing(-1, 8)
GUICtrlCreateGroup("", 325, 165, 263, 35)
GUICtrlCreateButton("7", 383, 177, 34, 17, $BS_VCENTER) ;~ Skipback Button
GUICtrlSetFont(-1, 9, 800, Default, "WebDings")
GUICtrlSetTip(-1, "Rewind 10 seconds")
GUICtrlSetOnEvent(-1, "SkipBack")
GUICtrlCreateButton("9", 343, 177, 34, 17, $BS_VCENTER) ;~ Previous Button
GUICtrlSetFont(-1, 9, 800, Default, "WebDings")
GUICtrlSetTip(-1, "Previous")
GUICtrlSetOnEvent(-1, "Previous")
Global Const $Play = GUICtrlCreateButton("4", 423, 177, 34, 17, $BS_VCENTER) ;~ Play Button
GUICtrlSetFont(-1, 9, 800, Default, "WebDings")
GUICtrlSetTip(-1, "Play/Pause")
GUICtrlSetOnEvent(-1, "Play")
GUICtrlCreateButton("<", 463, 177, 34, 17, $BS_VCENTER) ;~ Stop Button
GUICtrlSetFont(-1, 9, 800, Default, "WebDings")
GUICtrlSetOnEvent(-1, "Stop")
GUICtrlSetTip(-1, "Stop")
GUICtrlCreateButton("8", 503, 177, 34, 17, $BS_VCENTER) ;~ Skip Forward Button
GUICtrlSetFont(-1, 9, 800, Default, "webdings")
GUICtrlSetTip(-1, "Forward 10 seconds")
GUICtrlSetOnEvent(-1, "SkipFwd")
GUICtrlCreateButton(":", 543, 177, 34, 17, $BS_VCENTER) ;~ Next Button
GUICtrlSetTip(-1, "Next")
GUICtrlSetFont(-1, 9, 800, Default, "webdings")
GUICtrlSetOnEvent(-1, "Next1")
Const $FileMenu = GUICtrlCreateMenu("&File")
GUICtrlCreateMenuItem("&Add to song library", $FileMenu, 1)
GUICtrlSetOnEvent(-1, "BuildList")
GUICtrlSetTip(-1, "Add songs to the library, doesn't delete the current list if any")
GUICtrlCreateMenuItem("&Save song list to disk", $FileMenu, 2)
GUICtrlSetOnEvent(-1, "Save")
GUICtrlCreateMenuItem("Save song list &as", $FileMenu, 3)
GUICtrlSetOnEvent(-1, "SaveAs")
GUICtrlCreateMenuItem("&Open a saved song list", $FileMenu, 4)
GUICtrlSetOnEvent(-1, "OpenAs")
GUICtrlCreateMenuItem("B&uild new song library", $FileMenu, 5)
GUICtrlSetOnEvent(-1, "RebuildList")
GUICtrlSetTip(-1, "Deletes the song library and builds a new one.")
GUICtrlCreateMenuItem("", $FileMenu, 6)
GUICtrlCreateMenuItem("&Close", $FileMenu, 7) ;~ File Menu Exit Option
GUICtrlSetOnEvent(-1, "Form1Close")
Const $Pic = GUICtrlCreatePic($FilesDir & "\CD.gif", 10, 3, 120, 120)
Const $PlayList = GUICtrlCreatePic($FilesDir & "\Folder_music.jpg", 490, 8, 50, 50)
GUICtrlSetTip(-1, "Show/Hide Playlist window")
GUICtrlSetOnEvent($PlayList, "ShowLV")
Const $Options = GUICtrlCreatePic($FilesDir & "\Option.jpg", 490, 70, 50, 50)
GUICtrlSetOnEvent($Options, "Options")
GUICtrlSetTip(-1, "Options")
Const $PlayMenu = GUICtrlCreateMenu("&Play")
Const $Shuffle = GUICtrlCreateMenuItem("&Shuffle Play", $PlayMenu, 1)
GUICtrlSetOnEvent(-1, "Shuffle")
Const $HelpMenu = GUICtrlCreateMenu("&Help") ;~ Start of the Help Menu
GUICtrlCreateMenuItem("H&elp", $HelpMenu, 1)
GUICtrlSetOnEvent(-1, "_HelpMe")
GUICtrlCreateMenuItem("&Copyright Notice", $HelpMenu, 2)
GUICtrlSetOnEvent(-1, "_Copyright")
GUICtrlCreateMenuItem("C&redits", $HelpMenu, 3)
GUICtrlSetOnEvent(-1, "_Credits")
GUICtrlCreateMenuItem("FAQ", $HelpMenu, 4)
GUICtrlSetOnEvent(-1, "_FAQ")
GUICtrlCreateMenuItem("Reset my playlist", $HelpMenu, 5)
GUICtrlSetOnEvent(-1, "ResetLV")
#EndRegion ; ### START Koda GUI section ### Form=
#Region ; #### GUI for ListView ###
Global $ChildWidth = IniRead($IniFile, "Child GUI", "Width", 675)
Global $ChildHeight = IniRead($IniFile, "Child GUI", "Height", 500)
Global $XChild = IniRead($IniFile, "Child GUI", "XPos", -1)
Global $YChild = IniRead($IniFile, "Child GUI", "YPos", -1)
If $YChild > $DesktopSize[3] Then $YChild = 100
If $XChild > $DesktopSize[2] Then $XChild = 20
Global $ListViewChild = GUICreate("Playlist", $ChildWidth, $ChildHeight, $XChild, $YChild, BitOR($WS_MAXIMIZEBOX, $WS_SYSMENU, $WS_SIZEBOX, $WS_MINIMIZEBOX), Default, $Form1)
GUISetOnEvent($GUI_EVENT_CLOSE, "ShowLV")
Global $ListView = GUICtrlCreateListView("|Track|Title|Artist|Album|Year|Original Filename and Path", 10, 20, $ChildWidth - 20, $ChildHeight - 60, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES))
Global $hListview = GUICtrlGetHandle($ListView)
GUICtrlSetColor($ListView, "0x002DBDB")
GUICtrlSetBkColor($ListView, $LVPrimary)
GUICtrlSetBkColor($ListView, $GUI_BKCOLOR_LV_ALTERNATE)
GUICtrlSetResizing($ListView, 102)
Global $ColumnCount = _GUICtrlListView_GetColumnCount($hListview)
Global $ContextMenu = GUICtrlCreateContextMenu($ListView)
GUICtrlCreateMenuItem("Edit", $ContextMenu) ;~ Context Menu Edit Option
GUICtrlSetOnEvent(-1, "Edit")
GUICtrlCreateMenuItem("Delete", $ContextMenu) ;~ Context Menu Delete Option
GUICtrlSetOnEvent(-1, "Delete")
GUICtrlCreateMenuItem("Search", $ContextMenu)
GUICtrlSetOnEvent(-1, "SearchWindow")
#EndRegion ; #### GUI for ListView ###
;~		========================================================================
;~		End of the GUI create stuff, time to start the real meat of the project
;~		========================================================================
_GUICtrlListView_RegisterSortCallBack($hListview)
Open()
$ReadScheme = IniRead($IniFile, "Settings", "Scheme", "Black")
$LVPrimary = IniRead($IniFile, "Child GUI", "LVPrimary", "Yellow")
$LVSecondary = IniRead($IniFile, "Child GUI", "LVSecondary", "Green")
_Scheme($ReadScheme, $LVPrimary, $LVSecondary)
GUISetBkColor($SchemeSet, $Form1)
GUISetBkColor($SchemeSet, $ListViewChild)
GUISetState(@SW_SHOW, $Form1)
GUICtrlSendMsg($ListView, $LVM_SETCOLUMNWIDTH, $ColumnCount - 1, 0)
$bShowLV = IniRead($IniFile, "Child GUI", "State", "1")
ShowLV()
If IniRead($IniFile, "Controls", "Shuffle", 68) = 65 Then
	$RandomSong = True
	GUICtrlSetState($Shuffle, $GUI_CHECKED)
EndIf
AdlibRegister("Timer", 500) ; Calls the Timer function every 1/2 second
AdlibRegister("Progress") ; Calls the Progress bar update every 1/4 second
$Timer1 = TimerInit()
Global $bEdit = 0
Options()
While 1
	$VolumeTest = GUICtrlRead($Volume)
	If $VolumeTest <> $VolumeTest1 Then Volume()
	$VolumeTest1 = $VolumeTest
	If WinActive($ListViewChild) Then ; And (ControlGetHandle($ListViewChild, "", ControlGetFocus($ListViewChild, "")) = $ListView) Then
		If Not $f_HotKeyEnabled Then
			$f_HotKeyEnabled = True
			HotKeySet("{F3}", "SearchWindow")
			HotKeySet("+{F3}", "SearchWindow")
		EndIf
	Else
		If $f_HotKeyEnabled Then
			$f_HotKeyEnabled = False
			HotKeySet("{F3}")
			HotKeySet("+{F3}")
		EndIf
	EndIf
	If $Playing Then
		If _BASS_ChannelIsActive($File) = $BASS_ACTIVE_STOPPED Then
			Next1()
		EndIf
		Marquee($NowPlaying)
	Else
		Sleep(100)
	EndIf
	If $bEdit = 1 Then Edit()
WEnd
#Region			******* Help menu screens *******
Func _BassURL()
	ShellExecute($URL[0])
EndFunc   ;==>_BassURL
Func _Copyright()
	Local $Text = @TAB & @TAB & @TAB & @TAB & @TAB & "Copyright notice" & @LF & @TAB & @TAB & @TAB & "Copyright © 2010 All rights reserved Robert Marotte" & @LF & @LF & _
			"This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by " & _
			"the Free Software Foundation, either version 3 of the License, or (at your option) any later version." & @LF & @LF & _
			"This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of " & _
			"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details." & @LF & @LF & _
			"You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>." & _
			@LF & @LF & @TAB & @TAB & @TAB & @TAB & "Contact: bobmarotte@gmail.com" & @LF & @LF & "Notice that the above copyright does not apply to " & _
			"any of the functions and/or other UDFs that have been used, it only applies to original code written by myself." & @LF & @LF _
			 & @LF & @TAB & @TAB & @TAB & @TAB & "Click anywhere to close this window"
	WinSetState($Form1, "", @SW_DISABLE)
	$Temp = GUICreate("Copyright Notice", 800, 330, -1, -1, BitOR($WS_DLGFRAME, $WS_POPUP))
	GUISetOnEvent($GUI_EVENT_CLOSE, "_TempClose")
	GUISetBkColor(0x02616FF, $Temp)
	GUICtrlCreateLabel($Text, 40, 10, 750, 380)
	GUICtrlSetFont(-1, 10, 400, -1, "Consolas")
	GUICtrlSetColor(-1, 0x02AFF6A)
	GUICtrlSetOnEvent(-1, "_TempClose")
	GUISetState()
EndFunc   ;==>_Copyright
Func _Credits()
	Local $Func[4]
	$URL[0] = "http://www.autoitscript.com/forum/index.php?showtopic=83481"
	$URL[1] = "http://www.autoitscript.com/forum/index.php?showtopic=43950"
	$URL[2] = "http://www.autoitscript.com/forum/index.php?showtopic=120154&view=findpost&p=835800"
	$URL[3] = "http://www.autoitscript.com/forum/index.php?showtopic=109096"
	Local $Text = "This program could not have been successfully completed without the amazing people" & _
			" on the AutoItScript forums, even those that didn't know that they helped me. The program is mostly original " & _
			"code with a sprinkling of code that was found in various threads on the forums." & @LF & @LF & _
			"I have also used the following UDFs in the creation of this script and I would like to give credit where credit is due: "
	$Func[0] = "Bass.au3" & @TAB & @TAB & "by BrettF"
	$Func[1] = "ID3.au3" & @TAB & @TAB & "by joeyb1275"
	$Func[2] = "RecFileListToArray" & @TAB & "by Melba23"
	$Func[3] = "ExtMsgBox" & @TAB & @TAB & "by Melba23"
	WinSetState($Form1, "", @SW_DISABLE)
	$Temp = GUICreate("Credits", 800, 270, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_TempClose")
	GUISetBkColor(0x0FFFFFF, $Temp)
	GUICtrlCreateLabel($Text, 40, 10, 750, 100)
	GUICtrlSetFont(-1, 10, 800, -1, "Consolas")
	GUICtrlSetColor(-1, 0x0000000)
	GUICtrlCreateButton(" Close ", 360, 230, -1)
	GUICtrlSetOnEvent(-1, "_TempClose")
	For $I = 0 To 3
		GUICtrlCreateLabel($Func[$I], 40, 130 + ($I * 20), 200, 20)
		GUICtrlSetColor(-1, 0x000000)
		GUICtrlSetFont(-1, 9, 400, 0)
	Next
	GUICtrlCreateLabel($URL[0], 260, 130, 400, 20)
	GUICtrlSetOnEvent(-1, "_BassURL")
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetColor(-1, 0x00000FF)
	GUICtrlSetFont(-1, 9, 400, 4)
	GUICtrlCreateLabel($URL[1], 260, 150, 400, 20)
	GUICtrlSetOnEvent(-1, "_ID3URL")
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetColor(-1, 0x00000FF)
	GUICtrlSetFont(-1, 9, 400, 4)
	GUICtrlCreateLabel($URL[2], 260, 170, 348, 20)
	GUICtrlSetOnEvent(-1, "_RFLTAURL")
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetColor(-1, 0x00000FF)
	GUICtrlSetFont(-1, 9, 400, 4)
	GUICtrlCreateLabel($URL[3], 260, 190, 400, 20)
	GUICtrlSetOnEvent(-1, "_EMBURL")
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetColor(-1, 0x00000FF)
	GUICtrlSetFont(-1, 9, 400, 4)
	GUISetState()
EndFunc   ;==>_Credits
Func _EMBURL()
	ShellExecute($URL[3])
EndFunc   ;==>_EMBURL
Func _FAQ()
	Local $Text = "Why does it take so long to build the song listings?" & @LF & @TAB & "When you're reading in song files for the first time the program reads the ID3 tags of the files, if any, " & _
			"if it can't find any tags it will then try to get the extended file information from Windows, this can take a while" & @LF & @LF & "When I delete or edit songs in the song list it takes a while to rebuild the list, what is it doing?" & _
			@LF & @TAB & "Because this media player has some unique features that others don't, when you delete or edit songs I have to read the entire playlist, and then rebuild the list all over again. If I didn't do this, the Next and Previous " & _
			"functions wouldn't work correctly." & @LF & @LF & "Why is it taking so long to sort the playlist?" & @LF & @TAB & "The sort process takes a few seconds when you have a large amount of songs in your playlist, it's just the nature of the beast. " & _
			"I also have to rebuild the Playlist after it has finished sorting." & @LF & @LF & "Why does it seem like you are rebuilding the listview so often?" & @LF & @TAB & "In a listview, the items are accessed by their controlIDs, when you sort/edit/delete items in" & _
			" a listview those ids get rearranged making the Next and Previous functions think that they're going to the song adjacent to the one currently playing, but because of the rearragement, it can jump anywhere in the list. Rebuilding the list the way that I " & _
			"do, an exclusive feature of my player, allows those functions to work as you would expect them to." & @LF & @LF _
			 & @TAB & @TAB & @TAB & "Click anywhere to close this window"
	WinSetState($Form1, "", @SW_DISABLE)
	$Temp = GUICreate("Frequently asked questions", 750, 400, -1, -1, BitOR($WS_DLGFRAME, $WS_POPUP))
	GUISetOnEvent($GUI_EVENT_CLOSE, "_TempClose")
	GUISetBkColor(0x02616FF, $Temp)
	GUICtrlCreateLabel($Text, 40, 10, 670, 530)
	GUICtrlSetFont(-1, 10, 400, -1, "Consolas")
	GUICtrlSetColor(-1, 0x02AFF6A)
	GUICtrlSetOnEvent(-1, "_TempClose")
	GUISetState()
EndFunc   ;==>_FAQ
Func _HelpMe()
	Local $Text = "The Hotkeys set up for the player are:" & @LF & @LF & "CTRL + Shift + A " & @TAB & "-  plAy/pAuse the selected song" & @LF & _
			"CTRL + Right Arrow" & @TAB & "-  Fast Forward" & @LF & "CTRL + Left Arrow" & @TAB & "-  Fast Rewind" & @LF & "CTRL + Up Arrow" & @TAB & @TAB & "-  Volume Up" & @LF & _
			"CTRL + Down Arrow" & @TAB & "-  Volume Down" & @LF & "CTRL + NumPad+" & @TAB & @TAB & "-  Next Song" & @LF & "CTRL + NumPad-" & @TAB & @TAB & "-  Previous Song" & @LF & _
			"F8" & @TAB & @TAB & @TAB & "-  Show the Playlist" & @LF & @LF & "*	Clicking on the folder icon on the main GUI screen will open the Play list. Clicking on the 	Gear icon on the main GUI " & _
			"will open the Options menu." & @LF & "*	You can double click on any song in the Playlist and it will start playing that song, double click it again and it will pause the song." & _
			@LF & "*	If you don't have a song selected when you press Play it will jump to the first song in the list. If the currently playing song is selected and you press Play, it will pause the song playback. " & @LF & _
			"*	If you have selected another song in the list while a song is playing, playback of the current song will stop and it will start playing the selected one. " & _
			@LF & "*	You can click anywhere on the progress bar to jump to that part of the currently playing song." & @LF & "*	Clicking on the timer display will toggle it between displaying the time remaining and time played." & @LF & _
			"*	The playlist is fully resizable, and if you so choose, in the options menu you can save the size and position of the windows when the program is closed." & @LF & "*	The Playlist is sortable by any heading " & _
			", clicking on the heading again will sort it in the opposite direction (ascending/descending order). Please note, if you have a lot of songs listed it will take a few seconds to sort the list." & @LF _
			 & "*	The Next and Previous buttons will take you to the next and previous songs in the Playlist unless Shuffle Play is selected, then it will randomly jump to a song in the list." & @LF & _
			@LF & "Currently supported file types are MP3/OGG/WAV/WMA/AIFF/FLAC, the program is capable of playing MP1 and MP2 files as well, it's just not set up to scan for those types." & @LF & @LF _
			 & @LF & @TAB & @TAB & @TAB & @TAB & "Click anywhere to close this window"
	WinSetState($Form1, "", @SW_DISABLE)
	$Temp = GUICreate("Help", 800, 550, -1, -1, BitOR($WS_DLGFRAME, $WS_POPUP))
	GUISetBkColor(0x02616FF, $Temp)
	GUICtrlCreateLabel($Text, 40, 10, 750, 530)
	GUICtrlSetFont(-1, 10, 400, -1, "Consolas")
	GUICtrlSetColor(-1, 0x02AFF6A)
	GUICtrlSetOnEvent(-1, "_TempClose")
	GUISetState()
EndFunc   ;==>_HelpMe
Func _ID3URL()
	ShellExecute($URL[1])
EndFunc   ;==>_ID3URL
Func _RFLTAURL()
	ShellExecute($URL[2])
EndFunc   ;==>_RFLTAURL
Func _TempClose()
	GUIDelete($Temp)
	WinSetState($Form1, "", @SW_ENABLE)
	WinActivate("Bob's Media Player")
EndFunc   ;==>_TempClose
#EndRegion			******* Help menu screens *******
#Region			******* Misc. functions that just don't fit other categories *******
Func Form1Close()
	If $Playing Then _BASS_ChannelStop($File)
	If Not $Saved And $Built Then ;~	Check to see if the music list has been changed and/or saved yet
		SoundPlay(@WindowsDir & "\Media\Windows Exclamation.wav", 1)
		_ExtMsgBoxSet(1, 0, 0x02616FF, 0x02AFF6A, 10, "Consolas")
		Local $Check = _ExtMsgBox($MB_ICONQUERY, 3, "Save?", "Your music list hasn't been saved yet, do you want to save first?")
		Switch $Check
			Case 3
				Return
			Case 1
				Save()
				If @error > 0 Then
					SoundPlay(@WindowsDir & "\Media\Windows Error.wav", 1)
					Local $Return = _ExtMsgBox(64, "Yes|No", "Error", "There was a problem saving the song file, would you like to retry?", 0, "", "", 1)
					If $Return = 1 Then
						SaveAs()
					EndIf
				EndIf
			Case 2
				Exit
		EndSwitch
	EndIf
	IniWrite($IniFile, "Settings", "FileListName", $Musiclisting)
	Local $WindowPos = WinGetPos("Bob's Media Player"), $ChildPos = WinGetPos("Playlist")
	Local $SaveIt = IniRead($IniFile, "Settings", "SavePos", "Ask") ;~		Check to see if you want to save the windows positions
	Select
		Case $SaveIt = "Always" ;~		Autosave the windows positions without asking first
			IniWrite($IniFile, "Main GUI", "XPos", $WindowPos[0])
			IniWrite($IniFile, "Main GUI", "YPos", $WindowPos[1])
			IniWrite($IniFile, "Child GUI", "XPos", $ChildPos[0])
			IniWrite($IniFile, "Child GUI", "YPos", $ChildPos[1])
			IniWrite($IniFile, "Child GUI", "Width", $ChildPos[2])
			IniWrite($IniFile, "Child GUI", "Height", $ChildPos[3])
		Case $SaveIt = "Ask" ;~			Ask if you want to save the windows positions before exiting
			SoundPlay(@WindowsDir & "\Media\Windows Exclamation.wav", 1)
			_ExtMsgBoxSet(1, 0, 0x02616FF, 0x02AFF6A, 10, "Consolas")
			$Return = _ExtMsgBox(32, "Yes|No", "Save?", "Save the positions of the windows?")
			If $Return <> 2 Then
				IniWrite($IniFile, "Main GUI", "XPos", $WindowPos[0])
				IniWrite($IniFile, "Main GUI", "YPos", $WindowPos[1])
				IniWrite($IniFile, "Child GUI", "XPos", $ChildPos[0])
				IniWrite($IniFile, "Child GUI", "YPos", $ChildPos[1])
				IniWrite($IniFile, "Child GUI", "Width", $ChildPos[2])
				IniWrite($IniFile, "Child GUI", "Height", $ChildPos[3])
			Else ;~						Don't save the windows positions and delete the settings if they're in the ini file
				IniDelete($IniFile, "Main GUI", "XPos")
				IniDelete($IniFile, "Main GUI", "YPos")
				IniDelete($IniFile, "Child GUI", "XPos")
				IniDelete($IniFile, "Child GUI", "YPos")
				IniDelete($IniFile, "Child GUI", "Width")
				IniDelete($IniFile, "Child GUI", "Height")
			EndIf
		Case $SaveIt = "Never" ;~		Don't save the windows positions and delete the settings if they're in the ini file
			IniDelete($IniFile, "Main GUI", "XPos")
			IniDelete($IniFile, "Main GUI", "YPos")
			IniDelete($IniFile, "Child GUI", "XPos")
			IniDelete($IniFile, "Child GUI", "YPos")
			IniDelete($IniFile, "Child GUI", "Width")
			IniDelete($IniFile, "Child GUI", "Height")
	EndSelect
	$SaveIt = IniRead($IniFile, "Settings", "SaveState", "Yes")
	If $SaveIt = "Yes" Then
		If $bShowLV = "0" Then
			IniWrite($IniFile, "Child GUI", "State", "1")
		Else
			IniWrite($IniFile, "Child GUI", "State", "0")
		EndIf
	Else
		IniWrite($IniFile, "Child GUI", "State", 1)
	EndIf
	$SaveIt = IniRead($IniFile, "Settings", "SaveVolume", "Yes")
	If $SaveIt = "Yes" Then
		IniWrite($IniFile, "Controls", "Volume", GUICtrlRead($Volume))
		IniWrite($IniFile, "Controls", "Shuffle", GUICtrlRead($Shuffle))
	Else
		IniWrite($IniFile, "Controls", "Volume", 70)
		IniWrite($IniFile, "Controls", "Shuffle", 68)
	EndIf
	Exit
EndFunc   ;==>Form1Close
Func Marquee(ByRef $String1)
	Local $DelayTime = 150, $Marquee, $Marquee1
	Static Local $Counting
	$Marquee = ""
	Local $LenMarquee = 52 ;~ Change this number if you change font size or length of the label
	Local $STRFormat = "%" & $LenMarquee + StringLen($String1) & "s"
	$Marquee1 = StringFormat($STRFormat, $String1)
	$STRFormat = "%-" & $LenMarquee + StringLen($Marquee1) & "s"
	$Marquee = StringFormat($STRFormat, $Marquee1)
	Local $CharCount = StringLen($Marquee)
	Local $Delay = TimerDiff($Timer1)
	If $Delay >= $DelayTime Then
		$Counting += 1
		If $Counting = $CharCount - $LenMarquee Then
			$Counting = 1
		EndIf
		$Timer1 = TimerInit()
		GUICtrlSetData($Label1, StringMid($Marquee, $Counting, $LenMarquee))
		If IniRead($IniFile, "Settings", "Scheme", "Black") <> "Black" Then
			GUICtrlSetColor($Label1, $SchemeSet)
		Else
			GUICtrlSetColor($Label1, $White)
		EndIf
	EndIf
	Sleep(20)
EndFunc   ;==>Marquee
Func Progress()
	Local $Prog
	If $Playing Then
		Local $Prog1 = _BASS_ChannelGetPosition($File, $BASS_POS_BYTE)
		$Prog1 = _BASS_ChannelBytes2Seconds($File, $Prog1)
		$Prog = ($Prog1 / $SetTime) * 100
		GUICtrlSetData($Progress, $Prog)
		GUICtrlSetTip($Progress, $Prog1)
	EndIf
EndFunc   ;==>Progress
Func ProgressClick()
	Local $Mouse, $MPer
	$Mouse = GUIGetCursorInfo($Form1)
	$MPer = ($Mouse[0] / 579) * $SetTime
	If $Playing Then
		$MPer = _BASS_ChannelSeconds2Bytes($File, $MPer)
		_BASS_ChannelSetPosition($File, $MPer, $BASS_POS_BYTE)
	EndIf
EndFunc   ;==>ProgressClick
Func Timer()
	Local $Pos, $Minutes, $Seconds
	If $Playing Then
		WinSetTitle("Bob's Media Player", "", "Bob's Media Player - " & $aSelection[4] & " - " & $aSelection[3])
		Local $SetTime1 = _BASS_ChannelGetPosition($File, $BASS_POS_BYTE)
		Local $Length = $SetTime
		$Pos = _BASS_ChannelBytes2Seconds($File, $SetTime1)
		If $TD Then $Counter = ($Length - $Pos)
		If Not $TD Then $Counter = $Pos
		$Minutes = Int($Counter / 60)
		$Seconds = Int((($Counter / 60) - $Minutes) * 60)
		$Counter = StringFormat("%02u:%02u", $Minutes, $Seconds)
		If $Seconds <> $Seconds1 Then
			If Not $TD Then
				GUICtrlSetData($Timer, " " & $Counter)
			Else
				GUICtrlSetData($Timer, "-" & $Counter)
			EndIf
			$Seconds1 = $Seconds
		EndIf
	Else
		WinSetTitle("Bob's Media Player", "", "Bob's Media Player")
	EndIf
EndFunc   ;==>Timer
Func Volume()
	Local $Percent
	$Percent = GUICtrlRead($Volume)
	GUICtrlSetTip($Volume, "Volume - " & $Percent & "%")
	SoundSetWaveVolume($Percent)
	$Set = $Percent / 10
	$Set = StringFormat("%.1f", $Set)
	GUICtrlSetData($Input, "")
	GUICtrlSetData($Input, $Set)
EndFunc   ;==>Volume
Func TimerSet() ;~ Toggles the direction the timer counts to
	If $TD = True Then
		$TD = False ; = Time counts up
	Else
		$TD = True ; = Time counts down
	EndIf
EndFunc   ;==>TimerSet
#EndRegion			******* Misc. functions that just don't fit other categories *******
#Region 		******* Button Functions *******
Func Next1()
	$DelayNext1 = TimerDiff($PauseNext1)
	If $DelayNext1 < 1000 Then Return
	Stop()
	$PauseNext1 = TimerInit()
	If $RandomSong Then
		$Skip = Random(0, _GUICtrlListView_GetItemCount($hListview), 1)
	Else
		If $aLV_Items[0] <> "" Then
			$Skip = $Current - ($aLV_Items[1] - 1)
		EndIf
		If $Skip < 0 Or $Skip > _GUICtrlListView_GetItemCount($hListview) Then $Skip = 0
		If $Skip = _GUICtrlListView_GetItemCount($hListview) Then
			$Skip = 0
		EndIf
	EndIf
	_GUICtrlListView_SetItemSelected($hListview, $Skip)
	_GUICtrlListView_EnsureVisible($hListview, $Skip)
	Play()
EndFunc   ;==>Next1
Func Play()
	Local $Show, $SelectionTest, $Minutes, $Seconds
	If GUICtrlRead($ListView) = 0 Then _GUICtrlListView_SetItemSelected($hListview, 0)
	$SelectionTest = GUICtrlRead($ListView)
	If $Current = $SelectionTest And $Playing = 1 Then
		Local $NotPausedStatus = _BASS_ChannelIsActive($File)
		If $NotPausedStatus = $BASS_ACTIVE_PLAYING Then
			$NotPaused = True
		ElseIf $NotPausedStatus = $BASS_ACTIVE_PAUSED Then
			$NotPaused = False
		EndIf
		If $NotPaused And $Playing = 1 Then
			GUICtrlSetData($Play, "4")
			_BASS_ChannelPause($File)
		ElseIf $Playing = 1 And Not $NotPaused Then
			GUICtrlSetData($Play, ";")
			_BASS_ChannelPlay($File, 0)
		EndIf
	Else
		If $Playing Then _BASS_ChannelStop($File)
		GUICtrlSetData($Play, ";")
		Local $aSelection = StringSplit(GUICtrlRead(GUICtrlRead($ListView)), "|")
		$Selection = $aSelection[7]
		$NowPlaying = ReadTags($Selection)
		$File = _BASS_StreamCreateFile(False, $Selection, 0, 0, 0)
		$Playing = 1
		$NotPaused = True
		_BASS_ChannelPlay($File, 1)
		Local $SetTime1 = _BASS_ChannelGetLength($File, $BASS_POS_BYTE)
		$SetTime = _BASS_ChannelBytes2Seconds($File, $SetTime1)
		$Minutes = Int(($SetTime) / 60)
		$Seconds = Int((($SetTime / 60) - $Minutes) * 60)
		$Counter = StringFormat("%02u:%02u", $Minutes, $Seconds)
		GUICtrlSetData($Timer, "-" & StringRight($Counter, 5) & " ")
		$Current = GUICtrlRead($ListView)
		If $aLV_Items[0] <> "" Then
			$Show = $Current - ($aLV_Items[1])
		EndIf
		_GUICtrlListView_EnsureVisible($hListview, $Show)
	EndIf
EndFunc   ;==>Play
Func Previous()
	Global $DelayPrevious = TimerDiff($PausePrevious)
	If $DelayPrevious < 1000 Then Return
	Stop()
	$PausePrevious = TimerInit()
	If $RandomSong Then
		$Skip = Random(0, _GUICtrlListView_GetItemCount($hListview), 1)
		Play()
	Else
		If $aLV_Items[0] <> "" Then
			$Skip = $Current - ($aLV_Items[1] + 1)
		EndIf
		If $Skip < 0 Then
			$Skip = _GUICtrlListView_GetItemCount($hListview) - 1
		EndIf
	EndIf
	_GUICtrlListView_SetItemSelected($hListview, $Skip)
	_GUICtrlListView_EnsureVisible($hListview, $Skip)
	Play()
EndFunc   ;==>Previous
Func ResetLV()
	WinSetState("Playlist", "", @SW_RESTORE)
	WinMove("Playlist", "", 100, 200, 600, 400)
EndFunc   ;==>ResetLV
Func ShowLV()
	If $bShowLV == "1" Then
		GUISetState(@SW_SHOW, $ListViewChild)
		$bShowLV = "0"
	Else
		GUISetState(@SW_HIDE, $ListViewChild)
		$bShowLV = "1"
	EndIf
EndFunc   ;==>ShowLV
Func Shuffle()
	If GUICtrlRead($Shuffle) = 68 Then
		$RandomSong = True
		GUICtrlSetState($Shuffle, $GUI_CHECKED)
	Else
		$RandomSong = False
		GUICtrlSetState($Shuffle, $GUI_UNCHECKED)
	EndIf
EndFunc   ;==>Shuffle
Func SkipBack()
	Local $SkipPos = _BASS_ChannelGetPosition($File, $BASS_POS_BYTE)
	$SkipPos = _BASS_ChannelBytes2Seconds($File, $SkipPos)
	$SkipPos = $SkipPos - 10
	If $SkipPos < 0 Then $SkipPos = 0
	$SkipPos = _BASS_ChannelSeconds2Bytes($File, $SkipPos)
	_BASS_ChannelSetPosition($File, $SkipPos, $BASS_POS_BYTE)
EndFunc   ;==>SkipBack
Func SkipFwd()
	Local $SkipPos = _BASS_ChannelGetPosition($File, $BASS_POS_BYTE)
	$SkipPos = _BASS_ChannelBytes2Seconds($File, $SkipPos)
	$SkipPos = $SkipPos + 10
	If $SkipPos >= $SetTime Then $SkipPos -= 10
	$SkipPos = _BASS_ChannelSeconds2Bytes($File, $SkipPos)
	_BASS_ChannelSetPosition($File, $SkipPos, $BASS_POS_BYTE)
EndFunc   ;==>SkipFwd
Func Stop()
	If $Playing < 1 Then Return
	_BASS_ChannelStop($File)
	$Playing = 0
	$Selection = ""
	GUICtrlSetData($Label1, "")
	$Count = 1
	GUICtrlSetData($Play, "4")
	GUICtrlSetData($Timer, " 00:00 ")
	GUICtrlSetData($Progress, 0)
EndFunc   ;==>Stop
#EndRegion 		******* Button Functions *******
#Region 		******* File Functions *******
;~	###################################################################################################################################
;~					The file access functions start here:
;~		BuildList() 		<== Creates a list of songs from the folder you choose
;~		ReadPic()			<== Scans for any pictures in the folders that your songs are in
;~		Open()			<== Opens a previously saved library (list of songs and attributes)
;~		ReadTags()		<== Using BassTags, read the ID3 tags on the files, also uses ID3.au3 to scan for album art embedded in the files
;~		Save()			<== Saves the music library to the script directory.
;~		RebuildList()		<== Clears the current song list and creates a new one from the folder you choose.
;~		_FileGetProperty(	<== Reads the file properties that Windows knows about.
;~	###################################################################################################################################
Func _FileGetProperty(Const $S_PATH, Const $S_PROPERTY = "")
	If Not FileExists($S_PATH) Then Return SetError(1, 0, 0)
	Local Const $S_FILE = StringTrimLeft($S_PATH, StringInStr($S_PATH, "\", 0, -1))
	Local Const $S_DIR = StringTrimRight($S_PATH, StringLen($S_FILE) + 1)
	Local Const $objShell = ObjCreate("Shell.Application")
	If @error Then Return SetError(3, 0, 0)
	Local Const $objFolder = $objShell.NameSpace($S_DIR)
	Local Const $objFolderItem = $objFolder.Parsename($S_FILE)
	If $S_PROPERTY Then
		For $I = 0 To 99
			If $objFolder.GetDetailsOf($objFolder.Items, $I) = $S_PROPERTY Then Return $objFolder.GetDetailsOf($objFolderItem, $I)
		Next
		Return SetError(2, 0, 0)
	EndIf
	Local $av_ret[1][2] = [[1]]
	For $I = 0 To 99
		If $objFolder.GetDetailsOf($objFolder.Items, $I) Then
			ReDim $av_ret[$av_ret[0][0] + 1][2]
			$av_ret[$av_ret[0][0]][0] = $objFolder.GetDetailsOf($objFolder.Items, $I)
			$av_ret[$av_ret[0][0]][1] = $objFolder.GetDetailsOf($objFolderItem, $I)
			$av_ret[0][0] += 1
		EndIf
	Next
	If Not $av_ret[1][0] Then Return SetError(2, 0, 0)
	$av_ret[0][0] -= 1
	Return $av_ret
EndFunc   ;==>_FileGetProperty
Func _FillListView()
	GUISetState(@SW_HIDE, $ListViewChild)
	_GUICtrlListView_DeleteAllItems($hListview)
	ConsoleWrite(UBound($aLV_Items))
	If UBound($aLV_Items) > 1 Then
		For $I = 1 To UBound($aLV_Items) - 1;[0] - 1
			If ($I / 2) = Int($I / 2) Then
				Local $sItem = $aLV_Content[$I][0] & "|" & $aLV_Content[$I][1] & "|" & $aLV_Content[$I][2] & "|" & $aLV_Content[$I][3] & "|" & $aLV_Content[$I][4] & "|" & $aLV_Content[$I][5] & "|" & $aLV_Content[$I][6]
				$aLV_Items[$I] = GUICtrlCreateListViewItem($sItem, $ListView)
				GUICtrlSetBkColor(-1, $LVSecondary)
				GUICtrlSetColor(-1, $LVsTextColor)
			Else
				Local $sItem = $aLV_Content[$I][0] & "|" & $aLV_Content[$I][1] & "|" & $aLV_Content[$I][2] & "|" & $aLV_Content[$I][3] & "|" & $aLV_Content[$I][4] & "|" & $aLV_Content[$I][5] & "|" & $aLV_Content[$I][6]
				$aLV_Items[$I] = GUICtrlCreateListViewItem($sItem, $ListView)
				GUICtrlSetBkColor($ListView, $LVPrimary)
				GUICtrlSetColor(-1, $LVpTextColor)
			EndIf
		Next
	EndIf
	GUICtrlSendMsg($ListView, $LVM_SETCOLUMNWIDTH, $ColumnCount - 1, 0)
	_GUICtrlListView_EndUpdate($hListview)
	GUISetState(@SW_SHOW, $ListViewChild)
EndFunc   ;==>_FillListView
;~		Build the library and populates the ViewList
Func _PreSelectAll()
	IniWrite($IniFile, "FileTypes", "$MP3", "1")
	IniWrite($IniFile, "FileTypes", "$WMA", "1")
	IniWrite($IniFile, "FileTypes", "$FLAC", "1")
	IniWrite($IniFile, "FileTypes", "$AIFF", "1")
	IniWrite($IniFile, "FileTypes", "$WAV", "1")
	IniWrite($IniFile, "FileTypes", "$OGG", "1")
EndFunc   ;==>_PreSelectAll
Func BuildList()
	Local $FileCount = 0, $DriveTemp, $Drive, $DriveName, $LV_Contents = UBound($aLV_Content) - 2
	Local $aMusicList[10000], $aMusicList1[10000]
	$DriveTemp = IniRead($IniFile, "Settings", "LastPath", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
	$Drive = FileSelectFolder("Select Folder", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", 4, $DriveTemp)
	If $Drive = "" Then Return
	$Drive &= "\"
	_PathSplit($Drive, $szDrive, $szDir, $szFName, $szExt)
	$DriveName = $szDrive
	IniWrite($IniFile, "Settings", "LastPath", $szDrive & $szDir)
	GUISetState(@SW_HIDE, $Form1)
	GUISetState(@SW_HIDE, $ListViewChild)
	$FileTypesRead = IniReadSection($IniFile, "FileTypes")
	If Not IsArray($FileTypesRead) Then
		_PreSelectAll()
		$FileTypesRead = IniReadSection($IniFile, "FileTypes")
	EndIf
	$FileTypes = ""
	For $I = 1 To UBound($FileTypesRead, 1) - 1
		Switch $FileTypesRead[$I][0]
			Case "$MP3"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.MP3;"
			Case "$WMA"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.WMA;"
			Case "$WAV"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.WAV;"
			Case "$OGG"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.OGG;"
			Case "$FLAC"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.FLAC;"
			Case "$AIFF"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.AIFF;"
		EndSwitch
	Next
	If $Rebuild Then _GUICtrlListView_DeleteAllItems($hListview)
	If $szDrive = StringLeft(@ScriptDir, 2) Then
		$aMusicList = _RecFileListToArray($szDir, $FileTypes, 1, 1, 1, 2)
	Else
		$aMusicList = _RecFileListToArray($Drive, $FileTypes, 1, 1, 1, 2)
	EndIf
	If Not IsArray($aMusicList) Then
		SoundPlay(@WindowsDir & "\Media\Windows Critical Stop.wav", 1)
		_ExtMsgBox(64, 0, "No Files", "No music found at that location", 2)
		GUISetState(@SW_SHOW, $Form1)
		GUISetState(@SW_SHOW, $ListViewChild)
		Return
	EndIf
;~
;~	Test for duplicate entries before adding them to the song list
;~
	For $I = 1 To $aLV_Items[0] - 1
		Local $Read1 = $aLV_Content[$I][6]
		Local $DelDup = _ArraySearch($aMusicList, $Read1)
		If $DelDup > -1 Then
			_ArrayDelete($aMusicList, $DelDup)
			$FileCount += 1
		EndIf
	Next
;~
;~	Here we check to see if there are any NON-duplicates left before continuing
;~	If $FileCount equals the number of files being added, that means that they are all duplicates so just return
;~
	If $FileCount = $aMusicList[0] Then
		$aMusicList = 0
		GUISetState(@SW_SHOW, $Form1)
		GUISetState(@SW_SHOW, $ListViewChild)
		Return
	EndIf
;~
;~	If we get to this point, that means that at least some files are new
;~
	$aMusicList[0] = $aMusicList[0] - $FileCount
	ReDim $aMusicList[$aMusicList[0] + 1]
	Global $ListItem[$aMusicList[0] + 1]
	ReDim $aLV_Items[$aLV_Items[0] + $aMusicList[0]]
	$aLV_Items[0] = UBound($aLV_Items)
	ReDim $aLV_Content[UBound($aLV_Content) + $aMusicList[0]][7]
;~
;~	Create a splash screen with scrolling progress bar to hide the build process
;~
	_Building()
;~
;~	Split the path list so that we can find the song name and type to put into the file list later if there is no other
;~	way to identify the song's name. Then try and read any and all ID3 tags for what information might be in them
;~
	For $I = 1 To $aMusicList[0]
		$String = ""
		_PathSplit($aMusicList[$I], $szDrive, $szDir, $szFName, $szExt)
		Local $sSong = $szFName
		Local $hMusic = _BASS_StreamCreateFile(False, $aMusicList[$I], 0, 0, $BASS_MUSIC_PRESCAN)
		If @error <> $BASS_ERROR_FILEOPEN Then
			Local $StringTemp
			If @OSVersion = "Win_7" Or @OSVersion = "WIN_VISTA" Then
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "#")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "#")
				EndIf
			Else
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = Number(_FileGetProperty($DriveName & $aMusicList[$I], "Track Number"))
				Else
					$StringTemp = Number(_FileGetProperty($aMusicList[$I], "Track Number"))
				EndIf
			EndIf
			If $StringTemp = "" Then
				$StringTemp = Number(_Bass_Tags_Read($hMusic, "%IFV2(%TRCK,%TRCK,xx)"))
			EndIf
			If $StringTemp = "" Then $StringTemp = "??"
			$String = "|" & $StringTemp
			If StringMid($aMusicList[$I], 2, 1) <> ":" Then
				$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Title")
			Else
				$StringTemp = _FileGetProperty($aMusicList[$I], "Title")
			EndIf
			If $StringTemp = "" Then $StringTemp = _Bass_Tags_Read($hMusic, "%IFV2(%TITL,%ICAP(%TITL),xx)")
			If $StringTemp = "" Or $StringTemp = "xx" Then $StringTemp = $sSong
			$String &= "|" & $StringTemp
			If @OSVersion = "Win_7" Or @OSVersion = "WIN_VISTA" Then
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Authors")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "Authors")
				EndIf
			Else
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Artist")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "Artist")
				EndIf
			EndIf
			If $StringTemp = "" Then $StringTemp = _Bass_Tags_Read($hMusic, "%IFV2(%ARTI,%ICAP(%ARTI),xx)")
			If $StringTemp = "" Or $StringTemp = "xx" Then $StringTemp = "Unknown Artist"
			$String &= "|" & $StringTemp
			If @OSVersion = "Win_7" Or @OSVersion = "WIN_VISTA" Then
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Album")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "Album")
				EndIf
			Else
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Album Title")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "Album Title")
				EndIf
			EndIf
			If $StringTemp = "" Then $StringTemp = _Bass_Tags_Read($hMusic, "%IFV2(%ALBM,%ICAP(%ALBM),xx)")
			If $StringTemp = "" Or $StringTemp = "xx" Then $StringTemp = "Unknown Album"
			$String &= "|" & $StringTemp
			If StringMid($aMusicList[$I], 2, 1) <> ":" Then
				$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Year")
			Else
				$StringTemp = _FileGetProperty($aMusicList[$I], "Year")
			EndIf
			If $StringTemp = "" Then $StringTemp = _Bass_Tags_Read($hMusic, "%IFV2(%YEAR,%YEAR,xx")
			If $StringTemp = "" Or $StringTemp = "<***) expected! ***" Or $StringTemp = "xx" Then $StringTemp = "????"
			$String &= "|" & $StringTemp & "|" & $aMusicList[$I]
			Local $TempML = StringSplit($String, "|")
			For $X = 0 To 6
				$aLV_Content[$LV_Contents + $I][$X] = $TempML[$X + 1]
			Next
			$aLV_Items[$LV_Contents + $I] = GUICtrlCreateListViewItem($String, $ListView)
		EndIf
	Next
	GUIDelete($Form2)
	_GUICtrlListView_BeginUpdate($hListview)
	_Scheme(IniRead($IniFile, "Settings", "Scheme", "Black"), IniRead($IniFile, "Child GUI", "LVPrimary", "Yellow"), IniRead($IniFile, "Child GUI", "lvsecondary", "Green"))
	$ListItem[0] = _GUICtrlListView_GetItemCount($hListview)
	Local $Temp = _GUICtrlListView_GetItemCount($hListview)
	ReDim $ListItem[$Temp + 1]
	$Saved = False
	$Built = True
	$Rebuild = False
	_FillListView()
;~
;~	Resize the columns to match the text width for easier reading
;~
	For $I = 2 To $ColumnCount - 2
		_GUICtrlListView_SetColumnWidth($hListview, $I, $LVSCW_AUTOSIZE)
	Next
	GUIDelete($Form2)
	GUISetState(@SW_SHOW, $Form1)
	WinSetState($Form1, "", @SW_ENABLE)
	WinActivate("Bob's Media Player")
	SoundPlay(@WindowsDir & "\Media\Windows Exclamation.wav", 1)
	_ExtMsgBoxSet(0, 0, 0x02616FF, 0x02AFF6A, 15, "Consolas")
	_ExtMsgBox(64, 0, "Done!", "Done with the build", 2, "", 0, .5)
EndFunc   ;==>BuildList
;~	Opens the saved music library and builds the ListView from it.
Func Open()
	$Musiclisting = IniRead($IniFile, "Settings", "FileListName", "MusicList.txt")
	If $Musiclisting = "" Or $OpenAs Then $Musiclisting = FileOpenDialog("Open Music list", @ScriptDir & "\", "Text Files (*.txt)", 8, $Musiclisting)
	If $Musiclisting = "" Then $Musiclisting = "MusicList.txt"
	_PathSplit($Musiclisting, $szDrive, $szDir, $szFName, $szExt)
	If @ScriptDir = $szDrive & StringTrimRight($szDir, 1) Then $Musiclisting = $szFName & $szExt
	Local $Open = FileOpen($Musiclisting, 0), $TempML
	GUISetState(@SW_HIDE, $ListViewChild)
	If $Open = -1 Then
		Local $Error = MsgBox(36, "Error", "Music library not found, create a new one?.")
		If $Error = 6 Then
			BuildList()
			Return
		Else
			$InitLoad = False
			Return
		EndIf
	EndIf
	_Building("Reading the music library file." & @LF & "Please stand by")
	Local $aMusicList[10000]
	Local $I = 1
	While 1
		$aMusicList[$I] = FileReadLine($Open)
		If @error = -1 Then ExitLoop
		$I += 1
	WEnd
	ReDim $aMusicList[$I + 1]
	$aMusicList[0] = $I
	FileClose($Open)
	For $I = 1 To $aMusicList[0] - 1
		$TempML = StringSplit($aMusicList[$I], "|")
		For $X = 0 To 6
			$aLV_Content[$I][$X] = $TempML[$X + 1]
		Next
	Next
	ReDim $aLV_Content[$aMusicList[0]][7]
	_GUICtrlListView_DeleteAllItems($hListview)
	For $I = 1 To ($aMusicList[0] - 1)
		$aLV_Items[$I] = GUICtrlCreateListViewItem($aMusicList[$I], $ListView)
	Next
	ReDim $aLV_Items[$aMusicList[0]]
	$aLV_Items[0] = $aMusicList[0]
	GUIDelete($Form2)
	_Scheme(IniRead($IniFile, "Settings", "Scheme", "Black"), IniRead($IniFile, "Child GUI", "LVPrimary", "Green"), IniRead($IniFile, "Child GUI", "LVSecondary", "Yellow"))
	$Built = True
	$Saved = True
	If Not $InitLoad Then MsgBox(64, "Loaded", "The music list has been loaded!")
	$InitLoad = False
	For $I = 2 To $ColumnCount - 3
		_GUICtrlListView_SetColumnWidth($hListview, $I, $LVSCW_AUTOSIZE)
	Next
	_GUICtrlListView_SetColumnWidth($hListview, 2, $LVSCW_AUTOSIZE_USEHEADER)
	_GUICtrlListView_SetColumnWidth($hListview, 6, $LVSCW_AUTOSIZE_USEHEADER)
	$aMusicList = 0
	If $OpenAs Then IniWrite($IniFile, "Settings", "FileListName", $Open)
EndFunc   ;==>Open
Func OpenAs()
	$OpenAs = 1
	Open()
	$OpenAs = 0
EndFunc   ;==>OpenAs
Func ReadPic($Song)
	Local $aString, $Pics
	Dim $szDrive, $szDir, $szFName
	$aString = _PathSplit($Song, $szDrive, $szDir, $szFName, $szExt)
	$Pics = _RecFileListToArray($szDrive & $szDir, "*.jpg;*.gif;*.bmp", 1, 0, 1, 2)
	Return $Pics
EndFunc   ;==>ReadPic
Func ReadTags($Song)
	Local $aString, $Pics, $Number, $RandomPic, $hMusic
	$aString = _PathSplit($Song, $szDrive, $szDir, $szFName, $szExt)
	_ID3ReadTag($Song)
	$Pics = ReadPic($Selection)
	If IsArray($Pics) Then
		If $Pics[0] > 1 Then
			$Number = Random(1, $Pics[0], 1)
		Else
			$Number = 1
		EndIf
		$RandomPic = $Pics[$Number]
	Else
		$RandomPic = $FilesDir & "\cd.gif"
	EndIf
	$hMusic = _BASS_StreamCreateFile(False, $Song, 0, 0, $BASS_MUSIC_PRESCAN)
	$String = "Song Title: " & $aSelection[3]
	$String &= "          Album: " & $aSelection[5]
	$String &= "          Track #: " & $aSelection[2]
	$String &= "          Artist: " & $aSelection[4]
	If _ID3GetTagField("APIC") <> "" Then
		If _ID3GetTagField("APIC") <> "File Type Unknown" And StringRight(_ID3GetTagField("APIC"), 3) <> "png" Then
			GUICtrlSetImage($Pic, _ID3GetTagField("APIC"))
			GUICtrlSetTip($Pic, "Tagged")
		Else
			GUICtrlSetImage($Pic, $RandomPic)
			GUICtrlSetTip($Pic, $RandomPic)
		EndIf
	Else
		GUICtrlSetImage($Pic, $RandomPic)
		GUICtrlSetTip($Pic, $RandomPic)
	EndIf
	Return $String
EndFunc   ;==>ReadTags
Func RebuildList()
	If Not $Saved And $Built Then ;~	Check to see if the music list has been changed and/or saved yet
		SoundPlay(@WindowsDir & "\Media\Windows Exclamation.wav", 1)
		_ExtMsgBoxSet(1, 0, 0x02616FF, 0x02AFF6A, 10, "Consolas")
		Local $Check = _ExtMsgBox($MB_ICONQUERY, 3, "Save?", "Your music list hasn't been saved yet, do you want to save first?")
		Switch $Check
			Case 3
				Return
			Case 1
				Save()
				If @error > 0 Then
					SoundPlay(@WindowsDir & "\Media\Windows Error.wav", 1)
					Local $Return = _ExtMsgBox(64, "Yes|No", "Error", "There was a problem saving the song file, would you like to retry?", 0, "", "", 1)
					If $Return = 1 Then
						SaveAs()
					EndIf
				EndIf
		EndSwitch
	EndIf
	Global $Rebuild = True
	Local $FileCount = 0, $DriveTemp, $Drive, $DriveName
	Local $aMusicList[10000], $aMusicList1[10000]
	$DriveTemp = IniRead($IniFile, "Settings", "LastPath", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
	$Drive = FileSelectFolder("Select Folder", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", 4, $DriveTemp)
	If $Drive = "" Then Return
	$Drive &= "\"
	_PathSplit($Drive, $szDrive, $szDir, $szFName, $szExt)
	$DriveName = $szDrive
	IniWrite($IniFile, "Settings", "LastPath", $szDrive & $szDir)
	GUISetState(@SW_HIDE, $Form1)
	GUISetState(@SW_HIDE, $ListViewChild)
	$FileTypesRead = IniReadSection($IniFile, "FileTypes")
	$FileTypes = ""
	For $I = 1 To UBound($FileTypesRead, 1) - 1
		Switch $FileTypesRead[$I][0]
			Case "$MP3"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.MP3;"
			Case "$WMA"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.WMA;"
			Case "$WAV"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.WAV;"
			Case "$OGG"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.OGG;"
			Case "$FLAC"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.FLAC;"
			Case "$AIFF"
				If $FileTypesRead[$I][1] = 1 Then $FileTypes &= "*.AIFF;"
		EndSwitch
	Next
	_GUICtrlListView_DeleteAllItems($hListview)
	If $szDrive = StringLeft(@ScriptDir, 2) Then
		$aMusicList = _RecFileListToArray($szDir, $FileTypes, 1, 1, 1, 2)
	Else
		$aMusicList = _RecFileListToArray($Drive, $FileTypes, 1, 1, 1, 2)
	EndIf
	If Not IsArray($aMusicList) Then
		SoundPlay(@WindowsDir & "\Media\Windows Critical Stop.wav", 1)
		_ExtMsgBox(64, 0, "No Files", "No music found at that location", 2)
		GUISetState(@SW_SHOW, $Form1)
		GUISetState(@SW_SHOW, $ListViewChild)
		Return
	EndIf
	ReDim $aMusicList[$aMusicList[0] + 1]
	Global $ListItem[$aMusicList[0] + 1]
;~ 	_ArrayDisplay($aMusicList)
	ReDim $aLV_Items[1][1]
	ReDim $aLV_Items[$aMusicList[0] + 1]
	$aLV_Items[0] = UBound($aLV_Items)
	ReDim $aLV_Content[1]
	ReDim $aLV_Content[$aMusicList[0] + 1][7]
	$aLV_Content[0][0] = UBound($aLV_Content)
;~ 	_ArrayDisplay($aLV_Items)
;~ 	_ArrayDisplay($aLV_Content)
;~
;~	Create a splash screen with scrolling progress bar to hide the build process
;~
	_Building()
;~
;~	Split the path list so that we can find the song name and type to put into the file list later if there is no other
;~	way to identify the song's name. Then try and read any and all ID3 tags for what information might be in them
;~
	For $I = 1 To $aMusicList[0]
		$String = ""
		_PathSplit($aMusicList[$I], $szDrive, $szDir, $szFName, $szExt)
		Local $sSong = $szFName
		Local $hMusic = _BASS_StreamCreateFile(False, $aMusicList[$I], 0, 0, $BASS_MUSIC_PRESCAN)
		If @error <> $BASS_ERROR_FILEOPEN Then
			Local $StringTemp
			If @OSVersion = "Win_7" Or @OSVersion = "WIN_VISTA" Then
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "#")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "#")
				EndIf
			Else
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = Number(_FileGetProperty($DriveName & $aMusicList[$I], "Track Number"))
				Else
					$StringTemp = Number(_FileGetProperty($aMusicList[$I], "Track Number"))
				EndIf
			EndIf
			If $StringTemp = "" Then
				$StringTemp = Number(_Bass_Tags_Read($hMusic, "%IFV2(%TRCK,%TRCK,xx)"))
			EndIf
			If $StringTemp = "" Then $StringTemp = "??"
			$String = "|" & $StringTemp
			If StringMid($aMusicList[$I], 2, 1) <> ":" Then
				$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Title")
			Else
				$StringTemp = _FileGetProperty($aMusicList[$I], "Title")
			EndIf
			If $StringTemp = "" Then $StringTemp = _Bass_Tags_Read($hMusic, "%IFV2(%TITL,%ICAP(%TITL),xx)")
			If $StringTemp = "" Or $StringTemp = "xx" Then $StringTemp = $sSong
			$String &= "|" & $StringTemp
			If @OSVersion = "Win_7" Or @OSVersion = "WIN_VISTA" Then
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Authors")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "Authors")
				EndIf
			Else
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Artist")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "Artist")
				EndIf
			EndIf
			If $StringTemp = "" Then $StringTemp = _Bass_Tags_Read($hMusic, "%IFV2(%ARTI,%ICAP(%ARTI),xx)")
			If $StringTemp = "" Or $StringTemp = "xx" Then $StringTemp = "Unknown Artist"
			$String &= "|" & $StringTemp
			If @OSVersion = "Win_7" Or @OSVersion = "WIN_VISTA" Then
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Album")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "Album")
				EndIf
			Else
				If StringMid($aMusicList[$I], 2, 1) <> ":" Then
					$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Album Title")
				Else
					$StringTemp = _FileGetProperty($aMusicList[$I], "Album Title")
				EndIf
			EndIf
			If $StringTemp = "" Then $StringTemp = _Bass_Tags_Read($hMusic, "%IFV2(%ALBM,%ICAP(%ALBM),xx)")
			If $StringTemp = "" Or $StringTemp = "xx" Then $StringTemp = "Unknown Album"
			$String &= "|" & $StringTemp
			If StringMid($aMusicList[$I], 2, 1) <> ":" Then
				$StringTemp = _FileGetProperty($DriveName & $aMusicList[$I], "Year")
			Else
				$StringTemp = _FileGetProperty($aMusicList[$I], "Year")
			EndIf
			If $StringTemp = "" Then $StringTemp = _Bass_Tags_Read($hMusic, "%IFV2(%YEAR,%YEAR,xx")
			If $StringTemp = "" Or $StringTemp = "<***) expected! ***" Or $StringTemp = "xx" Then $StringTemp = "????"
			$String &= "|" & $StringTemp & "|" & $aMusicList[$I]
			Local $TempML = StringSplit($String, "|")
			For $X = 0 To 6
				$aLV_Content[$I][$X] = $TempML[$X + 1]
			Next
			$aLV_Items[$I] = GUICtrlCreateListViewItem($String, $ListView)
		EndIf
	Next
	GUIDelete($Form2)
	_GUICtrlListView_BeginUpdate($hListview)
	_Scheme(IniRead($IniFile, "Settings", "Scheme", "Black"), IniRead($IniFile, "Child GUI", "LVPrimary", "Yellow"), IniRead($IniFile, "Child GUI", "lvsecondary", "Green"))
	$ListItem[0] = _GUICtrlListView_GetItemCount($hListview)
	Local $Temp = _GUICtrlListView_GetItemCount($hListview)
	ReDim $ListItem[$Temp + 1]
	$Saved = False
	$Built = True
	$Rebuild = False
;~
;~	Resize the columns to match the text width for easier reading
;~
	For $I = 2 To $ColumnCount - 2
		_GUICtrlListView_SetColumnWidth($hListview, $I, $LVSCW_AUTOSIZE)
	Next
	GUIDelete($Form2)
	GUISetState(@SW_SHOW, $Form1)
	GUISetState(@SW_SHOW, $ListViewChild)
	WinSetState($Form1, "", @SW_ENABLE)
	WinActivate("Bob's Media Player")
	SoundPlay(@WindowsDir & "\Media\Windows Exclamation.wav", 1)
	_ExtMsgBoxSet(0, 0, 0x02616FF, 0x02AFF6A, 15, "Consolas")
	_ExtMsgBox(64, 0, "Done!", "Done with the build", 2, "", 0, .5)
EndFunc   ;==>RebuildList
Func RebuildLV()
	ConsoleWrite('@@ (1201) :(' & @MIN & ':' & @SEC & ') RebuildLV()' & @CR) ;### Function Trace
	Local $Read1, $aMusicList1[10000]
	GUISetState(@SW_HIDE, $ListViewChild)
	_Building("Rebuilding the music list." & @LF & "Please stand by")
	For $I = 1 To _GUICtrlListView_GetItemCount($hListview)
		_GUICtrlListView_SetItemState($hListview, $I - 1, $LVIS_selected, $LVIS_selected)
		$Read1 = GUICtrlRead(GUICtrlRead($ListView))
		$aMusicList[$I] = $Read1
	Next
	$aMusicList[0] = $I
	For $I = 1 To $aMusicList[0] - 1
		Local $TempML = StringSplit($aMusicList[$I], "|")
		For $X = 0 To 6
			$aLV_Content[$I][$X] = $TempML[$X + 1]
		Next
	Next
	ReDim $aLV_Content[$aMusicList[0]][7]
	_GUICtrlListView_DeleteAllItems($hListview)
	ReDim $aLV_Items[$aMusicList[0]]
	$aLV_Items[0] = $aMusicList[0]
	GUIDelete($Form2)
	_GUICtrlListView_EndUpdate($hListview)
	$Rebuild_1 = True
	_Scheme(IniRead($IniFile, "Settings", "Scheme", "Black"), IniRead($IniFile, "Child GUI", "LVPrimary", "Green"), IniRead($IniFile, "Child GUI", "LVSecondary", "Yellow"))
	For $I = 1 To $aLV_Items[0] - 1
		If ($I / 2) = Int($I / 2) Then
			Local $sItem = $aLV_Content[$I][0] & "|" & $aLV_Content[$I][1] & "|" & $aLV_Content[$I][2] & "|" & $aLV_Content[$I][3] & "|" & $aLV_Content[$I][4] & "|" & $aLV_Content[$I][5] & "|" & $aLV_Content[$I][6]
			$aLV_Items[$I] = _GUICtrlListView_AddItem($hListview, $sItem)
			GUICtrlSetBkColor(-1, $LVSecondary)
			GUICtrlSetColor(-1, $LVsTextColor)
		Else
			$sItem = $aLV_Content[$I][0] & "|" & $aLV_Content[$I][1] & "|" & $aLV_Content[$I][2] & "|" & $aLV_Content[$I][3] & "|" & $aLV_Content[$I][4] & "|" & $aLV_Content[$I][5] & "|" & $aLV_Content[$I][6]
			$aLV_Items[$I] = _GUICtrlListView_AddItem($hListview, $sItem)
			GUICtrlSetBkColor($ListView, $LVPrimary)
			GUICtrlSetColor(-1, $LVpTextColor)
		EndIf
	Next
;~ 	_ArrayDisplay($aLV_Items)
	$Built = True
	$Saved = False
	GUICtrlSendMsg($ListView, $LVM_SETCOLUMNWIDTH, $ColumnCount - 1, 0)
;~  GUIDelete($Form2)
	GUISetState(@SW_SHOW, $ListViewChild)
	$Rebuild_1 = False
EndFunc   ;==>RebuildLV
Func Save()
	If Not $Built Then Return
	If _GUICtrlListView_GetItemCount($hListview) = 0 Then
		SoundPlay(@WindowsDir & "\Media\Windows Error.wav", 1)
		_ExtMsgBoxSet(0, 4, 0x02616FF, 0x02AFF6A, 10, "Consolas")
		_ExtMsgBox($MB_ICONSTOP, 0, "Empty List", "Your playlist is empty, there's nothing to save", 5, "", -1, .75)
		Return
	EndIf
	Local $Library
	$Library = FileOpen($Musiclisting, 2)
	If $Library = -1 Then
		SoundPlay(@WindowsDir & "\Media\Windows Error.wav", 1)
		_ExtMsgBox(64, 0, "Error", "Unable to open the file " & $Musiclisting & @LF & "Please make sure that you have write access to the folder " & @ScriptDir)
		SetError(1)
		Return
	EndIf
	For $I = 1 To $aLV_Items[0] - 1
		Local $String = ""
		For $X = 0 To 6
			$String &= $aLV_Content[$I][$X] & "|"
		Next
		FileWriteLine($Library, $String)
	Next
	FileClose($Library)
	SoundPlay(@WindowsDir & "\Media\Windows Error.wav", 1)
	_ExtMsgBoxSet(0, 4, 0x02616FF, 0x02AFF6A, 10, "Consolas")
	_ExtMsgBox(64, "Ok", "Saved", "The music list has been saved to disk as  " & $Musiclisting, 2)
	$Saved = True
EndFunc   ;==>Save
Func SaveAs()
	If Not $Built Then Return
	If _GUICtrlListView_GetItemCount($hListview) = 0 Then
		SoundPlay(@WindowsDir & "\Media\Windows Error.wav", 1)
		_ExtMsgBoxSet(0, 4, 0x02616FF, 0x02AFF6A, 10, "Consolas")
		_ExtMsgBox($MB_ICONSTOP, 0, "Empty List", "Your playlist is empty, there's nothing to save", 5, "", -1, .75)
		Return
	EndIf
	Local $aMusicList1[_GUICtrlListView_GetItemCount($hListview)], $Library1
	$Library1 = FileOpenDialog("Save As", @ScriptDir & "\", "Text Files (*.txt)", 8, $Musiclisting)
	If @error Then
		MsgBox(4096, "", "No File chosen")
		Return
	Else
		_PathSplit($Library1, $szDrive, $szDir, $szFName, $szExt)
		If @ScriptDir = $szDrive & StringTrimRight($szDir, 1) Then $Library1 = $szFName & $szExt
		Local $Library = FileOpen($Library1, 2)
		If $Library = -1 Then
			SoundPlay(@WindowsDir & "\Media\Windows Error.wav", 1)
			_ExtMsgBoxSet(0, 4, 0x02616FF, 0x02AFF6A, 10, "Consolas")
			_ExtMsgBox(64, 0, "Error", "Unable to open the file " & $Library1 & @LF & "Please make sure that you have write access to the folder " & @ScriptDir)
			Return
		EndIf
		For $I = 0 To _GUICtrlListView_GetItemCount($hListview) - 1
			_GUICtrlListView_SetItemState($hListview, $I, $LVIS_selected, $LVIS_selected)
			$Read1 = GUICtrlRead(GUICtrlRead($ListView))
			$aMusicList1[$I] = $Read1
		Next
		For $I = 0 To _GUICtrlListView_GetItemCount($hListview) - 1
			FileWriteLine($Library, $aMusicList1[$I])
		Next
		FileClose($Library)
		SoundPlay(@WindowsDir & "\Media\Windows Error.wav", 1)
		_ExtMsgBoxSet(0, 4, 0x02616FF, 0x02AFF6A, 10, "Consolas")
		_ExtMsgBox(64, 0, "Saved", "The music list has been saved to disk as  " & $Library1, 5)
		$Musiclisting = $Library1
		$Saved = True
	EndIf
EndFunc   ;==>SaveAs
#EndRegion 		******* File Functions *******
#Region 		******* HotKey and Windows Message functions here *******
Func _GUICtrl_GetHandle($control)
	If IsHWnd($control) Then Return $control
	Return GUICtrlGetHandle($control)
EndFunc   ;==>_GUICtrl_GetHandle
Func _MY_NCHITTEST($hWnd, $uMsg, $wParam, $lParam)
	Local $hGUI = WinGetHandle("Bob's Media Player")
	Switch $hWnd
		Case $hGUI
			Local $aPos = WinGetPos($hWnd)
			If Abs(BitAND(BitShift($lParam, 16), 0xFFFF) - $aPos[1]) < 220 And Abs(BitAND(BitShift($lParam, 16), 0xFFFF) - $aPos[1]) > 40 Then Return $HTCAPTION
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_MY_NCHITTEST
Func _WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $I
	Global $hWndFrom, $iCode, $tNMHDR, $hWndListView, $lParam
	$hWndListView = $hListview
	If Not IsHWnd($hListview) Then $hWndListView = GUICtrlGetHandle($ListView)
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
;~ 				Case $LVN_COLUMNCLICK ; A column was clicked
;~ 					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					$iCol = DllStructGetData($tInfo, "SubItem")
;~ 					; If you do not need the arrow on the column header remove this
;~ 					_GUICtrlListView_SortItems($hWndFrom, $iCol)
;~ 					; Reverse sort order for the column
;~ 					$aColOrder[$iCol] = Not ($aColOrder[$iCol])
;~ 					; Sort the array on the column
;~ 					_ArraySort($aLV_Content, $aColOrder[$iCol], 1, 0, $iCol)
;~ 					; Refill the ListView
;~ 					$Scheme = IniRead($IniFile, "Settings", "Scheme", "Blue")
;~ 					Local $LVP = IniRead($IniFile, "Child GUI", "LVPrimary", "Green")
;~ 					Local $LVS = IniRead($IniFile, "Child GUI", "LVSecondary", "Yellow")
;~ 					_Scheme($Scheme, $LVP, $LVS)
;~ 					$Saved = False
;~ 					$Built = True
				Case $LVN_COLUMNCLICK ; A column was clicked
					Local $Sortclock = TimerInit()
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					$iCol = DllStructGetData($tInfo, "SubItem")
;~ 					_GuiCtrlListView_BeginUpdate($hListview)
					_GUICtrlListView_SortItems($hWndFrom, DllStructGetData($tInfo, "SubItem"))
					$Scheme = IniRead($IniFile, "Settings", "Scheme", "Blue")
					Local $LVP = IniRead($IniFile, "Child GUI", "LVPrimary", "Green")
					Local $LVS = IniRead($IniFile, "Child GUI", "LVSecondary", "Yellow")
					RebuildLV()
					_Scheme($Scheme, $LVP, $LVS)
					$Saved = False
					$Built = True
					ConsoleWrite(" Sort time = " & TimerDiff($Sortclock) / 1000 & @LF & @LF)
				Case $LVN_ITEMACTIVATE
					Local $nmia = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					$I = DllStructGetData($nmia, "Index")
					Play()
			EndSwitch
	EndSwitch
	Return $__LISTVIEWCONSTANT_GUI_RUNDEFMSG
EndFunc   ;==>_WM_NOTIFY
Func HotKeySkipBack()
	Local $Position
	$Position = _BASS_ChannelGetPosition($File, $BASS_POS_BYTE)
	$Position = _BASS_ChannelBytes2Seconds($File, $Position)
	$Position -= 1
	$Position = _BASS_ChannelSeconds2Bytes($File, $Position)
	_BASS_ChannelSetPosition($File, $Position, $BASS_POS_BYTE)
EndFunc   ;==>HotKeySkipBack
Func HotKeySkipFwd()
	Local $Position
	$Position = _BASS_ChannelGetPosition($File, $BASS_POS_BYTE)
	$Position = _BASS_ChannelBytes2Seconds($File, $Position)
	$Position += 1
	$Position = _BASS_ChannelSeconds2Bytes($File, $Position)
	_BASS_ChannelSetPosition($File, $Position, $BASS_POS_BYTE)
EndFunc   ;==>HotKeySkipFwd
Func VolumeDown()
	Local $nPercent = GUICtrlRead($Volume)
	GUICtrlSetData($Volume, $nPercent - 1)
EndFunc   ;==>VolumeDown
Func VolumeUp()
	Local $nPercent = GUICtrlRead($Volume)
	GUICtrlSetData($Volume, $nPercent + 1)
EndFunc   ;==>VolumeUp
#EndRegion 		******* HotKey and Windows Message functions here *******
#Region			******* Color setting functions *******
Func _Building($MsgText = "Building the library, please stand by")
	Global $Form2 = GUICreate("", 290, 160, -1, -1, BitOR($WS_DLGFRAME, $WS_POPUP))
	GUISetBkColor(0x00080FF, $Form2)
	Local $PBMarquee = GUICtrlCreateProgress(20, 130, 250, 15, BitOR($PBS_SMOOTH, $PBS_MARQUEE))
	Local $hPBMarquee = GUICtrlGetHandle($PBMarquee)
	_SendMessage($hPBMarquee, $PBM_SETMARQUEE, True, 20) ; final parameter is update time in ms
	GUICtrlCreateLabel($MsgText, 20, 20, 250, 90)
	GUICtrlSetFont(-1, 14, 400, Default, "Comic Sans MS")
	GUICtrlSetColor(-1, 0x0FFFC19)
	GUISetState()
EndFunc   ;==>_Building
Func _ColorScheme($Color = "", $Pri = "", $Sec = "")
	$Scheme1 = $Color
	$CSOut = 1
	If $Scheme1 = "" Then $Scheme1 = GUICtrlRead($ColorScheme)
	If $Sec = "" Then $Sec = GUICtrlRead($LVColorSecondary)
	If $Pri = "" Then $Pri = GUICtrlRead($LVColorPrimary)
	$Scheme = IniRead($IniFile, "Settings", "Scheme", $Scheme1)
	If $Scheme <> $Scheme1 Then
		_Scheme($Scheme1, $Pri, $Sec)
	Else
		_Scheme($Scheme, $Pri, $Sec)
	EndIf
	GUISetBkColor($SchemeSet, $Form1)
	GUISetBkColor($SchemeSet, $ListViewChild)
	GUISetBkColor($SchemeSet, $OptionsBox)
	GUISetBkColor($SchemeSet, $EditBox)
EndFunc   ;==>_ColorScheme
Func _Scheme($SchemeIn = "Black", $SetP = "Yellow", $SetS = "Green")
	Stop()
	Select
		Case $SchemeIn = "Black"
			$SchemeSet = "0x0000000"
			GUICtrlSetImage($PlayList, $FilesDir & "\Folder_music.jpg")
			GUICtrlSetImage($Options, $FilesDir & "\option_black.jpg")
		Case $SchemeIn = "Blue"
			$SchemeSet = "0x0192CD3"
			GUICtrlSetImage($PlayList, $FilesDir & "\Folder_music_blue.jpg")
			GUICtrlSetImage($Options, $FilesDir & "\option_blue.jpg")
		Case $SchemeIn = "Red"
			$SchemeSet = "0x0E70215"
			GUICtrlSetImage($PlayList, $FilesDir & "\Folder_music_red.jpg")
			GUICtrlSetImage($Options, $FilesDir & "\option_red.jpg")
		Case $SchemeIn = "Green"
			$SchemeSet = "0x01F9F0B"
			GUICtrlSetImage($PlayList, $FilesDir & "\Folder_music_green.jpg")
			GUICtrlSetImage($Options, $FilesDir & "\option_green.jpg")
		Case $SchemeIn = "Purple"
			$SchemeSet = "0x07C20BD"
			GUICtrlSetImage($PlayList, $FilesDir & "\Folder_music_purple.jpg")
			GUICtrlSetImage($Options, $FilesDir & "\option_purple.jpg")
		Case $SchemeIn = "Yellow"
			$SchemeSet = "0x0EAE70E"
			GUICtrlSetImage($PlayList, $FilesDir & "\Folder_music_yellow.jpg")
			GUICtrlSetImage($Options, $FilesDir & "\option_yellow.jpg")
		Case $SchemeIn = "White"
			$SchemeSet = "0x0FFFFFF"
			GUICtrlSetImage($PlayList, $FilesDir & "\Folder_music_white.jpg")
			GUICtrlSetImage($Options, $FilesDir & "\option.jpg")
	EndSelect
	Select
		Case $SetP = "Yellow"
			$LVPrimary = $Yellow
			$LVpTextColor = "0x0000000"
		Case $SetP = "Black"
			$LVPrimary = $Black
			$LVpTextColor = "0x0999999"
		Case $SetP = "Blue"
			$LVPrimary = $Blue
			$LVpTextColor = "0x0FFFF2F"
		Case $SetP = "Red"
			$LVPrimary = $Red
			$LVpTextColor = "0x0000000"
		Case $SetP = "Green"
			$LVPrimary = $Green
			$LVpTextColor = "0x0FAD7FF"
		Case $SetP = "Purple"
			$LVPrimary = $Purple
			$LVpTextColor = "0x023FFF4"
		Case $SetP = "White"
			$LVPrimary = $White
			$LVpTextColor = "0x0FF492D"
	EndSelect
	Select
		Case $SetS = "Yellow"
			$LVSecondary = $Yellow
			$LVsTextColor = "0x09D5109"
		Case $SetS = "Black"
			$LVSecondary = $Black
			$LVsTextColor = "0x0FFFF2F"
		Case $SetS = "Blue"
			$LVSecondary = $Blue
			$LVsTextColor = "0x0C1A3EE"
		Case $SetS = "Red"
			$LVSecondary = $Red
			$LVsTextColor = "0x0FFFF2F"
		Case $SetS = "Green"
			$LVSecondary = $Green
			$LVsTextColor = "0x0000000"
		Case $SetS = "Purple"
			$LVSecondary = $Purple
			$LVsTextColor = "0x0FFFF2F"
		Case $SetS = "White"
			$LVSecondary = $White
			$LVsTextColor = "0x0AAAAAA"
	EndSelect
	If $CSOut = 1 Then
		$CSOut = 0
		Return
	EndIf
	_GUICtrlListView_BeginUpdate($hListview)
	_FillListView()
EndFunc   ;==>_Scheme
#EndRegion			******* Color setting functions *******
#Region			******* Options/Editing section *******
Func _SelectAll()
	GUICtrlSetState($MP3, $GUI_CHECKED)
	GUICtrlSetState($WAV, $GUI_CHECKED)
	GUICtrlSetState($FLAC, $GUI_CHECKED)
	GUICtrlSetState($AIFF, $GUI_CHECKED)
	GUICtrlSetState($WMA, $GUI_CHECKED)
	GUICtrlSetState($OGG, $GUI_CHECKED)
EndFunc   ;==>_SelectAll
Func _SelectNone()
	GUICtrlSetState($MP3, $GUI_UNCHECKED)
	GUICtrlSetState($WAV, $GUI_UNCHECKED)
	GUICtrlSetState($FLAC, $GUI_UNCHECKED)
	GUICtrlSetState($AIFF, $GUI_UNCHECKED)
	GUICtrlSetState($WMA, $GUI_UNCHECKED)
	GUICtrlSetState($OGG, $GUI_UNCHECKED)
EndFunc   ;==>_SelectNone
Func CloseOpt()
	$Scheme1 = GUICtrlRead($ColorScheme)
	$Scheme = IniRead($IniFile, "Settings", "Scheme", $Scheme1)
	If $Scheme <> $Scheme1 Then
		_ColorScheme($Scheme, IniRead($IniFile, "Child GUI", "LVPrimary", "Yellow"), IniRead($IniFile, "Child GUI", "LVSecondary", "Green"))
	Else
		_ColorScheme($Scheme1, IniRead($IniFile, "Child GUI", "LVPrimary", "Yellow"), IniRead($IniFile, "Child GUI", "LVSecondary", "Green"))
	EndIf
	GUISetState(@SW_HIDE, $OptionsBox)
	$Options1 = 0
EndFunc   ;==>CloseOpt
Func Delete()
	Local $Checked[_GUICtrlListView_GetItemCount($hListview) + 1], $X = 1
	If _GUICtrlListView_GetItemCount($hListview) = 0 Then
		SoundPlay(@WindowsDir & "\Media\Windows Exclamation.wav", 1)
		_ExtMsgBox($MB_ICONEXCLAM, 0, "What were you thinking?", "You're trying to use Delete when there is nothing in the list, are you sure that is what you wanted to do just now?", 0, "", 0, 1)
		Return
	EndIf
	For $I = 0 To _GUICtrlListView_GetItemCount($hListview) - 1
		If _GUICtrlListView_GetItemChecked($hListview, $I) = True Then
			$Checked[$X] = $I
			$X += 1
		EndIf
	Next
	ReDim $Checked[$X]
	$Checked[0] = $X - 1
	If $Checked[0] > 0 Then
		For $I = $Checked[0] To 1 Step -1
			_GUICtrlListView_SetItemSelected($hListview, $Checked[$I])
			Local $iCurr = GUICtrlRead($ListView)
			; Convert to index
			$iIndex = _ArraySearch($aLV_Items, $iCurr)
			; Delete that index from data and ControlID arrays
			_ArrayDelete($aLV_Items, $iIndex)
			$aLV_Items[0] -= 1
			_ArrayDelete($aLV_Content, $iIndex)
		Next
	Else
		Local $iCurr = GUICtrlRead($ListView)
		$iIndex = _ArraySearch($aLV_Items, $iCurr)
		_ArrayDelete($aLV_Items, $iIndex)
		$aLV_Items[0] -= 1
		_ArrayDelete($aLV_Content, $iIndex)
	EndIf
	$Built = True
	$Saved = False
	GUISetState(@SW_HIDE, $ListViewChild)
	_Scheme($Scheme, IniRead($IniFile, "Child GUI", "LVPrimary", "Yellow"), IniRead($IniFile, "Child GUI", "LVSecondary", "Green"))
	GUISetState(@SW_SHOW, $ListViewChild)
EndFunc   ;==>Delete
Func Edit()
	If _GUICtrlListView_GetItemCount($hListview) = 0 Then
		SoundPlay(@WindowsDir & "\Media\Windows Exclamation.wav", 1)
		_ExtMsgBox($MB_ICONEXCLAM, 0, "What were you thinking?", "You're trying to use Edit when there is nothing in the list, are you sure that is what you wanted to do just now?", 0, "", 0, 1)
		Return
	EndIf
	Global $EditTemp = GUICtrlRead($ListView)
	$EditTemp -= $aLV_Items[1] - 1
	Global $EditBox = GUICreate("EditBox", 400, 210)
	GUISetOnEvent($GUI_EVENT_CLOSE, "EditClose")
	GUISetBkColor($SchemeSet, $EditBox)
	_GUICtrlListView_BeginUpdate($ListView)
	Global $Track = GUICtrlCreateInput($aLV_Content[$EditTemp][1], 10, 10, 280, 20)
	GUICtrlCreateLabel("Track", 300, 10)
	Global $Title = GUICtrlCreateInput($aLV_Content[$EditTemp][2], 10, 35, 280, 20)
	GUICtrlCreateLabel("Title", 300, 35)
	Global $Artist = GUICtrlCreateInput($aLV_Content[$EditTemp][3], 10, 60, 280, 20)
	GUICtrlCreateLabel("Artist", 300, 60)
	Global $Album = GUICtrlCreateInput($aLV_Content[$EditTemp][4], 10, 85, 280, 20)
	GUICtrlCreateLabel("Album", 300, 85)
	Global $Year = GUICtrlCreateInput($aLV_Content[$EditTemp][5], 10, 110, 280, 20)
	GUICtrlCreateLabel("Year", 300, 110)
	GUICtrlCreateButton("Update", 120, 135, 60, 20)
	GUICtrlSetOnEvent(-1, "Update")
	Global $EditMore = GUICtrlCreateCheckbox("Edit next item in list after updating", 10, 160)
	If $bEdit = 1 Then GUICtrlSetState($EditMore, $GUI_CHECKED)
	GUISetState()
	Global $bEdit = 2
EndFunc   ;==>Edit
Func EditClose()
	GUIDelete($EditBox)
	_GUICtrlListView_EndUpdate($hListview)
	$bEdit = 0
EndFunc   ;==>EditClose
Func Options()
	If $Options1 = 1 Then Return
	Global $OptionsBox = GUICreate("Options", 500, 400, -1, -1, Default, Default, $Form1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseOpt")
	GUISetBkColor($SchemeSet, $OptionsBox)
	GUICtrlCreateTab(10, 32, 480, 360)
	GUICtrlCreateTabItem("Settings")
	GUIStartGroup()
	GUICtrlCreateLabel("Save window position and size on exit?", 20, 70, 150, 50)
	GUICtrlSetFont(-1, 8, 800)
	Global $Always = GUICtrlCreateRadio("Always ", 35, 110)
	GUICtrlSetFont(-1, 8, 800)
	Global $Never = GUICtrlCreateRadio("Never ", 35, 140)
	GUICtrlSetFont(-1, 8, 800)
	Global $Ask = GUICtrlCreateRadio("Ask ", 35, 170)
	GUICtrlSetFont(-1, 8, 800)
	GUIStartGroup()
	GUICtrlCreateLabel("Save the state of the music list on exit?", 20, 210, 150, 40)
	GUICtrlSetFont(-1, 8, 800)
	Global $StateYes = GUICtrlCreateRadio("Yes ", 35, 250)
	GUICtrlSetFont(-1, 8, 800)
	Global $StateNo = GUICtrlCreateRadio("No ", 35, 280)
	GUICtrlSetFont(-1, 8, 800)
	GUICtrlCreateLabel("Save Volume control setting on exit?", 250, 70, 150, 40)
	GUICtrlSetFont(-1, 8, 800)
	GUIStartGroup()
	Global $VolumeSetYes = GUICtrlCreateRadio("Yes ", 265, 110)
	GUICtrlSetFont(-1, 8, 800)
	Global $VolumeSetNo = GUICtrlCreateRadio("No ", 265, 140)
	GUICtrlSetFont(-1, 8, 800)
	GUICtrlCreateLabel("Select file types to play with BMP", 250, 170, 150, 40)
	GUICtrlSetFont(-1, 8, 800)
	Global $MP3 = GUICtrlCreateCheckbox("MP3", 265, 200)
	GUICtrlSetFont(-1, 8, 800)
	Global $WAV = GUICtrlCreateCheckbox("WAV", 265, 220)
	GUICtrlSetFont(-1, 8, 800)
	Global $AIFF = GUICtrlCreateCheckbox("AIFF", 265, 240)
	GUICtrlSetFont(-1, 8, 800)
	Global $FLAC = GUICtrlCreateCheckbox("FLAC", 265, 260)
	GUICtrlSetFont(-1, 8, 800)
	Global $OGG = GUICtrlCreateCheckbox("OGG", 265, 280)
	GUICtrlSetFont(-1, 8, 800)
	Global $WMA = GUICtrlCreateCheckbox("WMA", 265, 300)
	GUICtrlSetFont(-1, 8, 800)
	GUICtrlCreateButton("Select All", 245, 340, -1, 20)
	GUICtrlSetOnEvent(-1, "_SelectAll")
	GUICtrlCreateButton("Select None", 325, 340, -1, 20)
	GUICtrlSetOnEvent(-1, "_SelectNone")
	GUICtrlCreateTabItem("Interface")
	GUICtrlCreateLabel("Set the background color of the GUI windows", 20, 90, 300, 40)
	GUICtrlSetFont(-1, 10, 800)
	Global $ColorScheme = GUICtrlCreateCombo("Red", 50, 130, 70)
	GUICtrlSetOnEvent($ColorScheme, "_ColorScheme")
	Global $SaveScheme = IniRead($IniFile, "Settings", "Scheme", "Black")
	GUICtrlSetData(-1, "Black|Blue|Green|Purple|White|Yellow", $SaveScheme)
	GUICtrlCreateLabel("Set the musiclist main color", 20, 170, 300, 20)
	GUICtrlSetFont(-1, 10, 800)
	$LVPrimary = IniRead($IniFile, "Child GUI", "LVPrimary", "Yellow")
	Global $LVColorPrimary = GUICtrlCreateCombo("Yellow", 50, 190, 70)
	GUICtrlSetData(-1, "Black|Blue|Green|Purple|Red|White", $LVPrimary)
	GUICtrlCreateLabel("Set the musiclist secondary color", 20, 250, 300, 20)
	GUICtrlSetFont(-1, 10, 800)
	$LVSecondary = IniRead($IniFile, "Child GUI", "LVSecondary", "Green")
	Global $LVColorSecondary = GUICtrlCreateCombo("Green", 50, 270, 70)
	GUICtrlSetData(-1, "Black|Blue|Purple|Red|White|Yellow", $LVSecondary)
	GUICtrlCreateTabItem("")
	GUICtrlCreateButton("Save Options", 300, 10, 70, 20)
	GUICtrlSetOnEvent(-1, "OptionsSave")
	GUICtrlCreateButton("Cancel", 400, 10, 70, 20)
	GUICtrlSetOnEvent(-1, "CloseOpt")
	OptionsRead()
	GUICtrlSetState($SaveVolume, $GUI_CHECKED)
	GUICtrlSetState($SaveColors, $GUI_CHECKED)
	GUICtrlSetState($PosState, $GUI_CHECKED)
	GUICtrlSetState($SaveState, $GUI_CHECKED)
	If $SetOpt Then
		GUISetState(@SW_SHOW, $OptionsBox)
		$Options1 = 1
	Else
		GUISetState(@SW_HIDE, $OptionsBox)
		$SetOpt = True
	EndIf
EndFunc   ;==>Options
Func OptionsRead()
	$FileTypesRead = IniReadSection($IniFile, "FileTypes")
	For $I = 1 To UBound($FileTypesRead, 1) - 1
		Switch $FileTypesRead[$I][0]
			Case "$MP3"
				GUICtrlSetState($MP3, $FileTypesRead[$I][1])
			Case "$WMA"
				GUICtrlSetState($WMA, $FileTypesRead[$I][1])
			Case "$WAV"
				GUICtrlSetState($WAV, $FileTypesRead[$I][1])
			Case "$OGG"
				GUICtrlSetState($OGG, $FileTypesRead[$I][1])
			Case "$FLAC"
				GUICtrlSetState($FLAC, $FileTypesRead[$I][1])
			Case "$AIFF"
				GUICtrlSetState($AIFF, $FileTypesRead[$I][1])
		EndSwitch
	Next
	$PosState1 = IniRead($IniFile, "Settings", "SavePos", "Ask")
	Select
		Case $PosState1 = "Ask"
			$PosState = $Ask
		Case $PosState1 = "Never"
			$PosState = $Never
		Case $PosState1 = "Always"
			$PosState = $Always
	EndSelect
	$SaveState1 = IniRead($IniFile, "Settings", "SaveState", "Yes")
	Select
		Case $SaveState1 = "Yes"
			$SaveState = $StateYes
		Case $SaveState1 = "No"
			$SaveState = $StateNo
	EndSelect
	$SaveVolume1 = IniRead($IniFile, "Settings", "SaveVolume", "Yes")
	Select
		Case $SaveVolume1 = "Yes"
			$SaveVolume = $VolumeSetYes
		Case $SaveVolume1 = "No"
			$SaveVolume = $VolumeSetNo
	EndSelect
EndFunc   ;==>OptionsRead
Func OptionsSave()
	Select
		Case GUICtrlRead($Always) = $GUI_CHECKED
			IniWrite($IniFile, "Settings", "SavePos", "Always")
		Case GUICtrlRead($Never) = $GUI_CHECKED
			IniWrite($IniFile, "Settings", "SavePos", "Never")
		Case GUICtrlRead($Ask) = $GUI_CHECKED
			IniWrite($IniFile, "Settings", "SavePos", "Ask")
	EndSelect
	Select
		Case GUICtrlRead($StateYes) = $GUI_CHECKED
			IniWrite($IniFile, "Settings", "SaveState", "Yes")
		Case GUICtrlRead($StateNo) = $GUI_CHECKED
			IniWrite($IniFile, "Settings", "SaveState", "No")
	EndSelect
	Select
		Case GUICtrlRead($VolumeSetYes) = $GUI_CHECKED
			IniWrite($IniFile, "Settings", "SaveVolume", "Yes")
		Case GUICtrlRead($VolumeSetNo) = $GUI_CHECKED
			IniWrite($IniFile, "Settings", "SaveVolume", "No")
	EndSelect
	$Scheme1 = GUICtrlRead($ColorScheme)
	IniWrite($IniFile, "FileTypes", "$MP3", GUICtrlRead($MP3))
	IniWrite($IniFile, "FileTypes", "$WMA", GUICtrlRead($WMA))
	IniWrite($IniFile, "FileTypes", "$FLAC", GUICtrlRead($FLAC))
	IniWrite($IniFile, "FileTypes", "$AIFF", GUICtrlRead($AIFF))
	IniWrite($IniFile, "FileTypes", "$WAV", GUICtrlRead($WAV))
	IniWrite($IniFile, "FileTypes", "$OGG", GUICtrlRead($OGG))
	IniWrite($IniFile, "Settings", "Scheme", $Scheme1)
	IniWrite($IniFile, "Child GUI", "LVPrimary", GUICtrlRead($LVColorPrimary))
	IniWrite($IniFile, "Child GUI", "LVSecondary", GUICtrlRead($LVColorSecondary))
	_Scheme($Scheme1, GUICtrlRead($LVColorPrimary), GUICtrlRead($LVColorSecondary))
	CloseOpt()
EndFunc   ;==>OptionsSave
Func Update()
	$Built = True
	$Saved = False
	_GUICtrlListView_EndUpdate($hListview)
	$String = "|" & GUICtrlRead($Track) & "|" & GUICtrlRead($Title) & "|" & GUICtrlRead($Artist) & "|" & GUICtrlRead($Album) & "|" & GUICtrlRead($Year) & "|" & $aLV_Content[$EditTemp][6]
	Local $xarray = StringSplit($String, "|")
	For $I = 0 To 6
		$aLV_Content[$EditTemp][$I] = $xarray[$I + 1]
	Next
	GUICtrlSetData(GUICtrlRead($ListView), $String)
	If GUICtrlRead($EditMore) = $GUI_CHECKED Then
		$Current = GUICtrlRead($ListView)
		$Skip = $Current - ($aLV_Items[1] - 1)
		If $Skip = _GUICtrlListView_GetItemCount($hListview) Then
			$Skip = 0
		EndIf
		_GUICtrlListView_SetItemSelected($ListView, $Skip)
		_GUICtrlListView_EnsureVisible($hListview, $Skip)
		Sleep(100)
		$bEdit = 1
		GUIDelete($EditBox)
		Return
	EndIf
	EditClose()
	_Scheme($Scheme, IniRead($IniFile, "Child GUI", "LVPrimary", "Yellow"), IniRead($IniFile, "Child GUI", "LVSecondary", "Green"))
EndFunc   ;==>Update
#EndRegion			******* Options/Editing section *******
Func Search1()
	Global $ItemNum
	$Search_box = GUICtrlRead($Search)
	If $Search_box = "" And Not $SF3 Then
		$ItemNum = -1
		GUIDelete($Temp)
		$SF3 = False
		Return
	EndIf
	While True
		GUIDelete($Temp)
		If Not $SF3 Then _Building("Searching")
;~		$SF3 = False
		$ItemNum = _GUICtrlListView_FindInText($hListview, $Search_box, $ItemNum, False)
		If @error Or $ItemNum = -1 Then
			$f_HotKeyEnabled = False
			HotKeySet("{F3}")
			HotKeySet("+{F3}")
			GUIDelete($Form2)
			$SF3 = False
			_ExtMsgBoxSet(0, 4, 0x02616FF, 0x02AFF6A, 10, "Consolas")
			_ExtMsgBox(64, 0, "", "Not Found", 5)
			ExitLoop
		EndIf
		GUIDelete($Form2)
		_GUICtrlListView_SetItemSelected($hListview, $ItemNum)
		_GUICtrlListView_EnsureVisible($hListview, $ItemNum)
		ExitLoop
	WEnd
EndFunc   ;==>Search1
Func SearchWindow()
	If Not $SF3 Or @HotKeyPressed = "+{F3}" Then
		$ItemNum = -1
		$SF3 = True
		Global $Temp = GUICreate("Search", 300, 100)
		GUISetOnEvent($GUI_EVENT_CLOSE, "_TempClose")
		Global $Search = GUICtrlCreateInput("", 20, 20, 260)
		GUICtrlCreateButton(" Search ", 60, 60)
		GUICtrlSetOnEvent(-1, "Search1")
		GUISetState()
	Else
		$SF3 = True
		Search1()
	EndIf
EndFunc   ;==>SearchWindow
#Region
;~ List of Functions used in the program, for easy searching
;~ Func BuildList(
;~ Func CloseOpt(
;~ Func Delete(
;~ Func Edit(
;~ Func EditClose(
;~ Func Form1Close(
;~ Func HotKeySkipBack(
;~ Func HotKeySkipFwd(
;~ Func Marquee(
;~ Func Next1(
;~ Func Open(
;~ Func OpenAs(
;~ Func Options(
;~ Func OptionsRead(
;~ Func OptionsSave(
;~ Func Play(
;~ Func Previous(
;~ Func Progress(
;~ Func ProgressClick(
;~ Func ReadPic(
;~ Func ReadTags(
;~ Func RebuildLV(
;~ Func RebuildList(
;~ Func ResetLV(
;~ Func Save(
;~ Func SaveAs(
;~ Func Search1(
;~ Func SearchWindow(
;~ Func ShowLV(
;~ Func Shuffle(
;~ Func SkipBack(
;~ Func SkipFwd(
;~ Func Stop(
;~ Func Timer(
;~ Func TimerSet(
;~ Func Update(
;~ Func Volume(
;~ Func VolumeDown(
;~ Func VolumeUp(
;~ Func _Building(
;~ Func _ColorScheme(
;~ Func _CopyRight(
;~ Func _FAQ(
;~ Func _FileGetProperty(
;~ Func _FillListView(
;~ Func _GUICtrl_GetHandle(
;~ Func _HelpMe(
;~ Func _ExtMsgBox(
;~ Func _MY_NCHITTEST(
;~ Func _Scheme(
;~ Func _SelectAll(
;~ Func _SelectNone(
;~ Func _TempClose(
;~ Func _WM_NOTIFY(
#EndRegion