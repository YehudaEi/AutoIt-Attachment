Run("Setup.exe")
WinWaitActive("Home Cinema Setup")
Send("!s")
WinWaitActive("Home Cinema Setup", "Contrat de Licence Utilisateur Final")
Send("!o")
WinWaitActive("Home Cinema Setup", "Veuillez entrer votre nom, et le nom de la soci�t� qui vous emploie.")
Send("!s")
WinWaitActive("Home Cinema Setup", "installation installera Home Cinema dans le dossier suivant.")
Send("!s")
WinWaitActive("Home Cinema Setup", "installation ajoutera les ic�nes de programmes au dossier de programme inscrit ci-dessous.")
Send("!s")
WinWaitActive("Home Cinema Setup", "Please select the software you want to install from the following list.")
Send("!s")
WinWaitActive("Home Cinema Setup", "installation de Home Cinema est termin�e.")
Send("{TAB}")
Send("{SPACE}")
Send("{TAB}")
Send("{SPACE}")
Send("!T")
