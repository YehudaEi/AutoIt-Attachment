#compiler_plugin_funcs = FileHash, StringHash

$plH = PluginOpen("..\Bin\FSHash.dll")
MsgBox(0, "Test FSHash.DLL", "String 'Test String':" & @TAB & "(SHA)" & @TAB & StringHash("Test String", 2, True) & @CRLF & _
							  "File 'FSHash.dll':" & @TAB & "(MD5)" & @TAB & FileHash("..\Bin\FSHash.dll", 1, True))
PluginClose($plH)