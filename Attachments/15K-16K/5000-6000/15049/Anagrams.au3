#cs
 __              ___    ___             
/\ \            /\_ \  /\_ \            
\ \ \___      __\//\ \ \//\ \     ___   
 \ \  _ `\  /'__`\\ \ \  \ \ \   / __`\ 
  \ \ \ \ \/\  __/ \_\ \_ \_\ \_/\ \ \ \
   \ \_\ \_\ \____\/\____\/\____\ \____/
    \/_/\/_/\/____/\/____/\/____/\/___/ 

§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
§---Script by-: _Kurt                                        §
§---Email-----: kurtspivak@hotmail.com                       §
§---Purpose---: -Using String functions, _InetGetSource      §
§               -Own in TextTwist and Anagrammatics          §
§--Thanks to--:   Valuater   -   Restart function            §
§                 Jdeb       -   Help with replacing @CRLF's §
§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
#ce

#include <GuiConstants.au3>
#Include <Misc.au3>
#include <Inet.au3>
#include <String.au3>
Global $file = @TempDir & "\Anagrams.dat", $text, $NewTitle1 = _RandomText(30)
If NOT FileExists($file) Then
	MsgBox(0,"","The program has detected that this is your first" & @CRLF & "time running, please configure your settings.")
	Settings(1)
EndIf
If _Singleton(@ScriptFullPath,1) = 0 Then
    Msgbox(0,"","An occurence of this program is already running")
    Exit
EndIf
$line  = FileReadLine($file)
$split = StringSplit($line, "|")
If NOT IsArray($split) Then Settings(1);The 1 parameter indicates that the settings MUST be configured
If $split[1] = "Safe" Then
	$GUI = GUICreate("Anagrammatic Helper - " & $NewTitle1, 750, 485)
Else
	If $split[1] = "Safest" Then
		$GUI  = GUICreate($NewTitle1, 750, 485)
	Else
		If $split[1] = "Unsafe" Then
			$GUI = GUICreate("Anagrammatic Helper", 750, 485)
		Else
			If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(52,"","" & @CRLF & "There is something wrong with your settings." & @CRLF & "Would you like to configure them?")
			Select
			Case $iMsgBoxAnswer = 6 ;Yes
				FileDelete($file)
				Settings(1)
			Case $iMsgBoxAnswer = 7 ;No
				Exit
			EndSelect
		EndIf
	EndIf
EndIf
If $split[2] = "                                            " Then
	$l = -130
	$t = -160
	$w = 670
	$h = 590
Else
	If $split[2] = "http://www.miniclip.com/games/anagrammatic/en/" Then
		$l = -45
		$t = -215
		$w = 620
		$h = 640
	Else
		If $split[2] = " " Then
			$l = 0
			$t = 0
			$w = 0
			$h = 0
		Else
			MsgBox(0,"","ERROR: Please reconfigure your settings immediately");If one out of the three options aren't found.
			Settings(1)
		EndIf
	EndIf
EndIf
$filemenu  = GuiCtrlCreateMenu ("| M o r e |")
$CheckCon  = GuiCtrlCreateMenu ("Check A Connection ..",$filemenu)
$CheckCon1 = GuiCtrlCreateMenuitem ("My Internet Connection",$CheckCon)
$CheckCon2 = GuiCtrlCreateMenuitem ("Anagrammatic's Site",$CheckCon)
$Report    = GuiCtrlCreateMenuitem ("Report A Problem ..",$filemenu)
$ReLoad    = GuiCtrlCreateMenuitem ("Reload Web Page ..",$filemenu)
$filemenu2 = GuiCtrlCreateMenu ("| S e t t i n g s |")
$Settings  = GUICtrlCreateMenuitem ("Configure Your Settings ..",$filemenu2)
GuiCtrlCreateMenuitem ("",$filemenu)
$exititem  = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$oIE = ObjCreate("Shell.Explorer.2") 
$obj = GUICtrlCreateObj($oIE, $l, $t, $w, $h)
If $split[2] = " " Then
	GUICtrlSetState($obj, $GUI_HIDE)
Else
	$oIE.navigate($split[2])
EndIf
$label = GUICtrlCreateLabel("Scrambled Letters:", 5, 437, 145)
GUICtrlSetFont($label, 9, 400, 0, "Arial Bold")
GUICtrlSetColor($label, 0x007F00)
$find = GuiCtrlCreateButton("Find Words", 330, 435, 80, 20, $BS_DEFPUSHBUTTON)
GUICtrlSetFont(-1, 9, 400, 0, "Arial Bold")
$label2 = GUICtrlCreateLabel("Minimum Letters:", 423, 437, 100)
GUICtrlSetFont($label2, 9, 400, 0, "Arial Bold")
GUICtrlSetColor($label2, 0x007F00)
$min2 = GUICtrlCreateInput($split[3], 530, 435, 40, 20)
$min = GUICtrlCreateUpdown($min2)
GUICtrlSetLimit($min, 9, 2)
$result = GUICtrlCreateLabel("Results for:  ", 582, 2, 163, 20, 1, 15)
$txt = GUICtrlCreateLabel("",585,25,160,438)
$find2 = GUICtrlCreateInput("", 125, 435, 195, 20)
GUICtrlSetState($find2, $GUI_FOCUS)
GUISetState()
$begin = TimerInit()
While 1
	$split = StringSplit($line, "|")
	If $split[1] = "Safest" Then
		$dif = TimerDiff($begin)
		If $dif > Random(10000, 15000) Then
			$NewTitle2 = _RandomText(30)
			WinSetTitle($NewTitle1, "", $NewTitle2)
			$NewTitle1 = $NewTitle2
			$begin = TimerInit()
		EndIf
	EndIf
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			GUICtrlDelete($obj)
			Sleep(50)
			Exit
		Case $msg = $Report
			_INetMail("kurtspivak@hotmail.com", "Program Problem > Anagrams", "Kurt," & @CRLF & "I have found a problem in your program!" & @CRLF & @CRLF & "Let me describe me problem:"& @CRLF & @CRLF & @CRLF & @CRLF & @CRLF & @CRLF & "I also have specific information regarding my computer" & @CRLF & "(i.e. computer version, internet explorer version, firefox user)" & @CRLF & @CRLF & @CRLF & "I have some suggestions to improve your program:" & @CRLF & @CRLF & @CRLF & @CRLF & "Thanks," & @CRLF & "YourName")
		Case $msg = $CheckCon2
			SiteCheck()
		Case $msg = $ReLoad
			$oIE.navigate($split[2])
		Case $msg = $CheckCon1
			$s = SplashTextOn("","Checking Internet Connection",300,20)
			Sleep(2000)
			If NOT Ping("www.google.com",1500) = 0 Then
				SplashOff()
				MsgBox(0,"","                   Internet Connection Error" & @CRLF & "There is a problem with your internet connection.")
			Else
				SplashOff()
				MsgBox(0,"","Internet Connection is Working.")
			EndIf
		Case $msg = $Settings
			Settings(0)
		Case $msg = $find
			Global $p2 = "", $p3 = "", $p4 = "", $p5 = "", $p6 = "", $p7 = "", $p8 = "", $p9 = "", $p10 = "", $end = ""
			$txt2 = "___________________" & @CRLF & "  ERROR, NO WORDS FOUND" & @CRLF & "___________________" & @CRLF & "Please make sure you've entered" & @CRLF & "the correct amount of minimum letters."
			$text = GUICtrlRead($find2)
			Replace()
			$mini = GUICtrlRead($min2)
			$source = _INetGetSource("                                                                                  " & $mini & "&SortBy=Length&Letters=" & $text & "&Search=Find+Words")
			GUICtrlSetData($result, "Results for:  " & $text)
			$2 = _StringBetween($source, "<BR><BR><font face=Arial><B><I>2-letter words</I></B><BR></font><font face=Courier>", "</font>",-1, 1)
			$3 = _StringBetween($source, "<BR><BR><font face=Arial><B><I>3-letter words</I></B><BR></font><font face=Courier>", "</font>",-1, 1)
			$4 = _StringBetween($source, "<BR><BR><font face=Arial><B><I>4-letter words</I></B><BR></font><font face=Courier>", "</font>",-1, 1)
			$5 = _StringBetween($source, "<BR><BR><font face=Arial><B><I>5-letter words</I></B><BR></font><font face=Courier>", "</font>",-1, 1)
			$6 = _StringBetween($source, "<BR><BR><font face=Arial><B><I>6-letter words</I></B><BR></font><font face=Courier>", "</font>",-1, 1)
			$7 = _StringBetween($source, "<BR><BR><font face=Arial><B><I>7-letter words</I></B><BR></font><font face=Courier>", "</font>",-1, 1)
			$8 = _StringBetween($source, "<BR><BR><font face=Arial><B><I>8-letter words</I></B><BR></font><font face=Courier>", "</font>",-1, 1)
			$9 = _StringBetween($source, "<BR><BR><font face=Arial><B><I>9-letter words</I></B><BR></font><font face=Courier>", "</font>",-1, 1)
			$10= _StringBetween($source, "<BR><BR><font face=Arial><B><I>10-letter words</I></B><BR></font><font face=Courier>", "</font>",-1, 1)
			$str1 = _StringBetween($source, "<EM>", "</EM>",-1, 1)
			If UBound($2) = 1 AND IsArray($2) Then $p2 = "2 letter words:                              " & $2[0] & @CRLF & @CRLF
			If UBound($3) = 1 AND IsArray($3) Then $p3 = "3 letter words:                              " & $3[0] & @CRLF & @CRLF
			If UBound($4) = 1 AND IsArray($4) Then $p4 = "4 letter words:                              " & $4[0] & @CRLF & @CRLF
			If UBound($5) = 1 AND IsArray($5) Then $p5 = "5 letter words:                              " & $5[0] & @CRLF & @CRLF
			If UBound($6) = 1 AND IsArray($6) Then $p6 = "6 letter words:                              " & $6[0] & @CRLF & @CRLF
			If UBound($7) = 1 AND IsArray($7) Then $p7 = "7 letter words:                              " & $7[0] & @CRLF & @CRLF
			If UBound($8) = 1 AND IsArray($8) Then $p8 = "8 letter words:                              " & $8[0] & @CRLF & @CRLF
			If UBound($9) = 1 AND IsArray($9) Then $p9 = "9 letter words:                              " & $9[0] & @CRLF & @CRLF
			If UBound($10) = 1 AND IsArray($10) Then $p10 = "10 letter words:                            " & $10[0] & @CRLF & @CRLF
			If IsArray($str1) Then $end = @CRLF & @CRLF & $str1[0]
			$p2a = StringReplace($p2, @CR, " ");Thanks Jdeb :D
			$p2a = StringReplace($p2, @LF, " ")
			$p3a = StringReplace($p3, @CR, " ")
			$p3a = StringReplace($p3, @LF, " ")
			$p4a = StringReplace($p4, @CR, " ")
			$p4a = StringReplace($p4, @LF, " ")
			$p5a = StringReplace($p5, @CR, " ")
			$p5a = StringReplace($p5, @LF, " ")
			$p6a = StringReplace($p6, @CR, " ")
			$p6a = StringReplace($p6, @LF, " ")
			$p7a = StringReplace($p7, @CR, " ")
			$p7a = StringReplace($p7, @LF, " ")
			$p8a = StringReplace($p8, @CR, " ")
			$p8a = StringReplace($p8, @LF, " ")
			$p9a = StringReplace($p9, @CR, " ")
			$p9a = StringReplace($p9, @LF, " ")
			$p10a=StringReplace($p10, @CR, " ")
			$p10a=StringReplace($p10, @LF, " ")
			$txt2 = $p2a & $p3a & $p4a & $p5a & $p6a & $p7a & $p8a & $p9a & $p10a & $end
			GUICtrlSetData($txt, $txt2)
	EndSelect
WEnd
;§§§§§§ Replace for site link §§§§§§ 
Func Replace()
	$Text = StringReplace($Text, "&", "&amp;")
	$Text = StringReplace($Text, " ", "+")
	$Text = StringReplace($Text, "à", "&agrave;")
	$Text = StringReplace($Text, "é", "&eacute;")
	$Text = StringReplace($Text, "ï", "&iuml;")
	$Text = StringReplace($Text, "ô", "&ocirc;")
	$Text = StringReplace($Text, "ç", "&ccedil;")
	$Text = StringReplace($Text, "À", "&Agrave;")
	$Text = StringReplace($Text, "É", "&Eacute;")
	$Text = StringReplace($Text, "<", "");the below are for replacing mistakes
	$Text = StringReplace($Text, ">", "");from the input box
	$Text = StringReplace($Text, '"', "")
	$Text = StringReplace($Text, '/', "")
	$Text = StringReplace($Text, '\', "")
	$Text = StringReplace($Text, '.', "")
	$Text = StringReplace($Text, ',', "")
	Return $Text
EndFunc
;§§§§§§ Check For Site's availability §§§§§§
Func SiteCheck();This grabs the source code and compares it to some text that is regularly found.
	$s = SplashTextOn("","Checking Site Status",300,20)
	$Source1 = _INetGetSource("                                                                                                                                 ")
	$Source2 = _INetGetSource("http://www.miniclip.com/games/anagrammatic/en/")
	$Text1  = '<title>A2Z WordFinder: Scrabble, Literati, Jumble, Anagram and Crossword Search Results Page</title>'
	$Text2 = '<title>Anagrammatic - Miniclip Games  -  Play Free Games</title>'
	$Array  = StringRegExp($Source1, $Text1, 3)
	If NOT IsArray($Array) Then
		$msgb1 = "Not Available"
	Else
		If $Array[0] = $Text1 Then
			$msgb1 = "Working"
		Else
			$msgb1 = "STATUS UNKNOWN"
		EndIf
	EndIf
	$Array2  = StringRegExp($Source2, $Text2, 3)
	If NOT IsArray($Array2) Then
		$msgb2 = "Not Available"
	Else
		If $Array2[0] = $Text2 Then
			$msgb2 = "Working"
		Else
			$msgb2 = "STATUS UNKNOWN"
		EndIf
	EndIf
	SplashOff()
	MsgBox(0,"","SITE STATUS: Anagrammatic Site:" & @TAB & $msgb2 & @CRLF & "                                   Dictionnary:" & @TAB & $msgb1)
EndFunc
;§§§§§§ Configure Settings §§§§§§
Func Settings($num);Set defaults and options.
	$GUI2 = GuiCreate("Configure Your Settings", 250, 365, -1, -1, $WS_EX_LAYERED, $WS_EX_TOOLWINDOW)
	$1label = GUICtrlCreateLabel("Detect Modes", 25, 5, 100, 20, 1, 15)
	GUICtrlSetFont($1label, 9, 400, 0, "Arial Bold")
	GUICtrlSetColor($1label, 0x007F00)
	GUICtrlCreateLabel("This will depend on how undetectable you want to run the program, since some people are more paranoid than others. Safest mode will change the windows title every x seconds. Safe mode will add a random number to the windows title.", 2, 26, 240, 65)
	$rada1 = GUICtrlCreateCheckbox("Safest", 10, 95)
	$rada2 = GUICtrlCreateCheckbox("Safe", 95, 95)
	$rada3 = GUICtrlCreateCheckbox("Unsafe", 180, 95)
	$2label = GUICtrlCreateLabel("Game Modes", 25, 120, 100, 20, 1, 15)
	GUICtrlSetFont($2label, 9, 400, 0, "Arial Bold")
	GUICtrlSetColor($2label, 0x007F00)
	GUICtrlCreateLabel("Which game would you like to play? You have 3 options: Anagrammatic, TextTwist, or None", 2, 140, 246, 30)
	$chkb1 = GUICtrlCreateCheckbox("Anagrammatic", 5, 175)
	$chkb2 = GUICtrlCreateCheckbox("TextTwist", 100, 175)
	$chkb3 = GUICtrlCreateCheckbox("None", 185, 175)
	$3label = GUICtrlCreateLabel("Default Options", 25, 200, 100, 20, 1, 15)
	GUICtrlSetFont($3label, 9, 400, 0, "Arial Bold")
	GUICtrlSetColor($3label, 0x007F00)
	GUICtrlCreateLabel("Change the default minimum letters on program start-up. Limits: 2-9", 2, 222, 246, 30)
	$updwn1 = GUICtrlCreateInput("4", 95, 260, 40, 20)
	$updwn2 = GUICtrlCreateUpdown($updwn1)
	GUICtrlSetLimit($updwn2, 9, 2)
	GUICtrlCreateLabel("Default Number:", 10, 263, 80)
	GUICtrlCreateLabel("________________________________________________________________________________________", -2, 290,260)
	$OK = GUICtrlCreateButton("Save Settings", 137, 312, 100, 20)
	$CA = GUICtrlCreateButton("Cancel", 8, 312, 100, 20)
	$er1 = GUICtrlCreateLabel(" ", 135, 5, 150)
	GUICtrlSetColor(-1, 0xAA00000)
	$er2 = GUICtrlCreateLabel(" ", 135, 120, 150)
	GUICtrlSetColor(-1, 0xAA00000)
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE OR $msg = $CA
				If $num = 0 Then
					GUIDelete($GUI2)
					ExitLoop
				EndIf
				If $num = 1 Then MsgBox(0,"","Please configure your settings.")
			Case $msg = $rada1
				GUICtrlSetState($rada2, $GUI_UNCHECKED)
				GUICtrlSetState($rada3, $GUI_UNCHECKED)
			Case $msg = $rada2
				GUICtrlSetState($rada1, $GUI_UNCHECKED)
				GUICtrlSetState($rada3, $GUI_UNCHECKED)
			Case $msg = $rada3
				GUICtrlSetState($rada2, $GUI_UNCHECKED)
				GUICtrlSetState($rada1, $GUI_UNCHECKED)
			Case $msg = $chkb1
				GUICtrlSetState($chkb2, $GUI_UNCHECKED)
				GUICtrlSetState($chkb3, $GUI_UNCHECKED)
			Case $msg = $chkb2
				GUICtrlSetState($chkb1, $GUI_UNCHECKED)
				GUICtrlSetState($chkb3, $GUI_UNCHECKED)
			Case $msg = $chkb3
				GUICtrlSetState($chkb2, $GUI_UNCHECKED)
				GUICtrlSetState($chkb1, $GUI_UNCHECKED)
			Case $msg = $OK
				If GUICtrlRead($rada1) = $GUI_UNCHECKED AND GUICtrlRead($rada2) = $GUI_UNCHECKED AND GUICtrlRead($rada3) = $GUI_UNCHECKED Then
					GUICtrlSetData($er1, "<--- This is required")
				Else
					GUICtrlSetData($er1, " ")
					If GUICtrlRead($chkb1) = $GUI_UNCHECKED AND GUICtrlRead($chkb2) = $GUI_UNCHECKED AND GUICtrlRead($chkb3) = $GUI_UNCHECKED Then
						GUICtrlSetData($er2, "<--- This is required")
					Else
						GUICtrlSetData($er2, " ")
						Local $n = "", $y = ""
						If GUICtrlRead($rada1) = $GUI_CHECKED Then $n = "Safest"
						If GUICtrlRead($rada2) = $GUI_CHECKED Then $n = "Safe"
						If GUICtrlRead($rada3) = $GUI_CHECKED Then $n = "Unsafe"
						If GUICtrlRead($chkb1) = $GUI_CHECKED Then $y = "http://www.miniclip.com/games/anagrammatic/en/"
						If GUICtrlRead($chkb2) = $GUI_CHECKED Then $y = "                                            "
						If GUICtrlRead($chkb3) = $GUI_CHECKED Then $y = " "
						$def = GUICtrlRead($updwn1)
						FileDelete($file)
						FileWrite($file, $n & "|" & $y & "|" & $def)
						GUIDelete($GUI2)
						_restart()
					EndIf
				EndIf
		EndSelect
	WEnd
EndFunc
;§§§§§§ Restart Funtion §§§§§§ -Valuater
Func _restart()
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
EndFunc
;§§§§§§ RandomText §§§§§§ -ezzetabi
Func _RandomText($N)
  If $N < 1 Then Return -1
  Local $COUNTER, $ALPHA, $RESULT
  
  For $COUNTER = 1 To $N
     If Random() < 0.5 Then
        $ALPHA = Chr(Random(Asc("A"), Asc("Z") + 1))
     Else
        $ALPHA = Chr(Random(Asc("a"), Asc("z") + 1))
     EndIf
     $RESULT = $RESULT & $ALPHA
  Next
  Return $RESULT
EndFunc