; From xenobiologist - I think
; 11/13/09 or so.

#include<Array.au3>
#include<GuiListView.au3>

; Global Variables
Global $adUseServer = 2
Global $adUseClient = 3

; Initialize COM error handler
Global $oMyError = ObjEvent('AutoIt.Error', 'MyErrFunc')

;Global $provider = 'IBMDADB2'
;Global $provider='vfpoledb.1;Data Source=C:\CBJTMP\Tmp\EPSS\Copy_To_CPSW\;Collating Sequence=general'
Global $provider='vfpoledb.1;Data Source=C:\CBJTMP\Tmp\EPSS\bol\'
Global $IP = ''
Global $port = ''
Global $DSN = ''
Global $userID = ''
Global $password = ''
Global $fileName = 'ltl_rates' ; .dbf added to file name automatically ??
Global $connection_Obj = _connectDB($provider, $IP, $port, $DSN, $userID, $password)

;_getColumns($connection_Obj, 'SELECT * FROM "bol_uom.DBF"')
;_displayTable($connection_Obj, 'SELECT * FROM "BOL_UOM.DBF" WHERE ABBR = "BG"')

;_getColumns($connection_Obj, 'SELECT * FROM $fileName ') ; "ltl_rates.DBF"')
;_displayTable($connection_Obj, 'SELECT * FROM $fileName WHERE RATECODE = "RDWY"') ; "ltl_rates.DBF"')

_getColumns($connection_Obj, 'SELECT * FROM "ltl_rates.DBF"')
_displayTable($connection_Obj, 'SELECT * FROM "ltl_rates.dbf" WHERE RATECODE = "RDWY"')

Func _connectDB($provider, $IP, $port, $DSN, $userID, $password)
    Local $sqlCon = ObjCreate('ADODB.Connection')
    $sqlCon.Mode = 16 ; Erlaubt im MultiUser-Bereich das öffnen anderer Verbindungen ohne Beschränkungen [Lesen/Schreiben/Beides]
    $sqlCon.CursorLocation = $adUseClient ; client side cursor Schreiben beim Clienten

    $sqlCon.Open('Provider=' & $provider & ';IP=' & $IP & ';Port=' & $port & ';DSN=' & $DSN & ';User ID=' & $userID & ';Password=' & $password)
    If @error Then Return -1
    Return $sqlCon
EndFunc   ;==>_connectDB

Func _getColumns($sqlCon, $SQL)
    Local $sqlRs = ObjCreate('ADODB.Recordset')
    If Not @error Then
        $sqlRs.open($SQL, $sqlCon)
        If Not @error Then
            For $i = 0 To $sqlRs.Fields.Count - 1
                ConsoleWrite($sqlRs.Fields($i).Name & @CRLF)
            Next
            $sqlRs.close
        EndIf
    EndIf
EndFunc   ;==>_getColumns

Func _displayTable($sqlCon, $SQL)
;	MsgBox(0,"_displayTable","What's happening")
    Local $sqlRs = ObjCreate('ADODB.Recordset')
;    MsgBox(0,"xxxx",@error)
	If Not @error Then
        $sqlRs.open($SQL, $sqlCon)
        If Not @error Then
;		MsgBox(0,"_displayTable1",@error)
            Local $header[$sqlRs.Fields.Count], $rows
;		MsgBox(0,"_displayTable2",$sqlRs.Fields.Count)
			For $i = 0 To $sqlRs.Fields.Count - 1
                $header[$i] = $sqlRs.Fields($i).Name
            Next
            $rows = $sqlRs.GetRows()
			$sqlRs.close
        EndIf
	EndIf
	_ArrayDisplay_WithHeader($rows, $header)
EndFunc   ;==>_displayTable

Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    MsgBox(0, 'MyErrFunc', 'We intercepted a COM Error !' & @CRLF & @CRLF & _
            'err.description is: ' & @TAB & $oMyError.description & @CRLF & _
            'err.windescription:' & @TAB & $oMyError.windescription & @CRLF & _
            'err.number is: ' & @TAB & $HexNumber & @CRLF & _
            'err.lastdllerror is: ' & @TAB & $oMyError.lastdllerror & @CRLF & _
            'err.scriptline is: ' & @TAB & $oMyError.scriptline & @CRLF & _
            'err.source is: ' & @TAB & $oMyError.source & @CRLF & _
            'err.helpfile is: ' & @TAB & $oMyError.helpfile & @CRLF & _
            'err.helpcontext is: ' & @TAB & $oMyError.helpcontext _
            )
    SetError(1) ; to check for after this function returns
EndFunc   ;==>MyErrFunc

Func _ArrayDisplay_WithHeader(Const ByRef $avArray, $header, $sTitle = "Array: ListView Display", $iItemLimit = -1, $iTranspose = 0, $sSeparator = "", $sReplace = "|")
    If Not IsArray($avArray) Then Return SetError(1, 0, 0)

    ; Dimension checking
    Local $iDimension = UBound($avArray, 0), $iUBound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
    If $iDimension > 2 Then Return SetError(2, 0, 0)

    ; Separator handling
;~     If $sSeparator = "" Then $sSeparator = Chr(1)
    If $sSeparator = "" Then $sSeparator = Chr(124)

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
    For $i = 0 To UBound($header) - 1
        $sHeader &= $sSeparator & $header[$i]
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
            $vTmp = StringReplace($vTmp, $sSeparator, $sReplace, 0, 1)
            $avArrayText[$i] &= $sSeparator & $vTmp

            ; Set max buffer size
            $vTmp = StringLen($vTmp)
            If $vTmp > $iBuffer Then $iBuffer = $vTmp
        Next
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
    Local Const $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH = (0x1000 + 29)
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
            DllStructSetData($tItem, "SubItem", $j - 1)
            GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETITEMA, 0, $pItem)
        Next
    Next

    ; ajust window width
    $iWidth = 0
    For $i = 0 To $iSubMax + 1
        $iWidth += GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH, $i, 0)
    Next
    If $iWidth < 250 Then $iWidth = 230
    WinMove($hGUI, "", Default, Default, $iWidth + 20)

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
EndFunc   ;==>_ArrayDisplay_WithHeader
