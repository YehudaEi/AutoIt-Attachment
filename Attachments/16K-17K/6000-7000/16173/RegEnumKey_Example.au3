#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.4.9
 Author:         Tiger

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <Array.au3>
#include "RegEnumKey.au3"

$array = _RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE")

_ArrayDisplay($array)