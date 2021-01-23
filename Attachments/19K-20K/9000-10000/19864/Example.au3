#include <GUIConstants.au3>
#include <Keygen.au3>

;The name of your product, or the encryption password
Global $Product = "My Keygen w/ Checker"

;A code within the encrypted key to check to ensure valid key
Global $sConfirmCode = "No one should know me, else this is useless"

;How encrypted you want your key to be (1-5, Low number means smaller key)
Global $sSecure = 3


;===[This would be something on your machine to create the key for them]===
Local $sKey = _Keygen($Product, $sConfirmCode, $sSecure)
MsgBox(0, "Key Generated!", "Your user's keycode is: " & $sKey)


$Form1 = GUICreate("Activate your program.", 571, 261, 193, 125)
$Label1 = GUICtrlCreateLabel("Please enter your key code that was given to your upon purchase,", 8, 8, 317, 17)
$Edit1 = GUICtrlCreateEdit("", 8, 32, 553, 193)
GUICtrlSetData(-1, $sKey)
$Button1 = GUICtrlCreateButton("Activate", 8, 232, 555, 25, 0)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			If _Confirm(GUICtrlRead($Edit1), $Product, $sConfirmCode, $sSecure) = 1 Then
				MsgBox(0, "Activated!", "Thank you for activating this software!")
				Exit
			Else
				MsgBox(0, "Activated Failed", "The key you entered isn't correct.")
			EndIf
	EndSwitch
WEnd