$Avicodec = IniRead("OT.ini","Grafiki","Avicodec","                                                                             ")
$Download = IniRead("OT.ini","Grafiki","Download","                                                                             ")
$HashCode = IniRead("OT.ini","Grafiki","HashCode","                                                                             ")
$Info = IniRead("OT.ini","Grafiki","Info","                                                                             ")
$Obsada = IniRead("OT.ini","Grafiki","Obsada","                                                                            ")
$Opis = IniRead("OT.ini","Grafiki","Opis","                                                                           ")
$Screeny = IniRead("OT.ini","Grafiki","Screeny","                                                                             ")
$Uczestnicy = IniRead("OT.ini","Grafiki","Uczestnicy","                                                                             ")
$Pres = IniRead("OT.ini","Grafiki","Pres","                                                       ")
$Kolor1 = IniRead("OT.ini","Kolory","Kolor1","[color=blue]")
$Kolor2 = IniRead("OT.ini","Kolory","Kolor2","[color=green]")
$Font1 = IniRead("OT.ini","Font","Font1","[font=Comic Sans MS]")
$Font2 = IniRead("OT.ini","Font","Font2","[Courier New]")
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
#Include <GuiScrollBars.au3>
#NoTrayIcon
#Region ### START Koda GUI section ### Form=c:\documents and settings\user\pulpit\skrypty\koda_1.7.1.0\forms\otaku team.kxf
Dim $elozx
$Form1 = GUICreate("Generator Opisów [Otaku Team]", 632, 800, 240, 54)
$Group1 = GUICtrlCreateGroup("Info Ogólne", 8, 8, 313, 97)
$Label1 = GUICtrlCreateLabel("Tytu³ Oryginalny :", 16, 24, 87, 17)
$Input1 = GUICtrlCreateInput("", 104, 20, 209, 21)
$Input2 = GUICtrlCreateInput("", 104, 46, 209, 21)
$Label2 = GUICtrlCreateLabel("Tytu³ Polski :", 16, 50, 66, 17)
$Input3 = GUICtrlCreateInput("", 104, 72, 209, 21)
$Label3 = GUICtrlCreateLabel("Link do ok³adki :", 16, 76, 84, 17)
$Group2 = GUICtrlCreateGroup("Szczegó³y", 8, 112, 313, 177)
$Label4 = GUICtrlCreateLabel("Typ :", 16, 127, 28, 17)
$Input4 = GUICtrlCreateInput("", 104, 124, 209, 21)
$Input5 = GUICtrlCreateInput("", 104, 150, 209, 21)
$Label5 = GUICtrlCreateLabel("Data Premiery :", 16, 154, 76, 17)
$Input6 = GUICtrlCreateInput("", 104, 176, 209, 21)
$Label6 = GUICtrlCreateLabel("Dozwolony Wiek:", 16, 180, 87, 17)
$Label7 = GUICtrlCreateLabel("Ocena :", 16, 206, 42, 17)
$Input7 = GUICtrlCreateInput("", 104, 202, 209, 21)
$Label31 = GUICtrlCreateLabel("Gatunek:", 16, 231, 45, 17)
$Input31 = GUICtrlCreateInput("", 104, 228, 209, 21)
$Input32 = GUICtrlCreateInput("", 72, 254, 81, 21)
$Label32 = GUICtrlCreateLabel("Produkcja:", 16, 258, 55, 17)
$Input33 = GUICtrlCreateInput("", 232, 254, 81, 21)
$Label33 = GUICtrlCreateLabel("Czas Trwania:", 160, 258, 71, 17)
$Group3 = GUICtrlCreateGroup("Opis", 8, 288, 313, 129)
$Edit1 = GUICtrlCreateEdit("", 16, 304, 297, 105,$WS_VSCROLL)
$Group4 = GUICtrlCreateGroup("Produkcja", 8, 424, 313, 297)
$Label8 = GUICtrlCreateLabel("Re¿yser :", 16, 440, 48, 17)
$Input8 = GUICtrlCreateInput("", 104, 436, 209, 21)
$Input9 = GUICtrlCreateInput("", 104, 462, 209, 21)
$Label9 = GUICtrlCreateLabel("Muzyka :", 16, 466, 47, 17)
$Input10 = GUICtrlCreateInput("", 104, 488, 209, 21)
$Label10 = GUICtrlCreateLabel("Scenografia :", 16, 492, 67, 17)
$Label11 = GUICtrlCreateLabel("Zdjêcia :", 16, 518, 45, 17)
$Input11 = GUICtrlCreateInput("", 104, 514, 209, 21)
$Edit2 = GUICtrlCreateEdit("", 16, 568, 297, 145)
$Label12 = GUICtrlCreateLabel("Obsada:", 16, 544, 44, 17)
$Group5 = GUICtrlCreateGroup("Plik", 328, 8, 297, 169)
$Edit3 = GUICtrlCreateEdit("", 336, 24, 281, 105)
GuiCtrlSetData(-1,"AviCodec Info")
$Input18 = GUICtrlCreateInput("", 336, 152, 89, 21)
$Input19 = GUICtrlCreateInput("", 432, 152, 89, 21)
$Input20 = GUICtrlCreateInput("", 528, 152, 89, 21)
$Label25 = GUICtrlCreateLabel("Jêzyk", 361, 135, 31, 17)
$Label26 = GUICtrlCreateLabel("Napisy", 457, 135, 36, 17)
$Label27 = GUICtrlCreateLabel("Grupa", 553, 135, 33, 17)
$Group6 = GUICtrlCreateGroup("Screeny", 328, 184, 297, 177)
$Edit4 = GUICtrlCreateEdit("", 336, 200, 281, 153)
$Group7 = GUICtrlCreateGroup("Download", 328, 368, 297, 393, -1, $WS_EX_TRANSPARENT)
$Tab1 = GUICtrlCreateTab(336, 384, 281, 257)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$TabSheet1 = GUICtrlCreateTabItem("Epik 1")
GUICtrlSetState(-1,$GUI_SHOW)
$Input12 = GUICtrlCreateInput("", 348, 432, 257, 21)
$Label13 = GUICtrlCreateLabel("Nazwa", 348, 416, 37, 17)
$Edit5 = GUICtrlCreateEdit("", 348, 488, 257, 145)
$Label14 = GUICtrlCreateLabel("Download", 348, 472, 52, 17)
$Button4 = GUICtrlCreateButton("BBC z HC", 536, 464, 65, 17, $WS_GROUP)
$TabSheet2 = GUICtrlCreateTabItem("Epik 2")
$Label15 = GUICtrlCreateLabel("Nazwa", 348, 416, 37, 17)
$Input13 = GUICtrlCreateInput("", 348, 432, 257, 21)
$Edit6 = GUICtrlCreateEdit("", 348, 488, 257, 145)
$Label16 = GUICtrlCreateLabel("Download", 348, 472, 52, 17)
$Button5 = GUICtrlCreateButton("BBC z HC", 536, 464, 65, 17, $WS_GROUP)
$TabSheet3 = GUICtrlCreateTabItem("Epik 3")
$Label17 = GUICtrlCreateLabel("Nazwa", 348, 416, 37, 17)
$Input14 = GUICtrlCreateInput("", 348, 432, 257, 21)
$Edit7 = GUICtrlCreateEdit("", 348, 488, 257, 145)
$Label18 = GUICtrlCreateLabel("Download", 348, 472, 52, 17)
$Button6 = GUICtrlCreateButton("BBC z HC", 536, 464, 65, 17, $WS_GROUP)
$TabSheet4 = GUICtrlCreateTabItem("Epik 4")
$Label19 = GUICtrlCreateLabel("Nazwa", 348, 416, 37, 17)
$Input15 = GUICtrlCreateInput("", 348, 432, 257, 21)
$Edit8 = GUICtrlCreateEdit("", 348, 488, 257, 145)
$Label20 = GUICtrlCreateLabel("Download", 348, 472, 52, 17)
$Button7 = GUICtrlCreateButton("BBC z HC", 536, 464, 65, 17, $WS_GROUP)
$TabSheet5 = GUICtrlCreateTabItem("Epik 5")
$Label21 = GUICtrlCreateLabel("Nazwa", 348, 416, 37, 17)
$Input16 = GUICtrlCreateInput("", 348, 432, 257, 21)
$Edit9 = GUICtrlCreateEdit("", 348, 488, 257, 145)
$Label22 = GUICtrlCreateLabel("Download", 348, 472, 52, 17)
$Button8 = GUICtrlCreateButton("BBC z HC", 536, 464, 65, 17, $WS_GROUP)
$TabSheet6 = GUICtrlCreateTabItem("Epik 6")
$Label23 = GUICtrlCreateLabel("Nazwa", 348, 416, 37, 17)
$Input17 = GUICtrlCreateInput("", 348, 432, 257, 21)
$Edit10 = GUICtrlCreateEdit("", 348, 488, 257, 145)
$Label24 = GUICtrlCreateLabel("Download", 348, 472, 52, 17)
$Button9 = GUICtrlCreateButton("BBC z HC", 536, 464, 65, 17, $WS_GROUP)
GUICtrlCreateTabItem("")
;$Checkbox1 = GUICtrlCreateCheckbox("Zbiorczy HC", 432, 648, 81, 17)
$Label28 = GUICtrlCreateLabel("Upload", 336, 676, 38, 17)
$Label29 = GUICtrlCreateLabel("Konta", 336, 702, 32, 17)
$Label30 = GUICtrlCreateLabel("Opis", 336, 728, 25, 17)
$Input21 = GUICtrlCreateInput("", 376, 672, 73, 21)
$Input22 = GUICtrlCreateInput("", 376, 698, 73, 21)
$Input23 = GUICtrlCreateInput("", 376, 724, 73, 21)
$Input24 = GUICtrlCreateInput("", 457, 672, 73, 21)
$Input25 = GUICtrlCreateInput("", 457, 698, 73, 21)
$Input26 = GUICtrlCreateInput("", 457, 724, 73, 21)
$Input27 = GUICtrlCreateInput("", 536, 672, 73, 21)
$Input28 = GUICtrlCreateInput("", 536, 698, 73, 21)
$Input29 = GUICtrlCreateInput("", 536, 724, 73, 21)
$Group8 = GUICtrlCreateGroup("Pobierz Informacje", 8, 728, 313, 65)
$Input30 = GUICtrlCreateInput("Link - Azunime.net", 16, 744, 297, 21)
$Button1 = GUICtrlCreateButton("Pobierz", 128, 768, 73, 25, $WS_GROUP)
$Button2 = GUICtrlCreateButton("Generuj BBC", 432, 768, 81, 25, $WS_GROUP)
$Button3 = GUICtrlCreateButton("Wyczysc", 544, 772, 81, 17, $WS_GROUP)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$Upload = ""
$Konta = ""
$Opisik = ""
Func opis($txt)
	GuiCtrlSetData($Editl1,$txt & @CRLF,1)
EndFunc
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $Button3
	$boxik = MSgBox(324,"Generator Opisów [Otaku Team]","Wyczyœciæ wszystko?")
	If $boxik = 6 Then
		GuiCtrlSetData($Input1,"")
		GuiCtrlSetData($Input2,"")
		GuiCtrlSetData($Input3,"")
		GuiCtrlSetData($Input4,"")
		GuiCtrlSetData($Input5,"")
		GuiCtrlSetData($Input6,"")
		GuiCtrlSetData($Input7,"")
		GuiCtrlSetData($Input8,"")
		GuiCtrlSetData($Input9,"")
		GuiCtrlSetData($Input10,"")
		GuiCtrlSetData($Input11,"")
		GuiCtrlSetData($Input12,"")
		GuiCtrlSetData($Input13,"")
		GuiCtrlSetData($Input14,"")
		GuiCtrlSetData($Input15,"")
		GuiCtrlSetData($Input16,"")
		GuiCtrlSetData($Input17,"")
		GuiCtrlSetData($Input18,"")
		GuiCtrlSetData($Input19,"")
		GuiCtrlSetData($Input20,"")
		GuiCtrlSetData($Input21,"")
		GuiCtrlSetData($Input22,"")
		GuiCtrlSetData($Input23,"")
		GuiCtrlSetData($Input24,"")
		GuiCtrlSetData($Input25,"")
		GuiCtrlSetData($Input26,"")
		GuiCtrlSetData($Input27,"")
		GuiCtrlSetData($Input28,"")
		GuiCtrlSetData($Input29,"")
		GuiCtrlSetData($Input30,"Link - Azunime.net")
		GuiCtrlSetData($Input31,"")
		GuiCtrlSetData($Input32,"")
		GuiCtrlSetData($Input33,"")
		GuiCtrlSetData($Edit1,"")
		GuiCtrlSetData($Edit2,"")
		GuiCtrlSetData($Edit3,"AviCodec Info")
		GuiCtrlSetData($Edit4,"")
		GuiCtrlSetData($Edit5,"")
		GuiCtrlSetData($Edit6,"")
		GuiCtrlSetData($Edit7,"")
		GuiCtrlSetData($Edit8,"")
		GuiCtrlSetData($Edit9,"")
	EndIf
Case $Button4
	$oIE = _IECreate("                                ",0,0,1,1)
	_IELoadWait($oIE)
	$hc = _IEGetObjByName($oIE,"hashe")
	_IEFormElementSetValue($hc,GuiCtrlRead($Edit5))
	$box = _IEGetObjByName($oIE,"iAcc")
	_IEAction($box,"click")
	$colTags = _IETagNameGetCollection($oIE, "input")
	For $oTag In $colTags
	; Might also work this way:
	;    If $oTag.value = "Release" Then
    If _IEPropertyGet($oTag, "innertext") = "Utwórz BBCode :)" Then
        _IEAction($oTag, "click")
    EndIf
	Next
	_IELoadWait($oIE)
	$hcdc = _IEGetObjByID($oIE,"prawa")
	$hcdc1 = _IEPropertyGet($hcdc,"innertext")
	$hcdc2 = StringReplace($hcdc1,"Wykryto 1 prawdopodobnych HashCodów" & @CRLF,"")
	GuiCtrlSetData($Edit5,$hcdc2)
	_IEQuit($oIE)
Case $Button5
	$oIE = _IECreate("                                ",0,0,1,1)
	_IELoadWait($oIE)
	$hc = _IEGetObjByName($oIE,"hashe")
	_IEFormElementSetValue($hc,GuiCtrlRead($Edit6))
	$box = _IEGetObjByName($oIE,"iAcc")
	_IEAction($box,"click")
	$colTags = _IETagNameGetCollection($oIE, "input")
	For $oTag In $colTags
	; Might also work this way:
	;    If $oTag.value = "Release" Then
    If _IEPropertyGet($oTag, "innertext") = "Utwórz BBCode :)" Then
        _IEAction($oTag, "click")
    EndIf
	Next
	_IELoadWait($oIE)
	$hcdc = _IEGetObjByID($oIE,"prawa")
	$hcdc1 = _IEPropertyGet($hcdc,"innertext")
	$hcdc2 = StringReplace($hcdc1,"Wykryto 1 prawdopodobnych HashCodów" & @CRLF,"")
	GuiCtrlSetData($Edit6,$hcdc2)
	_IEQuit($oIE)
Case $Button6
	$oIE = _IECreate("                                ",0,0,1,1)
	_IELoadWait($oIE)
	$hc = _IEGetObjByName($oIE,"hashe")
	_IEFormElementSetValue($hc,GuiCtrlRead($Edit7))
	$box = _IEGetObjByName($oIE,"iAcc")
	_IEAction($box,"click")
	$colTags = _IETagNameGetCollection($oIE, "input")
	For $oTag In $colTags
	; Might also work this way:
	;    If $oTag.value = "Release" Then
    If _IEPropertyGet($oTag, "innertext") = "Utwórz BBCode :)" Then
        _IEAction($oTag, "click")
    EndIf
	Next
	_IELoadWait($oIE)
	$hcdc = _IEGetObjByID($oIE,"prawa")
	$hcdc1 = _IEPropertyGet($hcdc,"innertext")
	$hcdc2 = StringReplace($hcdc1,"Wykryto 1 prawdopodobnych HashCodów" & @CRLF,"")
	GuiCtrlSetData($Edit7,$hcdc2)
	_IEQuit($oIE)
Case $Button7
	$oIE = _IECreate("                                ",0,0,1,1)
	_IELoadWait($oIE)
	$hc = _IEGetObjByName($oIE,"hashe")
	_IEFormElementSetValue($hc,GuiCtrlRead($Edit8))
	$box = _IEGetObjByName($oIE,"iAcc")
	_IEAction($box,"click")
	$colTags = _IETagNameGetCollection($oIE, "input")
	For $oTag In $colTags
	; Might also work this way:
	;    If $oTag.value = "Release" Then
    If _IEPropertyGet($oTag, "innertext") = "Utwórz BBCode :)" Then
        _IEAction($oTag, "click")
    EndIf
	Next
	_IELoadWait($oIE)
	$hcdc = _IEGetObjByID($oIE,"prawa")
	$hcdc1 = _IEPropertyGet($hcdc,"innertext")
	$hcdc2 = StringReplace($hcdc1,"Wykryto 1 prawdopodobnych HashCodów" & @CRLF,"")
	GuiCtrlSetData($Edit8,$hcdc2)
	_IEQuit($oIE)
Case $Button8
	$oIE = _IECreate("                                ",0,0,1,1)
	_IELoadWait($oIE)
	$hc = _IEGetObjByName($oIE,"hashe")
	_IEFormElementSetValue($hc,GuiCtrlRead($Edit9))
	$box = _IEGetObjByName($oIE,"iAcc")
	_IEAction($box,"click")
	$colTags = _IETagNameGetCollection($oIE, "input")
	For $oTag In $colTags
	; Might also work this way:
	;    If $oTag.value = "Release" Then
    If _IEPropertyGet($oTag, "innertext") = "Utwórz BBCode :)" Then
        _IEAction($oTag, "click")
    EndIf
	Next
	_IELoadWait($oIE)
	$hcdc = _IEGetObjByID($oIE,"prawa")
	$hcdc1 = _IEPropertyGet($hcdc,"innertext")
	$hcdc2 = StringReplace($hcdc1,"Wykryto 1 prawdopodobnych HashCodów" & @CRLF,"")
	GuiCtrlSetData($Edit9,$hcdc2)
	_IEQuit($oIE)
Case $Button9
	$oIE = _IECreate("                                ",0,0,1,1)
	_IELoadWait($oIE)
	$hc = _IEGetObjByName($oIE,"hashe")
	_IEFormElementSetValue($hc,GuiCtrlRead($Edit10))
	$box = _IEGetObjByName($oIE,"iAcc")
	_IEAction($box,"click")
	$colTags = _IETagNameGetCollection($oIE, "input")
	For $oTag In $colTags
	; Might also work this way:
	;    If $oTag.value = "Release" Then
    If _IEPropertyGet($oTag, "innertext") = "Utwórz BBCode :)" Then
        _IEAction($oTag, "click")
    EndIf
	Next
	_IELoadWait($oIE)
	$hcdc = _IEGetObjByID($oIE,"prawa")
	$hcdc1 = _IEPropertyGet($hcdc,"innertext")
	$hcdc2 = StringReplace($hcdc1,"Wykryto 1 prawdopodobnych HashCodów" & @CRLF,"")
	GuiCtrlSetData($Edit10,$hcdc2)
	_IEQuit($oIE)
Case $Button2
	$Forml1 = GUICreate("BBCode", 633, 367, 192, 124)
	$Editl1 = GUICtrlCreateEdit("", 8, 8, 617, 321)
	$Buttonl1 = GUICtrlCreateButton("Zapisz", 276, 336, 81, 25, $WS_GROUP)
	$Buttonl2 = GUICtrlCreateButton("Kopiuj", 8, 336, 49, 25, $WS_GROUP)
	GUISetState(@SW_SHOW)
	opis("[center]")
	opis("[img]" & $Pres & "[/img]")
	opis("")
	opis($Kolor1 & $Font1 & "[size=6][b]" & GuiCtrlRead($Input1) & "[/b][/size][/font][/color]")
	If NOT GuiCtrlRead($Input2) = "" Then opis($Kolor2 & $Font2 & "[b]" & GuiCtrlRead($Input2) & "[/b][/color][/font]")
	opis("")
	opis("[img]" & GuiCtrlRead($Input3) & "[/img]")
	opis("")
	opis("[img]" & $Info & "[/img]")
	opis("")
	If Not GuiCtrlRead($Input8) = "" Then opis("[b]" & $Kolor2 & "Typ[/color][/b] : " & GuiCtrlRead($Input4)) 
	If Not GuiCtrlRead($Input8) = "" Then opis("[b]" & $Kolor2 & "Data Premiery[/color][/b] : " & GuiCtrlRead($Input5)) 
	If Not GuiCtrlRead($Input8) = "" Then opis("[b]" & $Kolor2 & "Dozwolony Wiek[/color][/b] : " & GuiCtrlRead($Input6)) 
	If Not GuiCtrlRead($Input8) = "" Then opis("[b]" & $Kolor2 & "Ocena[/color][/b] : " & GuiCtrlRead($Input7))
	If Not GuiCtrlRead($Input31) = "" Then opis("[b]" & $Kolor2 & "Gatunek[/color][/b] : " & GuiCtrlRead($Input31))
	If Not GuiCtrlRead($Input33) = "" Then opis("[b]" & $Kolor2 & "Czas Trwania[/color][/b] : " & GuiCtrlRead($Input33)) 
	opis("")
	If Not GuiCtrlRead($Input32) = "" Then opis("[b]" & $Kolor1 & "Produkcja[/color][/b] : " & GuiCtrlRead($Input32)) 
	If Not GuiCtrlRead($Input8) = "" Then opis("[b]" & $Kolor1 & "Re¿yseria[/color][/b] : " & GuiCtrlRead($Input8)) 
	If Not GuiCtrlRead($Input9) = "" Then opis("[b]" & $Kolor1 & "Muzyka[/color][/b] : " & GuiCtrlRead($Input9))
	If Not GuiCtrlRead($Input10) = "" Then opis("[b]" & $Kolor1 & "Scenografia[/color][/b] : " & GuiCtrlRead($Input10))
	If Not GuiCtrlRead($Input11) = "" Then opis("[b]" & $Kolor1 & "Zdjêcia[/color][/b] : " & GuiCtrlRead($Input11))
	opis("")
	If Not GuiCtrlRead($Input18) = "" Then opis("[b]" & $Kolor2 & "Jêzyk[/color][/b] : " & GuiCtrlRead($Input18))
	If Not GuiCtrlRead($Input19) = "" Then opis("[b]" & $Kolor2 & "Napisy[/color][/b] : " & GuiCtrlRead($Input19))
	If Not GuiCtrlRead($Input20) = "" Then opis("[b]" & $Kolor2 & "Grupa[/color][/b] : " & GuiCtrlRead($Input20))
	opis("")
	opis("[img]" & $Opis & "[/img]")
	opis("[opis][FONT=Comic Sans MS]" & GuiCtrlRead($Edit1) & "[/font][/opis]")
	opis("[img]" & $Obsada & "[/img]")
	opis("")
	opis("[color=DarkSlateGray][b]" & GuiCtrlRead($Edit2) & "[/b][/color]")
	opis("")
	$pop1 = StringReplace(GuiCtrlRead($Edit4),"http://","[img]http://")
	$pop2 = StringReplace($pop1,".jpg",".jpg[/img]")
	$pop3 = StringReplace($pop2,".png",".png[/img]")
	$pop4 = StringReplace($pop3,".gif",".gif[/img]")
	opis("")
	opis("[img]" & $Screeny & "[/img]")
	opis("")
	opis("[opis]" & $pop4 & "[/opis]")
	opis("")
	opis("[img]" & $AviCodec & "[/img]")
	opis("[code]" & GuiCtrlRead($Edit3) & "[/code]")
	opis("[img]" & $Download & "[/img]")
	opis("")
	If NOT GuiCtrlRead($Edit5) = "" AND GuiCtrlRead($Edit6) = "" Then
		If NOT GuiCtrlRead($Input12) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 1 - [/color][color=DarkGreen] " & GuiCtrlRead($Input12) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 1 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit5))
	ElseIF Not GuiCtrlReaD($Edit6) = "" AND GuiCtrlRead($Edit7) = "" Then
		If NOT GuiCtrlRead($Input12) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 1 - [/color][color=DarkGreen] " & GuiCtrlRead($Input12) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 1 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit5))
		If NOT GuiCtrlRead($Input13) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 2 - [/color][color=DarkGreen] " & GuiCtrlRead($Input13) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 2 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit6))
	ElseIF Not GuiCtrlRead($Edit7) = "" And GuiCtrlRead($Edit8) = "" Then
		If NOT GuiCtrlRead($Input12) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 1 - [/color][color=DarkGreen] " & GuiCtrlRead($Input12) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 1 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit5))
		If NOT GuiCtrlRead($Input13) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 2 - [/color][color=DarkGreen] " & GuiCtrlRead($Input13) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 2 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit6))
		If Not GuiCtrlRead($Input14) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 3 - [/color][color=DarkGreen] " & GuiCtrlRead($Input14) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 3 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit7))
	ElseIf Not GuiCtrlRead($Edit8) = "" AND GuiCtrlRead($Edit9) = "" Then
		If NOT GuiCtrlRead($Input12) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 1 - [/color][color=DarkGreen] " & GuiCtrlRead($Input12) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 1 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit5))
		If NOT GuiCtrlRead($Input13) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 2 - [/color][color=DarkGreen] " & GuiCtrlRead($Input13) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 2 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit6))
		If Not GuiCtrlRead($Input14) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 3 - [/color][color=DarkGreen] " & GuiCtrlRead($Input14) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 3 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit7))
		If Not GuiCtrlRead($Input15) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 4 - [/color][color=DarkGreen] " & GuiCtrlRead($Input15) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 4 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlReaD($Edit8))
	ElseIf Not GuiCtrlRead($Edit9) = "" AND GuiCtrlRead($Edit10) = "" Then
		If NOT GuiCtrlRead($Input12) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 1 - [/color][color=DarkGreen] " & GuiCtrlRead($Input12) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 1 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit5))
		If NOT GuiCtrlRead($Input13) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 2 - [/color][color=DarkGreen] " & GuiCtrlRead($Input13) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 2 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit6))
		If Not GuiCtrlRead($Input14) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 3 - [/color][color=DarkGreen] " & GuiCtrlRead($Input14) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 3 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit7))
		If Not GuiCtrlRead($Input15) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 4 - [/color][color=DarkGreen] " & GuiCtrlRead($Input15) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 4 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlReaD($Edit8))
		If Not GuiCtrlRead($Input16) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 5 - [/color][color=DarkGreen] " & GuiCtrlRead($Input16) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 5 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit9))
		ElseIF Not GuiCtrlRead($Edit10) = "" Then
		If NOT GuiCtrlRead($Input12) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 1 - [/color][color=DarkGreen] " & GuiCtrlRead($Input12) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 1 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit5))
		If NOT GuiCtrlRead($Input13) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 2 - [/color][color=DarkGreen] " & GuiCtrlRead($Input13) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 2 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit6))
		If Not GuiCtrlRead($Input14) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 3 - [/color][color=DarkGreen] " & GuiCtrlRead($Input14) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 3 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit7))
		If Not GuiCtrlRead($Input15) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 4 - [/color][color=DarkGreen] " & GuiCtrlRead($Input15) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 4 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlReaD($Edit8))
		If Not GuiCtrlRead($Input16) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 5 - [/color][color=DarkGreen] " & GuiCtrlRead($Input16) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 5 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit9))
		If Not GuiCtrlRead($Input17) = "" Then
			opis("[Size=4]..::[Color=Navy] Epizod 6 - [/color][color=DarkGreen] " & GuiCtrlRead($Input17) & " [/color]::..[/size]")
		Else
			opis("[Size=4]..::[Color=Navy] Epizod 5 [/color]::..[/size]")
		EndIf
		opis(GuiCtrlRead($Edit10))
	EndIf
	opis("[img]" & $Uczestnicy & "[/img]")
	opis("")
	#Comments-start
	If NOT GuiCtrlRead($Input21) = "" AND GuiCtrlRead($Input24) = "" Then
		$Upload = GuiCtrlRead($Input21)
	ElseIf NOT GuiCtrlRead($Input24) = "" AND GuiCtrlRead($Input27) = "" Then
		$Upload = GuiCtrlRead($Input21) & ", " & GuiCtrlRead($Input24)
	ElseIf Not GuiCtrlRead($Input27) = "" Then
		$Upload = GuiCtrlRead($Input21) & ", " & GuiCtrlRead($Input24) & ", " & GuiCtrlRead($Input27)
	EndIf 
	IF Not GuiCtrlRead($Input23) = "" AND GuiCtrlRead($Input26) = "" Then
		$Opisik = GuiCtrlRead($Input23)
	ElseIf NOT GuiCtrlRead($Input26) = "" AND GuiCtrlRead($Input29) = "" Then
		$Opisik = GuiCtrlRead($Input23) & ", " & GuiCtrlRead($Input26)
	ElseIF NOT GuiCtrlRead($Input29) = "" Then
		$Opisik = GuiCtrlRead($Input23) & ", " & GuiCtrlRead($Input26) & ", " & GuiCtrlRead($Input29)
	EndIf
	IF Not GuiCtrlRead($Input22) = "" AND GuiCtrlRead($Input25) = "" Then
		$Konta = GuiCtrlRead($Input22)
	ElseIf NOT GuiCtrlRead($Input25) = "" AND GuiCtrlRead($Input28) = "" Then
		$Konta = GuiCtrlRead($Input22) & ", " & GuiCtrlRead($Input25)
	ElseIF NOT GuiCtrlRead($Input28) = "" Then
		$Konta = GuiCtrlRead($Input22) & ", " & GuiCtrlRead($Input25) & ", " & GuiCtrlRead($Input28)
	EndIf
	#Comments-end
	If NOT GuiCtrlRead($Input21) = "" AND GuiCtrlRead($Input24) = "" Then
		If StringLeft(GuiCtrlRead($Input21),1) = "=" Then 
			$Upload = "[color=#e29eb1]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "~" Then
			$Upload = "[color=olive]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "^" Then
			$Upload = "[color=blue]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "%" Then
			$Upload = "[color=#8a6fb1]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "!" Then
			$Upload = "[color=#a5434d]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "#" Then
			$Upload = "[color=green]" & GuiCtrlRead($Input21) & "[/color]"
		Else
			$Upload = GuiCtrlRead($Input21)
		EndIf
	ElseIf NOT GuiCtrlRead($Input24) = "" AND GuiCtrlRead($Input27) = "" Then
		If StringLeft(GuiCtrlRead($Input21),1) = "=" Then 
			$Upload1 = "[color=#e29eb1]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "~" Then
			$Upload1 = "[color=olive]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "^" Then
			$Upload1 = "[color=blue]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "%" Then
			$Upload1 = "[color=#8a6fb1]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "!" Then
			$Upload1 = "[color=#a5434d]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "#" Then
			$Upload1 = "[color=green]" & GuiCtrlRead($Input21) & "[/color]"
		Else
			$Upload1 = GuiCtrlRead($Input21)
		EndIf
		If StringLeft(GuiCtrlRead($Input24),1) = "=" Then 
			$Upload2 = "[color=#e29eb1]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "~" Then
			$Upload2 = "[color=olive]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "^" Then
			$Upload2 = "[color=blue]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "%" Then
			$Upload2 = "[color=#8a6fb1]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "!" Then
			$Upload2 = "[color=#a5434d]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "#" Then
			$Upload2 = "[color=green]" & GuiCtrlRead($Input24) & "[/color]"
		Else
			$Upload2 = GuiCtrlRead($Input24)
		EndIf
		$Upload = $Upload1 & ", " & $Upload2
	ElseIf Not GuiCtrlRead($Input27) = "" Then
		If StringLeft(GuiCtrlRead($Input21),1) = "=" Then 
			$Upload1 = "[color=#e29eb1]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "~" Then
			$Upload1 = "[color=olive]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "^" Then
			$Upload1 = "[color=blue]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "%" Then
			$Upload1 = "[color=#8a6fb1]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "!" Then
			$Upload1 = "[color=#a5434d]" & GuiCtrlRead($Input21) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input21),1) = "#" Then
			$Upload1 = "[color=green]" & GuiCtrlRead($Input21) & "[/color]"
		Else
			$Upload1 = GuiCtrlRead($Input21)
		EndIf
		If StringLeft(GuiCtrlRead($Input24),1) = "=" Then 
			$Upload2 = "[color=#e29eb1]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "~" Then
			$Upload2 = "[color=olive]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "^" Then
			$Upload2 = "[color=blue]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "%" Then
			$Upload2 = "[color=#8a6fb1]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "!" Then
			$Upload2 = "[color=#a5434d]" & GuiCtrlRead($Input24) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input24),1) = "#" Then
			$Upload2 = "[color=green]" & GuiCtrlRead($Input24) & "[/color]"
		Else
			$Upload2 = GuiCtrlRead($Input24)
		EndIf
		If StringLeft(GuiCtrlRead($Input27),1) = "=" Then 
			$Upload3 = "[color=#e29eb1]" & GuiCtrlRead($Input27) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input27),1) = "~" Then
			$Upload3 = "[color=olive]" & GuiCtrlRead($Input27) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input27),1) = "^" Then
			$Upload3 = "[color=blue]" & GuiCtrlRead($Input27) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input27),1) = "%" Then
			$Upload3 = "[color=#8a6fb1]" & GuiCtrlRead($Input27) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input27),1) = "!" Then
			$Upload3 = "[color=#a5434d]" & GuiCtrlRead($Input27) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input27),1) = "#" Then
			$Upload3 = "[color=green]" & GuiCtrlRead($Input27) & "[/color]"
		Else
			$Upload3 = GuiCtrlRead($Input27)
		EndIf
		$Upload = $Upload1 & ", " & $Upload2 & ", " & $Upload3
	EndIf 
	IF Not GuiCtrlRead($Input23) = "" AND GuiCtrlRead($Input26) = "" Then
		If StringLeft(GuiCtrlRead($Input23),1) = "=" Then 
			$Opisik = "[color=#e29eb1]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "~" Then
			$Opisik= "[color=olive]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "^" Then
			$Opisik = "[color=blue]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "%" Then
			$Opisik = "[color=#8a6fb1]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "!" Then
			$Opisik = "[color=#a5434d]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "#" Then
			$Opisik = "[color=green]" & GuiCtrlRead($Input23) & "[/color]"
		Else
			$Opisik = GuiCtrlRead($Input23)
		EndIf
	ElseIf NOT GuiCtrlRead($Input26) = "" AND GuiCtrlRead($Input29) = "" Then
		If StringLeft(GuiCtrlRead($Input23),1) = "=" Then 
			$Opisik1 = "[color=#e29eb1]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "~" Then
			$Opisik1 = "[color=olive]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "^" Then
			$Opisik1 = "[color=blue]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "%" Then
			$Opisik1 = "[color=#8a6fb1]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "!" Then
			$Opisik1 = "[color=#a5434d]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "#" Then
			$Opisik1 = "[color=green]" & GuiCtrlRead($Input23) & "[/color]"
		Else
			$Opisik1 = GuiCtrlRead($Input23)
		EndIf
		If StringLeft(GuiCtrlRead($Input26),1) = "=" Then 
			$Opisik2 = "[color=#e29eb1]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "~" Then
			$Opisik2 = "[color=olive]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "^" Then
			$Opisik2 = "[color=blue]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "%" Then
			$Opisik2 = "[color=#8a6fb1]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "!" Then
			$Opisik2 = "[color=#a5434d]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "#" Then
			$Opisik2 = "[color=green]" & GuiCtrlRead($Input26) & "[/color]"
		Else
			$Opisik2 = GuiCtrlRead($Input26)
		EndIf
		$Opisik = $Opisik1 & ", " & $Opisik2
	ElseIF NOT GuiCtrlRead($Input29) = "" Then
		If StringLeft(GuiCtrlRead($Input23),1) = "=" Then 
			$Opisik1 = "[color=#e29eb1]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "~" Then
			$Opisik1 = "[color=olive]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "^" Then
			$Opisik1 = "[color=blue]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "%" Then
			$Opisik1 = "[color=#8a6fb1]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "!" Then
			$Opisik1 = "[color=#a5434d]" & GuiCtrlRead($Input23) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input23),1) = "#" Then
			$Opisik1 = "[color=green]" & GuiCtrlRead($Input23) & "[/color]"
		Else
			$Opisik1 = GuiCtrlRead($Input23)
		EndIf
		If StringLeft(GuiCtrlRead($Input26),1) = "=" Then 
			$Opisik2 = "[color=#e29eb1]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "~" Then
			$Opisik2 = "[color=olive]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "^" Then
			$Opisik2 = "[color=blue]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "%" Then
			$Opisik2 = "[color=#8a6fb1]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "!" Then
			$Opisik2 = "[color=#a5434d]" & GuiCtrlRead($Input26) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input26),1) = "#" Then
			$Opisik2 = "[color=green]" & GuiCtrlRead($Input26) & "[/color]"
		Else
			$Opisik2 = GuiCtrlRead($Input26)
		EndIf
		If StringLeft(GuiCtrlRead($Input29),1) = "=" Then 
			$Opisik3 = "[color=#e29eb1]" & GuiCtrlRead($Input29) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input29),1) = "~" Then
			$Opisik3 = "[color=olive]" & GuiCtrlRead($Input29) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input29),1) = "^" Then
			$Opisik3 = "[color=blue]" & GuiCtrlRead($Input29) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input29),1) = "%" Then
			$Opisik3 = "[color=#8a6fb1]" & GuiCtrlRead($Input29) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input29),1) = "!" Then
			$Opisik3 = "[color=#a5434d]" & GuiCtrlRead($Input29) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input29),1) = "#" Then
			$Opisik3 = "[color=green]" & GuiCtrlRead($Input29) & "[/color]"
		Else
			$Opisik3 = GuiCtrlRead($Input29)
		EndIf
		$Opisik = $Opisik1 & ", " & $Opisik2 & ", " & $Opisik3
	EndIf
	IF Not GuiCtrlRead($Input22) = "" AND GuiCtrlRead($Input25) = "" Then
		If StringLeft(GuiCtrlRead($Input22),1) = "=" Then 
			$Konta = "[color=#e29eb1]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "~" Then
			$Konta = "[color=olive]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "^" Then
			$Konta = "[color=blue]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "%" Then
			$Konta = "[color=#8a6fb1]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "!" Then
			$Konta = "[color=#a5434d]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "#" Then
			$Konta = "[color=green]" & GuiCtrlRead($Input22) & "[/color]"
		Else
			$Konta = GuiCtrlRead($Input22)
		EndIf
	ElseIf NOT GuiCtrlRead($Input25) = "" AND GuiCtrlRead($Input28) = "" Then
		If StringLeft(GuiCtrlRead($Input22),1) = "=" Then 
			$Konta1 = "[color=#e29eb1]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "~" Then
			$Konta1 = "[color=olive]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "^" Then
			$Konta1 = "[color=blue]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "%" Then
			$Konta1 = "[color=#8a6fb1]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "!" Then
			$Konta1 = "[color=#a5434d]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "#" Then
			$Konta1 = "[color=green]" & GuiCtrlRead($Input22) & "[/color]"
		Else
			$Konta1 = GuiCtrlRead($Input22)
		EndIf
		If StringLeft(GuiCtrlRead($Input25),1) = "=" Then 
			$Konta2 = "[color=#e29eb1]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "~" Then
			$Konta2 = "[color=olive]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "^" Then
			$Konta2 = "[color=blue]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "%" Then
			$Konta2 = "[color=#8a6fb1]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "!" Then
			$Konta2 = "[color=#a5434d]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "#" Then
			$Konta2 = "[color=green]" & GuiCtrlRead($Input25) & "[/color]"
		Else
			$Konta2 = GuiCtrlRead($Input25)
		EndIf
		$Konta = $Konta1 & ", " & $Konta2
	ElseIF NOT GuiCtrlRead($Input28) = "" Then
		If StringLeft(GuiCtrlRead($Input22),1) = "=" Then 
			$Konta1 = "[color=#e29eb1]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "~" Then
			$Konta1 = "[color=olive]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "^" Then
			$Konta1 = "[color=blue]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "%" Then
			$Konta1 = "[color=#8a6fb1]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "!" Then
			$Konta1 = "[color=#a5434d]" & GuiCtrlRead($Input22) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input22),1) = "#" Then
			$Konta1 = "[color=green]" & GuiCtrlRead($Input22) & "[/color]"
		Else
			$Konta1 = GuiCtrlRead($Input22)
		EndIf
		If StringLeft(GuiCtrlRead($Input25),1) = "=" Then 
			$Konta2 = "[color=#e29eb1]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "~" Then
			$Konta2 = "[color=olive]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "^" Then
			$Konta2 = "[color=blue]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "%" Then
			$Konta2 = "[color=#8a6fb1]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "!" Then
			$Konta2 = "[color=#a5434d]" & GuiCtrlRead($Input25) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input25),1) = "#" Then
			$Konta2 = "[color=green]" & GuiCtrlRead($Input25) & "[/color]"
		Else
			$Konta2 = GuiCtrlRead($Input25)
		EndIf
		If StringLeft(GuiCtrlRead($Input28),1) = "=" Then 
			$Konta3 = "[color=#e29eb1]" & GuiCtrlRead($Input28) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input28),1) = "~" Then
			$Konta3 = "[color=olive]" & GuiCtrlRead($Input28) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input28),1) = "^" Then
			$Konta3 = "[color=blue]" & GuiCtrlRead($Input28) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input28),1) = "%" Then
			$Konta3 = "[color=#8a6fb1]" & GuiCtrlRead($Input28) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input28),1) = "!" Then
			$Konta3 = "[color=#a5434d]" & GuiCtrlRead($Input28) & "[/color]"
		ElseIf StringLeft(GuiCtrlRead($Input28),1) = "#" Then
			$Konta3 = "[color=green]" & GuiCtrlRead($Input28) & "[/color]"
		Else
			$Konta3 = GuiCtrlRead($Input28)
		EndIf
		$Konta = $Konta1 & ", " & $Konta2 & ", " & $Konta3
	EndIf
	opis("[b][color=Indigo]Upload: [/color]" & $Upload & "[/b]")
	opis("[b][color=DarkSlateGray]Konta: [/color]" & $Konta & "[/b]")
	opis("[b][color=DarkSlateGray]Opis: [/color]" & $Opisik & "[/b]")
	opis("[/center]")
	While 1
		$nMsg = GuiGetMsg()
		Switch $nMsg
		Case $Buttonl1
			$MyDocsFolder = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}"
			$var = FileSaveDialog("Zapisz plik z opisem",$MyDocsFolder,"Tekst (*.txt)",2,GuiCtrlRead($Input1) & ".txt")
			If @ERROR Then
				ToolTip("Plik z opisem nie zosta³ zapisany!",0,0,"Zapis pliku z opisem")
			Else
				FileWrite($var,GuiCtrlRead($Editl1))
				ToolTip("Plik z opisem zosta³ zapisany" & @CRLF & $var,0,0,"Zapis pliku z opisem")
			EndIf
		Case $Buttonl2
			ClipPut(GuiCtrlRead($Editl1))
		Case $GUI_EVENT_CLOSE
			Exit
		EndSwitch
	WEnd
Case $Button1
		$oIE = _IECreate(GuiCtrlRead($Input30),0,0,1,0)
		_IELoadWait($oIE)
		$tyt = _IEGetObjById($oIE,"typanime") ; Typ Anime (np Serial TV)
		$prm = _IEGetObjById($oIE,"premiera") ; Data Premiery
		$ocr = _IEGetObjById($oIE,"ocena_redakcji") ; Ocena Redakcji
		$ogw = _IEGetObjById($oIE,"ograniczenie_wieku") ; Ograniczenia wiekowe
		$ogi = _IEGetObjById($oIE,"ograniczenie_img") ; Ikonka ograniczeñ +                          
		$opi = _IEGetObjByID($oIE,"synopsis") ; opis
		If @Error Then
			ToolTip("Nie znaleziono niektórych informacji!",0,0,"Uwaga")
			Sleep(2000)
		EndIf
		$l1 = StringReplace(_IEPropertyGet($tyt,"innertext"), "Produkcja" & @CRLF, "")
		$l2 = StringReplace(_IEPropertyGet($prm,"innertext"), "Premiera" & @CRLF, "")
		$naw1 = StringReplace(_IEPropertyGet($ogw,"innertext"),"(","")
		$naw2 = StringReplace($naw1,")","")
		$l3 = StringReplace(_IEPropertyGet($ocr,"innertext"), "Ocena redakcji", "")
		If NOT $l1 = 0 Then
			GuiCtrlSetData($Input4,$l1)
		EndIf
		If NOT $l2 = 0 Then
			GuiCtrlSetData($Input5,$l2)
		EndIf
		If Not $naw2 = 0 Then
			GuiCtrlSetData($Input6,$naw2)
		EndIf
		If NOT $l3 = 0 Then
			GuiCtrlSetData($Input7,$l3 & " [redakcja Azunime.net]")
		EndIf
		If Not _IEPropertyGet($opi,"innertext") = 0 Then
			GuiCtrlSetData($Edit1,_IEPropertyGet($opi,"innertext"))
		EndIf
		_IEQuit($oIE)
Case $GUI_EVENT_CLOSE
	Exit
EndSwitch
WEnd
