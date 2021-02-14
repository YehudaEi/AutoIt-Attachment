#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=bot.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
HotKeySet ("1","sair")
Func sair()
	Exit
	EndFunc
$line = 1
$file = @ScriptDir & 'teclas.txt'
WinActivate ('(Untitled) * SciTE')
Do
$lineread = FileReadLine ($file,$line)
Send ('HotKeySet')
Send ("'")
Send ($lineread)
Send ("'")
Send ('{Enter}')
$line = $line + 1
Until $line = 99