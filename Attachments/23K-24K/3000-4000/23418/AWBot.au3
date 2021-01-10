;
;
;
#include <GuiConstantsEx.au3>


Opt('MustDeclareVars', 1)

_Main()

Func _Main()
	 Local $mainmenu, $mainmenuitem1, $mainmenuitem2
	 ;Auflistung der MainMenü Variablen
	 Local $servermenu, $servermenuitem1, $servermenuitem2, $servermenuitem3
	 ;Auflistung der Servermenü Variablen
	 Local $helpmenu, $helpmenuitem1
	 ;Auflistung der Helpmenü Variablen
	 Local $aboutmenu, $aboutmenuitem1
	 ;Auflistung der Aboutmenü Variablen
	 Local $Keulioff, $Speeroff, $Axtioff, $Spaeheroff, $Palaoff, $Teutoneoff, $Rammeoff, $Kataoff, $Stammioff, $Siedleroff
	 ;Auflistung der OFF Truppen
	 Local $attackX, $attackY
	 ;Variablen für Off Koordinateninput
	 Local $Keulidef, $Speerdef, $Axtidef, $Spaeherdef, $Paladef, $Teutonedef, $Rammedef, $Katadef, $Stammidef, $Siedlerdef
	 ;Auflistung der DEF Truppen
 	 Local $defX, $defY
	 ;Variablen für Def Koordinateninput
	 Local $KeuliKata, $SpeerKata, $AxtiKata, $SpaeherKata, $PalaKata, $TeutoneKata, $RammeKata, $KataKata, $StammiKata, $SiedlerKata
	 ;Auflistung der Kata Truppen
	 Local $KataX, $KataY, $Katawellen
	 ;Variablen für Kata Koordinaten
	 
	 Local $msg, $exititem
	 ;Auflistung der allgemeinen Variablen
	 
	 Local $Inputkeulioff, $Inputspeeroff, $InputAxtioff, $InputSpaeheroff, $Inputpalaoff, $Inputteutoneoff, $Inputrammeoff, $Inputkataoff, $Inputstammioff, $Inputsiedleroff 
	 ;Auflistung der Variablen für die off.ini
	 Local $Inputkeulidef, $Inputspeerdef, $InputAxtidef, $InputSpaeherdef, $Inputpaladef, $Inputteutonedef, $Inputrammedef, $Inputkatadef, $Inputstammidef, $Inputsiedlerdef
	 ;Auflistung der Variablen für die def.ini
	 Local $InputkeuliKata, $InputspeerKata, $InputAxtiKata, $InputSpaeherKata, $InputpalaKata, $InputteutoneKata, $InputrammeKata, $InputkataKata, $InputstammiKata, $InputsiedlerKata
	 ;Auflistung der Variablen für die kata.ini
	 
GUICreate("Bot Manager", 400, 400)
; Gui Icon Setzen!!! GUISetIcon()

; Menü
$mainmenu = GUICtrlCreateMenu("Menü")
$mainmenuitem1 = GUICtrlCreateMenuItem("Nicht gesetzt.", $mainmenu)
$mainmenuitem2 = GUICtrlCreateMenuItem("Nicht gesetzt.", $mainmenu)

$servermenu = GuiCtrlCreateMenu("Server")
$servermenuitem1 = GUICtrlCreateMenuItem("www.???.de", $servermenu)
$servermenuitem2 = GUICtrlCreateMenuItem("www.???.at", $servermenu)
$servermenuitem3 = GUICtrlCreateMenuItem("www.???.no", $servermenu)

$helpmenu = GUICtrlCreateMenu("Help")
$helpmenuitem1 = GUICtrlCreateMenuItem("Hilfe", $helpmenu)

$aboutmenu = GuiCtrlCreateMenu("About")
$aboutmenuitem1 = GUICtrlCreateMenuItem("About", $aboutmenu)



;Tab
GuiCtrlCreateTab(10, 0, 380,380)
;Endtab

;Anfang Off Fenster
GuiCtrlCreateTabItem("Angriff")
GuiCtrlCreateGroup("Truppen", 20, 26, 150, 300)
$Keulioff = GuiCtrlCreateCheckbox("Keulenschwinger", 30, 40, 130)
$Speeroff = GuiCtrlCreateCheckbox("Speerkämpfer", 30, 60, 130)
$Axtioff = GuiCtrlCreateCheckbox("Axtkämpfer", 30, 80, 130)
$Spaeheroff = GuiCtrlCreateCheckbox("Späher", 30, 100, 130)
$Palaoff = GuiCtrlCreateCheckbox("Paladin", 30, 120, 130)
$Teutoneoff = GuiCtrlCreateCheckbox("Teutonen Reiter", 30, 140, 130)
$Rammeoff = GuiCtrlCreateCheckbox("Ramme", 30, 160, 130)
$Kataoff = GuiCtrlCreateCheckbox("Katapult", 30, 180, 130)
$Stammioff = GuiCtrlCreateCheckbox("Stammesführer", 30, 200, 130)
$Siedleroff = GuiCtrlCreateCheckbox("Siedler", 30, 220, 130)
GUICtrlCreateGroup("",-99,-99,1,1)  ;close group
GUICtrlCreateLabel("Koordinaten", 180, 30)
GUICtrlCreateLabel("X", 180, 50)
$attackX = GUICtrlCreateInput("", 190, 50, 50)
GUICtrlCreateLabel("Y", 270, 50)
$attackY = GUICtrlCreateInput("", 280, 50, 50)
;Ende Off Fenster


;Anfang Def Fenster
GuiCtrlCreateTabItem("Verteidigung")
GuiCtrlCreateGroup("Truppen", 20, 26, 150, 300)
$Keulidef = GuiCtrlCreateCheckbox("Keulenschwinger", 30, 40, 130)
$Speerdef = GuiCtrlCreateCheckbox("Speerkämpfer", 30, 60, 130)
$Axtidef = GuiCtrlCreateCheckbox("Axtkämpfer", 30, 80, 130)
$Spaeherdef = GuiCtrlCreateCheckbox("Späher", 30, 100, 130)
$Paladef = GuiCtrlCreateCheckbox("Paladin", 30, 120, 130)
$Teutonedef = GuiCtrlCreateCheckbox("Teutonen Reiter", 30, 140, 130)
$Rammedef = GuiCtrlCreateCheckbox("Ramme", 30, 160, 130)
$Katadef = GuiCtrlCreateCheckbox("Katapult", 30, 180, 130)
$Stammidef = GuiCtrlCreateCheckbox("Stammesführer", 30, 200, 130)
$Siedlerdef = GuiCtrlCreateCheckbox("Siedler", 30, 220, 130)
GUICtrlCreateGroup("",-99,-99,1,1)  ;close group
GUICtrlCreateLabel("Koordinaten", 180, 30)
GUICtrlCreateLabel("X", 180, 50)
$defX = GUICtrlCreateInput("", 190, 50, 50)
GUICtrlCreateLabel("Y", 270, 50)
$defY = GUICtrlCreateInput("", 280, 50, 50)
;Ende Def Fenster

;Anfang Kata Fenster
GuiCtrlCreateTabItem("Katas")
GuiCtrlCreateGroup("Truppen", 20, 26, 150, 300)
$KeuliKata = GuiCtrlCreateCheckbox("Keulenschwinger", 30, 40, 130)
$SpeerKata = GuiCtrlCreateCheckbox("Speerkämpfer", 30, 60, 130)
$AxtiKata = GuiCtrlCreateCheckbox("Axtkämpfer", 30, 80, 130)
$SpaeherKata = GuiCtrlCreateCheckbox("Späher", 30, 100, 130)
$PalaKata = GuiCtrlCreateCheckbox("Paladin", 30, 120, 130)
$TeutoneKata = GuiCtrlCreateCheckbox("Teutonen Reiter", 30, 140, 130)
$RammeKata = GuiCtrlCreateCheckbox("Ramme", 30, 160, 130)
$KataKata = GuiCtrlCreateCheckbox("Katapult", 30, 180, 130)
$StammiKata = GuiCtrlCreateCheckbox("Stammesführer", 30, 200, 130)
$SiedlerKata = GuiCtrlCreateCheckbox("Siedler", 30, 220, 130)
GUICtrlCreateGroup("",-99,-99,1,1)  ;close group
GUICtrlCreateLabel("Koordinaten", 180, 30)
GUICtrlCreateLabel("X", 180, 50)
$KataX = GUICtrlCreateInput("", 190, 50, 50)
GUICtrlCreateLabel("Y", 270, 50)
$KataY = GUICtrlCreateInput("", 280, 50, 50)
GUICtrlCreateLabel("Anzahl der Wellen:", 180, 80)
$Katawellen = GUICtrlCreateInput("", 280, 80, 50)
;Ende Kata Fenster


GuiCtrlCreateTabItem("Markt")
GuiCtrlCreateLabel("Tab Inhalt", 12, 30)







GUISetState()


	While 1
		$msg = GUIGetMsg()

		Select
			Case $msg = $GUI_EVENT_CLOSE 
				ExitLoop

			Case $msg = $mainmenuitem1
				Msgbox(0, "Main 1", "Wurde noch nicht gesetzt")
				
			Case $msg = $mainmenuitem2
				Msgbox(0, "Main 1", "Wurde noch nicht gesetzt")
				
				
			
			Case $msg = $helpmenuitem1
				MsgBox(0, "Help Menü", "Hier entsteht ein Help Menü")
				; Run Funktion funktioniert nicht!!! Run("readme.txt")
			
			Case $msg = $aboutmenuitem1
				MsgBox(0, "About", "Version X.X")	
			;Off.ini wird ab hier geschrieben.
			Case $msg = $Keulioff
				$Inputkeulioff = InputBox("Keulenschwinger", "Anzahl der Keulenschwinger?")
				Iniwrite("off.ini", "Truppen", "Keuli", $Inputkeulioff)
			Case $msg = $Speeroff
				$Inputspeeroff = InputBox("Speerkämpfer", "Anzahl der Speerkämpfer?")
				Iniwrite("off.ini", "Truppen", "Speere", $Inputspeeroff)
			Case $msg = $Axtioff
				$InputAxtioff = InputBox("Axtkämpfer", "Anzahl der Axtkämpfer?")
				Iniwrite("off.ini", "Truppen", "Axti", $InputAxtioff)
			Case $msg = $spaeheroff
				$Inputspaeheroff = InputBox("Späher", "Anzahl der Späher?")
				Iniwrite("off.ini", "Truppen", "Spaeher", $Inputspaeheroff)
			Case $msg = $palaoff
				$Inputpalaoff = InputBox("Paladine", "Anzahl der Paladine?")
				Iniwrite("off.ini", "Truppen", "Pala", $Inputpalaoff)
			Case $msg = $teutoneoff
				$Inputteutoneoff = InputBox("Teutonen", "Anzahl der Teutonen?")
				Iniwrite("off.ini", "Truppen", "Teutonen", $Inputteutoneoff)
			Case $msg = $rammeoff
				$Inputrammeoff = InputBox("Rammen", "Anzahl der Rammen?")
				Iniwrite("off.ini", "Truppen", "Rammen", $Inputrammeoff)
			Case $msg = $kataoff
				$Inputkataoff = InputBox("Katapulte", "Anzahl der Katapulte?")
				Iniwrite("off.ini", "Truppen", "Katas", $Inputkataoff)
			Case $msg = $stammioff
				$Inputstammioff = InputBox("Stammesführer", "Anzahl der Stammesführer?")
				Iniwrite("off.ini", "Truppen", "Stammis", $Inputstammioff)
			Case $msg = $siedleroff
				$Inputsiedleroff = InputBox("Siedler", "Anzahl der Siedler?")
				Iniwrite("off.ini", "Truppen", "Siedler", $Inputsiedleroff)
			Case $msg = $attackX
				Iniwrite("off.ini", "Koords", "X", $attackX)
			Case $msg = $attackY
				Iniwrite("off.ini", "Koords", "Y", $attackY)
			;Ende der Off.ini
			
			;Anfang der def.ini
			Case $msg = $Keulidef
				$Inputkeulidef = InputBox("Keulenschwinger", "Anzahl der Keulenschwinger?")
				Iniwrite("def.ini", "Truppen", "Keuli", $Inputkeulidef)
			Case $msg = $Speerdef
				$Inputspeerdef = InputBox("Speerkämpfer", "Anzahl der Speerkämpfer?")
				Iniwrite("def.ini", "Truppen", "Speere", $Inputspeerdef)
			Case $msg = $Axtidef
				$InputAxtidef = InputBox("Axtkämpfer", "Anzahl der Axtkämpfer?")
				Iniwrite("def.ini", "Truppen", "Axti", $InputAxtidef)
			Case $msg = $spaeherdef
				$Inputspaeherdef = InputBox("Späher", "Anzahl der Späher?")
				Iniwrite("def.ini", "Truppen", "Spaeher", $Inputspaeherdef)
			Case $msg = $paladef
				$Inputpaladef = InputBox("Paladine", "Anzahl der Paladine?")
				Iniwrite("def.ini", "Truppen", "Pala", $Inputpaladef)
			Case $msg = $teutonedef
				$Inputteutonedef = InputBox("Teutonen", "Anzahl der Teutonen?")
				Iniwrite("def.ini", "Truppen", "Teutonen", $Inputteutonedef)
			Case $msg = $rammedef
				$Inputrammedef = InputBox("Rammen", "Anzahl der Rammen?")
				Iniwrite("def.ini", "Truppen", "Rammen", $Inputrammedef)
			Case $msg = $katadef
				$Inputkatadef = InputBox("Katapulte", "Anzahl der Katapulte?")
				Iniwrite("def.ini", "Truppen", "Katas", $Inputkatadef)
			Case $msg = $stammidef
				$Inputstammidef = InputBox("Stammesführer", "Anzahl der Stammesführer?")
				Iniwrite("def.ini", "Truppen", "Stammis", $Inputstammidef)
			Case $msg = $siedlerdef
				$Inputsiedlerdef = InputBox("Siedler", "Anzahl der Siedler?")
				Iniwrite("def.ini", "Truppen", "Siedler", $Inputsiedlerdef)
			Case $msg = $defX
				Iniwrite("def.ini", "Koords", "X", $defX)
			Case $msg = $defY
				Iniwrite("def.ini", "Koords", "Y", $defY)
			;Ende der def.ini
			
			
			;Katas Anfang
			Case $msg = $KeuliKata
				$InputkeuliKata = InputBox("Keulenschwinger", "Anzahl der Keulenschwinger?")
				Iniwrite("kata.ini", "Truppen", "Keuli", $InputkeuliKata)
			Case $msg = $SpeerKata
				$InputspeerKata = InputBox("Speerkämpfer", "Anzahl der Speerkämpfer?")
				Iniwrite("kata.ini", "Truppen", "Speere", $InputspeerKata)
			Case $msg = $AxtiKata
				$InputAxtiKata = InputBox("Axtkämpfer", "Anzahl der Axtkämpfer?")
				Iniwrite("kata.ini", "Truppen", "Axti", $InputAxtiKata)
			Case $msg = $spaeherKata
				$InputspaeherKata = InputBox("Späher", "Anzahl der Späher?")
				Iniwrite("kata.ini", "Truppen", "Spaeher", $InputspaeherKata)
			Case $msg = $palaKata
				$InputpalaKata = InputBox("Paladine", "Anzahl der Paladine?")
				Iniwrite("kata.ini", "Truppen", "Pala", $InputpalaKata)
			Case $msg = $teutoneKata
				$InputteutoneKata = InputBox("Teutonen", "Anzahl der Teutonen?")
				Iniwrite("kata.ini", "Truppen", "Teutonen", $InputteutoneKata)
			Case $msg = $rammeKata
				$InputrammeKata = InputBox("Rammen", "Anzahl der Rammen?")
				Iniwrite("kata.ini", "Truppen", "Rammen", $InputrammeKata)
			Case $msg = $kataKata
				$InputkataKata = InputBox("Katapulte", "Anzahl der Katapulte?")
				Iniwrite("kata.ini", "Truppen", "Katas", $InputkataKata)
			Case $msg = $stammiKata
				$InputstammiKata = InputBox("Stammesführer", "Anzahl der Stammesführer?")
				Iniwrite("kata.ini", "Truppen", "Stammis", $InputstammiKata)
			Case $msg = $siedlerKata
				$InputsiedlerKata = InputBox("Siedler", "Anzahl der Siedler?")
				Iniwrite("kata.ini", "Truppen", "Siedler", $InputsiedlerKata)
			Case $msg = $KataX
				Iniwrite("kata.ini", "Koords", "X", $KataX)
			Case $msg = $KataY
				Iniwrite("kata.ini", "Koords", "Y", $KataY)
			Case $msg = $Katawellen
				Iniwrite("kata.ini", "Wellen", "Wellen", $Katawellen)
			;Ende kata.ini
			
			
			;Auflistung der Server
			Case $msg = $servermenuitem1
				Iniwrite("server.ini", "Server", "Welt", "www.???de")
			Case $msg = $servermenuitem2
				Iniwrite("server.ini", "Server", "Welt", "www.???.at")
			Case $msg = $servermenuitem3
				Iniwrite("server.ini", "Server", "Welt", "www.???.no")
			;Ende der Auflistung der Server

		EndSelect
	WEnd

	GUIDelete()

	Exit
EndFunc   ;==>_Main


