#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=AuditSearch_1.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GuiConstants.au3>
#include <String.au3>

opt("GUICloseOnESC", 1)
opt("TrayOnEventMode", 1)

Dim $location, $servername, $username

$Window = GUICreate("Search for Users PC Name", 250, 350)
$combo = GUICtrlCreateCombo("", 20, 50, 150, 20)
$button = GUICtrlCreateButton("Press here to begin search", 20, 250, 200, 40)
$Input1 = GUICtrlCreateInput("", 20, 100, 121, 21)
$Label1 = GUICtrlCreateLabel("Select Office", 20, 30, 150, 20)
$Label2 = GUICtrlCreateLabel("Input Username", 20, 80, 121, 21)
$Edit1 = GUICtrlCreateEdit("", 20, 140, 185, 89)

GUISetState()

$locations = StringSplit("Tulsa,Boston,Fairfax,Chicago,Detroit,Dallas,San Fransico", ",")

For $x = 1 to $locations[0]
	GUICtrlSetData( $combo, $locations[$x])
Next

While 1
	$message = GUIGetMsg()

	If $message = $GUI_EVENT_CLOSE Then Set_Exit()

	If $message = $button Then
		$location = GUICtrlRead( $combo )
		$username = GUICtrlRead( $Input1 )
		location_Function($location)
	EndIf

WEnd


Func location_Function($location)
	If $location = "" Then Return
	$noneselected = "Select a Location"
	Server_Name()
    change_label()
	MsgBox(68, "Search Logs","Search " & $servername & " audit log for user " & $username & " and return login info")
EndFunc


Func Server_Name()
	If $location = "Tulsa" Then
		$servername = "DC1"
		Return
	EndIf
	If $location = "Boston" Then
		$servername = "DC2"
		Return
	EndIf
	If $location = "Fairfax" Then
		$servername = "DC3"
		Return
	EndIf
	If $location = "Chicago" Then
		$servername = "DC4"
		Return
	EndIf
	If $location = "Detroit" Then
		$servername = "DC5"
		Return
	EndIf
	If $location = "Dallas" Then
		$servername = "DC6"
		Return
	EndIf
	If $location = "San Fransico" Then
		$servername = "DC7"
		Return
	EndIf
EndFunc

Func change_label()
	GUICtrlSetData($Edit1, $username & "'s login info:")
EndFunc

Func Set_Exit()
	MsgBox(0,"","Good-Bye",1)
	Exit
EndFunc
