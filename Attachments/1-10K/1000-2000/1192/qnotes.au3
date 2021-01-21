#cs ===============================================================================

   Quick Notepad v0.5 - 12.02.2005
   Autor: Lazycat

   Features:

       - unlimited pages
       - adding/renaming/deleting pages
       - save cursor position for every page
       - autosave feature
       - autohide feature
       - transparency (Win2k/XP)
       - smooth fade in/out (Win2k/XP)
       - setting hotkey from GUI (default - Scroll Lock)
       - ...

   Requirements:
       
       Autoit 3.1+

   Where Autoit limits are?..

#ce ===============================================================================

#include <GUIConstants.au3>
#include <Gui_Message.au3>

Opt ("GUIResizeMode", 2+32+4+64)

Global $sIniName   = @ScriptDir & "\qnotes.ini"
Global $nActiveTab = IniRead($sIniName, "Main", "ActiveTab", 0) 

Global $nMaxTrans  = Number(IniRead($sIniName, "Main", "MaxTrans", 255))
Global $nFadeSpeed = Number(IniRead($sIniName, "Main", "FadeSpeed", 5)) 
Global $nHideWin   = Number(IniRead($sIniName, "Main", "HideWindow", 1)) ; Hide when Focus lose
Global $nStartMin  = Number(IniRead($sIniName, "Main", "StartMinimized", 4)) ; Starts minimized
Global $nOnTop     = Number(IniRead($sIniName, "Main", "AlwaysOnTop", 1)) ; Window always on top
Global $sHotKey    = IniRead($sIniName, "Main", "HotKey", "{SCROLLLOCK}")
Global $sTempHK    = $sHotKey   ; Temporary hotkey for options
Global $nWinState  = @SW_SHOW   ; Main GUI visibility state
Global $anRect[4]
Global $avTab[1][5]

$anRect[0] = IniRead($sIniName, "Main", "Left", @DesktopWidth/2-251)
$anRect[1] = IniRead($sIniName, "Main", "Top", @DesktopHeight/2-201)
$anRect[2] = IniRead($sIniName, "Main", "Width", 506)
$anRect[3] = IniRead($sIniName, "Main", "Height", 416)

;;;;;;;;;;;; Loading pages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$asIniTab = IniReadSection ($sIniName, "Tabs")
If @error Then 
    IniWrite($sIniName, "Tabs", "Default", 0)
    $avTab[0][0] = "Default"
    $avTab[0][1] = 0 ; Cursor position
Else
    ReDim $avTab[ $asIniTab[0][0] ][5]
    For $iCnt = 0 to $asIniTab[0][0]-1
        $avTab[$iCnt][0] = $asIniTab[$iCnt+1][0]
        $avTab[$iCnt][1] = $asIniTab[$iCnt+1][1]
    Next
Endif

If $nActiveTab > UBound($avTab) - 1 Then $nActiveTab = 0 ; Get rid of possible error
If $nStartMin = 1 Then $nWinState = @SW_HIDE             ; Set default state if start minimized

;;;;;;;;;;;; Main GUI create ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$hGUI = GUICreate("Quick Notepad", 508, 422, -1, -1, $WS_SIZEBOX, $WS_EX_TOPMOST)
GUISetFont (9, 400, -1, "MS Sans Serif")

$hMenuFile = GUICtrlCreateMenu ("File")
    $hExit = GUICtrlCreateMenuitem ("Exit", $hMenuFile)
$hMenuPage = GUICtrlCreateMenu ("Page")
     $hAdd = GUICtrlCreateMenuitem ("Add", $hMenuPage)
     $hRen = GUICtrlCreateMenuitem ("Rename", $hMenuPage)
     $hDel = GUICtrlCreateMenuitem ("Delete", $hMenuPage)
$hMenuTool = GUICtrlCreateMenu ("Tools")
     $hOpt = GUICtrlCreateMenuitem ("Options", $hMenuTool)
$hMenuHelp = GUICtrlCreateMenu ("Help")
   $hAbout = GUICtrlCreateMenuitem ("About", $hMenuHelp)

Global $hTab=GUICtrlCreateTab(4,0,500,380)
For $i = 0 to UBound($avTab)-1
   $avTab[$i][2] = GUICtrlCreateTabItem($avTab[$i][0])
   $avTab[$i][3] = GUICtrlCreateEdit(FileRead($avTab[$i][0] & ".txt", FileGetSize($avTab[$i][0] & ".txt")), 10, 27, 487, 348, BitOr($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL) )
   $avTab[$i][4] = $avTab[$i][1]
Next
GUICtrlCreateTabItem("")

$hContMenu = GUICtrlCreateContextMenu ($hTab)
   $hCMAdd = GUICtrlCreateMenuitem ("Add", $hContMenu)
   $hCMRen = GUICtrlCreateMenuitem ("Rename", $hContMenu)
   $hCMDel = GUICtrlCreateMenuitem ("Delete", $hContMenu)

;;;;;;;;;;;; Options GUI create ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$hOptGUI = GUICreate("Options", 330, 280, -1, -1, $WS_POPUP+$WS_CAPTION, -1, $hGUI)

GUICtrlCreateGroup("Interface", 5, 0, 320, 140)
GUICtrlCreateLabel("Transparency (2k/XP)", 15, 20, 140, 16)
GUICtrlCreateLabel("Fade speed (0 - no fade)", 15, 50, 140, 16)
GUICtrlCreateGroup("Hot Key", 5, 145, 320, 90)
GUICtrlCreateLabel('While holding hotkey you want to set, click "Capture" button.', 15, 170, 300, 16)

$hOptTrans  = GUICtrlCreateSlider(150, 15 , 170 , 20)
GUICtrlSetLimit(-1, 255, 50)

$hOptFEdit  = GUICtrlCreateInput($nFadeSpeed, 160, 48, 50, 20)
GUICtrlCreateUpdown($hOptFEdit)
GUICtrlSetLimit(-1, 15, 0)

$hOptStart  = GUICtrlCreateCheckbox("Start minimized", 15, 75)
$hOptFocus  = GUICtrlCreateCheckbox("Hide when loose focus", 15, 95)
$hOptOntop  = GUICtrlCreateCheckbox("Always on top", 15, 115)

$hOptHKEdit = GUICtrlCreateInput(_HotKeyName($sHotKey), 15, 195, 150, 20, $ES_READONLY)
$hOptCaptHK = GUICtrlCreateButton("Capture", 170, 195, 60, 20)

$hOptOk     = GUICtrlCreateButton("OK", 150, 245, 80, 24)
$hOptCancel = GUICtrlCreateButton("Cancel", 240, 245, 80, 24)

;;;;;;;;;;;; Intializtions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WinSetTrans($hGUI, "", 0) ; Reduce flickering
GUISetState(@SW_SHOW, $hGUI)
GUICtrlSendMsg($hTab,  0x1330, Number($nActiveTab), 0)
GUICtrlSetState($avTab[$nActiveTab][3], $GUI_FOCUS)
GUICtrlSendMsg($avTab[$nActiveTab][3], $EM_SETSEL, Number($avTab[$nActiveTab][1]), Number($avTab[$nActiveTab][1]))
WinMove($hGUI, "", $anRect[0], $anRect[1], $anRect[2], $anRect[3])
GUISetState($nWinState, $hGUI)
WinSetOnTop($hGUI, "", BitAND($nOnTop, 1))
HotKeySet($sHotKey, "_WinSwitch")
_SetOptDefaults()

While 1
	$nMsg=GUIGetMsg()
    If ($nHideWin = 1) and ($nWinState = @SW_SHOW) Then
        If not BitAnd(WinGetState($hGUI), 8) and _
           not BitAnd(WinGetState($hOptGUI), 2) and _
           not BitAnd(WinGetState($hOptGUI), 2) Then 
           Fade($hGUI, $nMaxTrans, 0, $nFadeSpeed)
           GUISetState(@SW_HIDE, $hGUI)
           $nWinState = @SW_HIDE
           _SaveData()
        Endif
    Endif
    Select
        Case $nMsg = $hOptCaptHK
            $sTempHK = _CaptureHotKey()
            If $sTempHK == "" Then $sTempHK = $sHotKey
            GUICtrlSetData($hOptHKEdit, _HotKeyName($sTempHK))
        Case $nMsg = $hOptFocus
            GUICtrlSetState($hOptOntop, (BitAnd(GUICtrlRead($hOptFocus), 1)+1)*64)
        Case $nMsg = $hOptTrans
            WinSetTrans ($hGUI, "", GUICtrlRead($hOptTrans))
        Case $nMsg = $hOptOk
            $nMaxTrans  = GUICtrlRead($hOptTrans)
            $nFadeSpeed = GUICtrlRead($hOptFEdit)
            $nHideWin   = GUICtrlRead($hOptFocus)
            $nStartMin  = GUICtrlRead($hOptStart)
            $nOnTop     = GUICtrlRead($hOptOntop)
            $sHotKey    = $sTempHK
            HotKeySet($sHotKey, "_WinSwitch") ; Set new hotkey
            WinSetOnTop($hGUI, "", BitAND($nOnTop, 1)) ; Set ontop flag
            GUISetState(@SW_HIDE, $hOptGUI)
            _SaveData()
        Case $nMsg = $hOptCancel
            _SetOptDefaults()
            GUISetState(@SW_HIDE, $hOptGUI)
            $sTemphK = $sHotKey
            HotKeySet($sHotKey, "_WinSwitch") ; Return hotkey

        Case $nMsg = $hOpt
            GUISetState(@SW_SHOW, $hOptGUI)
            HotKeySet($sHotKey) ; Release hotkey
        Case $nMsg = $hAbout
            MsgBox (270400, "About", "Quick Notepad, version 0.5" & @CR & @CR & "Lazycat, 2005")
        Case $nMsg = $hExit
            _SaveData()
            _WinSwitch()
            Exit
        Case $nMsg = $GUI_EVENT_CLOSE
            _SaveData()
            _WinSwitch()
;            Exit
        Case ($nMsg = $hCMAdd) or ($nMsg = $hAdd)
            _PageAdd()
        Case ($nMsg = $hCMRen) or ($nMsg = $hRen) 
            _PageRename()
        Case ($nMsg = $hCMDel) or ($nMsg = $hDel)
            _PageDelete()
        Case $nMsg = $hTab
            _SaveData()
            $nActiveTab = GUICtrlRead($hTab); 
            GUICtrlSetState($avTab[$nActiveTab][3], $GUI_FOCUS)
            GUICtrlSendMsg($avTab[$nActiveTab][3], $EM_SETSEL, Number($avTab[$nActiveTab][1]),_
                                                               Number($avTab[$nActiveTab][4]))
            GUICtrlSendMsg($avTab[$nActiveTab][3], $EM_SCROLLCARET, 0, 0)
    EndSelect
WEnd

;;;;;;;;;;;; One time functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func _SetOptDefaults()
    WinSetTrans ($hGUI, "", $nMaxTrans)
    GUICtrlSetData($hOptTrans, $nMaxTrans)
    GUICtrlSetState($hOptStart, $nStartMin)
    GUICtrlSetState($hOptFocus, $nHideWin)
    GUICtrlSetState($hOptOntop, $nOnTop + (BitAnd($nHideWin, 1)+1)*64)
    GUICtrlSetData($hOptFEdit, $nFadeSpeed)
EndFunc

Func SaveCursorPos()
    $editpos = GUICtrlRecvMsg($avTab[$nActiveTab][3], $EM_GETSEL)
    If UBound($editpos) > 0 Then
        $avTab[$nActiveTab][1] = $editpos[0]
        $avTab[$nActiveTab][4] = $editpos[1]
    Else
        $avTab[$nActiveTab][1] = 0
        $avTab[$nActiveTab][4] = 0
    Endif
EndFunc

Func _PageAdd()
    Local $sRet = _MyInput("", $hGUI)
    If $sRet == "" Then Return
    If StringIsAlNum($sRet) Then 
        ReDim $avTab[UBound($avTab)+1][5]
        $nActiveTab = UBound($avTab)-1
        GUISwitch($hGUI) ; Create tab in main GUI...
        $avTab[$nActiveTab][0] = $sRet
        $avTab[$nActiveTab][2] = GUICtrlCreateTabItem($avTab[$nActiveTab][0])
        $avTab[$nActiveTab][3] = GUICtrlCreateEdit("", 10, 27, 487, 348, BitOr($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
        IniWrite($sIniName, "Tabs", $sRet, "")
    Endif
    GUICtrlSendMsg($hTab,  0x1330, Number($nActiveTab), 0)
    ; How to get rid those ugly code?..
    $anRect = WinGetPos($hGUI)
    WinMove($hGUI, "", $anRect[0], $anRect[1], $anRect[2]+8, $anRect[3])
    WinMove($hGUI, "", $anRect[0], $anRect[1], $anRect[2]-8, $anRect[3])
EndFunc

Func _PageRename()
    Local $sRet = _MyInput($avTab[$nActiveTab][0], $hGUI)
    If ($sRet == "") or ($sRet == $avTab[$nActiveTab][0]) Then Return
    $nActiveTab = GUICtrlRead($hTab)
    If StringIsAlNum($sRet) Then 
        FileMove($avTab[$i][0] & ".txt", $sRet & ".txt")
        $avTab[$nActiveTab][0] = $sRet
        IniDelete($sIniName, "Tabs")
        For $i = 0 to UBound($avTab)-1
            IniWrite($sIniName, "Tabs", $avTab[$i][0], $avTab[$i][1])
        Next
        GUICtrlSetData($avTab[$nActiveTab][2], $sRet)
        GUISetState(@SW_HIDE, $hGUI)
        GUISetState(@SW_SHOW, $hGUI)
    Endif    
EndFunc

Func _PageDelete()
    If UBound($avTab) = 1 Then
        MsgBox (48+262144+8192, "Error", "You can not delete last page.")
        Return
    Endif
    If not (MsgBox (270388, "Confirm", "Do you want to delete this page?") = 6) Then Return
    $nActiveTab = GUICtrlRead($hTab)
    IniDelete($sIniName, "Tabs", $avTab[$nActiveTab][0])
    GUICtrlDelete($avTab[$nActiveTab][3])
    GUICtrlDelete($avTab[$nActiveTab][2])
    For $i = $nActiveTab To UBound($avTab)-2
        For $j = 0 to 4
            $avTab[$i][$j] = $avTab[$i+1][$j]
        Next
    Next
    ReDim $avTab[UBound($avTab)-1][5]
    $nActiveTab = $nActiveTab - 1
    If $nActiveTab < 0 Then $nActiveTab = 0
    GUICtrlSendMsg($hTab,  0x1330, Number($nActiveTab), 0)
EndFunc

Func _SaveData()
    SaveCursorPos()
    For $i = 0 to UBound($avTab)-1
        $hFile = FileOpen($avTab[$i][0] & ".txt", 2)
        IniWrite($sIniName, "Tabs", $avTab[$i][0], $avTab[$i][1])
        FileWrite($hFile, GUICtrlRead($avTab[$i][3]))
        FileClose($hFile)
    Next
    $anRect = WinGetPos($hGUI)
    IniWrite($sIniName, "Main", "Left",   $anRect[0])
    IniWrite($sIniName, "Main", "Top",    $anRect[1])
    IniWrite($sIniName, "Main", "Width",  $anRect[2])
    IniWrite($sIniName, "Main", "Height", $anRect[3])
    IniWrite($sIniName, "Main", "ActiveTab", $nActiveTab)

    IniWrite($sIniName, "Main", "MaxTrans", $nMaxTrans)
    IniWrite($sIniName, "Main", "FadeSpeed", $nFadeSpeed)
    IniWrite($sIniName, "Main", "HideWindow", $nHideWin)
    IniWrite($sIniName, "Main", "StartMinimized", $nStartMin)
    IniWrite($sIniName, "Main", "AlwaysOnTop", $nOnTop)
    IniWrite($sIniName, "Main", "HotKey", $sHotKey)
EndFunc

Func _WinSwitch()
    If $nWinState = @SW_SHOW Then
        Fade($hGUI, $nMaxTrans, 0, $nFadeSpeed)
        $nWinState = @SW_HIDE
        GUISetState(@SW_HIDE, $hGUI)
    Else
        If $nFadeSpeed Then WinSetTrans ($hGUI, "", 0) ; Workaround: flicker out
        GUISetState(@SW_SHOW, $hGUI)
        $nWinState = @SW_SHOW       
        Fade($hGUI, 0, $nMaxTrans, $nFadeSpeed)
    Endif
EndFunc

;;;;;;;;;;;; Reusable functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func Fade($hWnd, $nStart, $nEnd, $nStep)
    If not $nStep Then Return
    For $t = $nStart to $nEnd step $nStep * ($nEnd - $nStart)/Abs($nEnd - $nStart)
        WinSetTrans ($hWnd, "", $t)
    Next
EndFunc

Func _MyInput($sDefStr, $hParent)
    Local $hInpGUI = GUICreate("Input name", 210, 75, -1, -1, $WS_POPUP+$WS_CAPTION, -1, $hParent)
    Local $hInpEdit = GUICtrlCreateInput("", 10, 10, 190, 20)
    Local $hInpOk = GUICtrlCreateButton("OK", 10, 40, 80, 24)
    Local $hInpCancel = GUICtrlCreateButton("Cancel", 120, 40, 80, 24)
    Local $sRetStr = "", $nMsg
    GUISetState(@SW_SHOW, $hInpGUI)
    GUICtrlSetData($hInpEdit, $sDefStr)
    While 1
    	$nMsg=GUIGetMsg()
        Select
            Case $nMsg = $hInpOk 
                $sRetStr = GUICtrlRead($hInpEdit)
                Exitloop                
            Case $nMsg = $hInpCancel
                Exitloop
        EndSelect
    Wend
    GUISetState(@SW_HIDE, $hInpGUI)
    GUIDelete($hInpGUI)
    Return($sRetStr)
EndFunc

Func _HotKeyName($sAHotKey)
    Local $asKey  = StringSplit("+|^|!|#|{NUMLOCK}|{SCROLLLOCK}|{TAB}|{ESC}|{PRINTSCREEN}", "|") ; "+" should be first!
    Local $asFKey = StringSplit("Shift + |Ctrl + |Alt + |Win + |Num Lock|Scroll Lock|Tab|Esc|Print Screen", "|")
    For $iCnt = 1 To $asKey[0]
        $sAHotKey = StringReplace($sAHotKey, $asKey[$iCnt], $asFKey[$iCnt])
    Next
    $sAHotKey = StringReplace($sAHotKey, "{", "")
    $sAHotKey = StringReplace($sAHotKey, "}", "")
    Return $sAHotKey
EndFunc

Func _CaptureHotKey()
    Local $aRes, $sRet = ""
    For $iAsc = 0 to 255
    $aRes = DllCall("user32.dll", "int", "GetAsyncKeyState", "int", $iAsc)
    If Abs($aRes[0]) > 1 Then
        Select
            Case $iAsc = 0x12 ; Alt
                $sRet = "!" & $sRet 
            Case $iAsc = 0x11 ; Ctrl
                $sRet = "^" & $sRet 
            Case $iAsc = 0x10 ; Shift
                $sRet = "+" & $sRet 
            Case $iAsc = 0x5B ; Win
                $sRet = "#" & $sRet 
            Case ($iAsc >= 0x70) and ($iAsc <= 0x7B) ; Functional keys
                $sRet = $sRet & "{F" & $iAsc - 0x6F & "}"
            Case ($iAsc >= 0x70) and ($iAsc <= 0x7B) ; Digits
                $sRet = $sRet & Chr($iAsc)
            Case ($iAsc >= 0x41) and ($iAsc <= 0x5A) ; Letters
                $sRet = $sRet & StringLower(Chr($iAsc))
            Case $iAsc = 0x90
                $sRet = $sRet & "{NUMLOCK}"
            Case $iAsc = 0x91
                $sRet = $sRet & "{SCROLLLOCK}"
            Case $iAsc = 0x09
                $sRet = $sRet & "{TAB}"
            Case $iAsc = 0x1B
                $sRet = $sRet & "{ESC}"
            Case $iAsc = 0x2C
                $sRet = $sRet & "{PRINTSCREEN}"
        EndSelect
     EndIf
    Next
    Return $sRet
EndFunc