;Already running check
$PList = ProcessList("wFTPLogRead.exe")
If $PList[0][0] > 1 Then
	MsgBox(48," wFTPLogRead"," wFTPLogRead is already active",3)
	WinActivate(" wFTPLogRead")
	Exit
EndIf

; SETTINGS
$appVersion = "0.1"
$appTitle = " wFTPLogRead v" & $appVersion
$testingvariable = 0

; INCLUDES
#include <GUIConstants.au3>
#Include <GuiListView.au3>
#include <Array.au3>
#include <FTP.au3>
#include <Math.au3>
#include <File.au3>
;#include <Misc.au3>

; VARIABLES
$timervar = 0
$ifvar = 0

; OPTIONS
Opt("TrayMenuMode",1)
If NOT @compiled Then
	Opt("TrayIconDebug", 1)
	Opt("TrayAutoPause",0)
EndIf
If @compiled Then
	Opt("TrayIconHide",1)
	;#NoTrayIcon
EndIf
;Opt("GUIOnEventMode", 1)

; TRAY
$TrayQuick = TrayCreateItem("Export Log")
TrayItemSetState($TrayQuick,128)
$TrayRestore = TrayCreateItem("Restore")
TrayItemSetState($TrayRestore,128)
TrayCreateItem("")
$TrayExit = TrayCreateItem("Exit")

; HOTKEYS
;HotKeySet("{ESC}", "LeaveLoop")

; GUI
$GUIMain = GUICreate($appTitle,550,375)

;GUISetBkColor (16777215)
GUISetIcon("favicon.ico",0)
Opt("GUICloseOnESC",0)

; MENU
$MenuFile = GUICtrlCreateMenu("&File")
	$MenuExit = GUICtrlCreateMenuitem("Exit",$MenuFile)
$MenuEdit = GUICtrlCreateMenu("&Edit")
	$MenuOptions = GUICtrlCreateMenuitem("Options...        Ctrl+O",$MenuEdit)
;$MenuTools = GUICtrlCreateMenu("&Tools")
;	$MenuFTP = GUICtrlCreateMenuitem("FTP",$MenuTools)
$MenuView = GUICtrlCreateMenu("&View")
	$MenuRefresh = GUICtrlCreateMenuitem("&Refresh        F5",$MenuView)
$MenuHelp = GUICtrlCreateMenu("&Help")
;	$MenuInstructions = GUICtrlCreateMenuitem("Instructions        F1",$MenuHelp)

;-----------------------------------------------------------
;FILTERS
GUICtrlCreateGroup("       Filter Results:  ",10,5,530,70)
$optFilter = GUICtrlCreateCheckbox("",20,2,20,20)
$optFilterCams = GUICtrlCreateCheckbox("CatCams",20,20)
$optFilterFox = GUICtrlCreateCheckbox("Firefox",20,40)
GUICtrlSetState($optFilterCams,$gui_disable)
GUICtrlSetState($optFilterFox,$gui_disable)
;-----------------------------------------------------------
;PROGRESS -- $PBS_SMOOTH
$progress = GUICtrlCreateProgress(10,80,530,8,$PBS_SMOOTH)
;-----------------------------------------------------------
;BUTTONS
$btnScan = GUICtrlCreateButton("Scan",480,35,50,20,BitOR($BS_FLAT,$BS_DEFPUSHBUTTON))
;-----------------------------------------------------------
;Read filters
$optFilterRead = GUICtrlRead($optFilter)
$optFilterCamsRead = GUICtrlRead($optFilterCams)
$optFilterFoxRead = GUICtrlRead($optFilterFox)

$listview = GUICtrlCreateListView("TimeStamp              |User   |Action |Detail|",10,90,530,255)
_GUICtrlListViewSetColumnWidth($listview,4,250)

;-----------------------------------------------------------
;GUICtrlCreateLabel("Location:", 5, 5, 153, 15)

; BROWSE BUTTON
;$btnBrowse = GUICtrlCreateButton("&Browse", 284, 18, 100, 25)

;-----------------------------------------------------------

; GUI MESSAGE LOOP

GUISetState()
;ReadFile()

While 1

	$msg = GUIGetMsg()
	$traymsg = TrayGetMsg()
	;If $traymsg <> 0 AND $traymsg <> -11 Then MsgBox(0,"TrayMsg",$traymsg)

	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	If $msg = $menuOptions Then Options()
	If @compiled Then
		If $msg = $GUI_EVENT_MINIMIZE Then Opt("TrayIconHide",0)
	EndIf

	Opt("GUICloseOnESC",0)

	Select

		Case $msg = $GUI_EVENT_MINIMIZE
			TrayItemSetState($TrayRestore,64)
			GUISetState(@SW_HIDE)

		Case $traymsg = $TrayRestore OR $traymsg = -13
			;Exit Program
			GUISetState(@SW_SHOW)
			GUISetState(@SW_RESTORE)
			If @compiled Then
				Opt("TrayIconHide",1)
			EndIf

		Case $traymsg = $TrayExit
			;Exit Program
			Exit
			
		Case $msg = $MenuRefresh
			;Reload log
			ClearList($listview)
			ReadFile()

		Case $msg = $optFilter
			;ReadChecks()
			; Set Checks
			If $optFilterRead = 1 Then
				GUICtrlSetState($optFilterCams,$gui_enable)
				GUICtrlSetState($optFilterFox,$gui_enable)
			ElseIf $optFilterRead = 4 Then
				GUICtrlSetState($optFilterCams,$gui_disable)
				GUICtrlSetState($optFilterFox,$gui_disable)
			EndIf

		Case $msg = $optFilterCams

			; Read Checks
			ReadChecks()

			If $optFilterCamsRead Then
				ClearList($listview)
				ReadFile()
			EndIf

		Case $msg = $optFilterFox

			; Read Checks
			ReadChecks()

			If $optFilterFoxRead Then
				ClearList($listview)
				ReadFile()
			EndIf

		Case $msg = $MenuExit
			;Exit Program
			Kill()

	EndSelect

	#cs
	$evenodd = _MathCheckDiv($timervar,1000)
	If $evenodd = 2 Then
		ClearList($listview)
		ReadFile()
	EndIf
	$timervar = $timervar + 1
	#ce

Wend

; FUNCTIONS
Func ReadChecks()
	; Read Checks
	$optFilterRead = GUICtrlRead($optFilter)
	$optFilterCamsRead = GUICtrlRead($optFilterCams)
EndFunc

Func ReadFile()
	$totallines = 0
	$linecount = 0
	$linepercent = 0
	$delayvar = 0
	$file = FileOpen("c:\wFTPLog.txt",0)
	GUICtrlSetState($optFilter,$gui_disable)

	; Check if file opened for reading OK
	If $file = -1 Then
	    MsgBox(0, "Error", "Unable to open file.")
	    Exit
	EndIf

	; Fill List
	While 1
		$delayvar = $delayvar + 1
	
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then Kill()
		
		#cs
		$exit = _IsPressed("1B")
		If $exit = 1 Then ExitLoop
		#ce
		
		#cs
		$totallinesc = _FileCountLines("c:\wFTPLog.txt")
		If $ifvar = 0 Then
			;MsgBox(0,"Total",$totallinesc)
		EndIf
		$linecount = $linecount + 1
		$linepercent = (($linecount/$totallinesc) * 100)
		$evenodddelay = _MathCheckDiv($delayvar,100)
		If $evenodddelay = 2 Then
			GUICtrlSetData($progress,$linepercent)
		EndIf
		#ce
		
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop ; end of file
		If @error = 1 Then
			MsgBox(0,"error","Cannot read line")
		EndIf
		
		;Valid Line - Count it
		;$totallines = $totallines + 1
		
		If $optFilterRead = 4 Then
			GUICtrlCreateListViewItem($line,$listview)
			;_GUICtrlListViewScroll($listview,1,10)
		Else
			;FILTER RESULTS
			$linearray = StringSplit($line,"|")
			#cs
			$linearray[0] = Total
			$linearray[1] = timestamp
			$linearray[2] = username
			$linearray[3] = action
			$linearray[4] = detail
			$linearray[5] = blank
			#ce
			If $optFilterCamsRead = 4 AND $optFilterFoxRead = 4 Then
				GUICtrlCreateListViewItem($line,$listview)
				;_GUICtrlListViewScroll($listview,1,10)
			ElseIf $optFilterCamsRead = 1 Then
				If $linearray[2] <> "brcmsS" AND $linearray[2] <> "bascom" Then
					GUICtrlCreateListViewItem($line,$listview)
					;_GUICtrlListViewScroll($listview,1,10)
				EndIf
			ElseIf $optFilterFoxRead = 1 Then
				If $linearray[4] <> "H:\rss\inforss.XML" AND $linearray[4] <> "H:\rss\inforss.RDF" Then
					GUICtrlCreateListViewItem($line,$listview)
					;_GUICtrlListViewScroll($listview,1,10)
				EndIf
			EndIf
		EndIf
	$ifvar = $ifvar + 1
	Wend

	FileClose($file)
	;GUICtrlSetData($progress,0)
	GUICtrlSetState($optFilter,$gui_enable)
	_GUICtrlListViewScroll($listview,1,10)
	$timervar = 0
EndFunc

Func ClearList($listview)
    Local $LVM_DELETEALLITEMS = 0x1009
    GUICtrlSendMsg($listview, $LVM_DELETEALLITEMS,0,0)
EndFunc

;Launches the Options GUI
Func Options()
	;Create GUI
	$GUIOptions = GUICreate(" wFTPLog Options",300,200,-1,-1,-1,-1,$GUIMain)
	Opt("GUICloseOnESC",1)
	$btnOK = GUICtrlCreateButton("OK",130,170,80,25)
	$btnCancel = GUICtrlCreateButton("Cancel",215,170,80,25)
	$tabGroup = GUICtrlCreateTab(5,6,290,160)
	$tabPreferences = GUICtrlCreateTabItem("Preferences")
		GUICtrlCreateLabel("Options:",13,40)
		$tabCheck1 = GUICtrlCreateCheckbox("Show Webcams",25,55)
		;GUICtrlCreateLabel("Show Messages:",13,80)
		;$tabCheck2 = GUICtrlCreateCheckbox("Initial Warning",25,95)
		;$tabCheck3 = GUICtrlCreateCheckbox("Plot Confirmation",25,115)
	;$tabLocations = GUICtrlCreateTabItem("Locations")

	;Set Dynamic Checkboxes
	If $optFilterRead = 1 Then
		GUICtrlSetState($tabCheck1,$GUI_CHECKED)
	EndIf

	;Tooltips
	GUICtrlSetTip ($tabCheck1,"Filters webcams from the log")
	;GUICtrlSetTip ($tabCheck2,"Filters firefox from the log")
	;GUICtrlSetTip ($tabCheck3,"Minimize the application to the task tray")


	GUISetState(@SW_SHOW)
	while 1
		$msg2 = GUIGetMSG()
		Select
			Case $msg2 = $GUI_EVENT_CLOSE
				GUIDelete($GUIOptions)
				ExitLoop

			Case $msg2 = $btnCancel
				GUIDelete($GUIOptions)
				ExitLoop

			Case $msg2 = $btnOK
				$tabCheck1Value = GUICtrlRead($tabCheck1)
				If $tabCheck1Value = 1 Then
					$optFilter = 1
				Else
					$optFilter = 0
				EndIf

				GUIDelete($GUIOptions)
				ExitLoop
		EndSelect
	WEnd

EndFunc

Func Kill()
	;Autolaunch Self - Test Mode
	If NOT @compiled Then
		Run(@COMSPEC & " /c " & @scriptfullpath,"",@sw_hide)
	EndIf
	Exit
EndFunc

;MsgBox(0,"End","End of code",1)
Kill()