; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_FolderClassSet
; Description ...: Set the default form (message class) for a folder
; Syntax.........: _OL_FolderClassSet($oFolder, $sMsgClass)
; Parameters ....: $oFolder   - Folder object of the folder to be changed as returned by _OL_FolderAccess
;                  $sMsgClass - New message class to set for the folder. Has to start with the DefaultMessageClass e.g. IPM.NOTE.mynote for class IPM.NOTE
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - $oFolder is not an object
;                  |2 - message class IPM.NOTE can not be default for any folders
;                  |3 - message class IPM.POST can only be default for mail/post folders
;                  |4 - New message class has to start with the DefaultMessageClass e.g. IPM.NOTE.mynote for class IPM.NOTE
;                  |5 - Parameter $sMsgClass is invalid. A required period is missing
;                  |6 - Error setting folder property. @extended is set to the COM error
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.outlookcode.com/codedetail.aspx?id=1594
; Example .......: Yes
; ===============================================================================================================================
Func _OL_FolderClassSet($oFolder, $sMsgClass)
	If Not IsObj($oFolder) Then Return SetError(1, 0, 0)
	Local $oPropertyAccessor, $iLoc
	Local Const $PR_DEF_POST_MSGCLASS = "http://schemas.microsoft.com/mapi/proptag/0x36E5001E"
	Local Const $PR_DEF_POST_DISPLAYNAME = "http://schemas.microsoft.com/mapi/proptag/0x36E6001E"
	Switch StringLeft(StringUpper($sMsgClass), 8)
		Case "IPM.NOTE" ; cannot be default for any folder
			Return SetError(2, 0, 0)
		Case "IPM.POST" ; default only for mail/post folders
			If $oFolder.DefaultMessageClass = "IPM.NOTE" Then Return SetError(3, 0, 0)
		Case Else ; New message class has to start with the DefaultMessageClass e.g. IPM.NOTE.mynote for class IPM.NOTE
			If StringInStr($sMsgClass, $oFolder.DefaultMessageClass) <> 1 Then Return SetError(4, 0, 0)
	EndSwitch
	$iLoc = StringInStr($sMsgClass, ".", 0, -1) ; Find last "." in class
	If @error Then Return SetError(5, 0, 0)
	Local $aSchema[2] = [$PR_DEF_POST_MSGCLASS, $PR_DEF_POST_DISPLAYNAME]
	Local $aValues[2] = [$sMsgClass, StringMid($sMsgClass, $iLoc + 1)]
	$oPropertyAccessor = $oFolder.PropertyAccessor
	$oPropertyAccessor.SetProperties($aSchema, $aValues)
	If @error Then Return SetError(6, @error, 0)
	$oPropertyAccessor = 0
EndFunc   ;==>_OL_FolderClassSet