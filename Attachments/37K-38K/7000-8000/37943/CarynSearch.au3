#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <SQlite.au3>
#include <SQlite.dll.au3>
#include <Process.au3>


Local $hQuery, $aRow

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
				$file = FileOpen("c:\a\Sql Queary Test.txt", 2)
				$sSQliteDll = _SQLite_Startup("c:\a\SQlite3.exe")
				If @error Then
					MsgBox(16, "SQLite Error", "SQLite.dll Can't be Loaded!" & @error)
					Exit -1
				Else
					MsgBox(0, "SQLite.dll Loaded", $sSQliteDll)
				EndIf

				;;______________________________________________________________________________________
				_SQLite_Open("c:\a\caz.db");;;FAILS HERE
				If @error Then
					MsgBox(16, "SQLite Error", "Can't create a memory Database!" & @error);;;;FAILS HERE
					Exit -1
				EndIf
				_SQLite_Close()
				;;_________________________________________________________________________________________________
				_SQLite_Exec("caz.db", "Select * From tblOrder;")
				FileClose($file)
				_RunDos("notepad c:\a\sql queary test.txt")
				$winclose = WinWaitClose("sql queary test.txt - notepad")

				If $winclose = 1 Then
					GUICtrlSetData(4, "")
					GUICtrlSetState(4, $gui_focus)
					_SQLite_Close()
					_SQLite_Shutdown()
				EndIf

			ElseIf $orderNumSearch1 <> "" Then
				$file = FileOpen("c:\a\Sql Queary Test.txt", 2)
				_SQLite_Startup()
				_SQLite_Open("c:\a\caz.db")
				_SQLite_Exec(-1, "Select * From tblorder;", "_cb")
				FileClose($file)
				_RunDos("notepad c:\a\sql queary test.txt")
			EndIf

			$winclose = WinWaitClose("sql queary test.txt - notepad")

			If $winclose = 1 Then
				GUICtrlSetData(6, "")
				GUICtrlSetState(4, $gui_focus)
				_SQLite_Close()
				_SQLite_Shutdown()

			EndIf
	EndSelect
WEnd
Func _cb($aRow)
	For $s In $aRow
		FileWrite($file, $s & @CRLF)
	Next
	FileWrite($file, @CRLF & "____________________________________________________________________________________________________" & @CRLF)

EndFunc   ;==>_cb
