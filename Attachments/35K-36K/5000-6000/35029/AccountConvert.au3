#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=AccountConvert.ico
#AutoIt3Wrapper_Res_Description=Conversione XLS-CSV Elenco Account CyberArk
#AutoIt3Wrapper_Res_Fileversion=1.0
#AutoIt3Wrapper_Res_LegalCopyright=G. Criaco - Sogei
#AutoIt3Wrapper_Res_Language=1040
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===================================================================================================================================================
; Program Name:     AccountChk()
; Description:      Verifica Account CyberArk
; Parameter(s):     None
; Requirement(s):   AccountChk.ini
; Return Value(s):  None
; Author(s):        Giuseppe Criaco <gcriaco@sogei.it>
;===================================================================================================================================================
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#region ### START Koda GUI section ### Form=c:\autoit\accountchk\form1.kxf
$Form1_1 = GUICreate("AccountChk", 219, 118, 413, 291, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_WINDOWEDGE))
$StatusBar1 = _GUICtrlStatusBar_Create($Form1_1)
$txtFile = GUICtrlCreateInput("", 8, 32, 161, 21)
$cmdSearch = GUICtrlCreateButton("...", 176, 32, 35, 21)
$cmdStart = GUICtrlCreateButton("&Start", 56, 64, 75, 25, $BS_DEFPUSHBUTTON)
$cmdExit = GUICtrlCreateButton("&Exit", 136, 64, 75, 25)
$Label1 = GUICtrlCreateLabel("Account File:", 8, 9, 66, 17)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

#include <File.au3>
;~ #include <Array.au3>
#include <Excel.au3>

Const $bDEBUGIT = True
;~ Const $INIFILE = @ScriptDir & "\" & StringLeft(@ScriptName, StringLen(@ScriptName) - 3) & "ini"
Const $LOGFILE = @ScriptDir & "\" & StringLeft(@ScriptName, StringLen(@ScriptName) - 3) & "log"
Const $ERRORFILE = @ScriptDir & "\" & StringLeft(@ScriptName, StringLen(@ScriptName) - 4) & "_Errors.log"

Global  $sCmd, $iRC = 0, $sIP, $iPorta, _
		$iSID, $sHostname, $sTipologia, $sProtocollo, $sSistemaOperativo, $sUtenteDaGestire, $sUtenteAccessoRemoto, $sPasswordIniziale, $iScadenzaPassword, $sSafe, _
		$sFW, $sAzione, $sNote, $iTotRow, $iTotCol, $aExcel, $sFileIn, $sFileOut, $iRow, $iCol = 1, $iTotSafeRow, $iTotSafeCol

If $bDEBUGIT Then AutoItSetOption("TrayIconDebug", 1) ;Debug: 0=no info, 1=debug line info

GUICtrlSetState($txtFile, $GUI_DROPACCEPTED)

_GUICtrlStatusBar_SetText($StatusBar1, "")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $cmdExit
			Exit

		Case $cmdSearch
;~ 			$sFileIn = FileOpenDialog("Selezionare il file Excel con l'elenco di Account", @ScriptDir & "\", "File Excel (*.xls;*.xlsx)", 1 + 2)
			GUICtrlSetData($txtFile, FileOpenDialog("Selezionare il file Excel con l'elenco di Account", @ScriptDir & "\", "File Excel (*.xls;*.xlsx)", 1 + 2))

		Case $cmdStart
			$sFileIn = GUICtrlRead($txtFile)
			If $sFileIn = "" Then
				MsgBox(16, "Messaggio di Errore", "Nessun file Excel selezionato")
			Else
				_CSVWrite()
			EndIf

		Case $GUI_EVENT_DROPPED
;~ 			$sFileIn = GUICtrlRead($txtFile)
;~ 			_AccountCheck()
	EndSwitch
WEnd

Exit

;===================================================================================================================================================
; Function Name:	_CSVWrite
; Description:
; Parameter(s):
; Requirement(s):	None
; Return Value(s):	0=OK, 1=Errori
;===================================================================================================================================================
Func _CSVWrite()
	Local Const $SHEADER = "Password_name,TemplateSafe,CPMUser,Safe,Folder,Password,DeviceType,PolicyID,Address,UserName,HostName,Type,VTY,ExtraPass1Name,ExtraPass1Safe,ExtraPass1Folder,ExtraPass2Name,ExtraPass2Safe,ExtraPass2Folder,ExtraPass3Name,ExtraPass3Safe,ExtraPass3Folder,Location,OwnerName,MasterPassName,MasterPassFolder,GroupName,ServiceName,RestartService,CPMDisabled,ResetImmediately,DSN,ClientDN,ServerDN"

	$sFileOut = StringReplace($sFileIn, "xls", "csv")

	$file = FileOpen($sFileOut, 2)
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf

	FileWriteLine($file, $SHEADER)

	_GUICtrlStatusBar_SetText($StatusBar1, "Caricamento file Excel...")
	_ReadExcel($sFileIn)

;~ Indirizzo IP	Porta Sid Hostname Tipologia Protocollo Sistema Operativo(**) Utente da Gestire Utente Accesso Remoto(***) Password iniziale Scadenza Password Safe FW Azione(*) Note(****)
	For $iRow = 1 To $iTotRow
		_GUICtrlStatusBar_SetText($StatusBar1, "Scrittura Riga " & $iRow)

		$sIP = $aExcel[$iRow][1]
		$iPorta = $aExcel[$iRow][2]
		$iSID = $aExcel[$iRow][3]
		$sHostname = $aExcel[$iRow][4]
		$sTipologia = $aExcel[$iRow][5]
		$sProtocollo = $aExcel[$iRow][6]
		$sSistemaOperativo = $aExcel[$iRow][7]
		$sUtenteDaGestire = $aExcel[$iRow][8]
		$sUtenteAccessoRemoto = $aExcel[$iRow][9]
		$sPasswordIniziale = $aExcel[$iRow][10]
		$iScadenzaPassword = $aExcel[$iRow][11]
		$sSafe = $aExcel[$iRow][12]
		$sFW = $aExcel[$iRow][13]
		$sAzione = $aExcel[$iRow][14]
		$sNote = $aExcel[$iRow][15]

		If $sIP = "" Then
			ExitLoop
		Else
			FileWriteLine($file, $sTipologia & "-" & "POLICY" & "-" & $sIP & "-" & $sHostname & "-" & $sUtenteDaGestire & ",,PasswordManager," & $sSafe & ",root," & _
				$sPasswordIniziale & "," & $sTipologia & "," & "POLICY" & "," & $sIP & "," & $sUtenteDaGestire & "," & $sHostname & ",,,,,,,,,,,,,,,,,,,,VerifyTask,,,")
		EndIf

	Next

	FileClose($file)

	_GUICtrlStatusBar_SetText($StatusBar1, "CSV OK")
EndFunc   ;==>_CSVWrite

;===================================================================================================================================================
; Function Name:	_WriteLog
; Description:
; Parameter(s):
; Requirement(s):	None
; Return Value(s):	0=OK, 1=Errori
;===================================================================================================================================================
Func _WriteLog($sMsg)
	_FileWriteLog($LOGFILE, $sMsg)
EndFunc   ;==>_WriteLog

;===================================================================================================================================================
; Function Name:	_ReadExcel
; Description:
; Parameter(s):
; Requirement(s):	None
; Return Value(s):	0=OK, 1=Errori
;===================================================================================================================================================
Func _ReadExcel($sFileIn)
	Local $oExcel = _ExcelBookOpen($sFileIn, 0)
	If @error <> 0 Then _ScriptErr("_ExcelBookOpen Error - File: " & $sFileIn & " - @error: " & @error)

	$aExcel = _ExcelReadSheetToArray($oExcel, 2) ;Using Default Parameters
	If @error <> 0 Then _ScriptErr("_ExcelReadSheetToArray Error - @error: " & @error & " - @extended: " & @extended)
;~ 	_ArrayDisplay($aExcel, "Array using Default Parameters")

	_ExcelBookClose($oExcel) ; And finally we close out
	If @error <> 0 Then _ScriptErr("_ExcelBookClose Error - File: " & $sFileIn & " - @error: " & @error)

	$iTotRow = $aExcel[0][0]
	$iTotCol = $aExcel[0][1]
EndFunc   ;==>_ReadExcel

;===================================================================================================================================================
; Function Name:    _ScriptErr
; Description:      Gestione errori
; Parameter(s):     $sMsg, $sMailServer
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Giuseppe Criaco <gcriaco@sogei.it>
;@sogei.it
;===================================================================================================================================================
Func _ScriptErr($sMsg)
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Critical
	MsgBox(16, "Messaggio di Errore", $sMsg)

	Local $sCmd

	;Scrittura Log
	_FileWriteLog($ERRORFILE, $sMsg)

	Exit
EndFunc   ;==>_ScriptErr

;===================================================================================================================================================
;~ Func _dbg($sMsg)
;~ 	If @Compiled Then
;~ 		DllCall("kernel32.dll", "none", "OutputDebugString", "str", $sMsg)
;~ 	Else
;~ 		ConsoleWrite($sMsg & @CRLF)
;~ 	EndIf
;~ EndFunc   ;==>_dbg