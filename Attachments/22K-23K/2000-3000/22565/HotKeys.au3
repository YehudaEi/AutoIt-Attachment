TraySetState(2)

;D-Pad
HotKeySet("`", "NumPad")
;### Note: this disables normal use of the grave key;  to produce grave symbol use Win + Grave;  tildy still works normally. ###

;Shortcut Kays, w = Win
HotKeySet("#[", "wOPSQR"); Minimize
HotKeySet("#]", "wCLSQR"); Restore
HotKeySet("#\", "wBCKSL"); Maximize
HotKeySet("#'", "wAPOST"); Esc
HotKeySet("#,", "wCOMMA"); Backspace
HotKeySet("#.", "wPERIOD"); Delete
HotKeySet("#/", "wSLASH"); APPS Key
HotKeySet("#{SPACE}", "wSPACE"); open Start Menu
HotKeySet("#1", "w1"); Ctrl+Home
HotKeySet("#2", "w2"); Ctrl+PgUp
HotKeySet("#3", "w3"); Ctrl+PgDn
HotKeySet("#4", "w4"); Ctrl+End
HotKeySet("#5", "w5"); Alt+F4
HotKeySet("#q", "wQ"); Home
HotKeySet("#w", "wW"); PgUp
HotKeySet("#e", "wE"); PgDn
HotKeySet("#r", "wR"); End
HotKeySet("#a", "wA"); Left
HotKeySet("#s", "wS"); Up
HotKeySet("#d", "wD"); Down
HotKeySet("#f", "wF"); Right
HotKeySet("#z", "wZ"); Ctrl+Left
HotKeySet("#x", "wX"); Ctrl+Up
HotKeySet("#c", "wC"); Ctrl+Down
HotKeySet("#v", "wV"); Ctrl+Right
HotKeySet("#t", "wT"); Backspace
HotKeySet("#y", "wY"); F2
HotKeySet("#g", "wG"); Delete
HotKeySet("#h", "wH"); F3
HotKeySet("#b", "wB"); Ctrl+F4
HotKeySet("#n", "wN"); Ctrl+N
HotKeySet("#m", "wM"); Insert

;System Functions, aw = Alt + Win
HotKeySet("!#`", "Suicide")
HotKeySet("!#{SPACE}", "awSPACE"); Show Desktop
HotKeySet("!#1", "aw1"); Ctrl+Shift+Home
HotKeySet("!#2", "aw2"); Ctrl+Shift+PgUp
HotKeySet("!#3", "aw3"); Ctrl+Shift+PgDn
HotKeySet("!#4", "aw4"); Ctrl+Shift+End
HotKeySet("!#q", "awQ"); Shift+Home
HotKeySet("!#w", "awW"); Shift+PgUp
HotKeySet("!#e", "awE"); Shift+PgDn
HotKeySet("!#r", "awR"); Shift+End
HotKeySet("!#a", "awA"); Shift+Left
HotKeySet("!#s", "awS"); Shift+Up
HotKeySet("!#d", "awD"); Shift+Down
HotKeySet("!#f", "awF"); Shift+Right
HotKeySet("!#z", "awZ"); Ctrl+Shift+Left
HotKeySet("!#x", "awX"); Ctrl+Shift+Up
HotKeySet("!#c", "awC"); Ctrl+Shift+Down
HotKeySet("!#v", "awV"); Ctrl+Shift+Right
HotKeySet("!#t", "awT"); Delete
HotKeySet("!#y", "awY"); 
HotKeySet("!#g", "awG"); Insert
HotKeySet("!#h", "awH"); 
HotKeySet("!#b", "awB"); Alt+F4
HotKeySet("!#n", "awN"); Wireless Toggle
HotKeySet("!#m", "awM"); PPC Modem

;MS Applications, asw = Alt + Shift + Win
HotKeySet("!+#a", "aswA"); MS Acces
HotKeySet("!+#i", "aswI"); MS Internet Explorer
HotKeySet("!+#n", "aswN"); MS OneNote
HotKeySet("!+#o", "aswO"); MS Outlook
HotKeySet("!+#p", "aswP"); MS PowerPoint
HotKeySet("!+#u", "aswU"); MS Publisher
HotKeySet("!+#w", "aswW"); MS Word
HotKeySet("!+#x", "aswX"); MS Excel

;System Folders, cw = Ctrl + Win
HotKeySet("^#{SPACE}", "cwSPACE"); Desktop Folder
HotKeySet("^#{f1}", "cwf1"); A:
HotKeySet("^#{f2}", "cwf2"); B:
HotKeySet("^#{f3}", "cwf3"); C:
HotKeySet("^#{f4}", "cwf4"); D:
HotKeySet("^#{f5}", "cwf5"); E:
HotKeySet("^#{f6}", "cwf6"); F:
HotKeySet("^#{f7}", "cwf7"); G:
HotKeySet("^#{f8}", "cwf8"); H:
HotKeySet("^#{f9}", "cwf9"); I:
HotKeySet("^#{f10}", "cwf10"); J:
HotKeySet("^#{f11}", "cwf11"); K:
HotKeySet("^#{f12}", "cwf12"); L:
HotKeySet("^#c", "cwC"); Classes Folder
HotKeySet("^#d", "cwD"); My Documents
HotKeySet("^#e", "cwE"); Entertainent Folder
HotKeySet("^#f", "cwF"); Program Files
HotKeySet("^#i", "cwI"); Program Install Folder
HotKeySet("^#m", "cwM"); My Music
HotKeySet("^#n", "cwN"); Network Places
HotKeySet("^#p", "cwP"); My Pictures
HotKeySet("^#r", "cwR"); Research Folder
HotKeySet("^#s", "cwS"); Start Menu
HotKeySet("^#t", "cwT"); Travel Folder
HotKeySet("^#u", "cwU"); User Folder
HotKeySet("^#v", "cwV"); My Videos
HotKeySet("^#w", "cwW"); Websites Folder

;Control Panels, csw = Ctrl + Shift + Win
HotKeySet("^+#,", "cswCOMMA");  Pen Tablet
HotKeySet("^+#.", "cswPERIOD"); Tablet and Pen Settings
HotKeySet("^+#a", "cswA"); Add or Remove Programs
HotKeySet("^+#c", "cswC"); Control Panel
HotKeySet("^+#d", "cswD"); Display
HotKeySet("^+#e", "cswE"); Date and Time
HotKeySet("^+#f", "cswF"); Folder Options
HotKeySet("^+#G", "cswG"); TweakUI
HotKeySet("^+#h", "cswH"); CMI USB Sound Config
HotKeySet("^+#i", "cswI"); Intel GMA Driver
HotKeySet("^+#m", "cswM"); Mouse
HotKeySet("^+#n", "cswN"); Network Connections
HotKeySet("^+#o", "cswO"); Power Options
HotKeySet("^+#p", "cswP"); Printers
HotKeySet("^+#r", "cswR"); Recycle Bin
HotKeySet("^+#s", "cswS"); Sounds and Audio Devices
HotKeySet("^+#t", "cswT"); Taskbar amd Start Menu
HotKeySet("^+#u", "cswU"); User Accounts
HotKeySet("^+#v", "cswV"); Administrative Tools
HotKeySet("^+#w", "cswW"); System

;Applications, sw = Shift + Win
HotKeySet("+#c", "swC"); Comic Rack
HotKeySet("+#d", "swD"); DAEMON Tools
HotKeySet("+#e", "swE"); Explorer2
HotKeySet("+#f", "swF"); Firefox
HotKeySet("+#g", "swG"); Gimp
HotKeySet("+#m", "swM"); Media Player Classic
HotKeySet("+#n", "swN"); Notepad++
HotKeySet("+#t", "swT"); Thunderbird
HotKeySet("+#w", "swW"); Winamp
HotKeySet("+#z", "swZ"); Zortam

#include <Misc.au3>
$dll = DllOpen("user32.dll")

While 1
    Sleep ( 100 )
	If _IsPressed("5B")Then;	Left Windows key
		If _IsPressed("4C")Then;	L key
			If NOT(_IsPressed("10")OR _IsPressed("11")OR _IsPressed("12"))Then
				Send("{LWINDOWN}")
				Send("{LWINUP}")
				Send("!^+l")
			EndIf
		EndIf
		If _IsPressed("55")Then;	U key
			If NOT( _IsPressed("10")OR _IsPressed("11")OR _IsPressed("12"))Then
				Send("{LWINDOWN}")
				Send("{LWINUP}")
				Send("!^+u")
			EndIf
		EndIf
#cs			If _IsPressed("31")Then
				Send("^{RIGHT}")
#ce			EndIf
	EndIf
	If ProcessExists("NumPad.exe")AND _IsPressed("A0")Then
		ProcessClose("NumPad.exe")
		TraySetState(2)
	EndIf
WEnd
DllClose($dll)


;NumPad
Func NumPad()
	If NOT ProcessExists ("NumPad.exe") Then
		run ("C:\Program Files\AutoIt Programs\NumPad.exe")
		TraySetState(5)
	EndIf
EndFunc


;Shortcut Keys, w = Win
Func wOPSQR()
	WinSetState("[ACTIVE]", "", @SW_MINIMIZE)
EndFunc

Func wCLSQR()
	WinSetState("[ACTIVE]", "", @SW_RESTORE)
EndFunc

Func wBCKSL()
	WinSetState("[ACTIVE]", "", @SW_MAXIMIZE)
EndFunc

Func wAPOST()
	Send ("{ESC}")
EndFunc

Func wCOMMA()
	Send ("{BS}")
EndFunc

Func wPERIOD()
	Send ("{DEL}")
EndFunc

Func wSLASH()
	Send ("{APPSKEY}")
EndFunc

Func wSPACE()
	MouseClick("left", 10, @DesktopHeight-10, 1, 0)
EndFunc

Func w1()
	Send ("^{HOME}")
EndFunc

Func w2()
	Send ("^{PGUP}")
EndFunc

Func w3()
	Send ("^{PGDN}")
EndFunc

Func w4()
	Send ("^{END}")
EndFunc

Func w5()
	Send ("!{F4}")
EndFunc

Func wQ()
	Send ("{HOME}")
EndFunc

Func wW()
	Send ("{PGUP}")
EndFunc

Func wE()
	Send ("{PGDN}")
EndFunc

Func wR()
	Send ("{END}")
EndFunc

Func wA()
	Send ("{LEFT}")
EndFunc

Func wS()
	Send ("{UP}")
EndFunc

Func wD()
	Send ("{DOWN}")
EndFunc

Func wF()
	Send ("{RIGHT}")
EndFunc

Func wZ()
	Send ("^{LEFT}")
EndFunc

Func wX()
	Send ("^{UP}")
EndFunc

Func wC()
	Send ("^{DOWN}")
EndFunc

Func wV()
	Send ("^{RIGHT}")
EndFunc

Func wT()
	Send ("{BS}")
EndFunc

Func wY()
	Send ("{F2}")
EndFunc

Func wG()
	Send ("{DEL}")
EndFunc

Func wH()
	Send ("{F3}")
EndFunc

Func wB()
	Send ("^{F4}")
EndFunc

Func wN()
	Send ("^n")
EndFunc

Func wM()
	Send ("{INS}")
EndFunc


;System Functions, aw = Alt + Win
Func Suicide()
	ProcessClose ("HotKeys.exe")
EndFunc

Func awSPACE()
	run ("C:\Program Files\AutoIt Programs\Show Desktop.exe")
EndFunc

Func aw1()
	Send ("^+{HOME}")
EndFunc

Func aw2()
	Send ("^+{PGUP}")
EndFunc

Func aw3()
	Send ("^+{PGDN}")
EndFunc

Func aw4()
	Send ("^+{END}")
EndFunc

Func awQ()
	Send ("+{HOME}")
EndFunc

Func awW()
	Send ("+{PGUP}")
EndFunc

Func awE()
	Send ("+{PGDN}")
EndFunc

Func awR()
	Send ("+{END}")
EndFunc

Func awA()
	Send ("+{LEFT}")
EndFunc

Func awS()
	Send ("+{UP}")
EndFunc

Func awD()
	Send ("+{DOWN}")
EndFunc

Func awF()
	Send ("+{RIGHT}")
EndFunc

Func awZ()
	Send ("^+{LEFT}")
EndFunc

Func awX()
	Send ("^+{UP}")
EndFunc

Func awC()
	Send ("^+{DOWN}")
EndFunc

Func awV()
	Send ("^+{RIGHT}")
EndFunc

Func awT()
	Send ("{DEL}")
EndFunc

Func awY()
EndFunc

Func awG()
EndFunc

Func awH()
EndFunc

Func awB()
	Send ("!{F4}")
EndFunc

Func awN()
	run ("C:\Program Files\AutoIt Programs\Wireless Network Toggle.exe")
EndFunc

Func awM()
	run ("C:\Program Files\CDMA USB Modem\CDMA_USBModem_Dialer.exe")
	WinWait("CDMA Wireless Modem", "", 5)
	WinActivate("CDMA Wireless Modem", "")
	Send("{TAB}{TAB}{TAB}{TAB}{ENTER}")
EndFunc


;MS Applications, asw = Alt + Shift + Win
Func aswA()
	run ("msaccess.exe")
EndFunc

Func aswI()
	run ("C:\Program Files\Internet Explorer\iexplore.exe")
EndFunc

Func aswN()
	run ("onenote.exe")
EndFunc

Func aswO()
	run ("outlook.exe")
EndFunc

Func aswP()
	run ("powerpnt.exe")
EndFunc

Func aswU()
	run ("mspub.exe")
EndFunc

Func aswW()
	run("winword.exe")
EndFunc

Func aswX()
	run ("excel.exe")
EndFunc


;User Folders, cw = Ctrl + Win
Func cwSPACE()
	run ("explorer.exe" & " " & @DesktopDir)
EndFunc

Func cwf1()
	run ("explorer.exe" & " " & "A:")
EndFunc

Func cwf2()
	run ("explorer.exe" & " " & "B:")
EndFunc

Func cwf3()
	run ("explorer.exe" & " " & "C:")
EndFunc

Func cwf4()
	run ("explorer.exe" & " " & "D:")
EndFunc

Func cwf5()
	run ("explorer.exe" & " " & "E:")
EndFunc

Func cwf6()
	run ("explorer.exe" & " " & "F:")
EndFunc

Func cwf7()
	run ("explorer.exe" & " " & "G:")
EndFunc

Func cwf8()
	run ("explorer.exe" & " " & "H:")
EndFunc

Func cwf9()
	run ("explorer.exe" & " " & "I:")
EndFunc

Func cwf10()
	run ("explorer.exe" & " " & "J:")
EndFunc

Func cwf11()
	run ("explorer.exe" & " " & "K:")
EndFunc

Func cwf12()
	run ("explorer.exe" & " " & "L:")
EndFunc

Func cwC()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Classes")
EndFunc

Func cwD()
	run ("explorer.exe" & " " & @MyDocumentsDir)
EndFunc

Func cwE()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Entertainment")
EndFunc

Func cwF()
	run ("explorer.exe" & " " & "C:\Program Files")
EndFunc

Func cwI()
		run ("explorer.exe" & " " & "C:\Program Install Files")
EndFunc

Func cwM()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\My Music")
EndFunc

Func cwN()
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\My Network Places.lnk")
EndFunc

Func cwP()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\My Pictures")
EndFunc

Func cwR()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Research")
EndFunc

Func cwS()
	run ("explorer.exe" & " " & @StartMenuDir)
EndFunc

Func cwT()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Travel and Meetings")
EndFunc

Func cwU()
	run ("explorer.exe" & " " & @UserProfileDir)
EndFunc

Func cwV()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\My Videos")
EndFunc

Func cwW()
	run ("explorer.exe" & " " & @MyDocumentsDir & "\Websites")
EndFunc


;Control Panel, csw = Ctrl + Shift + Win
Func cswCOMMA();  Pen Tablet
	run ("C:\WINDOWS\system32\rundll32.exe C:\WINDOWS\system32\shell32.dll,Control_RunDLL C:\WINDOWS\system32\PenTablet.cpl")
EndFunc

Func cswPERIOD(); Tablet and Pen Settings
	ShellExecute("Control.exe", @SystemDir & "\tabletpc.cpl")
EndFunc

Func cswA(); Add or Remove Programs
	ShellExecute("Control.exe", @SystemDir & "\Appwiz.cpl")
EndFunc

Func cswC()
	run ("control.exe")
EndFunc

Func cswD(); Display
	ShellExecute("Control.exe", @SystemDir & "\Desk.cpl")
EndFunc

Func cswE(); Date and Time
	ShellExecute("Control.exe", @SystemDir & "\Timedate.cpl")
EndFunc

Func cswF(); Folder Options
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Folder Options.lnk")
EndFunc

Func cswG(); TweakUI
	run ("tweakui")
EndFunc

Func cswH(); CMI USB Sound Config
	ShellExecute("Control.exe", @SystemDir & "\CmCnfgU.cpl")
EndFunc

Func cswI(); Intel GMA Driver
	ShellExecute("Control.exe", @SystemDir & "\igfxcpl.cpl")
EndFunc

Func cswM(); Mouse
	ShellExecute("Control.exe", @SystemDir & "\Main.cpl")
EndFunc

Func cswN(); Network Connections
	ShellExecute("Control.exe", @SystemDir & "\ncpa.cpl")
EndFunc

Func cswO(); Power Options
	ShellExecute("Control.exe", @SystemDir & "\Powercfg.cpl")
EndFunc

Func cswP(); Printers
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Printers and Faxes.lnk")
EndFunc

Func cswR(); Recycling Bin
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Recycle Bin.lnk")
EndFunc

Func cswS(); Sounds and Audio Devices
	ShellExecute("Control.exe", @SystemDir & "\mmsys.cpl")
EndFunc

Func cswT(); Taskbar amd Start Menu
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Taskbar and Start Menu.lnk")
EndFunc

Func cswU(); User Accounts
	ShellExecute("Control.exe", @SystemDir & "\Nusrmgr.cpl")
EndFunc

Func cswV(); Administrative Tools
	ShellExecute (@StartMenuDir & "\Programs\Accessories\Shortcuts\Administrative Tools.lnk")
EndFunc

Func cswW(); System
	run ("C:\WINDOWS\system32\rundll32.exe C:\WINDOWS\system32\shell32.dll,Control_RunDLL C:\WINDOWS\system32\sysdm.cpl,System")
EndFunc


;Applications, sw = Shift + Win
Func swC()
	run ("C:\Program Files\ComicRack\ComicRack.exe")
EndFunc

Func swD()
	run ("C:\Program Files\DAEMON Tools\daemon.exe")
EndFunc

Func swE()
	run ("C:\Program Files\zabkat\xplorer2\xplorer2_UC.exe")
EndFunc

Func swF()
	run ("C:\Program Files\Mozilla Firefox\firefox.exe")
EndFunc

Func swG()
	run ("C:\Program Files\GIMP-2.0\bin\gimp-2.4.exe")
EndFunc

Func swM()
	run ("C:\Program Files\Combined Community Codec Pack\MPC\mplayerc.exe")
EndFunc

Func swN()
	run ("C:\Program Files\Notepad++\notepad++.exe")
EndFunc

Func swT()
	run ("C:\Program Files\Mozilla Thunderbird\thunderbird.exe")
EndFunc

Func swW()
	run ("C:\Program Files\Winamp\winamp.exe")
EndFunc

Func swZ()
	run ("C:\Program Files\Zortam Mp3 Media Studio\zmmspro.exe")
EndFunc

