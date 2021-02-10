
;.......script written by trancexx (trancexx at yahoo dot com)

#include <Memory.au3>
#include <WinAPI.au3>

Opt("MustDeclareVars", 1)

Global $hGui = GUICreate("Internet status", 350, 270)
GUISetBkColor(0xFFFFFF, $hGui)

Global $hLabel = GUICtrlCreateLabel("STAND BY", 18, 253, 42, 14) ; can be empty string of course
GUICtrlSetFont(-1, 7, 400, 1, "Trebuchet MS")
GUICtrlSetColor(-1, 0x0000CC)

Global $hIcon = GUICtrlCreateIcon("", "", 20, 220, 32, 32)
GUICtrlSetTip(-1, "Status")

Global $hButton = GUICtrlCreateButton("MsgBox", 125, 220, 100, 25)


Global $aInternetCon = _InternetCheckConnectionInAnotherThread($hLabel, $hIcon)

GUISetState()


While 1

	Switch GUIGetMsg()
		Case -3
			Exit
		Case $hButton
			MsgBox(0, "Title", "Text", 0, $hGui)
	EndSwitch

WEnd



Func _InternetCheckConnectionInAnotherThread($hLabelControl, $hIconControl = 0, $iInterval = -1, $sURL1 = -1, $sURL2 = -1, $hIconON = -1, $hIconOFF = -1)
    ; Setting default values
    If $iInterval = Default Or $iInterval = -1 Then $iInterval = 3000
	If $sURL1 = Default Or $sURL1 = -1 Then $sURL1 = "http://www.google.com"
	If $sURL2 = Default Or $sURL2 = -1 Then $sURL2 = "http://www.microsoft.com"
    ; Allocating for the strings
	Local $pDataBuffer = _MemVirtualAlloc(0, 288, $MEM_COMMIT, $PAGE_READWRITE)
    If @error Then Return SetError(1, 0, 0)
    ; Organizing that space
	Local $tDataBuffer = DllStructCreate("char URL1[64];" & _
			"char URL2[64];" & _
			"wchar OFF[8];" & _
			"wchar ON[8]", _
			$pDataBuffer)
	DllStructSetData($tDataBuffer, "URL1", $sURL1)
	DllStructSetData($tDataBuffer, "URL2", $sURL2)
	DllStructSetData($tDataBuffer, "OFF", "OFFLINE")
	DllStructSetData($tDataBuffer, "ON", " ONLINE")
	; Get addresses of the functions to use
	Local $aInternetCheckConnectionW = DllCall("kernel32.dll", "ptr", "GetProcAddress", "handle", _WinAPI_GetModuleHandle("wininet.dll"), "str", "InternetCheckConnectionA")
	If @error Or Not $aInternetCheckConnectionW[0] Then Return SetError(2, 0, 0)
	Local $pInternetCheckConnectionW = $aInternetCheckConnectionW[0]
	Local $aSendMessageW = DllCall("kernel32.dll", "ptr", "GetProcAddress", "handle", _WinAPI_GetModuleHandle("user32.dll"), "str", "SendMessageW")
	If @error Or Not $aSendMessageW[0] Then Return SetError(3, 0, 0)
	Local $pSendMessageW = $aSendMessageW[0]
	Local $aSleep = DllCall("kernel32.dll", "ptr", "GetProcAddress", "handle", _WinAPI_GetModuleHandle("kernel32.dll"), "str", "Sleep")
	If @error Or Not $aSleep[0] Then Return SetError(4, 0, 0)
	Local $pSleep = $aSleep[0]
    ; Set connection timeout
	DllCall("wininet.dll", "bool", "InternetSetOption", _
			"handle", 0, _
			"dword", 2, _ ; INTERNET_OPTION_CONNECT_TIMEOUT
			"dword*", 3000, _ ; 3s
			"dword", 4)
    ; Allocate for the executable code
	Local $pExecutableCode = _MemVirtualAlloc(0, 512, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE) ; allocating 512 bytes
    If @error Then Return SetError(5, 0, 0)
    ; Arrange the space
	Local $tCodeBuffer = DllStructCreate("byte[512]", $pExecutableCode) ; again 512 bytes, only this way
    ; Icons
	If $hIconControl Then
		If $hIconON = Default Or $hIconON = -1 Then $hIconON = _GetIcon("shell32.dll", 10, 32)
		If $hIconOFF = Default Or $hIconOFF = -1 Then $hIconOFF = _GetIcon("shell32.dll", 11, 32)
	EndIf
    ; Write code
	If @AutoItX64 Then
		DllStructSetData($tCodeBuffer, 1, _
				"0x" & _ ; BLOCK 10 - INITIALIZE
				"4883EC" & SwapEndian(40, 1) & _                                ; sub rsp, 40d                              ; expand the stack 40 bytes
				"" & _ ; BLOCK 20 - CALLING InternetCheckConnectionW with URL1
				"49C7C0" & SwapEndian(0) & _                                    ; mov r8, 0                                 ; parameter Reserved
				"48C7C2" & SwapEndian(1) & _                                    ; mov rdx, 1                                ; parameter Flag
				"48B9" & SwapEndian(DllStructGetPtr($tDataBuffer, "URL1")) & _  ; mov rcx, URL1                             ; parameter url
				"48B8" & SwapEndian($pInternetCheckConnectionW) & _             ; mov rax, InternetCheckConnectionW
				"FFD0" & _                                                      ; call rax                                  ; call function
				"" & _ ; BLOCK 30 - CHECK RETURNED
				"3D" & SwapEndian(0) & _                                        ; cmp eax, 0d                               ; compare returned with 0
				"" & _ ; BLOCK 40 - CONDITION
				"74" & SwapEndian(116, 1) & _                                   ; je 116d                                   ; if InternetCheckConnectionW returned 0 jump forward 116 bytes (to BLOCK 90)
				"" & _ ; BLOCK 50 - SET LABEL TEXT TO "ONLINE"
				"49B9" & SwapEndian(DllStructGetPtr($tDataBuffer, "ON")) & _    ; mov r9, string
				"49C7C0" & SwapEndian(0) & _                                    ; mov r8, 0
				"48C7C2" & SwapEndian(12) & _                                   ; mov rdx, WM_SETTEXT
				"48B9" & SwapEndian(GUICtrlGetHandle($hLabelControl), 8) & _    ; mov rcx, HANDLE
				"48B8" & SwapEndian($pSendMessageW) & _                         ; mov rax, SendMessageW
				"FFD0" & _                                                      ; call rax
				"" & _ ; BLOCK 60 - SET ICON "ONLINE"
				"49B9" & SwapEndian($hIconON, 8) & _                            ; mov r9, hIcon
				"49C7C0" & SwapEndian(2) & _                                    ; mov r8, IMAGE_ICON
				"48C7C2" & SwapEndian(370) & _                                  ; mov rdx, WM_SETTEXT
				"48B9" & SwapEndian(GUICtrlGetHandle($hIconControl), 8) & _     ; mov rcx, HANDLE
				"48B8" & SwapEndian($pSendMessageW) & _                         ; mov rax, SendMessageW
				"FFD0" & _                                                      ; call rax
				"" & _ ; BLOCK 70 - SLEEP SPECIFIED INTERVAL OF TIME
				"48C7C1" & SwapEndian($iInterval) & _                           ; mov rcx, $iInterval
				"48B8" & SwapEndian($pSleep) & _                                ; mov rax, $pSleep
				"FFD0" & _                                                      ; call rax
				"" & _ ; BLOCK 80 - START ALL OVER AGAIN (GOTO Start)
				"E9" & SwapEndian(-159) & _                                     ; jump -159d                                ; jump back 159 bytes (to BLOCK 20)
				"" & _ ; BLOCK 90 - CALLING InternetCheckConnectionW with URL2
				"49C7C0" & SwapEndian(0) & _                                    ; mov r8, Reserved
				"48C7C2" & SwapEndian(1) & _                                    ; mov rdx, Flag
				"48B9" & SwapEndian(DllStructGetPtr($tDataBuffer, "URL2")) & _  ; mov rcx, URL2
				"48B8" & SwapEndian($pInternetCheckConnectionW) & _             ; mov rax, InternetCheckConnectionW
				"FFD0" & _                                                      ; call rax
				"" & _ ; BLOCK 100 - CHECK RETURNED
				"3D" & SwapEndian(0) & _                                        ; cmp eax, 0d                               ; compare returned with 0
				"" & _ ; BLOCK 110 - CONDITION
				"74" & SwapEndian(5, 1) & _                                     ; je 5d                                     ; if InternetCheckConnectionW returned 0, jump forward 5 bytes (to BLOCK 130)
				"" & _ ; BLOCK 120 - JUMP TO BLOCK 50
				"E9" & SwapEndian(-164) & _                                     ; jmp -164d                                 ; else go back 164 bytes (to BLOCK 50)
				"" & _ ; BLOCK 130 - SET LABEL TEXT TO "OFFLINE"
				"49B9" & SwapEndian(DllStructGetPtr($tDataBuffer, "OFF")) & _   ; mov r9, string
				"49C7C0" & SwapEndian(0) & _                                    ; mov r8, wParam
				"48C7C2" & SwapEndian(12) & _                                   ; mov rdx, WM_SETTEXT
				"48B9" & SwapEndian(GUICtrlGetHandle($hLabelControl), 8) & _    ; mov rcx, HANDLE
				"48B8" & SwapEndian($pSendMessageW) & _                         ; mov rax, SendMessageW
				"FFD0" & _                                                      ; call rax
				"" & _ ; BLOCK 140 - SET ICON "OFFLINE"
				"49B9" & SwapEndian($hIconOFF, 8) & _                           ; mov r9, hIcon
				"49C7C0" & SwapEndian(2) & _                                    ; mov r8, IMAGE_ICON
				"48C7C2" & SwapEndian(370) & _                                  ; mov rdx, $STM_SETIMAGE
				"48B9" & SwapEndian(GUICtrlGetHandle($hIconControl), 8) & _     ; mov rcx, HANDLE
		 		"48B8" & SwapEndian($pSendMessageW) & _                         ; mov rax, SendMessageW
				"FFD0" & _                                                      ; call rax
				"" & _ ; BLOCK 150 - JUMP TO BLOCK 70 (GOTO Sleep)
				"E9" & SwapEndian(-169) & _                                     ; jump -169d                                ; jump back to BLOCK 70 (Sleep)
				"" & _ ; BLOCK 160 - DEAL WITH THE STACK
				"4883C4" & SwapEndian(40, 1) & _                                 ; add rsp, 40d                             ; shrink stack (40 bytes)
				"" & _ ; BLOCK 170 - RETURN
				"C3" _                                                          ; ret                                       ; return
				)
	Else
		DllStructSetData($tCodeBuffer, 1, _
				"0x" & _
				"68" & SwapEndian(0) & _                                      ; push Reserved
				"68" & SwapEndian(1) & _                                      ; push Flag
				"68" & SwapEndian(DllStructGetPtr($tDataBuffer, "URL1")) & _  ; push URL1 string
				"B8" & SwapEndian($pInternetCheckConnectionW) & _             ; mov eax, InternetCheckConnectionW
				"FFD0" & _                                                    ; call eax
				"3D" & SwapEndian(0) & _                                      ; cmp eax, 00000000
				"74" & SwapEndian(68, 1) & _                                  ; je 68 bytes
				"68" & SwapEndian(DllStructGetPtr($tDataBuffer, "ON")) & _    ; push string
				"68" & SwapEndian(0) & _                                      ; push wParam
				"68" & SwapEndian(12) & _                                     ; push WM_SETTEXT
				"68" & SwapEndian(GUICtrlGetHandle($hLabelControl)) & _       ; push HANDLE
				"E8" & SwapEndian($pSendMessageW - ($pExecutableCode + 54)) & _    ; call function SendMessageW
				"68" & SwapEndian($hIconON) & _                               ; push hendle to the icon
				"68" & SwapEndian(2) & _                                      ; push IMAGE_ICON
				"68" & SwapEndian(370) & _                                    ; push STM_SETIMAGE
				"68" & SwapEndian(GUICtrlGetHandle($hIconControl)) & _        ; push HANDLE
				"B8" & SwapEndian($pSendMessageW) & _                         ; mov eax, SendMessageW
				"FFD0" & _                                                    ; call eax
				"68" & SwapEndian($iInterval) & _                             ; push Milliseconds
				"E8" & SwapEndian($pSleep - ($pExecutableCode + 91)) & _           ; call function Sleep
				"E9" & SwapEndian(-96) & _                                    ; jump [start address]
				"C3" & _                                                      ; ret
				"68" & SwapEndian(0) & _                                      ; push Reserved
				"68" & SwapEndian(1) & _                                      ; push Flag
				"68" & SwapEndian(DllStructGetPtr($tDataBuffer, "URL2")) & _  ; push URL2 string
				"B8" & SwapEndian($pInternetCheckConnectionW) & _             ; mov eax, InternetCheckConnectionW
				"FFD0" & _                                                    ; call eax
				"3D" & SwapEndian(0) & _                                      ; cmp eax, 00000000
				"74" & SwapEndian(68, 1) & _                                  ; je 68 bytes
				"68" & SwapEndian(DllStructGetPtr($tDataBuffer, "ON")) & _    ; push string
				"68" & SwapEndian(0) & _                                      ; push wParam
				"68" & SwapEndian(12) & _                                     ; push WM_SETTEXT
				"68" & SwapEndian(GUICtrlGetHandle($hLabelControl)) & _       ; push HANDLE
				"E8" & SwapEndian($pSendMessageW - ($pExecutableCode + 151)) & _   ; call function SendMessageW
				"68" & SwapEndian($hIconON) & _                               ; push hendle to the icon
				"68" & SwapEndian(2) & _                                      ; push IMAGE_ICON
				"68" & SwapEndian(370) & _                                    ; push STM_SETIMAGE
				"68" & SwapEndian(GUICtrlGetHandle($hIconControl)) & _        ; push HANDLE
				"B8" & SwapEndian($pSendMessageW) & _                         ; mov eax, SendMessageW
				"FFD0" & _                                                    ; call eax
				"68" & SwapEndian($iInterval) & _                             ; push Milliseconds
				"E8" & SwapEndian($pSleep - ($pExecutableCode + 188)) & _          ; call function Sleep
				"E9" & SwapEndian(-193) & _                                   ; jump [start address]
				"C3" & _                                                      ; ret
				"68" & SwapEndian(DllStructGetPtr($tDataBuffer, "OFF")) & _   ; push string
				"68" & SwapEndian(0) & _                                      ; push wParam
				"68" & SwapEndian(12) & _                                     ; push WM_SETTEXT
				"68" & SwapEndian(GUICtrlGetHandle($hLabelControl)) & _       ; push HANDLE
				"E8" & SwapEndian($pSendMessageW - ($pExecutableCode + 219)) & _   ; call function SendMessageW
				"68" & SwapEndian($hIconOFF) & _                              ; push hendle to the icon
				"68" & SwapEndian(2) & _                                      ; push IMAGE_ICON
				"68" & SwapEndian(370) & _                                    ; push STM_SETIMAGE
				"68" & SwapEndian(GUICtrlGetHandle($hIconControl)) & _        ; push HANDLE
				"B8" & SwapEndian($pSendMessageW) & _                         ; mov eax, SendMessageW
				"FFD0" & _                                                    ; call eax
				"68" & SwapEndian($iInterval) & _                             ; push Milliseconds
				"E8" & SwapEndian($pSleep - ($pExecutableCode + 256)) & _          ; call function Sleep
				"E9" & SwapEndian(-261) & _                                   ; jump [start address]
				"C3" _                                                        ; ret
				)
	EndIf
    ; Make theread to run code in
	Local $aCall = DllCall("kernel32.dll", "handle", "CreateThread", "ptr", 0, "dword_ptr", 0, "ptr", $pExecutableCode, "ptr", 0, "dword", 0, "dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(7, 0, 0)
	Local $hThread = $aCall[0]
    ; Pack output in array
	Local $aOut[5] = [$pDataBuffer, $pExecutableCode, $hThread, $hIconON, $hIconOFF]
    ; Return sucess
	Return $aOut
EndFunc   ;==>_InternetCheckConnectionInAnotherThread


Func SwapEndian($iValue, $iSize = 0)
	If $iSize Then
		Local $sPadd = "00000000"
		Return Hex(BinaryMid($iValue, 1, $iSize)) & StringLeft($sPadd, 2 * ($iSize - BinaryLen($iValue)))
	EndIf
	Return Hex(Binary($iValue))
EndFunc   ;==>SwapEndian


Func _GetIcon($sModule, $iName, $iSize) ; for loaded modules
	Local $aCall = DllCall("kernel32.dll", "handle", "GetModuleHandleW", "wstr", $sModule)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Local $hModule = $aCall[0]
	$aCall = DllCall("user32.dll", "handle", "LoadImageW", _
			"handle", $hModule, _
			"int", $iName, _
			"dword", 1, _ ; IMAGE_ICON
			"int", $iSize, _
			"int", $iSize, _
			"dword", 0) ; LR_DEFAULTCOLOR
	If @error Or Not $aCall[0] Then Return SetError(2, 0, 0)
	Local $hIcon = $aCall[0]
	Return $hIcon
EndFunc   ;==>_GetIcon
