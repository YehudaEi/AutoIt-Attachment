Opt("TrayMenuMode",1)
Opt ( "RunErrorsFatal", 0 )
$ini = "Installer.ini"
$var = IniReadSection("Installer.ini", "Commands")
If @error Then
	Exit
Else
	For $i = 1 To $var[0][0]
		$tip = IniRead ( $ini , "Tips", $var[$i][0], "" )
		RunWait ( $var[$i][1] , @ScriptDir , @SW_MINIMIZE )
		TrayTip("",$tip,$i,0)
		Sleep($i)
	Next
EndIf
