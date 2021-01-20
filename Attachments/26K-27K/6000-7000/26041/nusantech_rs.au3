;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Nusantara Technologies (azrudi@nusantech.com)
;
; Script Function:
;   Plays with RapidShare.
;



#include <HTTP.au3>

$file = FileOpen("rs.txt",0)
$counter = 1

;Check if file opened for reading OK
If $file = -1 Then
MsgBox(0, "Error", "Unable to open file.")
Exit
EndIf


;Read in lines of text until the EOF is reached
Dim $sRet, $aMatch, $iTmp, $sTmp

While 1
$alamat = FileReadLine($file)
If @error = -1 Then ExitLoop

$mula=StringInStr($alamat,'rapidshare.com')+14
if $mula=14 Then 
		$mula=StringInStr($alamat,'rapidshare.de')+13
		If $mula=13 Then OhBoy("Server Not Found!")
	EndIf
	
$bilang=StringLen($alamat)-$mula+1
$sPage=StringMid($alamat,$mula,$bilang)

$sHost='rs69.rapidshare.com'
$sHTTP= _HTTPConnect($sHost)
if @error Then Exit

_HTTPPost($sHost, $sPage, $sHTTP, 'dl.start=Free')
$sRet = _HTTPRead($sHTTP)
If $sRet = '' Then OhBoy(1)

If StringRegExp($sRet, '(?i)<h1>error</h1>') Then OhBoy('You have reached the download limit for free-users')

$aMatch = StringRegExp($sRet, '(?i)var c\s*=\s*(\d+);', 1)
If Not IsArray($aMatch) Then OhBoy(2)

$iTmp = Int($aMatch[0])
$aMatch = StringRegExp($sRet, "(?i)document\.dlf\.action=\\'([^']*)\\", 1)
If Not IsArray($aMatch) Then OhBoy(3)

$sTmp = $aMatch[0]
$aMatch = StringRegExp($sRet, '(?i)(\d+)\s+kb', 1)
If Not IsArray($aMatch) Then OhBoy(4)

For $i = $iTmp To 1 Step -1
    ToolTip(@TAB & $i, @DesktopWidth-100, 0, 'Waiting...', 1)
    Sleep(1000)
Next
ToolTip('')

$iTmp = Int($aMatch[0])
ProgressOn('Downloading "' & $sTmp & '"', 'Please wait while downloading the file')

InetGet($sTmp, @ScriptDir & '\' &  StringTrimLeft($sTmp, StringInStr($sTmp, '/', 0, -1)), 1, 1)

While @InetGetActive
    Local $iKBRead = @InetGetBytesRead/0x400
    Local $iPrcnt = Round(100*$iKBRead/$iTmp)
    ProgressSet($iPrcnt, $iKBRead & '/' & $iTmp & ' KB')
    Sleep(200)
WEnd

ProgressOff()
_HTTPClose($sHTTP)




$i = 0
while $i < $counter
$i = $i + 1
Wend

$counter = $counter + 1

Wend

FileClose($file)

Func OhBoy($sStr = 'Unknown')
    MsgBox(0x10, 'Error!', $sStr)
    _HTTPClose($sHTTP)
    Exit
EndFunc
