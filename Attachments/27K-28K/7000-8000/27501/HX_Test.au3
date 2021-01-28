;Autoit Ver3.3
;Phil Young
;8/5/2009
;This script is intented for use as the main test engine for the HX controller board

;Revision History
#comments-start
8/5/2009 - Vers au3-1.0.0  Unreleased, Under Developement
#comments-end

;Important Notes
#comments-start
	1) function names must begin with a capital letter ie. Func FunctionName ()
	2) subroutine names must begin with '_Sub' and the name must begin with a capital letter ie. Func _SubSubroutineName ()
#comments-end

;Begin Script

#include <GUIconstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3> 

;Options
AutoItSetOption('MustDeclareVars', 1)

;Variables



;Build GUI

Dim $guiHandle, $btn_ok, $btn_test, $btn_clr, $lbl_0, $input_0
Dim $msg, $junk

$guiHandle=GUICreate('HX Test', 500, 250, -1, -1, BitOR($WS_CAPTION, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SIZEBOX))						;create main GUI window
$btn_ok=GUICtrlCreateButton('OK', 230, 200, 40, 27)
$btn_test=GUICtrlCreateButton('Test', 10, 105, 80, 27)
$btn_clr=GUICtrlCreateButton('Clear', 10, 205, 80, 27)
$lbl_0=GUICtrlCreateLabel("", 10, 10, 480, 75, $SS_SUNKEN)																					;display window
$input_0=GUICtrlCreateInput("", 10, 142, 160, 20)

GUISetState(@SW_SHOW, $guiHandle)																											;show GUI window

While 1
	$msg=GUIGetMsg(0)
		Select
		Case $msg = $GUI_EVENT_CLOSE
			$junk=GUIDelete()
			ExitLoop
		Case $msg = $btn_test
			Call("_LVComDllTest")
		Case $msg=$btn_clr
			GUICtrlSetData($lbl_0, "")
		EndSelect
WEnd
	


Func _LVComDllTest()
	
Local $hdl_lvComDll, $stringIn
Local $A[16] = ["0"]
Local $B[16] = ["0"]
		
	$hdl_lvComDll=DllOpen("Q:\LV85Projects\builds\COMDLL\COMDLLrc1\lvcom.dll")
	
	$A=DllCall($hdl_lvComDll,"none:cdecl","Func_CfgSerial_init", "str", $hdl_lvComDll, "str", "19200", "str", "none", "str", "", "int", 16)
	$stringIn=GUICtrlRead($input_0)
	$B=DllCall($hdl_lvComDll,"none:cdecl","Func_Serial_TxRx", "str", $A[4], "str", $stringIn, "str", "250", "str", "", "str", "", "int", 16, "int", 16)
	$junk=DllClose($hdl_lvComDll)
	GUICtrlSetData($lbl_0, $B[4] & $B[5])

	Return 0
EndFunc