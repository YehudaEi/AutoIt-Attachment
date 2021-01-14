#NoTrayIcon
#include <GUIConstants.au3>
;===============================================================================
;
; Program Name:		Unit Converter
; Description::		Converts Length, Area, Volume, Weight, and Temperature to different units
; Requirement(s):	None
; Author(s):		RazerM
;
;===============================================================================
;

Opt("GUIOnEventMode", 1)
GUICreate("Imperial to Metric Converter", 440, 130)
$tab = GUICtrlCreateTab(10, 10, 420, 110)
GUICtrlSetOnEvent(-1, "TabClicked")

GUICtrlCreateTabItem("Length")
GUICtrlCreateLabel("From:", 20, 35)
$LengthFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$LengthTo = GUICtrlCreateInput("", 270, 50, 150)
$LengthConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertLength")
$LengthFromUnits = GUICtrlCreateCombo("", 20, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Inches|Feet|Yards|Miles|Millimetres|Centimetres|Metres|Kilometres", "Inches")
$LengthToUnits = GUICtrlCreateCombo("", 270, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Inches|Feet|Yards|Miles|Millimetres|Centimetres|Metres|Kilometres", "Millimetres")

GUICtrlCreateTabItem("Area")
GUICtrlCreateLabel("From:", 20, 35)
$AreaFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$AreaTo = GUICtrlCreateInput("", 270, 50, 150)
$AreaConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertArea")
$AreaFromUnits = GUICtrlCreateCombo("", 20, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Square Inches|Square Feet|Square Yards|Acres|Square Miles|Square Millimetres|Square Centimetres|Square Metres|Hectares|Square Kilometres", "Square Inches")
$AreaToUnits = GUICtrlCreateCombo("", 270, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Square Inches|Square Feet|Square Yards|Acres|Square Miles|Square Millimetres|Square Centimetres|Square Metres|Hectares|Square Kilometres", "Square Millimetres")

GUICtrlCreateTabItem("Volume")
GUICtrlCreateLabel("From:", 20, 35)
$VolumeFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$VolumeTo = GUICtrlCreateInput("", 270, 50, 150)
$VolumeConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertVolume")
$VolumeFromUnits = GUICtrlCreateCombo("", 20, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Cubic Inches|Cubic Feet|Fluid Ounces|Pints|Gallons|US Fluid Ounces|US Pints|US Gallons|Cubic Centimetres|Cubic Decimetres|Cubic Metres|Litres|Hectolitres", "Cubic Inches")
$VolumeToUnits = GUICtrlCreateCombo("", 270, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Cubic Inches|Cubic Feet|Fluid Ounces|Pints|Gallons|US Fluid Ounces|US Pints|US Gallons|Cubic Centimetres|Cubic Decimetres|Cubic Metres|Litres|Hectolitres", "Cubic Centimetres")

GUICtrlCreateTabItem("Weight")
GUICtrlCreateLabel("From:", 20, 35)
$WeightFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$WeightTo = GUICtrlCreateInput("", 270, 50, 150)
$WeightConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertWeight")
$WeightFromUnits = GUICtrlCreateCombo("", 20, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Ounces|Pounds|Stone|Milligrams|Grams|Kilograms", "Ounces")
$WeightToUnits = GUICtrlCreateCombo("", 270, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Ounces|Pounds|Stone|Milligrams|Grams|Kilograms", "Milligrams")

GUICtrlCreateTabItem("Temperature")
GUICtrlCreateLabel("From:", 20, 35)
$TempFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$TempTo = GUICtrlCreateInput("", 270, 50, 150)
$TempConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertTemp")
$TempFromUnits = GUICtrlCreateCombo("", 20, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Celsius|Fahrenheit|Kelvin", "Celsius")
$TempToUnits = GUICtrlCreateCombo("", 270, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Celsius|Fahrenheit|Kelvin", "Fahrenheit")

GUICtrlCreateTabItem("Pressure")
GUICtrlCreateLabel("From:", 20, 35)
$PressureFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$PressureTo = GUICtrlCreateInput("", 270, 50, 150)
$PressureConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertPressure")
$PressureFromUnits = GUICtrlCreateCombo("", 20, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Pound-force per square inch|Bar|Atmosphere|Technical Atmosphere|Pascal", "Pound-force per square inch")
$PressureToUnits = GUICtrlCreateCombo("", 270, 80, 150, 200, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Pound-force per square inch|Bar|Atmosphere|Technical Atmosphere|Pascal", "Bar")

GUICtrlCreateTabItem("")

GUICtrlSetState($LengthConvert, $GUI_DEFBUTTON)

GUISetState()
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")

While 1
	Sleep(1000)
WEnd

Func ConvertPressure()
	$vFrom = Execute(GUICtrlRead($PressureFrom))
	If Not IsNumber(Number($vFrom)) Then Return SetError(1, 0, 0)
	Local $avUnits[5][2] = [["Pound-force per square inch", 1], ["Bar", 14.5037738], ["Atmosphere", 14.6959488], ["Technical Atmosphere", 14.223], ["Pascal", 0.000145037738]]
		For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($PressureFromUnits) = $avUnits[$iUnit][0] Then
			$vFrom *= $avUnits[$iUnit][1]
		EndIf
	Next
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($PressureToUnits) = $avUnits[$iUnit][0] Then
			$vTo = $vFrom / $avUnits[$iUnit][1]
		EndIf
	Next
	GUICtrlSetData($PressureTo, $vTo)
EndFunc

Func ConvertTemp()
	$vFrom = Execute(GUICtrlRead($TempFrom))
	If Not IsNumber(Number($vFrom)) Then Return SetError(1, 0, 0)
	Local $avUnits[3][2] = [["Kelvin", ")*1"], ["Fahrenheit", "+459.67)*5/9"], ["Celsius", "+273.15)"]]
	Local $avToUnits[3][2] = [["Kelvin", ")*1"], ["Fahrenheit", "*9/5-459.67)"], ["Celsius", "-273.15)"]]
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($TempFromUnits) = $avUnits[$iUnit][0] Then
			$vFrom = Execute("(" & $vFrom & $avUnits[$iUnit][1])
		EndIf
	Next
	For $iUnit = 0 To UBound($avToUnits) - 1
		If GUICtrlRead($TempToUnits) = $avToUnits[$iUnit][0] Then
			$vTo = Execute("(" & $vFrom & $avToUnits[$iUnit][1])
		EndIf
	Next
	GUICtrlSetData($TempTo, $vTo)
EndFunc   ;==>ConvertTemp

Func ConvertWeight()
	$vFrom = Execute(GUICtrlRead($WeightFrom))
	If Not IsNumber(Number($vFrom)) Then Return SetError(1, 0, 0)
	Local $avUnits[6][2] = [["Ounces", 1], ["Pounds", 16], ["Stone", 224], ["Milligrams", 3.52739619 * 10 ^ - 5], ["Grams", 0.0352739619], ["Kilograms", 35.2739619]]
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($WeightFromUnits) = $avUnits[$iUnit][0] Then
			$vFrom *= $avUnits[$iUnit][1]
		EndIf
	Next
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($WeightToUnits) = $avUnits[$iUnit][0] Then
			$vTo = $vFrom / $avUnits[$iUnit][1]
		EndIf
	Next
	GUICtrlSetData($WeightTo, $vTo)
EndFunc   ;==>ConvertWeight

Func ConvertVolume()
	$vFrom = Execute(GUICtrlRead($VolumeFrom))
	If Not IsNumber(Number($vFrom)) Then Return SetError(1, 0, 0)
	Local $avUnits[13][2] = [["Cubic Inches", 1], ["Cubic Feet", 1728], ["Fluid Ounces", 1.73387217], ["Pints", 34.6774434], ["Gallons", 277.419547], ["US Fluid Ounces", 1.80468751 ], ["US Pints", 28.8750001], ["US Gallons", 231.000001], ["Cubic Centimetres", 0.0610237441], ["Cubic Decimetres", 61.0237441], ["Cubic Metres", 61023.7441], ["Litres", 61.0237441], ["Hectolitres", 6102.37441]]
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($VolumeFromUnits) = $avUnits[$iUnit][0] Then
			$vFrom *= $avUnits[$iUnit][1]
		EndIf
	Next
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($VolumeToUnits) = $avUnits[$iUnit][0] Then
			$vTo = $vFrom / $avUnits[$iUnit][1]
		EndIf
	Next
	GUICtrlSetData($VolumeTo, $vTo)
EndFunc   ;==>ConvertVolume

Func ConvertArea()
	$vFrom = Execute(GUICtrlRead($AreaFrom))
	If Not IsNumber(Number($vFrom)) Then Return SetError(1, 0, 0)
	Local $avUnits[10][2] = [["Square Inches", 1], ["Square Feet", 144], ["Square Yards", 1296], ["Acres", 6272640], ["Square Miles", 4014489600], ["Square Millimetres", 0.0015500031], ["Square Centimetres", 0.15500031], ["Square Metres", 1550.0031], ["Hectares", 15500031], ["Square Kilometres", 1.5500031 * 10 ^ 9]]
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($AreaFromUnits) = $avUnits[$iUnit][0] Then
			$vFrom *= $avUnits[$iUnit][1]
		EndIf
	Next
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($AreaToUnits) = $avUnits[$iUnit][0] Then
			$vTo = $vFrom / $avUnits[$iUnit][1]
		EndIf
	Next
	GUICtrlSetData($AreaTo, $vTo)
EndFunc   ;==>ConvertArea

Func ConvertLength()
	$vFrom = Execute(GUICtrlRead($LengthFrom))
	If Not IsNumber(Number($vFrom)) Then Return SetError(1, 0, 0)
	Local $avUnits[8][2] = [["Inches", 1], ["Feet", 12], ["Yards", 36], ["Miles", 63360], ["Millimetres", 0.0393700787], ["Centimetres", 0.393700787], ["Metres", 39.3700787], ["Kilometres", 39370.0787]]
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($LengthFromUnits) = $avUnits[$iUnit][0] Then
			$vFrom *= $avUnits[$iUnit][1]
		EndIf
	Next
	For $iUnit = 0 To UBound($avUnits) - 1
		If GUICtrlRead($LengthToUnits) = $avUnits[$iUnit][0] Then
			$vTo = $vFrom / $avUnits[$iUnit][1]
		EndIf
	Next
	GUICtrlSetData($LengthTo, $vTo)
EndFunc   ;==>ConvertLength

Func TabClicked()
	Switch GUICtrlRead($tab)
		Case 0 ;Length Tab is visible
			GUICtrlSetState($LengthConvert, $GUI_DEFBUTTON)
		Case 1 ;Area Tab is visible
			GUICtrlSetState($AreaConvert, $GUI_DEFBUTTON)
		Case 2 ;Volume Tab is visible
			GUICtrlSetState($VolumeConvert, $GUI_DEFBUTTON)
		Case 3 ;Weight Tab is visible
			GUICtrlSetState($WeightConvert, $GUI_DEFBUTTON)
		Case 4 ;Temperature Tab is visible
			GUICtrlSetState($TempConvert, $GUI_DEFBUTTON)
		Case 5 ;Pressure tab is visible
			GUICtrlSetState($PressureConvert, $GUI_DEFBUTTON)
	EndSwitch
EndFunc   ;==>TabClicked

Func Close()
	Exit
EndFunc   ;==>Close