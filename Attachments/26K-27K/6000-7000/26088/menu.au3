#include <GuiConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WINAPI.au3>
#include <ButtonConstants.au3>
#include <Process.au3>
#include<Misc.au3>
#include <DateTimeConstants.au3>
#include <GuiMenu.au3>

;AutoItSetOption("WinTitleMatchMode",2)
Global $topped
Global $topped2 = "0"
Global $off = "0"
Global $saver="1"
Global $size, $state
Global $from=""
global $same=""

_Main()

Func Terminate()
	Send("{CAPSLOCK OFF}")
    Exit 0
EndFunc

Func _Main()

	$hGUI = GUICreate("Menu", 400, 18, 0,0,$WS_POPUP, BitOR($WS_EX_ACCEPTFILES,$WS_EX_TOOLWINDOW))

	$logistics = GUICtrlCreateMenu("&2 Logistics")

	$email = GUICtrlCreateMenu("&3 Emails")

	$prog = GUICtrlCreateMenu("&4 Programs")
		$progitem = GUICtrlCreateMenuItem("&Adolix", $prog)
		$progitem2 = GUICtrlCreateMenuItem("&Edraw", $prog)
		$progitem3 = GUICtrlCreateMenuItem("&Conversions", $prog)
		$separator1 = GUICtrlCreateMenuItem("", $prog, 3) 	; create a separator line
		$progitem4 = GUICtrlCreateMenuItem("Aut2&Exe", $prog)
		$progitem5 = GUICtrlCreateMenuItem("Aut&Info", $prog)
		$progitem6 = GUICtrlCreateMenuItem("AutoIt Help", $prog)
   ;    $date = GUICtrlCreateMenu(GetDayOfWeek() & "  " & GetMonth() & " " & @MDAY & ", " & Getyear())
 
  ;  $hMenu = _GUICtrlMenu_GetMenu($hGUI)
  ;  $iMenuCnt = _GUICtrlMenu_GetItemCount($hMenu)
  ;  _GUICtrlMenu_SetItemType($hMenu, ($iMenuCnt - 1), $MFT_RIGHTJUSTIFY, True)
	GUISetState()

    ; Loop until user exits
LOCAL $act=""
WinSetTrans("Menu","",0)
 
    While 1
        If _IsPressed(14) AND _WinGetTrans("Menu")=0 Then
			$act=WinGetTitle("[ACTIVE]")
			WinSetTrans("Menu","",230)
			WinActivate("Menu","")
			SEND("{ALT}")
			Send("{CAPSLOCK OFF}")
		ElseIf  _IsPressed(14) OR _IsPressed("1B") and _WinGetTrans("Menu")=230 Then
			WinSetTrans("Menu","",0)
			WinActivate($act, "")
			Send("{CAPSLOCK OFF}")
        ElseIf Not _IsPressed(14) and not WinActive("Menu","") Then
			if _WinGetTrans("Menu")=230 then WinSetTrans("Menu","",0)
		EndIf

		$msg = GUIGetMsg()		
		Select
		Case $msg = $progitem
			ShellExecute("F:\applications\AdolixPDF\AdolixSplitandMergePDF.exe")
		Case $msg = $progitem2
			ShellExecute("F:\applications\Edraw Max\edraw.exe")
		Case $msg = $progitem3
			ShellExecute("f:\Mshell\programs\convert.exe")
		Case $msg = $progitem4
			ShellExecute("F:\applications\autoit\install\Aut2Exe\aut2exe.exe")
		Case $msg = $progitem5
			ShellExecute("F:\applications\autoit\install\au3info.exe")
		Case $msg = $progitem6
			ShellExecute("F:\applications\autoit\install\AutoIt3Help.exe")
		EndSelect
	WEnd
EndFunc   ;==>_Main

Func _WinGetTrans($sTitle, $sText = "")
    Local $hWnd = WinGetHandle($sTitle, $sText)
    If Not $hWnd Then Return -1
    Local $val = DllStructCreate("int")
    Local $aRet = DllCall("user32.dll", "int", "GetLayeredWindowAttributes", "hwnd", $hWnd, "ulong_ptr", 0, "int_ptr", DllStructGetPtr($val), "ulong_ptr", 0)
    If @error Or Not $aRet[0] Then Return -1
    Return DllStructGetData($val, 1)
EndFunc