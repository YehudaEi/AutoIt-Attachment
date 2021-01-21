$hSearchPathPlugin = PluginOpen("SearchPathPlugin.dll")
OpenSearchPath("C:\Temp")
$n  = 1
While 1
	$sPath = GetSearchPath()
	If $sPath <> "" Then 
		ConsoleWrite($n & " - " & $sPath & @LF)
		$n = $n+1
	Else
		ExitLoop
	EndIf
WEnd
CloseSearchPath()
PluginClose($hSearchPathPlugin)
