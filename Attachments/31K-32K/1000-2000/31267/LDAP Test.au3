#Include <GUIConstants.au3>
#Include <GUIConstantsEx.au3>
#Include <AD.au3>
#Include <Array.au3> 
#Include <WindowsConstants.au3>
#Include <GuiTreeView.au3>

HotKeySet("{ESC}", "Terminate")

Global $aMain[1]
Global $CurrentItem
Global $Tree
Global $Root
Global $aRevOUs[1]

BuildGUI()
Terminate()

; *****************************************************************************
; Connect to AD and build the array.
; *****************************************************************************
Func AD()
	_AD_Open()
	
	Global $aTemp = _AD_GetAllOUs()
	If @error > 0 Then
		MsgBox(64, "Active Directory Functions - Example 1", "No OUs could be found")
	EndIf
	
	Global $aOUs[1] 
	
	For $x = 1 To UBound($aTemp, 1) -1
		_ArrayAdd($aOUs, $aTemp[$x][0])
	Next

	_AD_Close()
EndFunc


; *****************************************************************************
; Build the main GUI
; *****************************************************************************
Func BuildGUI()
	Opt("GUICloseOnESC", 1)
	Opt("GUIOnEventMode", 1)
	
	$MainGUI = GUICreate("LDAP View", 500, 700, -1, -1)
	$Tree = GUICtrlCreateTreeView(10, 40, 290, 650, -1, -1)
	
	GUISetState(@SW_SHOW)
	AD()
	_ArrayDelete($aOUs, 0)
	_ArraySort($aOUs)
;~ 	_ArrayDisplay($aOUs)
	
	
	For $OU In $aOUs
		$RevOU = Reverse($OU)
		_ArrayAdd($aRevOUs, $RevOU)
	Next
	
	_ArrayDelete($aRevOUs, 0)
;~ 	_ArrayDisplay($aRevOUs)
	
	Global $TIDArray[UBound($aOUs) * 2]
	BuildTree()
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "Terminate")
	
	While 1
		Sleep(1)
	WEnd
EndFunc


; *****************************************************************************
; Build the TreeView data from the Reversed OU Array
; ***************************************************************************** 
Func BuildTree()
	For $RevOU In $aRevOUs
		$FullOU = StringStripWS ($RevOU, 3)
		$ShortOU = ShortName($FullOU)
		$ParentOU = Parent($FullOU)
		$ParentTreeID = _ArraySearch($TIDArray, $ParentOU)
		
		If ($ParentTreeID <> "-1") Then	
			$TreeID = GUICtrlCreateTreeViewItem ($ShortOU, $ParentTreeID)
		Else	
			$TreeID	= GUICtrlCreateTreeViewItem ($ShortOU, $Tree)
		EndIf
		
		$TIDArray[$TreeID] = $FullOU
		
	Next
EndFunc


; *****************************************************************************
; Reverse the master array or OUs 
; ***************************************************************************** 
Func Reverse($OU)
	$aSub = StringSplit($OU, "\")
	$Rev = ""
	For $i = (UBound($aSub) -1) To 1 Step -1
		If $i = (UBound($aSub) -1) Then
			$Rev = $Rev & $aSub[$i]
		Else
			$Rev = $Rev & "\" & $aSub[$i]
		EndIf
	Next
	Return $Rev
EndFunc


; *****************************************************************************
; Return the Short Name of the OU
; ***************************************************************************** 
Func ShortName($DN)
	Return StringMid($DN, StringInStr($DN, "=")+1, StringInStr($DN, "\")-(StringInStr($DN, "=")+1))
EndFunc


; *****************************************************************************
; Return the Parent of the OU
; *****************************************************************************
Func Parent($Child)
	Return StringRight($Child, ( StringLen($Child)-StringInStr($Child, "\") ) )
EndFunc


; *****************************************************************************
; Color function to convert RGB to hex colors 
; ***************************************************************************** 
Func Color($red,$green,$blue) 
    Return "0x" & Hex( BitAND($red, 255), 2) & Hex( BitAND($green, 255), 2) & Hex( BitAND($blue, 255), 2) 
EndFunc


; *****************************************************************************
; Terminate the app.
; *****************************************************************************
Func Terminate()
    Exit 0
EndFunc