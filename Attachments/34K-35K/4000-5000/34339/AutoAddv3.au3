;INCLUDES
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Math.au3>
#Include <WinAPI.au3>
#include <Constants.au3>
#include <Array.au3>
#include <IE.au3>

;REPORTS and SERVERS ini and declarations





;INIT
Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode
Opt("TrayIconDebug", 1)     ;0=no info, 1=debug line info

;VARIABLES
Dim $LastRow, $CurRow ;Last used row
Dim $i, $j, $k ;Counters
Dim $SqFt ;unit converter var
Dim $StartTime = TimerInit()
Dim $dif, $begin ;timer
Dim $nMsg
Dim $DescComb = ""
Dim $RentValue
Dim $AuthCode

;and CONSTANTS
Dim Const $autosave =1500000 ; autosave interval (5 minutes) in miliseconds (1000 =1 second)
Dim $Acres = "43560"
Dim $Sqm = "10.7639104"
Dim $RefSingle = "0"
Dim $RefDouble = "00"
;Dim $AuthPC = "BFEBFBFF00000F65"
Dim $AuthPC = "BFEBFBFF00000F65"
Dim $AuthPCLiviu = "BFE9FBFF000006EC"

#Region ### START Koda GUI section ### Form=c:\documents and settings\m\desktop\autoit test\main.kxf
$Autoaddmain = GUICreate("AutoAdd V3 - Dan", 252, 800, 448, 115)
GUISetOnEvent($GUI_EVENT_CLOSE, "AutoaddmainClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "AutoaddmainMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "AutoaddmainMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "AutoaddmainRestore")
$SaveKeep = GUICtrlCreateButton("Save+Keep", 8, 8, 115, 33, $WS_GROUP)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "SaveKeepClick")
$SaveClear = GUICtrlCreateButton("Save+Clear", 128, 8, 115, 33, $WS_GROUP)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "SaveClearClick")
;$overwriteLast = GUICtrlCreateButton("Replace Last", 128, 8, 115, 33, $WS_GROUP)
;GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
;GUICtrlSetOnEvent(-1, "SaveOverLast")
$address = GUICtrlCreateInput("Address", 8, 48, 161, 21)
$AddressLBL = GUICtrlCreateLabel("Address", 176, 48, 62, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "AddressLBLClick")
$postcode = GUICtrlCreateInput("PostCode", 8, 72, 161, 21)
$PostCodeLBL = GUICtrlCreateLabel("PostCode", 176, 72, 72, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "PostCodeLBLClick")
$category = GUICtrlCreateInput("Category", 8, 96, 105, 21)
$CatLBL = GUICtrlCreateLabel("Category", 176, 96, 67, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "CatLBLClick")
$KeepCat = GUICtrlCreateCheckbox("Keep", 120, 96, 57, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$size = GUICtrlCreateInput("Size", 8, 120, 57, 21)
$SizeLBL = GUICtrlCreateLabel("Size", 176, 120, 34, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "SizeLBLClick")
$ConvSQM = GUICtrlCreateCheckbox("Sq m", 72, 120, 49, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "ConvSQMClick")
$ConvAcr = GUICtrlCreateCheckbox("Acres", 120, 120, 57, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "ConvAcrClick")

$rentpr = GUICtrlCreateInput("Rental Price", 8, 144, 80, 21)
$RentalLBL = GUICtrlCreateLabel("Rent", 176, 144, 36, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "RentalLBLClick")
$ForRent = GUICtrlCreateCheckbox("No £", 120, 145, 40, 17)
GUICtrlSetOnEvent(-1, "ForRentClick")
$Rent12 = GUICtrlCreateCheckbox("x12", 8, 166, 40, 17)
GUICtrlSetOnEvent(-1, "Rent12Click")
$Rent52 = GUICtrlCreateCheckbox("x52", 60, 166, 40, 17)
GUICtrlSetOnEvent(-1, "Rent52Click")
$RentIsSQFT = GUICtrlCreateCheckbox("XSize", 120, 166, 60, 17)
GUICtrlSetOnEvent(-1, "RentxSize")
$RentSQFT = GUICtrlCreateCheckbox("£/Sqm", 176, 166, 60, 17)
GUICtrlSetOnEvent(-1, "RentSQFTClick")

$salepr = GUICtrlCreateInput("Sale Price", 8, 185, 136, 21)
$SaleLBL = GUICtrlCreateLabel("Sale Pr.", 176, 185, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "SaleLBLClick")
$ForSale = GUICtrlCreateCheckbox("", 150, 187, 17, 17)
GUICtrlSetOnEvent(-1, "ForSaleClick")
$heading = GUICtrlCreateInput("Heading", 8, 209, 161, 21)
$HeadLBL = GUICtrlCreateLabel("Heading", 176, 209, 63, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "HeadLBLClick")
;$desc = GUICtrlCreateInput("Desc", 8, 216, 161, 21)
$desc = GUICtrlCreateEdit("Desc", 8, 233, 161, 80)
$DescLBL = GUICtrlCreateLabel("Desc", 176, 233, 40, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "DescLBLClick")

$img1 = GUICtrlCreateInput("Image 1", 8, 316, 161, 21)
$Img1LBL = GUICtrlCreateLabel("Image 1", 176, 316, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Img1LBLClick")
$img2 = GUICtrlCreateInput("Image 2", 8, 340, 161, 21)
$Img2LBL = GUICtrlCreateLabel("Image 2", 176, 340, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Img2LBLClick")
$img3 = GUICtrlCreateInput("Image 3", 8, 364, 161, 21)
$Img3LBL = GUICtrlCreateLabel("Image 3", 176, 364, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Img3LBLClick")
$img4 = GUICtrlCreateInput("Image 4", 8, 388, 161, 21)
$Img4LBL = GUICtrlCreateLabel("Image 4", 176, 388, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Img4LBLClick")
$img5 = GUICtrlCreateInput("Image 5", 8, 412, 161, 21)
$Img5LBL = GUICtrlCreateLabel("Image 5", 176, 412, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Img5LBLClick")
$UnderOffer = GUICtrlCreateInput("Under Offer", 8, 437, 141, 21)
$UnderOfferLBL = GUICtrlCreateLabel("Under Of", 176, 437, 65, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "UnderOfferLBLClick")
$UnderOffDef = GUICtrlCreateCheckbox("", 155, 437, 17, 17)
GUICtrlSetOnEvent(-1, "UnderOffDefClick")

$ClearAllData = GUICtrlCreateButton("CLEAR DATA FROM FIELDS", 8, 466, 227, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "ClearAfterSave")
$StartRow = GUICtrlCreateInput("Start Record", 8, 493, 73, 21)
$Label1 = GUICtrlCreateLabel("Starting Row for data", 88, 493, 148, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Label1Click")

$ASexcel = GUICtrlCreateCheckbox("Auto-Save after every record", 40, 517, 161, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Autopaste = GUICtrlCreateCheckbox("Auto-paste on click", 40, 533, 129, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$AutoFilldefault = GUICtrlCreateCheckbox("Auto-fill with default values ?", 40, 549, 161, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Excelhasheader = GUICtrlCreateCheckbox("Excel has first row with header ?", 40, 565, 185, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

$ReFABC = GUICtrlCreateInput("ABC", 8, 584, 73, 21)
$ReF123 = GUICtrlCreateInput("123", 85, 584, 73, 21)
$RefLabel = GUICtrlCreateLabel("Ref Code", 161, 584, 73, 21)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "RefLabelClick")

$Closeapp = GUICtrlCreateButton("EXIT", 8, 609, 229, 25, $WS_GROUP)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetOnEvent(-1, "CloseappClick")

$Label15 = GUICtrlCreateLabel("App by Dan Cornel ©2011", 48, 639, 142, 17)
GUICtrlSetOnEvent(-1, "Label15Click")
$Label16 = GUICtrlCreateLabel("Contact at dan_cornel_harju@yahoo.com", 16, 656, 201, 17)
GUICtrlSetOnEvent(-1, "Label16Click")
$Label16 = GUICtrlCreateLabel("TIP: CTRL+HOME or CTRL+END", 30, 673, 201, 17)
GUICtrlSetOnEvent(-1, "Label16Click")
$LBLHIDDEN = GUICtrlCreateLabel("HIDDEN", 8, 700, 200, 10)
GUISetState(@SW_SHOW)

;TEST CONTROLS

#EndRegion ### END Koda GUI section ###


;ON LOAD STUFF
WinSetOnTop($Autoaddmain, "", 1)
WinMove($Autoaddmain,"", @DesktopWidth-252,0)

$AuthCode = Label16Click()
If $AuthCode <> $AuthPC And $AuthCode <> $AuthPCLiviu Then
	Msgbox (0,"FATAL ERROR", "Runtime files not found. Error code:" & $AuthCode)
    Exit
EndIf

GUICtrlSetData($StartRow,"2")
GUICtrlSetState($StartRow,$Gui_Show)
$LastRow =1
$CurRow =2
$k =0
;=AUTO FIND AND ATTACH TO EXCEL - WORKING=
$oExcel = ObjGet("","Excel.Application")
if @error then
 Msgbox (0,"ExcelFileTest","You don't have Excel running at this moment. Error code: " & hex(@error,8))
  exit
endif
if IsObj($oExcel) then Msgbox (0,"","You successfully attached to the existing Excel Application.")
;$iLastRow = $oExcel.ActiveSheet.Range("B65535").End($xlUp).Row ; last row column 'B' ; Get last used row
;=END AUTO FIND AND ATTACH TO EXCEL - WORKING=



;END ON LOAD STUFF



;KEPP ALIVE
While 1
$dif = TimerDiff($StartTime)
If TimerDiff($StartTime) > $autosave Then autosavefile()
$begin = TimerInit()
	Sleep(100); Idle around
WEnd
;END KEEP ALIVE


;BUTTONS EVENTS
Func SaveClearClick()
WriteToFile()
If GUICtrlRead($ASexcel) =1 then SaveExcel()
ClearAfterSave()
GUICtrlSetData($rentpr,"")
GUICtrlSetState($rentpr,$Gui_Show)
GUICtrlSetData($salepr,"")
GUICtrlSetState($salepr,$Gui_Show)
GUICtrlSetData($StartRow,GUICtrlRead($StartRow)+1)
GUICtrlSetState($StartRow,$Gui_Show)
RefLabelClick()
EndFunc

Func SaveKeepClick()
WriteToFile()
If GUICtrlRead($ASexcel) =1 then SaveExcel()
GUICtrlSetData($rentpr,"")
GUICtrlSetState($rentpr,$Gui_Show)
GUICtrlSetData($salepr,"")
GUICtrlSetState($salepr,$Gui_Show)
GUICtrlSetData($StartRow,GUICtrlRead($StartRow)+1)
GUICtrlSetState($StartRow,$Gui_Show)
RefLabelClick()
EndFunc

;Func SaveOverLast()
;EndFunc

Func AutoaddmainClose()
CLOSEClicked()
EndFunc

Func CloseappClick()
CLOSEClicked()
EndFunc


Func AutoaddmainMaximize()

EndFunc
Func AutoaddmainMinimize()

EndFunc
Func AutoaddmainRestore()

EndFunc

Func Label15Click()
MsgBox(0,"COMPUTER ID",Label16Click())
EndFunc
Func Label16Click()

$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2")
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL",0x10+0x20)
If IsObj($colItems) Then
    For $objItem In $colItems
    Local $PROC_ID = $objItem.ProcessorId
    Next
    Return $PROC_ID
Else
    Return 0
EndIf


EndFunc


;AFTER INPUT UPDATE EVENTS

Func StartRowChange()
$CurRow = GUICtrlRead($StartRow)

EndFunc


;LABELS EVENTS
Func RefLabelClick()

Select
	Case GUICtrlRead($Excelhasheader) = 1
		If $CurRow <10 OR  $CurRow =10 then
							GUICtrlSetData($ReF123,$RefDouble & GUICtrlRead($StartRow)-1)
							GUICtrlSetState($ReF123,$Gui_Show)
						ElseIf $CurRow <100 OR $CurRow =100 then
												GUICtrlSetData($ReF123,$RefSingle & GUICtrlRead($StartRow)-1)
												GUICtrlSetState($ReF123,$Gui_Show)
											Else
												GUICtrlSetData($ReF123,GUICtrlRead($StartRow)-1)
												GUICtrlSetState($ReF123,$Gui_Show)
		EndIf
	Case GUICtrlRead($Excelhasheader) = 4
		If $CurRow <10 OR  $CurRow =10 then
							GUICtrlSetData($ReF123,$RefDouble & GUICtrlRead($StartRow))
							GUICtrlSetState($ReF123,$Gui_Show)
						ElseIf $CurRow <100 OR $CurRow =100 then
												GUICtrlSetData($ReF123,$RefSingle & GUICtrlRead($StartRow))
												GUICtrlSetState($ReF123,$Gui_Show)
											Else
												GUICtrlSetData($ReF123,GUICtrlRead($StartRow))
												GUICtrlSetState($ReF123,$Gui_Show)
		EndIf
EndSelect
EndFunc

Func UnderOfferLBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($UnderOffer,ClipGet())
GUICtrlSetState($UnderOffer,$Gui_Show)
EndIf
EndFunc


Func Label1Click()
$CurRow = GUICtrlRead($StartRow)
RefLabelClick()


EndFunc

Func AddressLBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($LBLHIDDEN,ClipGet())
GUICtrlSetState($LBLHIDDEN,$Gui_Show)
GUICtrlSetData($address,GUICtrlRead($LBLHIDDEN))
GUICtrlSetState($address,$Gui_Show)
EndIf
EndFunc

Func PostCodeLBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($postcode,ClipGet())
GUICtrlSetState($postcode,$Gui_Show)
EndIf
EndFunc

Func CatLBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($category,ClipGet())
GUICtrlSetState($category,$Gui_Show)
EndIf
EndFunc

Func SizeLBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($size,ClipGet())
$SqFt =ClipGet()
GUICtrlSetState($size,$Gui_Show)
EndIf
EndFunc

Func RentalLBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($rentpr,ClipGet())
GUICtrlSetState($rentpr,$Gui_Show)
EndIf
EndFunc

Func SaleLBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($salepr,ClipGet())
GUICtrlSetState($salepr,$Gui_Show)
EndIf
EndFunc

Func HeadLBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($heading,ClipGet())
GUICtrlSetState($heading,$Gui_Show)
EndIf
EndFunc

Func DescLBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
$i=GUICtrlRead($desc)&ClipGet()
GUICtrlSetData($desc,$i)
GUICtrlSetState($desc,$Gui_Show)
EndIf
;	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
;GUICtrlSetData($desc,ClipGet())
;GUICtrlSetState($desc,$Gui_Show)
;EndIf
EndFunc

Func Img1LBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($img1,ClipGet())
GUICtrlSetState($img1,$Gui_Show)
EndIf
EndFunc

Func Img2LBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($img2,ClipGet())
GUICtrlSetState($img2,$Gui_Show)
EndIf
EndFunc

Func Img3LBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($img3,ClipGet())
GUICtrlSetState($img3,$Gui_Show)
EndIf
EndFunc

Func Img4LBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($img4,ClipGet())
GUICtrlSetState($img4,$Gui_Show)
EndIf
EndFunc

Func Img5LBLClick()
	If GUICtrlRead($Autopaste) = $GUI_CHECKED =1 then
GUICtrlSetData($img5,ClipGet())
GUICtrlSetState($img5,$Gui_Show)
EndIf
EndFunc

;CHECKBOXES Events
Func RentSQFTClick()
Select
	Case $k = 1
		$RentValue = Floor(GUICtrlRead($rentpr)/$sqm)
		GUICtrlSetData($rentpr,$RentValue)
		GUICtrlSetState($rentpr,$Gui_Show)
		GUICtrlSetState($RentSQFT, 4)
		$k=0
	Case $k = 0
		GUICtrlSetState($RentSQFT, 4)
		MsgBox(0, "", "No conversions were made when you entered size")
	EndSelect
EndFunc



Func Rent12Click()
$RentValue = Floor(GUICtrlRead($rentpr) * 12)
GUICtrlSetData($rentpr,$RentValue)
GUICtrlSetState($rentpr,$Gui_Show)
GUICtrlSetState($Rent12, 4)
EndFunc

Func Rent52Click()
$RentValue = Floor(GUICtrlRead($rentpr) * 52)
GUICtrlSetData($rentpr,$RentValue)
GUICtrlSetState($rentpr,$Gui_Show)
GUICtrlSetState($Rent52, 4)
EndFunc

Func RentxSize()
$RentValue = Floor(GUICtrlRead($rentpr) * GUICtrlRead($size))
GUICtrlSetData($rentpr,$RentValue)
GUICtrlSetState($rentpr,$Gui_Show)
GUICtrlSetState($RentIsSQFT, 4)
EndFunc

Func UnderOffDefClick()
GUICtrlSetData($UnderOffer,"1")
GUICtrlSetState($UnderOffer,$Gui_Show)
GUICtrlSetState($UnderOffDef, 4)
EndFunc

Func NoSizeClick()
GUICtrlSetData($size,"1")
GUICtrlSetState($size,$Gui_Show)
EndFunc

Func ForSaleClick()
GUICtrlSetData($salepr,"1")
GUICtrlSetState($salepr,$Gui_Show)
GUICtrlSetState($ForSale, 4)
EndFunc

Func ForRentClick()
GUICtrlSetData($rentpr,"1")
GUICtrlSetState($rentpr,$Gui_Show)
GUICtrlSetState($ForRent, 4)
EndFunc



Func ConvAcrClick()
	$k = 1
$SqFt = Floor(GUICtrlRead($size) * $Acres)
GUICtrlSetData($size,$SqFt)
GUICtrlSetState($size,$Gui_Show)
GUICtrlSetState($ConvAcr, 4)
EndFunc

Func ConvSQMClick()
	$k = 1
$SqFt = Floor(GUICtrlRead($size) * $Sqm)
GUICtrlSetData($size,$SqFt)
GUICtrlSetState($size,$Gui_Show)
GUICtrlSetState($ConvSQM, 4)
EndFunc

Func ExcelhasheaderClick()
Select
	Case 	GUICtrlRead($Excelhasheader) =1
			GUICtrlSetData($StartRow,2)
			$CurRow =2
			GUICtrlSetState($StartRow,$Gui_Show)
	Case 	GUICtrlRead($Excelhasheader) =4
			GUICtrlSetData($StartRow,1)
			$CurRow =1
			GUICtrlSetState($StartRow,$Gui_Show)
EndSelect
EndFunc






;MODULES AND FUNCTIONS CALLED BY CLICKS FROM ABOVE FUNTIONS

Func CLOSEClicked()

  MsgBox(0, "GUI Event", "You clicked CLOSE! Exiting...")
  Exit
EndFunc

Func autosavefile()
_ExcelBookSave($oExcel)
EndFunc


Func SaveExcel()
;SAVE EXCEL FILE
_ExcelBookSave($oExcel) ;Save File With No Alerts
If @error Then MsgBox(0, "ERROR", "File Was NOT Saved!", 3)
$LastRow=$CurRow
$CurRow=$CurRow+1

EndFunc

Func WriteToFile()
;WRITE TO EXCEL

_ExcelWriteCell($oExcel, GUICtrlRead($address), $CurRow, 2)
_ExcelWriteCell($oExcel, GUICtrlRead($postcode), $CurRow, 3)
_ExcelWriteCell($oExcel, GUICtrlRead($category), $CurRow, 4)
_ExcelWriteCell($oExcel, GUICtrlRead($size), $CurRow, 5)
_ExcelWriteCell($oExcel, GUICtrlRead($rentpr), $CurRow, 6)
_ExcelWriteCell($oExcel, GUICtrlRead($salepr), $CurRow, 7)
_ExcelWriteCell($oExcel, GUICtrlRead($heading), $CurRow, 8)
_ExcelWriteCell($oExcel, GUICtrlRead($desc), $CurRow, 9)
_ExcelWriteCell($oExcel, GUICtrlRead($img1), $CurRow, 10)
_ExcelWriteCell($oExcel, GUICtrlRead($img2), $CurRow, 11)
_ExcelWriteCell($oExcel, GUICtrlRead($img3), $CurRow, 12)
_ExcelWriteCell($oExcel, GUICtrlRead($img4), $CurRow, 13)
_ExcelWriteCell($oExcel, GUICtrlRead($img5), $CurRow, 14)
_ExcelWriteCell($oExcel, GUICtrlRead($UnderOffer), $CurRow, 15)
_ExcelWriteCell($oExcel, GUICtrlRead($ReFABC)&GUICtrlRead($ReF123), $CurRow, 1)
MsgBox(0, "DONE", "DATA SENT TO EXCEL!", 1)
;If GUICtrlRead($ASexcel) =1 then SaveExcel()

EndFunc

Func WriteToFileBeta()

Endfunc





Func ClearAfterSave()
	GUICtrlSetData($address,"")
	GUICtrlSetState($address,$Gui_Show)
	GUICtrlSetData($postcode,"")
	GUICtrlSetState($postcode,$Gui_Show)
if	GUICtrlRead($KeepCat) <>1 Then
	GUICtrlSetData($category,"")
	GUICtrlSetState($category,$Gui_Show)
EndIf
	GUICtrlSetData($size,"")
	GUICtrlSetState($size,$Gui_Show)
	GUICtrlSetData($rentpr,"")
	GUICtrlSetState($rentpr,$Gui_Show)
	GUICtrlSetData($salepr,"")
	GUICtrlSetState($salepr,$Gui_Show)
	GUICtrlSetData($heading,"")
	GUICtrlSetState($heading,$Gui_Show)
	GUICtrlSetData($desc,"")
	GUICtrlSetState($desc,$Gui_Show)
	GUICtrlSetData($img1,"")
	GUICtrlSetState($img1,$Gui_Show)
	GUICtrlSetData($img2,"")
	GUICtrlSetState($img2,$Gui_Show)
	GUICtrlSetData($img3,"")
	GUICtrlSetState($img3,$Gui_Show)
	GUICtrlSetData($img4,"")
	GUICtrlSetState($img4,$Gui_Show)
	GUICtrlSetData($img5,"")
	GUICtrlSetState($img5,$Gui_Show)
	GUICtrlSetData($UnderOffer,"")
	GUICtrlSetState($UnderOffer,$Gui_Show)
	GUICtrlSetState($ReF123,$Gui_Show)
	$k=0

EndFunc

Func CallHome()
;check internet conn and status of the web servers to submit data



EndFunc


Func SubmitReports()


EndFunc
