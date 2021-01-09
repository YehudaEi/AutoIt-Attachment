;
;	Adressenboek
;	Version 0.17
;


;;	Includes
#include <File.au3>
#include <String.au3>
#include <GUIConstants.au3>

;;	Init
Global	Const	$VERSION		=	"1.20a";;20 versions
Global	Const	$DATAFILE		=	"DATA.AB1"
Global	Const	$DATAMAX		=	5000
Global	Const	$tabwidth		=	475
Global	Const	$tabheight		=	475

Global	$width			=	500
Global	$height			=	475
Global	$handle			=	GUICreate("Adressenboek  ---  " & $VERSION, 500, 500)

Dim		$DeleteOn		=	0

Opt("GUICloseOnESC",	0)
Opt("RunErrorsFatal",	0)
Opt("TrayOnEventMode",	0)
Opt("TrayIconHide",		1)
Opt("TrayIconDebug",	0)

	;;	--Open File: $DATAFILE
	If Not FileExists($DATAFILE) Then
		$RESULT	=	_FileCreate($DATAFILE)
		If $RESULT = 0 Then
			Error("Bestand " & $DATAFILE & " kan niet gemaakt worden.")
			Exit
		EndIf
		
		;;	--Insert Data: $DATAFILE
		FileWrite($DATAFILE, "# FILE_CREATED @ "&@MDAY&@MON&@YEAR&@CRLF)
		FileWrite($DATAFILE, "# Please do not modify"&@CRLF&@CRLF)
		FileWrite($DATAFILE, "[ONLOAD]"&$DATAFILE&"[/ONLOAD]"&@CRLF)
		FileWrite($DATAFILE, "[VERSION]"&$VERSION&"[/VERSION]"&@CRLF)
		FileWrite($DATAFILE, "[DATAMAX]"&$DATAMAX&"[/DATAMAX]"&@CRLF)
	EndIf
	
	;;	--Read File: $DATAFILE
	Global	$DATA_INFO[$DATAMAX]

;;	Create Tabs + Tabitems
Global	$tabitem[10]
$tabview	=	GUICtrlCreateTab(10, 10, $tabwidth, $tabheight)
GUICtrlSetStyle($tabview, $TCS_FOCUSNEVER)

	;;	--Tabitem: Adressen
	$tabitem[0]	=	GUICtrlCreateTabItem("Adressen")

	;;	--ListView
	Global	$COUNT_ITEMS	=	0
	Global	$CTRL_ITEM[$DATAMAX]
	$listview	=	GUICtrlCreateListView("Postcode|Adres|Nr|Telefoonnummer|Opmerkingen", 10, 31, 470.5, $tabheight-25)
	GUICtrlRegisterListViewSort(-1, "ListViewSort")
	Refresh()

	;;	--Manual Refresh
;~ 	GUICtrlCreateLabel("", $width-110, 15, 65, 15, $SS_BLACKFRAME)
	$manualrefresh	=	GUICtrlCreateLabel("Refresh", $width-110, 15, 65, 15, $SS_CENTER )
	GUICtrlSetFont(-1, 11)

	;;	--Tabitem: Toevoegen
	$tabitem[1]	=	GUICtrlCreateTabItem(" Nieuw Adres ")
		
		;;	--Create Input
		Global	$INPUTADD[7]
			
			;;	--Label:	Information
			GUICtrlCreateLabel("Gegevens Toevoegen", 22, 55, 160)
			GUICtrlSetFont(-1, 13, 550)
			$INFO	=	"Vul de gegevens van een klant in. Druk op Toevoegen om de gegevens permanent te maken. Om de"
			$INFO	&=	" ingevulde gegevens ongedaan te maken, druk je op Overnieuw."
			GUICtrlCreateLabel($INFO, 22,80, 450, 50)
			GUICtrlSetFont(-1, 10, 400)
			
			;;	--Graphic:	Style line
			GUICtrlCreateGraphic(18, 178, 450, 230,$SS_BLACKFRAME)
			
			;;	--Input:	postcode
			GUICtrlCreateLabel("Postcode:", 30, 198)
			$INPUTADD[0]	=	GUICtrlCreateInput("", 120, 195, 50, 20, $ES_CENTER+$ES_UPPERCASE)
			
			;;	--Input:	Straat
			GUICtrlCreateLabel("Straat:", 30, 228)
			$INPUTADD[1]	=	GUICtrlCreateInput("", 120, 225, 225, 20)
			 
			;;	--Input:	Huisnummer
			GUICtrlCreateLabel("Huisnummer:", 30, 258)
			$INPUTADD[2]	=	GUICtrlCreateInput("", 120, 255, 50, 20, $ES_CENTER+$ES_UPPERCASE)
			
			;;	--Input:	Telefoon nummer
			GUICtrlCreateLabel("Telefoon:", 30, 288)
			$INPUTADD[3]	=	GUICtrlCreateInput("", 120, 285, 70, 20, $ES_LEFT+$ES_NUMBER)
			
			;;	--Input:	Opmerkingen
			GUICtrlCreateLabel("Opmerking:", 30, 318)
			$INPUTADD[4]	=	GUICtrlCreateInput("", 120, 315, 300, 20)
			
			;;	--Button:	Toevoegen
			$INPUTADD[5]	=	GUICtrlCreateButton("Toevoegen", 30, 360)
			
			;;	--Button:	Reset
			$INPUTADD[6]	=	GUICtrlCreateButton("Overnieuw ", 95, 360)
		
		
	;;	--Tabitem: Wijzigen
	$tabitem[3]	=	GUICtrlCreateTabItem(" Adres Wijzigen ")
	Global	$ONMODIFY		=	""
		
		;;	--Create Input
		Global	$INPUTEDIT[7]
		
		;;	--Label:	Information
		GUICtrlCreateLabel("Gegevens Wijzigen", 22, 55, 160)
		GUICtrlSetFont(-1, 13, 550)
		$INFO	=	"Vul de gegevens van een klant in. Als de gegevens aangepast is, druk dan op Aanpassen "
		$INFO	&=	"om het permanent te maken. Om de ingevulde gegevens ongedaan te maken, druk je op Annuleren."
		GUICtrlCreateLabel($INFO, 22,80, 450, 50)
		GUICtrlSetFont(-1, 10, 400)
		
		;;	--Graphic:	Style line
		GUICtrlCreateGraphic(18, 178, 450, 230,$SS_BLACKFRAME)
		
		;;	--Input:	postcode
		GUICtrlCreateLabel("Postcode:", 30, 198)
		$INPUTEDIT[0]	=	GUICtrlCreateInput("", 120, 195, 50, 20, $ES_CENTER+$ES_UPPERCASE)
		GUICtrlSetStyle(-1, $WS_DISABLED)
		
		;;	--Input:	Straat
		GUICtrlCreateLabel("Straat:", 30, 228)
		$INPUTEDIT[1]	=	GUICtrlCreateInput("", 120, 225, 225, 20)
		GUICtrlSetStyle(-1, $WS_DISABLED)
		 
		;;	--Input:	Huisnummer
		GUICtrlCreateLabel("Huisnummer:", 30, 258)
		$INPUTEDIT[2]	=	GUICtrlCreateInput("", 120, 255, 50, 20, $ES_CENTER+$ES_UPPERCASE)
		GUICtrlSetStyle(-1, $WS_DISABLED)
		
		;;	--Input:	Telefoon nummer
		GUICtrlCreateLabel("Telefoon:", 30, 288)
		$INPUTEDIT[3]	=	GUICtrlCreateInput("", 120, 285, 70, 20, $ES_LEFT+$ES_NUMBER)
		GUICtrlSetStyle(-1, $WS_DISABLED)
		
		;;	--Input:	Opmerkingen
		GUICtrlCreateLabel("Opmerking:", 30, 318)
		$INPUTEDIT[4]	=	GUICtrlCreateInput("", 120, 315, 300, 20)
		GUICtrlSetStyle(-1, $WS_DISABLED)
		
		;;	--Button:	Toevoegen
		$INPUTEDIT[5]	=	GUICtrlCreateButton("Aanpassen", 30, 360)
		GUICtrlSetStyle(-1, $WS_DISABLED)
		
		;;	--Button:	Reset
		$INPUTEDIT[6]	=	GUICtrlCreateButton("Annuleren", 100, 360)
		GUICtrlSetStyle(-1, $WS_DISABLED)


	;;	--Tabitem: Zoeken
	$tabitem[2]	=	GUICtrlCreateTabItem(" Zoeken ")
		
		;;	--Create Input
		Global	$INPUTSEARCH[7]
		Global	$LISTSEARCHITEM[$DATAMAX]
		Global	$LISTSEARCHX
		
		Global	$SEARCHITEMX
		Global	$SEARCHITEM[$DATAMAX]
		
			;;	--Label:	Zoeken
			GUICtrlCreateLabel("Klant Zoeken", 22, 55, 160)
			GUICtrlSetFont(-1, 13, 550)
			$INFO	=	"Vul bekende gegevens van een klant in. Het programma zoekt automatisch met behulp van"
			$INFO	&=	" deze gegevens. De straatnaam en het huisnummer is verplicht!"
			GUICtrlCreateLabel($INFO, 22,80, 450, 50)
			GUICtrlSetFont(-1, 10, 400)
			
			;;	--Graphic:	Style line
			GUICtrlCreateGraphic(18, 148, 450, 150,$SS_BLACKFRAME)
			
			;;	--Input:	postcode
			GUICtrlCreateLabel("Postcode:", 30, 168)
			$INPUTSEARCH[0]	=	GUICtrlCreateInput("", 120, 165, 50, 20, $ES_CENTER+$ES_UPPERCASE)
			
			;;	--Input:	Straat
			GUICtrlCreateLabel("*Straat:", 30, 198)
			$INPUTSEARCH[1]	=	GUICtrlCreateInput("", 120, 195, 225, 20)
			 
			;;	--Input:	Huisnummer
			GUICtrlCreateLabel("*Huisnummer:", 30, 228)
			$INPUTSEARCH[2]	=	GUICtrlCreateInput("", 120, 225, 50, 20, $ES_CENTER+$ES_UPPERCASE)
			
			;;	--Button:	Zoeken
			$INPUTSEARCH[3]	=	GUICtrlCreateButton("Zoeken", 35, 260)
			
			;;	--Button:	Reset
			$INPUTSEARCH[4]	=	GUICtrlCreateButton("Overnieuw", 85, 260)
		
		$LISTSEARCH	=	GUICtrlCreateListView("Postcode|Adres|Nr|Telefoonnummer|Opmerkingen", 10, 331, 470.5, $tabheight/3-9)
		
		
	;;	--Context Menu
;~ 	Global $MENUITEM[10]
;~ 	$contextmenu	=	GUICtrlCreateContextMenu($handle)
;~ 	$MENUITEM[0]	=	GUICtrlCreateMenuItem("wijzigen", $contextmenu)
;~ 	$MENUITEM[1]	=	GUICtrlCreateMenuItem("Verwijderen", $contextmenu)
		
		
;;	--Delete Button
HotKeySet ( "{DEL}", "Remove")

;;	--Modify Button
HotKeySet ( "{ENTER}", "Modify")

;;	--Runtime
GUISetState(@SW_SHOW, $handle)

While 1
	$event	=	GUIGetMsg()

	LimitInput()

	Select
		Case	$event	=	$INPUTADD[5]
			DataWrite()
			
		Case	$event	=	$INPUTSEARCH[3]
			DataSearch()
			
		Case	$event	=	$INPUTADD[6]
			DataClear("ADD")
			
		Case	$event	=	$INPUTSEARCH[4]
			DataClear("SEARCH")
			
		Case	$event	=	$INPUTEDIT[5]
			DataModify()
			
		Case	$event	=	$INPUTEDIT[6]
			DataClear("MODIFY")
			
		Case	$event	=	$manualrefresh
			Refresh()
			
		Case	$event	=	$GUI_EVENT_CLOSE
			ExitLoop
			
			
	EndSelect
		
	If @error = 1 Then
		MsgBox(48, "Error", @error)
	EndIf
WEnd

Exit


;;-----------------------------------------------------------------------------------------------------------------------------------


Func Refresh()
	For $x=1 To $COUNT_ITEMS Step 1
		If GUICtrlDelete($CTRL_ITEM[$x]) = 0 Then
			Error("Error in file "&$DATAFILE&@CRLF&"Runtime error @ line 248 #Failed function Refresh()")
		EndIf
	Next
	
	$COUNT_ITEMS	=	0
	
	Local	$DATA_INDEX	=	FileIndex()
	For $x=1 To $DATA_INDEX
		$RESULT	=	StringInStr($DATA_INFO[$x], "[ITEM]", 2)
		If Not $RESULT = 0 Then
			$POST	=	_StringBetween($DATA_INFO[$x], "[POSTCODE]", "[/POSTCODE]")
			$STREET	=	_StringBetween($DATA_INFO[$x], "[STRAAT]", "[/STRAAT]")
			$NUMBER	=	_StringBetween($DATA_INFO[$x], "[HUISNUMMER]", "[/HUISNUMMER]")
			$PHONE	=	_StringBetween($DATA_INFO[$x], "[TELEFOON]", "[/TELEFOON]")
			$MORE	=	_StringBetween($DATA_INFO[$x], "[COMMENT]", "[/COMMENT]")
			
			If Not @error = 1 Then
				$COUNT_ITEMS	=	$COUNT_ITEMS+1
				$CTRL_ITEM[$COUNT_ITEMS]	=	GUICtrlCreateListViewItem($POST[0]&"|"&$STREET[0]&"|"&$NUMBER[0]&"|"&$PHONE[0]&"|"&$MORE[0], $listview)
			Else
				Error("Error in file "&$DATAFILE&@CRLF&"Runtime error on line 268 #Failed function Refresh()")
			EndIf
		EndIf
	Next
EndFunc

Func DataWrite()
	If GUICtrlRead($INPUTADD[0]) = "" Then
		GUICtrlSetData($INPUTADD[0], "GEEN")
	EndIf
	
	If StringReplace(GUICtrlRead($INPUTADD[1]), " ","") = "" Then
		GUICtrlSetData($INPUTADD[1], "GEEN")
	EndIf

	If GUICtrlRead($INPUTADD[2]) = "" Then
		GUICtrlSetData($INPUTADD[2], "GEEN")
	EndIf

	If GUICtrlRead($INPUTADD[3]) = "" Then
		GUICtrlSetData($INPUTADD[3], "GEEN")
	EndIf

	If StringReplace(GUICtrlRead($INPUTADD[4]), " ","") = "" Then
		GUICtrlSetData($INPUTADD[4], "GEEN")
	EndIf
	
	$POST	=	"[POSTCODE]"&GUICtrlRead($INPUTADD[0])&"[/POSTCODE]"
	$STREET	=	"[STRAAT]"&GUICtrlRead($INPUTADD[1])&"[/STRAAT]"
	$NUMBER	=	"[HUISNUMMER]"&GUICtrlRead($INPUTADD[2])&"[/HUISNUMMER]"
	$PHONE	=	"[TELEFOON]"&GUICtrlRead($INPUTADD[3])&"[/TELEFOON]"
	$COMMENT=	"[COMMENT]"&GUICtrlRead($INPUTADD[4])&"[/COMMENT]"
	
	$CODE	=	UniqueID()
	$CODE	=	"[CODE]"&$CODE&"[/CODE]"
	$NEWDATA	=	&@CRLF"[ITEM]"&$CODE&$POST&$STREET&$NUMBER&$PHONE&$COMMENT&"[/ITEM]"
	
	If FileWrite($DATAFILE, $NEWDATA) = 1 Then
		DataClear("ADD")
		Refresh()
	Else
		Error("Bestand " & $DATAFILE & " kan niet worden herschreven! Het toevoegen van de ingevoerde gegevens is gefaald.")
	EndIf
EndFunc

Func DataClear($order)
	If $order = "ADD" Then
		GUICtrlSetData($INPUTADD[0], "")
		GUICtrlSetData($INPUTADD[1], "")
		GUICtrlSetData($INPUTADD[2], "")
		GUICtrlSetData($INPUTADD[3], "")
		GUICtrlSetData($INPUTADD[4], "")
	ElseIf $order = "SEARCH" Then
		;;	--Renew List
		For $x=1 To $DATAMAX Step 1
			If Not $SEARCHITEM[$x] = "" Then
				GUICtrlDelete($SEARCHITEM[$x])
			Else
				ExitLoop
			EndIf
		Next
		
		GUICtrlSetData($INPUTSEARCH[0], "")
		GUICtrlSetData($INPUTSEARCH[1], "")
		GUICtrlSetData($INPUTSEARCH[2], "")
	ElseIf $order = "MODIFY" Then
		$ONMODIFY = ""
		GUICtrlSetData($INPUTEDIT[0], "")
		GUICtrlSetData($INPUTEDIT[1], "")
		GUICtrlSetData($INPUTEDIT[2], "")
		GUICtrlSetData($INPUTEDIT[3], "")
		GUICtrlSetData($INPUTEDIT[4], "")
		
		GuiCtrlSetState($INPUTEDIT[0], $GUI_DISABLE)
		GuiCtrlSetState($INPUTEDIT[1], $GUI_DISABLE)
		GuiCtrlSetState($INPUTEDIT[2], $GUI_DISABLE)
		GuiCtrlSetState($INPUTEDIT[3], $GUI_DISABLE)
		GuiCtrlSetState($INPUTEDIT[4], $GUI_DISABLE)
		GuiCtrlSetState($INPUTEDIT[5], $GUI_DISABLE)
		GuiCtrlSetState($INPUTEDIT[6], $GUI_DISABLE)
	EndIf
EndFunc

Func DataSearch()
	
	;;	--Renew List
	For $x=1 To $DATAMAX Step 1
		If Not $SEARCHITEM[$x] = "" Then
			GUICtrlDelete($SEARCHITEM[$x])
		Else
			ExitLoop
		EndIf
	Next

	;;	--Declaration
	Local	$POST	=	GUICtrlRead($INPUTSEARCH[0])
	Local	$STRAAT	=	GUICtrlRead($INPUTSEARCH[1])
	Local	$NUMMER	=	GUICtrlRead($INPUTSEARCH[2])
	
	Local	$OCCURENCE[$DATAMAX]
	Local	$OCCMAX=0
	
	Local	$DATA_INDEX	=	FileIndex()
	
	Local	$MATCHX=0
	Local	$MATCHFOUND[$DATAMAX]
	
	If $NUMMER="" Or $STRAAT="" Then
		MsgBox(032, "Zoeken gefaald", "Het zoeken is gefaald. Kijk of het straat en het nummer is ingevuld.")
		
	Else
		;;	--Rough Occurence Search
		For $x=1 To $DATA_INDEX Step 1
			$DATA_STRING	=	FileReadLine($DATAFILE, $x)
			
			If $POST = "" Then
				$RESULT	=	StringInStr($DATA_STRING, "[STRAAT]"&$STRAAT&"[/STRAAT][HUISNUMMER]"&$NUMMER&"[/HUISNUMMER]")
				If Not $RESULT = 0 Then
					$OCCMAX+=1
					$OCCURENCE[$OCCMAX]	=	$DATA_STRING
				EndIf
			Else
				$RESULT	=	StringInStr($DATA_STRING, "[POSTCODE]"&$POST&"[/POSTCODE][STRAAT]"&$STRAAT&"[/STRAAT]"&"[HUISNUMMER]"&$NUMMER&"[/HUISNUMMER]")
				If Not $RESULT = 0 Then
					$OCCMAX+=1
					$OCCURENCE[$OCCMAX]	=	$DATA_STRING
				EndIf
			EndIf
		Next
		
		;;	--Remove equality
;~ 		For $x=1 To $OCCMAX Step 1
;~ 			$ERROR = 0
;~ 			For $y=$x  To $OCCMAX Step 1
;~ 				If $OCCURENCE[$y] = $OCCURENCE[$x] Then
;~ 					$ERROR = 1
;~ 				EndIf
;~ 			Next
;~ 			
;~ 			If $ERROR = 0 Then
;~ 				$MATCHX	+=	1
;~ 				$MATCHFOUND[$MATCHX] = $OCCURENCE[$x]
;~ 			EndIf
;~ 		Next
		
		Local	$SEARCHITEMX=0
		
		For $x=1 To $OCCMAX Step 1
			$DATA_INPUT	=	$OCCURENCE[$x]
			If Not $DATA_INPUT = "" Then
				$POST	=	_StringBetween($DATA_INPUT, "[POSTCODE]", "[/POSTCODE]")
				$STREET	=	_StringBetween($DATA_INPUT, "[STRAAT]", "[/STRAAT]")
				$NUMBER	=	_StringBetween($DATA_INPUT, "[HUISNUMMER]", "[/HUISNUMMER]")
				$PHONE	=	_StringBetween($DATA_INPUT, "[TELEFOON]", "[/TELEFOON]")
				$MORE	=	_StringBetween($DATA_INPUT, "[COMMENT]", "[/COMMENT]")
				
				If Not @error = 1 Then
					$SEARCHITEMX+=1
					$SEARCHITEM[$SEARCHITEMX]	=	GUICtrlCreateListViewItem($POST[0]&"|"&$STREET[0]&"|"&$NUMBER[0]&"|"&$PHONE[0]&"|"&$MORE[0], $LISTSEARCH)
				EndIf
			EndIf
		Next
		
		If $SEARCHITEMX = 0 Then
			MsgBox(032, "Zoeken gefaald", "Het zoeken is gefaald. Er zijn geen gelijkenissen gevonden.")
		EndIf

	EndIf
EndFunc

Func Remove()
	If $tabitem[GUICtrlRead($tabview)] = $tabitem[0] Then
		If Not $DeleteOn = 1 Then
			$DeleteOn = 1
			$current	=	GUICtrlRead($listview)

			If Not $current = 0 Then
				$data	=	GUICtrlRead($current)
				$data	=	StringSplit($data, "|")

				$address	=	@CRLF&@CRLF&"("&$data[1]&")("&$data[4]&") "&$data[2]&" "&$data[3]&" - "&$data[5]
				$result		=	MsgBox(52,"Bevestiging","Weet u zeker om het item met het volgende adres te verwijderen?"&$address)
				$DeleteOn	=	0
				
				If $result = 6 Then
					$input1	=	StringReplace($data[1], " ", "")
					$input2	=	StringReplace($data[2], " ", "")
					$input3	=	StringReplace($data[3], " ", "")
					$input4	=	StringReplace($data[4], " ", "")
					
					$SCASE		=	"[POSTCODE]"&$input1&"[/POSTCODE][STRAAT]"&$input2&"[/STRAAT][HUISNUMMER]"&$input3&"[/HUISNUMMER][TELEFOON]"&$input4&"[/TELEFOON]"
					Local	$DATA_INDEX	=	FileIndex()
					
					For $x=1 To $DATA_INDEX Step 1
						$DATA_STRING	=	FileReadLine($DATAFILE, $x)
						$RESULT			=	StringInStr($DATA_STRING, $SCASE)
						
						If Not $RESULT = 0 Then
							#cs
							$input1	=	_StringBetween($DATA_STRING, "[POSTCODE]", "[/POSTCODE]")
							$input2	=	_StringBetween($DATA_STRING, "[STRAAT]", "[/STRAAT]")
							$input3	=	_StringBetween($DATA_STRING, "[HUISNUMMER]", "[/HUISNUMMER]")
							$input4	=	_StringBetween($DATA_STRING, "[TELEFOON]", "[/TELEFOON]")
							
							$FSTRING	=	$input1&$input2&$input3&$input4
							$LINE	=	$FSTRING
							#ce
							
							#cs
							$RULE	=	StringInStr(FileRead($DATAFILE), $SCASE)
							$DELETE	=	FileReadLine($DATAFILE, $RULE)
							#ce
							_ReplaceStringInFile($DATAFILE, $DATA_STRING, "", 0, 1)
							ExitLoop
						EndIf
						
						
					Next
					Refresh()
						
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc

Func Modify()
	If $tabitem[GUICtrlRead($tabview)] = $tabitem[0] Then
		If $ONMODIFY = "" Then
			$current	=	GUICtrlRead($listview)

			If Not $current = 0 Then
				$ONMODIFY	=	1
				$data	=	GUICtrlRead($current)
				$data	=	StringSplit($data, "|")
					
				$POSTCODE	=	"[POSTCODE]"&StringReplace($data[1], " ", "")&"[/POSTCODE]"
				$STRAAT		=	"[STRAAT]"&$data[2]&"[/STRAAT]"
				$NUMMER		=	"[HUISNUMMER]"&StringReplace($data[3], " ", "")&"[/HUISNUMMER]"
				$TELEFOON	=	"[TELEFOON]"&StringReplace($data[4], " ", "")&"[/TELEFOON]"
				$COMMENT	=	"[COMMENT]"&$data[5]&"[/COMMENT]"
				
				$ONMODIFY	=	$POSTCODE&$STRAAT&$NUMMER&$TELEFOON&$COMMENT
				
				GUICtrlSetData($INPUTEDIT[0], StringReplace($data[1], " ", ""))
				GUICtrlSetData($INPUTEDIT[1], $data[2])
				GUICtrlSetData($INPUTEDIT[2], StringReplace($data[3], " ", ""))
				GUICtrlSetData($INPUTEDIT[3], StringReplace($data[4], " ", ""))
				GUICtrlSetData($INPUTEDIT[4], $data[5])
				GUICtrlSetState($tabitem[3], $GUI_SHOW)
				
				GuiCtrlSetState($INPUTEDIT[0], $GUI_ENABLE)
				GuiCtrlSetState($INPUTEDIT[1], $GUI_ENABLE)
				GuiCtrlSetState($INPUTEDIT[2], $GUI_ENABLE)
				GuiCtrlSetState($INPUTEDIT[3], $GUI_ENABLE)
				GuiCtrlSetState($INPUTEDIT[4], $GUI_ENABLE)
				GuiCtrlSetState($INPUTEDIT[5], $GUI_ENABLE)
				GuiCtrlSetState($INPUTEDIT[6], $GUI_ENABLE)
			EndIf
		EndIf
	EndIf
EndFunc

Func DataModify()
	If Not $ONMODIFY = "" Then
		If GUICtrlRead($INPUTEDIT[0]) = "" Then
			GUICtrlSetData($INPUTEDIT[0], "GEEN")
		EndIf
		
		If StringReplace(GUICtrlRead($INPUTEDIT[1]), " ","") = "" Then
			GUICtrlSetData($INPUTEDIT[1], "GEEN")
		EndIf

		If GUICtrlRead($INPUTEDIT[2]) = "" Then
			GUICtrlSetData($INPUTEDIT[2], "GEEN")
		EndIf

		If GUICtrlRead($INPUTEDIT[3]) = "" Then
			GUICtrlSetData($INPUTEDIT[3], "GEEN")
		EndIf

		If StringReplace(GUICtrlRead($INPUTEDIT[4]), " ","") = "" Then
			GUICtrlSetData($INPUTEDIT[4], "GEEN")
		EndIf
		
		$POST	=	"[POSTCODE]"&GUICtrlRead($INPUTEDIT[0])&"[/POSTCODE]"
		$STREET	=	"[STRAAT]"&GUICtrlRead($INPUTEDIT[1])&"[/STRAAT]"
		$NUMBER	=	"[HUISNUMMER]"&GUICtrlRead($INPUTEDIT[2])&"[/HUISNUMMER]"
		$PHONE	=	"[TELEFOON]"&GUICtrlRead($INPUTEDIT[3])&"[/TELEFOON]"
		$COMMENT=	"[COMMENT]"&GUICtrlRead($INPUTEDIT[4])&"[/COMMENT]"
		
		$CHANGE	=	$POST&$STREET&$NUMBER&$PHONE&$COMMENT
		
		For $x=1 To FileIndex() Step 1
			$DATA_STRING	=	FileReadLine($DATAFILE, $x)
			$RESULT			=	StringInStr($DATA_STRING, $ONMODIFY)
			
;~ 			MsgBox(0,"", "RESULT: "&$RESULT&@CRLF&"CURRENT STRING: "&$DATA_STRING&@CRLF&@CRLF&"CHANGE: "&$CHANGE&@crlf&@crlf&"search: "&$ONMODIFY)
			If Not $RESULT = 0 Then
				$REPLACEMENT	=	StringReplace($DATA_STRING, $ONMODIFY, $CHANGE)
				_ReplaceStringInFile($DATAFILE, $DATA_STRING, $REPLACEMENT, 0, 0)
			EndIf
		Next

	DataClear("MODIFY")
	Refresh()
	GUICtrlSetState($tabitem[0], $GUI_SHOW)
	EndIf
EndFunc

;~ Func ListViewSort($ctrl, $item1, $item2, $column)
;~ 	If $column = 1 Then
;~ 		;;	--Straat
;~ 		$data	=	StringSplit(GUICtrlRead($item1), "|")
;~ 		
;~ 		If $data[0] = 1 Then
;~ 			Return 1
;~ 		Else
;~ 			$proces	=	$data[2]
;~ 			For $x=1 To StringLen($proces)
;~ 				
;~ 	EndIf
;~ EndFunc

#cs
Func ListViewValue($item, $x)
	;;Creates a value for a text
	;;A value increases when the character is further in the alphabet
	;;example: aba = 1+2+1 & aab = 1+1+2
	Local $data	=	StringSplit(GUICtrlRead($item), "|")
	Local $order	=	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	
	If $data[0] = 1 Then
		Return 0 
	Else
		Local $value	=	0
		For $x=1 To StringLen($data[$x]) Step 1
			For $y=1 To StringLen($order) Step 1
				If Not StringInStr(StringMid($data[$x],$x,1), $order) = 0 Then
					$value	+=	StringInStr($data[$x], $order)
				Else
					$value	+=	StringInStr($data[$x], $order)+0.5
				EndIf
			Next
		Next
	EndIf
	
	Return $value
EndFunc

Func ListViewSort($ctrl, $item1, $item2, $column)
	If $column = 1 Then
		;;	--Straat
		Local $value1	=	ListViewValue($item1, 2) ;;2=straat
		Local $value2	=	ListViewValue($item2, 2)

		If $value1 > $value2 Then
			Return 1
		ElseIf $value1 < $value2 Then
			Return -1
		EndIf
	EndIf

	If $column = 2 Then
		;;	--Huisnummer
	EndIf
EndFunc
#ce

Func FileIndex()
	For $x=1 To $DATAMAX Step 1
		$DATA_INFO[$x]	=	FileReadLine($DATAFILE, $x)
		If @error = -1 Then
			$DATA_INDEX	=	$x-1
			Return($DATA_INDEX)
			ExitLoop
		EndIf
	Next
EndFunc

Func Error($string)
	MsgBox(16, "Oops!", $string)
	Exit
EndFunc

Func LimitInput()
	;;	--Limit Postcode ($INPUTADD)
	$data	=	GUICtrlRead($INPUTADD[0])
	If StringLen($data) > 6 Then
		GUICtrlSetData($INPUTADD[0], StringMid($data, 1, 6))
	EndIf
	
	If StringLen($data) < 5 And Not StringIsDigit($data) = 1 Then
		GUICtrlSetData($INPUTADD[0], StringMid($data, 1, StringLen($data)-1))
	EndIf

	If StringLen($data) > 4 And Not StringIsAlpha( StringMid($data, 5) ) = 1 Then
		GUICtrlSetData($INPUTADD[0], StringMid($data, 1, StringLen($data)-1))
	EndIf

	;;	--Limit Postcode ($INPUTSEARCH)
	$data	=	GUICtrlRead($INPUTSEARCH[0])
	If StringLen($data) > 6 Then
		GUICtrlSetData($INPUTSEARCH[0], StringMid($data, 1, 6))
	EndIf
	
	If StringLen($data) < 5 And Not StringIsDigit($data) = 1 Then
		GUICtrlSetData($INPUTSEARCH[0], StringMid($data, 1, StringLen($data)-1))
	EndIf

	If StringLen($data) > 4 And Not StringIsAlpha( StringMid($data, 5) ) = 1 Then
		GUICtrlSetData($INPUTSEARCH[0], StringMid($data, 1, StringLen($data)-1))
	EndIf

	;;	--Limit Straat ($INPUTADD)
	$data	=	GUICtrlRead($INPUTADD[1])
	GUICtrlSetData( $INPUTADD[1], StringUpper(StringMid($data,1,1))&StringMid($data, 2) )

	If StringIsDigit(StringMid($data, StringLen($data), 1)) = 1 Then
		GUICtrlSetData($INPUTADD[1], StringMid($data, 1, StringLen($data)-1))
	EndIf
	
	;;	--Limit Straat ($INPUTSEARCH)
	$data	=	GUICtrlRead($INPUTSEARCH[1])
	GUICtrlSetData( $INPUTSEARCH[1], StringUpper(StringMid($data,1,1))&StringMid($data, 2) )

	If StringIsDigit(StringMid($data, StringLen($data), 1)) = 1 Then
		GUICtrlSetData($INPUTSEARCH[1], StringMid($data, 1, StringLen($data)-1))
	EndIf

	;;	--Limit Nummer ($INPUTADD)
	$data	=	GUICtrlRead($INPUTADD[2])
	If Not StringIsDigit(StringMid($data, 1, 1)) = 1 Then
		GUICtrlSetData($INPUTADD[2], StringMid($data, 1, StringLen($data)-1))
	EndIf
	
	;;	--Limit Nummer ($INPUTSEARCH)
	$data	=	GUICtrlRead($INPUTSEARCH[2])
	If Not StringIsDigit(StringMid($data, 1, 1)) = 1 Then
		GUICtrlSetData($INPUTSEARCH[2], StringMid($data, 1, StringLen($data)-1))
	EndIf

	;;	--Limit Telefoon
	$data	=	GUICtrlRead($INPUTADD[3])
	If StringLen($data) > 10 Then
		GUICtrlSetData($INPUTADD[3], StringMid($data, 1, 10))
	EndIf
EndFunc

Func UniqueID()
	$SCAN	=	FileIndex()
	
	For $x=0 To 10 Step 1
		$EXISTS	=	False
		$INDEX	=	$SCAN+$x
		
		If $INDEX < 10 Then
			;;	Example: "00004"<
			$KEY	=	"0000"&$INDEX
		ElseIf $INDEX < 100 Then
			;;	Example: "00040"<
			$KEY	=	"000"&$INDEX
		ElseIf $INDEX < 1000 Then
			;;	Example: "00400"<
			$KEY	=	"00"&$INDEX
		ElseIf $INDEX < 10000 Then
			;;	Example: "04000"<
			$KEY	=	"0"&$INDEX
		EndIf
		
		For $y=1 To $SCAN Step 1
			$DATA_LINE	=	FileReadLine($DATAFILE, $y)
			
			If StringInStr($DATA_LINE, "[CODE]"&$KEY&"[/CODE]") Then
				$EXISTS = True
			EndIf
		Next
		
		If $EXISTS	=	False Then
			Return $KEY
			ExitLoop
		EndIf
	Next
EndFunc