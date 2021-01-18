#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.7.1 (beta)
 Author:         Tiger

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <Array.au3>
#include <IE.au3>

$array = _IEReadToArray("http://www.autoitscript.com/autoit3/files/beta/update.dat")

_ArrayDisplay($array)

Func _IEReadToArray($s_url)
	
	Dim $ie_array
	
	$oIE = _IECreate($s_url, 0, 0)
	$sText = _IEBodyReadText ($oIE)
	
	$ie_array = StringSplit(StringStripCR($sText), @LF)
	
	Return $ie_array
	
EndFunc   ;==>_IEReadToArray