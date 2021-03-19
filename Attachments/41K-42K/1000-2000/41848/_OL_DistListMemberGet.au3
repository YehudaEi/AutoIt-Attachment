#include "H:\tools\autoit3\Outlookex\outlookex.au3"

$sDLName = InputBox("", "Enter Distribution List Name:", "", " M", 300, 130)
If @error = 1 Then Exit
$oOutlook = _OL_Open()
If @error Then Exit MsgBox(0, "Error", "Error creating a connection to Outlook.")
Global $aRecipient = _OL_ItemRecipientCheck($oOutlook, $sDLName)
If @error Or $aRecipient[0][0] = 0 Or $aRecipient[1][1] = False Then Exit MsgBox(16, "OutlookEX UDF", "Addresslist not found or not unique. @error = " & @error & ", @extended = " & @extended)
Global $members = _OL_DistListMemberGetEx($oOutlook, $aRecipient[1][3])
If @error Then Exit MsgBox(0, "Error", "Error " & @error & " retrieving the DL.")
_OL_Close($oOutlook)
_ArrayDisplay($members)

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
Func _OL_DistListMemberGetEx($oOL, $vItem, $sStoreID = Default)

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