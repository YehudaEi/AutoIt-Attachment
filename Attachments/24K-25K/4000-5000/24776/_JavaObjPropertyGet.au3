#include <IE.au3>
#include <Java.au3>

MsgBox(262144, "_JavaObjPropertyGet.au3", 	"You must perform the following steps before continuing with script:" & @CRLF & _
											"1.  Download jEdit from ""www.jedit.org""." & @CRLF & _
											"2.  Install jEdit on your computer." & @CRLF & _
											"3.  Start jEdit and select the menu item ""Utilities -> File System Browser""" & @CRLF)

; jEdit

_JavaAttachAndWait("File System Browser")
$java_prop1 = _JavaObjPropertyGet("", "Path:", "text", 1, "Name")
$java_prop2 = _JavaObjPropertyGet("", "Path:", "text", 1, "Description")
$java_prop3 = _JavaObjPropertyGet("", "Path:", "text", 1, "Role")
$java_prop4 = _JavaObjPropertyGet("", "Path:", "text", 1, "Role in en_US locale")
$java_prop5 = _JavaObjPropertyGet("", "Path:", "text", 1, "States")
$java_prop6 = _JavaObjPropertyGet("", "Path:", "text", 1, "States in en_US locale")
$java_prop7 = _JavaObjPropertyGet("", "Path:", "text", 1, "Index in parent")
$java_prop8 = _JavaObjPropertyGet("", "Path:", "text", 1, "Children count")
$java_prop9 = _JavaObjPropertyGet("", "Path:", "text", 1, "Bounding rectangle")
$java_prop10 = _JavaObjPropertyGet("", "Path:", "text", 1, "Top-level window name")
$java_prop11 = _JavaObjPropertyGet("", "Path:", "text", 1, "Top-level window role")
$java_prop12 = _JavaObjPropertyGet("", "Path:", "text", 1, "Parent name")
$java_prop13 = _JavaObjPropertyGet("", "Path:", "text", 1, "Parent role")
$java_prop14 = _JavaObjPropertyGet("", "Path:", "text", 1, "Visible descendents count")
$java_prop15 = _JavaObjPropertyGet("", "Path:", "text", 1, "Number of actions")
$java_prop16 = _JavaObjPropertyGet("", "Path:", "text", 1, "Action 0 name")
$java_prop17 = _JavaObjPropertyGet("", "Path:", "text", 1, "Action 1 name")
$java_prop18 = _JavaObjPropertyGet("", "Path:", "text", 1, "Action 2 name")
$java_prop19 = _JavaObjPropertyGet("", "Path:", "text", 1, "Mouse point at text index")
$java_prop20 = _JavaObjPropertyGet("", "Path:", "text", 1, "Caret at text index")
$java_prop21 = _JavaObjPropertyGet("", "Path:", "text", 1, "Char count")
$java_prop22 = _JavaObjPropertyGet("", "Path:", "text", 1, "Selection start index")
$java_prop23 = _JavaObjPropertyGet("", "Path:", "text", 1, "Selection end index")
$java_prop24 = _JavaObjPropertyGet("", "Path:", "text", 1, "Selected text")
$java_prop25 = _JavaObjPropertyGet("", "Path:", "text", 1, "Character bounding rectangle")
$java_prop26 = _JavaObjPropertyGet("", "Path:", "text", 1, "Line bounds")
$java_prop27 = _JavaObjPropertyGet("", "Path:", "text", 1, "Character")
$java_prop28 = _JavaObjPropertyGet("", "Path:", "text", 1, "Word")
$java_prop29 = _JavaObjPropertyGet("", "Path:", "text", 1, "Sentence")
$java_prop30 = _JavaObjPropertyGet("", "Path:", "text", 1, "Core attributes")
$java_prop31 = _JavaObjPropertyGet("", "Path:", "text", 1, "Background color")
$java_prop32 = _JavaObjPropertyGet("", "Path:", "text", 1, "Foreground color")
$java_prop33 = _JavaObjPropertyGet("", "Path:", "text", 1, "Font family")
$java_prop34 = _JavaObjPropertyGet("", "Path:", "text", 1, "Font size")
$java_prop35 = _JavaObjPropertyGet("", "Path:", "text", 1, "First line indent")
$java_prop36 = _JavaObjPropertyGet("", "Path:", "text", 1, "Left indent")
$java_prop37 = _JavaObjPropertyGet("", "Path:", "text", 1, "Right indent")
$java_prop38 = _JavaObjPropertyGet("", "Path:", "text", 1, "Line spacing")
$java_prop39 = _JavaObjPropertyGet("", "Path:", "text", 1, "Space above")
$java_prop40 = _JavaObjPropertyGet("", "Path:", "text", 1, "Space below")
$java_prop41 = _JavaObjPropertyGet("", "Path:", "text", 1, "Full attribute string")
$java_prop42 = _JavaObjPropertyGet("", "Path:", "text", 1, "Attribute run")
MsgBox(262144, "_JavaObjPropertyGet.au3", 	"Property values in the File System Browser window include:" & @CRLF & @CRLF & _
											"Name = " & $java_prop1 & "" & @CRLF & _
											"Description = " & $java_prop2 & "" & @CRLF & _
											"Role = " & $java_prop3 & "" & @CRLF & _
											"Role in en_US locale = " & $java_prop4 & "" & @CRLF & _
											"States = " & $java_prop5 & "" & @CRLF & _
											"States in en_US locale = " & $java_prop6 & "" & @CRLF & _
											"Index in parent = " & $java_prop7 & "" & @CRLF & _
											"Children count = " & $java_prop8 & "" & @CRLF & _
											"Bounding rectangle = " & $java_prop9 & "" & @CRLF & _
											"Top-level window name = " & $java_prop10 & "" & @CRLF & _
											"Top-level window role = " & $java_prop11 & "" & @CRLF & _
											"Parent name = " & $java_prop12 & "" & @CRLF & _
											"Parent role = " & $java_prop13 & "" & @CRLF & _
											"Visible descendents count = " & $java_prop14 & "" & @CRLF & _
											"Number of actions = " & $java_prop15 & "" & @CRLF & _
											"Action 0 name = " & $java_prop16 & "" & @CRLF & _
											"Action 1 name = " & $java_prop17 & "" & @CRLF & _
											"Action 2 name = " & $java_prop18 & "" & @CRLF & _
											"Mouse point at text index = " & $java_prop19 & "" & @CRLF & _
											"Caret at text index = " & $java_prop20 & "" & @CRLF & _
											"Char count = " & $java_prop21 & "" & @CRLF & _
											"Selection start index = " & $java_prop22 & "" & @CRLF & _
											"Selection end index = " & $java_prop23 & "" & @CRLF & _
											"Selected text = " & $java_prop24 & "" & @CRLF & _
											"Character bounding rectangle = " & $java_prop25 & "" & @CRLF & _
											"Line bounds = " & $java_prop26 & "" & @CRLF & _
											"Character = " & $java_prop27 & "" & @CRLF & _
											"Word = " & $java_prop28 & "" & @CRLF & _
											"Sentence = " & $java_prop29 & "" & @CRLF & _
											"Core attributes = " & $java_prop30 & "" & @CRLF & _
											"Background color = " & $java_prop31 & "" & @CRLF & _
											"Foreground color = " & $java_prop32 & "" & @CRLF & _
											"Font family = " & $java_prop33 & "" & @CRLF & _
											"Font size = " & $java_prop34 & "" & @CRLF & _
											"First line indent = " & $java_prop35 & "" & @CRLF & _
											"Left indent = " & $java_prop36 & "" & @CRLF & _
											"Right indent = " & $java_prop37 & "" & @CRLF & _
											"Line spacing = " & $java_prop38 & "" & @CRLF & _
											"Space above = " & $java_prop39 & "" & @CRLF & _
											"Space below = " & $java_prop40 & "" & @CRLF & _
											"Full attribute string = " & $java_prop41 & "" & @CRLF & _
											"Attribute run = " & $java_prop42 & "" & @CRLF)
