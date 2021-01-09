;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Jonathan Bennett (jon@hiddensoft.com)
;
; Script Function:
;   Demo of using multiple lines in a message box
;

; Use the @CRLF macro to do a newline in a MsgBox - it is similar to the \n in v2.64

#include <GuiConstants.au3>

$continue = 0
$processo = 0

Func Aviso()

; GUI
GuiCreate("SENAI FLORIAN�POLIS - SENAI/SC", 800, 400)
GuiSetBkColor(0xffffff)

; PIC
GuiCtrlCreatePic("logo.jpg", 0, 20, 204, 48)
GuiCtrlSetBkColor(-1, 0xffffff)

; LABEL
GuiCtrlCreateLabel("SENAI FLORIAN�POLIS - SENAI/SC" & @CRLF & @CRLF & "O SENAI FLORIAN�POLIS AVISA:" & @CRLF & @CRLF & "Os arquivos pessoais n�o devem ser salvos no computador, caso necess�rio favor salv�-los na unidade E:." & @CRLF & "Ainda assim n�o � garantida a integridade dos dados pois os computadores s�o de uso m�tuo dos alunos." & @CRLF & "Recomenda-se que os arquivos sejam salvos em PENDRIVE, enviados por e-mail ou no servidor de arquivos." & @CRLF & @CRLF & "Para obter acesso ao servidor de arquivos, acesse o endere�o: \\172.16.4.19\seu_nome_de_usu�rio\." & @CRLF & @CRLF & "Obs: Arquivos salvos na unidade C: ser�o apagados ap�s a reinicializa��o do sistema." & @CRLF & @CRLF & "O SENAI CTAI n�o se responsibilizar� pelo BACKUP dos arquivos salvos no computador." & @CRLF & @CRLF & "Para relatar quaisquer problemas com as m�quinas e/ou laborat�rio, acesse:                                 ", 0, 95, 800, 400)
GuiCtrlSetBkColor(-1, 0xffffff)
GuiCtrlSetFont(-1, 12)

GuiSetState()
While GuiGetMsg() <> $GUI_EVENT_CLOSE
WEnd

EndFunc

Func Logon() 
	MsgBox(0, "Logon do Windows", "Efetuando Logon!")
	$ctrl = ProcessExists("ctrl.exe")
While $processo == 0 Or $ctrl <> 0
	If $ctrl <> 0 Then
	ProcessClose("ctrl.exe")
	ProcessWaitClose("ctrl.exe", 1000)
	$ctrl = ProcessExists("ctrl.exe")
	EndIf
	If $processo == 0 Then
	Run("C:\WINDOWS\explorer.exe")
	ProcessWait("explorer.exe", 1000)
	$processo = ProcessExists("explorer.exe")
	EndIf
WEnd
EndFunc

Func Logoff()
	MsgBox(0, "Logoff do Windows", "Efetuando Logoff!")
    Shutdown(0)
EndFunc

Func Principal()
	$answer = MsgBox(4, "SENAI FLORIAN�POLIS - SENAI/SC", "Caro usu�rio, os computadores desta institui��o cont�m um software que possibilita que as atividades dos alunos sejam monitoradas pelo professor, havendo ainda a possibilidade de interven��o do professor nas atividades exercidas pelo aluno." & @CRLF & @CRLF & "Caso voc� n�o concorde com o mesmo, efetue logoff imediatamente." & @CRLF & @CRLF & "Voc� concorda com o uso deste computador sob estas condi��es?")
	
	If $answer == 7 Then
	$continue = 0
    Logoff()
	Exit(0)
	
	ElseIf $answer == 6 Then
	$continue = 1
	Aviso()
	Logon()
	Exit(0)
EndIf

EndFunc

While $continue == 0
	Principal()
WEnd

If $continue == 1 And $processo == 0 Then
	MsgBox(0, "Logon do Windows", "Ocorreu um erro na tentativa de Logon do sistema. Tente novamente.")
	Shutdown(0)
EndIF

Exit(0)