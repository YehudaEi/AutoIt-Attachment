#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <sqlite.au3>
#include <sqlite.dll.au3>
#include <Process.au3>
#include <Excel.au3>


Local $hQuery, $aRow
Local $aResult, $iRows, $iColumns, $iRval


GUICreate("Caryns Search", 1265, 725)
GUICtrlCreateLabel("Customers Name", 20, 50, 150)
$custnameSearch = GUICtrlCreateInput("", 200, 50)
GUICtrlCreateLabel("Order Number", 20, 80)
$orderNumSearch = GUICtrlCreateInput("", 200, 80, 150)
$enterSearch = GUICtrlCreateButton("Enter", 1000, 600, 100, 40)

GUISetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $enterSearch
			$custnameSearch1 = GUICtrlRead($custnameSearch)
			$orderNumSearch1 = GUICtrlRead($orderNumSearch)

			If $custnameSearch1 <> "" Then

				Local $oExcel = _ExcelBookNew()
				_SQLite_Startup()
				ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)

				_SQLite_Open("c:\aWork\Autoit\caz.db")
				;$iRval = _SQLite_GetTable2d(-1, "Select * From tblorder where custnme like" & "'" & "%" & $custnameSearch1 & "%" & "'", "_cb")
				$iRval = _SQLite_GetTable2d(-1, "Select * From tblorder where custnme like" & "'" & "%" & $custnameSearch1 & "%" & "'",  $aResult, $iRows, $iColumns)
				EndIf
            If $iRval = $SQLITE_OK Then
                _SQLite_Display2DResult($aResult)

			EndIf
			 ;_ExcelWriteArray($oExcel, 1, 1, $aArray) ; Write the Array Horizontally
				MsgBox(0, "Exiting", "Press OK to Save File and Exit")
				_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; Now we save it into the temp directory; overwrite existing file if necessary
				$winclose = _ExcelBookClose($oExcel) ; And finally we close out
			If $winclose = 1 Then
					GUICtrlSetData(4, "")
					GUICtrlSetState(4, $gui_focus)
					_SQLite_Close()
					_SQLite_Shutdown()
			EndIf


	EndSelect

WEnd
