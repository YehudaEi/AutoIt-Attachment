#include <String.au3>
#include <Misc.au3>
#include <array.au3>
Global $strFiles = '', $strSize = 0, $anzgesamt = 0, $anz = 0

Func _MultiFileCopy($aSource, $sDestPath = '', $bOverWrite = True, $sPreFix = '!Copy')
    
    Local $ret, $sShowSource, $sShowDest, $sSourcePath = '', $sNewFolder = '', $k
    Local $aMFC[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, False, DllOpen('user32.dll')]
    If IsArray($aSource) Then
        If Not IsNumber($aSource[0]) Then Return SetError(1, 0, 0)
        For $i = 1 To $aSource[0]
            $aMFC[7] += FileGetSize($aSource[$i])
        Next
    Else
        $sSourcePath = $aSource
        If StringRight($sSourcePath, 1) <> '\' Then $sSourcePath &= '\'
        $strSize = 0
        ToolTip('Please wait! Loading!', @DesktopWidth / 2 - 100, 10)
        If FileExists($sSourcePath & '!copydata.mfc') And $sDestPath <> '' Then
            Local $sFile = StringTrimRight(FileRead($sSourcePath & '!copydata.mfc'), 2)
            $strSize = DirGetSize($aSource)
            ;$strSize = StringLeft($sFile, StringInStr($sFile, @CRLF) - 1)
            $aSource = StringSplit(StringTrimLeft($sFile, StringInStr($sFile, @CRLF) + 1), @CRLF, 1)
        Else
            If FileExists($sSourcePath & '!copydata.mfc') Then FileDelete($sSourcePath & '!copydata.mfc')
            $strSize = DirGetSize($aSource)
            $aSource = _RecursiveFileListToArray($sSourcePath, '', 1)
                    Local $hFile = FileOpen($sSourcePath & '!copydata.mfc', 2)
            If $hFile <> -1 Then
                FileWriteLine($hFile, $strSize)
                For $i = 1 To $aSource[0]
                    FileWriteLine($hFile, $aSource[$i])
                Next
                FileClose($hFile)
            EndIf
        EndIf
        $aMFC[7] = $strSize
        ToolTip('')
        If $sDestPath = '' Then Return SetError(0, 0, 1)
    EndIf
    ;MsgBox(0,"",$aSource[0])
    $anzgesamt = $aSource[0]
    If StringRight($sDestPath, 1) <> '\' Then $sDestPath &= '\'
    If Not FileExists($sDestPath) Then
        If Not DirCreate($sDestPath) Then Return SetError(2, 0, 0)
    EndIf
    $sShowDest = StringRegExpReplace($sDestPath, '(.{3})(.*)(.{50})', '$1' & '[...]' & '$3')
    Local $aReturn = $aSource
    Local $callback = DllCallbackRegister('__Progress', 'int', 'uint64;uint64;uint64;uint64;dword;dword;ptr;ptr;str')
    Local $ptr = DllCallbackGetPtr($callback)
    Local $DllKernel32 = DllOpen('kernel32.dll')
    __ProgressCreate($aMFC)
    $aMFC[9] = TimerInit()
    For $i = 1 To $aSource[0]
        $anz = $anz +1
        $sArray = ''
        For $j = 0 To 11
            $sArray &= $aMFC[$j] & ';'
        Next
        $sFile = StringMid($aSource[$i], StringInStr($aSource[$i], '\', 0, -1) + 1)
        If $sSourcePath <> '' Then
            $sNewFolder = StringTrimLeft(StringLeft($aSource[$i], StringInStr($aSource[$i], '\', 0, -1)), StringLen($sSourcePath))
            If Not FileExists($sDestPath & $sNewFolder) Then 
                If Not DirCreate($sDestPath & $sNewFolder) Then Return SetError(3, 0, 0)
            EndIf
        EndIf
        If $sFile = '' Then ContinueLoop
        $k = 0
        While $bOverWrite = False And FileExists($sDestPath & $sNewFolder & $sFile)
            $k += 1
            $sFile = $sPreFix & $k & "_" & StringMid($aSource[$i], StringInStr($aSource[$i], '\', 0, -1) + 1)
        WEnd
        $aReturn[$i] = $sDestPath & $sNewFolder & $sFile
        ;$sShowSource = StringRegExpReplace($aSource[$i], '(.{3})(.*)(.{50})', '$1' & '[...]' & '$3')
		$sShowSource = $aSource[$i]
        GUICtrlSetData($aMFC[1], 'Copying Files: ' & @CRLF & '"' & $sShowSource & '"' & @CRLF & 'Destination: ' & @CRLF & '"' & $sShowDest & '"')
        $ret = DllCall($DllKernel32, 'int', 'CopyFileExA', 'str', $aSource[$i], 'str', $aReturn[$i], 'ptr', $ptr, 'str', $sArray, 'int', 0, 'int', 0)
;~         ConsoleWrite('Return: ' & $ret[0] & @LF)
        If $ret[0] = 0 Then $aMFC[10] = True
        $aMFC[8] += FileGetSize($aSource[$i])
    Next
    DllClose($DllKernel32)
    DllCallbackFree($callback)
    GUIDelete($aMFC[0])
    DllClose($aMFC[11])
    
    FileDelete($sSourcePath & '!copydata.mfc')

    Return $aReturn
EndFunc   ;==>_MultiFileCopy

Func __Progress($FileSize, $BytesTransferred, $StreamSize, $StreamBytesTransferred, $dwStreamNumber, $dwCallbackReason, $hSourceFile, $hDestinationFile, $lpData)
    Local $aSplit = StringSplit(StringTrimRight($lpData, 1), ";")
    If $aSplit[11] = 'True' Then Return 1
    Local $pos = GUIGetCursorInfo($aSplit[1])
    Local $sPercent = Round($BytesTransferred / $FileSize * 100, 0), $iTime, $iTotalTime, $iTransferRate
    Local $sPercentAll = Round(($aSplit[9] + $BytesTransferred) / $aSplit[8] * 100, 0)
    $iTime = TimerDiff($aSplit[10])
    $iTotalTime = Ceiling($iTime / 1000 / ($sPercentAll + 0.1) * 100)
    $iTransferRate = _StringAddThousandsSep(Int($aSplit[8] / $iTotalTime / 1000), '.', ',')
    GUICtrlSetData($aSplit[3], $sPercent & ' %')
    GUICtrlSetData($aSplit[5], $sPercent)
    GUICtrlSetData($aSplit[4], $sPercentAll & ' %  Time: ' & Int($iTime / 1000) & '/' & $iTotalTime & ' s   ' & $anz & '/' & $anzgesamt & '   (' & $iTransferRate & ' MB/s)')
    GUICtrlSetData($aSplit[6], $sPercentAll)
    ;$anz = $anz + 1
EndFunc   ;==>__Progress

Func __ProgressCreate(ByRef $aMFC)
    If Not IsDeclared('WS_POPUPWINDOW') Then Local Const $WS_POPUPWINDOW = 0x80880000
    If Not IsDeclared('WS_EX_TOPMOST') Then Local Const $WS_EX_TOPMOST = 0x00000008
    If Not IsDeclared('WS_EX_TOOLWINDOW') Then Local Const $WS_EX_TOOLWINDOW = 0x00000080
    If Not IsDeclared('WS_EX_COMPOSITED') Then Local Const $WS_EX_COMPOSITED = 0x02000000
    ;$aMFC[0] = GUICreate('MultiFileCopy', 520, 220, @DesktopWidth - 520, 20, $WS_POPUPWINDOW, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW, $WS_EX_COMPOSITED))
    $aMFC[0] = GUICreate('MultiFileCopy', @DesktopWidth - 40, 220, 20, 20, $WS_POPUPWINDOW, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW, $WS_EX_COMPOSITED))
	;$aMFC[1] = GUICtrlCreateLabel('', 10, 10, 500, 65)
	$aMFC[1] = GUICtrlCreateLabel('', 10, 10, @DesktopWidth - 60, 65)
    ;GUICtrlSetFont(-1, 10, 400, 0, 'Courier New')
    GUICtrlCreateLabel('Current File:', 10, 83, 60, 16)
    ;GUICtrlSetFont(-1, 11, 600, 0, 'Courier New')
    $aMFC[2] = GUICtrlCreateLabel('0 %', 80, 83, 500, 16)
    ;GUICtrlSetFont(-1, 11, 600, 0, 'Courier New')
    ;$aMFC[4] = GUICtrlCreateProgress(10, 100,500, 20)
	$aMFC[4] = GUICtrlCreateProgress(10, 100,@DesktopWidth - 60, 20)
    GUICtrlCreateLabel('Total:', 10, 133, 60, 16)
    ;GUICtrlSetFont(-1, 11, 600, 0, 'Courier New')
    $aMFC[3] = GUICtrlCreateLabel('0 %', 80, 133, 440, 16)
    ;GUICtrlSetFont(-1, 11, 600, 0, 'Courier New')
    ;$aMFC[5] = GUICtrlCreateProgress(10, 150, 500, 20)
	$aMFC[5] = GUICtrlCreateProgress(10, 150, @DesktopWidth - 60, 20)
    ;$aMFC[6] = GUICtrlCreateLabel('nathan@smartcom.co.nz', 10, 10, 30, 10)
    ;GUICtrlSetFont(-1, 9, 400, 0, 'Arial')
    GUISetState()
EndFunc   ;==>__ProgressCreate

Func _GetFilesFolder_Rekursiv($sPath, $sExt='*', $iDir=-1, $iRetType=0, $sDelim='0')
    Global $oFSO = ObjCreate('Scripting.FileSystemObject')
    Global $strFiles = ''
    Switch $sDelim
        Case '1'
            $sDelim = @CR
        Case '2'
            $sDelim = @LF
        Case '3'
            $sDelim = ';'
        Case '4'
            $sDelim = '|'
        Case Else
            $sDelim = @CRLF
    EndSwitch
    If ($iRetType < 0) Or ($iRetType > 1) Then $iRetType = 0
    If $sExt = -1 Then $sExt = '*'
    If ($iDir < -1) Or ($iDir > 1) Then $iDir = -1
    _ShowSubFolders($oFSO.GetFolder($sPath),$sExt,$iDir,$sDelim)
    If $iRetType = 0 Then
        Local $aOut
        $aOut = StringSplit(StringTrimRight($strFiles, StringLen($sDelim)), $sDelim, 1)
        If $aOut[1] = '' Then 
            ReDim $aOut[1]
            $aOut[0] = 0
        EndIf
        Return $aOut
    Else
        Return StringTrimRight($strFiles, StringLen($sDelim))
    EndIf
EndFunc

Func _ShowSubFolders($Folder, $Ext='*', $Dir=-1, $Delim=@CRLF)
    If Not IsDeclared("strFiles") Then Global $strFiles = ''
    If ($Dir = -1) Or ($Dir = 0) Then 
        For $file In $Folder.Files
            If $Ext <> '*' Then
                If StringRight($file.Name, StringLen($Ext)) = $Ext Then
                    $strSize += $file.size
                    $strFiles &= $file.Path & $Delim
                EndIf
            Else
                $strSize += $file.size
                $strFiles &= $file.Path & $Delim
            EndIf
        Next
    EndIf
    For $Subfolder In $Folder.SubFolders
        If ($Dir = -1) Or ($Dir = 1) Then $strFiles &= $Subfolder.Path & '\' & $Delim
        _ShowSubFolders($Subfolder, $Ext, $Dir, $Delim)
    Next
EndFunc

Func _RecursiveFileListToArray($sPath, $sPattern = '', $iFlag = 0, $iFormat = 1, $iRecursion = 1, $sDelim = @CRLF)
    Local $hSearch, $sFile, $sReturn = ''
    If StringRight($sPath, 1) <> '\' Then $sPath &= '\'
    $hSearch = FileFindFirstFile($sPath & '*.*')
    If @error Or $hSearch = -1 Then Return SetError(1, 0, $sReturn)
    While True
        $sFile = FileFindNextFile($hSearch)
        If @error Then ExitLoop
        If StringInStr(FileGetAttrib($sPath & $sFile), 'D') Then
            If StringRegExp($sPath & $sFile, $sPattern) And ($iFlag = 0 Or $iFlag = 2) Then $sReturn &= $sPath & $sFile & '\' & $sDelim
            If $iRecursion Then $sReturn &= _RecursiveFileListToArray($sPath & $sFile & '\', $sPattern, $iFlag, 0)
            ContinueLoop
        EndIf
        If StringRegExp($sFile, $sPattern) And ($iFlag = 0 Or $iFlag = 1) Then $sReturn &= $sPath & $sFile & $sDelim
    WEnd
    FileClose($hSearch)
    If $iFormat And $sReturn = '' Then Return StringSplit($sReturn, '', $iFormat)
    If $iFormat Then Return StringSplit(StringTrimRight($sReturn, StringLen($sDelim)), $sDelim, $iFormat)
    Return $sReturn
EndFunc

Func _StringAddThousandsSep($sString, $sThousands = ",", $sDecimal = ".")
    Local $aNumber, $sLeft, $sResult = "", $iNegSign = "", $DolSgn = ""
    If Number(StringRegExpReplace($sString, "[^0-9\-.+]", "\1")) < 0 Then $iNegSign = "-" ; Allows for a negative value
    If StringRegExp($sString, "\$") And StringRegExpReplace($sString, "[^0-9]", "\1") <> "" Then $DolSgn = "$" ; Allow for Dollar sign
    $aNumber = StringRegExp($sString, "(\d+)\D?(\d*)", 1)
    If UBound($aNumber) = 2 Then
        $sLeft = $aNumber[0]
        While StringLen($sLeft)
            $sResult = $sThousands & StringRight($sLeft, 3) & $sResult
            $sLeft = StringTrimRight($sLeft, 3)
        WEnd
        $sResult = StringTrimLeft($sResult, 1); Strip leading thousands separator
        If $aNumber[1] <> "" Then $sResult &= $sDecimal & $aNumber[1] ; Add decimal
    EndIf
    Return $iNegSign & $DolSgn & $sResult ; Adds minus or "" (nothing)and Adds $ or ""
EndFunc ;==>_StringAddThousandsSep