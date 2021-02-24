; model, machine, battery - by ndog
; last updated @ 22/09/2011
; version 1.4.2

; ================================================================================================================================

Func _GetLaptop()
$sStr = FileRead(@TempDir &"\mysystem.txt") ; Populate the array with CPUZ information

; [1] - check if the string Battery is found, if so assume Laptop and return

; Simple search for 'Battery' from CPUZ
If StringRegExp($sStr, "Battery") Then 
	$IsLaptop = "Laptop"
;Else
	;$IsLaptop = "Desktop"
EndIf

If IsDeclared("IsLaptop") Then Return $IsLaptop
	
	
; [2] - check if the string CardBus is found, if so assume Laptop and return
If StringRegExp($sStr, "CardBus") Then $IsLaptop = "Laptop"
If IsDeclared("IsLaptop") Then Return $IsLaptop


; [3] - check if chasis type is defined, if so use it

; Get the chassis type from CPUZ
$aDMI = StringRegExp($sStr, "(?is)dmi\s+system\s+enclosure\h*\v+(.+?)\v{3,}", 1)
If NOT @Error Then
    $aData = StringRegExp($aDMI[0], "(?i)(?:chassis\s+type)\h+(.+?)(?:\v)+", 3)
    If Not @Error Then
		$IsLaptop = $aData[0]
    EndIf
EndIf

; Detect Laptop
If IsDeclared("IsLaptop") Then
	If $IsLaptop = "Notebook" Then $IsLaptop = "Laptop"
		
		
	
	If $IsLaptop = "Laptop" Then Return $IsLaptop
EndIf


; Detect Desktop
;If $IsLaptop = "Low Profile Desktop" Then $IsLaptop = "Desktop"
;If $IsLaptop = "Space Saving" Then $IsLaptop = "Desktop"
;If $IsLaptop = "Tower" Then $IsLaptop = "Desktop"
;If $IsLaptop = "1X" Then $IsLaptop = "Desktop"


; If not detected yet assume Desktop
$IsLaptop = "Desktop"

Return $IsLaptop
EndFunc

Func _GetManufacturer()
$sStr = FileRead(@TempDir &"\mysystem.txt")

; Get the manufacturer and model from CPUZ DMI System Information
$sManufacturer = _sub_GetManufacturer($sStr)

;Clean up double spaces from manufacturer
$sline = $sManufacturer
$sLine = StringStripWS($sline,7)
$sLine = StringReplace($sLine, " ", "*")
$sLine = StringReplace($sLine, "*", " ")
$sManufacturer = $sLine

; Clean up Manufacturer codes
;Asus
If $sManufacturer = "Acer, inc." Then $sManufacturer = "Acer"
;Asus
If $sManufacturer = "ASUSTeK Computer INC." Then $sManufacturer = "Asus"
;HP
If $sManufacturer = "Hewlett-Packard" Then $sManufacturer = "HP"
If $sManufacturer = "HP Pavilion 05" Then $sManufacturer = "HP"
;MSI
If $sManufacturer = "MICRO-STAR INTERNATIONAL CO., LTD" Then $sManufacturer = "MSI"
If $sManufacturer = "Micro-Star International" Then $sManufacturer = "MSI"
;Toshiba
If $sManufacturer = "TOSHIBA" Then $sManufacturer = "Toshiba"
;Dell
If $sManufacturer = "Dell Inc." Then $sManufacturer = "Dell"
If $sManufacturer = "Dell Computer Corporation" Then $sManufacturer = "Dell"
;Gigabyte
If $sManufacturer = "Gigabyte Technology Co., Ltd." Then $sManufacturer = "Gigabyte"
;VIA
If $sManufacturer = "VIA Technologies, Inc." Then $sManufacturer = "VIA"
;Compaq
If $sManufacturer = "COMPAQ" Then $sManufacturer = "Compaq"
;Samsung
If $sManufacturer = "SAMSUNG ELECTRONICS CO., LTD." Then $sManufacturer = "Samsung"
;Lenovo
If $sManufacturer = "LENOVO" Then $sManufacturer = "Lenovo"
;Sony
If $sManufacturer = "Sony Corporation" Then $sManufacturer = "Sony"
;LG
If $sManufacturer = "LG Electronics Inc." Then $sManufacturer = "LG"
;Averatec (Korea & Japan)
If $sManufacturer = "AVERATEC" Then $sManufacturer = "Averatec"
;First International Computer (Taiwan)
If $sManufacturer = "First International Computer, Inc." Then $sManufacturer = "FIC"



ConsoleWrite("Manufacturer = " & $sManufacturer&@CRLF)
Return $sManufacturer
EndFunc

Func _sub_GetManufacturer($sStr)

$badvalues = StringSplit("unknown|System Manufacturer|System manufacturer", "|")

; First pass, try to get DMI System Information Manufacturer (Specific Model)
$aDMI = StringRegExp($sStr, "(?is)dmi\s+system\s+information\h*\v+(.+?)\v{3,}", 1)
If NOT @Error Then
    $aData = StringRegExp($aDMI[0], "(?i)(?:manufacturer|product)\h+(.+?)(?:\v)+", 3)
    If Not @Error Then
		$sManufacturer = $aData[0]
		;$sModel = $aData[1]
    EndIf
EndIf

$var = 0
For $n = 1 To $badvalues[0]
    If $sManufacturer <> $badvalues[$n] Then $var += 1
Next
If $var = $badvalues[0] Then Return $sManufacturer

; Second pass, try to get DMI Baseboard Vendor (Motherboard Information)
$aDMI = StringRegExp($sStr, "(?is)dmi\s+baseboard\h*\v+(.+?)\v{3,}", 1)
If NOT @Error Then
    $aData = StringRegExp($aDMI[0], "(?i)(?:vendor)\h+(.+?)(?:\v)+", 3)
    If Not @Error Then
		$sManufacturer = $aData[0]
    EndIf
EndIf

$var = 0
For $n = 1 To $badvalues[0]
    If $sManufacturer <> $badvalues[$n] Then $var += 1
Next
If $var = $badvalues[0] Then Return $sManufacturer

; First pass, try to get LPCIO Vendor (LPC bus southbridge controller, bad method but useful if no other info avaliable)
$aDMI = StringRegExp($sStr, "(?is)LPCIO\h*\v+(.+?)\v{5,}", 1)
If NOT @Error Then
    $aData = StringRegExp($aDMI[0], "(?i)(?:vendor)\h+(.+?)(?:\v)+", 3)
    If Not @Error Then
		$sManufacturer = $aData[0]
    EndIf
EndIf
Return $sManufacturer
EndFunc

Func _GetModel()
$sStr = FileRead(@TempDir &"\mysystem.txt")
; Get the manufacturer and model from CPUZ DMI System Information

; Get the manufacturer and model from CPUZ DMI System Information
$sModel = _sub_GetModel($sStr)

;Clean up double spaces from model
$sline = $sModel
$sLine = StringStripWS($sline,7)
$sLine = StringReplace($sLine, " ", "*")
$sLine = StringReplace($sLine, "*", " ")
$sModel = $sLine

;Remove illegal characters from model, replace with '-'
$sline = $sModel
$sModel = StringReplace($sline,"/","-")

ConsoleWrite("Model = " & $sModel&@CRLF)
Return $sModel
EndFunc

Func _sub_GetModel($sStr)
	
$badvalues = StringSplit("unknown|System Name|System Product Name|Product Name", "|")
	
; First pass, try to get DMI System Information Model (Specific Model)
$aDMI = StringRegExp($sStr, "(?is)dmi\s+system\s+information\h*\v+(.+?)\v{3,}", 1)
If NOT @Error Then
    $aData = StringRegExp($aDMI[0], "(?i)(?:product)\h+(.+?)(?:\v)+", 3)
    If Not @Error Then
		$sModel = $aData[0]
    EndIf
EndIf

$var = 0
For $n = 1 To $badvalues[0]
    If $sModel <> $badvalues[$n] Then $var += 1
Next
If $var = $badvalues[0] Then Return $sModel

; Second pass, try to get DMI Baseboard Vendor (Motherboard Information)
$aDMI = StringRegExp($sStr, "(?is)dmi\s+baseboard\h*\v+(.+?)\v{3,}", 1)
If NOT @Error Then
    $aData = StringRegExp($aDMI[0], "(?i)(?:model)\h+(.+?)(?:\v)+", 3)
    If Not @Error Then
		$sModel = $aData[0]
    EndIf
EndIf

$var = 0
For $n = 1 To $badvalues[0]
    If $sModel <> $badvalues[$n] Then $var += 1
Next
If $var = $badvalues[0] Then Return $sModel

; Third pass, try to get LPCIO Vendor (LPC bus southbridge controller, bad method but useful if no other info avaliable)
$aDMI = StringRegExp($sStr, "(?is)LPCIO\h*\v+(.+?)\v{5,}", 1)
If NOT @Error Then
    $aData = StringRegExp($aDMI[0], "(?i)(?:model)\h+(.+?)(?:\v)+", 3)
    If Not @Error Then
		$sModel = $aData[0]
    EndIf
EndIf
Return $sModel
EndFunc

; ================================================================================================================================

Func _GetChasisType() ; REDUNDANT FUNCTION
$sStr = FileRead(@TempDir &"\mysystem.txt")
; Get the chassis type from CPUZ
$aDMI = StringRegExp($sStr, "(?is)dmi\s+system\s+enclosure\h*\v+(.+?)\v{3,}", 1)
If NOT @Error Then
    $aData = StringRegExp($aDMI[0], "(?i)(?:chassis\s+type)\h+(.+?)(?:\v)+", 3)
    If Not @Error Then
		$IsLaptop = $aData[0]
    EndIf
EndIf

; Clean Chasis type to laptop or desktop
If $IsLaptop = "Notebook" Then $IsLaptop = "Laptop"

If $IsLaptop = "Low Profile Desktop" Then $IsLaptop = "Desktop"
If $IsLaptop = "Space Saving" Then $IsLaptop = "Desktop"
If $IsLaptop = "Tower" Then $IsLaptop = "Desktop"
If $IsLaptop = "1X" Then $IsLaptop = "Desktop"

Return $IsLaptop
EndFunc
