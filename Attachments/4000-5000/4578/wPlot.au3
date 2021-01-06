;Already running check
$PList = ProcessList("wPlot.exe")
If $PList[0][0] > 1 Then
	MsgBox(48,"wPlot","wPlot is already active",3)
	WinActivate("wPlot")
	Exit
EndIf

; SETTINGS
;#NoTrayIcon
$appVersion = ".08"
$appTitle = " wPlot v" & $appVersion
$ipHP1050c = "10.0.0.237"
$defaultdir = "Q:\Plot"

; INI OPERATIONS
IniWrite("C:\wPlot.ini","Application","Version",$appVersion)
$iniTabCheck1 = IniRead("C:\wPlot.ini","Preferences","tabCheck1",1)

#include <GuiConstants.au3>
#include <Array.au3>


If $iniTabCheck1 = 1 Then
	MsgBox(64,"wPlot","wPlot currently supports single file submission." & @CRLF & "Please do not submit more than one file at a time.")
EndIf

; VARIABLES
Dim $varFolderSel
Dim $listcontents

; HOTKEY
HotKeySet("{F5}","HotF5") ; Refresh the file list
HotKeySet("{F1}","HotF1") ; Display Help
HotKeySet("^o","Options") ; Display Options

; OPTIONS
Opt("TrayIconDebug", 1)
;Opt("GUIOnEventMode", 1)

; GUI
$guiMain = GuiCreate($appTitle,390,295)
;GUISetBkColor (16777215)
GuiSetIcon("favicon.ico",0)
Opt("GUICloseOnESC",0)

; MENU 
$MenuFile = GuiCtrlCreateMenu("&File")
	$MenuExit = GUICtrlCreateMenuitem("Exit",$MenuFile)
$MenuEdit = GuiCtrlCreateMenu("&Edit")
	$MenuOptions = GUICtrlCreateMenuitem("Options...        Ctrl+O",$MenuEdit)
$MenuView = GuiCtrlCreateMenu("&View")
	$MenuRefresh = GUICtrlCreateMenuitem("&Refresh        F5",$MenuView)
$MenuHelp = GuiCtrlCreateMenu("&Help")
	$MenuInstructions = GUICtrlCreateMenuitem("Instructions        F1",$MenuHelp)

;-----------------------------------------------------------

; LOCATION DROPDOWN
GuiCtrlCreateLabel("Location:", 5, 5, 153, 15)
$combo = GuiCtrlCreatecombo($defaultdir, 5, 20, 250, 160, -1)
guictrlsetdata($combo,$defaultdir)
guictrlsetdata($combo,"C:\Plot")
;GUICtrlSetState($combo,$GUI_DISABLE)

; BROWSE BUTTON
$btnBrowse = GuiCtrlCreateButton("&Browse", 284, 18, 100, 25)

;-----------------------------------------------------------

; FILE LIST
GuiCtrlCreateLabel("Select File:", 5, 55, 153, 15)
$listView = GuiCtrlCreateListView("File|Size|Modified|", 5, 70, 380, 100,$LVS_NOSORTHEADER)
;_GUICtrlListViewJustifyColumn($listview,1,1) <-- Beta code... not used

; Populate list with contents of default dir
FileChangeDir($defaultdir)
$search = FileFindFirstFile("*.plt")
	
; Check if the search was successful
If $search = 0 Then
	FillList()
EndIf

;-----------------------------------------------------------

; UPDOWN
GuiCtrlCreateLabel("Number Copies:", 260, 203)
$inputNumCopies = GuiCtrlCreateInput("1", 345, 200, 40, 20)
GuiCtrlCreateUpDown(-1)
Guictrlsetlimit(-1,99,0)

; PRINTER DROPDOWN
GuiCtrlCreateLabel("Select Printer:", 5, 185, 153, 15)
$comboPrinter = GuiCtrlCreatecombo("HP 1050C", 5, 200, 230, 160)
guictrlsetdata(-1,"K+E 6800")
guictrlsetdata(-1,"KIP")

; SUBMIT BUTTON
$btnSubmit = GuiCtrlCreateButton("&Submit Job", 285, 240, 100, 30)

;-----------------------------------------------------------
; GUI MESSAGE LOOP
GUISetState()
While 1; GuiGetMsg() <> $GUI_EVENT_CLOSE
	
	$msg = GuiGetMsg()
		
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	If $msg = $menuOptions Then Options()
	Opt("GUICloseOnESC",0)
	
	Select
		Case $msg = $MenuExit
			;Exit Program
			Kill()
			
		Case $msg = $MenuRefresh
			;Refresh Menu Item
			HotF5()
					
		Case $msg = $menuInstructions
			;Refresh Menu Item
			HotF1()
		
		Case $msg = $combo ; combo dropdown
			; COMBO BOX
			$combovalue = GUICtrlRead($combo)
			FileChangeDir($combovalue)
			$search = FileFindFirstFile("*.plt")
			
			; Check if the search was successful
			If $search = -1 Then
				MsgBox(0, "Error", "No plot files.  Choose a new location.")
			Else
				If $search = 0 Then
					FillList()
				EndIf
			EndIf
									
		Case $msg = $btnBrowse ; browse button
			; BROWSE
			$message = "Select a folder..."
			$varFolderSel = FileSelectFolder($message, "", 2, $defaultdir)
			
			If @error Then
				;MsgBox(4096,"","No Folder chosen")
			Else
	
				FileChangeDir($varFolderSel)
				$search = FileFindFirstFile("*.plt")
				
				; Check if the search was successful
				If $search = -1 Then
					    MsgBox(0, "Error", "No plot files.  Choose a new location.")
				Else
					If $search = 0 Then
						FillList()
						GUICtrlSetData($combo,$varFolderSel,$varFolderSel)
					EndIf
				EndIf
			EndIf
			
		Case $msg = $btnSubmit ; submit button
			$numCopies = GUICtrlRead($inputNumCopies)
			$printer = GUICtrlRead($comboprinter)
			$fileID = GUICtrlRead($listView) ; GUICtrlID for the ListViewItem
			$fileLoc = GUICtrlRead($combo)
			$fileString = GUICtrlRead($fileID)
			$fileStringLen = StringLen($fileString)
			$fileTrim = StringInStr($fileString,"|")-1
			$fileToPlot = StringLeft($fileString,$fileTrim)
			$fileToPlotLen = StringLen($fileToPlot)
			$fileMid1 = StringInStr($fileString,"|",-1,1)
			$fileMid2 = StringInStr($fileString,"|",-1,2)
			$fileMidTot = $fileMid2 - $fileMid1
			$fileSize = StringMid($fileString,$fileToPlotLen + 2,$fileMidTot - 4)
			;MsgBox(0,"FileSize",$fileToPlot)
			If StringInStr($fileToPlot," ") OR StringInStr($fileToPlot,",") Then
				$fileToPlotOrig = $FileToPlot
				$fileToPlot = StringReplace($fileToPlot," ","")
				$fileToPlot = StringReplace($fileToPlot,",","")
				FileMove($fileToPlotOrig,$fileToPlot,1)
				MsgBox(0,$fileToPlotOrig,"File contained invalid characters and was renamed." & @crlf & "New file: " & $fileToPlot)
			
				;Clear file list
				FileChangeDir($fileLoc)
				$search = FileFindFirstFile("*.plt")
				FillList()
				
			EndIf
			
			;String of index number "|"
			$selectStringIndex = ControlListView("wPlot","",$listview,"GetSelected",1)
			
			;Array of selected indexes
			$selectArrayIndex = StringSplit($selectStringIndex,"|")
			$numberOfItemsSelected = $selectArrayIndex[0]
			
			If $fileToPlot <> "" Then
			
				;$getText = ControlListView("wPlot","",$listview,"GetText",1,0)
				
				;Debug Messages
				;MsgBox(4096,"File",$fileToPlot,1)
				;MsgBox(4096,"Copies",$numCopies,1)
				;MsgBox(4096,"Selected",$numberOfItemsSelected,1)
				;MsgBox(0,"System",@systemDir)
				
				;For $i = 1 To $aRecords[0]
				;	$fileArrayString = $fileArrayString & $aRecords[$x] & "|"
				;Next
				;$fileArrayString = StringTrimRight($fileArrayString, 1)
				
				;---------
				;need to make array to cycle through...
				;MsgBox(4096,"Array2",$ListReadArray[2])
				;MsgBox(4096,"Printer",$printer,1)
				;MsgBox(4096,"Copies",$numCopies,1)
				
				;Launch DOS and send print commands
				If GUICtrlRead($comboPrinter) = "HP 1050C" Then
					Run("cmd.exe","",@SW_HIDE)
					;Run("cmd.exe","")
					WinWait(@systemDir & "\cmd.exe")
					
					;Progress Meter
					;Only supports files <= 999,999 
					$meterDelim = StringInStr($filesize,",")
					If $meterDelim <> 0 Then
						$meterNum1 = StringLeft($filesize,$meterDelim - 1)
						$meterNum2 = StringTrimLeft($filesize,$meterDelim)
						$meterNoComma = $meternum1 & $meternum2
						$meterSpeed = ($meterNoComma * $numCopies)/10
					Else
						$meterSpeed = ($filesize * $numCopies)/100
					EndIF
					
					Run("wInc\pg.exe " & $meterSpeed)
					
					ControlSend(@systemDir & "\cmd.exe", "","","ftp " & $ipHP1050c & "{ENTER}")
					Sleep("100")
					ControlSend(@systemDir & "\cmd.exe", "","","{ENTER}")
					Sleep("100")
					ControlSend(@systemDir & "\cmd.exe", "","","{ENTER}")
					$iprint = $numCopies
					While $iprint <> 0
						ControlSend(@systemDir & "\cmd.exe", "","","put " & $fileToPlot & "{ENTER}")
						$iprint = $iprint - 1
					WEnd
					ControlSend(@systemDir & "\cmd.exe", "","","quit{ENTER}")
						If $numCopies > 1 Then
							$pagevar = " pages"
						Else
							$pagevar = " page"
						EndIf
					ControlSend(@systemDir & "\cmd.exe", "","","net send jwiggins " & @UserName & " sent " & $numCopies & $pagevar & " to the HP1050C.{ENTER}")
					;ControlSend(@systemDir & "\cmd.exe", "","","net send alewis " & @UserName & " sent " & $numCopies & $pagevar &  " to the HP1050C.{ENTER}")
					;MsgBox(0,"wPlot","File Sent.")
					ControlSend(@systemDir & "\cmd.exe", "","","exit{ENTER}")
					;ControlClick("wPlot","",2)
				Else
					MsgBox(0,"Error", "The " & GUICtrlRead($comboPrinter) & " is not yet configured.")
				EndIf
			Else
				MsgBox(0,"Error", "No files selected.")
			EndIf
			$fileToPlot = ""
			$fileToPlotOrig = ""
	EndSelect

	;Release Hotkeys if window not active
	If NOT WinActive(" wPlot") Then
		HotKeySet("{F5}") ; Unset F5 key
		HotKeySet("{F1}") ; Unset F1 key
		HotKeySet("^o") ; Unset Options key
	Else
		HotKeySet("{F5}","HotF5") ; Refresh the file list
		HotKeySet("{F1}","HotF1") ; Display Help
		HotKeySet("^o","Options") ; Display Options
	EndIf
	
Wend

; FUNCTIONS

;New help because I can't run a new GUI without breaking my app.
Func HotF1()
	Run(@COMSPEC & ' /c "S:\Wiggins\W\wInc\wPlot.txt"','',@sw_hide)
EndFunc

#cs
;Old Help GUI
Func HotF1()
	$guiHelp = GuiCreate(" wPlot Help",400,200,-1,-1,-1,$WS_EX_TOOLWINDOW,$guiMain)
	GUISetBkColor (16777215)
	Opt("GUICloseOnESC",1)
	
	$guiHelpTextString = "Instructions:" & @crlf & @crlf & "1. Browse to a location that contains .plt files.  They will appear in the list." & @crlf & @crlf & "2. Select the file you would like to print." & @crlf & @crlf & "3. Choose your printer." & @crlf & @crlf & "4. Enter the number of copies." & @crlf & @crlf & "5. Click submit."
	
	$guiHelpText = GUICtrlCreateEdit($guiHelpTextString,5,6,390,190,$ES_READONLY)
	
	GUISetState(@SW_SHOW)
	While 1
		$msg = GUIGetMSG()
		Select
			case $msg = $GUI_EVENT_CLOSE
				GUIDelete($guiHelp)
				ExitLoop
		EndSelect
	WEnd
EndFunc
#ce

;Launches the Options GUI
Func Options()
	;Create GUI
	$guiOptions = GuiCreate(" wPlot Options",300,200,-1,-1,-1,-1,$guiMain)
	Opt("GUICloseOnESC",1)
	$btnOK = GuiCtrlCreateButton("OK",130,170,80,25)
	$btnCancel = GuiCtrlCreateButton("Cancel",215,170,80,25)
	$tabGroup = GUICtrlCreateTab(5,6,290,160)
	$tabPreferences = GUICtrlCreateTabItem("Preferences")
		$tabCheck1 = GUICtrlCreateCheckbox("Initial Warning",25,55)
		GUICtrlCreateLabel("Show Messages:",13,40)
	;$tabLocations = GUICtrlCreateTabItem("Locations")
	
	;Variables
	$tabCheck1Set = IniRead("C:\wPlot.ini","Preferences","tabCheck1",1)
	
	;Set Dynamic Checkboxes
	If $tabCheck1Set = 1 Then
		GUICtrlSetState($tabCheck1,$GUI_CHECKED)
	EndIf
	
	;Tooltips
	GUICtrlSetTip ($tabCheck1,"Disables the 'Single File' warning on startup")

	
	GUISetState(@SW_SHOW)
	while 1
		$msg = GUIGetMSG()
		Select
			case $msg = $GUI_EVENT_CLOSE
				GUIDelete($guiOptions)
				ExitLoop
				
			case $msg = $btnCancel
				GUIDelete($guiOptions)
				ExitLoop
			
			Case $msg = $btnOK
				$tabCheck1Value = GUICtrlRead($tabCheck1)
				If $tabCheck1Value = 1 Then
					IniWrite("C:\wPlot.ini","Preferences","tabCheck1",1)
				Else
					IniWrite("C:\wPlot.ini","Preferences","tabCheck1",4)
				EndIf
				GUIDelete($guiOptions)
				ExitLoop
		EndSelect
	WEnd
	
EndFunc

;Adds commas to large numbers
Func FormatNumber($Number)
	;Given a number such as 12345678 will return 12,345,678
	Dim $Result='', $Pos
	If StringIsDigit($Number) Then
	$Pos = StringLen($Number)-2
	While $Pos > -2
	If $Pos < 1 Then
	$Result = StringMid($Number, 1, $Pos + 2) & ',' & $Result
	Else
	$Result = StringMid($Number, $Pos, 3) & ',' & $Result
	EndIf
	$Pos = $Pos - 3
	WEnd
	$Result=StringLeft($Result, StringLen($Result) - 1)
	EndIf
	Return $Result
EndFunc

;Clears the list view
Func _GUICtrlLVClear($listview)
    Local $LVM_DELETEALLITEMS = 0x1009
    GuiCtrlSendMsg($listview, $LVM_DELETEALLITEMS,0,0)
EndFunc

;Refreshes the list view
Func HotF5()
	;Fill file list
	$combovaluehot = GUICtrlRead($combo)
	
	FileChangeDir($combovaluehot)
	$search = FileFindFirstFile("*.plt")
	FillList()
EndFunc

;Populates the list view with all .plt files
Func FillList()

	_GUICtrlLVClear($listview)
	
	While 1
		$file = Filefindnextfile($search)
		$size = FileGetSize($file) / 1024
		$date = FileGetTime($file)
		
		If @error <> 1 Then
			If $date[3] > 12 Then
				$ampm = " PM"
				$hour = $date[3] - 12
			Else
				$ampm = " AM"
				$hour = $date[3]
			EndIf
			$hour = StringReplace($hour,"0","")
			$time = $hour & ":" & $date[4] & $ampm
			$month = StringReplace($date[1],"0","")
			If StringLeft($date[2],1) = 0 Then
				$day = StringReplace($date[2],"0","")
			Else
				$day = $date[2]
			EndIf
			$dateformat = $month & "/" & $day & "/" & $date[0] & " " & $time
		EndIf
		
		If @error <> 1 Then
			$size = Round($size,0)
			;MsgBox(0,"Size",$size)
		EndIf
		
		$bytemarker = " KB"
		If @error Then Exitloop
		
		$listcontents = GuiCtrlCreateListViewItem($file & "|" & FormatNumber($size) & $bytemarker & "|" & $dateformat, $listView)
	WEnd
	FileClose($search)
EndFunc

Func Kill()
	;Autolaunch Self - Test Mode
	;Run(@COMSPEC & ' /c "C:\Documents and Settings\Jesse\Desktop\scripts\W\wPlot\wPlot.au3"','',@sw_hide)
	Exit
EndFunc

;MsgBox(0,"End","End of code",1)
Kill()