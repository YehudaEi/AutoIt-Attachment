#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <File.au3>
#include <Array.Au3>

;===============================================================================
; Variables: ListView Sorting
;===============================================================================
;Global Const $LVFI_PARAM			= 0x0001

;Global Const $LVIF_TEXT				= 0x0001
Global Const $LVIF_PARAM			= 0x0004 ; Important for finding/sorting listview item

;Global Const $LVM_FIRST				= 0x1000
;Global Const $LVM_GETITEMCOUNT		= $LVM_FIRST + 4
Global Const $LVM_GETITEM			= $LVM_FIRST + 5
Global Const $LVM_INSERTITEM		= $LVM_FIRST + 7
Global Const $LVM_FINDITEM			= $LVM_FIRST + 13
;Global Const $LVM_SETCOLUMNWIDTH	= $LVM_FIRST + 30
Global Const $LVM_SETITEMTEXT		= $LVM_FIRST + 46
;Global Const $LVM_SETSELECTEDCOLUMN	= $LVM_FIRST + 140

Dim $nCurCol	= -1
Dim $nSortDir	= 1
Dim $bSet		= 0
Dim $nCol		= -1

;===============================================================================
; Variables
;===============================================================================
Global Const $WM_NOTIFY = 0x004E
Global Const $LVN_FIRST = (-100)
Global Const $LVN_GETINFOTIPA = ($LVN_FIRST - 57)        ;---             IE >= 0x0400    NonUnicode
Global Const $LVN_GETINFOTIPW = ($LVN_FIRST - 58)        ;---             IE >= 0x0400    Unicode
Dim $aFile				;Array used for directory searches
Dim $aFileList[1][5]	;Array of tracked files
Dim $StrFmt = "%.2f"	;Format for StringFormat()
Dim $B_DESCENDING[3]    ;Array to hold sort states for the listview
;===============================================================================
; == GUI generated with Koda ==
$FileSizeTracker = GUICreate("File Size Tracker", 507, 316, 194, 123)
$Group1 = GUICtrlCreateGroup("Add File(s) or Directory(s)", 8, 0, 491, 44)
$Add = GUICtrlCreateButton("Add File", 400, 16, 89, 20)
$Browse = GUICtrlCreateButton("Browse...", 331, 16, 57, 20)
$File = GUICtrlCreateInput("Click Browse...", 16, 16, 313, 21, $ES_WANTRETURN)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$listview = GUICtrlCreateListView("Filename|Size| ", 8, 44, 491, 242, $LVS_SINGLESEL, BitOR($LVS_EX_INFOTIP, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP, $LVS_EX_GRIDLINES, 0x00010000)) ;0x00010000 = LVS_EX_DOUBLEBUFFER
_GUICtrlListViewSetColumnWidth($listview, 0, 419)
_GUICtrlListViewSetColumnWidth($listview, 1, 42)
_GUICtrlListViewSetColumnWidth($listview, 2, 26)
GUISetState(@SW_SHOW)
GUICtrlRegisterListViewSort($listview, "LVSort")
GUIRegisterMsg($WM_NOTIFY, "WM_Notify_Events")
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $Add
			Main()
		Case $msg = $File
			Main()
		Case $msg = $Browse
			GUICtrlSetData($File, FileOpenDialog("Select a file.", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "All (*.*)", 1 + 2))
		Case $msg = $listview
			; sort the list by the column header clicked on
			$bSet = 0
			$nCurCol = $nCol
			GUICtrlSendMsg($listview, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($listview), 0)
			DllCall("user32.dll", "int", "InvalidateRect", "hwnd", ControlGetHandle($FileSizeTracker, "", $listview), "int", 0, "int", 1)
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case Else
			;;;;;;;
	EndSelect
WEnd
Exit

; Our sorting callback funtion
Func LVSort($hWnd, $nItem1, $nItem2, $nColumn)
    Local $nSort

    ; Switch the sorting direction
    If $nColumn = $nCurCol Then
        If Not $bSet Then
            $nSortDir = $nSortDir * - 1
            $bSet = 1
        EndIf
    Else
        $nSortDir = 1
    EndIf
    $nCol = $nColumn

    $val1 = GetSubItemText($listview, $nItem1, $nColumn)
    $val2 = GetSubItemText($listview, $nItem2, $nColumn)
    $val3 = 0
    $val4 = 0

    ; If it is the 2nd colum (columns starts with 0)
    If $nColumn = 1 Then
        $val3 = GetSubItemText($listview, $nItem1, $nColumn + 1)
        $val4 = GetSubItemText($listview, $nItem2, $nColumn + 1)
    ElseIf $nColumn = 2 Then
        $val3 = GetSubItemText($listview, $nItem1, $nColumn - 1)
        $val4 = GetSubItemText($listview, $nItem2, $nColumn - 1)
    EndIf

    $nResult = 0        ; No change of item1 and item2 positions

    If $val1 < $val2 And $nColumn = 1 Then
        _CheckLessThan($val3, $val4, $nColumn, $nResult)
    ElseIf $val1 > $val2 And $nColumn = 1 Then
        _CheckGreaterThan($val3, $val4, $nColumn, $nResult)
    ElseIf $val3 < $val4 And $nColumn = 2 Then
        _CheckLessThan($val1, $val2, $nColumn, $nResult)
    ElseIf $val3 > $val4 And $nColumn = 2 Then
        _CheckGreaterThan($val1, $val2, $nColumn, $nResult)
    ElseIf $nColumn = 0 Then
        If $val1 < $val2 Then $nResult = -1
        If $val1 > $val2 Then $nResult = 1
    EndIf

    $nResult = $nResult * $nSortDir

    Return $nResult
EndFunc   ;==>LVSort

Func _CheckLessThan(ByRef $val1, ByRef $val2, ByRef $nColumn, ByRef $nResult)
    Switch $val1
        Case "KB"
            If $val2 = $val1 Then
                $nResult = -1
            Else
                $nResult = 1
            EndIf
        Case "MB"
            If $val2 = $val1 Then
                $nResult = -1
            Else
                $nResult = 1
            EndIf
        Case "GB"
            If $val2 = $val1 Then
                $nResult = -1
            Else
                $nResult = 1
            EndIf
        Case "TB"
            If $val2 = $val1 Then
                $nResult = -1
            Else
                $nResult = 1
            EndIf
    EndSwitch
EndFunc   ;==>_CheckLessThan

Func _CheckGreaterThan(ByRef $val1, ByRef $val2, ByRef $nColumn, ByRef $nResult)
    Switch $val1
        Case "KB"
            If $val2 = $val1 Then
                $nResult = 1
            Else
                $nResult = -1
            EndIf
           
        Case "MB"
            If $val2 = $val1 Then
                $nResult = 1
            Else
                $nResult = -1
            EndIf
        Case "GB"
            If $val2 = $val1 Then
                $nResult = 1
            Else
                $nResult = -1
            EndIf
        Case "TB"
            If $val2 = $val1 Then
                $nResult = 1
            Else
                $nResult = -1
            EndIf
    EndSwitch
EndFunc   ;==>_CheckGreaterThan

; Retrieve the text of a listview item in a specified column
Func GetSubItemText($nCtrlID, $nItemID, $nColumn)
    Local $stLvfi = DllStructCreate("uint;ptr;int;int[2];int")
    DllStructSetData($stLvfi, 1, $LVFI_PARAM)
    DllStructSetData($stLvfi, 3, $nItemID)

    Local $stBuffer = DllStructCreate("char[260]")

    $nIndex = GUICtrlSendMsg($nCtrlID, $LVM_FINDITEM, -1, DllStructGetPtr($stLvfi));

    Local $stLvi = DllStructCreate("uint;int;int;uint;uint;ptr;int;int;int;int")

    DllStructSetData($stLvi, 1, $LVIF_TEXT)
    DllStructSetData($stLvi, 2, $nIndex)
    DllStructSetData($stLvi, 3, $nColumn)
    DllStructSetData($stLvi, 6, DllStructGetPtr($stBuffer))
    DllStructSetData($stLvi, 7, 260)

    GUICtrlSendMsg($nCtrlID, $LVM_GETITEM, 0, DllStructGetPtr($stLvi));

    $sItemText = DllStructGetData($stBuffer, 1)

    $stLvi = 0
    $stLvfi = 0
    $stBuffer = 0

    Return $sItemText
EndFunc   ;==>GetSubItemText

Func _ArrayDisplayConsole(Const ByRef $avArray, $sTitle="")
	Local $iCounter = 0, $sMsg = ""
	
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return 0
	EndIf
	
	For $iCounter = 0 To UBound($avArray) - 1
		$sMsg = $sMsg & "[" & $iCounter & "]    = " & StringStripCR($avArray[$iCounter]) & @CRLF
	Next
	
	ConsoleWrite($sMsg)
	SetError(0)
	Return 1
EndFunc   ;==>_ArrayDisplay

Func Main()
	;GUICtrlSetState($File, $GUI_DISABLE) ;Disable Input Box while processing
	;GUICtrlSetState($Add,  $GUI_DISABLE) ;Disable Add Button while processing
	$sFile = GUICtrlRead($File)
	Local $szDrive, $szDir, $szFName, $szExt
	If FileExists($sFile) Then
		;$File is a File/Dir and exists.
		If ((StringInStr(FileGetAttrib($sFile), "D") <> 0) Or (StringInStr($sFile, "*") <> 0)) Then
			;$File is a Dir, do recursion to add all files
			ConsoleWrite("Running: _FileSearch(""" & $sFile & """, 0)" & @CRLF)
			$aFile = _FileSearch($sFile, 0)
			_ArrayDisplayConsole($aFile)
			For $i = 1 To $aFile[0] Step 1
;~ 				If FileExists($sFile & $aFile[$i]) Then
				_PathSplit($sFile, $szDrive, $szDir, $szFName, $szExt)
				$WorkingDir = $szDrive & $szDir
				If FileExists($WorkingDir & $aFile[$i]) Then
					Local $aSize = _FileSize($WorkingDir & $aFile[$i])
					Local $tmp = GUICtrlCreateListViewItem($aFile[$i] & "|" & StringFormat($StrFmt, $aSize[0]) & "|" & $aSize[1], $listview)
					ReDim $aFileList[UBound($aFileList) + 1][5]
					$aFileList[UBound($aFileList) - 2][0] = $tmp
					$aFileList[UBound($aFileList) - 2][1] = $WorkingDir
					$aFileList[UBound($aFileList) - 2][2] = $aFile[$i]
					$aFileList[UBound($aFileList) - 2][3] = StringFormat($StrFmt, $aSize[0])
					$aFileList[UBound($aFileList) - 2][4] = $aSize[1]
				EndIf
			Next
		Else ;CreateListViewItem($sText, $nCtrlID, $nIndex)
			Local $aSize = _FileSize($sFile)
			Local $aPathSplit = _PathSplit($sFile, $szDrive, $szDir, $szFName, $szExt)
			Local $tmp = GUICtrlCreateListViewItem($szFName & $szExt & "|" & StringFormat($StrFmt, $aSize[0]) & "|" & $aSize[1], $listview)
			ReDim $aFileList[UBound($aFileList) + 1][5]
			$aFileList[UBound($aFileList) - 2][0] = $tmp
			$aFileList[UBound($aFileList) - 2][1] = $szDrive & $szDir
			$aFileList[UBound($aFileList) - 2][2] = ($aPathSplit[3] & $aPathSplit[4])
			$aFileList[UBound($aFileList) - 2][3] = StringFormat($StrFmt, $aSize[0])
			$aFileList[UBound($aFileList) - 2][4] = $aSize[1]
		EndIf
	Else
		MsgBox(4096, "ERROR: Nonexistent file", "File: " & $sFile & @CRLF & "This file can not be found.")
	EndIf
	LVColumnWidth()
EndFunc   ;==>Main
;===============================================================================
Func ArrayAdd($avArray, $avValues)
	If IsArray($avArray) Then
		ReDim $avArray[UBound($avArray) + 1][5]
;~ 		$avArray[UBound($avArray) - 1] = $sValue
		For $i = 0 To UBound($avValues) - 1 Step 1
			$avArray[UBound($avArray) - 1][$i] = $avValues[$i]
		Next
	EndIf
EndFunc   ;==>ArrayAdd

Func _FileSearch($s_Mask = '', $i_Recurse = 1)
	Local $s_Command = ' /c dir /B /A:-D "'
	If $i_Recurse = 1 Then $s_Command = ' /c dir /B /A:-D /S "'
	Local $s_Buf = '', $i_Pid = Run(@ComSpec & $s_Command & $s_Mask & '"', @WorkingDir, @SW_HIDE, 2 + 4)
	While Not @error
		$s_Buf &= StdoutRead($i_Pid)
	WEnd
	$s_Buf = StringSplit(StringTrimRight($s_Buf, 2), @CRLF, 1)
	ProcessClose($i_Pid)
	If UBound($s_Buf) = 2 And $s_Buf[1] = '' Then SetError(1)
	Return $s_Buf
EndFunc   ;==>_FileSearch

Func LVColumnWidth()
	_GUICtrlListViewSetColumnWidth($listview, 1, $LVSCW_AUTOSIZE)
	_GUICtrlListViewSetColumnWidth($listview, 2, $LVSCW_AUTOSIZE)
	_GUICtrlListViewJustifyColumn($listview, 1, 1)
	_GUICtrlListViewSetColumnWidth($listview, 0, 491 - (_GUICtrlListViewGetColumnWidth($listview, 1) + _GUICtrlListViewGetColumnWidth($listview, 2)) - 4)
EndFunc   ;==>LVColumnWidth


Func WM_Notify_Events($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID, $wParam
	Local $event, $__FileFullSizeDesignation, $TipString
	Local $aSizeCalculations[5][3] = _
			[[0,  						 "B", "Byte"], _
			[ 1024, 					"KB", "KiloByte"], _
			[ 1048576, 					"MB", "MegaByte"], _
			[ 1073741824, 				"GB", "GigaByte"], _
			[ 1099511627776, 			"TB", "TeraByte"]]
	$NMLVGETINFOTIP = "int[3];int;ptr;int;int;int;int"
	$data = DllStructCreate($NMLVGETINFOTIP, $lParam)
	Local $__FileId = DllStructGetData($data, 5)
	$event = DllStructGetData($data, 1, 3)
	Select
		Case $wParam = $listview
			Select
				Case $event = $LVN_GETINFOTIPW ;Unicode notification
					If (UBound($aFileList) - 1) > 0 Then
						For $i = 0 To 3 Step 1
							If $aFileList[$__FileId][4] == $aSizeCalculations[$i][1] Then
								If $aFileList[$__FileId][3] > 1.00 Then
									$__FileFullSizeDesignation = $aSizeCalculations[$i][2] & "s" ;Pluralize as needed
								Else
									$__FileFullSizeDesignation = $aSizeCalculations[$i][2]
								EndIf
								$TipString = String($aFileList[$__FileId][1] & $aFileList[$__FileId][2] & @CRLF & _
										StringFormat($StrFmt, $aFileList[$__FileId][3]) & " " & $__FileFullSizeDesignation)
								ExitLoop
							EndIf
						Next
;~ 						ConsoleWrite("TipString: " & $TipString & @LF)
						SetToolTip($TipString, DllStructGetData($data, 3))
					EndIf
			EndSelect
	EndSelect
	$stString = 0
	$data = 0
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_Notify_Events

Func SetToolTip($sTipText, $ptrBuffer)
	; Convert and store the filename as a wide char string
	Local $nBuffersize = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "int", 0, "int", 0x00000001, "str", $sTipText, "int", -1, "ptr", 0, "int", 0)
	Local $stString = DllStructCreate("byte[" & (2 * $nBuffersize[0]) & "]", $ptrBuffer)
	DllCall("kernel32.dll", "int", "MultiByteToWideChar", "int", 0, "int", 0x00000001, "str", $sTipText, "int", -1, "ptr", DllStructGetPtr($stString), "int", $nBuffersize[0])
EndFunc   ;==>SetToolTip
;===============================================================================
;
; Description:      Returns the file size in human readable format
; Syntax:           _FileSize( $sFilePath )
; Parameter(s):     $sFilePath 	- Path and filename of the file to be read
; Requirement(s):   None
; Return Value(s):  Array:	[0] = Filesize
;							[1] = 2 char abbreviated designation
;							[2] = full designation
;===============================================================================
Func _FileSize($sFilePath = "")
	If $sFilePath = "" Then
		;Set $sFilePath to @AutoItExe if empty
		$sFilePath = @AutoItExe
	EndIf
	Local $iFileSize = FileGetSize($sFilePath)
	ConsoleWrite($iFileSize & @LF)
	Local $aSizeCalculations[4][3] = _
			[[1024, 					"KB", "KiloByte"], _
			[ 1048576, 					"MB", "MegaByte"], _
			[ 1073741824, 				"GB", "GigaByte"], _
			[ 1099511627776, 			"TB", "TeraByte"]]
	
	For $i = (UBound($aSizeCalculations) - 1) To 0 Step - 1
		If $iFileSize >= $aSizeCalculations[$i][0] Then
			Local $aReturn[3] = [$iFileSize / $aSizeCalculations[$i][0], String($aSizeCalculations[$i][1]), String($aSizeCalculations[$i][2]) ]
			If $aReturn[0] > 1 Then $aReturn[2] &= "s" ;Pluralize as needed
			Return $aReturn
		ElseIf $iFileSize < 1024 Then
			Local $aReturn[3] = [$iFileSize, "B", "Byte"]
			If $aReturn[0] > 1 Then $aReturn[2] &= "s" ;Pluralize as needed
			Return $aReturn
		EndIf
	Next
EndFunc   ;==>_FileSize

