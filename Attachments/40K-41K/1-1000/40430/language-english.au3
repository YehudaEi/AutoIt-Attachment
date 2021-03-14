;------------English--------------------------
Func _LanguageEnglish()

Global $adminmessage1 = "Administrator rights required"
Global $adminmessage2 = "Use an account that has sufficient rights, USSU Unlimited will quit now."
;------------update checker---------------------
Global $adminupdate1 = "USSU Unlimited online update checker. "
Global $adminupdate2 = "Online version: "
Global $adminupdate3 = "Current version: "
Global $adminupdate4 = "Click below to download the latest version."
Global $adminupdate5 = "THIS SOFTWARE MAY ONLY BE USED FREE OF CHARGE AT OWN RISK."
Global $adminupdate6 = "Download update|Info|Close"
Global $adminupdate7 = "Newer version available"
;------------User account control------------------
Global $adminuac1 = "User Account Control is turned on, "
Global $adminuac2 = "to ensure proper program functionality please turn it off by clicking the 'Turn off' button. This will disable 'User Account Control' while USSU Unlimited is running, it will be turned back on when it's finished."
Global $adminuac3 = "Click on the 'Leave on' button if you want to leave it on*."
Global $adminuac4 = "*This can prevent definitions from being downloaded properly."
Global $adminuac5 = "Turn off| Leave on | Don't show again"
Global $adminuac6 = "User Account Control notice."
;-----------Install Variables--------------------------------

Global $updatenow = "Update now"
Global $installnow = "Install now"
Global $installenglish = "English version"
Global $installdutch = "Dutch version"
Global $installgerman = "German version"
Global $installfrench = "French version"
Global $installspanish = "Spanish version"
Global $installitaliano = "Italian version"

Global $installnow2 = "Install Microsoft Security Essentials"
Global $installnow3 = "Install Avast 7"
Global $installnow4 = "Install Avira 2013"
Global $installnow5 = "Install AVG 2013"

Global $skipupdate = "Skip update"
Global $skipinstall = "Skip install"
Global $noupdateneeded = "No update needed"
Global $updateanyway = "Update anyway"

;------------------auto vs expert items-----------------------------
Global $adminmodeitem1 = "Expert Mode or Auto mode"
Global $adminmodeitem2 = "Expert Mode "
Global $adminmodeitem2_1 = " *Expert Mode: You can choose what you want to install or skip updates."
Global $adminmodeitem3 = "Shows information about Expert and Install mode."
Global $adminmodeitem3_1 = "Click here to tell me how this works."
Global $adminmodeitem4 = "Auto Mode "
Global $adminmodeitem4_1 = "*Auto Mode: The program runs the pre-determined settings."
Global $adminmodeitem5 = "I agree to the general disclaimer."
Global $adminmodeitem6 = "   Click here to read the Disclaimer 'PDF' "
Global $adminmodeitem7 = "I agree to the general disclaimer."
Global $adminmodeitem8 = "Disclaimer not checked"
Global $adminmodeitem8_1 = "Please agree to the disclaimer first. "
Global $adminmodeitem10 = "Expert Mode:"
Global $adminmodeitem11 = "Lets you decide what to update/install. This mode needs to run once before you can properly use 'Auto mode'."
Global $adminmodeitem12 = "Auto Mode:"
Global $adminmodeitem13 = "After you configured which application you want using 'Expert mode' you can update them all at once by just clicking the 'Auto' button."
Global $adminmodeitem14 = "OK"
Global $adminmodeitem15 = "Auto vs. Expert"


;------------------Menu items-----------------------------
Global $adminmenu1 = "USSU Unlimited version checker "
Global $adminmenu2 = "File"
Global $adminmenu3 = "Save" & @Tab & "Ctrl+S"
Global $adminmenu4 = "Exit"
Global $adminmenu5 = "Options"
Global $adminmenu6 = "Restart USSU Unlimited" & @Tab & "Ctrl+R"
Global $adminmenu7 = "Show Logfiles"& @Tab &"Ctrl+L"
Global $adminmenu8 = "Edit update values"
Global $adminmenu9 = "Help"
Global $adminmenu10 = "Check for USSU Unlimited updates"& @Tab &"Ctrl+U"
Global $adminmenu11 = "Details USSU Unlimited"
Global $adminmenu12 = "Report errors"
Global $adminmenu13 = "Feature request"
Global $adminmenu14 = "About"
Global $adminmenu15 = "Language settings"
Global $adminmenu16 = "English"
Global $adminmenu17 = "Nederlands"
Global $adminmenu18 = "Français"
Global $adminmenu19 = "Deutsch"
Global $adminmenu19_1 = "Italiano"
Global $adminmenu20 = "Schedule auto start"& @Tab &"Ctrl+T"
Global $adminmenu21 = "Settings saved"
Global $adminmenu22 = "Graphic mode" & @TAB & "F10"
Global $adminmenu23 = "Minimized mode" & @TAB & "F9"

;-----------------TAB ITEMS---------------------------
Global $admintabnames1 = "Runtimes - Plugins - PDF - Compression"
Global $admintabnames2 = "Browsers - Media - Utilities"
Global $admintabnames3 = "Documents - Imaging - Others "
Global $admintabnames4 = "Custom software"
Global $admintabnames5 = "Security software"

Global $admintabitems1 = "Application"
Global $admintabitems2 = "Installed version"
Global $admintabitems3 = "Newest version(s)"
Global $admintabitems4 = "Update options"
Global $admintabitems5 = "ON | OFF"
Global $admintabitems6 = " ON"
Global $admintabitems7 = "OFF"

Global $admintabitems8 = "Not installed"
Global $admintabitems9 = "Newer version found"
Global $admintabitems10 = "Older version installed"
Global $admintabitems10_1 = "Updates available! - click to install"

Global $admintabitems11 = "Custom applications options"
Global $admintabitems12 = "Custom applications"

;----------------------Security Applications--------------------

Global $admintabitems13 = "Security applications"
Global $admintabitems14 = "Choose antivirus"
Global $admintabitems15 = "Listed in this section is the Antivirus/Firewall program you are currently using."
Global $admintabitems16 = "Antivirus checker."
Global $admintabitems17 = "Currently installed"

;----------------------items below applications (check boxes, buttons)------------------------

Global $admincheckboxitems1 = "Click to perform selected installations and updates...."
Global $admincheckboxitems2 = "Click here to start the installation."
Global $admincheckboxitems3 = "Switch to next application tab...."
Global $admincheckboxitems4 = "Show me the next application tab."
Global $admincheckboxitems5 = "Switch to previous application tab...."
Global $admincheckboxitems6 = "Show me the previous application tab."
Global $admincheckboxitems7 = "Show PC Info "
Global $admincheckboxitems8 = "Show detailed PC information."
;--------------------------checkboxes--------------------------------------------------------------
Global $admincheckboxitems9 = "Create system restore point"
Global $admincheckboxitems10 = "Install Microsoft updates"
Global $admincheckboxitems11 = "Display logfile after completion"
Global $admincheckboxitems12 = "Email logfile after completion"
Global $admincheckboxitems13 = "Restart system after completion"
Global $admincheckboxitems14 = "Shutdown system after completion"
Global $admincheckboxitems15 = "Disable restore point?"
Global $admincheckboxitems16 = " Disable 'create restore point' ? "
Global $admincheckboxitems17 = "Don't create a restore point. I'm familiar with the risk."
Global $admincheckboxitems18 = "No. Get me outta here."

;---------------------------PC INFO screen---------------------------------------------------------------
Global $adminpcinfoitems1 = "Basic PC details"
Global $adminpcinfoitems2 = "< Hide PC info"
Global $adminpcinfoitems3 = "Windows key finder >"
Global $adminpcinfoitems4 = "System info creator >"
Global $adminpcinfoitems5 = "Getting basic info..."
Global $adminpcinfoitems6 = "One moment please"
Global $adminpcinfoitems7 = "Hostname: "
Global $adminpcinfoitems8 = "OSversion: "
Global $adminpcinfoitems9 = "Domain: "
Global $adminpcinfoitems10 = "IP: "
Global $adminpcinfoitems11 = "Current user: "

;-------------------------------------------- msgbox items -------------------------------------------------
Global $adminmsgboxitems1 = " Don't show again"

;---------------------Task scheduler--------------------------------------------------------------------------

Global $adminscheduleitem1 = "Schedule USSU Unlimited"
Global $adminscheduleitem2 = "Configure the schedule below when you want to run USSU Unlimited."
Global $adminscheduleitem3 = "Every: "
Global $adminscheduleitem4 = "Week(s)"
Global $adminscheduleitem5 = "Month(s)"
Global $adminscheduleitem6 = "Day"
Global $adminscheduleitem7 = "At: "
Global $adminscheduleitem8 = "On:"
Global $adminscheduleitem9 = "SUNDAY"
Global $adminscheduleitem10 = "MONDAY"
Global $adminscheduleitem11 = "TUESDAY"
Global $adminscheduleitem12 = "WEDNESDAY"
Global $adminscheduleitem13 = "THURSDAY"
Global $adminscheduleitem14 = "FRIDAY"
Global $adminscheduleitem15 = "SATURDAY"
Global $adminscheduleitem16 = "Create schedule"
Global $adminscheduleitem17 = "Don't schedule"

;-------------------------Custom Applications -----------------------------------------------------

Global $admincustomitem1 = "' Custom applications ' "
Global $admincustomitem2 = "What can I use it for ? "
Global $admincustomitem3 = "- Use it to add any kind of silent executable. "
Global $admincustomitem4 = "It can be an .exe .msi or any other kind of silent installer."
Global $admincustomitem5 = "What do I need to get started? "
Global $admincustomitem6 = "- Download link 'http or https'. "
Global $admincustomitem7 = "- Name of the downloaded installer 'example.exe, example.msi'."
Global $admincustomitem8 = "- Silent install switch for example: /s /quiet /norestart."
Global $admincustomitem9 = "* You can add install packages which are already silent executable. "
Global $admincustomitem10 = "Click the button 'example' below to fill out an example. "
Global $admincustomitem11 = "Don't forget to save the added applications when you are finished. "
Global $admincustomitem12 = "OK|Example"
Global $admincustomitem13 = "How to: custom applications"
Global $admincustomitem14 = "Example app"
Global $admincustomitem15 = "http://www.mydownloadlocation/installer.exe"
Global $admincustomitem16 = "installer.exe"
Global $admincustomitem17 = "/silent /norestart /sp"
Global $admincustomitem18 = "Turn custom applications on."
Global $admincustomitem19 = "Turn custom applications off."
Global $admincustomitem20 = "Erase all custom applications."
Global $admincustomitem21 = "Click here to tell me how 'custom applications' works."
Global $admincustomitem22 = "Save custom application settings."
Global $admincustomitem23 = "Installer link:"
Global $admincustomitem24 = "Filename:"
Global $admincustomitem25 = "Installer link:  http, https or ftp"
Global $admincustomitem26 = "Application name"
Global $admincustomitem27 = "Filename: example.exe, example.msi"
Global $admincustomitem28 = "Install switches: /silent /norestart /sp"
Global $admincustomitem29 = ""
Global $admincustomitem30 = ""
Global $admincustomitem31 = ""
Global $admincustomitem32 = ""
Global $admincustomitem33 = ""
Global $admincustomitem34 = ""
Global $admincustomitem35 = ""


;-----------------------------About Summary menu screen----------------------------------

Global $adminaboutmenuitem1 = "USSU Unlimited "
Global $adminaboutmenuitem2 = "Version: "
Global $adminaboutmenuitem3 = "Update Definitions "
Global $adminaboutmenuitem4 = "Created && Coded by:  Jochem de Hoog"
Global $adminaboutmenuitem4_1 = "Testers and support: You know who you are!"
Global $adminaboutmenuitem5 = "License: Freeware."
Global $adminaboutmenuitem6 = "currently running in: "
Global $adminaboutmenuitem7 = " mode."
Global $adminaboutmenuitem8 = "THIS SOFTWARE MAY ONLY BE USED FREE OF CHARGE AT OWN RISK."
Global $adminaboutmenuitem9 = "OK|Disclaimer"
Global $adminaboutmenuitem10 = "About USSU Unlimited"
Global $adminaboutmenuitem11 = "Translations made by:"
Global $adminaboutmenuitem12 = "OK"
Global $adminaboutmenuitem13 = "Disclaimer"


;-----------------------------Update menu screen----------------------------------

Global $adminupdatemenuitem1 = "USSU Unlimited Update checker. "
Global $adminupdatemenuitem2 = "Online version: "
Global $adminupdatemenuitem3 = "Current version: "
Global $adminupdatemenuitem4 = "Chooce the buttons below to download the preferred newer version."
Global $adminupdatemenuitem5 = "THIS SOFTWARE MAY ONLY BE USED FREE OF CHARGE AT OWN RISK."
Global $adminupdatemenuitem6 = "Update|Info|Close"
Global $adminupdatemenuitem7 = "Update checker 'newer version available.' "
Global $adminupdatemenuitem8 = "Update checker"
Global $adminupdatemenuitem9 = " is the latest."
Global $adminupdatemenuitem10 = ""
Global $adminupdatemenuitem11 = ""
Global $adminupdatemenuitem12 = ""
Global $adminupdatemenuitem13 = ""
Global $adminupdatemenuitem14 = ""
Global $adminupdatemenuitem15 = ""

;-----------------------------Trayitems----------------------------------------------

Global $admintrayitems1 = "Graphic mode" & @TAB & "F10"
Global $admintrayitems2 = "Minimized mode" & @TAB & "F9"
Global $admintrayitems3 = "No updates available"
Global $admintrayitems4 = "All supported programs are up-to-date."
Global $admintrayitems5 = "Update software"
Global $admintrayitems6 = "Automaticly refresh definitions"
Global $admintrayitems7 = ""
Global $admintrayitems8 = ""

;---------------------------Installer menu items ---------------------------------------

Global $admininstalleritems1 = "USSU Unlimited completed the requested installations."
Global $admininstalleritems2 = "Restart USSU"
Global $admininstalleritems2_1 = "Close"
Global $admininstalleritems3 = "Congratulations! Installations completed successfully."
Global $admininstalleritems4 = "Run on system startup"

;--------------------Declaratie programma's versie nummers en labels
Global $installatie = "Currently busy with......: "
Global $stagelabel1 = "Stage 1 from 6." & " 'Runtimes, Plugins, PDF..'."
Global $stagelabel2 = "Stage 2 from 6." & " 'Browsers, Media, Utilities..'."
Global $stagelabel3 = "Stage 3 from 6." & " 'Documents, Imaging, Others..'."
Global $stagelabel4 = "Stage 4 from 6." & " 'Custom applications'."
Global $stagelabel5 = "Stage 5 from 6." & " 'Security applications'."
Global $stagelabel6 = "Stage 6 from 6." & " 'Finalizing'."

;---------------Downloader information ------------------

Global $downloaderstatus = "No running downloads"

EndFunc
