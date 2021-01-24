#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=add.ico
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Date.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>

$buffer = 0
Global $input_hrdwr1price, $input_hrdwr2price, $input_hrdwr3price, $input_hrdwr4price, $input_hrdwr5price, $input_tlfnr, $color, $accesory, $dbn
Global Const $CBS_DROPDOWNLIST = 0x0003
Dim $salesman = ""
Dim $client = "ADD-Data "
Dim $date =  @MDAY & "-" & @MON & "-" & @YEAR
Dim $time = @HOUR & ":" & @MIN & ":" & @SEC
Dim $overslagheadline = "Overslag på reperationens pris (ikke bindende)"
Dim $int_ialtprice = $input_hrdwr1price + $input_hrdwr2price + $input_hrdwr3price + $input_hrdwr4price + $input_hrdwr5price
Dim $form_num = GUIctrlRead($input_tlfnr, 1) & @MDAY&@MON&@YEAR&@HOUR&@MIN&@SEC		

Dim $row1 = 30
Dim $row2 = $row1 + 30
Dim $row3 = $row2 + 30
Dim $row4 = $row3 + 30
Dim $row5 = $row4 + 30
Dim $rowheight = 20
Dim $colom1 = 20
Dim $colom2 = $colom1 + 120
Dim $colom3 = $colom2 + 120
Dim $colom4 = $colom3 + 120
Dim $smallcolom1 = 30
Dim $smallcolom2 = $smallcolom1 + 80
Dim $smallcolom3 = $smallcolom2 + 80
Dim $smallcolom4 = $smallcolom3 + 80
Dim $smallcolom5 = $smallcolom4 + 80
Dim $smallcolom6 = $smallcolom5 + 80
Dim $smallcolom7 = $smallcolom6 + 80
Dim $colomwidth = 110
Dim $smallwidth = 70

$hGUI = GUICreate ($client & "RMA System", 500, 670)
GUISetIcon("add.ico")
GUIRegisterMsg($WM_MOVE, "WM_MOVE")
$hTabs = GUICtrlCreateTab (0, 0, 500, 675)
$hTabPage1 = GUICtrlCreateTabItem ("Ny Indlevering")
		$label_ditnavn		= GUICtrlCreateLabel("Dit Navn: ", 				10, 	33, 	100, 	20, 	2)
		$combo_modtager		= GUICtrlCreateCombo("Alf",						110, 	30,		70, 	20, 	$CBS_DROPDOWNLIST) ; create first item
		GUICtrlSetData($combo_modtager, "Claus|Lasse|Per|Jacob|Toke") ; add other item
		GUICtrlCreateLabel("Date : " & $date & "  Time: " & $time, 190, 33, 300, 20, 0)
		$label_navn		 	= GUICtrlCreateLabel("Navn:  ", 				10, 	58, 	100, 	20, 	2)
		$input_navn			= GUICtrlCreateInput("", 						110, 	55, 	300, 	20, 	0)
		$label_tlfnr 		= GUICtrlCreateLabel("Telefonnummer:  ",		10, 	83, 	100, 	20, 	2)
		$input_tlfnr		= GUICtrlCreateInput("", 						110, 	80, 	150, 	20, 	0)
		$input_email		= GUICtrlCreateInput("E-Mail", 					270, 	80, 	140, 	20, 	0)
		$label_indleveret 	= GUICtrlCreateLabel("Indleveret produkt:  ",	10, 	108, 	100, 	20, 	2)
		$combo_indleveret	= GUICtrlCreateCombo("Almindelig PC", 			110, 	105,	170,	20,		$CBS_DROPDOWNLIST) ; create first item
		GUICtrlSetData($combo_indleveret, "Bærbar Computer|Hardware|Andet") ; add other item snd set a new default
		$chkbx_garanti 		= GUICtrlCreateCheckbox("Garantireperation", 	10, 	130, 	100, 	20)
		$combo_faknr		= GUICtrlCreateCombo("Faktura nr.", 			110, 	130,	100,	20, 2) ; create first item
		GUICtrlSetData($combo_faknr, "Ukendt") ; add other item snd set a new default
		
		$label_overslag		= GUICtrlCreateLabel($overslagheadline, 10, 450, 300, 15)
		$input_antaltimer	= GUICtrlCreateInput("", 10, 475, 30, 17)
		$label_antaltimer	= GUICtrlCreateLabel("Arbejdstimer", 45, 477, 100, 17)
		$label_hrdwrlabel	= GUICtrlCreateLabel("Reservedel", 10, 485, 360, 15, 1)
		$input_hrdwr1		= GUICtrlCreateInput("", 10, 500, 360, 20)
		$input_hrdwr1price	= GUICtrlCreateInput("", 369, 500, 100, 20)
		$input_hrdwr2		= GUICtrlCreateInput("", 10, 519, 360, 20)
		$input_hrdwr2price	= GUICtrlCreateInput("", 369, 519, 100, 20)
		$input_hrdwr3		= GUICtrlCreateInput("", 10, 538, 360, 20)
		$input_hrdwr3price	= GUICtrlCreateInput("", 369, 538, 100, 20)		
		$input_hrdwr4		= GUICtrlCreateInput("", 10, 557, 360, 20)
		$input_hrdwr4price	= GUICtrlCreateInput("", 369, 557, 100, 20)	
		$input_hrdwr5		= GUICtrlCreateInput("", 10, 576, 360, 20)
		$input_hrdwr5price	= GUICtrlCreateInput("", 369, 576, 100, 20)
		$label_ialtprice	= GUICtrlCreateLabel("Pris i alt: ", 10, 600, 360, 20, 2)
		$input_ialtprice	= GUICtrlCreateInput($int_ialtprice, 369, 595, 100, 20)
		
		$gemogudskriv 		= GUICtrlCreateButton("Gem og Udskriv", 200, 630, 100, 25)

$hTabPage2 = GUICtrlCreateTabItem ("Tjek Status")
	

$hindleveret = GUICreate ("", 500, 280, 0, 180, $WS_POPUP, $WS_EX_MDICHILD, $hGUI)
	$hSubTabs = GUICtrlCreateTab (0, 0, 500, 280)
	$hSubTabPage1 = GUICtrlCreateTabItem ("Beskrivelse")
		$check_color_black	= GUICtrlCreateCheckbox("Sort", 			$smallcolom1, $row1, $smallwidth, $rowheight)
		$check_color_silver	= GUICtrlCreateCheckbox("Sølv", 			$smallcolom2, $row1, $smallwidth, $rowheight)
		$check_color_blue	= GUICtrlCreateCheckbox("Blå", 				$smallcolom3, $row1, $smallwidth, $rowheight)
		$check_color_yellow	= GUICtrlCreateCheckbox("Gul", 				$smallcolom4, $row1, $smallwidth, $rowheight)
		$check_color_green	= GUICtrlCreateCheckbox("Grøn",				$smallcolom5, $row1, $smallwidth, $rowheight)
		$check_color_red	= GUICtrlCreateCheckbox("Rød",				$smallcolom6, $row1, $smallwidth, $rowheight)
		$combo_brand	= GUICtrlCreateCombo("Mærke", 					$colom1,      $row2, $colomwidth, $rowheight, $CBS_DROPDOWNLIST) ; create first item
		GUICtrlSetData($combo_brand, "Asus|MSI|Toshiba|Clevo|HP|Shuttle|Aopen|Calvin|Acer|Packard Bell|Samsung|Lenovo|IBM|NZXT|Antec|Apevia") ; add other item snd set a new default
		$diversebskrvls = GUICtrlCreateInput("",					$colom1, $row4 - 10, 450, 150)
	$hSubTabPage2 = GUICtrlCreateTabItem ("Tilbehør")
		$recoverymedier = GUICtrlCreateCheckbox("Recovery Medier", 	$colom1, $row1, $colomwidth, $rowheight)
		$PSU 			= GUICtrlCreateCheckbox("Strømforsyning", 	$colom2, $row1, $colomwidth, $rowheight)
		$taske			= GUICtrlCreateCheckbox("Taske", 			$colom3, $row1, $colomwidth, $rowheight)
		$memorystick	= GUICtrlCreateCheckbox("Memorystick", 		$colom4, $row1, $colomwidth, $rowheight)
		$eksternhdd		= GUICtrlCreateCheckbox("Ekstern Harddisk",	$colom1, $row2, $colomwidth, $rowheight)
		$eksterndvdrw	= GUICtrlCreateCheckbox("Ekstern DVD/RW",	$colom2, $row2, $colomwidth, $rowheight)
		$manual			= GUICtrlCreateCheckbox("Manual",			$colom3, $row2, $colomwidth, $rowheight)
		$3gmodem		= GUICtrlCreateCheckbox("3G Modem",			$colom4, $row2, $colomwidth, $rowheight)
		$andetTlbhr		= GUICtrlCreateLabel("Andet:", 				$colom1, $row3, $colomwidth, $rowheight)
		$diversetlbhr	= GUICtrlCreateInput("",					$colom1, $row4 - 10, 450, 150)
	$hSubTabPage3 = GUICtrlCreateTabItem ("Fejlbeskrivelse")
		$fejlbeskrivelse = GUICtrlCreateInput("",0, 20, 500, 260)

$hindleveret_read = GUICreate ("", 500, 280, 0, 180, $WS_POPUP, $WS_EX_MDICHILD, $hGUI)
	$hSubTabs_read = GUICtrlCreateTab (0, 0, 500, 280)
	$hSubTabPage1_read = GUICtrlCreateTabItem ("Beskrivelse")
		$diversebskrvls_read = GUICtrlCreateInput("",					$colom1, $row4 - 10, 450, 150)
	$hSubTabPage2_read = GUICtrlCreateTabItem ("Tilbehør")
		$diversetlbhr_read	= GUICtrlCreateInput("",					$colom1, $row4 - 10, 450, 150)
	$hSubTabPage3_read = GUICtrlCreateTabItem ("Fejlbeskrivelse")
		$fejlbeskrivelse_read = GUICtrlCreateInput("",0, 20, 500, 260)
	$hSubTabPage4_read = GUICtrlCreateTabItem("Yderligere Noter")
		$yderligerenoter = GUICtrlCreateInput("",0, 20, 500, 260)

GUISetState (@SW_SHOW, $hGUI)

_SQLite_Startup()
If NOT FileExists("W:\RMAdatabase.db") Then
	$dbn=_SQLite_Open("W:\RMAdatabase.db")
	_SQLite_Exec($dbn,"CREATE TABLE datas (id,modtager,timeanddate,navn,telefonnummer,email,indleveret,garanti,fakturanummer,color,brand,diversebeskrivelse,accesory,diversetlbhr,fejlbeskrivelse,antaltimer,reservedel1,pris1,reservedel2,pris2,reservedel3,pris3,reservedel4,pris4,reservedel5,pris5,ialtprice);")
Else
	$dbn=_SQLite_Open("W:\RMAdatabase.db")
EndIf

runprogram()

Func runprogram()
	While 1
		$nMsg = GUIGetMsg ()
		GUICtrlSetData($input_ialtprice, $int_ialtprice)
		Select
			Case $nMsg = $GUI_EVENT_CLOSE
				progend()
			Case $nMsg = $gemogudskriv
				checkphonenumber()
			Case GUICtrlRead ($hTabs, 1) = $hTabPage1
				If Not $buffer Then
					$buffer = True
					GUISetState (@SW_SHOW, $hindleveret)
					GUISetState (@SW_Hide, $hindleveret_read)
					GUISwitch ($hGUI)
				EndIf
			Case GUICtrlRead ($hTabs, 1) = $hTabPage2
				If $buffer Then
				   $buffer = False
					GUISetState (@SW_Hide, $hindleveret)
					GUISetState (@SW_SHOW, $hindleveret_read)
					GUISwitch ($hGUI)
				EndIf
		EndSelect
	WEnd
EndFunc

Func WM_MOVE($hWnd, $Msg, $wParam, $lParam)
    _WinAPI_RedrawWindow($hindleveret)
EndFunc

Func checkphonenumber()
    If GUICtrlRead($input_tlfnr) > 99999999 Or GUICtrlRead($input_tlfnr) < 20000000 Then
        MsgBox(0, "Fejl", "Telefonnummeret er ikke indtastet korrekt! Venligst udfyld telefonnummeret")
        runprogram()
    Else
		generateformnumber()
	EndIf
EndFunc

Func generateformnumber()
	$form_num = GUIctrlRead($input_tlfnr, 1) & @MDAY&@MON&@YEAR&@HOUR&@MIN&@SEC	
	generateaccesory()
EndFunc

Func generateaccesory()
	$accesory = ""
	If GUICtrlread($recoverymedier) = 1 Then
		$accesory = $accesory & "Recoverymedier, "
	EndIf
	If GUICtrlread($PSU) = 1 Then
		$accesory = $accesory & "Strømforsyning, "
	EndIf
	If GUICtrlread($taske) = 1 Then
		$accesory = $accesory & "Taske, "
	EndIf
	If GUICtrlread($memorystick) = 1 Then
		$accesory = $accesory & "Memorystick, "
	EndIf
	If GUICtrlread($eksternhdd) = 1 Then
		$accesory = $accesory & "Ekstern Harddisk, "
	EndIf
	If GUICtrlread($eksterndvdrw) = 1 Then
		$accesory = $accesory & "Ekstern DVD/RW, "
	EndIf
	If GUICtrlread($manual) = 1 Then
		$accesory = $accesory & "Manualer, "
	EndIf
	If GUICtrlread($3gmodem) = 1 Then
		$accesory = $accesory & "3G Modem, "
	EndIf
	generatecolor()
EndFunc

Func generatecolor()
	$color = ""
	If GUICtrlread($check_color_black) = 1 Then
		$color = $color & "Black, "
	EndIf
	If GUICtrlread($check_color_blue) = 1 Then
		$color = $color & "Blue, "
	EndIf
	IF GUICtrlread($check_color_green) = 1 Then
		$color = $color & "Green, "
	EndIf
	If GUICtrlread($check_color_red) = 1 Then
		$color = $color & "Red, "
	EndIf
	IF GUICtrlread($check_color_silver) = 1 Then
		$color = $color & "Silver, "
	EndIf
	If GUICtrlread($check_color_yellow) = 1 Then
		$color = $color & "Yellow, "
	EndIf
	dataadd($form_num)
EndFunc

Func dataadd($id)
	MsgBox(0, "Test", $color & $accesory)
	Local $retarr
	$str1 = GUICtrlRead($combo_modtager)
	$str2 = "Time: " & $time & " - " & "Date: " & $date
	$str3 = GUICtrlRead($input_navn)
	$str4 = GUICtrlRead($input_tlfnr)
	$str5 = GUICtrlRead($input_email)
	$str6 = GUICtrlRead($combo_indleveret)
	$str7 = GUICtrlRead($chkbx_garanti)
	$str8 = GUICtrlRead($combo_faknr)
	$str9 = $color
	$str10 = GUICtrlRead($combo_brand)
	$str11 = GUICtrlRead($diversebskrvls)
	$str12 = $accesory
	$str13 = GUICtrlRead($diversetlbhr)
	$str14 = GUICtrlRead($fejlbeskrivelse)
	$str15 = GUICtrlRead($input_antaltimer)
	$str16 = GUICtrlRead($input_hrdwr1)
	$str17 = GUICtrlRead($input_hrdwr1price)
	$str18 = GUICtrlRead($input_hrdwr2)
	$str19 = GUICtrlRead($input_hrdwr2price)
	$str20 = GUICtrlRead($input_hrdwr3)
	$str21 = GUICtrlRead($input_hrdwr3price)
	$str22 = GUICtrlRead($input_hrdwr4)
	$str23 = GUICtrlRead($input_hrdwr4price)
	$str24 = GUICtrlRead($input_hrdwr5)
	$str25 = GUICtrlRead($input_hrdwr5price)
	$str26 = GUICtrlRead($input_ialtprice)
	_SQLite_QuerySingleRow($dbn,"SELECT id FROM datas WHERE id='"&$id&"'",$retarr)
	If $retarr[0] <> "" Then
		_SQLite_Exec($dbn,"UPDATE datas SET modtager='"&$str1&"', timeanddate='"&$str2&"',navn='"&$str3&"',telefonnummer='"&$str4&"',email='"&$str5&"',indleveret='"&$str6&"',garanti='"&$str7&"',fakturanummer='"&$str8&"',color='"&$str9&"',brand='"&$str10&"',diversebeskrivelse='"&$str11&"',accesory='"&$str12&"',diversetlbhr='"&$str13&"',fejlbeskrivelse='"&$str14&"',antaltimer='"&$str15&"',reservedel1='"&$str16&"',pris1='"&$str17&"',reservedel2='"&$str18&"',pris2='"&$str19&"',reservedel3='"&$str20&"',pris3='"&$str21&"',reservedel4='"&$str22&"',pris4='"&$str23&"',reservedel5='"&$str24&"',pris5='"&$str25&"',ialtprice='"&$str26&"' WHERE id='"&$id&"'")
	Else
		_SQLite_Exec($dbn,"INSERT INTO datas (id,modtager,timeanddate,navn,telefonnummer,email,indleveret,garanti,fakturanummer,color,brand,diversebeskrivelse,accesory,diversetlbhr,fejlbeskrivelse,antaltimer,reservedel1,pris1,reservedel2,pris2,reservedel3,pris3,reservedel4,pris4,reservedel5,pris5,ialtprice) VALUES ('"&$form_num&"','"&$str1&"','"&$str2&"','"&$str3&"','"&$str4&"','"&$str5&"','"&$str6&"','"&$str7&"','"&$str8&"','"&$str9&"','"&$str10&"','"&$str11&"','"&$str12&"','"&$str13&"','"&$str14&"','"&$str15&"','"&$str16&"','"&$str17&"','"&$str18&"','"&$str19&"','"&$str20&"','"&$str21&"','"&$str22&"','"&$str23&"','"&$str24&"','"&$str25&"','"&$str26&"');")
	EndIf
EndFunc

Func progend()
	_SQLite_Close()
	_SQLite_Shutdown()
	Exit
EndFunc