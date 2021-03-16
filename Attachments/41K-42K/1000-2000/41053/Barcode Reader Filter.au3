#Region Includes
#include "..\include\RawInput.au3"
#include <WinAPI.au3>
#EndRegion Includes

#Region Configure Hotkeys
HotKeySet('{ESC}', '_EXIT')
#EndRegion Configure Hotkeys

#Region Initialize Global Variables
;Required for RawInput.au3 Functions
Global $tRID_KD, $pRID_KD, $iRID_KD
Global $tRIH, $pRIH, $iRIH
Global $iNumDevices
Global $hGUI
Global $val
#EndRegion Initialize Global Variables

#Region Initalize HID Device Monitoring
$hGUI = GUICreate('Test', 100, 100)
GUIRegisterMsg($WM_INPUT, 'OnInput')
$tRID_KD = DllStructCreate($tagRAWINPUTDEVICE)
$pRID_KD = DllStructGetPtr($tRID_KD)
$iRID_KD = DllStructGetSize($tRID_KD)
$tRIH = DllStructCreate($tagRAWINPUTHEADER)
$pRIH = DllStructGetPtr($tRIH)
$iRIH = DllStructGetSize($tRIH)
$iNumDevices = 1
;Register Keyboard HID Devices
DllStructSetData($tRID_KD, 'usUsagePage', 0x01)
DllStructSetData($tRID_KD, 'usUsage', 0x06)
DllStructSetData($tRID_KD, 'dwFlags', $RIDEV_INPUTSINK)
DllStructSetData($tRID_KD, 'hwndTarget', $hGUI)
_RegisterRawInputDevices($pRID_KD, $iNumDevices, $iRID_KD)
#EndRegion Initalize HID Device Monitoring

#Region Main Loop
Local $rep
While 1
	$rep = InputBox("Test", "Entrer une valeur quelconque", "<valeur par défaut>")
	MsgBox(0, "test", "La valeur entrée est '" & $rep & "'")
    Sleep(10)
WEnd
#EndRegion Main Loop


#Region ================================ USER DEFINED FUNCTIONS ================================
Func _EXIT()
;~     GUIDelete()
    Exit
EndFunc;==>_EXIT

Func OnInput($hwnd, $iMsg, $iwParam, $ilParam);Process Keyboard Input from RawInput.au3 Commands
    Local $tRI_KB, $pRI_KB, $iRI_KB
    Local $tRIDI_KB, $pRIDI_KB, $iRIDI_KB
    Local $hDevice, $makeCode, $Flags, $vKey, $Message, $ExtraInformation
	Local $dwVendorId, $dwProductId, $dwType
    Local $DIdwType
    Local $dwSubType
    Local $dwKeyboardMode
    Local $dwNumberOfFunctionKeys
    Local $dwNumberOfIndicators
    Local $dwNumberOfKeysTotal

; Prepare structure for keyboard info
    $tRI_KB = DllStructCreate($tagRAWINPUT_KEYBOARD)
    $pRI_KB = DllStructGetPtr($tRI_KB)
    $iRI_KB = DllStructGetSize($tRI_KB)
; Prepare structure for generic HID device info    
    $tRIDI_KB = DllStructCreate($tagRIDDEVICEINFO_KEYBOARD)
    $pRIDI_KB = DllStructGetPtr($tRIDI_KB)
    $iRIDI_KB = DllStructGetSize($tRIDI_KB)
    DllStructSetData($tRIDI_KB, 'cbSize', $iRIDI_KB)
; Pull keyboard info
    _GetRawInputData($ilParam, $RID_INPUT, $pRI_KB, $iRI_KB, $iRIH)
    If Not @error Then
        $hDevice          = DllStructGetData($tRI_KB, 'hDevice')
;~		$dwType           = DllStructGetData($tRI_KB, 'dwType')
;~		$makeCode         = DllStructGetData($tRI_KB, 'MakeCode')
        $Flags            = DllStructGetData($tRI_KB, 'Flags')
        $vKey             = DllStructGetData($tRI_KB, 'VKey')
;~         $Message          = DllStructGetData($tRI_KB, 'Message')
;~		$ExtraInformation = DllStructGetData($tRI_KB, 'ExtraInformation')
    EndIf

;

; Pull keyboard device info
    _GetRawInputDeviceInfo($hDevice, $RIDI_DEVICEINFO, $pRIDI_KB, $iRIDI_KB)
    If Not @error Then
;~		$dwVendorId  = DllStructGetData($tRIDI_KB, 'dwVendorId')
;~		$dwProductId = DllStructGetData($tRIDI_KB, 'dwProductId')
;~		$DIdwType = DllStructGetData($tRIDI_KB, 'dwType')
;~		$dwSubType = DllStructGetData($tRIDI_KB, 'dwSubType')
;~		$dwKeyboardMode = DllStructGetData($tRIDI_KB, 'dwKeyboardMode')
;~		$dwNumberOfFunctionKeys = DllStructGetData($tRIDI_KB, 'dwNumberOfFunctionKeys')
;~		$dwNumberOfIndicators = DllStructGetData($tRIDI_KB, 'dwNumberOfIndicators')
		$dwNumberOfKeysTotal = DllStructGetData($tRIDI_KB, 'dwNumberOfKeysTotal')
    EndIf
	
; Process all input received by Barcode Reader. Current processing if more for testing purposes than actual application
    If $dwNumberOfKeysTotal > 160 Then			; my barcode readers declare that many "keys", much more than actual keyboards
;;~  	ConsoleWrite("hdevice          		 = " & $hDevice & @LF)
;;~		ConsoleWrite("dwType           		 = " & $dwType & @LF)
;;~		ConsoleWrite("MakeCode 		         = " & $makeCode & @LF)
;~ 		ConsoleWrite("Flags         		 = " & $Flags & @LF)
;~ 		ConsoleWrite("VKey             		 = " & hex($vKey) & @LF)
;~ 		ConsoleWrite("Message        		 = " & hex($Message) & @LF)
;;~		ConsoleWrite("ExtraInformation 		 = " & $ExtraInformation & @LF & @LF)
;;~  	ConsoleWrite("dwVendorId             = " & $dwVendorId & @LF)
;;~  	ConsoleWrite("dwProductId            = " & $dwProductId & @LF)
;;~  	ConsoleWrite("dwType                 = " & $DIdwType & @LF)
;;~  	ConsoleWrite("dwSubType              = " & $dwSubType & @LF)
;;~  	ConsoleWrite("dwKeyboardMode         = " & $dwKeyboardMode & @LF)
;;~ 	ConsoleWrite("dwNumberOfFunctionKeys = " & $dwNumberOfFunctionKeys & @LF)
;;~ 	ConsoleWrite("dwNumberOfIndicators   = " & $dwNumberOfIndicators & @LF)
;;~ 	ConsoleWrite("dwNumberOfKeysTotal    = " & $dwNumberOfKeysTotal & @LF & @LF)
;~ 		ConsoleWrite($vKey - 96 & @LF)

;; from here, we know the vKey hit is from barcode reader.  We could switch to an ad hoc gui/input box to capture its data.

		Switch $vKey
			Case 0x12
				If BitAND($Flags, $RI_KEY_BREAK) = 0 Then
;; enregistrer la fenêtre active et switcher sur un contrôle caché qui va récupérer la touche
;; switcher sur la fenêtre active utilisateur après un "certain" temps
					$val = 0
				Else
					ConsoleWrite(Chr($val))
				EndIf
			Case 0x60 To 0x69
				If BitAND($Flags, $RI_KEY_BREAK) <> 0 Then $val = $val * 10 + ($vKey - 0x60)
			Case Else
 				ConsoleWrite("Code invalide reçu : 0x" & Hex($vKey) & @LF)
		EndSwitch
    EndIf

;

	$tRI_KB = 0
    Return 'GUI_RUNDEFMSG'
EndFunc;==>OnInput
#EndRegion ============================== USER DEFINED FUNCTIONS ================================