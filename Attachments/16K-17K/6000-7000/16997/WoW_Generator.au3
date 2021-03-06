#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=WoW Gen.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Thanks to Manadar for the BC idea!
#AutoIt3Wrapper_Res_Description=WoW character Generator
#AutoIt3Wrapper_Res_Fileversion=0.0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Language=3081
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <Array.au3>

;-----------Names-----------
$NameList = _ArrayCreate(12, "Dath", "Gar", "Ash", "Dal", "Mad", "Aeg", "Ak", "Aku", "Alex", "All", "Aman", "Arch")
$NameList1 = _ArrayCreate(4, "rem", "or", "de", "ma")
$NameList2 = _ArrayCreate(12, "nar", "ar", "las", "ynn", "mai", "eria", "thul", "thar", "ron", "das", "arak", "mer")
;-----------Names-----------

$GenderList = _ArrayCreate(2, "Male", "Female")
$FactionList = _ArrayCreate(2, "Alliance", "Horde")
$ARaceList = _ArrayCreate(4, "Night Elf", "Gnome", "Human", "Dwarf")
$HRaceList = _ArrayCreate(4, "Undead", "Tauren", "Troll", "Orc")
$ARaceListBC = _ArrayCreate(5, "Night Elf", "Gnome", "Human", "Draenei", "Dwarf")
$HRaceListBC = _ArrayCreate(5, "Undead", "Blood Elf", "Tauren", "Troll", "Orc")

;----------Alliance----------
$NightElf = _ArrayCreate(5, "Druid", "Hunter", "Priest", "Rogue", "Warrior")
$Gnome = _ArrayCreate(4, "Mage", "Rogue", "Warlock", "Warrior")
$Human = _ArrayCreate(6, "Mage", "Paladin", "Priest", "Rogue", "Warrior", "Warlock")
$Draenei = _ArrayCreate(6, "Hunter", "Mage", "Paladin", "Priest", "Shaman", "Warrior")
$Dwarf = _ArrayCreate(5, "Hunter", "Paladin", "Priest", "Rogue", "Warrior")
;----------Alliance----------

;------------Horde-----------
$Undead = _ArrayCreate(5, "Mage", "Priest", "Rogue", "Warlock", "Warrior")
$BloodElf = _ArrayCreate(6, "Hunter", "Mage", "Paladin", "Priest", "Rogue", "Warlock")
$Tauren = _ArrayCreate(4, "Druid", "Hunter", "Shaman", "Warrior")
$Troll = _ArrayCreate(6, "Hunter", "Mage", "Priest", "Rogue", "Shaman", " Warrior")
$Orc = _ArrayCreate(5, "Hunter", "Rogue", "Shaman", "Warlock", "Warrior")
;------------Horde-----------


$Main = GUICreate("WoW Character Generator", 521, 120)
$Name = GUICtrlCreateInput("Name", 200, 16, 121, 21)
$Gender = GUICtrlCreateInput("Gender", 8, 44, 121, 21)
$Faction = GUICtrlCreateInput("Faction", 136, 44, 121, 21)
$Race = GUICtrlCreateInput("Race", 264, 44, 121, 21)
$Class = GUICtrlCreateInput("Class", 392, 44, 121, 21)
$Generate = GUICtrlCreateButton("Generate", 136, 76, 107, 25, 0)
$GenName = GUICtrlCreateButton("New Name", 264, 76, 107, 25, 0)
$Expansion = GUICtrlCreateCheckbox("Burning Crusade", 10, 98)
$About = GUICtrlCreateLabel("?", 510, 103, 15, 15)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $About
			MsgBox(32, "About", "Don't know what character you want to make next? " & @CRLF & "Let WoW Character Generator decide for you! It gives you a Gender, Faction, Race and Class!" & @CRLF & @CRLF & "Made by alien13 -                       ")
		Case $Generate
			GUICtrlSetData($Gender, $GenderList[Random(1, 2, 1) ]) ; Generates a random gender from the array list
			GUICtrlSetData($Faction, $FactionList[Random(1, 2, 1) ]) ; Generates a random faction from the array list
			If GUICtrlRead($Expansion) = 1 Then ; Reads if you have the expansion or not (if its checked)
				$GetFaction = GUICtrlRead($Faction)  ; Gets the generated faction
				;Reads what the faction is and then generates a race from that faction
				If $GetFaction = "Horde" Then
					GUICtrlSetData($Race, $HRaceListBC[Random(1, 5, 1) ])
				Else
					GUICtrlSetData($Race, $ARaceListBC[Random(1, 5, 1) ])
				EndIf
				$GetRaceH = GUICtrlRead($Race) ;Gets the generated race
				;----HORDE----;
				;Reads the generated race and generates a class for it
				If $GetRaceH = "Undead" Then
					GUICtrlSetData($Class, $Undead[Random(1, 5, 1) ])
				ElseIf $GetRaceH = "Blood Elf" Then
					GUICtrlSetData($Class, $BloodElf[Random(1, 6, 1) ])
				Else
					If $GetRaceH = "Tauren" Then
						GUICtrlSetData($Class, $Tauren[Random(1, 4, 1) ])
					ElseIf $GetRaceH = "Troll" Then
						GUICtrlSetData($Class, $Troll[Random(1, 6, 1) ])
					Else
						If $GetRaceH = "Orc" Then
							GUICtrlSetData($Class, $Orc[Random(1, 5, 1) ])
						EndIf
					EndIf
				EndIf
				;----HORDE----;
				;--Alliance--;
				$GetRaceA = GUICtrlRead($Race)
				If $GetRaceA = "Night Elf" Then
					GUICtrlSetData($Class, $NightElf[Random(1, 5, 1) ])
				ElseIf $GetRaceA = "Gnome" Then
					GUICtrlSetData($Class, $Gnome[Random(1, 4, 1) ])
				Else
					If $GetRaceA = "Human" Then
						GUICtrlSetData($Class, $Human[Random(1, 6, 1) ])
					ElseIf $GetRaceA = "Draenei" Then
						GUICtrlSetData($Class, $Draenei[Random(1, 6, 1) ])
					Else
						If $GetRaceA = "Dwarf" Then
							GUICtrlSetData($Class, $Dwarf[Random(1, 5, 1) ])
						EndIf
					EndIf
				EndIf
				;--Alliance--;
			Else
				$GetFaction = GUICtrlRead($Faction)
				If $GetFaction = "Horde" Then
					GUICtrlSetData($Race, $HRaceList[Random(1, 4, 1) ])
				Else
					GUICtrlSetData($Race, $ARaceList[Random(1, 4, 1) ])
				EndIf
				;----HORDE----;
				$GetRaceH = GUICtrlRead($Race)
				If $GetRaceH = "Undead" Then
					GUICtrlSetData($Class, $Undead[Random(1, 5, 1) ])
				ElseIf $GetRaceH = "Tauren" Then
					GUICtrlSetData($Class, $Tauren[Random(1, 4, 1) ])
				Else
					If $GetRaceH = "Troll" Then
						GUICtrlSetData($Class, $Troll[Random(1, 6, 1) ])
					ElseIf $GetRaceH = "Orc" Then
						GUICtrlSetData($Class, $Orc[Random(1, 5, 1) ])
					EndIf
				EndIf
				;----HORDE----;
				;--Alliance--;
				$GetRaceA = GUICtrlRead($Race)
				If $GetRaceA = "Night Elf" Then
					GUICtrlSetData($Class, $NightElf[Random(1, 5, 1) ])
				ElseIf $GetRaceA = "Gnome" Then
					GUICtrlSetData($Class, $Gnome[Random(1, 4, 1) ])
				Else
					If $GetRaceA = "Human" Then
						GUICtrlSetData($Class, $Human[Random(1, 6, 1) ])
					ElseIf $GetRaceA = "Dwarf" Then
						GUICtrlSetData($Class, $Dwarf[Random(1, 5, 1) ])
					EndIf
				EndIf
				;--Alliance--;
			EndIf
		Case $GenName
			GUICtrlSetData($Name, $NameList[Random(1, 12, 1) ] & $NameList1[Random(1, 4, 1) ] & $NameList2[Random(1, 12, 1) ]) ; Generates a random name from the array list
	EndSwitch
WEnd