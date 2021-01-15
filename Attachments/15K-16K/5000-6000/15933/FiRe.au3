Opt("TrayIconDebug", 1) 
#include <GUIConstants.au3>
#Include <GUIStatusBar.au3>
#include <File.au3>
#include <array.au3>
#include <GuiListView.au3>
#include <Constants.au3>

Global $status, $sDateifilter = '', $listview
Global $avFileListGesamt [1][5]
Global $iJobNo = 0
Global $avJob [1][3]
Global $iLastLoad = 0
Global $avLoad [3]
Global $avElEi[3][3]
Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[4] = [150, 250, 310, - 1]
Local $a_PartsText[4] = ['', '', '', '2']

$avElEi[2][0]= 'B03'
$avElEi[2][1]= 'B04'
$avElEi[2][2]= '1' ; format number

$avLoad [1] = 'A01|A02|A03|A04|A05|A06|A07|A08'
$avLoad [2] = 'B01|B02|B03|B04'

$gui = GUICreate('FiRe', 530, 500)
$mnAw = GUICtrlCreateMenu ('&Auswahl')
$mnAwIt01 = GUICtrlCreateMenuitem ('&Auswahl neu', $mnAw)
$mnAwIt01z = GUICtrlCreateMenuitem ('&Markierte löschen', $mnAw)
$mnAwSp02 = GUICtrlCreateMenuitem ('', $mnAw, 3) ; create a separator line
$mnAwIt03 = GUICtrlCreateMenuitem ('&Dateien', $mnAw)
$mnAwIt04 = GUICtrlCreateMenuitem ('&Ordner', $mnAw)
$mnAwIt05 = GUICtrlCreateMenuitem ('Ordner &rek.', $mnAw)
$mnAwSp06 = GUICtrlCreateMenuitem ('', $mnAw, 6) ; create a separator line
$mnAwIt07 = GUICtrlCreateMenuitem ('&Beenden', $mnAw)

$mnBe = GUICtrlCreateMenu ('&Bearbeiten')
$mnBeIt01 = GUICtrlCreateMenu ('&Alles zurücksetzen', $mnBe)
$mnBeSp02 = GUICtrlCreateMenuitem ('', $mnBe, 4) ; create a separator line
$mnBeIt03 = GUICtrlCreateMenu ('Job &hinzufügen', $mnBe)
$mnBeIt04 = GUICtrlCreateMenu ('&Job ändern', $mnBe)

$mnEx = GUICtrlCreateMenu ('&Extras')
$mnExIt01 = GUICtrlCreateMenuitem ('&Optionen', $mnEx)
$mnExIt02 = GUICtrlCreateMenuitem ('&Updates', $mnEx)
$mnExIt03 = GUICtrlCreateMenuitem ('&Info', $mnEx)

GUICtrlCreateGraphic (2, 1, 526, 1)
GUICtrlSetGraphic ( - 1, $GUI_GR_LINE, 0, 0)
GUICtrlSetColor( - 1, 0xffffff)
GUICtrlCreateGraphic (2, 25, 526, 1)
GUICtrlSetGraphic ( - 1, $GUI_GR_LINE, 0, 0)
GUICtrlSetColor( - 1, 0x848284)
GUICtrlCreateGraphic (2, 26, 526, 1)
GUICtrlSetGraphic ( - 1, $GUI_GR_LINE, 0, 0)
GUICtrlSetColor( - 1, 0x424142)

$icon3 = GUICtrlCreateIcon ('fire128.ico', 6, 10, 28, 48, 48)
GUICtrlCreateLabel ('Fi', 55, 34, 40, 40)
GUICtrlSetFont ( - 1, 32, 1200, 2, 'Arial')
GUICtrlSetColor( - 1, 0xff0000) 
GUICtrlCreateLabel ('le', 96, 33, 40, 40)
GUICtrlSetFont ( - 1, 32, 1200, - 1, 'Arial')
GUICtrlCreateLabel ('Re', 132, 34, 55, 40)
GUICtrlSetFont ( - 1, 32, 1200, 2, 'Arial')
GUICtrlSetColor( - 1, 0xff0000) 
GUICtrlCreateLabel ('name', 188, 33, 110, 40)
GUICtrlSetFont ( - 1, 32, 1200, - 1, 'Arial')

$tab = GUICtrlCreateTab (10, 78, 510, 352)
;************* tab one **********************************
$tab0 = GUICtrlCreateTabitem ('Auswahl')
;GUICtrlSetState( - 1, $GUI_SHOW)
$t1bt01 = GUICtrlCreateButton ('', 15, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'papiere3.ico', - 1)
GUICtrlSetTip( - 1, 'Dateien rekursiv')
$t1bt02 = GUICtrlCreateButton ('', 41, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'onefol.ico', - 1)
GUICtrlSetTip( - 1, 'Dateien nur aus diesem Ordner')
$t1bt03 = GUICtrlCreateButton ('', 67, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'papiere1.ico', - 1)
GUICtrlSetTip( - 1, 'Dateien einzeln auswählen')

$t1bt04 = GUICtrlCreateButton ('', 101, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'papiere7.ico', - 1)
GUICtrlSetTip( - 1, 'Markierte Dateien aus Auswahl löschen')
$t1bt05 = GUICtrlCreateButton ('', 127, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'tab4.ico', - 1)
GUICtrlSetTip( - 1, 'Liste vollständig löschen')
$t1bt06 = GUICtrlCreateButton ('', 153, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'papiere9.ico', - 1)
GUICtrlSetTip( - 1, 'Den Dateienfilter definieren')
$t1lb01 = GUICtrlCreateLabel ('Filter:', 182, 114, 30, 16)
$t1In01 = GUICtrlCreateInput ('', 215, 112, 295, 20)

GUICtrlCreateIcon ('bluelo.ico', - 1, 15, 140, 20, 20)
GUICtrlCreateIcon ('blueoo.ico', - 1, 35, 140, 460, 20)
GUICtrlCreateLabel ('Liste der zu umzubenennenden Dateien', 25, 143, 300, 18, - 1, $WS_EX_TOPMOST)
GUICtrlSetFont ( - 1, 9, 600, - 1, 'Arial')
GUICtrlSetColor ( - 1, 0xFFFFFF)
GUICtrlCreateIcon ('bluero.ico', - 1, 495, 140, 20, 20)

$listview = GUICtrlCreateListView('Pfad|Datei|Erw.', 15, 160, 500, 240, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
_GUICtrlListViewSetColumnWidth ($listview, 0, 325)
_GUICtrlListViewSetColumnWidth ($listview, 1, 125)
_GUICtrlListViewSetColumnWidth ($listview, 2, 50)
GUICtrlCreateIcon ('bluelu.ico', - 1, 15, 400, 20, 20)
GUICtrlCreateIcon ('blueuu.ico', - 1, 35, 400, 460, 20)
GUICtrlCreateIcon ('blueru.ico', - 1, 495, 400, 20, 20)

;************* tab two **********************************
$tab1 = GUICtrlCreateTabitem ('Job/s')
GUICtrlSetState( - 1, $GUI_SHOW)
GUICtrlCreateIcon ('bluelo.ico', - 1, 15, 120, 20, 20)
GUICtrlCreateIcon ('blueoo.ico', - 1, 35, 120, 110, 20)
GUICtrlCreateLabel ('Aufgaben', 25, 123, 100, 18, - 1, $WS_EX_TOPMOST)
GUICtrlSetFont ( - 1, 9, 600, - 1, 'Arial')
GUICtrlSetColor ( - 1, 0xFFFFFF)
GUICtrlCreateIcon ('bluero.ico', - 1, 145, 120, 20, 20)
$treeview = GUICtrlCreateTreeView(15, 140, 150, 260, BitOr($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
$treeFileN = GUICtrlCreateTreeViewitem('Dateinamen', $treeview)
GUICtrlSetColor( - 1, 0x0000C0)

$treeFileN01 = GUICtrlCreateTreeViewitem('GROSS/klein', $treeFileN)
$treeFileN02 = GUICtrlCreateTreeViewitem('Länge', $treeFileN)
$treeFileN03 = GUICtrlCreateTreeViewitem('Ordnen', $treeFileN)
$treeFileN04 = GUICtrlCreateTreeViewitem('Suffix', $treeFileN)
$treeFileN05 = GUICtrlCreateTreeViewitem('Zeichen', $treeFileN)

$treeFileE = GUICtrlCreateTreeViewitem('Dateierw.', $treeview)
GUICtrlSetColor( - 1, 0x0000C0)
$treeFileE01 = GUICtrlCreateTreeViewitem('Ändern', $treeFileE)
$treeFileE02 = GUICtrlCreateTreeViewitem('GROSS/klein', $treeFileE)

$treeFileO = GUICtrlCreateTreeViewitem('Offline', $treeview)
GUICtrlSetColor( - 1, 0x0000C0)
$treeFileE01 = GUICtrlCreateTreeViewitem('Löschen', $treeFileO)
$treeFileE02 = GUICtrlCreateTreeViewitem('Umbenennen', $treeFileO)
$treeFileE03 = GUICtrlCreateTreeViewitem('Verschieben', $treeFileO)
GUICtrlCreateIcon ('bluelu.ico', - 1, 15, 400, 20, 20)
GUICtrlCreateIcon ('blueuu.ico', - 1, 35, 400, 110, 20)
GUICtrlCreateIcon ('blueru.ico', - 1, 145, 400, 20, 20)

GUICtrlCreateLabel ('Job 1', 270, 115, 120, 25)
GUICtrlSetFont ( - 1, 18, 1200, 2, 'Arial')
GUICtrlSetColor( - 1, 0x318ADE) 

GUIStartGroup() 
$A01=GUICtrlCreateRadio ( '&Alles GROSS schreiben', 180, 150, 140, 16 )
$A02=GUICtrlCreateRadio ( 'Alles &klein schreiben', 180, 170, 140, 16 )
$A03=GUICtrlCreateRadio ( 'Alles G&ross2 schreiben', 180, 190, 140, 16 )
$A04=GUICtrlCreateRadio ( 'Alles k&LEIN2 schreiben', 180, 210, 140, 16 )
$A05=GUICtrlCreateRadio ('nach diesem &Zeichen ', 180, 230, 125, 16)
$A06=GUICtrlCreateLabel ('gr&oss schreiben', 198, 247, 120, 16)
$A07=GUICtrlCreateCombo ('x', 305, 230, 42, 80)
$A08=GUICtrlCreateRadio ('&Vor GROSSB. Leerzeichen ', 355, 150, 150, 16)

$B01=GUICtrlCreateRadio ( '&Auf 128 Zeichen beschränken', 180, 150, 165, 16 )
$B02=GUICtrlCreateRadio ( '8.3 &Schreibweise', 180, 170, 140, 16 )
$B03=GUICtrlCreateRadio ( 'Z&eichen beschränken auf', 180, 190, 145, 16 )
$B04=GUICtrlCreateInput ( '', 325, 188, 30, 20, $ES_NUMBER)

GUICtrlCreateGroup ('Vorschau', 170, 270 , 345, 120)
GUICtrlCreateLabel ('Vorher', 175, 288, 42, 16)
GUICtrlCreateLabel ('', 223, 286, 124, 20, $SS_ETCHEDFRAME )
GUICtrlCreateLabel ('JohnLennon_Image.mp3', 225, 288, 120, 16)
GUICtrlCreateLabel ('Nachher', 175, 310, 42, 16)
GUICtrlCreateLabel ('', 223, 308, 124, 20, $SS_ETCHEDFRAME )
GUICtrlCreateLabel ('JohnLennon_Image.mp3', 225, 310, 120, 16)

GUICtrlCreateLabel ('Vorher', 175, 338, 42, 16)
GUICtrlCreateLabel ('', 223, 336, 124, 20, $SS_ETCHEDFRAME )
GUICtrlCreateLabel ('JohnLennon_Image.mp3', 225, 338, 120, 16)
GUICtrlCreateLabel ('Nachher', 175, 360, 42, 16)
GUICtrlCreateLabel ('', 223, 358, 124, 20, $SS_ETCHEDFRAME )
GUICtrlCreateLabel ('JohnLennon_Image.mp3', 225, 360, 120, 16)

GUICtrlCreateInput ('JohnLennon_Image.mp3', 360, 286, 140, 20)
GUICtrlCreateLabel ('', 360, 308, 142, 20, $SS_ETCHEDFRAME )
GUICtrlCreateLabel ('JohnLennon_Image.mp3', 362, 310, 138, 16)

$t2bn2= GUICtrlCreateButton ('Vorschau', 452, 395 , 30, 30, $BS_ICON)
GUICtrlSetImage ( - 1, 'vorschau.ico', - 1)
GUICtrlSetTip( - 1, 'Vorschau')

$t2bn1= GUICtrlCreateButton ('Zu den Jobs hinzufügen', 485, 395 , 30, 30, $BS_ICON)
GUICtrlSetImage ( - 1, 'aufnehmen.ico', - 1)
GUICtrlSetTip( - 1, 'Zu den Jobs hinzufügen')

;************* tab three **********************************
$tab2 = GUICtrlCreateTabitem ('Ablauf')
$t1bt01 = GUICtrlCreateButton ('', 15, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'papiere3.ico', - 1)
GUICtrlSetTip( - 1, 'Dateien rekursiv')
$t1bt02 = GUICtrlCreateButton ('', 41, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'onefol.ico', - 1)
GUICtrlSetTip( - 1, 'Dateien nur aus diesem Ordner')
$t1bt03 = GUICtrlCreateButton ('', 67, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'papiere1.ico', - 1)
GUICtrlSetTip( - 1, 'Dateien einzeln auswählen')

$t1bt04 = GUICtrlCreateButton ('', 101, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'papiere7.ico', - 1)
GUICtrlSetTip( - 1, 'Markierte Dateien aus Auswahl löschen')
$t1bt05 = GUICtrlCreateButton ('', 127, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'tab4.ico', - 1)
GUICtrlSetTip( - 1, 'Liste vollständig löschen')
$t1bt06 = GUICtrlCreateButton ('', 153, 110, 26, 26, $BS_ICON)
GUICtrlSetImage ( - 1, 'papiere9.ico', - 1)
GUICtrlSetTip( - 1, 'Den Dateienfilter definieren')
$t1lb01 = GUICtrlCreateLabel ('Filter:', 182, 114, 30, 16)
$t1In01 = GUICtrlCreateInput ('', 215, 112, 295, 20)

GUICtrlCreateIcon ('bluelo.ico', - 1, 15, 139, 20, 20)
GUICtrlCreateIcon ('blueoo.ico', - 1, 35, 139, 460, 20)
GUICtrlCreateLabel ('Jobliste', 25, 141, 300, 18, - 1, $WS_EX_TOPMOST)
GUICtrlSetFont ( - 1, 9, 600, - 1, 'Arial')
GUICtrlSetColor ( - 1, 0xFFFFFF)
GUICtrlCreateIcon ('bluero.ico', - 1, 495, 139, 20, 20)

$SecListView = GUICtrlCreateListView('Rang|Job', 15, 160, 500, 240, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
GUICtrlSendMsg($SecListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($SecListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
_GUICtrllistviewSetColumnWidth ($SecListView, 0, 40)
_GUICtrllistviewSetColumnWidth ($SecListView, 1, 455)
GUICtrlCreateIcon ('bluelu.ico', - 1, 15, 402, 20, 20)
GUICtrlCreateIcon ('blueuu.ico', - 1, 35, 402, 460, 20)
GUICtrlCreateIcon ('blueru.ico', - 1, 495, 402, 20, 20)



;************* tab four **********************************
$tab3 = GUICtrlCreateTabitem ('Optionen')

GUICtrlCreateTabitem (''); end tabitem definition

$mwBn01 = GUICtrlCreateButton ('Abbrechen', 370, 435, 70, 25)
$mwBn02 = GUICtrlCreateButton ('OK', 450, 435, 70, 25)

$StatusBar1 = _GUICtrlStatusBarCreate ($gui, $a_PartsRightEdge, $a_PartsText)
_Anfangsstart()
GUISetState ()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $mnAwIt01

		Case $msg = $GUI_EVENT_CLOSE Or $msg = $mwBn01 Or $msg = $mnAwIt07 
			ExitLoop
		Case $msg = $mnExIt01 
			Msgbox(0, 'Info', 'Only a test...')
		Case $msg = $GUI_EVENT_RESIZED
			_GUICtrlStatusBarResize ($StatusBar1)
		Case $msg = $mwBn01
			Exit
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop	
		Case $msg = $mnAwIt05 OR $msg = $t1bt01
			_Auswahl(3)
		Case $msg = $t1bt02 OR $msg = $mnAwIt04
			_Auswahl(2)
		Case $msg = $mnAwIt03 OR $msg = $t1bt03
			_AuswahlDateien()
		Case $msg = $mnAwIt01z OR $msg = $t1bt04
			_TeilAuswahlLoeschen()	
		Case $msg = $mnAwIt01 OR $msg = $t1bt05
			_AuswahlNeu()
		Case $msg = $t1bt06
			_DateiFilterAusAn()
		Case $msg = $treeFileN01
			_Load(1)
		Case $msg = $treeFileN02
			_Load(2)
		Case $msg = $t2bn1
			_TakeOver()
			
			
		Case $msg = $B04
			If GUICtrlRead($B04)> 128 Then 
				MsgBox(4160,'Hinweis', 'Es sind nur Zahlen bis 128 erlaubt')
				GUICtrlSetData($B04, StringTrimRight(GUICtrlRead($B04),1))
			EndIf
	EndSelect		
WEnd
GUIDelete()

Exit

;***************************************************************
Func _Anfangsstart()
	$sDateifilter = ''
	$avFlileList = '' ; Dateiliste gesplittet
	GUICtrlSetState ($t1lb01, $GUI_Hide) ; Tab1 Label Dateifilter
	GUICtrlSetState ($t1In01, $GUI_Hide) ; Tab1 Input Dateifilter
	_GUICtrlStatusBarSetText ($StatusBar1, 'Keine Aktion zur Zeit', 0)	
	_GUICtrlStatusBarSetText ($StatusBar1, 'Dateien: 0', 1)
	_GUICtrlStatusBarSetText ($StatusBar1, 'Job/s: 0', 2)
	For $i = 1 to UBound($avLoad)-1 ;arrays begin with 0
		_Unload($i)
	Next
EndFunc


Func _Auswahl($iWeiche)
	Dim $szDrive, $szDir, $szFName, $szExt, $ret, $iWeiche, $iCancel = 0
	If $iWeiche = 2 Then
		$sAwRk = FileSelectFolder ('Wählen Sie bitte einen Ordner aus, dessen Dateien nicht aber aus seinen Unterordner übernommen werden sollen. Setzen Sie ggf. den Dateifilter ein.', 'Arbeitsplatz', 2)
		If @error = 1 Then $iCancel = 1
	Else
		$sAwRk = FileSelectFolder ('Wählen Sie bitte einen Ordner aus, dessen Dateien - auch aus seinen Unterordner - übernommen werden sollen. Setzen Sie ggf. den Dateifilter ein.', 'f:\aaa', 2)
		If @error = 1 Then $iCancel = 1	
	EndIf	
	If $iCancel = 1 Then
	Else 
		If StringLen ($sDateiFilter) > 4 Then
			$iValDf = _ValidateDateiFilter()
			
			If $iValDf = 0 Then $avFileList = _FileListToArrayRek($sAwRk & $sAdd, $sDateiFilter, 1)
			Else 
				$avFileList = _FileListToArrayRek ($sAwRk & '\', '*.*', $iWeiche)
			EndIf
			_GUICtrlStatusBarSetText ($StatusBar1, 'Ergebnisse übernehmen ...' , 0)
		If $avFileList[0] > 0 Then	
			For $i = 1 to $avFileList[0]
				If $iWeiche = 2 then $avFileList[$i] = StringReplace($sAwRk & '\', '\\', '\') & $avFileList[$i]
				$avF = _PathSplit($avFileList[$i], $szDrive, $szDir, $szFName, $szExt)
				$iA = UBound($avFileListGesamt)
				$iAv = $iA +1
				ReDim $avFileListGesamt [$iAv] [5]
				$avFileListGesamt [$iA] [0] = $avF [0]
				$avFileListGesamt [$iA] [1] = $avF [1]
				$avFileListGesamt [$iA] [2] = $avF [2]
				$avFileListGesamt [$iA] [3] = $avF [3]
				$avFileListGesamt [$iA] [4] = $avF [4]
				If StringLeft($avF [2], 2) = '\\' Then $avF [2] = StringTrimLeft($avF [2], 1)
				
				$sEntry = $avF [1] & $avF [2] & '|' & $avF [3] & '|' & $avF [4]
				_GUICtrlStatusBarSetText ($StatusBar1, 'Dateien: ' & $iA, 1)
				$ret = _GUICtrlListViewInsertItem ($listview, $iA - 1, $sEntry)
			
				If ($ret == $LV_ERR) Then 
					MsgBox (4112, 'Abbruch', 'Fehler beim Aktualisieren der Dateiliste')
					ExitLoop
				EndIf
			Next
		Else
			MsgBox (4160, 'Hinweis', 'Es wurden keine Dateien gefunden')
		EndIf
		_GUICtrlStatusBarSetText ($StatusBar1, 'Suche beendet ...', 0)
	EndIf
EndFunc

Func _AuswahlDateien()
	Dim $szDrive, $szDir, $szFName, $szExt
	$iValDf = 0
	$sTxtAw = 'Mit gedrückter STRG - Taste ist auch Mehrfachauswahl von Dateien möglich. Setzen Sie ggf. den Filter ein.'	
	If StringLen ($sDateiFilter) > 4 Then 
		$iValDf = _ValidateDateiFilter()
		If $iValDf = 0 then $sAusw = 'Benutzerdefinierte Auswahl (' & $sDateiFilter & ')'
	Else
		$sAusw = 'Alle Dateien (*.*)|Audiodateien (*.mp3;*.mp4;*.wav)|Bilddateien (*.bmp;*.gif;*.jpeg;*.jpg;*.png;*.tif)|Internetdateien (*.css;*.htm;*.html;*.xml)|Office - Dokumente (*.csv;*.doc;*.pdf;*.ppt;*.xls;*.xlt)'
	EndIf
	
	$sDateiFileList = FileOpenDialog($sTxtAw, 'Arbeitsplatz', $sAusw, 7)
	If @error = 0 Then
		$avFileList = StringSplit($sDateiFileList, '|')
		For $i = 1 to $avFileList[0]
			If $avFileList[0] > 1 AND $i = 1 Then ContinueLoop
			If $avFileList[0] > 1 Then $avFileList[$i] = StringReplace($avFileList[1] &'\', '\\', '\') & $avFileList[$i]	
			$avF = _PathSplit($avFileList[$i], $szDrive, $szDir, $szFName, $szExt)
			$iA = UBound($avFileListGesamt)
			$iAv = $iA +1
			ReDim $avFileListGesamt [$iAv] [5]
			$avFileListGesamt [$iA] [0] = $avF [0]
			$avFileListGesamt [$iA] [1] = $avF [1]
			$avFileListGesamt [$iA] [2] = $avF [2]
			$avFileListGesamt [$iA] [3] = $avF [3]
			$avFileListGesamt [$iA] [4] = $avF [4]	
			$sEntry = $avF [1] & $avF [2] & '|' & $avF [3] & '|' & $avF [4]
			_GUICtrlStatusBarSetText ($StatusBar1, 'Dateien: ' & $iA, 1)
			$ret = _GUICtrlListViewInsertItem ($listview, $iA - 1, $sEntry)
			If ($ret = = $LV_ERR) Then 
				MsgBox (4112, 'Abbruch', 'Fehler beim Aktualisieren der Dateiliste')
				ExitLoop
			EndIf
		Next
	EndIf
	_GUICtrlStatusBarSetText ($StatusBar1, 'Suche beendet ...', 0)
EndFunc

Func _AuswahlNeu()
	Dim $iAnt
	$iAnt = MsgBox(4164, 'Sicherheitsabfrage', 'Wollen Sie die Auswahl wirklich löschen?')
	If $iAnt = 6 then
		$avFileListGesamt = ''
		_GUICtrlListViewDeleteAllItems($listview)
		_GUICtrlStatusBarSetText ($StatusBar1, 'Auswahl gelöscht ... ', 0)
		_GUICtrlStatusBarSetText ($StatusBar1, 'Dateien: 0', 1)		
	EndIf
EndFunc

Func _DateiFilterAusAn()
	Select
	Case GUICtrLGetState($t1In01) = 96 
		GUICtrlSetState($t1In01, $GUI_SHOW)
		GUICtrlSetState($t1lb01, $GUI_SHOW)
	Case GUICtrLGetState($t1In01) = 80
		GUICtrlSetState($t1In01, $GUI_HIDE)
		GUICtrlSetState($t1lb01, $GUI_HIDE)		
	EndSelect
EndFunc

Func _FileListToArrayRek($sPath, $sFilter = '*.*', $iFlag = 0)	
	;don't forget to #include <Constants.au3>
	Local $hSearch, $sFile, $avFileListR[1], $sSwitch = '', $sPathComplete = '', $iTwo = StringSplit('64|32|16|8|4|2|1', '|')
	Local $avFileListR, $avWait = StringSplit('.|..|...|....|.....', '|'), $iWait = 1	
	;0 = normaly search, 1 = recursive, 2 = files without folder, 4 = folder without files, alph. sort: 8 = names, 16 = extansion, 32 = size, 64 = date
	For $i = 1 to $iTwo[0]
		$j = $iTwo[$i]
		If $iTwo[$i] > $iFlag then ContinueLoop
		$iFlag = $iFlag - $iTwo[$i]
		$sSwitch = $sSwitch & '|' & $iTwo[$i]
	Next

	$aFlag = StringSplit(StringTrimLeft($sSwitch, 1), '|')	
	$sSwitch = ''
	
	For $i = 1 to $aFlag[0]			
		Switch $aFlag[$i] 
			Case 0
				$sSwitch = $sSwitch & ''
			Case 1
				$sSwitch = $sSwitch & '/S'
			Case 2
				$sSwitch = $sSwitch & '/A - D'
			Case 4
				$sSwitch = $sSwitch & '/AD'	
			Case 8
				$sSwitch = $sSwitch & '/ON'
			Case 16
				$sSwitch = $sSwitch & '/OE'
			Case 32
				$sSwitch = $sSwitch & '/OS'
			Case 64
				$sSwitch = $sSwitch & '/OD'					
		EndSwitch
	Next

	;Handles errors in inputs	
	If Not FileExists($sPath) Then Return SetError(1, 1, '')
	If (StringInStr($sFilter, '\')) Or (StringInStr($sFilter, '/')) Or (StringInStr($sFilter, ':')) Or (StringInStr($sFilter, '>')) Or (StringInStr($sFilter, '<')) Or (StringInStr($sFilter, '|')) Or (StringStripWS($sFilter, 8) = '') Then Return SetError(2, 2, '')
	;If Not ($iFlag > 63) Then Return SetError(3, 3, '')
	
	If StringRight($sPath, 1)<> '\' then $sPath = $sPath & '\' ;necessary, if path is only drive
	$sPath = StringReplace($sPath, '\\', '\')
	$avFilter = StringSplit($sFilter, ';')
	For $i = 1 to $avFilter[0] ;for allowing multiple filter
		$sPathComplete = $sPathComplete & ';' & $sPath & $avFilter[$i]
	Next

	$sPathComplete = StringTrimLeft($sPathComplete, 1) 
	$sCmdSearch = ' /c dir "' & $sPathComplete & '" /B' & $sSwitch	
	$sConsole = Run(@ComSpec & $sCmdSearch , @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)

	While 1
		$Output = StdoutRead($sConsole)
		If @error Then ExitLoop

		$avList = StringSplit(StringReplace($Output, @CRLF, '^'), '^')
		If NOT IsArray($avList) Then
			MsgBox(0, '', 'Ist kein Array', 2)
			Exit
		EndIf
		For $i = 1 to $avList[0]
			If $avList[$i] = '' then ContinueLoop
			ReDim $avFileListR[UBound($avFileListR) + 1]
			$avFileListR[0] = $avFileListR[0] + 1
			$avFileListR[UBound($avFileListR) - 1] = $avList[$i]
			$iWait = $iWait+1
			If $iWait = = $avWait[0]+1 then $iWait = 1
			_GUICtrlStatusBarSetText ($StatusBar1, 'Suche ' & $avWait[$iWait], 0)	
		Next
	Wend

	While 1
		$Output = StderrRead($sConsole)
		If @error Then ExitLoop
	Wend

	Return $avFileListR
EndFunc ; = = >_FileListToArrayRek

Func _Load($k)
	If $iLastLoad > 0 then _Unload($iLastLoad)
	$avElements = StringSplit ($avLoad[$k], '|')
	For $i = 1 to $avElements[0]
		$iPlacebo = Eval ($avElements[$i])
		GUICtrlSetState ($iPlacebo, $GUI_SHOW)
	Next
	$iLastLoad = $k
EndFunc

Func _TeilAuswahlLoeschen()
	Dim $iC = 0
	$avMarkElemente = _GUICtrlListViewGetSelectedIndices($listview, 1)
	_ArrayDisplay($avMarkElemente)
	If IsArray($avMarkElemente) Then
		Dim $avFileListGesamtX [UBound($avFileListGesamt) - $avMarkElemente[0]][5]
		For $i = 1 to UBound($avFileListGesamt) - 1
			$Weiter = 0
			For $j = 1 to $avMarkElemente[0]
				If $i = $avMarkElemente[$j]+1 Then ContinueLoop(2)			
			Next
				$iC = $iC + 1
				For $k = 0 to 4
					$avFileListGesamtX[$iC][$k] = $avFileListGesamt[$i][$K]
				Next
		Next
		$avFileListGesamtX[0][0] = $iC
		$avFileListGesamt = $avFileListGesamtX
		_ArrayDisplay ($avFileListGesamt, '$avFileListGesamt')
		$avFileListGesamtX = ''	
		_GUICtrlListViewDeleteItemsSelected($listview)
		_GUICtrlStatusBarSetText ($StatusBar1, 'Dateien: ' & $iC, 1)	
		_GUICtrlStatusBarSetText ($StatusBar1, 'Markierte Auswahl gelöscht ... ', 0)			
	Else
		MsgBox(4160, 'Hinweis', 'Sie haben keine Datei markiert.', 4)
	EndIf
EndFunc

Func _Unload($k)
	$avElements = StringSplit ($avLoad[$k], '|')
	For $i = 1 to $avElements[0]
		$iPlacebo = Eval ($avElements[$i])
		GUICtrlSetState ($iPlacebo, $GUI_HIDE)
	Next
EndFunc

Func _TakeOver()
	Dim $iErr=0, $iAdd = ''
	$avElements = StringSplit ($avLoad[$iLastLoad], '|')
	For $i = 1 to $avElements[0]
		$iPlacebo = Eval ($avElements[$i])
		If  GUICtrlGetState($iPlacebo)= 80 Then ExitLoop
	Next
	GUICtrlSetState($iPlacebo + 1, $GUI_UNCHECKED)	
	GUICtrlSetState($iPlacebo, $GUI_UNCHECKED)		
	$sTxt = ControlGetText ( 'FiRe','', $iPlacebo)
	If @error = 0 then		
		$iJobNo = $iJobNo + 1
		ReDim $avJob[$iJobNo +1][3]	
		$avJob[$iJobNo][0] = $sTxt
		;checks, if other controls should be read
		If StringLen($avElEi[$iLastLoad][0]) > 0 Then
			$avE1=StringSplit($avElEi[$iLastLoad][0], '|')
			$avE2=StringSplit($avElEi[$iLastLoad][1], '|')
			$avE3=StringSplit($avElEi[$iLastLoad][1], '|')		

			For $i = 1 to $avE1[0]
				$iP1 = Eval ($avE1 [$i])
				$iP2 = Eval ($avE2 [$i])
				$iP3 = Eval ($avE3 [$i])	
				If $iPlacebo==$iP1 Then ;this control has a subcontrol to read
					$iAdd = GUICtrlRead($iP2)
					$avJob[$iJobNo][2] = $iAdd
					$avJob[$iJobNo][1] = $iP3
				EndIf
			Next			
		EndIf
	Else
		MsgBox(4116, 'Fehler', 'Kann Job nicht aufnehmen')
		$iErr= $iErr + 1
		_GUICtrlStatusBarSetText ($StatusBar1, 'Fehler beim Job hinzufügen ', 0)
	EndIf
	
	If $iErr = 0 then
		$sEntry = $iJobNo & '|' & $avJob[$iJobNo][0] & ' ' & $iAdd & '| '
		$ret = _GUICtrlListViewInsertItem ($SecListView, 1, $sEntry)
		If ($ret == $LV_ERR) Then 
			MsgBox (4112, 'Hinweis', 'Fehler beim Aktualisieren der Jobliste')
		EndIf
		_GUICtrlStatusBarSetText ($StatusBar1, 'Job hinzugefügt ... ', 0)
		_GUICtrlStatusBarSetText ($StatusBar1, 'Job/s: ' & $iJobNo, 2)
		
		_ArrayDisplay($avJob)
	EndIf
	SetError ($iErr, 0, $iErr)
EndFunc
Func _ValidateDateiFilter()
	$sStr = ''
	$sDfErrMsg = ''
	
	$sDateiFilter = StringStripWS($sDateiFilter, 8)
	$iDatFil = StringLen ($sDateiFilter)
	
	If $iDatFil > 1 Then
		StringReplace ($sDateiFilter, '*', '*')
		$iDatFilAnz1 = @extended
		StringReplace ($sDateiFilter, '.', '.')
		$iDatFilAnz2 = @extended	
		StringReplace ($sDateiFilter, ';', ';')
		$iDatFilAnz3 = @extended	
		
		If 	$iDatFilAnz1 <> $iDatFilAnz2 Then $sDfErrMsg = $sDfErrMsg & ' Anzahl der Sternchen und Punkte sind ungleich. '
		If StringLen ($sDfErrMsg) > 1 Then $sStr = @CRLF 
		If $iDatFilAnz3 - 1 <> $iDatFilAnz2 Then $sDfErrMsg = $sDfErrMsg & $sStr &' Die Dateierweiterungen sind nicht korrekt mit Semikolon (;) getrennt. '
	EndIf	
	If StringLen ($sDfErrMsg) > 1 Then
		MsgBox (4160, 'Abbruch', 'Fehlerhafte Eingabe im Dateifilter: ' & @CRLF & $sDfErrMsg & @CRLF & 'Wiederholen Sie die Eingabe oder lassen Sie das Feld leer.')
		Return 1
	Else
		Return 0
	EndIf
EndFunc