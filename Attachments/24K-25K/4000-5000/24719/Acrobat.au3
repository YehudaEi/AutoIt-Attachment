#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=zurichlogo.ico
#AutoIt3Wrapper_outfile=PDF-Compare.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;
; AutoIt Version: 3.0
; Language:       german
; Platform:       Win9x/NT
; Author:         
;
; Script Function:
;   Opens Acrobat
;


; Prompt the user to run the script - use a Yes/No prompt (4 - see help file)
$answer = MsgBox(4, "PDF Compare", "Soll der PDF Compare gestartet werden? ")


; Check the user's answer to the prompt (see the help file for MsgBox return values)
; If "No" was clicked (7) then exit the script
If $answer = 7 Then
    MsgBox(0, "AutoIt", "OK.  Tschüß!")
    Exit
EndIf

; Run Acrobat
Run("C:\Program Files\Adobe\Acrobat_Pro_6_DE\Acrobat\Acrobat.exe")

; Wait for Acrobat
WinWaitActive("Adobe ")
Send("{alt}o")
Send("v")


#region --- öffnen IST Dokument --- 
Send("!w")

;Variable Pfadangabe IST beim Aufruf implementieren - ToDo
send("C:\Documents and Settings\deb8624\My Documents\BPI\Klandt_Hoffmann_auTest\test_bpi_MuP_iter_orig\pdf")
Send("{ENTER}")
WinWait("Öffnen")

Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)
WinWait("Öffnen","&Suchen in:")
If Not WinActive("Öffnen","&Suchen in:") Then WinActivate("Öffnen","&Suchen in:")
WinWaitActive("Öffnen","&Suchen in:")
MouseMove(126,75)
MouseDown("left")
MouseUp("left")
Send("{ALTDOWN}f{ALTUP}")
WinWait("Dokumente vergleichen","Vi&suelle Unterschie")
If Not WinActive("Dokumente vergleichen","Vi&suelle Unterschie") Then WinActivate("Dokumente vergleichen","Vi&suelle Unterschie")
WinWaitActive("Dokumente vergleichen","Vi&suelle Unterschie")
#endregion --- 

#region --- öffnen Soll Dokument --- 
Send("{ALTDOWN}h{ALTUP}")

; Variable Pfadangabe SOLL beim Aufruf implementieren - ToDo
send("C:\Documents and Settings\deb8624\My Documents\BPI\Klandt_Hoffmann_auTest\test_bpi_MuP_iter_orig\soll")
;send("..\soll")

Opt("WinWaitDelay",100)
Send("{ENTER}")

WinWait("Öffnen")

Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)

WinWait("Öffnen","&Suchen in:")
If Not WinActive("Öffnen","&Suchen in:") Then WinActivate("Öffnen","&Suchen in:")
WinWaitActive("Öffnen","&Suchen in:")
MouseMove(126,75)
MouseDown("left")
MouseUp("left")
Send("{ALTDOWN}f{ALTUP}")
WinWait("Dokumente vergleichen","Vi&suelle Unterschie")
If Not WinActive("Dokumente vergleichen","Vi&suelle Unterschie") Then WinActivate("Dokumente vergleichen","Vi&suelle Unterschie")
WinWaitActive("Dokumente vergleichen","Vi&suelle Unterschie")
   #endregion --- 
   
   #region --- Compare Starten
   send("Class:Buttton;Instance:9") ;button Auswählen
   Send("{ENTER}")
   #endregion --- 
   
#region --- Save
WinWaitActive("Adobe ")
Send("!d")
send("p")
Send("{ENTER}")
   #endregion --- 



