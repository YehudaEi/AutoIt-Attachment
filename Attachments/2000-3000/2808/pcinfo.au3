; PcINFO.....
; Created by Byteme
; 
AutoItSetOption("WinTitleMatchMode", 2)
AutoItSetOption("WinDetectHiddenText", 1)

#Include <process.au3>
#include <GuiConstants.au3>

filedelete("c:\temp\connect.ini")
if fileexists(@SystemDir & "\img123.jpg") then
	sleep(100)
Else
	fileinstall("c:\pcinfo\img123.jpg", @SystemDir & "\img123.jpg", 1)
EndIf
SplashTextOn("Info Updates...", "Checking for updates.  Please wait....", 500, 25)
sleep(1000)
if fileexists("\\server\share\update.exe") Then
	splashoff()
	runwait("\\server\share\update.exe")
EndIf
splashoff()
$ps = RegRead("HKEY_CURRENT_USER\Software\microsoft\windows\currentversion\internet settings", "proxyServer")
$dn = RegRead("HKEY_LOCAL_MACHINE\Software\microsoft\windows nt\currentversion\winlogon", "defaultdomainname")
$cm = RegRead("HKEY_LOCAL_MACHINE\Software\microsoft\windows\currentversion\windowsupdate\oeminfo", "wbemproduct")
$ls = StringTrimRight(@logonserver, 1)
if $cm = "" then $cm = "? Unknown ?"
	if $dn = "" then $dn = "? Unknown ?"
		if $dn = "" then $dn = "? Unknown ?"
If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000

GuiCreate("PC INFO.....", 677, 424,(@DesktopWidth-677)/2, (@DesktopHeight-424)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$Label_1 = GuiCtrlCreateLabel("Your computer name is:", 10, 10, 160, 20)
$Label_2 = GuiCtrlCreateLabel("Windows Version:", 10, 50, 160, 20)
$Label_3 = GuiCtrlCreateLabel("Service Pack:", 10, 95, 160, 20)
$Label_4 = GuiCtrlCreateLabel("IP Address:", 10, 140, 160, 20)
$Label_5 = GuiCtrlCreateLabel("Logged on user:", 10, 180, 160, 20)
$Label_6 = GuiCtrlCreateLabel("Logon Domain:", 10, 220, 160, 20)
$Label_7 = GuiCtrlCreateLabel("Logon Server:", 10, 260, 160, 20)
$Label_8 = GuiCtrlCreateLabel("Proxy Server:", 10, 300, 160, 20)
$Label_9 = GuiCtrlCreateLabel("PC Domain:", 10, 340, 160, 20)
$Label_10 = GuiCtrlCreateLabel("PC Model:", 10, 380, 160, 20)
$Label_11 = GuiCtrlCreateLabel(@ComputerName, 185, 10, 85, 20)
$Label_12 = GuiCtrlCreateLabel(@OSVersion, 185, 50, 85, 20)
$Label_13 = GuiCtrlCreateLabel(@OSServicePack, 185, 95, 85, 20)
$Label_14 = GuiCtrlCreateLabel(@IPAddress1, 185, 140, 85, 20)
$Label_15 = GuiCtrlCreateLabel(@UserName, 185, 180, 85, 20)
$Label_16 = GuiCtrlCreateLabel(@LogonDomain, 185, 220, 85, 20)
$Label_17 = GuiCtrlCreateLabel($ls, 185, 260, 85, 20)
$Label_18 = GuiCtrlCreateLabel($ps, 185, 300, 85, 20)
$Label_19 = GuiCtrlCreateLabel($dn, 185, 340, 85, 20)
$Label_20 = GuiCtrlCreateLabel($cm, 185, 380, 85, 20)
$Icon_21 = GuiCtrlCreateIcon("icon", 0, 630, 10, 32, 32)
$Pic_22 = GuiCtrlCreatePic(@SystemDir & "\img123.jpg", 310, 50, 350, 263)
$Button_23 = GuiCtrlCreateButton("Close", 370, 390, 260, 20)
$Button_24 = GuiCtrlCreateButton("Request for Service", 370, 360, 260, 20)
$Button_25 = GuiCtrlCreateButton("Remote Access Control", 370, 330, 260, 20)

if @hour > 12 Then
	$hour = @hour - 12
Else
	$hour = @hour
endif
$date = guictrlcreatelabel("Time: " & $hour & ":" & @min & "   Date: " & @mon & "/" & @mday & "/" & @year, 350, 10, 200, 20)
GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $Button_23 Then
		ExitLoop
		EndIf
	if $msg = $Button_24 Then
		guidelete()

if fileexists("c:\temp") then
	fileinstall("c:\pcinfo\connect.ini", "c:\temp\connect.ini", 1)
Else
	DirCreate("c:\temp")
	fileinstall("c:\pcinfo\connect.ini", "c:\temp\connect.ini", 1)
	EndIf
if @hour > 12 Then
	$hour = @hour - 12
	$z = ("pm")
Else
	$hour = @hour
	$z = ("am")
	
endif
$t = ($hour & ":" & @min & " " & $z)
$d = (@mon & "/" & @mday & "/" & @year)
$input1 = @UserName
$input2 = @ComputerName
$input3 = @OSVersion
$input4 = @IPAddress1
$file = FileOpen("c:\temp\connect.vbs", 2)
$db = IniRead("c:\temp\connect.ini", "Settings", "Full Database Path", "")
$table = IniRead("c:\temp\connect.ini", "Settings", "Table Name", "")
FileWriteLine($file, 'Dim adoCon, rsAddInfo, strSQL')
FileWriteLine($file, 'Set adoCon = CreateObject("ADODB.Connection")')
FileWriteLine($file, 'adoCon.Open "DRIVER={Microsoft Access Driver (*.mdb)}; DBQ=' & $db & '"')
FileWriteLine($file, 'Set rsAddInfo = CreateObject("ADODB.Recordset")')
FileWriteLine($file, 'strSQL = "SELECT * FROM ' & $table & ';"')
FileWriteLine($file, 'rsAddInfo.CursorType = 2')
FileWriteLine($file, 'rsAddInfo.LockType = 3')
FileWriteLine($file, 'rsAddInfo.Open strSQL, adoCon')
FileWriteLine($file, 'rsAddInfo.AddNew')
FileWriteLine($file, 'rsAddInfo.Fields("username") = ' & '"' & $input1 & '"')
FileWriteLine($file, 'rsAddInfo.Fields("pc name") = ' & '"' & $input2 & '"')
FileWriteLine($file, 'rsAddInfo.Fields("windows version") = ' & '"' & $input3 & '"')
FileWriteLine($file, 'rsAddInfo.Fields("ip address") = ' & '"' & $input4 & '"')
FileWriteLine($file, 'rsAddInfo.Fields("time") = ' & '"' & $t & '"')
FileWriteLine($file, 'rsAddInfo.Fields("date") = ' & '"' & $d & '"')


GuiCreate("Report A Problem.....", 402, 633,(@DesktopWidth-402)/2, (@DesktopHeight-633)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$Radio_1 = GuiCtrlCreateRadio("E-Mail", 20, 20, 180, 20)
$Radio_2 = GuiCtrlCreateRadio("Mainframe", 20, 60, 180, 20)
$Radio_3 = GuiCtrlCreateRadio("Printers", 20, 100, 180, 20)
$Radio_4 = GuiCtrlCreateRadio("Internet\Intranet", 20, 140, 180, 20)
$Radio_5 = GuiCtrlCreateRadio("User Account Information Maintenance", 20, 180, 230, 20)
$Radio_6 = GuiCtrlCreateRadio("Password Resets\Unlocks", 20, 220, 180, 20)
$Radio_7 = GuiCtrlCreateRadio("Network", 20, 260, 180, 20)
$Radio_8 = GuiCtrlCreateRadio("Hardware Issues", 20, 300, 180, 20)
$Radio_9 = GuiCtrlCreateRadio("Software", 20, 340, 180, 20)
$Radio_10 = GuiCtrlCreateRadio("Scanner", 20, 380, 180, 20)
$Radio_11 = GuiCtrlCreateRadio("Blackberry", 20, 420, 180, 20)
$Radio_12 = GuiCtrlCreateRadio("Shared Data Access", 20, 460, 180, 20)
$Radio_13 = GuiCtrlCreateRadio("PC Re-Image", 20, 500, 180, 20)
$Radio_14 = GuiCtrlCreateRadio("Laptop", 20, 540, 180, 20)
$Radio_15 = GuiCtrlCreateRadio("Other", 20, 580, 180, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $radio_1 Then
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Email"')
		GUIDelete() 
	
GuiCreate("Email Problems...", 416, 330,(@DesktopWidth-416)/2, (@DesktopHeight-330)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$em1 = GuiCtrlCreateRadio("Does not work", 20, 10, 320, 20)
$em2 = GuiCtrlCreateRadio("Cannot Access", 20, 50, 320, 20)
$em3 = GuiCtrlCreateRadio("Delegate permissions/access to", 20, 90, 320, 20)
$em4 = GuiCtrlCreateRadio("Spam", 20, 130, 320, 20)
$em5 = GuiCtrlCreateRadio("Personal folders", 20, 170, 320, 20)
$em6 = GuiCtrlCreateRadio("Contact list", 20, 210, 320, 20)
$em7 = GuiCtrlCreateRadio("Tips", 20, 250, 320, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $em1 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Does not work"')
		GUIDelete()

		exitloop
		elseif $msg = $em2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Cannot Access"')
				GUIDelete()

		exitloop
		elseif $msg = $em3 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Delegate Permissions/Access to"')
				GUIDelete()

		exitloop
		elseif $msg = $em4 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Spam"')
				GUIDelete()

		exitloop
		elseif $msg = $em5 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Personal Folders"')
				GUIDelete()

		exitloop
		elseif $msg = $em6 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Contact List"')
				GUIDelete()

		exitloop
		elseif $msg = $em7 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Tips"')
				GUIDelete()

		EndIf
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
WEnd

		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------		
	ElseIf	$msg = $radio_2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Mainframe"')
		GUIDelete()
		GuiCreate("Mainframe problems...", 417, 336,(@DesktopWidth-417)/2, (@DesktopHeight-336)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$mf1 = GuiCtrlCreateRadio("Does not work", 20, 20, 270, 20)
$mf2 = GuiCtrlCreateRadio("Imaging", 20, 60, 270, 20)
$mf3 = GuiCtrlCreateRadio("Printing problem", 20, 100, 270, 20)
$mf4 = GuiCtrlCreateRadio("Sessions fail", 20, 140, 270, 20)
$mf5 = GuiCtrlCreateRadio("Password resets", 20, 180, 270, 20)
$mf6 = GuiCtrlCreateRadio("LGAS/LGEN", 20, 220, 270, 20)
$mf7 = GuiCtrlCreateRadio("Keyboard mapping", 20, 260, 270, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $mf1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Does not work"')
		GUIDelete()

		exitloop
		elseif $msg = $mf2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Imaging"')
				GUIDelete()

		exitloop
		elseif $msg = $mf3 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Printing Problem"')
				GUIDelete()

		exitloop
		elseif $msg = $mf4 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Sessions fail"')
				GUIDelete()

		exitloop
		elseif $msg = $mf5 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Password reset"')
				GUIDelete()

		exitloop
		elseif $msg = $mf6 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"LGAS/LGEN"')
				GUIDelete()

		exitloop
		elseif $msg = $mf7 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Keyboard mapping"')
				GUIDelete()
		ExitLoop
		
	Select
		
	Case $msg = $GUI_EVENT_CLOSE
		
		
	Case Else
		;;;
	EndSelect
	endif
WEnd

		ExitLoop
		
;------------------------------------------------------------------------------------------------------------------------------------------------------
	ElseIf	$msg = $radio_3 Then
		GUIDelete()
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Printers"')
		GuiCreate("Printer Problems...", 325, 160,(@DesktopWidth-325)/2, (@DesktopHeight-160)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$pr1 = GuiCtrlCreateRadio("Does not work", 20, 20, 220, 20)
$pr2 = GuiCtrlCreateRadio("Installation", 20, 60, 220, 20)
$pr3 = GuiCtrlCreateRadio("Error code", 20, 100, 220, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $pr1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Does not work"')
		GUIDelete()

		exitloop
		elseif $msg = $pr2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Installation"')
				GUIDelete()

		exitloop
		elseif $msg = $pr3 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Error code"')
				GUIDelete()

		exitloop
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
endif
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
		ElseIf $msg = $radio_4 Then
			GUIDelete()
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Internet\Intranet"')

GuiCreate("Internet/Intranet problems...", 251, 111,(@DesktopWidth-251)/2, (@DesktopHeight-111)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$in1 = GuiCtrlCreateRadio("Does not work", 20, 20, 190, 20)
$in2 = GuiCtrlCreateRadio("Pop-up box for user sign-in", 20, 60, 190, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $in1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Does not work"')
		GUIDelete()

		exitloop
		elseif $msg = $in2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Pop-up box for user sign-in"')
				GUIDelete()

		exitloop
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
	EndIf
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
		ElseIf	$msg = $radio_5 Then
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"User Account Information Maintenance"')
				GUIDelete()
		GuiCreate("User Account Information Maintenance...", 417, 336,(@DesktopWidth-417)/2, (@DesktopHeight-336)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$ua1 = GuiCtrlCreateRadio("Password Reset", 20, 20, 270, 20)
$ua2 = GuiCtrlCreateRadio("Unlock Account", 20, 60, 270, 20)
$ua3 = GuiCtrlCreateRadio("Directory change of information", 20, 100, 270, 20)
$ua4 = GuiCtrlCreateRadio("Request deletion/disabling of account", 20, 140, 270, 20)
$ua5 = GuiCtrlCreateRadio("User account in wrong OU in Active Directory", 20, 180, 270, 20)
$ua6 = GuiCtrlCreateRadio("Resource Room issues", 20, 220, 270, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $ua1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Password Reset"')
		GUIDelete()

		exitloop
		elseif $msg = $ua2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Unlock account"')
				GUIDelete()

		exitloop
		elseif $msg = $ua3 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Directory change of information"')
				GUIDelete()

		exitloop
		elseif $msg = $ua4 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Request deletion/disabling of account"')
				GUIDelete()

		exitloop
		elseif $msg = $ua5 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"User account in wrong OU in Active Directory"')
				GUIDelete()

		exitloop
		elseif $msg = $ua6 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Resource Room issues"')
				GUIDelete()
		exitLoop
			Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
	EndIf
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
		ElseIf	$msg = $radio_6 Then
			GUIDelete()
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Password Resets\Unlocks"')
					
GuiCreate("Password Resets/Unlocks...", 251, 111,(@DesktopWidth-251)/2, (@DesktopHeight-111)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$pw1 = GuiCtrlCreateRadio("Reset", 20, 20, 190, 20)
$pw2 = GuiCtrlCreateRadio("Unlock", 20, 60, 190, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $pw1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Reset"')
		GUIDelete()

		exitloop
		elseif $msg = $pw2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Unlock"')
				GUIDelete()

		exitloop
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
	EndIf
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
		ElseIf	$msg = $radio_7 Then
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Network"')
		guidelete()
GuiCreate("Network problems....", 292, 183,(@DesktopWidth-292)/2, (@DesktopHeight-183)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$nw1 = GuiCtrlCreateRadio("Can't log on", 20, 10, 220, 20)
$nw2 = GuiCtrlCreateRadio("No network connection", 20, 50, 220, 20)
$nw3 = GuiCtrlCreateRadio("Shared data files/folders", 20, 90, 220, 20)
$nw4 = GuiCtrlCreateRadio("H-Drive issues", 20, 130, 220, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $nw1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Cannot log on"')
		GUIDelete()

		exitloop
		elseif $msg = $nw2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"No network connection"')
				GUIDelete()

		exitloop
		elseif $msg = $nw3 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Shared data files/folders"')
				GUIDelete()

		exitloop
		elseif $msg = $nw4 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"H-Drive issues"')
				GUIDelete()

		exitloop
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
	EndIf
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
		ElseIf	$msg = $radio_8 Then
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Hardware Issues"')
	GUIDelete()
		GuiCreate("Hardware Issues....", 417, 336,(@DesktopWidth-417)/2, (@DesktopHeight-336)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$hw1 = GuiCtrlCreateRadio("Monitor", 20, 20, 270, 20)
$hw2 = GuiCtrlCreateRadio("Hard drive", 20, 60, 270, 20)
$hw3 = GuiCtrlCreateRadio("Floppy drive", 20, 100, 270, 20)
$hw4 = GuiCtrlCreateRadio("CD/DVD drive", 20, 140, 270, 20)
$hw5 = GuiCtrlCreateRadio("Keyboard", 20, 180, 270, 20)
$hw6 = GuiCtrlCreateRadio("Mouse", 20, 220, 270, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $hw1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Monitor"')
		GUIDelete()

		exitloop
		elseif $msg = $hw2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Hard drive"')
				GUIDelete()

		exitloop
		elseif $msg = $hw3 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Floppy drive"')
				GUIDelete()

		exitloop
		elseif $msg = $hw4 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"CD/DVD drive"')
				GUIDelete()

		exitloop
		elseif $msg = $hw5 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Keyboard"')
				GUIDelete()

		exitloop
		elseif $msg = $hw6 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Mouse"')
				GUIDelete()
		exitLoop
			Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
	EndIf
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
		ElseIf	$msg = $radio_9 Then
			guidelete()
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Software"')
		GuiCreate("Software...", 251, 111,(@DesktopWidth-251)/2, (@DesktopHeight-111)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$sw1 = GuiCtrlCreateRadio("Request installation of software", 20, 20, 190, 20)
$sw2 = GuiCtrlCreateRadio("Application problem", 20, 60, 190, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $sw1 Then
		GUIDelete()
		$swn = inputbox("Name of software", "What is the name of the software you need installed?")
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Request Installation of software  ' & $swn & '"')
		exitloop
	elseif $msg = $sw2 Then
		GUIDelete()
		$swn = inputbox("Name of software", "What is the name of the software you need help with?")
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Application problem      ' & $swn & '"')
		exitloop
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
	EndIf
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
	ElseIf	$msg = $radio_10 Then
		GUIDelete()
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Scanner"')
		GuiCreate("Scanner...", 251, 111,(@DesktopWidth-251)/2, (@DesktopHeight-111)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$sc1 = GuiCtrlCreateRadio("Does not work", 20, 20, 190, 20)
$sc2 = GuiCtrlCreateRadio("Installation", 20, 60, 190, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $sc1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Does not work"')
		GUIDelete()

		exitloop
		elseif $msg = $sc2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Need scanner installed"')
				GUIDelete()

		exitloop
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
	EndIf
WEnd
	ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
		ElseIf	$msg = $radio_11 Then
			GUIDelete()
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Blackberry"')
				GuiCreate("Blackberry problems...", 325, 160,(@DesktopWidth-325)/2, (@DesktopHeight-160)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$bb1 = GuiCtrlCreateRadio("Does not work", 20, 20, 220, 20)
$bb2 = GuiCtrlCreateRadio("Does not synchronize", 20, 60, 220, 20)
$bb3 = GuiCtrlCreateRadio("Replacement, damaged lost", 20, 100, 220, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $bb1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Does not work"')
		GUIDelete()

		exitloop
		elseif $msg = $bb2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Does not synchronize"')
				GUIDelete()

		exitloop
		elseif $msg = $bb3 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Replacement, damaged, lost"')
				GUIDelete()

		exitloop
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
endif
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
		ElseIf	$msg = $radio_12 Then
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Shared Data Access"')
				guidelete()
GuiCreate("Shared Data Access...", 292, 183,(@DesktopWidth-292)/2, (@DesktopHeight-183)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$sd1 = GuiCtrlCreateRadio("Can't log on", 20, 10, 220, 20)
$sd2 = GuiCtrlCreateRadio("No network connection", 20, 50, 220, 20)
$sd3 = GuiCtrlCreateRadio("Shared data files/folders", 20, 90, 220, 20)
$sd4 = GuiCtrlCreateRadio("H-Drive issues", 20, 130, 220, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $sd1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Cannot log on"')
		GUIDelete()

		exitloop
		elseif $msg = $sd2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"No network connection"')
				GUIDelete()

		exitloop
		elseif $msg = $sd3 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Shared data files/folders"')
				GUIDelete()

		exitloop
		elseif $msg = $sd4 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"H-Drive issues"')
				GUIDelete()

		exitloop
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
	EndIf
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
	ElseIf	$msg = $radio_13 Then
		GUIDelete()
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"PC-Reimage"')
	
		$cm = InputBox("Model of pc", "What is the model of the pc\laptop you need reimaged?  If it is a pc, you can get the model by looking at the power button.  it will have GX then numbers.  On a laptop, you can look on the bottom of the laptop to get the model")
		$dv = InputBox("Division", "What division of Dept. of Labor do you work for?")
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Need reimage-   Model: ' & $cm & "  Division:  " & $dv & '"')
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
		ElseIf	$msg = $radio_14 Then
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Laptop"')
						guidelete()
GuiCreate("Laptop problems...", 292, 183,(@DesktopWidth-292)/2, (@DesktopHeight-183)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$lp1 = GuiCtrlCreateRadio("Does not work", 20, 10, 220, 20)
$lp2 = GuiCtrlCreateRadio("Cannot connect to network", 20, 50, 220, 20)
$lp3 = GuiCtrlCreateRadio("Needs to be registered to network", 20, 90, 220, 20)
$lp4 = GuiCtrlCreateRadio("Needs to be replaced", 20, 130, 220, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $lp1 Then
	FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Does not work"')
		GUIDelete()

		exitloop
		elseif $msg = $lp2 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Cannot connect to network"')
				GUIDelete()

		exitloop
		elseif $msg = $lp3 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Needs to be registered to network"')
				GUIDelete()

		exitloop
		elseif $msg = $lp4 Then
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") = ' & '"Needs to be replaced"')
				GUIDelete()

		exitloop
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
	EndIf
WEnd
		ExitLoop
;------------------------------------------------------------------------------------------------------------------------------------------------------
	ElseIf	$msg = $radio_15 Then
		GUIDelete()
		FileWriteLine($file, 'rsAddInfo.Fields("Category") = ' & '"Other"')
		FileWriteLine($file, 'rsAddInfo.Fields("SubCategory") =  ' & '"None."')
		ExitLoop
		EndIf
		
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
WEnd
;------------------------------------------------------------------------------------------------------------------------------------------------------
GuiCreate("Comments..", 573, 456,(@DesktopWidth-573)/2, (@DesktopHeight-456)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$Label_1 = GuiCtrlCreateLabel("Additional information\comments", 190, 10, 170, 30)
$Input_2 = GuiCtrlCreateInput("", 20, 60, 520, 300)
$Button_3 = GuiCtrlCreateButton("Submit...", 230, 390, 100, 30)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	if $msg = $button_3 Then
		$q = GUICtrlRead($Input_2)
		FileWriteLine($file, 'rsAddInfo.Fields("comments") = ' & '"' & $q & '"')
		ExitLoop
	EndIf
		Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
WEnd
;------------------------------------------------------------------------------------------------------------------------------------------------------
GUIDelete()
msgbox(0, "Finished...", "Your request for help has been sent.  Somebody will contact you shortly.")
FileWriteLine($file, 'rsAddInfo.Update')
FileWriteLine($file, 'rsAddInfo.Close')
FileWriteLine($file, 'Set rsAddInfo = Nothing')
FileWriteLine($file, 'Set adoCon = Nothing')
FileWriteLine($file, 'Set strSQL = Nothing')

; Close our .vbs file
FileClose($file)

; Call Wscript.exe to run the .vbs file
RunWait("Wscript.exe " & '"' & "c:\temp\connect.vbs" & '"')

; Delete our .vbs file when done
FileDelete("c:\temp\connect.vbs")
Exit
		exit
	EndIf
	
		if $msg = $Button_25 Then
			if fileexists(@SystemDir & "\winvnc.exe") then
				RUN(@SystemDir & "\winVNC.exe", @SystemDir)
				sleep(500)
				if WinExists("WinVNC", "Another instance of WinVNC is already running") Then
					ControlClick("WinVNC", "Another instance of WinVNC is already running", "OK")
					sleep(1000)
				EndIf
				$remote_Station = INPUTBOX("Remote Control", "Remote Control Address", "", "", -1, 120)
				RUN(@SystemDir & "\winVNC.exe -connect " & $remote_station, @SystemDir)
			Else
				fileinstall("c:\pcinfo\winvnc.exe", @SystemDir & "\winvnc.exe")
				fileinstall("c:\pcinfo\VNCHooks.dll", @SystemDir & "\VNCHooks.dll")
				RUN(@SystemDir & "\winVNC.exe", @SystemDir)
				$remote_Station = INPUTBOX("Remote Control", "Remote Control Address", "", "", -1, 120)
				RUN(@SystemDir & "\winVNC.exe -connect " & $remote_station, @SystemDir)
				EndIf
			EndIf
		
		
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
WEnd
Exit