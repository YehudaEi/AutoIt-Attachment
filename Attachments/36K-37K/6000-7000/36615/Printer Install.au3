#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

$print = IniReadSection(".\ifile\printerlist.ini","PRINTERS")
$port = IniReadSection(".\ifile\portlist.ini","PORTS")
$queue = IniReadSection(".\ifile\queuelist.ini","QUEUE")
$queuemini = IniReadSection(".\ifile\queuelist2.ini","QUEUE")

globaL $PrintGUI = GUICreate("Printer Installation Assistant", 530, 349, 192, 114)
GUISetBkColor(0xA6CAF0)
$EnterPC = GUICtrlCreateInput("", 160, 45, 225, 21)
$PCNum = GUICtrlCreateLabel("Enter PC number:", 18, 49, 107, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$PrintCombo = GUICtrlCreateCombo("", 160, 77, 225, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
For $iX = 1 To $print[0][0]
GUICtrlSetData(-1, $print[$iX][0],"")
Next
$PortCombo = GUICtrlCreateCombo("", 160, 110, 225, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
For $iY = 1 To $port[0][0]
GUICtrlSetData(-1, $port[$iY][0],"")
Next
$QueueCombo = GUICtrlCreateCombo("", 160, 141, 225, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
For $iZ = 1 To $queue[0][0]
GUICtrlSetData(-1, $queue[$iZ][0],"")
Next
$PrintLabel = GUICtrlCreateLabel("Choose printer:", 18, 77, 94, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$PortLabel = GUICtrlCreateLabel("Choose Port", 18, 111, 78, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$QueueLabel = GUICtrlCreateLabel("Choose Queue Name",17, 143, 134, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$AddButton = GUICtrlCreateButton("Add New Printer",14, 270, 116, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$SerialButton = GUICtrlCreateButton("Reinstall Serial2USB Drivers",13, 188, 188, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$InstallButton = GUICtrlCreateButton("INSTALL", 400, 39, 116, 62, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xC0DCC0)
$SerialUpdateButton = GUICtrlCreateButton("Update Serial2USB Driver Location", 14, 230, 188, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
$CancelButton = GUICtrlCreateButton("CANCEL", 400, 103, 116, 62, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xFF0000)
$Title = GUICtrlCreateLabel("INSTALL A PRINTER", 160, 8, 200, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$Spooler = GUICtrlCreateButton("Stop Start Spooler", 234, 308, 124, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$SetIP = GUICtrlCreateButton("Set Port to IP", 234, 189, 124, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$DeleteButton = GUICtrlCreateButton("Delete Printer", 14, 309, 116, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Instruct3 = GUICtrlCreateButton("Instructions", 8, 7, 92, 22, BitOR($BS_NOTIFY,$BS_FLAT))
$deftick = GUICtrlCreateCheckbox("Set this Printer as Default", 160, 166, 145, 17)
$TESTPAGE = GUICtrlCreateButton("Print Test Page", 234, 269, 124, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$defprint = GUICtrlCreateButton("Set Default Printer", 234, 228, 124, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Microsoft Sans Serif")
$pause = GUICtrlCreateButton("Pause Printing", 390, 188, 124, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

GUISetState(@SW_SHOW)
;~ 							BEGINNING	*****************
While 1
	$PC=GUICtrlRead($EnterPC)
	$PNAME=GUICtrlRead($QueueCombo)
	$MODEL=GUICtrlRead($PrintCombo)
	$PORT2=GUICtrlRead($PortCombo)


	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			FileDelete("c:\cred3.ini")
			Exit
		case $CancelButton
			FileDelete("c:\cred3.ini")
			Exit
		Case $Spooler
			if $PC = "" then
				MsgBox(0,"C'arn mate","Why are there empty fields, bro?")
			Else
				RunWait(@ComSpec & " /c " & "sc \\"&$PC&" stop spooler")
				sleep(3000)
				RunWait(@ComSpec & " /c " & "sc \\"&$PC&" start spooler")
				MsgBox(0,"Spooler restart","The spooler has been stopped and started")
			EndIf
		Case $SetIP
			GUISetState(@SW_DISABLE,$PrintGUI)
			setip ()
			GUISetState(@SW_ENABLE,$PrintGUI)
			WinActivate("Printer Installation Assistant")
		case $InstallButton
			if $PC = "" or $PNAME = "" or $MODEL = "" or $PORT2 = "" then
				MsgBox(0,"C'arn mate","Why are there empty fields, bro?")
			Else
				install ()
			EndIf
		Case $AddButton
			GUISetState(@SW_DISABLE,$PrintGUI)
			printadd ()
			GUISetState(@SW_ENABLE,$PrintGUI)
			WinActivate("Printer Installation Assistant")
		case $DeleteButton
			GUISetState(@SW_DISABLE,$PrintGUI)
			printdel ()
			GUISetState(@SW_ENABLE,$PrintGUI)
			WinActivate("Printer Installation Assistant")
		case $Instruct3
			shellexecute("./Instructions/Main Instructions.doc","","","",@SW_SHOW)
		case $defprint
			if $PC = "" or $PNAME = "" then
				MsgBox(0,"Waddaya want?","Enter a PC number and choose a Queue Name first, guvna!")
			Else
				RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /c\\"&$PC&" /y /n "&$PNAME&"")
			EndIf
		Case $TESTPAGE
			if $PC = "" or $PNAME = "" then
				MsgBox(0,"Waddaya want?","Enter a PC number and choose a Queue Name first, guvna!")
			Else
				RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /c\\"&$PC&" /k /n "&$PNAME&"")
			endif
		case $SerialButton
			if $PC = "" then
				MsgBox(0,"Waddaya want?","Enter a PC number first, guvna!")
			Else
				FileCopy("\\benfile\pccommon\__Helpdesk\PRINTER AIO\Serial2USB\serial.exe", "\\"&$PC&"\c$",9)
				FileCopy("\\benfile\pccommon\__Helpdesk\PRINTER AIO\Serial2USB\location.ini", "\\"&$PC&"\c$",9)
				FileCopy("c:\cred3.ini", "\\"&$PC&"\c$",9)
				FileCopy("\\benfile\pccommon\__Helpdesk\PRINTER AIO\Serial2USB\end.bat", "\\"&$PC&"\c$",9)
				FileCopy("\\benfile\pccommon\__Helpdesk\PRINTER AIO\Serial2USB\devcon.exe", "\\"&$PC&"\c$",9)
				run("\\"&$PC&"\c$\serial.exe","",@SW_HIDE)
			EndIf
	EndSwitch
WEnd
;~ 					INSTALL BUTTON	*****************
func install ()
	$PC=GUICtrlRead($EnterPC)
	$PNAME=GUICtrlRead($QueueCombo)
	$MODEL=GUICtrlRead($PrintCombo)
	$PORT2=GUICtrlRead($PortCombo)
	$deftick2=guictrlread($deftick)
	$DRIVER = IniRead(".\ifile\driverlist.ini","DRIVERS",$MODEL,"This driver does not live here yet.")

	ping($PC)
		if @error Then
			MsgBox(0,"Nobodies home","The PC number you entered is not online. Take a breath and try again.")
			Exit
		EndIf

	Select
		case $PORT2 = ("IP Address...")
			call("ipaddress")
		case Else
			RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /c\\"&$PC&" /dl /n """&$PNAME&"""")
			RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /c\\"&$PC&" /b """&$PNAME&""" /if /f """&$DRIVER&""" /m """&$MODEL&""" /r "&$PORT2&"")
			if $deftick2 = $GUI_CHECKED Then
				RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /c\\"&$PC&" /y /n "&$PNAME&"")
			EndIf
			RunWait(@ComSpec & " /c " & "sc \\"&$PC&" stop spooler")
			sleep(3000)
			RunWait(@ComSpec & " /c " & "sc \\"&$PC&" start spooler")
	EndSelect
EndFunc
;~ 							FULL INSTALL WITH IP	*****************
func ipaddress ()
	Global $PC=GUICtrlRead($EnterPC)
	$PNAME=GUICtrlRead($QueueCombo)
	$MODEL=GUICtrlRead($PrintCombo)
	$DRIVER = IniRead(".\ifile\driverlist.ini","DRIVERS",$MODEL,"This driver does not live here yet.")
	GUIDelete($PrintGUI)
		$IPADDRESS = GUICreate("IP Address", 253, 109, 192, 114)
		GUISetBkColor(0xA6CAF0)
		$NEED = GUICtrlCreateLabel("Insert the IP Address you need:", 16, 8, 218, 22)
		GUICtrlSetFont(-1, 12, 400, 0, "Arial")
		$IP1 = GUICtrlCreateInput("", 47, 36, 145, 21)
		$OK = GUICtrlCreateButton("OK", 72, 64, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
		GUISetState(@SW_SHOW)
		while 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					ExitLoop
				case $OK
					$p1 = GUICtrlRead($IP1)
					$PORT3=IniWrite("c:\ipaddress.ini","ADDRESS","IP",$p1)
					$PORT4=IniRead("c:\ipaddress.ini","ADDRESS","IP","Nothing is here")
					GUIDelete($IPADDRESS)
						RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /c\\"&$PC&" /dl /n """&$PNAME&"""")
						RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /c\\"&$PC&" /b """&$PNAME&""" /if /f """&$DRIVER&""" /m """&$MODEL&""" /r LPT1:")
						RunWait(@ComSpec & " /c " & "prnport -a -r IP_"&$PORT4&" -s \\"&$PC&" -h "&$PORT4&" -q "&$PNAME&" -o raw -n 9100")
						RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /c\"&$PC&" /Xs /n """&$PNAME&""" PortName ""IP_"&$PORT4&"""")
						RunWait(@ComSpec & " /c " & "sc \\"&$PC&" stop spooler")
						sleep(3000)
						RunWait(@ComSpec & " /c " & "sc \\"&$PC&" start spooler")
						FileDelete("c:\ipaddress.ini")
				ExitLoop
			EndSwitch
		WEnd
EndFunc
;~ 							IP ONLY	*****************
func setip ()
		GLOBAL $IPADDRESS2 = GUICreate("Set port", 358, 191, 192, 114)
		GUISetBkColor(0xA6CAF0)
		$Enter = GUICtrlCreateLabel("Enter IP Address ", 8, 74, 126, 22)
		GUICtrlSetFont(-1, 12, 400, 0, "Arial")
		$IP2 = GUICtrlCreateInput("", 199, 75, 145, 21)
		$OK2 = GUICtrlCreateButton("OK", 216, 148, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
		$PC2 = GUICtrlCreateInput("", 199, 14, 145, 21)
		$PCLABEL = GUICtrlCreateLabel("Enter PC number", 8, 15, 124, 22)
		GUICtrlSetFont(-1, 12, 400, 0, "Arial")
		$QUEUE2 = GUICtrlCreateCombo("", 199, 45, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
		For $iW = 1 To $queuemini[0][0]
			GUICtrlSetData(-1, $queuemini[$iW][0],"")
		Next
		$QUEUELABEL = GUICtrlCreateLabel("Choose a Queue Name", 7, 45, 168, 22)
		GUICtrlSetFont(-1, 12, 400, 0, "Arial")
		$CANCELIT = GUICtrlCreateButton("Cancel", 96, 148, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetBkColor(-1, 0xFF0000)
		$portchoose = GUICtrlCreateLabel("Choose a Port", 8, 118, 105, 24)
		GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
		$or = GUICtrlCreateLabel("OR", 46, 96, 28, 24)
		GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
		$portqueue = GUICtrlCreateCombo("", 199, 116, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
		For $iV = 1 To $port[0][0]
			GUICtrlSetData(-1, $port[$iV][0])
		Next

		GUISetState(@SW_SHOW)

		while 1
			$PC3=GUICtrlRead($PC2)
			$PNAME2=GUICtrlRead($QUEUE2)
			$p2 = GUICtrlRead($IP2)
			$nMsg = GUIGetMsg()
			$PORT7 = ($portqueue)
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					ExitLoop
				Case $CANCELIT
					ExitLoop
				case $OK2
					$nMsg = GUIGetMsg()
					Select
						case $PNAME2 = ("Choose my own queue...")
							call("ownqueue")
						Case $PC3 = "" or $PNAME2 = ""
							MsgBox(0,"C'arn mate","Why are there empty fields, bro?")
							setip ()
						case $p2 = "" and $PORT7 = ""
							MsgBox(0,"C'arn mate","Why are there empty fields, bro?")
							setip ()
						case $p2 <> "" and $PORT7 <> ""
							MsgBox(0,"C'arn mate","You can't have both!")
							setip ()
						case $p2 = ""
							RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /c\\"&$PC3&" /Xs /n """&$PNAME2&""" PortName """&$PORT7&"""")
							RunWait(@ComSpec & " /c " & "sc \\"&$PC3&" stop spooler")
							sleep(3000)
							RunWait(@ComSpec & " /c " & "sc \\"&$PC3&" start spooler")
						case $PORT7 = ""
							$PORT5=IniWrite("c:\ipaddress.ini","ADDRESS","IP",$p2)
							$PORT6=IniRead("c:\ipaddress.ini","ADDRESS","IP","Nothing is here")
							RunWait(@ComSpec & " /c " & "prnport -a -r IP_"&$PORT6&" -s \\"&$PC3&" -h "&$PORT6&" -q "&$PNAME2&" -o raw -n 9100")
							RunWait(@ComSpec & " /c " & "RUNDLL32 PRINTUI.DLL,PrintUIEntry /Xs /n """&$PNAME2&""" PortName ""IP_"&$PORT6&"""")
							RunWait(@ComSpec & " /c " & "sc \\"&$PC3&" stop spooler")
							sleep(3000)
							RunWait(@ComSpec & " /c " & "sc \\"&$PC3&" start spooler")
							FileDelete("c:\ipaddress.ini")
					EndSelect
					ExitLoop
			EndSwitch
		WEnd
EndFunc
;~ 					SET OWN QUEUE 	***************************
func ownqueue ()
	$CHOOSEPORT = GUICreate("Choose your port", 236, 102, 192, 114)
	$NAME = GUICtrlCreateLabel("What is the name of your port", 11, 8, 212, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$PORTNAME = GUICtrlCreateInput("", 32, 32, 177, 21)
	$OK3 = GUICtrlCreateButton("OK", 120, 64, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
	$CANCELIT4 = GUICtrlCreateButton("Cancel", 7, 64, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xFF0000)
	GUISetState(@SW_SHOW)
	while 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $CANCELIT4
				ExitLoop
		EndSwitch
	WEnd
EndFunc
;~ 							ADD A PRINTER 	*****************
func printadd ()
	GLOBAL $addprinter = GUICreate("Add a printer to the list", 319, 148, 190, 112)
		GUISetBkColor(0xA6CAF0)
	$addlist = GUICtrlCreateLabel("ADD A PRINTER TO THE LIST", 40, 8, 232, 23)
		GUICtrlSetFont(-1, 12, 800, 0, "Arial")
	$make = GUICtrlCreateInput("", 122, 37, 185, 21)
	$location = GUICtrlCreateInput("", 122, 72, 185, 21)
	$makelabel = GUICtrlCreateLabel("Printer Make\Model", 8, 40, 98, 17)
	$locationlabel = GUICtrlCreateLabel("Driver Location", 28, 76, 76, 17)
	$addbutton2 = GUICtrlCreateButton("ADD", 208, 104, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
		GUICtrlSetFont(-1, 11, 800, 0, "Arial")
		GUICtrlSetColor(-1, 0x00FF00)
		GUICtrlSetBkColor(-1, 0x008000)
	$CANCELIT2 = GUICtrlCreateButton("CANCEL", 100, 104, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
		GUICtrlSetFont(-1, 11, 800, 0, "Arial")
		GUICtrlSetColor(-1, 0x000000)
		GUICtrlSetBkColor(-1, 0xFF0000)
	$instruct = GUICtrlCreateButton("Instructions", 22, 104, 68, 22, BitOR($BS_NOTIFY,$BS_FLAT))
	GUISetState(@SW_SHOW)
	while 1
		$MAKE1=GUICtrlRead($make)
		$LOCATE=GUICtrlRead($location)
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $CANCELIT2
				ExitLoop
			case $addbutton2
				IniWrite("./ifile/printerlist.ini","PRINTERS",$MAKE1,"")
				IniWrite("./ifile/driverlist.ini","DRIVERS",$MAKE1,$LOCATE)
				ExitLoop
			case $instruct
				shellexecute("./Instructions/Add Instructions.doc","","","",@SW_SHOW)
		EndSwitch
	WEnd
EndFunc
;~ 							DELETE A PRINTER 	*****************
Func printdel ()
	GLOBAL $DELPRINTER = GUICreate("Remove a printer from the list", 319, 120, 190, 112)
		GUISetBkColor(0xA6CAF0)
	$removelabel = GUICtrlCreateLabel("REMOVE A PRINTER FROM THE LIST", 9, 8, 292, 23)
		GUICtrlSetFont(-1, 12, 800, 0, "Arial")
	$makelabel2 = GUICtrlCreateLabel("Printer Make\Model", 8, 40, 98, 17)
	$DELETE = GUICtrlCreateButton("DELETE", 208, 75, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
		GUICtrlSetFont(-1, 11, 800, 0, "Arial")
		GUICtrlSetColor(-1, 0x00FF00)
		GUICtrlSetBkColor(-1, 0x008000)
	$INSTRUCT2 = GUICtrlCreateButton("Instructions", 22, 75, 68, 22, BitOR($BS_NOTIFY,$BS_FLAT))
	$CANCELIT3 = GUICtrlCreateButton("CANCEL", 100, 75, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
		GUICtrlSetFont(-1, 11, 800, 0, "Arial")
		GUICtrlSetColor(-1, 0x000000)
		GUICtrlSetBkColor(-1, 0xFF0000)
	$MAKELIST = GUICtrlCreateCombo("", 128, 37, 161, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	For $iU = 1 To $print[0][0]
		GUICtrlSetData(-1, $print[$iU][0],"")
	Next
		GUISetState(@SW_SHOW)
	while 1
		guiswitch($DELPRINTER)
		$REMOVE=GUICtrlRead($MAKELIST)
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $CANCELIT3
				ExitLoop
			CASE $DELETE
				IniDelete("./ifile/printerlist.ini","PRINTERS",$REMOVE)
				IniDelete("./ifile/driverlist.ini","DRIVERS",$REMOVE)
				ExitLoop
			case $instruct2
				shellexecute("./Instructions/Delete Instructions.doc","","","",@SW_SHOW)
		EndSwitch
	WEnd
EndFunc


