#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=S:\AUTOMATIZACAO\weg.ico
#AutoIt3Wrapper_outfile=DeleteFiles.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Comment=Deleta Arquivos
#AutoIt3Wrapper_Res_Description=Developed by DavidLago (HELLFROST)
#AutoIt3Wrapper_Res_Fileversion=1.0.0.3
#AutoIt3Wrapper_Res_LegalCopyright=Hellfrost - David Lago
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


#cs ---------------------------Script Start-------------------------------------
	AutoIt Version: 3.3.6.1
	Author:         David Lago AKA Hellfrost
	Script Function:
	Delete files based on an .ini file.
#ce ----------------------------------------------------------------------------

$ExeError = ObjEvent("AutoIt.Error", "ComError")
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <array.au3>
#include <INet.au3>
#include <Date.au3>


If Not FileExists(@ScriptDir & "\LOG") Then
	DirCreate(@ScriptDir & "\LOG")
EndIf

If Not FileExists(@ScriptDir & "\Config.ini") Then
	$NoIniFileMsg = "The Script " & @ScriptName & ", at "
	$NoIniFileMsg = $NoIniFileMsg & "Computer/Server " & @ComputerName & ", does not have a config.ini file at its same dir " & @CRLF & @CRLF
	$NoIniFileMsg = $NoIniFileMsg & "Script path at the Computer / Server: " & @ScriptFullPath
	SendMail($NoIniFileMsg, "Script Alert: " & @ScriptName)
	Exit
EndIf


Global $Hora = @HOUR & @MIN
Global $Data = @YEAR & @MON & @MDAY
Global $logFileDeletion = @ScriptDir & "\LOG\" & "DeleteJob - " & $Data & "_" & $Hora & ".log"
Global $Caminho_logs = @ScriptDir & "\LOG\"
$ValidadeArquivo = IniRead("Config.ini", "Geral", "ValidadeArquivo", "15")
ScanFolder2($Caminho_logs, "*.*", $ValidadeArquivo, "N")
$sources = IniReadSection("Config.ini", "Sources")

;-------SOURCES-----------
Global $ManutencaoInic = IniRead("Config.ini", "Manutencao", "ManutencaoInic", "N")
Global $ManutencaoFim = IniRead("Config.ini", "Manutencao", "ManutencaoFim", "N")
Global $LogFile = $Data & "_" & IniRead("Config.ini", "Log", "LogFile", "")
Global $LogErro = IniRead("Config.ini", "Log", "LogErro", "") & "_" ; & $Data & ".log"
Global $LogValidade = IniRead("Config.ini", "Log", "LogValidade", "15")
Global $logFileError = @ScriptDir & "\LOG\" & $LogErro & $Data & "_" & $Hora & ".log"
Global $AlertaConf = IniRead("Config.ini", "Alerta", "AlertaConf", "N")
Global $AlertaDadosFrom = IniRead("Config.ini", "Alerta", "AlertaDadosFrom", "")
Global $AlertaDadosTo = IniRead("Config.ini", "Alerta", "AlertaDadosTo", "")
Global $AlertaDadosSubj = IniRead("Config.ini", "Alerta", "AlertaDadosSubj", "")
Global $MensagemManutencao = "The Script " & @ScriptFullPath & " at " & @ComputerName & ", is under maintenance since " & $ManutencaoInic & " and was not " _
		 & "run. It is set to end at " & $ManutencaoFim & ". In case you need any help, contact your Domain Admin."

;-------- Maintenance -----------------
If $ManutencaoInic <> "" Then
	If $ManutencaoInic <> "N" Then
		Sendmail($MensagemManutencao, "The DeleteJob Script was not run due to maintenance")
		Exit
	EndIf
EndIf

;-------- Dir Validate & Error -----------------

If @error Then
Else
	For $i = 1 To $sources[0][0]
		$source_folder = $sources[$i][0]
		$split_value = StringSplit($sources[$i][1], ";")
		$source_extension = StringUpper($split_value[1])
		$source_days = Number($split_value[2])
		$Recursivo = StringUpper($split_value[3])

		If FileExists($source_folder) Then
			ScanFolder2($source_folder, $source_extension, $source_days, $Recursivo)
		Else
			$mensagem = "The folder " & $source_folder & " was not located (Check the ini file)." & @CRLF & @CRLF
			$mensagem = $mensagem & "This script was run at the computer/server " & @ComputerName & @CRLF & @CRLF
			$mensagem = $mensagem & "Script: " & @ScriptFullPath
			SendMail($mensagem, "Script Alert: " & @ScriptName)
		EndIf
	Next
EndIf

Exit

;-----------------------------------------------
Func ScanFolder2($param_SourceFolder, $param_extensao, $param_days, $param_recursivo)
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath
	Local $ExtensaoCheck

	If $param_recursivo = "N" Then ; If the parameter is not set to recursive
		$Search = FileFindFirstFile($param_SourceFolder & "\" & $param_extensao)
		If $Search = -1 Then
			;Not found!
		Else
			;Found!
			While 1
				$File = FileFindNextFile($Search)
				If @error Then ExitLoop
				$FullFilePath = $param_SourceFolder & "\" & $File
				$t = FileGetTime($FullFilePath, 0, 0)
				$yyyymdhms = $t[0] & "/" & $t[1] & "/" & $t[2] & " " & $t[3] & ":" & $t[4] & ":" & $t[5]
				$iDateCalc = _DateDiff("D", $yyyymdhms, _NowCalc())
				If $iDateCalc > $param_days Then
					If FileDelete($FullFilePath) = 1 Then
						FileWriteLine($logFileDeletion, $FullFilePath & ";" & $t)
					Else
						FileWriteLine("\LOG\" & $LogErro, $FullFilePath & ";" & $t)
					EndIf
				EndIf
			WEnd
		EndIf
	Else
		$Search = FileFindFirstFile($param_SourceFolder & "\*.*")
		If $Search = -1 Then
			;Not Found!
		Else
			;Found!
			While 1
				$File = FileFindNextFile($Search)
				If @error Then ExitLoop
				;Are you a folder?
				$FullFilePath = $param_SourceFolder & "\" & $File
				$FileAttributes = FileGetAttrib($FullFilePath)
				If StringInStr($FileAttributes, "D") Then ;Yes, I'm a folder!
					;Am I in "Sources"?
					$retorno_search = _ArraySearch($sources, $FullFilePath, 0, 0, 0, 0, 1, 0)
					If $retorno_search = -1 Then
						ScanFolder2($FullFilePath, $param_extensao, $param_days, $param_recursivo)
					EndIf
				Else
					$file_extension = StringUpper("*" & StringMid($File, StringInStr($File, ".", 0, -1)))
					If $file_extension = $param_extensao Or $param_extensao = "*.*" Then
						$t = FileGetTime($FullFilePath, 0, 0)
						$yyyymdhms = $t[0] & "/" & $t[1] & "/" & $t[2] & " " & $t[3] & ":" & $t[4] & ":" & $t[5]
						$iDateCalc = _DateDiff("D", $yyyymdhms, _NowCalc())

						If $iDateCalc > $param_days Then
							If FileDelete($FullFilePath) = 1 Then
								FileWriteLine($logFileDeletion, $FullFilePath & ";" & $t)
							Else
								FileWriteLine($logFileError, $FullFilePath & ";" & $t)
							EndIf
						Else

						EndIf

					EndIf
				EndIf
			WEnd
		EndIf
	EndIf
EndFunc   ;==>ScanFolder2


; Function to send e-mail
Func SendMail($param_body, $param_subject)
	$objEmail = ObjCreate("CDO.Message")
	$objEmail.From = $AlertaDadosFrom
	$objEmail.To = $AlertaDadosTo
	$objEmail.Subject = $param_subject
	$objEmail.Textbody = $param_body
	$objEmail.Configuration.Fields.Item _
			("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$objEmail.Configuration.Fields.Item _
			("http://schemas.microsoft.com/cdo/configuration/smtpserver") = _
			"SMTPServer.net" ;	<--------------------------------------------------- CONFIGURE YOUR SMPT SERVER CORRECTLY!
	$objEmail.Configuration.Fields.Item _
			("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
	$objEmail.Configuration.Fields.Update
	$objEmail.Send
EndFunc   ;==>SendMail



#cs ---------------------------Script End---------------------------------------
	AutoIt Version: 3.3.6.1
	Author:         David Lago
	Script Function:
	Deleção de arquivos seguindo regras específicas,
	com base em um arquivo de configuração (ini).
#ce ----------------------------------------------------------------------------