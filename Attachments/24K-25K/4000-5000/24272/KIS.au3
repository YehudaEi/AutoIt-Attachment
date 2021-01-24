; ----------------------------------------------------------------------------
;
; Kaspersky Internet Security 2009 (8.0.506)
; Language:       English
; Creator: 		  SIMurq
; Version:	      1.0
; ----------------------------------------------------------------------------


;Extraction & Initial Setup
Run("kis80506.exe")

;Initial Setup
WinWaitActive("Kaspersky Internet Security 2009 Setup", "Welcome to the Kaspersky Setup Wizard")
ControlClick("Kaspersky Internet Security 2009 Setup", "", "Button2")

;Extraction
WinWaitActive("Kaspersky Internet Security 2009 Setup", "Choose Unpack Location")
Send("C:\Documents and Settings\All Users\Application Data\Kaspersky Lab Setup Files\Kaspersky Internet Security 2009\english")
ControlClick("Kaspersky Internet Security 2009 Setup", "", "Button2")

;Run Kaspersky Setup
WinWaitActive("Kaspersky Internet Security 2009 Setup", "Unpacking of Kaspersky Setup is complete.")
ControlClick("Kaspersky Internet Security 2009 Setup", "", "Button2")

;Skip cheking newer version
WinWaitActive("Kaspersky Internet Security 2009 Setup", "Establishing connection...")
ControlClick("Kaspersky Internet Security 2009 Setup", "", "Button1")

;Actual installation
WinWaitActive("Kaspersky Internet Security 2009", "Welcome to Kaspersky Internet Security 2009 Setup Wizard")
ControlClick("Kaspersky Internet Security 2009", "", "Button1")

;License
WinWaitActive("Kaspersky Internet Security 2009", "Standard End User License Agreement")
ControlClick("Kaspersky Internet Security 2009", "", "Button2")
ControlClick("Kaspersky Internet Security 2009", "", "Button5")

;Install type selection
WinWaitActive("Kaspersky Internet Security 2009", "Installation type")
ControlClick("Kaspersky Internet Security 2009", "", "Button1")

;Start install
WinWaitActive("Kaspersky Internet Security 2009", "Ready to install")
ControlClick("Kaspersky Internet Security 2009", "", "Button3")

;End install
WinWaitActive("Kaspersky Internet Security 2009", "Welcome")
Send("{ENTER}")

;Wizard Start
WinWaitActive("Kaspersky Internet Security Configuration Wizard", "&Next")
Send("!n")

;Activation
WinWaitActive("Kaspersky Internet Security Configuration Wizard", "Activate your copy of Kaspersky Internet Security")
Send("!l")

;Feedback
WinWaitActive("Kaspersky Internet Security Configuration Wizard", "Feedback")
Send("{TAB}")
Send("{TAB}")
Send("{SPACE}")
Send("!n")

;Restart
WinWaitActive("Kaspersky Internet Security Configuration Wizard", "Restart")
Send("!r")
Send("!f")