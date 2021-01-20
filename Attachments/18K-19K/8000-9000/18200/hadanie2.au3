; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         MrBestliving <mrbestliving@gmail.com>
;
; Script Function:
;	Taka haluzovinka :)
;
; ----------------------------------------------------------------------------

; Script Start

Opt("TrayIconDebug", 1)
Opt("OnExitFunc", "koniec")	;--- pocas Exit sa vykona funkcia koniec opisana na konci skriptu

#include <GuiConstants.au3>	;--- klasicky include s konstantami
MsgBox(0, "Hadanie cisla", "Tento program je hovadina a co viac dodat :D...")	;--- uvody MessageBox
Dim $m, $v, $s, $stav, $case	;--- Deklaracie: $m - najnizsie cislo, $v - najvyssie cislo, $s - spravne cislo, $stav - pocet pokusov, $case - vyuzije sa pri GUIGetMsg
$stav = 1	;--- pre lepsie pocitanie deklarujeme pre $stav = 1

GUICreate("MyGUI", 388, 316, (@DesktopWidth - 388) / 2, (@DesktopHeight - 316) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)	;--- vytvorenie GUI v strede obrazovky

$text = GUICtrlCreateEdit("Vytaj v mojom programiku. Cielom hry je uhadnut cislo, ktore" & @CRLF & "pocitac nahodne vygeneruje. Vyber si obtiaznost alebo napis" & @CRLF & "najmensie mozne vygenerovatelne cislo:" & @CRLF & "a: 0-15" & @CRLF & "b: 0-30" & @CRLF & "c: 0-50" & @CRLF & "Napis a, b alebo c alebo najmensie mozne vygenerovatelne cislo", 30, 10, 330, 230, $ES_READONLY) ;--- pole s textom
$input = GUICtrlCreateInput("", 100, 250, 60, 20)	;--- pole kde zadava hrac
$odpoved = GUICtrlCreateLabel("Odpoved", 40, 250, 50, 20)	;--- textove pole s texotm "Odpoved"
$ok = GUICtrlCreateButton("OK", 200, 250, 90, 30, $BS_DEFPUSHBUTTON)	;--- tlacitko OK
$odznova = GUICtrlCreateButton("Odznova", 200, 250, 90, 30, $GUI_HIDE)	;--- tlacitko Odznova pre neskorsie pouzitie

GUISetState()	;--- zviditelnienie okna

While 1	;--- opakovanie Loopu do pouzitia prikazu Exit alebo ExitLoop alebo nastatia chyby
	$msg = GUIGetMsg()	;--- $msg oznacuje eventy ktore sa staly
	Select
		Case $msg = $GUI_EVENT_CLOSE	;--- po kliknuti na X vykona akciu Exit
			Exit
		Case $msg = $ok	;--- ak sa klikne OK, vtedy...
			If $stav = 1 Then	;--- ak $stav = 1 tak...
				Select
					Case GUICtrlRead($input) = "a"	;--- ak napises a potom nastavi rozsah na 0-15
						$m = 0
						$v = 15
					Case GUICtrlRead($input) = "b"	;--- podobne ako vyssie
						$m = 0
						$v = 30
					Case GUICtrlRead($input) = "c"	;--- podobne ako vyssie
						$m = 0
						$v = 50
					Case Else	;--- ak ani jedna z moznosti vyssie nieje spravna, vykona sa toto:
						$m = Int(GUICtrlRead($input))	;--- zisti, ake cislo si napisal do $input, ak ziadne vrati 0
						GUICtrlSetStyle($input, $ES_NUMBER)	;--- od teraz sa daju pisat do $input iba cisla
						GUICtrlSetData($text, "Zvolil si najnizsie cislo: " & $m & ". Teraz zvol najvyssie cislo:")	;--- zmeni text v $text
						While $case <> $ok	;--- loop sa bude opakovat do kedy nestisnes $ok alebo X
							$case = GUIGetMsg()	;--- $case obsahuje odpoved z okna
							If $case = $GUI_EVENT_CLOSE Then	;--- tato podmienka zabepeci zatvorenie okna po kliknuti na X
								Exit
							EndIf
						WEnd
						$v = Int(GUICtrlRead($input))	;--- po opusteni loopu zisti ake je cislo napisane v $input a deklaruje ho za $v
						If $m = $v Or $m > $v Then	;--- tato podmienka zaruci ze ak $m je vacsie ako $v alebo rovne ako $v vtedy nastane toto...
							GUICtrlSetData($text, "Zadal si dajaku hovadinu...")	;--- zmeni text v $text
							GUICtrlSetState($ok, $GUI_HIDE)	;--- skrije tlacitko OK
							GUICtrlSetState($odznova, $GUI_SHOW)	;--- zviditelny tlacitko Odznova
							$tav = 0	;--- nastavi $stav = 0
							While 1	;--- bude sa opakovat loop pokial nenastane situacia...
								$msg = GUIGetMsg()	;--- $msg bude obsahovat event
								Select
									Case $msg = $GUI_EVENT_CLOSE	;--- ak sa zavrie okno, tak potom Exit
										Exit
									Case $msg = $odznova	;--- ak sa klikni $odznova tak potom_
										$stav = 99			;--- nastavi sa $stav na 99_
										Exit				;--- a potom Exit
								EndSelect
							WEnd
						EndIf
				EndSelect
				$stav = 2	;--- nastavi $stav na 2
				$s = Random($m, $v, 1)	;--- vygeneruje cele nahodne cislo v rozpeti $m az $v
				HotKeySet("!+h", "skratka")	;--- nastavi klavesovu skratku Alt + Shift + h ktora vykona funkciu skratka opisanu na konci skriptu
				GUICtrlSetData($text, "Zvolil si rozsah: " & $m & "-" & $v & ". Mas 5 pokusov." & @CRLF & "Teraz mozes tipovat...")	;--- zmeni text v $text
			EndIf
			
			GUICtrlSetData($input, "")	;--- vymaze obsah pola $input
			GUICtrlSetStyle($input, $ES_NUMBER)	;--- od teraz sa daju pisat do $input iba cisla
			
			While 1	;--- vytvori sa loop cakajuci na userovu akciu
				$msg = GUIGetMsg()
				Select
					Case $msg = $ok					;--- po kliknuti $ok_
						ExitLoop					;--- opusti sa aktualny loop
					Case $msg = $GUI_EVENT_CLOSE	;--- po kliknuti X_
						Exit						;--- odide sa
				EndSelect
			WEnd
			
			If $stav = 2 Then	;--- ak $stav = 2, vtedy...
				Select
					Case Int(GUICtrlRead($input)) < $s	;--- zisti sa ake je napisane cislo v $input a ak je mensie ako $s vtedy...
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Myslene cislo je vyssie.")	;--- zmeni sa text a_
						$stav = 3																							;--- nastavi sa $stav = 3 a pokracuje sa dalej za EndSelect
					Case Int(GUICtrlRead($input)) > $s ;--- zisti sa ake je napisane cislo v $input a ak je vacsie ako $s vtedy...
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Myslene cislo je nizsie.")	;--- zmeni sa text a_
						$stav = 3																							;--- nastavi sa $stav = 3 a pokracuje sa dalej za EndSelect
					Case Int(GUICtrlRead($input)) = $s	;--- zisti sa ake je napisane cislo v $input a ak je rovnake ako $s vtedy...
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Toto cislo je spravne. Vyhral si.")	;--- zmeni sa text,_
						GUICtrlSetState($ok, $GUI_HIDE)																				;--- skryje sa tlacitko $ok,_
						GUICtrlSetState($odznova, $GUI_SHOW)																		;--- zviditelni sa tlacitko $odznova a_
						$stav = 99																									;--- nastavi sa $stav = 99 a pokracuje sa dalej za EndSelect
				EndSelect
			EndIf
			
			While 1	;--- vytvori loop cakajuci na userovu akciu
				$msg = GUIGetMsg()
				Select
					Case $msg = $ok	;--- ak user klikni $ok, vtedy_
						ExitLoop	;--- sa opusti loop
					Case $msg = $GUI_EVENT_CLOSE	;--- ak user klikne X, vtedy_
						Exit						;--- sa vykona Exit
					Case $msg = $odznova	;--- ak user klikne $odznova, vtedy_
						$stav = 99			;--- sa nastavi $stav = 99 a_
						Exit				;--- vykona sa Exit
				EndSelect
			WEnd
			
			If $stav = 3 Then
				Select
					Case Int(GUICtrlRead($input)) < $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Myslene cislo je vyssie.")
						$stav = 4
					Case Int(GUICtrlRead($input)) > $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Myslene cislo je nizsie.")
						$stav = 4
					Case Int(GUICtrlRead($input)) = $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Toto cislo je spravne. Vyhral si.")
						GUICtrlSetState($ok, $GUI_HIDE)
						GUICtrlSetState($odznova, $GUI_SHOW)
						$stav = 99
				EndSelect
			EndIf
			
			While 1
				$msg = GUIGetMsg()
				Select
					Case $msg = $ok
						ExitLoop
					Case $msg = $GUI_EVENT_CLOSE
						Exit
					Case $msg = $odznova
						$stav = 99
						Exit
				EndSelect
			WEnd
			
			If $stav = 4 Then
				Select
					Case Int(GUICtrlRead($input)) < $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Myslene cislo je vyssie.")
						$stav = 5
					Case Int(GUICtrlRead($input)) > $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Myslene cislo je nizsie.")
						$stav = 5
					Case Int(GUICtrlRead($input)) = $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Toto cislo je spravne. Vyhral si.")
						GUICtrlSetState($ok, $GUI_HIDE)
						GUICtrlSetState($odznova, $GUI_SHOW)
						$stav = 99
				EndSelect
			EndIf
			
			While 1
				$msg = GUIGetMsg()
				Select
					Case $msg = $ok
						ExitLoop
					Case $msg = $GUI_EVENT_CLOSE
						Exit
					Case $msg = $odznova
						$stav = 99
						Exit
				EndSelect
			WEnd
			
			If $stav = 5 Then
				Select
					Case Int(GUICtrlRead($input)) < $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Myslene cislo je vyssie.")
						$stav = 6
					Case Int(GUICtrlRead($input)) > $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Myslene cislo je nizsie.")
						$stav = 6
					Case Int(GUICtrlRead($input)) = $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Toto cislo je spravne. Vyhral si.")
						GUICtrlSetState($ok, $GUI_HIDE)
						GUICtrlSetState($odznova, $GUI_SHOW)
						$stav = 99
				EndSelect
			EndIf
			
			While 1
				$msg = GUIGetMsg()
				Select
					Case $msg = $ok
						ExitLoop
					Case $msg = $GUI_EVENT_CLOSE
						Exit
					Case $msg = $odznova
						$stav = 99
						Exit
				EndSelect
			WEnd
			
			If $stav = 6 Then
				Select
					Case Int(GUICtrlRead($input)) <> $s										;--- ak je vlozene cislo <> $s, vtedy_
						GUICtrlSetData($text, "Prehral si. Spravne cislo je:" & $s & ".")	;--- zmeni sa text, _
						GUICtrlSetState($ok, $GUI_HIDE)										;--- skrije sa tlacitko $ok,_
						GUICtrlSetState($odznova, $GUI_SHOW)								;--- zobrazi sa tlacitko $odznova a _
						$stav = 99															;--- nastavi sa $stav = 99
					Case Int(GUICtrlRead($input)) = $s
						GUICtrlSetData($text, "Tipol si cislo:" & Int(GUICtrlRead($input)) & ". Toto cislo je spravne. Vyhral si.")
						GUICtrlSetState($ok, $GUI_HIDE)
						GUICtrlSetState($odznova, $GUI_SHOW)
						$stav = 99
				EndSelect
			EndIf
	EndSelect
WEnd

Func skratka()
	GUICtrlSetData($input, $s)	;--- zmeni obash pola $input na $s
EndFunc


Func koniec()	;--- funckia, ktora sa vykona pri Exit
	MsgBox(262208, "Hadanie cisla", "Created by: MrBestliving@gmail.com" & @CRLF & "ICQ#: 336-097-996")	;--- konciaci MsgBox
	If $stav = 99 Then			;--- ak $stav = 99_
		Run(@ScriptFullPath)	;--- spusti sa skript este raz
	EndIf
EndFunc