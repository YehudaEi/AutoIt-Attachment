; Objetivo : Criar uma pasta com todas as fotos
#include <String.au3>
#include <File.au3>
#include <Array.au3>

#region Faze inicial RECOLHER
#region Cole aqui os campos do BD

#endregion Cole aqui os campos do BD
#region sequencia de declarações Iniciais
Global $Contato = @CRLF & _ ;quebra a linha para ficar em baixo
		"Skype: junior.prof" & @CRLF & _ 				; Dados do meu skype
		"Fone:  +55 (11) 9-9372-0074" & @CRLF & _		; Cel
		"E-mail: junior.prof@ig.com.br" ; e-mail
;2)variaves globais internas
Global $XMax = @DesktopWidth, $YMax = @DesktopHeight
Global $EmailCliente = "@.com.br"

#endregion sequencia de declarações Iniciais
#region define caracteristicas para o autoit
;performace
Opt('WinWaitDelay', 50) ;diminui o tempo de espera (default=250).
Opt('WinDetectHiddenText', 1) ;obtem testos ocultos
Opt('MouseCoordMode', 0) ;coordenadas relativas a janela ativa
;Opt("SendKeyDelay", 0) ;desativa qq atrazo para a Função Send()
;menu Tray Icon
;#NoTrayIcon ;Não mostra o icone padrão
Opt("TrayOnEventMode", 1) ; forma mais elegante de usar menus (1=ativa as funções OnEvent)
;Opt("TrayMenuMode", 3) ; 1+2= sem menu padrão+desativa o unchecked
Opt("WinSearchChildren", 1);verifica tambem janelas filhas
;para depuração
Opt("TrayIconDebug", 1);ativa debug
Opt("TrayAutoPause", 1);ativa pausa no icone
#endregion define caracteristicas para o autoit
#region Dados do TrayTip
Global $TrayTesto = "Automação Jubior" & $Contato, _ ;>>>;texto que é mostrado no icone do Tray
		$TrayTipTitulo = "", _	;titulo da mensagem de status do programa
		$TrayTipTesto = "" ;testo de mensage
#endregion Dados do TrayTip

#region dados da janela ativa
Global $JanelaAtiva[10] ;Dados da janela ativa atual
;[0] Handle
;[1] PID	Processo ID
;[3] Path
;[4] Titulo
;[5] file name process
;[6] XCentro
;[7] yCentro
;[8] ContolID
;[8] ClassControl
;[9] InnstanceControl
#endregion dados da janela ativa
;=================================================
;3)variaveis globais minhas deste projeto
#region Variaveis de Arquivos e pastas
Global $NomeProjeto = "", _	;nome da pasta
		$DirProjeto = "" ;path da pasta
Global $ArqLeitura, _		;contem os dados do arq de leitura
		$ArqGravacao ;contem os dados do arq de grava��o
#endregion Variaveis de Arquivos e pastas
#region --- Internal functions Au3Recorder Start ---

Func _Au3RecordSetup()
	Opt('WinWaitDelay', 100)
	Opt('WinDetectHiddenText', 1)
	Opt('MouseCoordMode', 0)
EndFunc   ;==>_Au3RecordSetup
Func _WinWaitActivate($title, $text, $timeout = 0)
	WinWait($title, $text, $timeout)
	If Not WinActive($title, $text) Then WinActivate($title, $text)
	WinWaitActive($title, $text, $timeout)
EndFunc   ;==>_WinWaitActivate
;_AU3RecordSetup()

#endregion --- Internal functions Au3Recorder Start ---
#region Funções internas do programa
Func IncluiPasta($PastaOrigem, $PastaDestino)
	$PastaDestinoFinal = $PastaDestino & "\" & @YEAR & "-" & @MON & "-" & @MDAY & " - BKP"

	;$iFlag=0(Default) Return both files and folders
	;$iFlag=1 Return files only
	;$iFlag=2 Return Folders only
	;If @error = 1 Then
	;MsgBox(0, "Sem imagens", "Nenhum arquivo encontrado")
	;Exit
	;EndIf
	;If @error = 4 Then
	;MsgBox(0, "", "No Files Found.")
	;Exit
	;EndIf
	$ListaPastas = _FileListToArray($PastaOrigem, "*.*", 2)
	$ListaArquivos = _FileListToArray($PastaOrigem, "*.*", 1)
	If $ListaArquivos <> 0 Then
		;ProgressOn("Copia de Fotos", "Pasta " & $PastaOrigem, "0 %",10,10)
		For $i = 1 To $ListaArquivos[0]
			;ProgressSet($i,Int( $i / $ListaArquivos[0] * 100 )& " %")
			TrayTip("Copiando Fotos", "Pasta " & $PastaOrigem & @CRLF & Int($i / $ListaArquivos[0] * 100) & " %", 5, 1)

			MontaPasta($ListaArquivos[$i], $PastaOrigem, $PastaDestinoFinal)
		Next
		;ProgressOff()
	EndIf
	If $ListaPastas <> 0 Then
		For $i = 1 To $ListaPastas[0]
			
			#region --- CodeWizard generated code Start ---
			;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(36, "Sub Pastas", "Existem subpastas deseja incluir (S/N)?" & @CRLF & $ListaPastas[$i], 3)
			Select
				Case $iMsgBoxAnswer = 6 Or $iMsgBoxAnswer = -1;Yes
					IncluiPasta($PastaOrigem & "\" & $ListaPastas[$i], $PastaDestino)
				Case $iMsgBoxAnswer = 7 ;No
			EndSelect
			#endregion --- CodeWizard generated code Start ---
		Next
	EndIf
EndFunc   ;==>IncluiPasta
Func MontaPasta($ArqAtual, $PastaOrigem, $PastaDest)

	Local $t = FileGetTime($PastaOrigem & "\" & $ArqAtual, 1)
	
	If @error Then
		MsgBox(0, "Arquivo nâo encontrado", "[" & $PastaOrigem & "\" & $ArqAtual & "]")
	Else
		$ArqNome = StringSplit($ArqAtual, ".")
		If $ArqNome[0] > 2 Then
			$ArqNome[1] = StringTrimRight($ArqAtual, StringLen($ArqNome[$ArqNome[0]]))
			$ArqNome[2] = $ArqNome[$ArqNome[0]]
			$ArqNome[0] = 2
		EndIf
		$PastaDest = $PastaDest & "\" & $t[0] & "\" & StringFormat("%02d", $t[1]) & "\" & $ArqNome[1]
		#region Faze I Verifica se já existe
		Local $Quant = 1
		Local $search = FileFindFirstFile($PastaDest & "*.*")
		If $search <> -1 Then
			While 1
				Local $file = FileFindNextFile($search)
				If @error Then
					ExitLoop
					
				Else
					$Quant += 1
				EndIf
			WEnd
		EndIf
		; Close the search handle
		FileClose($search)
		;copia o arquivo
		If $Quant <> 1 Then
			
			#region --- CodeWizard generated code Start ---
			;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(36, "Arquivo existente", "O Aequivo " & $ArqAtual & " já existe deseja ciar uma nova copia (S/N)?", 3)
			Select
				Case $iMsgBoxAnswer = 6 Or $iMsgBoxAnswer = -1;Yes
					FileCopy($PastaOrigem & "\" & $ArqAtual _								;origem
							, $PastaDest & "(" & StringFormat("%04d", $Quant) & ")." & $ArqNome[2] _						; Nome do arquivo e extenção
							, 8) ;Cria e nao sobrescreve
				Case $iMsgBoxAnswer = 7 ;No
			EndSelect
			#endregion --- CodeWizard generated code Start ---
		Else
			FileCopy($PastaOrigem & "\" & $ArqAtual _								;origem
					, $PastaDest & "." & $ArqNome[2] _						; Nome do arquivo e extenção
					, 8) ;Cria e nao sobrescreve
		EndIf
		
		;FileDelete($PastaOrigem & "\" & $ArqAtual) ;Programa principal original)
		#endregion Faze I Verifica se já existe
		#region Faze II gera GoBack
		$ArqGravacao = $DirProjeto & "\GoBack.txt"
		If FileExists($ArqGravacao) = 0 Then
			; Não existe: Cria Cabeçalho
			$ArqAbertoGravacao = FileOpen($ArqGravacao, 1);Adicionando dados
			If $ArqAbertoGravacao <> -1 Then
				FileWriteLine($ArqAbertoGravacao, "Data" & @TAB & "Arquivo" & @TAB & "Extencao" & @TAB & "PastaOrigem" & @TAB & "ArqDestino")
				FileClose($ArqAbertoGravacao)
			Else
				FileClose($ArqAbertoGravacao)
				MsgBox(Default _; flag
						, "Cancelado a montagem " _;"title"
						, "O arquivo  ( " & $ArqGravacao & " ) não existe ou não esta disponivel" & @CRLF & _
						"Quarquer duvida entrar em contato" & @CRLF & _
						$Contato _; "text"
						, 5 _; 						[, timeout
						, Default);					[, hwnd]] )
				
				Exit
			EndIf
		EndIf
		$ArqAbertoGravacao = FileOpen($ArqGravacao, 1);Adicionando dados
		If $ArqAbertoGravacao <> -1 Then
			FileWriteLine($ArqAbertoGravacao, StringRight(@YEAR, 2) & "-" & @MON & "-" & @MDAY & @TAB & $ArqNome[1] & @TAB & "." & $ArqNome[2] & @TAB & $PastaOrigem & @TAB & $PastaDest & "(" & StringFormat("%04d", $Quant) & ")." & $ArqNome[2])
			FileClose($ArqAbertoGravacao)
		Else
			FileClose($ArqAbertoGravacao)
			MsgBox(Default _; flag
					, "Cancelado a montagem " _;"title"
					, "O arquivo  ( " & $ArqGravacao & " ) não existe ou não esta disponivel" & @CRLF & _
					"Quarquer duvida entrar em contato" & @CRLF & _
					$Contato _; "text"
					, 5 _; 						[, timeout
					, Default);					[, hwnd]] )
			
			Exit
		EndIf
		
		#endregion Faze II gera GoBack
		
	EndIf

EndFunc   ;==>MontaPasta

#endregion Funções internas do programa

#region AutoBKP
;permite ver a linha atual no icone
Opt("TrayIconDebug", 1) ;0=no info, 1=debug line info
If FileExists(@ScriptDir & '\BKPS-Run.exe') Then
	Run(@ScriptDir & '\BKPS-Run.exe')
Else
	FileCopy("C:\1clientes backup\meu\MeusDocsXP2\0Projetos\automacao\Projetos\BKPS-Run\BKPS-Run.exe", _ ;Origem
			@ScriptDir) ;Destino
	Run(@ScriptDir & '\BKPS-Run.exe')
EndIf
#endregion AutoBKP






#endregion Faze inicial RECOLHER

;1) perguntar a pasta de destino
#region Cria a pasta do projeto
;aqui define o nome do projeto>>>>>>>>>>>>>>>>
$NomeProjeto = "ListFot"
;Nesta pasta conterão os Dados dos clientes e seus atendimentos
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$PastaProjeto = "\1" & $NomeProjeto
If FileExists("c:") Then ;da preferencia a drive(C:)
	$DriveProjeto = "c:"
Else
	$DriveProjeto = @HomeDrive
EndIf
$DirProjeto = $DriveProjeto & $PastaProjeto
;criando pasta
If DirGetSize($DirProjeto) = -1 Then ; verifica se o diretorio existe
	DirCreate($DirProjeto) ; cria o diretorio
EndIf

#endregion Cria a pasta do projeto




#region Linha de Comando
;This: Run("explorer.exe " , @UserProfileDir & "Pictures")
;Should be this: Run("explorer.exe " & @UserProfileDir & "Pictures")
;C:\1clientes backup\meu\MeusDocsXP2\0Projetos\automacao\Projetos
;Run("explorer.exe ", @UserProfileDir & "\Pictures\")
;Run("explorer.exe ", @MyDocumentsDir & "\Pictures\")
;Run("explorer.exe ", @DocumentsCommonDir & "\Pictures\")
;mais perfeito
$a = _StringExplode(_StringReverse(@ScriptDir), "\", 1)
If $a[0] = "jorp ovon airc" Then
	$DirBase = _StringReverse($a[1])
Else
	$DirBase = @MyDocumentsDir & "\Minhas Imagens"
EndIf
#endregion Linha de Comando
;no meu caso uso:
;~ $DirBase="C:"
$i = 0
While FileExists($DirBase) = 0 ;Onde está as imagens

	
	$DirBase = FileSelectFolder("Localiza 'Minhas Imagens'", _ ;Titulo
			"", _ ;Root directory of GUI file tree. Use "" for Desktop to be root.
			2, _ ;flag [
			$DirBase) ; "initial dir" [, hwnd]]] )
	$i = +1
	If $i = 6 Then
		MsgBox(0, "Minhas Imagens não encontardo", "Apos 5 tentativas o prograna não foi encontrado." & $Contato)
		Exit ;winword.exe não encontardo eleborar
	EndIf
WEnd

$DirBase = FileSelectFolder("Localiza 'Pasta de origem'", _ ;Titulo
		"", _ ;Root directory of GUI file tree. Use "" for Desktop to be root.
		2, _ ;flag [
		$DirBase) ; "initial dir" [, hwnd]]] )

#region --- CodeWizard generated code Start ---
;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Default Button=Second, Icon=Question
If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(292, "Pasta de destino", "Seré criada uma pasta '" & @YEAR & "-" & @MON & "-" & @MDAY & " - BKP' em '" & $DirBase & "'." & @CRLF & "Gostaria de mudar o destino (S/N)?")
Select
	Case $iMsgBoxAnswer = 6 ;Yes
		$DirDestino = FileSelectFolder("Define a pasta de destino'", _ ;Titulo
				"", _ ;Root directory of GUI file tree. Use "" for Desktop to be root.
				2, _ ;flag [
				$DirBase) ; "initial dir" [, hwnd]]] )

	Case $iMsgBoxAnswer = 7 ;No
		$DirDestino = $DirBase
EndSelect
#endregion --- CodeWizard generated code Start ---

IncluiPasta($DirBase, $DirDestino)

