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
#region Added this even to allow the GUI to track when the tabs change so that it can change the default button to the convert button on the currently visible tab - TKM
GUICtrlSetOnEvent(-1, "TabClicked")
#endregion
#cs
I added the the $CBS_DROPDOWNLIST style to every combobox because it makes the combobox text static so that the user shouldn't be able to modify the unit types. - TKM
#ce
GUICtrlCreateTabItem("Length")
GUICtrlCreateLabel("From:", 20, 35)
$LengthFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$LengthTo = GUICtrlCreateInput("", 270, 50, 150)
$LengthConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertLength")
$LengthFromUnits = GUICtrlCreateCombo("", 20, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Inches|Feet|Yards|Miles|Millimetres|Centimetres|Metres|Kilometres", "Inches")
$LengthToUnits = GUICtrlCreateCombo("", 270, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Inches|Feet|Yards|Miles|Millimetres|Centimetres|Metres|Kilometres", "Millimetres")

GUICtrlCreateTabItem("Area")
GUICtrlCreateLabel("From:", 20, 35)
$AreaFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$AreaTo = GUICtrlCreateInput("", 270, 50, 150)
$AreaConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertArea")
$AreaFromUnits = GUICtrlCreateCombo("", 20, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Square Inches|Square Feet|Square Yards|Acres|Square Miles|Square Millimetres|Square Centimetres|Square Metres|Hectares|Square Kilometres", "Square Inches")
$AreaToUnits = GUICtrlCreateCombo("", 270, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Square Inches|Square Feet|Square Yards|Acres|Square Miles|Square Millimetres|Square Centimetres|Square Metres|Hectares|Square Kilometres", "Square Millimetres")

GUICtrlCreateTabItem("Volume")
GUICtrlCreateLabel("From:", 20, 35)
$VolumeFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$VolumeTo = GUICtrlCreateInput("", 270, 50, 150)
$VolumeConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertVolume")
$VolumeFromUnits = GUICtrlCreateCombo("", 20, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Cubic Inches|Cubic Feet|Fluid Ounces|Pints|Gallons|US Fluid Ounces|US Pints|US Gallons|Cubic Centimetres|Cubic Decimetres|Cubic Metres|Litres|Hectolitres", "Cubic Inches")
$VolumeToUnits = GUICtrlCreateCombo("", 270, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Cubic Inches|Cubic Feet|Fluid Ounces|Pints|Gallons|US Fluid Ounces|US Pints|US Gallons|Cubic Centimetres|Cubic Decimetres|Cubic Metres|Litres|Hectolitres", "Cubic Centimetres")

GUICtrlCreateTabItem("Weight")
GUICtrlCreateLabel("From:", 20, 35)
$WeightFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$WeightTo = GUICtrlCreateInput("", 270, 50, 150)
$WeightConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertWeight")
$WeightFromUnits = GUICtrlCreateCombo("", 20, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Ounces|Pounds|Stone|Milligrams|Grams|Kilograms", "Ounces")
$WeightToUnits = GUICtrlCreateCombo("", 270, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Ounces|Pounds|Stone|Milligrams|Grams|Kilograms", "Milligrams")

GUICtrlCreateTabItem("Temperature")
GUICtrlCreateLabel("From:", 20, 35)
$TempFrom = GUICtrlCreateInput("", 20, 50, 150)
GUICtrlCreateLabel("To:", 270, 35)
$TempTo = GUICtrlCreateInput("", 270, 50, 150)
$TempConvert = GUICtrlCreateButton("Convert", 180, 50, 80, 25)
GUICtrlSetOnEvent(-1, "ConvertTemp")
$TempFromUnits = GUICtrlCreateCombo("", 20, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Celsius|Fahrenheit|Kelvin", "Celsius")
$TempToUnits = GUICtrlCreateCombo("", 270, 80, 150,-1,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Celsius|Fahrenheit|Kelvin", "Fahrenheit")
GUICtrlCreateTabItem("")
#region Added this to set length convert button to default because length tab is first visible tab on startup. -TKM
GUICtrlSetState($LengthConvert,$GUI_DEFBUTTON)
#endregion
GUISetState()
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")

While 1
	Sleep(1000)
WEnd

Func ConvertTemp()
#region This executes anything the user puts in.  Allows the user to use scientific notation - TKM
	$vFrom = Execute(GUICtrlRead($TempFrom))
#endregion
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
#region This executes anything the user puts in.  Allows the user to use scientific notation - TKM
	$vFrom = Execute(GUICtrlRead($WeightFrom))
#endregion
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
#region This executes anything the user puts in.  Allows the user to use scientific notation - TKM
	$vFrom = Execute(GUICtrlRead($VolumeFrom))
#endregion
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
#region This executes anything the user puts in.  Allows the user to use scientific notation - TKM
	$vFrom = Execute(GUICtrlRead($AreaFrom))
#endregion
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
#region This executes anything the user puts in.  Allows the user to use scientific notation - TKM
	$vFrom = Execute(GUICtrlRead($LengthFrom))
#endregion
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

#region This sets the default button every time the tab is clicked - TKM
Func TabClicked()
	Switch GUICtrlread($tab)
		Case 0;Length Tab is visible
			GUICtrlSetState($LengthConvert,$GUI_DEFBUTTON)
		Case 1;Area Tab is visible
			GUICtrlSetState($AreaConvert,$GUI_DEFBUTTON)
		Case 2;Volume Tab is visible
			GUICtrlSetState($VolumeConvert,$GUI_DEFBUTTON)
		Case 3;Weight Tab is visible
			GUICtrlSetState($WeightConvert,$GUI_DEFBUTTON)
		Case 4;Temperature Tab is visible
			GUICtrlSetState($TempConvert,$GUI_DEFBUTTON)
	EndSwitch
EndFunc
#endregion

Func Close()
	Exit
EndFunc   ;==>Close