
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <Date.au3>
#include <editconstants.au3>
#include <listviewconstants.au3>
#include <staticconstants.au3>
#include <windowsconstants.au3>
#include <guilistview.au3>
#include <Word.au3>
#include <GuiImageList.au3>
#include <Timers.au3>
#include <GuiListBox.au3>
#include <GuiButton.au3>
#include <ComboConstants.au3>
#include <misc.au3>
#include <Word.au3>
#include <MPDF_UDF.au3>
#include <GUIComboBox.au3>
#include <Constants.au3>
#include <DateTimeConstants.au3>
#include <file.au3>
#include <array.au3>
#include <INet.au3>
#include <Process.au3>
#include <ColorPicker.au3>
#include <WinAPI.au3>
#Include <Excel.au3>

;#RequireAdmin

Opt("GuiOnEventMode", 1)
Opt("GUICloseOnESC", 0)
Global $lettura_riga1,$lettura_riga2,$lettura_riga3,$lettura_riga4,$lettura_riga5,$lettura_riga6,$lettura_riga7,$lettura_riga8,$lettura_riga9,$lettura_riga10,$lettura_riga11,$lettura_riga12,$lettura_riga13,$lettura_riga14,$lettura_riga15,$lettura_riga16
Global $lettura_riga17,$lettura_riga18,$lettura_riga19,$lettura_riga20,$lettura_riga21,$lettura_riga22,$lettura_riga23,$lettura_riga24,$lettura_riga25
Global $c,$var,$open_folder,$Checkbox1,$lettura_riga1,$riga1,$List1AC
Global $dittaAC,$viaAC,$cittaAC,$provinciaAC,$mailAC,$cellAC,$pivaAC,$cdifiAC,$tellAC,$faxAC,$capAC,$ditta2AC,$via2AC,$citta2AC,$provincia2AC,$mail2AC,$cell2AC,$piva2AC
Global $cdfis2AC,$tell2AC,$fax2AC,$cap2AC,$ibanAC,$swiftAC,$bancaAC,$Checkbox2
Global $nome_op,$via_op,$citta_op,$provincia_op,$mail_op,$cell_op,$piva_op,$cdfi_op,$tell_op,$fax_op,$cap_op,$nome_leg,$via_leg,$citta_leg,$prov_leg,$mail_leg,$cell_leg
Global $piva_leg,$cdfi_leg,$tell_leg,$fax_leg,$cap_leg,$iban,$swift,$banca,$file_xls,$riga
Global $id,$item[99999]
Global $read_riga,$Address,$Subject,$Body,$Attach,$cella,$cella1,$semi_path

Global $__MonitorList[1][5]
Global $Configfile = @scriptdir & "\data\config.ini"
Global $MenuItem8,$Input1
Global $VersionBuild = "20120727" ;YEAR|MON|DAY
Global $Studioversion = "0.1 Alpha"
GLOBAL $ERSTELLUNGSTAG = "27.07.2012 (" & $VersionBuild & ")"
Global $Studiofenster
Global $closeaction = _Config_Read("closeaction", "close")
Global $AskExit = _Config_Read("askexit", "true")
Global $enablelogo = _Config_Read("enablelogo", "true")
Global $Languagefile = _Config_Read("language", "Italiano.lng")
Global $Runonmonitor ;= _Config_Read("runonmonitor", "1")

;Startup Logo
Global Const $AC_SRC_ALPHA = 1
_GDIPlus_Startup()
$pngX = @ScriptDir & "\Data\startup.png"
Global $hImagestartup = _GDIPlus_ImageLoadFromFile($pngX)
$width = _GDIPlus_ImageGetWidth($hImagestartup)
$height = _GDIPlus_ImageGetHeight($hImagestartup)
Global $Logo_PNG = GUICreate("", $width, $height, -1, -1, $WS_POPUP, bitor($WS_EX_LAYERED, $WS_EX_TOOLWINDOW))
SetBitmap($Logo_PNG, $hImagestartup, 0)
GUISetState()
WinSetOnTop($Logo_PNG, "", 1)
Global $controlGui_startup = GUICreate("", $width, $height, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD, $WS_EX_TOOLWINDOW), $Logo_PNG)
GUISetBkColor(0xFFFFFF) ; => hintergrund ebenfalls durchsichtig, damit die buttons direkt auf das Hintergrundbild gesetzt werden
_WinAPI_SetLayeredWindowAttributes($controlGui_startup, 0xFFFFFF)
;$startup_progress = GUICtrlCreateProgress(260, 290, 100, 10)
GUICtrlCreateLabel($Studioversion & @crlf & $VersionBuild, 240, 275, 295, 25, 2, -1)
GUICtrlSetFont(-1, 8.5, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x000000)
$startup_text = GUICtrlCreateLabel("", 100, 250, 430, 25, 1, -1)
GUICtrlSetFont(-1, 8.5, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x000000)
Global $controlGui_ueber_GUI = GUICreate("", $width, $height, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD, $WS_EX_TOOLWINDOW), $Logo_PNG)
GUISetBkColor(0xFFFFFF) ; => hintergrund ebenfalls durchsichtig, damit die buttons direkt auf das Hintergrundbild gesetzt werden
_WinAPI_SetLayeredWindowAttributes($controlGui_ueber_GUI, 0xFFFFFF)
$ueber_txt = GUICtrlCreateLabel("", 200, 220, 335, 70, 2, -1)
GUICtrlSetFont(-1, 8.5, 800, 0, "Arial")
;GUICtrlCreateIcon($smallIconsdll, 132, 520, 50, 16, 16)
#include <Studio_Addons.au3>
GUICtrlSetOnEvent(-1, "_hide_Info")
#include <Addons.au3>


_CenterOnMonitor($Logo_PNG, "", $Runonmonitor)

;Startup Ani
SetBitmap($Logo_PNG, $hImagestartup, 0)
if $enablelogo = "true" then
	$alpha = 0
	while 1
		$alpha = $alpha + 10
		if $alpha > 255 then
			$alpha = 255
			ExitLoop

		endif
		SetBitmap($Logo_PNG, $hImagestartup, $alpha)
	WEnd
	SetBitmap($Logo_PNG, $hImagestartup, 255)
	GUISetState(@SW_SHOW, $controlGui_startup)
	;guictrlsetdata($startup_progress, 10)
sleep(2000)
endif
_Fadeout_logo()

_anagraficaclienti()

Func _anagraficaclienti()
	 $var = IniRead(@ScriptDir &"\Config.ini", "GlobalConfig", "key1", "NotFound")

	if $var <> '' Then
		$k = 0 ;  questa variabile a zero serve per quando passo da anagrafica clienti a fatture di vendita e in listcorpofatt non scazza i prodotti
	GUIDelete("GEST")
	$Form1 = GUICreate("GEST -- Anagrafica Clienti", 1075, 675, 150, 4);, BitOR($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_SYSMENU, $WS_CAPTION, $WS_OVERLAPPEDWINDOW, $WS_TILEDWINDOW, $WS_POPUP, $WS_POPUPWINDOW, $WS_GROUP, $WS_TABSTOP, $WS_BORDER, $WS_CLIPSIBLINGS))
	$Group1 = GUICtrlCreateGroup("Anagrafica Cliente", 15, 11, 1057, 633)
	$Group2 = GUICtrlCreateGroup("Sede Operativa", 31, 51, 217, 505)

	$dittaAC = GUICtrlCreateInput("", 47, 91, 185, 21)

	$viaAC = GUICtrlCreateInput("", 47, 130, 185, 21)
	$cittaAC = GUICtrlCreateInput("", 47, 171, 185, 21)
	$provinciaAC = GUICtrlCreateInput("", 47, 213, 185, 21)
	$mailAC = GUICtrlCreateInput("", 47, 254, 185, 21)
	$cellAC = GUICtrlCreateInput("", 47, 296, 185, 21)
	$pivaAC = GUICtrlCreateInput("", 47, 341, 185, 21)
	$cdifiAC = GUICtrlCreateInput("", 47, 384, 185, 21)
	$tellAC = GUICtrlCreateInput("", 47, 427, 185, 21)
	$faxAC = GUICtrlCreateInput("", 47, 472, 185, 21)
	$capAC = GUICtrlCreateInput("", 47, 522, 65, 21)

	$Label1 = GUICtrlCreateLabel("Ragione Sociale", 47, 74, 82, 17)
	$Label2 = GUICtrlCreateLabel("Via", 47, 113, 19, 17)
	$Label3 = GUICtrlCreateLabel("Città", 47, 154, 25, 17)
	$Label4 = GUICtrlCreateLabel("Provincia", 47, 196, 48, 17)
	$Label5 = GUICtrlCreateLabel("Mail", 47, 235, 23, 17)
	$Label6 = GUICtrlCreateLabel("Cell", 47, 279, 21, 17)
	$Label7 = GUICtrlCreateLabel("P.Iva", 47, 323, 29, 17)
	$Label8 = GUICtrlCreateLabel("C.d.Fis", 47, 367, 36, 17)
	$Label9 = GUICtrlCreateLabel("Tell", 47, 410, 21, 17)
	$Label10 = GUICtrlCreateLabel("Fax", 47, 451, 21, 17)
	$Label11 = GUICtrlCreateLabel("Cap", 47, 499, 23, 17)

	$Group3 = GUICtrlCreateGroup("Sede Legale", 257, 51, 217, 505)

	$ditta2AC = GUICtrlCreateInput("", 273, 91, 185, 21)
	$via2AC = GUICtrlCreateInput("", 273, 130, 185, 21)
	$citta2AC = GUICtrlCreateInput("", 273, 171, 185, 21)
	$provincia2AC = GUICtrlCreateInput("", 273, 213, 185, 21)
	$mail2AC = GUICtrlCreateInput("", 273, 254, 185, 21)
	$cell2AC = GUICtrlCreateInput("", 273, 296, 185, 21)
	$piva2AC = GUICtrlCreateInput("", 273, 341, 185, 21)
	$cdfis2AC = GUICtrlCreateInput("", 273, 384, 185, 21)
	$tell2AC = GUICtrlCreateInput("", 273, 427, 185, 21)
	$fax2AC = GUICtrlCreateInput("", 273, 472, 185, 21)
	$cap2AC = GUICtrlCreateInput("", 273, 522, 65, 21)

	$Label12 = GUICtrlCreateLabel("Ragione Sociale", 273, 74, 82, 17)
	$Label13 = GUICtrlCreateLabel("Via", 273, 113, 19, 17)
	$Label14 = GUICtrlCreateLabel("Città", 273, 154, 25, 17)
	$Label15 = GUICtrlCreateLabel("Provincia", 273, 196, 48, 17)
	$Label16 = GUICtrlCreateLabel("Mail", 273, 235, 23, 17)
	$Label17 = GUICtrlCreateLabel("Cell", 273, 279, 21, 17)
	$Label18 = GUICtrlCreateLabel("P.Iva", 273, 323, 29, 17)
	$Label19 = GUICtrlCreateLabel("C.d.Fis", 273, 367, 36, 17)
	$Label20 = GUICtrlCreateLabel("Tell", 273, 410, 21, 17)
	$Label21 = GUICtrlCreateLabel("Fax", 273, 451, 21, 17)
	$Label22 = GUICtrlCreateLabel("Cap", 273, 499, 23, 17)

	$Checkbox1 = GUICtrlCreateCheckbox("Se Uguale", 257, 26, 97, 17)
	$Checkbox2 = GUICtrlCreateCheckbox("Apri cartella a fine inserimento", 722, 608, 161, 17, BitOR($BS_CHECKBOX,$BS_AUTOCHECKBOX,$BS_RIGHTBUTTON,$WS_TABSTOP))
	$Group4 = GUICtrlCreateGroup("Coordinate Bancarie", 31, 563, 443, 73)
	$Label23 = GUICtrlCreateLabel("Banca", 39, 585, 35, 17)
	$ibanAC = GUICtrlCreateInput("", 175, 603, 169, 21)
	$Label24 = GUICtrlCreateLabel("Iban", 175, 585, 25, 17)
	$swiftAC = GUICtrlCreateInput("", 359, 602, 105, 21)
	$Label25 = GUICtrlCreateLabel("Swift", 359, 585, 27, 17)
	$bancaAC = GUICtrlCreateInput("", 39, 603, 121, 21)

	$EscConfigAC = GUICtrlCreateButton("Esci", 989, 607, 75, 25, 0)
	$InConfigAC = GUICtrlCreateButton("Inserisci", 899, 607, 75, 25, 0)

	$Group5 = GUICtrlCreateGroup("Anagrafica ",491, 51, 569, 529)

	$List1AC = GUICtrlCreateListView("Nome o Ditta|Mail|Telefono|Cell|Indirizzo|Città|Fax|Cod.DB", 501, 76, 545, 409, $LVS_EX_GRIDLINES)
	_GUICtrlListView_SetExtendedListViewStyle($List1AC, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_SUBITEMIMAGES)) ; questa stringa fa la griglia stile excel
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 100) ; nome ditta
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 100) ; mail
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 80) ; telefono
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 80) ; cell
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 100) ; indirizzo
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 80) ; citta
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 80) ; fax
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 7, 30) ; cod.db
	$EliminaAC = GUICtrlCreateButton("Elimina", 872, 507, 75, 25, 0)
	$Button7AC = GUICtrlCreateButton("Visualizza", 971, 507, 75, 25, 0)
	$Button8AC = GUICtrlCreateButton("Cerca", 507, 507, 75, 21, 0)
	$Input6AC = GUICtrlCreateInput("", 595, 507, 169, 21)
	$Button1 = GUICtrlCreateButton("Mail", 507, 545, 75, 21, 0)
	$Button2 = GUICtrlCreateButton("Cartella", 597, 545, 75, 21, 0)

	$file_xls=_ExcelBookOpen(@ScriptDir & '\Data\Anagrafica_Clienti.xls',0)
$riga1=1
	do
	$riga1=$riga1+1
	$lettura_riga1=_ExcelReadCell($file_xls,$riga1,1)
	$lettura_riga2=_ExcelReadCell($file_xls,$riga1,2)
	$lettura_riga3=_ExcelReadCell($file_xls,$riga1,3)
	$lettura_riga4=_ExcelReadCell($file_xls,$riga1,4)
	$lettura_riga5=_ExcelReadCell($file_xls,$riga1,5)
	$lettura_riga6=_ExcelReadCell($file_xls,$riga1,6)
	$lettura_riga7=_ExcelReadCell($file_xls,$riga1,7)
	$lettura_riga8=_ExcelReadCell($file_xls,$riga1,8)
	$lettura_riga9=_ExcelReadCell($file_xls,$riga1,9)
	$lettura_riga10=_ExcelReadCell($file_xls,$riga1,10)
	$lettura_riga11=_ExcelReadCell($file_xls,$riga1,11)
	$lettura_riga12=_ExcelReadCell($file_xls,$riga1,12)
	$lettura_riga13=_ExcelReadCell($file_xls,$riga1,13)
	$lettura_riga14=_ExcelReadCell($file_xls,$riga1,14)
	$lettura_riga15=_ExcelReadCell($file_xls,$riga1,15)
	$lettura_riga16=_ExcelReadCell($file_xls,$riga1,16)
	$lettura_riga17=_ExcelReadCell($file_xls,$riga1,17)
	$lettura_riga18=_ExcelReadCell($file_xls,$riga1,18)
	$lettura_riga19=_ExcelReadCell($file_xls,$riga1,19)
	$lettura_riga20=_ExcelReadCell($file_xls,$riga1,20)
	$lettura_riga21=_ExcelReadCell($file_xls,$riga1,21)
	$lettura_riga22=_ExcelReadCell($file_xls,$riga1,22)
	$lettura_riga23=_ExcelReadCell($file_xls,$riga1,23)
	$lettura_riga24=_ExcelReadCell($file_xls,$riga1,24)
	$lettura_riga25=_ExcelReadCell($file_xls,$riga1,25)


$item[$id] = GUICtrlCreateListViewItem($lettura_riga1&"|"&$lettura_riga5&"|"&$lettura_riga9&"|"&$lettura_riga6&"|"&$lettura_riga2&"|"&$lettura_riga3&"|"&$lettura_riga10&"|"&$riga1, $List1AC)

Until $lettura_riga1 = ''
_ExcelBookClose($file_xls,1,0)
GUISetState(@SW_SHOW)

	_MenuFile()

GUISetState(@SW_SHOW)
	GUICtrlSetOnEvent($EscConfigAC, "_Close")
	GUICtrlSetOnEvent($InConfigAC, "_insert_anagrafica")
	GUICtrlSetOnEvent($Checkbox1, "_se_uguale")
	GUICtrlSetOnEvent($Button1, "_lancia_mail")
	GUICtrlSetOnEvent($Button2, "_open_folder")

Else
	$c=0
	_opzioni()
EndIf

EndFunc


Func _lancia_mail()

				$read_riga=GUICtrlRead($List1AC)

				if $read_riga = '' Then

					MsgBox(262144, "Errore!", "Devi Selezionare un Cliente")
				Else
					$cella=_GUICtrlListView_GetItemTextString($List1AC,-1)
					$cella1=StringSplit($cella,'|')

		$Address = $cella1[2];InputBox('Address', 'Enter the E-Mail address to send message to')
		$Subject = IniRead(@ScriptDir &"\Config.ini", "GlobalConfig", "key2", "NotFound");InputBox('Subject', 'Enter a subject for the E-Mail')
		$Body = IniRead(@ScriptDir &"\Config.ini", "GlobalConfig", "key3", "NotFound");InputBox('Body', 'Enter the body (message) of the E-Mail')
		$bcc = IniRead(@ScriptDir &"\Config.ini", "GlobalConfig", "key4", "NotFound");InputBox('Body', ' of the E-Mail')
		;$bcc = 'info@e-officecom.com';InputBox('Body', ' of the E-Mail')
		$Attach = ""
		_INetMail($Address, $bcc, $Subject, $Body, $Attach)

				EndIf
	EndFunc

Func  _open_folder()
	$read_riga=GUICtrlRead($List1AC)

				if $read_riga = '' Then

					MsgBox(262144, "Errore!", "Devi Selezionare un Cliente")
				Else
					$cella=_GUICtrlListView_GetItemTextString($List1AC,-1)
					$cella1=StringSplit($cella,'|')


		$semi_path = IniRead(@ScriptDir &"\Config.ini", "GlobalConfig", "key1", "NotFound");InputBox('Subject', 'Enter a subject for the E-Mail')
		ShellExecute($semi_path&'\'&$cella1[1])

				EndIf


	EndFunc


Func _se_uguale()
	If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
		GUICtrlSetData($ditta2AC, GUICtrlRead($dittaAC))
		GUICtrlSetData($via2AC, GUICtrlRead($viaAC))
		GUICtrlSetData($citta2AC, GUICtrlRead($cittaAC))
		GUICtrlSetData($provincia2AC, GUICtrlRead($provinciaAC))
		GUICtrlSetData($mail2AC, GUICtrlRead($mailAC))
		GUICtrlSetData($cell2AC, GUICtrlRead($cellAC))
		GUICtrlSetData($piva2AC, GUICtrlRead($pivaAC))
		GUICtrlSetData($cdfis2AC, GUICtrlRead($cdifiAC))
		GUICtrlSetData($tell2AC, GUICtrlRead($tellAC))
		GUICtrlSetData($fax2AC, GUICtrlRead($faxAC))
		GUICtrlSetData($cap2AC, GUICtrlRead($capAC))
	Else
		GUICtrlSetState($ditta2AC, $GUI_ENABLE)
		GUICtrlSetState($via2AC, $GUI_ENABLE)
		GUICtrlSetState($citta2AC, $GUI_ENABLE)
		GUICtrlSetState($provincia2AC, $GUI_ENABLE)
		GUICtrlSetState($mail2AC, $GUI_ENABLE)
		GUICtrlSetState($cell2AC, $GUI_ENABLE)
		GUICtrlSetState($piva2AC, $GUI_ENABLE)
		GUICtrlSetState($cdfis2AC, $GUI_ENABLE)
		GUICtrlSetState($tell2AC, $GUI_ENABLE)
		GUICtrlSetState($fax2AC, $GUI_ENABLE)
		GUICtrlSetState($cap2AC, $GUI_ENABLE)
	EndIf

EndFunc


Func _insert_anagrafica()

	$nome_op=GUICtrlRead($dittaAC)
	$via_op=GUICtrlRead($viaAC)
	$citta_op=GUICtrlRead($cittaAC)
	$provincia_op=GUICtrlRead($provinciaAC)
	$mail_op=GUICtrlRead($mailAC)
	$cell_op=GUICtrlRead($cellAC)
	$piva_op=GUICtrlRead($pivaAC)
	$cdfi_op=GUICtrlRead($cdifiAC)
	$tell_op=GUICtrlRead($tellAC)
	$fax_op=GUICtrlRead($faxAC)
	$cap_op=GUICtrlRead($capAC)
	$nome_leg=GUICtrlRead($ditta2AC)
	$via_leg=GUICtrlRead($via2AC)
	$citta_leg=GUICtrlRead($citta2AC)
	$prov_leg=GUICtrlRead($provincia2AC)
	$mail_leg=GUICtrlRead($mail2AC)
	$cell_leg=GUICtrlRead($cell2AC)
	$piva_leg=GUICtrlRead($piva2AC)
	$cdfi_leg=GUICtrlRead($cdfis2AC)
	$tell_leg=GUICtrlRead($tell2AC)
	$fax_leg=GUICtrlRead($fax2AC)
	$cap_leg=GUICtrlRead($cap2AC)
	$iban=GUICtrlRead($ibanAC)
	$swift=GUICtrlRead($swiftAC)
	$banca=GUICtrlRead($bancaAC)

	$open_folder=GUICtrlRead($Checkbox2)

;MsgBox(0,'',$nome_op)

$file_xls=_ExcelBookOpen(@ScriptDir & '\Data\Anagrafica_Clienti.xls',0)
If @error = 1 Then
    MsgBox(262144, "Errore!", "impossibile Creare un file Xls")
    Exit
ElseIf @error = 2 Then
    MsgBox(262144, "Errore!", "il File anagrafica_clienti.xls  non Esiste!, Devi crearne uno")
    Exit
EndIf

do
	$riga=$riga+1
$lettura_riga=_ExcelReadCell($file_xls,$riga,1)

Until $lettura_riga = ''

_ExcelWriteCell($file_xls,$nome_op,$riga,1)
_ExcelWriteCell($file_xls,$via_op,$riga,2)
_ExcelWriteCell($file_xls,$citta_op,$riga,3)
_ExcelWriteCell($file_xls,$provincia_op,$riga,4)
_ExcelWriteCell($file_xls,$mail_op,$riga,5)
_ExcelWriteCell($file_xls,$cell_op,$riga,6)
_ExcelWriteCell($file_xls,$piva_op,$riga,7)
_ExcelWriteCell($file_xls,$cdfi_op,$riga,8)
_ExcelWriteCell($file_xls,$tell_op,$riga,9)
_ExcelWriteCell($file_xls,$fax_op,$riga,10)
_ExcelWriteCell($file_xls,$cap_op,$riga,11)
_ExcelWriteCell($file_xls,$nome_leg,$riga,12)
_ExcelWriteCell($file_xls,$via_leg,$riga,13)
_ExcelWriteCell($file_xls,$citta_leg,$riga,14)
_ExcelWriteCell($file_xls,$prov_leg,$riga,15)
_ExcelWriteCell($file_xls,$mail_leg,$riga,16)
_ExcelWriteCell($file_xls,$cell_leg,$riga,17)
_ExcelWriteCell($file_xls,$piva_leg,$riga,18)
_ExcelWriteCell($file_xls,$cdfi_leg,$riga,19)
_ExcelWriteCell($file_xls,$tell_leg,$riga,20)
_ExcelWriteCell($file_xls,$fax_leg,$riga,21)
_ExcelWriteCell($file_xls,$cap_leg,$riga,22)
_ExcelWriteCell($file_xls,$iban,$riga,23)
_ExcelWriteCell($file_xls,$swift,$riga,24)
_ExcelWriteCell($file_xls,$banca,$riga,25)

$folder_source=IniRead(@ScriptDir & "\Config.ini", "GlobalConfig", "key1", "NotFound")

DirCreate($folder_source&'\'&$nome_op)
if $open_folder = 1 Then
ShellExecute($folder_source&'\'&$nome_op)
endif
_ExcelBookSave($file_xls)
_ExcelBookClose($file_xls,1,0)
_anagraficaclienti()
	EndFunc




Func _opzioni()

$Form3 = GUICreate("Gest -- Opzioni", 502, 177, 268, 119)
$Group1 = GUICtrlCreateGroup("Opzioni Generali", 8, 16, 489, 153)
$Input1 = GUICtrlCreateInput("", 24, 72, 449, 21)
$Label1 = GUICtrlCreateLabel("Percorso Cartelle Clienti", 24, 48, 115, 17)
$Button1 = GUICtrlCreateButton("Apri", 392, 104, 75, 25, 0)
$Button2 = GUICtrlCreateButton("Salva", 392, 136, 75, 25, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

GUIctrlSetOnEvent($MenuItem8, "_insert_path")
GUIctrlSetOnEvent($Button1, "_Apri_folder")
GUIctrlSetOnEvent($Button2, "_Salva_config")
GUISetOnEvent($GUI_EVENT_CLOSE, "_del_opzioni")
	EndFunc


Func _del_opzioni()
	guidelete('Gest -- Opzioni')
	EndFunc
Func _Salva_config()

if $c <> 0 Then
	Local $path=GUICtrlRead($Input1)
	IniWrite(@ScriptDir &"\Config.ini", "GlobalConfig", "key1", $path)
	GUIDelete('Gest -- Opzioni')
Else
	Local $path=GUICtrlRead($Input1)
	IniWrite(@ScriptDir &"\Config.ini", "GlobalConfig", "key1", $path)
	GUIDelete('Gest -- Opzioni')
	_anagraficaclienti()
EndIf

	EndFunc

Func _Apri_folder()
$cartella = FileSelectFolder("Scegli la Cartella.", "",1)
GUICtrlSetData($Input1, $cartella)

	EndFunc

Func _insert_path()




	EndFunc


Func _MenuFile()
	$MenuItem3 = GUICtrlCreateMenu("&File")
	$MenuItem9 = GUICtrlCreateMenuItem("Apri Archivio Anagrafica", $MenuItem3)
	$MenuItem6 = GUICtrlCreateMenuItem("Opzioni", $MenuItem3)
	$MenuItem7 = GUICtrlCreateMenuItem("", $MenuItem3)
	$MenuItem8 = GUICtrlCreateMenuItem("Esci", $MenuItem3)

	GUISetOnEvent($GUI_EVENT_CLOSE, "_Close")
	GUIctrlSetOnEvent($MenuItem8, "_Close")
	GUIctrlSetOnEvent($MenuItem6, "_opzioni")
	GUIctrlSetOnEvent($MenuItem9, "_AAA")
	EndFunc

Func _AAA()

	ShellExecute(@ScriptDir&'\data\Anagrafica_Clienti.xls')
	EndFunc

func _Get_langstr($str)
$get = iniread(@scriptdir&"\data\language\"&$Languagefile,"RECORDER","str"&$str,"#LANGUAGE_ERROR#ID#"&$str)
return $get
EndFunc


func _Config_Read($key, $errorkey)
	$i = iniread($Configfile, "config", $key, $errorkey)
	return $i
EndFunc
;============= chiusura programma
Func _close()
_ExcelBookClose($file_xls,1,0)
	Exit
EndFunc   ;==>_close

;===============================================================
;Keep the GUI alive
;===============================================================
While 1
	Sleep(1000)
WEnd