;ws - Sen's Simple Wallpaper Selector
;Version 1.00 - December 20th 2007
;Original code: alien13 (http://www.autoitscript.com/forum/index.php?showtopic=55422&st=0)
;Thanks!
;

#include <GUIConstants.au3>
#Include <GuiListBox.au3>

Global $Ini = @ScriptDir & "\ws.ini"
Dim Const $SPI_SETDESKWALLPAPER = 20;
Dim Const $SPIF_UPDATEINIFILE = 0x01;
Dim Const $SPIF_SENDWININICHANGE = 0x02;
Dim Const $REGISTRY_PATH = "HKEY_CURRENT_USER\Control Panel\Desktop"

_Wallpaper()

Func _PopulateListBox($WallpaperList)
	$var = IniReadSection($Ini, "List")
	If @error Then 
		MsgBox(4096, "", "INI file not found, pick a wallpaper (.bmp) then click Save to remedy.")
	Else
		For $i = 1 To $var[0][0]
			If FileExists($var[$i][1]) Then
				_GUICtrlListBox_AddString($WallpaperList, $var[$i][1])
			EndIf
		Next
	EndIf
EndFunc

Func _Wallpaper()
    $WPs = IniRead($Ini, "Settings", "Background", "")
    $WallpaperMain = GUICreate("A13 Shell - Wallpaper Selector", 367, 406)
    Global $WallpaperList = GUICtrlCreateList("", 16, 208, 334, 159, $WS_VSCROLL)
    ;$WallpaperPreview = GUICtrlCreatePic("", 70, 16, 260, 177, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
    $Browse = GUICtrlCreateButton("Browse", 8, 368, 65, 25, 0)
    $Preview = GUICtrlCreateButton("Preview", 78, 368, 65, 25, 0)
    $Save = GUICtrlCreateButton("Save", 150, 368, 65, 25, 0)
    $Delete = GUICtrlCreateButton("Delete", 222, 368, 65, 25, 0)
    $Cancel = GUICtrlCreateButton("Close", 294, 368, 65, 25, 0)
	
	_PopulateListBox($WallpaperList)
	_GUICtrlListBox_SetCurSel($WallpaperList, 0)
	$NewPic = _GUICtrlListBox_GetText($WallpaperList, _GUICtrlListBox_GetCurSel($WallpaperList))
	$WallpaperPreview = GUICtrlCreatePic($NewPic, 50, 16, 257, 177, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
	
    GUISetState(@SW_SHOW)

    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                GUIDelete($WallpaperMain)
                ExitLoop
            Case $Browse
                $SelectWP = FileOpenDialog("Please select an image(s) to add to the list.", @DesktopDir, "Images (*.jpg;*.bmp)", 1)
                _GUICtrlListBox_AddString($WallpaperList, $SelectWP)
                GUICtrlDelete($WallpaperPreview)
                $WallpaperPreview = GUICtrlCreatePic($SelectWP, 50, 16, 257, 177, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
				_GUICtrlListBox_SetCurSel($WallpaperList, _GUICtrlListBox_GetCount($WallpaperList)-1)
            Case $Preview
                GUICtrlDelete($WallpaperPreview)
                $NewPic = _GUICtrlListBox_GetText($WallpaperList, _GUICtrlListBox_GetCurSel($WallpaperList))
                $WallpaperPreview = GUICtrlCreatePic($NewPic, 50, 16, 257, 177, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
            Case $Save
				$err = 0
                $GetPic = _GUICtrlListBox_GetText($WallpaperList, _GUICtrlListBox_GetCurSel($WallpaperList))
                $SaveBkGrnd = IniWrite($Ini, "Settings", "Background", $GetPic)
                $SetBkGrnd = GUICtrlSetImage($SaveBkGrnd, $GetPic)
				_UpdateIni($WallpaperList)
				$err = RegWrite( $REGISTRY_PATH, "WallpaperStyle", "REG_SZ", "2" )	;update registry, stretch
                $err += RegWrite( $REGISTRY_PATH, "TileWallpaper", "REG_SZ", "0" )
				If $err <> 2 Then
                    MsgBox( 4096, "Registery Error!!!", "There was an error writing to the registry." )
                Else
                    ;code taken from autoit forum, but forgot whose.
                    $err = DllCall( "User32.dll", "int", "SystemParametersInfo", "int", $SPI_SETDESKWALLPAPER, _
                                    "int", 0, "string", $GetPic, "int", $SPIF_UPDATEINIFILE )
                    If @error <> 0 Then
                        MsgBox( 4096, "Dll Error!!!", "There was an error making the Dll call." & @CR & "Error Code: " & @error )
                    EndIf 
                    $err = DllCall( "User32.dll", "int", "SystemParametersInfo", "int", $SPI_SETDESKWALLPAPER, _
                                    "int", 0, "string", $GetPic, "int", $SPIF_SENDWININICHANGE )
                    If @error <> 0 Then
                        MsgBox( 4096, "Dll Error!!!", "There was an error making the Dll call." & @CR & "Error Code: " & @error )
                    EndIf                      
                EndIf
            Case $Delete
                $GetPc = _GUICtrlListBox_GetCurSel($WallpaperList)
                _GUICtrlListBox_DeleteString($WallpaperList, $GetPc)
                GUICtrlDelete($WallpaperPreview)
            Case $Cancel
                GUIDelete($WallpaperMain)
                ExitLoop
        EndSwitch
    WEnd
EndFunc

Func _UpdateIni($newList)
	IniDelete($Ini, "List")
	$preparedData = ""
	_GUICtrlListBox_SetCurSel($newList, 0)
	
	For $i = 0 to _GUICtrlListBox_GetCount($newList)-1
		$preparedData = $preparedData & @LF & $i+1 & "=" & _GUICtrlListBox_GetText($newList, $i)
	Next
	IniWriteSection($Ini, "List", $preparedData)
EndFunc