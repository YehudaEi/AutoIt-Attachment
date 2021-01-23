#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_run_tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1) ; 0=no, 1=require pre-declare

If _Singleton(@ScriptName, 1) = 0 Then
	Debug(@ScriptName & " is already running!", 0x40, 5)
	Exit
EndIf

#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <String.au3>
#include <Date.au3>
#include <Array.au3>
#include <iNet.au3>
#include "_DougFunctions.au3"

DirCreate("AUXFiles")

Local $tmp = StringSplit(@ScriptName, ".")
Global $Project_filename = @ScriptDir & "\AUXFiles\" & $tmp[1] & ".prj"
Global $LOG_filename = @ScriptDir & "\AUXFiles\" & $tmp[1] & ".log"

Local $SystemS = @OSVersion & "  " & @OSServicePack & "  " & @OSTYPE & "  " & @ProcessorArch & "  " & @IPAddress1
Global $MainForm = GUICreate(@ScriptName & "  version: 0.0.0.1  " & $SystemS, 750, 400, 10, 10)

Global $ButtonPing = GUICtrlCreateButton("Ping", 8, 15, 75, 20, 0)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "This will do the pings. (What did you expect?)")

Global $LabelData = GUICtrlCreateLabel("Data", 90, 15, 40, 20, 0x1000)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
Global $InputIPAddress = GUICtrlCreateInput("InputIPAddress", 135, 15, 300, 20, 0x81)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "String describing the addresses to test")
GUICtrlSetState(-1, $GUI_DROPACCEPTED)

Global $LabelLocalIP = GUICtrlCreateLabel("Local IP", 450, 8, 50, 20, 0x1000)
Global $InputLocalIP = GUICtrlCreateInput("7777", 505, 8, 90, 20, 0x0800)
GUICtrlSetData($InputLocalIP, @IPAddress1)
GUICtrlSetFont(500, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "This is the systems local IP address")

Global $LabelPublicIP = GUICtrlCreateLabel("Public IP", 450, 30, 50, 20, 0x1000)
Global $InputPublicIP = GUICtrlCreateInput("7777", 505, 30, 90, 20, 0x0800)
GUICtrlSetData($InputPublicIP, _GetIP())
GUICtrlSetFont(500, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "This is the systems public IP address (what the WWW sees)")

Global $LabelTimeout = GUICtrlCreateLabel("Timeout", 610, 15, 60, 20, 0x1000)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
Global $InputTimeout = GUICtrlCreateInput("****", 675, 15, 50, 20, 0x081)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Timeout value in milliseconds")

Global $CheckDNS = GUICtrlCreateCheckbox("DNS", 10, 50, 60, 30)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Display DNS results of alive hosts")

Global $CheckClass = GUICtrlCreateCheckbox("Class", 80, 50, 60, 30)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Display IP Class")

Global $CheckSpecial = GUICtrlCreateCheckbox("Special", 150, 50, 75, 30)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Include special")

Global $ButtonSaveProject = GUICtrlCreateButton("Save project", 260, 50, 100, 20, 0)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Save the current settings")
Global $ButtonLoadProject = GUICtrlCreateButton("Load project", 360, 50, 107, 20, 0)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Load saved settings")

Global $ButtonSaveLog = GUICtrlCreateButton("Save log", 470, 50, 75, 20, 0)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Save a log of test results")

Global $ButtonViewLog = GUICtrlCreateButton("View log", 545, 50, 75, 20, 0)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "View a saved log of test results")

Global $ButtonAbout = GUICtrlCreateButton("About", 620, 50, 55, 20, 0)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "About button")

Global $ButtonExit = GUICtrlCreateButton("Exit", 675, 50, 55, 20, 0)
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Exit button")

Global $hListView = _GUICtrlListView_Create($MainForm, "Address|Status|Class|Reponse (ms)|Name", 10, 80, 720, 300)
_GUICtrlListView_SetColumnWidth($hListView, 0, 100)
_GUICtrlListView_SetColumnWidth($hListView, 1, 50)
_GUICtrlListView_SetColumnWidth($hListView, 2, 75)
_GUICtrlListView_SetColumnWidth($hListView, 3, 80)
_GUICtrlListView_SetColumnWidth($hListView, 4, 400)
_GUICtrlListView_SetExtendedListViewStyle($hListView, $LVS_EX_GRIDLINES)

DefaultSettings()
LoadProject("start")

GUISetState(@SW_SHOW)
While 1
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ButtonExit
			Exit
		Case $ButtonPing
			PingTheHosts()
		Case $InputLocalIP
			Debug("Case $InputLocalIP")
		Case $InputPublicIP
			Debug("Case $InputPublicIP")
		Case $InputIPAddress
			Debug("Case $InputIPAddress")
		Case $ButtonSaveProject
			SaveProject()
		Case $ButtonLoadProject
			LoadProject("Menu")
		Case $ButtonSaveLog
			SaveLog()
		Case $ButtonViewLog
			ViewLog()
		Case $ButtonAbout
			Debug(@CRLF & @ScriptName & @CRLF & "Written by Doug Kaynor because I wanted to!", 0x40, 5)

	EndSwitch
WEnd

;-----------------------------------------------
Func PingTheHosts()
	Debug("PingTheHosts")
	GuiDisable("disable")
	_GUICtrlListView_DeleteAllItems($hListView)
	If GUICtrlRead($CheckSpecial) = $GUI_CHECKED Then
		_GUICtrlListView_AddItem($hListView, "127.0.0.1")
		_GUICtrlListView_AddItem($hListView, GUICtrlRead($InputLocalIP))
		_GUICtrlListView_AddItem($hListView, GUICtrlRead($InputPublicIP))
	EndIf
	; Parse the addresses
	Local $HostList = StringSplit(GUICtrlRead($InputIPAddress), ";:,")
	
	;Add all of the addresses to the listview
	_ArrayDelete($HostList, 0) ;get rid of the count value
	For $A In $HostList
		$A = StringStripWS($A, 8) ;remove spaces
		If $A <> "" Then ;ignore blank values
			Local $B = IPAddress($A)
			For $C In $B
				_GUICtrlListView_AddItem($hListView, $C)
			Next
		EndIf
	Next

	;now do the testing
	For $X = 0 To _GUICtrlListView_GetItemCount($hListView)
		Local $T = _GUICtrlListView_GetItemText($hListView, $X)
		Local $result = Ping($T, GUICtrlRead($InputTimeout))
		_GUICtrlListView_AddSubItem($hListView, $X, StringFormat("%d", $result), 3)

		If $result = 0 Then
			_GUICtrlListView_AddSubItem($hListView, $X, "Dead", 1)
			;	_GUICtrlListView_SetItem ($hListView,$X,)
		Else
			_GUICtrlListView_AddSubItem($hListView, $X, "Alive", 1)
			Local $DNSResult = ""
			If GUICtrlRead($CheckDNS) = $GUI_CHECKED Then
				TCPStartup()
				$DNSResult = _TCPIpToName($T, 0)
			Else
				$DNSResult = ""
			EndIf
			_GUICtrlListView_AddSubItem($hListView, $X, $DNSResult, 4)
		EndIf
		
		Local $ClassResult = ""
		If GUICtrlRead($CheckClass) = $GUI_CHECKED Then
			$ClassResult = CheckIPClass($T)
		Else
			$ClassResult = ""
		EndIf
		_GUICtrlListView_AddSubItem($hListView, $X, $ClassResult, 2)
		
	Next
	TCPShutdown()

	GuiDisable("enable")
EndFunc   ;==>PingTheHosts
;-----------------------------------------------
Func SaveProject()
	Debug("SaveProject")
	$Project_filename = FileSaveDialog("Save project file", @ScriptDir & "\AUXFiles\", _
			"PingTool projects (P*.prj)|All projects (*.prj)|All files (*.*)", 18, @ScriptDir & "\AUXFiles\PingTool.prj")

	Local $file = FileOpen($Project_filename, 2)
	; Check if file opened for writing OK
	If $file = -1 Then
		Debug("SaveProject: Unable to open file for writing: " & $Project_filename, 0x10, 5)
		Return
	EndIf
	
	FileWriteLine($file, "Valid for PingTool project")
	FileWriteLine($file, "InputIPAddress:" & GUICtrlRead($InputIPAddress))
	FileWriteLine($file, "CheckDNS:" & GUICtrlRead($CheckDNS))
	FileWriteLine($file, "CheckClass:" & GUICtrlRead($CheckClass))
	FileWriteLine($file, "CheckSecial:" & GUICtrlRead($CheckSpecial))
	FileWriteLine($file, "InputTimeout:" & GUICtrlRead($InputTimeout))
	FileWriteLine($file, "Help 1 is enabled, 4 is disabled for checkboxes")
	FileClose($file)
EndFunc   ;==>SaveProject
;-----------------------------------------------
Func LoadProject($type)
	Debug("LoadProject")
	If StringCompare($type, "menu") = 0 Then
		$Project_filename = FileOpenDialog("Load project file", @ScriptDir & "\AUXFiles\", _
				"PingTool projects (P*.prj)|All projects (*.prj)|All files (*.*)", 18, @ScriptDir & "\AUXFiles\PingTool.prj")
	EndIf
	
	Local $file = FileOpen($Project_filename, 0)
	; Check if file opened for reading OK
	If $file = -1 Then
		Debug("LoadProject: Unable to open file for reading: " & $Project_filename, 0x10, 5)
		Return
	EndIf
	
	Debug("LoadProject 2   " & $Project_filename & "    " & $type)
	; Read in the first line to verify the file is of the correct type
	If StringCompare(FileReadLine($file, 1), "Valid for PingTool project") <> 0 Then
		Debug("Not a valid project file for PingTool", 0x20, 5)
		FileClose($file)
		Return
	EndIf
	
	; Read in lines of text until the EOF is reached
	While 1
		Local $LineIn = FileReadLine($file)
		If @error = -1 Then ExitLoop
		If StringInStr($LineIn, "InputIPAddress:") Then GUICtrlSetData($InputIPAddress, StringMid($LineIn, StringInStr($LineIn, ":") + 1))
		If StringInStr($LineIn, "CheckDNS:") Then GUICtrlSetState($CheckDNS, StringMid($LineIn, StringInStr($LineIn, ":") + 1))
		If StringInStr($LineIn, "CheckClass:") Then GUICtrlSetState($CheckClass, StringMid($LineIn, StringInStr($LineIn, ":") + 1))
		If StringInStr($LineIn, "CheckSpecial:") Then GUICtrlSetState($CheckSpecial, StringMid($LineIn, StringInStr($LineIn, ":") + 1))
		If StringInStr($LineIn, "InputTimeout:") Then GUICtrlSetData($InputTimeout, StringMid($LineIn, StringInStr($LineIn, ":") + 1))
	WEnd
	
	FileClose($file)
	_GUICtrlListView_DeleteAllItems($hListView)
EndFunc   ;==>LoadProject
;-----------------------------------------------
Func SaveLog()
	Debug("SaveLog")
	$LOG_filename = FileSaveDialog("Save log file", @ScriptDir & "\AUXFiles\", _
			"PingTool logs (P*.log)|All logs (*.log)|All files (*.*)", 18, @ScriptDir & "\AUXFiles\PingTool.log")

	Local $file = FileOpen($LOG_filename, 2)
	; Check if file opened for writing OK
	If $file = -1 Then
		Debug("SaveLog: Unable to open file for writing: " & $LOG_filename, 0x10, 5)
		Return
	EndIf
	
	FileWriteLine($file, "Log file for " & @ScriptName & "  " & _DateTimeFormat(_NowCalc(), 1))
	FileWriteLine($file, "InputIPAddress: " & GUICtrlRead($InputIPAddress))
	FileWriteLine($file, "CheckDNS: " & GUICtrlRead($CheckDNS))
	FileWriteLine($file, "CheckClass:" & GUICtrlRead($CheckClass))
	FileWriteLine($file, "InputTimeout: " & GUICtrlRead($InputTimeout))

	For $X = 0 To _GUICtrlListView_GetItemCount($hListView)
		Local $T = _GUICtrlListView_GetItem($hListView, $X)
		If StringCompare($T, "0") = 1 Then
			FileWriteLine($file, $T)
			debug($T)
		EndIf
	Next
	
	FileClose($file)
EndFunc   ;==>SaveLog
;-----------------------------------------------

Func ViewLog()
	Debug("ViewLog")
	$LOG_filename = FileOpenDialog("View log file", @ScriptDir & "\AUXFiles\", _
			"PingTool logs (P*.log)|All logs (*.log)|All files (*.*)", 18, @ScriptDir & "\AUXFiles\PingTool.log")
	Local $file = FileOpen($LOG_filename, 0)
	; Check if file opened for reading OK
	If $file = -1 Then
		Debug("ViewLog: Unable to open file for reading: " & $LOG_filename, 0x10, 5)
		Return
	EndIf
	
	
	_GUICtrlListView_DeleteAllItems($hListView)
	While 1
		Local $LineIn = FileReadLine($file)
		If @error = -1 Then ExitLoop
		GUICtrlSetData($hListView, $LineIn)
		GUICtrlSetColor(-1, 0xffffff) ;white
	WEnd
	
	FileClose($file)
EndFunc   ;==>ViewLog
;-----------------------------------------------
Func GuiDisable($choice) ;@SW_ENABLE @SW_disble
	Debug("GuiDisable " & $choice)
	Global $LastState
	Local $setting
	
	If $choice = "Enable" Then
		$setting = $GUI_ENABLE
	ElseIf $choice = "Disable" Then
		$setting = $GUI_DISABLE
	ElseIf $choice = "Toggle" Then
		If $LastState = $GUI_DISABLE Then
			$setting = $GUI_ENABLE
		Else
			$setting = $GUI_DISABLE
		EndIf
	Else
		Debug("Invalid choice at GuiDisable" & $choice, 0x40)
	EndIf
	
	$LastState = $setting
	For $X = 1 To 20
		If $hListView <> $X Then ;Don't disable the listview
			Local $result = GUICtrlSetState($X, $setting)
			;debug($X & "  " & $setting & "  " & $result)
		EndIf
	Next

EndFunc   ;==>GuiDisable
;-----------------------------------------------
Func DefaultSettings()
	GUICtrlSetData($InputIPAddress, "127.0.0.1;" & GUICtrlRead($InputPublicIP) & "+5")
	GUICtrlSetData($InputTimeout, 1000)
	GUICtrlSetState($CheckDNS, $GUI_CHECKED)
	GUICtrlSetState($CheckClass, $GUI_CHECKED)
	GUICtrlSetState($CheckSpecial, $GUI_CHECKED)
EndFunc   ;==>DefaultSettings
;-----------------------------------------------