$width = 5
$height = 10000
local $a[$height][$width]
for $i = 0 to $height-1
	for $j = 0 to $width-1
		$a[$i][$j] = $i & "|" & $j
	next
next

_arraydisplaybr($a, "", -1, 0, chr(1)) ; only way to make comparison fair -- by making it display text properly
_arraydisplaycurr($a)
_arraydisplaywithexec($a)

; arrayuExec.au3
Func _ArrayDisplayBr(Const ByRef $avArrayF, $sTitle = "Array: ListView Display", $iItemLimit = -1, $iTranspose = 0, $sSeparator = "|", $sReplace = "|")
Local $timer = TimerInit()
	If Not IsArray($avArrayF) Then Return SetError(1, 0, 0)
	Local $iDimension = UBound($avArrayF, 0), $iUBound = UBound($avArrayF, 1) - 1, $iSubMax = UBound($avArrayF, 2) - 1
	If $iDimension > 2 Then Return SetError(2, 0, 0)
	If $sSeparator <> $sReplace Then
		If $iDimension = 2 Then
			Local $avArray[$iUBound + 1][$iSubMax + 1]
			For $i = 0 To $iUBound
				For $j = 0 To $iSubMax
					$avArray[$i][$j] = StringReplace($avArrayF[$i][$j], $sSeparator, $sReplace, 0, 1)
				Next
			Next
		ElseIf $iDimension = 1 Then
			Local $avArray[$iUBound + 1]
			For $i = 0 To $iUBound
				$avArray[$i] = StringReplace($avArrayF[$i], $sSeparator, $sReplace, 0, 1)
			Next
		EndIf
	Else
		$avArray = $avArrayF
;~ 		$avArray[0] = $avArrayF[0]
	EndIf

	; Dimension checking
	Local $iDimension = UBound($avArray, 0), $iUBound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
	If $iDimension > 2 Then Return SetError(2, 0, 0)

	; Separator handling
	If $sSeparator = "" Then $sSeparator = Chr(1)

	; Declare variables
	Local $i, $j, $vTmp, $aItem, $avArrayText, $sHeader = "Row", $iBuffer = 64
	Local $iColLimit = 250, $iLVIAddUDFThreshold = 4000, $iWidth = 640, $iHeight = 480
	Local $iOnEventMode = Opt("GUIOnEventMode", 0), $sDataSeparatorChar = Opt("GUIDataSeparatorChar", $sSeparator)

	; Swap dimensions if transposing
	If $iSubMax < 0 Then $iSubMax = 0
	If $iTranspose Then
		$vTmp = $iUBound
		$iUBound = $iSubMax
		$iSubMax = $vTmp
	EndIf

	; Set limits for dimensions
	If $iSubMax > $iColLimit Then $iSubMax = $iColLimit
	If $iItemLimit = 1 Then $iItemLimit = $iLVIAddUDFThreshold
	If $iItemLimit < 1 Then $iItemLimit = $iUBound
	If $iUBound > $iItemLimit Then $iUBound = $iItemLimit
	If $iLVIAddUDFThreshold > $iUBound Then $iLVIAddUDFThreshold = $iUBound

	; Set header up
	For $i = 0 To $iSubMax
		$sHeader &= $sSeparator & "Col " & $i
	Next

	; Convert array into text for listview
	Local $avArrayText[$iUBound + 1], $iArrayType = $iDimension + 2 * $iTranspose - 1, $sTxt, $sExec1 = '"', $sExec2 = '"' 
	Local $arTmp[4] = ['$avArray[$i]', '$avArray[$i][$j]', '$avArray[$j]', '$avArray[$j][$i]'  ], $sTmp = $arTmp[$iArrayType], $sTmp2

	For $i = 0 To $iLVIAddUDFThreshold;$iUBound
		$avArrayText[$i] = "[" & $i & "]" 
		Switch $iArrayType   ;   $iDimension + 2 * $iTranspose - 1
			Case 0 ;1D
				For $j = 0 To $iSubMax; Add to text array [$iSubMax]
					$avArrayText[$i] &= $sSeparator & $avArray[$i];$sSeparator &
				Next
			Case 1 ;2D
				For $j = 0 To $iSubMax; Add to text array
					$avArrayText[$i] &= $sSeparator & $avArray[$i][$j];$sSeparator &
				Next
			Case 2 ;1DT
				For $j = 0 To $iSubMax; Add to text array
					$avArrayText[$i] &= $sSeparator & $avArray[$j];$sSeparator &
				Next
			Case 3 ;2DT
				For $j = 0 To $iSubMax; Add to text array
					$avArrayText[$i] &= $sSeparator & $avArray[$j][$i];$sSeparator &
				Next
		EndSwitch

		; Set max buffer size
		$vTmp = StringLen($avArrayText[$i])
		If $vTmp > $iBuffer Then $iBuffer = $vTmp
	Next
	$iBuffer += 1
	; GUI Constants
	Local Const $_ARRAYCONSTANT_GUI_DOCKBORDERS = 0x66
	Local Const $_ARRAYCONSTANT_GUI_DOCKBOTTOM = 0x40
	Local Const $_ARRAYCONSTANT_GUI_DOCKHEIGHT = 0x0200
	Local Const $_ARRAYCONSTANT_GUI_DOCKLEFT = 0x2
	Local Const $_ARRAYCONSTANT_GUI_DOCKRIGHT = 0x4
	Local Const $_ARRAYCONSTANT_GUI_EVENT_CLOSE = -3
	Local Const $_ARRAYCONSTANT_LVIF_PARAM = 0x4
	Local Const $_ARRAYCONSTANT_LVIF_TEXT = 0x1
	Local Const $_ARRAYCONSTANT_LVM_GETITEMCOUNT = (0x1000 + 4)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMSTATE = (0x1000 + 44)
	Local Const $_ARRAYCONSTANT_LVM_INSERTITEMA = (0x1000 + 7)
	Local Const $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE = (0x1000 + 54)
	Local Const $_ARRAYCONSTANT_LVM_SETITEMA = (0x1000 + 6)
	Local Const $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT = 0x20
	Local Const $_ARRAYCONSTANT_LVS_EX_GRIDLINES = 0x1
	Local Const $_ARRAYCONSTANT_LVS_SHOWSELALWAYS = 0x8
	Local Const $_ARRAYCONSTANT_WS_EX_CLIENTEDGE = 0x0200
	Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX = 0x00010000
	Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX = 0x00020000
	Local Const $_ARRAYCONSTANT_WS_SIZEBOX = 0x00040000
	Local Const $_ARRAYCONSTANT_tagLVITEM = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns" 

	Local $iAddMask = BitOR($_ARRAYCONSTANT_LVIF_TEXT, $_ARRAYCONSTANT_LVIF_PARAM)
	Local $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]"), $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM), $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "Param", 0)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer)

	; Set interface up
	Local $hGUI = GUICreate($sTitle, $iWidth, $iHeight, Default, Default, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX))
	Local $aiGUISize = WinGetClientSize($hGUI)
	Local $hListView = GUICtrlCreateListView($sHeader, 0, 0, $aiGUISize[0], $aiGUISize[1] - 26, $_ARRAYCONSTANT_LVS_SHOWSELALWAYS)
	Local $hCopy = GUICtrlCreateButton("Copy Selected", 3, $aiGUISize[1] - 23, $aiGUISize[0] - 6, 20)

	GUICtrlSetResizing($hListView, $_ARRAYCONSTANT_GUI_DOCKBORDERS)
	GUICtrlSetResizing($hCopy, $_ARRAYCONSTANT_GUI_DOCKLEFT + $_ARRAYCONSTANT_GUI_DOCKRIGHT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_GRIDLINES, $_ARRAYCONSTANT_LVS_EX_GRIDLINES)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE)

	; Fill listview
	For $i = 0 To $iLVIAddUDFThreshold
		GUICtrlCreateListViewItem($avArrayText[$i], $hListView)
	Next
	If $iDimension = 1 Then $iNumItems = 2
	If $iDimension = 2 Then $iNumItems = UBound($avArray, 2 - $iTranspose) + 1

	For $i = ($iLVIAddUDFThreshold + 1) To $iUBound
		DllStructSetData($tBuffer, "Text", "[" & $i & "]")

		; Add listview item
		DllStructSetData($tItem, "Item", $i)
		DllStructSetData($tItem, "SubItem", 0)
		DllStructSetData($tItem, "Mask", $iAddMask)
		GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_INSERTITEMA, 0, $pItem)

		; Set listview subitem text
		DllStructSetData($tItem, "Mask", $_ARRAYCONSTANT_LVIF_TEXT)
		For $j = 2 - $iDimension To $iNumItems - $iDimension
			Switch $iArrayType   ;   $iDimension + 2 * $iTranspose - 1
				Case 0 ;1D
					$sTxt = $avArray[$i];$sSeparator &
				Case 1 ;2D
					$sTxt = $avArray[$i][$j];$sSeparator &
				Case 2 ;1DT
					$sTxt = $avArray[$j];$sSeparator &
				Case 3 ;2DT
					$sTxt = $avArray[$j][$i];$sSeparator &
			EndSwitch
			If StringLen($sTxt) > $iBuffer Then
				$iBuffer = StringLen($sTxt)
				Local $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]"), $pBuffer = DllStructGetPtr($tBuffer)
				Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM), $pItem = DllStructGetPtr($tItem)
				ConsoleWrite("PROBLEM...........*********************************" & @LF)
			EndIf
			DllStructSetData($tBuffer, "Text", $sTxt)
			DllStructSetData($tItem, "SubItem", $j - 1 + $iDimension)
			GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETITEMA, 0, $pItem)
		Next
	Next

consolewrite(timerdiff($timer)/1000 & @CRLF)

	; Show dialog
	GUISetState(@SW_SHOW, $hGUI)
	While 1
		Switch GUIGetMsg()
			Case $_ARRAYCONSTANT_GUI_EVENT_CLOSE
				ExitLoop

			Case $hCopy
				Local $sClip = ""

				; Get selected indices [ _GUICtrlListView_GetSelectedIndices($hListView, True) ]
				Local $aiCurItems[1] = [0]
				For $i = 0 To GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMCOUNT, 0, 0)
					If GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMSTATE, $i, 0x2) Then
						$aiCurItems[0] += 1
						ReDim $aiCurItems[$aiCurItems[0] + 1]
						$aiCurItems[$aiCurItems[0]] = $i
					EndIf
				Next

				; Generate clipboard text
				If Not $aiCurItems[0] Then
					For $sItem In $avArrayText
						$sClip &= $sItem & @CRLF
					Next
				Else
					For $i = 1 To UBound($aiCurItems) - 1
						$sClip &= $avArrayText[$aiCurItems[$i]] & @CRLF
					Next
				EndIf
				ClipPut($sClip)
		EndSwitch
	WEnd
	GUIDelete($hGUI)
	$avArrayText = ""

	Opt("GUIOnEventMode", $iOnEventMode)
	Opt("GUIDataSeparatorChar", $sDataSeparatorChar)

	Return 1
EndFunc   ;==>_ArrayDisplayBr

Func _ArrayDisplayCurr(Const ByRef $avArray, $sTitle = "Array: ListView Display", $iItemLimit = -1, $iTranspose = 0, $sSeparator = "", $sReplace = "|")
Local $timer = TimerInit()
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	; Dimension checking
	Local $iDimension = UBound($avArray, 0), $iUBound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
	If $iDimension > 2 Then Return SetError(2, 0, 0)

	; Separator handling
	If $sSeparator = "" Then $sSeparator = Chr(1)

	; Declare variables
	Local $i, $j, $vTmp, $aItem, $avArrayText, $sHeader = "Row", $iBuffer = 64
	Local $iColLimit = 200, $iLVIAddUDFThreshold = 4000, $iWidth = 640, $iHeight = 480
	Local $iOnEventMode = Opt("GUIOnEventMode", 0), $sDataSeparatorChar = Opt("GUIDataSeparatorChar", $sSeparator)

	; Swap dimensions if transposing
	If $iSubMax < 0 Then $iSubMax = 0
	If $iTranspose Then
		$vTmp = $iUBound
		$iUBound = $iSubMax
		$iSubMax = $vTmp
	EndIf

	; Set limits for dimensions
	If $iSubMax > $iColLimit Then $iSubMax = $iColLimit
	If $iItemLimit = 1 Then $iItemLimit = $iLVIAddUDFThreshold
	If $iItemLimit < 1 Then $iItemLimit = $iUBound
	If $iUBound > $iItemLimit Then $iUBound = $iItemLimit
	If $iLVIAddUDFThreshold > $iUBound Then $iLVIAddUDFThreshold = $iUBound

	; Set header up
	For $i = 0 To $iSubMax
		$sHeader &= $sSeparator & "[" & $i & "]"
	Next

	; Convert array into text for listview
	Local $avArrayText[$iUBound + 1]
	For $i = 0 To $iUBound
		$avArrayText[$i] = "[" & $i & "]"
		For $j = 0 To $iSubMax
			; Get current item
			If $iDimension = 1 Then
				If $iTranspose Then
					$vTmp = $avArray[$j]
				Else
					$vTmp = $avArray[$i]
				EndIf
			Else
				If $iTranspose Then
					$vTmp = $avArray[$j][$i]
				Else
					$vTmp = $avArray[$i][$j]
				EndIf
			EndIf

			; Add to text array
			$avArrayText[$i] &= $sSeparator & StringReplace($vTmp, $sSeparator, $sReplace, 0, 1)

		Next
			; Set max buffer size
			$vTmp = StringLen($avArrayText[$i])
			If $vTmp > $iBuffer Then $iBuffer = $vTmp
	Next
	$iBuffer += 1

	; GUI Constants
	Local Const $_ARRAYCONSTANT_GUI_DOCKBORDERS = 0x66
	Local Const $_ARRAYCONSTANT_GUI_DOCKBOTTOM = 0x40
	Local Const $_ARRAYCONSTANT_GUI_DOCKHEIGHT = 0x0200
	Local Const $_ARRAYCONSTANT_GUI_DOCKLEFT = 0x2
	Local Const $_ARRAYCONSTANT_GUI_DOCKRIGHT = 0x4
	Local Const $_ARRAYCONSTANT_GUI_EVENT_CLOSE = -3
	Local Const $_ARRAYCONSTANT_LVIF_PARAM = 0x4
	Local Const $_ARRAYCONSTANT_LVIF_TEXT = 0x1
	Local Const $_ARRAYCONSTANT_LVM_GETITEMCOUNT = (0x1000 + 4)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMSTATE = (0x1000 + 44)
	Local Const $_ARRAYCONSTANT_LVM_INSERTITEMA = (0x1000 + 7)
	Local Const $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE = (0x1000 + 54)
	Local Const $_ARRAYCONSTANT_LVM_SETITEMA = (0x1000 + 6)
	Local Const $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT = 0x20
	Local Const $_ARRAYCONSTANT_LVS_EX_GRIDLINES = 0x1
	Local Const $_ARRAYCONSTANT_LVS_SHOWSELALWAYS = 0x8
	Local Const $_ARRAYCONSTANT_WS_EX_CLIENTEDGE = 0x0200
	Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX = 0x00010000
	Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX = 0x00020000
	Local Const $_ARRAYCONSTANT_WS_SIZEBOX = 0x00040000
	Local Const $_ARRAYCONSTANT_tagLVITEM = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns"

	Local $iAddMask = BitOR($_ARRAYCONSTANT_LVIF_TEXT, $_ARRAYCONSTANT_LVIF_PARAM)
	Local $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]"), $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM), $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "Param", 0)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer)

	; Set interface up
	Local $hGUI = GUICreate($sTitle, $iWidth, $iHeight, Default, Default, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX))
	Local $aiGUISize = WinGetClientSize($hGUI)
	Local $hListView = GUICtrlCreateListView($sHeader, 0, 0, $aiGUISize[0], $aiGUISize[1] - 26, $_ARRAYCONSTANT_LVS_SHOWSELALWAYS)
	Local $hCopy = GUICtrlCreateButton("Copy Selected", 3, $aiGUISize[1] - 23, $aiGUISize[0] - 6, 20)

	GUICtrlSetResizing($hListView, $_ARRAYCONSTANT_GUI_DOCKBORDERS)
	GUICtrlSetResizing($hCopy, $_ARRAYCONSTANT_GUI_DOCKLEFT + $_ARRAYCONSTANT_GUI_DOCKRIGHT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_GRIDLINES, $_ARRAYCONSTANT_LVS_EX_GRIDLINES)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE)

	; Fill listview
	For $i = 0 To $iLVIAddUDFThreshold
		GUICtrlCreateListViewItem($avArrayText[$i], $hListView)
	Next
	For $i = ($iLVIAddUDFThreshold + 1) To $iUBound
		$aItem = StringSplit($avArrayText[$i], $sSeparator)
		DllStructSetData($tBuffer, "Text", $aItem[1])

		; Add listview item
		DllStructSetData($tItem, "Item", $i)
		DllStructSetData($tItem, "SubItem", 0)
		DllStructSetData($tItem, "Mask", $iAddMask)
		GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_INSERTITEMA, 0, $pItem)

		; Set listview subitem text
		DllStructSetData($tItem, "Mask", $_ARRAYCONSTANT_LVIF_TEXT)
		For $j = 2 To $aItem[0]
			DllStructSetData($tBuffer, "Text", $aItem[$j])
			DllStructSetData($tItem, "SubItem", $j-1)
			GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETITEMA, 0, $pItem)
		Next
	Next

consolewrite(timerdiff($timer)/1000 & @CRLF)
	; Show dialog
	GUISetState(@SW_SHOW, $hGUI)
	While 1
		Switch GUIGetMsg()
			Case $_ARRAYCONSTANT_GUI_EVENT_CLOSE
				ExitLoop

			Case $hCopy
				Local $sClip = ""

				; Get selected indices [ _GUICtrlListView_GetSelectedIndices($hListView, True) ]
				Local $aiCurItems[1] = [0]
				For $i = 0 To GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMCOUNT, 0, 0)
					If GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMSTATE, $i, 0x2) Then
						$aiCurItems[0] += 1
						ReDim $aiCurItems[$aiCurItems[0] + 1]
						$aiCurItems[$aiCurItems[0]] = $i
					EndIf
				Next

				; Generate clipboard text
				If Not $aiCurItems[0] Then
					For $sItem In $avArrayText
						$sClip &= $sItem & @CRLF
					Next
				Else
					For $i = 1 To UBound($aiCurItems) - 1
						$sClip &= $avArrayText[$aiCurItems[$i]] & @CRLF
					Next
				EndIf
				ClipPut($sClip)
		EndSwitch
	WEnd
	GUIDelete($hGUI)

	Opt("GUIOnEventMode", $iOnEventMode)
	Opt("GUIDataSeparatorChar", $sDataSeparatorChar)

	Return 1
EndFunc   ;==>_ArrayDisplay

Func _ArrayDisplayWithExec(Const ByRef $avArray, $sTitle = "Array: ListView Display", $iItemLimit = -1, $iTranspose = 0, $sSeparator = "", $sReplace = "|")
Local $timer = TimerInit()
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	; Dimension checking
	Local $iDimension = UBound($avArray, 0), $iUBound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
	If $iDimension > 2 Then Return SetError(2, 0, 0)

	; Separator handling
	If $sSeparator = "" Then $sSeparator = Chr(1)

	; Declare variables
	Local $i, $j, $vTmp, $aItem, $avArrayText, $sHeader = "Row", $iBuffer = 64
	Local $iColLimit = 200, $iLVIAddUDFThreshold = 4000, $iWidth = 640, $iHeight = 480
	Local $iOnEventMode = Opt("GUIOnEventMode", 0), $sDataSeparatorChar = Opt("GUIDataSeparatorChar", $sSeparator)

	; Swap dimensions if transposing
	If $iSubMax < 0 Then $iSubMax = 0
	If $iTranspose Then
		$vTmp = $iUBound
		$iUBound = $iSubMax
		$iSubMax = $vTmp
	EndIf

	; Set limits for dimensions
	If $iSubMax > $iColLimit Then $iSubMax = $iColLimit
	If $iItemLimit = 1 Then $iItemLimit = $iLVIAddUDFThreshold
	If $iItemLimit < 1 Then $iItemLimit = $iUBound
	If $iUBound > $iItemLimit Then $iUBound = $iItemLimit
	If $iLVIAddUDFThreshold > $iUBound Then $iLVIAddUDFThreshold = $iUBound

	; Set header up
	For $i = 0 To $iSubMax
		$sHeader &= $sSeparator & "[" & $i & "]"
	Next

    ; Convert array into text for listview
    Local $avArrayText[$iUBound + 1]
    Local $arTmp[4] = ['$avArray[$i]', '$avArray[$i][$j]', '$avArray[$j]', '$avArray[$j][$i]'  ], $sTmp = $arTmp[$iDimension + 2 * $iTranspose - 1], $sTmp2

    For $i = 0 To $iUBound;$iUBound
        $avArrayText[$i] = "[" & $i & "]" 
        If $sSeparator == $sReplace Then
            For $j = 0 To $iSubMax
                ; Add to text array
                $avArrayText[$i] &= $sSeparator & Execute($sTmp);$sSeparator &
            Next
        Else
            For $j = 0 To $iSubMax
                ; Add to text array
                $avArrayText[$i] &= $sSeparator & StringReplace(Execute($sTmp), $sSeparator, $sReplace, 0, 1)
            Next
        EndIf
        
        ; Set max buffer size
        $vTmp = StringLen($avArrayText[$i])
        If $vTmp > $iBuffer Then $iBuffer = $vTmp
	Next

	; GUI Constants
	Local Const $_ARRAYCONSTANT_GUI_DOCKBORDERS = 0x66
	Local Const $_ARRAYCONSTANT_GUI_DOCKBOTTOM = 0x40
	Local Const $_ARRAYCONSTANT_GUI_DOCKHEIGHT = 0x0200
	Local Const $_ARRAYCONSTANT_GUI_DOCKLEFT = 0x2
	Local Const $_ARRAYCONSTANT_GUI_DOCKRIGHT = 0x4
	Local Const $_ARRAYCONSTANT_GUI_EVENT_CLOSE = -3
	Local Const $_ARRAYCONSTANT_LVIF_PARAM = 0x4
	Local Const $_ARRAYCONSTANT_LVIF_TEXT = 0x1
	Local Const $_ARRAYCONSTANT_LVM_GETITEMCOUNT = (0x1000 + 4)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMSTATE = (0x1000 + 44)
	Local Const $_ARRAYCONSTANT_LVM_INSERTITEMA = (0x1000 + 7)
	Local Const $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE = (0x1000 + 54)
	Local Const $_ARRAYCONSTANT_LVM_SETITEMA = (0x1000 + 6)
	Local Const $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT = 0x20
	Local Const $_ARRAYCONSTANT_LVS_EX_GRIDLINES = 0x1
	Local Const $_ARRAYCONSTANT_LVS_SHOWSELALWAYS = 0x8
	Local Const $_ARRAYCONSTANT_WS_EX_CLIENTEDGE = 0x0200
	Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX = 0x00010000
	Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX = 0x00020000
	Local Const $_ARRAYCONSTANT_WS_SIZEBOX = 0x00040000
	Local Const $_ARRAYCONSTANT_tagLVITEM = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns"

	Local $iAddMask = BitOR($_ARRAYCONSTANT_LVIF_TEXT, $_ARRAYCONSTANT_LVIF_PARAM)
	Local $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]"), $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM), $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "Param", 0)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer)

	; Set interface up
	Local $hGUI = GUICreate($sTitle, $iWidth, $iHeight, Default, Default, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX))
	Local $aiGUISize = WinGetClientSize($hGUI)
	Local $hListView = GUICtrlCreateListView($sHeader, 0, 0, $aiGUISize[0], $aiGUISize[1] - 26, $_ARRAYCONSTANT_LVS_SHOWSELALWAYS)
	Local $hCopy = GUICtrlCreateButton("Copy Selected", 3, $aiGUISize[1] - 23, $aiGUISize[0] - 6, 20)

	GUICtrlSetResizing($hListView, $_ARRAYCONSTANT_GUI_DOCKBORDERS)
	GUICtrlSetResizing($hCopy, $_ARRAYCONSTANT_GUI_DOCKLEFT + $_ARRAYCONSTANT_GUI_DOCKRIGHT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_GRIDLINES, $_ARRAYCONSTANT_LVS_EX_GRIDLINES)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE)

	; Fill listview
	For $i = 0 To $iLVIAddUDFThreshold
		GUICtrlCreateListViewItem($avArrayText[$i], $hListView)
	Next
	For $i = ($iLVIAddUDFThreshold + 1) To $iUBound
		$aItem = StringSplit($avArrayText[$i], $sSeparator)
		DllStructSetData($tBuffer, "Text", $aItem[1])

		; Add listview item
		DllStructSetData($tItem, "Item", $i)
		DllStructSetData($tItem, "SubItem", 0)
		DllStructSetData($tItem, "Mask", $iAddMask)
		GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_INSERTITEMA, 0, $pItem)

		; Set listview subitem text
		DllStructSetData($tItem, "Mask", $_ARRAYCONSTANT_LVIF_TEXT)
		For $j = 2 To $aItem[0]
			DllStructSetData($tBuffer, "Text", $aItem[$j])
			DllStructSetData($tItem, "SubItem", $j-1)
			GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETITEMA, 0, $pItem)
		Next
	Next

consolewrite(timerdiff($timer)/1000 & @CRLF)
	; Show dialog
	GUISetState(@SW_SHOW, $hGUI)
	While 1
		Switch GUIGetMsg()
			Case $_ARRAYCONSTANT_GUI_EVENT_CLOSE
				ExitLoop

			Case $hCopy
				Local $sClip = ""

				; Get selected indices [ _GUICtrlListView_GetSelectedIndices($hListView, True) ]
				Local $aiCurItems[1] = [0]
				For $i = 0 To GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMCOUNT, 0, 0)
					If GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMSTATE, $i, 0x2) Then
						$aiCurItems[0] += 1
						ReDim $aiCurItems[$aiCurItems[0] + 1]
						$aiCurItems[$aiCurItems[0]] = $i
					EndIf
				Next

				; Generate clipboard text
				If Not $aiCurItems[0] Then
					For $sItem In $avArrayText
						$sClip &= $sItem & @CRLF
					Next
				Else
					For $i = 1 To UBound($aiCurItems) - 1
						$sClip &= $avArrayText[$aiCurItems[$i]] & @CRLF
					Next
				EndIf
				ClipPut($sClip)
		EndSwitch
	WEnd
	GUIDelete($hGUI)

	Opt("GUIOnEventMode", $iOnEventMode)
	Opt("GUIDataSeparatorChar", $sDataSeparatorChar)

	Return 1
EndFunc   ;==>_ArrayDisplay
