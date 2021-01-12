#comments-start
--- @@@
silvano camerlo - www.crabservice.com
-- @@@@

una piccola utility per eseguire una schedulazione
lo script usa jt.exe distribuito da microsoft da scaricare ed 
inserire nella stessa directory dello script
---
little utility to schedule a job
this script use microsoft tool: jt.exe to schedule job
download it in the same directory of the script

#comments-end
#include <GUIConstants.au3>

Dim $chiaveREG = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\"

Dim $msgBase = 266240
Dim $msgErro = 16 + 266240
Dim $msgInte = 32 + 266240
Dim $msgEscl = 48 + 266240
Dim $msgInfo = 64 + 266240

If @OSLang == 0409 Or @OSLang == 0809 Then ; lingua inglese
	$txtDatiBackupAutomatico="Setting your job schedule"
	$txtPulsanteSfoglia="&Browse"
	$txtFileDaEseguire="Select executable file to sched"
	$txtNomeFileScelto = "No program selected"
	$txtScegliOra="Select hour:"
	$txtTitoloUserPassword="User and Password: Admini or Backup operators"
	$txtUtenteEsempio="User eg.:"
	$txtAttivoTestoOK="ACTIVE!"
	$txtAttivoTestoNOOK="NOT ACTIVE!"
	$txtPulsanteSchedula="&SCHED"
	$txtPulsanteChiudi="&CLOSE"
	$txtPulsanteCancella="Delete JOB"
	$txtNessunaPassword="Password must be not blank"
	$txtNessunUtente="Insert User"
	$txtSchedulazioneNOOK="JOB not schedule!"
	$txtSchedulazioneOK="JOB schedule OK"
Else ; italiano
	$txtDatiBackupAutomatico="Imposta i dati per il backup automatico"
	$txtPulsanteSfoglia="&Scegli"
	$txtFileDaEseguire="Seleziona il file da eseguire"
	$txtNomeFileScelto = "Nessun programma associato"
	$txtScegliOra="Scegli l'ora:"
	$txtTitoloUserPassword="Inserisci Utenza e Password Amministrative o di Backup"
	$txtUtenteEsempio="Utente es.:"
	$txtAttivoTestoOK="ATTIVO!"
	$txtAttivoTestoNOOK="NON ATTIVO!"
	$txtPulsanteSchedula="&SCHEDULA"
	$txtPulsanteChiudi="&CHIUDI"
	$txtPulsanteCancella="Cancella Operazione"
	$txtNessunaPassword="Non hai inserito la password"
	$txtNessunUtente="Non hai inserito il Nome Utente"
	$txtSchedulazioneNOOK="Operazione non eseguita correttamente!"
	$txtSchedulazioneOK="Operazione eseguita correttamente" 
EndIf

Global $sFilePath = @ScriptDir&"\sched.bat" ;temp .bat to launch sched
;Global $appName = @WindowsDir&"\notepad.exe" ; name of application to schedule

Func __fileCrea($sFilePath,$testo)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $hOpenFile
	Local $hWriteFile
	
	$hOpenFile = FileOpen($sFilePath, 2)
	
	If $hOpenFile = -1 Then
		SetError(1)
		Return 0
	EndIf
	
	$hWriteFile = FileWrite($hOpenFile, $testo)
	
	If $hWriteFile = -1 Then
		SetError(2)
		Return 0
	EndIf
	
	FileClose($hOpenFile)
	Return 1
EndFunc   ;==>_FileCreate

Func __appName($percorso)
	$result = StringTrimLeft($percorso,StringInStr($percorso, "\",0,-1))
	$result1 = StringTrimLeft($result,StringInStr($result, ".",0,-1))
	$result2 = StringReplace($result,$result1,"job")
	Return $result2
EndFunc

Func __schedula()

#Region ### START Koda GUI section ### Form=d:\backitup\definitivo\sorgenti\schedula.kxf
$skForm = GUICreate("TASK SCHED", 491, 270, 213, 126, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
$Schedula = GUICtrlCreateGroup("", 8, 1, 473, 225, $BS_FLAT)
$skTitolo = GUICtrlCreateLabel($txtDatiBackupAutomatico, 72, 16, 343, 22)
GUICtrlSetFont(-1, 12, 800, 0, "Verdana")

$skSfoglia = GUICtrlCreateButton($txtPulsanteSfoglia, 32, 72, 75, 25, 0)
$skSfogliaFile = GUICtrlCreateLabel($txtFileDaEseguire, 32, 48, 185, 17)
GUICtrlSetFont(-1, 8, 800, 0, "Verdana")
GUICtrlSetColor(-1, 0x800000)
$nomeFileScelto = RegRead($chiaveREG,"nomeFileScelto")
If @error Or $nomeFileScelto == "" Or $nomeFileScelto == 0 Then $nomeFileScelto = $txtNomeFileScelto
$skNomeFileDaEguire = GUICtrlCreateLabel($nomeFileScelto, 128, 64, 333, 41)

$nameFileToSched = __appName(GUICtrlRead($skNomeFileDaEguire)); name of job

$skOra = GUICtrlCreateCombo("01", 328, 185, 40, 25)
GUICtrlSetData(-1,"02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|00","01")
$skMinuti = GUICtrlCreateCombo("00", 384, 185, 40, 25)
GUICtrlSetData(-1,"01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59","00")

$skOratesto = GUICtrlCreateLabel($txtScegliOra, 240, 193, 81, 17)
$skMinutitesto = GUICtrlCreateLabel(":", 372, 190, 8, 17)
GUICtrlSetFont(-1, 8, 800, 0, "Verdana")
$skUtente = GUICtrlCreateInput("Administrator", 112, 144, 121, 21)
$skPassword = GUICtrlCreateInput("", 328, 144, 121, 21)
$Label1 = GUICtrlCreateLabel($txtTitoloUserPassword, 96, 112, 380, 17)
GUICtrlSetFont(-1, 8, 800, 0, "Verdana")
GUICtrlSetColor(-1, 0x800000)

$skUteTesto = GUICtrlCreateLabel($txtUtenteEsempio, 32, 144, 74, 17)
GUICtrlSetFont(-1, 8, 800, 0, "Verdana")
$skpswtesto = GUICtrlCreateLabel("Password:", 256, 144, 70, 17)
GUICtrlSetFont(-1, 8, 800, 0, "Verdana")

If FileExists(@WindowsDir&"\tasks\"&$nameFileToSched) Then 
	$skAttivoTesto = $txtAttivoTestoOK
	$coloreAttivo=0x008000
	$cancellaDisattivo = 0
Else
	$skAttivoTesto = $txtAttivoTestoNOOK
	$coloreAttivo=0xFF0000
	$cancellaDisattivo = 1
EndIf

$skAttivoTesto = GUICtrlCreateLabel("JOB "&$skAttivoTesto, 24, 192, 180, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Verdana")
GUICtrlSetColor(-1, $coloreAttivo)

GUICtrlCreateGroup("", -99, -99, 1, 1)

$buttonSchedula = GUICtrlCreateButton($txtPulsanteSchedula, 305, 234, 75, 25, 0)
$buttonChiudi = GUICtrlCreateButton($txtPulsanteChiudi, 400, 234, 75, 25, 0)
$buttonElimina = GUICtrlCreateButton($txtPulsanteCancella, 8, 240, 150, 25, 0)
If $cancellaDisattivo == 1 Then
GUICtrlSetState($buttonElimina,$GUI_DISABLE)
Else
GUICtrlSetState($buttonElimina,$GUI_SHOW)	
EndIf

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
		GUISetState(@SW_HIDE)
			ExitLoop
		Case $buttonChiudi
			GUISetState(@SW_HIDE)
			ExitLoop
		Case $skSfoglia
			$cheFile = FileOpenDialog("Select", "C:\", "(*.exe;*.bat)", 1)
			If @error <> 1 Then
				GUICtrlSetData($skNomeFileDaEguire,$cheFile)
				RegWrite($chiaveREG,"nomeFileScelto","REG_SZ",$cheFile)
				ContinueLoop
				EndIf
		Case $buttonSchedula
			If GUICtrlRead($skPassword) == "" Then 
				MsgBox($msgErro,"",$txtNessunaPassword)
				ContinueLoop
			EndIf
			If GUICtrlRead($skUtente) == "" Then 
				MsgBox($msgErro,"ATTENZIONE",$txtNessunUtente)
				ContinueLoop
				EndIf
			$oraTotale = GUICtrlRead($skOra)&":"&GUICtrlRead($skMinuti)
			$cancella = " "
			If FileExists(@WindowsDir&"\tasks\"&$nameFileToSched) Then 
				$cancella = " /SD "&$nameFileToSched
			EndIf
$testo = "jt.exe"&$cancella&" /SNJ "&$nameFileToSched&" /sc "&@LogonDomain&"\"&GUICtrlRead($skUtente)&" "&GUICtrlRead($skPassword)&" /CTJ StartDate=TODAY StartTime="&$oraTotale&" Type=Daily Disabled=0 /SJ ApplicationName="&GUICtrlRead($skNomeFileDaEguire)&" WorkingDirectory="&@WindowsDir&" /SAJ "&$nameFileToSched
			__fileCrea($sFilePath,$testo)
			Sleep(1000)
			RunWait($sFilePath)
			If @error Then 
				MsgBox($msgErro,"TASK SCHED",$txtSchedulazioneNOOK,10)
			Else
				If FileExists(@WindowsDir&"\tasks\"&$nameFileToSched) Then 
				MsgBox($msgInfo,"TASK SCHEDULA",$txtSchedulazioneOK,10)
				FileDelete($sFilePath)
				Else
				MsgBox($msgErro,"TASK SCHED",$txtSchedulazioneNOOK,10)
				EndIf
			EndIf
			GUISetState(@SW_HIDE)
			ExitLoop
		Case $buttonElimina
			FileDelete(@WindowsDir&"\tasks\"&$nameFileToSched)
			If @error Then 
				MsgBox($msgErro,"TASK SCHED",$txtSchedulazioneNOOK,10)
				Else
				MsgBox($msgInfo,"TASK SCHED",$txtSchedulazioneOK,10)
				RegWrite($chiaveREG,"nomeFileScelto","REG_SZ",0)
			EndIf
			GUISetState(@SW_HIDE)
			ExitLoop
	EndSwitch
WEnd
EndFunc
; ######fine schedula ##############

; ################ launch func to sched ; ########################
__schedula()