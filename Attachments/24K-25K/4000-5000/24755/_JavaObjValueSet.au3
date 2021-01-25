#include <IE.au3>
#include <Java.au3>

MsgBox(262144, "_JavaObjValueSet.au3", 	"You must perform the following steps before continuing with script:" & @CRLF & _
										"1.  Download jEdit from ""www.jedit.org""." & @CRLF & _
										"2.  Install jEdit on your computer." & @CRLF & _
										"3.  Start jEdit and select the menu item ""Utilities -> File System Browser""" & @CRLF & _
										"4.  Select the menu item ""File -> Print...""" & @CRLF & _
										"5.  If you don't have Mozilla Firefox installed, download it from ""www.mozilla.com/firefox""." & @CRLF & _
										"6.  Install Mozilla Firefox on your computer." & @CRLF & _
										"7.  Download ""piface.zip"" from ""http://www.autoitscript.com/forum/index.php?showtopic=87956""." & @CRLF & _
										"8.  Extract ""piface.zip"" to a location on your computer." & @CRLF & _
										"9.  Run ""piface_start.bat""." & @CRLF & _
										"10. In the ""About Piface"" window, click ""OK""." & @CRLF & _
										"11. In the ""Piface Application Selector"" window, click ""Run dialog""." & @CRLF)

; Piface

_JavaAttachAndWait("Piface Application Selector")
$java_obj1 = _JavaObjValueSet("[CLASS:ComboBox; INSTANCE:1]", "", "combo box", "CI for one mean", 1, 1, 1, @CRLF, 1, 1, 1, 5, 3, 1, 1, 5, 3)
MsgBox(262144, "_JavaObjValueSet.au3", 	"Object values in the Piface Application Selector window have changed to:" & @CRLF & @CRLF & _
										"#1 Combo Box = ""CI for one mean""" & @CRLF)

_JavaAttachAndWait("CI for a proportion")
$java_obj1 = _JavaObjValueSet("[CLASS:Edit; INSTANCE:1]", "", "", "500")
$java_obj2 = _JavaObjValueSet("[CLASS:Edit; INSTANCE:2]", "", "", ".75")
$java_obj3 = _JavaObjValueSet("[CLASS:ComboBox; INSTANCE:1]", "", "combo box", 4)
MsgBox(262144, "_JavaObjValueGet_Jar.au3", 	"Object values in the CI for a proportion window have changed to:" & @CRLF & @CRLF & _
											"#1 Text Box = ""500""" & @CRLF & _
											"#2 Text Box = "".75""" & @CRLF & _
											"#1 Combo Box = ""0.99""" & @CRLF)

; jEdit

WinActivate("Print")
_JavaAttachAndWait("Print")
$java_obj1 = _JavaObjValueSet("", "Name:", "combo box", "Generic / Text Only")
$java_obj2 = _JavaObjValueSet("", "", "text", "5", 3)
MsgBox(262144, "_JavaObjValueSet.au3", 	"Object values in the Print window have changed to:" & @CRLF & @CRLF & _
											"Name: combo box = ""Generic / Text Only""" & @CRLF & _
											"Number of copies: text = ""5""" & @CRLF)
_JavaObjSelect("", "Cancel", "push button")

WinActivate("File System Browser")
_JavaAttachAndWait("File System Browser")
$java_obj1 = _JavaObjValueSet("", "", "list", "jEdit", 1)
MsgBox(262144, "_JavaObjValueSet.au3", 	"Object values in the Print window have changed to:" & @CRLF & @CRLF & _
											"#1 list = ""jEdit""" & @CRLF)

; Arc Test (1.1) in Internet Explorer
$oIE = _IECreate ("http://java.sun.com/applets/jdk/1.4/demo/applets/ArcTest/example1.html")
_IELoadWait($oIE)
WinSetState("Arc Test (1.1) - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSet.au3", "Please wait for the webpage and applet ""Arc Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Arc Test (1.1) - Windows Internet Explorer")
$java_obj1 = _JavaObjValueSet("[CLASS:Edit; INSTANCE:4]", "", "", "111")
$java_obj2 = _JavaObjValueSet("[CLASS:Edit; INSTANCE:5]", "", "", "222")
MsgBox(262144, "_JavaObjValueSet.au3", 	"Object values in the Arc Test (1.1) applet have changed to:" & @CRLF & @CRLF & _
										"#1 Textbox = ""111""" & @CRLF & _
										"#2 Textbox = ""222""" & @CRLF)
_IEQuit($oIE)

; Draw Test (1.1) in Internet Explorer
$oIE = _IECreate ("http://java.sun.com/applets/jdk/1.4/demo/applets/DrawTest/example1.html")
_IELoadWait($oIE)
WinSetState("Draw Test (1.1) - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValuesGet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Draw Test (1.1) - Windows Internet Explorer")
$java_obj1 = _JavaObjValueSet("[CLASS:ComboBox; INSTANCE:2]", "", "combo box", 2)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Draw Test (1.1) applet have changed to:" & @CRLF & @CRLF & _
											"#2 Combo Box = ""Points""" & @CRLF)
_IEQuit($oIE)

; Java Auto-Completing Combobox Applet in Internet Explorer
$oIE = _IECreate ("http://www.somacon.com/p51.php")
_IELoadWait($oIE)
WinSetState("Java Auto-Completing Combobox Applet - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Java Auto-Completing Combobox Applet - Windows Internet Explorer")
$java_obj1 = _JavaObjValueSet("[CLASS:ListBox; INSTANCE:1]", "", "list", "Thirty Three", 1, 1, 1, @CRLF, 1, 1, 1, 5, 3, 1, 1, 5, 3)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Java Auto-Completing Combobox applet have changed to:" & @CRLF & @CRLF & _
											"#1 List Box = ""Thirty Three""" & @CRLF)
_IEQuit($oIE)

; Arc Test (1.1) in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://java.sun.com/applets/jdk/1.4/demo/applets/ArcTest/example1.html", "", @SW_MAXIMIZE)
WinSetState("Arc Test (1.1) - Mozilla Firefox", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSet.au3", "Please wait for the webpage and applet ""Arc Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Arc Test (1.1) - Mozilla Firefox")
$java_obj1 = _JavaObjValueSet("[CLASS:Edit; INSTANCE:1]", "", "", "111")
$java_obj2 = _JavaObjValueSet("[CLASS:Edit; INSTANCE:2]", "", "", "222")
MsgBox(262144, "_JavaObjValueSet.au3", 	"Object values in the Arc Test (1.1) applet have changed to:" & @CRLF & @CRLF & _
										"#1 Textbox = ""111""" & @CRLF & _
										"#2 Textbox = ""222""" & @CRLF)
WinClose("Arc Test (1.1) - Mozilla Firefox")

; Draw Test (1.1) in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://java.sun.com/applets/jdk/1.4/demo/applets/DrawTest/example1.html", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueGet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Draw Test (1.1) - Mozilla Firefox")
$java_obj1 = _JavaObjValueSet("[CLASS:ComboBox; INSTANCE:1]", "", "combo box", 2)
$java_obj1_str = _ArrayToString($java_obj1, @CRLF, 1)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Draw Test (1.1) applet have changed to:" & @CRLF & @CRLF & _
											"#1 Combo Box = ""Points""" & @CRLF)
WinClose("Draw Test (1.1) - Mozilla Firefox")

; Java Auto-Completing Combobox Applet in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://www.somacon.com/p51.php", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueSet.au3", "Please wait for the webpage and applet ""Java Auto-Completing Combobox"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Java Auto-Completing Combobox Applet - Mozilla Firefox")
$java_obj1 = _JavaObjValueSet("[CLASS:ListBox; INSTANCE:1]", "", "list", "Drowning in", 1, 1, 1, @CRLF, 1, 1, 1, 5, 3, 1, 1, 5, 3)
MsgBox(262144, "_JavaObjValueSet.au3", 	"Object values in the Java Auto-Completing Combobox applet have changed to:" & @CRLF & @CRLF & _
										"#1 List Box = ""Drowning In A Daydream""" & @CRLF)
WinClose("Java Auto-Completing Combobox Applet - Mozilla Firefox")
