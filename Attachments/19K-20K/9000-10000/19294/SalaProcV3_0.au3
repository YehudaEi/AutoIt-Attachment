#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=C:\Projeto\PIC\PIC2.ico
#AutoIt3Wrapper_outfile=SalaProc_v3_0.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Allow_Decompile=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>

Global $conta=0, $temperatura="", $x=16, $y=1, $Porta_Bit
Global $oMyError, $comRS232, $bufRS232=0
Global $watchDogAtual="nenhum", $watchDogPC="", $watchDogCmdo="", $watchDogTempo="", $watchDogTipo="", $Vref

; **** inicializa função de porta serial - Set a COM Error handler -- only one can be active at a time (see helpfile)

;====> musdar p/ NetComm, q nao exige o VB

$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc") 
$comRS232 = ObjCreate ("NETCommOCX.NETComm")
	With $comRS232 					; seta RS232 e envia comando + parametro
        .CommPort = 1
        .PortOpen = True
        .Settings = "9600,N,8,1"
        .InBufferCount = 0
    EndWith

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=C:\Projeto\PIC\SalaProc2\Pascal-Tel2\v2_2\SalaProc3_0.kxf
Global $TL1 = GUICreate("SalaProc v3.0", 289, 275, 193, 125)
Global $Group1 = GUICtrlCreateGroup("PCs & Internet", 8, 3, 105, 207)
Global $T1_Proc1 = GUICtrlCreateRadio("PC 1", 16, 27, 89, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
Global $T1_Proc2 = GUICtrlCreateRadio("PC 2", 16, 43, 89, 17)
Global $T1_Proc3 = GUICtrlCreateRadio("PC 3", 16, 59, 89, 17)
Global $T1_Proc4 = GUICtrlCreateRadio("PC 4", 16, 75, 89, 17)
Global $T1_Proc5 = GUICtrlCreateRadio("PC 5", 16, 91, 89, 17)
Global $T1_Internet = GUICtrlCreateRadio("PC 6 / Internet", 16, 107, 89, 17)
Global $T1_ligProc = GUICtrlCreateButton("liga", 16, 131, 43, 17, 0)
GUICtrlSetTip(-1, "LIGA o PC, atuando sobre seu botão liga/desliga " &@CRLF& "presssiona-o por 3 segundos")
Global $T1_desligProc = GUICtrlCreateButton("desliga", 64, 131, 43, 17, 0)
GUICtrlSetTip(-1, "DESLIGA o PC, atuando sobre seu botão liga/desliga " &@CRLF& "presssiona-o por 10 segundos")
Global $T1_resetProc = GUICtrlCreateButton("reset", 16, 155, 43, 17, 0)
GUICtrlSetTip(-1, "DESLIGA e LIGA o PC, atuando sobre seu botão liga/desliga " &@CRLF& "presssiona-o por 10 segs.,espera, pressiona-o por 3 segs.")
Global $T1_Rebut = GUICtrlCreateButton("reBoot", 64, 155, 43, 17, 0)
GUICtrlSetTip(-1, "REBUTA o PC, atuando sobre seu botão RESET" &@CRLF& "presssiona-o por 1 segundo")
Global $T1_watchDog = GUICtrlCreateButton("watchDog", 12, 180, 60, 17, 0)
GUICtrlSetTip(-1, "parametriza/ativa/desativa WatchDog na CPU definida no .ini")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $T1_ajusTemp = GUICtrlCreateButton("ajusta Temperatura", 8, 217, 97, 22, 0)
GUICtrlSetTip(-1, "permite que você meça a voltagem de referência na placa"&@crlf&"e a informe aqui para temperaturas mais precisas."&@crlf&"salva no .ini")
Global $T1_MostPort = GUICtrlCreateButton("mostra Porta", 8, 245, 97, 21, 0)
GUICtrlSetTip(-1, "passa a mostrar no LED o valor instantâneo da porta/bit desejado "&@crlf&"dê a letra da porta+bit (ex: A3)")
Global $Group2 = GUICtrlCreateGroup("Ar Refrigerado", 136, 5, 121, 46)
Global $T1_LigAr = GUICtrlCreateButton("liga", 144, 25, 41, 21, 0)
Global $T1_deslAr = GUICtrlCreateButton("desliga", 200, 25, 41, 21, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Group3 = GUICtrlCreateGroup("MODEM", 136, 50, 121, 71)
Global $T1_LigModem = GUICtrlCreateButton("liga", 144, 70, 41, 21, 0)
Global $T1_desligModem = GUICtrlCreateButton("desliga", 200, 70, 41, 21, 0)
Global $T1_resetModem = GUICtrlCreateButton("reset", 168, 95, 49, 21, 0)
GUICtrlSetTip(-1, "deliga o modem, dá 1 tempo e o religa")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $T1_Temp = GUICtrlCreateLabel("---º", 113, 125, 168, 145)
GUICtrlSetFont(-1, 110, 800, 0, "Arial Narrow")
GUICtrlSetColor(-1, 0x00FF00)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		$comRS232.PortOpen = False
		Exit
	Case $msg = $T1_ligProc
		If GUICtrlRead($T1_Proc1) = $GUI_CHECKED Then $param= "1"
		If GUICtrlRead($T1_Proc2) = $GUI_CHECKED Then $param= "2"
		If GUICtrlRead($T1_Proc3) = $GUI_CHECKED Then $param= "3"
		If GUICtrlRead($T1_Proc4) = $GUI_CHECKED Then $param= "4"
		If GUICtrlRead($T1_Proc5) = $GUI_CHECKED Then $param= "5"
;		If GUICtrlRead($T1_Proc6) = $GUI_CHECKED Then $param= "6"
		If GUICtrlRead($T1_Internet) = $GUI_CHECKED Then $param= "I"
		envia_cmd ("#L",$param)
		SplashTextOn("Aguarde", @CR&@CR&"Aguarde 5 segundos!" &@cr& "LIGANDO PC" & $param,270, 300, 192, 125,1,"",16)
		Sleep(5000) ; aguarda PIC estar pronto para receber novo comando
		SplashOff()
	Case $msg = $T1_desligProc
		If GUICtrlRead($T1_Proc1) = $GUI_CHECKED Then $param= "1"
		If GUICtrlRead($T1_Proc2) = $GUI_CHECKED Then $param= "2"
		If GUICtrlRead($T1_Proc3) = $GUI_CHECKED Then $param= "3"
		If GUICtrlRead($T1_Proc4) = $GUI_CHECKED Then $param= "4"
		If GUICtrlRead($T1_Proc5) = $GUI_CHECKED Then $param= "5"
;		If GUICtrlRead($T1_Proc6) = $GUI_CHECKED Then $param= "6"
		If GUICtrlRead($T1_Internet) = $GUI_CHECKED Then $param= "I"	
		$stat= MsgBox(40100,"DESLIGAR", "quer mesmo DESLIGAR o PC " & $param)
		If $stat <> 7 then 
			envia_cmd ("#D",$param)
			SplashTextOn("Aguarde", @CR&@CR&"Aguarde 15 segundos!" &@cr& "DESLIGANDO PC" & $param,270, 300, 192, 125,1,"",16)
			Sleep(15000) ; aguarda PIC estar pronto para receber novo comando
			SplashOff()
		EndIf
	Case $msg = $T1_resetProc
		If GUICtrlRead($T1_Proc1) = $GUI_CHECKED Then $param= "1"
		If GUICtrlRead($T1_Proc2) = $GUI_CHECKED Then $param= "2"
		If GUICtrlRead($T1_Proc3) = $GUI_CHECKED Then $param= "3"
		If GUICtrlRead($T1_Proc4) = $GUI_CHECKED Then $param= "4"
		If GUICtrlRead($T1_Proc5) = $GUI_CHECKED Then $param= "5"
;		If GUICtrlRead($T1_Proc6) = $GUI_CHECKED Then $param= "6"
		If GUICtrlRead($T1_Internet) = $GUI_CHECKED Then $param= "I"	
		$stat= MsgBox(40100,"RESET", "quer mesmo RESETAR (Desligar/Ligar) o PC " & $param )
		If $stat <> 7 then 			
			envia_cmd ("#R",$param)
			SplashTextOn("Aguarde", @CR&@CR&"Aguarde 25 segundos!" &@cr& "RESETANDO o PC" & $param &@cr& "(Desligando/Religando)",270, 300, 192, 125,1,"",16)
			Sleep(25000) ; aguarda PIC estar pronto para receber novo comando
			SplashOff()
		EndIf
	Case $msg = $T1_Rebut
		If GUICtrlRead($T1_Proc1) = $GUI_CHECKED Then $param= "1"
		If GUICtrlRead($T1_Proc2) = $GUI_CHECKED Then $param= "2"
		If GUICtrlRead($T1_Proc3) = $GUI_CHECKED Then $param= "3"
		If GUICtrlRead($T1_Proc4) = $GUI_CHECKED Then $param= "4"
		If GUICtrlRead($T1_Proc5) = $GUI_CHECKED Then $param= "5"
;		If GUICtrlRead($T1_Proc6) = $GUI_CHECKED Then $param= "6"
		If GUICtrlRead($T1_Internet) = $GUI_CHECKED Then $param= "I"	
		$stat= MsgBox(40100,"reBut", "quer mesmo reButar (botão RESET) o PC " & $param )
		If $stat <> 7 then 			
			envia_cmd ("#R",$param)
			SplashTextOn("Aguarde", @CR&@CR&"Aguarde 15 segundos!" &@cr& "reButando o PC" & $param &@cr& "-->botão RESET<---",270, 300, 192, 125,1,"",16)
			Sleep(15000) ; aguarda PIC estar pronto para receber novo comando
			SplashOff()
		EndIf

	Case $msg = $T1_LigAr
		envia_cmd ("#L","A")
	Case $msg = $T1_deslAr
		$stat= MsgBox(40100,"AR", "quer mesmo DESLIGAR o Ar Refrigerado?")
		If $stat <> 7 then 	envia_cmd ("#D","A")
	Case $msg = $T1_LigModem
			envia_cmd ("#L","M")
	Case $msg = $T1_desligModem
		$stat= MsgBox(40100,"MODEM", "quer mesmo DESLIGAR o MODEM?")
		If $stat <> 7 then 	envia_cmd ("#D","M")
	Case $msg = $T1_resetModem
		$stat= MsgBox(40100,"MODEM", "quer mesmo RESETAR o MODEM?")
		If $stat <> 7 then 	
			envia_cmd ("#R","M")
			SplashTextOn("Aguarde", @CR&@CR&"Aguarde 25 segundos!" &@cr& "RESETANDO o MODEM" &@cr& "(Desligando/Religando)",270, 300, 192, 125,1,"",16)
			Sleep(25000) ; aguarda PIC estar pronto para receber novo comando
			SplashOff()
		EndIf
	Case $msg = $T1_ajusTemp
			$vRef= InputBox("Ajuste Volt.Refer6encia","Meça a voltagem de referência na placa PIC e a multiplique por 100." &@cr&  "ex: mediu 1,72 V, digite 172")
			envia_cmd("#V",$vref*1)		;manda voltagem de referência dada para o PIC
	Case $msg= $T1_MostPort
			$Porta_Bit= InputBox("Mostra Bit duma Porta no LED","Exibe continuamente o valor atual do bit escolhido no LED da placa"&@cr& _ 
			"Dê a porta (A,B) seguida do bit(0..7)" &@cr& "ex: B3   => fica exibindo valor da porta B, bit 3")
			If $Porta_Bit = "" Then ContinueLoop
			$Porta_Bit= StringUpper($Porta_Bit)
			envia_cmd("#M",$Porta_Bit)
	Case $msg = $T1_watchDog
			trataWatchDog()
			
	Case Else
		;;;;;;;
EndSelect
;	Sleep(50)
	$temperatura = pega_temperatura() ;pega temperatura vinda do PIC
   $temperatura=28
    If $temperatura <> "" Then 
		GUICtrlSetData($T1_Temp, $temperatura)
		aviso_temp($temperatura)
;		sleep(300)
		GUICtrlSetData($T1_Temp, $temperatura & "º")
	EndIf
WEnd
Exit

Func pega_temperatura()

	If $comRS232.InBufferCount >= 4 Then   ; se tem caracter na RS232, o lê 
;MsgBox(4096, $comRS232.InBufferCount,$bufRS232)
		$bufRS232=$bufRS232 & $comRS232.InputData  ;vai armazenando caracteres da interface RS232
		$x = StringInStr($bufRS232, "#T") ;procura inicio do comando
		If  $x > 0 Then ; achou início de comando
			$y= Asc(StringMid($bufRS232,$x+2,1)) ; temperatura - pega byte + significativo
;			$comRS232.InBufferCount= 0  ; zera buffer de entrada da interface RS232
;MsgBox(4096,$x,$bufRS232)
			$bufRS232 = "" ; zera buffer q armazena 
			Return ($y)
		EndIf
	EndIf
	Return "" ;se não tem comando pronto ainda, retorna ""
#cs   //** código para teste, gera sequencia de temperaturas subindo e descendo
$conta = $conta + 1
	If $conta = 20 Then 
		$conta= 0
		$x= $x+$y
		If $x > 42 Then $y=-1
		If $x = 17 Then $y=1
		Return $x &"º"
	EndIf
#ce
EndFunc

Func aviso_temp($temperatura)
		Switch $temperatura
			Case 0 to 28
				GUICtrlSetColor($T1_Temp, 0x00FF00)
				SplashOff()
			Case  29 To 31
				SplashTextOn("temp= "&  $temperatura, "Atenção: temperatura ACIMA DO IDEAL",100,200,10,10)
				GUICtrlSetColor($T1_Temp, 0xf08000)
			Case 32 To 38
				SplashTextOn("temp= "&  $temperatura, "Atenção: temperatura ALTA",100,200,10,10)
				GUICtrlSetColor($T1_Temp, 0xf04000)
			Case 39
				SplashTextOn("temp= "&  $temperatura, "Atenção: temperatura ALTISSIMA",100,200,10,10)
				GUICtrlSetColor($T1_Temp, 0xf83000)
			Case 40 To 45
				Beep()
				SplashTextOn("temp= "&  $temperatura, "Atenção: EMERGENCIA: sala será desligada",100,200,10,10)
				GUICtrlSetColor($T1_Temp, 0xFF2000)
			case Else
				GUICtrlSetColor($T1_Temp, 0x00FF00)
				SplashOff()
		EndSwitch
	EndFunc
	
Func envia_cmd($cmdo, $param)
;	MsgBox(4096,"Comando","Comando: "& $cmdo &@cr& "Parametro: " & $param)
	With $comRS232 					; seta RS232 e envia comando + parametro
        .Output = $cmdo & $param 
    EndWith 
EndFunc
#cs
Func envia_cmd($p1,$p2)
	MsgBox(4096,$p1,$p2)
EndFunc
#ce

func trataWatchDog()
#Region ### START Koda GUI section ### Form=C:\Projeto\PIC\SalaProc3\WatchDog.kxf
Global $T2 = GUICreate("WatchDog - setagem", 210, 235, 193, 125)
Global $T2_L1 = GUICtrlCreateLabel("watchDog Atual:", 8, 10, 71, 19)
GUICtrlSetFont(-1, 8, 400, 0, "Arial Narrow")
GUICtrlSetTip(-1, "mostra status atual do watchDog")
Global $T2_watchDogAtual = GUICtrlCreateLabel(""  &$watchDogAtual & "", 72, 10, 100, 19)
GUICtrlSetFont(-1, 8, 400, 0, "Arial Narrow")
GUICtrlSetTip(-1, "p: (1..6) -> PC"&@cr&" c:(L,D,R,B) ->comando"&@cr&"t:(2..14,30) ->minutos")
Global $Group1 = GUICtrlCreateGroup("Escolha operação", 8, 30, 169, 176)
Global $T2_ligaWInternet = GUICtrlCreateRadio("Liga watchDog Internet", 16, 50, 153, 17)
GUICtrlSetTip(-1, "operaçoões: Desl.Modem, espera, desl.PC Internet, espera..."&@cr& "LigaModem, espera,Liga PC Internet")
Global $T2_DesligaW = GUICtrlCreateRadio("Desliga watchDog", 16, 67, 153, 17)
GUICtrlSetTip(-1, "desativa watchDog (todos)")
Global $T2_ligaWGenerico = GUICtrlCreateRadio("Liga watchDog Generico", 16, 85, 145, 17)
GUICtrlSetTip(-1, "defina abaixo os parâmetros do watchDog"&@cr&"tempo  = 0, desativa watchDog")
Global $Group2 = GUICtrlCreateGroup("parametros Genérico", 32, 100, 121, 101)
Global $T2_PC = GUICtrlCreateCombo("T2_PC", 72, 120, 57, 25)
GUICtrlSetData(-1, "|PC 1|PC 2|PC 3|PC 4|PC 5|PC 6")
Global $Label2 = GUICtrlCreateLabel("PC", 40, 120, 18, 17)
GUICtrlSetTip(-1, "escolha PC sobre o qual vai atuar o comando")
Global $Label3 = GUICtrlCreateLabel("cmdo", 40, 145, 30, 17)
GUICtrlSetTip(-1, "defina comando a executar sobre o PC")
Global $T2_tempo = GUICtrlCreateLabel("tempo", 40, 170, 33, 17)
GUICtrlSetTip(-1, "tempo após o qual vai executar o cmdo. dado acima"&@cr&"se receber qq. cmdo. neste tempo, o tempo de espera é reiniciado"&@cr&"desativa=desativa função watchDog")
Global $T2_Cmdo = GUICtrlCreateCombo("T2_Cmdo", 72, 145, 57, 25)
GUICtrlSetData(-1, "|Desliga|Liga|Reset|reBut")
Global $Combo3 = GUICtrlCreateCombo("Combo3", 72, 170, 57, 25)
GUICtrlSetData(-1, "|0|2|4|6|8|10|12|14|30")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $T2_btSair = GUICtrlCreateButton("sair", 104, 210, 51, 20, 0)
GUICtrlSetTip(-1, "sai sem executar qualquer comando")
Global $T2_btExecutar = GUICtrlCreateButton("executar", 24, 210, 59, 20, 0)
GUICtrlSetTip(-1, "executa o comando dado acima")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Local $x

While 1
$nMsg = GUIGetMsg()
Switch $nMsg
	Case $GUI_EVENT_CLOSE, $T2_btSair
		ExitLoop			;se bt sair, sai sem executar nada
	Case $T2_btExecutar
		if (GUICtrlRead($T2_DesligaW) = $GUI_CHECKED) Then 
			envia_cmd("#W","D")								;desliga watchDog
			$watchDogAtual= "nenhum"						;status atual
			GUICtrlSetData($T2_watchDogAtual,$watchDogAtual);atualiza tela
		EndIf
		If GUICtrlRead($T2_ligaWGenerico) = $GUI_CHECKED Then	;se genérico selecionado, pega cada parametro e passa pro PIC
			If GUICtrlRead($T2_tempo) < 30 Then 
				$x= GUICtrlRead($T2_tempo)*32/2
			Else
				$x=14*32/2
			EndIf
			envia_cmd("#W",GUICtrlRead($T2_PC) + StringMid(GUICtrlRead($T2_Cmdo),1,1)*8 + $x)
			$watchDogAtual= "pc:" & GUICtrlRead($T2_PC) & ", cmd:" & GUICtrlRead($T2_Cmdo)& ", tempo:"& GUICtrlRead($T2_tempo)
			If GUICtrlRead($T2_tempo) = 0 Then $watchDogAtual="nenhum"
			GUICtrlSetData($T2_watchDogAtual,$watchDogAtual)	;atualiza tela
		EndIf
		If GUICtrlRead($T2_ligaWInternet) = $GUI_CHECKED Then	;se Internet, liga watchDog de Internet
			envia_cmd("#W","L")									;liga watchDog Internet
			$watchDogAtual= "Internet"							;status atual
			GUICtrlSetData($T2_watchDogAtual,$watchDogAtual)	;atualiza tela
		EndIf
EndSwitch
WEnd
GUIDelete($T2)		;apaga esta form
EndFunc


