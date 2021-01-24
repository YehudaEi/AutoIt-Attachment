#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <IE.au3>
#include <Java.au3>

MsgBox(262144, "_JavaObjValueGet.au3", 	"You must perform the following steps before continuing with script:" & @CRLF & _
										"1.  Download jEdit from ""www.jedit.org""." & @CRLF & _
										"2.  Install jEdit on your computer." & @CRLF & _
										"3.  Start jEdit and select the menu item ""Utilities -> File System Browser""" & @CRLF & _
										"4.  Select the menu item ""File -> Print...""" & @CRLF & _
										"5.  If you don't have Mozilla Firefox installed, download it from ""www.mozilla.com/firefox""." & @CRLF & _
										"6.  Install Mozilla Firefox on your computer." & @CRLF & _
										"7.  Download ""piface.zip"" from ""http://www.autoitscript.com/forum/index.php?showtopic=87956""." & @CRLF & _
										"8.  Extract ""piface.zip"" to a location on your computer." & @CRLF & _
										"9.  Run ""piface_start.bat""." & @CRLF & _
										"10.  In the ""About Piface"" window, click ""OK""." & @CRLF & _
										"11. In the ""Piface Application Selector"" window, click ""Run dialog""." & @CRLF & _
										"12. In the ""CI for a proportion"" window, select the menu item ""Options -> Post hoc power...""." & @CRLF)

; Piface

WinActivate("Piface Application Selector")
_JavaAttachAndWait("Piface Application Selector")
$java_obj1 = _JavaObjValueGet("", "Type of analysis", "label")
$java_obj2 = _JavaObjValueGet("", "Run dialog", "push button")
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the Piface Application Selector window include:" & @CRLF & @CRLF & _
											"Type of analysis Label = " & $java_obj1 & "" & @CRLF & _
											"Run dialog Push Button = " & $java_obj2 & "" & @CRLF)

WinActivate("CI for a proportion")
_JavaAttachAndWait("CI for a proportion")
$java_obj1 = _JavaObjValueGet("", "", "check box", 1)
$java_obj2 = _JavaObjValueGet("", "N", "text")
$java_obj3 = _JavaObjValueGet("", "", "check box", 2)
$java_obj4 = _JavaObjValueGet("", "pi", "text")
$java_obj5 = _JavaObjValueGet("", "Confidence", "label")
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the CI for a proportion window include:" & @CRLF & @CRLF & _
											"#1 Check Box = " & $java_obj1 & "" & @CRLF & _
											"N Text = " & $java_obj2 & "" & @CRLF & _
											"#2 Check Box = " & $java_obj3 & "" & @CRLF & _
											"pi Text = " & $java_obj4 & "" & @CRLF & _
											"Confidence Label = " & $java_obj5 & "" & @CRLF)

WinActivate("Retrospective Power")
_JavaAttachAndWait("Retrospective Power")
$java_obj1 = _JavaObjValueGet("", "Was the test ""significant""?", "label")
$java_obj2 = _JavaObjValueGet("", "", "check box", 1)
$java_obj3 = _JavaObjValueGet("", "", "check box", 2)
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the Retrospective Power window include:" & @CRLF & @CRLF & _
											"Was the test ""significant""? Label = " & $java_obj1 & "" & @CRLF & _
											"#1 Check Box = " & $java_obj2 & "" & @CRLF & _
											"#2 Check Box = " & $java_obj3 & "" & @CRLF)

; jEdit

WinActivate("Print")
_JavaAttachAndWait("Print")
$java_obj1 = _JavaObjValueGet("", "General", "page tab list")
$java_obj2 = _JavaObjValueGet("", "Print Service", "panel")
$java_obj3 = _JavaObjValueGet("", "Name:", "label")
$java_obj4 = _JavaObjValueGet("", "Name:", "combo box")
$java_obj5 = _JavaObjValueGet("", "Properties...", "push button")
$java_obj6 = _JavaObjValueGet("", "Status:", "label")
$java_obj7 = _JavaObjValueGet("", "Accepting jobs", "label")
$java_obj8 = _JavaObjValueGet("", "Type:", "label")
$java_obj9 = _JavaObjValueGet("", "Info:", "label")
$java_obj10 = _JavaObjValueGet("", "Print To File", "check box")
$java_obj11 = _JavaObjValueGet("", "Print Range", "panel")
$java_obj12 = _JavaObjValueGet("", "All", "radio button")
$java_obj13 = _JavaObjValueGet("", "Pages", "radio button")
$java_obj14 = _JavaObjValueGet("", "Pages", "text")
$java_obj15 = _JavaObjValueGet("", "To", "label")
$java_obj16 = _JavaObjValueGet("", "To", "text")
$java_obj17 = _JavaObjValueGet("", "Copies", "panel")
$java_obj18 = _JavaObjValueGet("", "Number of copies:", "label")
$java_obj19 = _JavaObjValueGet("", "Collate", "check box")
$java_obj20 = _JavaObjValueGet("", "Print", "push button")
$java_obj21 = _JavaObjValueGet("", "Cancel", "push button")
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the Print window include:" & @CRLF & @CRLF & _
											"General page tab list = " & $java_obj1 & "" & @CRLF & _
											"Print Service panel = " & $java_obj2 & "" & @CRLF & _
											"Name: label = " & $java_obj3 & "" & @CRLF & _
											"Name: combo box = " & $java_obj4 & "" & @CRLF & _
											"Properties... push button = " & $java_obj5 & "" & @CRLF & _
											"Status: label = " & $java_obj6 & "" & @CRLF & _
											"Accepting jobs label = " & $java_obj7 & "" & @CRLF & _
											"Type: label = " & $java_obj8 & "" & @CRLF & _
											"Info: label = " & $java_obj9 & "" & @CRLF & _
											"Print To File check box = " & $java_obj10 & "" & @CRLF & _
											"Print Range panel = " & $java_obj11 & "" & @CRLF & _
											"All radio button = " & $java_obj12 & "" & @CRLF & _
											"Pages radio button = " & $java_obj13 & "" & @CRLF & _
											"Pages text = " & $java_obj14 & "" & @CRLF & _
											"To label = " & $java_obj15 & "" & @CRLF & _
											"To text = " & $java_obj16 & "" & @CRLF & _
											"Copies panel = " & $java_obj17 & "" & @CRLF & _
											"Number of copies: label = " & $java_obj18 & "" & @CRLF & _
											"Collate check box = " & $java_obj19 & "" & @CRLF & _
											"Print push button = " & $java_obj20 & "" & @CRLF & _
											"Cancel push button = " & $java_obj21 & "" & @CRLF)
_JavaObjSelect("", "Cancel", "push button")

WinActivate("File System Browser")
_JavaAttachAndWait("File System Browser")
$java_obj1 = _JavaObjValueGet("", "", "list", 1)
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the File System Browser window include:" & @CRLF & @CRLF & _
										"#1 List = " & $java_obj1 & "" & @CRLF)

; Graph Layout (example 1) in Internet Explorer
$oIE = _IECreate ("http://java.sun.com/applets/jdk/1.4/demo/applets/GraphLayout/example1.html")
_IELoadWait($oIE)
WinSetState("Graph Layout (example 1) - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueGet.au3", "Please wait for the webpage and applet ""Graph Layout (example 1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Graph Layout (example 1) - Windows Internet Explorer")
$java_obj1 = _JavaObjValueGet("[CLASS:Button; INSTANCE:3]", "", "check box")
$java_obj2 = _JavaObjValueGet("[CLASS:Button; INSTANCE:4]", "", "check box")
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the Graph Layout (example 1) applet include:" & @CRLF & @CRLF & _
											"#1 Checkbox = " & $java_obj1 & "" & @CRLF & _
											"#2 Checkbox = " & $java_obj2 & "" & @CRLF)
_IEQuit($oIE)

; Draw Test (1.1) in Internet Explorer
$oIE = _IECreate ("http://java.sun.com/applets/jdk/1.4/demo/applets/DrawTest/example1.html")
_IELoadWait($oIE)
WinSetState("Draw Test (1.1) - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueGet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Draw Test (1.1) - Windows Internet Explorer")
$java_obj1 = _JavaObjValueGet("[CLASS:Button; INSTANCE:1]", "", "check box")
$java_obj2 = _JavaObjValueGet("[CLASS:Button; INSTANCE:2]", "", "check box")
$java_obj3 = _JavaObjValueGet("[CLASS:Button; INSTANCE:3]", "", "check box")
$java_obj4 = _JavaObjValueGet("[CLASS:Button; INSTANCE:4]", "", "check box")
$java_obj5 = _JavaObjValueGet("[CLASS:Button; INSTANCE:5]", "", "check box")
$java_obj6 = _JavaObjValueGet("[CLASS:Button; INSTANCE:6]", "", "check box")
$java_obj7 = _JavaObjValueGet("[CLASS:ComboBox; INSTANCE:2]", "", "combo box")
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the Draw Test (1.1) applet include:" & @CRLF & @CRLF & _
											"#1 Radiobutton = " & $java_obj1 & "" & @CRLF & _
											"#2 Radiobutton = " & $java_obj2 & "" & @CRLF & _
											"#3 Radiobutton = " & $java_obj3 & "" & @CRLF & _
											"#4 Radiobutton = " & $java_obj4 & "" & @CRLF & _
											"#5 Radiobutton = " & $java_obj5 & "" & @CRLF & _
											"#6 Radiobutton = " & $java_obj6 & "" & @CRLF & _
											"#2 combo box = " & $java_obj7 & "" & @CRLF)
_IEQuit($oIE)

; Arc Test (1.1) in Internet Explorer
$oIE = _IECreate ("http://java.sun.com/applets/jdk/1.4/demo/applets/ArcTest/example1.html")
_IELoadWait($oIE)
WinSetState("Arc Test (1.1) - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueGet.au3", "Please wait for the webpage and applet ""Arc Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Arc Test (1.1) - Windows Internet Explorer")
$java_obj1 = _JavaObjValueGet("[CLASS:Edit; INSTANCE:4]")
$java_obj2 = _JavaObjValueGet("[CLASS:Edit; INSTANCE:5]")
$java_obj3 = _JavaObjValueGet("[TEXT:Fill]", "", "push button")
$java_obj4 = _JavaObjValueGet("[TEXT:Draw]", "", "push button")
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the Arc Test (1.1) applet include:" & @CRLF & @CRLF & _
											"#1 Textbox = """ & $java_obj1 & """" & @CRLF & _
											"#1 Textbox = """ & $java_obj2 & """" & @CRLF & _
											"Fill Button = " & $java_obj3 & "" & @CRLF & _
											"Draw Button = " & $java_obj4 & "" & @CRLF)
_IEQuit($oIE)

; Java Auto-Completing Combobox Applet in Internet Explorer
$oIE = _IECreate ("http://www.somacon.com/p51.php")
_IELoadWait($oIE)
WinSetState("Java Auto-Completing Combobox Applet - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Java Auto-Completing Combobox Applet - Windows Internet Explorer")
$java_obj1 = _JavaObjValueGet("[CLASS:ListBox; INSTANCE:1]", "", "list")
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Java Auto-Completing Combobox applet have changed to:" & @CRLF & @CRLF & _
											"#1 List = " & $java_obj1 & "" & @CRLF)
_IEQuit($oIE)

; Graph Layout (example 1) in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://java.sun.com/applets/jdk/1.4/demo/applets/GraphLayout/example1.html", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueGet_IE.au3", "Please wait for the webpage and applet ""Graph Layout (example 1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Graph Layout (example 1) - Mozilla Firefox")
$java_obj1 = _JavaObjValueGet("[CLASS:Button; INSTANCE:3]", "", "check box")
$java_obj2 = _JavaObjValueGet("[CLASS:Button; INSTANCE:4]", "", "check box")
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the Graph Layout (example 1) applet include:" & @CRLF & @CRLF & _
											"#1 Checkbox = " & $java_obj1 & "" & @CRLF & _
											"#2 Checkbox = " & $java_obj2 & "" & @CRLF)
WinClose("Graph Layout (example 1) - Mozilla Firefox")

; Draw Test (1.1) in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://java.sun.com/applets/jdk/1.4/demo/applets/DrawTest/example1.html", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueGet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Draw Test (1.1) - Mozilla Firefox")
$java_obj1 = _JavaObjValueGet("[CLASS:Button; INSTANCE:1]", "", "check box")
$java_obj2 = _JavaObjValueGet("[CLASS:Button; INSTANCE:2]", "", "check box")
$java_obj3 = _JavaObjValueGet("[CLASS:Button; INSTANCE:3]", "", "check box")
$java_obj4 = _JavaObjValueGet("[CLASS:Button; INSTANCE:4]", "", "check box")
$java_obj5 = _JavaObjValueGet("[CLASS:Button; INSTANCE:5]", "", "check box")
$java_obj6 = _JavaObjValueGet("[CLASS:Button; INSTANCE:6]", "", "check box")
$java_obj7 = _JavaObjValueGet("[CLASS:ComboBox; INSTANCE:2]", "", "combo box")
MsgBox(262144, "_JavaObjValueGet_IE.au3", 	"Object values in the Draw Test (1.1) applet include:" & @CRLF & @CRLF & _
											"#1 Radiobutton = " & $java_obj1 & "" & @CRLF & _
											"#2 Radiobutton = " & $java_obj2 & "" & @CRLF & _
											"#3 Radiobutton = " & $java_obj3 & "" & @CRLF & _
											"#4 Radiobutton = " & $java_obj4 & "" & @CRLF & _
											"#5 Radiobutton = " & $java_obj5 & "" & @CRLF & _
											"#6 Radiobutton = " & $java_obj6 & "" & @CRLF & _
											"#2 combo box = " & $java_obj7 & "" & @CRLF)
WinClose("Draw Test (1.1) - Mozilla Firefox")

; Arc Test (1.1) in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://java.sun.com/applets/jdk/1.4/demo/applets/ArcTest/example1.html", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueGet.au3", "Please wait for the webpage and applet ""Arc Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Arc Test (1.1) - Mozilla Firefox")
$java_obj1 = _JavaObjValueGet("[CLASS:Edit; INSTANCE:1]")
$java_obj2 = _JavaObjValueGet("[CLASS:Edit; INSTANCE:2]")
$java_obj3 = _JavaObjValueGet("[TEXT:Fill]", "", "push button")
$java_obj4 = _JavaObjValueGet("[TEXT:Draw]", "", "push button")
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the Arc Test (1.1) applet include:" & @CRLF & @CRLF & _
										"#1 Textbox = """ & $java_obj1 & """" & @CRLF & _
										"#1 Textbox = """ & $java_obj2 & """" & @CRLF & _
										"Fill Button = " & $java_obj3 & "" & @CRLF & _
										"Draw Button = " & $java_obj4 & "" & @CRLF)
WinClose("Arc Test (1.1) - Mozilla Firefox")

; Java Auto-Completing Combobox Applet in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://www.somacon.com/p51.php", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueGet.au3", "Please wait for the webpage and applet ""Java Auto-Completing Combobox"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Java Auto-Completing Combobox Applet - Mozilla Firefox")
$java_obj1 = _JavaObjValueGet("[CLASS:ListBox; INSTANCE:1]", "", "list")
MsgBox(262144, "_JavaObjValueGet.au3", 	"Object values in the Java Auto-Completing Combobox applet include:" & @CRLF & @CRLF & _
										"#1 List = " & $java_obj1 & "" & @CRLF)
WinClose("Java Auto-Completing Combobox Applet - Mozilla Firefox")
