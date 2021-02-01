#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT/Vista/Win 7
; Author:         Peter Atkin (computer-facilities.com)
; Credits:        verious
; Date:           27/01/2010
;
; Script Function:
; Generic Shutodown of remote servers in desired order;

#include <Constants.au3>
#include <Process.au3>

Dim $server[3]
$server[0] = "10.0.0.1"
$server[1] = "dccfu1"
$server[2] = "xp-terminal1"

password_option("password")

Func password_option($password)
	$gui = GUICreate("Password input", 250, 100)
	$label = GUICtrlCreateLabel("Enter serial code here: ", 10, 10, 180, 25)
	$input = GUICtrlCreateInput("", 10, 30, 100, 25)
	$button = GUICtrlCreateButton("OK", 10, 65, 50, 25)
	$xp = 0
	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case -3; this is the same sa $GUI_EVENT_CLOSE
				Exit
			Case $button
				$readinput = GUICtrlRead($input)
				If $readinput <> "" Then
					If $readinput = $password Then
						shutdown_servers()
						Exit
					Else
						MsgBox(64, "bad memory", "You've not forgotten the password again!")
						$xp = $xp + 1
						If $xp = 3 Then Exit
					EndIf
				Else
					MsgBox(64, "lazy", "You haven't typed anything in !")
				EndIf
		EndSwitch
		Sleep(25)
	WEnd
EndFunc   ;==>password_option

Func shutdown_servers()
	For $x = 0 To 2 Step 1
		$hostname = $server[$x]
		MsgBox(64, "remote shutting down:", $hostname, 1)
		;RunAsWait ("administrator", "cfu", "password",0,"shutdown.exe -s -f -m \\" &$hostname)
		RunWait('shutdown -s -f -m \\10.0.0.1 -t 20 -c "Datensicherung von Büro"',"",@SW_HIDE)
		;RemoteShutdown($hostname, 12)
	Next
EndFunc   ;==>shutdown_servers

Func RemoteShutdown(ByRef $s_Machine, ByRef $s_Command)
    Local $wbemFlagReturnImmediately, $wbemFlagForwardOnly, $objWMIService, $colItems, $objItem

    $wbemFlagReturnImmediately = 0x10
    $wbemFlagForwardOnly = 0x20
    $colItems = ""
    $objWMIService = ObjGet("winmgmts:\\" & $s_Machine & "\root\CIMV2")
    $colItems = $objWMIService.ExecQuery("SELECT Name From Win32_OperatingSystem", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    ; 0=Log Off|0+4=Forced Log Off|1=Shutdown|1+4=Forced Shutdown|2=Reboot|2+4=Forced Reboot|8=Power Off|8+4=Forced Power Off
    For $objItem in $colItems
        $objItem.Win32ShutDown($s_Command)
    Next
EndFunc; ==> _RemoteShutdown
