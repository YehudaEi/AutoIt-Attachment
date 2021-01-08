#cs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  SMT - Simple Multi Threading  ;;;
;;;;;;;;;  By NoCow AKA Mea  ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	Functions
	
	
	_CreateThread("Function")
	Creates a new thread of a function in the script
		Return: $PID of the new thread
	
	_KillThread($PID)
	Destroy the target Thread
		Return: 1 for success. 0 for failed

	_SetVar("var","value")
	Set Global var to the value, Can be get with _GetVar()

	_GetVar("var")
	Get a variable set by _SetVar()


	Examples
;=========================================================================================================
;  move the mouse random to 1-500,1-500 and sleep 10secounds for show its multitasking	
;=========================================================================================================
#include "smt.au3"                              ; Include the multithreaded libary maded by Mea(Aka NoCow)
$pid = _CreateThread("hookmouse")               ; Start new thread with the function hookmouse()
Sleep(10000)                                    ; Sleep in 10secounds
_KillThread($pid)                               ; Close the thread hookmouse()


Func hookmouse()                                ; Function hookmouse() start
	While 1
		MouseMove(Random(1,500),Random(1,500))  ; Move Mouse random on the screen
	WEnd
EndFunc                                         ; Function hookmouse() end	
;=========================================================================================================


;=========================================================================================================
;  Tooltip every 50milisecounds the variable text on 0,0 while change it every 4secound
;  For then force the thread to close
;=========================================================================================================
#include "smt.au3"
_SetVar("text","hello with a foo in a boo")
$pid = _CreateThread("showtooltip")
Sleep(4000)
_SetVar("text","lol this is too easy")
Sleep(4000)
_SetVar("text",InputBox("What you want to our tooltip message?","Text: "))
Sleep(10000)
_KillThread($pid)

Func showtooltip()
	While 1
		ToolTip(_GetVar("text"),0,0)
		Sleep(50)
	WEnd
EndFunc
;=========================================================================================================




#ce


#NoTrayIcon

If $cmdline[0] > 0 Then

	$str = call($cmdline[1])
	Exit
EndIf

Opt("TrayIconHide", 0)

GUICreate("threaded by mea")
GUICtrlCreateEdit("",0,0)

Func _GetVar($var)
	$text = ControlGetText("threaded by mea", "", "Edit1")
	$text = StringSplit($text,@CRLF)
	For $i = 1 To $text[0]
		If Not $text[$i] = "" Then
			$temp = StringSplit($text[$i]," ")
			If $temp[1] = $var Then	Return StringMid($text[$i],StringLen($temp[1]) + 1)
		EndIf
	Next
EndFunc

Func _CreateThread($thread)
	Return Run(@AutoItExe & " " & $thread)
EndFunc

Func _KillThread($thread)
	If ProcessExists($thread) <> 0 Then
		ProcessClose($thread)
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func _SetVar($var,$it = "")
	$text = ControlGetText("threaded by mea", "", "Edit1")
	$text = StringSplit($text,@CRLF)
	$data = ""
	For $i = 1 To $text[0]
		$temp = StringSplit($text[$i]," ")
		If $temp[1] = $var Then
		 ;
		Else
			If Not $text[$i] = "" Then $data = $data & @CRLF & $text[$i]
		EndIf
	Next
	ControlSetText("threaded by mea", "", "Edit1",$data & @CRLF & $var & " " & $it)
EndFunc