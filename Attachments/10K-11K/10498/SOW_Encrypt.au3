;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~                               ;~~           ;~                     ;~
;~ AutoIt Version: 3.2.0.1        ;~~         ;~                     ;~
;~ Author:clearguy               ;~~           ;~~~~~~~~~~~~~~~~~~~~;
;~~                                ;~~~~~~~~~~~~~~~~~~~~~~~~~~;    ;~
;~~ Script Function:                                        ;~~     ;~
;~~	Secret Of Walhall:encrypt/decrypt a file with password.  ;~~   ;~
;~~                   Micro-encryption                      ;~~     ;~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~ 
;~Script Start 
#include <GUIConstants.au3> ;~~ 
#include <File.au3> ;~~ 
#include <String.au3> ;~~ 
Global $converted,$filepath,$CryptKeyLen,$ChrVal = 0,$ChrPeriodDiv ;~~ 
Global $PosInPeri = 0,$add = 0 ,$linetoread = 0,$termination ;~~ 
Global $counter = 0,$status = "Ready" ;~~ 
;~ GUI
Opt("GUIOnEventMode",1) ;~~ 
GUICreate("SOW Encrypt",250,220) ;~~ 
GUISetState(@SW_SHOW) ;~~ 
;~ Menu
$filemenu = GUICtrlCreateMenu ("&File") ;~~ 
$fileitem = GUICtrlCreateMenuitem ("Open",$filemenu) ;~~ 
GUICtrlSetState(-1,$GUI_DEFBUTTON)
$helpmenu = GUICtrlCreateMenu ("?") ;~~ 
$helpitem = GUICtrlCreateMenuitem ("About SOW...",$helpmenu) ;~~ 
;~ Progress
$progressbar = GUICtrlCreateProgress (2,170,245,10) ;~~ 
;~ Inputs
$inputfile = GUICtrlCreateInput("",5,26,190,20) ;~~ 
$outputfile = GUICtrlCreateInput("",5,80,190,20) ;~~ 
$input = GUICtrlCreateInput("",50,129,150,20) ;~~ 
;~ Buttons to bottom
$search = GUICtrlCreateButton("Search",200,26,40,19) ;~~ 
$search2 = GUICtrlCreateButton("Search",200,80,40,19) ;~~ 
$button = GUICtrlCreateButton("Encrypt",204,130,46,19) ;~~ 
$buttondecrypt = GUICtrlCreateButton("Decrypt",1,130,46,19) ;~~ 
;~ Lables
$stat = GUICtrlCreateLabel ($status,0,185,300,16,BitOr($SS_SIMPLE,$SS_SUNKEN)) ;~~ 
$percentage = GUICtrlCreateLabel("0%",120,149) ;~~ 
GUICtrlCreateLabel("File to encrypt/decrypt(full path)",10,5) ;~~ 
GUICtrlCreateLabel("File output(full path)",10,58) ;~~ 
GUICtrlCreateLabel("Crypt key(in lowercase):",10,108) ;~~ 
;~ OnEvents
GUISetOnEvent($GUI_EVENT_CLOSE,"close") ;~~ 
GUIctrlSetOnEvent($button,"encrypt") ;~~ 
GUIctrlSetOnEvent($buttondecrypt,"decrypt") ;~~ 
GUIctrlSetOnEvent($search,"choosefile") ;~~ 
GUIctrlSetOnEvent($search2,"choosefile2") ;~~ 
GUIctrlSetOnEvent($fileitem,"choosefile") ;~~ 
GUIctrlSetOnEvent($helpitem,"helpfile") ;~~ 

While 1 ;~~ 
	Sleep(1000);~ idle around
WEnd ;~~ 

Func close() ;~~ 
	Exit ;~~ 
EndFunc ;~~ 

Func encrypt()
	If FileExists(GUICtrlRead($outputfile)) Then ;~~ delete if file already exists
	FileDelete(GUICtrlRead($outputfile)) ;~~ 
	EndIf ;~~ 
	$word = GUICtrlRead($input);reads the crypt key
	
	If $word = "" Then;~~ verification if crypt key is present
		MsgBox(64,"SOW Encrypt","No crypt key");~~
		Exit;~~
	EndIf;~~
	$verif = StringIsLower ( $word ) ;~~ verification if crypt key is only lowercase
	If $verif = 0 Then ;~~ 
		MsgBox(64,"SOW Encrypt","Only lowercase characters!");~~
		Exit ;~~ 
	EndIf ;~~ 
	$filepath = GUICtrlRead($inputfile) ;~~ 
	$CryptKeyLen = StringLen ( GUICtrlRead($input) ) ;~~ 
	For $start = 1 To $CryptKeyLen;~~ conversion of the crypt key in numbers(alphabetical order) 
		 $toconvert = StringMid($word,$start,1) ;~~
		For $start2 = 97 To 122  ;~~ lowercase
			If $toconvert = Chr($start2) Then ;~~
				$converted = $converted &$start2 - 96 ;~~
				$converted = $converted&"," ;~~
			EndIf ;~~
		Next ;~~
	Next ;~~
	$converted = StringSplit($converted,",");~~ conversion end
	GenHexSource();~~ generates a file with the characters converted in hexa,at each line
	GenSOW()
	FileDelete(@WorkingDir&"\generated.hs");~~ deleting temp file
	GUICtrlSetData($stat,"Ready");~~ update progress
	$converted = 0 ;to avoid system errors
	GUICtrlSetData($progressbar,0);~~ update progress
	GUICtrlSetData($percentage,"0%");~~ update progress
	MsgBox(64,"SOW Encrypt","Encryption finished!") ;~~ tells that encryption is finished
EndFunc

Func decrypt()
	If FileExists(GUICtrlRead($outputfile)) Then ;~~deletes file if already exists
		FileDelete(GUICtrlRead($outputfile)) ;~~ 
	EndIf        ;~~ end 
	$word = GUICtrlRead($input);~~ reads the crypt key
	If $word = "" Then ;~~ tells if no key is typed
		MsgBox(64,"SOW Encrypt","No crypt key") ;~~ 
		Exit ;~~ 
	EndIf ;~~ 
	$filepath = GUICtrlRead($inputfile) ;~~ path to file to encrypt
	$CryptKeyLen = StringLen ( GUICtrlRead($input) );~~ length of the crypt key
	For $start = 1 To $CryptKeyLen ;~~ conversion of the crypt key in numbers(alphabetical order) 
		 $toconvert = StringMid($word,$start,1) ;~~
		For $start2 = 97 To 122 ;~~
			If $toconvert = Chr($start2) Then ;~~
				$converted = $converted &$start2 - 96;~~
				$ChrVal = $ChrVal + ($start2 - 96)  ;~~
				$converted = $converted&"," ;~~
			EndIf ;~~
		Next ;~~
	Next ;~~
	$converted = StringSplit($converted,",");~~conversion end
	$ChrPeriodDiv = $ChrVal + $CryptKeyLen;~~ calculates the CharPeriod divisor,used to divide the number of lines of en encrypted SOW file -
	UngenSOW()   ;~~ writes a HexSource file with the right data from a password encrypted SOW file          ;~~ - to know how much periods of password are in a file...
	UngenHexSource()  ;~~ writes the decrypted file with the HexSource
	GUICtrlSetData($stat,"Ready")  ;~~ progreass update
	FileDelete(@WorkingDir&"\HexSource.hs")  ;~~ deleting temp file
	$converted = 0  ;~~  to avoid system errors
	GUICtrlSetData($progressbar,0) ;~~ progress update
	GUICtrlSetData($percentage,"0%") ;~~ progress update
	MsgBox(64,"SOW Encrypt","File decrypted") ;~~ tells that decryption is finished
EndFunc ;~~ 

Func UngenHexSource();~~ writes the decrypted file with the HexSource
	GUICtrlSetData($stat,"Generating requested "& $termination &" file") ;~~ progress update
	$path = @WorkingDir&"\HexSource.hs" ;~~ 
	$outputpath = GUICtrlRead($outputfile) ;~~ 
	$lines = _FileCountLines($path) ;~~ 
	For $i = 1 To $lines ;~~ converts the hex's of the HexSource(HS) to a string ,then put it the decrypted file
		FileWrite($outputpath,_HexToString(FileReadLine($path,$i))) ;~~ 
		GUICtrlSetData($percentage,($i*100)/$lines&"%") ;~~ progress update
		GUICtrlSetData($progressbar,($i*100)/$lines) ;~~ progress update
	Next ;~~ end of conversion
EndFunc ;~~ 

Func UngenSOW();~~ writes a HexSource file with the right data from a password encrypted SOW file  
	GUICtrlSetData($stat,"Generating HexSource") ;~~  progress update
	$lines = _FileCountLines($filepath) ;~~ 
	$outputpath = @WorkingDir&"\HexSource.hs" ;~~ 
	$periods = $lines / $ChrPeriodDiv ;~~ calculates the amount of periods in an encrypted file
	$periods = Floor($periods) ;~~ 
	$remainder = Mod( $lines,$ChrPeriodDiv) ;~~ 
	If $remainder <> 0 Then ;~~ if there is a remainder,calculates the remainder rate of the las period
		For $i = 1 To $CryptKeyLen ;~~ 
			$add = $converted[$i] + $add + 1 ;~~ 
			If $remainder =  $add Then ;~~ 
				$PosInPeri = $i ;~~ 
				ExitLoop ;~~ 
			EndIf ;~~ 
		Next ;~~ 
	EndIf ;~~ end calculate
	For $i = 1 To $periods ;~~ writes a HexSource file (HS) with the right data of the SOW file(encrypted file)
		For $i2 = 1 To $CryptKeyLen ;~~ 
		$linetoread = $converted[$i2] + $linetoread + 1 ;~~ 
		FileWriteLine($outputpath,FileReadLine($filepath,$linetoread)) ;~~ 
	Next ;~~ 
	GUICtrlSetData($percentage,($i*100)/$periods&"%") ;~~ progress update
	GUICtrlSetData($progressbar,($i*100)/$periods) ;~~ progress update
Next ;~~ 
	If $PosInPeri <> 0 Then ;~~ if there is a non-complete period
		For $i = 1 To $PosInPeri ;~~ write the last right data
			$linetoread = $converted[$i] + $linetoread + 1 ;~~ 
			FileWriteLine($outputpath,FileReadLine($filepath,$linetoread)) ;~~ 
		Next ;~~ 
	EndIf ;~~ 
EndFunc ;~~ 

Func GenSOW()  ;~~ generates an encrypted file (SOW) with the HexSource
	GUICtrlSetData($stat,"Generating SOW file") ;~~ updates progress
	$lines = _FileCountLines(@WorkingDir&"\generated.hs") ;~~
	$outputpath = GUICtrlRead($outputfile) ;~~ path to output file,encrypted file (SOW)
	For $i=1 To $lines  ;~~ starts generation of SOW file
		$gold = FileReadLine(@WorkingDir&"\generated.hs",$i) ;~~
		$counter = $counter + 1  ;~~
		If $counter > $CryptKeyLen Then  ;~~
			$counter = 1  ;~~
		EndIf ;~~
		For $i2 = 1 To $converted[$counter] ;~~
			FileWriteLine($outputpath,_StringToHex(Chr(Random(0,255))) ) ;~~ wrong hex data
		Next ;~~
		FileWriteLine($outputpath,$gold) ;~~ the "gold" data,it's the data of the file to encrypt
		$percent = (100*$i)/$lines ;~~progress update
		GUICtrlSetData($percentage,$percent&"%") ;~~progress update
		GUICtrlSetData($progressbar,$percent) ;~~progress update
	Next ;~~
EndFunc ;~~

Func GenHexSource();~~ generates a file with the characters converted in hexa,at each line
	GUICtrlSetData($stat,"Generating HexSource")  ;~~ updates data in status bar
	$code = FileRead($filepath)   ;~~ reads the file to encrypt
	$length = StringLen(FileRead($filepath)) ;~~ length of the string of the file to encrypt
	For $start = 1 To $length   ;~~ starts to making the HexSource file(HS)
		$string = StringMid($code,$start,1) ;~~
		$string = _StringToHex($string) ;~~
		FileWriteLine(@WorkingDir&"\generated.hs",$string) ;~~ a temp file 
		$percent = (100*$start)/$length ;~~
		GUICtrlSetData($percentage,$percent&"%") ;~~updates progress
		GUICtrlSetData($progressbar,$percent) ;~~updates progress
	Next ;~~ end of HexSource generation
GUICtrlSetData($progressbar,0) ;~~
EndFunc ;~~


Func choosefile() ;~~ choose input file
	$file = FileOpenDialog("Choose file...",@WorkingDir,"All (*.*)") ;~~ 
	GUICtrlSetData($inputfile,$file) ;~~ 
	$verif = StringInStr($file,".sow") ;~~ 
	If $verif = 0 Then ;~~ 
		GUICtrlSetData($outputfile,@WorkingDir&"\encrypted.sow") ;~~ 
	Else ;~~ 
		$termination = InputBox("SOW Encrypt","What is the termination of the file you want to decrypt(not sow!,example:exe,jpg,txt,wma):") ;~~ 
		GUICtrlSetData($outputfile,@WorkingDir&"\decrypted." & $termination) ;~~ 
	EndIf ;~~ 
	If FileExists(GUICtrlRead($outputfile)) Then ;~~ 
		$response = MsgBox(4,"SOW Encrypt",(GUICtrlRead($outputfile)) &" exists already! Delete it?") ;~~ 
		If $response = 6 Then ;~~ 
			FileDelete((GUICtrlRead($outputfile)))  ;~~ 
		EndIf ;~~ 
		If $response = 7 Then ;~~ 
			MsgBox(0,"SOW Encrypt","Please change the name of the output file before starting encryption/decryption")  ;~~ 
		EndIf ;~~ 
	EndIf ;~~ 
EndFunc ;~~ 
	
Func choosefile2() ;~~ chose output file
	$file = FileOpenDialog("Choose file...",@WorkingDir,"All (*.*)") ;~~ 
	GUICtrlSetData($outputfile,$file) ;~~ 
EndFunc ;~~ 

Func helpfile() ;~~ 
	MsgBox(0,"SOW Encrypt -Secret Of Walhall","SOW Encrypt is a little script made by my own,it can encode all possible files:txt,images,exe,all!First it generates a HexSource,with each character at each line converted in hex than spread each HS character in a marsh of randomly generated hex's and that in the order the password gives.                            ~~Clearguy~~") ;~~ 
EndFunc ;~~ 
