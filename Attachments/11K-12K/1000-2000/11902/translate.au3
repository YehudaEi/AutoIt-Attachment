#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.1.11 (beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GuiConstants.au3>

; http://translate.google.com/translate_t?hl=fr&langpair=en|fr&&text="nnnnnn"

#cs
 zh_en > Chinese-simp to English
 zt_en >Chinese-trad to English
 en_zh >English to Chinese-simp
 en_zt >English to Chinese-trad
 en_nl >English to Dutch
 en_fr >English to French
 en_de >English to German
 en_el >English to Greek
 en_it >English to Italian
 en_ja >English to Japanese
 en_ko >English to Korean
 en_pt >English to Portuguese
 en_ru >English to Russian
 en_es >English to Spanish
 nl_en >Dutch to English
 nl_fr >Dutch to French
 fr_nl >French to Dutch
 fr_en >French to English
 fr_de >French to German
 fr_el >French to Greek
 fr_it >French to Italian
 fr_pt >French to Portuguese
 fr_es >French to Spanish
 de_en >German to English
 de_fr >German to French
 el_en >Greek to English
 el_fr >Greek to French
 it_en >Italian to English
 it_fr >Italian to French
 ja_en >Japanese to English
 ko_en >Korean to English
 pt_en >Portuguese to English
 pt_fr >Portuguese to French
 ru_en >Russian to English
 es_en >Spanish to English
 es_fr >Spanish to French
#ce

#Include <Misc.au3>
;#NoTrayIcon
Opt("GUIOnEventMode", 1)

TranslateInit()
While 1
    Sleep(100)
WEnd


Func TranslateInit()
	Global $oHTTP
	HotKeySet("{F2}", "TranslateStart")
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
EndFunc

Func TranslateStart()
    ToolTip("Translating", 0, 0)
    Send("^c")
	$Text = ClipGet()
    $Translation = _Translate($Text, "en", "fr")
	$Translation = Web2Text($Translation)
	ClipPut($Translation)
	guiTranslationText($Text, $Translation)
EndFunc

Func Web2Text($Text)
	$Text = StringReplace($Text, "." & @CRLF, "." & @CR)
	$Text = StringReplace($Text, @CR & @CRLF, @CR & @CR)
	$Text = StringReplace($Text, @CRLF, " ")
	$Text = StringReplace($Text, @CR, @CRLF)
	Return $Text
EndFunc

Func guiTranslationText($Original, $Translated)
	GuiCreate("Translation Service", 805, 425,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	GUISetOnEvent($GUI_EVENT_CLOSE, "TranslationTextClose")
	GuiCtrlCreateEdit($Original, 10, 10, 780, 190, $ES_MULTILINE)
	GuiCtrlCreateEdit($Translated, 10, 210, 780, 200, $ES_MULTILINE)
	GuiSetState()
EndFunc

Func TranslationTextClose()
	GUIDelete(@GUI_WinHandle)
EndFunc

Func String2WWW($Text)
	$Text = StringReplace($Text, "&", "&amp;")
	$Text = StringReplace($Text, " ", "+")
	$Text = StringReplace($Text, "à", "&agrave;")
	$Text = StringReplace($Text, "é", "&eacute;")
	$Text = StringReplace($Text, "ï", "&iuml;")
	$Text = StringReplace($Text, "ô", "&ocirc;")
	$Text = StringReplace($Text, "ç", "&ccedil;")
	$Text = StringReplace($Text, "À", "&Agrave;")
	$Text = StringReplace($Text, "É", "&Eacute;")
	$Text = StringReplace($Text, "©", "&copy;")
	$Text = StringReplace($Text, "<", "&lt;")
	$Text = StringReplace($Text, ">", "&gt;")
	;$Text = StringReplace($Text, @CRLF, "%0D%0A")
	;$Text = StringReplace($Text, '"', "%22")
    $string = ""
	For $i=1 To StringLen($text)
		$char = StringMid($Text, $i, 1)
		If $char <> "+" And $char <> "&"  And $char <> ";" And StringIsAlNum($char)<>1 Then $char = "%" & Hex(Asc($char),2)
		$string = $string & $char
	Next
	Return $string
EndFunc

Func _Translate($Text, $From, $To)
    $Text = String2WWW($Text)
	$oHTTP.Open("GET","                                                                             " & $Text & "&lp=" & $From & "_" & $To & "&btnTrTxt=Translate")
	$oHTTP.Send()
	$HTMLSource = $oHTTP.Responsetext
	ToolTip("Done", 0, 0)
	Sleep(10)
	ToolTip("")
	$Text = _StringBetween($HTMLSource, "<div style=padding:10px;>", "</div>")
	$Text = StringReplace($Text, @LF, @CRLF)
	Return $Text
EndFunc

Func _StringBetween($s, $from, $to)
    $x = StringInStr($s, $from) + StringLen($from)
    $y = StringInStr(StringTrimLeft($s, $x), $to)
    Return StringMid($s, $x, $y)
EndFunc
