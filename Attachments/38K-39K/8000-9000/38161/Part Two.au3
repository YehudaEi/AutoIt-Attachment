#AutoIt3Wrapper_Au3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=Y
#include <OutlookEX.au3>

Global $asUnreadmails[1], $asTemp, $iIndexFolder, $iIndexMail = 0, $iUnReadMails, $iIndexItem
Global $oOutlook = _OL_Open()
Global $asFolderList = _OL_FolderFind($oOutlook, "*", 99, "", 1, $olMailItem)
For $iIndexFolder = 1 To $asFolderList[0][0]
    $iUnReadMails = $asFolderList[$iIndexFolder][0] .UnReadItemCount
    If $iUnReadMails > 0 Then
ConsoleWrite($asFolderList[$iIndexFolder][0].Folderpath & " Number of unread mails: " & $asFolderList[$iIndexFolder][0].UnReadItemCount & @CRLF)
        ReDim $asUnreadmails[UBound($asUnreadmails) + $iUnReadMails]
        $asTemp = _OL_ItemFind($oOutlook, $asFolderList[$iIndexFolder][0], $olMail, "[UnRead]=True", "", "", "EntryID", "")
        For $iIndexItem = 1 To $asTemp[0][0]
            $iIndexMail += 1
            $asUnreadmails[$iIndexMail] = $asTemp[$iIndexItem][0]
        Next
    EndIf
Next
$asUnreadmails[0] = UBound($asUnreadmails) - 1
_ArrayDisplay($asUnReadMails)
_OL_Close($oOutlook)