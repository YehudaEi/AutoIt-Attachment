#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <guiconstants.au3>
#include "em.au3"
; GUI and String stuff
$WinMain = GUICreate('Encryption tool', 400, 400)
; Creates window
$EditText = GUICtrlCreateEdit('', 5, 5, 380, 350)
$InputPass = GUICtrlCreateInput('', 5, 360, 100, 20, 0x21)
; Creates main edit
; Creates the password box with blured/centered input
; These two make the level input with the Up|Down ability
$EncryptButton = GUICtrlCreateButton('Encrypt', 170, 360, 105, 35)
; Encryption button
$DecryptButton = GUICtrlCreateButton('Decrypt', 285, 360, 105, 35)
; Decryption button
; Simple text labels so you know what is what
GUISetState()
; Shows window

Do
	$Msg = GUIGetMsg()
	If $Msg = $EncryptButton Then
		GUISetState(@SW_DISABLE, $WinMain) ; Stops you from changing anything
		$string = GUICtrlRead($EditText) ; Saves the editbox for later
		GUICtrlSetData($EditText, 'Please wait while the text is Encrypted/Decrypted.') ; Friendly message
		GUICtrlSetData($EditText, sen($string, GUICtrlRead($InputPass)))
		; Calls the encryption. Sets the data of editbox with the encrypted string
		; The encryption starts with 1/0 to tell it to encrypt/decrypt
		; The encryption then has the string that we saved for later from edit box
		; It then reads the password box & Reads the level box
		GUISetState(@SW_ENABLE, $WinMain) ; This turns the window back on
	EndIf
	If $Msg = $DecryptButton Then
		GUISetState(@SW_DISABLE, $WinMain) ; Stops you from changing anything
		$string = GUICtrlRead($EditText) ; Saves the editbox for later
		GUICtrlSetData($EditText, 'Please wait while the text is Encrypted/Decrypted.') ; Friendly message
		GUICtrlSetData($EditText, sde($string, GUICtrlRead($InputPass)))
		; Calls the encryption. Sets the data of editbox with the encrypted string
		; The encryption starts with 1/0 to tell it to encrypt/decrypt
		; The encryption then has the string that we saved for later from edit box
		; It then reads the password box & Reads the level box
		GUISetState(@SW_ENABLE, $WinMain) ; This turns the window back on
	EndIf
Until $Msg = $GUI_EVENT_CLOSE ; Continue loop untill window is closed