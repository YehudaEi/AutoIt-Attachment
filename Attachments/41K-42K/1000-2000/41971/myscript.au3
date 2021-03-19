#include <GuiConstantsEx.au3>
#include <EditConstants.au3>
#include <IE.au3>
#include <Misc.au3>
#include <Process.au3>



$oIE = _IECreate("http://sca2k8wmwp3/wmweb/main.asp", 1)
_IELoadWait($oIE, 1000)
$HWND = _IEPropertyGet($oIE, "hwnd")
WinSetState($HWND, "", @SW_MAXIMIZE)

_IELoadWait($oIE, 1000)


$EnterSKU = InputBox("Enter a SKU", "Enter a SKU. This will split the SKU from all existing printed cartons", "")


Local $fraBottom = _IEFrameGetObjByName($oIE, "fraBottom")
Local $fraRight = _IEFrameGetObjByName($fraBottom, "fraRight")
Local $fraNavigator = _IEFrameGetObjByName($fraBottom, "fraNavigator")
Local $fraData = _IEFrameGetObjByName($fraRight, "fraData")
Local $fraCriteria = _IEFrameGetObjByName($fraRight, "fraCriteria")


Local $TextInput = _IEGetObjById($fraNavigator, "txtMenuInpt")

_IEAction($TextInput, "focus")
Sleep(1000)
_IEFormElementSetValue($TextInput, "Carton Maintenance")
Sleep(500)
Send("{DOWN}")
Sleep(500)
Send("{DOWN}")
Sleep(500)
Send("{ENTER}")

_IELoadWait($oIE)
Sleep(1000)
_IELoadWait($oIE)
Sleep(8000)

Call("Criteria")

Func Criteria()

	Local $oForm = _IEFormGetObjByName($fraCriteria, "CRITERIA_FORM")
	Local $oWarehouse = _IEFormElementGetObjByName($oForm, "MANH_CO_DIV")
	_IEFormElementOptionSelect($oWarehouse, "2007", 1, "byValue")


	Local $oFromStatCode = _IEFormElementGetObjByName($oForm, "CR_FROM_STAT_CODE")
	_IEFormElementOptionSelect($oFromStatCode, "10", 1, "byValue")

	Local $oToStatCode = _IEFormElementGetObjByName($oForm, "CR_TO_STAT_CODE")
	_IEFormElementOptionSelect($oToStatCode, "10", 1, "byValue")


	Local $SKU = _IEFormElementGetObjByName($oForm, "SKU_ID_STYLE")
	_IEAction($SKU, "focus")
	Send($EnterSKU)
	Sleep(500)
    Send("{ENTER}")

EndFunc   ;==>Criteria




