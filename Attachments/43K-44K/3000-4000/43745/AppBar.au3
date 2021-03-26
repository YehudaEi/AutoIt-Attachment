#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Const $ABE_RIGHT = 2, $ABM_NEW = 0, $ABM_REMOVE = 1, $ABM_SETPOS = 3

; Create the GUI
$title = StringTrimRight(@ScriptName, 4)
$toolbarWidth = 40
$height = @DesktopHeight-40
$left = @DesktopWidth-$toolbarWidth
$top = 0
$right = @DesktopWidth
$bottom = $height
$hwnd = GUICreate($title, $toolbarWidth, $height, $left, $top, $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW)
GUISetState()

; Register the AppBar
$AppBarData = DllStructCreate("dword;int;uint;uint;int;int;int;int;int")
DllStructSetData($AppBarData, 1, DllStructGetSize($AppBarData))
DllStructSetData($AppBarData, 2, $hwnd)
DllStructSetData($AppBarData, 4, $ABE_RIGHT)
DllStructSetData($AppBarData, 5, $left)
DllStructSetData($AppBarData, 6, $top)
DllStructSetData($AppBarData, 7, $right)
DllStructSetData($AppBarData, 8, $bottom)
_SHAppBarMessage($ABM_NEW, $AppBarData)
_SHAppBarMessage($ABM_SETPOS, $AppbarData)

; Idle around
While 1
	Local $msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
WEnd

; Unregister the AppBar
_SHAppBarMessage($ABM_REMOVE, $AppBarData)

; Delete the GUI
GUIDelete($hwnd)

; Exit
Exit

Func _ShAppBarMessage($dwMessage, ByRef $AppBarData)
	DllCall("shell32.dll", "int", "SHAppBarMessage", "int", $dwMessage, "ptr", DllStructGetPtr($AppBarData))
EndFunc