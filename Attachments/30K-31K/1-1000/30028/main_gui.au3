#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=img\app.ico
#AutoIt3Wrapper_outfile=PROGRAM.exe
#AutoIt3Wrapper_Res_Description=PROGRAM - Your Program Description v1.0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Icefire
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Include <File.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#Include <Array.au3>
#include <IE.au3>
#Include <WinAPI.au3>
#include <Constants.au3>
#include <Excel.au3>
#Include <GuiListView.au3>
#include 'Gif89.dll.au3'

_IEErrorHandlerRegister('__com_error')

Global $I_VERSION = 2
Global $S_TEMP_DIR = @TempDir & '\your_program_files\'
Global $S_TEMP_DIR_IMG = @TempDir & '\your_program_files\img\'
Global $S_FILES_TEMP_DIR = @TempDir & '\your_program_files\temp\'
Global $O_GIF_START_CONTROL
Global $A_IE_EMBEDDED[2][2]

#include <__progress_functions.au3>
#include <__control_functions.au3>

#include <changelog.au3>
#include <panel_1.au3>
#include <panel_2.au3>
#include <panel_3.au3>

Opt('MustDeclareVars', 1)
Opt('TrayMenuMode',1)
OnAutoItExitRegister('__exit')

If WinExists('PROGRAM', 'Your Program Description') = 1 Then Exit MsgBox(48, 'PROGRAM', 'application already running')

__install_files($I_VERSION)
__graphical_user_interface()

Func __graphical_user_interface()
	;========== FUNCTION START
	Local $O_WIN, $O_MAIN_BUTTON_MINIMIZE, $O_MAIN_BUTTON_CLOSE, $A_MAIN_BUTTON[30], $O_MAIN_BUTTON_CREDIT, $O_GIF_START
	Local $A_WIN_PROGRESS
	;========== MAIN GUI
	$O_WIN = GUICreate('PROGRAM', 1004, 624, -1, -1, BitOR($WS_MINIMIZEBOX,$WS_SYSMENU,$WS_POPUP))
	GUISetBkColor(0xFFFFFF, $O_WIN)
	GUISetFont(8, 400, 0, 'tahoma', $O_WIN)
	;========== MAIN BORDER
	GUICtrlCreateGraphic(0, 0, 1004, 1)
	GUICtrlSetColor(-1, 0x8C8C8C)
	GUICtrlCreateGraphic(1003, 1, 1, 622)
	GUICtrlSetColor(-1, 0x8C8C8C)
	GUICtrlCreateGraphic(0, 623, 1004, 1)
	GUICtrlSetColor(-1, 0x8C8C8C)
	GUICtrlCreateGraphic(0, 1, 1, 622)
	GUICtrlSetColor(-1, 0x8C8C8C)
	GUICtrlCreateGraphic(1, 21, 1002, 1)
	GUICtrlSetColor(-1, 0x8C8C8C)
	GUICtrlCreateGraphic(159, 22, 1, 601)
	GUICtrlSetColor(-1, 0x8C8C8C)
	GUICtrlCreateGraphic(160, 22, 1, 601)
	GUICtrlSetColor(-1, 0xd3d4d4)
	;========== HEADER BUTTON
	$O_MAIN_BUTTON_MINIMIZE = GUICtrlCreatePic('', 973, 7, 9, 9)
	GUICtrlSetTip(-1, 'minimize')
	$O_MAIN_BUTTON_CLOSE = GUICtrlCreatePic('', 988, 7, 9, 9)
	GUICtrlSetTip(-1, 'close')
	;========== HEADER LABEL
	GUICtrlCreateLabel('  Program - Your Program Description', 1, 1, 1002, 20, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x3BA313)
	;========== HEADER PICTURE
	GUICtrlCreatePic($S_TEMP_DIR_IMG & 'minimize.jpg', 1004 - 31, 7, 9, 9)
	GUICtrlCreatePic($S_TEMP_DIR_IMG & 'close.jpg', 1004 - 16, 7, 9, 9)
	;========== MAIN BUTTON
	$A_MAIN_BUTTON[0] = __create_button_main(10, 32, 'Panel 1 example')
	$A_MAIN_BUTTON[1] = __create_button_main(10, 62, 'Panel 2 example')
	$A_MAIN_BUTTON[2] = __create_button_main(10, 92, 'Internet example')
;~ 	$A_MAIN_BUTTON[3] = __create_button_main(10, 122, 'empty')
;~ 	$A_MAIN_BUTTON[4] = __create_button_main(10, 152, 'empty')
;~ 	$A_MAIN_BUTTON[5] = __create_button_main(10, 182, 'empty')
;~ 	$A_MAIN_BUTTON[6] = __create_button_main(10, 212, 'empty')
;~ 	$A_MAIN_BUTTON[7] = __create_button_main(10, 242, 'empty')
;~ 	$A_MAIN_BUTTON[8] = __create_button_main(10, 272, 'empty')
;~ 	$A_MAIN_BUTTON[9] = __create_button_main(10, 302, 'empty')
;~ 	$A_MAIN_BUTTON[10] = __create_button_main(10, 332, 'empty')
;~ 	$A_MAIN_BUTTON[11] = __create_button_main(10, 362, 'empty')
;~ 	$A_MAIN_BUTTON[12] = __create_button_main(10, 392, 'empty')
;~ 	$A_MAIN_BUTTON[13] = __create_button_main(10, 422, 'empty')
;~ 	$A_MAIN_BUTTON[14] = __create_button_main(10, 452, 'empty')
	;========== MAIN PANEL LEFT
	GUICtrlCreateGraphic(1, 22, 158, 601)
	GUICtrlSetColor(-1, 0xEBEBEB)
	GUICtrlSetBkColor(-1, 0xEBEBEB)
	;========== MAIN PANEL LEFT PICTURE
	GUICtrlCreatePic($S_TEMP_DIR_IMG & 'backpanel.jpg', 1, 543, 158, 80)
	;========== MAIN GIF
;~ 	$O_GIF_START = ObjCreate('Gif89.Gif89') ;=== disabled because internet explorer will be on the main windows at startup
;~ 	If Not @error Then $O_GIF_START.filename = $S_TEMP_DIR_IMG & 'start.gif'
;~ 	If IsObj($O_GIF_START) = 1 Then $O_GIF_START_CONTROL = GUICtrlCreateObj($O_GIF_START, 210, 62, 720, 480)
	;========== FOOTER CREDIT
	$O_MAIN_BUTTON_CREDIT = GUICtrlCreateLabel('version 1.0 created by Icefire', 320, 566, 524, 48, BitOR($SS_CENTER,$SS_CENTERIMAGE))
	GUICtrlSetColor($O_MAIN_BUTTON_CREDIT, 0x8C8C8C)
	;========== INTERNET EXPLORER OBJECTS
	$A_WIN_PROGRESS = __progress_create('creating internet explorer object, one moment please')
;~ 	$A_IE_EMBEDDED = __create_internet_proccess($A_IE_EMBEDDED, 1, $O_WIN) ;=== old
	$A_IE_EMBEDDED = __create_internet_proccess($A_IE_EMBEDDED, 1, $O_WIN, 1, 'http://www.autoitscript.com/forum/index.php?showtopic=111104') ;=== new
	__progress_delete($A_WIN_PROGRESS)
	;==========
	GUISetState(@SW_SHOW, $O_WIN)
	;==========

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			Case $O_MAIN_BUTTON_CLOSE
				Exit
			Case $O_MAIN_BUTTON_MINIMIZE
				GUISetState(@SW_MINIMIZE, $O_WIN)
			Case $A_MAIN_BUTTON[0]
				WinSetState($A_IE_EMBEDDED[1][0], '', @SW_HIDE) ;=== to hide the main internet explorer
				__panel_1_1($O_WIN, $O_MAIN_BUTTON_MINIMIZE, $O_MAIN_BUTTON_CLOSE, $A_MAIN_BUTTON)
				WinSetState($A_IE_EMBEDDED[1][0], '', @SW_SHOW) ;=== to show the main internet explorer
			Case $A_MAIN_BUTTON[1]
				WinSetState($A_IE_EMBEDDED[1][0], '', @SW_HIDE) ;=== to hide the main internet explorer
				__panel_2_1($O_WIN, $O_MAIN_BUTTON_MINIMIZE, $O_MAIN_BUTTON_CLOSE, $A_MAIN_BUTTON)
				WinSetState($A_IE_EMBEDDED[1][0], '', @SW_SHOW) ;=== to show the main internet explorer
			Case $A_MAIN_BUTTON[2]
				WinSetState($A_IE_EMBEDDED[1][0], '', @SW_HIDE) ;=== to hide the main internet explorer
				__panel_3_1($O_WIN, $O_MAIN_BUTTON_MINIMIZE, $O_MAIN_BUTTON_CLOSE, $A_MAIN_BUTTON)
				WinSetState($A_IE_EMBEDDED[1][0], '', @SW_SHOW) ;=== to show the main internet explorer
			Case $O_MAIN_BUTTON_CREDIT
				WinSetState($A_IE_EMBEDDED[1][0], '', @SW_HIDE) ;=== to hide the main internet explorer
				__panel_changelog($O_WIN, $O_MAIN_BUTTON_MINIMIZE, $O_MAIN_BUTTON_CLOSE, $A_MAIN_BUTTON)
				WinSetState($A_IE_EMBEDDED[1][0], '', @SW_SHOW) ;=== to show the main internet explorer
		EndSwitch
	WEnd

	;========== FUNCTION END
	Return 1
EndFunc

Func __install_files($I_VERSION)
	;========== FUNCTION START
	Local $A_WIN_PROGRESS
	Local $I_PROGRESS_COUNT = 0
	Local $I_FILE_COUNT = 17 ;=== files included for proccess bar
	;==========
	If IniRead($S_TEMP_DIR & 'program.ini', 'MAIN', 'VERSION', 0) = 0 Then
		MsgBox(64, 'PROGRAM', 'installing files for first time use, please be patient', 3)
		DirRemove($S_TEMP_DIR, 1)
	ElseIf IniRead($S_TEMP_DIR & 'program.ini', 'MAIN', 'VERSION', 0) <> $I_VERSION Then
		MsgBox(64, 'PROGRAM', 'updated from version ' & IniRead($S_TEMP_DIR & 'program.ini', 'MAIN', 'VERSION', 0) & ' to version ' & $I_VERSION, 3)
		DirRemove($S_TEMP_DIR, 1)
	EndIf
	;==========
	If FileExists(@TempDir & '\your_program_files') = 0 Then DirCreate(@TempDir & '\your_program_files')
	If FileExists(@TempDir & '\your_program_files\img') = 0 Then DirCreate(@TempDir & '\your_program_files\img')
	If FileExists(@TempDir & '\your_program_files\temp') = 0 Then DirCreate(@TempDir & '\your_program_files\temp')
	;==========
	FileInstall('changelog.txt', $S_TEMP_DIR & 'changelog.txt', 1) ;=== excluded from file count
	If FileExists($S_TEMP_DIR_IMG & 'progress.gif') = 0 Then FileInstall('img\progress.gif', $S_TEMP_DIR_IMG & 'progress.gif', 0) ;=== excluded from file count
	__dll_create_gif_object()
	$A_WIN_PROGRESS = __progress_create('starting up')
	;========== #1 start.gif
	If FileExists($S_TEMP_DIR_IMG & 'start.gif') = 0 Then FileInstall('img\start.gif', $S_TEMP_DIR_IMG & 'start.gif', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #2 app.ico
	If FileExists($S_TEMP_DIR_IMG & 'app.ico') = 0 Then FileInstall('img\app.ico', $S_TEMP_DIR_IMG & 'app.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #3 close.jpg
	If FileExists($S_TEMP_DIR_IMG & 'close.jpg') = 0 Then FileInstall('img\close.jpg', $S_TEMP_DIR_IMG & 'close.jpg', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #4 minimize.jpg
	If FileExists($S_TEMP_DIR_IMG & 'minimize.jpg') = 0 Then FileInstall('img\minimize.jpg', $S_TEMP_DIR_IMG & 'minimize.jpg', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #5 backpanel.jpg
	If FileExists($S_TEMP_DIR_IMG & 'backpanel.jpg') = 0 Then FileInstall('img\backpanel.jpg', $S_TEMP_DIR_IMG & 'backpanel.jpg', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #6 btn_next.jpg
	If FileExists($S_TEMP_DIR_IMG & 'btn_next.jpg') = 0 Then FileInstall('img\btn_next.jpg', $S_TEMP_DIR_IMG & 'btn_next.jpg', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #7 btn_back.jpg
	If FileExists($S_TEMP_DIR_IMG & 'btn_back.jpg') = 0 Then FileInstall('img\btn_back.jpg', $S_TEMP_DIR_IMG & 'btn_back.jpg', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #8 0.ico
	If FileExists($S_TEMP_DIR_IMG & '0.ico') = 0 Then FileInstall('img\0.ico', $S_TEMP_DIR_IMG & '0.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #9 1.ico
	If FileExists($S_TEMP_DIR_IMG & '1.ico') = 0 Then FileInstall('img\1.ico', $S_TEMP_DIR_IMG & '1.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #10 close.ico
	If FileExists($S_TEMP_DIR_IMG & 'close.ico') = 0 Then FileInstall('img\close.ico', $S_TEMP_DIR_IMG & 'close.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #11 back.ico
	If FileExists($S_TEMP_DIR_IMG & 'back.ico') = 0 Then FileInstall('img\back.ico', $S_TEMP_DIR_IMG & 'back.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #12 next.ico
	If FileExists($S_TEMP_DIR_IMG & 'next.ico') = 0 Then FileInstall('img\next.ico', $S_TEMP_DIR_IMG & 'next.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #13 go.ico
	If FileExists($S_TEMP_DIR_IMG & 'go.ico') = 0 Then FileInstall('img\go.ico', $S_TEMP_DIR_IMG & 'go.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #14 blank.ico
	If FileExists($S_TEMP_DIR_IMG & 'blank.ico') = 0 Then FileInstall('img\blank.ico', $S_TEMP_DIR_IMG & 'blank.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #15 warning.ico
	If FileExists($S_TEMP_DIR_IMG & 'warning.ico') = 0 Then FileInstall('img\warning.ico', $S_TEMP_DIR_IMG & 'warning.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #16 send.ico
	If FileExists($S_TEMP_DIR_IMG & 'send.ico') = 0 Then FileInstall('img\send.ico', $S_TEMP_DIR_IMG & 'send.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;========== #17 search.ico
	If FileExists($S_TEMP_DIR_IMG & 'search.ico') = 0 Then FileInstall('img\search.ico', $S_TEMP_DIR_IMG & 'search.ico', 0)
	$I_PROGRESS_COUNT += 100 / $I_FILE_COUNT
	__progress_update($A_WIN_PROGRESS, 'starting up', $I_PROGRESS_COUNT)
	;==========
	IniWrite($S_TEMP_DIR & 'program.ini', 'MAIN', 'VERSION', $I_VERSION)
	;==========
	__progress_delete($A_WIN_PROGRESS)
	;========== FUNCTION END
EndFunc

Func __com_error()
	;========== FUNCTION START
	Local $S_ERROR_MESSAGE
	;==========
	$S_ERROR_MESSAGE = '' &  _
	'- ' & @TAB & 'OBJECT ERROR' & @CRLF & _
	'' & @CRLF & _
	'- ' & 'Source:' & @TAB & @TAB & $oIEErrorHandler.Source & @CRLF & _
	'- ' & 'Error:' & @TAB & @TAB & StringStripWS($oIEErrorHandler.WinDescription, 2) & @TAB & @CRLF & _
	'- ' & 'Error description:' & @TAB & StringStripWS($oIEErrorHandler.description, 2) & @CRLF & _
	'' & @CRLF & _
	'- ' & 'Script referrer:' & @TAB & $oIEErrorHandler.scriptline & @CRLF & _
	'- ' & 'Dll errorcode:' & @TAB & $oIEErrorHandler.LastDllError
	;========== FUNCTION END
	ConsoleWriteError('------------------------------' & @CRLF & $S_ERROR_MESSAGE & @CRLF & '------------------------------' & @CRLF)
	MsgBox(48, 'COM', $S_ERROR_MESSAGE)
	Beep(1800, 20)
EndFunc

Func __exit()
	;========== FUNCTION START
	Local $I_DEBUG
	;==========
	For $I_INDEX = 1 To UBound($A_IE_EMBEDDED) - 1 Step 1
		$I_DEBUG = _IEQuit($A_IE_EMBEDDED[$I_INDEX][1]) ;=== to bypass multi proccesses for internet explorer 8
	Next
	;========== FUNCTION END
EndFunc