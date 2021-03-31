#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.13.18 (Beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#cs
_UIA_Action:  Function location-UIAWrappers, line 1000

*** Standard code *** FROM TC2000 SPY
#include "UIAWrappers.au3"
AutoItSetOption("MustDeclareVars", 1)

Local $oP4=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=TC2000 ® Beta 12.4.5235.25989;controltype:=UIA_WindowControlTypeId;class:=Afx:00F30000:0", $treescope_children)
_UIA_Action($oP4,"setfocus")
Local $oP3=_UIA_getObjectByFindAll($oP4, "Title:=;controltype:=UIA_PaneControlTypeId;class:=Shell Embedding", $treescope_children)
_UIA_Action($oP3,"setfocus")
Local $oP2=_UIA_getObjectByFindAll($oP3, "Title:=;controltype:=UIA_PaneControlTypeId;class:=Shell DocObject View", $treescope_children)
_UIA_Action($oP2,"setfocus")
Local $oP1=_UIA_getObjectByFindAll($oP2, "Title:=file://C:\Users\Doug\AppData\Local\Microsoft\Silverlight\OutOfBrowser\1350570325.www.tc2000.com\index.html;controltype:=UIA_PaneControlTypeId;class:=Internet Explorer_Server", $treescope_children)
_UIA_Action($oP1,"setfocus")
Local $oP0=_UIA_getObjectByFindAll($oP1, "Title:=Silverlight Control;controltype:=UIA_WindowControlTypeId;class:=MicrosoftSilverlight", $treescope_children)
_UIA_Action($oP0,"setfocus")
;~ First find the object in the parent before you can do something
;~$oUIElement=_UIA_getObjectByFindAll("HON.mainwindow", "title:=HON;ControlType:=UIA_TextControlTypeId", $treescope_subtree)
Local $oUIElement=_UIA_getObjectByFindAll($oP0, "title:=HON;ControlType:=UIA_TextControlTypeId", $treescope_subtree)
_UIA_action($oUIElement,"click")

FOR REFERENCE:
*** Standard code *** FROM Freestockcharts.com SPY
#include "UIAWrappers.au3"
AutoItSetOption("MustDeclareVars", 1)

Local $oP2=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=FreeStockCharts.com - Web's Best Streaming Realtime Stock Charts - Free - Google Chrome;controltype:=UIA_WindowControlTypeId;class:=Chrome_WidgetWin_1", $treescope_children)
_UIA_Action($oP2,"setfocus")
Local $oP1=_UIA_getObjectByFindAll($oP2, "Title:=;controltype:=UIA_PaneControlTypeId;class:=WrapperNativeWindowClass", $treescope_children)
_UIA_Action($oP1,"setfocus")
Local $oP0=_UIA_getObjectByFindAll($oP1, "Title:=Silverlight Control;controltype:=UIA_WindowControlTypeId;class:=NativeWindowClass", $treescope_children)
_UIA_Action($oP0,"setfocus")
;~ First find the object in the parent before you can do something
;~$oUIElement=_UIA_getObjectByFindAll("HON.mainwindow", "title:=HON;ControlType:=UIA_TextControlTypeId", $treescope_subtree)
Local $oUIElement=_UIA_getObjectByFindAll($oP0, "title:=HON;ControlType:=UIA_TextControlTypeId", $treescope_subtree)
_UIA_action($oUIElement,"click")


#ce
; Script Start - Add your code below here
;~ *** Standard code ***
#include "UIAWrappers.au3"
AutoItSetOption("MustDeclareVars", 1)

;The obj strings in this code come from the Standard Code
;_UIA_Action("Title:=FreeStockCharts.*;controltype:=UIA_WindowControlTypeId;class:=Chrome_WidgetWin_1", "setfocus")
_UIA_Action("Title:=TC2000 *;controltype:=UIA_WindowControlTypeId;class:=Afx:00F30000:0", "setfocus")
consolewrite("Finished 1" & @CRLF)
;_UIA_Action("Title:=;controltype:=Pane;class:=WrapperNativeWindowClass", "setfocus")
_UIA_Action("Title:=;controltype:=Pane;class:=Shell Embedding", "setfocus")
consolewrite("Finished 2" & @CRLF)
_UIA_Action("Title:=;controltype:=Pane;class:=Shell DocObject View", "setfocus")
consolewrite("Finished 3" & @CRLF)
_UIA_Action("Title:=file://C:\Users\Doug\AppData\Local*;controltype:=Pane;class:=Internet Explorer_Server", "setfocus")
consolewrite("Finished 4" & @CRLF)


;_UIA_Action("Title:=Silverlight Control;controltype:=Window;class:=NativeWindowClass", "setfocus")
_UIA_Action("Title:=Silverlight Control;controltype:=Window;class:=MicrosoftSilverlight", "setfocus")
consolewrite("Finished 5" & @CRLF)


;_UIA_Action("title:=Add Indicator;ControlType:=Text;indexrelative:=-1","click")
_UIA_Action("title:=Daily;Class   := TextBlock;ControlType:=Text;indexrelative:=-5","click")
consolewrite("Finished 6" & @CRLF)









