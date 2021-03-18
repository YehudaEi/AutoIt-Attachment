;Dim $sKey = 'HKCU\Software\Microsoft\Internet Explorer\New Windows'
;RegWrite($sKEy, 'PopupMgr', 'REG_SZ', 'yes') ; Turn on
HotKeySet("{ESC}", "Terminate")

#include <WindowsConstants.au3>
#include <Excel.au3>
#include <IE.au3>



Local $sFilePath1 = @DesktopDir & "\icms_importacao.xls"
;Global $sExcelFile = @DesktopDir & "\Pasta2.xls" ; <== Add the name of the Excel file here and your User
Local $oExcel = _ExcelBookOpen($sFilePath1)
Local $aExcelData = _ExcelReadSheetToArray($oExcel);$oExcel
$oIE = _IECreate()
_IENavigate($oIE, "                                  ");                                          

;=======================>FROM HERE
For $iRow = 1 To $aExcelData[0][0]
    $o_form = _IEFormGetObjByName($oIE, "form1")
    $o_txtCpf = _IEFormElementGetObjByName($o_form, "txtCpf")
    $o_txtNumDoc = _IEFormElementGetObjByName($o_form, "txtNumDoc")
    $O_btnConsultar = _IEFormElementGetObjByName($o_form, "btnConsultar")

    _IEFormElementSetValue($o_txtCpf, $aExcelData[$iRow][1])
    _IEFormElementSetValue($o_txtNumDoc, $aExcelData[$iRow][2])
    $o_btnConsultar.click
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

	WinWaitActive("                                        ", "")
	WinKill("                                        ", "")

    $o_form = _IEFormGetObjByName($oIE, "Form1");_ctl0
	$o_gareLink = _IEFormElementGetObjByName($o_form, "gareLink")
    $o_btnSair = _IEFormElementGetObjByName($o_form, "btnSair")
	;_IELinkClickByText($oIE, "aqui")




   ;Sleep(6000)
   ;Send("{CTRLDOWN}")
   ;Send("{SHIFTDOWN}")
   ;Send("S")
   ;Send("{CTRLUP}")
   ;Send("{SHIFTUP}")
   ;WinWaitActive("Save As")
   ;Sleep(1500)
   ;Send("{ALTDOWN}")
   ;Send("S")
   ;Send("{ALTUP}")
   ;Sleep(1500)

	_IENavigate($oIE, "                                  ")
	_IELoadWait($oIE)

Next

;RegWrite($sKey, 'PopupMgr', 'REG_SZ', 'no') ; Turn off

Func Terminate()
    Exit 0
EndFunc   ;==>Terminate