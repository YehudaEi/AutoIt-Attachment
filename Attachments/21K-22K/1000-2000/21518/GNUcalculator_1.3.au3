HotKeySet ("q", "PAUSE")

#include <GUIConstants.au3>
#Include <Constants.au3>

Opt("TrayMenuMode",1)
Opt("GUICloseOnESC", 1)

#Region TRAYitem
$aboutitem	= TrayCreateItem("Donate")
TrayCreateItem("")
$exititem	= TrayCreateItem("Exit")

While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $aboutitem
			Msgbox(64, "Donate:", "GeekS on D2JSP")
		Case $msg = $exititem
			Exit
	EndSelect
WEnd
#EndRegion

#Region ### START Koda GUI section ### Form=
$FormMenu = GUICreate("Gnu's little helper", 457, 376, 263, 271)
$Amazon = GUICtrlCreateButton("Amazon", 16, 24, 113, 41, $BS_BITMAP)
GUICtrlSetImage (-1, @WorkingDir&"\Images\Ama.bmp")
GUICtrlSetTip(-1,"Amazon informations")
$Assassin = GUICtrlCreateButton("Assassin", 16, 72, 113, 41, $BS_BITMAP)
GUICtrlSetImage (-1, @WorkingDir&"\Images\Assa.bmp")
GUICtrlSetTip(-1,"Assassin informations")
$Necromancer = GUICtrlCreateButton("Necromancer", 16, 120, 113, 41, $BS_BITMAP)
GUICtrlSetImage (-1, @WorkingDir&"\Images\Nec.bmp")
GUICtrlSetTip(-1,"Necromancer informations")
$Barbarian = GUICtrlCreateButton("Barbarian", 16, 168, 113, 41, $BS_BITMAP)
GUICtrlSetImage (-1, @WorkingDir&"\Images\Barb.bmp")
GUICtrlSetTip(-1,"Barbarian informations")
$Paladin = GUICtrlCreateButton("Paladin", 16, 216, 113, 41, $BS_BITMAP)
GUICtrlSetImage (-1, @WorkingDir&"\Images\Pala.bmp")
GUICtrlSetTip(-1,"Paladin informations")
$Sorceress = GUICtrlCreateButton("Sorceress", 16, 264, 113, 41, $BS_BITMAP)
GUICtrlSetImage (-1, @WorkingDir&"\Images\Sorc.bmp")
GUICtrlSetTip(-1,"Sorceress informations")
$Druid = GUICtrlCreateButton("Druid", 16, 312, 113, 41, $BS_BITMAP)
GUICtrlSetImage (-1, @WorkingDir&"\Images\Druid.bmp")
GUICtrlSetTip(-1,"Druid informations")
$CharExit = GUICtrlCreateButton("Exit", 392, 312, 50, 50, 0)
$Slider1 = GUICtrlCreateSlider(128, 320, 265, 33)
GUICtrlSetLimit(-1,10,0)
$Label1 = GUICtrlCreateLabel("Gnu-donation bar", 216, 352, 86, 17)
$Group1 = GUICtrlCreateGroup("Gnu's little helper.", 280, 16, 153, 137)
$Radio1 = GUICtrlCreateRadio("Welcome", 304, 48, 113, 17)
$Radio2 = GUICtrlCreateRadio("Velkommen", 304, 72, 113, 17)
$Radio3 = GUICtrlCreateRadio("Wilkommen", 304, 96, 113, 17)
$Radio4 = GUICtrlCreateRadio("Konochiha", 304, 120, 113, 17)
$contextmenu	= GUICtrlCreateContextMenu ()
$cry		= GUICtrlCreateMenuitem ("Cry", $contextmenu)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$Msg = 0
While 1
	$Msg = GUIGetMsg()
	
	Select
		 Case $msg = $Amazon
#Region ### START Koda GUI section ### Form=
$FormAmazon = GUICreate("Amazon", 633, 447, 285, 315)
$Button1 = GUICtrlCreateButton("FCR Bps", 528, 16, 89, 33, 0)
$Button2 = GUICtrlCreateButton("FHR Bps", 528, 56, 89, 33, 0)
$Button3 = GUICtrlCreateButton("FBR Bps 1hand", 528, 96, 89, 33, 0)
$Button5 = GUICtrlCreateButton("Exit", 520, 376, 97, 57, 0)
$Label1 = GUICtrlCreateLabel("Amazon", 16, 16, 42, 17)
$Button4 = GUICtrlCreateButton("FBR Bps 2hand", 528, 136, 89, 33, 0)
$Group1 = GUICtrlCreateGroup("Helm", 128, 56, 49, 89)
$Input1 = GUICtrlCreateInput("Fcr", 136, 72, 33, 21)
$Input2 = GUICtrlCreateInput("Fhr", 136, 96, 33, 21)
$Input3 = GUICtrlCreateInput("Res", 136, 120, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Amulet", 184, 56, 49, 89)
$Input4 = GUICtrlCreateInput("Fcr", 192, 72, 33, 21)
$Input5 = GUICtrlCreateInput("Fhr", 192, 96, 33, 21)
$Input6 = GUICtrlCreateInput("Res", 192, 120, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("Weapon", 72, 160, 49, 89)
$Input7 = GUICtrlCreateInput("Fcr", 80, 176, 33, 21)
$Input8 = GUICtrlCreateInput("Fhr", 80, 200, 33, 21)
$Input9 = GUICtrlCreateInput("Res", 80, 224, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group5 = GUICtrlCreateGroup("Armor", 128, 160, 49, 89)
$Input10 = GUICtrlCreateInput("Fcr", 136, 176, 33, 21)
$Input11 = GUICtrlCreateInput("Fhr", 136, 200, 33, 21)
$Input12 = GUICtrlCreateInput("Res", 136, 224, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group6 = GUICtrlCreateGroup("Off-hand", 184, 160, 49, 89)
$Input13 = GUICtrlCreateInput("Fcr", 192, 176, 33, 21)
$Input14 = GUICtrlCreateInput("Fhr", 192, 200, 33, 21)
$Input15 = GUICtrlCreateInput("Res", 192, 224, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group7 = GUICtrlCreateGroup("Gloves", 16, 264, 49, 89)
$Input16 = GUICtrlCreateInput("Fcr", 24, 280, 33, 21)
$Input17 = GUICtrlCreateInput("Fhr", 24, 304, 33, 21)
$Input18 = GUICtrlCreateInput("Res", 24, 328, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group8 = GUICtrlCreateGroup("Ring 1", 72, 264, 49, 89)
$Input19 = GUICtrlCreateInput("Fcr", 80, 280, 33, 21)
$Input20 = GUICtrlCreateInput("Fhr", 80, 304, 33, 21)
$Input21 = GUICtrlCreateInput("Res", 80, 328, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group9 = GUICtrlCreateGroup("Belt", 128, 264, 49, 89)
$Input22 = GUICtrlCreateInput("Fcr", 136, 280, 33, 21)
$Input23 = GUICtrlCreateInput("Fhr", 136, 304, 33, 21)
$Input24 = GUICtrlCreateInput("Res", 136, 328, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group10 = GUICtrlCreateGroup("Ring 2", 184, 264, 49, 89)
$Input25 = GUICtrlCreateInput("Fcr", 192, 280, 33, 21)
$Input26 = GUICtrlCreateInput("Fhr", 192, 304, 33, 21)
$Input27 = GUICtrlCreateInput("Res", 192, 328, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group11 = GUICtrlCreateGroup("Boots", 240, 264, 49, 89)
$Input28 = GUICtrlCreateInput("Fcr", 248, 280, 33, 21)
$Input29 = GUICtrlCreateInput("Fhr", 248, 304, 33, 21)
$Input30 = GUICtrlCreateInput("Res", 248, 328, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group12 = GUICtrlCreateGroup("Charms", 88, 368, 129, 41)
$Input31 = GUICtrlCreateInput("Fcr", 96, 384, 33, 21)
$Input32 = GUICtrlCreateInput("Fhr", 136, 384, 33, 21)
$Input33 = GUICtrlCreateInput("Res", 176, 384, 33, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button6 = GUICtrlCreateButton("Your stats", 256, 184, 81, 57, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


$Msg = 0
While 1
	$Msg = GUIGetMsg()
	
	Select
		Case $msg = $GUI_EVENT_CLOSE
			GuiDelete ($FormAmazon)	
		 Case $msg = $Button1
			MsgBox(0,"", "FCR Bps for Amazon is: 0, 7, 14, 22, 32, 48, 68, 99, 152", 5)
		 Case $msg = $Button2
			MsgBox(0,"", "FHR Bps for Amazon is: 0, 6, 13, 20, 32, 52, 86, 174, 600", 5)
		 Case $msg = $Button3
			MsgBox(0,"", "FBR Bps for Amazon 1hand is: 0, 4, 6, 11, 15, 23, 29, 40, 56, 80, 120, 200, 480", 5)
		 Case $msg = $Button5
			GuiDelete ($FormAmazon)
		 Case $msg = $Button4
			MsgBox(0,"", "FBR Bps for Amazon 2hand is: 0, 13, 32, 86, 600", 5)			
		Case $msg = $Button6

;; FCR CALCULATIONS
;; ;0 7 14 22 32 48 68 99 152 
$FCRHelm = GUICtrlRead($Input1)
$FCRAmulet = GUICtrlRead($Input4)
$FCRWeapon = GUICtrlRead($Input7)
$FCRArmor = GUICtrlRead($Input10)
$FCRShield = GUICtrlRead($Input13)
$FCRGloves = GUICtrlRead($Input16)
$FCRRing1 = GUICtrlRead($Input19)
$FCRBelt = GUICtrlRead($Input22)
$FCRRing2 = GUICtrlRead($Input25)
$FCRBoots = GUICtrlRead($Input28)
$FCRCharms = GUICtrlRead($Input31)

$FCRTotal = $FCRHelm + $FCRAmulet + $FCRWeapon + $FCRArmor + $FCRShield + $FCRGloves + $FCRRing1 + $FCRBelt + $FCRRing2 + $FCRBoots + $FCRCharms

Dim $l[10] = ["",0,7,14,22,32,48,68,99,152]
$FCRBreakPoint = 152
For $i = 1 to 8
    If $FCRTotal >= $l[$i] And $FCRTotal < $l[$i + 1] Then $FCRBreakPoint = $l[$i]
Next

;; GUI READ TIL ANDEN COMMAND -- FHR

$FHRHelm = GUICtrlRead($Input2)
$FHRAmulet = GUICtrlRead($Input5)
$FHRWeapon = GUICtrlRead($Input8)
$FHRArmor = GUICtrlRead($Input11)
$FHRShield = GUICtrlRead($Input14)
$FHRGloves = GUICtrlRead($Input17)
$FHRRing1 = GUICtrlRead($Input20)
$FHRBelt = GUICtrlRead($Input23)
$FHRRing2 = GUICtrlRead($Input26)
$FHRBoots = GUICtrlRead($Input29)
$FHRCharms = GUICtrlRead($Input32)

$FHRTotal = $FHRHelm + $FHRAmulet + $FHRWeapon + $FHRArmor + $FHRShield + $FHRGloves + $FHRRing1 + $FHRBelt + $FHRRing2 + $FHRBoots + $FHRCharms

Dim $l[10] = ["", 0, 6, 13, 20, 32, 52, 86, 174, 600]
$FHRBreakPoint = 600
For $i = 1 to 8
    If $FHRTotal >= $l[$i] And $FHRTotal < $l[$i + 1] Then $FHRBreakPoint = $l[$i]
	Next
	
;; GUI READ TIL ANDEN COMMAND -- PRISMA

$RESHelm = GUICtrlRead($Input3)
$RESAmulet = GUICtrlRead($Input6)
$RESWeapon = GUICtrlRead($Input9)
$RESArmor = GUICtrlRead($Input12)
$RESShield = GUICtrlRead($Input15)
$RESGloves = GUICtrlRead($Input18)
$RESRing1 = GUICtrlRead($Input21)
$RESBelt = GUICtrlRead($Input24)
$RESRing2 = GUICtrlRead($Input27)
$RESBoots = GUICtrlRead($Input30)
$RESCharms = GUICtrlRead($Input33)

$RESTotal = $RESHelm + $RESAmulet + $RESWeapon + $RESArmor + $RESShield + $RESGloves + $RESRing1 + $RESBelt + $RESRing2 + $RESBoots + $RESCharms 

$RESHell = $RESTotal -100

#Region ### START Koda GUI section ### Form=C:\Documents and Settings\Lasse\Skrivebord\koda_1.7.0.1\Forms\Infoscreen.kxf
$FormStats = GUICreate("Stats", 273, 185, 191, 121)
$Group1 = GUICtrlCreateGroup("Your stats", 8, 8, 257, 169)
$Label1 = GUICtrlCreateLabel("Your faster cast rate:", 16, 24, 102, 17)
$Label2 = GUICtrlCreateLabel("Your faster cast rate breakpoint:", 16, 40, 155, 17)
$Label3 = GUICtrlCreateLabel("Your faster hit recovery:", 16, 80, 116, 17)
$Label4 = GUICtrlCreateLabel("Your faster hit recovery breakpoint:", 16, 96, 169, 17)
$Label5 = GUICtrlCreateLabel("Your all resistance:", 16, 136, 93, 17)
$Label6 = GUICtrlCreateLabel("Your all resistance on hell:", 16, 152, 127, 17)
$Label7 = GUICtrlCreateLabel($FCRTotal, 200, 24, 25, 17)
$Label8 = GUICtrlCreateLabel($FCRBreakpoint, 200, 40, 42, 17)
$Label9 = GUICtrlCreateLabel($FHRTotal, 200, 80, 26, 17)
$Label10 = GUICtrlCreateLabel($FHRBreakPoint, 200, 96, 43, 17)
$Label11 = GUICtrlCreateLabel($RESTotal, 200, 136, 26, 17)
$Label12 = GUICtrlCreateLabel($RESHell, 200, 152, 47, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			GuiDelete ($FormStats)
	EndSwitch
WEnd
	EndSelect
WEnd
		 Case $msg = $Assassin
#Region ### START Koda GUI section ### Form=
$FormAssassin = GUICreate("Form3", 633, 447, 285, 315)
$Button1 = GUICtrlCreateButton("FCR Bps", 528, 16, 89, 33, 0)
$Button2 = GUICtrlCreateButton("FHR Bps", 528, 56, 89, 33, 0)
$Button3 = GUICtrlCreateButton("FBR Bps", 528, 96, 89, 33, 0)
$Button5 = GUICtrlCreateButton("Exit", 520, 376, 97, 57, 0)
$Label1 = GUICtrlCreateLabel("Assassin", 16, 16, 45, 17)
$Button6 = GUICtrlCreateButton("Button6", 32, 144, 193, 249, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$Msg = 0
While 1
	$Msg = GUIGetMsg()
	
	Select
		         Case $msg = $GUI_EVENT_CLOSE
			ExitLoop	
		 Case $msg = $Button1
			MsgBox(0,"", "FCR Bps for Assassin is: 0, 8, 16, 27, 42, 65, 102, 174", 5)
		 Case $msg = $Button2
			MsgBox(0,"", "FHR Bps for Assassin is: 0, 7, 15, 27, 48, 86, 200", 5)
		 Case $msg = $Button3
			MsgBox(0,"", "FBR Bps for Assassin is: 0, 13, 32, 86, 600", 5)
		 Case $msg = $Button5
			GUIDelete ($FormAssassin)
		Case $msg = $Button6
	EndSelect
WEnd
		 Case $msg = $Necromancer
#Region ### START Koda GUI section ### Form=
$FormNecromancer = GUICreate("Form3", 633, 447, 285, 315)
$Button1 = GUICtrlCreateButton("FCR Bps", 528, 16, 89, 33, 0)
$Button2 = GUICtrlCreateButton("FCR Bps TO", 528, 56, 89, 33, 0)
$Button3 = GUICtrlCreateButton("FHR Bps", 528, 96, 89, 33, 0)
$Button5 = GUICtrlCreateButton("Exit", 520, 376, 97, 57, 0)
$Label1 = GUICtrlCreateLabel("Necromancer", 16, 16, 70, 17)
$Button6 = GUICtrlCreateButton("Button6", 32, 144, 193, 249, 0)
$Button4 = GUICtrlCreateButton("FBR Bps", 528, 136, 89, 33, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$Msg = 0
While 1
	$Msg = GUIGetMsg()
	
	Select
		         Case $msg = $GUI_EVENT_CLOSE
			GUIDelete ($FormNecromancer)	
		 Case $msg = $Button1
			MsgBox(0,"", "FCR Bps for Necromancer is: 0, 9, 18, 30, 48, 75, 125", 5)
		 Case $msg = $Button2
			MsgBox(0,"", "FCR Bps for Necromancer TO is: 0 6 11 18 24 35 48 65 86 120 180", 5)
		 Case $msg = $Button3
			MsgBox(0,"", "FHR Bps for Necromancer is: 0, 5, 10, 16, 26, 39, 56, 86, 152, 377", 5)
		 Case $msg = $Button5
			GUIDelete ($FormNecromancer)
		Case $msg = $Button4
			MsgBox(0,"", "FBR Bps for Necromancer is: 0, 6, 13, 20, 32, 52, 86, 174, 600", 5)
		Case $msg = $Button6
	EndSelect
WEnd
		 Case $msg = $Barbarian
#Region ### START Koda GUI section ### Form=
$FormBarbarian = GUICreate("Form3", 633, 447, 285, 315)
$Button1 = GUICtrlCreateButton("FCR Bps", 528, 16, 89, 33, 0)
$Button2 = GUICtrlCreateButton("FHR Bps", 528, 56, 89, 33, 0)
$Button3 = GUICtrlCreateButton("FBR Bps", 528, 96, 89, 33, 0)
$Button5 = GUICtrlCreateButton("Exit", 520, 376, 97, 57, 0)
$Label1 = GUICtrlCreateLabel("Barbarian", 16, 16, 49, 17)
$Button6 = GUICtrlCreateButton("Button6", 32, 144, 193, 249, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$Msg = 0
While 1
	$Msg = GUIGetMsg()
	
	Select
		         Case $msg = $GUI_EVENT_CLOSE
			GUIDelete ($FormBarbarian)	
		 Case $msg = $Button1
			MsgBox(0,"", "FCR Bps for Barbarian is: 0, 9, 20, 37, 63, 105, 200", 5)
		 Case $msg = $Button2
			MsgBox(0,"", "FHR Bps for Barbarian is: 0, 7, 15, 27, 48, 86, 200", 5)
		 Case $msg = $Button3
			MsgBox(0,"", "FBR Bps for Barbarian is: 0, 9, 20, 42, 86, 280", 5)
		 Case $msg = $Button5
			GUIDelete ($FormBarbarian)
		Case $msg = $Button6
	EndSelect
WEnd
		 Case $msg = $Paladin
#Region ### START Koda GUI section ### Form=
$FormPaladin = GUICreate("Form3", 633, 447, 285, 315)
$Button1 = GUICtrlCreateButton("FCR Bps", 528, 16, 89, 33, 0)
$Button2 = GUICtrlCreateButton("FHR Bps Spear", 528, 56, 89, 33, 0)
$Button3 = GUICtrlCreateButton("FHR Bps", 528, 96, 89, 33, 0)
$Button5 = GUICtrlCreateButton("Exit", 520, 376, 97, 57, 0)
$Label1 = GUICtrlCreateLabel("Paladin", 16, 16, 39, 17)
$Button6 = GUICtrlCreateButton("Button6", 32, 144, 193, 249, 0)
$Button4 = GUICtrlCreateButton("FBR Bps", 528, 136, 89, 33, 0)
$Button7 = GUICtrlCreateButton("FBR Bps HS", 528, 176, 89, 33, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$Msg = 0
While 1
	$Msg = GUIGetMsg()
	
	Select
		         Case $msg = $GUI_EVENT_CLOSE
			GUIDelete ($FormPaladin)	
		 Case $msg = $Button1
			MsgBox(0,"", "FCR Bps for Paladin is: 0, 9, 18, 30, 48, 75, 125", 5)
		 Case $msg = $Button2
			MsgBox(0,"", "FHR Bps for Paladin Spear is: 0, 3, 7, 13, 20, 32, 48, 75, 120, 280", 5)
		 Case $msg = $Button3
			MsgBox(0,"", "FBR Bps for Paladin is: 0, 7, 15, 27, 48, 86, 200", 5)
		 Case $msg = $Button5
			GUIDelete ($FormPaladin)
		 Case $msg = $Button4
			MsgBox(0,"", "FBR Bps for Paladin is: 0, 13, 32, 86, 600", 5)
		Case $msg = $Button7
			MsgBox(0,"", "FBR Bps for Paladin HS is: 0, 86", 5)
		Case $msg = $Button6
	EndSelect
WEnd
		 Case $msg = $Sorceress
#Region ### START Koda GUI section ### Form=
$FormSorceress = GUICreate("Form3", 633, 447, 285, 315)
$Button1 = GUICtrlCreateButton("FCR Bps", 528, 16, 89, 33, 0)
$Button2 = GUICtrlCreateButton("FCR Bps Light", 528, 56, 89, 33, 0)
$Button3 = GUICtrlCreateButton("FHR Bps", 528, 96, 89, 33, 0)
$Button5 = GUICtrlCreateButton("Exit", 520, 376, 97, 57, 0)
$Label1 = GUICtrlCreateLabel("Sorceress", 16, 16, 51, 17)
$Button6 = GUICtrlCreateButton("Button6", 32, 144, 193, 249, 0)
$Button4 = GUICtrlCreateButton("FBR Bps", 528, 136, 89, 33, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$Msg = 0
While 1
	$Msg = GUIGetMsg()
	
	Select
		         Case $msg = $GUI_EVENT_CLOSE
			GUIDelete ($FormSorceress)	
		 Case $msg = $Button1
			MsgBox(0,"", "FCR Bps for Sorceress is: 0, 9, 20, 37, 63, 105, 200", 5)
		 Case $msg = $Button2
			MsgBox(0,"", "FCR Bps for Sorceress is: 0, 7, 15, 23, 37, 52, 78, 117", 5)
		 Case $msg = $Button3
			MsgBox(0,"", "FBR Bps for Sorceress is: 0, 7, 15, 27, 48, 86, 200", 5)
		 Case $msg = $Button5
			GUIDelete ($FormSorceress)
		Case $msg = $Button4
			MsgBox(0,"", "FBR Bps for Sorceress is: 0, 7, 15, 27, 48, 86, 200", 5)
		Case $msg = $Button6
	EndSelect
WEnd
		 Case $msg = $Druid
#Region ### START Koda GUI section ### Form=
$FormDruid = GUICreate("Form3", 633, 447, 285, 315)
$Button1 = GUICtrlCreateButton("FCR Bps Human", 528, 16, 89, 33, 0)
$Button2 = GUICtrlCreateButton("FCR Bps Wolf", 528, 56, 89, 33, 0)
$Button3 = GUICtrlCreateButton("FCR Bps Bear", 528, 96, 89, 33, 0)
$Button5 = GUICtrlCreateButton("Exit", 520, 376, 97, 57, 0)
$Label1 = GUICtrlCreateLabel("Druid", 16, 16, 29, 17)
$Button6 = GUICtrlCreateButton("Button6", 32, 144, 193, 249, 0)
$Button4 = GUICtrlCreateButton("FHR Bps 1hand", 528, 136, 89, 33, 0)
$Button7 = GUICtrlCreateButton("FHR Bps 2hand", 528, 176, 89, 33, 0)
$Button8 = GUICtrlCreateButton("FHR Bps Wolf", 528, 216, 89, 33, 0)
$Button9 = GUICtrlCreateButton("FHR Bps Bear", 528, 256, 89, 33, 0)
$Button10 = GUICtrlCreateButton("FBR Bps Human", 528, 296, 89, 33, 0)
$Button11 = GUICtrlCreateButton("FBR Bps Wolf", 432, 16, 89, 33, 0)
$Button12 = GUICtrlCreateButton("FBR Bps Bear", 432, 56, 89, 33, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$Msg = 0
While 1
	$Msg = GUIGetMsg()
	
	Select
		         Case $msg = $GUI_EVENT_CLOSE
			GUIDelete ($FormDruid)	
		 Case $msg = $Button1
			MsgBox(0,"", "FCR Bps for Druid Human is: 0, 4, 10, 19, 30, 46, 68, 99, 163", 5)
		 Case $msg = $Button2
			MsgBox(0,"", "FCR Bps for Druid Wolf is: 0, 6, 14, 26, 40, 60, 95, 157", 5)
		 Case $msg = $Button3
			MsgBox(0,"", "FCR Bps for Druid Bear is: 0, 7, 15, 26, 40, 63, 99, 163", 5)
		 Case $msg = $Button5
			GUIDelete ($FormDruid)
		Case $msg = $Button4
			MsgBox(0,"", "FHR Bps for Druid 1hand  is: 0, 3, 7, 13, 19, 29, 42, 63, 99, 174, 456", 5)
		Case $msg = $Button7
			MsgBox(0,"", "FHR Bps for Druid 2hand is: 0, 5, 10, 16, 26, 39, 56, 86, 152, 377", 5)
		Case $msg = $Button8
			MsgBox(0,"", "FHR Bps for Druid Wolf is: 0, 9, 20, 42, 86, 280", 5)
		Case $msg = $Button9
			MsgBox(0,"", "FHR Bps for Druid Bear is: 0, 5, 10, 16, 24, 37, 54, 86, 152, 360", 5)
		Case $msg = $Button10
			MsgBox(0,"", "FBR Bps for Druid Human is: 0, 6, 13, 20, 32, 52, 86, 174, 600", 5)
		Case $msg = $Button11
			MsgBox(0,"", "FBR Bps for Druid Wolf is: 0, 7, 15, 27, 48, 86, 200", 5)
		Case $msg = $Button12
			MsgBox(0,"", "FBR Bps for Druid Bear is: 0, 5, 10, 16, 27, 40, 65, 109, 223", 5)
		Case $msg = $Button6
	EndSelect
WEnd
		 Case $msg = $CharExit
			 If GUICtrlRead($slider1) = 10 Then 
				 Exit
				 EndIf
			 MsgBox (0, "Cant exit", "You cant leave before you donated some more.")
;			 MsgBox (1, "Cant exit", "You cant leave before you donated some more.")
         Case $msg = $GUI_EVENT_CLOSE
			Exit			
	EndSelect
WEnd

Func PAUSE()
Exit
EndFunc

;#Region ### START Koda GUI section ### Form=
;$Form3 = GUICreate("Form3", 633, 447, 320, 248)
;$Button1 = GUICtrlCreateButton("FCR Bps", 528, 16, 89, 33, 0)
;$Button2 = GUICtrlCreateButton("FHR Bps", 528, 56, 89, 33, 0)
;$Button3 = GUICtrlCreateButton("FBR Bps", 528, 96, 89, 41, 0)
;$Button5 = GUICtrlCreateButton("Exit", 520, 376, 97, 57, 0)
;$Label1 = GUICtrlCreateLabel("Amazon", 16, 16, 42, 17)
;$Button6 = GUICtrlCreateButton("Button6", 32, 144, 193, 249, 0)
;GUISetState(@SW_SHOW)
;#EndRegion ### END Koda GUI section ###
;$Msg = 0
;While 1
;	$Msg = GUIGetMsg()
;	
;	Select
;		 Case $msg = $Button1
;			MsgBox(0,"", "FCR Bps for Amazon is: 7, 1,2, ,345,13, 513,45 1,345 ,135 ,1354", 5)
;		 Case $msg = $Button2
;			MsgBox(0,"", "FHR Bps for Amazon is: 7, 1,2, ,345,13, 513,45 1,345 ,135 ,1354", 5)
;		 Case $msg = $Button3
;			MsgBox(0,"", "FBR Bps for Amazon is: 7, 1,2, ,345,13, 513,45 1,345 ,135 ,1354", 5)
;		 Case $msg = $Button5
;			Exit
;		Case $msg = $Button6
;	EndSelect
;WEnd