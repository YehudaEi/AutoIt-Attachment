; AutoIt Version: 3.0
; Language: English
; Platform: Win98 2nd edition, Win XP and May work on other windows
; In order to work under Windows NT 4.0, requires the file
; PSAPI.DLL (included in the AutoIt installation directory).
; Author: Quick_sliver007
; Script Name: Process Blocker
; version: 1.3
; Script Function: To Block unwanted processes like spyware and adware
; fixed : Made block process list view clear before loading file,
; resized gui, cleaned up script with functions, added fade funtion,
; added shortcut keys and added annotation
#include <GuiConstants.au3>
#include <Array.au3>
#include <file.au3>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; START OF GUI CREATION
$GUI = GUICreate("Process Blocker", 565, 419, (@DesktopWidth - 565) / 2, (@DesktopHeight - 409) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$Process_List_View = GUICtrlCreateListView("Processes", 1, 30, 220, 370)
$Block_List_view = GUICtrlCreateListView("Block", 344, 30, 220, 370)
$Label_Process = GUICtrlCreateLabel("Process List", 10, 10, 220, 20)
$Label_Block = GUICtrlCreateLabel("Block List", 340, 10, 220, 20)
$Label_Add = GUICtrlCreateLabel("Add To Block List", 240, 30, 90, 20)
$Button_Add = GUICtrlCreateButton("&Add", 240, 50, 90, 30)
$Button_Delete = GUICtrlCreateButton("&Delete", 240, 130, 90, 30)
$Label_Delete = GUICtrlCreateLabel("Delete From List", 240, 110, 90, 20)
$Button_Reset = GUICtrlCreateButton("&Reset", 240, 270, 90, 50)
$Button_Block = GUICtrlCreateButton("&Block", 240, 190, 90, 50)
$Button_Exit = GUICtrlCreateButton("&Exit", 240, 350, 90, 50)
$Menu = GUICtrlCreateMenu("&File")
$Save = GUICtrlCreateMenuItem("&Save", $Menu)
$Load = GUICtrlCreateMenuItem("&Load", $Menu)
$Button_Donate = GUICtrlCreateButton("&Donate", 240, 10, 90, 20)
GUISetState() ; END OF GUI CREATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IN THE HELP FILE IT SENDS ProcessList() TO A MESSAGE BOX.....
; I HAD THE IDEAL TO SEND IT TO A LIST VIEW
Func _processlist()
	Dim $LVM_DELETEITEM = 0x1008
	$Process = ProcessList()
	For $i = 1 To $Process[0][0]
		$items = GUICtrlCreateListViewItem($Process[$i][0], $Process_List_View)
	Next
EndFunc   ;==>_processlist
_processlist()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Global $break = 0
; USE THIS FUNCTION TO EXIT THE RUN LOOP
; THANKS GOES TO erifash
Func _break()
	$break = 1
EndFunc   ;==>_break
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; USE THIS FUNCTION TO OPEN AN URL ON THE DEFAULT BROWSER
; THANKS TO Ejoc AND SlimShady FOR THIS FUNCTIONS
Func _GoToWebPage($URL)
	Run(@comspec & ' /c START "" "' & $URL & '"', @SystemDir, @SW_HIDE)
EndFunc   ;==>_GoToWebPage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;THANKS TO bshoenhair FOR POINTING TO "http://www.autoitscript.com/forum/index.php?showtopic=7026&hl="
;USE THIS FUNCTION TO MOVE SELECTED ITEM BETWEEN LIST VIEWS
Func _Move_Selected_Item_To_Another_List_View($Source_List_View, $destination_List_view)
	Dim $LVM_DELETEITEM, $a, $ItemCount, $Source_Title
	;COPY SELCTED ITEM FROM SOURCE LIST VIEW AND PASTE IT TO THE DESTINATION LIST VIEW
	GUICtrlCreateListViewItem(GUICtrlRead(GUICtrlRead($Source_List_View)), $destination_List_view)
	; THIS NUMBER IS USED TO DELETE AN ITEM FROM A LIST VIEW, SOME TYPE OF...
	; MICROSOFT STANDARD CONTROL NUMBER, I JUST KNOW IT WORKS
	$LVM_DELETEITEM = 0x1008
	$ItemCount = ControlListView("", "", $Source_List_View, "GetItemCount")
	For $a = 0 To $ItemCount - 1
		If ControlListView("", "", $Source_List_View, "IsSelected", $a) Then
			;DELETES THE SELECTED ITEM FROM THE SOURCE LIST VIEW
			GUICtrlSendMsg($Source_List_View, $LVM_DELETEITEM, $a, 0)
		EndIf
	Next
EndFunc   ;==>_Move_Selected_Item_To_Another_List_View
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; USE THIS FUNCTION TO CLEAR ALL ITEMS IN A LIST VIEW
Func _clearlistview($List_View)
	#cs
	Do
		Dim $LVM_DELETEITEM, $a, $ItemCount
		$LVM_DELETEITEM = 0x1008
		$ItemCount = ControlListView("", "", $List_View, "GetItemCount")
		For $a = 0 To $ItemCount - 1
			GUICtrlSendMsg($List_View, $LVM_DELETEITEM, $a, 0)
		Next
	;DO UNTIL ALL ITEMS ARE CLEARED	
	Until $ItemCount = 0
	#ce
	; I FOUND A BETTER WAY, THANKS TO Gary Frost AUTHOR OF CFCCodeWizard
	; AS YOU CAN SEE THERE IS MORE THEN ONE WAY AND HIS WAY IS THE CORRECT.
	Local $LVM_DELETEALLITEMS = 0x1009
   GUICtrlSendMsg($LIST_VIEW, $LVM_DELETEALLITEMS, 0, 0)
EndFunc   ;==>_clearlistview
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THANKS TO Lazycat FOR THE Fade FUNCTION
; AUTHOR OF Quick Notepad v0.5
; CAUSES THE GUI TO FADE IN OR OUT
; I BELIEVE $nStart AND $nEnd ARE BACKARDS
; $nEnd = HOW TRANSPARENT THE WINDOW STARTS, RANGE 0 - 255
; $nStart = HOW TRANSPARENT THE WINDOW ENDS, RANGE 0 - 255
; $hWnd IS THE WINDOW NAME
; $nStep IS HOW FAST
Func Fade($hWnd, $nStart, $nEnd, $nStep)
    If not $nStep Then Return
    For $t = $nStart to $nEnd step $nStep * ($nEnd - $nStart)/Abs($nEnd - $nStart)
        WinSetTrans ($hWnd, "", $t)
    Next
EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
While 1
	Dim $msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Button_Add
			; ADD ITEM FROM $Process_List_View TO $Block_List_view
			_Move_Selected_Item_To_Another_List_View($Process_List_View, $Block_List_view)
		Case $msg = $Button_Delete
			; MOVE ITEM BACK TO $Process_List_View
			_Move_Selected_Item_To_Another_List_View($Block_List_view, $Process_List_View)
		Case $msg = $Button_Block
			; THIS WHOLE AREA IS THE CORE OF THE SCRIPT
			; THIS AREA IS WHERE PROCESSES ARE BLOCKED
			Fade($gui, 100, 0, 10)
			GUISetState(@SW_HIDE, $GUI)
			HotKeySet("{ESC}", "_break")
			While 1
				Dim $count_items, $Get_text, $b
				;COUNT ITEMS IN THE $Block_List_view
				$count_items = ControlListView("Process Blocker", "", $Block_List_view, "GetItemCount")
				For $b = 0 To $count_items - 1
					; GET ALL OF THE ITEMS IN THE $Block_List_view
					$Get_text = ControlListView("Process Blocker", "", $Block_List_view, "GetText", $b)
					; CLOSE ALL OF THE ITEMS IN THE $Block_List_view UNTIL THE LOOP IS BROKEN
					ProcessClose($Get_text)
				Next
				; USED TO BREAK THE LOOP
				If $break = 1 Then
					HotKeySet("{ESC}")
					$break = 0
					GUISetState(@SW_SHOW, $GUI)
					Fade($gui, 0,250, 3)
					ExitLoop
				EndIf
			WEnd
		Case $msg = $Button_Reset
			; RESET ALL OF THE LIST VIEWS AND ENABLE THE BUTTONS IF THE....
			; BUTTONS WERE DISABLED FROM LOADING THE SAVE FILE
			_clearlistview($Process_List_View)
			_clearlistview($Block_List_view)
			_processlist()
			GUICtrlSetState($Button_Add, $GUI_ENABLE)
			GUICtrlSetState($Button_Delete, $GUI_ENABLE)
		Case $msg = $Save
			Dim $count_items, $b
			If FileExists("BlockProcessesSave.txt") Then
				;DELETE THE OLD FILE BEFORE WRITING A NEW ONE SO THAT THE LAST SAVE IS REPLACED
				FileDelete("BlockProcessesSave.txt")
				$count_items = ControlListView("Process Blocker", "", $Block_List_view, "GetItemCount")
				For $b = 0 To $count_items - 1
					Dim $Get_text[$count_items]
					$file = FileOpen("BlockProcessesSave.txt", 1)
					;SET ALL ITEMS IN THE $Block_List_view TO AN ARRAY
					$Get_text[$b] = ControlListView("Process Blocker", "", $Block_List_view, "GetText", $b)
					Do
						; GIVE TIME FOR THE FILE TO BE OPENED/CREATED BEFORE WRITING FILE
						Sleep(1000)
					Until FileExists("BlockProcessesSave.txt")
					;WRITE ALL ITEMS IN THE ARRAY TO THE FILE
					FileWrite($file, $Get_text[$b] & @CRLF)
					FileClose($file)
				Next
			ElseIf Not FileExists("BlockProcessesSave.txt") Then
				$count_items = ControlListView("Process Blocker", "", $Block_List_view, "GetItemCount")
				For $b = 0 To $count_items - 1
					Dim $Get_text[$count_items]
					$file = FileOpen("BlockProcessesSave.txt", 1)
					$Get_text[$b] = ControlListView("Process Blocker", "", $Block_List_view, "GetText", $b)
					Do
						Sleep(1000)
					Until FileExists("BlockProcessesSave.txt")
					FileWrite($file, $Get_text[$b] & @CRLF)
					FileClose($file)
				Next
			EndIf
		Case $msg = $Load
			; CLEAR ALL ITEMS BEFORE LOADING
			_clearlistview($Block_List_view)
			_clearlistview($Process_List_View)
			Dim $aRecords
			If Not _FileReadToArray("BlockProcessesSave.txt", $aRecords) Then
				MsgBox(4096, "Error", "Make Sure You Have A Saved List")
				Exit
			EndIf
			For $x = 1 To $aRecords[0]
				; $aRecords[$x] IS AN ARRAY THAT CONTAINS THE ITEMS FROM THE SAVE FILE
				; SET THE $Block_List_view ITEMS TO THE ITEMS STORED IN THE ARRAY
				; THE STRING TRIM IS TO CUT OUT THE LAST CHARACTER ,A SQUARE SHAPED CHARACTER
				; I BELIEVE THE SQUARE IS FROM LINE BREAKS I USED IN WRITING THE SAVE FILE
				GUICtrlCreateListViewItem(StringTrimRight($aRecords[$x], 1), $Block_List_view)
			Next
			; DISABLE BUTTONS TO AVOID ERRORS
			GUICtrlSetState($Button_Add, $GUI_DISABLE)
			GUICtrlSetState($Button_Delete, $GUI_DISABLE)
			GUICtrlCreateListViewItem("Click reset to reload list.", $Process_List_View)
		Case $msg = $Button_Donate
			; EVERY DOLLAR COUNTS AND
			; EVERY PENNY COUNTS TOO, LOL
			_GoToWebPage("https://www.paypal.com/xclick/business=quick_sliver007%40yahoo%2ecom&no_shipping=0&no_note=1&tax=0&currency_code=USD")
		Case $msg = $Button_Exit
			Exit
	EndSelect
WEnd
#cs
	I HOPE I DIDN'T GO OVER KILL WITH THE ANNOTATION. I ALL WAYS WANTED WELL ANNOTATED SCRIPTS
	TO LEARN FROM WHEN I HAD JUST STARTED TO LEARN AUTOLT 3. THE ONES I DID FIND WERE FAR AND FEW BETWEEN.
	SO I JUST WANTED TO ADD ONE TO THE PILE OF WELL ANNOTATED SCRIPTS FOR PEOPLE TO LEARN FROM. I KNOW
	I STILL HAVE A LOT MORE TO LEARN IN AUTOLT 3 BUT I WOULD LIKE TO HELP GIVE PEOPLE THAT ARE NEW
	SOMETHING MORE TO LEARN FROM. FOR NOW AM DONE WITH THIS SCRIPT. IF YOU FIND A BUG, FEEL FREE TO
	LET ME KNOW. I GIVE MANY THANKS TO ALL OF THE PEOPLE ON THE AUTOLT FORUM THAT HAVE HELPED ME LEARN
	THIS LANGUAGE.
	P.S.
	FEEL FREE TO DONATE.
#CE

