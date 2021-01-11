#compiler_plugin_funcs = SHAHash

$plH = PluginOpen("..\Bin\SHA\SHAHash.dll")
MsgBox(0, "Test SHAHash.DLL", "String 'Test String':" & @TAB & SHAHash("Test String", 2, True) & @CRLF & _
							  "File 'SHAHash.dll':" & @TAB & SHAHash("..\Bin\SHA\SHAHash.dll", 1, True))
PluginClose($plH)