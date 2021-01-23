#NoTrayIcon
#include "APIFileReadWrite.au3"

Global $a_values[1][3] ; address, orig. value, new value

If $CmdLine[0] = 0 Or $CmdLine[1] = '/?' Then
	Help()
	Exit
EndIf

If $CmdLine[0] <> 2 Then
	MsgBox(48,"Error","Bad arguments!" & @CRLF & "For help type parameter /?")
	Exit
EndIf

$file = $CmdLine[2]
$file_txt = $CmdLine[2] ; .txt

$i = StringInStr($file_txt,'.',0,-1) ; find first dot from right
If $i > 0 Then
	$ext = StringMid($file_txt,$i)
	$file_txt = StringReplace($file_txt,$ext,'.txt')
Else
	$file_txt = $file & '.txt'
EndIf

If Not FileExists($file) Then
	MsgBox(48,"Error","File not found: " & $file)
	Exit
EndIf

If Not FileExists($file_txt) Then
	MsgBox(48,"Error","Definition TXT file not found: " & $file_txt)
	Exit
EndIf

$command = StringUpper($CmdLine[1])

If $command = "/K" Then
	Test('K')
ElseIf $command = "/P" Then
	Patch()
ElseIf $command = "/Z" Then
	Undo()
Else
	MsgBox(48,"Error","Bad arguments!" & @CRLF & "For help type parameter /?")
	Exit
Endif

; load list of addresses and orig/new values from definition file into glob. array
Func LoadDef()
	Local $a_lines, $count
	
	_FileReadToArray($file_txt, $a_lines)
	If @error Then
		MsgBox(48,"Error","Error while opening definition file " & $file_txt)
		Exit
	EndIf
	
	$count = $a_lines[0]
	If $count = 0 Then
		MsgBox(48,"Error","Definition file " & $file_txt & " is empty")
		Exit
	EndIf
	
	ReDim $a_values[$count + 1][3]
	$a_values[0][0] = $count
	
	For $i = 1 To $count
		$line = StringStripWS($a_lines[$i],3)
		
		$line = StringSplit($line, ' ') ; 00000073: 65 FC
		If $line[0] <> 3 Then
			MsgBox(48,"Error","Definition file " & $file_txt & " contains bad data")
			Exit
		EndIf
		
		$line[1] = StringTrimRight($line[1], 1) ; remove char :
		$a_values[$i][0] = $line[1]
		$a_values[$i][1] = $line[2]
		$a_values[$i][2] = $line[3]
	Next
EndFunc	

; what: 'P'-patch 'Z'-undo 'K' --> whether test original or new value or all (when K)
Func Test($what)
	Local $count, $count_puv, $count_new
	
	LoadDef()
	
	$f = _APIFileOpen($file)
	If $f <= 0 Then
		MsgBox(48,"Error","Error while opening file " & $file)
		Exit
	EndIf
	
	$count = $a_values[0][0]
	For $i = 1 To $count
		_APIFileSetPos($f, Dec($a_values[$i][0]))
		$data = _APIFileRead($f,1,1)
		If $what = 'P' Then
			$data_def = $a_values[$i][1] ; test orig. value
		ElseIf $what = 'Z' Then
			$data_def = $a_values[$i][2] ; test new value
		EndIf
			
		If $what <> 'K' Then
			If $data <> $data_def Then
				MsgBox(48,"Error","Data in file are not corresponding to definition file:" & @CRLF & _
									'file:       ' & $a_values[$i][0] & ': ' & $data & @CRLF & _
									'definition: ' & $a_values[$i][0] & ': ' & $a_values[$i][1] & ' ' & $a_values[$i][2])
				Exit
			EndIf
		Else
			If $data = $a_values[$i][1] Then $count_puv = $count_puv + 1
			If $data = $a_values[$i][2] Then $count_new = $count_new + 1
		EndIf
	Next

	_APIFileClose($f)
	
	If $what = 'K' Then
		If $count_puv = $count Then $text = " match to original file"
		If $count_new = $count Then $text = " match to corrected file"
		If $count_puv <> $count And $count_new <> $count Then $text = " doesn't match neither original nor corrected file"
		
		MsgBox(64,"Test","File " & $file & $text & @CRLF & _
							'by definition from file ' & $file_txt)
	EndIf
EndFunc

; what: 'P'-patch 'Z'-undo --> whether write original or new value
Func WriteData($what)
	$f = _APIFileOpen($file)
	If $f <= 0 Then
		MsgBox(48,"Error","Error while opening file " & $file)
		Exit
	EndIf
	
	For $i = 1 To $a_values[0][0]
		_APIFileSetPos($f, Dec($a_values[$i][0]))
		If $what = 'P' Then
			$data_def = $a_values[$i][2] ; write new value
		ElseIf $what = 'Z' Then
			$data_def = $a_values[$i][1] ; write orig. value
		EndIf
			
		$written = _APIFileWrite($f,$data_def,1)
		If $written <> 1 Then
			MsgBox(48,"Error","Error while writing to file " & $file)
			Exit
		EndIf
	Next

	_APIFileClose($f)
EndFunc

Func Patch()
	Test('P')
	WriteData('P')
EndFunc

Func Undo()
	Test('Z')
	WriteData('Z')
EndFunc

Func Help()
    MsgBox(0,"Help", _
        'PATCH 1.0 - program to make/test patch' & @CRLF & _
        '' & @CRLF & _
        'input parametres:' & @CRLF & _
        '- command what to do /K test or /P patch or /Z undo' & @CRLF & _
        '- name of file to be patched' & @CRLF & _
        '' & @CRLF & _
        'also must exist TXT file of the same name like file to be patched' & @CRLF & _
        'with list of adresses and values in this form (compatible with output from FC.EXE):' & @CRLF & _
        'hexa position1: orig. hexa value1 new hexa value1' & @CRLF & _
        'hexa position2: orig. hexa value2 new hexa value2' & @CRLF & _
        '...'  & @CRLF & _
        'hexa positionN: orig. hexa valueN new hexa valueN' & @CRLF & _
        '' & @CRLF & _
        'examples:' & @CRLF & _
        '1) patch /K test.exe' & @CRLF & _
        '2) patch /P test.exe' & @CRLF & _
        '3) patch /Z test.exe' & @CRLF & _
        '' & @CRLF & _
        'test.txt:' & @CRLF & _
        '00000073: 65 FC' & @CRLF & _
        '001B4FE8: 24 40' & @CRLF & _
        '' & @CRLF & _
        'command /Z undo will do reverse patch, from new value to old one')
EndFunc

Func _FileReadToArray($sFilePath, ByRef $aArray)
	Local $hFile
	
	$hFile = FileOpen($sFilePath, 0)
	
	If $hFile = -1 Then
		SetError(1)
		Return 0
	EndIf
	
	$aArray = StringStripCR( FileRead($hFile, FileGetSize($sFilePath)))
	
	; eventually remove last @CRLF to not have last empty line in array
	If StringRight($aArray,1) = @LF Then $aArray = StringTrimRight($aArray,1)
	$aArray = StringSplit( $aArray, @LF)
	
	FileClose($hFile)
	Return 1
EndFunc
