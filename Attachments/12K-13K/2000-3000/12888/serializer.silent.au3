; ----------------------------------------------------------------------------
; Author:         Noobster24 (andreas_vliegen [AT] hotmail [DOT] com)
;
; Script Function:
;	Search for the licenses registrations on this computer for:
;   Nero - Windows - Office - Alcohol 120% - Call of Duty 1 & 2 - mIRC - Partition Magic - OmniPage - Sony Vegas/Video Capture - TuneUP Utilities
; ----------------------------------------------------------------------------

; ------------------- Included Files ----------------------------------
#NoTrayIcon
#include <GuiConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <String.au3>
#include <Date.au3>

; ------------------- Variables and globals ----------------------------------
Global $inifile = @ScriptDir & '\serializer_software.ini'

; ------------------- Dim etc.----------------------------------
Dim $Bin
Dim $key4RegisteredOwner = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion'

; ------------------- Functions ----------------------------------

	$Bin = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion','DigitalProductID') ;(Thanks to Thorsten Meger)
	$objWMIService = ObjGet('winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2') ;(Thanks to Thorsten Meger)
	$colSettings = $objWMIService.ExecQuery ('Select * from Win32_OperatingSystem')		;(Thanks to Thorsten Meger)
	For $objOperatingSystem In $colSettings
	Next
	$text2txt = 'Created by teh Serializer' & @CRLF & 'Date: ' & _Now() & @CRLF & '==========================' & @CRLF & 'Product Name: M$ Windows' & @CRLF & 'User/ID: ' & StringMid($objOperatingSystem.SerialNumber, 1) & @CRLF & 'Serial: ' & DecodeProductKey($Bin) & @CRLF & @CRLF & 'Product Name: M$ Internet Explorer' & @CRLF & 'User/ID: ' & RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration','ProductID') & @CRLF & 'Serial: ' & DecodeProductKey(RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration','DigitalProductID')) & @CRLF & @CRLF
	$text2txt2 = ''
	$text2txt3 = ''
	$text2txt4 = ''
	$iniread = IniRead($inifile,'Program','Total',10)	
	Dim $regread[$iniread+1], $regname[$iniread+1], $officekey[$iniread+1], $regread2[$iniread+1], $inireadname[$iniread+1], $inireadread[$iniread+1], $inireadreadkey[$iniread+1], $inireadreadkey2[$iniread+1], $inireadenumkey[$iniread+1], $inireaduser[$iniread+1], $inireaduser2[$iniread+1], $inireaduser3[$iniread+1], $inireaduser4[$iniread+1]
	For $i = 1 TO $iniread
	$inireadname[$i] = IniRead($inifile,$i,'Name',@error)
	$inireadread[$i] = IniRead($inifile,$i,'Read',@error)
	$inireadreadkey[$i] = IniRead($inifile,$i,'Readkey',@error)
	$inireaduser[$i] = IniRead($inifile,$i,'Userkey',@error)
	$regread[$i] = RegRead($inireadread[$i],$inireadreadkey[$i])
	$regread2[$i] = RegRead($inireadread[$i],$inireaduser[$i])
	If $inireadreadkey[$i] = '(|1|)' Then
		$inireadreadkey2[$i] = IniRead($inifile,$i,'Readkey2',@error)
		$inireadenumkey[$i] = RegEnumKey($inireadread[$i], 1)
		$officekey[$i] = RegRead($inireadread[$i] & '\' & $inireadenumkey[$i], 'DigitalProductID')
		$regname[$i] = RegRead($inireadread[$i] & '\' & $inireadenumkey[$i], 'ProductID')
		If Not $officekey[$i] = '' Then	$text2txt2 &= 'Product Name: ' & $inireadname[$i] & @CRLF & 'User/ID: ' & $regname[$i] & @CRLF & 'Serial: ' & DecodeProductKey($officekey[$i]) & @CRLF & @CRLF
	ElseIf $inireaduser[$i] = '(|2|)' Then
		$inireaduser2[$i] = IniRead($inifile,$i,'UserKey2',@error)
		$inireaduser3[$i] = IniRead($inifile,$i,'UserKey3',@error)
		$inireaduser4[$i] = RegRead($inireaduser2[$i],$inireaduser3[$i])										   
		If Not $inireaduser4[$i] = '' Then $text2txt3 &= 'Product Name: ' & $inireadname[$i] & @CRLF & 'User/ID: ' & $inireaduser4[$i] & @CRLF & 'Serial: ' & $regread[$i] & @CRLF & @CRLF
	Else								
		If Not $regread[$i] = '' Then $text2txt4 &= 'Product Name: ' & $inireadname[$i] & @CRLF & 'User/ID: ' & $regread2[$i] & @CRLF & 'Serial: ' & $regread[$i] & @CRLF & @CRLF
	EndIf
Next	

	$file2writetxt = @ScriptDir & '\serializer.txt'		
	QuickOutput($file2writetxt, $text2txt&$text2txt2&$text2txt3&$text2txt4, 2)
	Run('notepad.exe ' & $file2writetxt)
				
Func DecodeProductKey($BinaryDPID)
   Local $bKey[15]
   Local $sKey[29]
   Local $Digits[24]
   Local $Value = 0
   Local $hi = 0
   local $n = 0
   Local $i = 0
   Local $dlen = 29
   Local $slen = 15
   Local $Result

   $Digits = StringSplit('BCDFGHJKMPQRTVWXY2346789','')

   $binaryDPID = stringmid($binaryDPID,105,30)

   For $i = 1 to 29 step 2
       $bKey[int($i / 2)] = dec(stringmid($binaryDPID,$i,2))
   next

   For $i = $dlen -1 To 0 Step -1
       If Mod(($i + 1), 6) = 0 Then
           $sKey[$i] = '-'
       Else
           $hi = 0
           For $n = $slen -1 To 0 Step -1
               $Value = Bitor(bitshift($hi ,- 8) , $bKey[$n])
               $bKey[$n] = int($Value / 24)
               $hi = mod($Value , 24)
           Next
           $sKey[$i] = $Digits[$hi +1]
       EndIf

   Next
   For $i = 0 To 28
       $Result = $Result & $sKey[$i]
   Next

   Return $Result
EndFunc ;==>DecodeProductKey (Thanks to forum)

Func QuickOutput($Filename, $Output, $Mode)
    Local $File = FileOpen($Filename, $Mode)
    FileWriteLine($File, $Output)
    FileClose($File)
EndFunc ;==>QuickOutput