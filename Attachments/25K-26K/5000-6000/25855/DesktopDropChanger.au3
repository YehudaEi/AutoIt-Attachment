;Desktop Wallpaper Changer
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <file.au3>
#include <ScreenCapture.au3>
#include <SliderConstants.au3>
#Include <Misc.au3>
;
;version 2
Global $INI	= @ScriptDir & "\DesktopC.ini" 
Global $BK_COLOR = IniRead($INI, "Settings", "BK_COLOR", 0x000000)
Global $TXT_COLOR = _LightDark($BK_COLOR)
Global $szDrive, $szDir, $szFName, $szExt
Global $DESK_X = @DesktopWidth, $DESK_Y = @DesktopHeight
Global $Ratio = IniRead($INI, "Settings", "RATIO", 3.5)
Global $ShowCurrent = IniRead($INI, "Settings", "showcurrent", 1)
Global $REG_DESKTOP = "HKEY_CURRENT_USER\Control Panel\Desktop"
	
Global $iGUIWidth = Round($DESK_X/$Ratio,0) + 16, $iGUIHeight = Round($DESK_Y/$Ratio,0) + 82
;
If Not FileExists($INI) Then IniWriteSection($INI, "Settings", "BK_COLOR=0x000000" & @LF & "RATIO=3.5")
;
Opt("PixelCoordMode", 2)
#Region ### START Koda GUI section ### Form=
$Form1 			= GUICreate("Desktop Changer", $iGUIWidth, $iGUIHeight, -1, -1, -1, $WS_EX_ACCEPTFILES)
			GUISetFont(8, 400, 0, "Lucida Grande")
			WinSetOnTop("Desktop Changer", "", 1)
			GUISetBkColor($BK_COLOR)
			
			;GUI Context Menu
$ContextM		= GUICtrlCreateContextMenu()
$Topmenu 		= GUICtrlCreateMenuItem("Top Most", $ContextM)
			GUICtrlSetState(-1, $GUI_CHECKED)
$option 		= GUICtrlCreateMenuItem("Options", $ContextM)
			
			;Top Box
			GUICtrlCreateGraphic(7, 8, Round($DESK_X/$Ratio,0) + 2, 20) 
			GUICtrlSetColor(-1, $TXT_COLOR)
			GUICtrlSetBkColor(-1, $BK_COLOR)
			GUICtrlSetState(-1, $GUI_DISABLE) 	
			
			GUICtrlCreateLabel("Drop image file into feild below.", 10, 12)
			GUICtrlSetColor(-1, $TXT_COLOR)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)		
			
			; Buttons
$Button1		= GUICtrlCreateButton("Set", 8, Round($DESK_Y/$Ratio,0) + 52, 60, 17)
			GUICtrlSetState(-1, $GUI_DISABLE)
			
$Button2		= GUICtrlCreateButton("Close", Round($DESK_X/$Ratio,0) - 50, Round($DESK_Y/$Ratio,0) + 52, 60, 17)
 
$Button3		= GUICtrlCreateButton("Current", 72, Round($DESK_Y/$Ratio,0) + 52, 60, 17)  
			
			; Drop box area
			GUICtrlCreateGraphic(7, 27, Round($DESK_X/$Ratio,0) + 2, Round($DESK_Y/$Ratio,0)) 
			GUICtrlSetColor(-1, $TXT_COLOR)
			GUICtrlSetBkColor(-1, 0x555555)
			GUICtrlSetState(-1, $GUI_DISABLE)  

$Background		= GUICtrlCreatePic("", 8, 28, Round($DESK_X/$Ratio,0), Round($DESK_Y/$Ratio,0)-2)
			GUICtrlSetState(-1, $GUI_DROPACCEPTED)
			
			
			;Background Context Menu
$Context		= GUICtrlCreateContextMenu($Background)
$Openmenu 		= GUICtrlCreateMenuItem("Browse Image...", $Context)
$Editmenu 		= GUICtrlCreateMenuItem("Edit Image...", $Context)
			GUICtrlSetState(-1, $GUI_DISABLE)  
$cOption 		= GUICtrlCreateMenuItem("Options", $Context)

			; bottom box
$rec			= GUICtrlCreateGraphic(7,  Round($DESK_Y/$Ratio,0) + 26, Round($DESK_X/$Ratio,0) + 2, 20) 
			GUICtrlSetColor(-1, $TXT_COLOR)
			GUICtrlSetBkColor(-1, $BK_COLOR)
			GUICtrlSetState(-1, $GUI_DISABLE) 
			
$Label2 		= GUICtrlCreateLabel("", 8,  Round($DESK_Y/$Ratio,0) + 30, Round($DESK_X/$Ratio,0) - 4, 17, $SS_RIGHT)
			GUICtrlSetColor(-1, $TXT_COLOR)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetFont(-1, 8, 400, 0, "Lucida Grande")
			; link to interfacelift.com for wallpaper
$Label3			= GUICtrlCreateLabel("InterFaceLift.com",Round($DESK_X/$Ratio,0)-90, Round($DESK_Y/$Ratio,0) + 70, 100, 17, $SS_RIGHT)
			GUICtrlSetColor(-1, $TXT_COLOR)
			GUICtrlSetCursor(-1, 0)
			GUICtrlSetTip(-1, "InterFaceLift.com")
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			
			If $ShowCurrent = 1 Then
				$path1 = RegRead($REG_DESKTOP, "WallPaper")
				If FileExists($path1) Then
					GUICtrlSetImage($Background, $path1)
					$path1 = _PathSplit($path1, $szDrive, $szDir, $szFName, $szExt)
					GUICtrlSetData($Label2, $path1[3] & $path1[4])
					GUICtrlSetState($Editmenu, $GUI_ENABLE)
				Else
					GUICtrlSetData($Label2, "File does not exist")
				EndIf
			EndIf
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $Button2
			Exit
			;
		Case $GUI_EVENT_DROPPED
			$path1 = _PathSplit(@GUI_DragFile, $szDrive, $szDir, $szFName, $szExt)
			GUICtrlSetImage($Background, @GUI_DragFile)
			If _isImage(@GUI_DragFile) = 0 Then 
				GUICtrlSetData($Label2, $path1[3] & $path1[4] & " - Not an image file.")
			Else
				GUICtrlSetState($Editmenu, $GUI_ENABLE) 
				GUICtrlSetState($Button1, $GUI_ENABLE)   
				GUICtrlSetState($Button2, $GUI_ENABLE)  
				GUICtrlSetTip($Background, $path1[0])
				GUICtrlSetData($Label2, $path1[3] & $path1[4])
			EndIf
			;
		Case $Editmenu
			ShellExecute($path1[0], "", "", "edit")
		Case $Button1
			_ChangeDestopWallpaper($path1[0])
			If @error = 2 Then 
				GUICtrlSetData($Label2, "Not an image file.")
				Sleep(1000)
				GUICtrlSetImage($Background, "")
			Else
			EndIf
			;
		Case $Button3
			$path1 = RegRead($REG_DESKTOP, "WallPaper")
			If FileExists($path1) Then
				GUICtrlSetImage($Background, $path1)
				$path1 = _PathSplit($path1, $szDrive, $szDir, $szFName, $szExt)
				GUICtrlSetData($Label2, $path1[3] & $path1[4])
				GUICtrlSetState($Editmenu, $GUI_ENABLE)
			Else
				GUICtrlSetData($Label2, "File does not exist")
			EndIf
		Case $Openmenu
			$ImageFile = FileOpenDialog("Choose an Image", "", "Images (*.bmp;*.jpg;*.jpeg;*.jpe;*.jfif;*.tif;*.tiff;*.png)")
			
			$path1 = _PathSplit($ImageFile, $szDrive, $szDir, $szFName, $szExt)
			GUICtrlSetImage($Background, $ImageFile)
			If _isImage($ImageFile) = 0 Then 
				GUICtrlSetData($Label2, $path1[3] & $path1[4] & " - Not an image file.")
			Else
				GUICtrlSetState($Editmenu, $GUI_ENABLE)   
				GUICtrlSetState($Button1, $GUI_ENABLE)  
				GUICtrlSetState($Button2, $GUI_ENABLE)   
				GUICtrlSetTip($Background, $path1[0])
				GUICtrlSetData($Label2, $path1[3] & $path1[4])
			EndIf
			;
		Case $Topmenu
			If BitAND(GUICtrlRead($Topmenu), $GUI_CHECKED) = $GUI_CHECKED Then
				WinSetOnTop("Desktop Changer", "", 0)		
				GUICtrlSetState($Topmenu, $GUI_UNCHECKED)
			Else
				WinSetOnTop("Desktop Changer", "", 1)		
				GUICtrlSetState($Topmenu, $GUI_CHECKED)
			EndIf
			;
		Case $option, $cOption
			_Options()
			;
		Case $Label3
			ShellExecute("                                                             " & _ScreenRes())
	EndSwitch
WEnd
;
Func _ChangeDestopWallpaper($img, $style = 0)
	Local $SPI_SETDESKWALLPAPER = 20
	Local $SPIF_UPDATEINIFILE = 1
	Local $SPIF_SENDCHANGE = 2

	
	$Path = _PathSplit($img, $szDrive, $szDir, $szFName, $szExt)
	
		If Not FileExists($Path[0]) Then
			SetError(1)
			Return 0
		EndIf
		;Check to see if the file is an image.
		Switch $Path[4]
			Case ".bmp", ".jpg", ".jpeg", ".jpe", ".jfif", ".tif", ".tiff", ".png" ; add more if needed
				; continue
			Case Else
				SetError(2)
				Return 0
		EndSwitch
		
		If $style = 1 then
		   RegWrite($REG_DESKTOP, "TileWallPaper", "REG_SZ", 1)
		   RegWrite($REG_DESKTOP, "WallpaperStyle", "REG_SZ", 0)
		Else
		   RegWrite($REG_DESKTOP, "TileWallPaper", "REG_SZ", 0)
		   RegWrite($REG_DESKTOP, "WallpaperStyle", "REG_SZ", $style)
		EndIf
	  
		DllCall("user32.dll", "int", "SystemParametersInfo", _
			 "int", $SPI_SETDESKWALLPAPER, _
			 "int", 0, _
			 "str", $Path[0], _
			 "int", BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE))
			 
		Return 0
EndFunc
;	
Func _isImage($himage)
	$Path2 = _PathSplit($himage, $szDrive, $szDir, $szFName, $szExt)
	
	Switch $Path2[4]
		Case ".bmp", ".jpg", ".jpeg", ".jpe", ".jfif", ".tif", ".tiff", ".png" ; add more if needed
			Return 1
		Case Else
			Return 0
	EndSwitch
EndFunc
;
Func _ScreenRes()
	Local $Desktop_Resolution = @DesktopWidth & "x" & @DesktopHeight
	
	Switch $Desktop_Resolution
		Case "2560x1600", "1920x1200", "1680x1050", "1440x900", "1280x800"
			Return "widescreen/" & $Desktop_Resolution & "/"
		Case "1600x1200", "1400x1050", "1280x1024", "1280x960", "1024x768"
			Return "fullscreen/" & $Desktop_Resolution & "/"
		Case Else
			Return "any/"
	EndSwitch
EndFunc
;
Func _LightDark($i_Color)
	If $i_Color > 0xFFFFFF/2 Then $o_Color = 0x000000
	If $i_Color < 0xFFFFFF/2 Then $o_Color = 0xFFFFFF
	Return $o_Color
EndFunc
;
Func _restart()
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
	Exit
EndFunc
;
Func _Options()
	GUISetState(@SW_HIDE, $Form1)
	#Region ### START Koda GUI section ### Form=
	$Option_Gui		= GUICreate("Options", 295, 199, -1, -1,BitOR($WS_MINIMIZEBOX,$WS_CAPTION,$WS_POPUP,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS), BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
				WinSetOnTop($Option_Gui, "", 1)	
	$Option_Slider	= GUICtrlCreateSlider(0, 48, 294, 29, BitOR($TBS_TOP,$TBS_LEFT))
				GUICtrlSetLimit(-1, 100, 40)
				GUICtrlSetData(-1, 140 - ($Ratio*20))
	GUICtrlCreateLabel("Window Size:", 8, 8, 100, 17)
	GUICtrlCreateLabel("Small", 3, 32, 100, 17)
		GUICtrlSetFont(-1, 7, 400, 0, "tahoma")
	GUICtrlCreateLabel("Big", 270, 32, 100, 17)
		GUICtrlSetFont(-1, 7, 400, 0, "tahoma")
	GUICtrlCreateLabel("Background Color:", 8, 96, 92, 17)
	$Option_Input 	= GUICtrlCreateLabel($BK_COLOR, 8, 124, 121, 14, $SS_CENTER)
		GUICtrlSetColor(-1, _LightDark($BK_COLOR))
		GUICtrlSetBkColor(-1, $BK_COLOR)
		GUICtrlSetFont(-1, 8.5, 400, 0, "Courier New")
	$Option_Browse 	= GUICtrlCreateButton("Browse...", 136, 120, 75, 21, 0)
	$Optiion_Current= GUICtrlCreateCheckbox("Show Current Wallpaper when opened", 8, 145)
	If $ShowCurrent = 1 Then GUICtrlSetState(-1, $GUI_CHECKED)
	$Option_Save 	= GUICtrlCreateButton("Save and Restart", 184, 168, 107, 25, 0)
	$Option_Cancel 	= GUICtrlCreateButton("Cancel", 104, 168, 75, 25, 0)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Option_Cancel
				GUIDelete($Option_Gui)
				ExitLoop
			Case $Option_Save
				IniWrite($INI, "Settings", "RATIO", Round(((140-GUICtrlRead($Option_Slider))/20), 2))
				IniWrite($INI, "Settings", "BK_COLOR", GUICtrlRead($Option_Input))
				If BitAND(GUICtrlRead($Optiion_Current), $GUI_CHECKED) = $GUI_CHECKED Then
					IniWrite($INI, "Settings", "showcurrent", "1")
				Else
					IniWrite($INI, "Settings", "showcurrent", "0")
				EndIf
				GUIDelete($Option_Gui)
				_restart()
			Case $Option_Browse
				$OP_BK_COLOR = _ChooseColor(2, GUICtrlRead($Option_Input), 2)
				GUICtrlSetColor($Option_Input, _LightDark( "0x" & Hex($OP_BK_COLOR,6)))
				GUICtrlSetBkColor($Option_Input,  "0x" & Hex($OP_BK_COLOR,6))
				GUICtrlSetData($Option_Input, "0x" & Hex($OP_BK_COLOR,6))

		EndSwitch
	WEnd
	GUISetState(@SW_SHOW, $Form1)
EndFunc