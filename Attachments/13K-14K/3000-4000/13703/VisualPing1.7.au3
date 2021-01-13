#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.2.0
	Author:         November
	Date: 2007, March 02
	
	Script Function:
	Script ping loop with dynamic hosts
	
#ce ----------------------------------------------------------------------------

; Start Script
;Includes

#include <GuiListView.au3>
#include <GUIConstants.au3>
#include <GuiList.au3>
#include <GuiTreeView.au3>
#include <file.au3>
#include <array.au3>

;Options

;Opt ("GUICloseOnESC", 1)
Opt ("TCPTimeout", 10)
Opt("TrayIconHide", 1)
Opt("TrayAutoPause", 0)
Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 0)

;Hotkeys

HotKeySet("{ESC}", "exity")
HotKeySet("{F1}", "help")

;Declaration

Dim $listview, $totalservers, $ping, $msg, $aRecords, $x, $exitB, $index, $item, $round, $Progress, $value, $FileHost, $host, $totalservers, $repeat, $stop, $gui, $errorhost, $HelpB, $teste, $nametoip, $location, $name, $tempfile, $exitHB, $decision

;inicial declarations

$host = 0;Grants no hostfile in the beginning
$scan = 0; Grants no Scna was made for correct file export
;GUI creation

$osversion = @OSVersion;Organizes the images for the buttons for w2k and winxp
select
	case $OSVersion = "WIN_2000"
		$iconexit = "105"
		$iconscan = "55"
		$iconhelp = "23"
		$iconfile = "70"
		$iconexport = "6"
		
	case $OSVersion = "WIN_XP"
		$iconexit = "27"
		$iconscan = "22"
		$iconhelp = "23"
		$iconfile = "70"
		$iconexport = "6"
		
EndSelect

$gui = GUICreate("Visual Ping - Version 1.7", 450, 375, @DesktopHeight/2-120, @DesktopWidth/2-380, $WS_VISIBLE + $WS_CLIPSIBLINGS + $LVS_EX_GRIDLINES) ;, $LVS_EX_GRIDLINES and $LVS_EX_GRIDLINES
$progress = GUICtrlCreateProgress (20, 250, 150, 15); $PBS_SMOOTH
$listview = GUICtrlCreateListView("        Server Name         |     Server Status    |              IP Address         ", 15, 20, 415, 210, $LVS_EX_HEADERDRAGDROP)
$FileHost = GUICtrlCreateButton("Host File", 200, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
$repeat = GUICtrlCreateButton("Scan Hosts", 245, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
$export = GUICtrlCreateButton("Export", 290, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
$exitB = GUICtrlCreateButton("Exit Program", 335, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
$HelpB = GUICtrlCreateButton("Help", 380, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
GUICtrlCreateLabel( "HOSTS", 205, 310, 50, 15)
GUICtrlCreateLabel( "SCAN", 250, 310, 50, 15)
GUICtrlCreateLabel( "EXPORT", 290, 310, 50, 15)
GUICtrlCreateLabel( "EXIT", 345, 310, 50, 15)
GUICtrlCreateLabel( "HELP", 385, 310, 50, 15)

;GUI Style

GUICtrlSetImage ($repeat, "shell32.dll",$iconscan)
GUICtrlSetImage ($FileHost, "shell32.dll",$iconfile)
GUICtrlSetImage ($exitB, "shell32.dll",$iconexit)
GUICtrlSetImage ($HelpB, "shell32.dll",$iconhelp)
GUICtrlSetImage ($export, "shell32.dll",$iconexport)
GUICtrlCreateLabel( "OVERALL : ", 20, 270, 65, 15, $SS_SUNKEN, $SS_WHITERECT)
GUICtrlCreateLabel( "", 85, 270, 50, 15, $SS_SUNKEN )
GUICtrlCreateLabel( "TOTAL HOSTS: ", 20, 290, 115, 15, $SS_SUNKEN )
GUISetFont(9, 400, 2, "Monotype Corsiva")
GUISetFont(9, 400, "", "")

;Read GUI

GUISetState()

;Selection Loop

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			exity()
		Case $msg = $exitB
			exity()
		Case $msg = $repeat
			prerepeat()
		Case $msg = $export
			export()
		Case $msg = $FileHost
			file()
		Case $msg = $helpb
			help()
	EndSelect
Wend

;funcs

func prerepeat();Checks if host file is loaded
	if not $host = 0 Then
		repeat()
		;Return
	Else
		$errorhost = GUICtrlCreateLabel( "ERROR : HOST FILE NOT LOADED", 45, 325, 350, 15, $SS_SUNKEN)
		GUICtrlSetColor($errorhost, 0xff0000)
		return
	EndIf
EndFunc

Func repeat();Ping the Host File
	$name = "EXPORTDAY" & @YEAR & @WDAY  & @HOUR & @MIN & @SEC & ".TXT"
	$tempfile = _FileCreate(@TempDir & "\" & $name)
	FileWriteLine(@TempDir & "\" & $name, "SERVER,STATUS,IP" & @CRLF)
	TCPStartup()
	_GUICtrlListViewDeleteAllItems ( $listview )
	$teste = UBound ( $aRecords )-1
	for $x = 1 to $teste
		$errorhost = GUICtrlCreateLabel( "Scanning : " & $aRecords[$x], 45, 325, 350, 15, $SS_SUNKEN)
		$ping = ping($aRecords[$x], 2)
		$nametoip = TCPNameToIP($aRecords[$x])
			if $nametoip = "" Then
				$nametoip = "NO IP AVAILABLE"
			EndIf
		if $ping Then
			$ping = "ONLINE"
			$item = GUICtrlCreateListViewItem($aRecords[$x] & "|" & $ping & "|" & $nametoip, $listview)
			GUICtrlSetColor($item, 0x3cb371)
		Else
			$ping = "OFFLINE"
			$item = GUICtrlCreateListViewItem($aRecords[$x] & "|" & $ping & "|" & $nametoip, $listview)
			GUICtrlSetColor($item, 0xff0000)
		EndIf
		FileWriteLine(@TempDir & "\" & $name, $aRecords[$x] & "," & $ping & "," & $nametoip & @CRLF)
		$value = Number($x*100/$totalservers)
		$round = round($value)
		GUICtrlCreateLabel( "OVERALL : ", 20, 270, 65, 15, $SS_SUNKEN )
		GUICtrlCreateLabel( " " & $round & " %", 85, 270, 50, 15, $SS_SUNKEN )
		GUICtrlCreateLabel( "TOTAL HOSTS: " & $totalservers, 20, 290, 115, 15, $SS_SUNKEN )
		GUICtrlSetData($progress, $round)
	Next
	$errorhost = GUICtrlCreateLabel( "SCAN COMPLETED", 45, 325, 350, 15, $SS_SUNKEN)
	GUICtrlSetColor($errorhost, 0x3cb371)
	TCPShutdown()
	$scan = 1
EndFunc

Func export()
	If $scan = 0 Then
		$errorhost = GUICtrlCreateLabel( "ERROR : SCAN THE FILE FIRST", 45, 325, 350, 15, $SS_SUNKEN)
		GUICtrlSetColor($errorhost, 0xff0000)
		Return
	Else
		$location = FileSelectFolder("Choose folder", "")
		If @error = 1 Then
			$errorhost = GUICtrlCreateLabel( "ERROR : FOLDER NOT SELECTED", 45, 325, 350, 15, $SS_SUNKEN)
			GUICtrlSetColor($errorhost, 0xff0000)
			$location = ""
			Return
		EndIf
		$filecopy = FileCopy(@TempDir & "\" & $name, $location, 0)
		If $filecopy = 0 Then
			$errorhost = GUICtrlCreateLabel( "ERROR : FILE NOT CREATED", 45, 325, 350, 15, $SS_SUNKEN)
			GUICtrlSetColor($errorhost, 0xff0000)
			$filecopy = 0
			MsgBox(0, "filecopy", $filecopy)
			Return
		EndIf
	EndIf
	$errorhost = GUICtrlCreateLabel( "FILE: " & $name & " CREATED", 45, 325, 350, 15, $SS_SUNKEN)
	GUICtrlSetColor($errorhost, 0x3cb371)
EndFunc

Func file();Opens Host File and removes empty lines
	$host = FileOpenDialog("Host file location", @DesktopDir, "(*.txt)", 8+2)
		if @error = 1 Then
			$host = 0
			Return
		EndIf
	_FileReadToArray($host,$aRecords)
	while 1
		$newvar = _ArraySearch($aRecords, "", 0, 0, 0, false)
		if @error = 6 Then
			ExitLoop
		Else
			_ArrayDelete($aRecords, $newvar)
		EndIf
	wend
	$totalservers = UBound ( $aRecords )-1
	$errorhost = GUICtrlCreateLabel( "HOST FILE LOADED", 45, 325, 350, 15, $SS_SUNKEN)
	GUICtrlCreateLabel( "TOTAL HOSTS: " & $totalservers, 20, 290, 115, 15, $SS_SUNKEN )
	GUICtrlSetColor($errorhost, 0x3cb371)
	Return
EndFunc

Func help();Brings the Help Box
	$helpgui = GUICreate("Visual Ping - HELP", 220, 175, @DesktopHeight/2, @DesktopWidth/2-250, $WS_CAPTION + $WS_SYSMENU)
	$help = GUICtrlCreateLabel("Visual Ping - Version 1.7" & @LF & @LF & "Simple program to ping hosts" & @LF & "Text file export" & @LF & "" & @LF & "November 2007" & @LF & "Designed for Free Use", 20, 10)
	$exitHB = GUICtrlCreateButton("Exit Program", 85, 120, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
	GUICtrlSetImage ($exitHB, "shell32.dll",$iconexit, 0)
	GUISetState()
	while 1
		$decision = GUIGetMsg()
		Select
			Case $decision = $GUI_EVENT_CLOSE
				GUIDelete($helpgui)
				Return
			Case $decision = $exitHB
				GUIDelete($helpgui)
				Return
		EndSelect
	wend
EndFunc

Func exity();Exit Program
	FileDelete(@TempDir & "\" & $name)
	exit
EndFunc

;Fim de script