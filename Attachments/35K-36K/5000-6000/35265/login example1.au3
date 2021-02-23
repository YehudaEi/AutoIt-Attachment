#include <IE.au3>

openandloginIAS()

Func openandloginIAS()

	$oIE = _IECreate("MyUrlHere")
	Sleep(2000)
	$oForm = _IEFormGetCollection($oIE, 0)
	$oQuery = _IEFormElementGetCollection($oForm, 2)

	ConsoleWrite($oQuery)

EndFunc
