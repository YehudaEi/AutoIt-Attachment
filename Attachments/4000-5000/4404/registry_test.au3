#include "registry.au3"
#include "array.au3"

Opt("MustDeclareVars", 1)

local $a = _RegEnumKeys( "HKCR\CLSID" )
msgbox(0, ubound($a),"")
redim $a[10]
_ArrayDisplay($a,ubound($a))
