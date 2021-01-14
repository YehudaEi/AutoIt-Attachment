#cs ----------------------------------------------------------------------------

 AutoIt Version: 1.0.0
 Author:         Koenraad Dendas

 Script Function:
	Kopiëren en benoemen van een bestand met namen uit een excel-bestand. Dit programma maakt evenveel bestanden aan
	als er namen zijn in het excel-bestand.
	
#ce ----------------------------------------------------------------------------

#RequireAdmin
; Script Start
#include <GuiConstants.au3>

;GUI

$Koenraad = GUICreate("The Banana Tool (by Conrad D.)",500,300,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
GUISetState(@SW_ENABLE)
GUISetIcon(@windowsdir & "\cursors\banana.ani")

;labels
GUICtrlCreateLabel("Deze tool dient om een standaard bestand verschillende keren te kopiëren en een nieuwe naam te geven uit een Excel-bestand.", 20, 20,450,50)

$Lable = GuiCtrlCreateLabel("Selecteer het te kopiëren bestand:", 20, 80)
$lable2 = GUICtrlCreateLabel("File:", 20,100,50,15)
$label4 = GUICtrlCreateLabel("Opm: De namen in het excel-bestand moeten zich in kolom 1 bevinden!", 20, 130);hier een icoon bijplaatsen
$label3 = GUICtrlCreateLabel("Destination:", 20, 185)

; ICON in GUI
GUICtrlCreateIcon (@windowsdir & "\cursors\banana.ani", -1, 190, 253)

;Groepen invoer en uitvoer
$invoer = GUICtrlCreateGroup("Invoer", 15, 60, 470, 100)
$uitvoer = GUICtrlCreateGroup("Uitvoer", 15, 165, 470, 50)

;inputboxen
$input = GuiCtrlCreateInput("Selecteer bestand", 200, 80, 230, 18); people locate a file to copy a few times (as many times as there are records in the excel file)
$input2 = GUICtrlCreateInput("Selecteer bestand", 200, 100, 230, 18); select xls input file with names in 1st column
$input3 = GUICtrlCreateInput("Selecteer folder", 200, 185, 230, 18); select output folder for copied files

;buttons
$doe = GUICtrlCreateButton("Go Banana !", 230, 255, 100, 30); execute!

$Browse = GUICtrlCreateButton("...", 440, 80, 40, 20)
$Browse2 = GUICtrlCreateButton("...", 440, 100, 40, 20)
$Browse3 = GUICtrlCreateButton("...", 440, 185, 40, 20)

;ingevulde tekst van InputBox 
$inputi = GUICtrlRead($input)
$inputi2 = GUICtrlRead($input2)
$inputi3 = GUICtrlRead($input3)

; voor het drukken op de knop
GUISetState ()

; In this message loop we use variables to keep track of changes to the radios, another
; way would be to use GUICtrlRead() at the end to read in the state of each control
While 1
   $msg = GUIGetMsg()
   Select
	
	Case $msg = $GUI_EVENT_CLOSE
         MsgBox(0, "", "Venster sluiten") 
		 Exit
	
	Case $msg = $browse
		$FileLoc1 = FileOpenDialog("Kies een bestand", @MyDocumentsDir, "All(*.*)"); na de naam komt de initiele of standaard locatie, met @MyDocumentsDir wordt Mijn Documenten bedoeld... Dit is een macrofunctie, vandaar de @(zie help van deze functie)
		 If NOT @error Then 
			 GUICtrlSetData($input, $FileLoc1)
			 $inputi = GUICtrlRead($input)
		EndIf
	Case $msg = $browse2
		$FileLoc2 = FileOpenDialog("Kies een bestand", @MyDocumentsDir, "Excel-bestand (*.xls)"); filter for xls files
		If NOT @error Then 
		GUICtrlSetData($input2, $FileLoc2)
		 $inputi2 = GUICtrlRead($input2)
		EndIf
	Case $msg = $browse3
		$FileLoc3 = FileSelectFolder("Kies een folder", "",1)
		If NOT @error Then 
		GUICtrlSetData($input3, $FileLoc3)
		 $inputi3 = GUICtrlRead($input3)
		EndIf	
	Case $msg = $doe
         ;MsgBox(0, "Uitvoeren?", "Bananen vooruit!"); execute

		 ;The following is what should happen when you press the button (the script should get into action):
		 ;it should copy a file and save it to the directory as set before. It should rename it with the first record of
		 ;the excel file and keep on doing it till there is a blank cell. then quit excel.
		 ; (the error message says there is an error in the 102'th line, i'm not sure about the rest since this is my first (!) program)
		 $Clipboard = ClipGet()
		 
		 WinActivate("Microsoft Excel","Excel")
		 MsgBox(0,"","Select the first cell and push 'Ok'")
		 For $j = 1 To 2
			Send("^{c}")
			If $Clipboard == "" Then
			MsgBox(0,"",$Clipboard)
			IniWrite("Data.ini","Names",$Clipboard,"")
			Send("{Down}")
		EndIf
		Next
		 ;FileCopy($inputi,$inputi3 & $NewName[$i][0])
		 
		 
		 
		 
		; i don't think this is the right command to loop something. The UNTIL should prob be lower, but can't find what
		; it should be equal to. I dunno what the variable combined with a dot means.
		; or should i use WinClose?? But i don't want it to be window name based (to be more reliable)
			
   EndSelect
WEnd
; End of script