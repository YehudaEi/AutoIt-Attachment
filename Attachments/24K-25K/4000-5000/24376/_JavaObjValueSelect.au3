#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <IE.au3>
#include <Java.au3>

MsgBox(262144, "_JavaObjValueSelect.au3", 	"You must perform the following steps before continuing with script:" & @CRLF & _
											"1.  Download jEdit from ""www.jedit.org""." & @CRLF & _
											"2.  Install jEdit on your computer." & @CRLF & _
											"3.  Start jEdit and select the menu item ""File -> Print...""" & @CRLF & _
											"4.  If you don't have Mozilla Firefox installed, download it from ""www.mozilla.com/firefox""." & @CRLF & _
											"5.  Install Mozilla Firefox on your computer." & @CRLF & _
											"6.  Download ""piface.zip"" from ""http://www.autoitscript.com/forum/index.php?showtopic=87956""." & @CRLF & _
											"7.  Extract ""piface.zip"" to a location on your computer." & @CRLF & _
											"8.  Run ""piface_start.bat""." & @CRLF)

; Piface

WinActivate("Piface Application Selector")
_JavaAttachAndWait("Piface Application Selector")
$java_obj1 = _JavaObjSelect("[CLASS:ComboBox; INSTANCE:1]", "", "combo box")
$java_obj1 = _JavaObjDeselect("[CLASS:ComboBox; INSTANCE:1]", "", "combo box")
$java_obj2 = _JavaObjSelect("", "Run dialog", "push button")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the Piface Application Selector window include:" & @CRLF & @CRLF & _
											"#1 Combo Box" & @CRLF & _
											"Run dialog Push Button" & @CRLF)

_JavaAttachAndWait("CI for a proportion")
$java_obj1 = _JavaObjSelect("[CLASS:ComboBox; INSTANCE:1]", "", "combo box")
$java_obj1 = _JavaObjDeselect("[CLASS:ComboBox; INSTANCE:1]", "", "combo box")
$java_obj2 = _JavaObjSelect("[CLASS:Button; INSTANCE:1]", "", "check box")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the CI for a proportion window include:" & @CRLF & @CRLF & _
											"#1 Combo Box" & @CRLF & _
											"#1 Check Box" & @CRLF)

MsgBox(262144, "_JavaObjValueSelect.au3", 	"Manually select the menu item ""Options -> Post hoc power..."", then click ""OK""")

_JavaAttachAndWait("Retrospective Power")
$java_obj1 = _JavaObjSelect("[CLASS:Button; INSTANCE:1]", "", "check box")
Sleep(1000)
$java_obj2 = _JavaObjSelect("[CLASS:Button; INSTANCE:2]", "", "check box")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the Retrospective Power window include:" & @CRLF & @CRLF & _
											"#1 Radio Button" & @CRLF & _
											"#2 Radio Button" & @CRLF)

; jEdit

WinActivate("Print")
_JavaAttachAndWait("Print")
$java_obj1 = _JavaObjSelect("", "Name:", "combo box")
Sleep(1000)
$java_obj2 = _JavaObjSelect("", "Print To File", "check box")
Sleep(1000)
$java_obj3 = _JavaObjSelect("", "Pages", "radio button")
Sleep(1000)
$java_obj4 = _JavaObjSelect("", "Cancel", "push button")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the Print window include:" & @CRLF & @CRLF & _
											"Name: combo box" & @CRLF & _
											"Print To File check box" & @CRLF & _
											"Pages radio button" & @CRLF & _
											"Cancel push button" & @CRLF)

; Graph Layout (example 1) in Internet Explorer
$oIE = _IECreate ("http://java.sun.com/applets/jdk/1.4/demo/applets/GraphLayout/example1.html")
_IELoadWait($oIE)
WinSetState("Graph Layout (example 1) - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSelect.au3", "Please wait for the webpage and applet ""Graph Layout (example 1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Graph Layout (example 1) - Windows Internet Explorer")
$java_obj1 = _JavaObjSelect("[TEXT:Scramble]", "", "push button")
Sleep(1000)
$java_obj2 = _JavaObjSelect("[TEXT:Shake]", "", "push button")
Sleep(1000)
$java_obj3 = _JavaObjSelect("[CLASS:Button; INSTANCE:3]", "", "check box")
Sleep(1000)
$java_obj4 = _JavaObjSelect("[CLASS:Button; INSTANCE:4]", "", "check box")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the Graph Layout (example 1) applet include:" & @CRLF & @CRLF & _
											"Scramble Button" & @CRLF & _
											"Shake Button" & @CRLF & _
											"#1 Checkbox" & @CRLF & _
											"#2 Checkbox" & @CRLF)
_IEQuit($oIE)

; Draw Test (1.1) in Internet Explorer
$oIE = _IECreate ("http://java.sun.com/applets/jdk/1.4/demo/applets/DrawTest/example1.html")
_IELoadWait($oIE)
WinSetState("Draw Test (1.1) - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSelect.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Draw Test (1.1) - Windows Internet Explorer")
$java_obj1 = _JavaObjSelect("[CLASS:Button; INSTANCE:1]", "", "check box")
Sleep(1000)
$java_obj2 = _JavaObjSelect("[CLASS:Button; INSTANCE:2]", "", "check box")
Sleep(1000)
$java_obj3 = _JavaObjSelect("[CLASS:Button; INSTANCE:3]", "", "check box")
Sleep(1000)
$java_obj4 = _JavaObjSelect("[CLASS:Button; INSTANCE:4]", "", "check box")
Sleep(1000)
$java_obj5 = _JavaObjSelect("[CLASS:Button; INSTANCE:5]", "", "check box")
Sleep(1000)
$java_obj6 = _JavaObjSelect("[CLASS:Button; INSTANCE:6]", "", "check box")
Sleep(1000)
$java_obj7 = _JavaObjSelect("[CLASS:ComboBox; INSTANCE:2]", "", "combo box")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the Draw Test (1.1) applet include:" & @CRLF & @CRLF & _
											"#1 Radiobutton" & @CRLF & _
											"#2 Radiobutton" & @CRLF & _
											"#3 Radiobutton" & @CRLF & _
											"#4 Radiobutton" & @CRLF & _
											"#5 Radiobutton" & @CRLF & _
											"#6 Radiobutton" & @CRLF & _
											"#2 combo box" & @CRLF)
_IEQuit($oIE)

; Arc Test (1.1) in Internet Explorer
$oIE = _IECreate ("http://java.sun.com/applets/jdk/1.4/demo/applets/ArcTest/example1.html")
_IELoadWait($oIE)
WinSetState("Arc Test (1.1) - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSelect.au3", "Please wait for the webpage and applet ""Arc Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Arc Test (1.1) - Windows Internet Explorer")
$java_obj3 = _JavaObjSelect("[TEXT:Fill]", "", "push button")
Sleep(1000)
$java_obj4 = _JavaObjSelect("[TEXT:Draw]", "", "push button")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the Arc Test (1.1) applet include:" & @CRLF & @CRLF & _
											"Fill Button" & @CRLF & _
											"Draw Button" & @CRLF)
_IEQuit($oIE)

; Graph Layout (example 1) in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://java.sun.com/applets/jdk/1.4/demo/applets/GraphLayout/example1.html", "", @SW_MAXIMIZE)
WinSetState("Graph Layout (example 1) - Mozilla Firefox", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSelect.au3", "Please wait for the webpage and applet ""Graph Layout (example 1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Graph Layout (example 1) - Mozilla Firefox")
$java_obj1 = _JavaObjSelect("[TEXT:Scramble]", "", "push button")
Sleep(1000)
$java_obj2 = _JavaObjSelect("[TEXT:Shake]", "", "push button")
Sleep(1000)
$java_obj3 = _JavaObjSelect("[CLASS:Button; INSTANCE:3]", "", "check box")
Sleep(1000)
$java_obj4 = _JavaObjSelect("[CLASS:Button; INSTANCE:4]", "", "check box")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the Graph Layout (example 1) applet include:" & @CRLF & @CRLF & _
											"Scramble Button" & @CRLF & _
											"Shake Button" & @CRLF & _
											"#1 Checkbox" & @CRLF & _
											"#2 Checkbox" & @CRLF)
WinClose("Graph Layout (example 1) - Mozilla Firefox")

; Draw Test (1.1) in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://java.sun.com/applets/jdk/1.4/demo/applets/DrawTest/example1.html", "", @SW_MAXIMIZE)
WinSetState("Draw Test (1.1) - Mozilla Firefox", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSelect.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Draw Test (1.1) - Mozilla Firefox")
$java_obj1 = _JavaObjSelect("[CLASS:Button; INSTANCE:1]", "", "check box")
Sleep(1000)
$java_obj2 = _JavaObjSelect("[CLASS:Button; INSTANCE:2]", "", "check box")
Sleep(1000)
$java_obj3 = _JavaObjSelect("[CLASS:Button; INSTANCE:3]", "", "check box")
Sleep(1000)
$java_obj4 = _JavaObjSelect("[CLASS:Button; INSTANCE:4]", "", "check box")
Sleep(1000)
$java_obj5 = _JavaObjSelect("[CLASS:Button; INSTANCE:5]", "", "check box")
Sleep(1000)
$java_obj6 = _JavaObjSelect("[CLASS:Button; INSTANCE:6]", "", "check box")
Sleep(1000)
$java_obj7 = _JavaObjSelect("[CLASS:ComboBox; INSTANCE:1]", "", "combo box")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the Draw Test (1.1) applet include:" & @CRLF & @CRLF & _
											"#1 Radiobutton" & @CRLF & _
											"#2 Radiobutton" & @CRLF & _
											"#3 Radiobutton" & @CRLF & _
											"#4 Radiobutton" & @CRLF & _
											"#5 Radiobutton" & @CRLF & _
											"#6 Radiobutton" & @CRLF & _
											"#1 combo box" & @CRLF)
WinClose("Draw Test (1.1) - Mozilla Firefox")

; Arc Test (1.1) in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://java.sun.com/applets/jdk/1.4/demo/applets/ArcTest/example1.html", "", @SW_MAXIMIZE)
WinSetState("Arc Test (1.1) - Mozilla Firefox", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSelect.au3", "Please wait for the webpage and applet ""Arc Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Arc Test (1.1) - Mozilla Firefox")
$java_obj3 = _JavaObjSelect("[TEXT:Fill]", "", "push button")
Sleep(1000)
$java_obj4 = _JavaObjSelect("[TEXT:Draw]", "", "push button")
MsgBox(262144, "_JavaObjValueSelect.au3", 	"Objects selected in the Arc Test (1.1) applet include:" & @CRLF & @CRLF & _
											"Fill Button" & @CRLF & _
											"Draw Button" & @CRLF)
WinClose("Arc Test (1.1) - Mozilla Firefox")
