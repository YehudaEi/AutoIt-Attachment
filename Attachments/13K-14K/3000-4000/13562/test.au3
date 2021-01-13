; auto install voor laptop vincent
; begin datum:  4-3-2007
;laatst bij gewerkt : 4-3-2007
; de bedoeling is dat ik als mijn Laptop wordt op geschoond de meeste dingen weer automatisch installeerd.
; zoals voor mij office xp, brother DCP 115C software, games, mplab 7.0 , hamachi , winrar , enz
; onder de games vallen:
; C&C Generals, C&C Generals zero hour, Rome total war, Counterstrike source, pkr en scarlet poker.
; English:
; the meaning of this project is that when i need to reinstall my pc that the most things i regularly use
; some what auto matticly install themselfes on the pc.
; the soft ware i want to auto install are:
; office xp, brother DCP 115C software, mplab 7.0 , hamachi , winrar, C&C Generals, C&C Generals zero hour,
; Rome total war, Counterstrike source, pkr and scarlet poker.
; making the choise what to install
; 1 = all
; 2 = only the games
; 3 = only the software
$choise = inputbox("Auto install","geef aan wat u wilt doen 1: alles installeren 2: alleen games 3: alleen software", "?")
Select
Case $choise = "1" 
	MsgBox(0, "Full install", "u heeft optie 1 geselecteerd alles wordt nu geinstalleerd.")
	call("instAll")
Case $choise = "2" 
         MsgBox(0, "Alleen Games", "u heeft optie 2 geselecteerd alleen de games zullen worden geinstalleerd")
		 call("GamesOnly")
Case $choise = "3" 
         MsgBox(0, "Alleen Software", "u heeft optie 3 geselecteerd alleen de software zal nu worden geinstalleerd")
		 call("SoftwareOnly")
	 EndSelect
; de volgende functies zijn de installatie onderdelen.
; the next functions are for seperate installations parts software and games.
Func instAll()
	MsgBox( 48, "Muis en toetsenbord", "De muis en het toetsenbord worden nu uitggeschakeld.", 10)
	BlockInput(1)
	beep(100, 100)
	call("SoftwareOnly")
	Call("GamesOnly")
	BlockInput(0)
	MsgBox(48,"All Done", "Alle software is geinstalleerd.")
EndFunc

Func GamesOnly()
	msgbox(0,"Games","Games worden geinstalleerd.", 4)
	if FileExists("c:\program files\D-Tools") then
    Run("daemon.exe")
	if FileExists("D:\software disks\") Then
		MsgBox( 0,"exists", "File does exist.",3)
		EndIf
	;run(".exe","D:\software disks\") 
EndIf
EndFunc
func SoftwareOnly()
MsgBox(0,"Software", "Software wordt geinstalleerd.", 4)
EndFunc