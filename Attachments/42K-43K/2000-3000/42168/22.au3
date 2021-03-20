$i=DllOpen(@ScriptDir & "\user32.dll")


DllCall($i, 'int', 'keybd_event', 'int', 0x41, 'int', 0, 'int', 0, 'ptr', 0)
DllCall($i, 'int', 'keybd_event', 'int', 0x41, 'int', 0, 'int', 2, 'ptr', 0)