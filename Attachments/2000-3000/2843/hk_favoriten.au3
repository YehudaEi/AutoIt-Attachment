#include <GUIConstants.au3>
$destination1 = @TempDir & "\logo.jpg"
$destination2 = @TempDir & "\help.jpg"

FileInstall("e:\temp\logo.jpg", $destination1)
FileInstall("e:\temp\help.jpg", $destination2)

Opt("GUIOnEventMode", 1)
GUICreate("//HK-Vorlage", 620, 670)
GuiCtrlCreatePic($destination1,200,0, 106,52)


GUISetBkColor (0xE2E3E5)
$font="Verdana"
GUISetFont (10, 400,0, $font) 

$font="Comic Sans MS"
GUICtrlCreateLabel ("Version 0.9 Beta",10,730)
GUICtrlSetFont (-1,8, 400, 0, $font)


;---Falls Datei nicht vorhanden wird sie erstellt---
$file = FileOpen("d:\hk-vorlage.favoriten", 1)
FileClose($file)
;---------------------------------------------------

;--------------------------
Func CLOSEClicked()
    Exit
EndFunc
;--------------------------	

;--------------------------
Func CLOSEButton()
	Exit
endfunc
;--------------------------


Func CLOSEhelp()
	GUIDelete()
endfunc

;--------------------------
Func helpbutton()
	GUICreate("//Hilfe", 500, 500)
	GUISetState()
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEhelp")
	GuiCtrlCreatePic($destination2,0,0, 500,500)
	;$closebuttonhelp = GUICtrlCreateButton ("schliessen", 10, 10, 120, 25, $BS_FLAT)
	;GUICtrlSetOnEvent($closebuttonhelp, "CLOSEhelp")
endfunc
;--------------------------


;>>----------------------------FUNKTION Datei erstellen------------------------------
Func OKButton()
	$file = Fileopen("d:\hk-vorlage.favoriten", 2)
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
    		Exit
	EndIf
	;------------------------------WENN CHECK WIRD ZEILE GESCHRIEBEN-------------------------
      	if GUICtrlRead($check1) = $GUI_CHECKED then fileWriteLine($file, "[Geschäftsleitung]")
      	if GUICtrlRead($check2) = $GUI_CHECKED then FileWriteLine($file, "[H. Egenter]")
      	if GUICtrlRead($check3) = $GUI_CHECKED then FileWriteLine($file, "[Betriebsteil Künzelsau]")
      	if GUICtrlRead($check4) = $GUI_CHECKED then FileWriteLine($file, "[Betriebsteil Öhringen]")
      	if GUICtrlRead($check5) = $GUI_CHECKED then FileWriteLine($file, "[Änasthesiologie]")
      	if GUICtrlRead($check6) = $GUI_CHECKED then FileWriteLine($file, "[Innere Medizin Künzelsau]")
      	if GUICtrlRead($check7) = $GUI_CHECKED then FileWriteLine($file, "[Innere Medizin Öhringen]")
      	if GUICtrlRead($check8) = $GUI_CHECKED then FileWriteLine($file, "[Allgemeinchirurgie Künzelsau]")
      	if GUICtrlRead($check9) = $GUI_CHECKED then FileWriteLine($file, "[Allgemeinchirurgie Öhringen]")
      	if GUICtrlRead($check10) = $GUI_CHECKED then FileWriteLine($file, "[Unfallchirurgie Künzelsau]")
      	if GUICtrlRead($check11) = $GUI_CHECKED then FileWriteLine($file, "[Unfallchirurgie Öhringen]")
      	if GUICtrlRead($check12) = $GUI_CHECKED then FileWriteLine($file, "[Chir. Ambulanz]")
      	if GUICtrlRead($check13) = $GUI_CHECKED then FileWriteLine($file, "[Gyn / Geburtshilfe Öhringen]")
      	if GUICtrlRead($check14) = $GUI_CHECKED then FileWriteLine($file, "[Geriatrische Reha-Klinik]")
	if GUICtrlRead($check15) = $GUI_CHECKED then FileWriteLine($file, "[Hohenloher Seniorenbetreuung]")
	if GUICtrlRead($check16) = $GUI_CHECKED then FileWriteLine($file, "[Altenheim Krautheim]")
	if GUICtrlRead($check17) = $GUI_CHECKED then FileWriteLine($file, "[Altenheim Öhringen]")
	if GUICtrlRead($check18) = $GUI_CHECKED then FileWriteLine($file, "[Seniorenzentrum Forchtenberg]")
	if GUICtrlRead($check19) = $GUI_CHECKED then FileWriteLine($file, "[Seniorenzentrum Neuenstein]")
	if GUICtrlRead($check20) = $GUI_CHECKED then FileWriteLine($file, "[Seniorenzentrum Pfedelbach]")
	if GUICtrlRead($check21) = $GUI_CHECKED then FileWriteLine($file, "[Seniorenzentrum Dörzbach]")
	if GUICtrlRead($check22) = $GUI_CHECKED then FileWriteLine($file, "[EDV]")
	if GUICtrlRead($check23) = $GUI_CHECKED then FileWriteLine($file, "[Finanzen]")
	if GUICtrlRead($check24) = $GUI_CHECKED then FileWriteLine($file, "[Personal-Hanselmann]")
	if GUICtrlRead($check25) = $GUI_CHECKED then FileWriteLine($file, "[Personal-Merling]")
	if GUICtrlRead($check26) = $GUI_CHECKED then FileWriteLine($file, "[Personal-Reichert]")
	if GUICtrlRead($check27) = $GUI_CHECKED then FileWriteLine($file, "[Personal-Marinovic]")
	if GUICtrlRead($check28) = $GUI_CHECKED then FileWriteLine($file, "[Personal-Börsch]")
	if GUICtrlRead($check29) = $GUI_CHECKED then FileWriteLine($file, "[Technik]")
	if GUICtrlRead($check30) = $GUI_CHECKED then FileWriteLine($file, "[Wirtschaftsabteilung]")
	if GUICtrlRead($check31) = $GUI_CHECKED then FileWriteLine($file, "[Betriebsrat Ehmann]")
	if GUICtrlRead($check32) = $GUI_CHECKED then FileWriteLine($file, "[Betriebsrat Heidl]")
	if GUICtrlRead($check33) = $GUI_CHECKED then FileWriteLine($file, "[Sozialmarketing]")
	if GUICtrlRead($check34) = $GUI_CHECKED then FileWriteLine($file, "[Marketing]")
	if GUICtrlRead($check35) = $GUI_CHECKED then FileWriteLine($file, "[Medizinisches Controlling]")
	if GUICtrlRead($check36) = $GUI_CHECKED then FileWriteLine($file, "[Projektmanagment]")
	if GUICtrlRead($check37) = $GUI_CHECKED then FileWriteLine($file, "[Qualitätsmanagement]")
	if GUICtrlRead($check38) = $GUI_CHECKED then FileWriteLine($file, "[H. Drechsel]")
	if GUICtrlRead($check39) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Drößler]")
	if GUICtrlRead($check40) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Eckle]")
	if GUICtrlRead($check41) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Füller]")
	if GUICtrlRead($check42) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Hoffmann]")
	if GUICtrlRead($check43) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Knecht]")
	if GUICtrlRead($check44) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Koch]")
	if GUICtrlRead($check45) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Reinosch]")
	if GUICtrlRead($check46) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Rieben]")
	if GUICtrlRead($check47) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Römer]")
	if GUICtrlRead($check48) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Schulze]")
	if GUICtrlRead($check49) = $GUI_CHECKED then FileWriteLine($file, "[Dr. Wittner]")
	if GUICtrlRead($check50) = $GUI_CHECKED then FileWriteLine($file, "[Krankenpflegeschule]")
	if GUICtrlRead($check51) = $GUI_CHECKED then FileWriteLine($file, "[Innerbetriebliche Fortbildung]")
	if GUICtrlRead($check52) = $GUI_CHECKED then FileWriteLine($file, "[FüAss Bihlmaier Gyn/Geburtshilfe]")
	if GUICtrlRead($check53) = $GUI_CHECKED then FileWriteLine($file, "[FüAss Bihlmaier Innere Medizin]")
	if GUICtrlRead($check54) = $GUI_CHECKED then FileWriteLine($file, "[FüAss Munz Künzelsau]")
	if GUICtrlRead($check55) = $GUI_CHECKED then FileWriteLine($file, "[FüAss Munz Öhringen]")
	if GUICtrlRead($check56) = $GUI_CHECKED then FileWriteLine($file, "[FüAss Grädigk Künzelsau]")
	if GUICtrlRead($check57) = $GUI_CHECKED then FileWriteLine($file, "[FüAss Grädigk Öhringen]")
	if GUICtrlRead($check58) = $GUI_CHECKED then FileWriteLine($file, "[Leistungsabrechnung Künzelsau]")
	if GUICtrlRead($check59) = $GUI_CHECKED then FileWriteLine($file, "[Leistungsabrechnung Öhringen]")
	if GUICtrlRead($check60) = $GUI_CHECKED then FileWriteLine($file, "[Med. Schreibdienst]")
	if GUICtrlRead($check61) = $GUI_CHECKED then FileWriteLine($file, "[Physiotherapie Künzelsau]")
	if GUICtrlRead($check62) = $GUI_CHECKED then FileWriteLine($file, "[Physiotherapie Öhringen]")
	if GUICtrlRead($check63) = $GUI_CHECKED then FileWriteLine($file, "[Medizintechnik]")
	FileClose($file)
	MsgBox(64, "//Info", "Die Favoritendatei wurde erstellt.")
EndFunc
;-------------------------FUNKTION Datei erstellen-----------------------------<<


;-------------------Checkboxen erzuegen------------------------
$check1 = GUICtrlCreateCheckbox ("Geschäftsleitung", 10, 0)
$check2 = GUICtrlCreateCheckbox ("H. Egenter", 10, 20)
$check3 = GUICtrlCreateCheckbox ("Betriebsteil Künzelsau", 10, 40)
$check4 = GUICtrlCreateCheckbox ("Betriebsteil Öhringen", 10, 60)
$check5 = GUICtrlCreateCheckbox ("Änasthesiologie", 10, 80)
$check6 = GUICtrlCreateCheckbox ("Innere Medizin Künzelsau", 10, 100)
$check7 = GUICtrlCreateCheckbox ("Innere Medizin Öhringen", 10, 120)
$check8 = GUICtrlCreateCheckbox ("Allgemeinchirurgie Künzelsau", 10, 140)
$check9 = GUICtrlCreateCheckbox ("Allgemeinchirurgie Öhringen", 10, 160)
$check10 = GUICtrlCreateCheckbox ("Unfallchirurgie Künzelsau", 10, 180)
$check11 = GUICtrlCreateCheckbox ("Unfallchirurgie Öhringen", 10, 200)
$check12 = GUICtrlCreateCheckbox ("Chir. Ambulanz", 10, 220)
$check13 = GUICtrlCreateCheckbox ("Gyn / Geburtshilfe Öhringen", 10, 240)
$check14 = GUICtrlCreateCheckbox ("Geriatrische Reha-Klinik", 10, 260)
$check15 = GUICtrlCreateCheckbox ("Hohenloher Seniorenbetreuung", 10, 280)
$check16 = GUICtrlCreateCheckbox ("Altenheim Krautheim", 10, 300)
$check17 = GUICtrlCreateCheckbox ("Altenheim Öhringen", 10, 320)
$check18 = GUICtrlCreateCheckbox ("Seniorenzentrum Forchtenberg", 10, 340)
$check19 = GUICtrlCreateCheckbox ("Seniorenzentrum Neuenstein", 10, 360)
$check20 = GUICtrlCreateCheckbox ("Seniorenzentrum Pfedelbach", 10, 380)
$check21 = GUICtrlCreateCheckbox ("Seniorenzentrum Dörzbach", 10, 400)
$check22 = GUICtrlCreateCheckbox ("EDV", 10, 420)
$check23 = GUICtrlCreateCheckbox ("Finanzen", 10, 440)
$check24 = GUICtrlCreateCheckbox ("Personal-Hanselmann", 10, 460)
$check25 = GUICtrlCreateCheckbox ("Personal-Hanselmann", 10, 480)
$check26 = GUICtrlCreateCheckbox ("Personal-Reichert", 10, 500)
$check27 = GUICtrlCreateCheckbox ("Personal-Marinovic", 10, 520)
$check28 = GUICtrlCreateCheckbox ("Personal-Börsch", 10, 540)
$check29 = GUICtrlCreateCheckbox ("Technik", 10, 560)
$check30 = GUICtrlCreateCheckbox ("Wirtschaftsabteilung", 10, 580)
$check31 = GUICtrlCreateCheckbox ("Betriebsrat Ehmann", 10, 600)
$check32 = GUICtrlCreateCheckbox ("Betriebsrat Heidl", 10, 620)
$check33 = GUICtrlCreateCheckbox ("Sozialmarketing", 10, 640)
;---------------------------RECHTE SEITE------------------------------
$check34 = GUICtrlCreateCheckbox ("Marketing", 350, 0)
$check35 = GUICtrlCreateCheckbox ("Medizinisches Controlling", 350, 20)
$check36 = GUICtrlCreateCheckbox ("Projektmanagment", 350, 40)
$check37 = GUICtrlCreateCheckbox ("Qualitätsmanagement", 350, 60)
$check38 = GUICtrlCreateCheckbox ("H. Drechsel", 350, 80)
$check39 = GUICtrlCreateCheckbox ("Dr. Drößler", 350, 100)
$check40 = GUICtrlCreateCheckbox ("Dr. Eckle", 350, 120)
$check41 = GUICtrlCreateCheckbox ("Dr. Füller", 350, 140)
$check42 = GUICtrlCreateCheckbox ("Dr. Hoffmann", 350, 160)
$check43 = GUICtrlCreateCheckbox ("Dr. Knecht", 350, 180)
$check44 = GUICtrlCreateCheckbox ("Dr. Koch", 350, 200)
$check45 = GUICtrlCreateCheckbox ("Dr. Reinosch", 350, 220)
$check46 = GUICtrlCreateCheckbox ("Dr. Rieben", 350, 240)
$check47 = GUICtrlCreateCheckbox ("Dr. Römer", 350, 260)
$check48 = GUICtrlCreateCheckbox ("Dr. Schulze", 350, 280)
$check49 = GUICtrlCreateCheckbox ("Dr. Wittner", 350, 300)
$check50 = GUICtrlCreateCheckbox ("Krankenpflegeschule", 350, 320)
$check51 = GUICtrlCreateCheckbox ("Innerbetriebliche Fortbildung", 350, 340)
$check52 = GUICtrlCreateCheckbox ("FüAss Bihlmaier Gyn/Geburtshilfe", 350, 360)
$check53 = GUICtrlCreateCheckbox ("FüAss Bihlmaier Innere Medizin", 350, 380)
$check54 = GUICtrlCreateCheckbox ("FüAss Munz Künzelsau", 350, 400)
$check55 = GUICtrlCreateCheckbox ("FüAss Munz Öhringen", 350, 420)
$check56 = GUICtrlCreateCheckbox ("FüAss Grädigk Künzelsau", 350, 440)
$check57 = GUICtrlCreateCheckbox ("FüAss Grädigk Öhringen", 350, 460)
$check58 = GUICtrlCreateCheckbox ("Leistungsabrechnung Künzelsau", 350, 480)
$check59 = GUICtrlCreateCheckbox ("Leistungsabrechnung Öhringen", 350, 500)
$check60 = GUICtrlCreateCheckbox ("Med. Schreibdienst", 350, 520)
$check61 = GUICtrlCreateCheckbox ("Physiotherapie Künzelsau", 350, 540)
$check62 = GUICtrlCreateCheckbox ("Physiotherapie Öhringen", 350, 560)
$check63 = GUICtrlCreateCheckbox ("Medizintechnik", 350, 580)


$okbutton = GUICtrlCreateButton ("Datei erstellen", 350, 630, 120, 25, $BS_FLAT)
GUICtrlSetImage ($okbutton, "shell32.dll",22)
GUICtrlSetOnEvent($okbutton, "OKButton")

$closebutton = GUICtrlCreateButton ("schliessen", 480, 630, 120, 25, $BS_FLAT)
GUICtrlSetOnEvent($closebutton, "CLOSEButton")
;--------Schliessen über X---------------
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
;--------Schliessen über X---------------

$helpbutton = GUICtrlCreateButton ("Hilfe", 580,00,40,40, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",210)
GUICtrlSetOnEvent($helpbutton, "helpbutton")














;>>----------------------DATEI EINLESEN------------------------
$file = FileOpen("d:\hk-vorlage.favoriten", 0)
If $file = -1 Then
	MsgBox(0, "Error", "Datei nicht vorhanden.")
Exit
else

While 1
    $line = FileReadLine($file)
    If @error = -1 Then ExitLoop
    ;-------------------Abfrage ob Zeile übereinstimmt------------------------
    	if $line = "[Geschäftsleitung]" then GUICtrlSetState ($check1, $GUI_CHECKED)
    	if $line = "[H. Egenter]" then GUICtrlSetState ($check2, $GUI_CHECKED)
    	if $line = "[Betriebsteil Künzelsau]" then GUICtrlSetState ($check3, $GUI_CHECKED)
    	if $line = "[Betriebsteil Öhringen]" then GUICtrlSetState ($check4, $GUI_CHECKED)
    	if $line = "[Änasthesiologie]" then GUICtrlSetState ($check5, $GUI_CHECKED)
    	if $line = "[Innere Medizin Künzelsau]" then GUICtrlSetState ($check6, $GUI_CHECKED)
    	if $line = "[Innere Medizin Öhringen]" then GUICtrlSetState ($check7, $GUI_CHECKED)
    	if $line = "[Allgemeinchirurgie Künzelsau]" then GUICtrlSetState ($check8, $GUI_CHECKED)
    	if $line = "[Allgemeinchirurgie Öhringen]" then GUICtrlSetState ($check9, $GUI_CHECKED)
    	if $line = "[Unfallchirurgie Künzelsau]" then GUICtrlSetState ($check10, $GUI_CHECKED)
    	if $line = "[Unfallchirurgie Öhringen]" then GUICtrlSetState ($check11, $GUI_CHECKED)
    	if $line = "[Chir. Ambulanz]" then GUICtrlSetState ($check12, $GUI_CHECKED)
    	if $line = "[Gyn / Geburtshilfe Öhringen]" then GUICtrlSetState ($check13, $GUI_CHECKED)
    	if $line = "[Geriatrische Reha-Klinik]" then GUICtrlSetState ($check14, $GUI_CHECKED)
	if $line = "[Hohenloher Seniorenbetreuung]" then GUICtrlSetState ($check15, $GUI_CHECKED)
	if $line = "[Altenheim Krautheim]" then GUICtrlSetState ($check16, $GUI_CHECKED)
	if $line = "[Altenheim Öhringen]" then GUICtrlSetState ($check17, $GUI_CHECKED)
	if $line = "[Seniorenzentrum Forchtenberg]" then GUICtrlSetState ($check18, $GUI_CHECKED)
	if $line = "[Seniorenzentrum Neuenstein]" then GUICtrlSetState ($check19, $GUI_CHECKED)
	if $line = "[Seniorenzentrum Pfedelbach]" then GUICtrlSetState ($check20, $GUI_CHECKED)
	if $line = "[Seniorenzentrum Dörzbach]" then GUICtrlSetState ($check21, $GUI_CHECKED)
	if $line = "[EDV]" then GUICtrlSetState ($check22, $GUI_CHECKED)
	if $line = "[Finanzen]" then GUICtrlSetState ($check23, $GUI_CHECKED)
	if $line = "[Personal-Hanselmann]" then GUICtrlSetState ($check24, $GUI_CHECKED)
	if $line = "[Personal-Merling]" then GUICtrlSetState ($check25, $GUI_CHECKED)
	if $line = "[Personal-Reichert]" then GUICtrlSetState ($check26, $GUI_CHECKED)
	if $line = "[Personal-Marinovic]" then GUICtrlSetState ($check27, $GUI_CHECKED)
	if $line = "[Personal-Börsch]" then GUICtrlSetState ($check28, $GUI_CHECKED)
	if $line = "[Technik]" then GUICtrlSetState ($check29, $GUI_CHECKED)
	if $line = "[Wirtschaftsabteilung]" then GUICtrlSetState ($check30, $GUI_CHECKED)
	if $line = "[Betriebsrat Ehmann]" then GUICtrlSetState ($check31, $GUI_CHECKED)
	if $line = "[Betriebsrat Heidl]" then GUICtrlSetState ($check32, $GUI_CHECKED)
	if $line = "[Sozialmarketing]" then GUICtrlSetState ($check33, $GUI_CHECKED)
	if $line = "[Marketing]" then GUICtrlSetState ($check34, $GUI_CHECKED)
	if $line = "[Medizinisches Controlling]" then GUICtrlSetState ($check35, $GUI_CHECKED)
	if $line = "[Projektmanagment]" then GUICtrlSetState ($check36, $GUI_CHECKED)
	if $line = "[Qualitätsmanagement]" then GUICtrlSetState ($check37, $GUI_CHECKED)
	if $line = "[H. Drechsel]" then GUICtrlSetState ($check38, $GUI_CHECKED)
	if $line = "[Dr. Drößler]" then GUICtrlSetState ($check39, $GUI_CHECKED)
	if $line = "[Dr. Eckle]" then GUICtrlSetState ($check40, $GUI_CHECKED)
	if $line = "[Dr. Füller]" then GUICtrlSetState ($check41, $GUI_CHECKED)
	if $line = "[Dr. Hoffmann]" then GUICtrlSetState ($check42, $GUI_CHECKED)
	if $line = "[Dr. Knecht]" then GUICtrlSetState ($check43, $GUI_CHECKED)
	if $line = "[Dr. Koch]" then GUICtrlSetState ($check44, $GUI_CHECKED)
	if $line = "[Dr. Reinosch]" then GUICtrlSetState ($check45, $GUI_CHECKED)
	if $line = "[Dr. Rieben]" then GUICtrlSetState ($check46, $GUI_CHECKED)
	if $line = "[Dr. Römer]" then GUICtrlSetState ($check47, $GUI_CHECKED)
	if $line = "[Dr. Schulze]" then GUICtrlSetState ($check48, $GUI_CHECKED)
	if $line = "[Dr. Wittner]" then GUICtrlSetState ($check49, $GUI_CHECKED)
	if $line = "[Krankenpflegeschule]" then GUICtrlSetState ($check50, $GUI_CHECKED)
	if $line = "[Innerbetriebliche Fortbildung]" then GUICtrlSetState ($check51, $GUI_CHECKED)
	if $line = "[FüAss Bihlmaier Gyn/Geburtshilfe]" then GUICtrlSetState ($check52, $GUI_CHECKED)
	if $line = "[FüAss Bihlmaier Innere Medizin]" then GUICtrlSetState ($check53, $GUI_CHECKED)
	if $line = "[FüAss Munz Künzelsau]" then GUICtrlSetState ($check54, $GUI_CHECKED)
	if $line = "[FüAss Munz Öhringen]" then GUICtrlSetState ($check55, $GUI_CHECKED)
	if $line = "[FüAss Grädigk Künzelsau]" then GUICtrlSetState ($check56, $GUI_CHECKED)
	if $line = "[FüAss Grädigk Öhringen]" then GUICtrlSetState ($check57, $GUI_CHECKED)
	if $line = "[Leistungsabrechnung Künzelsau]" then GUICtrlSetState ($check58, $GUI_CHECKED)
	if $line = "[Leistungsabrechnung Öhringen]" then GUICtrlSetState ($check59, $GUI_CHECKED)
	if $line = "[Med. Schreibdienst]" then GUICtrlSetState ($check60, $GUI_CHECKED)
	if $line = "[Physiotherapie Künzelsau]" then GUICtrlSetState ($check61, $GUI_CHECKED)
	if $line = "[Physiotherapie Öhringen]" then GUICtrlSetState ($check62, $GUI_CHECKED)
	if $line = "[Medizintechnik]" then GUICtrlSetState ($check63, $GUI_CHECKED)

wend

EndIf

FileClose($file)

;----------------------DATEI EINLESEN------------------------<<



GUISetState ()       ; will display an  dialog box with 1 checkbox


; Run the GUI until the dialog is closed
While 1
    $msg = GUIGetMsg()

    If $msg = $GUI_EVENT_CLOSE Then ExitLoop

Wend
