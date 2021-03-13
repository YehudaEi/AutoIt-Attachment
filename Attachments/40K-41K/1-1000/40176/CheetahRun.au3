#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Cheetah.ico
#AutoIt3Wrapper_Res_Description=Cheetah Run
#AutoIt3Wrapper_Res_Fileversion=1.0.1.0
#AutoIt3Wrapper_Res_LegalCopyright=GreenCan
#AutoIt3Wrapper_AU3Check_Parameters=-w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include "GIFAnimation.au3"
#Include <Misc.au3>
;#include <Console.au3>
#cs
By GreenCan

The demo is a composite of 2 scripts
CheetahRun.au3 and _TigerWalk.au3
The application starts the child process with arguments that are pointers shared with the main application

Purpose:
A Cheetah and a tiger run, walk rest on the screen.
Capture the animals by clcking with your left mouse button on it.
As soon as a capture occured, the other application (mother or child) will go in Hold mode too
Click on the captured object and both processes will restart

Two important settings:
- If $bNoPause is True, the pause between animal appearing will randomly increase
	Global $bNoPause = True
- run _TigerWalk.au3 instead of compiled _TigerWalk.exe
	Global $b_TigerWalk_au3 = True

#ce

If @OSBuild < 6000 Then Exit MsgBox(48, "Error", "Cheetah Run can run on Operating System Vista or higher only")
If _Singleton(@ScriptName, 1) = 0 Then Exit

Opt("MustDeclareVars", 1)
Opt("TrayMenuMode", 3)
TraySetToolTip("Cheetah Run")
Global $iExit = TrayCreateItem("Exit")
TraySetState()
TrayTip("Quit", "Exit via tray menu", 5, 1)

#===============================================================
; If $bNoPause is True, the pause between animal appearing will randomly increase
Global $bNoPause = True
; run _TigerWalk.au3 instead of compiled _TigerWalk.exe
Global $b_TigerWalk_au3 = True
; If $bConsole is True, will start console for debugging purpose
Global $bConsole = True
If Not @Compiled Then $bConsole = False
#===============================================================

; remember current active GUI
Global $LastActive = WinActive("[ACTIVE]")


; use shared variables across applications
;	Create the structure
Global $struct = "int Hold;int NoPause"
Global $Structure=DllStructCreate($struct)
If @error Then Exit MsgBox(48,"Error","Error in DllStructCreate " & @error);

; get 2 pointer
Global $Pointer1 = DllStructGetPtr($Structure,"Hold") ; Returns the pointer for the Hold feature
Global $Pointer2 = DllStructGetPtr($Structure,"NoPause") ; Returns the pointer for the NoPause feature

;  Start the client application with 3 parameters:
;	the PID of the calling program (this example)
;   1 pointer for sharing variable for the Hold command
;   1 pointer for sharing variable for the NoPause command

If $bNoPause Then DllStructSetData($Structure,"NoPause",-2) ; NoPause value for child application

; keep pointer1 value for later comparison
Global $Keep_Pointer1 = DllStructGetData($Structure,"Hold") ; Pick up the Hold value from the child application's shared memory

If $bConsole Then Cout(@ScriptLineNumber & " " & @ScriptName & " @AutoItPID:" & @AutoItPID & " $Pointer1 (Hold) :" & $Pointer1 & " $Keep_Pointer1 (Hold) :" & $Keep_Pointer1 & " $Pointer2 (NoPause) :" & $Pointer2)

Global $sTempFolder = @TempDir & "\GIFS", $Pid, $sTiger
DirCreate($sTempFolder)

If $b_TigerWalk_au3 Then
	$sTiger = "_TigerWalk.au3"
	If FileExists(@ScriptDir & "\" & $sTiger) Then
		Global $AutoItexePath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir") ; betaInstallDir for beta
		$Pid = Run('"' & $AutoItexePath & '\AutoIt3.exe" "' & @ScriptDir & '\' & $sTiger & '" ' & @AutoItPID  &' ' & $Pointer1 & ' ' & $Pointer2, @ScriptDir)
		If $bConsole Then Cout(@ScriptLineNumber & " " & @ScriptName & " " & $Pid & " : " & '"' & $AutoItexePath & '\AutoIt3.exe" "' & @ScriptDir & '\' & $sTiger & '" ' & @AutoItPID  &' ' & $Pointer1 & ' ' & $Pointer2)

	Else
		MsgBox(48, "Error" , "'" & $sTiger & "' not found" & @CR & "Both scripts should be in the same folder.")
		Exit
	EndIf
Else
	;  _TigerWalk.exe requires parameters
	$sTiger = "_TigerWalk.exe"
	If FileExists(@ScriptDir & "\" & $sTiger) Then
		$Pid = Run('"' & @ScriptDir & '\' & $sTiger & '" ' & @AutoItPID & ' ' & $Pointer1 & ' ' & $Pointer2, @ScriptDir)
		If $bConsole Then Cout(@ScriptLineNumber & " " & @ScriptName & " " & $Pid & " : " & '"' & @ScriptDir & '\' & $sTiger & '" ' & @AutoItPID & ' ' & $Pointer1 & ' ' & $Pointer2)
; 87 CheetahRun.au3 3212 : "C:\Program Files (x86)\AutoIt3\AutoIt3.exe " "C:\Users\Alain\Desktop\GIFAnimation\Cheetah Run with Capture and communication via shared memory\_TigerWalk.au3" "1976" "0x03B80EB0" "0x03B80EB4"

	Else
		MsgBox(48, "Error" , "'" & $sTiger & "' not found" & @CR & "Both files should be in the same folder.")
		Exit
	EndIf
EndIf

Global $Images[4] = [ _
	"CheetahRun2_L2R.GIF", _
	"CheetahRun2_R2L.GIF", _
	"CheetahRun_L2R.GIF", _
	"CheetahRun_R2L.GIF" _
	]
Global $StaticImages[2] = [ _
	"CheetahSits_R2L.GIF", _
	"CheetahSits_L2R.GIF" _
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
; Get dimension of the GIF, first time
Global $aGIFDimension = _GIF_GetDimension($sFile)
; remember current active GUI
$LastActive = WinActive("[ACTIVE]")

; Make GUI
Global $hGui = GUICreate("GIF Animation", $aGIFDimension[0], $aGIFDimension[1], -1000, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))

; GIF job
Global $hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)

; Make GUI transparent
GUISetBkColor(345) ; some random color
_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
_WinAPI_SetParent($hGui, 0)

; Show it
GUISetState()
If $LastActive <> 0 Then WinActivate($LastActive) ; reactivate original GUI

Global $fh = -500, $iHoldFL = 0, $bDown = 1, $iImage = 0, $fv = Random(0,@DesktopHeight - 100,1), _
	$PassStatic1 = False, $PassStatic2 = False, $fhRandom1 = Random(300,$VirtualDesktopWidth - 100,1), $fhRandom2 = Random(100,$VirtualDesktopWidth - 300,1), _
	$MousePos, $hUserDll = DllOpen("user32.dll"), $Captured = False, $NewPointer, $Pause = False

; Loop till end
While 1
    If TrayGetMsg() = $iExit Then Quit()

	; Pick up the Hold value from the child application's shared memory
	$NewPointer = DllStructGetData($Structure,"Hold")
	If $NewPointer <> $Keep_Pointer1 Then
		If $NewPointer = 35 Then
			$Pause = True
		Else
			$Pause = False
		EndIf
		If $bConsole Then Cout(@ScriptLineNumber & " " & @ScriptName & " @AutoItPID:" & @AutoItPID & " $Pause: " & $Pause & " $Pointer1: (Hold) " & $Pointer1 & " $Keep_Pointer1:" & $Keep_Pointer1 & " $NewPointer: (Hold) " & $NewPointer &" @error: " & @error)
		$Keep_Pointer1 = $NewPointer
	EndIf

	If $iImage = 0 Then ; left to right horizontal
		$fh += 15
		$Captured = Captured() ; verify if Cheetah captured
		If $Captured Or $Pause Then
			; show sitting Cheetah
			$fh += 48
			$fv += 12
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
			If Not $Pause Then
				Release() ; Cheetah is mobilized, wait until released
			Else
				WaitReleaseClient() ; Cheetah is mobilized, wait until released by client trigger
			EndIf
			; continue with running Cheetah
			$fh += 0
			$fv += 12
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

	ElseIf $iImage = 1 Then ; right to left horizontal
		$fh -= 15
		$Captured = Captured() ; verify if Cheetah captured
		If $Captured Or $Pause Then
			; show sitting Cheetah
			$fh -= 24
			$fv += 12
			$PassStatic2 = True
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
			If Not $Pause Then
				Release() ; Cheetah is mobilized, wait until released
			Else
				WaitReleaseClient() ; Cheetah is mobilized, wait until released by client trigger
			EndIf
			; continue with running Cheetah
			$fh -= 96; 108
			$fv += 12; 27
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

	ElseIf $iImage = 2 Then ; left to right diagonal
		$fh += 12
		$fv += 3

		$Captured = Captured() ; verify if Cheetah captured

		If $fh > $fhRandom1 and Not $PassStatic1 Or $Captured Or $Pause Then
			; show sitting Cheetah
			$fh += 48
			$fv += 12
			$PassStatic1 = True
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
			If $Captured Then
				Release() ; Cheetah is mobilized, wait until released
			ElseIf  $Pause Then
				WaitReleaseClient() ; Cheetah is mobilized, wait until released by client trigger
			Else
				; pause random between 5 and 10 seconds
				For $i = 1 to Random(50,100,1)
					If TrayGetMsg() = $iExit Then Quit()
					Sleep(100)
				Next
			EndIf
			; continue with running Cheetah
			$fh += 0
			$fv += 12
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

	ElseIf $iImage = 3 Then ; right to left diagonal
		$fh -= 12
		$fv += 3

		$Captured = Captured() ; verify if Cheetah captured

		If $fh < $fhRandom2 and Not $PassStatic2 Or $Captured Or $Pause Then
			; show sitting Cheetah
			$fh -= 24
			$fv += 12
			$PassStatic2 = True
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
			; if Cheetah is mobilized, wait until released
			If $Captured Then
				Release() ; Cheetah is mobilized, wait until released
			ElseIf  $Pause Then
				WaitReleaseClient() ; Cheetah is mobilized, wait until released by client trigger
			Else
				; pause random between 5 and 10 seconds
				For $i = 1 to Random(50,100,1)
					If TrayGetMsg() = $iExit Then Quit()
					Sleep(100)
				Next
			EndIf
			; continue with running Cheetah
			$fh -= 96
			$fv += 12
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
	Sleep(2)

	If ($iImage = 0 Or $iImage = 2 And $fh > $VirtualDesktopWidth+50 Or $fv >@DesktopHeight+50) _
		Or ($iImage = 1 Or $iImage = 3 And $fh < -500 Or $fv >@DesktopHeight+50) Then
		$iImage += 1
		If $iImage > UBound($Images)-1 Then $iImage = 0
		If $iImage = 0 Then
			$fhRandom1 = Random(300,$VirtualDesktopWidth - 100,1)
			$fhRandom2 = Random(100,$VirtualDesktopWidth - 300,1)
			If Random(1,2,1)= 1 Then $PassStatic1 = False ; 2 will not stop cheetah
			If Random(1,2,1)= 1 Then $PassStatic2 = False ; 2 will not stop cheetah
		EndIf

		If $iImage = 0 Then
			$fh = - 500
			$fv = Random(0,@DesktopHeight - 100,1)
		ElseIf $iImage = 1 Then
			$fh = $VirtualDesktopWidth + 500
			$fv = Random(0,@DesktopHeight - 100,1)
		ElseIf $iImage = 2 Then
			$fh = - 500
			$fv = Random(0,200,1)
		Else
			$fh = $VirtualDesktopWidth + 500
			$fv = Random(0,200,1)
		EndIf


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
		; sleep between 0.1 and 100 seconds, but check for exit
		For $i = 1 to Random(1,1000,1)
			If TrayGetMsg() = $iExit Then Quit()
			If $bNoPause Then ExitLoop
			Sleep(100)
		Next
		; Show it
		GUISetState()
		WinMove($hGUI,"", $fh, $fv, $aGIFDimension[0], $aGIFDimension[1])
	Else
		WinMove($hGUI,"", $fh, $fv)
	EndIf
WEnd
#FUNCTION# ==============================================================
Func Captured()
	; Capture
	If _IsPressed("01", $hUserDll) Then
		$MousePos = MouseGetPos()
		If $MousePos[0] > $fh And $MousePos[0] < $fh + $aGIFDimension[0] And $MousePos[1] > $fV And $MousePos[1] < $fV + $aGIFDimension[1] Then
			If $bConsole Then cout(@ScriptLineNumber & " Pos[0]:" & $MousePos[0] & " Pos[1]:" & $MousePos[1] & " $fh:" & $fh & " $fv:" & $fv &  " " & _
				$fh + $aGIFDimension[0] & " " & $fv + $aGIFDimension[1] & " captured" )
			; object drag intercept, reposition the object by draging
			While _IsPressed("01", $hUserDll)
				$MousePos = MouseGetPos()
				$fh = $MousePos[0]
				$fV = $MousePos[1]
				WinMove($hGUI,"", $fh, $fv, $aGIFDimension[0], $aGIFDimension[1])
			WEnd
			DllStructSetData($Structure,"Hold",-2) ; Hold value for child application
			TrayTip("Cheetah Captured", "Press on Cheetah to continue", 5)
			Return True
		EndIf
	EndIf
	Return False
EndFunc ;==>Captured
#FUNCTION# ==============================================================
Func WaitReleaseClient()
	; release object in standby
	_ReduceMemory()
	TrayTip("Tiger Captured", "Press on Tiger to continue", 5)
	While 2
		Sleep(200)
		$NewPointer = DllStructGetData($Structure,"Hold") ; Pick up the Hold value from the child application's shared memory
		If $NewPointer <> $Keep_Pointer1 Then
			$Pause = False
			If $bConsole Then Cout(@ScriptLineNumber & " " & @ScriptName & " @AutoItPID:" & @AutoItPID & " $Pause: " & $Pause & " $Pointer1: (Hold) " & $Pointer1 & " $Keep_Pointer1:" & $Keep_Pointer1 & " $NewPointer: (Hold) " & $NewPointer &" @error: " & @error)
			$Keep_Pointer1 = $NewPointer
			Return
		EndIf
	WEnd
	Return
EndFunc ;==>WaitReleaseClient()
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
	DllStructSetData($Structure,"Hold",-1) ; release value for child application
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
Func Quit()
	ProcessClose ($Pid )
	Exit
EndFunc ;==>Quit
#FUNCTION# ==============================================================
Func Cout($a = "")
	ConsoleWrite($a & @LF & @LF)
EndFunc
#FUNCTION# ==============================================================