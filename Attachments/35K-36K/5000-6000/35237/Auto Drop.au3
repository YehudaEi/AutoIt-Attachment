#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <WinAPI.au3>
#include <NomadMemory.au3> ; esse include servi para que possamos entrar na memoria do Alvo  (WYD)
#Region ### START Koda GUI section ### Form=
Global $Nome = InputBox("Wyd:", "Escreva o nome da janela do Wyd que deseja utilizar") ;Pergunta o nome
$Form1 = GUICreate("Drop Control 0.1 By Welath - "&$nome, 500, 130, 124)
$Button1 = GUICtrlCreateButton("Atualizar", 8, 8, 75, 25, $WS_GROUP)
$Button2 = GUICtrlCreateButton("Ligar", 8, 38, 75, 25, $WS_GROUP)
$Button3 = GUICtrlCreateButton("Desligar", 8, 68, 75, 25, $WS_GROUP)
$Button4 = GUICtrlCreateButton("Cargo", 8, 98, 75, 25, $WS_GROUP)

$Label50 = GUICtrlCreateLabel("Somente restos, âmagos e charity box", 100, 105, 250, 17)
$Label1 = GUICtrlCreateLabel("0", 100, 12, 76, 17)
$Label2 = GUICtrlCreateLabel("0", 130, 12, 76, 17)
$Label3 = GUICtrlCreateLabel("0", 160, 12, 76, 17)
$Label4 = GUICtrlCreateLabel("0", 190, 12, 76, 17)
$Label5 = GUICtrlCreateLabel("0", 220, 12, 76, 17)
$Label6 = GUICtrlCreateLabel("0", 100, 42, 76, 17)
$Label7 = GUICtrlCreateLabel("0", 130, 42, 76, 17)
$Label8 = GUICtrlCreateLabel("0", 160, 42, 76, 17)
$Label9 = GUICtrlCreateLabel("0", 190, 42, 76, 17)
$Label10 = GUICtrlCreateLabel("0", 220, 42, 76, 17)
$Label11 = GUICtrlCreateLabel("0", 100, 72, 76, 17)
$Label12 = GUICtrlCreateLabel("0", 130, 72, 76, 17)
$Label13 = GUICtrlCreateLabel("0", 160, 72, 76, 17)
$Label14 = GUICtrlCreateLabel("0", 190, 72, 76, 17)
$Label15 = GUICtrlCreateLabel("0", 220, 72, 76, 17)
$Label16 = GUICtrlCreateLabel("0", 280, 12, 76, 17)
$Label17 = GUICtrlCreateLabel("0", 310, 12, 76, 17)
$Label18 = GUICtrlCreateLabel("0", 340, 12, 76, 17)
$Label19 = GUICtrlCreateLabel("0", 370, 12, 76, 17)
$Label20 = GUICtrlCreateLabel("0", 400, 12, 76, 17)
$Label21 = GUICtrlCreateLabel("0", 280, 42, 76, 17)
$Label22 = GUICtrlCreateLabel("0", 310, 42, 76, 17)
$Label23 = GUICtrlCreateLabel("0", 340, 42, 76, 17)
$Label24 = GUICtrlCreateLabel("0", 370, 42, 76, 17)
$Label25 = GUICtrlCreateLabel("0", 400, 42, 76, 17)
$Label26 = GUICtrlCreateLabel("0", 280, 72, 76, 17)
$Label27 = GUICtrlCreateLabel("0", 310, 72, 76, 17)
$Label28 = GUICtrlCreateLabel("0", 340, 72, 76, 17)
$Label29 = GUICtrlCreateLabel("0", 370, 72, 76, 17)
$Label30 = GUICtrlCreateLabel("0", 400, 72, 76, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $Vaviavel_Do_PID = WinGetProcess($Nome);Isso irá pega o pid do processo WYD
Global $OPEN = _MemoryOpen($Vaviavel_Do_PID); isso irá abrir a memoria do WYD atravez do PID


;~ Pointer do inventário
$Slot = _MemoryRead(0x01FFACAC,$OPEN) ; ele vai ler a memoria do address 006CD3E8
$Slot = $Slot + Dec("7C8"); ira adicionar o primeiro add no address base
$Slot = Hex($Slot); transforma a variavel $Bau em Hex
$Slot = ("0x"&$Slot) ; adiciona um 0x no bau para que o Hex seja valido
;~ Pointer do bau
$Bau = _MemoryRead(0x00765388,$OPEN) ; ele vai ler a memoria do address 006CD3E8
$Bau = $Bau + Dec(28); ira adicionar o primeiro add no address base
$Bau = Hex($Bau); transforma a variavel $Bau em Hex
$Address = ("0x"&$Bau) ; adiciona um 0x no bau para que o Hex seja valido

$Bau = _MemoryRead($Address,$OPEN) ; ele vai ler a memoria do address 006CD3E8
$Bau = $Bau + Dec(140); ira adicionar o primeiro add no address base
$Bau = Hex($Bau); transforma a variavel $Bau em Hex
$Address = ("0x"&$Bau) ; adiciona um 0x no bau para que o Hex seja valido

$Bau = _MemoryRead($Address,$OPEN) ; ele vai ler a memoria do address 006CD3E8
$Bau = $Bau + Dec("7E8"); ira adicionar o primeiro add no address base
$Bau = Hex($Bau); transforma a variavel $Bau em Hex
$Address = ("0x"&$Bau) ; adiciona um 0x no bau para que o Hex seja valido

$Bau = _MemoryRead($Address,$OPEN) ; ele vai ler a memoria do address 006CD3E8
$Bau = $Bau + Dec("1FC"); importante lembrar que quando o ADD tem so numeros nao precisa estar entre ""
$Bau = Hex($Bau); transforma a variavel $Bau em Hex
$Address = ("0x"&$Bau) ; adiciona um 0x no bau para que o Hex seja valido

$Bau = _MemoryRead($Address,$OPEN) ; ele vai ler a memoria do address 006CD3E8
$Bau = $Bau + Dec(28); importante lembrar que quando o ADD tem so numeros nao precisa estar entre ""
$Bau = Hex($Bau); transforma a variavel $Bau em Hex
$Address_FEITO = ("0x"&$Bau) ; adiciona um 0x no bau para que o Hex seja valido

Global $Slot00 = $Slot
Global $ligado = 0
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1 ; quando clica no botão para abrir ele vai fazer o codigo a baixo
		Verifica();chama a função Bau()
		Case $Button2
		Global $ligado = 1
		Ligar()
		Case $Button3
		Global $ligado = 0
		Case $Button4
		OpenBau()
	EndSwitch
WEnd

Func Verifica()
Global $Slot01 = _MemoryRead($Slot00,$OPEN, 'word') ; ele vai ler a memoria do address
Global $Slot02 = _MemoryRead($Slot00 + Dec(8),$OPEN, 'word') ; ele vai ler a memoria do address
Global $Slot03 = _MemoryRead($Slot00 + Dec(8) * 2,$OPEN, 'word')
Global $Slot04 = _MemoryRead($Slot00 + Dec(8) * 3,$OPEN, 'word')
Global $Slot05 = _MemoryRead($Slot00 + Dec(8) * 4,$OPEN, 'word')
Global $Slot06 = _MemoryRead($Slot00 + Dec(8) * 5,$OPEN, 'word')
Global $Slot07 = _MemoryRead($Slot00 + Dec(8) * 6,$OPEN, 'word')
Global $Slot08 = _MemoryRead($Slot00 + Dec(8) * 7,$OPEN, 'word')
Global $Slot09 = _MemoryRead($Slot00 + Dec(8) * 8,$OPEN, 'word')
Global $Slot10 = _MemoryRead($Slot00 + Dec(8) * 9,$OPEN, 'word')
Global $Slot11 = _MemoryRead($Slot00 + Dec(8) * 10,$OPEN, 'word')
Global $Slot12 = _MemoryRead($Slot00 + Dec(8) * 11,$OPEN, 'word')
Global $Slot13 = _MemoryRead($Slot00 + Dec(8) * 12,$OPEN, 'word')
Global $Slot14 = _MemoryRead($Slot00 + Dec(8) * 13,$OPEN, 'word')
Global $Slot15 = _MemoryRead($Slot00 + Dec(8) * 14,$OPEN, 'word')
Global $Slot16 = _MemoryRead($Slot00 + Dec(8) * 15,$OPEN, 'word')
Global $Slot17 = _MemoryRead($Slot00 + Dec(8) * 16,$OPEN, 'word')
Global $Slot18 = _MemoryRead($Slot00 + Dec(8) * 17,$OPEN, 'word')
Global $Slot19 = _MemoryRead($Slot00 + Dec(8) * 18,$OPEN, 'word')
Global $Slot20 = _MemoryRead($Slot00 + Dec(8) * 19,$OPEN, 'word')
Global $Slot21 = _MemoryRead($Slot00 + Dec(8) * 20,$OPEN, 'word')
Global $Slot22 = _MemoryRead($Slot00 + Dec(8) * 21,$OPEN, 'word')
Global $Slot23 = _MemoryRead($Slot00 + Dec(8) * 22,$OPEN, 'word')
Global $Slot24 = _MemoryRead($Slot00 + Dec(8) * 23,$OPEN, 'word')
Global $Slot25 = _MemoryRead($Slot00 + Dec(8) * 24,$OPEN, 'word')
Global $Slot26 = _MemoryRead($Slot00 + Dec(8) * 25,$OPEN, 'word')
Global $Slot27 = _MemoryRead($Slot00 + Dec(8) * 26,$OPEN, 'word')
Global $Slot28 = _MemoryRead($Slot00 + Dec(8) * 27,$OPEN, 'word')
Global $Slot29 = _MemoryRead($Slot00 + Dec(8) * 28,$OPEN, 'word')
Global $Slot30 = _MemoryRead($Slot00 + Dec(8) * 29,$OPEN, 'word')
GUICtrlSetData($Label1,$Slot01) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label2,$Slot02) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label3,$Slot03) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label4,$Slot04) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label5,$Slot05) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label6,$Slot06) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label7,$Slot07) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label8,$Slot08) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label9,$Slot09) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label10,$Slot10) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label11,$Slot11) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label12,$Slot12) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label13,$Slot13) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label14,$Slot14) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label15,$Slot15) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label16,$Slot16) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label17,$Slot17) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label18,$Slot18) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label19,$Slot19) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label20,$Slot20) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label21,$Slot21) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label22,$Slot22) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label23,$Slot23) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label24,$Slot24) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label25,$Slot25) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label26,$Slot26) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label27,$Slot27) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label28,$Slot28) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label29,$Slot29) ; Edita o Label para Bau ABerto
GUICtrlSetData($Label30,$Slot30) ; Edita o Label para Bau ABerto
EndFunc

Func OpenBau() ; Função que faz abrir o Bau
ControlSend($nome,"","","{F1}") ; Enviar F1 para o WYD
_MemoryWrite($Address_FEITO,$OPEN,1);Escreve na memorya do WYD
;~ GUICtrlSetData($Label1,"Bau Aberto") ; Edita o Label para Bau ABerto
EndFunc; Fim da função

Func Ligar()
	if $ligado = 1 Then
		Global $Slot01 = _MemoryRead($Slot00,$OPEN, 'word') ; ele vai ler a memoria do address
		Global $Slot02 = _MemoryRead($Slot00 + Dec(8),$OPEN, 'word') ; ele vai ler a memoria do address
		Global $Slot03 = _MemoryRead($Slot00 + Dec(8) * 2,$OPEN, 'word')
		Global $Slot04 = _MemoryRead($Slot00 + Dec(8) * 3,$OPEN, 'word')
		Global $Slot05 = _MemoryRead($Slot00 + Dec(8) * 4,$OPEN, 'word')
		Global $Slot06 = _MemoryRead($Slot00 + Dec(8) * 5,$OPEN, 'word')
		Global $Slot07 = _MemoryRead($Slot00 + Dec(8) * 6,$OPEN, 'word')
		Global $Slot08 = _MemoryRead($Slot00 + Dec(8) * 7,$OPEN, 'word')
		Global $Slot09 = _MemoryRead($Slot00 + Dec(8) * 8,$OPEN, 'word')
		Global $Slot10 = _MemoryRead($Slot00 + Dec(8) * 9,$OPEN, 'word')
		Global $Slot11 = _MemoryRead($Slot00 + Dec(8) * 10,$OPEN, 'word')
		Global $Slot12 = _MemoryRead($Slot00 + Dec(8) * 11,$OPEN, 'word')
		Global $Slot13 = _MemoryRead($Slot00 + Dec(8) * 12,$OPEN, 'word')
		Global $Slot14 = _MemoryRead($Slot00 + Dec(8) * 13,$OPEN, 'word')
		Global $Slot15 = _MemoryRead($Slot00 + Dec(8) * 14,$OPEN, 'word')
		Global $Slot16 = _MemoryRead($Slot00 + Dec(8) * 15,$OPEN, 'word')
		Global $Slot17 = _MemoryRead($Slot00 + Dec(8) * 16,$OPEN, 'word')
		Global $Slot18 = _MemoryRead($Slot00 + Dec(8) * 17,$OPEN, 'word')
		Global $Slot19 = _MemoryRead($Slot00 + Dec(8) * 18,$OPEN, 'word')
		Global $Slot20 = _MemoryRead($Slot00 + Dec(8) * 19,$OPEN, 'word')
		Global $Slot21 = _MemoryRead($Slot00 + Dec(8) * 20,$OPEN, 'word')
		Global $Slot22 = _MemoryRead($Slot00 + Dec(8) * 21,$OPEN, 'word')
		Global $Slot23 = _MemoryRead($Slot00 + Dec(8) * 22,$OPEN, 'word')
		Global $Slot24 = _MemoryRead($Slot00 + Dec(8) * 23,$OPEN, 'word')
		Global $Slot25 = _MemoryRead($Slot00 + Dec(8) * 24,$OPEN, 'word')
		Global $Slot26 = _MemoryRead($Slot00 + Dec(8) * 25,$OPEN, 'word')
		Global $Slot27 = _MemoryRead($Slot00 + Dec(8) * 26,$OPEN, 'word')
		Global $Slot28 = _MemoryRead($Slot00 + Dec(8) * 27,$OPEN, 'word')
		Global $Slot29 = _MemoryRead($Slot00 + Dec(8) * 28,$OPEN, 'word')
		Global $Slot30 = _MemoryRead($Slot00 + Dec(8) * 29,$OPEN, 'word')
		GUICtrlSetData($Label1,$Slot01) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label2,$Slot02) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label3,$Slot03) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label4,$Slot04) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label5,$Slot05) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label6,$Slot06) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label7,$Slot07) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label8,$Slot08) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label9,$Slot09) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label10,$Slot10) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label11,$Slot11) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label12,$Slot12) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label13,$Slot13) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label14,$Slot14) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label15,$Slot15) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label16,$Slot16) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label17,$Slot17) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label18,$Slot18) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label19,$Slot19) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label20,$Slot20) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label21,$Slot21) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label22,$Slot22) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label23,$Slot23) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label24,$Slot24) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label25,$Slot25) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label26,$Slot26) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label27,$Slot27) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label28,$Slot28) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label29,$Slot29) ; Edita o Label para Bau ABerto
		GUICtrlSetData($Label30,$Slot30) ; Edita o Label para Bau ABerto
;~ 		Slot 01 - 439,220 
		If $Slot01 = 419 then ;~Resto de Ori
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 01")
		Elseif $Slot01 = 420 then ;- Resto de Lac
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot01 = 2392 then ;- Amago de Lobo
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot01 = 2391 then ;- Amago de Javali
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot01 <> 0 AND $Slot01 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
;~ 			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ Slot 02 - 475,220
		If $Slot02 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 02")
		Elseif $Slot02 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot02 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot02 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot02 <> 0 AND $Slot02 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 03 - 505,220
		If $Slot03 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 03")
		Elseif $Slot03 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot03 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot03 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot03 <> 0 AND $Slot03 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 04 - 538,220
		If $Slot04 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 04")
		Elseif $Slot04 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot04 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot04 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot04 <> 0 AND $Slot04 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 05 - 571,220
		If $Slot05 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 05")
		Elseif $Slot05 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot05 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot05 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot05 <> 0 AND $Slot05 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 06 - 439,255 
		If $Slot06 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 06")
		Elseif $Slot06 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot06 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot06 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot06 <> 0 AND $Slot06 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 07 - 475,255
		If $Slot07 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 07")
		Elseif $Slot07 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot07 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot07 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot07 <> 0 AND $Slot07 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 08 - 505,255
		If $Slot08 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 08")
		Elseif $Slot08 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot08 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot08 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot08 <> 0 AND $Slot08 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 09 - 538,255
		If $Slot09 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 09")
		Elseif $Slot09 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot09 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot09 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot09 <> 0 AND $Slot09 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 10 - 571,255
		If $Slot10 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 10")
		Elseif $Slot10 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot10 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot10 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot10 <> 0 AND $Slot10 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 11 - 439,288 
		If $Slot11 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 11")
		Elseif $Slot11 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot11 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot11 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot11 <> 0 AND $Slot11 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,288)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 12 - 475,288
		If $Slot12 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 12")
		Elseif $Slot12 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot12 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot12 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot12 <> 0 AND $Slot12 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,288)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 13 - 505,288
		If $Slot13 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 13")
		Elseif $Slot13 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot13 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot13 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot13 <> 0 AND $Slot13 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,288)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 14 - 538,288
		If $Slot14 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 14")
		Elseif $Slot14 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot14 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot14 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot14 <> 0 AND $Slot14 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,288)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 15 - 571,288
		If $Slot15 = 419 then 
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 15")
		Elseif $Slot15 = 420 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot15 = 2392 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot15 = 2391 then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,288)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot15 <> 0 AND $Slot15 <> 480 Then
			ControlSend($nome,"","","{F1}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,288)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 16 - 439,220 
		If $Slot16 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 16")
		Elseif $Slot16 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot16 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot16 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot16 <> 0 AND $Slot16 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 17 - 475,220
		If $Slot17 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 17")
		Elseif $Slot17 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot17 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot17 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot17 <> 0 AND $Slot17 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 18 - 505,220
		If $Slot18 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 18")
		Elseif $Slot18 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot18 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot18 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot18 <> 0 AND $Slot18 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 19 - 538,220
		If $Slot19 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 19")
		Elseif $Slot19 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot19 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot19 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot19 <> 0 AND $Slot19 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 20 - 571,220
		If $Slot20 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 20")
		Elseif $Slot20 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot20 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot20 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot20 <> 0 AND $Slot20 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,220)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 21 - 439,255 
		If $Slot21 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 21")
		Elseif $Slot21 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot21 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot21 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot21 <> 0 AND $Slot21 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,439,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 22 - 475,255
		If $Slot22 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 22")
		Elseif $Slot22 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot22 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot22 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot22 <> 0 AND $Slot22 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 23 - 505,255
		If $Slot23 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 23")
		Elseif $Slot23 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot23 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot23 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot23 <> 0 AND $Slot23 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 24 - 538,255
		If $Slot24 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 24")
		Elseif $Slot24 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot24 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot24 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot24 <> 0 AND $Slot24 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,538,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
;~ 		Slot 25 - 571,255
		If $Slot25 = 419 then 
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,535,285)
			GUICtrlSetData($Label50,"Resto de ori movido do Slot 25")
		Elseif $Slot25 = 420 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,570,285)
		Elseif $Slot25 = 2392 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,505,285)
		Elseif $Slot25 = 2391 then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,475,285)
		Elseif $Slot25 <> 0 AND $Slot25 <> 480 Then
			ControlSend($nome,"","","{F2}")
			Sleep(2000)
			ControlClick($nome,"","","",1,571,255)
			Sleep(2000)
			ControlClick($nome,"","","",1,571,322)
			Sleep(2000)
			ControlSend($nome,"","","{ENTER}")
		EndIf
		
		Ligar()
	EndIf
EndFunc