#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>
#include <file.au3>
#include <GuiListView.au3>

; MENU
$X_SIZE=550

$Y_SIZE=500
;$Y_SIZE=@desktopheight/2
Local $gui
$GUI= GUICreate("ScanCOOP 1.2.0",$X_SIZE,$Y_SIZE, 20, 20,$WS_SIZEBOX ) ;,    $WS_MAXIMIZEBOX    $WS_SIZEBOX  ;    derzeit nicht resizeable
; GUICtrlCreatePic ("backgr.jpg", 300, 120, 100, 140) ; $X_SIZE, $Y_SIZE
GUICtrlSetState(-1,$GUI_DISABLE)
GUISetState (@SW_SHOW, $gui)

; READ GLOBAL VARIABLES*********************************************************************************************
$globalsettingsdir=IniRead ( @ScriptDir & "\globalsettings.ini", "Settings", "globalsettingsdir", "c:\Data")
$counterfile=IniRead ( @ScriptDir & "\globalsettings.ini", "Settings", "Counter", "")
; READ COMPANY VARIABLES*********************************************************************************************
Dim $FIRMENSETTINGSDIR
$FIRMENSETTINGSDIR=$CMDLINE[1]
$fileopen=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "Scandirectory", "c:\scan" )
$Firmenkuerzel=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "Firmenkuerzel", "notset" )
$DokLW=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "DokLW", "notset" )
$DoneLW=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "DoneLW", "notset" )
$Sicherungslw=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "Sicherungslw", "notset" )
$CSV_ERG=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "CSV_ERG", "notset" )
$CSV_ARG=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "CSV_ARG", "notset" )
$CSV_KAS=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "CSV_KAS", "notset" )
$CSV_CRE=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "CSV_CRE", "notset" )
$CSV_BAS=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "CSV_BAS", "notset" )
$CSV_BUE=IniRead ( $FIRMENSETTINGSDIR & "\settings.ini", "Settings", "CSV_BUE", "notset" )
;*********************************************************************************************************************
$FirmenLabel= GuiCtrlCreateLabel("Firmenkürzel:  " & $Firmenkuerzel, 30, 130, 100, 30); , 0x01, 0x00040000 ) ; , 0x1000
GUICtrlSetColor(-1,0x0000cd)	;Red

; CREATE GUI  MENU ITEMS
$filemenu = GuiCtrlCreateMenu ("File")
$fileitem = GuiCtrlCreateMenuitem ("Open...",$filemenu)
$recentfilesmenu = GuiCtrlCreateMenu ("Recent Files",$filemenu)
$separator1 = GuiCtrlCreateMenuitem ("",$filemenu)
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$helpmenu = GuiCtrlCreateMenu ("?")
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)

; CREATE STATUS BAR
Local $StatusBar1
Local $a_PartsRightEdge[3] = [150, 250, -1]
Local $a_PartsText[3] = ["Scan COOP", "", ""]
$StatusBar1 = _GUICtrlStatusBar_Create($gui, $a_PartsRightEdge, $a_PartsText)
_GUICtrlStatusBar_SetText($StatusBar1, "", 2)

;Create Control Group
GUICtrlCreateGroup("", 10, 10, $X_SIZE - 20, 90,2,$WS_EX_LAYERED) ;Rahmen GUICtrlCreateGroup ( "text", left, top [, width [, height [, style [, exStyle]]]] )
; INPUT Buttons
GuiCtrlCreateLabel("Bearbeitete PDF-Datei", 30, 25)
$Datadir = GUICtrlCreateInput($fileopen, 30, 45, 330, 20) ;( "text", left, top [, width [, height [, style [, exStyle]]]] )
$open = GuiCtrlCreateButton("F3 - Dateiauswahl", 400, 45, 130, 40) ;( "text", left, top [, width [, height [, style [, exStyle]]]] )
GUICtrlSetTip(-1, "Auswählen der gewünschten Datei")
GUICtrlSetBkColor(-1,0xc67171)  ; RED
$start= GuiCtrlCreateButton("Öffnen", 420, 130, 110, 40) ;( "text", left, top [, width [, height [, style [, exStyle]]]] )
GUICtrlSetTip(-1, "Öffnen der ausgewählten Datei mit dem PDF-Reader")
GUICtrlSetBkColor(-1,0x6183a6)  ; RED
$b_dokart= GuiCtrlCreateButton("Dok.Art", 420, 180, 110, 40) ;( "text", left, top [, width [, height [, style [, exStyle]]]] )
GUICtrlSetTip(-1, "Öffnen der DokArt.txt zum bearbeiten")
GUICtrlSetBkColor(-1,0x6183a6)  ; RED
$b_autor= GuiCtrlCreateButton("Autor", 420, 230, 110, 40) ;( "text", left, top [, width [, height [, style [, exStyle]]]] )
GUICtrlSetTip(-1, "Öffnen der Autor.txt zum bearbeiten")
GUICtrlSetBkColor(-1,0x6183a6)  ; RED
#include ".\Incl\hotkey.au3"


;**************************************************************Dokumentenart*****************************************************
$Y_ACHSE=170
$X_ACHSE=170

GuiCtrlCreateLabel("Dokumentenart", 30, $Y_ACHSE)
;checkbox
Dim $aRecords_DArt
$Dokumentenart=GUICtrlCreateCombo ($aRecords_DArt, $X_ACHSE,$Y_ACHSE,100,20) ; create first item
#include <file.au3>
If Not _FileReadToArray($globalsettingsdir & "\docart.txt",$aRecords_DArt) Then
   MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
   Exit
EndIf
For $x = 1 to $aRecords_DArt[0]
	GUICtrlSetData(-1,$aRecords_DArt[$x],$aRecords_DArt[1]) ; add other item snd set a new default
Next


If FileExists( $FIRMENSETTINGSDIR & "\docart.txt") Then
	If Not _FileReadToArray($FIRMENSETTINGSDIR & "\docart.txt",$aRecords_DArt) Then
		Exit
	EndIf
	For $x = 1 to $aRecords_DArt[0]
		GUICtrlSetData(-1,$aRecords_DArt[$x],$aRecords_DArt[1]) ; add other item snd set a new default
	Next
endif

;**************************************************************Dokumentennummer*****************************************************
$Y_ACHSE=$Y_ACHSE+30
GuiCtrlCreateLabel("Dokumentennummer", 30, $Y_ACHSE)
$Number=GuiCtrlCreateInput("0", $X_ACHSE, $Y_ACHSE, 100, 20)

;**************************************************************DATUM*****************************************************
$Y_ACHSE=$Y_ACHSE+30
#include <Date.au3>
$DATENOW=@YEAR & @MON & @MDAY
GuiCtrlCreateLabel("Datum", 30, $Y_ACHSE)
$DATE_FENSTER= GuiCtrlCreateDate("", $X_ACHSE, $Y_ACHSE, 100, 20)
GUICtrlSetTip(-1, "Datumsangabe in JahrMonatTag")

If @UNICODE Then
	$DTM_SETFORMAT_ = 0x1032
Else
	$DTM_SETFORMAT_ = 0x1005
Endif
 $style = "yyyy/MM/dd"
GuiCtrlSendMsg($date_Fenster, $DTM_SETFORMAT_, 0, $style)


;**************************************************************AUTOR*****************************************************
$Y_ACHSE=$Y_ACHSE+30
GuiCtrlCreateLabel("AUTOR", 30, $Y_ACHSE)
;checkbox
Dim $aRecords_autor
$autor=GUICtrlCreateCombo ($aRecords_autor, $X_ACHSE,$Y_ACHSE,150,20) ; create first item
#include <file.au3>
If Not _FileReadToArray($globalsettingsdir & "\autor.txt",$aRecords_autor) Then
   MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
   Exit
EndIf
For $x = 1 to $aRecords_autor[0]
	GUICtrlSetData(-1,$aRecords_autor[$x],$aRecords_autor[$x]) ; add other item snd set a new default
Next

If FileExists( $FIRMENSETTINGSDIR & "\autor.txt") Then
	If Not _FileReadToArray($FIRMENSETTINGSDIR & "\autor.txt",$aRecords_autor) Then
	Exit
	EndIf
	For $x = 1 to $aRecords_autor[0]
		GUICtrlSetData(-1,$aRecords_autor[$x],$aRecords_autor[$x]) ; add other item snd set a new default
	Next
EndIf


;****************************************************BRUTTOBETRAG*************************************************************************

$Y_ACHSE=$Y_ACHSE+30
GuiCtrlCreateLabel("Bruttobetrag", 30, $Y_ACHSE)
;checkbox
$BRUTTOBETRAG=GuiCtrlCreateInput("", $X_ACHSE, $Y_ACHSE, 100, 20)
GUICtrlSetTip(-1, "Zahleneingabe des Bruttobetrages")

;****************************************************Steuersatz***************************************************************
$Y_ACHSE=$Y_ACHSE+30
GuiCtrlCreateLabel("Steuersatz", 30, $Y_ACHSE)
;checkbox
Dim $aRecords_steuer
$steuersatz=GUICtrlCreateCombo ($aRecords_steuer, $X_ACHSE,$Y_ACHSE,100,20) ; create first item
#include <file.au3>
If Not _FileReadToArray($globalsettingsdir & "\tax.txt",$aRecords_steuer) Then
   MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
   Exit
EndIf
For $x = 1 to $aRecords_steuer[0]
	GUICtrlSetData(-1,$aRecords_steuer[$x],$aRecords_steuer[$x]) ; add other item snd set a new default
Next
If FileExists( $FIRMENSETTINGSDIR & "\tax.txt") Then
	If Not _FileReadToArray($FIRMENSETTINGSDIR & "\tax.txt",$aRecords_steuer) Then
		Exit
	EndIf
	For $x = 1 to $aRecords_steuer[0]
		GUICtrlSetData(-1,$aRecords_steuer[$x],$aRecords_steuer[$x]) ; add other item snd set a new default
	Next
EndIf

;****************************************************SPEICHERN BEENDEN***************************************************************
;$Y_ACHSE=$Y_ACHSE-80
; OK BUTTON & CANCEL
$speichern = GuiCtrlCreateButton ("Speichern",420,300,110,40)
GUICtrlSetTip(-1, "Beginnen mit dem Dateihandling")
GUICtrlSetBkColor(-1,0x50a6c2)  ; RED 
; Datei verschieben ohne Bearbeitung
$beleg_no = GuiCtrlCreateButton ("Kein Finanzbeleg!",420,345,110,40)
GUICtrlSetTip(-1, "Verschieben in Sicherungsverzeichnis für Originaldatei,ohne Eintrag in CSV")
GUICtrlSetBkColor(-1,0x6183a6)  ; RED 
;$Y_ACHSE=$Y_ACHSE+50
$Beenden = GuiCtrlCreateButton ("Beenden",30,390,500,40)
GUICtrlSetTip(-1, "Schliessen des Programmes")
GUICtrlSetBkColor(-1,0xc67171)  ; RED
$pos = MouseGetPos()

GuiSetState()
While 1
	$msg = GUIGetMsg()

	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $beenden
			ExitLoop
		Case $msg = $open Or $msg = $fileitem
			$message = "select pdf file."
			$fileopen = FileOpenDialog($message, $fileopen, "PDF documents (*.pdf)", 1 + 4 )
			GUICtrlSetData( $Datadir, $fileopen,"" )
			; Öffnen des files direkt nach Auswahl
			ShellExecute($fileopen, "", @ScriptDir, "open")
			If @error <> 1 Then GuiCtrlCreateMenuItem ($fileopen,$recentfilesmenu)
		
		Case $msg = $exititem
			ExitLoop
		;Speichern der Datei mit geänderten Datei-Namen in den verschiedenen Verzeichnissen
		Case $msg = $speichern
			_GUICtrlStatusBar_SetText($StatusBar1, @TAB & "", 2)
			GUISetState ()
			$DATENDIR= GUICtrlRead($Datadir,1)
			$a_Dokumentenart= GUICtrlRead($Dokumentenart,1)
			$a_Number=GUICtrlRead($Number,1)
			$a_Autor=GUICtrlRead($Autor,0)
			$a_DATE_FENSTER=GUICtrlRead ( $DATE_FENSTER, 1 )
			$a_BRUTTOBETRAG=GUICtrlRead($BRUTTOBETRAG,0)
			$a_Steuersatz=GUICtrlRead($Steuersatz,0)
		;Subroutine zum Abspeichern	
			#include ".\Incl\sub1.au3"
		Case $msg = $aboutitem
			Msgbox(0,"About","v 0.6.0")
		Case $msg = $GUI_EVENT_RESIZED
            _GUICtrlStatusBar_Resize ($StatusBar1)
		;Button Öffnen
		Case $msg = $start
			$right_fileopen=StringRight( $fileopen, 3 )
			if $right_fileopen ="pdf" then
				ShellExecute($fileopen, "", @ScriptDir, "open")
			endif
		;Dokart.txt(Firmensettings) aufrufen und ergänzen, Refresh nach Schliessen der Datei
		Case $msg = $b_dokart
			ShellExecuteWait($FIRMENSETTINGSDIR & "\docart.txt", "", $FIRMENSETTINGSDIR)
			_FileReadToArray($FIRMENSETTINGSDIR & "\docart.txt",$aRecords_DArt)
			For $x = 1 to $aRecords_DArt[0]
				GUICtrlSetData($Dokumentenart,$aRecords_DArt[$x],$aRecords_DArt[1]) ; add other item snd set a new default
			Next
		;Autor.txt aufrufen und ergänzen, Refresh nach Schliessen der Datei
		Case $msg = $b_autor
			ShellExecuteWait($FIRMENSETTINGSDIR & "\autor.txt", "", $FIRMENSETTINGSDIR)
			_FileReadToArray($FIRMENSETTINGSDIR & "\autor.txt",$aRecords_autor)
			For $x = 1 to $aRecords_autor[0]
				GUICtrlSetData($autor,$aRecords_autor[$x],$aRecords_autor[1]) ; add other item snd set a new default
			Next
		; File verschieben ohne etwas damit zu tun
		Case $msg = $beleg_no
			$DATENDIR= GUICtrlRead($Datadir,1)
			$SPLIT_DATENDIR=StringSplit($DATENDIR, "\")
			$FILENAME= $SPLIT_DATENDIR[$SPLIT_DATENDIR[0]]
			;MSgBox(4096, "filename", $FILENAME, 10)
			FileMove ( $DATENDIR, $DoneLW & "\" & $FILENAME , 8 )
	EndSelect
WEnd

GUIDelete()

Exit
