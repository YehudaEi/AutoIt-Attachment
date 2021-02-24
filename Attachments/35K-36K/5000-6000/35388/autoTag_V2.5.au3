#include <GuiConstants.au3>
#include <Array.au3>
#include <file.au3>
#include <ButtonConstants.au3>
#include <GUIListBox.au3>
;include <GUIConstantsEx.au3>
;#include <WindowsConstants.au3>
;#Include <GuiScrollBars.au3>

;~ HotKeySet("^w", "tag")
HotKeySet("^q", "lTag")
HotKeySet("{ESC}", "errorH")
;;;;HotKeySet("{DEL}", "del")


;**************************
;Global Variables
;**************************
$listFull = @ScriptDir & '\list.csv'
;$listShort = @ScriptDir & '\list short names.txt'
;$listWhole = @ScriptDir & '\people.csv'

$error = 0
Do
	;clean up the lists
;~  	$read=FileRead($listFull)
;~  	FileDelete($listFull)
;~  	Do
;~  		$read=StringReplace($read,@CRLF&@CRLF,@CRLF)
;~  	Until @extended=0
;~  	FileWrite($listFull,$read)

	;call function to clear blank lines in text
	clearBlank()






	;**************************
	;read array from text file
	;**************************
	;read the whole array
	Dim $Whole
	If Not _FileReadToArray($listFull,$Whole) Then
	   MsgBox(4096,"Error", " Error reading Array    error:" & @error)
	   Exit
   EndIf
   ;sort the array
 	_ArraySort($Whole)
	;write array back to csv
 	_FileWriteFromArray($listFull,$Whole, 1)

		;For $i = 1 to UBound($Whole)-1

		;Next
	Dim $helper[2] = [0,0]
	Dim $PeopleFull[1]
	Dim $PeopleShort[1]
	For $i = 1 to UBound($Whole)-1
		$helper = StringSplit($Whole[$i],';', 1)

		ReDim $PeopleFull[UBound($PeopleFull)+1]
		ReDim $PeopleShort[UBound($PeopleShort)+1]

		$PeopleFull[$i] = $helper[1]
		$PeopleShort[$i] = $helper[2]
		;MsgBox(0,"",$helper[1])
		;MsgBox(0,"",$helper[2])
	Next






	;**************************
	;Create the GUI
	;**************************
	;Do while loop so we can rebuild the GUI if need be.
	;main GUI window
	$Form1 = GUICreate("Auswählen",570,550,192,114)
	;some textlables to eplain whats going on
	GUICtrlCreateLabel("1. Select people, use shift and ctrl", 10, 480)
	GUICtrlCreateLabel("2. Go to G+ get cursor in input dialog", 10, 500)
	GUICtrlCreateLabel("3. CTRL+Q to start Tagging", 10, 520)
	;Button that adds ponies to the list
	$add = GUICtrlCreateButton("Add", 350, 520,50)
	;Input Box
	$Input1 = GUICtrlCreateInput("", 200, 520, 150, 25)
	;some textlables to explain whats going on
	GUICtrlCreateLabel("| Fomrate like this: Name;Shortname", 200, 480)
	GUICtrlCreateLabel("| Use with caution", 200, 500)
	;Button to delete people
	$del = GUICtrlCreateButton("Delete Selected", 400, 520)


	; Create an array to hold the checkbox ControlIds - make it the same size as the $PeopleFull array
	;Global $Person[UBound($PeopleFull)]
	;Global $del[UBound($PeopleFull)]

	;Some variables to count stuff
	$count = 0
	$counter = 0
	;if retry = 1 the do while loop will end
	$retry = 1

	;List of people
	$ListPeople = GUICtrlCreateList("", 10, 10, 550, 450, BitOR($LBS_STANDARD, $LBS_EXTENDEDSEL))
	;$ListPeople = GUICtrlCreateList("", 10, 10, 300, 450, BitOR($GUI_SS_DEFAULT_LIST,$LBS_MULTIPLESEL))

	For $i = 1 to UBound($PeopleFull)-1
		GUICtrlSetData($ListPeople, $PeopleFull[$i])
	Next

	;**************************
	;Create GUI Actions
	;**************************
	;Set the GUI to be shown
	GUISetState(@SW_SHOW)
		Do
			$msg = GUIGetMsg()
			Switch $msg
				Case $add
				If GUICtrlRead ($Input1) = "" Then
						MsgBox(0,'Niet','Please... Input!')
					Else
						add()
					EndIf
				Case $del
					del()

			EndSwitch


		Until $msg = $GUI_EVENT_CLOSE
Until $retry=1

;Functions
;~ Func tag()
;~ 	;First sleep 5seconds so the user can place the cursor to the right place
;~ 	;Sleep(4000)
;~ 	$error = 0
;~ 	For $i = 1 to UBound($PeopleFull)-1
;~ 		If $error = 1 Then

;~ 		ElseIf GuiCTRLRead ($Person[$i]) = $GUI_CHECKED Then
;~ 			ClipPut($PeopleFull[$i])
;~ 			;Send("{+}")
;~ 			Send("^v")
;~ 			Sleep(1000)
;~ 			Send("{ENTER}")
;~ 			Sleep(500)
;~ 		EndIf
;~ 	Next
;~ EndFunc

Func lTag()
	$items = _GUICtrlListBox_GetSelItems($ListPeople)
	Opt("SendKeyDelay",40)
	For $i = 1 to UBound($items)-1
		If $error = 1 Then

		Else
			$item = $items[$i]+1
			Send("{+}");
			Send($PeopleShort[$item])
			Sleep(1000)
			Send("{ENTER}")
			Sleep(500)
		EndIf
	Next

	Opt("SendKeyDelay",5)
	Send("{CTRLUP}")
	;Send("{SHIFTUP}")
	;Send("{ALTUP}")

	$error = 0



EndFunc

Func clearBlank()
		Global $aLines
	_FileReadToArray($listFull, $aLines)

	For $i = $aLines[0] To 1 Step -1
		If $aLines[$i] = "" Then
			_ArrayDelete($aLines, $i)
		EndIf
	Next

	_FileWriteFromArray($listFull, $aLines, 1)
EndFunc

Func add()
	;$counter = $counter
	ReDim $Whole[UBound($Whole)+1]
	$Whole[$counter] = GUICtrlRead ($Input1)
	_ArraySort($Whole)
	_FileWriteFromArray($listFull,$Whole, 1)

	$helper = StringSplit(GUICtrlRead ($Input1),';', 1)

	ReDim $PeopleFull[UBound($PeopleFull)+1]
	ReDim $PeopleShort[UBound($PeopleShort)+1]

	$PeopleFull[$i] = $helper[1]
	$PeopleShort[$i] = $helper[2]
	GUICtrlSetData($ListPeople, $helper[1])
	_ArraySort($PeopleFull)
	_ArraySort($PeopleShort)

EndFunc

Func del()
	$items = _GUICtrlListBox_GetSelItems($ListPeople)
	For $i = 1 to UBound($items)-1
		$item = $items[$i]+1
		$PeopleFull[$item] = ""
		$PeopleShort[$item] = ""
		$Whole[$item] = ""
		;MsgBox(0,"",$PeopleShort[1])

	Next


	_ArraySort($PeopleFull)
	_ArraySort($PeopleShort)
	_ArraySort($Whole)

	_FileWriteFromArray($listFull,$Whole, 1)

	clearBlank()

	GUICtrlSetData($ListPeople, "")
	For $i = 1 to UBound($PeopleFull)-1
		GUICtrlSetData($ListPeople, $PeopleFull[$i])
	Next

EndFunc

;debuging

Func errorH()
	$error=1
	;Exit
EndFunc