#comments-start
-------------------------------------------------------------------------------
Name:   	Build Auto Installer
Purpose: 	This script will install the Avistar product the user selects
Author:      Robin Siebler
Created:     6/1/2012
Version:     0.2
-------------------------------------------------------------------------------
#comments-end

; Includes
#include<file.au3>
#include<array.au3>
#include<date.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)

; Variables
Global $Branch, $Product, $Type, $Options, $Component, $BuildFolder
Local $IniFile = @ScriptDir & "\Build_Auto_Installer.ini"
Local $ConfigData = IniReadSection($IniFile, "Config")

$BuildFolder = "\\hqfile04\Build\releases"

;----------------------- Build Selection Dialog ----------------------------------------
#Region ### START Koda GUI section ### Form=f:\scripts\autoit\build auto installer\buildselectiondialog.kxf
$Form1 = GUICreate("Build Auto Installer", 297, 261, 194, 154, BitXOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MINIMIZEBOX))
GUISetIcon("F:\scripts\AutoIt\Build Auto Installer\avistar.ico", -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Label1 = GUICtrlCreateLabel("Please choose from the below options to install a build:", 16, 32, 261, 17, 0)
$Label2 = GUICtrlCreateLabel("Branch:", 40, 56, 41, 17, 0)
$Label3 = GUICtrlCreateLabel("Product:", 40, 88, 44, 17, 0)
$Label4 = GUICtrlCreateLabel("Type:", 40, 120, 31, 17, 0)
$Label5 = GUICtrlCreateLabel("Options:", 40, 152, 43, 17, 0)
$CB_Branch = GUICtrlCreateCombo("", 88, 56, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $ConfigData[1][1])
$CB_Product = GUICtrlCreateCombo("", 88, 88, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $ConfigData[2][1])
$CB_Type = GUICtrlCreateCombo("", 88, 120, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $ConfigData[4][1])
$CB_Options = GUICtrlCreateCombo("", 88, 152, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $ConfigData[5][1])
$Btn_OK = GUICtrlCreateButton("OK", 72, 208, 49, 25, $BS_NOTIFY)
GUICtrlSetOnEvent($Btn_OK, "SetBuildOptions")
$Btn_Cancel = GUICtrlCreateButton("Cancel", 144, 208, 49, 25, $BS_NOTIFY)
GUICtrlSetOnEvent($Btn_Cancel, "ProcessCancel")
GUISetState(@SW_SHOW, $Form1)
#EndRegion ### END Koda GUI section ###

;----------------------- Component Selection Dialog ----------------------------------------
#Region ### START Koda GUI section ### Form=F:\scripts\AutoIt\Build Auto Installer\ComponentSelectionDialog.kxf
$Form2 = GUICreate("Select Component", 228, 145, 194, 470, BitXOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MINIMIZEBOX))
GUISetIcon("F:\scripts\AutoIt\Build Auto Installer\avistar.ico", -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form2Close")
$Label1 = GUICtrlCreateLabel("Select the component to install:", 24, 16, 152, 17)
$CB_Component = GUICtrlCreateCombo("", 40, 40, 113, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData($CB_Component, "RTME|RTC")
$Btn_OK_2 = GUICtrlCreateButton("OK", 40, 88, 49, 25)
GUICtrlSetOnEvent($Btn_OK_2, "Btn_OK_2Click")
$Btn_Cancel_2 = GUICtrlCreateButton("Cancel", 112, 88, 49, 25)
GUICtrlSetOnEvent($Btn_Cancel_2, "ProcessCancel")
#EndRegion ### END Koda GUI section ###

$Loop = 1
While $Loop
	Sleep(100)
WEnd

$NewDir = NewestFolder($BuildFolder)
If @error Then	; If NewestFolder() didn't error out, report the newest directory, otherwise, report the error.
    MsgBox(8240, 'Error', 'No folders in directory')
	Exit
EndIf

Exit

; ----------------------------- Functions ---------------------------
; Get the build options provided by the user
Func SetBuildOptions()
	$Branch = GUICtrlRead($CB_Branch)
	$Product = GUICtrlRead($CB_Product)
	$Type = GUICtrlRead($CB_Type)
	$Options = GUICtrlRead($CB_Options)
	; Check to see if the user failed to select any options
	If $Branch == "" Or $Product = "" Or $Type = "" Or $Options = "" Then
		MsgBox(8208, "Missing Selection!", "Please choose an option from each ComboBox!")
		Return
	EndIf
	GUIDelete($Form1)
	$Loop = 0	; If all of the options have been selected, exit the loop
	If $Product = "Citrix HDX" Then
		GUISetState(@SW_SHOW, $Form2)
		$Loop = 1
		While $Loop = 1
			Sleep(100)
		WEnd
	EndIf
EndFunc

; The user clicked the Cancel button
Func ProcessCancel()
	$RtnVal = MsgBox(8228, "Cancel Installation?", "Are you sure you want to cancel the installation?")
	If $RtnVal = 6 Then Exit	; Yes was clicked
EndFunc


; Find the newest folder in the build directory
Func NewestFolder($Directory)
    $aFolders = _FileListToArray($Directory, '*', 2); Get a list of all the single level sub-folders in a specific folder
    If Not IsArray($aFolders) Then	; Check if we didn't find any folders, and return 0 with @error = 1 if we do not
        SetError(1)
        Return 0
    EndIf
    _ArrayDelete($aFolders, 0)	; Remove the first entry containing the total number of entries
    Dim $aEPOCH[UBound($aFolders)][2]	; Create a 2d array to hold epoch time and the folder names
    For $a = 0 To UBound($aFolders) - 1
        $aTime = FileGetTime($Directory & '\' & $aFolders[$a], 1, 0)	; Get time folder was created in an array ($aTime)
        $aEPOCH[$a][0] = _DateDiff('s', "1970/01/01 00:00:00", $aTime[0] & '/' & $aTime[1] & '/' & $aTime[2] & ' ' & $aTime[3] & ':' & $aTime[4] & ':' & $aTime[5])	; Convert to Epoch time
        $aEPOCH[$a][1] = $aFolders[$a]	; Store directory name
    Next
    _ArraySort($aEPOCH, 1)	; Sort the $aEPOCH array by EPOCH time, so index 0 contains the newest item
    Return $aEPOCH[0][1]	; Return the newest items directory name
EndFunc


Func Form1Close()
	ProcessCancel()
EndFunc

Func Btn_OK_2Click()
	$Component = GUICtrlRead($CB_Component)
	If $Component == "" Then
		MsgBox(8208, "Missing Component!", "Please select a component!")
		Return
	EndIf
	GUISetState(@SW_HIDE, $Form2)
	$Loop = 0	; If all of the options have been selected, close the dialog
EndFunc


Func Form2Close()
	ProcessCancel()
EndFunc