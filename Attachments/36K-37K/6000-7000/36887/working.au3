;~ ;................................................................................................
;~ ;................................................................................................
; Save screen resolution
IniWrite("RESsave.ini","Width","Default",@DesktopWidth)
IniWrite("RESsave.ini","Height","Default",@DesktopHeight)
IniWrite("RESsave.ini","Depth","Default",@DesktopDepth)
IniWrite("RESsave.ini","Refresh","Default",@DesktopRefresh)
;~ ;................................................................................................
;~ ;................................................................................................
; Define screen resolution
$Width = 1024
$Height = 768
$BitsPerPixel = 32
$RefreshRate = 85
; Define and set resolution
_ChangeScreenRes(1024,768,32,85)
;~ ;................................................................................................
;~ ;................................................................................................
;~ ;................................................................................................
;~ ;................................................................................................

;ADD YOUR SCRIPT HERE

;~ ;................................................................................................
;~ ;................................................................................................
;~ ;................................................................................................
;~ ;................................................................................................
;~ ;REVERTING BACK TO PREVIOUSE SCREEN RESSOLUTION
$DRW = IniRead("RESsave.ini","Width","Default",@DesktopWidth)
$DRH = IniRead("RESsave.ini","Height","Default",@DesktopHeight)
$DD = IniRead("RESsave.ini","Depth","Default",@DesktopDepth)
$DR = IniRead("RESsave.ini","Refresh","Default",@DesktopRefresh)
; Define and set resolution
_ChangeScreenRes($DRW,$DRH,$DD,$DR)
;~ ;................................................................................................
;~ ;................................................................................................
   Func _ChangeScreenRes($i_Width = @DesktopWidth, $i_Height = @DesktopHeight, $i_BitsPP = @DesktopDepth, $i_RefreshRate = @DesktopRefresh)
	  Local Const $DM_PELSWIDTH = 0x00080000
	  Local Const $DM_PELSHEIGHT = 0x00100000
	  Local Const $DM_BITSPERPEL = 0x00040000
	  Local Const $DM_DISPLAYFREQUENCY = 0x00400000
	  Local Const $CDS_TEST = 0x00000002
	  Local Const $CDS_UPDATEREGISTRY = 0x00000001
	  Local Const $DISP_CHANGE_RESTART = 1
	  Local Const $DISP_CHANGE_SUCCESSFUL = 0
	  Local Const $HWND_BROADCAST = 0xffff
	  Local Const $WM_DISPLAYCHANGE = 0x007E
		 If $i_Width = "" Or $i_Width = -1 Then $i_Width = @DesktopWidth ; default to current setting
		 If $i_Height = "" Or $i_Height = -1 Then $i_Height = @DesktopHeight ; default to current setting
		 If $i_BitsPP = "" Or $i_BitsPP = -1 Then $i_BitsPP = @DesktopDepth ; default to current setting
		 If $i_RefreshRate = "" Or $i_RefreshRate = -1 Then $i_RefreshRate = @DesktopRefresh ; default to current setting
	  Local $DEVMODE = DllStructCreate("byte[32];int[10];byte[32];int[6]")
	  Local $B = DllCall("user32.dll", "int", "EnumDisplaySettings", "ptr", 0, "long", 0, "ptr", DllStructGetPtr($DEVMODE))
		 If @error Then
		 $B = 0
		 SetError(1)
		 Return $B
		 Else
		 $B = $B[0]
		 EndIf
		 If $B <> 0 Then
		 DllStructSetData($DEVMODE, 2, BitOR($DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY), 5)
		 DllStructSetData($DEVMODE, 4, $i_Width, 2)
		 DllStructSetData($DEVMODE, 4, $i_Height, 3)
		 DllStructSetData($DEVMODE, 4, $i_BitsPP, 1)
		 DllStructSetData($DEVMODE, 4, $i_RefreshRate, 5)
		 $B = DllCall("user32.dll", "int", "ChangeDisplaySettings", "ptr", DllStructGetPtr($DEVMODE), "int", $CDS_TEST)
		 If @error Then
		 $B = -1
		 Else
		 $B = $B[0]
		 EndIf
			Select
			Case $B = $DISP_CHANGE_RESTART
			$DEVMODE = ""
			Return 2
			Case $B = $DISP_CHANGE_SUCCESSFUL
			DllCall("user32.dll", "int", "ChangeDisplaySettings", "ptr", DllStructGetPtr($DEVMODE), "int", $CDS_UPDATEREGISTRY)
			DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_DISPLAYCHANGE, _
			"int", $i_BitsPP, "int", $i_Height * 2 ^ 16 + $i_Width)
			$DEVMODE = ""
			Return 1
			Case Else
			$DEVMODE = ""
			SetError(1)
			Return $B
			EndSelect
		 EndIf
EndFunc