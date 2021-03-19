; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_DistListMemberGet
; Description ...: Gets all members of an Outlook or Exchange distribution list.
; Syntax.........: _OL_DistListMemberGet($oOL, $vItem[, $sStoreID = Default])
; Parameters ....: $oOL      - Outlook object returned by a preceding call to _OL_Open()
;                  $vItem    - EntryID or object of the distribution list item
;                  $sStoreID - Optional: StoreID where the EntryID is stored. Use the keyword "Default" to use the users mailbox
; Return values .: Success - two-dimensional one based array with the following information:
;                  |0 - Recipient object of the member
;                  |1 - Name of the member
;                  |2 - EntryID of the member
;                  Failure - Returns "" and sets @error:
;                  |1 - No distribution list item specified
;                  |2 - Item could not be found. EntryID might be wrong
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_DistListMemberGet($oOL, $vItem, $sStoreID = Default)

	If Not IsObj($vItem) Then
		If StringStripWS($vItem, 3) = "" Then Return SetError(1, 0, "")
		$vItem = $oOL.Session.GetItemFromID($vItem, $sStoreID)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	If $vItem.AddressEntryUserType = $olExchangeDistributionListAddressEntry Then
		$vItem = $vItem.GetExchangeDistributionListMembers()
		Local $aMembers[$vItem.Count + 1][3] = [[$vItem.Count, 3]]
		For $iIndex = 1 To $vItem.Count
			$aMembers[$iIndex][0] = $vItem.Item($iIndex)
			$aMembers[$iIndex][1] = $vItem.Item($iIndex).Name
			$aMembers[$iIndex][2] = $vItem.Item($iIndex).ID
		Next
	Else
		Local $aMembers[$vItem.MemberCount + 1][3] = [[$vItem.MemberCount, 3]]
		For $iIndex = 1 To $vItem.MemberCount
			$aMembers[$iIndex][0] = $vItem.GetMember($iIndex)
			$aMembers[$iIndex][1] = $vItem.GetMember($iIndex).Name
			$aMembers[$iIndex][2] = $vItem.GetMember($iIndex).EntryID
		Next
	EndIf
	Return $aMembers

EndFunc   ;==>_OL_DistListMemberGet