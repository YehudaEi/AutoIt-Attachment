#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\Icons\greg\metacafe_com.ico
#AutoIt3Wrapper_Outfile=..\..\..\..\Documents and Settings\Greg\Desktop\jdast pack\JDAutoSpeedTester.exe
#AutoIt3Wrapper_Res_Comment=JDAST
;~ #AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=JackDinn`s Auto SpeedTester
#AutoIt3Wrapper_Res_Fileversion=8.9.0.0
#AutoIt3Wrapper_Res_LegalCopyright=JackDinn software lol
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****




#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <string.au3>
#include <Timers.au3>
#include <Misc.au3>
#include <Constants.au3>
#include <GDIPlus.au3>
#include <StaticConstants.au3>
#include <GuiListView.au3>
#include <ReduceMemory.au3>
#include <GuiComboBox.au3>
#include <GuiListBox.au3>
#include <INet.au3>
#include <FTP_Ex.au3>
#include <GuiEdit.au3>
#include <ScrollBarConstants.au3>




#Region GUICREATE ....
Opt("TrayMenuMode", 1) ;~##################################### TRAY MODE   #################################
_Singleton(@ScriptName)
Global $pip = _GetIP()
For $x = 1 To 20
	Sleep(200)
	If @InetGetActive = 0 Then ExitLoop
Next
InetGet("                                                  ", @AppDataDir & "\jdast\jdast.ver", 1, 1)
$form1 = GUICreate("JackDinn`s Auto Speed Tester", 1008, 700, 0, 0, BitOR($WS_MAXIMIZEBOX, $ws_sizebox, $ws_minimizebox, $WS_SYSMENU, $WS_CAPTION, $WS_POPUPWINDOW, $WS_BORDER))
GUISetBkColor(0x8899ff)
GUICtrlCreatePic(@ProgramFilesDir & "\jdast\DROPLETS.JPG", 0, 0, 1008, 85)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
GUICtrlCreatePic(@ProgramFilesDir & "\jdast\DROPLETS.JPG", 0, 0, 192, 700)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
GUICtrlCreatePic(@ProgramFilesDir & "\jdast\DROPLETS.JPG", 1005, 0, 8, 700)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$Group1 = GUICtrlCreateGroup("", 6, 2, 993, 73)
$Input1 = GUICtrlCreateInput("60", 648, 44, 153, 21)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
GUICtrlSetTip(-1, "Frequency of testing cycles in Minutes", "", 0, 1)
$Label1 = GUICtrlCreateLabel("Cycle Minutes", 648, 18, 154, 20)
GUICtrlSetColor(-1, 0xffffff)
GUICtrlSetFont(-1, 14)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetTip(-1, "Frequency of testing cycles in Minutes", "", 0, 1)
$Button1 = GUICtrlCreateButton("Run Single Test", 16, 18, 145, 49, $BS_MULTILINE)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$Button4 = GUICtrlCreateButton("Display CSV", 320, 18, 145, 49, $BS_MULTILINE)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$Button2 = GUICtrlCreateButton("Send To Tray", 848, 18, 145, 49, $BS_MULTILINE)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$Checkbox1 = GUICtrlCreateCheckbox("Open After Cycle. OFF", 470, 16, 147, 53, BitOR($BS_MULTILINE, $BS_PUSHLIKE, $BS_CHECKBOX, $BS_AUTOCHECKBOX, $WS_TABSTOP))
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
GUICtrlSetTip(-1, "Will Open the graph after each test cycle", "", 0, 1)
$tracertbut = GUICtrlCreateButton("Tracert", 168, 18, 145, 49, 0)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$ListView1 = GUICtrlCreateListView("NO.|Date     Time |DL Kb/s|UL Kb/s|Ping ms", 4, 84, 184, 593)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_LV_ALTERNATE)
GUICtrlSetBkColor(-1, 0xffffff)
$hButleft = GUICtrlCreateButton("Scroll Left", 191, 657, 407, 22)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$hButright = GUICtrlCreateButton("Scroll Right", 599, 657, 407, 22)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$MenuItem1 = GUICtrlCreateMenu("Menu")
$Clearcsv = GUICtrlCreateMenuItem("Clear CSV File", $MenuItem1)
$scrnsht = GUICtrlCreateMenuItem("Save a shot of graph to a JPG file", $MenuItem1)
$bgpx = GUICtrlCreateMenu("Set Background Pic", $MenuItem1)
$bgp = GUICtrlCreateMenuItem("Set Background Pic", $bgpx)
$bgpc = GUICtrlCreateMenuItem("Clear Backgroud Pic", $bgpx)
$update = GUICtrlCreateMenuItem("Check For Update", $MenuItem1)
$config = GUICtrlCreateMenuItem("Config", $MenuItem1)
$about = GUICtrlCreateMenuItem("Help/About", $MenuItem1)
$Mexit = GUICtrlCreateMenuItem("Exit", $MenuItem1)
#EndRegion GUICREATE ....
#Region  Globals ....

Global $version = "8.9"
Global $hWnd = WinGetHandle("JackDinn`s Auto Speed Tester")
Global $goodspeed
Global $trigger = 0
Global $ping
Global $wherefrom
Global $array
Global $garray
Global $timex = 60
Global $maxlogsize = 400
Global $xarray[$maxlogsize + 5][4]
Global $csvfile = @MyDocumentsDir & "\Speed_Tester"
Global $c
Global $tgm
Global $Kbpersec
Global $Kbpersec_up
Global $labledim[100]
Global $cancledtest = 0
Global $bitmap
Global $backbuffer
Global $ymult = 1
Global $yplus = 0
Global $bannerswt = 0
Global $updown = 1
Global $colsortno = 0
Global $lows = 4
Global $autoupdate = 4
Global $loadintray = 4
Global $silentrunning = 4
Global $pausetesting = 0
Global $xposgraph = 0
Global $backgroundpic = ""
Global $mintime = 60
Global $mintimex = 0
Global $slowtestfileloc = "                                          "
Global $maintestfileloc = "                                           "
Global $maintestfilesize = 10
Global $slowtestfilesize = 5
Global $tctout = 999
Global $maxdlspeed = 0
Global $updatedone = 0
Global $PPqarray[105]
Global $rtob
Global $rtob_tog
Global $hideip = 0
Global $ftpupfile
Global $ftpupfilesize
Global $ftpserver
Global $ftpusername
Global $ftppassword
Global $ftpuplocation
Global $progressbar1
Global $cancletestcyclebut
Global $ftpultrim
Global $notify_sound = "0"

AutoItSetOption("MouseCoordMode", 2)
AutoItSetOption("pixelCoordMode", 2)
TraySetClick(16)
TraySetToolTip("JDAST")
$trayshow = TrayCreateItem("Show / Hide")
$pause = TrayCreateItem("Pause")
$trayexit = TrayCreateItem("Exit")
GUIRegisterMsg($WM_PAINT, "_ReDraw")
#EndRegion ### END Koda GUI section ###

#Region just run
If FileExists($csvfile & "\Speed_Test.csv") = 0 Then
	DirCreate(@MyDocumentsDir & "\Speed_Tester")
	Sleep(1000)
	_FileWriteLog($csvfile & "\Speed_Test.csv", "," & "DL Speed" & "," & "UL Speed" & "," & "Ping")
EndIf
If FileExists(@AppDataDir & "\jdast") = 0 Then DirCreate(@AppDataDir & "\jdast")
_GDIPlus_Startup()
$lows = IniRead(@AppDataDir & "\jdast\main.ini", "main", "lows", 4)
$timex = IniRead(@AppDataDir & "\jdast\main.ini", "main", "frequency", 60)
$autoupdate = IniRead(@AppDataDir & "\jdast\main.ini", "main", "autoupdate", 4)
$updatetime = IniRead(@AppDataDir & "\jdast\main.ini", "main", "autoupdatetime", @MDAY)
$backgroundpic = IniRead(@AppDataDir & "\jdast\main.ini", "main", "bgpic", "")
$loadintray = IniRead(@AppDataDir & "\jdast\main.ini", "main", "loadintray", 4)
$silentrunning = IniRead(@AppDataDir & "\jdast\main.ini", "main", "silentrunning", 4)
$mintimex = IniRead(@AppDataDir & "\jdast\main.ini", "main", "mintime", 0)
$slowtestfileloc = IniRead(@AppDataDir & "\jdast\main.ini", "main", "stfl", "                                          ")
$maintestfileloc = IniRead(@AppDataDir & "\jdast\main.ini", "main", "mtfl", "                                           ")
$slowtestfilesize = IniRead(@AppDataDir & "\jdast\main.ini", "main", "stfs", 5)
$maintestfilesize = IniRead(@AppDataDir & "\jdast\main.ini", "main", "mtfs", 10)
$tctout = IniRead(@AppDataDir & "\jdast\main.ini", "main", "tctout", 999)
$maxdlspeed = IniRead(@AppDataDir & "\jdast\main.ini", "main", "maxdlspeed", 0)
$rtob = IniRead(@AppDataDir & "\jdast\main.ini", "main", "rtob", 4)
$ftpupfile = IniRead(@AppDataDir & "\jdast\main.ini", "main", "ftpupfile", 0)
$ftpupfilesize = IniRead(@AppDataDir & "\jdast\main.ini", "main", "ftpupfilesize", 0)
$ftpserver = IniRead(@AppDataDir & "\jdast\main.ini", "main", "ftpserver", 0)
$ftpusername = IniRead(@AppDataDir & "\jdast\main.ini", "main", "ftpusername", 0)
$ftppassword = IniRead(@AppDataDir & "\jdast\main.ini", "main", "ftppassword", 0)
$ftppassword = _StringEncrypt(0, $ftppassword, "nottoforget99")
$ftpuplocation = IniRead(@AppDataDir & "\jdast\main.ini", "main", "ftpuplocation", 0)
$ftpultrim = IniRead(@AppDataDir & "\jdast\main.ini", "main", "ultrim", 0)
$notify_sound = IniRead(@AppDataDir & "\jdast\main.ini", "main", "notifysound", 0)

$rtob_tog = $rtob
_FileReadToArray(@AppDataDir & "\jdast\programList.txt", $PPqarray)
$runbyreg = String($cmdline[$cmdline[0]])
If $mintimex = 1 Then $mintime = 1
If StringInStr($maintestfileloc, "thinkbroadband.com") = 0 Then $mintime = 1
GUICtrlSetData($Input1, $timex)
traytipset()
If $loadintray = 4 And $runbyreg <> "tray" Then
	GUISetState(@SW_SHOW, $form1)
	main()
Else
	readin()
	If $rtob_tog = 1 Then
		$rtob_tog = 0
		cyclegregtest()
	EndIf
	littleloop()
EndIf
Exit
#EndRegion just run

Func main();;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  MAIN ;;
	If GUICtrlRead($Checkbox1) = 1 Then
		GUISetState(@SW_SHOW, $form1)
	EndIf
	readin()
	display()
	_reDraw()
	_reducememory()
	If $rtob_tog = 1 Then
		$rtob_tog = 0
		cyclegregtest()
		main()
	EndIf
	$c = @MIN
	While 1
		If $timex < $mintime Then
			$timex = $mintime
			GUICtrlSetData($Input1, $mintime)
		EndIf
		$nMsg = GUIGetMsg()
		$tgm = TrayGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Button2 ;;;;;;;;;;;;;;;;;SEND TO TRAY
				ToolTip("")
				littleloop()
			Case $about ;;;;;;;;;;;;;;;;;ABOUT INFO
				_helpabout()
			Case $GUI_EVENT_PRIMARYDOWN ;;;;;;;Sliders -- Buttons
				If WinActive("JackDinn`s Auto Speed Tester") = 1 Then
					_reDraw()
				EndIf
				While 1
					$rr = GUIGetCursorInfo()
					If _IsPressed("01") = 0 Then ExitLoop
					If $rr[4] = $hButright Then
						$xposgraph -= 5
						If $xposgraph < 0 Then $xposgraph = 0
						display()
						_reducememory()
					EndIf
					If $rr[4] = $hButleft Then
						$xposgraph += 5
						If $xposgraph > $xarray[0][0] - 70 Then $xposgraph = $xarray[0][0] - 70
						display()
						_reducememory()
					EndIf
				WEnd
			Case $config ;;;;;;;;;;;CONFIG
				_config()
				If StringInStr($maintestfileloc, "thinkbroadband.com") = 0 Or $mintimex = 1 Then
					$mintime = 1
				Else
					$mintime = 60
				EndIf
			Case $ListView1 ;;;;;;;;;;;;;;;;;;;;;;;LIST VIEW SORT
				$colsortno = GUICtrlGetState($ListView1)
				$updown = Not $updown
				_listview1()
			Case $Checkbox1 ;;;;;;;;;;;;;;;;;;;Open after cycle
				If GUICtrlRead($Checkbox1) = 1 Then
					GUICtrlSetData($Checkbox1, "Open After Cycle. ON")
				Else
					GUICtrlSetData($Checkbox1, "Open After Cycle. OFF")
				EndIf
			Case $Button1 ;;;;;;;;;;;;;;;;;RUN SINGLE TEST
				If $pausetesting = 0 Then
					_onetest()
					main()
				Else
					SplashTextOn("", "Testing is on PAUSE, can not run test.", -1, 50)
					Sleep(1500)
					SplashOff()
				EndIf
			Case $Button4 ;;;;;;;;;;;;;;;;;DISPLAY CSV DATA
				readin()
				$xarray[0][0] = $xarray[0][0] & " Entries     MAX VALUES ="
				$xarray[1][0] = "Time"
				$xarray[1][1] = "DL Speed Kb/s"
				$xarray[1][2] = "UL Speed Kb/s"
				$xarray[1][3] = "Ping ms"
				_ArrayDisplay($xarray, "JackDinn`s CSV Display", $maxlogsize + 2)
				readin()
			Case $Input1 ;;;;;;;;;;;;;;;;;FREQUENCY INPUT
				If GUICtrlRead($Input1) = String("jack") Then
					$mintime = 1
					$mintimex = 1
					IniWrite(@AppDataDir & "\jdast\main.ini", "main", "mintime", 1)
				EndIf
				If GUICtrlRead($Input1) > $mintime Then
					$timex = GUICtrlRead($Input1)
					GUICtrlSetState($Button2, $GUI_FOCUS)
				Else
					GUICtrlSetData($Input1, $mintime)
				EndIf
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "frequency", $timex)
			Case $Clearcsv ;    ;;;;;;;;;;;;;;;;;CLEAR CSV FILE
				If MsgBox(1, "", "Cear CSV log" & @CRLF & "ARE YOU SURE ?") = 1 Then
					FileDelete($csvfile & "\speed_test.csv")
					Global $xarray[$maxlogsize + 5][4]
					$xarray[0][0] = 0
					_FileWriteLog($csvfile & "\Speed_Test.csv", "," & "DL Speed" & "," & "UL Speed" & "," & "Ping")
					main()
				EndIf
			Case $scrnsht ;;;;;;;;;;;;;;;;;SCREEN SHOT SAVE
				_screenshot()
			Case $tracertbut ;;;;;;;;;;;;;;;;;;;;;TRACERT
				$trcloc = InputBox("Tracert", "Please enter target location", "bbc.co.uk")
				If @error = 0 Then
					GUIRegisterMsg($WM_PAINT, "")
					_tracert($trcloc)
					GUIRegisterMsg($WM_PAINT, "_ReDraw")
				EndIf
			Case $update ;;;;;;;;;;;;;;;;;UPDATE PROGRAM
				_update(1)
			Case $bgp
				$backgroundpic = FileOpenDialog("Choise a pic for the graph background", @MyDocumentsDir, "(*.jpg)", 1, "", $form1)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "bgpic", $backgroundpic)
				main()
			Case $bgpc
				$backgroundpic = ""
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "bgpic", $backgroundpic)
				main()
			Case $Mexit
				Exit
		EndSwitch
		Switch $tgm
			Case $pause ;;;;;;;;;;;;;;;;;;; tray pause
				If $pausetesting = 0 Then
					$pausetesting = 1
					TrayItemSetText($pause, "Un-Pause")
					TraySetIcon("Shell32.dll", -110)
					TraySetToolTip("JDAST. Paused")
				Else
					$pausetesting = 0
					TrayItemSetText($pause, "Pause")
					TraySetIcon("")
					TraySetToolTip("JDAST. " & $timex & " Minute Cycles." & @CRLF & "Next Cycle in " & $timex - $trigger & " minutes")
				EndIf
			Case $trayshow ;;;;;;;;;;;;;;;;; TRAY Show
				littleloop()
			Case $trayexit
				Exit
			Case $TRAY_EVENT_PRIMARYDOWN ;;;;;Tray click
				littleloop()
		EndSwitch
		If Hex(PixelGetColor(300, 200, $form1)) = "008899ff" Then ;;;;;;;;;;;;;;;;; REFRESH IF GRAPH GOES ALL BLUE
			_reDraw()
		EndIf
		If $trigger >= $timex And $timex > 0 Then ;;;;;;;;;;;;;;;;;TIMER
			cyclegregtest()
			$trigger = 0
			main()
		EndIf
		If @MIN <> $c Then ;;;;;;;;;;;;;;;;; TIMER
			$trigger += 1
			$c = @MIN
		EndIf
		_tooltipx()
		If $updatedone = 0 And $autoupdate = 1 And $updatetime <> @MDAY Then _update(0)
		If _IsPressed("54") Then _tooltiptest()
	WEnd
EndFunc   ;==>main

Func littleloop()
	$timex = GUICtrlRead($Input1)
	IniWrite(@AppDataDir & "\jdast\main.ini", "main", "frequency", $timex)
	While 1
		wait()
		cyclegregtest()
		If GUICtrlRead($Checkbox1) = 1 Then
			main()
		EndIf
	WEnd
EndFunc   ;==>littleloop

Func _onetest()
	If _checkproc() Then MsgBox(0, "JDast", "Can not run test as there is a listed program running !", 7, $form1)
	cyclegregtest()
	If $cancledtest = 1 Then main()
	readin()
	display()
	$form3 = GUICreate("Resaults", 385, 180, 300, 250, -1, -1, $form1)
	GUISetBkColor(0xA9BDE7)
	$Button1x = GUICtrlCreateButton("OK", 130, 120, 120, 41, $BS_DEFPUSHBUTTON)
	GUISetFont(20)
	$Label1x = GUICtrlCreateLabel("DownLoad = " & $Kbpersec & "Kb/s", 50, 20, 400, 30)
	$Label1x = GUICtrlCreateLabel("Upload       = " & $Kbpersec_up & "Kb/s", 50, 50, 400, 30)
	$Label2x = GUICtrlCreateLabel("Ping            = " & $ping & "ms", 50, 80, 400, 30)
	GUISetState(@SW_SHOW, $form3)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				ExitLoop
			Case $Button1x
				GUIDelete()
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_onetest

Func _screenshot()
	$savelocation = FileSaveDialog("Select Save Location", @MyDocumentsDir & "\Speed_tester", "(*.jpg)", 16, "JDAST_" & @YEAR & @MON & @MDAY & @HOUR & @MIN & ".jpg", $form1)
	$hideip = 1
	display()
	$hideip = 0
	If $savelocation <> "" Then
		$xdif = 0.7
		$ydif = 0.7
		$hWnd2 = GUICreate("jpg shot", 700, 400)
		$hForm2 = _GDIPlus_GraphicsCreateFromHWND($hWnd2)
		$himage1 = _GDIPlus_BitmapCreateFromGraphics(684, 392, $hForm2)
		$backbuffer2 = _GDIPlus_ImageGetGraphicsContext($himage1)
		_GDIPlus_GraphicsClear($backbuffer2, 0xffffffff)
		_GDIPlus_GraphicsDrawImageRect($backbuffer2, $bitmap, 0, 0, 977 * $xdif, 561 * $ydif);*(743/$sise[1])
		_GDIPlus_ImageSaveToFile($himage1, $savelocation)
		_WinAPI_DeleteObject($himage1)
		_GDIPlus_BitmapDispose($himage1)
		_GDIPlus_GraphicsDispose($hForm2)
		GUIDelete($hWnd2)
		main()
	EndIf
EndFunc   ;==>_screenshot

Func _config()
	#Region ### START Koda GUI section ### Form=c:\programdata\my docs\auto it\speedtester\gui\config2.kxf
	$Form_config = GUICreate("Config", 514, 501, 196, 129, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS, $DS_SETFOREGROUND), -1, $form1)
	$Tab1 = GUICtrlCreateTab(8, 40, 497, 449)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial")
	$TabSheet1 = GUICtrlCreateTabItem("Main Config")
	GUICtrlCreateGroup("", 23, 92, 465, 353)
	$hcb = GUICtrlCreateCheckbox("Load at windows startup", 47, 116, 137, 25)
	$hautoupdate = GUICtrlCreateCheckbox("Automatic Update", 47, 150, 105, 25)
	$ldintry = GUICtrlCreateCheckbox("Load in Tray", 47, 184, 81, 25)
	$silent = GUICtrlCreateCheckbox("Silent", 47, 218, 49, 25)
	GUICtrlCreateLabel("Slow Speed file location", 47, 372, 117, 17)
	GUICtrlCreateLabel("Main Test File Location", 47, 308, 114, 17)
	$Hmaintestfilesize = GUICtrlCreateInput("10", 423, 332, 49, 21)
	$Hslowtestfilesize = GUICtrlCreateInput("5", 423, 396, 49, 21)
	GUICtrlCreateLabel("File Size MB", 410, 308, 62, 17)
	GUICtrlCreateLabel("File Size MB", 410, 372, 62, 17)
	$Htctout = GUICtrlCreateInput("999", 223, 156, 65, 21)
	GUICtrlCreateLabel("Test Cycle Time Out After X Mins", 295, 156, 160, 17, $SS_CENTERIMAGE)
	$Hmaxdlspeed = GUICtrlCreateInput("0", 223, 116, 65, 21)
	$Lmaxdlspeednm = GUICtrlCreateLabel("Max DL speed (Mb/s) 0=No NetGraph", 295, 116, 185, 17, $SS_CENTERIMAGE)
	$Hmaintestfileloc = GUICtrlCreateCombo("", 47, 332, 369, 25)
	$Hslowtestfileloc = GUICtrlCreateCombo("", 47, 396, 369, 25)
	$Hrtob = GUICtrlCreateCheckbox("Run A test on load", 47, 252, 105, 25)
	$HI_notifysound = GUICtrlCreateInput("0", 224, 224, 249, 21)
	GUICtrlCreateLabel("Notify Sound (0=off)", 224, 200, 98, 17, $SS_CENTERIMAGE)
	$HB_notifysound = GUICtrlCreateButton("Change Sound File", 224, 256, 121, 25, 0)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$TabSheet2 = GUICtrlCreateTabItem("Program Pause List")
	$LHPauseprogram = GUICtrlCreateList("", 23, 165, 465, 305)
	$BEnterProgram = GUICtrlCreateButton("Enter Program", 23, 85, 225, 33, 0)
	$BClearProgram = GUICtrlCreateButton("Clear Program", 259, 85, 225, 33, 0)
	GUICtrlCreateLabel("Enter Program name that you want JDast to be put on pause whilst running", 39, 133, 438, 20)
	GUICtrlSetFont(-1, 11, 400, 0, "MS Sans Serif")
	$TabSheet3 = GUICtrlCreateTabItem("Upload")
	GUICtrlCreateGroup("", 24, 96, 465, 377)
	$HIserver = GUICtrlCreateInput("", 48, 144, 417, 21)
	GUICtrlCreateLabel("FTP Server   (0 = NO Upload tests)", 48, 120, 169, 17)
	GUICtrlCreateLabel("File to Upload - Location", 48, 336, 119, 17)
	$HBuploadfileloc = GUICtrlCreateButton("Pick File", 376, 320, 89, 25, 0)
	$HBtestftp = GUICtrlCreateButton("Test FTP", 376, 112, 89, 25, 0)
	$HIuploadfileloc = GUICtrlCreateInput("", 48, 360, 417, 21)
	$HIFTPLocation = GUICtrlCreateInput("", 48, 280, 417, 21)
	GUICtrlCreateLabel("FTP upload location", 48, 256, 99, 17)
	$HIusername = GUICtrlCreateInput("", 48, 208, 209, 21)
	$HIpassword = GUICtrlCreateInput("", 264, 208, 201, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
	GUICtrlCreateLabel("User Name", 48, 184, 57, 17)
	GUICtrlCreateLabel("PassWord", 264, 184, 53, 17)
	$HI_ULTrim = GUICtrlCreateInput("", 48, 424, 57, 21)
	GUICtrlCreateLabel("Upload Trim (Secs)", 120, 432, 94, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")
	$OKbut = GUICtrlCreateButton("OK", 401, 6, 97, 25, 0)
	$HBCancel = GUICtrlCreateButton("Cancel", 290, 6, 97, 25, 0)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	GUICtrlSetTip($HI_ULTrim, "If you have a slight delay before upload starts you can trim in the resault" & @CRLF & _
			"by enetring the delay here in seconds. so if it has a 1 sec delay enter 1", "", 1, 1)
	GUICtrlSetTip($Hmaxdlspeed, "To activate the little netmeter enter your max DL speed here in Mb/s", "", 0, 1)
	GUICtrlSetState($hautoupdate, $autoupdate)
	GUICtrlSetState($hcb, $lows)
	GUICtrlSetState($ldintry, $loadintray)
	GUICtrlSetState($silent, $silentrunning)
	GUICtrlSetData($Hmaxdlspeed, $maxdlspeed)
	GUICtrlSetData($Htctout, $tctout)
	GUICtrlSetState($Hrtob, $rtob)
	GUICtrlSetData($HIuploadfileloc, $ftpupfile)
	GUICtrlSetData($HIserver, $ftpserver)
	GUICtrlSetData($HIusername, $ftpusername)
	GUICtrlSetData($HIpassword, $ftppassword)
	GUICtrlSetData($HIFTPLocation, $ftpuplocation)
	GUICtrlSetData($HI_ULTrim, $ftpultrim)
	GUICtrlSetData($HI_notifysound, $notify_sound)
	$num = 1
	$numslow = 1
	For $x = 1 To $PPqarray[0]
		If $PPqarray[$x] = "" Then ExitLoop
		GUICtrlSetData($LHPauseprogram, $PPqarray[$x])
	Next
	Dim $ddbarray[50][2]
	Dim $xy[50]
	Dim $xyx[3]
	_FileReadToArray(@AppDataDir & "\jdast\locmenu.txt", $xy)
	If $xy[0] = 0 Then
		$xy[0] = 2
		$xy[1] = $maintestfileloc & "," & $maintestfilesize
		$xy[2] = $slowtestfileloc & "," & $slowtestfilesize
		FileWrite(@AppDataDir & "\jdast\locmenu.txt", $maintestfileloc & "," & $maintestfilesize & @CRLF)
		FileWrite(@AppDataDir & "\jdast\locmenu.txt", $slowtestfileloc & "," & $slowtestfilesize & @CRLF)
	EndIf
	For $x = 1 To $xy[0]
		$xyx = StringSplit($xy[$x], ",")
		$ddbarray[$x][0] = $xyx[1]
		_GUICtrlComboBox_AddString($Hmaintestfileloc, $xyx[1])
		_GUICtrlComboBox_AddString($Hslowtestfileloc, $xyx[1])
		If $xyx[1] = $maintestfileloc Then $num = $x
		If $xyx[1] = $slowtestfileloc Then $numslow = $x
		$ddbarray[$x][1] = $xyx[2]
	Next
	_GUICtrlComboBox_AddString($Hmaintestfileloc, "Clear List")
	_GUICtrlComboBox_SetEditText($Hmaintestfileloc, $ddbarray[$num][0])
	GUICtrlSetData($Hmaintestfilesize, $ddbarray[$num][1])
	_GUICtrlComboBox_SetEditText($Hslowtestfileloc, $ddbarray[$numslow][0])
	GUICtrlSetData($Hslowtestfilesize, $ddbarray[$numslow][1])
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form_config)
				Return
			Case $HBCancel
				GUIDelete($Form_config)
				Return
			Case $HB_notifysound
				$notify_sound = FileOpenDialog("Notify Sound File", @WindowsDir & "\media\", "Wav(*.wav)", 3, "", $Form_config)
				GUICtrlSetData($HI_notifysound, $notify_sound)
			Case $Hmaintestfileloc
				If GUICtrlRead($Hmaintestfileloc) = "Clear List" Then
					_GUICtrlComboBox_ResetContent($Hmaintestfileloc)
					_GUICtrlComboBox_ResetContent($Hslowtestfileloc)
					$maintestfileloc = "                                           "
					$slowtestfileloc = "                                          "
					$maintestfilesize = 10
					$slowtestfilesize = 5
					Dim $ddbarray[50][2]
					$ddbarray[1][0] = $maintestfileloc
					$ddbarray[1][1] = $maintestfilesize
					$ddbarray[2][0] = $slowtestfileloc
					$ddbarray[2][1] = $slowtestfilesize
					FileDelete(@AppDataDir & "\jdast\locmenu.txt")
					_GUICtrlComboBox_AddString($Hmaintestfileloc, $maintestfileloc)
					_GUICtrlComboBox_AddString($Hmaintestfileloc, $slowtestfileloc)
					_GUICtrlComboBox_AddString($Hslowtestfileloc, $maintestfileloc)
					_GUICtrlComboBox_AddString($Hslowtestfileloc, $slowtestfileloc)
					_GUICtrlComboBox_SetEditText($Hmaintestfileloc, $maintestfileloc)
					GUICtrlSetData($Hmaintestfilesize, $maintestfilesize)
					_GUICtrlComboBox_SetEditText($Hslowtestfileloc, $slowtestfileloc)
					GUICtrlSetData($Hslowtestfilesize, $slowtestfilesize)
				EndIf
				$hh = _ArraySearch($ddbarray, GUICtrlRead($Hmaintestfileloc))
				GUICtrlSetData($Hmaintestfilesize, $ddbarray[$hh][1])
			Case $Hslowtestfileloc
				$hh = _ArraySearch($ddbarray, GUICtrlRead($Hslowtestfileloc))
				GUICtrlSetData($Hslowtestfilesize, $ddbarray[$hh][1])
			Case $Hmaintestfilesize
				$maintestfilesize = GUICtrlRead($Hmaintestfilesize)
				If $maintestfilesize <= 0 Then
					$maintestfilesize = 1
					GUICtrlSetData($Hmaintestfilesize, 1)
				EndIf
			Case $Hslowtestfilesize
				$slowtestfilesize = GUICtrlRead($Hslowtestfilesize)
				If $slowtestfilesize <= 0 Then
					$slowtestfilesize = 1
					GUICtrlSetData($Hslowtestfilesize, 1)
				EndIf
			Case $Hmaxdlspeed
				$maxdlspeed = GUICtrlRead($Hmaxdlspeed)
			Case $BEnterProgram
				$Program = FileOpenDialog("Program", @ProgramFilesDir, "(*.exe)", 1, "", $Form_config)
				If $Program <> "" Then
					_GUICtrlListBox_AddString($LHPauseprogram, $Program)
				EndIf
			Case $BClearProgram
				$sel = _GUICtrlListBox_GetCurSel($LHPauseprogram)
				_GUICtrlListBox_DeleteString($LHPauseprogram, $sel)
			Case $HBuploadfileloc
				$ftpupfile = FileOpenDialog("Upload Test File", "C:", "(*.*)")
				GUICtrlSetData($HIuploadfileloc, $ftpupfile)
			Case $HBtestftp
				$ftpserver = GUICtrlRead($HIserver)
				$ftpusername = GUICtrlRead($HIusername)
				$ftppassword = GUICtrlRead($HIpassword)
				$Open = _FTPOpen('MyFTP Contr')
				$Conn = _FTPConnect($Open, $ftpserver, $ftpusername, $ftppassword)
				$Ftpc = _FTPClose($Open)
				If $Conn <> 0 Then
					MsgBox(0, "FTP Check", "              Looks OK              ", 20, $Form_config)
				Else
					MsgBox(16, "FTP Check", "         NOT CONNECTING !          ", 20, $Form_config)
				EndIf
			Case $OKbut
				$lows = GUICtrlRead($hcb)
				$autoupdate = GUICtrlRead($hautoupdate)
				$loadintray = GUICtrlRead($ldintry)
				$silentrunning = GUICtrlRead($silent)
				$maintestfileloc = GUICtrlRead($Hmaintestfileloc)
				$slowtestfileloc = GUICtrlRead($Hslowtestfileloc)
				$maintestfilesize = GUICtrlRead($Hmaintestfilesize)
				$slowtestfilesize = GUICtrlRead($Hslowtestfilesize)
				$tctout = GUICtrlRead($Htctout)
				$maxdlspeed = GUICtrlRead($Hmaxdlspeed)
				$rtob = GUICtrlRead($Hrtob)
				$ftpupfile = GUICtrlRead($HIuploadfileloc)
				$ftpserver = GUICtrlRead($HIserver)
				$ftpusername = GUICtrlRead($HIusername)
				$ftppassword = GUICtrlRead($HIpassword)
				$ftpuplocation = GUICtrlRead($HIFTPLocation)
				$ftpultrim = GUICtrlRead($HI_ULTrim)
				$notify_sound = GUICtrlRead($HI_notifysound)


				If $lows = 1 Then
					RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", "jdast_startup", "REG_SZ", @ProgramFilesDir & "\jdast\jdautospeedtester.exe tray")
				Else
					RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", "jdast_startup")
				EndIf
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "lows", $lows)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "autoupdatetime", @MDAY)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "autoupdate", $autoupdate)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "loadintray", $loadintray)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "silentrunning", $silentrunning)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "stfl", $slowtestfileloc)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "mtfl", $maintestfileloc)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "mtfs", $maintestfilesize)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "stfs", $slowtestfilesize)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "tctout", $tctout)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "maxdlspeed", $maxdlspeed)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "rtob", $rtob)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "ftpupfile", $ftpupfile)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "ftpserver", $ftpserver)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "ftpusername", $ftpusername)
				$EQpassword = _StringEncrypt(1, $ftppassword, "nottoforget99")
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "ftppassword", $EQpassword)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "ftpuplocation", $ftpuplocation)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "ultrim", $ftpultrim)
				IniWrite(@AppDataDir & "\jdast\main.ini", "main", "notifysound", $notify_sound)

				$mainline = _GUICtrlComboBox_FindString($Hmaintestfileloc, $maintestfileloc)
				$slowline = _GUICtrlComboBox_FindString($Hslowtestfileloc, $slowtestfileloc)
				If $mainline <> -1 Then
					_FileWriteToLine(@AppDataDir & "\jdast\locmenu.txt", $mainline + 1, $maintestfileloc & "," & $maintestfilesize, 1)
				ElseIf $maintestfileloc <> "" Then
					FileWrite(@AppDataDir & "\jdast\locmenu.txt", $maintestfileloc & "," & $maintestfilesize & @CRLF)
				EndIf
				If $slowline <> -1 Then
					_FileWriteToLine(@AppDataDir & "\jdast\locmenu.txt", $slowline + 1, $slowtestfileloc & "," & $slowtestfilesize, 1)
				ElseIf $slowtestfileloc <> "" Then
					FileWrite(@AppDataDir & "\jdast\locmenu.txt", $slowtestfileloc & "," & $slowtestfilesize & @CRLF)
				EndIf
				FileDelete(@AppDataDir & "\jdast\programList.txt")
				For $x = 1 To 10
					Sleep(50)
					If FileExists(@AppDataDir & "\jdast\programList.txt") = 0 Then ExitLoop
				Next
				For $x = 0 To _GUICtrlListBox_GetCount($LHPauseprogram) - 1
					If $x > 100 Then ExitLoop
					$text = _GUICtrlListBox_GetText($LHPauseprogram, $x)
					FileWrite(@AppDataDir & "\jdast\programList.txt", $text & @CRLF)
				Next
				GUIDelete($Form_config)
				Sleep(500)
				_FileReadToArray(@AppDataDir & "\jdast\programList.txt", $PPqarray)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_config

Func _update($x)
	$updatedone = 1
	If $x = 1 Then
		SplashTextOn("", "Checking for update..", -1, 50)
		$r = InetGet("                                                  ", @AppDataDir & "\jdast\jdast.ver", 1)
	EndIf
	For $xt = 1 To 6
		If @InetGetActive = 0 Then ExitLoop
		Sleep(500)
	Next
	Sleep(1000)
	SplashOff()
	$filever = FileRead(@AppDataDir & "\jdast\jdast.ver")
	If Number($filever) > $version Then
		$msg = MsgBox(1, "JDAST", "An Update is available. Do you want to update now ?")
		If $msg = 1 Then
			IniWrite(@AppDataDir & "\jdast\main.ini", "main", "autoupdatetime", @MDAY)
			Run(@ProgramFilesDir & "\jdast\update.exe", "", @SW_HIDE)
			Sleep(1000)
			_GDIPlus_Shutdown()
			Exit
		EndIf
	ElseIf $x = 1 Then
		SplashTextOn("JDast", "No New Updates", -1, 50)
		Sleep(2000)
		SplashOff()
	EndIf
	IniWrite(@AppDataDir & "\jdast\main.ini", "main", "autoupdatetime", @MDAY)
EndFunc   ;==>_update

Func _tooltipx()
	If WinActive("JackDinn`s Auto Speed Tester") Then ;;;;;;;;;;;;;;;;; TOOLTIPS
		AutoItSetOption("MouseCoordMode", 2)
		AutoItSetOption("pixelCoordMode", 2)
		$fifo = ($xarray[0][0] - 70)
		$fifo -= $xposgraph
		If $fifo < 1 Then $fifo = 0
		$sise = WinGetClientSize("JackDinn`s Auto Speed Tester");1008, 743
		$xdif = 1 / (1008 / $sise[0])
		$pos = MouseGetPos(0) / $xdif
		$oo = Round(($pos - 236) / 9.97)
		$piccol = PixelGetColor(MouseGetPos(0), MouseGetPos(1), $form1)
		If $oo > 0 And $oo < $xarray[0][0] - $fifo And MouseGetPos(1) > 70 And MouseGetPos(1) < $sise[1] And (Hex($piccol) = "00ff0000" Or Hex($piccol) = "000000ff") Or $piccol = 6684825 Then
			$textdate = StringLeft($xarray[$oo + 1 + $fifo][0], 16)
			$textdls = $xarray[$oo + 1 + $fifo][1]
			$textuls = $xarray[$oo + 1 + $fifo][2]
			$textping = $xarray[$oo + 1 + $fifo][3]
			AutoItSetOption("MouseCoordMode", 1)
			ToolTip($textdate & @CRLF & "DL " & $textdls & " Kb/s" & @CRLF & "UL " & $textuls & " Kb/s" & @CRLF & "Ping " & $textping & " ms", MouseGetPos(0) - 60, _
					MouseGetPos(1) - 100, "Test Resault " & $oo + $fifo + 1, 1, 4)
		Else
			ToolTip("")
		EndIf
	Else
		ToolTip("")
	EndIf
EndFunc   ;==>_tooltipx

Func _tooltiptest()
	$hgraphic = _GDIPlus_GraphicsCreateFromHWND($form1)
	$x = 0
	For $xx = 0 To 1008
		AutoItSetOption("MouseCoordMode", 2)
		AutoItSetOption("pixelCoordMode", 2)
		$fifo = ($xarray[0][0] - 70)
		$fifo -= $xposgraph
		If $fifo < 1 Then $fifo = 0
		$sise = WinGetClientSize("JackDinn`s Auto Speed Tester");1008, 743
		$xdif = 1 / (1008 / $sise[0])
		$pos = $xx / $xdif
		$oo = Round(($pos - 236) / 9.97)
		AutoItSetOption("MouseCoordMode", 1)
		If $x < $oo + $fifo + 1 Then
			_GDIPlus_GraphicsDrawLine($hgraphic, $xx, 600, $xx, 0)
			_GDIPlus_GraphicsDrawString($hgraphic, Number($oo + $fifo), $xx, 50)
			$x = $oo + $fifo + 1
		EndIf
	Next

EndFunc   ;==>_tooltiptest

Func readin()
	Local $max1 = 0
	Local $max2 = 0
	Local $max3 = 0
	_FileReadToArray($csvfile & "\Speed_Test.csv", $array)
	For $x = 2 To $array[0]
		$garray = _StringExplode($array[$x], ",")
		For $y = 0 To 3
			$xarray[$x][$y] = $garray[$y]
			If Number($garray[1]) > $max1 Then $max1 = Number($garray[1])
			If Number($garray[2]) > $max2 Then $max2 = Number($garray[2])
			If Number($garray[3]) > $max3 Then $max3 = Number($garray[3])
		Next
	Next
	$xarray[0][0] = $array[0]
	$xarray[0][1] = $max1
	$xarray[0][2] = $max2
	$xarray[0][3] = $max3
	_listview1()
EndFunc   ;==>readin

Func display()
	If $bannerswt = 1 Then
		$ymult = 0.9
		$yplus = 60
	Else
		$ymult = 1
		$yplus = 0
	EndIf
	$Graphic2 = _GDIPlus_GraphicsCreateFromHWND($form1)
	$bitmap = _GDIPlus_BitmapCreateFromGraphics(977, 561, $Graphic2);1008, 743
	$backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
	_GDIPlus_GraphicsClear($backbuffer, 0xffffffff)
	$hBitmappic = _GDIPlus_BitmapCreateFromFile($backgroundpic)
	_GDIPlus_GraphicsDrawImageRect($backbuffer, $hBitmappic, 0, 0, 977, 561)
	$brush = _GDIPlus_BrushCreateSolid(0x90ffffff)
	_GDIPlus_GraphicsFillRect($backbuffer, 0, 0, 977, 565, $brush)
	_GDIPlus_GraphicsDrawLine($backbuffer, 60, (20 + $yplus) * $ymult, 60, (500 + $yplus) * $ymult, 0)
	_GDIPlus_GraphicsDrawLine($backbuffer, 60, (500 + $yplus) * $ymult, 900, (500 + $yplus) * $ymult, 0)
	_GDIPlus_GraphicsDrawLine($backbuffer, 900, (500 + $yplus) * $ymult, 900, (20 + $yplus) * $ymult, 0)
	$fifo = ($xarray[0][0] - 70)
	$fifo -= $xposgraph
	If $fifo < 1 Then $fifo = 0
	For $x = 2 To 70
		$brush = _GDIPlus_BrushCreateSolid(0xffff0000)
		$linehight = (480 / (($xarray[0][1] / $xarray[$x + $fifo][1])))
		_GDIPlus_GraphicsFillRect($backbuffer, (($x - 2) * 12) + 61, (501 + $yplus) * $ymult - $linehight * $ymult, 10, $linehight * $ymult, $brush);DL graph bars
	Next
	For $x = 2 To 70
		$brush = _GDIPlus_BrushCreateSolid(0x990000ff)
		$linehight = (480 / (($xarray[0][1] / $xarray[$x + $fifo][2])))
		_GDIPlus_GraphicsFillRect($backbuffer, (($x - 2) * 12) + 61, (501 + $yplus) * $ymult - $linehight * $ymult, 10, $linehight * $ymult, $brush);UL graph bars
	Next
	$brush = _GDIPlus_BrushCreateSolid(0xffff0000)
	For $x = 2 To 70 Step 4
		_GDIPlus_GraphicsFillRect($backbuffer, (($x - 2) * 12) + 65, (500 + $yplus) * $ymult, 3, 5 * $ymult, $brush); red bottom nodes short
		$text = StringMid($xarray[$x + $fifo][0], 12, 5)
		_GDIPlus_GraphicsDrawString($backbuffer, $text, (($x - 1) * 12) + 36, (508 + $yplus) * $ymult); bottom text, top line
	Next
	For $x = 2 To 68 Step 4
		_GDIPlus_GraphicsFillRect($backbuffer, (($x - 2) * 12) + 88, (500 + $yplus) * $ymult, 3, 10 * $ymult, $brush); red bottom nodes long
		$text = StringMid($xarray[$x + $fifo + 2][0], 12, 5)
		_GDIPlus_GraphicsDrawString($backbuffer, $text, (($x - 1) * 12) + 58, (525 + $yplus) * $ymult); bottom text, bottom line
	Next
	$pen = _GDIPlus_PenCreate(0xff008800, 5)
	$brush = _GDIPlus_BrushCreateSolid(0xff008800) ; DAY LINE AT BOTTOM
	$hFormat = _GDIPlus_StringFormatCreate()
	$hFamily = _GDIPlus_FontFamilyCreate("Arial")
	$hFont = _GDIPlus_FontCreate($hFamily, 12, 2)
	$tLayout = _GDIPlus_RectFCreate(2, (540 + $yplus) * $ymult, 0, 0)
	$aInfo = _GDIPlus_GraphicsMeasureString($backbuffer, "DAY", $hFont, $tLayout, $hFormat)
	_GDIPlus_GraphicsDrawStringEx($backbuffer, "DAY", $hFont, $aInfo[0], $hFormat, $brush)
	$dayno = 0
	For $x = 2 To 70
		$day = StringMid($xarray[$x + $fifo][0], 9, 2)
		If $day <> $dayno Then
			$tLayout = _GDIPlus_RectFCreate((($x - 1) * 12) + 40, (540 + $yplus) * $ymult, 0, 0)
			$aInfo = _GDIPlus_GraphicsMeasureString($backbuffer, $day, $hFont, $tLayout, $hFormat)
			_GDIPlus_GraphicsDrawStringEx($backbuffer, $day, $hFont, $aInfo[0], $hFormat, $brush)
			_GDIPlus_GraphicsDrawLine($backbuffer, (($x - 1) * 12) + 53, (500 + $yplus) * $ymult, (($x - 1) * 12) + 53, (490 + $yplus) * $ymult, $pen)
			$dayno = $day
		ElseIf ($x - 1) < $xarray[0][0] Then
			$tLayout = _GDIPlus_RectFCreate((($x - 1) * 12) + 45, (535 + $yplus) * $ymult, 0, 0)
			$aInfo = _GDIPlus_GraphicsMeasureString($backbuffer, ".", $hFont, $tLayout, $hFormat)
			_GDIPlus_GraphicsDrawStringEx($backbuffer, ".", $hFont, $aInfo[0], $hFormat, $brush)
		EndIf
	Next
	$y = 20
	If $array[0] > 1 Then
		For $x = $xarray[0][1] To 1 Step -($xarray[0][1] / 10)
			_GDIPlus_GraphicsDrawLine($backbuffer, 60, ($y + $yplus) * $ymult, 900, ($y + $yplus) * $ymult, 0)
			_GDIPlus_GraphicsDrawString($backbuffer, Round($x, 2), 4, (($y - 5) + $yplus) * $ymult); left hand text , speed
			$y = $y + 48
		Next
		$y = 20
		For $x = $xarray[0][3] To 1 Step -($xarray[0][3] / 10)
			_GDIPlus_GraphicsDrawString($backbuffer, Round($x, 2), 910, (($y - 5) + $yplus) * $ymult); right hand text ping
			$y = $y + 48
		Next
	EndIf
	$pen = _GDIPlus_PenCreate(0xff0000ff, 2)
	$hbrush = _GDIPlus_BrushCreateSolid(0xff0000ff)
	For $x = 2 To 70
		If $xarray[$x + $fifo][3] > 0 Then
			_GDIPlus_GraphicsFillRect($backbuffer, (($x - 2) * 12) + 62, ((500 - (480 / ($xarray[0][3] / $xarray[$x + $fifo][3])) + $yplus) * $ymult) - 1, 7, 7, $hbrush); ping points
			If $xarray[$x + $fifo + 1][3] > 0 Then
				_GDIPlus_GraphicsDrawLine($backbuffer, (($x - 2) * 12) + 65, (502 - (480 / ($xarray[0][3] / $xarray[$x + $fifo][3])) + $yplus) * $ymult, _ ; ping lines
						(($x - 1) * 12) + 65, (502 - (480 / ($xarray[0][3] / $xarray[$x + $fifo + 1][3])) + $yplus) * $ymult, $pen)
			EndIf
		EndIf
	Next
	If $bannerswt = 1 Then
		$pen = _GDIPlus_PenCreate(0xff000000, 2)
		$brush = _GDIPlus_BrushCreateSolid(0xff8899ff)
		_GDIPlus_GraphicsFillRect($backbuffer, 0, 0, 973, 55, $brush)
		_GDIPlus_GraphicsDrawRect($backbuffer, 0, 0, 970, 55, $pen)
		$pen = _GDIPlus_PenCreate(0x880000ff, 8)
		_GDIPlus_GraphicsDrawLine($backbuffer, 10, 58, 977, 58, $pen)
		_GDIPlus_GraphicsDrawLine($backbuffer, 975, 58, 975, 7, $pen)
		$sstring = "JD`s Auto Speed Tester"
		$hbrush = _GDIPlus_BrushCreateSolid(0xff0000ff)
		$hFormat = _GDIPlus_StringFormatCreate()
		$hFamily = _GDIPlus_FontFamilyCreate("comic sans ms")
		$hFont = _GDIPlus_FontCreate($hFamily, 20, 2)
		$tLayout = _GDIPlus_RectFCreate(50, 4, 0, 0)
		$aInfo = _GDIPlus_GraphicsMeasureString($backbuffer, $sstring, $hFont, $tLayout, $hFormat)
		_GDIPlus_GraphicsDrawStringEx($backbuffer, $sstring, $hFont, $aInfo[0], $hFormat, $hbrush)
		$hbrush = _GDIPlus_BrushCreateSolid(0xaaffffff)
		$tLayout = _GDIPlus_RectFCreate(55, 7, 0, 0)
		$aInfo = _GDIPlus_GraphicsMeasureString($backbuffer, $sstring, $hFont, $tLayout, $hFormat)
		_GDIPlus_GraphicsDrawStringEx($backbuffer, $sstring, $hFont, $aInfo[0], $hFormat, $hbrush)
		$pen = _GDIPlus_PenCreate(0x88ffffff, 2)
		_GDIPlus_GraphicsDrawLine($backbuffer, 50, 42, 700, 42, $pen)
	EndIf
	$hbrush = _GDIPlus_BrushCreateSolid(0xddffffff)
	_GDIPlus_GraphicsFillRect($backbuffer, 675, 74, 122, 61, $hbrush)
	$sstring = "= DL Kb/s"
	$hbrush = _GDIPlus_BrushCreateSolid(0xffff0000)
	$hFormat = _GDIPlus_StringFormatCreate()
	$hFamily = _GDIPlus_FontFamilyCreate("Georgia")
	$hFont = _GDIPlus_FontCreate($hFamily, 14, 2)
	$tLayout = _GDIPlus_RectFCreate(700, 71, 0, 0)
	$aInfo = _GDIPlus_GraphicsMeasureString($backbuffer, $sstring, $hFont, $tLayout, $hFormat)
	_GDIPlus_GraphicsDrawStringEx($backbuffer, $sstring, $hFont, $aInfo[0], $hFormat, $hbrush)
	_GDIPlus_GraphicsFillRect($backbuffer, 680, 77, 14, 14, $hbrush)
	$sstring = "= UL Kb/s"
	$hbrush = _GDIPlus_BrushCreateSolid(0xff660099)
	$hFormat = _GDIPlus_StringFormatCreate()
	$hFamily = _GDIPlus_FontFamilyCreate("Georgia")
	$hFont = _GDIPlus_FontCreate($hFamily, 14, 2)
	$tLayout = _GDIPlus_RectFCreate(700, 91, 0, 0)
	$aInfo = _GDIPlus_GraphicsMeasureString($backbuffer, $sstring, $hFont, $tLayout, $hFormat)
	_GDIPlus_GraphicsDrawStringEx($backbuffer, $sstring, $hFont, $aInfo[0], $hFormat, $hbrush)
	_GDIPlus_GraphicsFillRect($backbuffer, 680, 97, 14, 14, $hbrush)
	$sstring = "= Ping ms"
	$hbrush = _GDIPlus_BrushCreateSolid(0xff0000ff)
	$hFormat = _GDIPlus_StringFormatCreate()
	$hFamily = _GDIPlus_FontFamilyCreate("Georgia")
	$hFont = _GDIPlus_FontCreate($hFamily, 14, 2)
	$tLayout = _GDIPlus_RectFCreate(700, 111, 0, 0)
	$aInfo = _GDIPlus_GraphicsMeasureString($backbuffer, $sstring, $hFont, $tLayout, $hFormat)
	_GDIPlus_GraphicsDrawStringEx($backbuffer, $sstring, $hFont, $aInfo[0], $hFormat, $hbrush)
	_GDIPlus_GraphicsFillRect($backbuffer, 680, 117, 14, 14, $hbrush)
	If $hideip = 0 Then
		_GDIPlus_GraphicsDrawString($backbuffer, "JD's Auto Speed Tester   For Public IP " & $pip, 300, 0, "Garamond", 12)
	Else
		_GDIPlus_GraphicsDrawString($backbuffer, "JD's Auto Speed Tester", 400, 0, "Garamond", 12)
	EndIf
	_GDIPlus_GraphicsDrawString($backbuffer, "Kb/s", 3, (480 + $yplus) * $ymult, "arial", 12)
	_GDIPlus_GraphicsDrawString($backbuffer, "Ping ms", 910, (480 + $yplus) * $ymult, "arial", 12)
	_GDIPlus_GraphicsDrawString($backbuffer, "Ver " & $version & "  GMW Software.", 870, (548 + $yplus) * $ymult, "comic sans ms", 7)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hbrush)
	_GDIPlus_BrushDispose($brush)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_PenDispose($pen)
	_GDIPlus_GraphicsDispose($Graphic2)
	_GDIPlus_BitmapDispose($hBitmappic)
	_reDraw()
EndFunc   ;==>display

Func testspeed()
	If $silentrunning = 4 Then SoundPlay($notify_sound)
	TraySetState(4)
	TraySetIcon("Shell32.dll", -177)
	If $xarray[0][0] > $maxlogsize - 1 Then Return
	Local $ping1[5]
	$ping1[0] = Ping("bbc.co.uk", 3000)
	$ping1[1] = Ping("                        ", 3000)
	$ping1[2] = Ping("                   ", 3000)
	$ping1[3] = Ping("google.co.uk", 3000)
	$ping1[4] = Ping("bbc.co.uk", 3000)
	For $t = 0 To 4
		If $ping1[$t] = 0 Then $ping1[$t] = 1000
	Next
	$ping = _ArrayMin($ping1, 0)
	InetGet($maintestfileloc, @TempDir & "\qtest.tst", 1, 1)
	Sleep(3000)
	If @InetGetBytesRead > 550000 Then
		InetGet("abort")
		FileDelete(@TempDir & "\qtest.tst")
		TraySetState(8)
		TraySetIcon("")
		Return (1)
	EndIf
	InetGet("abort")
	FileDelete(@TempDir & "\qtest.tst")
	TraySetState(8)
	TraySetIcon("")
	Return (0)
EndFunc   ;==>testspeed

Func cyclegregtest()
	$old = 0
	$xxq = 1
	$Kbpersec_up = 0
	$max = $maxdlspeed * 1000
	$cancletestcyclebut = 99
	If $pausetesting Or _checkproc() Then Return
	If StringInStr($maintestfileloc, "thinkbroadband.com") <> 0 Then
		InetGet("                                                    ", @AppDataDir & "\jdast\textx.txt", 1, 1)
		Sleep(1000)
		$tbb = FileReadLine(@AppDataDir & "\jdast\textx.txt", 1)
		If Number($tbb) = 400 Then
			SplashTextOn("JDast", "The TBB site is unable to provide a connection at the moment, sorry", -1, 50)
			Sleep(3000)
			SplashOff()
			Return
		EndIf
	EndIf
	If $xarray[0][0] > $maxlogsize - 1 Then
		FileCopy($csvfile & "\Speed_Test.csv", $csvfile & "\SpeedTest_" & @YEAR & "_" & @MON & "_" & @MDAY & ".csv")
		FileDelete($csvfile & "\Speed_Test.csv")
		_FileWriteLog($csvfile & "\Speed_Test.csv", "," & "DL Speed" & "UL Speed" & "," & "Ping")
		Global $xarray[$maxlogsize + 5][4]
		$xarray[0][0] = 0
	EndIf
	$quicktest = 0
	If $quicktest = 1 Then
		$ping = 30
		$Kbpersec = 1000
		$Kbpersec_up = 300
		_csvfile()
		$xarray[0][0]+=1
		Return
	EndIf
	If $silentrunning = 4 Then SplashTextOn("Speed tester", "Gathering Info.. Please wait. ", 300, 50, @DesktopWidth - 322, @DesktopHeight - 122)
	$goodspeed = testspeed()
	If $goodspeed = 2 Then
		SplashOff()
		Return
	EndIf
	If $goodspeed = 0 Then
		$loc = $slowtestfileloc
		$filesise = $slowtestfilesize
		$filesisex = 1048576 * $slowtestfilesize;5242880
	Else
		$loc = $maintestfileloc
		$filesise = $maintestfilesize
		$filesisex = 1048576 * $maintestfilesize
	EndIf
	SplashOff()
	TraySetState(4)
	TraySetIcon("Shell32.dll", -177)
	If $silentrunning = 4 Then
		$progr = GUICreate("testing", 230, 60, @DesktopWidth - 240, @DesktopHeight - 122, -1, $WS_EX_TOPMOST)
		$cancletestcyclebut = GUICtrlCreateButton("Cancel", 10, 30)
		If StringInStr($maintestfileloc, "thinkbroadband.com") = 0 Then
			$testlable = GUICtrlCreateLabel("DL " & $filesise & "MB Test File", 60, 30, 190, 38)
		Else
			$testlable = GUICtrlCreateLabel("DL " & $filesise & "MB Test File" & @CRLF & "Supplied by ThinkBroadband.com", 60, 30, 190, 38)
		EndIf
		$progressbar1 = GUICtrlCreateProgress(10, 10, 210, 20)
		GUICtrlSetData($progressbar1, 100)
		GUISetState(@SW_SHOWNOACTIVATE, $progr)
		If $maxdlspeed > 0 Then
			$Hnetmeter = GUICreate("", 230, 59, @DesktopWidth - 240, @DesktopHeight - 190, BitOR($WS_DLGFRAME, $WS_POPUP, $WS_GROUP, $WS_CLIPSIBLINGS), $WS_EX_TOPMOST)
			$Hnetmetergraphic = GUICtrlCreateGraphic(2, 2, 228, 57)
			GUICtrlSetBkColor(-1, 0x8888ff)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x00ff00)
			GUISetState(@SW_SHOWNOACTIVATE, $Hnetmeter)
		EndIf
	EndIf
	InetGet($loc, @TempDir & "\test.tst", 1, 1)
	$starttime1 = _Timer_Init()
	Do
		$msg = GUIGetMsg()
		If _Timer_Diff($starttime1) > 10000 Or $msg = $cancletestcyclebut Then
			If _Timer_Diff($starttime1) > 10000 Then
				MsgBox(0, "JDast", "There is NO data flowing within 10 seconds, I am timing out..", 5)
			EndIf
			InetGet("abort")
			If $silentrunning = 4 Then
				If $maxdlspeed > 0 Then GUIDelete($Hnetmeter)
				GUIDelete($progr)
			EndIf
			$cancledtest = 1
			FileDelete(@TempDir & "\test.tst")
			TraySetState(8)
			TraySetIcon("")
			Return
		EndIf
	Until @InetGetBytesRead > 10
	$starttimegraph = _Timer_Init()
	$starttime = _Timer_Init()
	While @InetGetActive
		$msg = GUIGetMsg()
		If $msg = $cancletestcyclebut Or ((_Timer_Diff($starttime)) / 60000) > $tctout Then
			If ((_Timer_Diff($starttime)) / 60000) > $tctout Then MsgBox(0, "JDast", "TIMED OUT...", 5)
			InetGet("abort")
			If $silentrunning = 4 Then
				If $maxdlspeed > 0 Then GUIDelete($Hnetmeter)
				GUIDelete($progr)
			EndIf
			$cancledtest = 1
			FileDelete(@TempDir & "\test.tst")
			TraySetState(8)
			TraySetIcon("")
			Return
		EndIf
		$i = Round((@InetGetBytesRead / ($filesisex / 100)))
		If $silentrunning = 4 Then GUICtrlSetData($progressbar1, 100 - $i)
		If _Timer_Diff($starttimegraph) > 1000 And $maxdlspeed > 0 And $silentrunning = 4 Then
			$kbpsx = (@InetGetBytesRead * 8) / 1084
			$kbps = $kbpsx - $old
			$kbpsonetimepercent = (($kbps / $max) * 100)
			$colorg = (510 / 100) * $kbpsonetimepercent
			$colorr = 510 - ((510 / 100) * $kbpsonetimepercent)
			If $colorg > 255 Then $colorg = 255
			If $colorr > 255 Then $colorr = 255
			If $colorr < 0 Then $colorr = 0
			$colorg = Hex($colorg, 2)
			$colorr = Hex($colorr, 2)
			$kk = "0x" & $colorr & $colorg & "00"
			GUICtrlSetGraphic($Hnetmetergraphic, $GUI_GR_COLOR, $kk, $kk)
			GUICtrlSetGraphic($Hnetmetergraphic, $GUI_GR_RECT, $xxq, 55, 3, -((55 / 100) * $kbpsonetimepercent))
			GUICtrlSetGraphic($Hnetmetergraphic, $GUI_GR_REFRESH)
			$old = $kbpsx
			$xxq += 3
			If $xxq > 228 Then
				$xxq = 0
				GUICtrlDelete($Hnetmetergraphic)
				$Hnetmetergraphic = GUICtrlCreateGraphic(2, 2, 228, 57)
				GUICtrlSetBkColor(-1, 0x8888ff)
				GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x00ff00)
			EndIf
			$starttimegraph = _Timer_Init()
		EndIf
	WEnd
	$time = _Timer_Diff($starttime)
	If $silentrunning = 4 Then GUICtrlSetData($progressbar1, 0)
	If $time < 2000 Then
		MsgBox(0, "JDast", "Your Download Test File is to small !" & @CRLF & "or your test file Location is not right" & @CRLF & "Please check your settings", 30)
		FileDelete(@TempDir & "\test.tst")
		If $maxdlspeed > 0 Then GUIDelete($Hnetmeter)
		GUIDelete($progr)
		Return
	EndIf
	$cancledtest = 0
	If String($ftpserver) <> "0" Then
		If $silentrunning = 4 Then
			GUISwitch($progr)
			$ftpupfilesize = FileGetSize($ftpupfile)
			$testlable = GUICtrlCreateLabel("UL " & Round($ftpupfilesize / 1048576, 2) & "MB Test File", 60, 30, 190, 38)
		EndIf
		$Kbpersec_up = uploadtest()
		If $Kbpersec_up = -1 Then
			If $silentrunning = 4 Then
				If $maxdlspeed > 0 Then GUIDelete($Hnetmeter)
				GUIDelete($progr)
			EndIf
			$cancledtest = 1
			$Kbpersec_up = 0
			FileDelete(@TempDir & "\test.tst")
			TraySetState(8)
			TraySetIcon("")
			Return
		EndIf
	EndIf
	If $silentrunning = 4 Then
		If $maxdlspeed > 0 Then GUIDelete($Hnetmeter)
		GUIDelete($progr)
		ProgressSet($i, $i & "Done", "Complete")
	EndIf
	Sleep(500)
	FileDelete(@TempDir & "\test.tst")
	$timesecs = $time / 1000
	$Kbpersec = ($filesise * 8192) / $timesecs ;81920 / $timesecs
	$Kbpersec = Round($Kbpersec)
	TraySetState(8)
	TraySetIcon("")
	If $silentrunning = 4 Then
		SplashTextOn("JDAST", "Download Speed = " & $Kbpersec & "Kb/s" & @CRLF & "Upload Speed = " & $Kbpersec_up & "Kb/s" & @CRLF & "Ping = " & $ping & "ms", 250, 90, @DesktopWidth - 260, @DesktopHeight - 150)
		Sleep(2000)
		SplashOff()
	EndIf
	_csvfile()
	$xarray[0][0]+=1
EndFunc   ;==>cyclegregtest

Func uploadtest()
	$ftpupfilesize = FileGetSize($ftpupfile) * 8
	$Open = _FTPOpen('MyFTP Contr')
	$Conn = _FTPConnect($Open, $ftpserver, $ftpusername, $ftppassword)
	$starttime = _Timer_Init()
	$Ftpp = _FTP_UploadProgress($Conn, $ftpupfile, $ftpuplocation & "/ULspeedtest.txt", "UPloadprogress")
	$time = _Timer_Diff($starttime) - ($ftpultrim * 1000)
	_FTPClose($Open)
	If $Ftpp = -1 Then Return -1
	If $Conn = 0 Then
		MsgBox(0, "JDast ftp upload test", "CAN NOT connect to ftp server !", 10)
		Return 0
	EndIf
	If $Ftpp = 0 Then
		MsgBox(0, "JDast ftp upload test", "Could NOT upload test file !", 10)
		Return 0
	EndIf
	If $time < 1000 And $Ftpp <> -1 Then
		MsgBox(0, "JDast", "Your Upload FTP settings are not right" & @CRLF & "or your test file is to small" & @CRLF & "Please check your settings", 20)
		Return 0
	EndIf
	$bitspersecup = $ftpupfilesize / ($time / 1000)
	$kbpsup = $bitspersecup / 1024
	$Kbpersecup = Round($kbpsup)
	Return $Kbpersecup
EndFunc   ;==>uploadtest

Func UPloadprogress($percent)
	If $silentrunning = 4 Then
		GUICtrlSetData($progressbar1, $percent)
		Switch GUIGetMsg()
			Case $cancletestcyclebut
				Return -1 ; Just Cancel, without special Return value
		EndSwitch
	EndIf
	Return 1 ; Otherwise contine Upload
EndFunc   ;==>UPloadprogress

Func _csvfile()
	If FileExists($csvfile & "\Speed_Test.csv") = 0 Then
		_FileWriteLog($csvfile & "\Speed_Test.csv", "," & "DL Speed" & "," & "UL Speed" & "," & "Ping")
	Else
		_FileWriteLog($csvfile & "\Speed_Test.csv", "," & $Kbpersec & "," & $Kbpersec_up & "," & $ping)
		$addval = 1
	EndIf
EndFunc   ;==>_csvfile

Func wait()
	GUISetState(@SW_HIDE, $form1)
	_reducememory()
	$c = @MIN
	$memdown = @MIN
	$tgm = 0
	TraySetToolTip("JDAST. " & $timex & " Minute Cycles." & @CRLF & "Next Cycle in " & $timex - $trigger & " minutes")
	While $trigger < $timex
		$tgm = TrayGetMsg()
		If $tgm = $trayshow Or $tgm = $TRAY_EVENT_PRIMARYDOWN Then
			GUISetState(@SW_SHOW, $form1)
			GUISetState(@SW_RESTORE, $form1)
			main()
		EndIf
		If $tgm = $trayexit Then Exit
		If $tgm = $pause Then ;;;;;;;;;;;;;;;;;;; tray pause
			If $pausetesting = 0 Then
				$pausetesting = 1
				TrayItemSetText($pause, "Un-Pause")
				TraySetIcon("Shell32.dll", -110)
			Else
				$pausetesting = 0
				TrayItemSetText($pause, "Pause")
				TraySetIcon("")
			EndIf
		EndIf
		If @MIN <> $c Then
			$trigger += 1
			$c = @MIN
		EndIf
		If $memdown <> @MIN Then
			traytipset()
			$memdown = @MIN
		EndIf
	WEnd
	$trigger = 0
EndFunc   ;==>wait

Func Traytipset()
	TraySetToolTip("JDAST. " & $timex & " Minute Cycles." & @CRLF & "Next Cycle in " & $timex - $trigger & " minutes")
	_reducememory()
EndFunc   ;==>Traytipset

Func _reDraw();beta redraw script
	$sise = WinGetClientSize("JackDinn`s Auto Speed Tester");1008, 743
	$xdif = 1 / (1008 / $sise[0])
	$ydif = 1 / (700 / $sise[1])
	$hForm1 = _GDIPlus_GraphicsCreateFromHWND($form1)
	_GDIPlus_GraphicsDrawImageRect($hForm1, $bitmap, 192 * $xdif, 87 * $ydif, 812 * $xdif, 587 * $ydif);*(743/$sise[1])
	_GDIPlus_GraphicsDispose($hForm1)
EndFunc   ;==>_reDraw

Func _listview1()
	GUICtrlSetState($ListView1, $GUI_hide)
	$lvtogle = $updown
	_GUICtrlListView_DeleteAllItems($ListView1)
	For $x = 2 To $xarray[0][0]
		GUICtrlCreateListViewItem($x & "|" & StringMid($xarray[$x][0], 6, 5) & "  " & StringMid($xarray[$x][0], 11, 6) & "|" & $xarray[$x][1] & "|" & $xarray[$x][2] & "|" & $xarray[$x][3], $ListView1)
		GUICtrlSetBkColor(-1, 0xddeeff)
	Next
	$lvcount = _GUICtrlListView_GetItemCount($ListView1)
	_GUICtrlListView_SimpleSort($ListView1, $lvtogle, $colsortno)
	If $updown = 1 Then
		_GUICtrlListView_SetItemSelected($ListView1, 0)
	Else
		_GUICtrlListView_SetItemSelected($ListView1, $lvcount - 1)
	EndIf
	GUICtrlSetState($ListView1, $GUI_show)
EndFunc   ;==>_listview1

Func _tracert($trcloc)
	$HG_tracert = GUICreate("TRACERT", 450, 355, 200, 125, -1, -1, $form1)
	$HB_tracert_cancel = GUICtrlCreateButton("STOP", 310, 310, 137, 37, 0)
	$tcrmb = GUICtrlCreateEdit("TRACERT", 5, 5, 445, 300)
	GUISetBkColor(0x8899ff)
	GUISetState(@SW_SHOW)
	_reDraw()
	$iPID = Run(@ComSpec & " /c tracert " & $trcloc, @TempDir, @SW_HIDE, $STDOUT_CHILD)
	$tcrtout = ""
	$tcrcatch = ""
	While 1
		$msg5 = GUIGetMsg()
		If $msg5 = $HB_tracert_cancel Then ExitLoop
		$tcrtout &= StdoutRead($iPID)

		If $tcrtout <> $tcrcatch Then
			GUICtrlSetData($tcrmb, $tcrtout)
			_GUICtrlEdit_Scroll($tcrmb, $SB_PAGEDOWN)
			$tcrcatch = $tcrtout
		EndIf
		If @error Then ExitLoop
	WEnd
	DllClose("user32.dll")
;~ 	$tcrtout = StringRegExpReplace($tcrtout, "\s{2,}", @CRLF)
	ProcessClose("tracert.exe")
	_reDraw()
	GUICtrlSetData($HB_tracert_cancel, "EXIT")
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($HG_tracert)
				ExitLoop
			Case $HB_tracert_cancel
				GUIDelete($HG_tracert)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_tracert

Func _helpabout()
	$line = ""
	$file = FileOpen("C:\Program Files\JDAST\readme.txt", 0)
	$hgui = GUICreate("Help & About", 600, 600, 0, 0, $ws_sizebox, -1, $form1)
	$hlist = GUICtrlCreateEdit("", 0, 0, 600, 580, $WS_VSCROLL)
	GUICtrlSetFont($hlist, 12)
	GUISetState()
	While 1
		$linex = FileReadLine($file) & @CRLF
		$line = $line & $linex
		If @error = -1 Then ExitLoop
	WEnd
	GUICtrlSetData($hlist, $line)
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($hgui)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_helpabout

Func _checkproc()
	Dim $splitproc[105]
	For $x = 1 To $PPqarray[0]
		$sp = StringSplit($PPqarray[$x], "\")
		$splitproc[$x] = ($sp[$sp[0]])
		If ProcessExists($splitproc[$x]) Then Return 1
	Next
EndFunc   ;==>_checkproc