#NoTrayIcon
#include "APIFileReadWrite.au3"

Global $pole_hodnot[1][3] ; adresa, puv. hodnota, nova hodnota

If $CmdLine[0] = 0 Or $CmdLine[1] = '/?' Then
	Napoveda()
	Exit
EndIf

If $CmdLine[0] <> 2 Then
	MsgBox(48,"Chyba","Chybne zadane parametry!" & @CRLF & "Pro napovedu zadejte parametr /?")
	Exit
EndIf

$soubor = $CmdLine[2]
$soubor_txt = $CmdLine[2] ; .txt

$i = StringInStr($soubor_txt,'.',0,-1) ; najit prvni tecku zprava
If $i > 0 Then
	$pripona = StringMid($soubor_txt,$i)
	$soubor_txt = StringReplace($soubor_txt,$pripona,'.txt')
Else
	$soubor_txt = $soubor & '.txt'
EndIf

If Not FileExists($soubor) Then
	MsgBox(48,"Chyba","Nenalezen zadany soubor " & $soubor)
	Exit
EndIf

If Not FileExists($soubor_txt) Then
	MsgBox(48,"Chyba","Nenalezen definicni TXT soubor " & $soubor_txt)
	Exit
EndIf

$prikaz = StringUpper($CmdLine[1])

If $prikaz = "/K" Then
	Kontrola('K')
ElseIf $prikaz = "/P" Then
	Patch()
ElseIf $prikaz = "/Z" Then
	Zpet()
Else
	MsgBox(48,"Chyba","Chybne zadane parametry!" & @CRLF & "Pro napovedu zadejte parametr /?")
	Exit
Endif

; nacist seznam adres a puv/novych hodnot z definicniho souboru do glob. pole
Func NactiDef()
	Local $pole_radku, $pocet
	
	_FileReadToArray($soubor_txt, $pole_radku)
	If @error Then
		MsgBox(48,"Chyba","Chyba pri otvirani definicniho souboru " & $soubor_txt)
		Exit
	EndIf
	
	$pocet = $pole_radku[0]
	If $pocet = 0 Then
		MsgBox(48,"Chyba","Definicni soubor " & $soubor_txt & " je prazdny")
		Exit
	EndIf
	
	ReDim $pole_hodnot[$pocet + 1][3]
	$pole_hodnot[0][0] = $pocet
	
	For $i = 1 To $pocet
		$radek = StringStripWS($pole_radku[$i],3)
		
		$radek = StringSplit($radek, ' ') ; 00000073: 65 FC
		If $radek[0] <> 3 Then
			MsgBox(48,"Chyba","Definicni soubor " & $soubor_txt & " obsahuje chybna data")
			Exit
		EndIf
		
		$radek[1] = StringTrimRight($radek[1], 1) ; odstranit znak :
		$pole_hodnot[$i][0] = $radek[1]
		$pole_hodnot[$i][1] = $radek[2]
		$pole_hodnot[$i][2] = $radek[3]
	Next
EndFunc	

; co: 'P'-patch 'Z'-zpet 'K' --> zda kontrolovat puvodni nebo novou hodnotu anebo vse (pri K)
Func Kontrola($co)
	Local $pocet, $pocet_puv, $pocet_new
	
	NactiDef()
	
	$f = _APIFileOpen($soubor)
	If $f <= 0 Then
		MsgBox(48,"Chyba","Chyba pri otvirani souboru " & $soubor)
		Exit
	EndIf
	
	$pocet = $pole_hodnot[0][0]
	For $i = 1 To $pocet
		_APIFileSetPos($f, Dec($pole_hodnot[$i][0]))
		$data = _APIFileRead($f,1,1)
		If $co = 'P' Then
			$data_def = $pole_hodnot[$i][1] ; kontrolovat puv. hodnotu
		ElseIf $co = 'Z' Then
			$data_def = $pole_hodnot[$i][2] ; kontrolovat novou hodnotu
		EndIf
			
		If $co <> 'K' Then
			If $data <> $data_def Then
				MsgBox(48,"Chyba","Data v souboru neodpovidaji definicnimu souboru:" & @CRLF & _
									'soubor:   ' & $pole_hodnot[$i][0] & ': ' & $data & @CRLF & _
									'definice: ' & $pole_hodnot[$i][0] & ': ' & $pole_hodnot[$i][1] & ' ' & $pole_hodnot[$i][2])
				Exit
			EndIf
		Else
			If $data = $pole_hodnot[$i][1] Then $pocet_puv = $pocet_puv + 1
			If $data = $pole_hodnot[$i][2] Then $pocet_new = $pocet_new + 1
		EndIf
	Next

	_APIFileClose($f)
	
	If $co = 'K' Then
		If $pocet_puv = $pocet Then $hlaseni = " odpovida puvodnimu souboru"
		If $pocet_new = $pocet Then $hlaseni = " odpovida opravenemu souboru"
		If $pocet_puv <> $pocet And $pocet_new <> $pocet Then $hlaseni = " neodpovida ani puvodnimu ani opravenemu souboru"
		
		MsgBox(64,"Kontrola","Soubor " & $soubor & $hlaseni & @CRLF & _
							'dle definice v souboru ' & $soubor_txt)
	EndIf
EndFunc

; co: 'P'-patch 'Z'-zpet --> zda zapisovat puvodni nebo novou hodnotu
Func Zapis($co)
	$f = _APIFileOpen($soubor)
	If $f <= 0 Then
		MsgBox(48,"Chyba","Chyba pri otvirani souboru " & $soubor)
		Exit
	EndIf
	
	For $i = 1 To $pole_hodnot[0][0]
		_APIFileSetPos($f, Dec($pole_hodnot[$i][0]))
		If $co = 'P' Then
			$data_def = $pole_hodnot[$i][2] ; zapsat novou hodnotu
		ElseIf $co = 'Z' Then
			$data_def = $pole_hodnot[$i][1] ; zapsat puv. hodnotu
		EndIf
			
		$zapsano = _APIFileWrite($f,$data_def,1)
		If $zapsano <> 1 Then
			MsgBox(48,"Chyba","Chyba pri zapisu do souboru " & $soubor)
			Exit
		EndIf
	Next

	_APIFileClose($f)
EndFunc

Func Patch()
	Kontrola('P')
	Zapis('P')
EndFunc

Func Zpet()
	Kontrola('Z')
	Zapis('Z')
EndFunc

Func Napoveda()
	MsgBox(0,"Napoveda", _
		'PATCH 1.0 - program pro provedeni/kontrolu patche' & @CRLF & _
		'' & @CRLF & _
		'jako vst. parametry ocekava:' & @CRLF & _
		'- prikaz co delat /K kontrola nebo /P patch nebo /Z zpet' & @CRLF & _
		'- jmeno souboru pro provedeni/kontrolu patche' & @CRLF & _
		'' & @CRLF & _
		'dale musi existovat TXT soubor stejneho jmena jako soubor pro patch' & @CRLF & _
		'se seznamem adres a hodnot ve tvaru (kompatibilita s vysledkem z FC.EXE):' & @CRLF & _
		'hexa pozice1: puv. hexa hodnota1 nova hexa hodnota1' & @CRLF & _
		'hexa pozice2: puv. hexa hodnota2 nova hexa hodnota2' & @CRLF & _
		'...'  & @CRLF & _
		'hexa poziceN: puv. hexa hodnotaN nova hexa hodnotaN' & @CRLF & _
		'' & @CRLF & _
		'priklady:' & @CRLF & _
		'1) patch /K pokus.exe' & @CRLF & _
		'2) patch /P pokus.exe' & @CRLF & _
		'3) patch /Z pokus.exe' & @CRLF & _
		'' & @CRLF & _
		'pokus.txt:' & @CRLF & _
		'00000073: 65 FC' & @CRLF & _
		'001B4FE8: 24 40' & @CRLF & _
		'' & @CRLF & _
		'prikaz /Z zpet provede patch opacnym smerem, tzn. z nove hodnoty na puvodni')
EndFunc
	
Func _FileReadToArray($sFilePath, ByRef $aArray)
	Local $hFile
	
	$hFile = FileOpen($sFilePath, 0)
	
	If $hFile = -1 Then
		SetError(1)
		Return 0
	EndIf
	
	$aArray = StringStripCR( FileRead($hFile, FileGetSize($sFilePath)))
	
	; prip. odstranit posledni @CRLF aby nebyl v poli posledni prazdny radek
	If StringRight($aArray,1) = @LF Then $aArray = StringTrimRight($aArray,1)
	$aArray = StringSplit( $aArray, @LF)
	
	FileClose($hFile)
	Return 1
EndFunc
