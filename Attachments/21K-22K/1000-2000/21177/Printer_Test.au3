#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\My Pictures\Printer.ico
#AutoIt3Wrapper_outfile=Add Office Printer.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>

#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=c:\software\kodaformdesign\forms\printer add.kxf
$Form1_1 = GUICreate("Add Printer", 467, 447, 193, 125)
$Label1 = GUICtrlCreateLabel("Office Printer", 88, 16, 278, 41)
GUICtrlSetFont(-1, 24, 800, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Fill in the name, IP, and select the model of the printer.  Then choose add.", 16, 72, 428, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$PrinterName = GUICtrlCreateInput("PrinterName", 112, 152, 177, 21)
$Label3 = GUICtrlCreateLabel("Printer Name", 144, 112, 126, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$Label4 = GUICtrlCreateLabel("IP Address", 152, 192, 105, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$IPAddress = GUICtrlCreateInput("IPAddress", 112, 232, 177, 21)
$Label5 = GUICtrlCreateLabel("Printer Model", 136, 264, 129, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$Model = GUICtrlCreateCombo("Model", 112, 304, 185, 25)
GUICtrlSetData(-1, "HP LaserJet 4250 PCL 6|HP LaserJet 4350 PCL 6|HP LaserJet 4345 MFP PCL 6|HP LaserJet P3005 PCL 6|HP LaserJet 2420 PCL 6|HP Laserjet 1100|HP LaserJet 1200 Series PCL 5e|HP LaserJet 1320 PCL 6|HP Color LaserJet 3600|HP Color LaserJet 2600n|LANIER LD135 PCL 6|Lanier LD245 PCL 6|LANIER MP 2510/LD325 PCL 6|LANIER MP 3500/LD335 PCL 6|Lanier LD335c PCL 6", "Model")
$Add = GUICtrlCreateButton("Add", 120, 368, 177, 41, 0)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFF0000)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$PrinterDriver = ""
$4250Driver = "\\Server\drivers\Printers\HP Laserjet 4250\hpc4x50c.inf"
$4350Driver = "\\server\drivers\Printers\HP Laserjet 4350\hpc4x50c.inf"
$4345MFPDriver = "\\server\drivers\Printers\HP Laserjet 4345 MFP\hpc4345c.inf"
$P3005Driver = "\\server\drivers\Printers\HP Laserjet P3005\hpc300xc.inf"
$2420Driver = "\\server\drivers\Printers\HP Laserjet 2420\hpc24x0c.inf"
$1100ADriver = "\\server\drivers\Printers\HP Laserjet 1100A\hp201ip5.inf"
$1200Driver = "\\server\drivers\Printers\HP Laserjet 1200\hpbf311i.inf"
$1320Driver = "\\server\drivers\Printers\HP Laserjet 1320\hpc1320c.inf"
$3600Driver = "\\server\drivers\Printers\HP color LaserJet 3600\hpc3600e.inf"
$2600Driver = "\\server\drivers\Printers\HP Color LaserJet 2600n\CLJ2600.INF"
$LD135Driver = "\\server\drivers\Printers\Lanier LD135\OEMSETUP.INF"
$LD245Driver = "\\server\drivers\Printers\Lanier LD245\OEMSETUP.INF"
$LD325Driver = "\\server\drivers\Printers\Lanier LD325\OEMSETUP.INF"
$LD335Driver = "\\server\drivers\Printers\Lanier LD335\OEMSETUP.INF"
$LD335CDriver = "\\server\drivers\Printers\Lanier LD335C\OEMSETUP.INF"

 If StringInStr($Model, "HP Laserjet 4250 PCL 6") Then
                    $PrinterDriver = $4250Driver
					ElseIf StringInStr($Model, "HP Laserjet 4350 PCL6") Then
                    $PrinterDriver = $4350Driver
					ElseIf StringInStr($Model, "HP Laserjet 4345 MFP PCL 6") Then
                    $PrinterDriver = $4350Driver
					ElseIf StringInStr($Model, "HP Laserjet P3005 PCL 6") Then
                    $PrinterDriver = $P3005Driver
					ElseIf StringInStr($Model, "HP Laserjet 2420 PCL 6") Then
                    $PrinterDriver = $2420Driver
					ElseIf StringInStr($Model, "HP Laserjet 1100") Then
                    $PrinterDriver = $1100ADriver
					ElseIf StringInStr($Model, "HP Laserjet 1200 Series PCL 5e") Then
                    $PrinterDriver = $1200Driver
					ElseIf StringInStr($Model, "HP Laserjet 1320 PCL 6") Then
                    $PrinterDriver = $1320Driver
					ElseIf StringInStr($Model, "HP Color Laserjet 3600") Then
                    $PrinterDriver = $3600Driver
					ElseIf StringInStr($Model, "HP Color Laserjet 2600n") Then
                    $PrinterDriver = $2600Driver
					ElseIf StringInStr($Model, "LANIER LD135 PCL 6") Then
                    $PrinterDriver = $LD135Driver
					ElseIf StringInStr($Model, "Lanier LD245 PCL 6") Then
                    $PrinterDriver = $LD245Driver
					ElseIf StringInStr($Model, "LANIER MP 2510/LD325 PCL 6") Then
                    $PrinterDriver = $LD325Driver
					ElseIf StringInStr($Model, "LANIER MP 3500/LD335 PCL 6") Then
                    $PrinterDriver = $LD335Driver
					ElseIf StringInStr($Model, "LANIER LD335c PCL 6") Then
                    $PrinterDriver = $LD335CDriver
                EndIf

While 1
	$nMsg = GUIGetMsg()
Select
	Case $nMsg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $nMsg = $Add
		;;Stop Print Spooler Service
		RunWait('cmd /c net stop "print spooler"')
		;;Adding specified printer
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Monitors\Standard TCP/IP Port\Ports\IP_" & $IPAddress, "Protocol", "REG_DWORD", "00000001")
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Monitors\Standard TCP/IP Port\Ports\IP_" & $IPAddress, "Version", "REG_DWORD", "00000001")
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Monitors\Standard TCP/IP Port\Ports\IP_" & $IPAddress, "HostName", "REG_SZ", "")
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Monitors\Standard TCP/IP Port\Ports\IP_" & $IPAddress, "HWAddress", "REG_SZ", "")
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Monitors\Standard TCP/IP Port\Ports\IP_" & $IPAddress, "IPAddress", "REG_SZ", $IPAddress)
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Monitors\Standard TCP/IP Port\Ports\IP_" & $IPAddress, "PortNumber", "REG_DWORD", "00009100")
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Monitors\Standard TCP/IP Port\Ports\IP_" & $IPAddress, "SNMP Community", "REG_SZ", "public")
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Monitors\Standard TCP/IP Port\Ports\IP_" & $IPAddress, "SNMP Enabled", "REG_DWORD", "00000001")
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Monitors\Standard TCP/IP Port\Ports\IP_" & $IPAddress, "SNMP Index", "REG_DWORD", "00000001")
		;; Start the Print Spooler Service
		RunWait('cmd /c net start "print spooler"')
		;; Install the printer
		RunWait(@ComSpec & " /c " & 'rundll32 printui.dll PrintUIEntry /b "' & $PrinterName & '" /if /f "' & $PrinterDriver & '" /r "' & "IP_" & $IPAddress & '" /m "' & $Model & '"', "",@SW_HIDE)
	MsgBox (48, "Printer Setup Complete", "" & $PrinterName & "was successfully added to your machine")	
	Exit
	EndSelect
WEnd
