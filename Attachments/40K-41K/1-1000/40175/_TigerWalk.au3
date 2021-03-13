#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Cheetah.ico
#AutoIt3Wrapper_Res_Comment=Child application of CheetahRun. The application does not start in standalone mode
#AutoIt3Wrapper_Res_Description=Tiger Walk
#AutoIt3Wrapper_Res_Fileversion=1.0.1.0
#AutoIt3Wrapper_Res_LegalCopyright=GreenCan
#AutoIt3Wrapper_AU3Check_Parameters=-w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include "GIFAnimation.au3"
#Include <Misc.au3>
#include <Array.au3>

#cs
By GreenCan

Child application of CheetahRun.au3
The application starts with arguments that are pointers shared with the main application
The application does not start in standalone mode
#ce

;~ _ArrayDisplay($CmdLine)
;~ MsgBox(0,"",@ScriptLineNumber & " " & @ScriptName & " $PID: " & $CmdLine[1] & " $Pointer1: " & $CmdLine[2] & " $Pointer2:" & $CmdLine[3] )

If $CmdLine[0] <> 3 Then Exit ; require PID, pointer1 and pointer2

TraySetState(2)

Global $PID = $CmdLine[1]
Global $Pointer1 = $CmdLine[2] ; Hold
Global $Pointer2 = $CmdLine[3] ; NoPause

#===============================================================
; If $bConsole is True, will start console for debugging purpose
Global $bConsole = False
#===============================================================

If $bConsole Then Cout(@ScriptLineNumber & " " & @ScriptName & " $PID: " & $PID & " $Pointer1: " & $Pointer1 & " $Pointer2:" & $Pointer2 & @LF & @LF)

Global $sTempFolder = @TempDir & "\GIFS"
DirCreate($sTempFolder)
Global $Images[2] = [ _
	"TigerWalk_L2R.gif", _
	"TigerWalk_R2L.gif" _
	]
Global $StaticImages[2] = [ _
	"TigerSits_L2R.gif", _
	"SleepingTiger.gif" _
	]
For $i = 0 to UBound($Images) -1
	If Not FileExists($sTempFolder & "\" & $Images[$i]) Then
	    TrayTip("Download " & $Images[$i], "Please wait...", 0)
	    InetGet("http://users.telenet.be/GreenCan/AutoIt/Images/" & $Images[$i], $sTempFolder & "\" & $Images[$i])
	    TrayTip("", "", 0)
	EndIf
	If Not FileExists($sTempFolder & "\" & $Images[$i]) Then MsgBox(262192, "Download",  $Images[$i] & " Download failed!")
Next
For $i = 0 to UBound($StaticImages) -1
	If Not FileExists($sTempFolder & "\" & $StaticImages[$i]) Then
	    TrayTip("Download " & $StaticImages[$i], "Please wait...", 0)
	    InetGet("http://users.telenet.be/GreenCan/AutoIt/Images/" & $StaticImages[$i], $sTempFolder & "\" & $StaticImages[$i])
	    TrayTip("", "", 0)
	EndIf
	If Not FileExists($sTempFolder & "\" & $StaticImages[$i]) Then MsgBox(262192, "Download",  $StaticImages[$i] & " Download failed!")
Next

Global $SM_VIRTUALWIDTH = 78
Global $VirtualDesktopWidth = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALWIDTH)
$VirtualDesktopWidth = $VirtualDesktopWidth[0]

Global $sFile = $sTempFolder & "\" & $Images[0]
; Get dimension of the GIF
Global $aGIFDimension = _GIF_GetDimension($sFile)

; Make GUI
; remember current active GUI
Global $LastActive = WinActive("[ACTIVE]")
Global $hGui = GUICreate("Tiger Animation", $aGIFDimension[0], $aGIFDimension[1], -1000, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))

; GIF job
Global $hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)

; Make GUI transparent
GUISetBkColor(345) ; some random color
_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
_WinAPI_SetParent($hGui, 0)

; Show it
GUISetState()
If $LastActive <> 0 Then WinActivate($LastActive)

Global $fh = -500, $iHoldFL = 0, $bDown = 1, $iImage = 0, $fv = Random(30,@DesktopHeight - 115,1), $PauseValue,  $ReleaseValue, _
	$hUserDll = DllOpen("user32.dll"), $NoPauseValue
; Loop till end
While 1
	; if the mother application is PAUSING, then the value will be set to -2
	$PauseValue =  Read_Memory($PID, $Pointer1, "int")
	If $PauseValue = -2 Then
		; show sitting Tiger
		$fh += 48
;~ 		$fv += 0
		If $iImage = 0 Then
			$sFile = $sTempFolder & "\" & $StaticImages[0]
		Else
			$sFile = $sTempFolder & "\" & $StaticImages[1]
		EndIf
		; delete current gif
		_GIF_DeleteGIF($hGIF)
		; Get dimension of the GIF
		$aGIFDimension = _GIF_GetDimension($sFile)
		; move GUI to avoid transparent glitch
		WinMove($hGUI,"", -1000, $fv, $aGIFDimension[0], $aGIFDimension[1])
		; New GIF
		$hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
		; Make GUI transparent
		GUISetBkColor(345) ; some random color
		_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
		_WinAPI_SetParent($hGui, 0)
		; Show it
		WinMove($hGUI,"", $fh, $fv, $aGIFDimension[0], $aGIFDimension[1])
		GUISetState()
		; now wait until pointer changes to -1, release value
		While 2
			$ReleaseValue =  Read_Memory($PID, $Pointer1, "int")
			If $ReleaseValue = -1 Then ExitLoop
		WEnd
		; continue with running Tiger
;~ 		$fh += 0
;~ 		$fv += 0
		$sFile = $sTempFolder & "\" & $Images[$iImage]
		; delete current gif
		_GIF_DeleteGIF($hGIF)
		; Get dimension of the GIF
		$aGIFDimension = _GIF_GetDimension($sFile)
		; move GUI to avoid transparent glitch
		WinMove($hGUI,"", -1000, $fv, $aGIFDimension[0], $aGIFDimension[1])
		; New GIF
		$hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
		; Make GUI transparent
		GUISetBkColor(345) ; some random color
		_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
		_WinAPI_SetParent($hGui, 0)
		; Show it
		WinMove($hGUI,"", $fh, $fv, $aGIFDimension[0], $aGIFDimension[1])
		GUISetState()

	EndIf
	If $iImage = 0 Then
		$fh += 1.2
		$Captured = Captured() ; verify if Tiger captured

		If $Captured Then
			; show sitting Tiger
;~ 			$fh += 0
			$fv -= 60
			$sFile = $sTempFolder & "\" & $StaticImages[0]
			; delete current gif
			_GIF_DeleteGIF($hGIF)
			; Get dimension of the GIF
			$aGIFDimension = _GIF_GetDimension($sFile)
			; move GUI to avoid transparent glitch
			WinMove($hGUI,"", -1000, $fv, $aGIFDimension[0], $aGIFDimension[1])
			; New GIF
			$hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
			; Make GUI transparent
			GUISetBkColor(345) ; some random color
			_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
			_WinAPI_SetParent($hGui, 0)
			; Show it
			WinMove($hGUI,"", $fh, $fv, $aGIFDimension[0], $aGIFDimension[1])
			GUISetState()
			Release() ; Tiger is mobilized, wait until released
			; continue with walking Tiger
;~ 			$fh += 0
;~ 			$fv += 0
			$sFile = $sTempFolder & "\" & $Images[$iImage]
			; delete current gif
			_GIF_DeleteGIF($hGIF)
			; Get dimension of the GIF
			$aGIFDimension = _GIF_GetDimension($sFile)
			; move GUI to avoid transparent glitch
			WinMove($hGUI,"", -1000, $fv, $aGIFDimension[0], $aGIFDimension[1])
			; New GIF
			$hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
			; Make GUI transparent
			GUISetBkColor(345) ; some random color
			_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
			_WinAPI_SetParent($hGui, 0)
			; Show it
			WinMove($hGUI,"", $fh, $fv, $aGIFDimension[0], $aGIFDimension[1])
			GUISetState()
		EndIf

	Else
		$fh -= 1.2

		$Captured = Captured() ; verify if Tiger captured

		If $Captured Then
			; show sleeping Tiger
			$fh -= 24
			$fv -= 20
			$sFile = $sTempFolder & "\" & $StaticImages[1]
			; delete current gif
			_GIF_DeleteGIF($hGIF)
			; Get dimension of the GIF
			$aGIFDimension = _GIF_GetDimension($sFile)
			; move GUI to avoid transparent glitch
			WinMove($hGUI,"", -1000, $fv, $aGIFDimension[0], $aGIFDimension[1])
			; New GIF
			$hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
			; Make GUI transparent
			GUISetBkColor(345) ; some random color
			_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
			_WinAPI_SetParent($hGui, 0)
			; Show it

			WinMove($hGUI,"", $fh, $fv, $aGIFDimension[0], $aGIFDimension[1])
			GUISetState()
			Release() ; Tiger is mobilized, wait until released
			; continue with walking Tiger
			$fh -= 20
			$fv -= 62
			$sFile = $sTempFolder & "\" & $Images[$iImage]
			; delete current gif
			_GIF_DeleteGIF($hGIF)
			; Get dimension of the GIF
			$aGIFDimension = _GIF_GetDimension($sFile)
			; move GUI to avoid transparent glitch
			WinMove($hGUI,"", -1000, $fv, $aGIFDimension[0], $aGIFDimension[1])
			; New GIF
			$hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
			; Make GUI transparent
			GUISetBkColor(345) ; some random color
			_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
			_WinAPI_SetParent($hGui, 0)
			; Show it
			WinMove($hGUI,"", $fh, $fv, $aGIFDimension[0], $aGIFDimension[1])
			GUISetState()
		EndIf

	EndIf
	Sleep(1)

	If ($iImage = 0 And $fh > $VirtualDesktopWidth+50 Or $fv >@DesktopHeight+50) Or ($iImage = 1 And $fh < -500 Or $fv >@DesktopHeight+50) Then
		$iImage += 1
		If $iImage > UBound($Images)-1 Then $iImage = 0

		If $iImage = 0 Then
			$fh = - 500
		Else
			$fh = $VirtualDesktopWidth + 500
		EndIf
		$fv = Random(30,@DesktopHeight - 115,1)

		$sFile = $sTempFolder & "\" & $Images[$iImage]
		; delete current gif
		_GIF_DeleteGIF($hGIF)
		; Get dimension of the GIF
		$aGIFDimension = _GIF_GetDimension($sFile)
		; New GIF
		$hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)

		; Make GUI transparent
		GUISetBkColor(345) ; some random color
		_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
		_WinAPI_SetParent($hGui, 0)
		_ReduceMemory()
		; if the mother application is in NoPause mode, the the value will be set to -2 and skip pausing
		$NoPauseValue =  Read_Memory($PID, $Pointer2, "int")
		If $NoPauseValue <> -2 Then
			; sleep between 0.1 and 50 seconds, but check for exit
			For $i = 1 to Random(1,500,1)
				Sleep(100)
			Next
		EndIf
		; Show it
		GUISetState()

	EndIf
	WinMove($hGUI,"", $fh, $fv)
WEnd

#FUNCTION# ==============================================================
Func Captured()
	; Capture
	If _IsPressed("01", $hUserDll) Then
		$MousePos = MouseGetPos()
		If $MousePos[0] > $fh And $MousePos[0] < $fh + $aGIFDimension[0] And $MousePos[1] > $fV And $MousePos[1] < $fV + $aGIFDimension[1] Then
			If $bConsole Then cout(@ScriptLineNumber & " Pos[0]:" & $MousePos[0] & " Pos[1]:" & $MousePos[1] & " $fh:" & $fh & " $fv:" & $fv &  " " & _
				$fh + $aGIFDimension[0] & " " & $fv + $aGIFDimension[1] & " captured" )
			Write_Memory($PID, $Pointer1, 35) ; communicate the Hold value to the mother application START OF Hold, cannot be -2 because this is the Hold command for the child application
			; object drag intercept, reposition the object by draging
			While _IsPressed("01", $hUserDll)
				$MousePos = MouseGetPos()
				$fh = $MousePos[0]
				$fV = $MousePos[1]
				WinMove($hGUI,"", $fh -100, $fv - 60, $aGIFDimension[0], $aGIFDimension[1])
			WEnd
			Return True
		EndIf
	EndIf
	Return False
EndFunc ;==>Captured
#FUNCTION# ==============================================================
Func Release()
	; release object in standby
	_ReduceMemory()
	While 2
		If _IsPressed("01", $hUserDll) Then
			$MousePos = MouseGetPos()
			If $MousePos[0] > $fh And $MousePos[0] < $fh + $aGIFDimension[0] And $MousePos[1] > $fV And $MousePos[1] < $fV + $aGIFDimension[1] Then ExitLoop
		EndIf
		Sleep(200)
	WEnd
	; now wait until mouse key released before continuing
	While 2
		If _IsPressed("01",$hUserDll) = 0 Then ExitLoop
		Sleep(100)
	WEnd
	Write_Memory($PID, $Pointer1, 0) ; communicate the Hold value to the mother application END OF Hold
	$Captured = False
	Return
EndFunc ;==>Release()
#FUNCTION# ==============================================================
Func _ReduceMemory()
	Local $dll_mem = DllOpen(@SystemDir & "\psapi.dll")
	Local $ai_Return = DllCall($dll_mem, 'int', 'EmptyWorkingSet', 'long', -1)
	If @error Then Return SetError(@error, @error, 1)
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory
#FUNCTION# ==============================================================
#region _Memory
Func Write_Memory($_PID, $_Pointer, $_Value, $_VarType = "int")
	; This function will replace a value in memory, allocated to the calling application
    Local $DllHandle = _MemoryOpen($_PID) ; Open the memory allocated by the PID from the calling application
	If $bConsole Then Cout(@ScriptLineNumber & " " & @ScriptName & " _MemoryOpen: @error: " & @error & @LF & @LF)
    _MemoryWrite($_Pointer, $DllHandle, $_Value, $_VarType) ; Write the new value at the Pointer address
	If @error > 1 Then beep(1000,1000) ; just ring the bell if unable to write
	If $bConsole Then
		Cout(@ScriptLineNumber & " " & @ScriptName & " _MemoryWrite: @error: " & @error & " $_Pointer:" & $_Pointer & " $_Value:" & $_Value & " $_VarType:" & $_VarType & @LF & @LF)
		Local $test = Read_Memory($PID, $_Pointer)
		Cout(@ScriptLineNumber & " " & @ScriptName & " Read_Memory: @error: " & @error & " $_Pointer:" & $_Pointer & " $test:" & $test & @LF & @LF)
	EndIf
    _MemoryClose($DllHandle) ; Close the Handle
EndFunc ;==>Write_Memory

#FUNCTION# ==============================================================
Func Read_Memory($_PID, $_Pointer, $_VarType = "int")
	; This function will read a value in memory, allocated by the calling application ToolbarAG.exe
    Local $DllHandle = _MemoryOpen($_PID) ; Open the memory allocated by the PID from the calling application
    Local $Data = _MemoryRead($_Pointer, $DllHandle , $_VarType) ; read value passed by the mother application
	If @Error Then
		_MemoryClose($DllHandle) ; Close the Handle
		Return ""
	Else
		_MemoryClose($DllHandle) ; Close the Handle
		Return $Data
	EndIf
EndFunc ;==>Read_Memory
#FUNCTION# ==============================================================
Func Cout($a = "")
	ConsoleWrite($a & @LF & @LF)
EndFunc
#FUNCTION# ==============================================================
;=================================================================================================
; AutoIt Version:   3.1.127 (beta)
; Language:   English
; Platform:   All Windows
; Author:         Nomad
; Requirements:  These functions will only work with beta.
;=================================================================================================
; Credits:  wOuter - These functions are based on his original _Mem() functions.  But they are
;         easier to comprehend and more reliable.  These functions are in no way a direct copy
;         of his functions.  His functions only provided a foundation from which these evolved.
;=================================================================================================
;
; Functions:
;
;=================================================================================================
; Function:   _MemoryOpen($iv_Pid[, $iv_DesiredAccess[, $iv_InheritHandle]])
; Description:    Opens a process and enables all possible access rights to the process.  The
;               Process ID of the process is used to specify which process to open.  You must
;               call this function before calling _MemoryClose(), _MemoryRead(), or _MemoryWrite().
; Parameter(s):  $iv_Pid - The Process ID of the program you want to open.
;               $iv_DesiredAccess - (optional) Set to 0x1F0FFF by default, which enables all
;                              possible access rights to the process specified by the
;                              Process ID.
;               $if_InheritHandle - (optional) If this value is TRUE, all processes created by
;                              this process will inherit the access handle.  Set to TRUE
;                              (1) by default.  Set to 0 if you want it to be FALSE.
; Requirement(s):   A valid process ID.
; Return Value(s):  On Success - Returns an array containing the Dll handle and an open handle to
;                         the specified process.
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = Invalid $iv_Pid.
;                      2 = Failed to open Kernel32.dll.
;                      3 = Failed to open the specified process.
; Author(s):        Nomad
; Note(s):
;=================================================================================================
Func _MemoryOpen($iv_Pid, $iv_DesiredAccess = 0x1F0FFF, $if_InheritHandle = 1)

    If Not ProcessExists($iv_Pid) Then
        SetError(1)
        Return 0
    EndIf

    Local $ah_Handle[2] = [DllOpen('kernel32.dll')]

    If @Error Then
        SetError(2)
        Return 0
    EndIf

    Local $av_OpenProcess = DllCall($ah_Handle[0], 'int', 'OpenProcess', 'int', $iv_DesiredAccess, 'int', $if_InheritHandle, 'int', $iv_Pid)

    If @Error Then
        DllClose($ah_Handle[0])
        SetError(3)
        Return 0
    EndIf

    $ah_Handle[1] = $av_OpenProcess[0]

    Return $ah_Handle

EndFunc ;==>_MemoryOpen

;=================================================================================================
; Function:   _MemoryRead($iv_Address, $ah_Handle[, $sv_Type])
; Description:    Reads the value located in the memory address specified.
; Parameter(s):  $iv_Address - The memory address you want to read from. It must be in hex
;                          format (0x00000000).
;               $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
;               $sv_Type - (optional) The "Type" of value you intend to read.  This is set to
;                        'dword'(32bit(4byte) signed integer) by default.  See the help file
;                        for DllStructCreate for all types.
;                        An example: If you want to read a word that is 15 characters in
;                        length, you would use 'char[16]'.
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns the value located at the specified address.
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = Invalid $ah_Handle.
;                      2 = $sv_Type was not a string.
;                      3 = $sv_Type is an unknown data type.
;                      4 = Failed to allocate the memory needed for the DllStructure.
;                      5 = Error allocating memory for $sv_Type.
;                      6 = Failed to read from the specified process.
; Author(s):        Nomad
; Note(s):      Values returned are in Decimal format, unless specified as a 'char' type, then
;               they are returned in ASCII format.  Also note that size ('char[size]') for all
;               'char' types should be 1 greater than the actual size.
;=================================================================================================
Func _MemoryRead($iv_Address, $ah_Handle, $sv_Type = 'dword')

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    Local $v_Buffer = DllStructCreate($sv_Type)

    If @Error Then
        SetError(@Error + 1)
        Return 0
    EndIf

    DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')

    If Not @Error Then
        Local $v_Value = DllStructGetData($v_Buffer, 1)
        Return $v_Value
    Else
        SetError(6)
        Return 0
    EndIf

EndFunc

;=================================================================================================
; Function:   _MemoryWrite($iv_Address, $ah_Handle, $v_Data[, $sv_Type])
; Description:    Writes data to the specified memory address.
; Parameter(s):  $iv_Address - The memory address you want to write to.  It must be in hex
;                          format (0x00000000).
;               $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
;               $v_Data - The data to be written.
;               $sv_Type - (optional) The "Type" of value you intend to write.  This is set to
;                        'dword'(32bit(4byte) signed integer) by default.  See the help file
;                        for DllStructCreate for all types.
;                        An example: If you want to write a word that is 15 characters in
;                        length, you would use 'char[16]'.
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns 1
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = Invalid $ah_Handle.
;                      2 = $sv_Type was not a string.
;                      3 = $sv_Type is an unknown data type.
;                      4 = Failed to allocate the memory needed for the DllStructure.
;                      5 = Error allocating memory for $sv_Type.
;                      6 = $v_Data is not in the proper format to be used with the "Type"
;                         selected for $sv_Type, or it is out of range.
;                      7 = Failed to write to the specified process.
; Author(s):        Nomad
; Note(s):      Values sent must be in Decimal format, unless specified as a 'char' type, then
;               they must be in ASCII format.  Also note that size ('char[size]') for all
;               'char' types should be 1 greater than the actual size.
;=================================================================================================
Func _MemoryWrite($iv_Address, $ah_Handle, $v_Data, $sv_Type = 'dword')

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    Local $v_Buffer = DllStructCreate($sv_Type)

    If @Error Then
        SetError(@Error + 1)
        Return 0
    Else
        DllStructSetData($v_Buffer, 1, $v_Data)
        If @Error Then
            SetError(6)
            Return 0
        EndIf
    EndIf

    DllCall($ah_Handle[0], 'int', 'WriteProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')

    If Not @Error Then
        Return 1
    Else
        SetError(7)
        Return 0
    EndIf

EndFunc

;=================================================================================================
; Function:   _MemoryClose($ah_Handle)
; Description:    Closes the process handle opened by using _MemoryOpen().
; Parameter(s):  $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns 1
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = Invalid $ah_Handle.
;                      2 = Unable to close the process handle.
; Author(s):        Nomad
; Note(s):
;=================================================================================================
Func _MemoryClose($ah_Handle)

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    DllCall($ah_Handle[0], 'int', 'CloseHandle', 'int', $ah_Handle[1])
    If Not @Error Then
        DllClose($ah_Handle[0])
        Return 1
    Else
        DllClose($ah_Handle[0])
        SetError(2)
        Return 0
    EndIf

EndFunc

;=================================================================================================
; Function:   _MemoryPointerRead ($iv_Address, $ah_Handle, $av_Offset[, $sv_Type])
; Description:    Reads a chain of pointers and returns an array containing the destination
;               address and the data at the address.
; Parameter(s):  $iv_Address - The static memory address you want to start at. It must be in
;                          hex format (0x00000000).
;               $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
;               $av_Offset - An array of offsets for the pointers.  Each pointer must have an
;                         offset.  If there is no offset for a pointer, enter 0 for that
;                         array dimension.
;               $sv_Type - (optional) The "Type" of data you intend to read at the destination
;                         address.  This is set to 'dword'(32bit(4byte) signed integer) by
;                         default.  See the help file for DllStructCreate for all types.
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns an array containing the destination address and the value
;                         located at the address.
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = $av_Offset is not an array.
;                      2 = Invalid $ah_Handle.
;                      3 = $sv_Type is not a string.
;                      4 = $sv_Type is an unknown data type.
;                      5 = Failed to allocate the memory needed for the DllStructure.
;                      6 = Error allocating memory for $sv_Type.
;                      7 = Failed to read from the specified process.
; Author(s):        Nomad
; Note(s):      Values returned are in Decimal format, unless a 'char' type is selected.
;               Set $av_Offset like this:
;               $av_Offset[0] = NULL (not used)
;               $av_Offset[1] = Offset for pointer 1 (all offsets must be in Decimal)
;               $av_Offset[2] = Offset for pointer 2
;               etc...
;               (The number of array dimensions determines the number of pointers)
;=================================================================================================
Func _MemoryPointerRead ($iv_Address, $ah_Handle, $av_Offset, $sv_Type = 'dword')

    If IsArray($av_Offset) Then
        If IsArray($ah_Handle) Then
            Local $iv_PointerCount = UBound($av_Offset) - 1
        Else
            SetError(2)
            Return 0
        EndIf
    Else
        SetError(1)
        Return 0
    EndIf

    Local $iv_Data[2], $i
    Local $v_Buffer = DllStructCreate('dword')

    For $i = 0 to $iv_PointerCount

        If $i = $iv_PointerCount Then
            $v_Buffer = DllStructCreate($sv_Type)
            If @Error Then
                SetError(@Error + 2)
                Return 0
            EndIf

            $iv_Address = '0x' & hex($iv_Data[1] + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(7)
                Return 0
            EndIf

            $iv_Data[1] = DllStructGetData($v_Buffer, 1)

        ElseIf $i = 0 Then
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(7)
                Return 0
            EndIf

            $iv_Data[1] = DllStructGetData($v_Buffer, 1)

        Else
            $iv_Address = '0x' & hex($iv_Data[1] + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(7)
                Return 0
            EndIf

            $iv_Data[1] = DllStructGetData($v_Buffer, 1)

        EndIf

    Next

    $iv_Data[0] = $iv_Address

    Return $iv_Data

EndFunc

;=================================================================================================
; Function:   _MemoryPointerWrite ($iv_Address, $ah_Handle, $av_Offset, $v_Data[, $sv_Type])
; Description:    Reads a chain of pointers and writes the data to the destination address.
; Parameter(s):  $iv_Address - The static memory address you want to start at. It must be in
;                          hex format (0x00000000).
;               $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
;               $av_Offset - An array of offsets for the pointers.  Each pointer must have an
;                         offset.  If there is no offset for a pointer, enter 0 for that
;                         array dimension.
;               $v_Data - The data to be written.
;               $sv_Type - (optional) The "Type" of data you intend to write at the destination
;                         address.  This is set to 'dword'(32bit(4byte) signed integer) by
;                         default.  See the help file for DllStructCreate for all types.
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns the destination address.
;               On Failure - Returns 0.
;               @Error - 0 = No error.
;                      1 = $av_Offset is not an array.
;                      2 = Invalid $ah_Handle.
;                      3 = Failed to read from the specified process.
;                      4 = $sv_Type is not a string.
;                      5 = $sv_Type is an unknown data type.
;                      6 = Failed to allocate the memory needed for the DllStructure.
;                      7 = Error allocating memory for $sv_Type.
;                      8 = $v_Data is not in the proper format to be used with the
;                         "Type" selected for $sv_Type, or it is out of range.
;                      9 = Failed to write to the specified process.
; Author(s):        Nomad
; Note(s):      Data written is in Decimal format, unless a 'char' type is selected.
;               Set $av_Offset like this:
;               $av_Offset[0] = NULL (not used, doesn't matter what's entered)
;               $av_Offset[1] = Offset for pointer 1 (all offsets must be in Decimal)
;               $av_Offset[2] = Offset for pointer 2
;               etc...
;               (The number of array dimensions determines the number of pointers)
;=================================================================================================
Func _MemoryPointerWrite ($iv_Address, $ah_Handle, $av_Offset, $v_Data, $sv_Type = 'dword')

    If IsArray($av_Offset) Then
        If IsArray($ah_Handle) Then
            Local $iv_PointerCount = UBound($av_Offset) - 1
        Else
            SetError(2)
            Return 0
        EndIf
    Else
        SetError(1)
        Return 0
    EndIf

    Local $iv_StructData, $i
    Local $v_Buffer = DllStructCreate('dword')

    For $i = 0 to $iv_PointerCount
        If $i = $iv_PointerCount Then
            $v_Buffer = DllStructCreate($sv_Type)
            If @Error Then
                SetError(@Error + 3)
                Return 0
            EndIf

            DllStructSetData($v_Buffer, 1, $v_Data)
            If @Error Then
                SetError(8)
                Return 0
            EndIf

            $iv_Address = '0x' & hex($iv_StructData + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'WriteProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(9)
                Return 0
            Else
                Return $iv_Address
            EndIf
        ElseIf $i = 0 Then
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(3)
                Return 0
            EndIf

            $iv_StructData = DllStructGetData($v_Buffer, 1)

        Else
            $iv_Address = '0x' & hex($iv_StructData + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(3)
                Return 0
            EndIf

            $iv_StructData = DllStructGetData($v_Buffer, 1)

        EndIf
    Next

EndFunc
#endregion _Memory
