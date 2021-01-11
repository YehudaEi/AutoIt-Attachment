#compiler_plugin_funcs = MD5Hash

$plH = PluginOpen("..\Bin\MD5\MD5Hash.dll")
MsgBox(0, "Test MD5Hash.DLL", "String 'Test String':" & @TAB & MD5Hash("Test String", 2, True) & @CRLF & _
							  "File 'MD5Hash.dll':" & @TAB & MD5Hash("..\Bin\MD5\MD5Hash.dll", 1, True))
PluginClose($plH)