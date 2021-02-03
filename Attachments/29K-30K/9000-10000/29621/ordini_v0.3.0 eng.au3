#include <GuiConstantsEx.au3>
#include <get_id.au3>
#include <GuiListView.au3>
#include <ListviewConstants.au3>
#include <ButtonConstants.au3>
#include <File.au3>
#include <EditConstants.au3>
#Include <Date.au3>

;OPT
Opt("GUICloseOnESC", 0)
Opt("TrayIconHide", 1)

; Var
Global $Ver, $Errore, $Preorder_ID, $Order_ID, $Line_ID, $Code, $Description, $Quantity, $Prize, $Supplier
Global $Item_Listview, $Preorders_Listview, $Orders_Listview
Global $Sel_Button, $Add_Button, $Close_Button, $Modify_Button, $Delete_Preorders_Button, $Gen_Orders_Button
Global $Clear_Button, $View_Button, $Delete_Orders_Button, $Print_Button
Global $Items_File = @AppDataCommonDir & "\test\Items.dat"
Global $Preorders_File = @AppDataCommonDir & "\test\Preorders.dat"
Global $Orders_File = @AppDataCommonDir & "\test\Orders.dat"
Global $Order_Lines_File = @AppDataCommonDir & "\test\Orderlines.dat"
Dim $Fields_Items, $Fields_Preorders, $Fields_Orders, $Fields_Order_Lines

#cs
	$Items_File
$Fields_Items[1] ; Item_ID
$Fields_Items[2] ; Codice
$Fields_Items[3] ; Descrizione
$Fields_Items[4] ; Prezzo
$Fields_Items[5] ; Fornitore
$Fields_Items[6] ; Sconto (future use)

	$Preorders_File
$Fields_Preorders[1] ; Preorder_ID
$Fields_Preorders[2] ; Codice
$Fields_Preorders[3] ; Descrizione
$Fields_Preorders[4] ; Quantità
$Fields_Preorders[5] ; Prezzo
$Fields_Preorders[6] ; Fornitore
$Fields_Preorders[7] ; Sconto (future use)

	$Orders_File
$Fields_Orders[1] ; Order_ID
$Fields_Orders[2] ; Data_Ordine
$Fields_Orders[3] ; Fornitore
$Fields_Orders[4] ; Ordine_Completo
$Fields_Orders[5] ; Sconto (future use)
$Fields_Orders[6] ; file (future use)

	$Order_Lines_File
$Fields_Order_Lines[1] ; Line_ID
$Fields_Order_Lines[2] ; Order_ID
$Fields_Order_Lines[3] ; Preorder_ID
$Fields_Order_Lines[4] ; Codice
$Fields_Order_Lines[5] ; Descrizione
$Fields_Order_Lines[6] ; Quantità
$Fields_Order_Lines[7] ; Prezzo
$Fields_Order_Lines[8] ; Sconto (future use)
#ce

; GUI
GUICreate("Orders (C) 2009 by Adams", 575, 800)
$Ver = GUICtrlCreateLabel("v0.3.0", 5, 785, 30, 15)
GUICtrlSetColor($Ver, 0x5d5d5d) ; grayed
GUICtrlSetBkColor($Ver, $GUI_BKCOLOR_TRANSPARENT)

; GROUP 1 Anagrafica articoli
GUICtrlCreateGroup("Items",5,80,565,160)

; LISTVIEW Articoli Selezionati
$Items_Listview = GUICtrlCreateListView("ID|Code  |Description|Price |Vendor   ",10,100,555,90,-1,BitOR($LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
_load_items()

; BUTTON Seleziona
$Sel_Button = GuiCtrlCreateButton("&Select",465,200,100,30)

; GROUP 2 Riga preordine
GUICtrlCreateGroup("Preorder line",5,250,565,110)

; ID non esposto a video
$Preorder_ID = ""

; INPUT Codice
GUICtrlCreateLabel("Code", 14, 270, 50, 20)
$Code = GUICtrlCreateInput("", 10, 290, 100, 20,$ES_READONLY)

; INPUT Descrizione
GUICtrlCreateLabel("Description", 119, 270, 60, 20)
$Description = GUICtrlCreateInput("", 115, 290, 200, 20,$ES_READONLY)

; INPUT Quantità
GUICtrlCreateLabel("Quantity", 324, 270, 50, 20)
$Quantity = GUICtrlCreateInput("", 320, 290, 50, 20)

; INPUT Prezzo
GuiCtrlCreateLabel("Price", 379, 270, 50, 20)
$Prize = GuiCtrlCreateInput("", 375, 290, 50, 20)

; INPUT Fornitore
GUICtrlCreateLabel("Vendor", 434, 270, 60, 20)
$Supplier = GUICtrlCreateInput("", 430, 290, 135, 20,$ES_READONLY)

; BUTTON Salva
$Add_Button = GUICtrlCreateButton("Add", 465, 320, 100, 30)

; BUTTON Clear
$Clear_Button = GUICtrlCreateButton("Clear", 355, 320, 100, 30)

; GROUP 3 Preordini
GUICtrlCreateGroup("Preorders",5,370,565,170)

; LISTVIEW Preordini (il control viene inizializzato direttamente nella funzione)
_load_preorders()

; BUTTON Modifica
$Modify_Button = GuiCtrlCreateButton("Change",245,500,100,30)

; BUTTON Cancella
$Delete_Preorders_Button = GuiCtrlCreateButton("Delete",355,500,100,30)

; BUTTON Genera ordini
$Gen_Orders_Button = GuiCtrlCreateButton("Create Orders",465,500,100,30)

; GROUP 4 Ordini
GUICtrlCreateGroup("Orders",5,550,565,170)

; LISTVIEW Ordini
$Orders_Listview = GUICtrlCreateListView("ID|Date|Vendor   |Complete",10,570,555,100,-1,BitOR($LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
_load_orders()

; BUTTON Stampa
$Print_Button = GuiCtrlCreateButton("Print",245,680,100,30)

; BUTTON Vedi
$View_Button = GuiCtrlCreateButton("Display",355,680,100,30)

; BUTTON Cancella
$Delete_Orders_Button = GuiCtrlCreateButton("Delete",465,680,100,30)

; BUTTON Esci
$Close_Button = GuiCtrlCreateButton("Exit",465,760,100,30)

; GUI MESSAGE LOOP
GUISetState()
While 1
	$Msg = GUIGetMsg()
	Select
		Case $Msg = $Sel_Button
			If GUICtrlRead(GUICtrlRead($Items_Listview)) <> "" Then
				$aItems_List_Line = StringSplit(GUICtrlRead(GUICtrlRead($Items_Listview)), "|", 1)
				$Preorder_ID = ""
				GUICtrlSetData($Code, $aItems_List_Line[2])
				GUICtrlSetData($Description, $aItems_List_Line[3])
				GUICtrlSetData($Quantity, "")
				GUICtrlSetData($Prize, $aItems_List_Line[4])
				GUICtrlSetData($Supplier, $aItems_List_Line[5])
				GUICtrlSetData($Add_Button, "Add")
			EndIf
		Case $Msg = $Add_Button
			$Errore = ""
			_check_items()
			If $Errore = "" Then
				_save()
			EndIf
		Case $Msg = $Clear_Button
			$Preorder_ID = ""
			GUICtrlSetData($Code, "")
			GUICtrlSetData($Description, "")
			GUICtrlSetData($Quantity, "")
			GUICtrlSetData($Prize, "")
			GUICtrlSetData($Supplier, "")
			GUICtrlSetData($Add_Button, "Add")
		Case $Msg = $Modify_Button
			If GUICtrlRead(GUICtrlRead($Preorders_Listview)) <> "" Then
				$aPreorders_List_Line = StringSplit(GUICtrlRead(GUICtrlRead($Preorders_Listview)), "|", 1)
				$Preorder_ID = $aPreorders_List_Line[1]
				GUICtrlSetData($Code, $aPreorders_List_Line[2])
				GUICtrlSetData($Description, $aPreorders_List_Line[3])
				GUICtrlSetData($Quantity, $aPreorders_List_Line[4])
				GUICtrlSetData($Prize, $aPreorders_List_Line[5])
				GUICtrlSetData($Supplier, $aPreorders_List_Line[6])
				GUICtrlSetData($Add_Button, "Update")
			EndIf
		Case $Msg = $Delete_Preorders_Button
			If GUICtrlRead(GUICtrlRead($Preorders_Listview)) <> "" Then
				$aPreorders_List_Line = StringSplit(GUICtrlRead(GUICtrlRead($Preorders_Listview)), "|", 1)
				$Preorder_ID = $aPreorders_List_Line[1]
				_delete_preorder()
			EndIf
		Case $Msg = $Gen_Orders_Button
			$Errore = ""
			_check_preorders()
			If $Errore = "" Then
				_create_orders()
			EndIf
		Case $Msg = $Print_Button
			_print()
		Case $Msg = $View_Button
			_view()
		Case $Msg = $Delete_Orders_Button
			If GUICtrlRead(GUICtrlRead($Orders_Listview)) <> "" Then
				$aOrders_List_Line = StringSplit(GUICtrlRead(GUICtrlRead($Orders_Listview)), "|", 1)
				$Order_ID = $aOrders_List_Line[1]
				_delete_order_lines()
				_delete_order()
			EndIf
		Case $Msg = $Close_Button
			ExitLoop
		Case $Msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
WEnd

Func _load_items()
	If FileExists($Items_File) Then
		$Handle_Items_R = FileOpen($Items_File, 0)
		If $Handle_Items_R = -1 Then   ; Check if file opened for reading OK
			MsgBox(0, "Error", "Unable to open items file.")
			Exit
		EndIf
		While 1
			$Rec_Items = FileReadLine($Handle_Items_R)
			If @error = -1 Then ExitLoop
			$Fields_Items = StringSplit($Rec_Items, ";", 1)
			GUICtrlCreateListViewItem($Fields_Items[1] & "|" & $Fields_Items[2] & "|" & $Fields_Items[3] & "|" & $Fields_Items[4] & "|" & $Fields_Items[5],$Items_Listview)
		WEnd
		FileClose($Handle_Items_R)
	EndIf
EndFunc

Func _load_preorders()
	; elimino e ricreo la lista preordini
	GUICtrlDelete($Preorders_Listview)
	$Preorders_Listview = GUICtrlCreateListView("ID   |Code         |Description                                  |Quantity|Price      |Vendor                    ",10,390,555,100,-1,BitOR($LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
	If FileExists($Preorders_File) Then
		$Handle_Preorders_R = FileOpen($Preorders_File, 0)
		If $Handle_Preorders_R = -1 Then   ; Check if file opened for reading OK
			MsgBox(0, "Error", "Unable to open preorders file.")
			Exit
		EndIf
		While 1
			$Rec_Preorders = FileReadLine($Handle_Preorders_R)
			If @error = -1 Then ExitLoop
			$Fields_Preorders = StringSplit($Rec_Preorders, ";", 1)
			GUICtrlCreateListViewItem($Fields_Preorders[1] & "|" & $Fields_Preorders[2] & "|" & $Fields_Preorders[3] & "|" & $Fields_Preorders[4] & "|" & $Fields_Preorders[5] & "|" & $Fields_Preorders[6],$Preorders_Listview)
		WEnd
		FileClose($Handle_Preorders_R)
	EndIf
EndFunc

Func _load_orders()
	If FileExists($Orders_File) Then
		$Handle_Orders_R = FileOpen($Orders_File, 0)
		If $Handle_Orders_R = -1 Then   ; Check if file opened for reading OK
			MsgBox(0, "Error", "Unable to open orders file.")
			Exit
		EndIf
		While 1
			$Rec_Orders = FileReadLine($Handle_Orders_R)
			If @error = -1 Then ExitLoop
			$Fields_Orders = StringSplit($Rec_Orders, ";", 1)
			Select
				Case $Fields_Orders[4] = "1"
					$Status = "Complete"
				Case Else
					$Status = "Open"
			EndSelect
			GUICtrlCreateListViewItem($Fields_Orders[1] & "|" & $Fields_Orders[2] & "|" & $Fields_Orders[3] & "|" & $Status,$Orders_Listview)
		WEnd
		FileClose($Handle_Orders_R)
	EndIf
EndFunc

Func _check_items()
	GUICtrlSetBkColor($Quantity, 0xffffff)   	; bianco
	GUICtrlSetBkColor($Prize, 0xffffff)     	; bianco
	If 	GUICtrlRead($Code) = "" And $Errore = "" Then
		MsgBox(0,"Errore", "Select an item or a preorder line.")
		$Errore = "1"
	EndIf

	If	GUICtrlRead($Quantity) = 0 And $Errore = "" Then
		MsgBox(0,"Error", "Type a valid quantity.")
		GUICtrlSetBkColor($Quantity, 0xffff80)     ; giallo
		GUICtrlSetState($Quantity, $GUI_FOCUS)
		$Errore = "1"
	EndIf
	If	GUICtrlRead($Prize) = 0 And $Errore = "" Then
		MsgBox(0,"Error", "Type a valid price.")
		GUICtrlSetBkColor($Prize, 0xffff80)     ; giallo
		GUICtrlSetState($Prize, $GUI_FOCUS)
		$Errore = "1"
	EndIf
EndFunc

Func _save()
	Local $Rec_Preorders_Count = 0
	Select
		Case $Preorder_ID = "" 	; Scrittura file
			$Handle_Preorders_W = FileOpen($Preorders_File, 1)
			If $Handle_Preorders_W = -1 Then   ; Check if file opened for reading OK
				MsgBox(0, "Error", "Unable to open preorders file.")
				Exit
			EndIf
			$Preorder_ID = _get_id("Preorders", @AppDataCommonDir & "\test")
			$Rec_Preorders = $Preorder_ID & ";" & GUICtrlRead($Code) & ";" & GUICtrlRead($Description) & ";" & GUICtrlRead($Quantity) & ";" & GUICtrlRead($Prize) & ";" & GUICtrlRead($Supplier)
			FileWriteLine($Handle_Preorders_W, $Rec_Preorders)
			FileClose($Handle_Preorders_W)
			GUICtrlCreateListViewItem($Preorder_ID & "|" & GUICtrlRead($Code) & "|" & GUICtrlRead($Description) & "|" & GUICtrlRead($Quantity) & "|" & GUICtrlRead($Prize) & "|" & GUICtrlRead($Supplier),$Preorders_Listview)
		Case Else			; Aggiornamento file
			$Handle_Preorders_W = FileOpen($Preorders_File, 0)
			If $Handle_Preorders_W = -1 Then   ; Check if file opened for reading OK
				MsgBox(0, "Error", "Unable to open preorders file.")
				Exit
			EndIf
			While 1
				$Rec_Preorders = FileReadLine($Handle_Preorders_W)
				$Rec_Preorders_Count += 1
				If @error = -1 Then ExitLoop
				$Fields_Preorders = StringSplit($Rec_Preorders, ";", 1)
				If $Preorder_ID = $Fields_Preorders[1] Then ExitLoop
			WEnd
			$Preorders_Path = $Preorders_File
			$Rec_Preorders = $Preorder_ID & ";" & GUICtrlRead($Code) & ";" & GUICtrlRead($Description) & ";" & GUICtrlRead($Quantity) & ";" & GUICtrlRead($Prize) & ";" & GUICtrlRead($Supplier)
			MsgBox(0, "Debug", $Preorders_Path & @CRLF & $Rec_Preorders_Count & @CRLF & $Rec_Preorders)
			_FileWriteToLine($Preorders_Path, $Rec_Preorders_Count, $Rec_Preorders, 1)
			GUICtrlSetData(GUICtrlRead($Preorders_Listview), $Preorder_ID & "|" & GUICtrlRead($Code) & "|" & GUICtrlRead($Description) & "|" & GUICtrlRead($Quantity) & "|" & GUICtrlRead($Prize) & "|" & GUICtrlRead($Supplier))
	EndSelect
	;Pulizia campi
	$Preorder_ID = ""
	GUICtrlSetData($Code, "")
	GUICtrlSetData($Description, "")
	GUICtrlSetData($Quantity, "")
	GUICtrlSetData($Prize, "")
	GUICtrlSetData($Supplier, "")
	GUICtrlSetData($Add_Button, "Add")
EndFunc

Func _delete_preorder()
	Local $Rec_Preorders_Count = 0
	$Handle_Preorders_W = FileOpen($Preorders_File, 0)
		If $Handle_Preorders_W = -1 Then   ; Check if file opened for reading OK
			MsgBox(0, "Error", "Unable to open preorders file")
			Exit
		EndIf
		While 1
			$Rec_Preorders = FileReadLine($Handle_Preorders_W)
			$Rec_Preorders_Count += 1
			If @error = -1 Then ExitLoop
			$Fields_Preorders = StringSplit($Rec_Preorders, ";", 1)
			If $Preorder_ID = $Fields_Preorders[1] Then ExitLoop
		WEnd
	$Preorders_Path = $Preorders_File
	MsgBox(0, "Debug", $Preorders_Path & @CRLF & $Rec_Preorders_Count)
	_FileWriteToLine($Preorders_Path, $Rec_Preorders_Count, "", 1)
	GUICtrlDelete(GUICtrlRead($Preorders_Listview))
	;Pulizia campi
	$Preorder_ID = ""
	GUICtrlSetData($Code, "")
	GUICtrlSetData($Description, "")
	GUICtrlSetData($Quantity, "")
	GUICtrlSetData($Prize, "")
	GUICtrlSetData($Supplier, "")
	GUICtrlSetData($Add_Button, "Add")
EndFunc

Func _check_preorders()
	If FileExists($Preorders_File) Then
		$Handle_Preorders_R = FileOpen($Preorders_File, 0)
		If $Handle_Preorders_R = -1 Then   ; Check if file opened for reading OK
			MsgBox(0, "Error", "Unable to open preorders file.")
			Exit
		EndIf
		While 1
			$Rec_Preorders = FileReadLine($Handle_Preorders_R) ;leggo un solo record per controllo
			ExitLoop
		WEnd
		FileClose($Handle_Preorders_R)
		If $Rec_Preorders = "" Then
			MsgBox(0,"Error", "Not exist any preorder line.")
			$Errore = "1"
		EndIf
	Else
		MsgBox(0,"Error", "Not exist any preorder line.")
		$Errore = "1"
	EndIf
EndFunc

Func _create_orders()
	Local $Rec_Preorders_Count = 0
	$Handle_Preorders_W = FileOpen($Preorders_File, 0)
	If $Handle_Preorders_W = -1 Then   ; Check if file opened for reading OK
		MsgBox(0, "Error", "Unable to open preorders file.")
		Exit
	EndIf
	While 1
		$Rec_Preorders = FileReadLine($Handle_Preorders_W)
		If @error = -1 Then ExitLoop
		$Fields_Preorders = StringSplit($Rec_Preorders, ";", 1)
		_get_order()
		_create_lines()
		$Preorders_Path = $Preorders_File
		_FileWriteToLine($Preorders_Path, 1, "",1 ) ; riga = 1 perchè cancellando una riga la successiva sale
	WEnd
	_load_preorders()
EndFunc

Func _get_order()
	If FileExists($Orders_File) Then
		$Handle_Orders_R = FileOpen($Orders_File, 0)
		If $Handle_Orders_R = -1 Then   ; Check if file opened for reading OK
			MsgBox(0, "Error", "Unable to open orders file.")
			Exit
		EndIf
		While 1
			$Rec_Orders = FileReadLine($Handle_Orders_R)
			If @error = -1 Then ExitLoop
			$Fields_Orders = StringSplit($Rec_Orders, ";", 1)
			If $Fields_Preorders[6] = $Fields_Orders[3] And $Fields_Orders[4] = "" Then ExitLoop
		WEnd
		FileClose($Handle_Orders_R)
		If $Fields_Preorders[6] = $Fields_Orders[3] And $Fields_Orders[4] = "" Then
			$Order_ID = $Fields_Orders[1]
		Else
			_create_header()
		EndIf
	Else
		_create_header()
	EndIf
EndFunc

Func _create_header()
	$Handle_Orders_W = FileOpen($Orders_File, 1)
	If $Handle_Orders_W = -1 Then   ; Check if file opened for reading OK
		MsgBox(0, "Error", "Unable to open orders file.")
		Exit
	EndIf
	$Order_ID = _get_id("Orders", @AppDataCommonDir & "\test")
	$Rec_Orders = $Order_ID & ";" & _NowDate() & ";" & $Fields_Preorders[6] & ";" & ""
	FileWriteLine($Handle_Orders_W, $Rec_Orders)
	FileClose($Handle_Orders_W)
	GUICtrlCreateListViewItem($Order_ID & "|" & _NowDate() & "|" & $Fields_Preorders[6] & "|" & "Open",$Orders_Listview)
EndFunc

Func _create_lines()
	$Handle_Order_Lines_W = FileOpen($Order_Lines_File, 1)
	If $Handle_Order_Lines_W = -1 Then   ; Check if file opened for reading OK
		MsgBox(0, "Error", "Unable to open order lines file.")
		Exit
	EndIf
	$Line_ID = _get_id("Orderlines", @AppDataCommonDir & "\test")
	$Rec_Order_lines = $Line_ID & ";" & $Order_ID & ";" & $Fields_Preorders[1] & ";" & $Fields_Preorders[2] & ";" & $Fields_Preorders[3] & ";" & $Fields_Preorders[4] & ";" & $Fields_Preorders[5]
	FileWriteLine($Handle_Order_Lines_W, $Rec_Order_lines)
	FileClose($Handle_Order_Lines_W)
EndFunc

Func _print()
MsgBox(0, "info", "function not yet implemented")
EndFunc

Func _view()
; si deve prima verificare che l'ordine sia stato stampato
MsgBox(0, "info", "function not yet implemented")
EndFunc

Func _delete_order()
	Local $Rec_Orders_Count = 0
	$Handle_Orders_W = FileOpen($Orders_File, 0)
		If $Handle_Orders_W = -1 Then   ; Check if file opened for reading OK
			MsgBox(0, "Error", "Unable to open orders file.")
			Exit
		EndIf
		While 1
			$Rec_Orders = FileReadLine($Handle_Orders_W)
			$Rec_Orders_Count += 1
			If @error = -1 Then ExitLoop
			$Fields_Orders = StringSplit($Rec_Orders, ";", 1)
			If $Order_ID = $Fields_Orders[1] Then ExitLoop
		WEnd
	$Orders_Path = $Orders_File
	_FileWriteToLine($Orders_Path, $Rec_Orders_Count, "", 1)
	GUICtrlDelete(GUICtrlRead($Orders_Listview))
	;Pulizia campi
	$Order_ID = ""
EndFunc

Func _delete_order_lines()
	Local $Rec_Order_lines_Count = 0
	$Handle_Order_Lines_W = FileOpen($Order_Lines_File, 0)
		If $Handle_Order_Lines_W = -1 Then   ; Check if file opened for reading OK
			MsgBox(0, "Error", "Unable to open order lines file.")
			Exit
		EndIf
		While 1
			$Rec_Order_lines = FileReadLine($Handle_Order_Lines_W)
			$Rec_Order_lines_Count += 1
			If @error = -1 Then ExitLoop
			$Fields_Order_Lines = StringSplit($Rec_Order_lines, ";", 1)
			If $Order_ID = $Fields_Order_Lines[2] Then
				$Order_Lines_Path = $Order_Lines_File
				_FileWriteToLine($Order_Lines_Path, $Rec_Order_lines_Count, "", 1)
				$Rec_Order_lines_Count -= 1
			EndIf
		WEnd
EndFunc
