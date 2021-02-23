#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <Process.au3>
#include <EditConstants.au3>

Global $TypeScript = "TrayIconChanger", $Version = "V 1.0", $MadeBy = "By SnéákyEric", $SystemTrayIcon_Dir = "C:\Windows\SneakyEricTweak\SystemTrayIcon"
Global $ODPNI, $ODACT, $ODBAT, $ODSND, $ODSTO, $AnyChanged = False

#Region - - Write - -
;WriteReplace
$h1File = FileOpen ( "C:\Windows\SneakyEricTweak\SystemTrayIcon\Replace_SystemTray.bat", 10 )
FileWrite ( $h1File, "taskkill /f /im explorer.exe" & @CRLF )
FileWrite ( $h1File, "takeown /f %systemroot%\system32\pnidui.dll && icacls %systemroot%\system32\pnidui.dll /grant administrators:F" & @CRLF )
;FileWrite ( $h1File, "takeown /f %systemroot%\SneakyEricTweak\SystemTrayIcon\pnidui_new.dll && icacls %systemroot%\SneakyEricTweak\SystemTrayIcon\pnidui_new.dll /grant administrators:F" & @CRLF )
FileWrite ( $h1File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\pnidui_new.dll %systemroot%\System32\pnidui.dll" & @CRLF )
FileWrite ( $h1File, "takeown /f %systemroot%\system32\ActionCenter.dll && icacls %systemroot%\system32\ActionCenter.dll /grant administrators:F" & @CRLF )
FileWrite ( $h1File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\ActionCenter_new.dll %systemroot%\System32\ActionCenter.dll" & @CRLF )
FileWrite ( $h1File, "takeown /f %systemroot%\system32\batmeter.dll && icacls %systemroot%\system32\batmeter.dll /grant administrators:F" & @CRLF )
FileWrite ( $h1File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\batmeter_new.dll %systemroot%\System32\batmeter.dll" & @CRLF )
FileWrite ( $h1File, "takeown /f %systemroot%\system32\SndVolSSO.dll && icacls %systemroot%\system32\SndVolSSO.dll /grant administrators:F" & @CRLF )
FileWrite ( $h1File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\SndVolSSO_new.dll C:\Windows\System32\SndVolSSO.dll" & @CRLF )
FileWrite ( $h1File, "takeown /f %systemroot%\system32\stobject.dll && icacls %systemroot%\system32\stobject.dll /grant administrators:F" & @CRLF )
FileWrite ( $h1File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\stobject_new.dll %systemroot%\System32\stobject.dll" & @CRLF )
FileWrite ( $h1File, "del %systemroot%\SneakyEricTweak\SystemTrayIcon\pnidui_new.dll" & @CRLF )
FileWrite ( $h1File, "del %systemroot%\SneakyEricTweak\SystemTrayIcon\ActionCenter_new.dll" & @CRLF )
FileWrite ( $h1File, "del %systemroot%\SneakyEricTweak\SystemTrayIcon\batmeter_new.dll" & @CRLF )
FileWrite ( $h1File, "del %systemroot%\SneakyEricTweak\SystemTrayIcon\SndVolSSO_new.dll" & @CRLF )
FileWrite ( $h1File, "del %systemroot%\SneakyEricTweak\SystemTrayIcon\stobject_new.dll" & @CRLF )
FileWrite ( $h1File, "CD C:\Windows" & @CRLF )
FileWrite ( $h1File, "start explorer.exe" & @CRLF & "pause" )
FileClose ( $h1File )
;WriteRestore
$h2File = FileOpen ( "C:\Windows\SneakyEricTweak\SystemTrayIcon\Restore_SystemTray.bat", 10 )
FileWrite ( $h2File, "taskkill /f /im explorer.exe" & @CRLF )
FileWrite ( $h2File, "takeown /f %systemroot%\system32\pnidui.dll && icacls %systemroot%\system32\pnidui.dll /grant administrators:F" & @CRLF )
FileWrite ( $h2File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\pnidui_backup.dll %systemroot%\System32\pnidui.dll" & @CRLF )
FileWrite ( $h2File, "takeown /f %systemroot%\system32\ActionCenter.dll && icacls %systemroot%\system32\ActionCenter.dll /grant administrators:F" & @CRLF )
FileWrite ( $h2File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\ActionCenter_backup.dll %systemroot%\System32\ActionCenter.dll" & @CRLF )
FileWrite ( $h2File, "takeown /f %systemroot%\system32\batmeter.dll && icacls %systemroot%\system32\batmeter.dll /grant administrators:F" & @CRLF )
FileWrite ( $h2File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\batmeter_backup.dll %systemroot%\System32\batmeter.dll" & @CRLF )
FileWrite ( $h2File, "takeown /f %systemroot%\system32\SndVolSSO.dll && icacls %systemroot%\system32\SndVolSSO.dll /grant administrators:F" & @CRLF )
FileWrite ( $h2File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\SndVolSSO_backup.dll %systemroot%\System32\SndVolSSO.dll" & @CRLF )
FileWrite ( $h2File, "takeown /f %systemroot%\system32\stobject.dll && icacls %systemroot%\system32\stobject.dll /grant administrators:F" & @CRLF )
FileWrite ( $h2File, "copy %systemroot%\SneakyEricTweak\SystemTrayIcon\stobject_backup.dll %systemroot%\System32\stobject.dll" & @CRLF )
FileWrite ( $h2File, "CD C:\Windows" & @CRLF )
FileWrite ( $h2File, "start explorer.exe" & @CRLF & "pause" )
FileClose ( $h2File )
;WriteBackup
$h3File = FileOpen ( "C:\Windows\SneakyEricTweak\SystemTrayIcon\Backup_SystemTray.bat", 10 )
FileWrite ( $h3File, "taskkill /f /im explorer.exe" & @CRLF )
FileWrite ( $h3File, "takeown /f %systemroot%\system32\pnidui.dll && icacls %systemroot%\system32\pnidui.dll /grant administrators:F" & @CRLF )
FileWrite ( $h3File, "copy %systemroot%\system32\pnidui.dll %systemroot%\SneakyEricTweak\SystemTrayIcon\pnidui_backup.dll" & @CRLF )
FileWrite ( $h3File, "takeown /f %systemroot%\system32\ActionCenter.dll && icacls %systemroot%\system32\ActionCenter.dll /grant administrators:F" & @CRLF )
FileWrite ( $h3File, "copy %systemroot%\system32\ActionCenter.dll %systemroot%\SneakyEricTweak\SystemTrayIcon\ActionCenter_backup.dll" & @CRLF )
FileWrite ( $h3File, "takeown /f %systemroot%\system32\batmeter.dll && icacls %systemroot%\system32\batmeter.dll /grant administrators:F" & @CRLF )
FileWrite ( $h3File, "copy %systemroot%\system32\batmeter.dll %systemroot%\SneakyEricTweak\SystemTrayIcon\batmeter_backup.dll" & @CRLF )
FileWrite ( $h3File, "takeown /f %systemroot%\system32\SndVolSSO.dll && icacls %systemroot%\system32\SndVolSSO.dll /grant administrators:F" & @CRLF )
FileWrite ( $h3File, "copy %systemroot%\system32\SndVolSSO.dll %systemroot%\SneakyEricTweak\SystemTrayIcon\SndVolSSO_backup.dll" & @CRLF )
FileWrite ( $h3File, "takeown /f %systemroot%\system32\stobject.dll && icacls %systemroot%\system32\stobject.dll /grant administrators:F" & @CRLF )
FileWrite ( $h3File, "copy %systemroot%\system32\stobject.dll %systemroot%\SneakyEricTweak\SystemTrayIcon\stobject_backup.dll" & @CRLF )
FileWrite ( $h3File, "CD C:\Windows" & @CRLF )
FileWrite ( $h3File, "start explorer.exe" & @CRLF & "exit" )
FileClose ( $h3File )
#EndRegion
#Region - - Main GUI - - 
$MainGUI 	=	GUICreate ( $TypeScript & " - " & $Version & " - " & $MadeBy, 400, 215 )
	
$LabPNI		=	GUICtrlCreateLabel ( "pnidui.dll:", 10, 13 ) 
$InpPNI		=	GUICtrlCreateInput ( "Path", 90, 10, 230, 20, $ES_READONLY )
$ButPNI		=	GUICtrlCreateButton ( "Browse...", 325, 8, 70, 24 )
$LabACT		=	GUICtrlCreateLabel ( "ActionCenter.dll:", 10, 37 ) 
$InpACT		=	GUICtrlCreateInput ( "Path", 90, 35, 230, 20, $ES_READONLY  )
$ButACT		=	GUICtrlCreateButton ( "Browse...", 325, 33, 70, 24 )
$LabBAT		=	GUICtrlCreateLabel ( "batmeter.dll:", 10, 62 ) 
$InpBAT		=	GUICtrlCreateInput ( "Path", 90, 60, 230, 20, $ES_READONLY  )
$ButBAT		=	GUICtrlCreateButton ( "Browse...", 325, 58, 70, 24 )
$LabSND		=	GUICtrlCreateLabel ( "SndVolSSO.dll:", 10, 87 ) 
$InpSND		=	GUICtrlCreateInput ( "Path", 90, 85, 230, 20, $ES_READONLY  )
$ButSND		=	GUICtrlCreateButton ( "Browse...", 325, 83, 70, 24 )
$LabSTO 	=	GUICtrlCreateLabel ( "stobject.dll:", 10, 112 ) 
$InpSTO		=	GUICtrlCreateInput ( "Path", 90, 110, 230, 20, $ES_READONLY  )
$ButSTO		=	GUICtrlCreateButton ( "Browse...", 325, 108, 70, 24 )
	
$RSTI		=	GUICtrlCreateButton ( "Replace SystemTrayIcons", 5, 140, 390, 30 )
$RBSTI		=	GUICtrlCreateButton ( "Restore SystemTrayIcons", 5, 175, 190, 30 )
$MBSTI	 	=	GUICtrlCreateButton ( "Backup SystemTrayIcons", 200, 175, 195, 30 )
				GUISetState ( @SW_SHOW, $MainGUI )
#EndRegion


While 1
	$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $ButPNI
				$ODPNI = FileOpenDialog ( "Browse pnidui.dll...", @MyDocumentsDir, "dll (*.dll)" )
				GUICtrlSetData ( $InpPNI, $ODPNI )
			Case $msg = $ButACT
				$ODACT = FileOpenDialog ( "Browse ActionCenter.dll...", @MyDocumentsDir, "dll (*.dll)" )
				GUICtrlSetData ( $InpACT, $ODACT )
			Case $msg = $ButBAT
				$ODBAT = FileOpenDialog ( "Browse batmeter.dll...", @MyDocumentsDir, "dll (*.dll)" )
				GUICtrlSetData ( $InpBAT, $ODBAT )
			Case $msg = $ButSND
				$ODSND = FileOpenDialog ( "Browse SndVolSSO.dll...", @MyDocumentsDir, "dll (*.dll)" )
				GUICtrlSetData ( $InpSND, $ODSND )
			Case $msg = $ButSTO
				$ODSTO = FileOpenDialog ( "Browse stobject.dll...", @MyDocumentsDir, "dll (*.dll)" )
				GUICtrlSetData ( $InpSTO, $ODSTO )
			Case $msg = $RSTI
				If GUICtrlRead ( $InpPNI ) <> "Path" Then 
					FileCopy ( $ODPNI, $SystemTrayIcon_Dir & "\pnidui_new.dll", 9 )
					$AnyChanged = True
				EndIf
				If GUICtrlRead ( $InpACT ) <> "Path"  Then 
					FileCopy ( $ODACT, $SystemTrayIcon_Dir & "\ActionCenter_new.dll", 9 )
					$AnyChanged = True
				EndIf
				If GUICtrlRead ( $InpBAT ) <> "Path"  Then 
					FileCopy ( $ODBAT, $SystemTrayIcon_Dir & "\batmeter_new.dll", 9 )
					$AnyChanged = True
				EndIf
				If GUICtrlRead ( $InpSND ) <> "Path" Then 
					FileCopy ( $ODSND, $SystemTrayIcon_Dir & "\SndVolSSO_new.dll", 9 )
					$AnyChanged = True
				EndIf
				If GUICtrlRead ( $InpSTO ) <> "Path"  Then 
					FileCopy ( $ODSTO, $SystemTrayIcon_Dir & "\stobject_new.dll", 9 )
					$AnyChanged = True
				EndIf
				If $AnyChanged == True Then	ReplaceSystemTrayIcons ( )
			Case $msg = $RBSTI
				RestoreSystemTrayIcons ( )
			Case $msg = $MBSTI
				BackupSystemTrayIcons ( )
		EndSelect
WEnd


Func ReplaceSystemTrayIcons ( )
	RunWait ( "C:\Windows\SneakyEricTweak\SystemTrayIcon\Replace_SystemTray.bat", "C:\Windows\SneakyEricTweak\SystemTrayIcon\", @SW_SHOW )
	MsgBox ( 0, "Items replaced", "The system tray icons are replaced, if you don't see any changes please restart your computer or try it again." )
	$AnyChanged = False
EndFunc
Func RestoreSystemTrayIcons ( )
	RunWait ( "C:\Windows\SneakyEricTweak\SystemTrayIcon\Restore_SystemTray.bat", "C:\Windows\SneakyEricTweak\SystemTrayIcon", @SW_SHOW )
	MsgBox ( 1, "Backup restored", "Backup is restored" )
EndFunc
Func BackupSystemTrayIcons ( )
	RunWait ( "C:\Windows\SneakyEricTweak\SystemTrayIcon\Backup_SystemTray.bat", "C:\Windows\SneakyEricTweak\SystemTrayIcon", @SW_HIDE )
	MsgBox ( 1, "Backup done", "Backup is done" )
EndFunc
