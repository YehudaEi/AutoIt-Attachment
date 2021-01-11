;
; Platform:       WinXP/Win2000
; Author:                                                       
;
; Script Function:
;   Install UltraVNC in Semiautomatic
;

#Region Compiler directives section
;** This is a list of compiler directives used by CompileAU3.exe.
;** comment the lines you don't need or else it will override the default settings
;#Compiler_Prompt=y                                  ;y=show compile menu
;** AUT2EXE settings
;#Compiler_AUT2EXE=
;#Compiler_Icon=au3.ico                              ;Filename of the Ico file to use
;#Compiler_OutFile=                                  ;Target exe filename.
#Compiler_Compression=4                             ;Compression parameter 0-4  0=Low 2=normal 4=High
#Compiler_Allow_Decompile=y                          ;y= allow decompile
;#Compiler_PassPhrase=                               ;Password to use for compilation
;** Target program Resource info
#Compiler_Res_Comment=UltraVNC automatic installer
#Compiler_Res_Description=Installiert UltraVNC ohne lästige Benutzerabfragen
#Compiler_Res_FileVersion_AutoIncrement=y
#Compiler_Res_Fileversion=0.0.1.11
#Compiler_Res_LegalCopyright= koala
; free form resource fields ... max 15
#Compiler_Res_Field=Email|    ;Free format fieldname|fieldvalue
;~ #Compiler_Res_Field=Release Date|07/21/2006          ;Free format fieldname|fieldvalue
;~ #Compiler_Res_Field=Update Date|                    ;Free format fieldname|fieldvalue
;~ #Compiler_Res_Field=Internal Name|FileProp2.exe    ;Free format fieldname|fieldvalue
;~ #Compiler_Res_Field=Status|Beta                     ;Free format fieldname|fieldvalue
#Compiler_Run_AU3Check=y                            ;Run au3check before compilation
#Compiler_AU3Check_Dat= ;Override the default au3check definition
#Compiler_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7 ;Au3Check parameters
;#Compiler_PlugIn_Funcs=
; The following directives can contain:
;   %in% , %out%, %icon% which will be replaced by the fullpath\filename.
;   %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.
#Compiler_Run_Before=                               ;process to run before compilation - you can have multiple records that will be processed in sequence
;#Compiler_Run_After=move "%out%" "%scriptdir%"      ;process to run After compilation - you can have multiple records that will be processed in sequence
#EndRegion
;~ #NoTrayIcon


;//////////////////
; Variablen Begin
;//////////////////

; Installationspfad fuer VNC; default c:\programme oder c:\program files
const $programpath = @ProgramFilesDir

; Pfad der VNC-Setupdatei
; Entweder einen direkten Pfad angeben, oder den aktuellen des ausführenden 
; Programmes nutzen. Dazu muss sich die VNC-Setupdatei im gleichen Verzeichnis befinden.
const $vnc_setuppfad = @ScriptDir
;const $vnc_setuppfad = "\\Pg01\tutti\SOFTWARE\Vnc"

; VNC-Dateiname der Setupdatei
const $vnc_name = "UltraVNC-102-Setup.exe"

; zu installierende UltraVNC-Version
const $vnc_version = "1.1.0.2"


; Achtung!
; Der Dateiname musste im FileInstall-Aufruf direkt eingegeben werden.
; Dieser ist dort evtl. auch noch zu aendern.
; Siehe: Setupdateien laden
const $vnc_config_de = "vncconfig_de.inf" ; Programmpfad: Programme
const $vnc_config_en = "vncconfig_en.inf" ; Programmpfad: Program Files
Const $vnc_config_it = "vncconfig_it.inf" ; Programmpfad: Programmi

;//////////////////
; Variablen End
;//////////////////


;
; Setupdateien laden
;
; Hier stehen die Setupdateien, die in das AutoIt-Script mit eincompiliert werden
; Der erste Wert von FileInstall muss ein String-Pfad sein. Er darf keine 
; Variable sein!
;FileInstall("c:\pathtoacl\vncaclconfig.acl", "c:\pathtoacl\vncaclconfig.acl", 1)
FileInstall("c:\tmp\vncconfig_de.inf", "c:\tmp\" & $vnc_config_de, 1)
FileInstall("c:\tmp\vncconfig_en.inf", "c:\tmp\" & $vnc_config_en, 1)
FileInstall("c:\tmp\vncconfig_it.inf", "c:\tmp\" & $vnc_config_it, 1)
FileInstall("c:\tmp\vncconfig.reg", "c:\tmp\vncconfig.reg", 1)








Local $vnc_config, $answer, $ver

; Prompt the user to run the script - use a Yes/No prompt (4 - see help file)
$answer = MsgBox(260, "UltraVNC automatic installation", "Dieses Script wird UltraVNC installieren. Start?")


; Check the user's answer to the prompt (see the help file for MsgBox return values)
; If "No" was clicked (7) then exit the script
If $answer = 7 Then
  ; the window will be close after 3 seconds
  MsgBox(0, "UltraVNC automatic installation", "OK, dann eben nicht.  Bye!", 5)
  Exit
EndIf


; Systemcheck und Zuweisung der Configdateien
if $programpath = "c:\Programme" OR $programpath = "c:\Program Files" OR $programpath = "c:\Programmi" Then
  Switch $programpath
    Case "c:\Programme" 
      $vnc_config = $vnc_config_de
    Case "c:\Program Files"
      $vnc_config = $vnc_config_en
    Case "c:\Programmi" 
      $vnc_config = $vnc_config_it
  EndSwitch
Else
  ; wenn der benötigte Programmpfad nicht stimmt, gib eine Meldung aus und 
  ; stoppe die weitere Ausfuehrung
  MsgBox(16, "UltraVNC automatic installation", 'Weder "Programme", "Programmi" noch "Program Files" sind vorhanden. Aktion abgebrochen.')
  ; Delete the Setup Configuration files if exists.
  DeleteTmpFiles()
  Exit
EndIf


; prüfe das vorhandensein der erwarteten Setupdatei
If Not $vnc_setuppfad &'\'& $vnc_name = FileExists($vnc_setuppfad &'\'& $vnc_name) Then
  ; wenn die benötigte Datei nicht existiert, gib eine Meldung aus und stoppe die weitere Ausfuehrung
  MsgBox(16, "UltraVNC automatic installation", 'Keine Setupdatei gefunden!' & @CRLF & _
        'Erwartet wurde: "' &$vnc_setuppfad&'\'&$vnc_name&'"' & @CRLF&@CRLF &'Aktion abgebrochen.')
  ; Delete the Setup Configuration files if exists.
  DeleteTmpFiles()
  Exit
EndIf


; prüfe ob der User Adminrechte hat (denn die sind für die Installation notwendig)
If Not IsAdmin() Then 
  MsgBox(16, "UltraVNC automatic installation", 'Zur Installation sind Administratorrechte notwendig.' & @CRLF & _
        'Starte das Programm als Administrator.' & @CRLF&@CRLF &'Aktion abgebrochen.')
  ; Delete the Setup Configuration files if exists.
  DeleteTmpFiles()
  Exit
EndIf


; prüfe ob es schon eine UltraVNC-Installation gibt und deren Version
If FileExists($programpath&'\UltraVNC\winvnc.exe') Then
  $ver = FileGetVersion(@ProgramFilesDir&'\UltraVNC\winvnc.exe')
  if $ver = '0.0.0.0' Then
    MsgBox(36, "UltraVNC automatic installation", 'Die Version einer bereits vorhandenen UltraVNC-Installation konnte nicht ermittelt werden.' &@CRLF& _
          'Dies stellt eigentlich keine Problem dar.' & @CRLF&@CRLF &'Möchtest du weitermachen?')
  ElseIf $ver = $vnc_version Then
    $answer = MsgBox(260, "UltraVNC automatic installation", 'UltraVNC in der Version "' & $vnc_version & _
                          '" ist berreits installiert.' & @CRLF&@CRLF & 'Willst du trotzdem installieren?')
    ; Check the user's answer to the prompt (see the help file for MsgBox return values)
    ; If "No" was clicked (7) then exit the script
    If $answer = 7 Then
      ; the window will be close after 5 seconds
      MsgBox(0, "UltraVNC automatic installation", "OK, dann eben nicht.  Bye!", 5)
      Exit
    EndIf
  EndIf
EndIf








; pruefe ob c:\tmp existiert, falls nicht, leg es an
If NOT FileExists("c:\tmp") Then
    DirCreate("C:\tmp")
EndIf




; bevor installiert wird, stoppe evtl. laufenden WinVNC
run("net stop WinVNC")

If Not $vnc_setuppfad = '' Then
  FileChangeDir($vnc_setuppfad)
EndIf

RunWait($vnc_name & " /verysilent /loadinf=C:\tmp\"&$vnc_config)

; im Originalforenbeitrag wird erwaehnt, dass die Datei mit den Registrydaten
; mit in die Config.inc-Datei soll (als Path...irgendwas)
; Das funktionierte aber bei mir nicht.
; Also rufe ich die regedit von Hand auf
;FileChangeDir("C:\tmp\")
RunWait("regedit /s c:\tmp\vncconfig.reg")
Sleep(3000)


DirCopy($programpath & "\UltraVNC\plugin", $programpath & "\UltraVNC")

; Register UltraVNC server as a sytem service.
FileChangeDir($programpath & "\UltraVNC")

Run("winvnc.exe -reinstall")

Sleep(3000)

; Start the server.
FileChangeDir($programpath & "\UltraVNC")

Run("net start WinVNC")
Sleep(3000)

; Start the system tray icon.
FileChangeDir($programpath & "\UltraVNC")
Run("winvnc.exe -servicehelper")

Sleep(3000)


; Delete the Setup Configuration files if exists.
DeleteTmpFiles()


MsgBox(0, "UltraVNC automatic installation", "Fertig.  Bye!", 5)
Exit



; Delete the Setup Configuration files if exists.
Func DeleteTmpFiles()
  ;FileDelete("C:\tmp\vncaclconfig.acl")
  If FileExists("c:\tmp\" & $vnc_config_de) Then 
    FileDelete("C:\tmp\" & $vnc_config_de)
  EndIf
  If FileExists("c:\tmp\" & $vnc_config_en) Then 
    FileDelete("C:\tmp\" & $vnc_config_en) 
  EndIf
  If FileExists("c:\tmp\" & $vnc_config_it) Then 
    FileDelete("C:\tmp\" & $vnc_config_it) 
  EndIf
  If FileExists("c:\tmp\vncconfig.reg") Then 
    FileDelete("C:\tmp\vncconfig.reg") 
  EndIf
  
EndFunc


