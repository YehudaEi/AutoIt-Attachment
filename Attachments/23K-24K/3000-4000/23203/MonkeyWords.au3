#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Monkeyboy.ico
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <INet.au3>
#include <array.au3>
#include <Constants.au3>
global $show = True
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)
TraySetOnEvent ($TRAY_EVENT_PRIMARYDOWN, "ToggleHide" )
TraySetState(1)
AdlibEnable("TimeStamp", 60000)
$minimize = True
TimeStamp()
ConsoleWrite("Monkey Theory Tester" & @CRLF & "Random Word Generator" & @CRLF)
WinSetTitle(@ScriptDir,'',"0 Words Found - Monkey Theorem")
$hWnd = WinGetHandle("0 Words Found - Monkey Theorem")
ToolTip("0 Words Found",0,0)
$found = 0
Global $letter
global $word
Dim $word1
While 1
	If Not WinActive($hWnd) And $show = True Then
		ToggleHide()
	EndIf
	$crlfatend = Random(1, 10, 1)
	SelectLetter()
	$word1 = $word1 & $letter
	If $crlfatend = 6 Then
		checkifisword($word1)
		$word1 = ""
	EndIf
WEnd
Func checkifisword($word)
	$inet = _INetGetSource('http://www.merriam-webster.com/dictionary/' & $word)

	If StringInStr($inet, "Suggestions for <STRONG>" & $word & "</STRONG>:", 0) > 1 Then
		ConsoleWrite($word & ", ")
	ElseIf StringLen($word) > 2 Then
		$found += 1
		If $found = 1 Then
			WinSetTitle($hWnd,'',"1 Word Found - Monkey Theorem")
			ToolTip("1 Word Found",0,0)
		Else
			WinSetTitle($hWnd,'',$found & " Words Found - Monkey Theorem")
			ToolTip($found & " Words Found",0,0)
		EndIf	
		ConsoleWrite(@CRLF & "-----------------------------------------------" & @CRLF & _
				"word found: " & $word & @CRLF & _
				"-----------------------------------------------" & @CRLF)
		If StringInStr($inet, '<span class="sense_content">') Then
			$string = StringSplit($inet, '<span class="sense_content">', 1)
			$string = StringSplit($string[2], '</span>', 1)
			$string = StringRegExpReplace($string[1], "(<(.*?)>)", "")
			$string = StringSplit($string, @CRLF)
			ConsoleWrite("Meaning: " & $string[1] & @CRLF)
			FileWrite("MonkeyWords.txt", $word & @TAB & @TAB & "Meaning: " & $string[1] & @CRLF)
		Else
			ConsoleWrite("Meaning: Not found." & @CRLF)
			FileWrite("MonkeyWords.txt", $word & @TAB & @TAB & "Meaning: Not found." & @CRLF)
		EndIf
		If $minimize = True Then
			$minimize = False
			ToggleHide()
			MsgBox(0,"Window Hidden","The window has been hidden. You can view the progress in the top-left corner of your screen." & @CRLF & "To Show this window again, click the tray icon.")
		EndIf
	EndIf
EndFunc   ;==>checkifisword

Func SelectLetter()
	$rand = Random(0, 1000, 1)
	Select
		Case $rand < 82
			$letter = "a"
		Case $rand < 97
			$letter = "b"
		Case $rand < 124
			$letter = "c"
		Case $rand < 167
			$letter = "d"
		Case $rand < 294
			$letter = "e"
		Case $rand < 316
			$letter = "f"
		Case $rand < 336
			$letter = "g"
		Case $rand < 397
			$letter = "h"
		Case $rand < 467
			$letter = "i"
		Case $rand < 469
			$letter = "j"
		Case $rand < 476
			$letter = "k"
		Case $rand < 516
			$letter = "l"
		Case $rand < 541
			$letter = "m"
		Case $rand < 608
			$letter = "n"
		Case $rand < 683
			$letter = "o"
		Case $rand < 702
			$letter = "p"
		Case $rand < 703
			$letter = "q"
		Case $rand < 763
			$letter = "r"
		Case $rand < 826
			$letter = "s"
		Case $rand < 917
			$letter = "t"
		Case $rand < 945
			$letter = "u"
		Case $rand < 954
			$letter = "v"
		Case $rand < 978
			$letter = "w"
		Case $rand < 980
			$letter = "x"
		Case $rand < 999
			$letter = "y"
		Case $rand < 1000
			$letter = "z"
	EndSelect
EndFunc   ;==>SelectLetter

Func TimeStamp()
	$time = @MDAY & "-" & @MON & "-" & @YEAR & " at " & @HOUR & ":" & @MIN
	FileWrite("MonkeyWords.txt", $time & @CRLF)
EndFunc   ;==>TimeStamp

Func ToggleHide()
	If $show = False Then
		WinActivate($hWnd)
		WinSetState($hWnd,'',@SW_SHOW)
	Else
		WinSetState($hWnd,'',@SW_HIDE)
	EndIf
	$show = Not $show
EndFunc