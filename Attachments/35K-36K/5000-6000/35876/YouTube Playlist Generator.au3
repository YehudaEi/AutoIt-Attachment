#AutoIt3Wrapper_Icon=Resources\Icon.ico
#AutoIt3Wrapper_Outfile=YouTube Playlist Generator.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Created by Robert Salatka (skin design by playlet)
#AutoIt3Wrapper_Res_Fileversion=1.4.0.4
#AutoIt3Wrapper_Res_LegalCopyright=R.S. Software
#AutoIt3Wrapper_Res_File_Add=Resources\Skin.png, 10, SKIN
#AutoIt3Wrapper_Res_File_Add=Resources\Skin2.png, 10, SKIN2
#AutoIt3Wrapper_Res_File_Add=Resources\Skin3.png, 10, SKIN3
#AutoIt3Wrapper_Res_File_Add=Resources\Skin4.png, 10, SKIN4
#AutoIt3Wrapper_Res_File_Add=Resources\Skin5.png, 10, SKIN5

#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <IE.au3>
#include <GUIListBox.au3>

Global $CMPLD = @Compiled, $VRSN = "1.4.0.4"
Global $ImgSA[3], $TabA[11][3], $PosAS[11][2], $Win[11], $Win2[7], $Win3[5], $Win4[4], $Win5[4], $Win6[5], $Win7[4], $MTim = TimerInit()

Opt("TrayAutoPause", 0)
If $CMPLD = 0 Then TraySetIcon(@ScriptDir & "\Resources\Icon.ico")

; Declarations
Global $GUI, $EmbedIE, $CGUI, $GUI2, $EmbedIE2, $CGUI2, $GUI3, $CGUI3, $GUI4, $CGUI4, $GUI5, $CGUI5, $GUI6, $CGUI6, $GUI7, $CGUI7
Global $CurrentGui = 1, $PlayListListBox, $PlayListView, $PlaySong, $NextControlModifier, $NextAltModifier, $PlayListSongs
Global $NextShiftModifier, $SetNextSongHotkey, $PreviousControlModifier, $PreviousAltModifier, $PreviousShiftModifier
Global $SetPreviousSongHotkey, $CurrentPlaylist, $KeepNextSongHotkey, $KeepPreviousSongHotkey, $RemoveSongList
Global $InputBox, $rInputBox, $exiter = 0

Opt("WinTitleMatchMode", 1)

_GDIPlus_Startup()
_IEErrorHandlerRegister()

$CheckForFirstRun = IniRead("Playlists.ini", "Playlist Manager", "Created By", "FirstRun")
If $CheckForFirstRun = "FirstRun" Then
	IniWrite("Playlists.ini", "Playlist Manager", "Created By", "Robert Salatka" & @CRLF & @CRLF)
	IniWrite("Playlists.ini", "Settings", "LastPlaylist", "")
	IniWrite("Playlists.ini", "Hotkeys", "Next", "^1")
	IniWrite("Playlists.ini", "Hotkeys", "Previous", "^2")
Else
	$PlayListNames = IniReadSectionNames("Playlists.ini")
	$CurrentPlayList = IniRead("Playlists.ini", "Settings", "LastPlaylist", "Error")
	$KeepNextSongHotkey = IniRead("Playlists.ini", "Hotkeys", "Next", "Error")
	$KeepPreviousSongHotkey = IniRead("Playlists.ini", "Hotkeys", "Previous", "Error")
	HotKeySet($KeepNextSongHotkey, "_NextSong")
	HotKeySet($KeepPreviousSongHotkey, "_PreviousSong")
	_OpenPlayList()
EndIf

; Begin creation of Gui and all controls
If $CMPLD = 1 Then
	$SKN = _ResourceGetAsImage("SKIN")
Else
	$SKN = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin.png")
EndIf
$sBG = _GDIPlus_BitmapCloneArea($SKN, 1, 1, 824, 632, 0x0026200A)
$TabA[1][0] = _GDIPlus_BitmapCloneArea($SKN, 1, 634, 32, 32, 0x0026200A)
$TabA[1][1] = _GDIPlus_BitmapCloneArea($SKN, 34, 634, 32, 32, 0x0026200A)
$TabA[1][2] = _GDIPlus_BitmapCloneArea($SKN, 67, 634, 32, 32, 0x0026200A)
$TabA[2][0] = _GDIPlus_BitmapCloneArea($SKN, 100, 634, 32, 32, 0x0026200A)
$TabA[2][1] = _GDIPlus_BitmapCloneArea($SKN, 133, 634, 32, 32, 0x0026200A)
$TabA[2][2] = _GDIPlus_BitmapCloneArea($SKN, 166, 634, 32, 32, 0x0026200A)
$TabA[3][0] = _GDIPlus_BitmapCloneArea($SKN, 199, 634, 32, 32, 0x0026200A)
$TabA[3][1] = _GDIPlus_BitmapCloneArea($SKN, 232, 634, 32, 32, 0x0026200A)
$TabA[3][2] = _GDIPlus_BitmapCloneArea($SKN, 265, 634, 32, 32, 0x0026200A)
$TabA[4][0] = _GDIPlus_BitmapCloneArea($SKN, 730, 634, 16, 16, 0x0026200A)
$TabA[4][1] = _GDIPlus_BitmapCloneArea($SKN, 747, 634, 16, 16, 0x0026200A)
$TabA[4][2] = _GDIPlus_BitmapCloneArea($SKN, 764, 634, 16, 16, 0x0026200A)
$TabA[5][0] = _GDIPlus_BitmapCloneArea($SKN, 781, 634, 16, 16, 0x0026200A)
$TabA[5][1] = _GDIPlus_BitmapCloneArea($SKN, 798, 634, 16, 16, 0x0026200A)
$TabA[5][2] = _GDIPlus_BitmapCloneArea($SKN, 815, 634, 16, 16, 0x0026200A)
$ImgSA[0] = _GDIPlus_BitmapCloneArea($SKN, 298, 634, 143, 27, 0x0026200A)
$ImgSA[1] = _GDIPlus_BitmapCloneArea($SKN, 442, 634, 143, 27, 0x0026200A)
$ImgSA[2] = _GDIPlus_BitmapCloneArea($SKN, 586, 634, 143, 27, 0x0026200A)
_GDIPlus_ImageDispose($SKN)

$GUI = GUICreate("YouTube Playlist Generator", 824, 632, -1, -1, 0x80000000 + 0x00020000, 0x00080000)
If $CMPLD = 0 Then GUISetIcon(@ScriptDir & "\Resources\Icon.ico")
; DRAG LABELS designed to avoid buttons
GUICtrlCreateLabel("", 8, 7, 752, 29, -1, 0x00100000); drag label
GUICtrlCreateLabel("", 8, 36, 13, 38, -1, 0x00100000); drag label
GUICtrlCreateLabel("", 145, 36, 666, 40, -1, 0x00100000); drag label
GUICtrlCreateLabel("", 8, 74, 11, 482, -1, 0x00100000); drag label
GUICtrlCreateLabel("", 800, 74, 11, 482, -1, 0x00100000); drag label
GUICtrlCreateLabel("", 8, 555, 803, 20, -1, 0x00100000); drag label
GUICtrlCreateLabel("", 8, 604, 803, 15, -1, 0x00100000); drag label
GUICtrlCreateLabel("", 8, 574, 25, 31, -1, 0x00100000); drag label
GUICtrlCreateLabel("", 786, 574, 25, 31, -1, 0x00100000); drag label

$hGr1 = _GDIPlus_GraphicsCreateFromHWND(_WinAPI_GetDesktopWindow())
$hBmp = _GDIPlus_BitmapCreateFromGraphics(824, 632, $hGr1)
$hGr2 = _GDIPlus_ImageGetGraphicsContext($hBmp)
_GDIPlus_GraphicsDrawImageRect($hGr2, $sBG, 0, 0, 824, 632)
_GDIPlus_GraphicsDrawString_($hGr2, "YouTube Playlist Generator v" & StringTrimRight($VRSN, 4), 36, 10, "Comic Sans MS", 12, "86b2e7")
_GDIPlus_GraphicsDispose($hGr2)
_GDIPlus_GraphicsDispose($hGr1)
SetBmp($GUI, $hBmp)
_GDIPlus_BitmapDispose($hBmp)
_GDIPlus_ImageDispose($sBG)

$PosAS[1][0] = GUICtrlCreateLabel("", 27, 38, 32, 32); back button
$PosAS[2][0] = GUICtrlCreateLabel("", 67, 38, 32, 32); forward button
$PosAS[3][0] = GUICtrlCreateLabel("", 107, 38, 32, 32); home button
$PosAS[4][0] = GUICtrlCreateLabel("", 763, 14, 16, 16); minimize button
$PosAS[5][0] = GUICtrlCreateLabel("", 788, 14, 16, 16); home button
$PosAS[6][0] = GUICtrlCreateLabel("", 37, 576, 143, 27)
$PosAS[7][0] = GUICtrlCreateLabel("", 187, 576, 143, 27)
$PosAS[8][0] = GUICtrlCreateLabel("", 337, 576, 143, 27)
$PosAS[9][0] = GUICtrlCreateLabel("", 487, 576, 143, 27)
$PosAS[10][0] = GUICtrlCreateLabel("", 637, 576, 143, 27); these are all tracking labels
For $i = 1 To 7
	$PosAS[$i][1] = 0; state
Next

$Win[1] = GUICreate("", 32, 32, 30, 42, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
SetBmp($Win[1], $TabA[1][0]); back
$Win[2] = GUICreate("", 32, 32, 70, 42, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
SetBmp($Win[2], $TabA[2][0]); forward
$Win[3] = GUICreate("", 32, 32, 110, 42, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
SetBmp($Win[3], $TabA[3][0]); home
$Win[4] = GUICreate("", 16, 16, 766, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
SetBmp($Win[4], $TabA[4][0]); minimize
$Win[5] = GUICreate("", 16, 16, 791, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
SetBmp($Win[5], $TabA[5][0]); exit
$Win[6] = GUICreate("", 143, 27, 40, 580, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
DrawImg($TabA, 6, $ImgSA, "New Playlist", 143, 27, 27, 1, "Comic Sans MS", 11)
SetBmp($Win[6], $TabA[6][0])
$Win[7] = GUICreate("", 143, 27, 190, 580, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
DrawImg($TabA, 7, $ImgSA, "Add song", 143, 27, 35, 1, "Comic Sans MS", 11)
SetBmp($Win[7], $TabA[7][0])
$Win[8] = GUICreate("", 143, 27, 340, 580, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
DrawImg($TabA, 8, $ImgSA, "Remove Song", 143, 27, 25, 1, "Comic Sans MS", 11)
SetBmp($Win[8], $TabA[8][0])
$Win[9] = GUICreate("", 143, 27, 490, 580, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
DrawImg($TabA, 9, $ImgSA, "Select Playlist", 143, 27, 20, 1, "Comic Sans MS", 11)
SetBmp($Win[9], $TabA[9][0])
$Win[10] = GUICreate("", 143, 27, 640, 580, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI)
DrawImg($TabA, 10, $ImgSA, "Play Playlist", 143, 27, 30, 1, "Comic Sans MS", 11)
SetBmp($Win[10], $TabA[10][0])

_GDIPlus_ImageDispose($ImgSA[0])
_GDIPlus_ImageDispose($ImgSA[1])
_GDIPlus_ImageDispose($ImgSA[2])

$CGUI = GUICreate("", 824, 632, -1, -1, 0x80000000, 0x00080000, $GUI)
GUISetBkColor(0x123456, $CGUI)
If $CMPLD = 1 Then
	GUICtrlCreateIcon(@ScriptFullPath, -1, 16, 14, 16, 16)
Else
	GUICtrlCreateIcon(@ScriptDir & "\Resources\Icon.ico", 0, 16, 14, 16, 16)
EndIf

$EmbedIE = _IECreateEmbedded()
$GUIActiveX = GUICtrlCreateObj($EmbedIE, 24, 80, 772, 468)

_WinAPI_SetLayeredWindowAttributes($CGUI, 0x123456, 255)
ShowHideGUI(1, 1)
; End creation of Gui and all controls

_IENavigate($EmbedIE, "http://www.YouTube.com", 0)

RedMem()

While 1; START OF MAIN LOOP
	MLoop(1, 1, 10, $GUI, $PosAS, $Win, $TabA)
	Sleep(10)
WEnd; END OF MAIN LOOP

Func MLoop($VAR0, $VARS, $VARE, $VARGUI, $VARARR, $VARWIN, $VARIMGARR)
	For $i = $VARS To $VARE
		$pos = GUIGetCursorInfo($VARGUI)
		If $pos[4] = $VARARR[$i][0] Then
			If $pos[3] = 1 Then ExitLoop
			If $pos[2] = 1 Then ExitLoop
			While $pos[4] = $VARARR[$i][0]
				$pos = GUIGetCursorInfo($VARGUI)
				Switch $pos[2]
					Case 0; not pressed
						If $VARARR[$i][1] <> 1 Then
							SetBmp($VARWIN[$i], $VARIMGARR[$i][1])
							$VARARR[$i][1] = 1
						EndIf
					Case 1
						While $pos[2] = 1; holding pressed
							$pos = GUIGetCursorInfo($VARGUI)
							Switch $pos[4]
								Case $VARARR[$i][0]; on button, pressed
									If $VARARR[$i][1] <> 2 Then
										SetBmp($VARWIN[$i], $VARIMGARR[$i][2])
										$VARARR[$i][1] = 2
									EndIf
								Case Else; not on button, pressed
									If $VARARR[$i][1] <> 3 Then
										SetBmp($VARWIN[$i], $VARIMGARR[$i][1])
										$VARARR[$i][1] = 3
									EndIf
							EndSwitch
							Sleep(10)
						WEnd
						If $pos[4] = $VARARR[$i][0] Then
							Switch $VAR0
								Case 1
									Switch $i
										Case 1; back pressed
											_IEAction($EmbedIE, "back")
										Case 2; forward pressed
											_IEAction($EmbedIE, "forward")
										Case 3; home pressed
											_IENavigate($EmbedIE, "http://www.YouTube.com", 0)
										Case 4; minimize pressed
											GUISetState(@SW_MINIMIZE, $GUI)
										Case 5; exit pressed
											CloseAll()
										Case 6
											_CreateNewPlayList()
										Case 7
											_AddNewSong()
										Case 8
											_RemoveSong()
										Case 9
											_ViewPlayLists()
										Case 10
											_PlayPlayList()
									EndSwitch
								Case 2
									Switch $i
										Case 1; minimize pressed
											GUISetState(@SW_MINIMIZE, $GUI2)
										Case 2; exit pressed
											$exiter = 1
											ExitLoop
										Case 3
											_PreviousSong()
										Case 4
											_PlaySong()
										Case 5
											_NextSong()
										Case 6
											GUISetState(@SW_DISABLE, $GUI2)
											_Shortcuts()
											GUISetState(@SW_ENABLE, $GUI2)
									EndSwitch
								Case 3
									Switch $i
										Case 1; minimize pressed
											GUISetState(@SW_MINIMIZE, $GUI3)
										Case 2; exit pressed
											$exiter = 1
											ExitLoop
										Case 3
											$exiter = 1
											_OpenPlayList()
											ExitLoop
										Case 4
											_RemovePlayList()
									EndSwitch
								Case 4
									Switch $i
										Case 1; minimize pressed
											GUISetState(@SW_MINIMIZE, $GUI4)
										Case 2; exit pressed
											$exiter = 1
											ExitLoop
										Case 3
											_DeleteSong()
											GUICtrlSetData($RemoveSongList, "")
											$PlayListSongs = IniReadSection("Playlists.ini", $CurrentPlayList)
											$SongList = IniReadSection("Playlists.ini", $CurrentPlayList)
											For $i = 2 To $SongList[0][0]
												GUICtrlSetData($RemoveSongList, $SongList[$i][0])
											Next
											_GUICtrlListBox_SetCurSel($RemoveSongList, 0)
									EndSwitch
								Case 5
									Switch $i
										Case 1; minimize pressed
											GUISetState(@SW_MINIMIZE, $GUI5)
										Case 2; exit pressed
											$exiter = 1
											ExitLoop
										Case 3
											$CheckForChange1 = GuiCtrlRead($SetNextSongHotkey)
											$CheckForChange2 = GuiCtrlRead($SetPreviousSongHotkey)
											If $CheckForChange1 = "" Or $CheckForChange2 = "" Then
												MsgBoxGUI("Error", "You haven't set the hotkeys yet.")
											Else
												_SetHotKeys()
												$exiter = 1
												ExitLoop
											EndIf
									EndSwitch
								Case 6
									Switch $i
										Case 1; minimize pressed
											GUISetState(@SW_MINIMIZE, $GUI6)
										Case 2, 4; exit pressed
											$exiter = 1
											ExitLoop
										Case 3
											$irInputBox = GUICtrlRead($InputBox)
											If $irInputBox <> "" Then
												$rInputBox = $irInputBox
												$exiter = 1
												ExitLoop
											EndIf
									EndSwitch
								Case 7
									Switch $i
										Case 1; minimize pressed
											GUISetState(@SW_MINIMIZE, $GUI7)
										Case 2, 3
											$exiter = 1
											ExitLoop
									EndSwitch
							EndSwitch
						EndIf
				EndSwitch
				;If $exiter = 1 Then ExitLoop
				If $CurrentGui <> 1 Then
					If GUIGetMsg() = -3 Or $exiter = 1 Then Return
				EndIf
				Sleep(10)
			WEnd
			SetBmp($VARWIN[$i], $VARIMGARR[$i][0])
			$VARARR[$i][1] = 0
		EndIf
	Next
	If TimerDiff($MTim) > 30000 Then RedMem()
	If $CurrentGui = 1 Then
		If GUIGetMsg() = -3 Then CloseAll()
	Else
		If GUIGetMsg() = -3 Or $exiter = 1 Then Return
	EndIf
EndFunc   ;==>MLoop

Func RedMem(); only @AutoItPID supported!
    Local $handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', @AutoItPID)
    DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $handle[0])
    DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $handle[0])
	$MTim = TimerInit()
EndFunc   ;==>RedMem

Func MsgBoxGUI($VAR1, $VAR2, $SZ = 0)
	Local $TabA7[4][3], $PosAS7[4][2], $ImgSA7[3], $currGUI = $CurrentGui
	$CurrentGui = 0
	If $CMPLD = 1 Then
		$SKN7a = _ResourceGetAsImage("SKIN4")
		$SKN7 = _ResourceGetAsImage("SKIN5")
	Else
		$SKN7a = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin4.png")
		$SKN7 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin5.png")
	EndIf
	$sBG7 = _GDIPlus_BitmapCloneArea($SKN7, 1, 1, 304, 168, 0x0026200A)
	$TabA7[1][0] = _GDIPlus_BitmapCloneArea($TabA[4][0], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA7[1][1] = _GDIPlus_BitmapCloneArea($TabA[4][1], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA7[1][2] = _GDIPlus_BitmapCloneArea($TabA[4][2], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA7[2][0] = _GDIPlus_BitmapCloneArea($TabA[5][0], 0, 0, 16, 16, 0x0026200A); close
	$TabA7[2][1] = _GDIPlus_BitmapCloneArea($TabA[5][1], 0, 0, 16, 16, 0x0026200A); close
	$TabA7[2][2] = _GDIPlus_BitmapCloneArea($TabA[5][2], 0, 0, 16, 16, 0x0026200A); close
	_GDIPlus_ImageDispose($SKN7)
	$ImgSA7[0] = _GDIPlus_BitmapCloneArea($SKN7a, 1, 218, 102, 22, 0x0026200A)
	$ImgSA7[1] = _GDIPlus_BitmapCloneArea($SKN7a, 104, 218, 102, 22, 0x0026200A)
	$ImgSA7[2] = _GDIPlus_BitmapCloneArea($SKN7a, 1, 241, 102, 22, 0x0026200A)
	_GDIPlus_ImageDispose($SKN7a)
	$GUI7 = GUICreate($VAR1, 304, 168, -1, -1, 0x80000000 + 0x00020000, 0x00080000);, $GUI)
	If $CMPLD = 0 Then GUISetIcon(@ScriptDir & "\Resources\Icon.ico")
	; DRAG LABELS designed to avoid buttons
	GUICtrlCreateLabel("", 8, 7, 236, 38, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 243, 33, 48, 12, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 8, 44, 11, 111, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 282, 44, 9, 111, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 18, 119, 80, 36, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 208, 119, 75, 36, -1, 0x00100000); drag label
	$hGr17 = _GDIPlus_GraphicsCreateFromHWND(_WinAPI_GetDesktopWindow())
	$hBmp7 = _GDIPlus_BitmapCreateFromGraphics(304, 168, $hGr17)
	$hGr27 = _GDIPlus_ImageGetGraphicsContext($hBmp7)
	_GDIPlus_GraphicsDrawImageRect($hGr27, $sBG7, 0, 0, 304, 168)
	_GDIPlus_GraphicsDrawString_($hGr27, $VAR1, 34, 10, "Comic Sans MS", 12, "86b2e7")
	If $SZ = 1 Then
		_GDIPlus_GraphicsDrawString_($hGr27, $VAR2, 28, 50, "Comic Sans MS", 8);, "86b2e7")
	Else
		_GDIPlus_GraphicsDrawString_($hGr27, $VAR2, 28, 50, "Comic Sans MS", 10);, "86b2e7")
	EndIf
	_GDIPlus_GraphicsDispose($hGr27)
	_GDIPlus_GraphicsDispose($hGr17)
	SetBmp($GUI7, $hBmp7)
	_GDIPlus_BitmapDispose($hBmp7)
	_GDIPlus_ImageDispose($sBG7)
	;TO RESTORE MINIMIZE AND EXIT BUTTON, UNCOMMENT THESE LINES AND SET THE SECOND LINE IN THE WHILE LOOP TO THIS: For $i = 1 To 3
	;$PosAS7[1][0] = GUICtrlCreateLabel("", 247, 14, 16, 16); minimize button
	;$PosAS7[2][0] = GUICtrlCreateLabel("", 267, 14, 16, 16); close button
	$PosAS7[3][0] = GUICtrlCreateLabel("", 102, 126, 102, 22); previous button
	For $i = 1 To 3
		$PosAS7[$i][1] = 0; state
	Next
	;TO RESTORE MINIMIZE AND EXIT BUTTON, UNCOMMENT THESE LINES AND SET THE SECOND LINE IN THE WHILE LOOP TO THIS: For $i = 1 To 3
	$Win7[1] = "";GUICreate("", 16, 16, 250, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI7)
	;SetBmp($Win7[1], $TabA7[1][0]); minimize
	$Win7[2] = "";GUICreate("", 16, 16, 270, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI7)
	;SetBmp($Win7[2], $TabA7[2][0]); exit
	$Win7[3] = GUICreate("", 102, 22, 105, 130, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI7)
	DrawImg($TabA7, 3, $ImgSA7, "OK", 102, 22, 38, 0, "Comic Sans MS", 10)
	SetBmp($Win7[3], $TabA7[3][0]); button
	_GDIPlus_ImageDispose($ImgSA7[0])
	_GDIPlus_ImageDispose($ImgSA7[1])
	_GDIPlus_ImageDispose($ImgSA7[2])
	$CGUI7 = GUICreate("", 304, 168, -1, -1, 0x80000000, 0x00080000, $GUI7)
	GUISetBkColor(0x123456, $CGUI7)
	If $CMPLD = 1 Then
		GUICtrlCreateIcon(@ScriptFullPath, -1, 16, 14, 16, 16)
	Else
		GUICtrlCreateIcon(@ScriptDir & "\Resources\Icon.ico", 0, 16, 14, 16, 16)
	EndIf
	_WinAPI_SetLayeredWindowAttributes($CGUI7, 0x123456, 255)
	ShowHideGUI(7, 1)
	RedMem()
	While 1
		;TO RESTORE MINIMIZE AND EXIT BUTTON, SET THE NEXT LINE TO THIS: For $i = 1 To 4
		MLoop(7, 3, 3, $GUI7, $PosAS7, $Win7, $TabA7)
		If $exiter = 1 Then ExitLoop
		Sleep(10)
	WEnd
	ShowHideGUI(7, 0)
	For $i = 1 To 3
		GUIDelete($Win7[$i])
	Next
	GUIDelete($CGUI7)
	GUIDelete($GUI7)
	For $i = 1 To 3
		_GDIPlus_ImageDispose($TabA7[$i][0])
		_GDIPlus_ImageDispose($TabA7[$i][1])
		_GDIPlus_ImageDispose($TabA7[$i][2])
	Next
	RedMem()
	$CurrentGui = $currGUI
	$exiter = 0
EndFunc   ;==>MsgBoxGUI

Func InputBoxGUI($VAR1, $VAR2)
	Local $TabA6[5][3], $PosAS6[5][2], $ImgSA6[3], $currGUI = $CurrentGui
	$CurrentGui = 0
	If $CMPLD = 1 Then
		$SKN6 = _ResourceGetAsImage("SKIN4")
	Else
		$SKN6 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin4.png")
	EndIf
	$sBG6 = _GDIPlus_BitmapCloneArea($SKN6, 1, 1, 273, 216, 0x0026200A)
	$TabA6[1][0] = _GDIPlus_BitmapCloneArea($TabA[4][0], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA6[1][1] = _GDIPlus_BitmapCloneArea($TabA[4][1], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA6[1][2] = _GDIPlus_BitmapCloneArea($TabA[4][2], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA6[2][0] = _GDIPlus_BitmapCloneArea($TabA[5][0], 0, 0, 16, 16, 0x0026200A); close
	$TabA6[2][1] = _GDIPlus_BitmapCloneArea($TabA[5][1], 0, 0, 16, 16, 0x0026200A); close
	$TabA6[2][2] = _GDIPlus_BitmapCloneArea($TabA[5][2], 0, 0, 16, 16, 0x0026200A); close
	$ImgSA6[0] = _GDIPlus_BitmapCloneArea($SKN6, 1, 218, 102, 22, 0x0026200A)
	$ImgSA6[1] = _GDIPlus_BitmapCloneArea($SKN6, 104, 218, 102, 22, 0x0026200A)
	$ImgSA6[2] = _GDIPlus_BitmapCloneArea($SKN6, 1, 241, 102, 22, 0x0026200A)
	_GDIPlus_ImageDispose($SKN6)
	$GUI6 = GUICreate("Input Text", 273, 216, -1, -1, 0x80000000 + 0x00020000, 0x00080000, $GUI)
	If $CMPLD = 0 Then GUISetIcon(@ScriptDir & "\Resources\Icon.ico")
	; DRAG LABELS designed to avoid buttons
	GUICtrlCreateLabel("", 8, 7, 206, 38, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 213, 33, 47, 12, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 8, 44, 11, 159, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 251, 44, 9, 159, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 129, 173, 10, 30, -1, 0x00100000); drag label
	$hGr16 = _GDIPlus_GraphicsCreateFromHWND(_WinAPI_GetDesktopWindow())
	$hBmp6 = _GDIPlus_BitmapCreateFromGraphics(273, 216, $hGr16)
	$hGr26 = _GDIPlus_ImageGetGraphicsContext($hBmp6)
	_GDIPlus_GraphicsDrawImageRect($hGr26, $sBG6, 0, 0, 273, 216)
	_GDIPlus_GraphicsDrawString_($hGr26, $VAR1, 34, 10, "Comic Sans MS", 12, "86b2e7")
	_GDIPlus_GraphicsDrawString_($hGr26, $VAR2, 28, 50, "Comic Sans MS", 10);, "86b2e7")
	_GDIPlus_GraphicsDispose($hGr26)
	_GDIPlus_GraphicsDispose($hGr16)
	SetBmp($GUI6, $hBmp6)
	_GDIPlus_BitmapDispose($hBmp6)
	_GDIPlus_ImageDispose($sBG6)
	;TO RESTORE MINIMIZE AND EXIT BUTTON, UNCOMMENT THESE LINES AND SET THE SECOND LINE IN THE WHILE LOOP TO THIS: For $i = 1 To 3
	;$PosAS6[1][0] = GUICtrlCreateLabel("", 217, 14, 16, 16); minimize button
	;$PosAS6[2][0] = GUICtrlCreateLabel("", 237, 14, 16, 16); close button
	$PosAS6[3][0] = GUICtrlCreateLabel("", 24, 174, 102, 22); previous button
	$PosAS6[4][0] = GUICtrlCreateLabel("", 143, 174, 102, 22); previous button
	For $i = 1 To 4
		$PosAS6[$i][1] = 0; state
	Next
	;TO RESTORE MINIMIZE AND EXIT BUTTON, UNCOMMENT THESE LINES AND SET THE SECOND LINE IN THE WHILE LOOP TO THIS: For $i = 1 To 3
	$Win6[1] = "";GUICreate("", 16, 16, 220, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI6)
	;SetBmp($Win6[1], $TabA6[1][0]); minimize
	$Win6[2] = "";GUICreate("", 16, 16, 240, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI6)
	;SetBmp($Win6[2], $TabA6[2][0]); exit
	$Win6[3] = GUICreate("", 102, 22, 27, 178, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI6)
	DrawImg($TabA6, 3, $ImgSA6, "OK", 102, 22, 38, 0, "Comic Sans MS", 10)
	SetBmp($Win6[3], $TabA6[3][0]); button
	$Win6[4] = GUICreate("", 102, 22, 146, 178, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI6)
	DrawImg($TabA6, 4, $ImgSA6, "Cancel", 102, 22, 29, 0, "Comic Sans MS", 10)
	SetBmp($Win6[4], $TabA6[4][0]); button
	_GDIPlus_ImageDispose($ImgSA6[0])
	_GDIPlus_ImageDispose($ImgSA6[1])
	_GDIPlus_ImageDispose($ImgSA6[2])
	$CGUI6 = GUICreate("", 273, 216, -1, -1, 0x80000000, 0x00080000, $GUI6)
	GUISetBkColor(0x123456, $CGUI6)
	If $CMPLD = 1 Then
		GUICtrlCreateIcon(@ScriptFullPath, -1, 16, 14, 16, 16)
	Else
		GUICtrlCreateIcon(@ScriptDir & "\Resources\Icon.ico", 0, 16, 14, 16, 16)
	EndIf
	$InputBox = GuiCtrlCreateInput("", 28, 130, 213, 25)
	_WinAPI_SetLayeredWindowAttributes($CGUI6, 0x123456, 255)
	ShowHideGUI(6, 1)
	GUICtrlSetState(-1, 256)
	RedMem()
	While 1
		;TO RESTORE MINIMIZE AND EXIT BUTTON, SET THE NEXT LINE TO THIS: For $i = 1 To 4
		MLoop(6, 3, 4, $GUI6, $PosAS6, $Win6, $TabA6)
		If $exiter = 1 Then ExitLoop
		Sleep(10)
	WEnd
	ShowHideGUI(6, 0)
	For $i = 1 To 4
		GUIDelete($Win6[$i])
	Next
	GUIDelete($CGUI6)
	GUIDelete($GUI6)
	For $i = 1 To 4
		_GDIPlus_ImageDispose($TabA6[$i][0])
		_GDIPlus_ImageDispose($TabA6[$i][1])
		_GDIPlus_ImageDispose($TabA6[$i][2])
	Next
	RedMem()
	$CurrentGui = $currGUI
	$exiter = 0
	Return $rInputBox
EndFunc   ;==>InputBoxGUI

Func _Shortcuts()
	$CurrentGui = 5
	HotKeySet($KeepNextSongHotkey)
	HotKeySet($KeepPreviousSongHotkey)
	Local $TabA5[4][3], $PosAS5[4][2], $ImgSA5[3]
	If $CMPLD = 1 Then
		$SKN5a = _ResourceGetAsImage("SKIN")
		$SKN5 = _ResourceGetAsImage("SKIN3")
	Else
		$SKN5a = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin.png")
		$SKN5 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin3.png")
	EndIf
	$sBG5 = _GDIPlus_BitmapCloneArea($SKN5, 1, 1, 353, 387, 0x0026200A)
	$TabA5[1][0] = _GDIPlus_BitmapCloneArea($TabA[4][0], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA5[1][1] = _GDIPlus_BitmapCloneArea($TabA[4][1], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA5[1][2] = _GDIPlus_BitmapCloneArea($TabA[4][2], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA5[2][0] = _GDIPlus_BitmapCloneArea($TabA[5][0], 0, 0, 16, 16, 0x0026200A); close
	$TabA5[2][1] = _GDIPlus_BitmapCloneArea($TabA[5][1], 0, 0, 16, 16, 0x0026200A); close
	$TabA5[2][2] = _GDIPlus_BitmapCloneArea($TabA[5][2], 0, 0, 16, 16, 0x0026200A); close
	_GDIPlus_ImageDispose($SKN5)
	$ImgSA5[0] = _GDIPlus_BitmapCloneArea($SKN5a, 298, 634, 143, 27, 0x0026200A)
	$ImgSA5[1] = _GDIPlus_BitmapCloneArea($SKN5a, 442, 634, 143, 27, 0x0026200A)
	$ImgSA5[2] = _GDIPlus_BitmapCloneArea($SKN5a, 586, 634, 143, 27, 0x0026200A)
	_GDIPlus_ImageDispose($SKN5a)
	$GUI5 = GUICreate("Shortcuts", 353, 387, -1, -1, 0x80000000 + 0x00020000, 0x00080000, $GUI2)
	If $CMPLD = 0 Then GUISetIcon(@ScriptDir & "\Resources\Icon.ico")
	; DRAG LABELS designed to avoid buttons
	GUICtrlCreateLabel("", 8, 7, 280, 37, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 287, 35, 53, 9, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 8, 43, 10, 330, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 330, 43, 10, 330, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 17, 333, 86, 40, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 254, 333, 76, 40, -1, 0x00100000); drag label
	$hGr15 = _GDIPlus_GraphicsCreateFromHWND(_WinAPI_GetDesktopWindow())
	$hBmp5 = _GDIPlus_BitmapCreateFromGraphics(353, 387, $hGr15)
	$hGr25 = _GDIPlus_ImageGetGraphicsContext($hBmp5)
	_GDIPlus_GraphicsDrawImageRect($hGr25, $sBG5, 0, 0, 353, 387)
	_GDIPlus_GraphicsDrawString_($hGr25, "Shortcuts", 34, 10, "Comic Sans MS", 12, "86b2e7")
	_GDIPlus_GraphicsDrawString_($hGr25, "Next Song", 28, 52, "Tahoma", 10);, "86b2e7")
	_GDIPlus_GraphicsDrawString_($hGr25, "Modifiers", 165, 64, "Tahoma", 9, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "Control", 114, 93, "Tahoma", 9);, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "Alt", 194, 93, "Tahoma", 9);, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "Shift", 254, 93, "Tahoma", 9);, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "Key", 182, 118, "Tahoma", 9);, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "Previous Song", 28, 172, "Tahoma", 10);, "86b2e7")
	_GDIPlus_GraphicsDrawString_($hGr25, "Modifiers", 165, 184, "Tahoma", 9, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "Control", 114, 213, "Tahoma", 9);, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "Alt", 194, 213, "Tahoma", 9);, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "Shift", 254, 213, "Tahoma", 9);, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "Key", 182, 238, "Tahoma", 9);, "2233ff")
	_GDIPlus_GraphicsDrawString_($hGr25, "You must set new shortcuts in order to proceed.", 28, 302, "Tahoma", 10, "ff0000")
	_GDIPlus_GraphicsDispose($hGr25)
	_GDIPlus_GraphicsDispose($hGr15)
	SetBmp($GUI5, $hBmp5)
	_GDIPlus_BitmapDispose($hBmp5)
	_GDIPlus_ImageDispose($sBG5)
	;TO RESTORE MINIMIZE AND EXIT BUTTON, UNCOMMENT THESE LINES AND SET THE SECOND LINE IN THE WHILE LOOP TO THIS: For $i = 1 To 3
	;$PosAS5[1][0] = GUICtrlCreateLabel("", 292, 14, 16, 16); minimize button
	;$PosAS5[2][0] = GUICtrlCreateLabel("", 317, 14, 16, 16); close button
	$PosAS5[3][0] = GUICtrlCreateLabel("", 107, 340, 143, 27); previous button
	For $i = 1 To 3
		$PosAS5[$i][1] = 0; state
	Next
	;TO RESTORE MINIMIZE AND EXIT BUTTON, UNCOMMENT THESE LINES AND SET THE SECOND LINE IN THE WHILE LOOP TO THIS: For $i = 1 To 3
	$Win5[1] = "";GUICreate("", 16, 16, 295, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI5)
	;SetBmp($Win5[1], $TabA5[1][0]); minimize
	$Win5[2] = "";GUICreate("", 16, 16, 320, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI5)
	;SetBmp($Win5[2], $TabA5[2][0]); exit
	$Win5[3] = GUICreate("", 143, 27, 110, 344, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI5)
	DrawImg($TabA5, 3, $ImgSA5, "Submit", 143, 27, 44, 1, "Comic Sans MS", 11)
	SetBmp($Win5[3], $TabA5[3][0]); button
	_GDIPlus_ImageDispose($ImgSA5[0])
	_GDIPlus_ImageDispose($ImgSA5[1])
	_GDIPlus_ImageDispose($ImgSA5[2])
	$CGUI5 = GUICreate("", 353, 387, -1, -1, 0x80000000, 0x00080000, $GUI5)
	GUISetBkColor(0x123456, $CGUI5)
	If $CMPLD = 1 Then
		GUICtrlCreateIcon(@ScriptFullPath, -1, 16, 14, 16, 16)
	Else
		GUICtrlCreateIcon(@ScriptDir & "\Resources\Icon.ico", 0, 16, 14, 16, 16)
	EndIf
	GuiCtrlCreateGroup("                                                       ", 92,65,200,100)
	$NextControlModifier = GuiCtrlCreateRadio("             ", 100,90,60)
	$NextAltModifier = GuiCtrlCreateRadio("             ", 180,90,60)
	$NextShiftModifier = GuiCtrlCreateRadio("             ", 240,90,50)
	$SetNextSongHotkey = GuiCtrlCreateInput("",157,140,80,20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GuiCtrlCreateGroup("                                                        ", 92,185,200,100)
	$PreviousControlModifier = GuiCtrlCreateRadio("             ", 100,210,60)
	$PreviousAltModifier = GuiCtrlCreateRadio("             ", 180,210,60)
	$PreviousShiftModifier = GuiCtrlCreateRadio("             ", 240,210,50)
	$SetPreviousSongHotkey = GuiCtrlCreateInput("",157,260,80,20)
	_WinAPI_SetLayeredWindowAttributes($CGUI5, 0x123456, 255)
	ShowHideGUI(5, 1)
	RedMem()
	While 1
		;TO RESTORE MINIMIZE AND EXIT BUTTON, SET THE NEXT LINE TO THIS: For $i = 1 To 3
		MLoop(5, 3, 3, $GUI5, $PosAS5, $Win5, $TabA5)
		If $exiter = 1 Then ExitLoop
		Sleep(10)
	WEnd
	ShowHideGUI(5, 0)
	For $i = 1 To 3
		GUIDelete($Win5[$i])
	Next
	GUIDelete($CGUI5)
	GUIDelete($GUI5)
	For $i = 1 To 3
		_GDIPlus_ImageDispose($TabA5[$i][0])
		_GDIPlus_ImageDispose($TabA5[$i][1])
		_GDIPlus_ImageDispose($TabA5[$i][2])
	Next
	$CurrentGui = 4
	ShowHideGUI(4, 1)
	RedMem()
	$exiter = 0
EndFunc   ;==>_Shortcuts

Func _SetHotKeys()
	$ControlModifierCheck = GuiCtrlRead($NextControlModifier)
	$AltModifierCheck = GuiCtrlRead($NextAltModifier)
	$ShiftModifierCheck = GuiCtrlRead($NextShiftModifier)
	$NextSongHotKey = GuiCtrlRead($SetNextSongHotkey)
	Select
		Case $ControlModifierCheck = 1
			$NextModifier = "^"
		Case $AltModifierCheck = 1
			$NextModifier = "!"
		Case $ShiftModifierCheck = 1
			$NextModifier = "+"
		Case Else
			$NextModifier = ""
	EndSelect
	$ControlModifierCheck = GuiCtrlRead($PreviousControlModifier)
	$AltModifierCheck = GuiCtrlRead($PreviousAltModifier)
	$ShiftModifierCheck = GuiCtrlRead($PreviousShiftModifier)
	$PreviousSongHotKey = GuiCtrlRead($SetPreviousSongHotkey)
	Select
		Case $ControlModifierCheck = 1
			$PreviousModifier = "^"
		Case $AltModifierCheck = 1
			$PreviousModifier = "!"
		Case $ShiftModifierCheck = 1
			$PreviousModifier = "+"
		Case Else
			$PreviousModifier = ""
	EndSelect
	$KeepNextSongHotKey = $NextModifier & $NextSongHotkey
	$KeepPreviousSongHotKey = $PreviousModifier & $PreviousSongHotkey
	HotKeySet($KeepNextSongHotkey, "_NextSong")
	HotKeySet($KeepPreviousSongHotkey, "_PreviousSong")
	IniWrite("Playlists.ini", "Hotkeys", "Next", $KeepNextSongHotkey)
	IniWrite("Playlists.ini", "Hotkeys", "Previous", $KeepPreviousSongHotkey)
EndFunc   ;==>_SetHotKeys

Func _RemoveSong()
	If $CurrentPlayList = "" Then
		MsgBoxGUI("Error", "Please select a playlist before removing" & @CRLF & "songs.")
		_ViewPlayLists()
		Return
	EndIf
	ShowHideGUI(1, 0)
	$CurrentGui = 3
	Local $PosAS4[4][2], $TabA4[4][3], $ImgSA4[3]
	If $CMPLD = 1 Then
		$SKN4a = _ResourceGetAsImage("SKIN")
		$SKN4 = _ResourceGetAsImage("SKIN3")
	Else
		$SKN4a = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin.png")
		$SKN4 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin3.png")
	EndIf
	$sBG4 = _GDIPlus_BitmapCloneArea($SKN4, 1, 1, 353, 387, 0x0026200A)
	$TabA4[1][0] = _GDIPlus_BitmapCloneArea($TabA[4][0], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA4[1][1] = _GDIPlus_BitmapCloneArea($TabA[4][1], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA4[1][2] = _GDIPlus_BitmapCloneArea($TabA[4][2], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA4[2][0] = _GDIPlus_BitmapCloneArea($TabA[5][0], 0, 0, 16, 16, 0x0026200A); close
	$TabA4[2][1] = _GDIPlus_BitmapCloneArea($TabA[5][1], 0, 0, 16, 16, 0x0026200A); close
	$TabA4[2][2] = _GDIPlus_BitmapCloneArea($TabA[5][2], 0, 0, 16, 16, 0x0026200A); close
	_GDIPlus_ImageDispose($SKN4)
	$ImgSA4[0] = _GDIPlus_BitmapCloneArea($SKN4a, 298, 634, 143, 27, 0x0026200A)
	$ImgSA4[1] = _GDIPlus_BitmapCloneArea($SKN4a, 442, 634, 143, 27, 0x0026200A)
	$ImgSA4[2] = _GDIPlus_BitmapCloneArea($SKN4a, 586, 634, 143, 27, 0x0026200A)
	_GDIPlus_ImageDispose($SKN4a)
	$GUI4 = GUICreate("Remove Song", 353, 387, -1, -1, 0x80000000 + 0x00020000, 0x00080000)
	If $CMPLD = 0 Then GUISetIcon(@ScriptDir & "\Resources\Icon.ico")
	; DRAG LABELS designed to avoid buttons
	GUICtrlCreateLabel("", 8, 7, 280, 37, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 287, 35, 53, 9, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 8, 43, 10, 330, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 330, 43, 10, 330, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 17, 333, 86, 40, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 254, 333, 76, 40, -1, 0x00100000); drag label
	$hGr14 = _GDIPlus_GraphicsCreateFromHWND(_WinAPI_GetDesktopWindow())
	$hBmp4 = _GDIPlus_BitmapCreateFromGraphics(353, 387, $hGr14)
	$hGr24 = _GDIPlus_ImageGetGraphicsContext($hBmp4)
	_GDIPlus_GraphicsDrawImageRect($hGr24, $sBG4, 0, 0, 353, 387)
	_GDIPlus_GraphicsDrawString_($hGr24, "Remove Song", 34, 10, "Comic Sans MS", 12, "86b2e7")
	_GDIPlus_GraphicsDispose($hGr24)
	_GDIPlus_GraphicsDispose($hGr14)
	SetBmp($GUI4, $hBmp4)
	_GDIPlus_BitmapDispose($hBmp4)
	_GDIPlus_ImageDispose($sBG4)
	$PosAS4[1][0] = GUICtrlCreateLabel("", 292, 14, 16, 16); minimize button
	$PosAS4[2][0] = GUICtrlCreateLabel("", 317, 14, 16, 16); close button
	$PosAS4[3][0] = GUICtrlCreateLabel("", 107, 340, 143, 27); previous button
	For $i = 1 To 3
		$PosAS4[$i][1] = 0; state
	Next
	$Win4[1] = GUICreate("", 16, 16, 295, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI4)
	SetBmp($Win4[1], $TabA4[1][0]); minimize
	$Win4[2] = GUICreate("", 16, 16, 320, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI4)
	SetBmp($Win4[2], $TabA4[2][0]); exit
	$Win4[3] = GUICreate("", 143, 27, 110, 344, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI4)
	DrawImg($TabA4, 3, $ImgSA4, "Remove Song", 143, 27, 26, 1, "Comic Sans MS", 11)
	SetBmp($Win4[3], $TabA4[3][0]); button
	_GDIPlus_ImageDispose($ImgSA4[0])
	_GDIPlus_ImageDispose($ImgSA4[1])
	_GDIPlus_ImageDispose($ImgSA4[2])
	$CGUI4 = GUICreate("", 353, 387, -1, -1, 0x80000000, 0x00080000, $GUI4)
	GUISetBkColor(0x123456, $CGUI4)
	If $CMPLD = 1 Then
		GUICtrlCreateIcon(@ScriptFullPath, -1, 16, 14, 16, 16)
	Else
		GUICtrlCreateIcon(@ScriptDir & "\Resources\Icon.ico", 0, 16, 14, 16, 16)
	EndIf
	$RemoveSongList = GUICtrlCreateList("", 24, 50, 300, 280, BitOR($WS_BORDER, $WS_VSCROLL))
	$SongList = IniReadSection("Playlists.ini", $CurrentPlayList)
	For $i = 2 To $SongList[0][0]
		GUICtrlSetData($RemoveSongList, $SongList[$i][0])
	Next
	_GUICtrlListBox_SetCurSel($RemoveSongList, 0)
	_WinAPI_SetLayeredWindowAttributes($CGUI4, 0x123456, 255)
	ShowHideGUI(4, 1)
	RedMem()
	While 1
		MLoop(4, 1, 3, $GUI4, $PosAS4, $Win4, $TabA4)
		If $exiter = 1 Then ExitLoop
		Sleep(10)
	WEnd
	ShowHideGUI(4, 0)
	For $i = 1 To 3
		GUIDelete($Win4[$i])
	Next
	GUIDelete($CGUI4)
	GUIDelete($GUI4)
	For $i = 1 To 3
		_GDIPlus_ImageDispose($TabA4[$i][0])
		_GDIPlus_ImageDispose($TabA4[$i][1])
		_GDIPlus_ImageDispose($TabA4[$i][2])
	Next
	$CurrentGui = 1
	ShowHideGUI(1, 1)
	RedMem()
	$exiter = 0
EndFunc   ;==>_RemoveSong

Func _ViewPlayLists()
	ShowHideGUI(1, 0)
	$CurrentGui = 2
	Local $TabA3[5][3], $PosAS3[5][2], $ImgSA3[3]
	If $CMPLD = 1 Then
		$SKN3a = _ResourceGetAsImage("SKIN")
		$SKN3 = _ResourceGetAsImage("SKIN3")
	Else
		$SKN3a = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin.png")
		$SKN3 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin3.png")
	EndIf
	$sBG3 = _GDIPlus_BitmapCloneArea($SKN3, 1, 1, 353, 387, 0x0026200A)
	$TabA3[1][0] = _GDIPlus_BitmapCloneArea($TabA[4][0], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA3[1][1] = _GDIPlus_BitmapCloneArea($TabA[4][1], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA3[1][2] = _GDIPlus_BitmapCloneArea($TabA[4][2], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA3[2][0] = _GDIPlus_BitmapCloneArea($TabA[5][0], 0, 0, 16, 16, 0x0026200A); close
	$TabA3[2][1] = _GDIPlus_BitmapCloneArea($TabA[5][1], 0, 0, 16, 16, 0x0026200A); close
	$TabA3[2][2] = _GDIPlus_BitmapCloneArea($TabA[5][2], 0, 0, 16, 16, 0x0026200A); close
	_GDIPlus_ImageDispose($SKN3)
	$ImgSA3[0] = _GDIPlus_BitmapCloneArea($SKN3a, 298, 634, 143, 27, 0x0026200A)
	$ImgSA3[1] = _GDIPlus_BitmapCloneArea($SKN3a, 442, 634, 143, 27, 0x0026200A)
	$ImgSA3[2] = _GDIPlus_BitmapCloneArea($SKN3a, 586, 634, 143, 27, 0x0026200A)
	_GDIPlus_ImageDispose($SKN3a)
	$GUI3 = GUICreate("View Playlists", 353, 387, -1, -1, 0x80000000 + 0x00020000, 0x00080000)
	If $CMPLD = 0 Then GUISetIcon(@ScriptDir & "\Resources\Icon.ico")
	; DRAG LABELS designed to avoid buttons
	GUICtrlCreateLabel("", 8, 7, 280, 37, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 287, 35, 53, 9, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 8, 43, 10, 330, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 330, 43, 10, 330, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 17, 333, 7, 40, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 324, 333, 7, 40, -1, 0x00100000); drag label
	$hGr13 = _GDIPlus_GraphicsCreateFromHWND(_WinAPI_GetDesktopWindow())
	$hBmp3 = _GDIPlus_BitmapCreateFromGraphics(353, 387, $hGr13)
	$hGr23 = _GDIPlus_ImageGetGraphicsContext($hBmp3)
	_GDIPlus_GraphicsDrawImageRect($hGr23, $sBG3, 0, 0, 353, 387)
	_GDIPlus_GraphicsDrawString_($hGr23, "View Playlists", 36, 10, "Comic Sans MS", 12, "86b2e7")
	_GDIPlus_GraphicsDispose($hGr23)
	_GDIPlus_GraphicsDispose($hGr13)
	SetBmp($GUI3, $hBmp3)
	_GDIPlus_BitmapDispose($hBmp3)
	_GDIPlus_ImageDispose($sBG3)
	$PosAS3[1][0] = GUICtrlCreateLabel("", 292, 14, 16, 16); minimize button
	$PosAS3[2][0] = GUICtrlCreateLabel("", 317, 14, 16, 16); close button
	$PosAS3[3][0] = GUICtrlCreateLabel("", 27, 340, 143, 27); previous button
	$PosAS3[4][0] = GUICtrlCreateLabel("", 177, 340, 143, 27)
	For $i = 1 To 4
		$PosAS3[$i][1] = 0; state
	Next
	$Win3[1] = GUICreate("", 16, 16, 295, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI3)
	SetBmp($Win3[1], $TabA3[1][0]); minimize
	$Win3[2] = GUICreate("", 16, 16, 320, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI3)
	SetBmp($Win3[2], $TabA3[2][0]); exit
	$Win3[3] = GUICreate("", 143, 27, 30, 344, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI3)
	DrawImg($TabA3, 3, $ImgSA3, "Load Playlist", 143, 27, 26, 1, "Comic Sans MS", 11)
	SetBmp($Win3[3], $TabA3[3][0]); button
	$Win3[4] = GUICreate("", 143, 27, 180, 344, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI3)
	DrawImg($TabA3, 4, $ImgSA3, "Remove Playlist", 143, 27, 16, 1, "Comic Sans MS", 11)
	SetBmp($Win3[4], $TabA3[4][0]); button
	_GDIPlus_ImageDispose($ImgSA3[0])
	_GDIPlus_ImageDispose($ImgSA3[1])
	_GDIPlus_ImageDispose($ImgSA3[2])
	$CGUI3 = GUICreate("", 353, 387, -1, -1, 0x80000000, 0x00080000, $GUI3)
	GUISetBkColor(0x123456, $CGUI3)
	If $CMPLD = 1 Then
		GUICtrlCreateIcon(@ScriptFullPath, -1, 16, 14, 16, 16)
	Else
		GUICtrlCreateIcon(@ScriptDir & "\Resources\Icon.ico", 0, 16, 14, 16, 16)
	EndIf
	$PlayListListBox = GUICtrlCreateList("", 24, 50, 300, 280, BitOR($WS_BORDER, $WS_VSCROLL))
	$PlayListNames = IniReadSectionNames("Playlists.ini")
	For $i = 4 To $PlayListNames[0]
		GUICtrlSetData($PlayListListBox, $PlayListNames[$i])
	Next
	_GUICtrlListBox_SetCurSel($PlayListListBox, 0)
	_WinAPI_SetLayeredWindowAttributes($CGUI3, 0x123456, 255)
	ShowHideGUI(3, 1)
	RedMem()
	While 1
		MLoop(3, 1, 4, $GUI3, $PosAS3, $Win3, $TabA3)
		If $exiter = 1 Then ExitLoop
		Sleep(10)
	WEnd
	ShowHideGUI(3, 0)
	For $i = 1 To 4
		GUIDelete($Win3[$i])
	Next
	GUIDelete($CGUI3)
	GUIDelete($GUI3)
	For $i = 1 To 4
		_GDIPlus_ImageDispose($TabA3[$i][0])
		_GDIPlus_ImageDispose($TabA3[$i][1])
		_GDIPlus_ImageDispose($TabA3[$i][2])
	Next
	$CurrentGui = 1
	ShowHideGUI(1, 1)
	RedMem()
	$exiter = 0
EndFunc   ;==>_ViewPlayLists

Func _PlayPlayList()
	If $CurrentPlayList = "" Then
		MsgBoxGUI("Error", "Please load a playlist before attempting" & @CRLF & "to play one.")
		_ViewPlayLists()
		Return
	EndIf
	_IENavigate($EmbedIE, "about:blank", 0); prevent main gui from playing at the same time as the playlist gui
	ShowHideGUI(1, 0)
	$CurrentGui = 4
	Local $PosAS2[7][2], $TabA2[7][3], $ImgSA2[3]
	If $CMPLD = 1 Then
		$SKN2a = _ResourceGetAsImage("SKIN")
		$SKN2 = _ResourceGetAsImage("SKIN2")
	Else
		$SKN2a = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin.png")
		$SKN2 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Resources\Skin2.png")
	EndIf
	$sBG2 = _GDIPlus_BitmapCloneArea($SKN2, 1, 1, 879, 632, 0x0026200A)
	$TabA2[1][0] = _GDIPlus_BitmapCloneArea($TabA[4][0], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA2[1][1] = _GDIPlus_BitmapCloneArea($TabA[4][1], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA2[1][2] = _GDIPlus_BitmapCloneArea($TabA[4][2], 0, 0, 16, 16, 0x0026200A); minimize
	$TabA2[2][0] = _GDIPlus_BitmapCloneArea($TabA[5][0], 0, 0, 16, 16, 0x0026200A); close
	$TabA2[2][1] = _GDIPlus_BitmapCloneArea($TabA[5][1], 0, 0, 16, 16, 0x0026200A); close
	$TabA2[2][2] = _GDIPlus_BitmapCloneArea($TabA[5][2], 0, 0, 16, 16, 0x0026200A); close
	$TabA2[3][0] = _GDIPlus_BitmapCloneArea($SKN2, 1, 634, 83, 52, 0x0026200A); previous
	$TabA2[3][1] = _GDIPlus_BitmapCloneArea($SKN2, 85, 634, 83, 52, 0x0026200A); previous
	$TabA2[3][2] = _GDIPlus_BitmapCloneArea($SKN2, 169, 634, 83, 52, 0x0026200A); previous
	$TabA2[4][0] = _GDIPlus_BitmapCloneArea($SKN2, 253, 634, 83, 52, 0x0026200A); play
	$TabA2[4][1] = _GDIPlus_BitmapCloneArea($SKN2, 337, 634, 83, 52, 0x0026200A); play
	$TabA2[4][2] = _GDIPlus_BitmapCloneArea($SKN2, 421, 634, 83, 52, 0x0026200A); play
	$TabA2[5][0] = _GDIPlus_BitmapCloneArea($SKN2, 505, 634, 83, 52, 0x0026200A); next
	$TabA2[5][1] = _GDIPlus_BitmapCloneArea($SKN2, 589, 634, 83, 52, 0x0026200A); next
	$TabA2[5][2] = _GDIPlus_BitmapCloneArea($SKN2, 673, 634, 83, 52, 0x0026200A); next
	_GDIPlus_ImageDispose($SKN2)
	$ImgSA2[0] = _GDIPlus_BitmapCloneArea($SKN2a, 298, 634, 143, 27, 0x0026200A)
	$ImgSA2[1] = _GDIPlus_BitmapCloneArea($SKN2a, 442, 634, 143, 27, 0x0026200A)
	$ImgSA2[2] = _GDIPlus_BitmapCloneArea($SKN2a, 586, 634, 143, 27, 0x0026200A)
	_GDIPlus_ImageDispose($SKN2a)
	$GUI2 = GUICreate("Play Playlist", 879, 632, -1, -1, 0x80000000 + 0x00020000, 0x00080000)
	If $CMPLD = 0 Then GUISetIcon(@ScriptDir & "\Resources\Icon.ico")
	; DRAG LABELS designed to avoid buttons
	GUICtrlCreateLabel("", 8, 7, 805, 36, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 855, 42, 11, 576, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 812, 35, 54, 8, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 8, 42, 11, 576, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 18, 528, 838, 17, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 292, 544, 20, 58, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 401, 544, 20, 58, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 510, 544, 191, 58, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 700, 544, 156, 12, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 700, 592, 156, 10, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 18, 601, 838, 17, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 688, 42, 11, 487, -1, 0x00100000); drag label
	GUICtrlCreateLabel("", 18, 544, 185, 58, -1, 0x00100000); drag label
	$hGr12 = _GDIPlus_GraphicsCreateFromHWND(_WinAPI_GetDesktopWindow())
	$hBmp2 = _GDIPlus_BitmapCreateFromGraphics(879, 632, $hGr12)
	$hGr22 = _GDIPlus_ImageGetGraphicsContext($hBmp2)
	_GDIPlus_GraphicsDrawImageRect($hGr22, $sBG2, 0, 0, 879, 632)
	_GDIPlus_GraphicsDrawString_($hGr22, "Play Playlist", 36, 10, "Comic Sans MS", 12, "86b2e7")
	_GDIPlus_GraphicsDispose($hGr22)
	_GDIPlus_GraphicsDispose($hGr12)
	SetBmp($GUI2, $hBmp2)
	_GDIPlus_BitmapDispose($hBmp2)
	_GDIPlus_ImageDispose($sBG2)
	$PosAS2[1][0] = GUICtrlCreateLabel("", 818, 14, 16, 16); minimize button
	$PosAS2[2][0] = GUICtrlCreateLabel("", 843, 14, 16, 16); close button
	$PosAS2[3][0] = GUICtrlCreateLabel("", 206, 547, 83, 52); previous button
	$PosAS2[4][0] = GUICtrlCreateLabel("", 315, 547, 83, 52); play button
	$PosAS2[5][0] = GUICtrlCreateLabel("", 424, 547, 83, 52); next button
	$PosAS2[6][0] = GUICtrlCreateLabel("", 707, 561, 143, 27)
	For $i = 1 To 6
		$PosAS2[$i][1] = 0; state
	Next
	$Win2[1] = GUICreate("", 16, 16, 821, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI2)
	SetBmp($Win2[1], $TabA2[1][0]); minimize
	$Win2[2] = GUICreate("", 16, 16, 846, 17, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI2)
	SetBmp($Win2[2], $TabA2[2][0]); exit
	$Win2[3] = GUICreate("", 83, 52, 209, 550, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI2)
	SetBmp($Win2[3], $TabA2[3][0]); previous
	$Win2[4] = GUICreate("", 83, 52, 318, 550, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI2)
	SetBmp($Win2[4], $TabA2[4][0]); play
	$Win2[5] = GUICreate("", 83, 52, 427, 550, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI2)
	SetBmp($Win2[5], $TabA2[5][0]); next
	$Win2[6] = GUICreate("", 143, 27, 710, 565, 0x80000000, BitOR(0x00080000, 0x00000040, 0x08000000), $GUI2)
	DrawImg($TabA2, 6, $ImgSA2, "Set Shortcuts", 143, 27, 19, 1, "Comic Sans MS", 11)
	SetBmp($Win2[6], $TabA2[6][0]); button
	_GDIPlus_ImageDispose($ImgSA2[0])
	_GDIPlus_ImageDispose($ImgSA2[1])
	_GDIPlus_ImageDispose($ImgSA2[2])
	$CGUI2 = GUICreate("", 879, 632, -1, -1, 0x80000000, 0x00080000, $GUI2)
	GUISetBkColor(0x123456, $CGUI2)
	If $CMPLD = 1 Then
		GUICtrlCreateIcon(@ScriptFullPath, -1, 16, 14, 16, 16)
	Else
		GUICtrlCreateIcon(@ScriptDir & "\Resources\Icon.ico", 0, 16, 14, 16, 16)
	EndIf
	$EmbedIE2 = _IECreateEmbedded()
	$GUIActiveX2 = GUICtrlCreateObj($EmbedIE2, 24, 50, 658, 473)
	_IENavigate($EmbedIE2, "about:blank")
	$oBody = _IETagNameGetCollection($EmbedIE2, "body", 0)
	_IEDocInsertHTML($oBody, "<br><br><br><br><br><br><br><br><br><br><br><center><font color='#555555' size='+1'><b>Select song from the list and then press play!</b></font></center>")
	$PlayListView = GUICtrlCreateList("", 704, 49, 148, 474, BitOR($WS_BORDER, $WS_VSCROLL))
	For $i = 0 To $PlayListSongs[0][0]
		GUICtrlSetData($PlayListView, $PlayListSongs[$i][0])
	Next
	_GUICtrlListBox_SetCurSel($PlayListView, 0)
	_WinAPI_SetLayeredWindowAttributes($CGUI2, 0x123456, 255)
	ShowHideGUI(2, 1)
	RedMem()
	While 1
		MLoop(2, 1, 6, $GUI2, $PosAS2, $Win2, $TabA2)
		If $exiter = 1 Then ExitLoop
		Sleep(10)
	WEnd
	ShowHideGUI(2, 0)
	For $i = 1 To 6
		GUIDelete($Win2[$i])
	Next
	GUIDelete($CGUI2)
	GUIDelete($GUI2)
	For $i = 1 To 6
		_GDIPlus_ImageDispose($TabA2[$i][0])
		_GDIPlus_ImageDispose($TabA2[$i][1])
		_GDIPlus_ImageDispose($TabA2[$i][2])
	Next
	$CurrentGui = 1
	ShowHideGUI(1, 1)
	_IENavigate($EmbedIE, "http://www.YouTube.com", 0)
	RedMem()
	$exiter = 0
EndFunc   ;==>_PlayPlayList

Func ShowHideGUI($var1, $var)
	Switch $var1
		Case 1
			If $var = 0 Then
				For $j = 1 To 10
					GUISetState(@SW_HIDE, $Win[$j])
				Next
				GUISetState(@SW_HIDE, $CGUI)
				GUISetState(@SW_HIDE, $GUI)
			Else
				GUISetState(@SW_SHOW, $GUI)
				GUISetState(@SW_SHOW, $CGUI)
				For $j = 1 To 10
					GUISetState(@SW_SHOW, $Win[$j])
				Next
			EndIf
		Case 2
			If $var = 0 Then
				For $i = 1 To 6
					GUISetState(@SW_HIDE, $Win2[$i])
				Next
				GUISetState(@SW_HIDE, $CGUI2)
				GUISetState(@SW_HIDE, $GUI2)
			Else
				GUISetState(@SW_SHOW, $GUI2)
				GUISetState(@SW_SHOW, $CGUI2)
				For $i = 1 To 6
					GUISetState(@SW_SHOW, $Win2[$i])
				Next
			EndIf
		Case 3
			If $var = 0 Then
				For $i = 1 To 4
					GUISetState(@SW_HIDE, $Win3[$i])
				Next
				GUISetState(@SW_HIDE, $CGUI3)
				GUISetState(@SW_HIDE, $GUI3)
			Else
				GUISetState(@SW_SHOW, $GUI3)
				GUISetState(@SW_SHOW, $CGUI3)
				For $i = 1 To 4
					GUISetState(@SW_SHOW, $Win3[$i])
				Next
			EndIf
		Case 4
			If $var = 0 Then
				For $i = 1 To 3
					GUISetState(@SW_HIDE, $Win4[$i])
				Next
				GUISetState(@SW_HIDE, $CGUI4)
				GUISetState(@SW_HIDE, $GUI4)
			Else
				GUISetState(@SW_SHOW, $GUI4)
				GUISetState(@SW_SHOW, $CGUI4)
				For $i = 1 To 3
					GUISetState(@SW_SHOW, $Win4[$i])
				Next
			EndIf
		Case 5
			If $var = 0 Then
				For $i = 1 To 3
					GUISetState(@SW_HIDE, $Win5[$i])
				Next
				GUISetState(@SW_HIDE, $CGUI5)
				GUISetState(@SW_HIDE, $GUI5)
			Else
				GUISetState(@SW_SHOW, $GUI5)
				GUISetState(@SW_SHOW, $CGUI5)
				For $i = 1 To 3
					GUISetState(@SW_SHOW, $Win5[$i])
				Next
			EndIf
		Case 6
			If $var = 0 Then
				For $i = 1 To 4
					GUISetState(@SW_HIDE, $Win6[$i])
				Next
				GUISetState(@SW_HIDE, $CGUI6)
				GUISetState(@SW_HIDE, $GUI6)
			Else
				GUISetState(@SW_SHOW, $GUI6)
				GUISetState(@SW_SHOW, $CGUI6)
				For $i = 1 To 4
					GUISetState(@SW_SHOW, $Win6[$i])
				Next
			EndIf
		Case 7
			If $var = 0 Then
				For $i = 1 To 3
					GUISetState(@SW_HIDE, $Win7[$i])
				Next
				GUISetState(@SW_HIDE, $CGUI7)
				GUISetState(@SW_HIDE, $GUI7)
			Else
				GUISetState(@SW_SHOW, $GUI7)
				GUISetState(@SW_SHOW, $CGUI7)
				For $i = 1 To 3
					GUISetState(@SW_SHOW, $Win7[$i])
				Next
			EndIf
	EndSwitch
EndFunc   ;==>ShowHideGUI

Func _DeleteSong()
	$SongToRemove = GUICtrlRead($RemoveSongList)
	If $SongToRemove = "" Then
		MsgBoxGUI("Error", "Please select a song to remove.")
		Return
	EndIf
	IniDelete("Playlists.ini", $CurrentPlayList, $SongToRemove)
	MsgBoxGUI("Song Removed", "The song has been removed.")
	_OpenPlayList()
EndFunc   ;==>_DeleteSong

Func _OpenPlayList()
	If $CurrentGui = 2 Then
		$CurrentPlayList = GUICtrlRead($PlayListListBox)
		If $CurrentPlayList = "" Then
			MsgBoxGUI("Error", "Please select a playlist to load.")
			Return
		EndIf
		$PlayListSongs = IniReadSection("Playlists.ini", $CurrentPlayList)
	Else
		$PlayListSongs = IniReadSection("Playlists.ini", $CurrentPlayList)
	EndIf
EndFunc   ;==>_OpenPlayList

Func _RemovePlayList()
	$CurrentPlayList = GUICtrlRead($PlayListListBox)
	If $CurrentPlayList = "" Then
		MsgBoxGUI("Error", "Please select a playlist to remove.")
		Return
	EndIf
	IniDelete("Playlists.ini", $CurrentPlayList)
	GUICtrlSetData($PlayListListBox, "")
	$PlayListNames = IniReadSectionNames("Playlists.ini")
	For $i = 4 To $PlayListNames[0]
		GUICtrlSetData($PlayListListBox, $PlayListNames[$i])
	Next
	_GUICtrlListBox_SetCurSel($PlayListListBox, 0)
	$PlayLists = IniReadSectionNames("Playlists.ini")
	$CurrentPlayList = $PlayLists[1]
EndFunc   ;==>_RemovePlayList

Func _PlaySong()
	$PlaySong = GUICtrlRead($PlayListView)
	$UrlOfSong = IniRead("Playlists.ini", $CurrentPlayList, $PlaySong, "Error")
	_IENavigate($EmbedIE2, $UrlOfSong, 0)
EndFunc   ;==>_PlaySong

Func _NextSong()
	If Not WinExists("Play Playlist") Then Return
	$PlayListSongNames = IniReadSection("Playlists.ini", $CurrentPlayList)
	For $i = 0 To $PlayListSongNames[0][0]
		If $PlayListSongNames[$i][0] = $PlaySong Then
			If $i + 1 > $PlayListSongNames[0][0] Then
				_IENavigate($EmbedIE2, "about:blank")
				$oBody = _IETagNameGetCollection($EmbedIE2, "body", 0)
				_IEDocInsertHTML($oBody, "<br><br><br><br><br><br><br><br><br><br><br><center><font color='#555555' size='+1'><b>You have reached the end of the playlist!</b></font></center>")
				ExitLoop
			Else
				$NewSong = $PlayListSongNames[$i + 1][0]
				$UrlOfSong = IniRead("Playlists.ini", $CurrentPlayList, $NewSong, "Error")
				_IENavigate($EmbedIE2, $UrlOfSong, 0)
				$PlaySong = $NewSong
				_GUICtrlListBox_SetCurSel($PlayListView, _GUICtrlListBox_GetCurSel($PlayListView) + 1)
				ExitLoop
			EndIf
		Else
			Sleep(5)
		EndIf
	Next
EndFunc   ;==>_NextSong

Func _PreviousSong()
	If Not WinExists("Play Playlist") Then Return
	If $PlaySong = "" Then
		MsgBoxGUI("Error", "Please start the playlist before" & @CRLF & "attempting to use the controls")
		Return
	EndIf
	$PlayListSongNames = IniReadSection("Playlists.ini", $CurrentPlayList)
	For $i = 0 To $PlayListSongNames[0][0]
		If $PlayListSongNames[$i][0] = $PlaySong Then
			If $i - 1 = 1 Then
				_IENavigate($EmbedIE2, "about:blank")
				$oBody = _IETagNameGetCollection($EmbedIE2, "body", 0)
				_IEDocInsertHTML($oBody, "<br><br><br><br><br><br><br><br><br><br><br><center><font color='#555555' size='+1'><b>You have reached the beginning of the playlist!</b></font></center>")
				ExitLoop
			Else
				$NewSong = $PlayListSongNames[$i - 1][0]
				$UrlOfSong = IniRead("Playlists.ini", $CurrentPlayList, $NewSong, "Error")
				_IENavigate($EmbedIE2, $UrlOfSong, 0)
				$PlaySong = $NewSong
				_GUICtrlListBox_SetCurSel($PlayListView, _GUICtrlListBox_GetCurSel($PlayListView) - 1)
				ExitLoop
			EndIf
		Else
			Sleep(5)
		EndIf
	Next
EndFunc   ;==>_PreviousSong

Func _AddNewSong()
	If $CurrentPlayList = "" Then
		MsgBoxGUI("Error", "Please load a playlist before adding" & @CRLF & "new songs.")
		_ViewPlayLists()
		Return
	EndIf
	$Url = _IEPropertyGet($EmbedIE, "locationurl")
	$ReadSource = BinaryToString(InetRead($Url))
	$GetSongName = StringRegExp($ReadSource, '(?i)(?s)<title>(.*?)- YouTube', 3)
	If @error Then
		MsgBoxGUI("Error", "An error has occured. Please play" & @CRLF & "a song to add a song.")
		Return
	EndIf
	If StringLeft($GetSongName[0], 1) = " " Or StringLeft($GetSongName[0], 1) = @CRLF Or StringLeft($GetSongName[0], 1) = @CR Or StringLeft($GetSongName[0], 1) = @LF Then
		Do
			$GetSongName[0] = StringTrimLeft($GetSongName[0], 1)
		Until StringLeft($GetSongName[0], 1) <> " " And StringLeft($GetSongName[0], 1) <> @CRLF And StringLeft($GetSongName[0], 1) <> @CR And StringLeft($GetSongName[0], 1) <> @LF
	EndIf
	If StringRight($GetSongName[0], 1) = " " Or StringRight($GetSongName[0], 1) = @CRLF Or StringRight($GetSongName[0], 1) = @CR Or StringRight($GetSongName[0], 1) = @LF Then
		Do
			$GetSongName[0] = StringTrimRight($GetSongName[0], 1)
		Until StringRight($GetSongName[0], 1) <> " " And StringRight($GetSongName[0], 1) <> @CRLF And StringRight($GetSongName[0], 1) <> @CR And StringRight($GetSongName[0], 1) <> @LF
	EndIf
	If StringLen($GetSongName[0]) > 40 Then
		Do
			$GetSongName[0] = StringTrimRight($GetSongName[0], 1)
		Until StringLen($GetSongName[0]) <= 40
	EndIf
	MsgBoxGUI("New Song", "Adding song:" & @CRLF & $GetSongName[0])
	$NewSongName = InputBoxGUI("New song name", "Please enter the name for this" & @CRLF & "song:")
	If $NewSongName = "" Then
		MsgBoxGUI("Error", "Cancelling addition of song.")
		Return
	EndIf
	$CheckForDuplicates = IniReadSection("Playlists.ini", $CurrentPlaylist)
	For $i = 1 To $CheckForDuplicates[0][0]
		If $CheckForDuplicates[$i][0] = $NewSongName Then
			MsgBoxGUI("Error", "There is already a song named:" & @CRLF & $NewSongName & @CRLF & "Please enter new name or remove the existing" & @CRLF & "one and re-create it.", 1)
			ExitLoop
		Else
			If $i = $CheckForDuplicates[0][0] Then
				IniWrite("Playlists.ini", $CurrentPlayList, $NewSongName, $Url)
				MsgBoxGUI("New song added", "The song has been added to the" & @CRLF & "playlist")
				_OpenPlayList()
			Else
				Sleep(10)
			EndIf
		EndIf
	Next
EndFunc   ;==>_AddNewSong

Func _CreateNewPlayList()
	$NewPlayListName = InputBoxGUI("Create new playlist", "What is the name of the new" & @CRLF & "playlist?")
	If $NewPlayListName = "" Then
		MsgBoxGUI("Error", "No name was entered, playlist creation" & @CRLF & "stopped.")
		Return
	EndIf
	$CheckForDuplicates = IniReadSectionNames("Playlists.ini")
	For $i = 1 To $CheckForDuplicates[0]
		If $CheckForDuplicates = $NewPlayListName Then
			MsgBoxGUI("Error", "There is already a playlist named:" & @CRLF & $NewPlayListName & @CRLF & "Please select a new name or remove the existing" & @CRLF & "one and re-create it.", 1)
		Else
			IniWrite("Playlists.ini", $NewPlayListName, "", "")
			$CurrentPlayList = $NewPlayListName
			_OpenPlayList()
		EndIf
	Next
EndFunc   ;==>_CreateNewPlayList

Func CloseAll()
	For $i = 1 To 10
		_GDIPlus_ImageDispose($TabA[$i][0])
		_GDIPlus_ImageDispose($TabA[$i][1])
		_GDIPlus_ImageDispose($TabA[$i][2])
	Next
	IniWrite("Playlists.ini", "Settings", "LastPlaylist", $CurrentPlayList)
	Exit
EndFunc   ;==>CloseAll

Func DrawImg(ByRef $RetA, $indx, $Imgs, $text = "", $ww = 0, $hh = 0, $xx = 0, $yy = 0, $sFont = "Comic Sans MS", $nSize = 10, $ncol = "000000", $iFormat = 0)
	For $i = 0 To 2
		Local $hGr1 = _GDIPlus_GraphicsCreateFromHWND(_WinAPI_GetDesktopWindow())
		Local $hBmp = _GDIPlus_BitmapCreateFromGraphics($ww, $hh, $hGr1)
		Local $hGr2 = _GDIPlus_ImageGetGraphicsContext($hBmp)
		_GDIPlus_GraphicsDrawImageRect($hGr2, $Imgs[$i], 0, 0, $ww, $hh)
		If $text <> "" Then _GDIPlus_GraphicsDrawString_($hGr2, $text, $xx, $yy, $sFont, $nSize, $ncol, $iFormat)
		_GDIPlus_GraphicsDispose($hGr2)
		_GDIPlus_GraphicsDispose($hGr1)
		$RetA[$indx][$i] = $hBmp
	Next
EndFunc   ;==>DrawImg

Func _GDIPlus_GraphicsDrawString_($hGraphics, $sString, $nX, $nY, $sFont = "Comic Sans MS", $nSize = 10, $ncol = "000000", $iFormat = 0); MODIFIED BY PLAYLET
	Local $hBrush = _GDIPlus_BrushCreateSolid("0xFF" & $ncol)
	Local $hFormat = _GDIPlus_StringFormatCreate($iFormat)
	Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $nSize)
	Local $tLayout = _GDIPlus_RectFCreate($nX, $nY, 0, 0)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	Local $aResult = _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
	Local $iError = @error
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	Return SetError($iError, 0, $aResult)
EndFunc   ;==>_GDIPlus_GraphicsDrawString_

Func SetBmp($hGUI, $hImage, $iOpacity = 255)
    Local $hScrDC = _WinAPI_GetDC(0)
	Local $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	Local $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    Local $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSize = DllStructCreate("long X;long Y")
	$pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
    DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate("long X;long Y")
	$pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate("byte Op;byte Flags;byte Alpha;byte Format")
	$pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $iOpacity)
    DllStructSetData($tBlend, "Format", 1)
    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, 0x02)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBmp

;########## Functions from Zedna's UDF (Resources.au3 - "http://www.autoitscript.com/forum/index.php?showtopic=51103") ###############################################################
Func _ResourceGet($ResName); MODIFIED BY PLAYLET
	Local $hInstance = _WinAPI_GetModuleHandle("")
	If $hInstance = 0 Then Return SetError(1, 0, 0)
	Local $InfoBlock = DllCall("kernel32.dll", "int", "FindResourceA", "int", $hInstance, "str", $ResName, "long", 10)
	If @error Then Return SetError(3, 0, 0)
	$InfoBlock = $InfoBlock[0]
	If $InfoBlock = 0 Then Return SetError(4, 0, 0)
	Local $ResSize = DllCall("kernel32.dll", "dword", "SizeofResource", "int", $hInstance, "int", $InfoBlock)
	If @error Then Return SetError(5, 0, 0)
	$ResSize = $ResSize[0]
	If $ResSize = 0 Then Return SetError(6, 0, 0)
	Local $GlobalMemoryBlock = DllCall("kernel32.dll", "int", "LoadResource", "int", $hInstance, "int", $InfoBlock)
	If @error Then Return SetError(7, 0, 0)
	$GlobalMemoryBlock = $GlobalMemoryBlock[0]
	If $GlobalMemoryBlock = 0 Then Return SetError(8, 0, 0)
	Local $MemoryPointer = DllCall("kernel32.dll", "int", "LockResource", "int", $GlobalMemoryBlock)
	If @error Then Return SetError(9, 0, 0)
	$MemoryPointer = $MemoryPointer[0]
	If $MemoryPointer = 0 Then Return SetError(10, 0, 0)
	If @error Then Return SetError(11, 0, 0)
	SetExtended($ResSize)
	Return $MemoryPointer
EndFunc   ;==>_ResourceGet
Func _ResourceGetAsImage($ResName); MODIFIED BY PLAYLET
	Local $ResData = _ResourceGet($ResName)
	If @error Then Return SetError(1, 0, 0)
	Local $nSize = @extended
	Local $hData = _MemGlobalAlloc($nSize, 2)
	Local $pData = _MemGlobalLock($hData)
	_MemMoveMemory($ResData, $pData, $nSize)
	_MemGlobalUnlock($hData)
	Local $pStream = DllCall("ole32.dll", "int", "CreateStreamOnHGlobal", "int", $hData, "long", 1, "Int*", 0)
	$pStream = $pStream[3]
	Local $hImage = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromStream", "ptr", $pStream, "int*", 0)
	$hImage = $hImage[2]
	_WinAPI_DeleteObject($pStream)
	_MemGlobalFree($hData)
	Return $hImage
EndFunc   ;==>_ResourceGetAsImage
;#####################################################################################################################################################################################
