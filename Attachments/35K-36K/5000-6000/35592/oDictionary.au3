#include-once
#include "AutoItObject.au3"

Func __Element__($key, $data, $nextEl = 0)
	Local $oClassObj = _AutoItObject_Class()
	$oClassObj.AddProperty("key", $ELSCOPE_PUBLIC, 0)
	$oClassObj.AddProperty("next", $ELSCOPE_PUBLIC, 0)
	$oClassObj.AddProperty("data", $ELSCOPE_PUBLIC, 0)
	Local $oObj = $oClassObj.Object
	$oObj.next = $nextEl
	$oObj.key = $key
	$oObj.data = $data
	Return $oObj
EndFunc   ;==>__Element__

Func _Dictionary()
	Local $oClassObj = _AutoItObject_Class()
	; Properties
	$oClassObj.AddProperty("first", $ELSCOPE_READONLY, 0)
	$oClassObj.AddProperty("last", $ELSCOPE_READONLY, 0)
	$oClassObj.AddProperty("size", $ELSCOPE_READONLY, 0)
	$oClassObj.AddProperty("compare", $ELSCOPE_READONLY, 0)
    ; Methods
	$oClassObj.AddMethod("Count", "_Dictionary_count")
	$oClassObj.AddMethod("Add", "_Dictionary_add")
	$oClassObj.AddMethod("Item", "_Dictionary_item")
	$oClassObj.AddMethod("Key", "_Dictionary_key")
	$oClassObj.AddMethod("Exists", "_Dictionary_exists")
	$oClassObj.AddMethod("__default__", "_Dictionary_item")
	$oClassObj.AddMethod("Remove", "_Dictionary_remove")
	$oClassObj.AddMethod("RemoveAll", "_Dictionary_removeall")
	$oClassObj.AddMethod("Items", "_Dictionary_items")
	$oClassObj.AddMethod("Keys", "_Dictionary_keys")
	$oClassObj.AddMethod("CompareMode", "_Dicionary_comparemode")
    ; Enum
	$oClassObj.AddEnum("_Dictionary_Enumnext", "_Dictionary_EnumReset")
    ; Return created object
	Return $oClassObj.Object
EndFunc   ;==>LinkedList

Func _Dicionary_comparemode($self, $newvalue=0)
	If @NumParams = 2 Then
		If $self.size <> 0 Then Return SetError(1, 0, -1)
		$self.compare = $newvalue
		Return $newvalue
	EndIf
	Return $self.compare
EndFunc

Func _Dictionary_remove($self, $key)
	If $self.size = 0 Then Return SetError(1, 0, 0)
	Local $current = $self.first
	Local $previous = 0
	Local $i = 0
	Do
		If ($self.compare = 1 And $current.key = $key) Or ($self.compare = 0 And $current.key == $key) Then
			If $self.size = 1 Then
				; very last element
				$self.first = 0
				$self.last = 0
			ElseIf $i = 0 Then
				; first element
				$self.first = $current.next
			Else
				If $i = $self.size - 1 Then $self.last = $previous ; last element
				$previous.next = $current.next
			EndIf
			$self.size = $self.size - 1
			Return
		EndIf
		$i += 1
		$previous = $current
		$current = $current.next
	Until $current = 0
	Return SetError(2, 0, 0)
EndFunc   ;==>_Dictionary_remove

Func _Dictionary_removeall($self)
	#forceref $self
	$self.first = 0
	$self.last = 0
	$self.size = 0
EndFunc

Func _Dictionary_add($self, $newkey, $newdata)
	If $self.Exists($newkey) Then Return SetError(1, 0, 0)
	Local $iSize = $self.size
	Local $oLast = $self.last
	If $iSize = 0 Then
		$self.first = __Element__($newkey, $newdata)
		$self.last = $self.first
	Else
		$oLast.next = __Element__($newkey, $newdata)
		$self.last = $oLast.next
	EndIf
	$self.size = $iSize + 1
EndFunc   ;==>_Dictionary_add

Func _Dictionary_item($self, $key, $data=0)
	Local $current = $self.first
	If @NumParams = 3 Then
		If $self.Exists($key) Then
			Do
				If ($self.compare = 1 And $current.key = $key) Or ($self.compare = 0 And $current.key == $key) Then
					$current.data = $data
				EndIf
				$current = $current.next
			Until $current = 0
		Else
			$self.Add($key, $data)
		EndIf
	Else
		Do
			If ($self.compare = 1 And $current.key = $key) Or ($self.compare = 0 And $current.key == $key) Then
				Return $current.data
			EndIf
		Until $current = 0
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_Dictionary_at

Func _Dictionary_key($self, $key, $newkey)
	Local $current = $self.first
	Do
		If ($self.compare = 1 And $current.key = $key) Or ($self.compare = 0 And $current.key == $key) Then
			$current.key = $newkey
		EndIf
		$current = $current.next
	Until $current = 0
	Return SetError(1, 0, 0)
EndFunc   ;==>_Dictionary_at

Func _Dictionary_exists($self, $key)
	For $Element in $self
		If ($self.compare = 1 And $Element = $key) Or ($self.compare = 0 And $Element == $key) Then Return True
	Next
	Return False
EndFunc   ;==>_Dictionary_at

Func _Dictionary_count($self)
	Return $self.size
EndFunc   ;==>_Dictionary_count

Func _Dictionary_items($self)
	Local $aReturn[$self.size]
	Local $i = 0
	For $Element In $self
		$aReturn[$i] = $self.Item($Element)
		$i += 1
	Next
	Return $aReturn
EndFunc

Func _Dictionary_keys($self)
	Local $aReturn[$self.size]
	Local $i = 0
	For $Element In $self
		$aReturn[$i] = $Element
		$i += 1
	Next
	Return $aReturn
EndFunc

Func _Dictionary_EnumReset(ByRef $self, ByRef $iterator)
	#forceref $self
	$iterator = 0
EndFunc   ;==>_Dictionary_EnumReset

Func _Dictionary_Enumnext(ByRef $self, ByRef $iterator)
	If $self.size = 0 Then Return SetError(1, 0, 0)
	If Not IsObj($iterator) Then
		$iterator = $self.first
		Return $iterator.key
	EndIf
	If Not IsObj($iterator.next) Then Return SetError(1, 0, 0)
	$iterator = $iterator.next
	Return $iterator.key
EndFunc   ;==>_Dictionary_Enumnext
