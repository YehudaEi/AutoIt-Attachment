#include <INet.au3>
#NoTrayIcon
$scriptversion = "0,0"
$config = "                                      "
$configDo = _INetGetSource($config)
$size = InetGetSize ( "                                   " )


InetGet ( $config ,@tempDir & "\tmpconfig.txt" ,1 )

$s_Version = IniRead(@tempDir & "\tmpconfig.txt","Config","version",0)

If $s_Version > $scriptversion Then
    Msgbox(0,"Error","The verson of this file is "&$scriptversion&" and the new update is "&$s_Version&" the script will now update the new file is "&$size&" bytes big.",5)
	InetGet ( "                                   ", @TempDir & "\tmplan.exe" )
	$coppy=FileCopy ( @TempDir & "\tmplan.exe", @ScriptFullPath , 9 )
	If $coppy = 1 then 
		msgbox(0,"adad","the update was a success")
	Else 
		msgbox(0,"adad","the update was a unsuccessfull")
	EndIf
Else
    Msgbox(0,"The version is:",$s_Version)
EndIf