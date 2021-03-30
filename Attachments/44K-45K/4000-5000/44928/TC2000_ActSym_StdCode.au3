;~ TEST SCRIPT TO READ ACTIVE SYMBOL FROM TC2000
;~ How to click
;~ How to find buttons (be aware that you have to change the captions to language of your windows)
;~ How to click in the menu (copy result to the clipboard)
;~    then it uses notepad to demonstrate
;~ How to set a value on a textbox with the value pattern
;~
;~ Attention points
;~ Examples are build on exact match of text (so this includes tab and Ctrl+C values), later I will
;~ make some function that can find with regexp or non exact match (need treewalker for that)
;~ Timing / sleep is sometimes needed to give the system time to popup the menus / execute the action
;~ Focus of application is sometimes to be set (and sometimes not as you look on the clicking of the
;~ buttons it will even happen when there is a screen in front of the calculator)

#include <debug.au3>
#include "UIAWrappers.au3"

#AutoIt3Wrapper_UseX64=Y  ;Should be used for stuff like tagpoint having right struct etc. when running on a 64 bits os


;TRY TO USE CODING AS IN EXAMPLES:

;~ $cTC2000Classname=32769
;~ $oTC2000=_UIA_getFirstObjectOfElement($UIA_oDesktop,"class:=" & $cTC2000Classname, $treescope_children)


;~ if isobj($oTC2000) Then
;~  _UIA_DumpThemAll($oCalc,$treescope_subtree)
;~  Else
;~ 	 ConsoleWrite("$oTC2000 is not an object")
;~  EndIf




;~ Exit

;~ ;*** Standard code *** ATTEMPT AT RUNNING IT, COMMENTED OUT FOR NOW

AutoItSetOption("MustDeclareVars", 1)

Local $oP4=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=TC2000 ® Beta 12.4.5235.25989;controltype:=UIA_WindowControlTypeId;class:=", $treescope_children)
if isobj($oP4) Then
	consolewrite("Got P4")
Else
	consolewrite("P4 not an object")
EndIf

_UIA_Action($oP4,"setfocus")
consolewrite("P4 Focus Set")


Local $oP3=_UIA_getObjectByFindAll($oP4, "Title:=;controltype:=UIA_PaneControlTypeId;class:=Shell Embedding", $treescope_children)
if isobj($oP3) Then
	consolewrite("Got P3")
Else
	consolewrite("P3 not an object")
EndIf

_UIA_Action($oP3,"setfocus")
consolewrite("P3 Focus Set")


Local $oP2=_UIA_getObjectByFindAll($oP3, "Title:=;controltype:=UIA_PaneControlTypeId;class:=Shell DocObject View", $treescope_children)
if isobj($oP2) Then
	consolewrite("Got P2")
Else
	consolewrite("P2 not an object")
EndIf

_UIA_Action($oP2,"setfocus")
consolewrite("P2 Focus Set")


Local $oP1=_UIA_getObjectByFindAll($oP2, "Title:=file://C:\Users\Doug\AppData\Local\Microsoft\Silverlight\OutOfBrowser\1350570325.www.tc2000.com\index.html;controltype:=UIA_PaneControlTypeId;class:=Internet Explorer_Server", $treescope_children)
if isobj($oP1) Then
	consolewrite("Got P1")
Else
	consolewrite("P1 not an object")
EndIf

_UIA_Action($oP1,"setfocus")
consolewrite("P1 Focus Set")





Local $oP0=_UIA_getObjectByFindAll($oP1, "Title:=Silverlight Control;controltype:=UIA_WindowControlTypeId;class:=MicrosoftSilverlight", $treescope_children)
if isobj($oP0) Then
	consolewrite("Got P0")
Else
	consolewrite("P0 not an object")
EndIf

_UIA_Action($oP0,"setfocus")
consolewrite("P0 Focus Set")





; First find the object in the parent before you can do something
;$oUIElement=_UIA_getObjectByFindAll("HON.mainwindow", "title:=HON;ControlType:=UIA_TextControlTypeId", $treescope_subtree)
;Local $oUIElement=_UIA_getObjectByFindAll($oP0, "title:=HON;ControlType:=UIA_TextControlTypeId", $treescope_subtree)

Local $oUIElement=_UIA_getObjectByFindAll($oP0, "title:=;ControlType:=UIA_TextControlTypeId;class:=TextBlock", $treescope_subtree)
if isobj($oUIElement) Then
	consolewrite("Got $oUIElement")
Else
	consolewrite("$oUIElement not an object")
EndIf





;THIS SHOULD BE THE ACTIVE SYMBOL ELEMENT:
_UIA_Action($oUIElement,"setfocus")
consolewrite("$oUIElement Focus Set" & @CRLF)


_UIA_DumpThemAll($oUIElement,$treescope_subtree)

;consolewrite($oUIElement)



;_UIA_action($oUIElement,"click")




;~ $oValueP=_UIA_getpattern($oUIElement,$UIA_ValuePatternId)
;~ $ActSym=""
;~ $oValueP.CurrentValue($ActSym)
;~ Consolewrite("Active Symbol is " & $ActSym& @CRLF)



Exit


;~ $myText=""
;~ $oValueP.CurrentValue($myText)
;~ consolewrite("address: " & $myText & @CRLF)





;~ $cCalcClassName="CalcFrame"
;~ $cNotepadClassName="Notepad"

;~ $cButton1="1"
;~ $cButtonAdd="Add"
;~ $cButton3="3"
;~ $cButtonEqual="Equals"
;~ $cButtonEdit="Edit"

;~ $oCalc=_UIA_getFirstObjectOfElement($UIA_oDesktop,"class:=" & $cCalcClassname, $treescope_children)
;~ $oNotepad=_UIA_getFirstObjectOfElement($UIA_oDesktop,"class:="& $cNotepadClassName, $treescope_children)

;~ if isobj($oCalc) Then

;You can comment this out just there to get the names of whats available under the calc window
;~ _UIA_DumpThemAll($oCalc,$treescope_subtree)

;~     $oButton=_UIA_getFirstObjectOfElement($oCalc,"name:=" & $cButton1, $treescope_subtree)
;~     $oInvokeP=_UIA_getpattern($oButton,$UIA_InvokePatternID)
;~     $oInvokeP.Invoke

;~     $oButton=_UIA_getFirstObjectOfElement($oCalc,"name:=" & $cButtonAdd, $treescope_subtree)
;~     $oInvokeP=_UIA_getpattern($oButton,$UIA_InvokePatternID)
;~     $oInvokeP.Invoke

;~     $oButton=_UIA_getFirstObjectOfElement($oCalc,"name:=" & $cButton3, $treescope_subtree)
;~     $oInvokeP=_UIA_getpattern($oButton,$UIA_InvokePatternID)
;~     $oInvokeP.Invoke

;~     $oButton=_UIA_getFirstObjectOfElement($oCalc,"name:=" & $cButtonEqual, $treescope_subtree)
;~     $oInvokeP=_UIA_getpattern($oButton,$UIA_InvokePatternID)
;~     $oInvokeP.Invoke

;~     $oButton=_UIA_getFirstObjectOfElement($oCalc,"name:=" & $cButtonEdit, $treescope_subtree)
;~     $oInvokeP=_UIA_getpattern($oButton,$UIA_InvokePatternID)
;~     $oInvokeP.Invoke

;~     sleep(1500)
 ;findThemAll($oCalc,$treescope_subtree)
; sleep(1000)

;    $sText="Kopiëren.*"    ;Copy
;    $sText="name:=((Copy.*)|(Kopi.*))"    ;Copy
;~     $sText="((Copy.*)|(Kopi.*))"    ;Copy
;~ 	consolewrite($sText)
;~     $oButton=_UIA_getObjectByFindAll($oCalc,"name:=" & $sText, $treescope_subtree)
;~     if isobj($oButton) Then
;~         consolewrite("Menuitem is there")
;~     Else
;~         consolewrite("Menuitem is NOT there")
;~     EndIf
;~     sleep(1000)

;~     $oInvokeP=_UIA_getpattern($oButton,$UIA_InvokePatternID)
;~     $oInvokeP.Invoke
;~     sleep(500)

;~ EndIf

;~ if isobj($oNotepad) Then

;~ $myText=clipget() ; Text from the clipboard

;You can comment this out
;~ _UIA_dumpThemAll($oNotepad,$treescope_subtree)
;~     sleep(1000)

;Activate notepad and put the value in the edit text control of notepad
;~     $oNotepad.setfocus()

;~     $sText="Edit"
;~     $oEdit=_UIA_getFirstObjectOfElement($oNotepad,"classname:=" & $sText, $treescope_subtree)
;~     $oValueP=_UIA_getpattern($oEdit,$UIA_ValuePatternId)
;~     $oValueP.SetValue($myText)

;~ EndIf

Exit

