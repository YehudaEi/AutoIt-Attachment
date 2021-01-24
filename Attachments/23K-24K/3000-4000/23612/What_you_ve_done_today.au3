#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\ICON\SHELL32\027_shell32.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Description=d3mon Corporation
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=d3mon Corporation. All rights reserved
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Constants.au3>
#include <DllCallBack.au3>
#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <Constants.au3>
#include <GUIButton.au3>

;================================================================================
;#  Title .........: What you've done today.au3									#
;#  Description ...: Count everything or almost :D								#
;#  Date ..........: 19.12.08													#
;#  Version .......: 1.5														#
;#  Author ........: FireFox													#
;#           ©  2008 d3mon Corporation											#
;================================================================================

#Region Opt
Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
Opt("GuiOnEventMode", 1)
Opt("TrayIconHide", 1)
#EndRegion Opt

#Region Tray
TraySetIcon("Shell32.dll", 27)
TrayCreateItem("Counter")
TrayItemSetOnEvent(-1, "_SHOW")

$MSU = TrayCreateMenu("Start-up")
$SUON = TrayCreateItem("ON", $MSU)
TrayItemSetOnEvent(-1, "_SUON")
$SUOFF = TrayCreateItem("OFF", $MSU)
TrayItemSetOnEvent(-1, "_SUOFF")

TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_Exit")
TraySetOnEvent(-13, "_SHOW")
#EndRegion Tray

#Region Hook Keyboard
;~ Global Const $WH_KEYBOARD_LL = 13
Global $hHook, $pStub_KeyProc, $GUI, $TotalClick = 0
Global $KeyCount, $TotalKey = "None", $Countwhat, $CPUCalc
Global $pStub_KeyProc = _DllCallBack("_KeyProc", "int;ptr;ptr")
Global $hmod = DllCall("kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
Global $hHook = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", $WH_KEYBOARD_LL, "ptr", $pStub_KeyProc, "hwnd", $hmod[0], "dword", 0)
$hButton = ControlGetHandle("[Class:Shell_TrayWnd]", "", "[Class:Button;Instance:1]")
Local $IDLETIME, $KERNELTIME, $USERTIME
Local $StartIdle, $StartKernel, $StartUser
Local $EndIdle, $EndKernel, $EndUser

$IDLETIME = DllStructCreate("dword;dword")
$KERNELTIME = DllStructCreate("dword;dword")
$USERTIME = DllStructCreate("dword;dword")
#EndRegion Hook Keyboard

#Region Variables
;~ $Record = FileRead(@TempDir & "\KeyCounter.txt")
Local $GUIlblDateStarted, $GUIlblKeysPressed
$Date = @MDAY & "/" & @MON & "/" & @YEAR
_ReduceMemory(@ScriptName)
Dim $last_pos[2] = [0, 0]
Dim $lastdistance
$Init = TimerInit()
$pl = ProcessList()
$lastnb = $pl[0][0]
#EndRegion Variables

#Region GUI
$GUI = GUICreate("What you've done today <d3montools>  " & $Date, 330, 95, -1, -1, -1, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
GUISetOnEvent($GUI_EVENT_CLOSE, "_CLOSE")
GUICtrlCreateLabel("Count since :", 5, 5, 70, 15)
$GUIlblTimeStarted = GUICtrlCreateLabel("0 sec", 75, 5, 150, 15)
GUICtrlCreateLabel("Count key of :", 170, 5)
$GUIcboKeyMouse = GUICtrlCreateCombo("All", 240, 2, 80, 17, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Mouse|Keyboard", "All")
GUICtrlCreateLabel("Keys pressed :", 5, 29, 100, 15)
$GUIlblKeysPressed = GUICtrlCreateLabel("0", 80, 29, 100, 15)
GUICtrlCreateLabel("Mouse dist :", 170, 29)
$GUIlblMousedist = GUICtrlCreateLabel("0 pixel", 240, 29, 100)
;~ GUICtrlCreateLabel("Record :", 195, 27)
;~ $GUIlblRecord = GUICtrlCreateLabel(FileRead(@TempDir & "\KeyCounter.txt"), 245, 27, 100)
GUICtrlCreateLabel("Total Process :", 5, 52, 100, 15)
$GUIlblProcess = GUICtrlCreateLabel("0", 80, 52, 100, 15)
$GUIlblCPU = GUICtrlCreateLabel("0%", 170, 52, 100, 15)
$GUIlblMEM = GUICtrlCreateLabel("0%", 240, 52, 100, 15)
GUICtrlCreateLabel("Start Menu Click :",5,75,100,17)
$GUIlblStart = GUICtrlCreateLabel("0", 95, 75, 100, 15)
GUISetState(@SW_HIDE)
#EndRegion GUI

#Region GUI STATE ----------------------------------------------------------------------------------
Func _CLOSE()
	GUISetState(@SW_HIDE, $GUI)
	_ReduceMemory(@ScriptName)
EndFunc   ;==>_CLOSE

Func _SHOW()
	GUISetState(@SW_SHOW, $GUI)
	_ReduceMemory(@ScriptName)
EndFunc   ;==>_SHOW
#EndRegion GUI STATE ----------------------------------------------------------------------------------

#Region Keyboard Key ------------------------------------------------------------------------------
Func EvaluateKey($keycode)
	If (($keycode > 22) And ($keycode < 91)) _
			Or (($keycode > 47) And ($keycode < 58)) Then
		GUICtrlSetData($GUIlblKeysPressed, $TotalKey + 1)
		Global $TotalKey = GUICtrlRead($GUIlblKeysPressed)
	Else
		GUICtrlSetData($GUIlblKeysPressed, $TotalKey + 1)
		Global $TotalKey = GUICtrlRead($GUIlblKeysPressed)
	EndIf
EndFunc   ;==>EvaluateKey

Func _KeyProc($nCode, $wParam, $lParam)
	Local $ret, $KEYHOOKSTRUCT
	
	If $Countwhat = 0 Or $Countwhat = 2 Then
		If $nCode < 0 Then
			$ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hHook[0], _
					"int", $nCode, "ptr", $wParam, "ptr", $lParam)
			Return $ret[0]
		EndIf
		If $wParam = 256 Then
			$KEYHOOKSTRUCT = DllStructCreate("dword;dword;dword;dword;ptr", $lParam)
			EvaluateKey(DllStructGetData($KEYHOOKSTRUCT, 1))
		EndIf
		$ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hHook[0], _
				"int", $nCode, "ptr", $wParam, "ptr", $lParam)
		Return $ret[0]
	EndIf
EndFunc   ;==>_KeyProc
#EndRegion Keyboard Key ------------------------------------------------------------------------------

#Region Start-up ----------------------------------------------------------------------------------
RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "KeyCounter")
If @error Then
	TrayItemSetState($SUOFF, $TRAY_CHECKED)
Else
	TrayItemSetState($SUON, $TRAY_CHECKED)
EndIf

Func _SUON()
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "KeyCounter", "REG_SZ", @ScriptFullPath)
	TrayItemSetState($SUOFF, $TRAY_UNCHECKED)
	TrayItemSetState($SUON, $TRAY_CHECKED)
EndFunc   ;==>_SUON

Func _SUOFF()
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "KeyCounter")
	TrayItemSetState($SUOFF, $TRAY_CHECKED)
	TrayItemSetState($SUON, $TRAY_UNCHECKED)
EndFunc   ;==>_SUOFF
#EndRegion Start-up ----------------------------------------------------------------------------------

Func _Exit()
;~ 	MsgBox(64,"",$Record&" | "&$TotalKey)
;~ 	If $Record < $TotalKey Then
;~ 		MsgBox(64,"","New record saved")
;~ 		FileDelete(@TempDir & "\KeyCounter.txt")
;~ 		FileWrite(@TempDir & "\KeyCounter.txt", $TotalKey)
;~ 	EndIf
	DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $hHook[0])
	Exit
EndFunc   ;==>_Exit


#Region ReduceMemory-------------------------------------------------------------------------------
;===============================================================================
; Function Name: _ReduceMemory
; Author(s): jftuga
;===============================================================================
Func _ReduceMemory($i_PID = -1)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf

	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory
#EndRegion ReduceMemory-------------------------------------------------------------------------------

#Region _IsPressed---------------------------------------------------------------------------------
;===============================================================================
; Function Name: _IsPressed
; Author(s): FireFox (Thanks to original _IsPressed)
;===============================================================================
Func _IsPressed($HexKey, $vDLL = 'user32.dll')
	$sHexKey = StringSplit($HexKey, "|", 1)

	For $nb = 1 To UBound($sHexKey) - 1
		$a_R = DllCall($vDLL, "int", "GetAsyncKeyState", "int", '0x' & $sHexKey[$nb])
		If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 1
	Next

	Return 0
EndFunc   ;==>_IsPressed
#EndRegion _IsPressed---------------------------------------------------------------------------------

#Region CPU----------------------------------------------------------------------------------------
;===============================================================================
; Function Name: _GetSysTime / _CPUCalc
; Author(s): rasim
;===============================================================================
Func _GetSysTime(ByRef $sIdle, ByRef $sKernel, ByRef $sUser)
	DllCall("kernel32.dll", "int", "GetSystemTimes", "ptr", DllStructGetPtr($IDLETIME), _
			"ptr", DllStructGetPtr($KERNELTIME), _
			"ptr", DllStructGetPtr($USERTIME))

	$sIdle = DllStructGetData($IDLETIME, 1)
	$sKernel = DllStructGetData($KERNELTIME, 1)
	$sUser = DllStructGetData($USERTIME, 1)
EndFunc   ;==>_GetSysTime

Func _CPUCalc()
	Local $iSystemTime, $iTotal, $iCalcIdle, $iCalcKernel, $iCalcUser

	$iCalcIdle = ($EndIdle - $StartIdle)
	$iCalcKernel = ($EndKernel - $StartKernel)
	$iCalcUser = ($EndUser - $StartUser)

	$iSystemTime = ($iCalcKernel + $iCalcUser)
	$iTotal = Int(($iSystemTime - $iCalcIdle) * (100 / $iSystemTime)) & "%"

	Global $CPUCalc = $iTotal
EndFunc   ;==>_CPUCalc
#EndRegion CPU----------------------------------------------------------------------------------------
Opt("TrayIconHide", 0)

While 1
	Sleep(100)
	#Region Key pressed -------------------------------------------------------------------------------
	Switch GUICtrlRead($GUIcboKeyMouse)
		Case "All"
			$Countwhat = 0
		Case "Mouse"
			$Countwhat = 1
		Case "Keyboard"
			$Countwhat = 2
	EndSwitch
	
	If $Countwhat = 0 Or $Countwhat = 1 Then
		If _IsPressed("01|02|03|04|05|06") Then
			Do
				;Nothing
			Until Not _IsPressed("01|02|03|04|05|06")
			GUICtrlSetData($GUIlblKeysPressed, $TotalKey + 1)
			Global $TotalKey = GUICtrlRead($GUIlblKeysPressed)
		EndIf
	EndIf
	#EndRegion Key pressed -------------------------------------------------------------------------------

	#Region Start Button Click --------------------------------------------------------------------
	If BitAND(_GUICtrlButton_GetState($hButton), $BST_PUSHED) Then
		GUICtrlSetData($GUIlblStart, $TotalClick + 1)
		Do ;----------
		Sleep(10)
		Until _GUICtrlButton_GetState($hButton) = 0
		Global $TotalClick = GUICtrlRead($GUIlblStart)
	EndIf
	#EndRegion Start Button Click --------------------------------------------------------------------

	#Region Process -------------------------------------------------------------------------------
	$wpl = ProcessList()
	$diff = $wpl[0][0] - $lastnb
	If $diff >= 0 Then
		$nb = $wpl[0][0] + $diff
		$lastnb = $nb
	EndIf
	GUICtrlSetData($GUIlblProcess, $lastnb)
	#EndRegion Process -------------------------------------------------------------------------------

	#Region CPU/MEM -------------------------------------------------------------------------------
	_GetSysTime($EndIdle, $EndKernel, $EndUser)
	_CPUCalc() ;--------------------------------
	_GetSysTime($StartIdle, $StartKernel, $StartUser)
	GUICtrlSetData($GUIlblCPU, "CPU : " & $CPUCalc)

	$Stats = MemGetStats()
	GUICtrlSetData($GUIlblMEM, "Memory : " & $Stats[0] & "%")
	#EndRegion CPU/MEM -------------------------------------------------------------------------------

	#Region Mouse distance ------------------------------------------------------------------------
	$current_pos = MouseGetPos()
	$distance = Sqrt(($current_pos[0] - $last_pos[0]) ^ 2 + ($current_pos[1] - $last_pos[1]) ^ 2)
	$mousedist = $distance + $lastdistance
	$lastdistance = $mousedist
	$last_pos = $current_pos
	$mousesplit = StringSplit($mousedist, ".")

	If Not @error Then
		$distance = $mousesplit[1]
		GUICtrlSetData($GUIlblMousedist, $distance & " pixels")
	Else
		$distance = $mousedist
		GUICtrlSetData($GUIlblMousedist, $distance & " pixels")
	EndIf
	#EndRegion Mouse distance ------------------------------------------------------------------------

;~ 	If $TotalKey > $Record Then
;~ 		GUICtrlSetData($GUIlblRecord, $TotalKey)
;~ 	EndIf

	$diff = StringLeft(TimerDiff($Init) * 0.001, 5)
	GUICtrlSetData($GUIlblTimeStarted, $diff & " sec")

	TraySetToolTip("Counter <d3montools>" _
			 & @CRLF & "Keys pressed : " & $TotalKey _
			 & @CRLF & "Mouse dist : " & $distance _
			 & @CRLF & "Total process : " & $lastnb _
			 & @CRLF & "CPU Usage : " & $CPUCalc _
			 & @CRLF & "MEM Usage : " & $Stats[0] & "%")
WEnd