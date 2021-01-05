; --------------------------------------------------------------------------------------------------
;
; AutoIt Version:	3.0
; Language:		English
; Platform:		Windows 2000 / XP
; Author:		Michael Müller Nicolaisen
;
; Script Function:	Adobe creative suite 1 click installer (unattended)
; Script Version:	1.1	
;
; Date:			19 september 2005
; Last updated:		23 september 2005
;
; Versin history
; 1.1 Added function to check if adobe cs is installed, if so the installation quits  
; 1.0 The installer is now working.
;
; --------------------------------------------------------------------------------------------------

; CHECK IF PROGRAM IS INSTALLED
$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D52ECEBC-9B20-41A5-81C4-A62DE2367419}", "ProductsInstalled")

; if string is empty then the program is not installed and we can go on
; if the string is not empty some of adobe cs programs are installed and we must quit
If $var <> "" Then
    MsgBox(4096,"CS INSTALLED","THE FOLLOWING ADOBE CS PROGRAMS WAS DETECTED: " & $var)
    exit

EndIf
; END OF CHECK PROGRAM, IF WE ARE HERE NOW CS WAS NOT DETECTED AND WE CAN START THE INSTALL

; start installer
run("setup.exe")

; ---------------------------
; Welcome - Registration
; ---------------------------
WinWaitActive("","Welcome")

;enter name
send("{TAB}")
ControlSend("", "Welcome", "Edit1", "Medieskolerne")

;enter company
send("{TAB}")
ControlSend("", "Welcome", "Edit2", "Medieskolerne")

;enter serial
ControlSend("", "Welcome", 15221, "1111")
ControlSend("", "Welcome", 15222, "2222")
ControlSend("", "Welcome", 15223, "3333")
ControlSend("", "Welcome", 15224, "4444")
ControlSend("", "Welcome", 15225, "5555")
ControlSend("", "Welcome", 15226, "6666")

;click next
Send("!x")

; ---------------------------
; Licens agreement
; ---------------------------
WinWaitActive("","To continue installing, you must accept the End User License Agreement.")
Send("!c")

; ---------------------------
; Select applications 
; ---------------------------
WinWaitActive("","Please select which components to install and where to place them.")

;Move combobox down to "selected components", instead of "entire suite"
send("{DOWN}")

; chose the applications to install, and deselect the ones we dont need, 
; by default all are checked, so we need to send mouseclicks to the ones we dont need
ControlClick("","Please select which components to install and where to place them.",30002) ; Acrobat 6.0 professional
;ControlClick("","Please select which components to install and where to place them.",30003) ; Golive
ControlClick("","Please select which components to install and where to place them.",30004) ; Illustrator
ControlClick("","Please select which components to install and where to place them.",30005) ; Indesign
;ControlClick("","Please select which components to install and where to place them.",30006) ; Photoshop & Image Ready
ControlClick("","Please select which components to install and where to place them.",30007) ; Version cue

;click next
Send("x")

; ---------------------------
; Summary 
; ---------------------------
WinWaitActive("","Each component will install individually.")
Send("!i")

; ---------------------------
; Installation complete and registration
; ---------------------------
WinWaitActive("","Installation is complete.")
Send("!n")
Send("!h")