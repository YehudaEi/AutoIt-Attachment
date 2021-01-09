#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=C:\Programmi\AutoIt3\Icons\filetype-blank.ico
#AutoIt3Wrapper_outfile=C:\Documents and Settings\Gabriele ( admin )\Desktop\iTunes_info.exe
#AutoIt3Wrapper_Res_Comment=info for itunes (wmp 11 style) on mouse hover of the mini player in taskbar
#AutoIt3Wrapper_Res_Fileversion=1.0.0.5
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=GNU GPL
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;itunes minimized info - torels_
;(c) GNU GPL

#include <GUIConstants.au3>
#include "iTunes.au3"

$control = "[CLASS:iTunesMiniPlayerDeskBandBitmapClass]"
RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run","itunes_info_torels","REG_SZ", @ScriptDir & @ScriptName)


While 1
	ControlGetHandle("[CLASS:Shell_TrayWnd]", "", $control)
	If Not @error And ProcessExists("iTunes.exe") Then
		$cPos = ControlGetPos("[CLASS:Shell_TrayWnd]", "", $control)
		_itunes_start()
		ExitLoop
	EndIf
WEnd

While 1
	If WinGetState("[CLASS:iTunes]") = 37 Then
		$mPos = MouseGetPos()
		$song = _itunes_get_Current_Info()

		If $mPos[0] > $cPos[0] And $mPos[0] < ($cPos[0] + $cPos[2]) And $mPos[1] > @DesktopHeight - ($cPos[1] + $cPos[3]) Then
			If Not WinExists("ITUNES-INFO_TORELS") Then
				$gui = GUICreate("ITUNES-INFO_TORELS", $cPos[2] - 1, 100, $cPos[0], @DesktopHeight - ($cPos[3] + 105), $WS_POPUP, $WS_EX_TOOLWINDOW)
				GUICtrlCreatePic(_iTunes_Current_Get_Artwork_tmp(), ($cPos[2] / 2) - 30, 0, 60, 60)
				GUICtrlCreateLabel($song[0] & @CRLF & $song[1] & @CRLF & $song[2], 0, 60, $cPos[2], 90, $SS_CENTER, $WS_EX_TOPMOST)
				GUICtrlSetColor(-1, 0xffffff)
				GUISetBkColor(0x101010)
				GUISetState()
				WinSetTrans($gui, "", 235)
			EndIf
		Else
			If WinExists("ITUNES-INFO_TORELS") Then
				For $i = 100 To 0 Step -1
					WinSetTrans($gui, "", $i)
					Sleep(4)
				Next
				GUIDelete($gui)
			EndIf
		EndIf
	Else
		If WinExists("ITUNES-INFO_TORELS") Then GUIDelete($gui)
	EndIf
WEnd