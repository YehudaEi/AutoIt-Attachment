; Open me using SciTE or similar and the Fold the code as flat as it will go 
; to see a reasonable outline.

#cs

Type-16 uses the numpad of a standard UK keyboard to type with, similar to the
t9 predictive typing on a mobile phone

I think that there is a patent on the t9 'stuff'. this was coded up without 
sight of that patent, so I have no idea on any ramifications.

It was coded with a UK key keyboard in mind but that should not be a problem

the numbers used for input are not the same as a mobile phone, but the positions 
are the same 
eg 
2 on a phone (abc) corrsponds to 8 on the keypad.
1 on the numpad corresponds to 7 on a phone (pqrs)


How to use
1. Import a list of words for use. The words file should be a standard .txt file 
    with each LOWER CASE word on a separate line. The file 	MUST contain at least 
	one word starting with the first character for each	typing key on the numpad.
	
2. the import function will create a <filename>.t16 file, this is used by the program
	for the predictive typing. This file and it's format is the key to everything.
	
3. the program currently defaults to using words.t16. if this exists it will be 
    automatically used. you only need to open a file if you want to use a different word list.
	
4. create some labels for your keypad 

5. start the application

6. make sure that the application that is to receiove the text has focus And
7. start typing. 

8. use the * on the numpad as a backspace when in T16 mode (this leaves the normal BS 
    available for the application) this will toggle the case between Sentence Case, 
	Title Case, Upper Case, Lower case when in 'Case' mode.
	
9. use the - on the numpad to select the previous word from the presented list

10. use the + on the numpad to select the next word on the presented list

11. use the / on the numpad to Toggle input State  T16(1), Num(2), Type(3), 'Case'(4)

12. use the 0 or the . on the numpad to accept the current word in in T16 mode 
    This also adds a space or a . to the text
	
13. Enter on the numpad will send the displayed text to the application that currently has focus.
	(But not to itself)

14. 'Esc' will Exit (the hotkey is disabled so that the confirmation can be easily accepted.)

Input Modes are:
T16: predictive input mode using the num keypad and a T16 word list.
	you MUST be in 'T16' or 'Num' mode to send text to your target applicatoin.

Num: deactivate T16 input and enable the num keypad for normal use with the exception that
		'/', '*' and 'Enter' are still hooked.
		
Type: deactivate T16 input and type using the keypad 
		e.g. 	double 8 = b
				triple 8 = c  
				single 9 = d
				etc.
				
Case: is only there to enable you to toggle the case of input text using the * key
		Ab c - Sentence case (Default)
		Ab C - Title Case
		ABC  - Upper Case
		abc  - Lower case

Set the $compact variable to 1 if you want a small compact GUI

TODO 
Update frequency of use of words and save updates to the t16 file when exiting the application.
Error trapping could be tidied before putting into production use.
Add words into the .t16 file from the application

Problems
The 'Return' key on the keyboard is inactive while this app is running. 
	(it behaves the same as the enter key on the keypad)
Variable declaration and use is a little loose and may be hiding a bug or 2 or more

Remember
1. Update the $Compactmode variable to Suit.
2. edit the $letterdelay variable to suit your needs
3. If you have more than one script that uses the same hotkeys, the second script 
   started will have problems!

#ce

#include <GUIConstants.au3>
#include <Array.au3>
#include <File.au3>
#Include <GuiList.au3>

Opt("GUIOnEventMode", 1)

Global $Compact = 1		; 1 use the compact display without the keys, otherwise show them.
Global $LetterDelay = 250	;edit this to suit

$g_szVersion = "Type16 (1.0)"
If WinExists($g_szVersion) Then 
	WinActivate ( $g_szVersion )
	Exit ; It's already running
EndIf

#region Keyboard Mapping
; If this is changed then the work list will need to be re-imported
Global $CodeTable [13][7] 
    $CodeTable[1][1] = "p"
    $CodeTable[1][2] = "q"
    $CodeTable[1][3] = "r"
    $CodeTable[1][4] = "s"
    $CodeTable[1][5] = "!"
	$CodeTable[1][6] = "1"
    $CodeTable[2][1] = "t"
    $CodeTable[2][2] = "u"
    $CodeTable[2][3] = "v"
	$CodeTable[2][4] = """"
    $CodeTable[2][5] = "2"
    $CodeTable[3][1] = "w"
    $CodeTable[3][2] = "x"
    $CodeTable[3][3] = "y"
    $CodeTable[3][4] = "z"
	$CodeTable[3][5] = "£"
    $CodeTable[3][6] = "3"
    $CodeTable[4][1] = "g"
    $CodeTable[4][2] = "h"
    $CodeTable[4][3] = "i"
	$CodeTable[4][4] = "$"
    $CodeTable[4][5] = "4"
    $CodeTable[5][1] = "j"
    $CodeTable[5][2] = "k"
    $CodeTable[5][3] = "l"
	$CodeTable[5][4] = "%"
    $CodeTable[5][5] = "5"
    $CodeTable[6][1] = "m"
    $CodeTable[6][2] = "n"
    $CodeTable[6][3] = "o"
	$CodeTable[6][4] = "^"
    $CodeTable[6][5] = "6"
    $CodeTable[7][1] = "&"
    $CodeTable[7][2] = ","
    $CodeTable[7][3] = "_"
    $CodeTable[7][4] = "?"
    $CodeTable[7][5] = "-"
    $CodeTable[7][6] = "7"
    $CodeTable[8][1] = "a"
    $CodeTable[8][2] = "b"
    $CodeTable[8][3] = "c"
    $CodeTable[8][4] = "*"
	$CodeTable[8][5] = "8"
    $CodeTable[9][1] = "d"
    $CodeTable[9][2] = "e"
    $CodeTable[9][3] = "f"
    $CodeTable[9][4] = "9"
	$CodeTable[9][5] = "("
    $CodeTable[10][1] = " " ; 0
    $CodeTable[10][2] = ")"
    $CodeTable[10][3] = ">"
    $CodeTable[10][4] = "<"
	$CodeTable[10][5] = "\"	
	$CodeTable[10][6] = "/"
	$CodeTable[11][1] = "."	; .
    $CodeTable[11][2] = "@"
    $CodeTable[11][3] = "#"
    $CodeTable[11][4] = "["
	$CodeTable[11][5] = "]"	
	$CodeTable[11][6] = ";"	
	$CodeTable[12][1] = ":"	; Enter
    $CodeTable[12][2] = "~"
    $CodeTable[12][3] = "{"
    $CodeTable[12][4] = "}"
	$CodeTable[12][5] = "|"	
#endregion Key Mapping



#region Globals

Global $numkey
Global $presscount = 0
Global $prevkey = 99
global $timer = 0
Global $CurrKeys
Global $CurrWord
Global $numstate
Global $casestate
Global $WordList[1] ;key for chars 1-8 or ' ', freq of use, word
Global $T16file = ""
Global $modestr = ""
Global $casestr = ""
Global $index[10]
#endregion Globals


#Region ### START GUI section ### 

; read the last position we were at and make sure we go to the same place
$x = RegRead("HKCU\SOFTWARE\T-16\","xpos")
$y = RegRead("HKCU\SOFTWARE\T-16\","ypos")

; A full size screen of a compact one.
If $compact = 1 Then
	$FormMain = GUICreate( "" , 160, 202, $x, $y, $WS_BORDER)
	$Input = GUICtrlCreateInput("", 0, 0, 155, 21)
	$List = GUICtrlCreateList("", 0, 24, 155, 136)
Else	
	$FormMain = GUICreate( $g_szVersion & " :T16" , 160, 385, $x, $y $WS_BORDER)
	$Input = GUICtrlCreateInput("", 0, 0, 155, 21)
	$List = GUICtrlCreateList("", 0, 220, 155, 130)
	$0 = GUICtrlCreateButton("0", 0, 184, 73, 33, 0)
	GUICtrlSetOnEvent(-1,"NUMPAD0Pressed")
	$1 = GUICtrlCreateButton("1", 0, 144, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"f1")
	$2 = GUICtrlCreateButton("2", 40, 144, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"f2")
	$3 = GUICtrlCreateButton("3", 80, 144, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"f3")
	$4 = GUICtrlCreateButton("4", 0, 104, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"f4")
	$5 = GUICtrlCreateButton("5", 40, 104, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"f5")
	$6 = GUICtrlCreateButton("6", 80, 104, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"f6")
	$7 = GUICtrlCreateButton("7", 0, 64, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"f7")
	$8 = GUICtrlCreateButton("8", 40, 64, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"f8")
	$9 = GUICtrlCreateButton("9", 80, 64, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"f9")
	$num = GUICtrlCreateButton("Num", 0, 24, 33, 33, 0)
	$div = GUICtrlCreateButton("/", 40, 24, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"NUMPADDIVPressed")
	$mult = GUICtrlCreateButton("*", 80, 24, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"NUMPADMULTPressed")
	$add = GUICtrlCreateButton("+", 120, 64, 33, 73, 0)
	GUICtrlSetOnEvent(-1,"NUMPADADDPressed")
	$sub = GUICtrlCreateButton("-", 120, 24, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"NUMPADSUBPressed")
	$enter = GUICtrlCreateButton("Enter", 120, 144, 33, 73, 0)
	GUICtrlSetOnEvent(-1,"EnterPressed")
	$dot = GUICtrlCreateButton(".", 80, 184, 33, 33, 0)
	GUICtrlSetOnEvent(-1,"NUMPADDOTPressed")
EndIf

$Menu1 = GUICtrlCreateMenu("File")
$Menu11 = GUICtrlCreateMenuItem("Open", $Menu1)
GUICtrlSetOnEvent(-1,"mnuOpen")
$Menu12 = GUICtrlCreateMenuItem("Save", $Menu1)
$Menu13 = GUICtrlCreateMenuItem("Import", $Menu1)
GUICtrlSetOnEvent(-1,"mnuImportWords")
$Menu14 = GUICtrlCreateMenuItem("Exit", $Menu1)
GUICtrlSetOnEvent(-1,"ExitProg")
$Menu2 = GUICtrlCreateMenu("Help")
$Menu21 = GUICtrlCreateMenuItem("Help", $Menu2)
GUICtrlSetOnEvent(-1,"mnuHelp")
$Menu22 = GUICtrlCreateMenuItem("About", $Menu2)
GUICtrlSetOnEvent(-1,"mnuAbout")
#EndRegion ### END GUI section ###

Init()

While 1	; the keepalive loop
	sleep(100)
WEnd

ExitProg()	; no idea why I insist on putting this here

;========================================================
Func Init()	; does exactly that
	SetNUMLOCKState()	; make sure numlock is set on
	EnableHotkeys()	; set the initial state of the hotkeys
	$numstate = 1
	$modestr = "T16"
	$casestate = 1
	$casestr = "Ab c"
	$timer = TimerInit()
	
	$T16file = RegRead("HKCU\SOFTWARE\T-16\","T-16File")	; open the last t16 file we were using
	If StringLen($T16file) < 4 Then $T16file = "words.t16"  ; or open words.t16
	OpenWords() 
		
	HotKeySet ( "{NUMPADDIV}" , "NUMPADDIVPressed")		; toggle Input mode
	HotKeySet ( "{ENTER}", "EnterPressed")				; accept text
	
	GUISetOnEvent($GUI_EVENT_CLOSE,"ExitProg")
	GUISetState(@SW_SHOW)
	
	WinSetTitle ( "", "", $g_szVersion & " -" & $modestr & "  " & $casestr)

	WinSetTrans($g_szVersion,"",220)
	WinSetOnTop($g_szVersion,"",1)

EndFunc

#region Keypad hotkey hooks

Func NUMPADDIVPressed()	; toggle the input mode
	$numstate += 1
	If $numstate = 5 Then $numstate = 1
		
	If $numstate  = 1 Then 	; T16
		EnableHotkeys()
		$modestr = "T16" 
	EndIf
	
	If $numstate  = 2 Then	; NUM
		DisableHotkeys()
		$modestr = "Num" 
	EndIf

	If $numstate  = 3 Then	; Type
		EnableHotkeys()
		$modestr =  "Type" 
	EndIf
	
	If $numstate  = 4 Then	; Change Case		
		EnableHotkeys()
		$modestr =  "Case" 
	EndIf
	
	WinSetTitle ( $g_szVersion, "", $g_szVersion & " -" & $modestr & "  " & $casestr)
	$presscount = 0
	TimerInit()
	
EndFunc

Func NUMPADMULTPressed() ; Backspace or change case when in case mode
	If $numstate = 1 Then	; T16 Mode
		If StringLen($CurrKeys) > 0 Then
			$CurrKeys = StringLeft($CurrKeys,StringLen($CurrKeys)-1)
			$presscount -= 1
			If $presscount > 0 Then
				FillList()
			Else
				_GUICtrlListClear($List)
			EndIf
		EndIf
	ElseIf $numstate = 4 Then
		$casestate += 1
		If $casestate = 5 Then $casestate = 1 ; Sentence , 	Title , Upper , Lower
		If $casestate = 1 Then $casestr = "Ab c"
		If $casestate = 2 Then $casestr = "Ab C"
		If $casestate = 3 Then $casestr = "ABC"
		If $casestate = 4 Then $casestr = "abc"
		WinSetTitle ( $g_szVersion, "", $g_szVersion & " -" & $modestr & "  " & $casestr)
	Else
		$a = GUICtrlRead($input)
		$l = StringLen($a)
		If $l > 0 Then
			$a = StringLeft($a,$l-1)
		EndIf
		GUICtrlSetData($input,$a)
	EndIf
EndFunc

Func NUMPADSUBPressed() ; Previous entry in list
	$a = _GUICtrlListSelectedIndex($List)
	If $a > 0 Then
		_GUICtrlListSelectIndex($List,$a - 1)
	EndIf
EndFunc

Func NUMPADADDPressed()	;next entry in list	
	$a = _GUICtrlListSelectedIndex($List)
	$m = _GUICtrlListCount($List)
	If $a < $m Then
		_GUICtrlListSelectIndex($List,$a + 1)
	EndIf
EndFunc

#region  Main Keypress functions
Func f1()
	$numkey = 1
	GetWord()	
EndFunc

Func f2()
	$numkey = 2
	GetWord()	
EndFunc

Func f3()
	$numkey = 3
	GetWord()	
EndFunc

Func f4()
	$numkey = 4
	GetWord()	
EndFunc

Func f5()
	$numkey = 5
	GetWord()	
EndFunc

Func f6()
	$numkey = 6
	GetWord()	
EndFunc

Func f7()
	$numkey = 7
	GetWord()	
EndFunc


Func f8()
	$numkey = 8
	GetWord()
EndFunc

Func f9()
	$numkey = 9
	GetWord()
EndFunc

#endregion Main Keypress Functions 

Func NUMPAD0Pressed()
	$numkey = 10
	If $numstate = 3 Then ; typing
		GetWord()
	Else
		AcceptWord()
		GUICtrlSetData($input,GUICtrlRead($input) & " ")
	EndIf
EndFunc

Func NUMPADDOTPressed()
	$numkey = 11
	If $numstate = 3 Then	; typing
		GetWord()
	Else
		AcceptWord()
		GUICtrlSetData($input,GUICtrlRead($input) & ".")
	EndIf
EndFunc

Func EnterPressed() ; Send contents of inputline to target application if we are not typing
;~ 	if _IsPressed("0d") Then MsgBox(0,"0d","ouch")
;~ 			if _IsPressed("2b") Then MsgBox(0,"2b","ouch")
	$numkey = 12
	If $numstate = 3 Then	; typing
		GetWord()
	Elseif $numstate = 1 Then
		If Not WinActive("Type16") Then
			send(GUICtrlRead($input))
			GUICtrlSetData($input,"")
		EndIf
	EndIf
EndFunc

#endregion Keypad hotkey hooks

Func GetWord()	; find the word we are typing or build a list when using T16
	$presscount += 1
			
	If $numstate = 3	Then ;typing
		If $presscount = 1 Then  
			$prevkey = $numkey
		EndIf
		
		$delay = TimerDiff($timer)
		If $delay > $LetterDelay Then
			$presscount = 1
		EndIf
		
		If $prevkey <> $numkey Then ; detect the change in keys pressed
			$presscount = 1
			$prevkey = $numkey
			$timer = TimerInit()
		EndIf
		
		If $presscount > ubound($CodeTable,2) - 1 Then ; loop around the list of available characters for each key.
			$presscount = 1
			$timer = TimerInit()
		EndIf

		$letter = $CodeTable[$numkey][$presscount]
		$current = GUICtrlRead($input)
		If $presscount > 1 Then
			If $delay < $LetterDelay Then	; select the next letter from the same key
				$current = StringLeft($current,stringlen($current) - 1)
			EndIf
		EndIf
		$letter = SetCase($current,$letter)
		$current &= $letter
		GUICtrlSetData($input, $current)
		$timer = TimerInit()	; Reset the timer for the next keypress
	EndIf
	
	If $numstate = 1 Then	; T16
		$CurrKeys &=  $Numkey
		FillList()
	EndIf
EndFunc
 
Func AcceptWord()	; use this word then
	If $numstate = 1 Then	; T16
		If GUICtrlRead($List) > "" Then
			$word = GUICtrlRead($list)
			$current = GUICtrlRead($input)
			$word = SetCase($current,$word)
			$current &= $word
			GUICtrlSetData($input, $current)
			_GUICtrlListClear($List)
			$CurrPress = ""
			$numkey = 0
			$CurrKeys = ""
			$CurrWord = ""
		EndIf
	EndIf
	$presscount = 0
EndFunc

Func  SetCase($current, $word) 	; make sure that the case is correct
;~  $casestate  ; Sentence(1) , 	Title (2), Upper(3) , Lower(4)9
	If $casestate = 1 Then 
		If StringLen($current) = 0 or _
			StringRight($current,2) = ". " or _
			StringRight($current,1) = "." Then 
			$word = TitleWord($word)
		EndIf
	EndIf
	If $casestate = 2 Then $word = TitleWord($word)
	If $casestate = 3 Then $word = StringUpper($word)
	If $casestate = 4 Then $word = StringLower($word) ; words should be lower case, but anyway
	Return $word
EndFunc

Func TitleWord($x)	; change words to titlecase
	Return StringUpper(stringleft($x,1)) & stringlower(stringright($x,(stringlen($x)-1)))
EndFunc

Func EnableHotkeys()
	HotKeySet ( "{NUMPADMULT}" , "NUMPADMULTPressed")
	HotKeySet ( "{NUMPADSUB}" , "NUMPADSUBPressed")
	HotKeySet ( "{NUMPADADD}" , "NUMPADADDPressed")
	HotKeySet ( "{NUMPADDOT}" , "NUMPADDOTPressed")
	HotKeySet ( "{NUMPAD0}" , "NUMPAD0Pressed")
	HotKeySet ( "{NUMPAD1}" , "f1")
	HotKeySet ( "{NUMPAD2}" , "f2")
	HotKeySet ( "{NUMPAD3}" , "f3")
	HotKeySet ( "{NUMPAD4}" , "f4")
	HotKeySet ( "{NUMPAD5}" , "f5")
	HotKeySet ( "{NUMPAD6}" , "f6")
	HotKeySet ( "{NUMPAD7}" , "f7")
	HotKeySet ( "{NUMPAD8}" , "f8")
	HotKeySet ( "{NUMPAD9}" , "f9")
EndFunc

Func DisableHotkeys()
	HotKeySet ( "{NUMPADMULT}")
	HotKeySet ( "{NUMPADSUB}")
	HotKeySet ( "{NUMPADADD}")
	HotKeySet ( "{NUMPADDOT}")
	HotKeySet ( "{NUMPAD0}")
	HotKeySet ( "{NUMPAD1}")
	HotKeySet ( "{NUMPAD2}")
	HotKeySet ( "{NUMPAD3}")
	HotKeySet ( "{NUMPAD4}")
	HotKeySet ( "{NUMPAD5}")
	HotKeySet ( "{NUMPAD6}")
	HotKeySet ( "{NUMPAD7}")
	HotKeySet ( "{NUMPAD8}")
	HotKeySet ( "{NUMPAD9}")
EndFunc

Func SetNUMLOCKState()
	local $state
    $state = DllCall("user32.dll","long","GetKeyState","long",0x90)
	If $state[0] = 0 Then
		Send("{NUMLOCK}")	; we need to have numlock on
	EndIf
EndFunc

Func FillList()
	; this could be a lot more efficient
	_GUICtrlListClear($List)
	
	local $top = UBound($Wordlist)
	$bottom = $index[StringLeft($CurrKeys,1)]
	
	For $loop = $bottom To $top -1
		$cword = $wordlist[$loop]
		If StringLeft($cword,$presscount) = $CurrKeys Then
			$lword = stringsplit($cword,"|")
			_GUICtrlListAddItem($List,$lword[3])
		Else
			If StringLeft($cword,$presscount) > $CurrKeys Then
				ExitLoop
			EndIf
		EndIf
	Next
	_GUICtrlListSelectIndex($List,0)
EndFunc

Func OpenWords()	; open the formatted list of words and key for the T16 predictive text
	; This is also a little slow, but easy to understand.
	If StringLen($T16file) < 4 Then
		$T16file = FileOpenDialog ( "Use this T16 List", @ScriptDir, "T16 File (*.T16)" ,4 )
		If @error Then
			Return
		EndIf
	EndIf
	
	_FileReadToArray($T16file,$WordList)	; read the file into an array
	_ArrayDelete($WordList,0)				; delete the number of entries read
	_ArraySort($WordList)
	_ArrayDelete($WordList,0)				; delete end of file or something
	
	$x = "zzz"
	For $rec = 0 To UBound($WordList) - 1
		If $x <> StringLeft($WordList[$rec],1) Then	; build the index for each letter key
			$x = StringLeft($WordList[$rec],1)
			Select
				Case $x = "1" 
					$index[1] = $rec
				Case $x = "2"
					$index[2] = $rec
				Case $x = "3"
					$index[3] = $rec
				Case $x = "4"
					$index[4] = $rec
				Case $x = "5"
					$index[5] = $rec
				Case $x = "6"
					$index[6] = $rec
				Case $x = "8"
					$index[8] = $rec
				Case $x = "9"
					$index[9] = $rec
			EndSelect
		EndIf
	Next

EndFunc

Func FindLetterKey($letter)	; what letter does this key represent
	For $outer = 0 to 9
		For $inner = 0 To UBound($CodeTable,2)-1
			If $letter = $CodeTable[$outer][$inner] Then
				Return $outer 
			EndIf
		Next
	Next
EndFunc

Func mnuOpen()
	$tmp = $T16file
	$T16file = ""
	OpenWords()
	If StringLen($T16file) < 4 Then
		$T16file = $tmp
	EndIf
	
EndFunc

Func mnuImportWords()	; import a list of words and format into the required T16 format
	; this function is a bit tedious and should be made a lot faster
	$timer = TimerInit()
	
	$filein = FileOpenDialog ( "Import Word List", @ScriptDir, "WordList (*.txt)" ,4 )
	$fileread = FileOpen($filein,0)
	If $fileread = -1 Then
		MsgBox(0, "Error", "Unable to open Input file.")
		Return
	EndIf

; Read in lines of text until the EOF is reached
	$fileout = StringLeft($filein,StringLen($filein)-4) & ".T16"
	$filewrite = FileOpen($fileout,2)
	If $filewrite = -1 Then
		MsgBox(0, "Error", "Unable to open Output file.")
		Return
	EndIf
	While 1
		$line = FileReadLine($fileread)
		If @error = -1 Then ExitLoop
		If StringLen(StringStripWS($line,8)) > 0 Then
			$wordarray = StringSplit($line,"")
			$lineout = ""
			ReDim $WordList[UBound($WordList) + 1][10]
			For $loop = 1 To 8 
				If $loop < $wordarray[0] + 1 Then
					$lineout = $lineout & FindLetterKey($wordarray[$loop]) 
				Else
					$lineout = $lineout & " "
				EndIf
			Next
			$lineout = $lineout & "|0|" & $line ; initial use count = 0
			FileWriteLine($filewrite,$lineout)
		EndIf
	Wend
	FileClose($fileread)
	FileClose($filewrite)
	TimerDiff($timer)
	MsgBox(0, "Import","Import into " & $fileout & @CRLF & "completed in " & StringFormat("%.2f",TimerDiff($timer)/1000) & " seconds.",5)
EndFunc

Func mnuHelp()
	$line = $g_szVersion & @CRLF & @CRLF & "Predictive typing using Autoit" & @CRLF & @CRLF
	$line = $line & "1. Import a list of words for use. The words file should be a standard .txt file " & @CRLF 
    $line = $line &  "   with each LOWER CASE word on a separate line. The file MUST be sorted ASC and" & @CRLF 
	$line = $line &  "   MUST contain at least one word starting with the first character for each" & @CRLF 
	$line = $line &  "   typing key on the keypad." & @CRLF 
	$line = $line &  "2. the import function will create a <filename>.t16 file, this is used by the program" & @CRLF 
	$line = $line &  "   or the predictive typing. This file and it's format is the key to everything." & @CRLF 
	$line = $line &  "3. the program currently defaults to using words.t16. if this exists it will be " & @CRLF 
    $line = $line &  "a   utomatically used. you only need to open a file if you want to use a different word list." & @CRLF 
	$line = $line &  "4. create some labels for your keypad" & @CRLF 
	$line = $line &  "5. start the application" & @CRLF & @CRLF
	$line = $line &  "6. make sure that the application that is to receive the text has focus And" & @CRLF 
	$line = $line &  "7. start typing. " & @CRLF 
	$line = $line &  "8. use the * on the numpad as a backspace when in T16 mode (this leaves the normal BS " & @CRLF 
    $line = $line &  "   available for the application) this will toggle the case between Sentence Case, " & @CRLF 
	$line = $line &  "   Title Case, Upper Case, Lower case when in 'Case' mode." & @CRLF 
	$line = $line &  "9. use the - on the numpad to select the previous word from the presented list" & @CRLF 
	$line = $line & "10. use the + on the numpad to select the next word on the presented list" & @CRLF 
	$line = $line &  "11. use the / on the numpad to Toggle input State  T16(1), Num(2), Type(3), 'Case'(4)" & @CRLF 
	$line = $line &  "12. use the 0 or the . on the numpad to accept the current word in in T16 mode " & @CRLF 
    $line = $line &  "    This also adds a space or a . to the text" & @CRLF 
	$line = $line &  "13. Enter on the numpad will send the displayed text to the application that currently has focus." & @CRLF &@CRLF
	$line = $line &  "14.'Esc' will Exit if TType16 has focus" & @CRLF
	$line = $line &  "   (the hotkey is disabled so that the confirmation can be easily accepted.)" & @CRLF 

Msgbox(0,"Help",$line)
EndFunc

Func mnuAbout()
	Msgbox(0,"About",$g_szVersion & @CRLF & @CRLF & "Predictive typing using Autoit")
EndFunc

Func ExitProg()
	HotKeySet ( "{ENTER}")	; disable the hotkey so we can exit easily
	If MsgBox(4,"Exit Program","Are you sure?") = 6 Then
		; save our current position for next time
		$pos = WinGetPos($g_szVersion)
		RegWrite("HKCU\SOFTWARE\T-16","xpos","REG_SZ",$pos[0])
		RegWrite("HKCU\SOFTWARE\T-16","ypos","REG_SZ",$pos[1])
		; save the file we are using
		RegWrite("HKCU\SOFTWARE\T-16","T-16File","REG_SZ",$T16file)
		GUIDelete()
		Exit
	EndIf
	HotKeySet ( "{ENTER}" , "EnterPressed") ; We did not exit so enable it again.
EndFunc