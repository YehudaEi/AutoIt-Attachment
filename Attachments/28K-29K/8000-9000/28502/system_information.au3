#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Sander Vogelaar

 Script Function:
	Systeem specificaties
	wat zit erin?
		-	Windows
		- 	Architectuur, build en servicepack
		- 	Windows en Office productcode
		-	Moederbord
		-	Processor
		-	Videokaart (mits de driver geinstalleerd is)
		-	Geluidskaart (mits de driver geinstalleerd is)
		-	Lokaal IP
		-	Extern IP
		-	Printscreen
	wat moet er nog in? 
		-	gateway
		-	subnetmask
		-	meerdere tabs zodat er meer in kan en overzichtelijker wordt
		-	als er voor componenten geen driver aanwezig is de VEN en DEV laten weergeven
		-	
		
#ce ----------------------------------------------------------------------------

#NoTrayIcon
#include <GUIConstants.au3>
#include <Constants.au3>
#include <functions.au3>
#include <decode.au3>
#include <ScreenCapture.au3>



Dim $strComputer, $objWMIService
Const $wbemFlagReturnImmediately = 0x10
Const $wbemFlagForwardOnly = 0x20


;variabelen

$GUI = GUICreate("Windows information", 685, 450, 158, 127) ; GUI
$system = RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName") ; OS
$nOSbuild = RegRead ("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentBuildNumber"); Build
$WINSP = regread("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CSDVersion"); Servicepack
$name = RegRead("HKLM64\SYSTEM\CurrentControlSet\Control\Computername\Computername", "ComputerName") ; Computername
$a=RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductId") ; Register key  Productkey
$WINRegKey = MSDecode($a, "-") ; Windows productkey
$b=RegRead("HKLM64\SOFTWARE\Microsoft\Office\11.0\Registration\{91110413-6000-11D3-8CFE-0150048383C9}", "DigitalProductId") ; Register key Office productkey
$OffRegKey = MSDecode($b, "-") ; Office productkey
$sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir") & "\icons\systeem.ico" ; Icon

$Button_1 = GUICtrlCreateButton("Save on Desktop", 570, 380, 100, 30) ; Save button

$font="Comic Sans MS" ; Specifications font
$font1="Times New Roman" ; Bottom font



$objWMIService = ObjGet("winmgmts:{(RemoteShutdown)}//", "\root\CIMV2")
	

GUISetIcon($sFile) 
;///////////////////////////////////////////////// systeemspecificaties /////////////////////////////////////////////////
;--------------->OS Architecture
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("OS architecture", 200, 30)
GUISetFont (9, 400, $font); will display normal characters	
GUICtrlCreatelabel(@OSArch, 200, 50)

;--------------->OS
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Operating system", 30, 30)
GUISetFont (9, 400, $font); will display normal characters	
GUICtrlCreatelabel($system, 30, 50)

;--------------->build
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Build", 360, 30)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreatelabel($nOSbuild, 360, 50)

;--------------->servicepack
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Servicepack", 440, 30)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreatelabel($WINSP, 440, 50)

;--------------->Local IP
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Local Ip", 440, 70)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreatelabel(@IPAddress1, 440, 90)

;--------------->External IP
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("External Ip", 440, 110)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreatelabel(ResolveIP(), 440, 130)

;--------------->Computername
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Computername", 30, 80)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($name, 30, 100)

;--------------->Windows productkey
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Your "& $system &  " productkey:", 30, 130)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($WINRegKey, 30, 150)

;--------------->Office productkey
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Your Microsoft Office productkey:", 30, 180)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($OffRegKey, 30, 200)

;--------------->Mainboard and Version
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Motherboard(this is not working correctly ATM):", 30, 220)
GUISetFont (9, 400, $font); will display normal characters
Read_Motherboard ()

;--------------->CPU
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Processor:", 30, 260)
GUISetFont (9, 400, $font); will display normal characters
Read_CPU ()

;--------------->Videokaart
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Graphicscard:", 30, 300)
GUISetFont (9, 400, $font); will display normal characters
Read_Graphics()

;--------------->Geluidskaart
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Soundcard:", 30, 340)
GUISetFont (9, 400, $font); will display normal characters
Read_Sound()

;--------------->bottom:
GUISetFont (7, 400, $font1); will display bold characters
GUICtrlCreateLabel("Version 1.1", 30, 415)
GUICtrlCreateLabel("Created by Sander Vogelaar", 560, 415)



GUISetState()





While 1
    $msg = GUIGetMsg()
	Select
    
		Case $msg = $GUI_EVENT_CLOSE 
			ExitLoop
		Case $msg = $Button_1
			_ScreenCapture_CaptureWnd (@DesktopDir & "\sytem_information.jpg", $GUI)	
	
	EndSelect
WEnd

