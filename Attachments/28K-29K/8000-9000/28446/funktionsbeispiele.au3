
;http://www.autoit.de/index.php?page=Thread&postID=75677#post75677

#include <Constants.au3>

Local $path_Devcon = @ScriptDir&"\devcon.exe" ;@MyDocumentsDir & '\DOWNLOADS\TOOLS\Devcon\i386\devcon.exe'   ; <<===== Pfad anpassen
Local $strRun, $ID

; Name und Hardware-ID der Instance-ID USB ausgeben
$strRun = '"' & $path_Devcon & '" hwids *USB*'
ConsoleWrite(_RunDevcon($strRun) & @CRLF)
; m�gliche Ausgabe:
; USB\VID_13FE&PID_1D00\907310000250
;    Name: USB-Massenspeicherger�t
;    Hardware ID's:
;        USB\Vid_13fe&Pid_1d00&Rev_0110
;        USB\Vid_13fe&Pid_1d00
;    Compatible ID's:
;        USB\Class_08&SubClass_06&Prot_50
;        USB\Class_08&SubClass_06
;        USB\Class_08

; Entfernen des USB-Massenspeichers mit der ID "USB\Vid_13fe&Pid_1d00&Rev_0110"
#cs
$ID = '"USB\Vid_13fe&Pid_1d00&Rev_0110"'    ; <<------- ID in Anf�hrungszeichen einfassen, sonst Fehler in Console
$strRun = '"' & $path_Devcon & '" remove ' & $ID
ConsoleWrite(_RunDevcon($strRun) & @CRLF)
#ce
; Scannen nach neu angeschlossener Hardware, z.B. wieder Aktivieren eines zuvor entfernten USB-Sticks
$strRun = '"' & $path_Devcon & '" rescan'
ConsoleWrite(_RunDevcon($strRun) & @CRLF)


; alle PCI-Ger�te auf dem Computer ausgeben
$strRunRun = '"' & $path_Devcon & '" -m:\\' & @ComputerName & ' find pci\*'
ConsoleWrite(_RunDevcon($strRun) & @CRLF)

; Anzeigen aller bekannten Setupklassen
$strRun = '"' & $path_Devcon & '" classes'
ConsoleWrite(_RunDevcon($strRun) & @CRLF)

; Anzeigen von Dateien, die jeweils mit den in der Setupklasse ports (Anschl�sse) enthaltenen
; Ger�ten verkn�pft sind
$strRun = '"' & $path_Devcon & '" driverfiles =ports'
ConsoleWrite(_RunDevcon($strRun) & @CRLF)

; Anzeigen der Ger�teinstanzen aller Ger�te , die auf dem lokalen Computer vorhanden sind.
$strRun = '"' & $path_Devcon & '" find *'
ConsoleWrite(_RunDevcon($strRun) & @CRLF)

; Anzeigen aller "nicht vorhandenen" Ger�te und vorhandenen Ger�te der Klasse ports (Anschl�sse).
; Dies schlie�t auch Ger�te ein, die entfernt wurden, Ger�te die von einem Steckplatz zu einem anderen
; Steckplatz versetzt wurden, und m�glicherweise auch Ger�te, die aufgrund einer BIOS-�nderung anders
; aufgez�hlt wurden.
$strRun = '"' & $path_Devcon & '" findall =ports'
ConsoleWrite(_RunDevcon($strRun) & @CRLF)

; Anzeigen aller vorhandenen Ger�te aller angegebenen Klassen (in diesem Fall der Klassen "USB" und "1394").
$strRun = '"' & $path_Devcon & '" listclass usb 1394'
ConsoleWrite(_RunDevcon($strRun) & @CRLF)

; Anzeigen der Ressourcen, die von den Ger�ten der Setupklasse USB verwendet werden.
$strRun = '"' & $path_Devcon & '" resources =usb'
ConsoleWrite(_RunDevcon($strRun) & @CRLF)

Func _RunDevcon($strRun)
    Local $data, $foo = Run("cmd.exe", @SystemDir, @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD)
    StdinWrite($foo, $strRun & @CRLF)
    StdinWrite($foo)
    While True
        $data &= StdoutRead($foo)
        If @error Then ExitLoop
        Sleep(25)
    WEnd
    Local $split = StringSplit($data, @LF)
    $data = ''
    For $i = 5 To $split[0]
        If StringStripWS($split[$i], 8) == '' Then ExitLoop
        $data &= $split[$i]
    Next
    Return $data
EndFunc
