#include <dbug.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

;varables declaration
$a = "Global_var_a"						;implicit declared (global)
Dim $b = "Global_var_b"					;implicit global
Global $c = 'Global_var_c'				;forced global
Global Const $d = 'Global_constant_d'	;constant
Global $e = Default						;keyword

;object declaration
Global $oDict = ObjCreate("scripting.dictionary")
Global $oShell = ObjCreate("shell.application")
Global $oIE = ObjCreate("Shell.Explorer.2")
Global $oFS = objcreate('Scripting.FileSystemObject')

;structures declaration
Global $struc1 = DllStructCreate("ubyte;char;wchar;int;long;dword;ptr;hwnd;float;double")
DllStructSetData($struc1, 1, 0xAB)
DllStructSetData($struc1, 2, 'A')
DllStructSetData($struc1, 3, "B")
DllStructSetData($struc1, 4, 123)
DllStructSetData($struc1, 5, 0xFFFF)
DllStructSetData($struc1, 6, 0xFFFF)
DllStructSetData($struc1, 7, DllStructGetPtr($struc1))
DllStructSetData($struc1, 8, DllStructGetPtr($struc1))
DllStructSetData($struc1, 9, 123.45)
DllStructSetData($struc1, 10, 123.45)

Global $struc2 = DllStructCreate("ubyte[20];char[20];wchar[20];int[20];long[20];dword[20];ptr[20];hwnd[20];float[20];double[20]")
DllStructSetData($struc2, 1, 0xABCDEF)
DllStructSetData($struc2, 2, 123)
DllStructSetData($struc2, 3, "DBUG testscript")

;array's declaration
Global $arr1[2][4]=[["Paul", "Jim", "Richard", "Louis"], [180, 161, 178, 173]]
Global $arr2[20]=['Wilma', $oDict, 'Ann', $struc1, 'Mabel', $arr1, 'Susan', 0xABCD, 'Christel', 123, 'Joan', 123.45, 'Rachel', binary(123), 'Mildred', hex(123), 'Sylvia', DllStructGetPtr($struc1), 'Amber', default]

;macro declarations
$ver = @AutoItVersion
$sec = @SEC
$crlf = @CRLF

GUICreate('DBUG test')
GUICtrlCreateButton("Exit",10,10)
GUISetState(@SW_SHOW)

GUIRegisterMsg($WM_COMMAND, "MY_WMCOMMAND")
GUIRegisterMsg($WM_NOTIFY, "MY_WMNOTIFY")

Function1($a, $b)
;check $a, $b and $i

While True
	Sleep(100)
WEnd



Func Display($txt)
	MsgBox(0, "Display message", $txt)
EndFunc

Func Function1($par1, ByRef $par2)

	$par1 = "by value"		;global argument untouched
	$par2 = "by reference"	;global argument is changed

	$f = "Local_var_f"			;implicit declared (local)
	Dim $g = "Local_var_g"		;implicit local
	Local $h = "Local_var_h"	;forced local
	Global $i = "Global_var_i"	;forced global

	Local $c = "I'm local"		;not the same as the global $c
	Local Static $static = "Local_static_var"

EndFunc


Func MY_WMCOMMAND($hWnd, $Msg, $wParam, $lParam)

	Local $nNotifyCode, $nID
    $nNotifyCode = BitShift($wParam, 16)
    $nID = BitAND($wParam, 0xFFFFFFFF)
	Exit

EndFunc

Func MY_WMNOTIFY($hWnd, $Msg, $wParam, $lParam )

	;don't set a breakpoint in a notify handler to prevent unpredictical behaviour

EndFunc

