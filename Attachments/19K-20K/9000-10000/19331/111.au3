#include<inet.au3>
#include<ie.au3>
#include <String.au3>
#include <array.au3>
HotKeySet("{ESC}", "oo")
While 1
	$name = InputBox("Hello", "Please type the artists name", "")
	$nnn = StringReplace($name, " ", "+")
	$oie = _IECreate("                                  ;_ylt=A0geu6g2_7lHAKEABbeEzbkF?p=%22" & $nnn & "%22&y=Search&fr=&ei=UTF-8", 0, 0)
	$text = _IEBodyReadText($oie)
	$cat = StringSplit($text, "Category: ", 1)
	;_ArrayDisplay($cat)
	If StringInStr($cat[2], ">") Then
		$cat1 = StringSplit($cat[2], ">")
		$br = 1

		MsgBox(0, "RESULT1:", $cat1[1])
	Else
		MsgBox(0, "RESULT1:", "Sorry, try another")
	EndIf
WEnd


Func oo()
	Exit
EndFunc   ;==>oo