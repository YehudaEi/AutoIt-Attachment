#include-once
#include <File.au3>
; #INDEX# =======================================================================================================================
; Title .........: GetMac
; AutoIt Version: 33.0
; Language:       English
; Description ...: Functions MAC Address of first no disconnected NIC.
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_getmac
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _Getmac
; Description ...: Returns the first active physical MAC Address.
; Syntax.........: _Getmac
; Parameters ....: None
; Return values .: Success - Returns MAC Address.
;                  
; Author ........: Richard Easton <rich.easton@gmail.com>
; Modified.......:
; Remarks .......: Tested on XP and Vista.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _GetMAC()
	local $mac
	
$PC = @ComputerName & ".tmp"
if fileexists($pc) then 
	filedelete($pc)
EndIf

Run(@ComSpec & " /c " & 'getmac >> ' & $PC, "", @SW_HIDE)


$i = _FileCountLines($pc)

$line = 0
Do
	$info = filereadline($PC, $line)
	if  $info = "" or StringInStr($info, "Physical", 0) or StringInStr($info, "===================", 0) or StringInStr($info, "Media disconnected", 0) then 
		sleep(1000)
		$line = $line +1
	else
		$mac = stringleft(FileReadLine($pc, $line), 17)
		$line = $i
		filedelete($pc)
		Return $mac
	EndIf
		
until $line = $i
EndFunc

