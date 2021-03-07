; Function: UnHide_Drive v0.1b
; Released: August 23, 2012 by ripdad
; Example: Yes

#include 'array.au3'
#RequireAdmin
;
Local $sTitle = 'UnHide_Drive v0.1b'
;
Local $msg = '- IMPORTANT -' & @CRLF & @CRLF & 'This should only be done when a virus has hidden your files.' & @TAB & @CRLF & @CRLF & 'Use At Your Own Risk!' & @CRLF & @CRLF & 'Continue?'
If MsgBox(8228, $sTitle, $msg) <> 6 Then Exit
;
Local $IsReal = 1; YES
$msg = 'Yes = Do It' & @TAB & @TAB & @TAB & @CRLF & @CRLF & 'No = Just Scan'
If MsgBox(8228, $sTitle, $msg) <> 6 Then $IsReal = 0; NO
;
Local $hSearch, $nRounds = 0, $Vista_7 = 0
If @OSBuild >= 6000 Then $Vista_7 = 1
;
Opt('GUIOnEventMode', 1)
;
Local $gui = GUICreate($sTitle & '  -  ' & @UserName & '/' & @OSVersion & '/' & @OSArch, 600, 106, 0, 0)
GUISetFont(8.5, Default, Default, 'arial')
Local $lb1 = GUICtrlCreateLabel('Enumerating Folders...', 5, 2, 117, 18, BitOR(0x1000, 0x01));$SS_SUNKEN,$SS_CENTER
Local $lb2 = GUICtrlCreateLabel('Running Minutes: 0', 124, 2, 117, 18, BitOR(0x1000, 0x01))
Local $lb3 = GUICtrlCreateLabel('Session Errors: 0', 243, 2, 117, 18, BitOR(0x1000, 0x01))
Local $lb4 = GUICtrlCreateLabel('Hidden Items: 0', 362, 2, 117, 18, BitOR(0x1000, 0x01))
Local $lb5 = GUICtrlCreateLabel('Junctions: 0', 481, 2, 114, 18, BitOR(0x1000, 0x01))
Local $lb6 = GUICtrlCreateLabel('', 5, 28, 590, 18)
Local $lb7 = GUICtrlCreateLabel('', 5, 50, 590, 18)
Local $pbr = GUICtrlCreateProgress(5, 75, 500, 18, 0x01);$PBS_SMOOTH
Local $pse = GUICtrlCreateButton('Pause', 514, 74, 80, 22, 0x1002, 0x00020000)
GUICtrlSetBkColor($lb1, 0xFFFFFF);White
GUICtrlSetBkColor($lb2, 0xFFFFFF)
GUICtrlSetBkColor($lb3, 0xFFFFFF)
GUICtrlSetBkColor($lb4, 0xFFFFFF)
GUICtrlSetBkColor($lb5, 0xFFFFFF)
GUICtrlSetBkColor($pbr, 0xFFFFFF)
GUISetState(@SW_SHOW, $gui)
;
GUISetOnEvent(-3, '_Exit')
GUICtrlSetOnEvent($pse, '_Pause')
;
_UnHide_Drive(@HomeDrive)
;
Opt('GUIOnEventMode', 0)
GUICtrlSetData($lb1, 'Task Completed')
GUICtrlSetData($pse, 'Exit')
GUICtrlSetData($lb6, '')
GUICtrlSetData($lb7, 'Finished!')
;
While 1
    Switch GUIGetMsg()
        Case -3, $pse
            ExitLoop
    EndSwitch
WEnd
GUIDelete($gui)
Exit
;
Func _FileSetAttrib($path, $attribute)
    If $IsReal Then
        If FileSetAttrib($path, '-RASHNOT') Then
            If FileSetAttrib($path, $attribute) Then Return
        EndIf
        Return SetError(-1)
    EndIf
EndFunc
;
Func _UnHide_Drive($sPath)
    If Not FileExists($sPath) Then Return SetError(-1, 0, -1)

    Local $sConfigDir = @WindowsDir & '\System32\Config'
    Local $nExtended, $sFolder, $sItem, $nTime, $str = $sPath
    Local $nHidden = 0, $nJunctions = 0, $nLastCount = 0, $nMinutes = 0
    Local $nErrors = 0, $nTimer = TimerInit()

    _EnumFolders($str, $sPath)
    Local $aFolders = StringSplit($str, '|')
    _ArraySort($aFolders, 0, 1)
    Local $n = $aFolders[0]
    $str = ''

    Local $sMode
    If $IsReal Then
        $sMode = 'Applying Attributes'
    Else
        $sMode = 'Scan Only Mode'
    EndIf
    GUICtrlSetData($lb1, $sMode)

    For $i = 1 To $n
        $sFolder = $aFolders[$i]
        GUICtrlSetData($lb6, StringLeft($sFolder, 95))

        $nTime = Round((TimerDiff($nTimer) / 1000) / 60)
        If ($nTime <> $nMinutes) Then
            GUICtrlSetData($lb2, 'Running Minutes: ' & $nMinutes)
            $nMinutes = $nTime
        EndIf
        GUICtrlSetData($pbr, Round(($i / $n) * 98))

        If StringInStr($sFolder, $sConfigDir) Then
            ContinueLoop
        ElseIf $Vista_7 And _IsJunction($sFolder) Then
            _FileSetAttrib($sFolder, '+SH')
            If @error Then $nErrors += 1
            $nJunctions += 1
            GUICtrlSetData($lb5, 'Junctions: ' & $nJunctions)
            ContinueLoop
        ElseIf StringInStr(FileGetAttrib($sFolder), 'H') Then
            Switch StringRegExpReplace($sFolder, '.*\\', '')
                Case 'Templates', 'Cookies', 'Local Settings', 'Start Menu', 'Temporary Internet Files', 'ProgramData'
                    _FileSetAttrib($sFolder, '+ASH')
                    If @error Then $nErrors += 1
                Case '$Recycle.Bin', 'Recycler', 'System Volume Information', 'LocalService', 'NetworkService', 'SendTo'
                    _FileSetAttrib($sFolder, '+ASH')
                    If @error Then $nErrors += 1
                Case 'AppData', 'Application Data', 'Favorites', 'History', 'NetHood', 'PrintHood', 'Recent'
                    _FileSetAttrib($sFolder, '+ASH')
                    If @error Then $nErrors += 1
                Case Else
                    _FileSetAttrib($sFolder, '+A')
                    If @error Then $nErrors += 1
            EndSwitch
            $nHidden += 1
            GUICtrlSetData($lb4, 'Hidden Items: ' & $nHidden)
        EndIf

        $hSearch = FileFindFirstFile($sFolder & '\*')
        If $hSearch = -1 Then ContinueLoop

        While 1
            $sItem = FileFindNextFile($hSearch)
            If @error Then ExitLoop
            If @extended Then ContinueLoop

            GUICtrlSetData($lb7, StringLeft($sItem, 95))
            $sPath = $sFolder & '\' & $sItem

            If StringInStr(FileGetAttrib($sPath), 'H') Then
                Switch $sItem
                    Case 'boot.ini', 'hiberfil.sys', 'pagefile.sys', 'ntdetect.com', 'ntldr'
                        _FileSetAttrib($sPath, '+ASH')
                        If @error Then $nErrors += 1
                    Case 'desktop.ini', 'index.dat', 'ntuser.ini', 'ntuser.pol', 'thumbs.db'
                        _FileSetAttrib($sPath, '+ASH')
                        If @error Then $nErrors += 1
                    Case 'ntuser.dat', 'ntuser.dat.log', 'ntuser.dat.log1', 'ntuser.dat.log2'
                        _FileSetAttrib($sPath, '+AH')
                        If @error Then $nErrors += 1
                    Case 'UsrClass.dat', 'UsrClass.dat.log', 'UsrClass.dat.log1', 'UsrClass.dat.log2'
                        _FileSetAttrib($sPath, '+AH')
                        If @error Then $nErrors += 1
                    Case Else
                        _FileSetAttrib($sPath, '+A')
                        If @error Then $nErrors += 1
                EndSwitch
                $nHidden += 1
                GUICtrlSetData($lb4, 'Hidden Items: ' & $nHidden)
            EndIf

            If ($nErrors <> $nLastCount) Then
                GUICtrlSetData($lb3, 'Session Errors: ' & $nErrors)
                $nLastCount = $nErrors
            EndIf

            $nRounds += 1
            If ($nRounds > 20) Then; throttle
                Sleep(10)
                $nRounds = 0
            EndIf
        WEnd
        FileClose($hSearch)
    Next
    GUICtrlSetData($pbr, 100)
    $aFolders = ''
EndFunc
;
Func _EnumFolders(ByRef $str, $sPath);<-- Recursive Function
    Local $sItem, $hPath = FileFindFirstFile($sPath & '\*')
    If $hPath = -1 Then Return

    While 1
        $sItem = FileFindNextFile($hPath)
        If @error Then ExitLoop

        If @extended Then
            $str &= '|' & $sPath & '\' & $sItem
            GUICtrlSetData($lb6, StringLeft($sPath & '\' & $sItem, 95))
            _EnumFolders($str, $sPath & '\' & $sItem)
        EndIf

        $nRounds += 1
        If ($nRounds > 100) Then; throttle
            Sleep(10)
            $nRounds = 0
        EndIf
    WEnd
    FileClose($hPath)
EndFunc
;
Func _Pause()
    Opt('GUIOnEventMode', 0)
    GUICtrlSetData($pse, 'Continue')
    GUICtrlSetState($lb1, 256);focus
    While 1; pause in loop
        Switch GUIGetMsg()
            Case -3
                _Exit()
            Case $pse
                GUICtrlSetData($pse, 'Pause')
                GUICtrlSetState($lb1, 256);focus
                ExitLoop
        EndSwitch
    WEnd
    Opt('GUIOnEventMode', 1)
EndFunc
;
Func _Exit()
    If MsgBox(8228, $sTitle, 'Session has not completed - Really Exit?' & @TAB) <> 6 Then
        Return
    EndIf
    FileClose($hSearch)
    GUIDelete($gui)
    Exit
EndFunc
;
;=========================================
; #Function: _IsJunction()
; Author: wraithdu
;-----------------------------------------
; Junctions have these attributes:
; FILE_ATTRIBUTE_HIDDEN = 0x2
; FILE_ATTRIBUTE_SYSTEM = 0x4
; FILE_ATTRIBUTE_REPARSE_POINT = 0x400
;=========================================
Func _IsJunction($sDirectory)
    Local Const $INVALID_FILE_ATTRIBUTES = -1
    Local Const $FILE_ATTRIBUTE_JUNCTION = 0x406
    Local $attrib = DllCall('kernel32.dll', 'dword', 'GetFileAttributesW', 'wstr', $sDirectory)
    If @error Or $attrib[0] = $INVALID_FILE_ATTRIBUTES Then Return SetError(1, 0, -1)
    Return (BitAND($attrib[0], $FILE_ATTRIBUTE_JUNCTION) = $FILE_ATTRIBUTE_JUNCTION)
EndFunc
;
;


