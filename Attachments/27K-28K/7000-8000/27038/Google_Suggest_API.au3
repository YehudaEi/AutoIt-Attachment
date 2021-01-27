#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
AutoItSetOption("WinTitleMatchMode",2)
$main = GUICreate("Google Suggest Program",300,400)
$term = GUICtrlCreateInput("",20,20,260,20)
$button1 = GUICtrlCreateButton("Query",130,60,40)
$list1 = GUICtrlCreateList("Results will be shown here",20,120,260,142)
$quit = GUICtrlCreateButton("Quit",20,360,60)
$credits = GUICtrlCreateButton("Credits",220,360,60)
$help = GUICtrlCreateButton("?",280,360)
$lab = GUICtrlCreateLabel("Engine status: nominal",20,270,100,60)
GUICtrlSetColor($lab,0xcd5c5c) ;brown
$waitgui = GUICreate("Google Suggest API",200,50,-1,-1,BitOr($WS_POPUP,$WS_CAPTION,$DS_SETFOREGROUND),$WS_EX_TOPMOST)
$text1 = GUICtrlCreateLabel("Please wait; obtaining results...",20,20,300,20,$SS_LEFT)
GUISetState(@SW_SHOW,$main)
While 1
	If GUICtrlRead($button1) <> "Query" Then
		GUICtrlSetData($button1,"Query")
	EndIf
	dim $msg = GUIGetMsg(1)
	Select
	Case $msg[0] = $button1
		GUICtrlSetData($button1,"Stop")
		dim $termr = GUICtrlRead($term)
		$ttt = StringRegExp($termr,"(?i)[a-z0-9@.&_]") ;google only reads these characters: a-z/0-9, at sign, period, ampersand, and underscore
		If $ttt = 0 then
			MsgBox(0,"Error","You entered an invalid character or query!")
		Else
			GUISetState(@SW_SHOW,$waitgui)
					GUICtrlSetData($list1,"")
			dim $offset
			dim $url2
			$url = "http://google.com/complete/search?output=toolbar&q=" & GUICtrlRead($term)
			GUICtrlSetData($lab,"Engine status: Getting data")
			GUICtrlSetColor($lab,0xff0000) ;red
			INetGet($url,@ScriptDir & "\output.file")
			While @INetGetActive = True
			WEnd
			GUISetState(@SW_HIDE,$waitgui)
			$file = FileOpen(@ScriptDir & "\output.file",0)
			$inputdata = FileRead($file)
			$filter = '<CompleteSuggestion>(?:)<suggestion data="(.*?)"/><num_queries int="(\d{0,})"/>'
			$thru = 0
			For $o = 1 to 10 ;read stringregexp's return for all 10 items
			$bob = StringRegExp($inputdata,$filter,1,$offset)
			If not @error then $offset = @extended
			If IsArray($bob) = 0 and $thru = 0 then
				MsgBox(0,"Error","There are no results.")
				ExitLoop
			Elseif IsArray($bob) = 0 and $thru = 1 then ;we assume since it ran through with a returned array, google gave us less than 10 results
				Exitloop
			EndIf
			$suggestion = $bob[0]
			$num_queries = $bob[1]
			$output1 = $suggestion & "   (" & $num_queries & ")"
			GUICtrlSetData($list1,$output1)
			$thru = 1
			Next
		GUICtrlSetData($lab,"Engine status: nominal")
		GUICtrlSetColor($lab,0xcd5c5c)
		$offset = 1 ;IMPORTANT: puts the offset back to 1 for the next search otherwise it will be at the final extended!
		EndIf
	Case $msg[0] = $GUI_EVENT_CLOSE
		If FileExists(@ScriptDir & "\output.file") = 1 Then
			FileDelete(@ScriptDir & "\output.file")
			Exit
		Else
			Exit
		EndIf
	Case $msg[0] = $quit ;i would like to combine this with qui_event_close, but it just quits.
		If FileExists(@ScriptDir & "\output.file") = 1 Then
				FileDelete(@ScriptDir & "\output.file")
				Exit
			Else
				Exit
			EndIf
	Case $msg[0] = $credits
		MsgBox(064,"Credits","Programming: trav1085, Bugging me to get it right: Sarah")
	Case $msg[0] = $list1
		$selected = GUICtrlRead($list1)
		$selected2 = StringSplit($selected,"(")
		ShellExecute("http://www.google.ca/search?&q=" & $selected2[1])
	Case $msg[0] = $help
		MsgBox(064,"Help","Enter a query and then press Query. Results will load, please wait. Then you can click on a result and it will go to that requested query in Google. The numbers next to the result are the amount of hits on Google.")
	EndSelect
WEnd