#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.6.1
	Author:         Ricardo Vermeltfoort

	Script Function:
	Shows the usage of _WinMove().

#ce ----------------------------------------------------------------------------

#include <WinMove.au3>

_WinMove("[TITLE:Google - Google Chrome;CLASS:Chrome_WidgetWin_0]", "", "[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]", 0, 0, 960, 600, 2)
Switch @error
	Case 1
		MsgBox(0, "", "Control is not found")
	Case 2
		MsgBox(0, "", "Window is not found")
EndSwitch