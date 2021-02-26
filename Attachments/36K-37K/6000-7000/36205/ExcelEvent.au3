#include-once

; *******************************************************
; Example - How to get events from Excel using Excel internal Visual Basic components.
; *******************************************************

; NOTES - doesnt recognize from which excel the events come. => trouble if many excels open which have
; VB script sending msgs to mailslot.
; Recognition could be added for example by fetching the window handle or window title with VB and passing
; it to mailslot.

; #LIST OF EVENTS#================================================================================
; Activate
; AddinInstall
; AddinUninstall
; AfterXmlExport
; AfterXmlImport
; BeforeClose
; BeforePrint
; BeforeSave
; BeforeXmlExport
; BeforeXmlImport
; Deactivate
; NewSheet
; Open
; PivotTableCloseConnection
; PivotTableOpenConnection
; RowsetComplete
; SheetActivate
; SheetBeforeDoubleClick
; SheetBeforeRightClick
; SheetCalculate
; SheetChange
; SheetDeactivate
; SheetFollowHyperlink
; SheetPivotTableUpdate
; SheetSelectionChange
; Sync
; WindowActivate
; WindowDeactivate
; WindowResize
; #END LIST OF EVENTS#=====================================================================

#region - #INCLUDES#===============================================================================================


#include <Excel.au3>
#include "MailSlot\MailSlot.au3" ; uses mailslots for communicating between Excel VB and AutoIt. (http://www.autoitscript.com/forum/topic/106710-mailslot/)
#include <Debug.au3> ; for debugging functions
#include <Array.au3> ; array functions

Global $hExcelEventMailSlot, _ ; Stores AutoIt mailslot handle
		$aExcelEventRegisteredFunctions[1] ; Stores function names registered to excel events

#endregion - #INCLUDES#===============================================================================================

#region - #FUNCTIONS#================================================================================================



#region - _ExcelEvent

;===============================================================================
;
; Description:		: Registers function to excel event. Regurlary checks if events have occured and runs
;					  	the functions registered to the event. Check interval for events can be set by
;					  	parameter $eventtime. Setting $eventName to "" sets only check interval.
; Parameter(s):		: $oExcel - an object variable pointing to the Excel.Application
;					 	$eventName - name of the event to look for. Available events: http://msdn.microsoft.com/en-us/library/microsoft.office.interop.excel.workbook_events.aspx
;					 	$functionName - name of user defined function to be called when event occurs
;					 	$checktime - OPTIONAL. Registers how often event occuring is checked. Default = 250 ms
; Requirement:		: #include "MailSlot.au3" ; http://www.autoitscript.com/forum/topic/106710-mailslot/
;					 	#include <Array.au3>
; Return Value(s):	: On Success - Returns 1
;                  	 	On Failure - Returns 0 and sets @error on errors:
;                  		|@error=1 - Didn't find ThisWorkbook object.
;                  		|@error=2 - Function already registered.
; User CallTip:		: _ExcelEvent($oExcel, $eventName, $functionName [, $checktime = 250])
;						Registers function to be executed when event occurs. (Requires: #include "ExcelEvent.au3")
; Author(s):		: Eemuli
; Note(s):			: http://msdn.microsoft.com/en-us/library/microsoft.office.interop.excel.workbook_events.aspx
;						Check interval is for ALL events.
;
;===============================================================================

Func _ExcelEvent($oExcel, $eventName, $functionName, $checktime = 250)
	Local $VBcode, $oModule, $oModules, $VBkey, $iAddLine, $sTemp, $aTemp, $i

	$oModules = $oExcel.ActiveWorkbook.VBProject.VBComponents
	$oModule = $oModules.Item("ThisWorkbook").CodeModule
	If Not IsObj($oModule) Then Return SetError(1, 0, 0)

	If $oModule.CountOfLines > 0 Then
		$sTemp = $oModule.Lines(1, $oModule.CountOfLines)
	Else
		$sTemp = ""
	EndIf

	If Not StringInStr($sTemp, "'AutoIt ExcelEvents") Then

		; VB code which is used to write to mailslot
		$VBcode = "'AutoIt ExcelEvents. This text is used for recognition." & @CRLF & _
				"'Visual Basic snippet for sending a mailslot msg." & @CRLF & _
				"'http://www.shamrock-software.eu/popup.htm" & @CRLF & _
				"Const PopAdr$ = ""*"" 'To all workstations" & @CRLF & _
				@CRLF & _
				"'Windows API: File open/close functions" & @CRLF & _
				"Private Declare Function CreateFile Lib ""kernel32"" _" & @CRLF & _
				" Alias ""CreateFileA"" (ByVal lpFileName As String, _" & @CRLF & _
				" ByVal dwDesiredAccess As Long, ByVal dwShareMode _" & @CRLF & _
				" As Long, ByVal lpSecurityAttributes As Long, _" & @CRLF & _
				" ByVal dwCreationDisposition As Long, _" & @CRLF & _
				" ByVal dwFlagsAndAttributes As Long, _" & @CRLF & _
				" ByVal hTemplateFile As Long) As Long" & @CRLF & _
				"Private Declare Function WriteFile Lib ""kernel32"" _" & @CRLF & _
				"(ByVal hFile As Long, ByVal lpBuffer As Any, _" & @CRLF & _
				" ByVal nNumberOfBytesToWrite As Long, _" & @CRLF & _
				" lpNumberOfBytesWritten As Long, _" & @CRLF & _
				" ByVal lpOverlapped As Long) As Long" & @CRLF & _
				"Private Declare Function CloseHandle Lib _" & @CRLF & _
				" ""kernel32"" (ByVal hHandle As Long) As Long" & @CRLF & _
				@CRLF & _
				"'File open constants" & @CRLF & _
				"Private Const OPEN_EXISTING = 3" & @CRLF & _
				"Private Const GENERIC_WRITE = &H40000000" & @CRLF & _
				"Private Const FILE_SHARE_READ = &H1" & @CRLF & _
				"Private Const FILE_ATTRIBUTE_NORMAL = &H80" & @CRLF & _
				@CRLF & _
				"Private Sub SendMailSlot(e$)" & @CRLF & _
				"'Sends message text e$ to destination" & @CRLF & _
				"Dim f$, i, h" & @CRLF & _
				" f$ = e$" & @CRLF & _
				" h = CreateFile(""\\.\mailslot\Excel\AutoItevents"", _" & @CRLF & _
				"  GENERIC_WRITE, FILE_SHARE_READ, 0&, _" & @CRLF & _
				"  OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0&)" & @CRLF & _
				" If h Then" & @CRLF & _
				"  WriteFile h, f$, Len(f$), i, 0: CloseHandle h" & @CRLF & _
				" End If" & @CRLF & _
				"End Sub"

		$oModule.InsertLines(1, $VBcode)
	EndIf

	; $VBkey is used to recognize the starting point of event function in Excel if it exists.
	Switch $eventName

		Case "Activate"
			$VBkey = 'Private Sub Workbook_Activate()'
			$VBcode = 'SendMailSlot ("Activate")'

		Case "AddinInstall"
			$VBkey = 'Private Sub Workbook_AddinInstall()'
			$VBcode = 'SendMailSlot ("AddinInstall")'

		Case "AddinUninstall"
			$VBkey = 'Private Sub Workbook_AddinUninstall()'
			$VBcode = 'SendMailSlot ("AddinUninstall")'

		Case "AfterXmlExport"
			$VBkey = 'Private Sub Workbook_AfterXmlExport(ByVal Map As XmlMap, ByVal Url As String, ByVal Result As XlXmlExportResult)'
			$VBcode = 'SendMailSlot ("AfterXmlExport")'

		Case "AfterXmlImport"
			$VBkey = 'Private Sub Workbook_AfterXmlImport(ByVal Map As XmlMap, ByVal IsRefresh As Boolean, ByVal Result As XlXmlImportResult)'
			$VBcode = 'SendMailSlot ("AfterXmlImport")'

		Case "BeforeClose"
			$VBkey = 'Private Sub Workbook_BeforeClose(Cancel As Boolean)'
			$VBcode = 'SendMailSlot ("BeforeClose")'

		Case "BeforePrint"
			$VBkey = 'Private Sub Workbook_BeforePrint(Cancel As Boolean)'
			$VBcode = 'SendMailSlot ("BeforePrint")'

		Case "BeforeSave"
			$VBkey = 'Private Sub Workbook_BeforeSave(ByVal SaveAsUI As Boolean, Cancel As Boolean)'
			$VBcode = 'SendMailSlot ("BeforeSave")'

		Case "BeforeXmlExport"
			$VBkey = 'Private Sub Workbook_BeforeXmlExport(ByVal Map As XmlMap, ByVal Url As String, Cancel As Boolean)'
			$VBcode = 'SendMailSlot ("BeforeXmlExport")'

		Case "BeforeXmlImport"
			$VBkey = 'Private Sub Workbook_BeforeXmlImport(ByVal Map As XmlMap, ByVal Url As String, ByVal IsRefresh As Boolean, Cancel As Boolean)'
			$VBcode = 'SendMailSlot ("BeforeXmlImport")'

		Case "Deactivate"
			$VBkey = 'Private Sub Workbook_Deactivate()'
			$VBcode = 'SendMailSlot ("Deactivate")'

		Case "NewSheet"
			$VBkey = 'Private Sub Workbook_NewSheet(ByVal Sh As Object)'
			$VBcode = 'SendMailSlot ("NewSheet")'

		Case "Open"
			$VBkey = 'Private Sub Workbook_Open()'
			$VBcode = 'SendMailSlot ("Open")'

		Case "PivotTableCloseConnection"
			$VBkey = 'Private Sub Workbook_PivotTableCloseConnection(ByVal Target As PivotTable)'
			$VBcode = 'SendMailSlot ("PivotTableCloseConnection")'

		Case "PivotTableOpenConnection"
			$VBkey = 'Private Sub Workbook_PivotTableOpenConnection(ByVal Target As PivotTable)'
			$VBcode = 'SendMailSlot ("PivotTableOpenConnection")'

		Case "RowsetComplete"
			$VBkey = 'Private Sub Workbook_RowsetComplete(ByVal Description As String, ByVal Sheet As String, ByVal Success As Boolean)'
			$VBcode = 'SendMailSlot ("RowsetComplete")'

		Case "SheetActivate"
			$VBkey = 'Private Sub Workbook_SheetActivate(ByVal Sh As Object)'
			$VBcode = 'SendMailSlot ("SheetActivate")'

		Case "SheetBeforeDoubleClick"
			$VBkey = 'Private Sub Workbook_SheetBeforeDoubleClick(ByVal Sh As Object, ByVal Target As Range, Cancel As Boolean)'
			$VBcode = 'SendMailSlot ("SheetBeforeDoubleClick")'

		Case "SheetBeforeRightClick"
			$VBkey = 'Private Sub Workbook_SheetBeforeRightClick(ByVal Sh As Object, ByVal Target As Range, Cancel As Boolean)'
			$VBcode = 'SendMailSlot ("SheetBeforeRightClick")'

		Case "SheetCalculate"
			$VBkey = 'Private Sub Workbook_SheetCalculate(ByVal Sh As Object)'
			$VBcode = 'SendMailSlot ("SheetCalculate")'

		Case "SheetChange"
			$VBkey = 'Private Sub Workbook_SheetChange(ByVal Sh As Object, ByVal Target As Range)'
			$VBcode = 'SendMailSlot ("SheetChange")'

		Case "SheetDeactivate"
			$VBkey = 'Private Sub Workbook_SheetDeactivate(ByVal Sh As Object)'
			$VBcode = 'SendMailSlot ("SheetDeactivate")'

		Case "SheetFollowHyperlink"
			$VBkey = 'Private Sub Workbook_SheetFollowHyperlink(ByVal Sh As Object, ByVal Target As Hyperlink)'
			$VBcode = 'SendMailSlot ("SheetFollowHyperlink")'

		Case "SheetPivotTableUpdate"
			$VBkey = 'Private Sub Workbook_SheetPivotTableUpdate(ByVal Sh As Object, ByVal Target As PivotTable)'
			$VBcode = 'SendMailSlot ("SheetPivotTableUpdate")'

		Case "SheetSelectionChange"
			$VBkey = 'Private Sub Workbook_SheetSelectionChange(ByVal Sh As Object, ByVal Target As Range)'
			$VBcode = 'SendMailSlot ("SheetSelectionChange")'

		Case "Sync"
			$VBkey = 'Private Sub Workbook_Sync(ByVal SyncEventType As Office.MsoSyncEventType)'
			$VBcode = 'SendMailSlot ("Sync")'

		Case "WindowActivate"
			$VBkey = 'Private Sub Workbook_WindowActivate(ByVal Wn As Window)'
			$VBcode = 'SendMailSlot ("WindowActivate")'

		Case "WindowDeactivate"
			$VBkey = 'Private Sub Workbook_WindowDeactivate(ByVal Wn As Window)'
			$VBcode = 'SendMailSlot ("WindowDeactivate")'

		Case "WindowResize"
			$VBkey = 'Private Sub Workbook_WindowResize(ByVal Wn As Window)'
			$VBcode = 'SendMailSlot ("WindowResize")'

		Case Default
			$VBcode = ""

	EndSwitch

	If $VBcode <> "" Then

		; Finds the starting line for function
		$iAddLine = 1
		For $i = 1 To $oModule.CountOfLines

			$sTemp = $oModule.Lines($i, 1)
			If StringInStr($sTemp, $VBkey) Then ; if event function already exists, writes into it.
				$iAddLine = $i + 1
				ExitLoop
			EndIf

		Next

		; If $VBkey (event function) not found, then adds the function into workbook.
		; NOTE - function must be added to the end of file, otherwise it screws up declarations at the top of VB file.
		If $iAddLine = 1 Then
			$iAddLine = $oModule.CountOfLines
			If $iAddLine = 0 Then $iAddLine = 1
			$sTemp = $VBcode
			$VBcode = $VBkey & @CRLF & $sTemp & @CRLF & 'End Sub'
		Else

			For $i = $iAddLine To $oModule.CountOfLines
				If $oModule.Lines($i, 1) = "End Sub" Then

					$sTemp = $oModule.Lines($iAddLine - 1, $i)
					If StringInStr($sTemp, $VBcode) Then
						$VBcode = ""
					EndIf
					ExitLoop

				EndIf
			Next

		EndIf


		; If script doesnt have mailslot for excel events, creates one.
		If Not $hExcelEventMailSlot Then
			$hExcelEventMailSlot = _MailSlotCreate("\\.\mailslot\Excel\AutoItevents")
		EndIf

		; inserts the $VBcode into the event function
		If $VBcode Then $oModule.InsertLines($iAddLine, $VBcode)

		; Adds users function to array. When event occurs array is searched for this function
		; $aExcelEventRegisteredFunctions [0] = not used
		; [1] = event name, [2] = function name to be executed,
		; [3] = event name, [4] = function name to be executed, ...
		$aTemp = _ArrayFindAll($aExcelEventRegisteredFunctions, $eventName)
		If $aTemp = -1 Then
			_ArrayAdd($aExcelEventRegisteredFunctions, $eventName)
			_ArrayAdd($aExcelEventRegisteredFunctions, $functionName)

		Else
			For $i In $aTemp ; checks if already added
				If $functionName = $aExcelEventRegisteredFunctions[$i + 1] Then
					$eventName = ""
				EndIf
			Next
			If $eventName <> "" Then
				_ArrayAdd($aExcelEventRegisteredFunctions, $eventName)
				_ArrayAdd($aExcelEventRegisteredFunctions, $functionName)

			Else
				Return SetError(2, 0, 0)
			EndIf


		EndIf

	EndIf

	AdlibRegister("_ExcelEventHandler", $checktime)
	OnAutoItExitRegister("_ExcelEventsClose") ; closes mailslot on exit

	Return 1

EndFunc   ;==>_ExcelEvent
#endregion - _ExcelEvent




#region - _ExcelEventHandler

;===============================================================================
;
; Description:		: Mainly for internal use. Called regurlary to check if events have occured in Excel.
;					  	Calls the user-defined function which have been attached to the event.
;					  	Gives the event name as parameter to the user-function.
; Parameter(s):		: -
; Requirement:		: #include "MailSlot.au3" ; http://www.autoitscript.com/forum/topic/106710-mailslot/
;					 	#include <Array.au3>
; Return Value(s):	: On Success - Returns 1
;                  	 	On Failure - Returns 0 and sets @error on errors:
;                  		|@error=1 - User-defined function call failed. Function doesnt exist or invalid number of parameters.
; User CallTip:		: _ExcelEventHandler()
;						Checks if events have occured in Excel and calls user-defined function registered to the event. (Requires: #include "ExcelEvent.au3")
; Author(s):		: Eemuli
; Note(s):			: Communicates with Excel VB script using mailslot system.
;						When event occurs VB script sends a message to mailslot with event name.
;						Mailslots: http://msdn.microsoft.com/en-us/library/aa365576%28VS.85%29.aspx
;						Events: http://msdn.microsoft.com/en-us/library/microsoft.office.interop.excel.workbook_events.aspx
;
;===============================================================================

Func _ExcelEventHandler()
	Local $iSize, $sData

	While _MailSlotGetMessageCount($hExcelEventMailSlot) > 0

		; Reads next msg from mailslot
		Local $iSize = _MailSlotCheckForNextMessage($hExcelEventMailSlot)
		If $iSize Then
			Local $sData = _MailSlotRead($hExcelEventMailSlot, $iSize, 1)
		EndIf

		; Searches through the array for functions.
		Local $aTemp
		$aTemp = _ArrayFindAll($aExcelEventRegisteredFunctions, $sData)

		If IsArray($aTemp) Then
			For $i In $aTemp

				Call($aExcelEventRegisteredFunctions[$i + 1], $sData)
				If @error Then Return SetError(1, 0, 0)

			Next
		EndIf
	WEnd

	Return 1

EndFunc   ;==>_ExcelEventHandler
#endregion - _ExcelEventHandler


#region - _ExcelUnEvent

;===============================================================================
;
; Description:		: Unregisters function from excel event.
; Parameter(s):		: $eventName - event name where function was registered
;						$functionName - name of the function registered
; Requirement:		: #include <Array.au3>
; Return Value(s):	: On Success - Returns 1
;                  	 	On Failure - Returns 0 and sets @error on errors:
;                  		|@error=1 - No functions registered to given event.
; User CallTip:		: _ExcelUnEvent($eventName, $functionName)
;						Unregisters function from excel event. (Requires: #include "ExcelEvent.au3")
; Author(s):		: Eemuli
; Note(s):			: Doesnt remove VB code from excel workbook. So Excel keeps sending event messages to mailslot.
;
;===============================================================================

Func _ExcelUnEvent($eventName, $functionName)
	Local $aTemp, $i

	$aTemp = _ArrayFindAll($aExcelEventRegisteredFunctions, $eventName)
	If @error Then Return SetError(1, 0, 0)

	If IsArray($aTemp) Then
		For $i = 0 To UBound($aTemp) - 1

			If $functionName = $aExcelEventRegisteredFunctions[$aTemp[$i] + 1] Then
				_ArrayDelete($aExcelEventRegisteredFunctions, $aTemp[$i])
				_ArrayDelete($aExcelEventRegisteredFunctions, $aTemp[$i])

				For $i2 = 0 To UBound($aTemp) - 1
					$aTemp[$i2] -= 2
				Next
			EndIf

		Next
	EndIf

	Return 1

EndFunc   ;==>_ExcelUnEvent
#endregion - _ExcelUnEvent


; closes mailslot when autoit exits
Func _ExcelEventsClose()
	_MailSlotClose($hExcelEventMailSlot)
EndFunc   ;==>_ExcelEventsClose




#endregion - #FUNCTIONS#================================================================================================





