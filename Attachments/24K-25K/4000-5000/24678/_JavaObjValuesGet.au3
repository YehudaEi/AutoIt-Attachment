#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#Include <Array.au3>
#include <IE.au3>
#include <Java.au3>
#Include <GuiComboBox.au3>
#Include <GuiListBox.au3>

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
										"10. In the ""About Piface"" window, click ""OK""." & @CRLF & _
										"11. In the ""Piface Application Selector"" window, click ""Run dialog""." & @CRLF)

; Piface

WinActivate("Piface Application Selector")
_JavaAttachAndWait("Piface Application Selector")
$java_obj1 = _JavaObjValuesGet("[CLASS:ComboBox; INSTANCE:1]", "", "combo box", 1, 1, @CRLF, 1, 1, 0, 5, 3, 1, 1, 5, 3)
$java_obj1_str = _ArrayToString($java_obj1, @CRLF)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Piface Application Selector window include:" & @CRLF & @CRLF & _
											"#1 Combo Box = " & $java_obj1_str & "" & @CRLF)

WinActivate("CI for a proportion")
_JavaAttachAndWait("CI for a proportion")
$java_obj1 = _JavaObjValuesGet("[CLASS:ComboBox; INSTANCE:1]", "", "combo box", 1, 1, @CRLF, 1, 1, 0, 5, 3, 1, 1, 5, 3)
$java_obj1_str = _ArrayToString($java_obj1, @CRLF)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the CI for a proportion window include:" & @CRLF & @CRLF & _
											"#1 Combo Box = " & $java_obj1_str & "" & @CRLF)

; jEdit

WinActivate("Print")
_JavaAttachAndWait("Print")
$java_obj1 = _JavaObjValuesGet("", "Name:", "combo box")
$java_obj1_str = _ArrayToString($java_obj1, @CRLF, 1)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Print window include:" & @CRLF & @CRLF & _
											"Name: Combo Box = " & $java_obj1_str & "" & @CRLF)
_JavaObjSelect("", "Cancel", "push button")

WinActivate("File System Browser")
_JavaAttachAndWait("File System Browser")
$java_obj1 = _JavaObjValuesGet("", "", "list", 1)
$java_obj1_str = _ArrayToString($java_obj1, @CRLF, 1)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the File System Browser window include:" & @CRLF & @CRLF & _
											"#1 List = " & $java_obj1_str & "" & @CRLF)

; Draw Test (1.1) in Internet Explorer
$oIE = _IECreate ("http://java.sun.com/applets/jdk/1.4/demo/applets/DrawTest/example1.html")
_IELoadWait($oIE)
WinSetState("Draw Test (1.1) - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValuesGet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Draw Test (1.1) - Windows Internet Explorer")
$java_obj1 = _JavaObjValuesGet("[CLASS:ComboBox; INSTANCE:2]", "", "combo box", 1, 1, @CRLF, 1, 1, 0, 5, 3, 1, 1, 5, 3)
$java_obj1_str = _ArrayToString($java_obj1, @CRLF, 1)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Draw Test (1.1) applet include:" & @CRLF & @CRLF & _
											"#1 Combo Box = " & $java_obj1_str & "" & @CRLF)
_IEQuit($oIE)

; Java Auto-Completing Combobox Applet in Internet Explorer
$oIE = _IECreate ("http://www.somacon.com/p51.php")
_IELoadWait($oIE)
WinSetState("Java Auto-Completing Combobox Applet - Windows Internet Explorer", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValuesGet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Java Auto-Completing Combobox Applet - Windows Internet Explorer")
$java_obj1 = _JavaObjValuesGet("[CLASS:ListBox; INSTANCE:1]", "", "list", 1, 1, @CRLF, 1, 1, 0, 5, 3, 1, 1, 5, 3)
$java_obj1_str = _ArrayToString($java_obj1, @CRLF, 1)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Java Auto-Completing Combobox applet include:" & @CRLF & @CRLF & _
											"#1 List Box = " & $java_obj1_str & "" & @CRLF)
_IEQuit($oIE)

; Draw Test (1.1) in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://java.sun.com/applets/jdk/1.4/demo/applets/DrawTest/example1.html", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValueGet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Draw Test (1.1) - Mozilla Firefox")
$java_obj1 = _JavaObjValuesGet("[CLASS:ComboBox; INSTANCE:1]", "", "combo box", 1, 1, @CRLF, 1, 1, 0, 5, 3, 1, 1, 5, 3)
$java_obj1_str = _ArrayToString($java_obj1, @CRLF, 1)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Draw Test (1.1) applet include:" & @CRLF & @CRLF & _
											"#1 Combo Box = " & $java_obj1_str & "" & @CRLF)
WinClose("Draw Test (1.1) - Mozilla Firefox")

; Java Auto-Completing Combobox Applet in Firefox
Run(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe http://www.somacon.com/p51.php", "", @SW_MAXIMIZE)
MsgBox(262144, "_JavaObjValuesGet.au3", "Please wait for the webpage and applet ""Draw Test (1.1)"" to finish loading before clicking ""OK""")
_JavaAttachAndWait("Java Auto-Completing Combobox Applet - Mozilla Firefox")
$java_obj1 = _JavaObjValuesGet("[CLASS:ListBox; INSTANCE:1]", "", "list", 1, 1, @CRLF, 1, 1, 0, 5, 3, 1, 1, 5, 3)
$java_obj1_str = _ArrayToString($java_obj1, @CRLF, 1)
MsgBox(262144, "_JavaObjValuesGet.au3", 	"Object values in the Java Auto-Completing Combobox applet include:" & @CRLF & @CRLF & _
											"#1 List Box = " & $java_obj1_str & "" & @CRLF)
WinClose("Java Auto-Completing Combobox Applet - Mozilla Firefox")
