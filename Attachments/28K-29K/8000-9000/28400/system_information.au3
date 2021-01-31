#AutoIt3Wrapper_UseX64
#include <GUIConstants.au3>
#include <Constants.au3>
#include <hardware.au3>
#include <decode.au3>


Dim $strComputer, $objWMIService



;variabelen
$GUI = GUICreate("Windows information", 685, 450, 158, 127)
$system = RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName") ; Besturingssysteem
$nOSbuild = RegRead ("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentBuildNumber"); Build
$WINSP = regread("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CSDVersion"); Servicepack
$name = RegRead("HKLM64\SYSTEM\CurrentControlSet\Control\Computername\Computername", "ComputerName") ; Computernaam
$a=RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductId") ; register sleutel Windows productcode 
$WINRegKey = MSDecode($a, "-") ; Windows productcode
$b=RegRead("HKLM64\SOFTWARE\Microsoft\Office\11.0\Registration\{91110413-6000-11D3-8CFE-0150048383C9}", "DigitalProductId") ; register sleutel Office productcode
$OffRegKey = MSDecode($b, "-") ; office productcode
$Motherboard = _Read_Motherboard ()
$CPU = _Read_CPU ()
$graphics = _Read_Graphics()
$font="Comic Sans MS"
$button1 = GUICtrlCreateButton("print", 540, 380, 80, 30)
Opt("GUIOnEventMode", 1)



$objWMIService = ObjGet("winmgmts:{(RemoteShutdown)}//", "\root\CIMV2")



;///////////////////////////////////////////////// systeemspecificaties /////////////////////////////////////////////////
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Operating system", 30, 30)
GUISetFont (9, 400, $font); will display normal characters	
GUICtrlCreatelabel($system, 30, 50)
;build
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Build", 320, 30)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreatelabel($nOSbuild, 320, 50)
;servicepack
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Servicepack", 420, 30)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreatelabel($WINSP, 420, 50)
;computernaam
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Computername", 30, 80)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($name, 30, 100)
;Windows productkey
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Your "& $system &  " productkey:", 30, 130)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($WINRegKey, 30, 150)
;Office productkey
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Your Microsoft Office productkey:", 30, 180)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($OffRegKey, 30, 200)
;Moederbord
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Motherboard(this is not working correctly ATM):", 30, 220)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($Motherboard, 1000, 1000)
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Processor:", 30, 260)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($CPU, 1000, 1000)
;Videokaart
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Graphicscard:", 30, 300)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($Graphics, 1000, 1000)
;Geluidskaart
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Soundcard:", 30, 340)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel($Sound, 30, 360)


GUICtrlSetOnEvent($Button1, "OKPressed")
GUICtrlCreateLabel("Created by Sander Vogelaar", 500, 430)



GUISetState()


Func OKPressed()
Run("notepad.exe")
sleep(2000)
send("Your Oparating system is:{TAB}{TAB}" & "Build{TAB}{TAB}" & "Servicepack{ENTER}")
send($system & "{TAB}{TAB}{TAB}" & $nOSbuild & "{TAB}{TAB}" & $WINSP & "{ENTER}{ENTER}")
send("Computername{ENTER}" & $name & "{ENTER}{ENTER}")
send($system & " productkey{ENTER}" & $WINRegKey & "{ENTER}{ENTER}")
send("Your Microsoft Office productkey:{ENTER}" & $OffRegKey & "{ENTER}{ENTER}")
send("Motherboard(this is not working correctly ATM):{ENTER}" & $Motherboard & "{ENTER}{ENTER}")
send("CPU:{ENTER}" & $CPU() & "{ENTER}{ENTER}")
send("Graphics:{ENTER}" & $Graphics() & "{ENTER}{ENTER}")
send("Sound:{ENTER}" & $Sound() & "{ENTER}{ENTER}")
EndFunc





While 1
    $msg = GUIGetMsg()
    
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd
	
	

