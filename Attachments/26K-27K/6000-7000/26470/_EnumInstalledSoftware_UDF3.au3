#Region Example
Opt("MustDeclareVars", 1)
#include <array.au3>
Global $counter = 1
Dim $val

$val = _Enum_InstalledApps()
_ArrayDisplay($val, " Installed software ")
$val = _Enum_InstalledApps(1)
_ArrayDisplay($val, " Installed software + updates")

$val = _Enum_InstalledApps(1, 1)
_ArrayDisplay($val, " Installed software + updates + blankentries")

$val = _Enum_InstalledApps(1, 1, 1)
_ArrayDisplay($val, " Installed software + updates + blankentries + systemcomponents")

#EndRegion Example

Func _Enum_InstalledApps($showUpdates = 0, $showBlankEntries = 0, $showSysComp = 0)
	; Author: Rajesh V R
	; v3.0 includes modify strings.
	;  v2.0 has lot more features included filtering out useless info, prominently...
	;  v1.0 dated 01 june 2009
	; Function will return a list of software installed in the pc
	; 0 - registry key name, 1  displayname, 2 Display version, 3 uninstall string, 3 - publisher other extra info to follow later on....
	; 4 - nomodify, 5 - modifypath (if nomodify is false!)
	; input $showupdates = 1 will show installed updates, $showsyscomp is a rarely required hidden attribute? systemcomponents will be shown!
	
	If Not IsNumber($showSysComp) Then $showSysComp = 0 ; by default hide system components...
	If Not IsNumber($showUpdates) Then $showUpdates = 0 ; by default hide update packages...
	If Not IsNumber($showUpdates) Then $showUpdates = 0 ; by default hide blank & useless entries...
	
	Const $HKLM_Uninstall = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall"

	Local $retVal[1][5], $i = 1, $regKey
	While 1
		$i += 1
		$regKey = RegEnumKey($HKLM_Uninstall, $i - 1)
		If @error <> 0 Then ExitLoop
		If $showSysComp = 0 And _IsRegSysComponent($regKey) = True Then ContinueLoop
		If $showUpdates = 0 And _IsUpdatePKG($regKey) = True Then ContinueLoop
		If $showBlankEntries = 0 And _IsBlankEntry($regKey) = True Then ContinueLoop
		ReDim $retVal[UBound($retVal, 1) + 1][7]
		$retVal[UBound($retVal, 1) - 1][0] = $regKey
		$retVal[UBound($retVal, 1) - 1][1] = RegRead($HKLM_Uninstall & "\" & $regKey, "DisplayName")
		$retVal[UBound($retVal, 1) - 1][2] = RegRead($HKLM_Uninstall & "\" & $regKey, "DisplayVersion")
		$retVal[UBound($retVal, 1) - 1][3] = RegRead($HKLM_Uninstall & "\" & $regKey, "UninstallString")
		$retVal[UBound($retVal, 1) - 1][4] = RegRead($HKLM_Uninstall & "\" & $regKey, "Publisher")
		$retVal[UBound($retVal, 1) - 1][5] = RegRead($HKLM_Uninstall & "\" & $regKey, "NoModify")
		If $retVal[UBound($retVal, 1) - 1][5] <> 1 Then ; if this is 1 then skip modification should not be allowed!
			$retVal[UBound($retVal, 1) - 1][6] = RegRead($HKLM_Uninstall & "\" & $regKey, "ModifyPath")
		EndIf
	WEnd
	If StringInStr($retVal[UBound($retVal) - 1][0], "No more data is available.") Then ReDim $retVal[UBound($retVal) - 1][7]
	$retVal[0][0] = UBound($retVal) - 1
	Return $retVal
EndFunc   ;==>_Enum_InstalledApps

Func _IsRegSysComponent($regKey)
	; check if it is a system component  - there is not gonna be any more info or options available anyways!
	Local $regPath = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $regKey
	Local $retVal = False
	If RegRead($regPath, "SystemComponent") <> "" Then ; key exists ?
		If RegRead($regPath, "SystemComponent") = 1 And @extended = 4 Then
			$retVal = True
		EndIf
	EndIf
	Return $retVal
EndFunc   ;==>_IsRegSysComponent

Func _IsUpdatePKG($regKey)
	; check if it is a windows update package
	Local $regPath = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $regKey
	Local $retVal = False
	If RegRead($regPath, "ParentKeyName") <> "" Then ; key exists ?
		$retVal = True
		;ConsoleWrite( @CRLF & $counter & " :" & $regKey & @TAB & RegRead($regPath,"ParentKeyName") & @TAB & RegRead($regPath,"ReleaseType"))
		$counter = $counter + 1
	EndIf
	Return $retVal
EndFunc   ;==>_IsUpdatePKG

Func _IsBlankEntry($regKey)
	; check if the uninstall string & display names are blank then there is not much a point in displaying it...
	Local $regPath = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $regKey
	
	Local $retVal = False
	If StringStripWS(RegRead($regPath, "DisplayName"), 8) = "" And StringStripWS(RegRead($regPath, "UninstallString"), 8) = "" Then
		$retVal = True
	EndIf
	Return $retVal
EndFunc   ;==>_IsBlankEntry