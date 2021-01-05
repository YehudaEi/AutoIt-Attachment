; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         Alexischeng <alexischengl@netvigator.com>
;
; Script Function:
;	Change pagefile size
;	$init = init size
;	$max = maximum size (4095 max)
;	Remark :	Reboot to take effect
; ----------------------------------------------------------------------------

$init="3000"
$max="4095"
$par1="c:\pagefile.sys "&$init&" "&$max
$keyname="HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
$valuename="PagingFiles"
RegWrite($keyname, $valuename, "REG_MULTI_SZ", $par1)

