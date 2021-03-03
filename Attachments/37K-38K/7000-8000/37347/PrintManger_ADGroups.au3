#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\Applications\PrintManager.ico
#AutoIt3Wrapper_outfile=\\Rtsrv\NETLOGON\iPrintMgr.exe
#AutoIt3Wrapper_Res_Comment=Print Manager for Reitzel Technology
#AutoIt3Wrapper_Res_Description=Print Manager for Reitzel Technology
#AutoIt3Wrapper_Res_Fileversion=4.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Reitzel Technology
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include <\\ReitzelTechnology.int\Adm$\AutoIt_Scripts\AD.au3>


$Domain = RegRead("HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "Domain") ;Finds Computer Domain Name

If Not $Domain="ReitzelTechnology.int" Then ;Prevents iPrintMgr from running if not in the domain or doesn't have override file present.
	If Not FileExists("C:\NotInDomain_AllowiPrintToRun.txt") Then
		Msgbox(64,"iPrintMgr Initiation Cancelled","This machine is not in the domain ReitzelTechnology.int and does not have the override file present.  iPrintMgr will now terminate.  Alert your administrator if you recieved this message in error.")
		Exit
	EndIf
EndIf


Opt("TrayIconHide", 0)
Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.
AdlibRegister("_SetDefaults",1000*60*30)
Opt("TrayAutoPause",0)  ; Script will not be paused when clicking the tray icon
TraySetToolTip("Reitzel Technology iPrintMgr")


$aboutitem = TrayCreateItem("About")
$refreshdefault = TrayCreateItem("Refresh Default Printer")
$remap = TrayCreateItem("Refresh Printers")
$exititem       = TrayCreateItem("Exit PrintMgr")

TraySetState()
_ServerConnection()
_Run()

While 1
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
        Case $msg = $remap
            _Run()
		Case $msg = $refreshdefault
			_ReMapDefault()
		Case $msg = $exititem
			ExitLoop
		Case $msg = $aboutitem
            Msgbox(64,"About iPrintMgr","iPrint Manager 4.1 for Reitzel Technology.  Will refresh default printer every 30 minutes.  Printers are mapped on 1st run or when the ReMap command is selected.  Alert helpdesk with problems.")
    EndSelect
WEnd
Exit

;Start Global Code

Func _ServerConnection()
	$var = Ping("RTSRV.ReitzelTechnology.int")
	If @error=0 Then
	Else
	_Sleep_15Mins()
EndIf
EndFunc

Func _Sleep_15Mins()
	Sleep(1000*60*15)
	_ServerConnection()
EndFunc

Func MapPrint($uncpath)
    $serverAr = StringSplit($uncpath, "\")
    $server = $serverAr[3]

    If (Ping($server)) Then
        RunWait(@ComSpec & ' /c Rundll32 printui.dll,PrintUIEntry /q /in /n  "' & $uncpath & '"', "", @SW_HIDE)
    EndIf
EndFunc   ;==>useprinter

Func DelPrint($uncpath)
    $serverAr = StringSplit($uncpath, "\")
    $server = $serverAr[3]

    If (Ping($server)) Then
        RunWait(@ComSpec & ' /c Rundll32 printui.dll,PrintUIEntry /q /dn /n  "' & $uncpath & '"', "", @SW_HIDE)
    EndIf
EndFunc   ;==>useprinter

Func SetDefault($Printer)
   RunWait(@ComSpec & " /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n " & $Printer , "",@SW_HIDE)
EndFunc

Func _OpenHelpWebpage()
	ShellExecute ("iexplore", "http://www.reitzeltechnology.com/HelpPages/iPrintHelp.html")
EndFunc

;End Global Code



Func _Run()
	_ServerConnection()
	_MapPrintifOverRideFilePresent()
	_CMF4370dnPrinter()
	Sleep(1000*2)
	_CMF4370dn_FxPrinter()
	Sleep(1000*2)
	_CP2025Printer()
	Sleep(1000*5)
	_SetDefaults()
EndFunc   ;==>_Run

Func _SetDefaults()
	_ServerConnection()
	_CP2025Printer_Default()
	_CMF4370dnDefault()
	_CMF4370dn_FxDefault()
EndFunc


Func _ReMapDefault()
	_ServerConnection()
	TrayTip("Resetting Default Printer", "Your default printer is being reset to the printer specified in Active Directory.", 10, 0)
	Sleep(1000*5)
	_SetDefaults()
	Sleep(1000*10)
	TrayTip("clears any tray tip","",0)
EndFunc




; Begin Commands to map Individual Printers

Func _CMF4370dnPrinter()
	Global $iResult, $sGroup = "CMF4370dnPrinter"
	; Open Connection to the Active Directory
	_AD_Open()
	If @error Then Exit MsgBox(16, "Active Directory", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
	; Check if the computer is an immediate member of the group
	If _AD_IsMemberOf($sGroup, @ComputerName & "$") = 1 Then
	MapPrint("\\RTSRV\CMF4370DN")
Else
	DelPrint("\\RTSRV\CMF4370DN")
EndIf
; Close Connection to the Active Directory
_AD_Close()
EndFunc

Func _CMF4370dn_FxPrinter()
	Global $iResult, $sGroup = "CMF4370dn_FxPrinter"
	; Open Connection to the Active Directory
	_AD_Open()
	If @error Then Exit MsgBox(16, "Active Directory", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
	; Check if the computer is an immediate member of the group
	If _AD_IsMemberOf($sGroup, @ComputerName & "$") = 1 Then
	MapPrint("\\RTSRV\CMF4370DN_FX")
Else
	DelPrint("\\RTSRV\CMF4370DN_FX")
EndIf
; Close Connection to the Active Directory
_AD_Close()
EndFunc

Func _CP2025Printer()
	Global $iResult, $sGroup = "CP2025Printer"
	; Open Connection to the Active Directory
	_AD_Open()
	If @error Then Exit MsgBox(16, "Active Directory", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
	; Check if the computer is an immediate member of the group
	If _AD_IsMemberOf($sGroup, @ComputerName & "$") = 1 Then
	MapPrint("\\RTSRV\HPCP2025")
Else
	DelPrint("\\RTSRV\HPCP2025")
EndIf
; Close Connection to the Active Directory
_AD_Close()
EndFunc

Func _MapPrintifOverRideFilePresent()
	If FileExists("C:\NotInDomain_AllowiPrintToRun.txt") Then
		MapPrint("\\RTSRV\CMF4370DN")
		MapPrint("\\RTSRV\CMF4370DN_FX")
		MapPrint("\\RTSRV\HPCP2025")
	EndIf
EndFunc


;End Commands


;Begin Set Default Commands
Func _CP2025Printer_Default()
	Global $iResult, $sGroup = "CP2025Printer_Default"
	; Open Connection to the Active Directory
	_AD_Open()
	If @error Then Exit MsgBox(16, "Active Directory", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
	; Check if the computer is an immediate member of the group
	If _AD_IsMemberOf($sGroup, @ComputerName & "$") = 1 Then
	SetDefault("\\RTSRV\HPCP2025")
EndIf
; Close Connection to the Active Directory
_AD_Close()
EndFunc

Func _CMF4370dnDefault()
	Global $iResult, $sGroup = "CMF4370dn_Default"
	; Open Connection to the Active Directory
	_AD_Open()
	If @error Then Exit MsgBox(16, "Active Directory", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
	; Check if the computer is an immediate member of the group
	If _AD_IsMemberOf($sGroup, @ComputerName & "$") = 1 Then
	SetDefault("\\RTSRV\CMF4370DN")
EndIf
; Close Connection to the Active Directory
_AD_Close()
EndFunc

Func _CMF4370dn_FxDefault()
	Global $iResult, $sGroup = "CMF4370dn_FxPrinter_Default"
	; Open Connection to the Active Directory
	_AD_Open()
	If @error Then Exit MsgBox(16, "Active Directory", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
	; Check if the computer is an immediate member of the group
	If _AD_IsMemberOf($sGroup, @ComputerName & "$") = 1 Then
	SetDefault("\\RTSRV\CMF4370DN_FX")
EndIf
; Close Connection to the Active Directory
_AD_Close()
EndFunc


;End Set Default Commands


