HotKeySet("{ESC}", "Terminate")


#include <Excel.au3>
#include <IE.au3>
Global $sExcelFile = "C:\Users\e8760255\Desktop\Pasta1.xls" ; <== Add the name of the Excel file here and your User
Global $oExcel = _ExcelBookOpen($sExcelFile)
Global $aExcelData = _ExcelReadSheetToArray($oExcel);$oExcel
$oIE = _IECreate()
_IENavigate($oIE, "                                         ");                                          

;=======================>FROM HERE
For $iRow = 1 To $aExcelData[0][0]
    $o_form = _IEFormGetObjByName($oIE, "form1")
    $o_txtCpf = _IEFormElementGetObjByName($o_form, "txtCpf")
    $o_txtNumDoc = _IEFormElementGetObjByName($o_form, "txtNumDoc")
    $O_btnConsultar = _IEFormElementGetObjByName($o_form, "btnConsultar")

    _IEFormElementSetValue($o_txtCpf, $aExcelData[$iRow][1])
    _IEFormElementSetValue($o_txtNumDoc, $aExcelData[$iRow][2])
    $O_btnConsultar.click
    _IELoadWait($oIE)

    $o_form = _IEFormGetObjByName($oIE, "_ctl0")
    $o_btnContinuar = _IEFormElementGetObjByName($o_form, "btnContinuar")
    If IsObj($o_btnContinuar) Then
        $o_btnContinuar.click
        _IELoadWait($oIE)
    EndIf

    If Not IsObj($o_btnContinuar) Then
        $o_form = _IEFormGetObjByName($oIE, "Form1")
        $o_btnGare = _IEFormElementGetObjByName($o_form, "btnGare")
        $o_btnGare.click
        _IELoadWait($oIE)
    EndIf

    $o_form = _IEFormGetObjByName($oIE, "Form1")
    $o_btnGare = _IEFormElementGetObjByName($o_form, "btnGare")
    $o_btnGare.click
    _IELoadWait($oIE)

    ; Doc informations
    $o_form = _IEFormGetObjByName($oIE, "Form1")
    $o_txtObs = _IEFormElementGetObjByName($o_form, "txtObs")
    $o_txtDataPagto = _IEFormElementGetObjByName($o_form, "txtDataPagto")
    $o_txtReceita = _IEFormElementGetObjByName($o_form, "txtReceita")

    _IEFormElementSetValue($o_txtObs, $aExcelData[$iRow][3])
    _IEFormElementSetValue($o_txtDataPagto, $aExcelData[$iRow][4])
    _IEFormElementSetValue($o_txtReceita, $aExcelData[$iRow][5])
    $o_form = _IEFormGetObjByName($oIE, "Form1")
    $o_btnCalculoProd = _IEFormElementGetObjByName($o_form, "btnCalculoProd")
    $o_btnCalculoProd.click
    _IELoadWait($oIE)

    $o_form = _IEFormGetObjByName($oIE, "Form1")
    $o_btnGera = _IEFormElementGetObjByName($o_form, "btnGera")
    $o_btnGera.click
    _IELoadWait($oIE)

    Sleep(6000)
    Send("{CTRLDOWN}")
    Send("{SHIFTDOWN}")
    Send("s")
    Send("{CTRLUP}")
    Send("{SHIFTUP}")
    Sleep(3000)
    Send("{ALTDOWN}")
    Send("s")
    Send("{ALTUP}")
    Sleep(1500)
    Send("!{F4}")
    Sleep(1500)

    $o_form = _IEFormGetObjByName($oIE, "_ctl0");Form1
    $o_btnSair = _IEFormElementGetObjByName($o_form, "btnSair")
    $o_btnSair.click

Next

Func Terminate()
    Exit 0
EndFunc   ;==>Terminate