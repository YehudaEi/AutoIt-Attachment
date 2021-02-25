#include <GUIConstants.au3>
#Include <WinAPI.au3>

ProgressOn("A Carregar", "Abrir", "0%") 
For $i = 10 To 100 Step 10
	Sleep(1000)
	ProgressSet($i, $i & "%")
Next
ProgressSet(100, "Carregado", "Completo")
Sleep(500)
ProgressOff()

Local $comprimento = iniRead(".\Contador.ini", "Janela do Contador regressivo", "comprimento", ""); pega os dados do arquivo ini
Local $altura = iniRead(".\Contador.ini", "Janela do Contador regressivo", "altura", ""); pega os dados do arquivo ini
Local $horizontal = iniRead(".\Contador.ini", "Janela do Contador regressivo", "Horizontal", ""); pega os dados do arquivo ini
Local $vertical = iniRead(".\Contador.ini", "Janela do Contador regressivo", "Vertical", ""); pega os dados do arquivo ini
Local $fonte = iniRead(".\Contador.ini", "Janela do Contador regressivo", "Fonte Usada", ""); pega os dados do arquivo ini
Local $font_size = iniRead(".\Contador.ini", "Janela do Contador regressivo", "Tamanho da fonte", ""); pega os dados do arquivo ini
Local $bot_credito = iniRead(".\Contador.ini", "Botão usado para creditar tempo", "Creditar", ""); pega os dados do arquivo ini
Local $JOYID = IniRead(".\contador.ini", "Identifica joy", "Id joy", ""); identifica qual joystick será usado
Local $tempo, $temporizador, $horas, $minutos, $segundos; variáveis globais
Local $JOYINFO, $bt_joy, $str

$str = "int x;int y;int z;int buttons"
$JOYINFO = DllStructCreate($str)

$hWnd = WinGetHandle("[CLASS:Shell_TrayWnd]"); identifica a barra
_WinAPI_ShowWindow($hWnd, @SW_SHOW); mostra a barra de tarefas

AdlibRegister("sistema", 1000); Ajuste o tempo de acordo com o pulso do seu moedeiro


While 1
	$retjoy = DllCall("winmm.dll", "int", "joyGetPos", "int", $JOYID, "ptr", DllStructGetPtr($JOYINFO))
	$bt_joy = DllStructGetData($JOYINFO, "buttons");pega os valores preenchidos pela função JoyGetPos
	
	If BitAND($bt_joy, $bot_credito) Then
		creditar(); chama a função creditar
	Endif

	If WinExists("Gestor de tarefas do Windows") Then ; verifica se a janela existe
		WinClose("Gestor de tarefas do Windows"); fecha o Gestor de tarefas
        MsgBox("", "", "Bloqueado pelo Administrador", 3); mostra a mensagem
	Endif
	
	If WinExists("Centro de ajuda e suporte")Then;verifica se a janela existe 
		WinClose("Centro de ajuda e suporte");fecha o Centro de ajuda e suporte
		MsgBox("","","Bloqueado pelo Administrador",3);mostra a mensagem
	EndIf
	

	$tempo = IniRead(".\contador.ini", "Tempo Restante", "Restando", ""); pega a informação de fichas do arquivo ini
	$temporizador = "00:00:00"; formato do contador
	$horas = Int($tempo / 3600000); converte o valor em horas
	$minutos = Int(Mod($tempo, 3600000) / 60000); converte o valor em minutos
	$segundos = Int(Mod(Mod($tempo, 3600000), 60000) / 1000); converte o valor em segundos
	$temporizador = StringFormat("%02d:%02d:%02d", $horas, $minutos, $segundos); informações que serão mostradas no contador


	SplashTextOn("Tempo", "" & $temporizador, 115, 35, 4, 2, 300, "Bernard MT Condensed", 18); mostra o contador

	sleep(1000); ajuste este tempo de acordo com o pulso do seu moedeiro, terá que ser menor que o pulso

Wend

$JOYINFO = 0
Exit(0)

func sistema()
	
	


	if $tempo >= 1000 then; verifica se o tempo chegou a 1 segundo se estiver em "0" para de gravar
		$diminui = (Number($tempo) - 1000); diminui 1 segundo
		IniWrite(".\contador.ini", "Tempo Restante", "Restando", ($diminui)); grava o tempo com 1 segundo a menos
	endif

	if $tempo <= 0 then; quando chegar a "0" Bloqueia o teclado
		BlockInput(0)
	endif
	
	if $tempo  < 1 then
		ProcessClose("firefox.exe")
	endif
    If $tempo < 1 Then
        ProcessClose("msnmsgr.exe")	
    endif		

	if $tempo > 1 then; se o tempo for maior que "0" libera o teclado
		BlockInput(0); libera o teclado
	endif

endfunc   ;==>sistema

func creditar()
	Local $valor_ficha, $converte, $tempo_rest, $adiciona
	Local $JOYID = IniRead(".\contador.ini", "Identifica joy", "Id joy", ""); identifica qual joystick será usado
	Local $JOYINFO, $bt_joy, $str
	Local $bot_credito = iniRead(".\Contador.ini", "Botão usado para creditar tempo", "Creditar", ""); pega os dados do arquivo ini
	$str = "int x;int y;int z;int buttons"
	$JOYINFO = DllStructCreate($str)

	While 1
		$retjoy = DllCall("winmm.dll", "int", "joyGetPos", "int", $JOYID, "ptr", DllStructGetPtr($JOYINFO))
		$bt_joy = DllStructGetData($JOYINFO, "buttons") ;pega os valores preenchidos pela função JoyGetPos
		If not BitAND($bt_joy, $bot_credito) Then ; credita somente quando o botão for solto
			$valor_ficha = IniRead(".\contador.ini", "Tempo que vale 1 ficha", "Tempo em minutos", ""); valor em minutos de 1 ficha
			$converte = (Number($valor_ficha) * 60000); converte o tempo que vale a ficha para milisegundos
			$tempo_rest = IniRead(".\contador.ini", "Tempo Restante", "Restando", ""); lê no contador.ini
			$adiciona = (Number($tempo_rest) + Number($converte)); soma o valor da ficha ao tempo restante
			IniWrite(".\contador.ini", "Tempo Restante", "Restando", String($adiciona)); grava no contador.ini
			ExitLoop
		endif
		sleep(20)
	Wend

endfunc   ;==>creditar