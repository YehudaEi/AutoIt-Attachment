#include "XML.au3"
#include <GUIConstants.au3>
#include <Misc.au3>
;~ #include <Array.au3>
#include <GUIEdit.au3>

MsgBox (64, "AIML Bot", "Welcome to the AIML Bot made in AutoIt. Your bot is being prepared.")

Global $contents = _XMLLoad("brain.aiml")

Global $categories_num = __StringNumOccur ($contents, "<category>")

MsgBox (0, "info", "found "&$categories_num&" categories.")

Global $patterns[$categories_num + 1], $templates[$categories_num + 1]

If $categories_num = 0 Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"There are no <category> tags. Please check your code and try again.")
If $categories_num > __StringNumOccur ($contents, "</category>") Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"There is one or more <category> tag without an ending </category> tag. Please check your code and try again.")
If $categories_num < __StringNumOccur ($contents, "</category>") Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"There is one or more extra </category> tags without beginning <category> tags. Please check your code and try again.")

$botinfo = _XMLGet ($contents, "botinfo")
If @error Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"There is no <botinfo> tag. This tag should contain a <name> tag with the name of your bot, and an <unknown> tag containing your bot's default response for when a user inputs a message that is unknown to the bot. Please check your code and try again.")

$bot_name = _XMLGet ($botinfo, "name")
If @error Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"There is no <name> tag inside your <botinfo> tag. The <name> tag should contain the bot's name. Please check your code and try again.")

$unknown_reply = _XMLGet ($botinfo, "unknown")
If @error Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"There is no <unknown> tag inside your <botinfo> tag. The <name> tag should contain your bot's default response for when a user inputs a message that is unknown to the bot. Please check your code and try again.")

For $i=1 To $categories_num
	$cat_contents = _XMLGet ($contents, "category", $i)
	$cat_pattern = StringLower (StringReplace (StringLower(_XMLGet ($cat_contents, "pattern")), "&botname;", $bot_name))
	__StringStripPunct ($cat_pattern)
	If @error Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"Category number "&$i&" does not have a <pattern> tag. Please check your code and try again.")
	If $cat_pattern = "" Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"The <pattern> tag in category number "&$i+1&" is empty. Please check your code and try again.")
	$patterns[$i] = $cat_pattern
	$cat_template = StringReplace (_XMLGet ($cat_contents, "template"), "&botname;", $bot_name)
	If @error Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"Category number "&$i&" does not have a <template> tag. Please check your code and try again.")
	If $cat_template = "" Then Exit MsgBox (48, "AIML Bot", "AIML Syntax Error:"&@CRLF&@CRLF&"The <template> tag in category number "&$i+1&" is empty. Please check your code and try again.")
	$templates[$i] = $cat_template
Next

GUICreate ( "AIML Bot", 261, 321, (@DesktopWidth-261)/2, (@DesktopHeight-321)/2 )
$input = GUICtrlCreateInput("", 10, 260, 180, 40)
$history = GUICtrlCreateEdit("Please type in the input field at the bottom."&@CRLF&"---------------", 10, 10, 240, 230, BitOR($WS_VSCROLL, $ES_READONLY, $ES_AUTOVSCROLL))
$Sbutton = GUICtrlCreateButton("Say", 200, 260, 50, 30, $BS_DEFPUSHBUTTON)
$exit = GUICtrlCreateButton("Exit", 200, 300, 50, 20)

GUISetState()

While 1
	$msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then
        Exit
    ElseIf $msg = $Sbutton Then
        $Text = GUICtrlRead($input)
		If $Text <> "" Then
			$response = AIML_Respond ($Text)
			GUICtrlSetData ( $history, GUICtrlRead ($history) & @CRLF & "You: " & $Text & @CRLF & $bot_name & ": " & $response )
		EndIf
		GUICtrlSetData ($input, "")
	ElseIf $msg = $exit Then
		If MsgBox ( 36, "Disconnect", "Are you sure you want to quit?") = 6 Then Exit
	EndIf
	For $Line_Count = 1 To _GUICtrlEditGetLineCount ($history)
		_GUICtrlEditScroll ($history, $SB_LINEDOWN)
    Next
WEnd

Func AIML_Respond ($message)
	$message = StringLower ($message)
	__StringStripPunct ($message)
;~ 	$pos = _ArraySearch ($patterns, $message)
	$pos = __ArraySearchWithWildcards ($patterns, $message)
	_ArrayDisplay ($patterns, "patterns")
	_ArrayDisplay ($templates, "templates")
	MsgBox (0, "pos", $pos)
	If $pos = -1 Then
		$response = $unknown_reply
	ElseIf $pos = 0 Then
		$response = $unknown_reply
	Else
		$response = $templates[$pos]
	EndIf
	Return $response
EndFunc