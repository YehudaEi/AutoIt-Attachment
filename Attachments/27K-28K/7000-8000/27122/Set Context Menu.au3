$CommandPath = "C:\Documents and Settings\Owner\Desktop\Command.exe" ;change this to the full path of the COMPILED Command.au3
;uncomment the following to add two entries to the right click context menu for folders
;AddItemToRightClick("Encrypt", $CommandPath & " -Lock")
;AddItemToRightClick("Decrypt", $CommandPath & " -Unlock")

Func AddItemToRightClick($Name, $Command)
	If RegRead("HKEY_CLASSES_ROOT\Folder\shell\" & $Name, "") Then Return SetError(1, 0, -1) ;make sure registry entry doesn't already exist
	Return RegWrite("HKEY_CLASSES_ROOT\Folder\shell\" & $Name & "\command", "", "REG_SZ", $Command)
EndFunc   ;==>AddItemToRightClick

Func DeleteItemFromRightClick($Name)
	Return RegDelete("HKEY_CLASSES_ROOT\Folder\shell\" & $Name)
EndFunc   ;==>DeleteItemFromRightClick