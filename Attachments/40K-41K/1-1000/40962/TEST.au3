
#include <Excel.au3>
#include <IE.au3>
Global $sExcelFile = "C:\Users\Your User\Desktop\Pasta1.xls" ; <== Add the name of the Excel file here and your User
Global $oExcel = _ExcelBookOpen($sExcelFile)
Global $aExcelData = _ExcelReadSheetToArray($oExcel);$oExcel

$oIE = _IECreate()
_IENavigate($oIE, "WWW.FAZENDA.SP.GOV.BR/SIMP");                                          
$o_form = _IEFormGetObjByName($oIE,"form1")
$o_txtCpf = _IEFormElementGetObjByName($o_form, "txtCpf")
$o_txtNumDoc = _IEFormElementGetObjByName($o_form, "txtNumDoc")
$O_btnConsultar = _IEFormElementGetObjByName($o_form, "btnConsultar")


For $iRow = 1 To $aExcelData ; Process all read Excel rows
   _IEFormElementSetValue($o_txtcpf, $aExcelData[$iRow][1])
   _IEFormElementSetValue($o_txtNumDoc,$aExcelData[$iRow][2])
Next
$o_btnConsultar.click
_IELoadWait($oIE)

;I can have this move or not sometimes (IN MY EXAMPLE ILL NOT HAVE THIS STEP)
$o_form = _IEFormGetObjByName($oIE,"_ctl0")
$O_btnContinuar = _IEFormElementGetObjByName($o_form, "btnContinuar")
$O_btnContinuar.click
_IELoadWait($oIE)

; I'll always have this step
$o_form = _IEFormGetObjByName($oIE,"Form1")
$O_btnGare = _IEFormElementGetObjByName($o_form, "btnGare")
$O_btnGare.click
_IELoadWait($oIE)

; Doc informations
$o_form = _IEFormGetObjByName($oIE,"Form1")
$o_txtObs = _IEFormElementGetObjByName($o_form, "txtObs")
$o_txtDataPagto = _IEFormElementGetObjByName($o_form, "txtDataPagto")
$o_txtReceita = _IEFormElementGetObjByName($o_form, "txtReceita")

For $iRow = 1 To $aExcelData ; Process all read Excel rows
   _IEFormElementSetValue($o_txtObs, $aExcelData[$iRow][3])
   _IEFormElementSetValue($o_txtDataPagto,$aExcelData[$iRow][4])
   _IEFormElementSetValue($o_txtReceita,$aExcelData[$iRow][5])
Next
