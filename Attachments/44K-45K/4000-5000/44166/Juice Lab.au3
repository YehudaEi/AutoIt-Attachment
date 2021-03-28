#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=C:\Program Files (x86)\AutoIt3\Icons\au3.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ build 11

#include <Date.au3>
#include <Array.au3>
#include <GuiListBox.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

$GUIColor=0xb2ccff
$GUI = GUICreate("Juice Lab", 600, 640)
GUISetBkColor($GuiColor, $GUI)
GUISetFont(8.5)
$ListRecipies = GUICtrlCreateList("", 10, 10, 440, 200)
$NewJuice = GUICtrlCreateButton("New Juice Recipe", 470, 10, 120, 30)
$EditJuice = GUICtrlCreateButton("Edit Juice Recipe", 470, 60, 120, 30)
$DeleteJuice = GUICtrlCreateButton("Delete Juice Recipe", 470, 100, 120, 30)
$SetDefaults = GUICtrlCreateButton("Set Defaults", 470, 170, 120, 30)
GUICtrlCreateLabel("Size of bottle (ml)", 15, 210, 90, 20)
$SizeToMake = GUICtrlCreateInput("", 15, 230, 50, 20)
GUICtrlCreateLabel("Base nicotine", 15, 260, 160, 20)
$JuiceShowBase = GUICtrlCreateLabel("", 15, 280, 80, 20)
GUICtrlCreateLabel("Desired nicotine strength", 160, 260, 160, 20)
$JuiceShowDesiredNicotine = GUICtrlCreateLabel("", 160, 280, 80, 20)
GUICtrlCreateLabel("Desired VG", 350, 260, 160, 20)
$JuiceShowDesiredVGPerc = GUICtrlCreateLabel("", 350, 280, 80, 20)
GUICtrlCreateGraphic(0, 300, 600, 3)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 10, 1)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x808080)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 590, 1)
GUICtrlCreateLabel("Use base nicotine", 15, 310, 110, 20)
$JuiceShowNicotine = GUICtrlCreateLabel("", 15, 330, 100, 20)
GUICtrlCreateLabel("Use VG", 160, 310, 60, 20)
$JuiceShowVG = GUICtrlCreateLabel("", 160, 330, 80, 20)
GUICtrlCreateLabel("Use PG", 350, 310, 60, 20)
$JuiceShowPG = GUICtrlCreateLabel("", 350, 330, 80, 20)
$JuiceShowNameF1 = GUICtrlCreateLabel("", 15, 360, 300, 20)
$JuiceShowNameF2 = GUICtrlCreateLabel("", 15, 380, 300, 20)
$JuiceShowNameF3 = GUICtrlCreateLabel("", 15, 400, 300, 20)
$JuiceShowNameF4 = GUICtrlCreateLabel("", 15, 420, 300, 20)
$JuiceShowNameF5 = GUICtrlCreateLabel("", 15, 440, 300, 20)
GUICtrlCreateGraphic(350, 355, 250, 3)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 1, 1)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x808080)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 240, 1)
GUICtrlCreateGraphic(350, 355, 3, 140)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 1, 1)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x808080)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 1, 135)
GUICtrlCreateLabel("Base Cost:", 400, 370, 100, 20)
$BaseCost = GUICtrlCreateLabel("", 500, 370, 100, 20)
GUICtrlCreateLabel("VG Cost:", 400, 390, 100, 20)
$VGCost = GUICtrlCreateLabel("", 500, 390, 100, 20)
GUICtrlCreateLabel("PG Cost:", 400, 410, 100, 20)
$PGCost = GUICtrlCreateLabel("", 500, 410, 100, 20)
GUICtrlCreateLabel("Flavoring Cost:", 400, 430, 100, 20)
$FlavoringCost = GUICtrlCreateLabel("", 500, 430, 100, 20)
GUICtrlCreateLabel("Total Cost:", 400, 460, 100, 20)
$TotalCost = GUICtrlCreateLabel("", 500, 460, 100, 20)
GUICtrlCreateLabel("Notes", 15, 480, 80, 20)
$Notes = GUICtrlCreateList("", 15, 500, 570, 85)
$AddNote = GUICtrlCreateButton("Add a Note", 470, 600, 120, 30)
$LogoColor = 0x6D6968;	LOL, "cloudy grey"!!  hahahahaha	http://www.computerhope.com/htmcolor.htm
GUICtrlCreateLabel("Ian Maxwell", 15, 600, 160, 15)
GUICtrlSetColor(-1, $LogoColor)
GUICtrlCreateLabel("MaxImuM AdVaNtAgE SofTWarE 2014", 15, 620, 190, 15)
GUICtrlSetColor(-1, $LogoColor)
GUICtrlCreateGraphic(15, 615, 110, 2)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $LogoColor)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, 1)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 110, 1)
GUISetState(@SW_SHOW, $GUI)

$Recipies = @ScriptDir & "\Recipies.ini"
If Not FileExists($Recipies) Then
	$JuiceGetBottleSize = 10
	IniWrite($Recipies, "Default", "Size", "10")
	IniWrite($Recipies, "Default", "BaseStrength", "100")
	IniWrite($Recipies, "Default", "VGPercent", "85")
	IniWrite($Recipies, "Default", "BaseCostPerML", "")
	IniWrite($Recipies, "Default", "VGCostPerML", "")
	IniWrite($Recipies, "Default", "PGCostPerML", "")
	IniWrite($Recipies, "Default", "FlavoringCostPerML", "")
Else
	$JuiceGetBottleSize = IniRead($Recipies, "Default", "Size", 10)
	If $JuiceGetBottleSize == "" Then
		$JuiceGetBottleSize = 10
		IniWrite($Recipies, "Default", "Size", "10")
	EndIf
EndIf
$GlobalBaseCost = IniRead($Recipies, "Default", "BaseCostPerML", "")
$GlobalBaseStrength = IniRead($Recipies, "Default", "BaseStrength", "")
$GlobalVGPercent = IniRead($Recipies, "Default", "VGPercent", "")
$GlobalVGCost = IniRead($Recipies, "Default", "VGCostPerML", "")
$GlobalPGCost = IniRead($Recipies, "Default", "PGCostPerML", "")
$GlobalFlavoringCost = IniRead($Recipies, "Default", "FlavoringCostPerML", "")
GUICtrlSetData($SizeToMake, $JuiceGetBottleSize)

_FillList()
$Index = -1

Do
	$Count = _GUICtrlListBox_GetCount($ListRecipies)
	If $Count > 0 Then
		$OldIndex = $Index
		$Index = _GUICtrlListBox_GetCurSel($ListRecipies)
		If $Index <> $OldIndex Then
			$GetRecipeName = GUICtrlRead($ListRecipies)
			$JuiceGetDesiredNicotine = IniRead($Recipies, $GetRecipeName, "Desired Nicotine", 0)
			$JuiceGetBaseNicotine = IniRead($Recipies, $GetRecipeName, "Base Nicotine", 0)
			$JuiceGetVG = IniRead($Recipies, $GetRecipeName, "Percent VG", 0)
			$JuiceGetNameF1 = IniRead($Recipies, $GetRecipeName, "Flavor 1 Name", "")
			$JuiceGetPercF1 = IniRead($Recipies, $GetRecipeName, "Flavor 1 Percent", 0)
			$JuiceGetNameF2 = IniRead($Recipies, $GetRecipeName, "Flavor 2 Name", "")
			$JuiceGetPercF2 = IniRead($Recipies, $GetRecipeName, "Flavor 2 Percent", 0)
			$JuiceGetNameF3 = IniRead($Recipies, $GetRecipeName, "Flavor 3 Name", "")
			$JuiceGetPercF3 = IniRead($Recipies, $GetRecipeName, "Flavor 3 Percent", 0)
			$JuiceGetNameF4 = IniRead($Recipies, $GetRecipeName, "Flavor 4 Name", "")
			$JuiceGetPercF4 = IniRead($Recipies, $GetRecipeName, "Flavor 4 Percent", 0)
			$JuiceGetNameF5 = IniRead($Recipies, $GetRecipeName, "Flavor 5 Name", "")
			$JuiceGetPercF5 = IniRead($Recipies, $GetRecipeName, "Flavor 5 Percent", 0)

			_Calculate($JuiceGetBottleSize, $JuiceGetPercF1, $JuiceGetPercF2, $JuiceGetPercF3, $JuiceGetPercF4, $JuiceGetPercF5, $JuiceGetBaseNicotine, $JuiceGetDesiredNicotine, $JuiceGetVG)

			GUICtrlSetData($Notes, "")
			$AllNotes = IniRead($Recipies, $GetRecipeName, "Notes", "") & Chr(2)
			$NoteBreak = StringSplit($AllNotes, "|")
			For $a = 1 To $NoteBreak[0]
				$CurrentNote = StringReplace($NoteBreak[$a], Chr(2), "")
				If $CurrentNote <> "note" And $CurrentNote <> "" Then
					GUICtrlSetData($Notes, $CurrentNote)
				EndIf
			Next
		EndIf

		$OldJuiceGetBottleSize = $JuiceGetBottleSize
		$JuiceGetBottleSize = GUICtrlRead($SizeToMake)
		If $JuiceGetBottleSize <> $OldJuiceGetBottleSize Then
			GUICtrlSetData($SizeToMake, $JuiceGetBottleSize)
			_Calculate($JuiceGetBottleSize, $JuiceGetPercF1, $JuiceGetPercF2, $JuiceGetPercF3, $JuiceGetPercF4, $JuiceGetPercF5, $JuiceGetBaseNicotine, $JuiceGetDesiredNicotine, $JuiceGetVG)
		EndIf
	EndIf

	$MSG = GUIGetMsg()
	If $MSG == $GUI_EVENT_CLOSE Then Exit
	If $MSG == $NewJuice Then _Make()
	If $MSG == $EditJuice Then
		_Make($JuiceGetDesiredNicotine, $JuiceGetBaseNicotine, $JuiceGetVG, $JuiceGetNameF1, $JuiceGetPercF1, $JuiceGetNameF2, $JuiceGetPercF2, $JuiceGetNameF3, $JuiceGetPercF3, $JuiceGetNameF4, $JuiceGetPercF4, $JuiceGetNameF5, $JuiceGetPercF5, $GetRecipeName, $Index, False)
	EndIf
	If $MSG == $DeleteJuice Then _Delete()
	If $MSG == $AddNote Then _AddNote($GetRecipeName)
	If $MSG == $SetDefaults Then _SetDefaults()
Until True == False


Func _Calculate($sSize, $sJuicePercF1 = 0, $sJuicePercF2 = 0, $sJuicePercF3 = 0, $sJuicePercF4 = 0, $sJuicePercF5 = 0, $sBaseNicotine = 0, $sDesiredNicotine = 0, $sPercVG = 50)
	$JuiceGetTotalFlavor = _FlavorPercent($sJuicePercF1 + $sJuicePercF2 + $sJuicePercF3 + $sJuicePercF4 + $sJuicePercF5, $sSize)
	$JuiceCalcBase = _UseBase($sSize, $sBaseNicotine, $sDesiredNicotine)
	$JuiceCalcVG = _TotalVG($sSize, $JuiceCalcBase, $JuiceGetTotalFlavor, $sPercVG)
	$JuiceCalcPG = _TotalPG($sSize, $JuiceCalcBase, $JuiceGetTotalFlavor, $JuiceCalcVG)

	GUICtrlSetData($SizeToMake, $sSize)
	GUICtrlSetData($JuiceShowBase, $sBaseNicotine & " mg/ml")
	GUICtrlSetData($JuiceShowDesiredNicotine, $sDesiredNicotine & " mg/ml")
	GUICtrlSetData($JuiceShowDesiredVGPerc, $sPercVG & "%")
	GUICtrlSetData($JuiceShowNicotine, StringFormat('%.2f', $JuiceCalcBase) & " ml")
	GUICtrlSetData($JuiceShowVG, StringFormat('%.2f', $JuiceCalcVG) & " ml")
	GUICtrlSetData($JuiceShowPG, StringFormat('%.2f', $JuiceCalcPG) & " ml")
	If $sJuicePercF1 > 0 Then
		GUICtrlSetData($JuiceShowNameF1, $JuiceGetNameF1 & ", " & _FlavorPercent($sJuicePercF1, $sSize) & " ml (" & $sJuicePercF1 & "%)")
	Else
		GUICtrlSetData($JuiceShowNameF1, "")
	EndIf
	If $sJuicePercF2 > 0 Then
		GUICtrlSetData($JuiceShowNameF2, $JuiceGetNameF2 & ", " & _FlavorPercent($sJuicePercF2, $sSize) & " ml (" & $sJuicePercF2 & "%)")
	Else
		GUICtrlSetData($JuiceShowNameF2, "")
	EndIf
	If $sJuicePercF3 > 0 Then
		GUICtrlSetData($JuiceShowNameF3, $JuiceGetNameF3 & ", " & _FlavorPercent($sJuicePercF3, $sSize) & " ml (" & $sJuicePercF3 & "%)")
	Else
		GUICtrlSetData($JuiceShowNameF3, "")
	EndIf
	If $sJuicePercF4 > 0 Then
		GUICtrlSetData($JuiceShowNameF4, $JuiceGetNameF4 & ", " & _FlavorPercent($sJuicePercF4, $sSize) & " ml (" & $sJuicePercF4 & "%)")
	Else
		GUICtrlSetData($JuiceShowNameF4, "")
	EndIf
	If $sJuicePercF5 > 0 Then
		GUICtrlSetData($JuiceShowNameF5, $JuiceGetNameF5 & ", " & _FlavorPercent($sJuicePercF5, $sSize) & " ml (" & $sJuicePercF5 & "%)")
	Else
		GUICtrlSetData($JuiceShowNameF5, "")
	EndIf

	$CalcBaseCost = $JuiceCalcBase * $GlobalBaseCost
	$CalcVGCost = $JuiceCalcVG * $GlobalVGCost
	$CalcPGCost = $JuiceCalcPG * $GlobalPGCost
	$CalcFlavoringCost = $JuiceGetTotalFlavor * $GlobalFlavoringCost
	GUICtrlSetData($BaseCost, "$" & StringFormat('%.2f', $CalcBaseCost))
	GUICtrlSetData($VGCost, "$" & StringFormat('%.2f', $CalcVGCost))
	GUICtrlSetData($PGCost, "$" & StringFormat('%.2f', $CalcPGCost))
	GUICtrlSetData($FlavoringCost, "$" & StringFormat('%.2f', $CalcFlavoringCost))
	GUICtrlSetData($TotalCost, "$" & StringFormat('%.2f', $CalcBaseCost + $CalcVGCost + $CalcPGCost + $CalcFlavoringCost))
EndFunc   ;==>_Calculate


Func _Make($sDesiredNicStrength = 0, $sBaseStrength = $GlobalBaseStrength, $sVGPercent = $GlobalVGPercent, $sFlavor1 = "", $sFlavor1Percent = 0, $sFlavor2 = "", $sFlavor2Percent = 0, $sFlavor3 = "", $sFlavor3Percent = 0, $sFlavor4 = "", $sFlavor4Percent = 0, $sFlavor5 = "", $sFlavor5Percent = 0, $sJuiceName = "", $sIndex = 0, $sNew = True)
	If $sNew == True Then
		$NewJuiceGUI = GUICreate("New Juice Recipe", 420, 540)
	Else
		$NewJuiceGUI = GUICreate("Edit " & $sJuiceName, 420, 540)
	EndIf
	GUISetBkColor($GuiColor, $NewJuiceGUI)
	GUISetFont(8.5)
	GUICtrlCreateLabel("Desired nicotine strength", 20, 10, 80, 15)
	$InputNicotineStrength = GUICtrlCreateInput($sDesiredNicStrength, 20, 30, 50, 18)
	$ShowNicotineStrength = GUICtrlCreateLabel("mg/ml", 75, 36, 50, 20)
	GUICtrlCreateLabel("Base nicotine strength", 140, 10, 140, 15)
	$InputBaseNicotineStrength = GUICtrlCreateInput($sBaseStrength, 140, 30, 50, 18)
	$ShowBaseNicotineStrength = GUICtrlCreateLabel("mg/ml", 195, 36, 50, 20)
	GUICtrlCreateLabel("Percent vegetable glycerin", 275, 10, 200, 15)
	$InputPercentVG = GUICtrlCreateInput($sVGPercent, 275, 30, 50, 18)
	$ShowPercentVG = GUICtrlCreateLabel("%", 330, 36, 50, 20)
	GUICtrlCreateLabel("28mg/ml - 32mg/ml", 10, 70, 120, 16, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xFF0000)
	GUICtrlSetColor(-1, 0xffffff)
	GUICtrlCreateLabel("High nicotine", 140, 70, 80, 20)
	GUICtrlCreateLabel("18mg/ml - 24mg/ml", 10, 90, 120, 16, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xF7FE2E)
	GUICtrlCreateLabel("Medium nicotine", 140, 90, 80, 20)
	GUICtrlCreateLabel("8mg/ml - 12mg/ml", 10, 110, 120, 16, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0x00ff40)
	GUICtrlCreateLabel("Low nicotine", 140, 110, 80, 20)
	GUICtrlCreateLabel("Reduce the level of nicotine in your liquid if you are going to use dual/quad coil or low resistance builds!", 240, 70, 180, 60)
	GUICtrlCreateLabel("Percent flavoring", 20, 175, 200, 15)
	$InputPercentFlavoring1 = GUICtrlCreateInput($sFlavor1Percent, 20, 195, 50, 18)
	$ShowPercentFlavoring1 = GUICtrlCreateLabel("%", 75, 201, 50, 20)
	GUICtrlCreateLabel("Flavor name", 135, 175, 75, 15)
	$InputFlavorName1 = GUICtrlCreateInput($sFlavor1, 135, 195, 270, 20)
	GUICtrlCreateLabel("Percent flavoring", 20, 230, 200, 15)
	$InputPercentFlavoring2 = GUICtrlCreateInput($sFlavor2Percent, 20, 250, 50, 18)
	$ShowPercentFlavoring2 = GUICtrlCreateLabel("%", 75, 256, 50, 20)
	GUICtrlCreateLabel("Flavor name", 135, 230, 75, 15)
	$InputFlavorName2 = GUICtrlCreateInput($sFlavor2, 135, 250, 270, 20)
	GUICtrlCreateLabel("Percent flavoring", 20, 285, 200, 15)
	$InputPercentFlavoring3 = GUICtrlCreateInput($sFlavor3Percent, 20, 305, 50, 18)
	$ShowPercentFlavoring3 = GUICtrlCreateLabel("%", 75, 311, 50, 20)
	GUICtrlCreateLabel("Flavor name", 135, 285, 75, 15)
	$InputFlavorName3 = GUICtrlCreateInput($sFlavor3, 135, 305, 270, 20)
	GUICtrlCreateLabel("Percent flavoring", 20, 340, 200, 15)
	$InputPercentFlavoring4 = GUICtrlCreateInput($sFlavor4Percent, 20, 360, 50, 18)
	$ShowPercentFlavoring4 = GUICtrlCreateLabel("%", 75, 366, 50, 20)
	GUICtrlCreateLabel("Flavor name", 135, 340, 75, 15)
	$InputFlavorName4 = GUICtrlCreateInput($sFlavor4, 135, 360, 270, 20)
	GUICtrlCreateLabel("Percent flavoring", 20, 395, 200, 15)
	$InputPercentFlavoring5 = GUICtrlCreateInput($sFlavor5Percent, 20, 415, 50, 18)
	$ShowPercentFlavoring5 = GUICtrlCreateLabel("%", 75, 421, 50, 20)
	GUICtrlCreateLabel("Flavor name", 135, 395, 75, 15)
	$InputFlavorName5 = GUICtrlCreateInput($sFlavor5, 135, 415, 270, 20)
	GUICtrlCreateLabel("Juice Name:", 10, 485, 200, 15)
	$JuiceName = GUICtrlCreateInput($sJuiceName, 10, 500, 200, 20)
	$Save = GUICtrlCreateButton("Save", 230, 495, 100, 30)
	GUISetState(@SW_SHOW, $NewJuiceGUI)

	Do
		$JuiceGetDesiredNicotine = GUICtrlRead($InputNicotineStrength)
		$GetBaseNicotine = GUICtrlRead($InputBaseNicotineStrength)
		$GetPercentFlavoring1 = GUICtrlRead($InputPercentFlavoring1)
		$GetPercentFlavoring2 = GUICtrlRead($InputPercentFlavoring2)
		$GetPercentFlavoring3 = GUICtrlRead($InputPercentFlavoring3)
		$GetPercentFlavoring4 = GUICtrlRead($InputPercentFlavoring4)
		$GetPercentFlavoring5 = GUICtrlRead($InputPercentFlavoring5)
		$GetPercentVG = GUICtrlRead($InputPercentVG)

		$MSG = GUIGetMsg()
		If $MSG == $Save Then
			$RecipeName = GUICtrlRead($JuiceName)
			$Flavor1Name = GUICtrlRead($InputFlavorName1)
			$Flavor2Name = GUICtrlRead($InputFlavorName2)
			$Flavor3Name = GUICtrlRead($InputFlavorName3)
			$Flavor4Name = GUICtrlRead($InputFlavorName4)
			$Flavor5Name = GUICtrlRead($InputFlavorName5)
			IniWrite($Recipies, $RecipeName, "Desired Nicotine", $JuiceGetDesiredNicotine)
			IniWrite($Recipies, $RecipeName, "Base Nicotine", $GetBaseNicotine)
			IniWrite($Recipies, $RecipeName, "Percent VG", $GetPercentVG)
			IniWrite($Recipies, $RecipeName, "Flavor 1 Name", $Flavor1Name)
			IniWrite($Recipies, $RecipeName, "Flavor 1 Percent", $GetPercentFlavoring1)
			IniWrite($Recipies, $RecipeName, "Flavor 2 Name", $Flavor2Name)
			IniWrite($Recipies, $RecipeName, "Flavor 2 Percent", $GetPercentFlavoring2)
			IniWrite($Recipies, $RecipeName, "Flavor 3 Name", $Flavor3Name)
			IniWrite($Recipies, $RecipeName, "Flavor 3 Percent", $GetPercentFlavoring3)
			IniWrite($Recipies, $RecipeName, "Flavor 4 Name", $Flavor4Name)
			IniWrite($Recipies, $RecipeName, "Flavor 4 Percent", $GetPercentFlavoring4)
			IniWrite($Recipies, $RecipeName, "Flavor 5 Name", $Flavor5Name)
			IniWrite($Recipies, $RecipeName, "Flavor 5 Percent", $GetPercentFlavoring5)
			_FillList($sIndex)
			If $sNew == True Then
				For $a = 0 To _GUICtrlListBox_GetCount($ListRecipies)
					If _GUICtrlListBox_GetText($ListRecipies, $a) == $RecipeName Then $sIndex = $a
				Next
				_GUICtrlListBox_SetCurSel($ListRecipies, $sIndex)
			Else
				_Calculate($JuiceGetBottleSize, $GetPercentFlavoring1, $GetPercentFlavoring2, $GetPercentFlavoring3, $GetPercentFlavoring4, $GetPercentFlavoring5, $GetBaseNicotine, $JuiceGetDesiredNicotine, $GetPercentVG)
			EndIf
			MsgBox(0, "Saved", "recipe saved")
			ExitLoop
		EndIf
		If $MSG == $GUI_EVENT_CLOSE Then
			ExitLoop
		EndIf
	Until True == False
	GUIDelete($NewJuiceGUI)
EndFunc   ;==>_Make


Func _SetDefaults()
	$DefaultGUI = GUICreate("Defaults", 290, 430)
	GUISetBkColor($GuiColor, $DefaultGUI)
	GUISetFont(8.5)
	GUICtrlCreateLabel("Default Bottle Size: (ML)", 10, 10, 200, 15)
	$ShowDefaultBottleSize = GUICtrlCreateInput($JuiceGetBottleSize, 230, 10, 50, 20)
	GUICtrlCreateLabel("Default Base Nicotine Strength: (MG/ML)", 10, 40, 200, 15)
	$ShowDefaultBaseStrength = GUICtrlCreateInput($GlobalBaseStrength, 230, 40, 50, 20)
	GUICtrlCreateLabel("Default VG Percent:", 10, 70, 200, 15)
	$ShowDefaultVGPercent = GUICtrlCreateInput($GlobalVGPercent, 230, 70, 50, 20)
	GUICtrlCreateLabel("Default Base Nicotine Cost per ML: ($)", 10, 100, 200, 15)
	$ShowDefaultBaseCost = GUICtrlCreateInput($GlobalBaseCost, 230, 100, 50, 20)
	GUICtrlCreateLabel("Default VG Cost per ML: ($)", 10, 130, 200, 15)
	$ShowDefaultVGCost = GUICtrlCreateInput($GlobalVGCost, 230, 130, 50, 20)
	GUICtrlCreateLabel("Default PG Cost per ML: ($)", 10, 160, 200, 15)
	$ShowDefaultPGCost = GUICtrlCreateInput($GlobalPGCost, 230, 160, 50, 20)
	GUICtrlCreateLabel("Default Flavoring Cost per ML: ($)", 10, 190, 200, 15)
	$ShowDefaultFlavoringCost = GUICtrlCreateInput($GlobalFlavoringCost, 230, 190, 50, 20)
	GUICtrlCreateLabel("Calculator to help determine the cost per ML", 0, 260, 290, 20, $SS_CENTER)
	GUICtrlCreateLabel("Total cost", 60, 290, 100, 15)
	$GetCost = GUICtrlCreateInput("", 60, 315, 80, 20)
	GUICtrlCreateLabel("Size (ML)", 150, 290, 100, 15)
	$GetML = GUICtrlCreateInput("", 150, 315, 80, 20)
	$Calculator = GUICtrlCreateLabel("", 105, 340, 80, 20, $SS_CENTER)
	$DefaultSave = GUICtrlCreateButton("Save Defaults", 95, 375, 100, 30)
	GUISetState(@SW_SHOW, $DefaultGUI)

	Local $CalcGetCost, $CalcGetML
	Do
		$OldCalcGetCost = $CalcGetCost
		$OldCalcGetML = $CalcGetML
		$CalcGetCost = GUICtrlRead($GetCost)
		$CalcGetML = GUICtrlRead($GetML)
		If $CalcGetCost <> $OldCalcGetCost Or $CalcGetML <> $OldCalcGetML And $CalcGetCost <> "" And $CalcGetCost <> 0 And $CalcGetML <> "" And $CalcGetML <> 0 Then
			GUICtrlSetData($Calculator, $CalcGetCost / $CalcGetML)
		EndIf

		$MSG = GUIGetMsg()
		If $MSG == $GUI_EVENT_CLOSE Then
			GUIDelete($DefaultGUI)
			ExitLoop
		EndIf
		If $MSG == $DefaultSave Then
			IniWrite($Recipies, "Default", "Size", GUICtrlRead($ShowDefaultBottleSize))
			IniWrite($Recipies, "Default", "BaseCostPerML", GUICtrlRead($ShowDefaultBaseCost))
			IniWrite($Recipies, "Default", "BaseStrength", GUICtrlRead($ShowDefaultBaseStrength))
			IniWrite($Recipies, "Default", "VGPercent", GUICtrlRead($ShowDefaultVGPercent))
			IniWrite($Recipies, "Default", "VGCostPerML", GUICtrlRead($ShowDefaultVGCost))
			IniWrite($Recipies, "Default", "PGCostPerML", GUICtrlRead($ShowDefaultPGCost))
			IniWrite($Recipies, "Default", "FlavoringCostPerML", GUICtrlRead($ShowDefaultFlavoringCost))
			MsgBox(0, "Saved", "Defaults have been saved.")
			GUIDelete($DefaultGUI)
			ExitLoop
		EndIf
	Until True == False
EndFunc   ;==>_SetDefaults


Func _Delete()
	$GetRecipeName = GUICtrlRead($ListRecipies)
	$YesOrNo = MsgBox(4, "Delete?", "Are you sure you want to delete this recipie?" & @CR & @CR & $GetRecipeName)
	If $YesOrNo == 6 Then
		IniDelete($Recipies, $GetRecipeName)
		_FillList()
	EndIf
EndFunc   ;==>_Delete


Func _FillList($sIndex = 0)
	_GUICtrlListBox_ResetContent($ListRecipies)
	$GetRecipies = IniReadSectionNames($Recipies)
	For $a = 1 To $GetRecipies[0]
		If $GetRecipies[$a] <> "Default" Then GUICtrlSetData($ListRecipies, $GetRecipies[$a])
	Next
	_GUICtrlListBox_SetCurSel($ListRecipies, $sIndex)
EndFunc   ;==>_FillList


Func _AddNote($aName)
	$NewNote = InputBox("Add a Note", "Enter your note about this juice recipe.")
	If $NewNote <> "" Then
		$OldNotes = IniRead($Recipies, $aName, "Notes", "")
		IniWrite($Recipies, $aName, "Notes", $OldNotes & _NowDate() & " - " & $NewNote & "|")
		GUICtrlSetData($Notes, _NowDate() & " - " & $NewNote)
	EndIf
EndFunc   ;==>_AddNote


Func _FlavorPercent($aPerc, $aSize)
	Return StringFormat('%.2f', $aPerc * $aSize / 100)
EndFunc   ;==>_FlavorPercent


Func _UseBase($aSize, $aBase, $aDesired)
	Return StringFormat('%.2f', $aSize / ($aBase / $aDesired))
EndFunc   ;==>_UseBase


Func _TotalFlavoring($aSize, $aFlav1, $aFlav2, $aFlav3, $aFlav4, $aFlav5)
	Return StringFormat('%.2f', $aSize * ($aFlav1 + $aFlav2 + $aFlav3 + $aFlav4 + $aFlav5) / 100)
EndFunc   ;==>_TotalFlavoring


Func _TotalVG($aSize, $aBase, $aFlav, $aPerc)
	Return StringFormat('%.2f', ($aSize - $aBase - $aFlav) * ($aPerc / 100))
EndFunc   ;==>_TotalVG


Func _TotalPG($aSize, $aBase, $aFlav, $aVG)
	Return StringFormat('%.2f', $aSize - $aBase - $aFlav - $aVG)
EndFunc   ;==>_TotalPG