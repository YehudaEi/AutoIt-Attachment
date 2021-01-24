#include-once
Opt("MustDeclareVars", 1)
Opt("OnExitFunc", "CallBack_Exit")

;Thanks to piccaso for the CallBack funcs!!!
;(soon i will adapt it to the latest beta's CallBack functions).

; Adjustable values
Global Const $gi_DllCallBack_uiMsg = 0x7FFF ; WM_USER + 0x7BFF
Global Const $gi_DllCallBack_MaxStubs = 64

; Constants for $nOptions
Global Const $_DllCallBack_StdCall = 0
Global Const $_DllCallBack_Cdecl = 1
Global Const $_DllCallBack_Sync = 2
Global Const $_DllCallBack_Subclass = 4
Global Const $_DllCallBack_Struct = 8
Global Const $_DllCallBack_Debug = 1024

; Internaly used
Global Const $gs_DllCallBack_typedef_CriticalSection = "PTR DebugInfo;LONG LockCount;LONG RecursionCount;PTR OwningThread;PTR LockSemaphore;DWORD SpinCount"
Global $gp_DllCallBack_SendMessage = 0
Global $gh_DllCallBack_hUser32 = 0
Global $gi_DllCallBack_StubCount = 0
Global $gp_DllCallBack_EnterCriticalSection = 0
Global $gp_DllCallBack_LeaveCriticalSection = 0
Global $gp_DllCallBack_CallWindowProc = 0
Global $gh_DllCallBack_hWnd = GUICreate("au3_Callback")
Global $gf_DllCallBack_fMsgRegistred = GUIRegisterMsg($gi_DllCallBack_uiMsg, "__DllCallBack_MsgHandler")
Global $ga_DllCallBack_sParameters[$gi_DllCallBack_MaxStubs + 1]
Global $ga_DllCallBack_nParameters[$gi_DllCallBack_MaxStubs + 1]
Global $ga_DllCallBack_sFunctions[$gi_DllCallBack_MaxStubs + 1]
Global $ga_DllCallBack_hGlobals[$gi_DllCallBack_MaxStubs + 1]
Global $ga_DllCallBack_vCriticalSections[$gi_DllCallBack_MaxStubs + 1]
Global $ga_DllCallBack_nOptions[$gi_DllCallBack_MaxStubs + 1]

;GUICtrlSetOnHover Initialize
Global $HOVER_CONTROLS_ARRAY[1][1]
Global $LAST_HOVERED_ELEMENT[2] = [-1, -1]
Global $LAST_HOVERED_ELEMENT_MARK = -1
Global $pTimerProc = _DllCallBack("CALLBACKPROC", "hwnd;uint;uint;dword")
Global $uiTimer = DllCall("user32.dll", "uint", "SetTimer", "hwnd", 0, "uint", 0, "int", 10, "ptr", $pTimerProc)
$uiTimer = $uiTimer[0]

Opt("MustDeclareVars", 0)

Func CALLBACKPROC($hWnd, $uiMsg, $idEvent, $dwTime)
	If UBound($HOVER_CONTROLS_ARRAY)-1 < 1 Then Return
	Local $ControlGetHovered = _ControlGetHovered()
	Local $sCheck_LHE = $LAST_HOVERED_ELEMENT[1]
	
	If $ControlGetHovered = 0 Or ($sCheck_LHE <> -1 And $ControlGetHovered <> $sCheck_LHE) Then
		If $LAST_HOVERED_ELEMENT_MARK = -1 Then Return
		If $LAST_HOVERED_ELEMENT[0] <> -1 Then Call($LAST_HOVERED_ELEMENT[0], $LAST_HOVERED_ELEMENT[1])
		$LAST_HOVERED_ELEMENT[0] = -1
		$LAST_HOVERED_ELEMENT[1] = -1
		$LAST_HOVERED_ELEMENT_MARK = -1
	Else
		For $i = 1 To $HOVER_CONTROLS_ARRAY[0][0]
			If $HOVER_CONTROLS_ARRAY[$i][0] = GUICtrlGetHandle($ControlGetHovered) Then
				If $LAST_HOVERED_ELEMENT_MARK = $HOVER_CONTROLS_ARRAY[$i][0] Then ExitLoop
				$LAST_HOVERED_ELEMENT_MARK = $HOVER_CONTROLS_ARRAY[$i][0]
				Call($HOVER_CONTROLS_ARRAY[$i][1], $ControlGetHovered)
				If $HOVER_CONTROLS_ARRAY[$i][2] <> -1 Then
					$LAST_HOVERED_ELEMENT[0] = $HOVER_CONTROLS_ARRAY[$i][2]
					$LAST_HOVERED_ELEMENT[1] = $ControlGetHovered
				EndIf
				ExitLoop
			EndIf
		Next
	EndIf
EndFunc

Func GUICtrlSetOnHover($CtrlID, $HoverFuncName, $LeaveHoverFuncName=-1)
	Local $Ubound = UBound($HOVER_CONTROLS_ARRAY)
	ReDim $HOVER_CONTROLS_ARRAY[$Ubound+1][3]
	$HOVER_CONTROLS_ARRAY[$Ubound][0] = GUICtrlGetHandle($CtrlID)
	$HOVER_CONTROLS_ARRAY[$Ubound][1] = $HoverFuncName
	$HOVER_CONTROLS_ARRAY[$Ubound][2] = $LeaveHoverFuncName
	$HOVER_CONTROLS_ARRAY[0][0] = $Ubound
EndFunc

;Thanks to amel27 for that one!!!
Func _ControlGetHovered()
    Local $iRet = DllCall("user32.dll", "int", "WindowFromPoint", _
        "long", MouseGetPos(0), _
        "long", MouseGetPos(1))
    $iRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $iRet[0])
    Return $iRet[0]
EndFunc

;===============================================================================
;
; Function Name:   	_DllCallBack
; Description:		Registers a callback function and creates a stub which handles incoming calls.
; Parameter(s):    	$sFunction - Name of callback function
;					$sParameters - DllStruct like parameter definition (only 32 and 64bit datatypes supported)
;					$nOptions, Optional - Can be one or more (add them together) of the folowing constants:
;						$_DllCallBack_StdCall (0)  - Use 'stdcall' calling method (Default)
;						$_DllCallBack_Cdecl (1)    - Use 'cdecl' calling method
;						$_DllCallBack_Sync (2)     - Enable Critical Section (see Remarks)
;                       $_DllCallBack_Subclass (4) - Enable Subclassing (see Remarks)
;						$_DllCallBack_Struct (8)   - Pass the struct to the handler function (see Remarks)
;						$_DllCallBack_Debug (1024) - Enable breakpoint (requires a JIT debugger)
; Requirement(s):
; Return Value(s):	Pointer to created stub or NULL on error
; @error Value(s):	1 = Error allocating memory
;					2 = Error Loading User32.dll or Kernel32.dll
;					3 = Failed to get the address of SendMessage, EnterCriticalSection, LeaveCriticalSection or CallWindowProc
;					4 = Too many callbacks
;					5 = GUIRegisterMsg() Failed
;					6 = $sParameters Fromat wrong
;                   7 = Error calling InitializeCriticalSection
;
; Author(s): 		Florian Fida
; Remarks:			The number of coexistent callback stubs is limited to 64.
;					Windows message WM_USER + 0x7BFF is used by this function.
;
;					If Subclassing is enabled the callback function must not call 'CallWindowProc' itself.
;					If the Function processes the message it should return NULL if not is has to return a Pointer
;					to the previous 'WindowProc' Function.
;
;					Critical sections allow better synchronisation, if a multithreaded library calls
;					the callback function, enable this option.
;
;					Passing the struct requires the callback function to accept one parameter which is the
;                   Struct defined in $sParameters. This allows the modification of the stack.
;
;===============================================================================
;
Func _DllCallBack($sFunction, $sParameters = "", Const $nOptions = 0)
	Local $pSendMessage, $hGlobal, $hUser32, $vStub, $i, $vCriticalSection, $pCallWindowProc
	Local $nParameters, $vParameters, $wParam = -1, $nParameters_struct = -1, $hKernel32
	Local $sStub, $dwStubSize
	If BitAND($_DllCallBack_Debug, $nOptions) Then $sStub = "90909090CC" ; INT3
	If Not $gf_DllCallBack_fMsgRegistred Then Return SetError(5, 0, 0)
	If $sParameters = "" Or $sParameters = Default Then
		$nParameters = 0
	Else
		$vParameters = DllStructCreate($sParameters)
		If @error Then Return SetError(6, 0, 0)
		$nParameters = DllStructGetSize($vParameters) / 4
		If $nParameters <> Int($nParameters) Or @error Then Return SetError(6, 0, 0)
		For $i = 1 To 256
			DllStructGetData($vParameters, $i)
			If @error Then
				$nParameters_struct = $i - 1
				ExitLoop
			EndIf
		Next
		If $nParameters_struct < 0 Then SetError(6, 0, 0)
	EndIf
	For $i = 0 To $gi_DllCallBack_MaxStubs
		If Not $ga_DllCallBack_hGlobals[$i] Then
			$wParam = $i
			ExitLoop
		EndIf
	Next
	If $wParam = -1 Then Return SetError(4, 0, 0)
	If $gh_DllCallBack_hUser32 = 0 Then
		$hUser32 = DllCall("kernel32.dll", "ptr", "LoadLibrary", "str", "user32.dll")
		If @error Then Return SetError(2, 0, 0)
		If $hUser32[0] = 0 Then Return SetError(2, 0, 0)
		$gh_DllCallBack_hUser32 = $hUser32[0]
		$pSendMessage = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $gh_DllCallBack_hUser32, "str", "SendMessage")
		If @error Then Return SetError(3, 0, 0)
		If $pSendMessage[0] = 0 Then
;~ 			If @Unicode Then
				$pSendMessage = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $gh_DllCallBack_hUser32, "str", "SendMessageW")
				If @error Then Return SetError(3, 0, 0)
;~ 			Else
;~ 				$pSendMessage = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $gh_DllCallBack_hUser32, "str", "SendMessageA")
;~ 				If @error Then Return SetError(3, 0, 0)
;~ 			EndIf
		EndIf
		If $pSendMessage[0] = 0 Then Return SetError(3, 0, 0)
		$gp_DllCallBack_SendMessage = $pSendMessage[0]
		$pCallWindowProc = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $gh_DllCallBack_hUser32, "str", "CallWindowProc")
		If @error Then Return SetError(3, 0, 0)
		If $pCallWindowProc[0] = 0 Then
;~ 			If @Unicode Then
				$pCallWindowProc = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $gh_DllCallBack_hUser32, "str", "CallWindowProcW")
				If @error Then Return SetError(3, 0, 0)
;~ 			Else
;~ 				$pCallWindowProc = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $gh_DllCallBack_hUser32, "str", "CallWindowProcA")
;~ 				If @error Then Return SetError(3, 0, 0)
;~ 			EndIf
		EndIf
		If $pCallWindowProc[0] = 0 Then Return SetError(3, 0, 0)
		$gp_DllCallBack_CallWindowProc = $pCallWindowProc[0]
	EndIf
	If Not BitAND($_DllCallBack_Sync, $nOptions) Then ; Critical section disabled
		$vCriticalSection = -1
	Else ; Critical section enabled
		If $gp_DllCallBack_EnterCriticalSection = 0 Or $gp_DllCallBack_LeaveCriticalSection = 0 Then
			; we assume kernel32.dll is allways loaded
			$hKernel32 = DllCall("kernel32.dll", "ptr", "GetModuleHandle", "str", "kernel32.dll")
			If @error Then Return SetError(2, 0, 0)
			If $hKernel32[0] = 0 Then Return SetError(2, 0, 0)
			$gp_DllCallBack_EnterCriticalSection = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $hKernel32[0], "str", "EnterCriticalSection")
			If @error Then Return SetError(3, 0, 0)
			$gp_DllCallBack_EnterCriticalSection = $gp_DllCallBack_EnterCriticalSection[0]
			If $gp_DllCallBack_EnterCriticalSection = 0 Then Return SetError(3, 0, 0)
			$gp_DllCallBack_LeaveCriticalSection = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $hKernel32[0], "str", "LeaveCriticalSection")
			If @error Then Return SetError(3, 0, 0)
			$gp_DllCallBack_LeaveCriticalSection = $gp_DllCallBack_LeaveCriticalSection[0]
			If $gp_DllCallBack_LeaveCriticalSection = 0 Then Return SetError(3, 0, 0)
		EndIf
		$vCriticalSection = DllStructCreate($gs_DllCallBack_typedef_CriticalSection)
		DllCall("kernel32.dll", "none", "InitializeCriticalSection", "ptr", DllStructGetPtr($vCriticalSection))
		If @error Then Return SetError(7, 0, 0)
	EndIf

	If @error Then Return SetError(7, 0, 0)
	#cs
		Options: Critical section, Breakpoint, stdcall - 2 parameters
		
		$ ==>    > CC               INT3                                     ; Breakpoint (for debugging only)
		$+1      > 68 30859B00      PUSH 9B8530                              ; Push LPCRITICAL_SECTION
		$+6      > B8 0510917C      MOV EAX,ntdll.RtlEnterCriticalSection    ; Set address for EnterCriticalSection
		$+B      > FFD0             CALL EAX                                 ; Call EnterCriticalSection
		$+D      > 8D4424 04        LEA EAX,DWORD PTR SS:[ESP+4]             ; Load Pointer to parameters on stack to EAX
		$+11     > 50               PUSH EAX                                 ; Push lParam - Stack Pointer
		$+12     > 68 00000000      PUSH 0                                   ; Push wParam - internal reference to au3 function
		$+17     > 68 FF7F0000      PUSH 7FFF                                ; Push uiMsg - internal identifier for callback
		$+1C     > 68 26063000      PUSH 300626                              ; Push hWnd - Autoit's Callback window
		$+21     > B8 AEE2D177      MOV EAX,USER32.SendMessageA              ; Set address for SendMessage
		$+26     > FFD0             CALL EAX                                 ; Call Sendmessage
		$+28     > 50               PUSH EAX                                 ; Preserve Return value of Callback Function
		$+29     > 68 30859B00      PUSH 9B8530                              ; Push LPCRITICAL_SECTION
		$+2E     > B8 ED10917C      MOV EAX,ntdll.RtlLeaveCriticalSection    ; Set address for LeaveCriticalSection
		$+33     > FFD0             CALL EAX                                 ; Call LeaveCriticalSection
		$+35     > 58               POP EAX                                  ; Restore Return value of Callback Function
		$+36     > C2 0800          RETN 8                                   ; Adjust stack for stdcall and return
		
		
		Options: Default, stdcall - 2 parameters
		
		$ ==>    > 8D4424 04        LEA EAX,DWORD PTR SS:[ESP+4]             ; Load Pointer to parameters on stack to EAX
		$+4      > 50               PUSH EAX                                 ; Push lParam - Stack Pointer
		$+5      > 68 00000000      PUSH 0                                   ; Push wParam - internal reference to au3 function
		$+A      > 68 FF7F0000      PUSH 7FFF                                ; Push uiMsg - internal identifier for callback
		$+F      > 68 C6041700      PUSH 1704C6                              ; Push hWnd - Autoit's Callback window
		$+14     > B8 AEE2D177      MOV EAX,USER32.SendMessageA              ; Set address for SendMessage
		$+19     > FFD0             CALL EAX                                 ; Call Sendmessage
		$+1B     > C2 0800          RETN 8                                   ; Adjust stack for stdcall and return
		
		
		nOptions: Subclassing, stdcall - 4 parameters
		
		$ ==>    > 8D4424 04        LEA EAX,DWORD PTR SS:[ESP+4]             ; Load Pointer to parameters on stack to EAX
		$+4      > 50               PUSH EAX                                 ; Push lParam - Stack Pointer
		$+5      > 68 00000000      PUSH 0                                   ; Push wParam - internal reference to au3 function
		$+A      > 68 FF7F0000      PUSH 7FFF                                ; Push uiMsg - internal identifier for callback
		$+F      > 68 34063100      PUSH 310634                              ; Push hWnd - Autoit's Callback window
		$+14     > B8 62B7D177      MOV EAX,USER32.SendMessageW              ; Set address for SendMessage
		$+19     > FFD0             CALL EAX                                 ; Call Sendmessage
		$+1B     > 83F8 00          CMP EAX,0                                ; Compare EAX and NULL
		$+1E     > 74 1C            JE SHORT <$+3C>                          ; If equal (EAX == NULL) jump down to $+3C (return)
		$+20     > 8B5424 10        MOV EDX,DWORD PTR SS:[ESP+10]            ; Copy lParam from stack to EDX
		$+24     > 52               PUSH EDX                                 ; Push lParam
		$+25     > 8B5424 10        MOV EDX,DWORD PTR SS:[ESP+10]            ; Copy wParam from stack to EDX
		$+29     > 52               PUSH EDX                                 ; Push wParam
		$+2A     > 8B5424 10        MOV EDX,DWORD PTR SS:[ESP+10]            ; Copy uiMsg from stack to EDX
		$+2E     > 52               PUSH EDX                                 ; Push uiMsg
		$+2F     > 8B5424 10        MOV EDX,DWORD PTR SS:[ESP+10]            ; Copy hWnd from stack to EDX
		$+33     > 52               PUSH EDX                                 ; Push hWnd - Subclassed Window
		$+34     > 50               PUSH EAX                                 ; Push lpPrevWndFunc (Returned by SendMessage/Callback Func)
		$+35     > B8 19C0D177      MOV EAX,USER32.CallWindowProcW           ; Set address for CallWindowProc
		$+3A     > FFD0             CALL EAX                                 ; Call CallWindowProc
		$+3C     > C2 1000          RETN 10                                  ; Adjust stack and return
	#ce
	; Note: EAX ECX EDX can be freely modified
	If BitAND($_DllCallBack_Sync, $nOptions) Then ; Critical section
		$sStub &= "68" & __DllCallBack_Endian(DllStructGetPtr($vCriticalSection))
		$sStub &= "B8" & __DllCallBack_Endian($gp_DllCallBack_EnterCriticalSection)
		$sStub &= "FFD0" ; call EnterCriticalSection
	EndIf
	$sStub &= "8D442404" ; load stack poiner into eax
	$sStub &= "50" ; push eax - lparam
	$sStub &= "68" & __DllCallBack_Endian($wParam, "uint")
	$sStub &= "68" & __DllCallBack_Endian($gi_DllCallBack_uiMsg, "uint")
	$sStub &= "68" & __DllCallBack_Endian($gh_DllCallBack_hWnd, "hwnd")
	$sStub &= "B8" & __DllCallBack_Endian($gp_DllCallBack_SendMessage)
	$sStub &= "FFD0" ; call SendMessage
	If BitAND($_DllCallBack_Sync, $nOptions) Then ; Critical section
		$sStub &= "50" ; push eax - to preserve return value of callback function
		$sStub &= "68" & __DllCallBack_Endian(DllStructGetPtr($vCriticalSection))
		$sStub &= "B8" & __DllCallBack_Endian($gp_DllCallBack_LeaveCriticalSection)
		$sStub &= "FFD0" ; call LeaveCriticalSection
		$sStub &= "58" ; pop eax - Retstore return value
	EndIf
	If BitAND($_DllCallBack_Subclass, $nOptions) Then ; Subclassing
		$sStub &= "83F800"; cmp eax,0
		$sStub &= "74" & "1C"; je 0x1c - if eax == 0 jump down 0x1c opcodes (to return)
		$sStub &= "8B5424" & "10" & "52"; mov edx,dword ptr ss:esp+10; push edx - lparam
		$sStub &= "8B5424" & "10" & "52"; mov edx,dword ptr ss:esp+10; push edx - wparam
		$sStub &= "8B5424" & "10" & "52"; mov edx,dword ptr ss:esp+10; push edx - msg
		$sStub &= "8B5424" & "10" & "52"; mov edx,dword ptr ss:esp+10; push edx - hwnd
		$sStub &= "50"; push eax - lpPrevWndFunc
		$sStub &= "B8" & __DllCallBack_Endian($gp_DllCallBack_CallWindowProc) ; Set eax to CallWindowProc
		$sStub &= "FFD0"; call eax
	EndIf
	If BitAND($_DllCallBack_Cdecl, $nOptions) Then
		$sStub &= "C3" ; return near 'cdecl'
	Else
		$sStub &= "C2" & __DllCallBack_Endian($nParameters * 4, "ushort", 2) ; Return near 'stdcall'
	EndIf
	$dwStubSize = StringLen($sStub) / 2
	$hGlobal = DllCall("kernel32.dll", "ptr", "GlobalAlloc", "uint", 0, "dword", $dwStubSize)
	If @error Then Return SetError(1, 0, 0)
	If $hGlobal[0] = 0 Then Return SetError(1, 0, 0)
	$hGlobal = $hGlobal[0]
	$vStub = DllStructCreate("ubyte[" & $dwStubSize & "]", $hGlobal)
	DllStructSetData($vStub, 1, Binary("0x" & $sStub))
	$gi_DllCallBack_StubCount += 1
	$ga_DllCallBack_hGlobals[$wParam] = $hGlobal
	$ga_DllCallBack_sFunctions[$wParam] = $sFunction
	$ga_DllCallBack_sParameters[$wParam] = $sParameters
	$ga_DllCallBack_nParameters[$wParam] = $nParameters_struct
	$ga_DllCallBack_vCriticalSections[$wParam] = $vCriticalSection
	$ga_DllCallBack_nOptions[$wParam] = $nOptions
	Return $hGlobal
EndFunc   ;==>_DllCallBack

;===============================================================================
;
; Function Name:	_DllCallBack_Free
; Description:		Frees memory from global heap allocated by _DllCallBackAlloc
; Parameter(s):    	$hStub - Pointer to stub
; Requirement(s):
; Return Value(s):	On Success: True
;					On Failure: False
; @error Value(s):	1 - Error freeing memory or Invalid handle
;					2 - Error freeing User32.dll
; Author(s):		Florian Fida
;
;===============================================================================
;
Func _DllCallBack_Free(ByRef $hStub)
	Local $aTmp, $i, $fFound = False
	If $hStub > 0 Then
		$aTmp = DllCall("kernel32.dll", "ptr", "GlobalFree", "ptr", $hStub)
		If @error Then Return SetError(1, 0, False)
		If $aTmp[0] = $hStub Then Return SetError(1, 0, False)
		If $aTmp[0] = 0 Then
			For $i = 0 To $gi_DllCallBack_MaxStubs
				If $ga_DllCallBack_hGlobals[$i] = $hStub Then
					If $ga_DllCallBack_vCriticalSections[$i] > 0 Then DllCall("kernel32.dll", "none", "DeleteCriticalSection", "ptr", DllStructGetPtr($ga_DllCallBack_vCriticalSections[$i]))
					$ga_DllCallBack_hGlobals[$i] = 0
					$ga_DllCallBack_sParameters[$i] = 0
					$ga_DllCallBack_nParameters[$i] = 0
					$ga_DllCallBack_sFunctions[$i] = 0
					$ga_DllCallBack_vCriticalSections[$i] = 0
					$fFound = True
					ExitLoop
				EndIf
			Next
			If $fFound = False Then Return SetError(1, 0, False)
			$hStub = 0
			$gi_DllCallBack_StubCount -= 1
			If $gi_DllCallBack_StubCount < 1 Then
				$gi_DllCallBack_StubCount = 0
				$aTmp = DllCall("kernel32.dll", "int", "FreeLibrary", "ptr", $gh_DllCallBack_hUser32)
				If @error Then Return SetError(2, 0, False)
				If $aTmp[0] = 0 Then Return SetError(2, 0, False)
				$gh_DllCallBack_hUser32 = 0
			EndIf
			Return True
		EndIf
		Return False
	EndIf
	Return True
EndFunc   ;==>_DllCallBack_Free

; Internals
Func __DllCallBack_MsgHandler($hWnd_Callback, $uiMsg, $wParam, $lParam)
	Local $vParameters, $i
	If $ga_DllCallBack_nParameters[$wParam] > 0 Then
		$vParameters = DllStructCreate($ga_DllCallBack_sParameters[$wParam], $lParam)
		If BitAND($ga_DllCallBack_nOptions[$wParam], $_DllCallBack_Struct) Then
			Local $aCallArgs[2] = ["CallArgArray", $vParameters]
		Else
			Local $aCallArgs[$ga_DllCallBack_nParameters[$wParam] + 1]
			$aCallArgs[0] = "CallArgArray"
			For $i = 1 To $ga_DllCallBack_nParameters[$wParam]
				$aCallArgs[$i] = DllStructGetData($vParameters, $i)
			Next
		EndIf
		Return Call($ga_DllCallBack_sFunctions[$wParam], $aCallArgs)
	EndIf
	Return Call($ga_DllCallBack_sFunctions[$wParam])
EndFunc   ;==>__DllCallBack_MsgHandler

Func __DllCallBack_Endian($n, $s = "ptr", $bytes = 4) ; Return $bytes bytes from $n as Little Endian Hex String, threat as $s
	Local $a = DllStructCreate($s), $b = DllStructCreate("ubyte[" & $bytes & "]", DllStructGetPtr($a))
	DllStructSetData($a, 1, $n)
	Return StringTrimLeft(DllStructGetData($b, 1), 2)
EndFunc   ;==>__DllCallBack_Endian

Func CallBack_Exit()
	_DllCallBack_Free($pTimerProc)
	DllCall("user32.dll", "int", "KillTimer", "hwnd", 0, "uint", $uiTimer)
EndFunc
