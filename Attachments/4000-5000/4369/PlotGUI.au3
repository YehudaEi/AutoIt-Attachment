#include <GuiConstants.au3>
;Opt("GUIOnEventMode", 1)

; VARIABLES
Dim $var
Dim $listcontents

; OPTIONS
Opt("TrayIconDebug", 1)

; GUI
GuiCreate("Plot File", 400, 400)
GuiSetIcon("favicon.ico", 0)

; MENU 
GuiCtrlCreateMenu("&File")
GuiCtrlCreateMenu("&Edit")
GuiCtrlCreateMenu("&Help")

$defaultdir = "X:\PLOT"

;-----------------------------------------------------------

; FILE BROWSE
GuiCtrlCreateLabel("Location:", 5, 5, 153, 15)
$combo = GuiCtrlCreatecombo($defaultdir, 5, 20, 230, 160)
guictrlsetdata(7,$defaultdir)

; BROWSE BUTTON
GuiCtrlCreateButton("&Browse", 270, 18, 100, 25)

;-----------------------------------------------------------

; FILE LIST
GuiCtrlCreateLabel("Select File:", 5, 55, 153, 15)
$sizetext = "Size"
$listView = GuiCtrlCreateListView("File|Size|Modified|", 5, 70, 380, 100,$LVS_NOSORTHEADER)
;_GUICtrlListViewJustifyColumn($listview,1,1)

; Populate list with contents of default dir
FileChangeDir($defaultdir)
$initsearch = FileFindFirstFile("*.plt")
	
; Check if the search was successful
If $initsearch = 0 Then
	
	While 1
		$initfile = Filefindnextfile($initsearch)
		$initsize = FileGetSize($initfile) / 1024
		;Array
		;-$t = FileGetTime($initfile,0,0)
		;String
		;$t = FileGetTime($initfile,0,1)
		;-MsgBox(0, "Debug", $t[0])
		;Array
		;-$MMDDYYYYT = $t[1] & "/" & $t[2] & "/" & $t[0]
		;String
		;$MMDDYYYYT = StringLeft($t,4) & "/" & StringMid($t,4,2) & "/" & StringMid($t,6,2) & " " & StringMid($t,8,2) & ":" & StringMid($t,10,2)

		$initbytemarker = " KB"
		If @error Then Exitloop
	
		$listcontents = GuiCtrlCreateListViewItem($initfile & "|" & $initsize & $initbytemarker, $listView)
	WEnd
EndIf

FileClose($initsearch)

;-----------------------------------------------------------

; UPDOWN
GuiCtrlCreateLabel("Number Copies:", 260, 243)
GuiCtrlCreateInput("1", 345, 240, 40, 20)
GuiCtrlCreateUpDown(-1)
Guictrlsetlimit(-1,99,0)

; PRINTER DROPDOWN
GuiCtrlCreateLabel("Select Printer:", 5, 225, 153, 15)
GuiCtrlCreatecombo("HP 1050C", 5, 240, 230, 160)
guictrlsetdata(-1,"K+E 6800")

; SUBMIT BUTTON
GuiCtrlCreateButton("&Submit Job", 285, 300, 100, 30)

;-----------------------------------------------------------

; GUI MESSAGE LOOP
GuiSetState()
While GuiGetMsg() <> $GUI_EVENT_CLOSE

	$msg = GuiGetMsg(0)

	Select
	Case $msg = 8 ; browse button
		; BROWSE
		
		$message = "Select a folder..."
		$var = FileSelectFolder($message, "", 2, $defaultdir)
		
		If @error Then
			MsgBox(4096,"","No Folder chosen")
		Else

			FileChangeDir($var)
			$search = FileFindFirstFile("*.plt")
			
			; Check if the search was successful
			If $search = -1 Then
				    MsgBox(0, "Error", "No plot files.  Choose a new location.")
			Else
			
			If $search = 0 Then
				
				While 1
					$file = Filefindnextfile($search)
					$size = FileGetSize($file) / 1024

					$bytemarker = " KB"
					If @error Then Exitloop
				
					$listcontents = GuiCtrlCreateListViewItem($file & "| " & Round($size,0) & $bytemarker, $listView)
				WEnd
			EndIf
			EndIf
			FileClose($search)
		
		EndIf
		
		; EDIT BOX
		;GuiCtrlCreateEdit("Drag files here...", 200, 70, 185, 100,$ES_AUTOVSCROLL+$WS_VSCROLL)
		;GUICtrlSetState(-1,$GUI_ACCEPTFILES)
	
	Case $msg = 18 ; submit button
		;MsgBox(4096,"Status","Submit Button",1)
										
			;If Not $listcontents = "" Then
				GUICtrlDelete($listcontents)
			;EndIf

	EndSelect
Wend

; FUNCTIONS
Func FormatNumber($Number)
	;Given a number such as 12345678 will return 12,345,678
	Dim $Result='', $Pos
	If StringIsDigit($Number) Then
	$Pos = StringLen($Number)-2
	While $Pos > -2
	If $Pos < 1 Then
	$Result = StringMid($Number, 1, $Pos + 2) & ',' & $Result
	Else
	$Result = StringMid($Number, $Pos, 3) & ',' & $Result
	EndIf
	$Pos = $Pos - 3
	WEnd
	$Result=StringLeft($Result, StringLen($Result) - 1)
	EndIf
	Return $Result
EndFunc

Exit