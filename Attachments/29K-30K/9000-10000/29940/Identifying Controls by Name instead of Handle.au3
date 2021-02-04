#CS
	================================================================
	=        Identifying Controls by Name instead of Handle        =
	=                     Example by: Shafayat                     =
	================================================================

	It can be quite troublesome to maintain controls (especially
	GUI controls) using the handlers. So, it can be a better solution
	to use "Names" instead of "Handles" (or variable containing it).

	This example shows how you can use the "Scripting.Dictionary"
	to perfectly substitute the variables containing handlers.

	If you do not know what is "Scripting.Dictionary" then you
	just need to search a little. For this example it is enough to
	know that this will work as a makeshift Associative array.

	You are free to use/modify this sample script anyway you
	like.

	- Shafayat
#CE

; First we are creating a basic GUI. It is only for the example's purpose.
GUICreate("NameList UDF Test")
$set = GUICtrlCreateButton("Insert Labels", 2, 2, 100)
$rem = GUICtrlCreateButton("Remove Labels", 2 + 100, 2, 100)
$show = GUICtrlCreateButton("Show List", 2 + 200, 2, 100)
GUISetState(@SW_SHOW)
; End of GUI creation ;)

; Now we create the makeshift Associative Array. This will contain our data.
$Labels = ObjCreate("Scripting.Dictionary")

; The main loop
While 1
	$msg = GUIGetMsg()
	Switch $msg

		Case -3 ; GUI close event (i.e. you press the X button
			Exit ; Good Bye  ;)

		Case $set ; We are going to insert 10 labels without writing 10 lines
			If Not $Labels.count() = 10 Then ; We are only creating ten lines for this example. Ofcourse you can have more.
				; NOTE: $YOURVAR.count() returns the number of entries in $YOURVAR
				For $i = 0 To 10
					$Labels("LAB" & $i) = GUICtrlCreateLabel("SAMPLE TEXT", 20, 50 + $i * 20)
					; See! How simple it was. If you didn't need names you'd have to write ten lines like: -
					;  $Label1 = GUICtrlCreateLabel("SAMPLE TEXT", 20, 50 + 20)
					;  $Label2 = GUICtrlCreateLabel("SAMPLE TEXT", 20, 50 + 2 * 20)
					;  .........
					;  $Label10 = GUICtrlCreateLabel("SAMPLE TEXT", 20, 50 + 10 * 20)
					; Now you see my point. Don't you?
				Next
			EndIf

		Case $rem ; Lets clean up the mess ;)
			For $i = 0 To $Labels.Count()
				GUICtrlDelete($Labels("LAB" & $i)) ; Again we see how useful it is.
			Next
			$Labels.removeall() ; We will clean up the records so that $Labels.count() Becomes 0 (Zero)

		Case $show ;We can also do some advanced stuff. For example showing what we are hiding behind the names.
			Local $tempArray = $Labels.Keys() ; $YOURVAR.Keys() will always return ALL the names in a ARRAY.
			Local $text = "" ; Now, we don't want prior data to be included. Do we?
			For $i = 0 To UBound($tempArray) - 1
				$text &= $tempArray[$i] & " = " & $Labels($tempArray[$i]) & @CRLF ; This line explains itself.
			Next
			MsgBox(0, "Names = values", $text)

	EndSwitch
WEnd


#CS
	================================================================
	=                       Further Questions                      =
	================================================================

	It is hard to know how human brain works. I worked so hard to
	explain this and you've still got questions! JUST KIDDIN'

	Actually it is only natural for questions to arise. I believe
	there are AutoIt scripters and my friend Google to answer you.

	So, Bye Bye.

							CLAP! CLAP! CLAP!

	================================================================
	=                           THE END                            =
	================================================================

	P.S: If you think this example is a waste of space then........
													Bear with it ;)
	P.S: I am a fun loving person and sometimes I get carried away
	If this sample somehow offended you or made you want to
	BANG MY HEAD OFF then please forgive me considering that was
	unintentional.
#CE