#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <OutlookEX.au3>

Global $oOutlook = _OL_Open()
If @error <> 0 Then Exit MsgBox(16, "OutlookEX UDF", "Error creating a connection to Outlook. @error = " & @error & ", @extended = " & @extended)

; *******************************************************************************
; Example 1
; Add a Userproperty to a folder so the property can be used in a view
; *******************************************************************************
Global $aFolder = _OL_FolderAccess($oOutlook, "*\Outlook-UDF-Test\TargetFolder\Mail")
If @error <> 0 Then Exit MsgBox(16, "OutlookEX UDF: _OL_UserpropertyAdd Example Script", "Error accessing folder 'Outlook-UDF-Test\TargetFolder\Mail'. @error = " & @error)
_OL_UserPropertyAdd($oOutlook, Default, $aFolder[1], "TestProperty", $olText)
If @error <> 0 Then Exit MsgBox(16, "OutlookEX UDF: _OL_UserpropertyAdd Example Script", "Error addin user property 'Test' to the folder. @error = " & @error & ", @extended: " & @extended)

; *******************************************************************************
; Example 2
; Add a Userproperty to an item
; *******************************************************************************
Global $aItems = _OL_ItemFind($oOutlook, $aFolder[1], $olMail, '[Subject] = "Test User Properties"', "", "", "EntryID")
If @error <> 0 Or $aItems[0][0] = 0 Then Exit MsgBox(48, "OutlookEX UDF: _OL_UserpropertyAdd Example Script", "Error finding a mail. @error = " & @error & ", @extended: " & @extended)
_OL_UserPropertyAdd($oOutlook, Default, $aItems[1][0], "TestProperty", $olText, Default, "TestValue")
If @error <> 0 Then Exit MsgBox(16, "OutlookEX UDF: _OL_UserpropertyAdd Example Script", "Error adding user property 'Test' to the item. @error = " & @error & ", @extended: " & @extended)

; *******************************************************************************
; Example 3
; Get user properties of a folder
; *******************************************************************************
Global $aUserProperties = _OL_UserpropertyGet($oOutlook, Default, $aFolder[1])
_ArrayDisplay($aUserProperties)

; *******************************************************************************
; Example 4
; Get user properties of an item
; *******************************************************************************
$aUserProperties = _OL_UserpropertyGet($oOutlook, Default, $aItems[1][0])
_ArrayDisplay($aUserProperties)

; *******************************************************************************
; Example 5
; Remove a user property from an item
; *******************************************************************************
_OL_UserPropertyRemove($oOutlook, Default, $aItems[1][0], "TestProperty")
If @error <> 0 Then Exit MsgBox(16, "OutlookEX UDF: _OL_UserpropertyRemove Example Script", "Error removing user property 'TestProperty' from the item. @error = " & @error & ", @extended: " & @extended)

; *******************************************************************************
; Example 6
; Remove a user property from a folder
; *******************************************************************************
_OL_UserPropertyRemove($oOutlook, Default, $aFolder[1], "TestProperty")
If @error <> 0 Then Exit MsgBox(16, "OutlookEX UDF: _OL_UserpropertyRemove Example Script", "Error removing user property 'TestProperty' from the folder. @error = " & @error & ", @extended: " & @extended)

_OL_Close($oOutlook)

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_UserpropertyAdd
; Description ...: Adds a user property to an item or folder
; Syntax.........: _OL_UserpropertyAdd($oOL, $sStoreID, $vObject, $sName, $iType[, $iDisplayFormat = Default[, $vValue = Default[, $bAddToFolderFields = Default]]])
; Parameters ....: $oOL                - Outlook object returned by a preceding call to _OL_Open()
;                  $sStoreID           - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $vObject            - Object or EntryID of the item or folder you want to add the user property to
;                  $sName              - Name of the user property you want to add
;                  $iType              - Type of the user property. Can be any of the OlUserPropertyType enumeration
;                  $iDisplayFormat     - Optional: Display format of the user property. Can be set to a value from one of several
;                                        different enumerations, determined by the OlUserPropertyType specified in $iType
;                  $vValue             - Optional: Sets the value for the user property (default = Default = No value)
;                  $bAddToFolderFields - Optional: If True the property will be added to the folder the item is in.
;                                        This field can be displayed in the folder's view (default = True)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oOL is not an object
;                  |2 - $vObject is neither a valid EntryID nor a valid FolderID
;                  |3 - Error occurred when adding the user property to the item. @extended is set to the COM error code
;                  |4 - Error occurred when adding the user property to the folder. @extended is set to the COM error code
;                  |5 - Error when setting the value of the user property. @extended is set to the COM error code
;                  |6 - $vValue is not valid for a folder
;                  |7 - $bAddToFolderFields is not valid for a folder
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_UserpropertyAdd($oOL, $sStoreID, $vObject, $sName, $iType, $iDisplayFormat = Default, $vValue = Default, $bAddToFolderFields = Default)

	If Not IsObj($oOL) Then Return SetError(1, 0, 0)
	If Not IsObj($vObject) Then
		Local $oObject = $oOL.Session.GetItemFromID($vObject, $sStoreID) ; Is it an item ID?
		If @error Then
			SetError(0)
			$oObject = $oOL.Session.GetFolderFromID($vObject, $sStoreID) ; Is it a folder ID?
			If @error Then Return SetError(2, @error, 0)
		EndIf
		$vObject = $oObject
	EndIf
	If $vObject.Class = $olFolder Then
		; Folder
		If $vValue <> Default Then Return SetError(6, 0, 0)
		If $bAddToFolderFields <> Default Then Return SetError(7, 0, 0)
		$vObject.UserDefinedProperties.Add($sName, $iType, $iDisplayFormat)
		If @error Then Return SetError(4, @error, 0)
	Else
		; Item
		If $bAddToFolderFields = Default Then $bAddToFolderFields = True
		$vObject.UserProperties.Add($sName, $iType, $bAddToFolderFields, $iDisplayFormat)
		If @error Then Return SetError(3, @error, 0)
		If $vValue <> Default Then
			$vObject.UserProperties.Item($sName).Value = $vValue
			If @error Then Return SetError(5, @error, 0)
		EndIf
	EndIf
	Return 1

EndFunc   ;==>_OL_UserpropertyAdd

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_UserpropertyRemove
; Description ...: Remove a user property from an item
; Syntax.........: _OL_UserpropertyRemove($oOL, $vObject, $sName)
; Parameters ....: $oOL                - Outlook object returned by a preceding call to _OL_Open()
;                  $sStoreID           - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $vObject            - Object or EntryID of the item or folder you want to add the user property to
;                  $sName              - Name of the user property you want to add
;                  $iType              - Type of the user property. Can be any of the OlUserPropertyType enumeration
;                  $iDisplayFormat     - Optional: Display format of the user property. Can be set to a value from one of several
;                                        different enumerations, determined by the OlUserPropertyType specified in $iType
;                  $vValue             - Optional: Sets the value for the user property (default = Default = No value)
;                  $bAddToFolderFields - Optional: If True the property will be added to the folder the item is in.
;                                        This field can be displayed in the folder's view (default = True)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oOL is not an object
;                  |2 - $vObject is neither a valid EntryID nor a valid FolderID
;                  |3 - Error occurred when removing the user property from the item. @extended is set to the COM error code
;                  |4 - Error occurred when removing the user property from the folder. @extended is set to the COM error code
;                  |5 - Specified user property could not be found
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_UserpropertyRemove($oOL, $sStoreID, $vObject, $sName)

	Local $bFound = False
	If Not IsObj($oOL) Then Return SetError(1, 0, 0)
	If Not IsObj($vObject) Then
		Local $oObject = $oOL.Session.GetItemFromID($vObject, $sStoreID) ; Is it an item ID?
		If @error Then
			SetError(0)
			$oObject = $oOL.Session.GetFolderFromID($vObject, $sStoreID) ; Is it a folder ID?
			If @error Then Return SetError(2, @error, 0)
		EndIf
		$vObject = $oObject
	EndIf
	If $vObject.Class = $olFolder Then
		; Folder
		For $iIndex = 1 To $vObject.UserDefinedProperties.Count
			If $vObject.UserDefinedProperties.Item($iIndex).Name = $sName Then
				$vObject.UserDefinedProperties.Remove($iIndex)
				If @error Then Return SetError(4, @error, 0)
				$bFound = True
				ExitLoop
			EndIf
		Next
		If $bFound = False Then Return SetError(5, @error, 0)
	Else
		; Item
		For $iIndex = 1 To $vObject.UserProperties.Count
			If $vObject.UserProperties.Item($iIndex).Name = $sName Then
				$vObject.UserProperties.Remove($iIndex)
				If @error Then Return SetError(3, @error, 0)
				$bFound = True
				ExitLoop
			EndIf
		Next
		If $bFound = False Then Return SetError(5, @error, 0)
	EndIf
	Return 1

EndFunc   ;==>_OL_UserpropertyRemove

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_UserpropertiesGet
; Description ...: Returns the names, values and types of all user properties for an item or folder.
; Syntax.........: _OL_UserpropertiesGet($oOL, $sStoreID, $vObject)
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $sStoreID - StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
;                  $vObject  - Object or EntryID of the item or folder you want to add the user property to
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - name of the user property
;                  |1 - type of the user property
;                  |2 - value of the user property (only for items)
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oOL is not an object
;                  |2 - $vObject is neither a valid EntryID nor a valid FolderID
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_UserpropertyGet($oOL, $sStoreID, $vObject)

	If Not IsObj($oOL) Then Return SetError(1, 0, 0)
	If Not IsObj($vObject) Then
		Local $oObject = $oOL.Session.GetItemFromID($vObject, $sStoreID) ; Is it an item ID?
		If @error Then
			SetError(0)
			$oObject = $oOL.Session.GetFolderFromID($vObject, $sStoreID) ; Is it a folder ID?
			If @error Then Return SetError(2, @error, 0)
		EndIf
		$vObject = $oObject
	EndIf
	If $vObject.Class = $olFolder Then
		; Folder
		Local $aProperties[$vObject.UserDefinedProperties.Count + 1][2] = [[$vObject.UserDefinedProperties.Count, 2]]
		For $iIndex = 1 To $vObject.UserDefinedProperties.Count
			$aProperties[$iIndex][0] = $vObject.UserDefinedProperties.Item($iIndex).Name
			$aProperties[$iIndex][1] = $vObject.UserDefinedProperties.Item($iIndex).Type
		Next
	Else
		; Item
		Local $aProperties[$vObject.UserProperties.Count + 1][3] = [[$vObject.UserProperties.Count, 3]]
		For $iIndex = 1 To $vObject.UserProperties.Count
			$aProperties[$iIndex][0] = $vObject.UserProperties.Item($iIndex).Name
			$aProperties[$iIndex][1] = $vObject.UserProperties.Item($iIndex).Type
			$aProperties[$iIndex][2] = $vObject.UserProperties.Item($iIndex).Value
		Next
	EndIf
	Return $aProperties

EndFunc   ;==>_OL_UserpropertyGet

Func __OL_CheckPropertiesEx($oItem, $aProperties, $iFlag = 0, $bItemProperties = True)

	Local $aTemp, $iIndex, $iEnd, $oProperty
	If $iFlag = 1 Then
		$iIndex = 1
		$iEnd = $aProperties[0]
	Else
		$iIndex = 0
		$iEnd = UBound($aProperties) - 1
	EndIf
	For $iIndex = $iIndex To $iEnd
		$aTemp = StringSplit($aProperties[$iIndex], "=")
		If $aTemp[1] <> "" Then
			SetError(0)
			$oProperty = $oItem.UserProperties.Find($aTemp[1], Not $bItemProperties) ; Search Itemproperties or UserProperties
			If @error Then Return SetError(100, $iIndex, 0) ; Property not found
			If Not ($aTemp[1] == $oProperty.Name) Then SetError(101, $iIndex, 0) ; Case doesn't match
		EndIf
	Next
	Return 1

EndFunc   ;==>__OL_CheckPropertiesEx