#include <_RunCMD.au3>

;init
$ScriptTitle = "RunCMD Example"
$Header = "Example of:" & @CRLF & @CRLF
;default command
$cmd = "ping localhost"

;_RunCMD
If MsgBox(4, $ScriptTitle, $Header & " _RunCMD") <> 7 Then

	;note the use of _WinPath to add quotes when there are spaces in the path
	$cmd = _WinPath("C:\Program Files\Windows NT\Accessories\wordpad.exe")
	;note the script does not pause
	_RunCMD($cmd)

EndIf

;_RunWaitCMD
If MsgBox(4, $ScriptTitle, $Header & " _RunWaitCMD") <> 7 Then

	;note the script will pause until you close wordpad
	$cmd = _WinPath("C:\Program Files\Windows NT\Accessories\wordpad.exe")
	_RunWaitCMD($cmd)

EndIf

;_RunCMD_Window with DOS command
If MsgBox(4, $ScriptTitle, $Header & " _RunCMD_Window with DOS Command") <> 7 Then

	_RunCMD_Window("dir c:\Windows", "CMD: " & $cmd)

EndIf

;_RunWaitCMD_Window with external program
If MsgBox(4+0, $ScriptTitle, $Header & " _RunWaitCMD_Window with External Program") <> 7 Then

	;xcopy is an example of a program that requires stdin with stderr_merged to run in the GUI
	$exe = _WinPath("C:\Windows\System32\xcopy.exe")
	$opt = " /I /L "
	$p1 = "C:\Windows "
	$p2 = "C:\TEMP"
	$p3 = ""
	$p4 = ""

	$cmd = $exe & $opt & $p1 & $p2 & $p3 & $p4

	_RunWaitCMD_Window($cmd, "CMD: " & $cmd)

EndIf

;_RunCMD_GUI
If MsgBox(4, $ScriptTitle, $Header & " _RunCMD_GUI") <> 7 Then

	;prepare a command line with several parameters
	$IsoTool = "C:\Program Files\Windows AIK\Tools\amd64\oscdimg.exe"
	$IsoFile = "pe3_DELETE.iso"
	$WorkPath = "C:\winpe3_x86"
	;note the use of _WinPath to add quotes when there are spaces in the path
	$exe = _WinPath($IsoTool)
	$opt = " -n -m -o -b" ;leading, but no trailing space for the -b option
	$p1 = _WinPath($WorkPath) & "\ISO\boot\etfsboot.com "
	$p2 = _WinPath($WorkPath) & "\ISO "
	$p3 = _WinPath($WorkPath) & $IsoFile
	$p4 = "" ;not used on purpose to show how this could be used in your script
	;uncomment the next line if you have the 64-bit AIK installed and the paths above
	;$cmd = $exe & $opt & $p1 & $p2 & $p3 & $p4

	_RunCMD_GUI($cmd)

EndIf

; MsgBox(0, $ScriptTitle, "End of Examples")
