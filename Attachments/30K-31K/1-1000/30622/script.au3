 $WshShell = ObjCreate("WScript.Shell")
Func DefaultGateway()
	Local $Return
$Return = Empty
Dim $oDG, $oDGs, $WMI
 $WMI = ObjGet("winmgmts:\\.\root\cimv2")
 $oDGs = $WMI.ExecQuery _
("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=" TRUE")
For $oDG in $oDGs
If Not IsNull($oDG.DefaultIPGateway) And Not $oDG.defaultIPGateway(0) =  "0.0.0.0" Then
$Return = $oDG.DefaultIPGateway(0)
ExitLoop
EndIf
Next
	Return $Return
EndFunc
Select
Case StringSplit(DefaultGateway and  ".")( 0 )="172"
$nAble = 1
Case StringSplit(DefaultGateway and  ".")( 0 )="192"
$nAble = 0
EndSelect
$WshShell.RegWrite ("HKCU\software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyEnable", $nAble, "REG_DWORD")
$WshShell.RegWrite ("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyEnable", $nAble, "REG_DWORD")