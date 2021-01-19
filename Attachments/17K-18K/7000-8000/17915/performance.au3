#include <GUIConstants.au3>
#include <GuiConstantsEx.au3>
#include <GuiListView.au3>

;~ Which PublicFolder has to be checked? ====> PLEASE CHANGE TO ONE OF YOUR PUBLIC FOLDERS !!!!!
;~ =========================================================================================================================
CONST $PublicFolder = "Öffentliche Ordner\Alle Öffentlichen Ordner\HIS\HIS (00031293)\HIS42\HIS05\HIS05RS\GHCP-Support"
;~ =========================================================================================================================


Dim $objApp, $objNS, $objFolder

;Create MAIN-GUI
$GHCP = GUICreate("Performance-Test",600,150, @DesktopWidth - 605, @DesktopHeight - 200, -1, BitOr($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST))
$SListView = GUICtrlCreateListView("Received|Sender|Subject" ,5,5,450,140)
GUICtrlSetFont($SListView, 7)
_GUICtrlListView_SetColumnWidth ($SListView, 0, 100)
_GUICtrlListView_SetColumnWidth ($SListView, 1, 80)
_GUICtrlListView_SetColumnWidth ($SListView, 2, 222)
GUISetState(@SW_SHOW, $GHCP)

If NOT _GetConnection() Then
	MsgBox(16+4096+262144,"ERROR!", "No Outlook-Connection available!")
	Exit
EndIf

;Get Connection to the Support-Folder
$SupportFolder = _GetFolder ($PublicFolder)

; Fill LV with unread items
_UpdateListView()

;Initialize Timer
AdlibEnable( "_TimerEvent", 5000)


While 1
	$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE 
				ExitLoop
		EndSelect
WEnd
ConsoleWrite("Program terminated" & @CRLF)


;~ ************************************************************************************************************


Func _TimerEvent()
	;Update ListView with mailitems
	_UpdateListView()
	ConsoleWriteError(_GUICtrlListView_GetItemCount($SListView) & " Items in Public Folder found!" & @CRLF)
EndFunc


Func _UpdateListView()
;~ 	Local $LVItem
	$Items = _GetAllMessages($SupportFolder)
	$UnreadMessageAvailable = FALSE
	If $Items.Count > 0 Then
		;Reduce flicker while updating
		GUISetState(@SW_LOCK, $GHCP)
		
		;Delete all "old" entries
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($SListView))
				
		ConsoleWrite("Timing..." & @CRLF)
		Local $Time = TimerInit()
		
		; Create LV-Item for each unread element and add it's receivedtime to the ItemTimes-Array
		For $i=1 To $Items.Count
			
			; UDF-Version (unfortunately no textcolor-change)
			;==================================================
			_GUICtrlListView_AddItem ($SListView, _GetReceivedTimeFormatted($Items.Item($i).ReceivedTime))
			_GUICtrlListView_AddSubItem ($SListView, $i-1, $Items.Item($i).SenderName, 1)
			_GUICtrlListView_AddSubItem ($SListView, $i-1, $Items.Item($i).Subject, 2)

			; Built-In-Version (able to change text-color)
			;=============================================
;~ 			$LVItem = GuiCtrlCreateListViewItem(_GetReceivedTimeFormatted($Items.Item($i).ReceivedTime) & "|" & $Items.Item($i).SenderName & "|" & $Items.Item($i).Subject,$SListView)
;~ 			If $Items.Item($i).Unread Then
;~ 				GUICtrlSetColor($LVItem,0xff0000)
;~ 				$UnreadMessageAvailable = TRUE
;~ 			EndIf

		Next
		ConsoleWrite("Timing finished. Duration: " & TimerDiff($Time) & @CRLF)

		;Update the changes of the Listview (reducing flicker)
		GUISetState(@SW_UNLOCK, $GHCP)
	EndIf
EndFunc


Func _GetReceivedTimeFormatted($ReceivedTime)
	Dim $ReceivedTimeFormatted
	If StringLen($ReceivedTime)=14 Then
		$ReceivedTimeFormatted = StringMid($ReceivedTime,7,2) & "." & StringMid($ReceivedTime,5,2) & "." & StringLeft($ReceivedTime,4) & " " & StringMid($ReceivedTime,9,2) & ":" & StringMid($ReceivedTime,11,2) & ":" & StringMid($ReceivedTime,13,2)
	Else
		$ReceivedTimeFormatted = -1
	EndIf
	Return $ReceivedTimeFormatted
EndFunc


Func _GetAllMessages($objFolder)
	Dim $objItems
	If $objFolder.Items.Count > 0 Then
		$objItems = $objFolder.Items
	EndIf
	If $objItems.Count > 1 Then $objItems.Sort("[ReceivedTime]", True)
	Return $objItems
EndFunc


Func _GetFolder($strFolderPath)
    Dim $arrFolders
	Dim $colFolders
    $arrFolders = StringSplit($strFolderPath, "\")
	$objFolder = $objNS.Folders.Item($arrFolders[1])
	If  IsObj($objFolder) Then
		For $i = 2 To $arrFolders[0]
			$colFolders = $objFolder.Folders
			$objFolder = $colFolders.Item($arrFolders[$i])
			If Not IsObj($objFolder) Then
				ExitLoop
			EndIf
		Next
	EndIf
	Return $objFolder
EndFunc


Func _GetConnection()
	$objApp = ObjCreate("Outlook.Application")
    $objNS = $objApp.GetNamespace("MAPI")
	If NOT isObj($objNS) Then
		Return False
	Else
		Return True
	EndIf
EndFunc