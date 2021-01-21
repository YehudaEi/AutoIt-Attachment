;The script will need Array.au3 because we are using arrays and it will also need GUIConstants.au3 because of our cool gui.
#include <Array.au3>
#include <GUIConstants.au3>
#NoTrayIcon

;$vTarget is who we are getting so lets declare him as ourselfs for presentation sake
$vTarget = "Working As "&@IPAddress1

;The GUI is created here.
GUICreate("DFW-IR - " &$vTarget, 300, 140)

; Show the GUI
GUISetState()

;INPUTBOXES of IP Address for the Target and action button along with a status label
$Target = GuiCtrlCreateInput(@IPAddress1, 5, 20, 0, 0)
$button_1 = GUICtrlCreateButton("Execute", "5", "60", "80", "20", $BS_DEFPUSHBUTTON)
$Status = GUICtrlCreateLabel ("Ready", "90", "60", "100", "25")

;Creating ProgressBar
$ProgressBar = GUICtrlCreateProgress("5","100","180","0")

;This script is to bring down the RI Firewall on the Windows XP Images
Dim $aReg[2]

;Now the arrays are created
$aReg[0] = "\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile /v EnableFirewall /t reg_dword /d 00000000 /F"
$aReg[1] = "\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile /v EnableFirewall /t reg_dword /d 00000000 /F"

;While 1 keeps the application from stoping
While 1
	$msg = GUIGetMsg()
	$i = 0 ;$i is defined as 0 so the while loop that is later called, for DFW-IR, can be broken
	GUICtrlSetData($ProgressBar,0) ;Setting the progressbar to 0
	
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $GUI_EVENT_MINIMIZE
			
		Case $msg = $GUI_EVENT_MAXIMIZE
		
		Case $msg = $button_1
				While $i = 0
					$vTarget = GUICtrlRead($Target)
					GUICtrlSetData($ProgressBar,18)
					GUICtrlSetData($Status, "Enabling Remote Registry")
					RunWait(@ComSpec & " /c sc \\" & $vTarget&" config RemoteRegistry start= auto", "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,38)
					GUICtrlSetData($Status, "Starting Remote Registry")
					RunWait(@ComSpec & " /c sc \\" & $vTarget&" start RemoteRegistry", "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,42)
					GUICtrlSetData($Status, "Turning off firewall for the user")
					RunWait(@ComSpec & " /c reg add \\" & $vTarget&$aReg[0], "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,84)
					GUICtrlSetData($Status, "Turning off firewall for the computer")
					RunWait(@ComSpec & " /c reg add \\" & $vTarget&$aReg[1], "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,100)
					GUICtrlSetData($Status, "Firewall Disabled on "&$vTarget)
					$i = $i + 1
				WEnd
	
	EndSelect			
WEnd

