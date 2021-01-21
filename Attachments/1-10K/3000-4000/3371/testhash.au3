#include <Hash.au3>

$k = _HashCreate()
_HashAdd($k, "Don", 23)
_HashAdd($k, "Bill", 24)

msgbox (0, "Value of key 'Don'", _HashVal($k, "Don"))

dim $i
for $i = 1 to _HashUBound($k)											;show all keys and vals
	msgbox (0, "", "Key: " & _HashKeyByIndex($k, $i) & "           Value: " & _HashValByIndex($k, $i))
next

_HashDelete($k, "Don")													;remove key and val 'don' returns > 0 if fail



Exit