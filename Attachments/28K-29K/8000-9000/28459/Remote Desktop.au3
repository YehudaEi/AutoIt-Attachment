#include <IE.au3>
Global $hGui = GUICreate("AutoITScript.com",380, 160,-1,-1)
Global $hLabel = GUICtrlCreateLabel("", 10, 10, 80, 20)
GUICtrlSetColor(-1, 0x0000CC)
GUICtrlSetFont(-1, 11.5, 600)


$Remote = GUICtrlCreateButton("Remote Desktop",10,50,100,25)
$input = GUICtrlCreateInput("Type your IP",120,50,150,23)
$Button = GUICtrlCreateButton("Ping", 10, 90, 100, 25)
$input = GUICtrlCreateInput("Type your IP",120,90,150,23)

$CLOSE = GUICtrlCreateButton("CLOSE",10,130,100,25)

_ClockThisInAnotherThread($hLabel)


GUISetState()


While 1
	 Switch GUIGetMsg()
        Case - 3
            Exit


		Case $CLOSE
			Send("!{f4}")
	EndSwitch

 WEnd



Func _ClockThisInAnotherThread($hControl)

    ; Get kernel32.dll handle
    Local $aCall = DllCall("kernel32.dll", "ptr", "GetModuleHandleW", "wstr", "kernel32.dll")

    If @error Or Not $aCall[0] Then
        Return SetError(1, 0, 0)
    EndIf

    Local $hHandle = $aCall[0]

    ; Get addresses of functions from kernel32.dll. Sleep first:
    Local $aSleep = DllCall("kernel32.dll", "ptr", "GetProcAddress", _
            "ptr", $hHandle, _
            "str", "Sleep")

    If @error Or Not $aCall[0] Then
        Return SetError(2, 0, 0)
    EndIf

    Local $pSleep = $aSleep[0]

    ; GetTimeFormatW then:
    Local $aGetTimeFormatW = DllCall("kernel32.dll", "ptr", "GetProcAddress", _
            "ptr", $hHandle, _
            "str", "GetTimeFormatW")

    If @error Or Not $aCall[0] Then
        Return SetError(3, 0, 0)
    EndIf

    Local $pGetTimeFormatW = $aGetTimeFormatW[0]

    ; Get user32.dll handle
    $aCall = DllCall("kernel32.dll", "ptr", "GetModuleHandleW", "wstr", "user32.dll")

    If @error Or Not $aCall[0] Then
        Return SetError(4, 0, 0)
    EndIf

    $hHandle = $aCall[0]

    ; Get address of function from user32.dll, SendMessageW:
    Local $aSendMessageW = DllCall("kernel32.dll", "ptr", "GetProcAddress", _
            "ptr", $hHandle, _
            "str", "SendMessageW")

    If @error Or Not $aCall[0] Then
        Return SetError(5, 0, 0)
    EndIf

    Local $pSendMessageW = $aSendMessageW[0]

    ; Allocate enough memory with PAGE_EXECUTE_READWRITE for code to run
    $aCall = DllCall("kernel32.dll", "ptr", "VirtualAlloc", _
            "ptr", 0, _
            "dword", 82, _
            "dword", 4096, _ ; MEM_COMMIT
            "dword", 64) ; PAGE_EXECUTE_READWRITE

    If @error Or Not $aCall[0] Then
        Return SetError(6, 0, 0)
    EndIf

    Local $pRemoteCode = $aCall[0]

    ; Make structure in reserved space
    Local $CodeBuffer = DllStructCreate("byte[82]", $pRemoteCode)

    ; Allocate global memory with PAGE_READWRITE. This can be done with ByRef-ing too.
    $aCall = DllCall("kernel32.dll", "ptr", "VirtualAlloc", _
            "ptr", 0, _
            "dword", 36, _
            "dword", 4096, _ ; MEM_COMMIT
            "dword", 4) ; PAGE_READWRITE

    If @error Or Not $aCall[0] Then
        Return SetError(7, 0, 0)
    EndIf

    Local $pStrings = $aCall[0]

    ; Arrange strings in reserved space
    Local $tSpace = DllStructCreate("wchar Format[9];wchar Result[9]", $pStrings)
    DllStructSetData($tSpace, "Format", "hh:mm:ss")

    ; Write assembly on the fly
    DllStructSetData($CodeBuffer, 1, _
            "0x" & _
            "68" & SwapEndian(9) & _                                           ; push output size
            "68" & SwapEndian(DllStructGetPtr($tSpace, "Result")) & _          ; push pointer to output container
            "68" & SwapEndian(DllStructGetPtr($tSpace, "Format")) & _          ; push pointer to format string
            "68" & SwapEndian(0) & _                                           ; push NULL
            "68" & SwapEndian(4) & _                                           ; push TIME_FORCE24HOURFORMAT
            "68" & SwapEndian(0) & _                                           ; push Locale
            "B8" & SwapEndian($pGetTimeFormatW) & _                            ; mov eax, [$pGetTimeFormatW]
            "FFD0" & _                                                         ; call eax
            "68" & SwapEndian(DllStructGetPtr($tSpace, "Result")) & _          ; push pointer to the result
            "68" & SwapEndian(0) & _                                           ; push wParam
            "68" & SwapEndian(12) & _                                          ; push WM_SETTEXT
            "68" & SwapEndian(GUICtrlGetHandle($hControl)) & _                 ; push HANDLE
            "B8" & SwapEndian($pSendMessageW) & _                              ; mov eax, [$pSendMessageW]
            "FFD0" & _                                                         ; call eax
            "68" & SwapEndian(491) & _                                         ; push Milliseconds
            "B8" & SwapEndian($pSleep) & _                                     ; mov eax, [$pSleep]
            "FFD0" & _                                                         ; call eax
            "E9" & SwapEndian(-81) & _                                         ; jump back 81 bytes (start address)
            "C3" _                                                             ; Ret
            )

    ; Create new thread to execute code in
    $aCall = DllCall("kernel32.dll", "ptr", "CreateThread", _
            "ptr", 0, _
            "dword", 0, _
            "ptr", $pRemoteCode, _
            "ptr", 0, _
            "dword", 0, _
            "dword*", 0)

    If @error Or Not $aCall[0] Then
        Return SetError(8, 0, 0)
    EndIf

    Local $hThread = $aCall[0]

    ; Return thread handle
    Return $hThread

EndFunc   ;==>_ClockThisInAnotherThread


Func SwapEndian($iValue)
   Return Hex(BinaryMid($iValue, 1, 4))
EndFunc   ;==>SwapEndian
