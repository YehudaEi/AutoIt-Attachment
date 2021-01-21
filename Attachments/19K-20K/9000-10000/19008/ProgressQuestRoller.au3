#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Lej

 Script Function:
	Progress Quest Roller.

#ce ----------------------------------------------------------------------------

#include <Misc.au3>
#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=e:\linus\autoit\progressquestroller.kxf
$Form1_1 = GUICreate("PQRoll", 137, 255, 193, 125)
$Label1 = GUICtrlCreateLabel("Total", 8, 200, 28, 17)
$Label2 = GUICtrlCreateLabel("STR", 8, 32, 26, 17)
$Label3 = GUICtrlCreateLabel("CON", 8, 56, 27, 17)
$Label4 = GUICtrlCreateLabel("DEX", 8, 80, 26, 17)
$Label5 = GUICtrlCreateLabel("INT", 8, 104, 22, 17)
$Label6 = GUICtrlCreateLabel("WIS", 8, 128, 25, 17)
$Label7 = GUICtrlCreateLabel("CHA", 8, 152, 26, 17)
$Input1 = GUICtrlCreateInput("", 40, 196, 32, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input2 = GUICtrlCreateInput("", 40, 28, 32, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input3 = GUICtrlCreateInput("", 40, 52, 32, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input4 = GUICtrlCreateInput("", 40, 76, 32, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input5 = GUICtrlCreateInput("", 40, 100, 32, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input6 = GUICtrlCreateInput("", 40, 124, 32, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input7 = GUICtrlCreateInput("", 40, 148, 32, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input8 = GUICtrlCreateInput("0", 96, 196, 32, 21)
$Input9 = GUICtrlCreateInput("0", 96, 28, 32, 21)
$Input10 = GUICtrlCreateInput("0", 96, 52, 32, 21)
$Input11 = GUICtrlCreateInput("0", 96, 76, 32, 21)
$Input12 = GUICtrlCreateInput("0", 96, 100, 32, 21)
$Input13 = GUICtrlCreateInput("0", 96, 124, 32, 21)
$Input14 = GUICtrlCreateInput("0", 96, 148, 32, 21)
$Label8 = GUICtrlCreateLabel(">=", 76, 200, 10, 17)
$Label9 = GUICtrlCreateLabel(">=", 76, 32, 10, 17)
$Label10 = GUICtrlCreateLabel(">=", 76, 56, 10, 17)
$Label11 = GUICtrlCreateLabel(">=", 76, 80, 10, 17)
$Label12 = GUICtrlCreateLabel(">=", 76, 104, 10, 17)
$Label13 = GUICtrlCreateLabel(">=", 76, 128, 10, 17)
$Label14 = GUICtrlCreateLabel(">=", 76, 152, 10, 17)
$Label15 = GUICtrlCreateLabel("Current", 40, 8, 38, 17)
$Label16 = GUICtrlCreateLabel("Want", 96, 8, 30, 17)
$Roll = GUICtrlCreateButton("Roll", 24, 224, 89, 25, 0)
GUICtrlSetOnEvent(-1, "RollClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUISetOnEvent($GUI_EVENT_CLOSE,"Bye")

Global $tot
Global $str
Global $con
Global $dex
Global $int
Global $wis
Global $cha

Global $totWant
Global $strWant
Global $conWant
Global $dexWant
Global $intWant
Global $wisWant
Global $chaWant

$dllUser32 = DllOpen("user32.dll")

While 1
	Sleep(100)
WEnd

Func RollClick()
	GUICtrlSetData($Roll, "TAB to cancel")
	WantsDisable()
	WantsSet()

	$wHandle = WinGetHandle("Progress Quest - New Character")
	If @error Then
		MsgBox(-1, "Error", "Could not find New Character window")
	EndIf
	WinActivate($wHandle)

	Do
		ControlClick($wHandle,"","TButton5")
		StatsGet($wHandle)
		StatsShow()
	Until _IsPressed("09",$dllUser32) Or ($str >= $strWant)
	
	WantsEnable()
	
	GUICtrlSetData($Roll, "Roll")
	
EndFunc

Func StatsGet($wHandle)
	$tot = ControlGetText($wHandle, "", "TPanel1")
	$str = ControlGetText($wHandle, "", "TPanel2")
	$con = ControlGetText($wHandle, "", "TPanel3")
	$dex = ControlGetText($wHandle, "", "TPanel4")
	$int = ControlGetText($wHandle, "", "TPanel5")
	$wis = ControlGetText($wHandle, "", "TPanel6")
	$cha = ControlGetText($wHandle, "", "TPanel7")
EndFunc

Func StatsShow()
	GUICtrlSetData($Input1, $tot)
	GUICtrlSetData($Input2, $str)
	GUICtrlSetData($Input3, $con)
	GUICtrlSetData($Input4, $dex)
	GUICtrlSetData($Input5, $int)
	GUICtrlSetData($Input6, $wis)
	GUICtrlSetData($Input7, $cha)
EndFunc

Func WantsSet()
	$totWant = GUICtrlRead($Input8)
	$strWant = GUICtrlRead($Input9)
	$conWant = GUICtrlRead($Input10)
	$dexWant = GUICtrlRead($Input11)
	$intWant = GUICtrlRead($Input12)
	$wisWant = GUICtrlRead($Input13)
	$chaWant = GUICtrlRead($Input14)
EndFunc

Func WantsDisable()
	GUICtrlSetState($Input8, $GUI_DISABLE)
	GUICtrlSetState($Input9, $GUI_DISABLE)
	GUICtrlSetState($Input10, $GUI_DISABLE)
	GUICtrlSetState($Input11, $GUI_DISABLE)
	GUICtrlSetState($Input12, $GUI_DISABLE)
	GUICtrlSetState($Input13, $GUI_DISABLE)
	GUICtrlSetState($Input14, $GUI_DISABLE)
EndFunc

Func WantsEnable()
	GUICtrlSetState($Input8, $GUI_ENABLE)
	GUICtrlSetState($Input9, $GUI_ENABLE)
	GUICtrlSetState($Input10, $GUI_ENABLE)
	GUICtrlSetState($Input11, $GUI_ENABLE)
	GUICtrlSetState($Input12, $GUI_ENABLE)
	GUICtrlSetState($Input13, $GUI_ENABLE)
	GUICtrlSetState($Input14, $GUI_ENABLE)
EndFunc

Func Bye()
	DllClose($dllUser32)
	Exit
EndFunc
	
