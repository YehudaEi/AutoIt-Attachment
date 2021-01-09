#include <Misc.au3>
#include <String.au3>
#include <Array.au3>
Func _IsPressEs($String,$Flag=0)
$Array=StringSplit($String,"")
_ArrayDelete($Array,0)
$Count=0
$Times=0
$dll = DllOpen("user32.dll")

while 1
	Select
		Case $Flag=0
	If _IsPressed(_Stringtohex(StringUpper($Array[0])),$dll)  Then
		_ArrayDelete($Array,0)
	If _ArrayMax($Array,1,0)=UBound($Array)-1 Then
		$Times=$Times+1
	If $Times=2 Then
		$Times=0
		$Array=StringSplit($String,"")
		_ArrayDelete($Array,0)
	Return 1
EndIf
EndIf

Do
Sleep(10)
Until Not _IsPressed(_Stringtohex(StringUpper($Array[0])),$dll)
EndIf

		Case $Flag=1
For $i=0 to UBound($Array)-1
	If _IsPressed(_Stringtohex(StringUpper($Array[$i])),$dll)  Then
		_ArrayDelete($Array,$i)
		_ArrayAdd($Array,"Over")
If _ArrayMin($Array,1,0)="Over" Then
	Return 1
EndIf

	EndIf
Next
	EndSelect
WEnd
EndFunc
