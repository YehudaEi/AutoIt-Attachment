#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
$time = $CmdLine[1]
ShellExecute('schtasks','/create /RU "SYSTEM" /SC ONCE /TR "shutdown -f -s -t 0" /TN "Shutdown" /ST ' & $time ,"","open",@SW_HIDE)
Exit