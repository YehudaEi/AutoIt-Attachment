Func _IniGetSectionNames( $file, $TreeView )
    Local $varx = IniReadSectionNames( $file )
    If @error Then
        MsgBox(4096, "", "Error occured, probably no INI file.")
    Else
        For $i_SectionIndex = 1 To $varx[0]
            ;MsgBox(4096, "", $varx[$i_SectionIndex])
            _IniReadInfo( $file, $varx, $TreeView, $i_SectionIndex )
        Next
    EndIf
EndFunc

Func _IniReadInfo( $file, $varx, $TreeView, $i_SectionIndex )
    Local $var = IniReadSection($file,$varx[$i_SectionIndex])

    ;MsgBox(32,"VarX","Varx = " & $varx[$i_SectionIndex])

    If @error Then
        MsgBox(4096, "", "Error occured, probably no INI file.")
    Else
        Local $TreeView2 = GUICtrlCreateTreeViewitem($varx[$i_SectionIndex],$TreeView )
        For $i = 1 To $var[0][0]
            GUICtrlCreateTreeViewItem($var[$i][0], $TreeView2)
            ;MsgBox(4096, "", "Key: " & $var[$i][0] & @CRLF );& "Value: " & $var[$i][1])
        Next
    EndIf
EndFunc

Func _CreateGUI()
    If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000
   GuiCreate("Antitux-Installer", 955, 620,(@DesktopWidth-955)/2, (@DesktopHeight-620)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	Global $Edit_1 = GuiCtrlCreateEdit("Edit", 320, 10, 300, 600)
	Global $Pic_1 = GuiCtrlCreatePic("Screen1", 630, 100, 320, 240)
	Global $Pic_2 = GuiCtrlCreatePic("Screen2", 630, 370, 320, 240)
	Global $Button_install = GuiCtrlCreateButton("Installieren", 650, 20, 80, 30)
	Global $Button_repair = GuiCtrlCreateButton("Reparieren", 750, 20, 80, 30)
	Global $Button_uninstall = GuiCtrlCreateButton("Deinstallieren", 850, 20, 80, 30)
	Global $Label_1 = GuiCtrlCreateLabel("Screenshot n.v.", 630, 70, 320, 30)
	Global $Label_2 = GuiCtrlCreateLabel("Screenshot n.v.", 630, 350, 320, 20)
	Global $Group_Action = GuiCtrlCreateGroup("Aktion", 630, 0, 320, 60)
	Return GuiCtrlCreateTreeview(10, 10, 300, 600)
EndFunc