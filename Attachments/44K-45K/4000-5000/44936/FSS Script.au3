#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.13.18 (Beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
;*** Standard code ***
#include "UIAWrappers.au3"
#include "CUIAutomation2.au3"

#AutoIt3Wrapper_UseX64=Y
AutoItSetOption("MustDeclareVars", 1)

Local $oP2=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=FreeStockCharts.com - Web's Best Streaming Realtime Stock Charts - Free - Google Chrome;controltype:=UIA_WindowControlTypeId;class:=Chrome_WidgetWin_1", $treescope_children)
if isobj($oP2) Then
	consolewrite("Got P2")
Else
	consolewrite("P2 not an object")
EndIf

_UIA_Action($oP2,"setfocus")
consolewrite("P2 Focus Set")


Local $oP1=_UIA_getObjectByFindAll($oP2, "Title:=;controltype:=UIA_PaneControlTypeId;class:=WrapperNativeWindowClass", $treescope_children)
if isobj($oP1) Then
	consolewrite("Got P1")
Else
	consolewrite("P1 not an object")
EndIf

_UIA_Action($oP1,"setfocus")
consolewrite("P1 Focus Set")



Local $oP0=_UIA_getObjectByFindAll($oP1, "Title:=Silverlight Control;controltype:=UIA_WindowControlTypeId;class:=NativeWindowClass", $treescope_children)
if isobj($oP0) Then
	consolewrite("Got P0")
Else
	consolewrite("P0 not an object")
EndIf

_UIA_Action($oP0,"setfocus")
consolewrite("P0 Focus Set")

_UIA_DumpThemAll($oP0,$treescope_subtree)

;~ First find the object in the parent before you can do something
;~$oUIElement=_UIA_getObjectByFindAll("HON.mainwindow", "title:=HON;ControlType:=UIA_TextControlTypeId", $treescope_subtree)
Local $oUIElement=_UIA_getObjectByFindAll($oP0, "title:=HON;ControlType:=UIA_TextControlTypeId", $treescope_subtree)
if isobj($oUIElement) Then
	consolewrite("Got $oUIElement")
Else
	consolewrite("$oUIElement not an object")
EndIf

_UIA_Action($oUIElement,"setfocus")
consolewrite("$oUIElement Focus Set")

;_UIA_DumpThemAll($oUIElement,$treescope_subtree)



Exit








