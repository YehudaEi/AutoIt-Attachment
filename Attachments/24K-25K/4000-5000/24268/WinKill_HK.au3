#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Winkill.ico
#AutoIt3Wrapper_Outfile=WinKill.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=Kill actived window if not responding and some others options !
#AutoIt3Wrapper_Res_Description=d3mon Corporation
#AutoIt3Wrapper_Res_Fileversion=1.9.0.0
#AutoIt3Wrapper_Res_LegalCopyright=d3mon Corporation. All rights reserved.
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;===============================================================================
; Script Name: WinKill
; Author(s): d3mon Corporation
; Copyright : All functions in this script writted by me (without other autor)
; must be used or copied with my name on top
;===============================================================================

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <IsPressed_UDF.au3>
#include <Process.au3>

HotKeySet('^{F12}', '_WK')
HotKeySet('^{F9}', '_WH')
HotKeySet('^{F7}', '_WMIN')
HotKeySet('^{F6}', '_WMAX')

FileInstall('WinKillTray.ico', @TempDir & '\WinKillTray.ico', 1)
FileInstall('WinKill-About.bmp', @TempDir & '\WinKill-About.bmp', 1)

AutoItSetOption('WinTitleMatchMode', 2)
Opt('GuiOnEventMode', 1)
Opt('WinWaitDelay', 0)
Opt('TrayOnEventMode', 1)
Opt('TrayMenuMode', 1)

Local $init, $time = False, $found = -1

If (FileRead(@TempDir & '\ExWinKill.txt') = '') Then
	FileDelete(@TempDir & '\ExWinKill.txt')
	FileWrite(@TempDir & '\ExWinKill.txt', 'WinKill <d3montools>| 0|')
	FileWrite(@TempDir & '\ExWinKill.txt', 'Program Manager| 1|')
EndIf

#Region Tray
TrayCreateItem('Exclude...')
TrayItemSetOnEvent(-1, '_Ex')
TrayCreateItem('About...')
TrayItemSetOnEvent(-1, '_About')
TrayCreateItem('')
TrayCreateItem('Quit')
TrayItemSetOnEvent(-1, '_Exit')
TraySetIcon(@TempDir & '\WinKillTray.ico')
TraySetToolTip('WinKill <d3montools>')
#EndRegion Tray

#Region About
$About = GUICreate('WinKill About v2.0', 350, 250, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUICtrlCreatePic(@TempDir & '\WinKill-About.bmp', 10, 10, 90, 90)
GUISetBkColor('0xFFFFFF', $About)
GUICtrlCreateLabel('WinKill - d3mon Corporation', 120, 30, 300, 25)
GUICtrlSetFont(-1, 12, 400, 1, 'Comic Sans MS')
GUICtrlCreateLabel('Contact : d3mon@live.fr', 20, 105, 300, 25)
GUICtrlSetFont(-1, 10)
GUICtrlCreateLabel('• [CTRL+F12] = WINKILL • [CTRL+F6] = WINMAXIMIZE' & _
		@CRLF & '• [CTRL+F7] = WINMINIMIZE • [CTRL+F9] = WINHIDE' & _
		@CRLF & '• [CTRL+ESC] = URGENT KILL' & _
		@CRLF & '• [ESC+DEL] = RESTART IMMEDIATELY', 20, 135, 330, 60)
GUICtrlSetFont(-1, 9)

$startup = GUICtrlCreateCheckbox('Run on start-up', 120, 55, 300, 25)
GUICtrlSetFont(-1, 10)

$KILLPROCESS = GUICtrlCreateCheckbox('Kill process of window', 120, 75, 300, 25)
GUICtrlSetFont(-1, 10)

GUICtrlCreateButton('OK', 100, 210, 150, 25)
GUICtrlSetOnEvent(-1, '_AboutClose')
#EndRegion About

#Region Exclude window
$GUI = GUICreate('WinKill Exclude window <d3montools>', 350, 310, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
$wnd = GUICtrlCreateEdit('', 5, 5, 315, 17, $ES_AUTOVSCROLL)
GUICtrlCreateButton('...', 325, 5, 20, 17)
GUICtrlSetOnEvent(-1, '_wndAdd')
$wndlist = GUICtrlCreateListView('Exclude window / process|nb', 5, 28, 340, 245)
GUICtrlSendMsg(-1, 0x101E, 0, 298)
GUICtrlSendMsg(-1, 0x101E, 1, 37)

GUICtrlCreateLabel('[ENTER] Add item', 5, 285)
GUICtrlCreateLabel('[DEL] delete item', 250, 285)

GUICtrlCreateButton('OK', 105, 280, 130, 25)
GUICtrlSetOnEvent(-1, '_ExHIDE')
GUISetState(@SW_HIDE, $GUI)
#EndRegion Exclude window

#Region ToolTip
$wk = GUICreate('WinKill <d3montools>', 300, 17, 50, 50, $WS_BORDER + $WS_POPUP, $WS_EX_TOPMOST, $About)
$LABEL = GUICtrlCreateLabel('WinKill v2.0 tooltip', 2, 3, 296, 12, $ES_AUTOHSCROLL)
GUISetState(@SW_HIDE, $wk)
#EndRegion ToolTip

While 1
	Sleep(250)
	If $time = True Then
		If TimerDiff($init) >= 1000 Then
			GUISetState(@SW_HIDE, $wk)
			Global $time = False
		EndIf
	EndIf
	
	#Region URGENT KILL
	If _IsAndKeyPressed('11|1B') Then
		$WinTitle = WinGetTitle('[ACTIVE]', '')
		If FileExists(@TempDir & '\WinUCKill.txt') Then
			While Not ($WinTitle = '')
				WinActivate('[ACTIVE]')
				WinWaitActive('[ACTIVE]', '', 1)
				$WinTitle = WinGetTitle('[ACTIVE]', '')
				$WinH = WinGetHandle($WinTitle)
				
				If Not _Check($WinTitle) Then
					WinKill($WinH)
				EndIf
			WEnd
		Else
			While Not ($WinTitle = '')
				WinActivate('[ACTIVE]')
				WinWaitActive('[ACTIVE]', '', 1)
				$WinTitle = WinGetTitle('[ACTIVE]', '')
				$WinH = WinGetHandle($WinTitle)
				$ID = WinGetProcess($WinH)
				$PGN = _ProcessGetName($ID)
				
				If Not _Check($PGN) And _
						Not _Check($WinTitle) Then
					If $ID <> @AutoItPID Then
						ProcessClose($ID)
					EndIf
				EndIf
			WEnd
		EndIf
		
		_ToolTip('Urgent WinKill Cleared !')
		#EndRegion URGENT KILL

		#Region RESTART
	ElseIf _IsAndKeyPressed('1B|2E') Then
		SoundPlay(@WindowsDir & '\Media\Windows XP Arrêt du système.wav')
		_ToolTip('Urgent Restart started !')
		$init = TimerInit()
		$time = True
		While ProcessExists('winlogon.exe')
			ProcessClose('winlogon.exe')
		WEnd
	EndIf
	#EndRegion RESTART

	#Region Ex
	If WinActive($GUI) Then
		If _IsPressed('0D') Then
			If GUICtrlRead($wnd) <> '' Then
				$NB = StringTrimRight(StringRight(FileRead(@TempDir & '\ExWinKill.txt'), 2), 1)
				GUICtrlCreateListViewItem(GUICtrlRead($wnd) & '| ' & $NB + 1, $wndlist)
				FileWrite(@TempDir & '\ExWinKill.txt', '//' & GUICtrlRead($wnd) & '| ' & $NB + 1 & '|')
				GUICtrlSetData($wnd, '') ;---------------------------------------------
				Sleep(150) ;-----------------------------------
			EndIf
		ElseIf _IsPressed('2E') Then
			If GUICtrlRead(GUICtrlRead($wndlist)) <> '' Then
				$wndR = StringReplace(FileRead(@TempDir & '\ExWinKill.txt'), '//' & GUICtrlRead(GUICtrlRead($wndlist)), '')
				FileDelete(@TempDir & '\ExWinKill.txt')
				FileWrite(@TempDir & '\ExWinKill.txt', $wndR)
				_ExRefresh()
			EndIf
			Sleep(150) ;--------------------------------------------------
		EndIf
	EndIf
	#EndRegion Ex
	_ReduceMemory()
WEnd ;==>_While 1

#Region Hotkey Func
Func _WK()
	If FileExists(@TempDir & '\WinUCKill.txt') Then
		WinActivate('[ACTIVE]')
		WinWaitActive('[ACTIVE]', '', 1)
		$WinTitle = WinGetTitle('[ACTIVE]')
		$WinH = WinGetHandle($WinTitle)
		$ID = WinGetProcess($WinH)
		$PGN = _ProcessGetName($ID)
		
		If Not _Check($PGN) And _
				Not _Check($WinTitle) Then
			If $ID <> @AutoItPID Then
				ProcessClose($ID)
			EndIf
		EndIf
	Else
		WinActivate('[ACTIVE]')
		WinWaitActive('[ACTIVE]', '', 1)
		$WinTitle = WinGetTitle('[ACTIVE]')
		$WinH = WinGetHandle($WinTitle)
		If Not _Check($WinTitle) Then
			WinKill($WinH)
		EndIf
	EndIf
	_ToolTip('WinKill > ' & $WinTitle)
EndFunc   ;==>_WK

Func _WH()
	WinActivate('[ACTIVE]')
	WinWaitActive('[ACTIVE]', '', 1)
	$WinTitle = WinGetTitle('[ACTIVE]')
	$WinH = WinGetHandle($WinTitle)
	If Not _Check($WinTitle) Then
		WinSetState($WinH, '', @SW_HIDE)
	EndIf
	
	_ToolTip('WinHide > ' & $WinTitle)
EndFunc   ;==>_WH

Func _WMIN()
	WinActivate('[ACTIVE]')
	WinWaitActive('[ACTIVE]', '', 1)
	$WinTitle = WinGetTitle('[ACTIVE]')
	$WinH = WinGetHandle($WinTitle)
	
	If Not _Check($WinTitle) Then
		WinSetState($WinH, '', @SW_MINIMIZE)
	EndIf
	
	_ToolTip('WinMinimize > ' & $WinTitle)
EndFunc   ;==>_WMIN

Func _WMAX()
	WinActivate('[ACTIVE]')
	WinWaitActive('[ACTIVE]', '', 1)
	$WinTitle = WinGetTitle('[ACTIVE]', '')
	$WinH = WinGetHandle($WinTitle)
	
	If Not _Check($WinTitle) Then
		WinSetState($WinH, '', @SW_MAXIMIZE)
	EndIf
	
	_ToolTip('WinMaximize > ' & $WinTitle)
EndFunc   ;==>_WMAX
#EndRegion Hotkey Func


#Region Ex
Func _Ex()
	GUISetState(@SW_SHOW, $GUI)
	_ExRefresh()
EndFunc   ;==>_Ex

Func _ExHIDE()
	GUISetState(@SW_HIDE, $GUI)
EndFunc   ;==>_ExHIDE

Func _wndAdd()
	$newwnd = FileSelectFolder('Select folder to add', '')

	If @error Then
		MsgBox(4096, 'Error', 'No folder Selected !')
	Else
		GUICtrlSetData($wnd, $newwnd)
	EndIf
EndFunc   ;==>_wndAdd

Func _ExRefresh()
	GUICtrlDelete($wndlist)
	$array = StringSplit(FileRead(@TempDir & '\ExWinKill.txt'), '//')
	$wndlist = GUICtrlCreateListView('Exclude window / process|nb', 5, 28, 340, 245)
	GUICtrlSendMsg(-1, 0x101E, 0, 298)
	GUICtrlSendMsg(-1, 0x101E, 1, 37)

	For $nbarray = 1 To $array[0]
		If $array[$nbarray] <> '' Then
			GUICtrlCreateListViewItem($array[$nbarray], $wndlist)
		EndIf
	Next
EndFunc   ;==>_ExRefresh
#EndRegion Ex

#Region Func
Func _ReduceMemory($i_PID = @ScriptName)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall('kernel32.dll', 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall('psapi.dll', 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall('psapi.dll', 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf

	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func _Exit()
	FileDelete(@TempDir & '\WinKill-About.bmp')
	FileDelete(@TempDir & '\WinKillTray.ico')
	Exit
EndFunc   ;==>_Exit

Func _Check($wndTitle)
	$array = StringSplit(FileRead(@TempDir & '\ExWinKill.txt'), '//')
	For $nbarray = 1 To $array[0]
		If Not @error And $array[$nbarray] <> '' Then
			$cwnd = StringTrimRight($array[$nbarray], 4)
			If $cwnd = $wndTitle Then
				Return 1
			EndIf
		EndIf
	Next
	Return 0
EndFunc   ;==>_Check

Func _ToolTip($lbl)
	Sleep(50)
	GUISetState(@SW_SHOW, $wk)
	GUICtrlSetData($LABEL, $lbl)
	Global $init = TimerInit()
	Global $time = True
EndFunc   ;==>_ToolTip
#EndRegion Func


#Region About
Func _About()
	RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'WinKill')

	If @error Then
		GUICtrlSetState($startup, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($startup, $GUI_CHECKED)
	EndIf

	If FileExists(@TempDir & '\WinUCKill.txt') Then
		GUICtrlSetState($KILLPROCESS, $GUI_CHECKED)
	Else
		GUICtrlSetState($KILLPROCESS, $GUI_UNCHECKED)
	EndIf

	GUISetState(@SW_SHOW, $About)
	WinSetTrans($About, '', 215)
EndFunc   ;==>_About

Func _AboutClose()
	If (GUICtrlRead($startup) == $GUI_CHECKED) Then
		RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'WinKill', 'REG_SZ', @ScriptFullPath)
	Else
		RegDelete('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'WinKill')
	EndIf

	If (GUICtrlRead($KILLPROCESS) == $GUI_CHECKED) Then
		FileWrite(@TempDir & '\WinUCKill.txt', '')
	Else
		FileDelete(@TempDir & '\WinUCKill.txt')
	EndIf

	GUISetState(@SW_HIDE, $About)
EndFunc   ;==>_AboutClose
#EndRegion About;### Tidy Error -> while is never closed in your script.