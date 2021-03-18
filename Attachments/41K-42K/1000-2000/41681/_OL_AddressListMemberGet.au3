#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <OutlookEX.au3>

; *****************************************************************************
; Create test environment
; *****************************************************************************
Global $oOutlook = _OL_Open()
If @error <> 0 Then Exit MsgBox(16, "OutlookEX UDF", "Error creating a connection to Outlook. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; List all adress lists that are used when resolving an address then
; display all members of the first address list
; *****************************************************************************
Global $aResult = _OL_AddressListGet($oOutlook)
If @error <> 0 Then _
	Exit MsgBox(16, "OutlookEX UDF: _OL_AddressListMemberGet Example Script", "Error " & @error & " when listing address lists!")
$aResult = _OL_AddressListMemberGet($oOutlook, $aResult[1][2])
If @error <> 0 Then _
	Exit MsgBox(16, "OutlookEX UDF: _OL_AddressListMemberGet Example Script", "Error " & @error & " gettings members of first address lists!")
_ArrayDisplay($aResult, "OutlookEX UDF: _OL_AddressListMemberGet Example Script - All members of the first address list", _
	-1, 0, "", "|", "Row|EMail address|Name|OlAddresEntryUserType|Identifier|Object of the address entry")

_OL_Close($oOutlook)