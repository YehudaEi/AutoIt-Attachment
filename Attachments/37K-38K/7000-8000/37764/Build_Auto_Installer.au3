#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=avistar.ico
#AutoIt3Wrapper_Res_Description=This script will install the Avistar product the user selects after uninstalling the old version
#AutoIt3Wrapper_Res_Fileversion=0.4.0.7
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Author: Robin Siebler
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=ProductName|Build Auto Installer
#AutoIt3Wrapper_Res_Field=CompanyName|Avistar
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#comments-start
	-------------------------------------------------------------------------------
	Name:       Build Auto Installer
	Purpose:    This script will install the Avistar product the user selects after uninstalling the old version
	Author:      Robin Siebler
	Created:     6/1/2012
	Version:     0.4
	-------------------------------------------------------------------------------
#comments-end

; **** To Do: Add registry search for uninstall string

; Includes
#include <file.au3>
#include <array.au3>
#include <date.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIButton.au3>
#include <GUIConstantsEx.au3>
#include <GUIExtender.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)
TraySetIcon(@ScriptDir & "\avistar.ico", -1)

; Variables
Global $BaseFolder, $Branch, $BuildFolder, $BuildFound, $BuildNo, $BuildType, $Installer, $NewestDir, $Options, $Product, $RelBuildNo, $Type, $_Product
Local $IniFile = @ScriptDir & "\Build_Auto_Installer.ini"
Local $ConfigData = IniReadSection($IniFile, "Config")
$BaseFolder = "\\hqfile04\Build\releases"

;----------------------- Build Selection Dialog ----
#region ### START Koda GUI section ### Form=c:\scripts\autoit\build_auto_installer\buildselectiondialog.kxf
$Form1 = GUICreate("Build Auto Installer", 366, 426)
GUISetIcon(@ScriptDir & "avistar.ico", -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "ProcessCancel")

;_GUIExtender_Init($Form1) ; Initialise the GUI
GUICtrlCreateLabel("Please choose from the below options to install a build:", 25, 23, 321, 21)
GUICtrlCreateLabel("Branch:", 25, 53, 51, 21)
GUICtrlCreateLabel("Product:", 25, 92, 54, 21)
GUICtrlCreateLabel("Type:", 25, 132, 38, 21)
GUICtrlCreateLabel("Options:", 25, 171, 53, 21)
$CB_Branch = GUICtrlCreateCombo("", 84, 53, 259, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData($CB_Branch, $ConfigData[1][1])
$CB_Product = GUICtrlCreateCombo("", 84, 92, 259, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData($CB_Product, $ConfigData[2][1])
$CB_Type = GUICtrlCreateCombo("", 84, 132, 259, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData($CB_Type, $ConfigData[3][1])
$CB_Options = GUICtrlCreateCombo("", 84, 171, 259, 25, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($CB_Options, "CB_OptionsChange")
GUICtrlSetData($CB_Options, $ConfigData[4][1])


;$1stSection = _GUIExtender_Section_Start() ; Create section
;_GUIExtender_Section_Action($1stSection) ; Make it dynamic

;$1stSection = _GUIExtender_Section_Start() ; Create section
;_GUIExtender_Section_Action($1stSection) ; Make it dynamic
$Label1 = GUICtrlCreateLabel("Please enter the 3 digit build number:", 25, 214, 222, 20)
GUICtrlSetState($Label1, $GUI_HIDE)
$SpecificBuildNoInput = GUICtrlCreateInput("", 249, 211, 94, 24, $ES_NUMBER)
GUICtrlSetLimit($SpecificBuildNoInput, 3, 3)
GUICtrlSetState($SpecificBuildNoInput, $GUI_HIDE)
$Group1 = GUICtrlCreateGroup("Build Type", 114, 244, 150, 46)
$Radio1 = GUICtrlCreateRadio("Release", 130, 260, 60, 20)
GUICtrlSetTip($Radio1, "Non 99.99.99 Build Number")
GUICtrlSetOnEvent($Radio1, "Radio1Click")
$Radio2 = GUICtrlCreateRadio("Trunk", 206, 260, 50, 20)
GUICtrlSetTip($Radio2, "99.99.99 Build Number")
GUICtrlSetOnEvent($Radio2, "Radio2Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState($Group1, $GUI_HIDE)
GUICtrlSetState($Radio1, $GUI_HIDE)
GUICtrlSetState($Radio2, $GUI_HIDE)
$Label2 = GUICtrlCreateLabel("Enter the Release Version Number:", 25, 313, 214, 20)
GUICtrlSetState($Label2, $GUI_HIDE)
$ReleaseNoInput = GUICtrlCreateInput("", 249, 313, 94, 24)
GUICtrlSetState($ReleaseNoInput, $GUI_HIDE)
;_GUIExtender_Section_End() ; Close section

;$2ndSection = _GUIExtender_Section_Start() ; Everything else goes in another section
$Btn_OK = GUICtrlCreateButton("OK", 108, 360, 60, 31, $BS_NOTIFY)
GUICtrlSetOnEvent($Btn_OK, "GetBuildOptions")
$Btn_Cancel = GUICtrlCreateButton("Cancel", 196, 360, 61, 31, $BS_NOTIFY)
GUICtrlSetOnEvent($Btn_Cancel, "ProcessCancel")
;_GUIExtender_Section_End() ; Close section
;_GUIExtender_Section_Extend($1stSection, False) ; Close the dynamic section

GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

$Loop = 1
While $Loop ; Wait for Build Selection Dialog to close
	Sleep(100)
WEnd

Select
	Case $Options = "Install the latest build"
		;DetermineBuildFolder()

	Case $Options = "Install a specific version"
		;FindSpecificBuild()
	Case $Options = "Browse for an installer"
		BrowseForInstaller()
EndSelect
;UninstallProduct()
;InstallProduct()
MsgBox(8256, "Installation Complete!", "The installation is complete!")
Exit

; ----------------------------- Functions ---------------------------
; Browse for the installer
Func BrowseForInstaller()
	$Installer = FileOpenDialog("Pick the installer you wish to use:", $BaseFolder & "\" & $Branch, "Installers (*.msi)", 1 + 2)
	If @error Then
		$RtnVal = MsgBox(8228, "", "You did not chose a file. Abort the install?")
		If $RtnVal = 6 Then
			Exit ; Yes was clicked
		Else
			BrowseForInstaller()
		EndIf
	EndIf
EndFunc   ;==>BrowseForInstaller

; Find the latest build
Func DetermineBuildFolder($recurse = 0) ; $recurse will be set to 1 by FindPreviousBuild when a previous build folder is found
	If $recurse = 0 Then $BuildFolder = $BaseFolder & "\" & $Branch ; 1st time through, point to the correct build path

	If $NewestDir = "" Then ; 1st time through, get the Newest Folder
		$NewestDir = NewestFolder($BuildFolder)
		If @error Then ; If NewestFolder() didn't error out, report the newest directory, otherwise, report the error.
			MsgBox(8240, 'Navigation Error', 'No folders were found in ' & $BuildFolder)
			Exit
		Else
			$BuildFolder = $BuildFolder & "\" & $NewestDir & "\" & $Type & "\windows" ; a folder was found
		EndIf
	Else
		If $BuildNo = "" Then ; recurse, a Build No hasn't been found
			$BuildFolder = $BuildFolder & "\" & $NewestDir & "\" & $Type & "\windows"
		Else ; there is a Build No to check
			$BuildFolder = $BuildFolder & "\" & $Type & "\windows"
		EndIf
	EndIf
	$RtnVal = FileFindFirstFile($BuildFolder & "\" & $Product & "\" & $Installer) ; Look for the Installer in the Product folder
	If Not ($RtnVal = -1) Then ; Found the Installer
		$BuildFolder = $BuildFolder & "\" & $Product
		If Not ($BuildNo = "") Then $BuildFound = True
	Else ; See if there is an Experimental folder
		$RtnVal = FileFindFirstFile($BuildFolder & "\Experimental\" & $Product & "\" & $Installer)
		If Not ($RtnVal = -1) Then ; Found the Installer in the Experimental Product folder
			$BuildFolder = $BuildFolder & "\Experimental\" & $Product
			If Not ($BuildNo = "") Then $BuildFound = True ; Found the Previous Build
		Else
			MsgBox(8240, "Missing Build!", "There was no " & $Product & " folder in " & _
					$BuildFolder & " and there is no Experimental folder either. " & _
					" This probably means there is no windows installer for this build." & _
					@CRLF & @CRLF & "The script will now try to find the previous release.")
			FindPreviousBuild() ; Look for the Previous Build
		EndIf
	EndIf
EndFunc   ;==>DetermineBuildFolder

; Look for the Previous Build No
Func FindPreviousBuild()
	; Get the actual number part of the Build Folder
	Dim $aBuild = StringSplit($NewestDir, "-", 2)
	$BuildNo = $aBuild[1]
	If IsInt($BuildNo) Then
		MsgBox(8240, "Navigation Error!", "I should have a build number, but I do not!")
	EndIf
	$BuildNo = $BuildNo - 1 ; Previous Build No
	$BuildNo = $aBuild[0] & "-" & $BuildNo
	$BuildFolder = $BaseFolder & "\" & $Branch & "\" & $BuildNo
	$RtnVal = FileFindFirstFile($BuildFolder)
	If Not ($RtnVal = -1) Then ; This build number was skipped
		DetermineBuildFolder(1)
	Else
		$NewestDir = $BuildNo
		FindPreviousBuild()
	EndIf
EndFunc   ;==>FindPreviousBuild

; Find the user specified build
Func FindSpecificBuild()

	; Full Build version example = 1.0.3r-575 (release) - 99.99.99r-575 (internal)
	If $BuildType = "Release" Then
		$BuildNo = $RelBuildNo & "-" & $BuildNo
	Else
		$BuildNo = "99.99.99r-" & $BuildNo
	EndIf
	$BuildFolder = $BaseFolder & "\" & $Branch & "\" & $BuildNo & "\" & $Type & "\windows"
	$RtnVal = FileFindFirstFile($BuildFolder & "\" & $Product & "\" & $Installer) ; Look for the Installer in the Product folder
	If Not ($RtnVal = -1) Then ; Found the Installer
		$BuildFolder = $BuildFolder & "\" & $Product
	Else ; See if there is an Experimental folder
		$RtnVal = FileFindFirstFile($BuildFolder & "\Experimental\" & $Product & "\" & $Installer)
		If Not ($RtnVal = -1) Then ; Found the Installer in the Experimental Product folder
			$BuildFolder = $BuildFolder & "\Experimental\" & $Product
		EndIf
	EndIf
EndFunc   ;==>FindSpecificBuild

; Get and validate the build options provided by the user
Func GetBuildOptions()

	; Assign values
	$Branch = GUICtrlRead($CB_Branch)
	$Product = GUICtrlRead($CB_Product)
	$Type = GUICtrlRead($CB_Type)
	$Options = GUICtrlRead($CB_Options)

	; Validate required fields
	If $Branch = "" Or $Product = "" Or $Type = "" Or $Options = "" Then
		MsgBox(8208, "Missing Selection!", "All ComboBoxes must have a value")
		Return
	EndIf

	; Validate fields required for a specific build
	If $Options = "Install a specific version" Then
		$BuildNo = GUICtrlRead($SpecificBuildNoInput)
		If $BuildNo = "" Then
			MsgBox(8208, "Missing Selection!", "Please enter a Build Number!")
			Return
		ElseIf _GUICtrlButton_GetCheck($Radio1) = $BST_UNCHECKED And _GUICtrlButton_GetCheck($Radio2) = $BST_UNCHECKED Then
			MsgBox(8208, "Missing Selection!", "Please select a Build Type!")
			Return
		ElseIf $BuildType = "Release" Then
			$RelBuildNo = GUICtrlRead($ReleaseNoInput)
			If $RelBuildNo = "" Then
				MsgBox(8208, "Missing Selection!", "Please enter a Release Build Number!")
				Return
			EndIf
		EndIf
	EndIf

	If $Product = "Citrix HDX RealTime Media Engine " Then
		$_Product = $Product ; all because the Folder name is different
		$Product = "Cixtrix HDX"
		$Installer = "Citrix HDX RealTime Media Engine.msi"
	ElseIf $Product = "Citrix RealTime Connector" Then
		$_Product = $Product ; all because the Folder name is different
		$Product = "Cixtrix HDX"
		$Installer = "HDX RealTime Connector LC.msi"
	EndIf
	GUISetState(@SW_HIDE, $Form1)
	$Loop = 0 ; If all of the options have been selected, exit the loop
EndFunc   ;==>GetBuildOptions

; Install the Product
Func InstallProduct()
	If $BuildFound = True Then
		$RtnVal = MsgBox(8228, "Previous Build Found!", "A previous build was found - " & $BuildNo & ". Shall I install it?")
		If $RtnVal = 7 Then Exit ; No was clicked
	EndIf

	Dim $InstallString = 'MsiExec.exe /i "' & $BuildFolder & "\" & $Installer & '" /passive'

	If $Product = "Citrix HDX" Then
		Dim $message = @CRLF & "Preparing to install Citrix " & $_Product
	Else
		Dim $message = @CRLF & "Preparing to install " & $Product
	EndIf
	SplashTextOn("", $message, 400, 80, -1, -1, 1)
	Sleep(5000)
	SplashOff()
	RunWait(@ComSpec & " /c " & $InstallString, "", @SW_HIDE)
EndFunc   ;==>InstallProduct

; Find the newest folder in the build directory
Func NewestFolder($Directory)
	$aFolders = _FileListToArray($Directory, '*', 2); Get a list of all the single level sub-folders in a specific folder
	If Not IsArray($aFolders) Then ; Check if we didn't find any folders, and return 0 with @error = 1 if we do not
		SetError(1)
		Return 0
	EndIf
	_ArrayDelete($aFolders, 0) ; Remove the first entry containing the total number of entries
	Dim $aEPOCH[UBound($aFolders)][2] ; Create a 2d array to hold epoch time and the folder names
	For $a = 0 To UBound($aFolders) - 1
		$aTime = FileGetTime($Directory & '\' & $aFolders[$a], 1, 0) ; Get time folder was created in an array ($aTime)
		$aEPOCH[$a][0] = _DateDiff('s', "1970/01/01 00:00:00", $aTime[0] & '/' & $aTime[1] & '/' & $aTime[2] & ' ' & $aTime[3] & ':' & $aTime[4] & ':' & $aTime[5]) ; Convert to Epoch time
		$aEPOCH[$a][1] = $aFolders[$a] ; Store directory name
	Next
	_ArraySort($aEPOCH, 1) ; Sort the $aEPOCH array by EPOCH time, so index 0 contains the newest item
	Return $aEPOCH[0][1] ; Return the newest items directory name
EndFunc   ;==>NewestFolder

; The user clicked the Cancel button
Func ProcessCancel()
	$RtnVal = MsgBox(8228, "Cancel Installation?", "Are you sure you want to cancel the installation?")
	If $RtnVal = 6 Then Exit ; Yes was clicked
EndFunc   ;==>ProcessCancel

Func UninstallProduct()
	If $Product = "Citrix HDX" Then
		Dim $message = @CRLF & "Preparing to uninstall " & $_Product
	Else
		Dim $message = @CRLF & "Preparing to uninstall " & $Product
	EndIf

	SplashTextOn("", $message, 400, 80, -1, -1, 1)
	Sleep(5000)
	SplashOff()

	Select
		#cs		Case $Product = "Citrix HDX"
			If $Component = "RTME" Then
			$UninstallString = "MsiExec.exe /passive /X{0EDD8CAB-7A46-4126-8B53-C3B3D600C0AB}"
			Else
			$UninstallString = "MsiExec.exe /passive /X{DDD10E6B-6100-4A16-BBFE-B7CEAEC2BB39}"
			EndIf
			RunWait(@ComSpec & " /c " & $UninstallString, "", @SW_HIDE)
		#ce
		Case $Product = "C3 Communicator"
			;Put code here

		Case $Product = "Unified"
			;Put code here
	EndSelect
EndFunc   ;==>UninstallProduct

; ---------------------- Button Functions ---------------------------
; Trigger visibilty of the specific version controls
#cs
Func CB_OptionsChange()
    If GUICtrlRead($CB_Options) = "Install a specific version" Then
        _GUIExtender_Section_Extend($1stSection) ; Open dynamic section
    Else
        _GUIExtender_Section_Extend($1stSection, False) ; Close dynamic section
    EndIf
EndFunc
#ce

Func CB_OptionsChange()

	Select
		Case GUICtrlRead($CB_Options) = "Install the latest build"
			GUICtrlSetState($Label1, $GUI_HIDE)
			GUICtrlSetState($SpecificBuildNoInput, $GUI_HIDE)
			GUICtrlSetState($Group1, $GUI_HIDE)
			GUICtrlSetState($Radio1, $GUI_HIDE)
			GUICtrlSetState($Radio1, $GUI_UNCHECKED)
			GUICtrlSetState($Radio2, $GUI_HIDE)
			GUICtrlSetState($Radio2, $GUI_UNCHECKED)
			GUICtrlSetState($Label2, $GUI_HIDE)
			GUICtrlSetState($ReleaseNoInput, $GUI_HIDE)
		Case GUICtrlRead($CB_Options) = "Install a specific version"
			GUICtrlSetState($Label1, $GUI_SHOW)
			GUICtrlSetState($SpecificBuildNoInput, $GUI_SHOW)
			GUICtrlSetState($Group1, $GUI_SHOW)
			GUICtrlSetState($Radio1, $GUI_SHOW)
			GUICtrlSetState($Radio2, $GUI_SHOW)

		Case GUICtrlRead($CB_Options) = "Browse for an installer"
			GUICtrlSetState($Label1, $GUI_HIDE)
			GUICtrlSetState($SpecificBuildNoInput, $GUI_HIDE)
			GUICtrlSetState($Label1, $GUI_HIDE)
			GUICtrlSetState($SpecificBuildNoInput, $GUI_HIDE)
			GUICtrlSetState($Group1, $GUI_HIDE)
			GUICtrlSetState($Radio1, $GUI_HIDE)
			GUICtrlSetState($Radio1, $GUI_UNCHECKED)
			GUICtrlSetState($Radio2, $GUI_HIDE)
			GUICtrlSetState($Radio2, $GUI_UNCHECKED)
			GUICtrlSetState($Label2, $GUI_HIDE)
			GUICtrlSetState($ReleaseNoInput, $GUI_HIDE)
	EndSelect

EndFunc   ;==>CB_OptionsChange

; Trigger visibility of the Release Number controls
Func Radio1Click()
	If BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = 1 Then
		$BuildType = 'Release'
		GUICtrlSetState($Label2, $GUI_SHOW)
		GUICtrlSetState($ReleaseNoInput, $GUI_SHOW)
	EndIf
EndFunc   ;==>Radio1Click

; Trigger visibility of the Release Number controls
Func Radio2Click()
	If BitAND(GUICtrlRead($Radio2), $GUI_CHECKED) = 1 Then
		$BuildType = 'Trunk'
		GUICtrlSetState($Label2, $GUI_HIDE)
		GUICtrlSetState($ReleaseNoInput, $GUI_HIDE)
	EndIf
EndFunc   ;==>Radio2Click
