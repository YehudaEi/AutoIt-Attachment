#include "FF3.au3"

global $i

for $i=1 to 4
;~ 	_FFStart('www.onet.pl',$i,9)
	Run('d:\program files (x86)\Mozilla Firefox\firefox.exe -P ' & $i & ' -no-remote', '', @SW_SHOW)
	_FFConnect()
	_FFWindowSelect()
	If Not _FFIsConnected() Then
		Exit;
	EndIf
	Switch $i
		Case 1
			_FFOpenURL('www.axa.com')
		Case 2
			_FFOpenURL('www.aegon.com')
		Case 3
			_FFOpenURL('www.compensa.com')
		case 4
			_FFOpenURL('www.google.com')
	EndSwitch
next

