#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.13.3 (beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#Include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

Global Const $CS_VREDRAW = 0x0001;
Global Const $CS_HREDRAW = 0x0002;
Global Const $CS_DBLCLKS = 0x0008;
Global Const $CS_OWNDC = 0x0020;
Global Const $CS_CLASSDC = 0x0040;
Global Const $CS_PARENTDC = 0x0080;
Global Const $CS_NOCLOSE = 0x0200;
Global Const $CS_SAVEBITS = 0x0800;
Global Const $CS_BYTEALIGNCLIENT = 0x1000;
Global Const $CS_BYTEALIGNWINDOW = 0x2000;
Global Const $CS_GLOBALCLASS = 0x4000;
Global Const $CS_DROPSHADOW = 0x00020000;

Global Const $CS_DEFAULTSTYLE = BitOR($CS_VREDRAW, $CS_HREDRAW)
Global Const $CW_USEDEFAULT = 0x80000000

;#CS
Global Const $CURSOR_ARROW           =32512
Global Const $CURSOR_IBEAM           =32513
Global Const $CURSOR_WAIT            =32514
Global Const $CURSOR_CROSS           =32515
Global Const $CURSOR_UPARROW         =32516
Global Const $CURSOR_SIZENWSE        =32642
Global Const $CURSOR_SIZENESW        =32643
Global Const $CURSOR_SIZEWE          =32644
Global Const $CURSOR_SIZENS          =32645
Global Const $CURSOR_SIZEALL         =32646
Global Const $CURSOR_NO              =32648
Global Const $CURSOR_APPSTARTING     =32650
Global Const $CURSOR_HELP            =32651
;#CE

#cs

_WinAPI_RegisterClassEx($sClassName, $sCallbackFunction, $hIcon=0, $hCursor=0, $iBkColor=$COLOR_BTNFACE, $iStyle=$CS_DEFAULTSTYLE)

$sClassName -				Classname
$sCallbackFunction - 		WindowProc callback function
$hIcon - 					Handle to a icon which will be be used as the window icon (Default = application icon)
$hCursor - 					Handle to cursor which will be used as the window cursor (Default = arraow cursor)
								Use _WinAPI_LoadCursor() [also included with this UDF] to load a system cursor:
									
									$CURSOR_ARROW
									$CURSOR_IBEAM
									$CURSOR_WAIT
									$CURSOR_CROSS
									$CURSOR_UPARROW
									$CURSOR_SIZENWSE
									$CURSOR_SIZENESW
									$CURSOR_SIZEWE
									$CURSOR_SIZENS
									$CURSOR_SIZEALL
									$CURSOR_NO
									$CURSOR_APPSTARTING
									$CURSOR_HELP
									
									Example: _WinAPI_LoadCursor(0, $CURSOR_IBEAM)
									Do not use the $IDC_ constants declared in Constants.au3 

$iBkColor - 				RGB color code of window background color
$iStyle - 					Class style. A combination of these values: (Default = $CS_DEFAULTSTYLE)
								
								$CS_VREDRAW
								$CS_HREDRAW
								$CS_DBLCLKS
								$CS_OWNDC
								$CS_CLASSDC
								$CS_PARENTDC
								$CS_NOCLOSE
								$CS_SAVEBITS
								$CS_BYTEALIGNCLIENT
								$CS_BYTEALIGNWINDOW
								$CS_GLOBALCLASS
								$CS_DROPSHADOW

Function: Creating a class which can be used with CreateWindowEx, and others

Author: Original - 			amel27
		Working version - 	Kip

#ce

Func _WinAPI_RegisterClassEx($sClassName, $sCallbackFunction="", $hIcon=0, $hCursor=0, $iBkColor=$COLOR_BTNFACE, $iStyle=$CS_DEFAULTSTYLE)
	
	If not $hIcon Then
		Local $aIcon = DllCall("user32.dll", "hwnd", "LoadIcon", "hwnd", 0, "int", $IDI_APPLICATION)
		$hIcon = $aIcon[0]
	EndIf
	
	If not $hCursor Then
		$hCursor = _WinAPI_LoadCursor(0,$CURSOR_ARROW)
	EndIf
    
	local	$hWndProc = DLLCallbackRegister ($sCallbackFunction, "int", "hwnd;int;wparam;lparam")
	Local	$pCallback = DllCallbackGetPtr($hWndProc)
	
    Local $tWndClassEx = DllStructCreate("uint cbSize;uint style;ptr lpfnWndProc;int cbClsExtra;int cbWndExtra;hwnd hInstance;hwnd hIcon;hwnd hCursor;hwnd hbrBackground;ptr lpszMenuName;ptr lpszClassName;hwnd hIconSm")
    Local $tClassName = DllStructCreate("char["& StringLen($sClassName)+1 &"]")
    DllStructSetData($tClassName, 1, $sClassName)
	
    DllStructSetData($tWndClassEx, "cbSize", DllStructGetSize($tWndClassEx) )
    DllStructSetData($tWndClassEx, "style", $iStyle)
    DllStructSetData($tWndClassEx, "lpfnWndProc", $pCallback)
    DllStructSetData($tWndClassEx, "hInstance", _WinAPI_GetModuleHandle(""))
    DllStructSetData($tWndClassEx, "hIcon", $hIcon)
    DllStructSetData($tWndClassEx, "hCursor", $hCursor)
    DllStructSetData($tWndClassEx, "hbrBackground", _WinAPI_CreateSolidBrush(RGB_to_BGR($iBkColor)))
    DllStructSetData($tWndClassEx, "lpszClassName", DllStructGetPtr($tClassName))
    DllStructSetData($tWndClassEx, "hIconSm", $hIcon)
    
    Local $aRet = DllCall("user32.dll", "dword", "RegisterClassExA", "ptr", DllStructGetPtr($tWndClassEx) )
	
	Return $aRet[0]
	
EndFunc


Func _WinAPI_UnregisterClass($sClassName)
    
    Local $aRet = DllCall("user32.dll", "int", "UnregisterClassA", "str", $sClassName, "hwnd", _WinAPI_GetModuleHandle(""))
    Return $aRet[0]
	
EndFunc


Func _WinAPI_LoadCursor($hInstance, $iCursor)
	$GuiCursor = DllCall("user32.dll", "hwnd", "LoadCursor", "hwnd", $hInstance, "int", $iCursor)
	Return $GuiCursor[0]
EndFunc

Func RGB_to_BGR($BRG)
	
	$b = BitAND(BitShift($BRG, 16), 0xFF)
	$g = BitAND(BitShift($BRG, 8), 0xFF)
	$r = BitAND($BRG, 0xFF)
	
	Return "0x"&Hex($r,2)&Hex($g,2)&Hex($b,2)
EndFunc