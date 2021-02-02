#CS 
LFQ  in ini-file that is been created by this script is "Last Folders Quantity"
    for 2-nd, 3-d launching the script and calculating progressbar
#CE

#Region includes and vars
#include <FTPEx.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
AutoItSetOption ("TrayIconDebug", 1)
local $sServer = '172.17.0.7', $sUserName = 'anonymous', $sPass = '', $s_root = '/upload/'
local $s_ini = @ScriptDir & "\FTP_checker.ini", $s_dktH
local $sStartTime = _NowCalc(), $nData, $nDataTmp
Global $nTag = 0, $n_LFQ = 0, $s_progress = 0
#EndRegion vars

#Region progressbar
; progressbar:
    local $a_Servers = IniReadSectionNames($s_ini)
    if not @error then
        for $a = 1 to $a_Servers[0]
            if $a_Servers[$a] == $sServer then $nTag = 1
        Next
        if $nTag == 1 then $n_LFQ = iniRead($s_ini, $sServer, "LFQ", 100)
    Endif
  ; Progress GUI:
    $Form1 = GUICreate("FTP checker", 320, 19,   20, 22, BitOR($WS_DLGFRAME,$WS_POPUP, _ ; $WS_POPUP Ц без title
                        $WS_CLIPSIBLINGS), $WS_EX_TOPMOST)
    Global $Progress1 = GUICtrlCreateProgress(-1, -1, 200, 20, $PBS_SMOOTH)
    Global $label = GUICtrlCreateLabel("Processing folders...", 210, 4)
    GUISetBkColor(0x272936)
    GUICtrlSetFont(-1, 14, 800, 0, "MS Serif")
    ; to color text:
        DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($label), "wstr", "", "wstr", "")
        GUICtrlSetColor($label, 0xE0E0E0)
    
    GUISetState()
#EndRegion progressbar

$hOpen =    _FTP_Open('MyFTP Control')
$Ftp_Conn = _FTP_Connect($hOpen, $sServer, $sUserName, $sPass, 1) ; in passive mode

$a_Dirs = _FTP_DirsListToArray($Ftp_Conn, $s_root) ;!!!
IniWrite($s_ini, $sServer, "LFQ", $a_Dirs[0])  ; writing into ini for future reqests
$DiffTime = _DateDiff ('s', $sStartTime, _NowCalc()) ; how many seconds it took?
; MsgBox(0, "", $DiffTime & " sec." & " (" & round ($DiffTime/60, 1) & " min.)")
; _ArrayDisplay($a_Dirs)

; creating dkt-file:
$nDateTime = _NowCalc()
$nDateTime = StringReplace ($nDateTime, "/", "-")
$nDateTime = StringReplace ($nDateTime, ":", "-")
$nDateTime = StringReplace ($nDateTime, " ", "_")
$s_dktH = FileOpen (@ScriptDir & "\" & $sServer & "_" & $nDateTime & ".dkt", 2)
FileWriteLine ($s_dktH, $sServer)
GUICtrlSetData($Progress1, 0) 
GUICtrlSetData($label, "Processing files...")
$s_progress = 0
; folders shouldn't have / in their names, but \ only
; folders names shouldn't start with \, but should end with \
; date should be separated from time stamp
for $b = 1 to $a_Dirs[0]    ; every folder we've got
    
    ; writing folder:
    $s_DirTmp = StringReplace ($a_Dirs[$b], "/", "\")  ; from Linux 2 windows
    $s_Dir = StringregExpReplace ($s_DirTmp, "\\(.*)","\1\\")
    FileWriteLine ($s_dktH, $s_Dir)
    ; every file in the folder:
    _FTP_DirSetCurrent($Ftp_Conn, "/" & $a_Dirs[$b] & "/")
;     MsgBox(1, "AutoIt", _FTP_DirGetCurrent($Ftp_Conn))
    $aFiles = _FTP_ListToArrayEx($Ftp_Conn, 2)
    if IsArray($aFiles) then
        ;     _ArrayDisplay($aFiles)
        for $c = 1 to $aFiles[0][0]
            ; date showing as tc 19.11.09 06:44 writes as 2009\19\11 06:44:00
                ; but should be: 2009.11.19	06:44.00
                $nDataTmp = StringRegExp($aFiles[$c][3], "\d+", 3)
                $nData = $nDataTmp[0] & "." & $nDataTmp[2] & "." & $nDataTmp[1] & @tab & $nDataTmp[3] & ":" & _
                         $nDataTmp[4] & "." & $nDataTmp[5]
            ; name  size  date:
            FileWriteLine ($s_dktH, $aFiles[$c][0] & @TAB & $aFiles[$c][1] & @TAB & $nData)
        Next
    Endif
    ;     _ArrayDisplay($aFile)
    GUICtrlSetData($Progress1, 100/$n_LFQ*$s_progress)
    $s_progress +=1
Next
_FTP_Close($hOpen)


 

#Region funcs
; recursive function (borns itself)
Func _FTP_DirsListToArray($Ftp_Conn, $sDirName)
    Local $aSubDirsArr, $aRetArray[1] 
 
    _FTP_DirSetCurrent($Ftp_Conn, "/" & $sDirName & "/")
 
    Local $aRet = _FTP_ListToArray($Ftp_Conn, 1)
    If Not IsArray($aRet) Or $aRet[0] = 0 Or ($aRet[0] = 2 And $aRet[1] = "." And $aRet[2] = "..") _
        Then Return SetError(1, 0, 0)
 
    For $i = 1 To $aRet[0]
        If $aRet[$i] = "." Or $aRet[$i] = ".." Then ContinueLoop 
        $aRetArray[0] += 1 
        ReDim $aRetArray[$aRetArray[0]+1] 
        $aRetArray[$aRetArray[0]] = $sDirName & "/" & $aRet[$i] 

        $aSubDirsArr = _FTP_DirsListToArray($Ftp_Conn, $sDirName & "/" & $aRet[$i])     ; recursion
        If @error Then ContinueLoop 
        if $aRetArray[0] > $s_progress then $s_progress += $aRetArray[0]    ; accumulating

        ; progressbar:
        if $n_LFQ > 0 then  ; if we have in ini
            ;             ProgressSet(100/$n_LFQ*$s_progress)
            GUICtrlSetData($Progress1, 100/$n_LFQ*$s_progress) 
        else
            ;             ProgressSet($s_progress + Int(100/$s_progress))
;             GUICtrlSetData(-1, $s_progress + Int(100/$s_progress)) 
            GUICtrlSetData($Progress1, Int(100 * ($i / $aRet[0])))
        Endif
        
        For $j = 1 To $aSubDirsArr[0] 
            $aRetArray[0] += 1
            ReDim $aRetArray[$aRetArray[0]+1] 
            $aRetArray[$aRetArray[0]] = $aSubDirsArr[$j] 
        Next 
    Next 
    Return $aRetArray 
EndFunc

#EndRegion funcs