Local $SciteApp = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SciTE.exe","")
Local $ScitePath = StringTrimRight($SciteApp, 10)
Local $calltippsPath = $ScitePath & '\api\au3.user.calltips.api'
Local $newCalltips = _
'_GUICtrlListView_Formatting_Startup($hGUI, $hListView) initialize Global vars #include <LV_Format_include.au3>' & @CRLF & _
'_GUICtrlListView_Formatting_Shutdown() clean up ressources #include <LV_Format_include.au3>' & @CRLF & _
'_GUICtrlListView_AddOrIns_Item($hWnd, $sText [, $iItem=-1]) add or insert Item #include <LV_Format_include.au3>' & @CRLF & _
'_GUICtrlListView_FormattedDeleteItem($hWnd, $iIndex) delete Item at index #include <LV_Format_include.au3>' & @CRLF & _
'_GUICtrlListView_FormattedDeleteItemsSelected($hWnd) delete selected item #include <LV_Format_include.au3>' & @CRLF & _
'_GUICtrlListView_FormattedDeleteAllItems($hWnd) delete all item #include <LV_Format_include.au3>' & @CRLF & _
'_GUICtrlListView_DefaultsSet([$iBkCol[, $iCol[, $iSize[, $iWeight[, $sFont]]]]]) set values for defaults #include <LV_Format_include.au3>' & @CRLF & _
'_GUICtrlListView_FormattingCell($hWnd, $iItem, $iSubItem[, $iBkCol[, $iCol[, $iSize[, $iWeight[, $sFont]]]]]) set format for LV-cell #include <LV_Format_include.au3>'
If FileExists($calltippsPath) Then FileCopy($calltippsPath, $calltippsPath & '.bak', 1)
Local $fh = FileOpen($calltippsPath, 1)
If FileWrite($fh, $newCalltips) Then
	MsgBox(0, '', 'Succes')
Else
	MsgBox(0, '', 'An error is occured')
EndIf
FileClose($fh)
