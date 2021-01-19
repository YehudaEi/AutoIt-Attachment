#include <GUIConstants.au3>
#include <Array.au3>

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


$Main = GUICreate("WoW Character Generator", 521, 92)
$Gender = GUICtrlCreateInput("Gender", 8, 16, 121, 21)
$Faction = GUICtrlCreateInput("Faction", 136, 16, 121, 21)
$Race = GUICtrlCreateInput("Race", 264, 16, 121, 21)
$Class = GUICtrlCreateInput("Class", 392, 16, 121, 21)
$Generate = GUICtrlCreateButton("Generate", 208, 48, 107, 25, 0)
$Expansion = GUICtrlCreateCheckbox("Burning Crusade", 10, 70)
$About = GUICtrlCreateLabel("?", 510, 75, 15, 15)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $About
			MsgBox(32, "About", "Don't know what character you want to make next? " & @CRLF & "Let WoW Character Generator decide for you! It gives you a Gender, Faction, Race and Class!" & @CRLF & @CRLF & "Made by alien13 -                       ")
		Case $Generate
			GUICtrlSetData($Gender, $GenderList[Random(1, 2, 1) ])
			GUICtrlSetData($Faction, $FactionList[Random(1, 2, 1) ])
			If GUICtrlRead($Expansion) = 1 Then
				$GetFaction = GUICtrlRead($Faction)
				If $GetFaction = "Horde" Then
					GUICtrlSetData($Race, $HRaceListBC[Random(1, 5, 1) ])
				Else
					GUICtrlSetData($Race, $ARaceListBC[Random(1, 5, 1) ])
				EndIf
				$GetRaceH = GUICtrlRead($Race)
				;----HORDE----;
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
	EndSwitch
WEnd