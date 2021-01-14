#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author:	Jon Mason
 Date:		4/1/2007

 Script Function:
	simple script to help manage my growing number of rdp sessions

#ce ----------------------------------------------------------------------------
#include <GuiConstants.au3>
#include <Array.au3>
$version = "2.2"
$ip = ""
$rdp = @SystemDir & "\mstsc.exe"
$appName = "mstsc Options+ v" & $version

if Not FileExists($rdp) Then
	MsgBox(48, "Error", "Can not find " & $rdp & @CR & "Now exiting.")
	Exit
EndIf
$iniFile = @ScriptDir & "\mstsc.ini"

GuiCreate($appName, 220, 310)

$mnu_Options = GuiCtrlCreateMenu ("Options")
$mnu_exitOnConnect = GuiCtrlCreateMenuitem ("Exit on connect",$mnu_Options)
$mnu_writeRDPcmd = GuiCtrlCreateMenuitem ("Print RDP command",$mnu_Options)
$mnu_SaveSession = GuiCtrlCreateMenuitem ("Save previous session",$mnu_Options)

GuiCtrlCreateLabel("Saved Connections", 10, 10)
GuiCtrlCreateLabel("Name:", 10, 60)
GuiCtrlCreateLabel("Server/Workstation:", 10, 110)
GuiCtrlCreateLabel(".rdp base:", 10, 160)

$Cm_Saved = GuiCtrlCreateCombo("", 10, 30, 200, 21)

$In_Name = GuiCtrlCreateInput("", 10, 80, 200, 20)
$In_ServerIP = GuiCtrlCreateInput("", 10, 130, 200, 20)
$In_RDPFile = GuiCtrlCreateInput("", 10, 180, 150, 20)
$In_Width = GuiCtrlCreateInput("800", 100, 230, 50, 20)
$In_Height = GuiCtrlCreateInput("600", 160, 230, 50, 20)

$ch_Console = GuiCtrlCreateCheckbox("Console", 10, 210, 70, 20)
GUICtrlSetTip(-1, "Takes over console at the server side" & @CR & _
				"Usefull if you want to login as Admin but not start a 2nd instance")
$ch_FullScr = GuiCtrlCreateCheckbox("Full Screen", 10, 230, 80, 20)
GUICtrlSetTip(-1, "Create RDP session to take up entire screen")
$Ch_Height = GuiCtrlCreateCheckbox("Height", 160, 210, 80, 20)
$Ch_Width = GuiCtrlCreateCheckbox("Width", 100, 210, 50, 20)

$Bt_Conect = GuiCtrlCreateButton("Connect", 10, 260, 60)
$Bt_Save = GuiCtrlCreateButton("Save", 80, 260, 60)
$Bt_Remove = GuiCtrlCreateButton("Remove", 150, 260, 60)
$Bt_RDPBrowse = GuiCtrlCreateButton("Browse", 165, 178, 50)

readSaved()
readPref()


;HotKeySet("{ENTER}", "HotKeyConnect")
;HotKeySet("{ESC}", "Terminate")

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
			
		Case $Bt_Conect
			$ip = GUICtrlRead($In_ServerIP)
			$w = GUICtrlRead($Ch_Width)
			$h = GUICtrlRead($Ch_Height)
			$rdpF = GUICtrlRead($In_RDPFile)
			$go = 1
			
			if $ip = "" Then
				MsgBox(48, "Error", "No IP or URL to connect to")
				$go = 0
			EndIf
			
			if $w = 1 Then
				if GUICtrlRead($In_Width) = "" Then
					MsgBox(48, "Error", "RDP width specified w/o entering value")
					$go = 0
				EndIf
			EndIf
			
			if $h = 1 Then
				if GUICtrlRead($In_Height) = "" Then
					MsgBox(48, "Error", "RDP width specified w/o entering value")
					$go = 0
				EndIf
			EndIf
			
			if $rdpF <> "" Then
				if not FileExists(@ScriptDir & "\" & $rdpF) Then
					MsgBox(48, "Error", "File Not found:" & @CR & @ScriptDir & "\" & $rdpF)
					$go = 0
				EndIf
			EndIf
			
			if $go = 1 Then
				Connect()
			EndIf
			
		Case $Bt_Save
			;save screen
			Select
				Case GUICtrlRead($In_Name) = ""
					MsgBox(48, "Error", "Please enter a name to save too")
				
				Case GUICtrlRead($In_ServerIP) = ""
					MsgBox(48, "Error", "Please enter a server URL/short name/IP address to save")
				
				case Else
					Save()
			EndSelect
			
		Case $Bt_Remove
			if MsgBox(4, "Verify Remove", "Are you sure you want to remove " & GUICtrlRead($Cm_Saved) & "?") = 6 Then
				Remove()
			EndIf
			
		Case $Bt_RDPBrowse
			;Open File Dialog to "My Documents"
			$file = FileOpenDialog("Choose file...", @ScriptDir, "RDP file (*.rdp)")
			If $file <> "1" Then
				$fileStringSplit = StringSplit($file, "\")
				GUICtrlSetData($In_RDPFile, $fileStringSplit[$fileStringSplit[0]])
			EndIf
			
		Case $Cm_Saved
			;if the user changes a selection in the drop down box, update the screen
			UpdateScr()
			
		Case $ch_FullScr
			;disable width options if full screen is checked
			FullScrCheck()
			
		Case $mnu_exitOnConnect
			If BitAnd(GUICtrlRead($mnu_exitOnConnect),$GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($mnu_exitOnConnect,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($mnu_exitOnConnect,$GUI_CHECKED)
			EndIf
			writePref()
			
		Case $mnu_writeRDPcmd
			If BitAnd(GUICtrlRead($mnu_writeRDPcmd),$GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($mnu_writeRDPcmd,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($mnu_writeRDPcmd,$GUI_CHECKED)
			EndIf
			writePref()
			
		Case $mnu_SaveSession
			If BitAnd(GUICtrlRead($mnu_SaveSession),$GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($mnu_SaveSession,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($mnu_SaveSession,$GUI_CHECKED)
			EndIf
			writePref()
			
		Case Else
			;;;
	EndSwitch
WEnd

writePref()
Exit

Func HotKeyConnect()
	if WinActive($appName) Then
		;$msg = $Bt_Conect
	EndIf
EndFunc

Func Terminate()
	if WinActive($appName) Then
		Exit 0
	EndIf
EndFunc

Func readPref()
	$exitOnConnect = IniRead($iniFile, "conf", "exitOnConnect", "yes")
	$writeRDP = IniRead($iniFile, "conf", "writeRDP", "no")
	$saveSession = IniRead($iniFile, "conf", "SaveSession", "yes")
	
	if $exitOnConnect = "yes" Then GUICtrlSetState($mnu_exitOnConnect,$GUI_CHECKED)
	if $writeRDP = "yes" Then GUICtrlSetState($mnu_writeRDPcmd,$GUI_CHECKED)
	if $saveSession = "yes" Then GUICtrlSetState($mnu_SaveSession,$GUI_CHECKED)
EndFunc

Func writePref()
	If BitAnd(GUICtrlRead($mnu_exitOnConnect),$GUI_CHECKED) = $GUI_CHECKED Then
		$exitOnConnect = "yes"
	Else
		$exitOnConnect = "no"
	EndIf
	If BitAnd(GUICtrlRead($mnu_writeRDPcmd),$GUI_CHECKED) = $GUI_CHECKED Then
		$writeRDP = "yes"
	Else
		$writeRDP = "no"
	EndIf
	If BitAnd(GUICtrlRead($mnu_SaveSession),$GUI_CHECKED) = $GUI_CHECKED Then
		$saveSession = "yes"
	Else
		$saveSession = "no"
	EndIf
	;IniWrite($iniFile, 
	IniWrite($iniFile, "conf", "exitOnConnect", $exitOnConnect)
	IniWrite($iniFile, "conf", "writeRDP", $writeRDP)
	IniWrite($iniFile, "conf", "SaveSession", $saveSession)
EndFunc

Func Connect()
	if pingTarget($ip) Then
		$run = $rdp
		;mstsc.exe /v:n060app01.esde.kroger.com /console
		if GUICtrlRead($In_RDPFile) <> "" Then
			$run = $run & ' "' & @ScriptDir & '\' & GUICtrlRead($In_RDPFile) & '"'
		EndIf
		$run = $run & " /v:" & $ip
		
		if GUICtrlRead($ch_Console) =1 then $run = $run & " /Console"
		if GUICtrlRead($ch_FullScr) =1 then 
			$run = $run & " /f"
		Else
			if GUICtrlRead($Ch_Width) = 1 then $run = $run & " /w:" & GUICtrlRead($In_Width)
			if GUICtrlRead($Ch_Height) = 1 then $run = $run & " /h:" & GUICtrlRead($In_Height)
		EndIf
		
		;see the rdp command or to run it?
		if IniRead($iniFile, "conf", "writeRDP", 'no') = "yes" Then
			Run("notepad.exe")
			WinWaitActive("Untitled - Notepad")
			Send($run)
		Else
			Run($run)
		EndIf
		
		;exit program after starting connection?
		if IniRead($iniFile, "conf", "exitOnConnect", '') = "yes" Then
			Exit
		EndIf
		
		;save last connect
		if GUICtrlRead($Cm_Saved) <> "" And GUICtrlRead($Cm_Saved) = GUICtrlRead($In_Name) Then
			IniWrite($iniFile, "conf", "last", GUICtrlRead($Cm_Saved))
		EndIf
	EndIf
EndFunc

;reads ini file and populates drop down box
Func readSaved()
	GUICtrlSetData($Cm_Saved, "") ;blank saved pull down
	$saved = IniReadSectionNames($iniFile)
	if not @error Then
		_ArraySort($saved)
		$c = ""
		For $i = 1 To $saved[0]
			if StringLeft($saved[$i], 4) = "rdp-" Then
				$name = StringRight($saved[$i], StringLen($saved[$i]) - 4)
				if $c = "" Then
					$c = $name
				Else
					$c = $c & "|" & $name
				EndIf
			EndIf
		Next
		
		if IniRead($iniFile, "conf", "SaveSession", "yes") = "yes" then 
			GUICtrlSetData($Cm_Saved, $c, IniRead($iniFile, "conf", "last", ""))
		Else
			GUICtrlSetData($Cm_Saved, $c)
		EndIf
		UpdateScr()
	EndIf
EndFunc

;saves settings on screen ini file
Func Save()
	IniWrite($iniFile, "rdp-" & GUICtrlRead($In_Name), "IP", GUICtrlRead($In_ServerIP))
	IniWrite($iniFile, "rdp-" & GUICtrlRead($In_Name), "h", GUICtrlRead($In_Height))
	IniWrite($iniFile, "rdp-" & GUICtrlRead($In_Name), "w", GUICtrlRead($In_Width))
	IniWrite($iniFile, "rdp-" & GUICtrlRead($In_Name), "rdpFile", GUICtrlRead($In_RDPFile))
	
	if GUICtrlRead($ch_Console) = 1 Then 
		$console = "checked"
	Else
		$console = "unchecked"
	EndIf
	if GUICtrlRead($ch_FullScr) = 1 Then 
		$fullScreen = "checked"
	Else
		$fullScreen = "unchecked"
	EndIf
	if GUICtrlRead($Ch_Width) = 1 Then 
		$widthCh = "checked"
	Else
		$widthCh = "unchecked"
	EndIf
	if GUICtrlRead($Ch_Height) = 1 Then 
		$heightCh = "checked"
	Else
		$heightCh = "unchecked"
	EndIf

	IniWrite($iniFile, "rdp-" & GUICtrlRead($In_Name), "console", $console)
	IniWrite($iniFile, "rdp-" & GUICtrlRead($In_Name), "fullScreen", $fullScreen)
	IniWrite($iniFile, "rdp-" & GUICtrlRead($In_Name), "heightCh", $heightCh)
	IniWrite($iniFile, "rdp-" & GUICtrlRead($In_Name), "widthCh", $widthCh)
	
	;UpdateScr()
	readSaved()
EndFunc

;updates screen info to reflect saved rdp setting in ini file
Func UpdateScr()
	$ip = IniRead($iniFile, "rdp-" & GUICtrlRead($Cm_Saved), "IP" , "")
	$name = GUICtrlRead($Cm_Saved)
	$w = IniRead($iniFile, "rdp-" & GUICtrlRead($Cm_Saved), "w" , "800")
	$h = IniRead($iniFile, "rdp-" & GUICtrlRead($Cm_Saved), "h" , "600")
	$wC = IniRead($iniFile, "rdp-" & GUICtrlRead($Cm_Saved), "widthCh" , "null")
	$hC = IniRead($iniFile, "rdp-" & GUICtrlRead($Cm_Saved), "heightCh" , "null")
	$fc = IniRead($iniFile, "rdp-" & GUICtrlRead($Cm_Saved), "fullScreen" , "null")
	$con = IniRead($iniFile, "rdp-" & GUICtrlRead($Cm_Saved), "console" , "null")
	$rdpF = IniRead($iniFile, "rdp-" & GUICtrlRead($Cm_Saved), "rdpFile" , "null")
	
	;MsgBox(0, "", $name)
	
	GUICtrlSetData($In_ServerIP, $ip)
	GUICtrlSetdata($In_Name, $name)
	if $w <> "null" Then
		GUICtrlSetdata($In_Width, $w)
	Else
		GUICtrlSetdata($In_Width, 800)
	EndIf
	if $h <> "null" Then
		GUICtrlSetdata($In_Height, $h)
	Else
		GUICtrlSetdata($In_Height, 600)
	EndIf
	if $rdpF = "null" Then
		GUICtrlSetdata($In_RDPFile, "")
	Else
		GUICtrlSetdata($In_RDPFile, $rdpF)
	EndIf
	
	Switch $hC
		Case "Checked"
			GUICtrlSetState($Ch_Height, $GUI_CHECKED)
		case Else
			GUICtrlSetState($Ch_Height, $GUI_UNCHECKED)
	EndSwitch
	Switch $wC
		Case "Checked"
			GUICtrlSetState($Ch_Width, $GUI_CHECKED)
		case Else
			GUICtrlSetState($Ch_Width, $GUI_UNCHECKED)
	EndSwitch
	
	Switch $fc
		Case "Checked"
			GUICtrlSetState($ch_FullScr, $GUI_CHECKED)
			FullScrCheck()
		case Else
			GUICtrlSetState($ch_FullScr, $GUI_UNCHECKED)
			FullScrCheck()
	EndSwitch
	Switch $con
		Case "Checked"
			GUICtrlSetState($ch_Console, $GUI_CHECKED)
		case Else
			GUICtrlSetState($ch_Console, $GUI_UNCHECKED)
	EndSwitch
	
EndFunc

;disables and unchecks screen size options if full screen is checked
;and re-enables then if full screen is unchecked
Func FullScrCheck()
	if GUICtrlRead($ch_FullScr) = 1 Then
		GUICtrlSetState($Ch_Width, $GUI_DISABLE)
		GUICtrlSetState($Ch_Height, $GUI_DISABLE)
		GUICtrlSetState($In_Width, $GUI_DISABLE)
		GUICtrlSetState($In_Height, $GUI_DISABLE)
		
		;uncheck w & h optison if full screen is shcedked
		GUICtrlSetState($Ch_Height, $GUI_UNCHECKED)
		GUICtrlSetState($Ch_Width, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Ch_Width, $GUI_ENABLE)
		GUICtrlSetState($Ch_Height, $GUI_ENABLE)
		GUICtrlSetState($In_Width, $GUI_ENABLE)
		GUICtrlSetState($In_Height, $GUI_ENABLE)
	EndIf
EndFunc

;removes saved rdp setting on screen
Func Remove()
	IniDelete($iniFile, "rdp-" & GUICtrlRead($Cm_Saved))
	GUICtrlSetdata($In_Name, "")
	GUICtrlSetdata($In_ServerIP, "")
	GUICtrlSetdata($In_RDPFile, "")
	GUICtrlSetdata($In_Width, 800)
	GUICtrlSetdata($In_Height, 600)
	GUICtrlSetState($Ch_Height, $GUI_UNCHECKED)
	GUICtrlSetState($Ch_Width, $GUI_UNCHECKED)
	GUICtrlSetState($ch_FullScr, $GUI_UNCHECKED)
	GUICtrlSetState($ch_Console, $GUI_UNCHECKED)
	readSaved()
EndFunc

;check to see if target host is on line or not
Func pingTarget($p)
	Ping($p)
	if @error Then
		Switch @error
			case 1
				MsgBox(48, "Host is offline", $p)
			case 2
				MsgBox(48, "Host is unreachable", $p)
			Case 3
				MsgBox(48, "Bad destination", $p)
			Case 4
				MsgBox(48, "Other errors", $p)
			Case Else
				;unknown error that might not be covered
				MsgBox(48, "Unknown error", $p)
		EndSwitch
		Return 0
	Else
		Return 1
	EndIf
EndFunc