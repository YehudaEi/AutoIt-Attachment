TraySetState(2)

HotKeySet("!#`", "Suicide")

;D-Pad
HotKeySet("`", "NumPad")
;### Note: this disables normal use of the grave key;  to produce grave symbol use Win + Grave;  tildy still works normally. ###

;Miscellaneous HotKeys
;HotKeySet("#{DOWN}", "wDOWN")
;HotKeySet("#{LEFT}", "wLEFT")
;HotKeySet("#{RIGHT}", "wRIGHT")
;HotKeySet("#{UP}", "wUP")

;Shortcut Kays, w = Win
HotKeySet("#/", "wSLASH")
HotKeySet("#a", "wA"); Left Arrow
HotKeySet("#b", "waR"); Run Dialog
HotKeySet("#c", "wC"); Ctrl+PgUp
HotKeySet("#d", "wD"); Down Arrow
HotKeySet("#e", "wE"); PgDn
HotKeySet("#f", "wF"); Right Arrow
HotKeySet("#g", "waR"); Run Dialog
HotKeySet("#h", "waR"); Run Dialog
HotKeySet("#n", "wN"); Ctrl+N
HotKeySet("#q", "wQ"); Home
HotKeySet("#r", "wR"); End
HotKeySet("#s", "wS"); Up Arrow
HotKeySet("#t", "waR"); Run Dialog
HotKeySet("#v", "wV"); Ctrl+PgDn
HotKeySet("#w", "wW"); PgUp
HotKeySet("#x", "wX"); Ctrl+F4
HotKeySet("#y", "waR"); Run Dialog
HotKeySet("#z", "wZ"); Alt+F4

;Control Panels, wcs = Win + Ctrl + Shift
HotKeySet("#^+,", "wcsCOMMA");  Pen Tablet
HotKeySet("#^+.", "wcsPERIOD"); Tablet and Pen Settings
HotKeySet("#^+a", "wcsA"); Add or Remove Programs
HotKeySet("#^+c", "wcsC"); Control Panel
HotKeySet("#^+d", "wcsD"); Display
HotKeySet("#^+e", "wcsE"); Date and Time
HotKeySet("#^+f", "wcsF"); Folder Options
HotKeySet("#^+G", "wcsG"); TweakUI
HotKeySet("#^+h", "wcsH"); CMI USB Sound Config
HotKeySet("#^+i", "wcsI"); Intel GMA Driver
HotKeySet("#^+m", "wcsM"); Mouse
HotKeySet("#^+n", "wcsN"); Network Connections
HotKeySet("#^+o", "wcsO"); Power Options
HotKeySet("#^+p", "wcsP"); Printers
HotKeySet("#^+r", "wcsR"); Recycle Bin
HotKeySet("#^+s", "wcsS"); Sounds and Audio Devices
HotKeySet("#^+t", "wcsT"); Taskbar amd Start Menu
HotKeySet("#^+u", "wcsU"); User Accounts
HotKeySet("#^+v", "wcsV"); Administrative Tools
HotKeySet("#^+w", "wcsW"); System

;System Folders, wc = Win + Ctrl
HotKeySet("#^{SPACE}", "wcspace"); My Documents Folder
HotKeySet("#^{f1}", "wcf1"); A:
HotKeySet("#^{f2}", "wcf2"); B:
HotKeySet("#^{f3}", "wcf3"); C:
HotKeySet("#^{f4}", "wcf4"); D:
HotKeySet("#^{f5}", "wcf5"); E:
HotKeySet("#^{f6}", "wcf6"); F:
HotKeySet("#^{f7}", "wcf7"); G:
HotKeySet("#^{f8}", "wcf8"); H:
HotKeySet("#^{f9}", "wcf9"); I:
HotKeySet("#^{f10}", "wcf10"); J:
HotKeySet("#^{f11}", "wcf11"); K:
HotKeySet("#^{f12}", "wcf12"); L:
HotKeySet("#^d", "wcD"); Desktop Folder
HotKeySet("#^c", "wcC"); Classes Folder
HotKeySet("#^e", "wcE"); Entertainent Folder
HotKeySet("#^g", "wcG"); Program Files
HotKeySet("#^i", "wcI"); Program Install Folder
HotKeySet("#^m", "wcM"); My Music
HotKeySet("#^n", "wcN"); Network Places
HotKeySet("#^p", "wcP"); My Pictures
HotKeySet("#^r", "wcR"); Research Folder
HotKeySet("#^s", "wcS"); Start Menu
HotKeySet("#^t", "wcT"); Travel Folder
HotKeySet("#^u", "wcU"); User Folder
HotKeySet("#^v", "wcV"); My Videos
HotKeySet("#^w", "wcW"); Websites Folder

;MS Applications, was = Win + Alt + Shift
HotKeySet("#!+a", "wasA"); MS Acces
HotKeySet("#!+i", "wasI"); MS Internet Explorer
HotKeySet("#!+n", "wasN"); MS OneNote
HotKeySet("#!+o", "wasO"); MS Outlook
HotKeySet("#!+p", "wasP"); MS PowerPoint
HotKeySet("#!+u", "wasU"); MS Publisher
HotKeySet("#!+w", "wasW"); MS Word
HotKeySet("#!+x", "wasX"); MS Excel

;System Functions, wa = Win + Alt
HotKeySet("#!d", "waD"); Show Desktop
HotKeySet("#!n", "waN"); Wireless Toggle
HotKeySet("#!m", "waM"); PPC Modem
HotKeySet("#!r", "waR"); Run Dialog
HotKeySet("#!x", "waX"); X-Mouse Toggle

;Applications, ws = Win + Shift
HotKeySet("#+c", "wsC"); Comic Rack
HotKeySet("#+d", "wsD"); DAEMON Tools
HotKeySet("#+e", "wsE"); Explorer2
HotKeySet("#+f", "wsF"); Firefox
HotKeySet("#+g", "wsG"); Gimp
HotKeySet("#+m", "wsM"); Media Player Classic
HotKeySet("#+n", "wsN"); Notepad++
HotKeySet("#+t", "wsT"); Thunderbird
HotKeySet("#+w", "wsW"); Winamp
HotKeySet("#+z", "wsZ"); Zortam


#include <Misc.au3>

$dll = DllOpen("user32.dll")

While 1
    Sleep ( 100 )

	If(_IsPressed("5B")OR _IsPressed("5C"))AND _IsPressed("4C")Then
        If NOT(_IsPressed("10")OR _IsPressed("11")OR _IsPressed("12"))Then
;			Send("{LWINUP}{RWINUP}")
			Send("!^+3")
		EndIf
    EndIf
	If(_IsPressed("5B")OR _IsPressed("5C"))AND _IsPressed("55")Then
        If NOT( _IsPressed("10")OR _IsPressed("11")OR _IsPressed("12"))Then
;			Send("{LWINUP}{RWINUP}")
			Send("!^+1")
		EndIf
    EndIf
	
	If ProcessExists("NumPad.exe")AND _IsPressed("A0")Then
		ProcessClose("NumPad.exe")
		TraySetState(2)
	EndIf

WEnd
DllClose($dll)


Func Suicide()
	ProcessClose ("HotKeys.exe")
EndFunc


;NumPad
Func NumPad()
	If NOT ProcessExists ("NumPad.exe") Then
		run ("C:\Program Files\AutoIt Programs\NumPad.exe")
		TraySetState(5)
	EndIf
EndFunc


;Shortcut Keys, w = Win
Func wSLASH()
	Send ("{APPSKEY}")
EndFunc

Func wA()
	Send ("{LEFT}")
EndFunc

Func wC()
	Send ("^{PGUP}")
EndFunc

Func wD()
	Send ("{DOWN}")
EndFunc

Func wE()
	Send ("{PGDN}")
EndFunc

Func wF()
	Send ("{RIGHT}")
EndFunc

Func wN()
	Send ("^n")
EndFunc

Func wQ()
	Send ("{HOME}")
EndFunc

Func wR()
	Send ("{END}")
EndFunc

Func wS()
	Send ("{UP}")
EndFunc

Func wV()
	Send ("^{PGDN}")
EndFunc

Func wW()
	Send ("{PGUP}")
EndFunc

Func wX()
	Send ("^{F4}")
EndFunc

Func wZ()
	Send ("!{F4}")
EndFunc


;Control Panel, wcs = Win + Ctrl + Shift
Func wcsCOMMA();  Pen Tablet
	run ("C:\WINDOWS\system32\rundll32.exe C:\WINDOWS\system32\shell32.dll,Control_RunDLL C:\WINDOWS\system32\PenTablet.cpl")
EndFunc

Func wcsPERIOD(); Tablet and Pen Settings
	ShellExecute("Control.exe", @SystemDir & "\tabletpc.cpl")
EndFunc

Func wcsA(); Add or Remove Programs
	ShellExecute("Control.exe", @SystemDir & "\Appwiz.cpl")
EndFunc

Func wcsC()
	run ("control.exe")
EndFunc

Func wcsD(); Display
	ShellExecute("Control.exe", @SystemDir & "\Desk.cpl")
EndFunc

Func wcsE(); Date and Time
	ShellExecute("Control.exe", @SystemDir & "\Timedate.cpl")
EndFunc

Func wcsF(); Folder Options
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Folder Options.lnk")
EndFunc

Func wcsG(); TweakUI
	run ("tweakui")
EndFunc

Func wcsH(); CMI USB Sound Config
	ShellExecute("Control.exe", @SystemDir & "\CmCnfgU.cpl")
EndFunc

Func wcsI(); Intel GMA Driver
	ShellExecute("Control.exe", @SystemDir & "\igfxcpl.cpl")
EndFunc

Func wcsM(); Mouse
	ShellExecute("Control.exe", @SystemDir & "\Main.cpl")
EndFunc

Func wcsN(); Network Connections
	ShellExecute("Control.exe", @SystemDir & "\ncpa.cpl")
EndFunc

Func wcsO(); Power Options
	ShellExecute("Control.exe", @SystemDir & "\Powercfg.cpl")
EndFunc

Func wcsP(); Printers
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Printers and Faxes.lnk")
EndFunc

Func wcsR()
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Recycle Bin.lnk")
EndFunc

Func wcsS(); Sounds and Audio Devices
	ShellExecute("Control.exe", @SystemDir & "\mmsys.cpl")
EndFunc

Func wcsT(); Taskbar amd Start Menu
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Taskbar and Start Menu.lnk")
EndFunc

Func wcsU(); User Accounts
	ShellExecute("Control.exe", @SystemDir & "\Nusrmgr.cpl")
EndFunc

Func wcsV()
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Administrative Tools.lnk")
EndFunc

Func wcsW(); System
	run ("C:\WINDOWS\system32\rundll32.exe C:\WINDOWS\system32\shell32.dll,Control_RunDLL C:\WINDOWS\system32\sysdm.cpl,System")
EndFunc


;User Folders, wc = Win + Ctrl
Func wcspace()
	run ("explorer.exe" & " " & @MyDocumentsDir)
EndFunc

Func wcf1()
	run ("explorer.exe" & " " & "A:")
EndFunc

Func wcf2()
	run ("explorer.exe" & " " & "B:")
EndFunc

Func wcf3()
	run ("explorer.exe" & " " & "C:")
EndFunc

Func wcf4()
	run ("explorer.exe" & " " & "D:")
EndFunc

Func wcf5()
	run ("explorer.exe" & " " & "E:")
EndFunc

Func wcf6()
	run ("explorer.exe" & " " & "F:")
EndFunc

Func wcf7()
	run ("explorer.exe" & " " & "G:")
EndFunc

Func wcf8()
	run ("explorer.exe" & " " & "H:")
EndFunc

Func wcf9()
	run ("explorer.exe" & " " & "I:")
EndFunc

Func wcf10()
	run ("explorer.exe" & " " & "J:")
EndFunc

Func wcf11()
	run ("explorer.exe" & " " & "K:")
EndFunc

Func wcf12()
	run ("explorer.exe" & " " & "L:")
EndFunc

Func wcC()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Classes")
EndFunc

Func wcD()
	run ("explorer.exe" & " " & @DesktopDir)
EndFunc

Func wcE()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Entertainment")
EndFunc

Func wcG()
	run ("explorer.exe" & " " & "C:\Program Files")
EndFunc

Func wcI()
		run ("explorer.exe" & " " & "C:\Program Install Files")
EndFunc

Func wcM()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\My Music")
EndFunc

Func wcN()
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\My Network Places.lnk")
EndFunc

Func wcP()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\My Pictures")
EndFunc

Func wcR()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Research")
EndFunc

Func wcS()
	run ("explorer.exe" & " " & @StartMenuDir)
EndFunc

Func wcT()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Travel and Meetings")
EndFunc

Func wcU()
	run ("explorer.exe" & " " & @UserProfileDir)
EndFunc

Func wcV()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\My Videos")
EndFunc

Func wcW()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Websites")
EndFunc


;MS Applications, was = Win + Alt + Shift
Func wasA()
	run ("msaccess.exe")
EndFunc

Func waD()
	run ("C:\Program Files\AutoIt Programs\Show Desktop.exe")
EndFunc

Func wasI()
	run ("C:\Program Files\Internet Explorer\iexplore.exe")
EndFunc

Func wasN()
	run ("onenote.exe")
EndFunc

Func wasO()
	run ("outlook.exe")
EndFunc

Func wasP()
	run ("powerpnt.exe")
EndFunc

Func waR()
	run ("C:\Program Files\AutoIt Programs\Run Dialog.exe")
EndFunc

Func wasU()
	run ("mspub.exe")
EndFunc

Func wasW()
	run("winword.exe")
EndFunc

Func wasX()
	run ("excel.exe")
EndFunc


;System Functions, wa = Win + Alt
Func waN()
	run ("C:\Program Files\AutoIt Programs\Wireless Network Toggle.exe")
EndFunc

Func waM()
	run ("C:\Program Files\CDMA USB Modem\CDMA_USBModem_Dialer.exe")
	WinWait("CDMA Wireless Modem", "", 5)
	WinActivate("CDMA Wireless Modem", "")
	Send("{TAB}{TAB}{TAB}{TAB}{ENTER}")
EndFunc

Func waX()
	run ("C:\Program Files\AutoIt Programs\X-Mouse Toggle.exe")
EndFunc


;Applications, ws = Win + Shift
Func wsC()
	run ("C:\Program Files\ComicRack\ComicRack.exe")
EndFunc

Func wsD()
	run ("C:\Program Files\DAEMON Tools\daemon.exe")
EndFunc

Func wsE()
	run ("C:\Program Files\zabkat\xplorer2\xplorer2_UC.exe")
EndFunc

Func wsF()
	run ("C:\Program Files\Mozilla Firefox\firefox.exe")
EndFunc

Func wsG()
	run ("C:\Program Files\GIMP-2.0\bin\gimp-2.4.exe")
EndFunc

Func wsM()
	run ("C:\Program Files\Combined Community Codec Pack\MPC\mplayerc.exe")
EndFunc

Func wsN()
	run ("C:\Program Files\Notepad++\notepad++.exe")
EndFunc

Func wsT()
	run ("C:\Program Files\Mozilla Thunderbird\thunderbird.exe")
EndFunc

Func wsW()
	run ("C:\Program Files\Winamp\winamp.exe")
EndFunc

Func wsZ()
	run ("C:\Program Files\Zortam Mp3 Media Studio\zmmspro.exe")
EndFunc

