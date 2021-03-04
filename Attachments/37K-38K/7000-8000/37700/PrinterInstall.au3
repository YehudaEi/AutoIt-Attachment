#include <file.au3>
;Read INI File
$que = IniRead( "printer.ini", "Printer QUE", "Printer", "")
$ip =  iniread("printer.ini", "Printer IP", "IP" ,"")
$driver =  IniRead( "printer.ini", "Printer DRIVERS", "Driver", "")
$description = IniRead("printer.ini", "Printer DISCRIPTION", "Discription","")

;Command string to run from INI file
$info = 'rundll32 printui.dll,PrintUIEntry /if /b ' & '"' & $que & '" /f "' & $driver & '" /r "' & "IP_" & $ip & '" /m "' &  $description & '" /z'

;Create *.vbs File From INI
_FileCreate(@TempDir & "\" & $que & ".vbs")

;name of the file to open
$file = @TempDir & "\" & $que & ".vbs"

$open = FileOpen($file, 0)
; Check if file opened for writing OK
If $open = -1 Then
    MsgBox(0, "Error", "Unable to open file from Temp directory.")

Else
FileWriteLine($file,'Set objWMIService = GetObject("winmgmts:")')
FileWriteLine($file, 'Set objNewPort = objWMIService.Get _')
FileWriteLine($file, '("Win32_TCPIPPrinterPort").SpawnInstance_')
FileWriteLine($file, 'objNewPort.Name = ' & '"IP_' & $ip & '"')
FileWriteLine($file, 'objNewPort.Protocol = 1')
FileWriteLine($file, 'objNewPort.HostAddress = ' & '"' & $ip & '"' )
FileWriteLine($file, 'objNewPort.PortNumber = "9100"')
FileWriteLine($file, 'objNewPort.SNMPEnabled = False')
FileWriteLine($file, 'objNewPort.Put_')

;Run Install
$destination = "sscreen.gif"
SplashImageOn("Installing Printer " & $que, $destination, 272, 167,300,100,16)
RunWait(@ComSpec & " /c " & $file,"", @SW_HIDE)
RunWait(@ComSpec & " /c " & $info,"", @SW_HIDE)
Sleep(500)
SplashOff()
MsgBox(64,"Printer", "Printer has installed correctly")
Exit
EndIf
