
#include <GUIConstants.au3>
#include <Constants.au3>
#include <hardware.au3>
#include <decode.au3>

Dim $strComputer, $objWMIService
Const $wbemFlagReturnImmediately = 0x10
Const $wbemFlagForwardOnly = 0x20

;variabelen
$GUI = GUICreate("Windows information", 685, 450, 158, 127)
$a=RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductId") ; register sleutel Windows productcode 
$b=RegRead("HKLM64\SOFTWARE\Microsoft\Office\11.0\Registration\{91110413-6000-11D3-8CFE-0150048383C9}", "DigitalProductId") ; register sleutel Office productcode
$name = RegRead("HKLM64\SYSTEM\CurrentControlSet\Control\Computername\Computername", "ComputerName") ; Computernaam
$system = RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName") ; Besturingssysteem
$WINRegKey = MSDecode($a, "-") ; Windows productcode
$OffRegKey = MSDecode($b, "-") ; office productcode
$nOSbuild = RegRead ("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentBuildNumber"); Build
$WINSP = regread("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CSDVersion"); Servicepack
$font="Comic Sans MS"

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
;CPU
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Processor:", 30, 220)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel(_Read_CPU(), 1000, 1000)
;Videokaart
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Graphicscard:", 30, 260)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel(_Read_Graphics(), 1000, 1000)
;Geluidskaart
GUISetFont (9, 600, $font); will display bold characters
GUICtrlCreateLabel("Soundcard:", 30, 300)
GUISetFont (9, 400, $font); will display normal characters
GUICtrlCreateLabel(_Read_Sound(), 1000, 1000)

GUICtrlCreateLabel("Created by Sander Vogelaar", 500, 430)


GUISetState()

While 1
    $msg = GUIGetMsg()
    
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd
