#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.2.12.1
 Author:         UndeadHarlequin
 Script Function:
	Paket RunUO-Server
#ce ----------------------------------------------------------------------------
;#NoTrayIcon
AutoItSetOption("sendkeydelay",0.1)
;AutoItSetOption("trayiconhide",1)
AutoItSetOption("wintitlematchmode",4)

;blockinput

;a=Installationsort
;@startupdir
$b=@ComputerName&"-Server"
$a=@ProgramFilesDir&"\Spiele\UltimaOnline\"&$b
;FileReadline("Instinfos.txt",3)
;b=Servername

;FileReadLine("Instinfos.txt",5)
;c=Charname
$c=@username

;;;;Zu ändernde Textdokumente:
$a1="ServerList.cs";["using System;"]
;Filereadline("instinfos.txt",7)
#cs
DirCreate(@TempDir&"\UoServerDaten\")
FileInstall("C:\Dokumente und Einstellungen\ArlenDoremin\Desktop\RunUO\slfxtrct.exe",@TempDir&"\UoServerDaten\slfxtrct.exe",1)
Run("slfxtrct.exe",@TempDir&"\UoServerDaten\")
;;;; Gui Abfrage nach wünschen und Anregungen(servername, Instalationsverzeichnis, blockieren?;;;;;;
WinWaitActive("Selbstentpackendes WinRAR-Archiv","&Zielverzeichnis")
winsetstate("Selbstentpackendes WinRAR-Archiv","&Zielverzeichnis")
;;Controllid/hndle controlle
send($a)
send("!i")
Select
	case FileExists($a)
		WinWaitActive("Ersetzen von Dateien bestätigen","Die folgende Datei existiert bereits")
		send("!a")
EndSelect
;winsetstate("Selbstentpackendes WinRAR-Archiv","Installationsfortschritt",@sw_hide)
Sleep(6000)
WinWaitClose("Selbstentpackendes WinRAR-Archiv")

$d=WinGetHandle("serverlist.cs","RunUO TC")
StringReplace ($d,"RunUO TC",$b,1,1)
#ce

run("notepad.exe "&$a1,$a&"\scripts\misc\",@SW_MAXIMIZE)
WinWaitActive($a1,"using System;")
$a2=ControlGetHandle($a1,"using System;","Edit1")
$a3=ControlCommand($a1,"using System;","[CLASS:Edit; INSTANCE:1]","Findstring",'"RunUO TC"')
MsgBox(1,"msgbox",$a3)
;ControlCommand($a1,"using System;","[CLASS:Edit; INSTANCE:1]","editpaste",$b)

;Clientinstalation mit settings IM HINTERGRUND

;FileWriteLine("ServerList.cs",41)
;fertige instalationen
; gui abtasten
Exit