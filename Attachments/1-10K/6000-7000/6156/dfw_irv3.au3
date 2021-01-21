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

;Enable and Disable options options for the firewall
$Radio1 = GUICtrlCreateRadio ("Disable", 205, 50, 120, 20)
$Radio2 = GUICtrlCreateRadio ("Enable", 205, 70, 120, 20)
GUICtrlSetState($Radio1,$GUI_CHECKED)
GUICtrlSetState($Target,$GUI_FOCUS)

;Creating ProgressBar
$ProgressBar = GUICtrlCreateProgress("5","100","180","0")

;This script is to bring down the RI Firewall on the Windows XP Images
Dim $aReg[6]

;Now the arrays are created
$aReg[0] = "\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile /v EnableFirewall /t reg_dword "
$aReg[1] = "\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile /v EnableFirewall /t reg_dword "
$aReg[2] = "/d 00000000 /F"
$aReg[3] = "/d 00000001 /F"
$aReg[4] = "on"
$aReg[5] = "off"

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
				$i = $i + 1
				While $i = 1
					
					;Here is we get the state of the raido buttons
					If GUICtrlRead($Radio1) = $GUI_CHECKED Then $x = $aReg[2]
					If GUICtrlRead($Radio2) = $GUI_CHECKED Then $x = $aReg[3]
					If GUICtrlRead($Radio1) = $GUI_CHECKED Then $q = $aReg[5]
					If GUICtrlRead($Radio2) = $GUI_CHECKED Then $q = $aReg[4]
	
					;Now the games begin					
					$vTarget = GUICtrlRead($Target)
					GUICtrlSetData($ProgressBar,18)
					GUICtrlSetData($Status, "Enabling Remote Registry")
					RunWait(@ComSpec & " /c sc \\" & $vTarget&" config RemoteRegistry start= auto", "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,38)
					GUICtrlSetData($Status, "Starting Remote Registry")
					RunWait(@ComSpec & " /c sc \\" & $vTarget&" start RemoteRegistry", "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,42)
					GUICtrlSetData($Status, "Turning "& $q&" firewall for the user")
					RunWait(@ComSpec & " /c reg add \\" & $vTarget&$aReg[0]&$x, "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,64)
					GUICtrlSetData($Status, "Turning "& $q&" firewall for the computer")
					RunWait(@ComSpec & " /c reg add \\" & $vTarget&$aReg[1]&$x, "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,79)
					GUICtrlSetData($Status, "Stoping Remote Registry")
					RunWait(@ComSpec & " /c sc \\" & $vTarget&" start RemoteRegistry", "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,95)
					GUICtrlSetData($Status, "Disabling Remote Registry")
					RunWait(@ComSpec & " /c sc \\" & $vTarget&" config RemoteRegistry start= auto", "C:\", @SW_HIDE)
					GUICtrlSetData($ProgressBar,100)
					GUICtrlSetData($Status, "Process Complete on "&$vTarget)
					$i = $i + 1
				WEnd
	
	EndSelect			
WEnd

