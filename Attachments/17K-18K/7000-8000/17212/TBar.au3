#include <GUIConstants.au3>
;#include <RepairTool.au3>
Global $min, $hour, $Demarrer, $Reduire, $Iconeplus, $Plus, $Agrandir, $IconeMoins, $Next, $Previous, $Bureau, $AutoScript, $gui1, $gui2, $gui3
Global $NTB1 = "(¯`-._ Ni¢k To0lBar _.-´¯)"
Global $NTB2 = "(_.-´¯ N!ck T0olbar ¯`-._)"
Global $NTB3 = "(¯`-._ Mini ToolBar _.-´¯)"
Global $NTB4 = "(¯`-._ Ni¢k To0lBar _.-´¯)"
Global $Bureauz = "1"
Global $Labels[100][25], $ToolBarContext[10], $PlusContext[10], $hm[1], $NTBHandle[1], $ToolTipDisable[1]
; $labels[n][0] Stores the Label Control ID
; $labels[n][1] Stores the Window Handle
; $labels[n][2] Stores the ProcessID the Window comes from
; $labels[n][3] Stores the Icon from the Window ProcessID path.
; $labels[n][4] Stores the Window Title & ProcessID path, this is for a tooltip info.
; $labels[n][5] Stores/creates right click Context Menu ID
; $labels[n][6] Stores/creates right click Context Menu Item ID for Restore on label
; $labels[n][7] Stores/creates right click the Context Menu Item ID for Minimise on label
; $labels[n][8] Stores/creates right click Context Menu Item ID for Maximise on label
; $labels[n][9] Stores/creates right click Context Menu Item ID for Line on label
; $labels[n][10] Stores/creates right click Context Menu Item ID for Close on label
; n = number from 1 to 99

; $hm[0] The number of Windows

; $ToolBarContext[0] Stores/creates right click Context Menu ID on main and complete and mini gui on toolbar.
; $ToolBarContext[1] Stores/creates right click Context Menu Item ID "Restore All Windows" on main and complete and mini gui on toolbar.
; $ToolBarContext[2] Stores/creates right click Context Menu Item ID "Minimize All Windows" on main and complete and mini gui on toolbar.
; $ToolBarContext[3] Stores/creates right click Context Menu Item ID "Maximize All Windows" (Depending on state) on main and complete and mini gui on toolbar.
; $ToolBarContext[4] Stores/creates right click Context Menu Item ID "Line" on main and complete gui and mini on toolbar.
; $ToolBarContext[5] Stores/creates right click Context Menu Item ID "Close All Windows" on main and complete and mini gui on toolbar.
; $ToolBarContext[6] Stores/creates right click Context Menu Item ID "Line" on main and complete and mini gui on toolbar.
; $ToolBarContext[7] Stores/creates right click Context Menu Item ID "Disable/Enable Tooltips" on main and complete gui for toolbar labels.
; $ToolBarContext[8] Stores/creates right click Context Menu Item ID "Line" on main and complete and mini gui on toolbar
; $ToolBarContext[9] Stores/creates right click Context Menu Item ID "Exit Toolbar" on main and complete or mini gui on toolbar.


_Maingui()


While 1
    If GUICtrlRead($min) = @MIN Then
        ;;;
    Else
        GUICtrlSetData($min, @MIN)
    EndIf
    If GUICtrlRead($hour) = @HOUR Then
        ;;;
    Else
        GUICtrlSetData($hour, @HOUR)
    EndIf
    $msg = GuiGetMsg()
    If WinExists($NTB1) Then
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ;Exit
            Case $msg = $Demarrer
                _DemarrerGui()
            Case $msg = $Reduire
                _MiniGui()
                GUIDelete($gui1) ; <-- Delete old gui after the new gui has loaded , makes it flicker a little less
            Case $msg = $Iconeplus
                _Completegui()
                $hm[0] = 0 ; <-- Reset how many windows after starting new gui, listwin() will redraw the labels/icons on new gui.
                GUIDelete($gui1) ; <-- Delete old gui after the new gui has loaded , makes it flicker a little less
            Case $msg = $Plus
                MouseClick("Right")
			Case $msg = $Previous
                MsgBox(0, "", "Previous")
			Case $msg = $Next
                MsgBox(0, "", "Next")
			Case $msg = $Bureau
                If $Bureauz = 1 Then
					WinMinimizeAll()
					$Bureauz = 2
				ElseIf $Bureauz = 2 Then
					WinMinimizeAllUndo()
					$Bureauz = 1
				EndIf
			Case $msg = $AutoScript
				$RD = Random(0, 999, 1)
				$Name = $RD & ".au3"
				If FileExists(@DesktopDir & "\" & $Name) Then
					Do
						$RD = Random(0, 999)
						$Name = $RD & ".au3"
					Until FileExists(@DesktopDir & "\" & $Name) = 0
				EndIf
                IniWrite(@DesktopDir & "\" & $Name, "", "", "")
				$File = FileOpen(@DesktopDir & "\" & $Name, 2)
				FileWrite($File, "")
				FileClose($File)
				ShellExecute($Name, "", @DesktopDir, "open")
        EndSelect
        ToolTipCheck()
    ElseIf WinExists($NTB2) Then
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ;Exit
            Case $msg = $Demarrer
                _DemarrerGui()
            Case $msg = $Reduire
                _MiniGui()
                GUIDelete($gui2) ; <-- Delete old gui after the new gui has loaded , makes it flicker a little less
            Case $msg = $IconeMoins
                _Maingui()
                $hm[0] = 0 ; <-- Reset how many windows after starting new gui, listwin() will redraw the labels/icons on new gui.
                GUIDelete($gui2) ; <-- Delete old gui after the new gui has loaded , makes it flicker a little less
            Case $msg = $Plus
                MouseClick("Right")
			Case $msg = $Previous
                MsgBox(0, "", "Previous")
			Case $msg = $Next
                MsgBox(0, "", "Next")
			Case $msg = $Bureau
				If $Bureauz = 1 Then
					WinMinimizeAll()
					$Bureauz = 2
				ElseIf $Bureauz = 2 Then
					WinMinimizeAllUndo()
					$Bureauz = 1
				EndIf
			Case $msg = $AutoScript
                $RD = Random(0, 999, 1)
				$Name = $RD & ".au3"
				If FileExists(@DesktopDir & "\" & $Name) Then
					Do
						$RD = Random(0, 999)
						$Name = $RD & ".au3"
					Until FileExists(@DesktopDir & "\" & $Name) = 0
				EndIf
                IniWrite(@DesktopDir & "\" & $Name, "", "", "")
				$File = FileOpen(@DesktopDir & "\" & $Name, 2)
				FileWrite($File, "")
				FileClose($File)
				ShellExecute($Name, "", @DesktopDir, "open")
		EndSelect
    ElseIf WinExists($NTB3) Then
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ;Exit
            Case $msg = $Agrandir
                $hm[0] = 0 ; <-- Reset how many windows before starting new gui, listwin() will redraw the buttons
                _Maingui()
                GUIDelete($gui3) ; <-- Delete gui after the new gui has loaded , makes it flicker a little less
            Case $msg = $ToolBarContext[1] ;Toolbar Context Menu Item Control "Restore All Windows"
                For $rs = 1 to $hm[0]
                    WinSetState($Labels[$rs][1], '', @SW_RESTORE)
                Next
            Case $msg = $ToolBarContext[2] ;Toolbar Context Menu Item Control "Minimize All Windows"
                For $mn = 1 to $hm[0]
                    WinSetState($Labels[$mn][1], '', @SW_MINIMIZE)
                Next
            Case $msg = $ToolBarContext[3] ;Toolbar Context Menu Item Control "Maximize All Windows"
                For $mx = 1 to $hm[0]
                    WinSetState($Labels[$mx][1], '', @SW_MAXIMIZE)
                Next
            Case $msg = $ToolBarContext[5]
                    For $cs = 1 to $hm[0]
                        WinClose($Labels[$cs][1])
                    Next
					_Maingui()
					$hm[0] = 0
					GUIDelete($gui2)
            Case $msg = $ToolBarContext[7]
                    If $ToolTipDisable[0] = 0 Then
                        GUICtrlSetData($ToolBarContext[7], 'Enable Tooltips')
                        $ToolTipDisable[0] = 1
                        ToolTipCheck()
                    ElseIf $ToolTipDisable[0] = 1 Then
                        GUICtrlSetData($ToolBarContext[7], 'Disable Tooltips')
                        $ToolTipDisable[0] = 0
                        ToolTipCheck()
                    EndIf
            Case $msg = $ToolBarContext[9] ;<-- Context Menu Item ID "Exit Toolbar"
                Exit
        EndSelect
    EndIf
    If WinExists($NTB1) Or WinExists($NTB2) Then
        For $l = 1 To $hm[0] ; <-- Start: Added this just so we can see the controls do something.
            Select
                Case $msg = $Labels[$l][0] ; Label Control id
                    For $c = 20 To 23
                        GUICtrlSetBkColor($Labels[$l][$c], 0xBADCFF)
                    Next   
                    GUICtrlSetColor($Labels[$l][0], 0xBADCFF)
                    If Not BitAnd(WinGetState($Labels[$l][1]), 8) Then
                        WinActivate($Labels[$l][1])
                        ToolTipCheck()
                    EndIf
                    GUICtrlSetColor($Labels[$l][0], 0xffffff)
                    For $c = 20 To 23
                        GUICtrlSetBkColor($Labels[$l][$c], 0xffffff);$GUI_BKCOLOR_TRANSPARENT
                    Next
                Case $msg = $Labels[$l][3] ; Icon Control id
                    For $c = 20 To 23
                        GUICtrlSetBkColor($Labels[$l][$c], 0xBADCFF)
                    Next   
                    GUICtrlSetColor($Labels[$l][0], 0xBADCFF)
                    If Not BitAnd(WinGetState($Labels[$l][1]), 8) Then
                        WinActivate($Labels[$l][1])
                        ToolTipCheck()
                    EndIf
                    GUICtrlSetColor($Labels[$l][0], 0xffffff)
                    For $c = 20 To 23
                        GUICtrlSetBkColor($Labels[$l][$c], 0xffffff);$GUI_BKCOLOR_TRANSPARENT
                    Next
                Case $msg = $Labels[$l][6] ;Label Context Menu Item Control "Restore Window"
                    WinSetState($Labels[$l][1], '', @SW_RESTORE)
                    WinActivate($Labels[$l][1])
                    ToolTipCheck()
                Case $msg = $Labels[$l][7] ;Label Context Menu Item Control "Minimise Window"
                    WinSetState($Labels[$l][1], '', @SW_MINIMIZE)
                    ToolTipCheck()
                Case $msg = $Labels[$l][8] ;Label Context Menu Item Control "Maximise Window"
                    WinSetState($Labels[$l][1], '', @SW_MAXIMIZE)
                    WinActivate($Labels[$l][1])
                    ToolTipCheck()
                Case $msg = $Labels[$l][10] ;Label Context Menu Item Control "Close Window"
                    WinClose($Labels[$l][1])
            EndSelect
        Next ; <-- End: of controls do something.
        _ListWin()
        Select
            Case $msg = $ToolBarContext[1] ;Toolbar Context Menu Item Control "Restore All Windows"
                For $rs = 1 to $hm[0]
                    WinSetState($Labels[$rs][1], '', @SW_RESTORE)
                Next
            Case $msg = $ToolBarContext[2] ;Toolbar Context Menu Item Control "Minimize All Windows"
                For $mn = 1 to $hm[0]
                    WinSetState($Labels[$mn][1], '', @SW_MINIMIZE)
                Next
            Case $msg = $ToolBarContext[3] ;Toolbar Context Menu Item Control "Maximize All Windows"
                For $mx = 1 to $hm[0]
                    WinSetState($Labels[$mx][1], '', @SW_MAXIMIZE)
                Next
            Case $msg = $ToolBarContext[5]
                    For $cs = 1 to $hm[0]
                        WinClose($Labels[$cs][1])
                    Next
            Case $msg = $ToolBarContext[7]
                    If $ToolTipDisable[0] = 0 Then
                        GUICtrlSetData($ToolBarContext[7], 'Enable Tooltips')
                        $ToolTipDisable[0] = 1
                        ToolTipCheck()
                    ElseIf $ToolTipDisable[0] = 1 Then
                        GUICtrlSetData($ToolBarContext[7], 'Disable Tooltips')
                        $ToolTipDisable[0] = 0
                        ToolTipCheck()
                    EndIf
            Case $msg = $ToolBarContext[9] ;<-- Context Menu Item ID "Exit Toolbar"
                Exit
        EndSelect
    EndIf
WEnd

; === Fonctions utiles ===
Func SetWindowRgn($h_win, $rgn)
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc

Func IsVisible($wdfds)
  If BitAnd(WinGetState($wdfds),2) Then
    Return 1
  Else
    Return 0
  EndIf
EndFunc

Func _ProcessGetLocation($iPID) ; <-- Larry's handy work , I luv the way his functions don't rely on wmi service.. awesome biggrin.gif
    Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
    If $aProc[0] = 0 Then Return SetError(1, 0, '')
    Local $vStruct = DllStructCreate('int[1024]')
    DllCall('psapi.dll', 'int', 'EnumProcessModules', 'hwnd', $aProc[0], 'ptr', DllStructGetPtr($vStruct), 'int', DllStructGetSize($vStruct), 'int_ptr', 0)
    Local $aReturn = DllCall('psapi.dll', 'int', 'GetModuleFileNameEx', 'hwnd', $aProc[0], 'int', DllStructGetData($vStruct, 1), 'str', '', 'int', 2048)
    If StringLen($aReturn[3]) = 0 Then Return SetError(2, 0, '')
    Return $aReturn[3]
EndFunc
; === Fonctions utiles ===

; === GUI ===
Func _Maingui()
    $gui1 = GUICreate($NTB1,1024,60,0,@DesktopHeight-60,$WS_POPUP)
    ;=== Start Toolbar Context Menu ===
    $ToolBarContext[0] = GUICtrlCreateContextMenu()
    $ToolBarContext[1] = GUICtrlCreateMenuitem("Restore All Windows", $ToolBarContext[0])
    $ToolBarContext[2] = GUICtrlCreateMenuitem("Minimize All Windows", $ToolBarContext[0])
    $ToolBarContext[3] = GUICtrlCreateMenuitem("Maximize All Windows", $ToolBarContext[0])
    $ToolBarContext[4] = GUICtrlCreateMenuitem("", $ToolBarContext[0])
    $ToolBarContext[5] = GUICtrlCreateMenuitem('Close All Windows', $ToolBarContext[0])
    $ToolBarContext[6] = GUICtrlCreateMenuitem("", $ToolBarContext[0])
    $ToolBarContext[7] = GUICtrlCreateMenuitem('Disable Tooltips', $ToolBarContext[0])
    $ToolBarContext[8] = GUICtrlCreateMenuitem("", $ToolBarContext[0])
    $ToolBarContext[9] = GUICtrlCreateMenuitem("Exit Toolbar", $ToolBarContext[0])
    ;=== End Toolbar Context Menu ===
    ;=== Cacher ===
    $Demarrer = GUICtrlCreateLabel("", 6, 13, 41, 42)
    GUICtrlSetCursor($Demarrer, 0)
    $Reduire = GUICtrlCreateLabel("", 967, 38, 8, 9)
    GUICtrlSetCursor($Reduire, 0)
    $Iconeplus = GUICtrlCreateLabel("", 1012, 27, 9, 8)
    GUICtrlSetCursor($Iconeplus, 0)
    $Plus = GUICtrlCreateLabel("", 228, 43, 9, 7)
    GUICtrlSetCursor($Plus, 0)
	$Previous = GUICtrlCreateLabel("", 266, 41, 7, 13)
    GUICtrlSetCursor($Previous, 0)
	$Next = GUICtrlCreateLabel("", 950, 41, 7, 13)
    GUICtrlSetCursor($Next, 0)
	$Bureau = GUICtrlCreateLabel("", 70, 36, 15, 17)
    GUICtrlSetCursor($Bureau, 0)
	$AutoScript = GUICtrlCreateLabel("", 86, 36, 15, 17)
    GUICtrlSetCursor($AutoScript, 0)
    ; === Cacher ===
	_PlusCreate()
    ; === À voir ===
    GUICtrlCreatePic(".\larry.bmp",0,0,1024,60)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $a = DLLCall(".\BMP2RGN.dll","int","BMP2RGN", "str", ".\larry.bmp", "int", 0, "int", 0, "int", 0)
    SetWindowRgn($gui1, $a[0])
    $min =  GUICtrlCreateLabel(@MIN, 1008, 40, 12, 17)
    GUICtrlSetBkColor(-1,0x444444)
    GUICtrlSetColor(-1,0xffffff)
    GUICtrlCreateLabel(":", 1004, 39, 3, 17)
    GUICtrlSetBkColor(-1,0x444444)
    GUICtrlSetColor(-1,0xffffff)
    $hour = GUICtrlCreateLabel(@HOUR, 990, 40, 12, 17)
    GUICtrlSetBkColor(-1,0x444444)
    GUICtrlSetColor(-1,0xffffff)
    ; === À Voir ===
    WinSetOnTop($gui1, "", 1)
    GUISetState(@SW_SHOW)
    $NTBHandle[0] = $gui1
EndFunc

Func _Completegui()
    $gui2 = GUICreate($NTB2,1024,180,0,@DesktopHeight-180,$WS_POPUP)
    ;=== Start Toolbar Context Menu ===
    $ToolBarContext[0] = GUICtrlCreateContextMenu()
    $ToolBarContext[1] = GUICtrlCreateMenuitem("Restore All Windows", $ToolBarContext[0])
    $ToolBarContext[2] = GUICtrlCreateMenuitem("Minimize All Windows", $ToolBarContext[0])
    $ToolBarContext[3] = GUICtrlCreateMenuitem("Maximize All Windows", $ToolBarContext[0])
    $ToolBarContext[4] = GUICtrlCreateMenuitem("", $ToolBarContext[0])
    $ToolBarContext[5] = GUICtrlCreateMenuitem('Close All Windows', $ToolBarContext[0])
    $ToolBarContext[6] = GUICtrlCreateMenuitem("", $ToolBarContext[0])
    $ToolBarContext[7] = GUICtrlCreateMenuitem('Disable Tooltips', $ToolBarContext[0])
    $ToolBarContext[8] = GUICtrlCreateMenuitem("", $ToolBarContext[0])
    $ToolBarContext[9] = GUICtrlCreateMenuitem("Exit Toolbar", $ToolBarContext[0])
    ;=== End Toolbar Context Menu ===
    ;=== Cacher ===
    $Demarrer = GUICtrlCreateLabel("", 6, 133, 41, 42)
    GUICtrlSetCursor($Demarrer, 0)
    $Reduire = GUICtrlCreateLabel("", 967, 158, 8, 9)
    GUICtrlSetCursor($Reduire, 0)
    $IconeMoins = GUICtrlCreateLabel("", 1013, 147, 9, 8)
    GUICtrlSetCursor($IconeMoins, 0)
    $Plus = GUICtrlCreateLabel("", 228, 163, 9, 7)
    GUICtrlSetCursor($Plus, 0)
	$Previous = GUICtrlCreateLabel("", 266, 161, 7, 13)
    GUICtrlSetCursor($Previous, 0)
	$Next = GUICtrlCreateLabel("", 950, 161, 7, 13)
    GUICtrlSetCursor($Next, 0)
	$Bureau = GUICtrlCreateLabel("", 70, 156, 15, 17)
    GUICtrlSetCursor($Bureau, 0)
	$AutoScript = GUICtrlCreateLabel("", 86, 156, 15, 17)
    GUICtrlSetCursor($AutoScript, 0)
    ; === Cacher ===
	_PlusCreate()
    ; === À voir ===
    GUICtrlCreatePic(".\icones.bmp",0,0,1024,180)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $a = DLLCall(".\BMP2RGN.dll","int","BMP2RGN", "str", ".\icones.bmp", "int", 0, "int", 0, "int", 0)
    SetWindowRgn($gui2, $a[0])
    $min =  GUICtrlCreateLabel(@MIN, 1008, 160, 12, 17)
    GUICtrlSetBkColor(-1,0x444444)
    GUICtrlSetColor(-1,0xffffff)
    GUICtrlCreateLabel(":", 1004, 159, 3, 17)
    GUICtrlSetBkColor(-1,0x444444)
    GUICtrlSetColor(-1,0xffffff)
    $hour = GUICtrlCreateLabel(@HOUR, 990, 160, 12, 17)
    GUICtrlSetBkColor(-1,0x444444)
    GUICtrlSetColor(-1,0xffffff)
    ; === À Voir ===
    WinSetOnTop($gui2, "", 1)
    GUISetState(@SW_SHOW)
    $NTBHandle[0] = $gui2
EndFunc

Func _MiniGui()
    $gui3 = GUICreate($NTB3,1024,60,@DesktopWidth-80,@DesktopHeight-60,$WS_POPUP)
    ;=== Start Toolbar Context Menu ===
    $ToolBarContext[0] = GUICtrlCreateContextMenu()
    $ToolBarContext[1] = GUICtrlCreateMenuitem("Restore All Windows", $ToolBarContext[0])
    $ToolBarContext[2] = GUICtrlCreateMenuitem("Minimize All Windows", $ToolBarContext[0])
    $ToolBarContext[3] = GUICtrlCreateMenuitem("Maximize All Windows", $ToolBarContext[0])
    $ToolBarContext[4] = GUICtrlCreateMenuitem("", $ToolBarContext[0])
    $ToolBarContext[5] = GUICtrlCreateMenuitem('Close All Windows', $ToolBarContext[0])
    $ToolBarContext[6] = GUICtrlCreateMenuitem("", $ToolBarContext[0])
    $ToolBarContext[7] = GUICtrlCreateMenuitem('Disable Tooltips', $ToolBarContext[0])
    $ToolBarContext[8] = GUICtrlCreateMenuitem("", $ToolBarContext[0])
    $ToolBarContext[9] = GUICtrlCreateMenuitem("Exit Toolbar", $ToolBarContext[0])
    ;=== End Toolbar Context Menu ===
    ;=== Cacher ===
    $Agrandir = GUICtrlCreateLabel("", 23, 38, 8, 9)
    GUICtrlSetCursor($Agrandir, 0)
    ; === Cacher ===
    ; === À voir ===
    GUICtrlCreatePic(".\mini.bmp",0,0,80,60)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $a = DLLCall(".\BMP2RGN.dll","int","BMP2RGN", "str", ".\mini.bmp", "int", 0, "int", 0, "int", 0)
    SetWindowRgn($gui3, $a[0])
    $min =  GUICtrlCreateLabel(@MIN, 64, 40, 12, 17)
    GUICtrlSetBkColor(-1,0x444444)
    GUICtrlSetColor(-1,0xffffff)
    GUICtrlCreateLabel(":", 60, 39, 3, 17)
    GUICtrlSetBkColor(-1,0x444444)
    GUICtrlSetColor(-1,0xffffff)
    $hour = GUICtrlCreateLabel(@HOUR, 46, 40, 12, 17)
    GUICtrlSetBkColor(-1,0x444444)
    GUICtrlSetColor(-1,0xffffff)
    ; === À Voir ===
    WinSetOnTop($gui3, "", 1)
    GUISetState(@SW_SHOW)
    $NTBHandle[0] = $gui3
EndFunc

Func _DemarrerGui()
	$gui4 = GUICreate($NTB4, 260, 700, 0, 65, $WS_POPUP)
	GUICtrlCreatePic(".\demarrer.bmp",0,0,260,700)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $a = DLLCall(".\BMP2RGN.dll","int","BMP2RGN", "str", ".\demarrer.bmp", "int", 0, "int", 0, "int", 0)
    SetWindowRgn($gui4, $a[0])
	WinSetOnTop($gui4, "", 1)
    GUISetState(@SW_SHOW)
EndFunc
; === GUI ===

; === WinList ===
Func _ListWin()
    $hm1 = 0
    If $hm[0] = 0 Then
        SetLabels()
    ElseIf $hm[0] > 0 Then
        $var = WinList()
        For $i = 1 to $var[0][0]
            If $var[$i][0] <> "" AND IsVisible($var[$i][1]) And $var[$i][0] <> 'Program Manager' And $var[$i][0] <> $NTB1 And $var[$i][0] <> $NTB2 Then
                $hm1 = $hm1 + 1
            EndIf
        Next
        For $cPid = 1 To $hm[0] ; <-- Start Child Filter: This is so child/dialog windows of a main window won't show on the toolbar.
            If WinGetProcess($Labels[$hm1][1]) == WinGetProcess($Labels[$cPid][1]) Or WinGetProcess($Labels[$hm1][1]) == WinGetProcess($NTBHandle[0]) Then
                For $m = 1 To $hm[0]
                    If ProcessExists(WinGetProcess($Labels[$m][1])) = 0 Then
                        For $d = 1 To $hm[0]
                            GUICtrlDelete($Labels[$d][0])
                            GUICtrlDelete($Labels[$d][3])
							GUICtrlDelete($Labels[$d][20])
							GUICtrlDelete($Labels[$d][21])
							GUICtrlDelete($Labels[$d][22])
							GUICtrlDelete($Labels[$d][23])
                            $Labels[$d][1] = ''
                            $Labels[$d][2] = ''
                            $Labels[$d][4] = ''
                            $Labels[$d][5] = ''
                            $Labels[$d][6] = ''
                            $Labels[$d][7] = ''
                            $Labels[$d][8] = ''
                            $Labels[$d][9] = ''
                            $Labels[$d][10] = ''
                        Next
                        $hm[0] = 0
                    EndIf
                Next
                Return
            EndIf
        Next ;<-- End Child Filter: This is so child windows of a main windows won't show on the toolbar.
        If $hm1 = $hm[0] Then
            Return ;$hm[0]
        ElseIf $hm1 <> $hm[0] Then
            For $d = 1 To $hm[0]
                GUICtrlDelete($Labels[$d][0])
                GUICtrlDelete($Labels[$d][3])
                $Labels[$d][1] = ''
                $Labels[$d][2] = ''
                $Labels[$d][1] = ''
                $Labels[$d][2] = ''
                $Labels[$d][4] = ''
                $Labels[$d][5] = ''
                $Labels[$d][6] = ''
                $Labels[$d][7] = ''
                $Labels[$d][8] = ''
                $Labels[$d][9] = ''
                $Labels[$d][10] = ''
            Next
            SetLabels()
        EndIf
    EndIf
EndFunc

Func SetLabels()
    $hm[0] = 0
    $Rx = 277
    $Ry = 38
    $TrimTitle = ''
    $var = WinList()
    For $i = 1 to $var[0][0]
        If $var[$i][0] <> "" AND IsVisible($var[$i][1]) And $var[$i][0] <> 'Program Manager' And $var[$i][0] <> $NTB1 And $var[$i][0] <> $NTB2 Then ; Added Program Manger nnd Toolbar window to not show on toolbar
            $hm[0] = $hm[0] + 1
			If $hm[0] < 8 Then
				If WinExists($NTB2) Then ; <-- Adjust the control position if complete gui is showing
					$Ry = 158
				EndIf
				$Labels[$hm[0]][1] = $var[$i][1] ; <-- Store the window handle

				$Labels[$hm[0]][2] = _ProcessGetLocation(WinGetProcess($var[$i][1])) ; <-- Store the window process id path
				$Labels[$hm[0]][3] = GUICtrlCreateIcon($Labels[$hm[0]][2], 0, $Rx+1, $Ry+1, 16, 16) ; <-- Store/Create the icons for the labels
				GUICtrlSetCursor($Labels[$hm[0]][3], 0)

				$Labels[$hm[0]][4] = 'Window Title: ' & $var[$i][0] & @LF & 'Process Path: ' & $Labels[$hm[0]][2] ;<-- This stores the info for a tooltip

				$Labels[$hm[0]][0] = GUICtrlCreateLabel('',$Rx , $Ry, 93, 18, $SS_LEFTNOWORDWRAP + $SS_CENTERIMAGE) ; <-- Store/Create the label controls
				GUICtrlSetBkColor($Labels[$hm[0]][0], $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetColor($Labels[$hm[0]][0], 0xffffff)
				GUICtrlSetFont($Labels[$hm[0]][0] ,7, 400)
				GUICtrlSetCursor($Labels[$hm[0]][0], 0)
				$Labels[$hm[0]][20] = GUICtrlCreateLabel('',$Rx , $Ry, 93, 1)
				GUICtrlSetBkColor($Labels[$hm[0]][20], 0xffffff)
				$Labels[$hm[0]][21] = GUICtrlCreateLabel('',$Rx , $Ry+17, 93, 1)
				GUICtrlSetBkColor($Labels[$hm[0]][21], 0xffffff)
				$Labels[$hm[0]][22] = GUICtrlCreateLabel('',$Rx , $Ry, 1, 18)
				GUICtrlSetBkColor($Labels[$hm[0]][22], 0xffffff)
				$Labels[$hm[0]][23] = GUICtrlCreateLabel('',$Rx+92 , $Ry, 1, 18)
				GUICtrlSetBkColor($Labels[$hm[0]][23], 0xffffff)           
			   
				If StringLen($var[$i][0]) > 16 Then  ; <-- Start: Trim titles for the labels
					$TrimTitle = StringLeft($var[$i][0], 16) & '...'
				Else
					$TrimTitle = $var[$i][0]
				EndIf   ; <-- End: Trim titles for the labels
				GuiCtrlSetData($Labels[$hm[0]][0], '      ' & $TrimTitle) ; <-- Set the trimmed titles on the labels
			   
				$Rx = $Rx + 96
			   
				$Labels[$hm[0]][5] = GUICtrlCreateContextMenu($Labels[$hm[0]][0]) ;<-- Store/create Context Menu on label
				$Labels[$hm[0]][6] = GUICtrlCreateMenuitem("Restore Window", $Labels[$hm[0]][5]) ;<-- Store/create Context Menu Item for label
				$Labels[$hm[0]][7] = GUICtrlCreateMenuitem("Minimize Window", $Labels[$hm[0]][5]) ;<-- Store/create Context Menu Item for label
				$Labels[$hm[0]][8] = GUICtrlCreateMenuitem("Maximize Window", $Labels[$hm[0]][5]) ;<-- Store/create Context Menu Item for label
				$Labels[$hm[0]][9] = GUICtrlCreateMenuitem("", $Labels[$hm[0]][5]) ;<-- Store/create Context Menu Item (Line) for label
				$Labels[$hm[0]][10] = GUICtrlCreateMenuitem("Close Window", $Labels[$hm[0]][5]) ;<-- Store/create Context Menu Item for label
			EndIf
        EndIf
    Next
    ToolTipCheck()
EndFunc

Func _PlusCreate()
	$PlusContext[0] = GUICtrlCreateContextMenu($Plus)
	$PlusContext[1] = GUICtrlCreateMenuitem("Test", $PlusContext[0])
EndFunc

Func ToolTipCheck()
    If $ToolTipDisable[0] = 0 Then
        GUICtrlSetData($ToolBarContext[7], 'Disable Tooltips')
        For $tte = 1 To $hm[0]
            GUICtrlSetTip($Labels[$tte][0], $Labels[$tte][4])
        Next
    ElseIf $ToolTipDisable[0] = 1 Then
        GUICtrlSetData($ToolBarContext[7], 'Enable Tooltips')
        For $ttd = 1 To $hm[0]
            GUICtrlSetTip($Labels[$ttd][0], '')
        Next
    EndIf
EndFunc