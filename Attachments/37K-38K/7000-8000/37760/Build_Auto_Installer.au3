#comments-start
-------------------------------------------------------------------------------
Name:       Build Auto Installer
Purpose:    This script will install the Avistar product the user selects
Author:      Robin Siebler
Created:     6/1/2012
Version:     0.3
-------------------------------------------------------------------------------
#comments-end

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=avistar.ico
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Includes
#include <file.au3>
#include <array.au3>
#include <date.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIExtender.au3>

Opt("GUIOnEventMode", 1)
TraySetIcon(@ScriptDir & "\avistar.ico", -1)

; Variables
Global $BaseFolder, $Branch, $BuildFolder, $BuildFound, $BuildNo, $BuildType, $Component, $EXE, $NewestDir, $Options, $Product, $Type
Local $IniFile = @ScriptDir & "\Build_Auto_Installer.ini"
Local $ConfigData = IniReadSection($IniFile, "Config")

$BaseFolder = "\\hqfile04\Build\releases"

;----------------------- Build Selection Dialog ----------------------------------------
#Region ### START Koda GUI section ### Form=c:\scripts\autoit\build_auto_installer\buildselectiondialog.kxf
$Form1 = GUICreate("Build Auto Installer", 297, 285)
GUISetIcon(@ScriptDir & "avistar.ico", -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "ProcessCancel")

_GUIExtender_Init($Form1) ; Initialise the GUI
GUICtrlCreateLabel("Please choose from the below options to install a build:", 16, 32, 261, 17, 0)
GUICtrlCreateLabel("Branch:", 40, 56, 41, 17, 0)
$CB_Branch = GUICtrlCreateCombo("", 100, 56, 145, 25)
GUICtrlSetData(-1, $ConfigData[1][1])
GUICtrlCreateLabel("Product:", 40, 88, 44, 17, 0)
$CB_Product = GUICtrlCreateCombo("", 100, 88, 145, 25)
GUICtrlSetOnEvent($CB_Product, "CB_ProductChange")
GUICtrlSetData(-1, $ConfigData[2][1])

$1stSection = _GUIExtender_Section_Start(105, 25) ; Create section
_GUIExtender_Section_Action($1stSection) ; Make it dynamic
GUICtrlCreateLabel("Component:", 40, 120, 58, 17, 0)
$CB_Component = GUICtrlCreateCombo("", 100, 120, 145, 25)
GUICtrlSetData(-1, $ConfigData[3][1])
_GUIExtender_Section_End() ; Close section

$2ndSection = _GUIExtender_Section_Start(130, 150) ; Everything else goes in another section
GUICtrlCreateLabel("Type:", 40, 148, 31, 17, 0)
$CB_Type = GUICtrlCreateCombo("", 100, 148, 145, 25)
GUICtrlSetData(-1, $ConfigData[4][1])
GUICtrlCreateLabel("Options:", 40, 180, 43, 17, 0)
$CB_Options = GUICtrlCreateCombo("", 100, 180, 145, 25)
GUICtrlSetData(-1, $ConfigData[5][1])
$Btn_OK = GUICtrlCreateButton("OK", 83, 225, 49, 25, $BS_NOTIFY)
GUICtrlSetOnEvent($Btn_OK, "GetBuildOptions")
$Btn_Cancel = GUICtrlCreateButton("Cancel", 171, 225, 49, 25, $BS_NOTIFY)
GUICtrlSetOnEvent($Btn_Cancel, "ProcessCancel")
_GUIExtender_Section_End() ; Close section
_GUIExtender_Section_Extend($1stSection, False) ; Close the dynamic section

GUISetState(@SW_SHOW, $Form1)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=c:\scripts\autoit\build_auto_installer\SpecifyBuildNumber.kxf
$Form2 = GUICreate("Specify Build Number", 298, 262)
GUISetIcon(@ScriptDir & "avistar.ico", -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "ProcessCancel")
$Input1 = GUICtrlCreateInput("", 83, 48, 129, 21, $ES_NUMBER)
GUICtrlSetLimit($Input1, 3, 3)
GUICtrlCreateGroup("Build Type", 70, 88, 161, 57)
$Radio1 = GUICtrlCreateRadio("Released", 75, 112, 65, 17)
GUICtrlSetTip($Radio1, "Non 99.99.99 Build Number")
GUICtrlSetOnEvent($Radio1, "Radio1Click")
$Radio2 = GUICtrlCreateRadio("Trunk", 155, 112, 57, 17)
GUICtrlSetTip($Radio2, "99.99.99 Build Number")
GUICtrlSetOnEvent($Radio2, "Radio2Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Input2 = GUICtrlCreateInput("", 83, 176, 129, 21)
GUICtrlSetState($Input2, $GUI_HIDE)
;GUICtrlSetOnEvent($Input2, "Input2Change")
$Label2 = GUICtrlCreateLabel("Enter the Release Version Number:", 59, 152, 170, 17)
GUICtrlSetState($Label2, $GUI_HIDE)
$Btn_OK_2 = GUICtrlCreateButton("OK", 76, 216, 57, 25)
GUICtrlSetOnEvent($Btn_OK_2, "Btn_OK_2Click")
$Btn_Cancel_2 = GUICtrlCreateButton("Cancel", 164, 216, 57, 25)
GUICtrlSetOnEvent($Btn_Cancel_2, "ProcessCancel")
GUICtrlCreateLabel("Please enter the 3 digit build number:", 59, 24, 178, 17)
#EndRegion ### END Koda GUI section ###

$Loop = 1
While $Loop     ; Wait for Build Selection Dialog to close
    Sleep(100)
WEnd

If Not ($Product = "Citrix HDX") Then
	MsgBox(8240, 'Configuration Error!', 'This install configuration is not implemented yet!')
	Exit
EndIf

;UninstallProduct()
Select
	Case $Options = "Install the latest build"
		DetermineBuildFolder()

	Case $Options = "Install a specific version"
		FindSpecificBuild()
	Case $Options = "Browse for an installer"
		BrowseForInstaller()
EndSelect
;InstallProduct()
MsgBox(8256, "Installation Complete!", "The installation is complete!")
Exit

; ----------------------------- Functions ---------------------------
; Browse for the installer
Func BrowseForInstaller()
EndFunc

; Find the latest build
Func DetermineBuildFolder($recurse = 0)		; $recurse will be set to 1 by FindPreviousBuild when a previous build folder is found
	If $recurse = 0 Then $BuildFolder = $BaseFolder & "\" & $Branch		; 1st time through, point to the correct build path

	If $NewestDir = "" Then												; 1st time through, get the Newest Folder
		$NewestDir = NewestFolder($BuildFolder)
		If @error Then  ; If NewestFolder() didn't error out, report the newest directory, otherwise, report the error.
			MsgBox(8240, 'Navigation Error', 'No folders were found in ' & $BuildFolder)
			Exit
		Else
			$BuildFolder = $BuildFolder & "\" & $NewestDir & "\" & $Type & "\windows"	; a folder was found
		EndIf
	Else
			If $BuildNo = "" Then															; recurse, a Build No hasn't been found
				$BuildFolder = $BuildFolder & "\" & $NewestDir & "\" & $Type & "\windows"
			Else																			; there is a Build No to check
				$BuildFolder = $BuildFolder & "\" & $Type & "\windows"
			EndIf
	EndIf
	$RtnVal = FileFindFirstFile($BuildFolder & "\" & $Product & "\" & $EXE)		; Look for the Installer in the Product folder
	If Not ($RtnVal = -1) Then 													; Found the Installer
		$BuildFolder = $BuildFolder & "\" & $Product
		If Not ($BuildNo = "") Then $BuildFound = True
	Else																		; See if there is an Experimental folder
		$RtnVal = FileFindFirstFile($BuildFolder & "\Experimental\" & $Product & "\" & $EXE)
		If Not ($RtnVal = -1) Then 												; Found the Installer in the Experimental Product folder
			$BuildFolder = $BuildFolder & "\Experimental\" & $Product
			If Not ($BuildNo = "") Then $BuildFound = True						; Found the Previous Build
		Else
			MsgBox(8240, "Missing Build!", "There was no " & $Product & " folder in " & _
			$BuildFolder & " and there is no Experimental folder either. " & _
			" This probably means there is no windows installer for this build." & _
			@CRLF & @CRLF & "The script will now try to find the previous release.")
			FindPreviousBuild()	; Look for the Previous Build
		EndIf
	EndIf
EndFunc

; Look for the Previous Build No
Func FindPreviousBuild()
	; Get the actual number part of the Build Folder
	Dim $aBuild = StringSplit($NewestDir, "-", 2)
	$BuildNo = $aBuild[1]
	If IsInt($BuildNo) Then
		MsgBox(8240, "Navigation Error!", "I should have a build number, but I do not!")
	EndIf
	$BuildNo = $BuildNo - 1	; Previous Build No
	$BuildNo = $aBuild[0] & "-" & $BuildNo
	$BuildFolder = $BaseFolder & "\" & $Branch & "\" & $BuildNo
	$RtnVal = FileFindFirstFile($BuildFolder)
	If Not ($RtnVal = -1) Then 				; This build number was skipped
		DetermineBuildFolder(1)
	Else
		$NewestDir = $BuildNo
		FindPreviousBuild()
	EndIf
EndFunc

; Find the user specified build
Func FindSpecificBuild()

	; Full Build version example = 1.0.3r-575 (release) - 99.99.99r-575 (internal)
	GUISetState(@SW_SHOW, $Form2)
	$Loop = 1
	While $Loop     ; Wait for Build Selection Dialog to close
		Sleep(100)
	WEnd

	If $BuildType = "Released" Then
		$BuildNo = GUICtrlRead($Input2) & "-" & $BuildNo
	Else
		$BuildNo = "99.99.99r-" & $BuildNo
	EndIf
	$BuildFolder = $BaseFolder & "\" & $Branch & "\" & $BuildNo & "\" & $Type & "\windows"
	MsgBox(0, "", $BuildFolder)
	$RtnVal = FileFindFirstFile($BuildFolder & "\" & $Product & "\" & $EXE)		; Look for the Installer in the Product folder
	If Not ($RtnVal = -1) Then 													; Found the Installer
		$BuildFolder = $BuildFolder & "\" & $Product
	Else																		; See if there is an Experimental folder
		$RtnVal = FileFindFirstFile($BuildFolder & "\Experimental\" & $Product & "\" & $EXE)
		If Not ($RtnVal = -1) Then 												; Found the Installer in the Experimental Product folder
			$BuildFolder = $BuildFolder & "\Experimental\" & $Product
		EndIf
	EndIf
EndFunc

; Get the build options provided by the user
Func GetBuildOptions()
    $Branch = GUICtrlRead($CB_Branch)
    $Product = GUICtrlRead($CB_Product)
	If $Product = "Citrix HDX" Then
		$Component = GUICtrlRead($CB_Component)
		If $Component = "RTME" Then
			$EXE = "Citrix HDX RealTime Media Engine.msi"
		Else
			$EXE = "HDX RealTime Connector LC.msi"
		EndIf
	EndIf
    $Type = GUICtrlRead($CB_Type)
    $Options = GUICtrlRead($CB_Options)
    ; Check to see if the user failed to select any options
    If $Branch == "" Or $Product = "" Or $Type = "" Or $Options = "" Then
        MsgBox(8208, "Missing Selection!", "Please choose an option from each ComboBox!")
        Return
    EndIf
	If $Product = "Citrix HDX" And $Component = "" Then
        MsgBox(8208, "Missing Selection!", "Please choose an option from each ComboBox!")
        Return
    EndIf
	GUISetState(@SW_HIDE, $Form1)
	$Loop = 0   ; If all of the options have been selected, exit the loop
EndFunc

; Install the Product
Func InstallProduct()
	If $BuildFound = True Then
		$RtnVal = MsgBox(8228, "Previous Build Found!", "A previous build was found - " & $BuildNo & ". Shall I install it?")
		If $RtnVal = 7 Then Exit    ; Yes was clicked
	EndIf

	Select
		Case $Options = "Install the latest build"
			Dim $InstallString = 'MsiExec.exe /i "' & $BuildFolder & "\" & $EXE & '" /passive'

			If $Product = "Citrix HDX" Then
				Dim $message = @CRLF & "Preparing to install Citrix " & $Component
			Else
				Dim $message = @CRLF & "Preparing to install " & $Product
			EndIf

			SplashTextOn("", $message, 400, 80, -1, -1, 1)
			sleep(5000)
			SplashOff()

			RunWait(@ComSpec & " /c " & $InstallString, "", @SW_HIDE)
		Case $Options = "Install a specific version"
			; Put code here

		Case $Options = "Browse for an installer"
			; Put code here
	EndSelect
EndFunc

; Find the newest folder in the build directory
Func NewestFolder($Directory)
    $aFolders = _FileListToArray($Directory, '*', 2); Get a list of all the single level sub-folders in a specific folder
    If Not IsArray($aFolders) Then  ; Check if we didn't find any folders, and return 0 with @error = 1 if we do not
        SetError(1)
        Return 0
    EndIf
    _ArrayDelete($aFolders, 0)  ; Remove the first entry containing the total number of entries
    Dim $aEPOCH[UBound($aFolders)][2]   ; Create a 2d array to hold epoch time and the folder names
    For $a = 0 To UBound($aFolders) - 1
        $aTime = FileGetTime($Directory & '\' & $aFolders[$a], 1, 0)    ; Get time folder was created in an array ($aTime)
        $aEPOCH[$a][0] = _DateDiff('s', "1970/01/01 00:00:00", $aTime[0] & '/' & $aTime[1] & '/' & $aTime[2] & ' ' & $aTime[3] & ':' & $aTime[4] & ':' & $aTime[5]) ; Convert to Epoch time
        $aEPOCH[$a][1] = $aFolders[$a]  ; Store directory name
    Next
    _ArraySort($aEPOCH, 1)  ; Sort the $aEPOCH array by EPOCH time, so index 0 contains the newest item
    Return $aEPOCH[0][1]    ; Return the newest items directory name
EndFunc

; The user clicked the Cancel button
Func ProcessCancel()
    $RtnVal = MsgBox(8228, "Cancel Installation?", "Are you sure you want to cancel the installation?")
    If $RtnVal = 6 Then Exit    ; Yes was clicked
EndFunc

Func UninstallProduct()
	If $Product = "Citrix HDX" Then
		Dim $message = @CRLF & "Preparing to uninstall " & $Product & " " & $Component
	Else
		Dim $message = @CRLF & "Preparing to uninstall " & $Product
	EndIf

	SplashTextOn("", $message, 400, 80, -1, -1, 1)
	sleep(5000)
	SplashOff()

	Select
		Case $Product = "Citrix HDX"
			If $Component = "RTME" Then
				$UninstallString = "MsiExec.exe /passive /X{0EDD8CAB-7A46-4126-8B53-C3B3D600C0AB}"
			Else
				$UninstallString = "MsiExec.exe /passive /X{DDD10E6B-6100-4A16-BBFE-B7CEAEC2BB39}"
			EndIf
			RunWait(@ComSpec & " /c " & $UninstallString, "", @SW_HIDE)

		Case $Product = "C3 Communicator"
			;Put code here

		Case $Product = "Unified"
			;Put code here
	EndSelect
EndFunc

; ---------------------- Button Functions ---------------------------
Func Btn_OK_2Click()
	$BuildNo = GUICtrlRead($Input1)
	If $BuildNo = "" or $BuildType = "" Then
		MsgBox(8208, "Missing Selection!", "Please enter a Build Number and select a Build Type")
	Else
		GUISetState(@SW_HIDE, $Form2)
		$Loop = 0   ; If all of the options have been selected, exit the loop
	EndIf
EndFunc

; Display/hide section for Citrix Component
Func CB_ProductChange()
    If GUICtrlRead($CB_Product) = "Citrix HDX" Then
        _GUIExtender_Section_Extend($1stSection) ; Open dynamic section
    Else
        _GUIExtender_Section_Extend($1stSection, False) ; Close dynamic section
    EndIf
EndFunc

Func Radio1Click()
	If BitAnd(GUICtrlRead($Radio1),$GUI_CHECKED) = 1 Then
		$BuildType = 'Released'
		GUICtrlSetState($Input2, $GUI_SHOW)
		GUICtrlSetState($Label2, $GUI_SHOW)
    EndIf
EndFunc

Func Radio2Click()
	If BitAnd(GUICtrlRead($Radio2),$GUI_CHECKED) = 1 Then
		$BuildType = 'Trunk'
		GUICtrlSetState($Input2, $GUI_HIDE)
		GUICtrlSetState($Label2, $GUI_HIDE)
	EndIf
EndFunc