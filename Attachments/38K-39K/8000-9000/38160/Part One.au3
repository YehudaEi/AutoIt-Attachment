Global $oOutlook = _OL_Open()
Global $asFolderList = _OL_FolderFind($oOutlook, "*", 99, "", 1, $olMailItem)
For $i = 1 To $asFolderList[0][0]
	If $asFolderList[$i][0] .UnReadItemCount > 0 Then ConsoleWrite($asFolderList[$i][0] .Folderpath & " Number of unread mails: " & $asFolderList[$i][0] .UnReadItemCount & @CRLF)
Next
_OL_Close($oOutlook)
