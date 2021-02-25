#include <IE.au3>
#include <Inet.au3>
#include <Array.au3>

Func ActivateEmailAddresses()

If Not WinActive("Left window, email addresses", "") Then
	WinActivate ( "Left window, email addresses", "")

EndIf
EndFunc
Func ActivateMail()

If Not WinActive("Right Window, Mail", "") Then
	WinActivate ("Right Window, Mail", "")

EndIf
EndFunc

Func SearchChkBx()
$oIE = _IEAttach ("Left window, email addresses") ;attach the IExplore window to AutoIT

$chkbx = _IEGetObjByName($oIE, "ids") ; get the checkbox
$chkbxVal2 = $chkbx.value ; get the value of the checkbox, i will use this for the navigate link
Global $values[1] ; array that holds the checkboxes values
$values[0] = $chkbxVal2 ; assign first element
$arr_count = UBound($values) - 2 ; used for loops
_ArrayDisplay($values, "asta-i") ; test

;~ For $i = 0 to $arr_count Step 1
;~ 	$arrval = $values[$i]
;~ 	If $chkbx.value = $arrval Then
;~ 	EndIf
;~
;~ Next

$i= 0
While $i <= $arr_count
; ====> What i try to do here, is to add all the verified and used values of the checkboxes, to an array, so i can use it to check the rest of them
$arrval = $values[$i]
	If $chkbx.value <> $arrval Then
	$chkbxVal2 = $chkbx.value		;;===>> If the value of the checkbox is not in the array, add it, and navigate to the link
	_ArrayAdd($values, $chkbxVal2)
	$chkbx.checked = True
	_IENavigate($oIE, "javascript:showContact('" & $chkbxVal2 & "')") ; ==> Navigate
	MsgBox(0, '', $chkbxVal2) ; Test
	EndIf

$i = $i+1
WEnd

	EndFunc


	ActivateEmailAddresses()
	SearchChkBx()

