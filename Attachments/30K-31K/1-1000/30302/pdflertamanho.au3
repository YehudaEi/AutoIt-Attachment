#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WinAPI.au3>
#include <String.au3>

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <GUIListBox.au3>
#include <Constants.au3>
#include <StaticConstants.au3>
#include <GuiStatusBar.au3>


;Opt('MustDeclareVars', 1)
;$Debug_LB = False ; Check ClassName being passed to ListBox functions, set to True and use a handle to another control to see it work

$Pasta = ""
Local $aText[2] = ["Diretório", $Pasta]
Local $aParts[2] = [50, -1]
$ligtextos = Chr(10)
$selecao = 1
Global $ListaArquivos
$filtro = "*.pdf"

#region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Copia lista para clipboard ou copia lista com tamanho das páginas", 625, 445, 193, 125)
;$TreeView1 = GUICtrlCreateTreeView(16, 24, 161, 377)
;$generalitem = GUICtrlCreateTreeView(32, 16, 137, 209)
;$ListView1 = GUICtrlCreateListView("", 200, 24, 137, 385)
$Edit1 = GUICtrlCreateList("", 16, 1, 195, 345)
$StatusBar1 = _GUICtrlStatusBar_Create($Form1, $aParts, $aText)
GUICtrlSetData(-1, "")
$Button1 = GUICtrlCreateButton("Pasta", 16, 384, 97, 33, 0)
$Button2 = GUICtrlCreateButton("Limpa", 115, 384, 97, 33, 0)

$Input1 = GUICtrlCreateInput($ligtextos, 432, 88, 121, 21)
$Input2 = GUICtrlCreateInput($filtro, 16, 350, 121, 21)
$Label1 = GUICtrlCreateLabel("separador", 300, 88, 100, 17)
$Button3 = GUICtrlCreateButton("chr(13)", 448, 152, 81, 25, 0)
$Button4 = GUICtrlCreateButton("chr(10)", 448, 192, 81, 25, 0)
$Button5 = GUICtrlCreateButton("usar meu", 448, 232, 81, 25, 0)
$Button6 = GUICtrlCreateButton("tamanho PDF", 448, 332, 81, 25, 0)
$Label3 = GUICtrlCreateLabel("Cria lista com tamanho da página", 250, 332, 170, 17)
$Label4 = GUICtrlCreateLabel("dos pdf para colar no excel", 250, 352, 170, 17)
$Label5 = GUICtrlCreateLabel("Reinaldo - 14/04/2010", 500, 390, 150, 17)
$Label2 = GUICtrlCreateLabel(GUICtrlRead($Input1), 448, 270, 100, 25)
;GUICtrlSetData($Input2, $filtro)

GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Select
		Case $nMsg = $Button1
			_listar()
		Case $nMsg = $Button2
			_limpa()
		Case $nMsg = $Button3
			$selecao = 1
		Case $nMsg = $Button4
			$selecao = 2
		Case $nMsg = $Button5
			$selecao = 3
			GUICtrlSetData($Label2, GUICtrlRead($Input1))
		Case $nMsg = $Button6
			dim1e2()
		Case $nMsg = $GUI_EVENT_CLOSE
			ExitLoop

	EndSelect
WEnd



Func _listar()
	; escolhe pasta
	$Pasta = FileSelectFolder("Selecione a pasta...", "")

	; lista arquivos para matriz
	$filtro = GUICtrlRead($Input2)
	$ListaArquivos = _FileListToArray($Pasta, $filtro)
	If @error = 1 Then
		MsgBox(0, "", "Nenhuma Pasta encontrada.")
		Exit
	EndIf
	;_ArrayDisplay($ListaArquivos, "$ListaArquivos")

	; matriz para string

	$listatexto1 = _ArrayToString($ListaArquivos, "|")
	Select
		Case $selecao = 1
			$listatexto2 = _ArrayToString($ListaArquivos, Chr(10))
		Case $selecao = 2
			$listatexto2 = _ArrayToString($ListaArquivos, Chr(13))
		Case $selecao = 3
			$listatexto2 = _ArrayToString($ListaArquivos, GUICtrlRead($Input1))
	EndSelect
	ClipPut($listatexto2)

	;MsgBox(0, "_ArrayToString() getting $avArray items 1 to 7", _ArrayToString($ListaArquivos, "|"))
	GUICtrlSetData($Edit1, $listatexto1)
	_GUICtrlStatusBar_SetText($StatusBar1, $Pasta, 1)


EndFunc   ;==>_listar

Func _limpa()
	$Pasta = ""
	$ListaArquivos = ""
	$listatexto1 = ""
	$listatexto2 = ""
	GUICtrlSetData($Edit1, $listatexto1)
	_GUICtrlStatusBar_SetText($StatusBar1, $Pasta, 1)
EndFunc   ;==>_limpa






Func dim1e2()
	Dim $xx[$ListaArquivos[0] + 1]
	Dim $yy[$ListaArquivos[0] + 1]
	$tttt = ""
	For $ii = 1 To $ListaArquivos[0] Step 1
		$TestFile_Path = $Pasta & "\" & $ListaArquivos[$ii]
		$bData = StringToBinary("MediaBox")
		;MsgBox(4096, Default, "texto:" & @CRLF & $TestFile_Path)
		;MsgBox(4096, Default, "texto:" & @CRLF & BinaryToString($bData))
		;## Procura o texto media box
		$Offset = _HexSearch($TestFile_Path, $bData)
		;MsgBox(4096, "HexSearch Function", "hex endereço: " & @CRLF & @TAB & $bData & @CRLF & "Result = 0x" & Hex($Offset, 3))
		$data = _HexRead($TestFile_Path, $Offset, '50') ; 50 is the lenght to read
		$data = StringTrimLeft($data, 2)
		$data = _HexToString($data)
		;MsgBox(4096, Default, "texto depois:" & @CRLF & $data)
		;ConsoleWrite($data & @CRLF)
		$dim1 = StringReplace($data, "MediaBox [0 0 ", "")
		$dim1 = StringReplace($dim1, "MediaBox[0 0 ", "")
		;MsgBox(4096, Default, "textocortado:" & @CRLF & $dim1)
		$posicao = StringInStr($dim1, "]")
		$dim1 = StringMid($dim1, 1, $posicao)
		$posicao = StringInStr($dim1, " ")
		$dim2 = StringMid($dim1, $posicao, StringLen($dim1))
		$dim2 = StringReplace($dim2, "]", "")
		$dim1 = StringMid($dim1, 1, $posicao)
		;MsgBox(4096, Default, "dimensões:" & @CRLF & $dim1 & "X" & $dim2)
		$xx[$ii] = Int($dim1) / 72 * 2.54 ; show in mm
		$yy[$ii] = Int($dim2) / 72 * 2.54 ; show in mm
		$tttt = $tttt & $ListaArquivos[$ii] & Chr(09) & $xx[$ii] & Chr(09) & $yy[$ii] & Chr(13)
	Next
	;_ArrayDisplay( $xx, "1" )
	;_ArrayDisplay( $yy, "2" )
	;_ArrayDisplay( $listaarquivos, "3" )
	ClipPut($tttt)
EndFunc   ;==>dim1e2

#region ;**** HexEdit Functions

Func _HexWrite($FilePath, $Offset, $BinaryValue)
	Local $Buffer, $ptr, $bLen, $fLen, $hFile, $Result, $Written

	;## Parameter Checks
	If Not FileExists($FilePath) Then Return SetError(1, @error, 0)
	$fLen = FileGetSize($FilePath)
	If $Offset > $fLen Then Return SetError(2, @error, 0)
	If Not IsBinary($BinaryValue) Then Return SetError(3, @error, 0)
	$bLen = BinaryLen($BinaryValue)
	If $bLen > $Offset + $fLen Then Return SetError(4, @error, 0)

	;## Place the supplied binary value into a dll structure.
	$Buffer = DllStructCreate("byte[" & $bLen & "]")

	DllStructSetData($Buffer, 1, $BinaryValue)
	If @error Then Return SetError(5, @error, 0)

	$ptr = DllStructGetPtr($Buffer)

	;## Open File
	$hFile = _WinAPI_CreateFile($FilePath, 2, 4, 0)
	If $hFile = 0 Then Return SetError(6, @error, 0)

	;## Move file pointer to offset location
	$Result = _WinAPI_SetFilePointerRR($hFile, $Offset)
	$err = @error
	If $Result = 0xFFFFFFFF Then
		_WinAPI_CloseHandle($hFile)
		Return SetError(7, $err, 0)
	EndIf

	;## Write new Value
	$Result = _WinAPI_WriteFile($hFile, $ptr, $bLen, $Written)
	$err = @error
	If Not $Result Then
		_WinAPI_CloseHandle($hFile)
		Return SetError(8, $err, 0)
	EndIf

	;## Close File
	_WinAPI_CloseHandle($hFile)
	If Not $Result Then Return SetError(9, @error, 0)
EndFunc   ;==>_HexWrite

Func _HexRead($FilePath, $Offset, $Length)
	Local $Buffer, $ptr, $fLen, $hFile, $Result, $Read, $err, $Pos

	;## Parameter Checks
	If Not FileExists($FilePath) Then Return SetError(1, @error, 0)
	$fLen = FileGetSize($FilePath)
	If $Offset > $fLen Then Return SetError(2, @error, 0)
	If $fLen < $Offset + $Length Then Return SetError(3, @error, 0)

	;## Define the dll structure to store the data.
	$Buffer = DllStructCreate("byte[" & $Length & "]")
	$ptr = DllStructGetPtr($Buffer)

	;## Open File
	$hFile = _WinAPI_CreateFile($FilePath, 2, 2, 0)
	If $hFile = 0 Then Return SetError(5, @error, 0)

	;## Move file pointer to offset location
	$Pos = $Offset
	$Result = _WinAPI_SetFilePointerRR($hFile, $Pos)
	$err = @error
	If $Result = 0xFFFFFFFF Then
		_WinAPI_CloseHandle($hFile)
		Return SetError(6, $err, 0)
	EndIf

	;## Read from file
	$Read = 0
	$Result = _WinAPI_ReadFile($hFile, $ptr, $Length, $Read)
	$err = @error
	If Not $Result Then
		_WinAPI_CloseHandle($hFile)
		Return SetError(7, $err, 0)
	EndIf

	;## Close File
	_WinAPI_CloseHandle($hFile)
	If Not $Result Then Return SetError(8, @error, 0)

	;## Return Data
	$Result = DllStructGetData($Buffer, 1)

	Return $Result
EndFunc   ;==>_HexRead

Func _HexSearch($FilePath, $BinaryValue, $StartOffset = Default)
	Local $Buffer, $ptr, $hFile, $Result, $Read, $SearchValue, $Pos, $BufferSize = 2048

	;## Parameter Defaults
	If $StartOffset = Default Then $StartOffset = 0

	;## Parameter Checks
	If Not FileExists($FilePath) Then Return SetError(1, @error, 0)
	$fLen = FileGetSize($FilePath)
	If $StartOffset > $fLen Then Return SetError(2, @error, 0)
	If Not IsBinary($BinaryValue) Then Return SetError(3, @error, 0)
	If Not IsNumber($StartOffset) Then Return SetError(4, @error, 0)

	;## Prep the supplied binary value for search
	$SearchValue = BinaryToString($BinaryValue)

	;## Define the dll structure to store the data.
	$Buffer = DllStructCreate("byte[" & $BufferSize & "]")
	$ptr = DllStructGetPtr($Buffer)

	;## Open File
	$hFile = _WinAPI_CreateFile($FilePath, 2, 2, 1)
	If $hFile = 0 Then Return SetError(5, @error, 0)

	;## Move file pointer to offset location
	$Result = _WinAPI_SetFilePointerRR($hFile, $StartOffset)
	$err = @error
	If $Result = 0xFFFFFFFF Then
		_WinAPI_CloseHandle($hFile)
		Return SetError(5, $err, 0)
	EndIf

	;## Track the file pointer's position
	$Pos = $StartOffset

	;## Start Search Loop
	While True

		;## Read from file
		$Read = 0
		$Result = _WinAPI_ReadFile($hFile, $ptr, $BufferSize, $Read)
		$err = @error
		If Not $Result Then
			_WinAPI_CloseHandle($hFile)
			Return SetError(6, $err, 0)
		EndIf

		;## Prep read data for search
		$Result = DllStructGetData($Buffer, 1)
		$Result = BinaryToString($Result)

		;## Search the read data for first match
		$Result = StringInStr($Result, $SearchValue)
		If $Result > 0 Then ExitLoop

		;## Test for EOF and return -1 to signify value was not found
		If $Read < $BufferSize Then
			_WinAPI_CloseHandle($hFile)
			Return -1
		EndIf

		;## Value not found, Continue Tracking file pointer's position
		$Pos += $Read

	WEnd

	;## Close File
	_WinAPI_CloseHandle($hFile)
	If Not $Result Then Return SetError(7, @error, 0)

	;## Calculate the offset and return
	$Result = $Pos + $Result - 1
	Return $Result
EndFunc   ;==>_HexSearch

Func _WinAPI_SetFilePointerRR($hFile, $nDistance, $nMethod = 0)
	Local $nRet
	$nRet = DllCall("kernel32.dll", "dword", "SetFilePointer", "ptr", $hFile, "long", $nDistance, "ptr", 0, "dword", $nMethod)

	Return $nRet[0]
EndFunc   ;==>_WinAPI_SetFilePointerRR

#endregion ;**** HexEdit Functions