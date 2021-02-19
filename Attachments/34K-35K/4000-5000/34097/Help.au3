#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <File.au3>
#include <Array.au3>
#include <Date.au3>


$GUIRecovery = GUICreate("Test ", 241, 203, 352, 256)
$NextB = GUICtrlCreateButton("Next", 8, 168, 225, 33, BitOR($BS_DEFPUSHBUTTON,$WS_GROUP), $WS_EX_STATICEDGE)
$PDROP = GUICtrlCreateCombo("", 28, 32, 97, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($PDROP, "Asus|Clevo|Dell|Fujitsu|HP|LG|Lenovo|MSI|Medion|Packard Bell|Samsung|Sony|Toshiba|Zepto|")
$OSDROP = GUICtrlCreateCombo("Win7", 128, 88, 97, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($OSDROP, "Vista|XP")
$RLabel = GUICtrlCreateLabel(" Model Nr:", 128, 120, 99, 17, $SS_CENTER)
$PNAVN = GUICtrlCreateLabel("Vælg PC Proucent", 128, 9, 101, 17)
$OSL = GUICtrlCreateLabel("Vælg OS Version", 128, 64, 94, 17)
$PDROPSTATE = GUICtrlRead($PDROP,1)
$OSDROPSTATE = GUICtrlRead($OSDROP,1)
If $PDROPSTATE = "Acer" Then
$DskName = GUICtrlCreateInput("", 128, 136, 105, 21,-1)
GUICtrlSetLimit($DskName, 5,4)
EndIf
If $PDROPSTATE = "HP" Then
$DskName = GUICtrlCreateInput("", 128, 136, 105, 21,-1)
GUICtrlSetLimit($DskName, 10,4)
EndIf



GUISetState()

While 1

	 $Msg = GUIGetMsg()

			If $Msg = $GUI_Event_close Then
				Exit
				EndIf

			If $Msg = $NextB Then
				Exit
			EndIf

WEnd