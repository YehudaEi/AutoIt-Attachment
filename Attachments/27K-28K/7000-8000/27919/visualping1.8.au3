#cs ----------------------------------------------------------------------------

    AutoIt Version: 3.3.0.0
    Author:         November
    Date: 2009, September 17

    Script Function:
    Script ping loop with dynamic hosts

#ce ----------------------------------------------------------------------------

; Start Script

;Includes

#include <ProgressConstants.au3>
#include <Guibutton.au3>
#Include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
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

HotKeySet("^z", "exity")
HotKeySet("{F1}", "help")

;Declaration

Dim $listview, $totalservers, $ping, $msg, $aRecords, $x, $exitB, $index, $item, $round, $Progress, $value, $FileHost, $host, $totalservers, $repeat, $stop, $gui, $errorhost, $HelpB, $teste, $nametoip, $location, $name, $tempfile, $exitHB, $decision, $u, $lat

;inicial declarations

$lat = 500
$host = 0;Grants no hostfile in the beginning
$scan = 0; Grants no Scan was made for correct file export

;GUI creation

$osversion = @OSVersion;Organizes the images for the buttons for w2k and winxp
select
    case $OSVersion = "WIN_2000"
        $iconexit = "105"
        $iconscan = "55"
        $iconhelp = "23"
        $iconfile = "70"
        $iconexport = "6"
		$iconlat = "186"

    case $OSVersion = "WIN_XP"
        $iconexit = "27"
        $iconscan = "22"
        $iconhelp = "23"
        $iconfile = "70"
        $iconexport = "6"
		$iconlat = "186"

    case $OSVersion = "WIN_VISTA"
        $iconexit = "28"
        $iconscan = "19"
        $iconhelp = "24"
        $iconfile = "23"
        $iconexport = "7"
		$iconlat = "186"

EndSelect

$gui = GUICreate("Visual Ping - Version 1.7", 450, 425, @DesktopHeight/2-120, @DesktopWidth/2-380, $WS_VISIBLE + $WS_CLIPSIBLINGS + $LVS_EX_GRIDLINES) ;, $LVS_EX_GRIDLINES and $LVS_EX_GRIDLINES
$menufile = GUICtrlCreateMenu("File")
$menuaction = GUICtrlCreateMenu("Action")
$menuoption = GUICtrlCreateMenu("Options")
$menuhelp = GUICtrlCreateMenu("Help")
$menufileHost = GUICtrlCreateMenuItem("Import Hosts", $menufile)
$menufileExport = GUICtrlCreateMenuItem("Export Result", $menufile)
$menufileexit = GUICtrlCreateMenuItem("Exit", $menufile)
$menuactionscan = GUICtrlCreateMenuItem("Scan Host File", $menuaction)
$menuoptionlatency = GUICtrlCreateMenuItem("Latency (ms)", $menuoption)
$menuhelpabout = GUICtrlCreateMenuItem("About", $menuhelp)
$progress = GUICtrlCreateProgress (20, 250, 150, 15, $PBS_SMOOTH)
$listview = GUICtrlCreateListView("     Server Name     |  Server Status  |Ping (ms)|  IP Address  ", 15, 20, 415, 210, $LVS_EX_HEADERDRAGDROP)
$FileHost = GUICtrlCreateButton("Host File", 200, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
$repeat = GUICtrlCreateButton("Scan Hosts", 245, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
$export = GUICtrlCreateButton("Export", 290, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
$exitB = GUICtrlCreateButton("Exit Program", 335, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
$HelpB = GUICtrlCreateButton("Help", 380, 263, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
GUISetFont(8, 60, 2, "Arial")
GUICtrlCreateLabel( "HOSTS", 205, 310, 50, 15)
GUICtrlCreateLabel( "SCAN", 250, 310, 50, 15)
GUICtrlCreateLabel( "EXPORT", 290, 310, 50, 15)
GUICtrlCreateLabel( "EXIT", 345, 310, 50, 15)
GUICtrlCreateLabel( "HELP", 385, 310, 50, 15)
GUICtrlCreateLabel( "OVERALL : ", 20, 270, 65, 15, $SS_SUNKEN, $SS_WHITERECT)
GUICtrlCreateLabel( "", 85, 270, 50, 15, $SS_SUNKEN )
GUICtrlCreateLabel( "TOTAL HOSTS: ", 20, 290, 115, 15, $SS_SUNKEN )
GUICtrlCreateLabel( "", 45, 325, 350, 15, $SS_SUNKEN)

;GUI Style

GUICtrlSetImage ($repeat, "shell32.dll",$iconscan)
GUICtrlSetImage ($FileHost, "shell32.dll",$iconfile)
GUICtrlSetImage ($exitB, "shell32.dll",$iconexit)
GUICtrlSetImage ($HelpB, "shell32.dll",$iconhelp)
GUICtrlSetImage ($export, "shell32.dll",$iconexport)

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
		case $msg = $menufileexit
			exity()
		case $msg = $menuoptionlatency
			latency()
		case $msg = $menuhelpabout
			help()
		case $msg =	$menufileHost
            file()
		case $msg =	$menufileExport
            export()
		case $msg =	$menuactionscan
			prerepeat()
	EndSelect
	Sleep(10)
Wend

;funcs

func prerepeat();Checks if host file is loaded
    Select
		case $host = 0 and $u = 0
			$errorhost = GUICtrlCreateLabel( "ERROR : HOST FILE NOT LOADED", 45, 325, 350, 15, $SS_SUNKEN)
			GUICtrlSetColor($errorhost, 0xff0000)
			return
		case $host = 0 and $u > 0
			repeat()
		Case $host = 1 and $u = 1
			repeat()
	EndSelect
EndFunc;end func prerepeat

Func repeat();Ping the Host File
    $name = "EXPORTDAY" & @YEAR & @WDAY  & @HOUR & @MIN & @SEC & ".TXT"
    $tempfile = _FileCreate(@TempDir & "\" & $name)
    FileWriteLine(@TempDir & "\" & $name, "SERVER,STATUS,IP" & @CRLF)
    _GUICtrlListView_DeleteAllItems ( $listview )
    $teste = UBound ( $aRecords )-1
	TCPStartup()
    for $x = 1 to $teste
        $errorhost = GUICtrlCreateLabel( "Scanning : " & $aRecords[$x], 45, 325, 350, 15, $SS_SUNKEN)
        $ping = ping($aRecords[$x], $lat)
		Select
			case $ping >= 1
				$iping = $ping
				$ping = "Online"
				$checkip = StringReplace($aRecords[$x], ".", "")
				$isIP = StringIsDigit($checkip)
				ConsoleWrite($checkip & ":" & $isIP & @CRLF)
				If $isIP = 1 Then
					$nametoip = "N/A"
				Else
					$nametoip = TCPNameToIP($aRecords[$x])
				EndIf
				if $nametoip = "" Then
					$nametoip = "***.***.***.***"
				EndIf
				$item = GUICtrlCreateListViewItem($aRecords[$x] & "|" & $ping & "|" & $iping & "|" & $nametoip, $listview)
				GUICtrlSetColor($item, 0x3cb371)
			case @error = 1
				$ping = "Host Offline"
				$iping = "N/A"
				$nametoip = "***.***.***.***"
				$item = GUICtrlCreateListViewItem($aRecords[$x] & "|" & $ping & "|" & $iping & "|" & $nametoip, $listview)
				GUICtrlSetColor($item, 0xff0000)
			case @error = 2
				$ping = "Host Unreachable"
				$iping = "N/A"
				$nametoip = "***.***.***.***"
				$item = GUICtrlCreateListViewItem($aRecords[$x] & "|" & $ping & "|" & $iping & "|" & $nametoip, $listview)
				GUICtrlSetColor($item, 0xff0000)
			case @error = 3
				$ping = "Bad Destination"
				$iping = "N/A"
				$nametoip = "***.***.***.***"
				$item = GUICtrlCreateListViewItem($aRecords[$x] & "|" & $ping & "|" & $iping & "|" & $nametoip, $listview)
				GUICtrlSetColor($item, 0xff0000)
			case @error = 4
				$ping = "Other Errors"
				$iping = "N/A"
				$nametoip = "***.***.***.***"
				$item = GUICtrlCreateListViewItem($aRecords[$x] & "|" & $ping & "|" & $iping & "|" & $nametoip, $listview)
				GUICtrlSetColor($item, 0xff0000)
		EndSelect
        $nametoip = TCPNameToIP($aRecords[$x])
            if $nametoip = "" Then
                $nametoip = "No IP Available"
            EndIf
        FileWriteLine(@TempDir & "\" & $name, $aRecords[$x] & "," & $ping & "," & $iping & "|" & $nametoip & @CRLF)
        $value = Number($x*100/$totalservers)
        $round = round($value)
        GUICtrlCreateLabel( "OVERALL : ", 20, 270, 65, 15, $SS_SUNKEN )
        GUICtrlCreateLabel( " " & $round & " %", 85, 270, 50, 15, $SS_SUNKEN )
        GUICtrlCreateLabel( "TOTAL HOSTS: " & $totalservers, 20, 290, 115, 15, $SS_SUNKEN )
        GUICtrlSetData($progress, $round)
    Next
    $errorhost = GUICtrlCreateLabel( "SCAN COMPLETED", 45, 325, 350, 15, $SS_SUNKEN)
    GUICtrlSetColor($errorhost, 0x3cb371)
    $scan = 1
	TCPShutdown()
EndFunc;end func repeat

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
EndFunc;end func export

Func file();Opens Host File and removes empty lines
    $host = FileOpenDialog("Host file location", @DesktopDir, "(*.txt)", 8+2)
        if @error = 1 and $u = 0 Then
            $host = 0
            Return
        EndIf
    _FileReadToArray($host,$aRecords)
	$u = UBound($aRecords)
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
EndFunc;end func file

Func help();Brings the Help Box

	if WinExists("Visual Ping - HELP") then Return; only one help gui allowed
    $helpgui = GUICreate("Visual Ping - HELP", 200, 200, @DesktopHeight/2, @DesktopWidth/2-250, $WS_CAPTION + $WS_SYSMENU)
    $help = GUICtrlCreateLabel("Visual Ping - Version 1.7" & @LF & @LF & "Simple program to ping hosts" & @LF & "Text file export" & @LF & @LF & "CTRL + Z - Exit program" & @LF & "F1 - Help " & @LF & @LF & "November 2009" & @LF & "Designed for Free Use", 20, 10)
    $exitHB = GUICtrlCreateButton("Exit Program", 75, 145, 45, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
    GUICtrlSetImage ($exitHB, "shell32.dll",$iconexit);, 0)
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
		Sleep(10)
    wend
EndFunc;end func help

func latency()
	$latgui = GUICreate("Latency", 130, 85, @DesktopHeight/2, @DesktopWidth/2-250, $WS_CAPTION + $WS_SYSMENU)
	$inputlat = GUICtrlCreateInput($lat, 10, 15, 40, 20)
	$latOK = GUICtrlCreateButton("OK", 65, 10, 55, 45, $BS_ICON,$BS_DEFPUSHBUTTON)
	GUICtrlSetImage ($latOK, "shell32.dll",$iconlat);, 0)
	GUISetState()
	    while 1
        $declat = GUIGetMsg()
        Select
			Case $declat = $GUI_EVENT_CLOSE
					$lat = $lat
				    GUIDelete($latgui)
					MsgBox(16, "Latency", "Cancelled")
                Return
            Case $declat = $latOK
				$newlat = GUICtrlRead($inputlat)
				if $newlat = 0 or $newlat = "" Then
					$lat = $lat
					GUIDelete($latgui)
					MsgBox(32, "Latency", "Latency not set. Latency is " & $lat & " ms.")
				Else
					GUIDelete($latgui)
					MsgBox(64, "Latency", "Latency set to " & $newlat & " ms.")
					$lat = $newlat
				EndIf
                Return
		EndSelect
		Sleep(10)
    wend
EndFunc

Func exity();Exit Program
    FileDelete(@TempDir & "\" & $name)
    exit
EndFunc;end func Exity

;End of script
