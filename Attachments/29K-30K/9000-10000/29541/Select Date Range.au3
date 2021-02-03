#include <IE.au3>

Const $adOpenStatic = 3
Const $adLockOptimistic = 3
Const $adCmdText = 0x0001
Local $hGUI, $tCur, $tNew, $tCurTime


$oIE = _IEAttach ("StorQM PLUS 3.0")

$accNo = "5400-3415-0025-8242"
$statDate = "17/9/1996"

	_IELinkClickByText ($oIE, "Reset Query")
	_IELoadWait ($oIE)
	
	$o_form = _IEFormGetObjByName ($oIE, "formQuery")


	$o_acctNum = _IEFormElementGetObjByName ($o_form, "valueText")
	_IEFormElementSetValue ($o_acctNum, $accNo)

	$o_type = _IEFormElementGetObjByName ($o_form, "columnNames")
	_IEFormElementSetValue ($o_type, "Credit Card Number")


;Begin Date
	$o_year = _IEFormElementGetObjByName ($o_form, "yearList")
	_IEFormElementSetValue ($o_year, "1996")

	$o_month = _IEFormElementGetObjByName ($o_form, "monthList")
 	_IEFormElementSetValue ($o_month, "09 - September")
	
	$o_day = _IEFormElementGetObjByName ($o_form, "dayList")
	_IEFormElementSetValue ($o_day, "17")

;End Date
	$o_year = _IEFormElementGetObjByName ($o_form, "yearList")
	_IEFormElementSetValue ($o_year, "1996")

	$o_month = _IEFormElementGetObjByName ($o_form, "monthList")
 	_IEFormElementSetValue ($o_month, "09 - September")
	
	$o_day = _IEFormElementGetObjByName ($o_form, "dayList")
	_IEFormElementSetValue ($o_day, "17")


	_IEFormImageClick ($o_form, "addCriteriaButton", "name")
	_IELoadWait ($oIE)
	
