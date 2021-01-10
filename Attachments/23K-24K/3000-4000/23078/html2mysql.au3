#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
; 0. Variables et fichier de configuration
$url_serveur_edition = IniRead("config.ini","config","url_serveur_edition","                                                             ")
$url_serveur_artist = IniRead("config.ini","config","url_serveur_artist","")
$local_edition = IniRead("config.ini","config","local_edition","F:\Projets\magic\3 - www\images\editions")
$local_artist = IniRead("config.ini","config","local_artist","F:\Projets\magic\3 - www\images\artistes")
$force_download = IniRead("config.ini","config","force_download",0)
$mysql_server = IniRead("config.ini","config","mysql_server","localhost")
$mysql_database = IniRead("config.ini","config","mysql_database","magic")
$mysql_user = IniRead("config.ini","config","mysql_user","root")
$mysql_password = IniRead("config.ini","config","mysql_password","numeris")
$mysql_driver = IniRead("config.ini","config","mysql_driver","MySQL ODBC 5.1 Driver")

$output_master_edition = FileOpen(@ScriptDir &"\master_edition.txt",2)
$output_short_edition = FileOpen(@ScriptDir &"\short_edition.txt",2)
$output_artist = FileOpen(@ScriptDir &"\artist.txt",2)

$no_ligne_search = 560
$a_master = 0
$no_ligne_artist = 570


; ********* GESTION EDITIONS
; 1. Téléchargement pages html base des éditions/liste illustrateur et ouverture des fichiers
if Not FileExists(@ScriptDir &"\editions.html") OR $force_download = 1 Then
	$download = InetGet($url_serveur_edition,@ScriptDir &"\editions.html",1)
Else
	$download = 1
EndIf
if $download = 1 Then
	$base_edition = FileOpen(@ScriptDir &"\editions.html",0)
	if @error Then
		MsgBox(0,"Erreur","Le fichier editions.html n'a pu être trouvée")
		Exit
	EndIf
Else
	MsgBox(0,"Erreur","Le fichier d'éditions n'a pu être téléchargé")
	Exit
EndIf

if Not FileExists(@ScriptDir &"\illustrateurs.html") OR $force_download = 1 Then
	$download = InetGet($url_serveur_artist,@ScriptDir &"\illustrateurs.html",1)
Else
	$download = 1
EndIf
if $download = 1 Then
	$base_illustrateur = FileOpen(@ScriptDir &"\illustrateurs.html",0)
	if @error Then
		MsgBox(0,"Erreur","Le fichier illustrateurs.html n'a pu être trouvée")
		Exit
	EndIf
Else
	MsgBox(0,"Erreur","Le fichier d'illustrateurs n'a pu être téléchargé")
	Exit
EndIf

; 2. Ecriture des en-têtes CSV
FileWriteLine($output_master_edition,"ID"& chr(9) &"name")
FileWriteLine($output_short_edition,"ID"& chr(9) &"ID_master"& chr(9) &"name")
FileWriteLine($output_artist,"ID"& chr(9) &"name")

; 3. EDITIONS : Analyse du fichier de base html vers 2 fichiers CSV
While 1
	; Debug
	ExitLoop
	
	$line = FileReadLine($base_edition,$no_ligne_search)
	If @error = -1 Then
		ExitLoop
	EndIf
	if stringInStr($line,"<p align=""right"">Modérateurs Cartes&nbsp;",1) Then
		ExitLoop
	EndIf
	if StringInStr($line,"<p align=""right"">") Then
		$a_master = $a_master + 1
		$edition = StringSplit($line,"<p align=""right"">",1)
		$edition = StringSplit($edition[2],"&nbsp;",1)
		$master_edition = $edition[1]
		FileWriteLine($output_master_edition,$a_master & chr(9) & $master_edition)
		$no_ligne_search = $no_ligne_search + 3
		$line = FileReadLine($base_edition,$no_ligne_search)
		$splitline = StringSplit($line,"<td",1)
		for $a = 2 To $splitline[0] - 2
			$new_line = StringSplit($splitline[$a],"""",1)
			if $new_line[0] >= 23 OR $new_line[0] = 17 Then
				$sous_edition = $new_line[16]
			Else
				$sous_edition = $new_line[12]
			EndIf
			$new_line1 = StringSplit($new_line[2],"-",1)
			$id_edition = $new_line1[4]
			InetGet("                                "& $new_line[4],$local_edition &"\"& $id_edition &".gif",1)
			FileWriteLine($output_short_edition,$id_edition & chr(9) & $a_master & chr(9) & $sous_edition)
		Next
	EndIf
$no_ligne_search = $no_ligne_search + 1
WEnd

; 4. ARTISTES : Analyse du ficheir de base html vers un fichier csv
$line = FileReadLine($base_illustrateur,$no_ligne_artist)
$split = StringSplit($line,"</table>",1)
$split = StringSplit($split[1],"</tr>",1)
ConsoleWrite("Debug:  $line length = " & Stringlen($line) & @LF)
ConsoleWrite("Debug:  Binary $line length = " & BinaryLen(Binary($line)) & @LF)
ConsoleWrite("Debug:  split[0] = " & $split[0] & @LF)
FileDelete("debug.txt")
FileDelete("debug_line.txt")
FileWriteLine("debug_line.txt",$line)
For $zae = 1 to $split[0] Step 1
	;FileWriteLine("debug.txt",$split[$zae])
Next
Exit
For $a_artist = 249 to $split[0] Step 1
	MsgBox(0,$a_artist,$split[$a_artist])
	$split_artist = StringSplit($split[$a_artist],"</a>",1)
	$split_artist = StringSplit($split_artist[1],">",1)
	$name_artist = $split_artist[$split_artist[0]]
	$split_idartist = StringSplit($split_artist[1],"""",1)
	if $a_artist = 1 Then
		$split_artist = StringSplit($split_artist[4],"-",1)
	Else
		$split_artist = StringSplit($split_artist[3],"-",1)
	EndIf
	if $split_artist[0] < 4 Then
		MsgBox(0,$a_artist,$split_artist[0])
	Else
		MsgBox(0,$a_artist,$split_artist[0])
	EndIf
	FileWriteLine($output_artist,$split_artist[4] & chr(9) & $name_artist)
Next

; 4. Mise à jour MySQL
;LogParser.exe "SELECT * INTO master_edition FROM master_edition.txt" -i:TSV -o:SQL -server:localhost -database:magic -username:root -password:numeris -driver:"MySQL ODBC 5.1 Driver" -createTable:ON -ClearTable:ON
FileClose($output_master_edition)
FileClose($output_short_edition)
RunWait(@ComSpec & " /c " & "LogParser.exe ""SELECT ID,name INTO master_edition FROM master_edition.txt"" -i:TSV -o:SQL -server:"& $mysql_server &" -database:"& $mysql_database &" -username:"& $mysql_user &" -password:"& $mysql_password &" -driver:"""& $mysql_driver &""" -createTable:ON -ClearTable:ON",@ScriptDir,@SW_HIDE)
RunWait(@ComSpec & " /c " & "LogParser.exe ""SELECT ID,ID_master,name INTO short_edition FROM short_edition.txt"" -i:TSV -o:SQL -server:"& $mysql_server &" -database:"& $mysql_database &" -username:"& $mysql_user &" -password:"& $mysql_password &" -driver:"""& $mysql_driver &""" -createTable:ON -ClearTable:ON",@ScriptDir,@SW_HIDE)

; X. Fermeture des fichiers

FileClose($output_artist)