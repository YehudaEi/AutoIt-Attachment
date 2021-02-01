#include <GUIConstants.au3>
#include <Array.au3>

Opt("TrayIconDebug", 1)
AutoItSetOption ( "CaretCoordMode", 2 )
AutoItSetOption ( "MouseCoordMode", 2 )
AutoItSetOption ( "PixelCoordMode", 2 )
HotKeySet("{HOME}", "startbot")
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{END}", "stop")
Dim $Paused

$statsfile=Fileopen("itemstats.txt",1)
Global $oRP = ObjCreate("ShockwaveFlash.ShockwaveFlash.1")
GUICreate ("Flash", 820, 700, -1, -1)
$GUIActiveX    = GUICtrlCreateObj( $oRP, 10, 10 , 800 , 580)
; Other variables

Dim $start=0

; Getlifemana()
Dim $charid,$lifeleft,$manaleft,$totallife,$totalmana,$procentmonsterlife

; Monster()

Dim $expdown,$exp,$charlevel
$charlevel=1
$exp=0

; ini file definitions
$minlife=IniRead("config.ini","Standaard","Minimumlifepercentage","-1")
$minmana=IniRead("config.ini","Standaard","Minimummanapercentage","-1")
$leaveatlife=IniRead("config.ini","Standaard","LeaveAtLife","-1")
$leaveatlifediff=IniRead("config.ini","Standaard","MaxLifeDiff","-1")
$plek=IniRead("config.ini","Standaard","Plek","-1")
$hit=IniRead("config.ini","Standaard","Hit","-1")
$spell=IniRead("config.ini","Standaard","Spell","-1")
$stoplvlup=IniRead("config.ini","Standaard","Stoplvlup","-1")
$dropsleep=IniRead("config.ini","Standaard","DropSleep","-1")
$acc=IniRead("config.ini","Standaard","Account","-1")
$pass=IniRead("config.ini","Standaard","Password","-1")
$goldpass=IniRead("config.ini","Standaard","GoldPassword","-1")
If $stoplvlup<>"" AND $stoplvlup>0 Then
Else
$stoplvlup=100
$charlvl=100
Endif

; check for errors in ini file
If $plek=-1 OR $hit=$spell OR $goldpass="" OR $pass="" OR $acc="" OR $dropsleep="" Then
Msgbox(0,"error", "couldnt read ini file or theres some wrong definitiona or you want to hit and use a spell at the same time look at your config.ini file")
EndIf

; check location character
Dim $charplek[2]
Select
	Case $plek=1
	$charplek[0]=149
	$charplek[1]=36
	Case $plek=2
	$charplek[0]=414
	$charplek[1]=36
	Case $plek=3
	$charplek[0]=149
	$charplek[1]=85
	Case $plek=4
	$charplek[0]=414
	$charplek[1]=85
	Case $plek=5
	$charplek[0]=140
	$charplek[1]=130
	Case $plek=6
	$charplek[0]=414
	$charplek[1]=130

EndSelect

; variables for drops
Dim $EnhancedEffect[4],$Strength[4],$Dexterity[4],$Vitality[4],$Intelligence[4],$MaxLife[4],$MaxMana[4],$ExperienceGained[4],$MagicLuck[4],$LifeRegen[4],$ManaRegen[4]
Dim $ExtraItemSlots[4],$CriticalStrike[4],$LifeperAttack[4],$ManaperAttack[4],$LifeperKill[4],$ManaperKill[4],$LifeSteal[4],$DamageReturned[4],$MindNumb[4],$ArmorPierce[4]
Dim $Block[4],$CriticalFlux[4],$PhysicalDamageReduction[4],$MagicalDamageReduction[4],$ManaSyphon[4],$QuickDraw[4],$ManaConsumption[4],$HealMastery[4],$ManaSkin[4],$PowerShot[4],$GlancingBlow[4],$Jubilance[4]

; variables itemstats

Dim $statsarray[33][4],$totalstats[4],$tier[4],$lvlreq[4],$pickup[4],$item[4],$itemclass[4]

; array item definitions

Dim $statsnames[13]

$statsnames[1]="Magical"
$statsnames[2]="Rare"
$statsnames[3]="Mystical"
$statsnames[4]="Angelic"
$statsnames[5]="Mythical"
$statsnames[6]="Arcane"
$statsnames[7]="Legendary"
$statsnames[8]="Godly"
$statsnames[9]="Epic"
$statsnames[10]="Relic"
$statsnames[11]="Artifact"
$statsnames[12]="Unique"


Dim $itemdefinitions[10][5]

;Weapons
$itemdefinitions[0][0]="Sword"
$itemdefinitions[1][0]="Club"
$itemdefinitions[2][0]="Axe"
$itemdefinitions[3][0]="Dagger"
$itemdefinitions[4][0]="Staff"
$itemdefinitions[5][0]="Longsword"
$itemdefinitions[6][0]="Warhammer"
$itemdefinitions[7][0]="Battleaxe"
$itemdefinitions[8][0]="Spear"
$itemdefinitions[9][0]="Polearm"
;Armors
$itemdefinitions[0][1]="Robe"
$itemdefinitions[1][1]="Padded Robe"
$itemdefinitions[2][1]="Leather Armor"
$itemdefinitions[3][1]="Scale Armor"
$itemdefinitions[4][1]="Chain Mail"
$itemdefinitions[5][1]="Plate Mail"
;Charms
$itemdefinitions[0][2]="Ice"
$itemdefinitions[1][2]="Fire"
$itemdefinitions[2][2]="Lightning"
$itemdefinitions[3][2]="Wind"
$itemdefinitions[4][2]="Earth"
$itemdefinitions[5][2]="Wild Heal"
$itemdefinitions[6][2]="Heal"
$itemdefinitions[7][2]="Focused Heal"
;Items
$itemdefinitions[0][3]="Fish"
$itemdefinitions[1][3]="Glyph"
$itemdefinitions[2][3]="Comfrey"
$itemdefinitions[3][3]="Potion"
$itemdefinitions[4][3]="Totem"
;Objects
$itemdefinitions[0][4]="Fishing Rod"

Dim $itemmaterials[14][7]

;Metal
$itemmaterials[0][0]="Rusted"
$itemmaterials[1][0]="Copper"
$itemmaterials[2][0]="Bronze"
$itemmaterials[3][0]="Iron"
$itemmaterials[4][0]="Steel"
$itemmaterials[5][0]="Alloy"
$itemmaterials[6][0]="Fine Alloy"
$itemmaterials[7][0]="Mithril"
$itemmaterials[8][0]="Sapphire"
$itemmaterials[9][0]="Adamantium"
$itemmaterials[10][0]="Diamond"
$itemmaterials[11][0]="Tempered-Diamond"
$itemmaterials[12][0]="Tintinanium"
$itemmaterials[13][0]="Ultimanium"

;Wood
$itemmaterials[0][1]="Splintered"
$itemmaterials[1][1]="Pine"
$itemmaterials[2][1]="Elm"
$itemmaterials[3][1]="Oak"
$itemmaterials[4][1]="Ironwood"
$itemmaterials[5][1]="Heartwood"
$itemmaterials[6][1]="Runewood"
$itemmaterials[7][1]="Stonewood"
$itemmaterials[8][1]="Ebonwood"
$itemmaterials[9][1]="Drywood"
$itemmaterials[10][1]="Darkwood"
$itemmaterials[11][1]="Steelwood"
$itemmaterials[12][1]="Angelwood"
$itemmaterials[13][1]="Godwood"

;Leather
$itemmaterials[0][2]="Patched"
$itemmaterials[1][2]="Rawhide"
$itemmaterials[2][2]="Tanned"
$itemmaterials[3][2]="Cured"
$itemmaterials[4][2]="Hard"
$itemmaterials[5][2]="Double cured"
$itemmaterials[6][2]="Rigid"
$itemmaterials[7][2]="Embossed"
$itemmaterials[8][2]="Imbued"
$itemmaterials[9][2]="Runed"
$itemmaterials[10][2]="Enchanted"
$itemmaterials[11][2]="Tempered"
$itemmaterials[12][2]="Encrested"
$itemmaterials[13][2]="Fine honed"

;Cloth
$itemmaterials[0][3]="Tattered"
$itemmaterials[1][3]="Cotton"
$itemmaterials[2][3]="Woolen"
$itemmaterials[3][3]="Linen"
$itemmaterials[4][3]="Brocade"
$itemmaterials[5][3]="Silk"
$itemmaterials[6][3]="Gossamer"
$itemmaterials[7][3]="Elvan"
$itemmaterials[8][3]="Seamist"
$itemmaterials[9][3]="Nightshade"
$itemmaterials[10][3]="Wyvernskin"
$itemmaterials[11][3]="Silksteel"
$itemmaterials[12][3]="Pixiesilk"
$itemmaterials[13][3]="Spiderthread"

;Bone
$itemmaterials[0][4]="Cracked"
$itemmaterials[1][4]="Steel Leaf"
$itemmaterials[2][4]="Bone"
$itemmaterials[3][4]="Bine"
$itemmaterials[4][4]="Shell"
$itemmaterials[5][4]="Dragonbone"
$itemmaterials[6][4]="Fossil"
$itemmaterials[7][4]="Amber"
$itemmaterials[8][4]="Coral"
$itemmaterials[9][4]="Chitin"
$itemmaterials[10][4]="Fossilized"
$itemmaterials[11][4]="Crystallized"
$itemmaterials[12][4]="Petrified"
$itemmaterials[13][4]="Dragon skull"

;Numeral
$itemmaterials[0][5]="I"
$itemmaterials[1][5]="II"
$itemmaterials[2][5]="III"
$itemmaterials[3][5]="IV"
$itemmaterials[4][5]="V"
$itemmaterials[5][5]="VI"
$itemmaterials[6][5]="VII"
$itemmaterials[7][5]="VIII"
$itemmaterials[8][5]="IX"
$itemmaterials[9][5]="X"
$itemmaterials[10][5]="XI"
$itemmaterials[11][5]="XII"
$itemmaterials[12][5]="XIII"
$itemmaterials[13][5]="XIV"

;Fish
$itemmaterials[0][6]="Sardine"
$itemmaterials[1][6]="Herring"
$itemmaterials[2][6]="Cod"
$itemmaterials[3][6]="Trout"
$itemmaterials[4][6]="Bass"
$itemmaterials[5][6]="Salmon"
$itemmaterials[6][6]="Catfish"
$itemmaterials[7][6]="Pike"
$itemmaterials[8][6]="Tuna"
$itemmaterials[9][6]="Mackerel"
$itemmaterials[10][6]="Grouper"
$itemmaterials[11][6]="Sturgeon"
$itemmaterials[12][6]="Swordfish"
$itemmaterials[13][6]="Marlin"

;~~~~ Item Definitions Materials
; -1 means they dont have any material

Dim $itemdefmats[10][5]
;Weapons
$itemdefmats[0][0]=0
$itemdefmats[1][0]=1
$itemdefmats[2][0]=0
$itemdefmats[3][0]=0
$itemdefmats[4][0]=1
$itemdefmats[5][0]=0
$itemdefmats[6][0]=1
$itemdefmats[7][0]=0
$itemdefmats[8][0]=0
$itemdefmats[9][0]=0
;Armors
$itemdefmats[0][1]=3
$itemdefmats[1][1]=3
$itemdefmats[2][1]=2
$itemdefmats[3][1]=4
$itemdefmats[4][1]=0
$itemdefmats[5][1]=0
;Charms
$itemdefmats[0][2]=5
$itemdefmats[1][2]=5
$itemdefmats[2][2]=5
$itemdefmats[3][2]=5
$itemdefmats[4][2]=5
$itemdefmats[5][2]=5
$itemdefmats[6][2]=5
$itemdefmats[7][2]=5
;Items
$itemdefmats[0][3]=6
$itemdefmats[1][3]=5
$itemdefmats[2][3]=-1
$itemdefmats[3][3]=4
$itemdefmats[4][3]=1
;Objects
$itemdefmats[0][4]=-1





; variables main program
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Dim $timer,$stats,$drops
$text1=GUICtrlCreateLabel("stats:",50,640,400,20)
$text2=GUICtrlCreateLabel("drops:",50,610,100,20)
$statslabel=GUICtrlCreateLabel($stats,100,640,400,20)
$dropslabel=GUICtrlCreateLabel($drops,100,610,40,20)

With $oRP
    .bgcolor = "#ffffff"
    .Movie = 'http://ladderslasher.d2jsp.org/LS.swf'
    .ScaleMode = 2
    .Loop = False
    .wmode = "Opaque"
    .FlashVars = ""
EndWith

GUISetState ()

$timer=TimerInit()
$timerdiff=4000
$expdowntimer=TimerInit()

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Func startbot()
$start=1	
EndFunc

; main loop
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
While 1
	$inlogscherm=Pixelgetcolor(446,107)   ; 0x002985
	$characterselection=PixelGetColor(106,395) ; 0x727272
	$mainscherm=PixelGetColor(416,370) ; 0xAF80DE
	
	$market=PixelGetColor(541,367) ; 0x6E6E8B
	$catacombs=PixelGetColor(572,336) ; 0x878787
	$shrine=PixelGetColor(45,128) ; 0xCCCCCC
	$vault=PixelGetColor(756,273) ; 0x949494
	$fish=PixelGetColor(133,316) ; 0x626281
	$cook=PixelGetColor(137,323) ; 0x8A8AA1
	$glyph=PixelGetColor(120,317) ; 0x717171
	$well=PixelGetColor(194,153) ; 0x4E4E4E
	$transmutebox=PixelGetColor(235,307) ; 0x4D4D71
	$ladder=PixelGetColor(219,78) ; 0x585858
	$chat=PixelGetColor(134,70) ; 0x09093A
	
	$arena=PixelGetColor(373,142) ;0x8B8B8B
	
	$monster=PixelGetColor(700,203) ; 0x6D6D6D
	
	$resummon1=PixelGetColor(148,200) ; 0x7B7B7B
	$resummon2=PixelGetColor(701,201) ; 0x767676


	If (($exp-($charlevel-1)*1000000)/1000000)*100>=93 AND $stoplvlup=$charlevel Then
	$expdown=1
	EndIf

	if $start=1 Then
	
	if (timerdiff($timer)-$timerdiff)>100  Then
	$timerdiff=Timerdiff($timer)
	$stats=$oRP.GetVariable("drops")
	$drops=$oRP.GetVariable("lastMobDrops")
	
    GUICtrlSetData($dropslabel,$drops)
	
	EndIf
	Select
		Case $resummon1=0x7B7B7B AND $resummon2=0x767676
			resummon()
		Case $inlogscherm=0x002985
			inlog()
		Case  $characterselection=0x727272
			characterselect()
		Case $mainscherm=0xAF80DE
			mainscherm()
		Case $market=0x6E6E8B OR $catacombs=0x878787 OR $shrine=0xCCCCCC OR $vault=0x949494 OR $fish=0x8F8FA6 OR $cook=0x8A8AA1 OR $glyph=0x717171 OR $well=0x4E4E4E OR _
			 $transmutebox=0x4D4D71 OR $ladder=0x585858 OR $chat=0x09093A
			fout()
		Case $arena=0x8B8B8B
			arena()
		Case $oRP.GetVariable("inCombat")=1 OR $monster=0x6D6D6D
			monster()
		
	EndSelect
	EndIf
	$msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then
		ExitLoop
	EndIf

WEnd
$oRP = 0

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Func readstats()
$stats=$oRP.GetVariable("drops")
$drops=$oRP.GetVariable("lastMobDrops")
$array=Stringsplit($stats,",")	
If Ubound($array)<8 Then

$pickup[1]=0
$pickup[2]=0
$pickup[3]=0

Else
; ~~ item 1 ~~
$item[1]=$array[6]
$itemclass[1]=$array[7]
$totalstats[1]=$array[9]
$tier[1]=$array[8]
$lvlreq[1]=$array[8]*5-10

If $lvlreq[1]>0 Then
Else
$lvlreq[1]=0
endif

$statsarray[0][0]="EnhancedEffect"
$statsarray[1][0]="Strength"
$statsarray[2][0]="Dexterity"
$statsarray[3][0]="Vitality"
$statsarray[4][0]="Intelligence"
$statsarray[5][0]="MaxLife"
$statsarray[6][0]="MaxMana"
$statsarray[7][0]="ExperienceGained"
$statsarray[8][0]="MagicLuck"
$statsarray[9][0]="LifeRegen"
$statsarray[10][0]="ManaRegen"
$statsarray[11][0]="ExtraItemSlots"
$statsarray[12][0]="CriticalStrike"
$statsarray[13][0]="LifeperAttack"
$statsarray[14][0]="ManaperAttack"
$statsarray[15][0]="LifeperKill"
$statsarray[16][0]="ManaperKill"
$statsarray[17][0]="LifeSteal"
$statsarray[18][0]="DamageReturned"
$statsarray[19][0]="MindNumb"
$statsarray[20][0]="ArmorPierce"
$statsarray[21][0]="Block"
$statsarray[22][0]="CriticalFlux"
$statsarray[23][0]="PhysicalDamageReduction"
$statsarray[24][0]="MagicalDamageReduction"
$statsarray[25][0]="ManaSyphon"
$statsarray[26][0]="QuickDraw"
$statsarray[27][0]="ManaConsumption"
$statsarray[28][0]="Heal Mastery"
$statsarray[29][0]="Mana Skin"
$statsarray[30][0]="Power Shot"
$statsarray[31][0]="Glancing Blow"
$statsarray[32][0]="Jubilance"

$statsarray[0][1]= $array[10]
$statsarray[1][1]= $array[11]
$statsarray[2][1]= $array[12]
$statsarray[3][1]= $array[13]
$statsarray[4][1]= $array[14]
$statsarray[5][1]= $array[15]
$statsarray[6][1]= $array[16]
$statsarray[7][1]= $array[17]
$statsarray[8][1]= $array[18]
$statsarray[9][1]= $array[19]
$statsarray[10][1]= $array[20]
$statsarray[11][1]= $array[21]
$statsarray[12][1]= $array[22]
$statsarray[13][1]= $array[23]
$statsarray[14][1]= $array[24]
$statsarray[15][1]= $array[25]
$statsarray[16][1]= $array[26]
$statsarray[17][1]= $array[27]
$statsarray[18][1]= $array[28]
$statsarray[19][1]= $array[29]
$statsarray[20][1]= $array[30]
$statsarray[21][1]= $array[31]
$statsarray[22][1]= $array[32]
$statsarray[23][1]= $array[33]
$statsarray[24][1]= $array[34]
$statsarray[25][1]= $array[35]
$statsarray[26][1]= $array[36]
$statsarray[27][1]= $array[37]
$statsarray[28][1]= $array[38]
$statsarray[29][1]= $array[39]
$statsarray[30][1]= $array[40]
$statsarray[31][1]= $array[41]
$statsarray[32][1]= $array[42]

$EnhancedEffect[1]=$array[10]
$Strength[1]=$array[11]
$Dexterity[1]=$array[12]
$Vitality[1]=$array[13]
$Intelligence[1]=$array[14]
$MaxLife[1]=$array[15]
$MaxMana[1]=$array[16]
$ExperienceGained[1]=$array[17]
$MagicLuck[1]=$array[18]
$LifeRegen[1]=$array[19]
$ManaRegen[1]=$array[20]
$ExtraItemSlots[1]=$array[21]
$CriticalStrike[1]=$array[22]
$LifeperAttack[1]=$array[23]
$ManaperAttack[1]=$array[24]
$LifeperKill[1]=$array[25]
$ManaperKill[1]=$array[26]
$LifeSteal[1]=$array[27]
$DamageReturned[1]=$array[28]
$MindNumb[1]=$array[29]
$ArmorPierce[1]=$array[30]
$Block[1]=$array[31]
$CriticalFlux[1]=$array[32]
$PhysicalDamageReduction[1]=$array[33]
$MagicalDamageReduction[1]=$array[34]
$ManaSyphon[1]=$array[35]
$QuickDraw[1]=$array[36]
$ManaConsumption[1]=$array[37]
$HealMastery[1]=$array[38]
$ManaSkin[1]=$array[39]
$PowerShot[1]=$array[40]
$GlancingBlow[1]=$array[41]
$Jubilance[1]=$array[42]

$pickup[1]=pickup(1)

If Number($drops)>1 Then
$item[2]=$array[47]
$itemclass[2]=$array[48]
$totalstats[2]=$array[50]
$tier[2]=$array[49]
$lvlreq[2]=$array[49]*5-10	
If $lvlreq[2]>0 Then
Else
$lvlreq[2]=0
endif

$statsarray[0][2]= $array[51]
$statsarray[1][2]= $array[52]
$statsarray[2][2]= $array[53]
$statsarray[3][2]= $array[54]
$statsarray[4][2]= $array[55]
$statsarray[5][2]= $array[56]
$statsarray[6][2]= $array[57]
$statsarray[7][2]= $array[58]
$statsarray[8][2]= $array[59]
$statsarray[9][2]= $array[60]
$statsarray[10][2]= $array[61]
$statsarray[11][2]= $array[62]
$statsarray[12][2]= $array[63]
$statsarray[13][2]= $array[64]
$statsarray[14][2]= $array[65]
$statsarray[15][2]= $array[66]
$statsarray[16][2]= $array[67]
$statsarray[17][2]= $array[68]
$statsarray[18][2]= $array[69]
$statsarray[19][2]= $array[70]
$statsarray[20][2]= $array[71]
$statsarray[21][2]= $array[72]
$statsarray[22][2]= $array[73]
$statsarray[23][2]= $array[74]
$statsarray[24][2]= $array[75]
$statsarray[25][2]= $array[76]
$statsarray[26][2]= $array[77]
$statsarray[27][2]= $array[78]
$statsarray[28][2]= $array[79]
$statsarray[29][2]= $array[80]
$statsarray[30][2]= $array[81]
$statsarray[31][2]= $array[82]
$statsarray[32][2]= $array[83]

$EnhancedEffect[2]=$array[51]
$Strength[2]=$array[52]
$Dexterity[2]=$array[53]
$Vitality[2]=$array[54]
$Intelligence[2]=$array[55]
$MaxLife[2]=$array[56]
$MaxMana[2]=$array[57]
$ExperienceGained[2]=$array[58]
$MagicLuck[2]=$array[59]
$LifeRegen[2]=$array[60]
$ManaRegen[2]=$array[61]
$ExtraItemSlots[2]=$array[62]
$CriticalStrike[2]=$array[63]
$LifeperAttack[2]=$array[64]
$ManaperAttack[2]=$array[65]
$LifeperKill[2]=$array[66]
$ManaperKill[2]=$array[67]
$LifeSteal[2]=$array[68]
$DamageReturned[2]=$array[69]
$MindNumb[2]=$array[70]
$ArmorPierce[2]=$array[71]
$Block[2]=$array[72]
$CriticalFlux[2]=$array[73]
$PhysicalDamageReduction[2]=$array[74]
$MagicalDamageReduction[2]=$array[75]
$ManaSyphon[2]=$array[76]
$QuickDraw[2]=$array[77]
$ManaConsumption[2]=$array[78]
$HealMastery[2]=$array[79]
$ManaSkin[2]=$array[80]
$PowerShot[2]=$array[81]
$GlancingBlow[2]=$array[82]
$Jubilance[2]=$array[83]

$pickup[2]=pickup(2)

EndIf

If Number($Drops)>2 Then
$item[3]=$array[88]
$itemclass[3]=$array[89]	
$totalstats[3]=$array[91]
$tier[3]=$array[90]
$lvlreq[3]=$array[90]*5-10	
If $lvlreq[3]>0 Then
Else
$lvlreq[3]=0
endif


$statsarray[0][3]= $array[92]
$statsarray[1][3]= $array[93]
$statsarray[2][3]= $array[94]
$statsarray[3][3]= $array[95]
$statsarray[4][3]= $array[96]
$statsarray[5][3]= $array[97]
$statsarray[6][3]= $array[98]
$statsarray[7][3]= $array[99]
$statsarray[8][3]= $array[100]
$statsarray[9][3]= $array[101]
$statsarray[10][3]= $array[102]
$statsarray[11][3]= $array[103]
$statsarray[12][3]= $array[104]
$statsarray[13][3]= $array[105]
$statsarray[14][3]= $array[106]
$statsarray[15][3]= $array[107]
$statsarray[16][3]= $array[108]
$statsarray[17][3]= $array[109]
$statsarray[18][3]= $array[110]
$statsarray[19][3]= $array[111]
$statsarray[20][3]= $array[112]
$statsarray[21][3]= $array[113]
$statsarray[22][3]= $array[114]
$statsarray[23][3]= $array[115]
$statsarray[24][3]= $array[116]
$statsarray[25][3]= $array[117]
$statsarray[26][3]= $array[118]
$statsarray[27][3]= $array[119]
$statsarray[28][3]= $array[120]
$statsarray[29][3]= $array[121]
$statsarray[30][3]= $array[122]
$statsarray[31][3]= $array[123]
$statsarray[32][3]= $array[124]

$EnhancedEffect[3]=$array[92]
$Strength[3]=$array[93]
$Dexterity[3]=$array[94]
$Vitality[3]=$array[95]
$Intelligence[3]=$array[96]
$MaxLife[3]=$array[97]
$MaxMana[3]=$array[98]
$ExperienceGained[3]=$array[99]
$MagicLuck[3]=$array[100]
$LifeRegen[3]=$array[101]
$ManaRegen[3]=$array[102]
$ExtraItemSlots[3]=$array[103]
$CriticalStrike[3]=$array[104]
$LifeperAttack[3]=$array[105]
$ManaperAttack[3]=$array[106]
$LifeperKill[3]=$array[107]
$ManaperKill[3]=$array[108]
$LifeSteal[3]=$array[109]
$DamageReturned[3]=$array[110]
$MindNumb[3]=$array[111]
$ArmorPierce[3]=$array[112]
$Block[3]=$array[113]
$CriticalFlux[3]=$array[114]
$PhysicalDamageReduction[3]=$array[115]
$MagicalDamageReduction[3]=$array[116]
$ManaSyphon[3]=$array[117]
$QuickDraw[3]=$array[118]
$ManaConsumption[3]=$array[119]
$HealMastery[3]=$array[120]
$ManaSkin[3]=$array[121]
$PowerShot[3]=$array[122]
$GlancingBlow[3]=$array[123]
$Jubilance[3]=$array[124]

$pickup[3]=pickup(3)

EndIf
EndIf
If Number($Drops)>1 Then

EndIf
Return $pickup

EndFunc

Func pickup($itemid)
; return 1 if item needs to be picked up else 0
if ($totalstats[$itemid]>0 AND $tier[$itemid]>=2) OR ($totalstats[$itemid]=0 AND $lvlreq[$itemid]>=40) Then
WriteStats($itemid)
return 1	
EndIf
	
return 0

EndFunc

Func WriteStats($itemid)
Local $itemmaterial,$itemdef
$itemdef=$itemdefinitions[$itemclass[$itemid]][$item[$itemid]]
$itemmaterial=$itemdefmats[$itemclass[$itemid]][$item[$itemid]]

If $item[$itemid]<>2 Then 
Filewrite($statsfile,$statsnames[$totalstats[$itemid]] & " " & $itemmaterials[$tier[$itemid]][$itemmaterial] & " " & $itemdef & " totalstats:   " & $totalstats[$itemid] & "  lvlreq:   " & $lvlreq[$itemid] & "   -   " & ":" & @HOUR & ":" & @MIN & " " & @CRLF)
Else
Filewrite($statsfile,$statsnames[$totalstats[$itemid]] & " " & $itemdef & " " & $itemmaterials[$tier[$itemid]][$itemmaterial] & " totalstats:   " & $totalstats[$itemid] & "  lvlreq:   " & $lvlreq[$itemid] & "   -   " & ":" & @HOUR & ":" & @MIN & " " & @CRLF)
EndIf
EndFunc

; bot run functions
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Func inlog()
local $inlogtimer,$inlogcharselect
Do
MouseClick("left",542+Random(-10,0,1),298+Random(-1,1,1))    ; click account inputform
sleep(Random(200,400,1))
Send("^a")
sleep(Random(200,400,1))
Send("{BACKSPACE}")
sleep(Random(200,400,1))
Send($acc)
sleep(Random(400,600,1))
MouseClick("left",542+Random(-10,0,1),337+Random(-1,1,1))   ; click password form
sleep(Random(200,400,1))
Send("^a")
sleep(Random(200,400,1))
Send("{BACKSPACE}")
sleep(Random(200,400,1))
Send($pass)
sleep(Random(200,400,1))
MouseClick("left",542+Random(-10,0,1),373+Random(-1,1,1))  ; click gold password form
sleep(Random(200,400,1))
Send("^a")
sleep(Random(200,400,1))
Send("{BACKSPACE}")
sleep(Random(200,400,1))
Send($goldpass)
sleep(Random(600,800,1))
MouseClick("left",419+Random(-40,40,1),414+Random(-1,1,1))  ; login
$inlogtimer=TimerInit()
Do
$inlogcharselect=PixelGetColor(102,393)
sleep(100)
Until TimerDiff($inlogtimer)>10000 OR $inlogcharselect=0x7B7B7B
Until $inlogcharselect=0x7B7B7B
Endfunc

Func characterselect()
sleep(Random(400,600,1))
Mouseclick("left",$charplek[0]+Random(-10,10,1),$charplek[1]+Random(-5,5,1))
sleep(Random(400,600,1))
EndFunc

Func mainscherm()
sleep(Random(200,400,1))
weapon()
sleep(Random(200,400,1))
Mouseclick("left",484+Random(-30,30,1),122+Random(-20,20,1))
sleep(Random(200,400,1))

Endfunc

func weapon()
Select
Case $hit=1 AND $spell=0
mouseclick("left",342+Random(-6,0,1),49)
Case $spell=1 AND $hit=0
Mouseclick("left",367+random(-5,5,1),49+Random(-6,6,1))
Endselect
Endfunc

Func fout()
Select
	Case $market=0x6E6E8B 
		Mouseclick("left",740+Random(-40,40,1),421+Random(-3,3,1))
	Case $catacombs=0x878787 
		Mouseclick("left",625+Random(-40,40,1),341+Random(-3,3,1))
	Case $shrine=0xCCCCCC 
		Mouseclick("left",777+Random(-3,0,1),86+Random(-1,1,1))
		sleep(Random(400,600,1))
		Mouseclick("left",154+Random(-40,40,1),365+Random(-3,3,1))
	Case $vault=0x949494 
		Mouseclick("left",736+Random(-40,40,1),419+Random(-3,3,1))
	Case $cook=0x8A8AA1 
		Mouseclick("left",777+Random(-3,0,1),86+Random(-1,1,1))
		sleep(400)
		Mouseclick("left",409+Random(-40,40,1),379+Random(-3,3,1))
	Case $fish=0x626281
		Mouseclick("left",412+Random(-40,40,1),378+Random(-3,3,1))
	Case $glyph=0x717171 
		Mouseclick("left",777+Random(-3,0,1),86+Random(-1,1,1))
		sleep(400)
		Mouseclick("left",409+Random(-40,40,1),376+Random(-3,3,1))
    Case $well=0x4E4E4E 
		Mouseclick("left",777+Random(-3,0,1),86+Random(-1,1,1))
		sleep(400)
		Mouseclick("left",506+Random(-40,40,1),398+Random(-3,3,1))
    Case $transmutebox=0x4D4D71 
		Mouseclick("left",777+Random(-3,0,1),86+Random(-1,1,1))
		sleep(400)
		Mouseclick("left",472+Random(-40,40,1),306+Random(-3,3,1))
	Case $ladder=0x585858 
		Mouseclick("left",83+Random(-40,40,1),81+Random(-3,3,1))
	Case $chat=0x09093A
		Mouseclick("left",72+Random(-40,40,1),79+Random(-3,3,1))
		
Endselect
sleep(500)
Endfunc

Func getlifemana()
$charid=0;
$charid=$oRP.GetVariable("selC")
$totallife=$oRP.GetVariable("chars." & $charid & ".18")
$totalmana=$oRP.GetVariable("chars." & $charid & ".19")
$lifeleft=$oRP.GetVariable("chars." & $charid & ".20")
$manaleft=$oRP.GetVariable("chars." & $charid & ".21")
$test=$oRP.GetVariable("chars." & $charid)

Tooltip("Life:  " & $lifeleft & "/" & $totallife & "  Mana:  " & $manaleft & "/" & $totalmana & "  Testvalue1:  " & $test,0,0)
	
EndFunc

Func getmonsterlife()
Local $currentmonsterlife[1],$lifepixmonsterteller
$procentmonsterlife=0
$startlifemonster=279
$stoplifemonster=527
$yposmonsterlife=207
For $i= 1 to $stoplifemonster-$startlifemonster
ReDim $currentmonsterlife[$i+1]
$currentmonsterlife[$i]=PixelGetColor($startlifemonster-1+$i,$yposmonsterlife)
If $currentmonsterlife[$i]<>0xFFFFFF Then
$lifepixmonsterteller=$lifepixmonsterteller+1
EndIf
Next
$procentmonsterlife=($lifepixmonsterteller/($stoplifemonster-$startlifemonster))*100

EndFunc


Func arena()
Do
sleep(Random(150,200,1))
getlifemana()

Until (($lifeleft/$totallife)*100>=$minlife AND ($manaleft/$totalmana)*100>=$minmana) OR $oRP.GetVariable("inCombat")=1 OR $expdown=1
$arenatimer=Timerinit()
Do
Mouseclick("left",517+Random(-40,40,1),99+Random(-3,3,1))
sleep(Random(50,150,1))
Until $oRP.GetVariable("inCombat")=1 OR Timerdiff($arenatimer)>10000
EndFunc


Func monster()
Local $mouse[426][266]	
	
If $oRP.GetVariable("inCombat")=1 Then

For $i = 390 to 425 step 5
For $j = 221 To 265 step 5
$mouse[$i][$j]=2
MouseMove($i,$j)
$mouse[$i][$j]=MouseGetCursor()
If $mouse[$i][$j]=0 Then
ExitLoop(2)
EndIf
Next
Next
$timermonster=Timerinit()
$timerexpdown=Timerinit()
Do
if timerdiff($timermonster)>300 Then
	$timermonster=Timerinit()
	getlifemana()
	getmonsterlife()
EndIf
	sleep(Random(30,70,1))
	$inlogscherm=Pixelgetcolor(446,107)   ; 0x002985
	If $expdown=1 AND Timerdiff($timerexpdown)>7000 Then
	$timerexpdown=timerinit()
	mouseclick("left")
	Elseif $expdown=0 Then
	mouseclick("left")
	EndIf
Until $oRP.GetVariable("inCombat")=0 OR $inlogscherm=0x002985 OR (($lifeleft/$totallife)*100<=$leaveatlife AND $expdown=0) OR _
(($procentmonsterlife-($lifeleft/$totallife)*100)>=$leaveatlifediff AND $expdown=0 AND ($lifeleft/$totallife)*100<=75)
if (($lifeleft/$totallife)*100<=$leaveatlife AND $expdown=0) OR (($procentmonsterlife-($lifeleft/$totallife)*100)>=$leaveatlifediff AND $expdown=0 AND ($lifeleft/$totallife)*100<=75) Then
leave()
EndIf
if $expdown=1 Then
Do
sleep(Random(400,500,1))
Mouseclick("left",666+Random(-40,40,1),202+Random(-2,2,1))
$backtotown=Pixelgetcolor(686,203)   ; 0x6D6D6D
$inlogscherm=Pixelgetcolor(446,107)   ; 0x002985
Until $backtotown<>0x6D6D6D OR $inlogscherm=0x002985
$charlevel=$oRP.GetVariable("chars." & $charid & ".5")
$exp=$oRP.GetVariable("chars." & $charid & ".7")
if (($exp-($charlevel-1)*1000000)/1000000)*100<=5 Then
$expdown=0
EndIf

EndIf
sleep(Random($dropsleep,$dropsleep+500,1))
$drops=$oRP.GetVariable("lastMobDrops")
if $drops>0 Then
$monsterdrops=readstats()
if $monsterdrops[1]=1 Then
Mouseclick("left",337+Random(-40,40,1),224+random(-4,4,1))  
sleep(500+Random(-100,100,1))
Mouseclick("left",337+Random(-40,40,1),224+random(-4,4,1))
sleep(200+Random(0,100,1))
EndIf
If $monsterdrops[2]=1 Then
Mouseclick("left",337+random(-10,10,1),251+random(-4,4,1))
sleep(1000+Random(-100,100,1))
Mouseclick("left",337+random(-10,10,1),251+random(-4,4,1))
sleep(200+Random(0,100,1))
EndIf
If $monsterdrops[3]=1 Then
Mouseclick("left",337+random(-10,10,1),277+random(-4,4,1))
sleep(500+Random(-100,100,1))
Mouseclick("left",337+random(-10,10,1),277+random(-4,4,1))
sleep(200+Random(0,100,1))
EndIf

EndIf

EndIf

EndFunc

Func resummon()
	
$charlevel=$oRP.GetVariable("chars." & $charid & ".5")
$exp=$oRP.GetVariable("chars." & $charid & ".7")
if $expdown=1 Then
Mouseclick("left",666+Random(-40,40,1),202+Random(-2,2,1))
sleep(Random(100,200,1))
Else
If (($exp-($charlevel-1)*1000000)/1000000)*100>=93 AND $stoplvlup=$charlevel Then
$expdown=1
Else

Do
getlifemana()
sleep(Random(50,150,1))
Until ($lifeleft/$totallife)*100>=$minlife AND ($manaleft/$totalmana)*100>=$minmana
Mouseclick("left",143+Random(-40,40,1),203+Random(-3,3,1))
EndIf
EndIf
EndFunc

Func leave()
Local $leave
$timerleave=TimerInit()
Do
MouseClick("left",664+Random(-20,20,1),203+Random(-1,1,1))	
$leave=PixelGetColor(675,200)    ; 0x7B7B7B
$inlogscherm=Pixelgetcolor(446,107)   ; 0x002985
sleep(Random(50,120,1))
Until $leave<>0x7B7B7B OR $inlogscherm=0x002985 OR TimerDiff($timerleave)>5000
sleep(Random(1800,2200,1))
EndFunc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Func TogglePause()
$Paused = NOT $Paused
While $Paused
sleep(100)
WEnd
EndFunc

Func Stop()
Exit
Endfunc


