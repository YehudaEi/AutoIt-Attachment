#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=beta
#AutoIt3Wrapper_icon=CSicon.ico
#AutoIt3Wrapper_outfile=Craftsave.exe
#AutoIt3Wrapper_Res_Description=Craftsave-Minecraft Server Automatic Backups
#AutoIt3Wrapper_Res_Fileversion=0.9.4.0
#AutoIt3Wrapper_Res_LegalCopyright=Completely Free, no obligation, no warrantee.
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <zip.au3>
#include <date.au3>
#include <constants.au3>

Sleep( 500 )


;set some variables for system tray
Dim $winstate = "Hide Minecraft Console"
Dim $togsh=1
Dim $savetime = "None"
Dim $togasaves = 1
Dim $togshide, $togsave, $traysave, $trayexit, $trayfexit, $traysall

#Region INI Setup ;Config file setup
If FileExists ( "Craftsave.ini" ) Then
	$window=IniRead ( "Craftsave.ini", "Settings", "Window Name", "C:\Windows\system32\cmd.exe" )
	$prefix=IniRead ( "Craftsave.ini", "Settings", "Prefix", "Craftsave_" )
	$worlds=StringSplit(IniRead ( "Craftsave.ini", "Settings", "Worlds", "World,Nether" ), ",", 2 )
	$zipfolder=IniRead ( "Craftsave.ini", "Settings", "Backup Folder", @ScriptDir & "\" )
	If Not (StringRight ( $zipfolder, 1 ) = "\") Then
		$zipfolder = $zipfolder & "\"
	EndIf
	$broadcast=IniRead ( "Craftsave.ini", "Settings", "Broadcast", "Yes" )
	$minbsaves=IniRead ( "Craftsave.ini", "Settings", "Save Time", "120" )
	$numbackups=IniRead ( "Craftsave.ini", "Settings", "Days To Keep Backups", "2" )
	$fullworldpath=IniRead ( "Craftsave.ini", "Settings", "Path To World Folder", "")
	$saveall=IniRead ( "Craftsave.ini", "Settings", "Saveall Time", "0" )

Else
	IniWrite ( "Craftsave.ini", "Settings", "Window Name", "C:\Windows\system32\cmd.exe" )
	FileOpen ( "Craftsave.ini" )
	FileWrite ( "Craftsave.ini", ";Window Name is the name of the window your server runs in")
	IniWrite ( "Craftsave.ini", "Settings", "Prefix", "Craftsave_" )
	FileWrite ( "Craftsave.ini", ";Prefix is the beginning of your save file name")
	IniWrite ( "Craftsave.ini", "Settings", "Worlds", "World,Nether" )
	FileWrite ( "Craftsave.ini", ";Worlds is the list of world folders to backup separated by comma" )
	IniWrite ( "Craftsave.ini", "Settings", "Backup Folder", @ScriptDir & "\" )
	FileWrite ( "Craftsave.ini", ";Backup Folder is where your backups are stored, please use the full path")
	IniWrite ( "Craftsave.ini", "Settings", "Broadcast", "Yes" )
	FileWrite ( "Craftsave.ini", ";Change Broadcast to No to disable broadcasting saves to the server." )
	IniWrite ( "Craftsave.ini", "Settings", "Save Time", "120" )
	FileWrite ( "Craftsave.ini", ";Save Time is the amount of time in minutes between automatic saves. Set to 0 to permanently disable autosaves." )
	IniWrite ( "Craftsave.ini", "Settings", "Days To Keep Backups", "2" )
	FileWrite ( "Craftsave.ini", ";Days To Keep Backups is the number of days before a backup gets deleted. (1-30) Set to 0 to disable deletion." )
	IniWrite ( "Craftsave.ini", "Settings", "Path To World Folder", "" )
	FileWrite ( "Craftsave.ini", ";Path To World Folder is the full path of the folder your world folders are in, leave blank unless you are having issues." )
	IniWrite ( "Craftsave.ini", "Settings", "Saveall Time", "0" )
	FileWrite ( "Craftsave.ini", ";Saveall Time is the time in minutes between sending save-all to the server, 0 turns this feature off (default)" )
	FileClose ( "Craftsave.ini" )
	MsgBox ( 0, "Craftsave", "Craftsave.ini config file not found, created. Please adjust the settings in this file to suit your needs.")
	Exit
EndIf
#EndRegion INI Setup

;set some variables for controlling saves
Dim $saveallstate = 0
Dim $savestate = 0
Dim $lastsave
Dim $lastsaveall = _NowCalc()
Dim $diffsaveall

#Region Systray ;System Tray Setup
Opt ( "TrayMenuMode", 7 )
Opt ( "TrayOnEventMode", 1)
TraySetClick ( 8 )
$togshide=TrayCreateItem ( $winstate )
TrayItemSetOnEvent ( $togshide, "_togshide" )
$togsave =TrayCreateItem ("Toggle Autosave")
_asavestate ()
TrayItemSetOnEvent ( $togsave, "AStoggle")
$traysave=TrayCreateItem ( "Force Save" )
TrayItemSetOnEvent ( $traysave, "Saveit" )
$traysall=TrayCreateItem ( "Force Save-All" )
TrayItemSetOnEvent ( $traysall, "_saveall" )
TrayCreateItem ( "" )
$trayexit=TrayCreateItem ( "Exit Craftsave" )
TrayItemSetOnEvent ( $trayexit, "Exitprog" )
$trayfexit=TrayCreateItem ( "Force Close (Last Resort)" )
TrayItemSetOnEvent ( $trayfexit, "ForceExit" )
TraySetToolTip ( "Last Save: " & $savetime )
Sleep (200)
#EndRegion Systray



#Region Splash Text ;Get fancy
SplashTextOn("","Craftsave Reborn v1" & @CRLF & "Created by(Malface) Fixed By Chernobyl","-1","-1","-1","-1",35,"Courier New","16","400")
Sleep ( 3500 )
SplashOff()
#EndRegion Splash Text

;save server window
If WinExists ( $window )=0 Then
	$pid=ProcessExists( "cmd.exe" )
	If WinExists ( _GetHwndFromPID($pid) ) = 0 Then
		;Opt("WinTitleMatchMode", 2)  ;Sets it to search for the closest matching window, not recommended.
		If Winexists ( $window )=0 Then
			$errwind=MsgBox (4, "Craftsave Error", "Cannot find the Minecraft Server Window." & @CR & "Click Yes for Craftsave to find it, click No to exit.")
			If $errwind=6 Then
				MsgBox (0, "Finding Server Window", "Click Ok, then click inside your server window to make it the active window." & @CR & "Craftsave will wait 20 seconds, then set the active window as your server.")
				Sleep(20000)
				$window=WinGetTitle("[active]")
				If $window=0 Then
					WinSetTitle ( "[active]", "", "Minecraft Server - Protected By Craftsave")
					$window="Minecraft Server - Protected By Craftsave"
				EndIf
				IniWrite ( "Craftsave.ini", "Settings", "Window Name", $window )
				Dim $winid=WinGetHandle ($window)
				MsgBox (0, "Server Found", "Craftsave found your server and set it to " & $window & "." & @CR & "If you continue to see this message, you may need to run your server in a plain cmd window.")
			Else
				Exitprog()
			EndIf
		Else

		Dim $winid=WinGetHandle ($window)
		;MsgBox (0, "Wintitlematch", "Your window is " & WinGetTitle ($winid ) )  ;Window Debug Mode

		EndIf
	Else
		$winid=_GetHWndFromPID($pid)
		;MsgBox (0, "PIDmatch", "Your window is " & WinGetTitle($winid ) )  ;Window Debug Mode
	EndIf
Else
	Dim $winid=WinGetHandle ($window)
	;MsgBox (0, "INIfile", "Your window is " & WinGetTitle($winid ) )  ;Window Debug Mode
EndIf

WinActivate ( $winid )
$state = WinGetState ( $winid )
If BitAND ($state, 2) Then
	$winstate = "Hide Minecraft Console"
Else
	$winstate = "Show Minecraft Console"
EndIf
TrayItemSetText( $togshide, $winstate )

Saveit()
$lastsave= _NowCalc()
Sleep( 100 )

;Main loop with autosave timer
While 1
	Select
		Case WinExists ($winid) = 0
			Exitprog()
		Case $saveall > 0
			$diffsaveall = _DateDiff ( 'n', $lastsaveall, _NowCalc () )
			If $diffsaveall >= $saveall Then
				_saveall()
			EndIf
			Sleep ( 100 )
			ContinueCase
		Case $minbsaves > 0 And $togasaves = 1
			$diffsaveit= _DateDiff ( 'n', $lastsave, _NowCalc() )
			If $diffsaveit >= $minbsaves Then
				Saveit()
				$lastsave=_NowCalc ()
			EndIf
			Sleep ( 500 )
			ContinueLoop
	EndSelect
		Sleep (100)
		ContinueLoop
WEnd

;Functions

Func _asavestate()
	If $minbsaves = 0 Then
		TrayItemSetState ( $togsave, 128 )
	ElseIf $togasaves=1 Then
		TrayItemSetState ( $togsave, 1 )
	Else
		TrayItemSetState ( $togsave, 4 )
	EndIf
EndFunc

Func bm ($st)
	TrayItemSetState ( $st , 128 )
EndFunc

Func _BlankMenu ($tf)
If $tf = 0 Then
	bm ( $togshide )
	bm ( $togsave )
	bm ( $traysave )
	bm ( $traysall )
	bm ( $trayexit )
Else
	TrayItemSetState ( $togshide, 68 )
	TrayItemSetState ( $togsave, 64 )
	_asavestate()
	TrayItemSetState ( $traysave, 68 )
	TrayItemSetState ( $traysall, 68 )
	TrayItemSetState ( $trayexit, 68 )
EndIf
EndFunc




Func AStoggle() ;Controls the toggle switch for autosaves in the system tray
	If $togasaves=1 Then
		$togasaves=0
		TrayItemSetState ( $togsave, 4)
	Else
		$togasaves=1
		TrayItemSetState ( $togsave, 1)
	EndIf
	Sleep ( 100 )
EndFunc

Func deleteold() ;checks if files should be deleted and deletes them if they pass all tests
	FileChangeDir ($zipfolder)
	$saves = FileFindFirstFile ( "*.zip" )
	While 1
		$file = FileFindNextFile ( $saves )
		If @error Then
			ExitLoop
		ElseIf $numbackups > 30 Then
			ExitLoop
		ElseIf _IsOld ($file) = 1 And StringLeft ( $file, StringLen( $prefix) ) = $prefix  Then
			FileDelete ( $file )
			Sleep ( 500 )
		Else
			ExitLoop
		EndIf
	WEnd
	FileClose($saves)
	Sleep ( 100 )
EndFunc

Func _IsOld ( $filedate ) ;checks if file is old enough to delete based on ini setting
	$arrDate= FileGetTime ( $filedate, 1, 0)
	$datestring= $arrDate[0] & "/" & $arrDate[1] & "/" & $arrDate[2] & " " & $arrDate[3] & ":" & $arrDate[4] & ":" & $arrDate[5]
	If _DateDiff ('D', $datestring, _NowCalc() ) > $numbackups Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func Saveit() ;Saves the world, sends messages to server window
If $savestate="0" Then
	If $saveallstate = 1 Then
		While $saveallstate = 1
			Sleep ( 100 )
		WEnd
	EndIf
	$savestate="1"
	TraySetToolTip( "Backup In Progress" )
	_BlankMenu (0)

	;Add the full path to the world folders from the ini
	If $fullworldpath = "" Then
		$path=StringTrimRight (@ScriptDir, 9 )
	ElseIf StringRight ( $fullworldpath, 1) = "" Then
		$path=$fullworldpath & "\"
	Else
		$path=$fullworldpath
	EndIf
	Dim $pathworlds[UBound($worlds)]
	For $world In $worlds
		_ArrayAdd ($pathworlds, $path & $world)
		_ArrayDelete ($pathworlds, 0)
	Next

	Dim $leavesaveit=0

	;Check that the world folders are all there.
	For $pathworld In $pathworlds
		If FileExists($pathworld)=0 Then
			$fullworldpath=InputBox ("Craftsave Error", $pathworld & " folder not found. Please enter the full path to the location of your world files.")
			If $fullworldpath=1 Then
				Exit
			EndIf
			If StringRight ($fullworldpath, 1 ) = "\" Then
			IniWrite ( "Craftsave.ini", "Settings", "Path To World Folder", $fullworldpath )
			$leavesaveit=1
			ExitLoop
			Else
			$fullworldpath = $fullworldpath & "\"
			IniWrite ( "Craftsave.ini", "Settings", "Path To World Folder", $fullworldpath )
			$leavesaveit=1
			ExitLoop

			EndIf

		EndIf
	Next
	If $leavesaveit=0 Then

		;Stop saves in Minecraft
		SendToMC ( "save-off" )
		If $broadcast = "Yes" Then
		SendToMC ( "say +Craftsave is backing up World files..." )
		EndIf
		;Create the zip file
		Local Const $zipfile=$zipfolder & $prefix & @MON & "-" & @MDAY & "-" & @YEAR & "_" & @HOUR & @MIN & ".zip"
		_Zip_Create ($zipfile)
		Sleep ( 500 )
		For $folder In $pathworlds
			If IsString ( $folder) Then ;For people with trailing commas
			_Zip_AddFolder ($zipfile, $folder, 0)
			Sleep ( 500 )
			EndIf
		Next

		;Restart saves in Minecraft
		SendToMC( "save-on" )
			If $broadcast = "Yes" Then
			SendToMC ( "say ...completed World backup." )
			EndIf
			$savetime = _Now ()
			TraySetToolTip ( "Last Save: " & $savetime )

			;Delete old backups
			If $numbackups < 30 AND $numbackups > 0 Then
				deleteold()
				$savestate = "0"
				_BlankMenu (1)
			Else
				$savestate = "0"
				_BlankMenu (1)
			EndIf
	Else
		$savestate= "0"
		$leavesaveit= "0"
		MsgBox ( 0, "Settings Changed", "Your folder has been changed to the new setting.  Use Force Save from the tray menu to try again." )
		TraySetToolTip ( "Last Save: " & $savetime )
	EndIf

Else
			MsgBox (0, "Craftsave Error", "Craftsave is currently in the middle of a save, try again soon.",20)
EndIf



EndFunc

Func SendToMC( $command ) ;Send Command to Minecraft Server Window
	$statebit=WinGetState ( $winid )
	IF NOT BitAND( $statebit, 2 ) Then
		WinActivate ( $winid )
	EndIf
		Controlsend ( $winid,"","", $command & "{ENTER}" )
		Sleep ( 100 )
EndFunc

;Function for getting HWND from PID
Func _GetHwndFromPID($procid)
	If $procid = 0 Then
		Return 0
	Else
	$hWnd = 0
	$winlist = WinList()
	Do
		For $i = 1 To $winlist[0][0]
			If $winlist[$i][0] <> "" Then
				$iPID2 = WinGetProcess($winlist[$i][1])
				If $iPID2 = $procid Then
					$hWnd = $winlist[$i][1]
					ExitLoop
				EndIf
			EndIf
		Next
	Until $hWnd <> 0
	Return $hWnd
	EndIf
EndFunc;==>_GetHwndFromPID

Func _saveall ()
	_BlankMenu (0)
	If $savestate = 1 Then
		While $savestate = 1
			Sleep ( 100 )
		WEnd
	EndIf
	If $saveallstate = 1 Then
		While $saveallstate = 1
			Sleep ( 100 )
		WEnd
	EndIf
	If $savestate = 0 Then
		$saveallstate = 1
		SendToMC ( "save-all" )
		$lastsaveall = _NowCalc ()
		Sleep ( 120000 )
	EndIf
	$saveallstate = 0
	_BlankMenu (1)
EndFunc

Func _togshide ()
		WinActivate ($winid)
		If $togsh = 1 Then
			WinSetState ($winid, "", @SW_HIDE )
			$winstate= "Show Minecraft Console"
			TrayItemSetText ( $togshide, $winstate )
			$togsh = 0
		Else
			WinSetState ($winid, "", @SW_SHOW )
			$winstate= "Hide Minecraft Console"
			TrayItemSetText ( $togshide, $winstate )
			$togsh = 1
		EndIf
		Sleep ( 100 )
EndFunc


Func Exitprog() ;exits the program if no saves are in progress
	If $savestate = 0 Then
		Exit
	Else
		MsgBox(0, "Craftsave", "Please wait for all saves to complete.", 10)
	EndIf
EndFunc

Func ForceExit()
	Exit
EndFunc




