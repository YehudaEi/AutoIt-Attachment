#include-once

; #FUNCTION# ====================================================================================================================
; Name...........: _HashNew
; Description ...: Create a new Hash (Dictionary) Object
; Syntax.........: _HashNew([$iMode = 1])
; Parameters ....: [$iMode] - Mode to use for comparing keys.
;                  |0 - (Default) Binary - case sensitive
;                  |1 - Text - not case sensitive
;                  |2 - Database
; Return values .: Success - Returns a Scripting Dictionary object (a hash).
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
;                  |2 - Invalid $iMode - Not an integer
;                  |3 - Invalid $iMode - Out of range
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/x4k5wbx4(VS.85).aspx
;                  "A Dictionary object is the equivalent of a PERL associative array. Items can be any form of data, and are
;                  stored in the array. Each item is associated with a unique key. The key is used to retrieve an individual
;                  item and is usually an integer or a string, but can be anything except an array."
; Related .......: _HashAdd, _HashGet, _HashSet, _HashFind, _HashRename, _HashDelete, _HashClear, _HashCount, _HashKeys,
;                  +_HashValues
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashNew($iMode = 0)
  Local $oHash = ObjCreate("Scripting.Dictionary")
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  If Not IsInt($iMode) Then Return SetError(2, 0, False)
  If Not ($iMode >= 0) And ($iMode <= 2) Then Return SetError(3, 0, False)
  $oHash.CompareMode = $iMode
  Return $oHash
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashAdd
; Description ...: Add a new Key/Value pair
; Syntax.........: _HashAdd($oHash, $vKey, $vValue = "")
; Parameters ....: $oHash  - Hash object, created with _HashNew()
;                  $vKey   - Hash key, typically a string, must be unique.
;                  $vValue - The value you want to store, can not be an object.
; Return values .: Success - Returns True
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
;                  |2 - Invalid $vKey  - Already exists
;                  |3 - Unable to create key/value pair
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/5h92h863(VS.85).aspx
; Related .......: _HashGet, _HashSet, _HashFind, _HashRename, _HashDelete
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashAdd($oHash, $vKey, $vValue = "")
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  If _HashFind($oHash, $vKey) Then Return SetError(2, 0, False)
  $oHash.add($vKey, $vValue)
  If @error Then Return SetError(3, 0, False)
  Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashGet
; Description ...: Get the value associated with a key
; Syntax.........: _HashGet($oHash, $vKey)
; Parameters ....: $oHash - Hash object, created with _HashNew()
;                  $vKey  - Hash key, typically a string, must be unique.
; Return values .: Success - Returns the value associated with $vKey
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/84k9x471(VS.85).aspx
;                  "If key is not found when changing an item, a new key is created with the specified newitem. If key is not
;                  found when attempting to return an existing item, a new key is created and its corresponding item is left
;                  empty."
; Related .......: _HashAdd, _HashSet, _HashFind, _HashRename, _HashDelete
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashGet($oHash, $vKey)
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  Return $oHash.item($vKey)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashSet
; Description ...: Set the value of a key
; Syntax.........: _HashSet($oHash, $vKey, $vValue)
; Parameters ....: $oHash  - Hash object, created with _HashNew()
;                  $vKey   - Hash key, typically a string, must be unique.
;                  $vValue - The value you want to store, can not be an object.
; Return values .: Success - Returns True
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/84k9x471(VS.85).aspx
;                  "If key is not found when changing an item, a new key is created with the specified newitem. If key is not
;                  found when attempting to return an existing item, a new key is created and its corresponding item is left
;                  empty."
; Related .......: _HashAdd, _HashGet, _HashFind, _HashRename, _HashDelete
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashSet($oHash, $vKey, $vValue)
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  $oHash.item($vKey) = $vValue
  Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashFind
; Description ...: Check whether a named key exists
; Syntax.........: _HashFind($oHash, $vKey)
; Parameters ....: $oHash - Hash object, created with _HashNew()
;                  $vKey  - Hash key, typically a string, must be unique.
; Return values .: Success:
;                  |True   - Found
;                  |False  - Not found
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash  - Not an object
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/57hdf10z(VS.85).aspx
; Related .......: _HashAdd, _HashGet, _HashSet, _HashRename, _HashDelete
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashFind($oHash, $vKey)
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  Return $oHash.Exists($vKey)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashRename
; Description ...: Rename a key, value follows
; Syntax.........: _HashRename($oHash, $vKey, $vNewKey)
; Parameters ....: $oHash   - Hash object, created with _HashNew()
;                  $vKey    - Hash key, typically a string, must be unique.
;                  $vNewKey - The new key, replaces $vKey
; Return values .: Success - Returns True
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/1ex01tte(VS.85).aspx
;                  "If key is not found when changing a key, a new key is created and its associated item is left empty."
; Related .......: _HashAdd, _HashGet, _HashSet, _HashFind, _HashDelete
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashRename($oHash, $vKey, $vNewKey)
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  $oHash.key($vKey) = $vNewKey
  Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashDelete
; Description ...: Remove (delete) a key/value pair
; Syntax.........: _HashDelete($oHash, $vKey)
; Parameters ....: $oHash - Hash object, created with _HashNew()
;                  $vKey  - Hash key, typically a string, must be unique.
; Return values .: Success - True
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
;                  |2 - Invalid $vKey  - Doesn't exist
;                  |3 - Unable to delete key
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/ywyayk03(VS.85).aspx
; Related .......: _HashAdd, _HashGet, _HashSet, _HashFind, _HashRename
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashDelete($oHash, $vKey)
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  If Not _HashFind($oHash, $vKey) Then Return SetError(2, 0, False)
  $oHash.remove($vKey)
  If @error Then Return SetError(3, 0, False)
  Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashClear
; Description ...: Remove all key/value pairs.
; Syntax.........: _HashClear($oHash, $vKey)
; Parameters ....: $oHash - Hash object, created with _HashNew
;                  $vKey  - Hash key, typically a string, must be unique.
; Return values .: Success - Returns True
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/45731e2w(VS.85).aspx
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashClear($oHash, $vKey)
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  $oHash.removeAll($vKey)
  Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashCount
; Description ...: Determine how many keys exist.
; Syntax.........: _HashCount($oHash)
; Parameters ....: $oHash - Hash object, created with _HashNew()
; Return values .: Success - The number of keys stored in the hash object.
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/5t9h9579(VS.85).aspx
; Related .......: _HashKeys, _HashValues
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashCount($oHash)
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  Return $oHash.count
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashKeys
; Description ...: Return an array of all key names.
; Syntax.........: _HashKeys($oHash)
; Parameters ....: $oHash - Hash object, created with _HashNew()
; Return values .: Success - Array of all key values
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/etzd1tzc(VS.85).aspx
; Related .......: _HashCount, _HashValues
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashKeys($oHash)
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  Return $oHash.keys
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _HashValues
; Description ...: Return an array of all key values
; Syntax.........: _HashValues($oHash)
; Parameters ....: $oHash - Hash object, created with _HashNew()
; Return values .: Success - Array of all key values
;                  Failure - Returns False, and sets @error:
;                  |1 - Invalid $oHash - Not an object
; Author ........: Bill Guindon (aGorilla)
; Modified.......:
; Remarks .......: http://msdn.microsoft.com/en-us/library/8aet97f2(VS.85).aspx
; Related .......: _HashCount, _HashKeys
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _HashValues($oHash)
  If Not IsObj($oHash) Then Return SetError(1, 0, False)
  Return $oHash.items
EndFunc

