#include "CustXML.au3"
#include <GUIConstants.au3>

$GUI = GUICreate("AIML Brain Editor", 600, 500)
$load = GUICtrlCreateButton("Load Brain", 10, 40, 80, 25)
$add = GUICtrlCreateButton("Add Response", 95, 40, 80, 25)
Global $contents = ""
Global $file


GUISetState( )

While 1
	$msg = GUIGetMsg( )
	Select
	Case $msg = $GUI_EVENT_CLOSE
		Exit
		
	Case $msg = $load
		;load file
		$file = FileOpenDialog("Choose Brain", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "AIML Brain Files (* brain.aiml)")
		$contents = _XMLLoad($file)
		
	Case $msg = $add
		;remove </aiml>
		$contents = StringReplace($contents,"</aiml>", "", 0, 1)
		;start category
		$contents = _XMLStartSection($contents, "category")
		;phrase to respond too
		$pattern = InputBox("Pattern", "Enter phrase the AIML bot should respond too" & @CRLF & "Use * as a wildcard")
		;add to $contents
		$contents = $contents & @CRLF & "        <pattern>" & $pattern & "</pattern>"; & @CRLF
		;phrase bot replies with
		$template = InputBox("Pattern", "Enter phrase the AIML bot should say")
		;add to $contents
		$contents = $contents & @CRLF & "        <template>" & $template & "</template>" & @CRLF
		;end category and aiml
		$contents = _XMLEndSection($contents, "category")
		$contents = _XMLEndSection2($contents, "aiml")
		;delete old file
		FileDelete($file)
		;write new file
		_XMLSave($contents, $file)
		
	EndSelect
WEnd


;;for debug
Func Msg($msg, $title = @error, $flag = 0, $time = -1)
	MsgBox($flag, $title, $msg, $time)
EndFunc   ;==>Msg