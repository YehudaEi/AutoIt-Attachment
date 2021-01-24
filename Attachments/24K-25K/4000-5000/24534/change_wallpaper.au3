Func _ChangeDestopWallpaper($bmp, $style = 0)
;===============================================================================
;
; Function Name:    _ChangeDesktopWallPaper
; Description:       Update WallPaper Settings
;Usage:              _ChangeDesktopWallPaper(@WindowsDir & '\' & 'zapotec.bmp',1)
; Parameter(s):     $bmp - Full Path to BitMap File (*.bmp)
;                              [$style] - 0 = Centered, 1 = Tiled, 2 = Stretched
; Requirement(s):   None.
; Return Value(s):  On Success - Returns 0
;                   On Failure -   -1  
; Author(s):        FlyingBoz
;Thanks:        Larry - DllCall Example - Tested and Working under XPHome and W2K Pro
;                     Excalibur - Reawakening my interest in Getting This done.
;
;===============================================================================
      
   If Not FileExists($bmp) Then Return -1
  ;The $SPI*  values could be defined elsewhere via #include - if you conflict,
  ; remove these, or add if Not IsDeclared "SPI_SETDESKWALLPAPER" Logic
   Local $SPI_SETDESKWALLPAPER = 20
   Local $SPIF_UPDATEINIFILE = 1
   Local $SPIF_SENDCHANGE = 2
   Local $REG_DESKTOP= "HKEY_CURRENT_USER\Control Panel\Desktop"
   if $style = 1 then 
   RegWrite($REG_DESKTOP, "TileWallPaper", "REG_SZ", 1)
   RegWrite($REG_DESKTOP, "WallpaperStyle", "REG_SZ", 0)
Else
   RegWrite($REG_DESKTOP, "TileWallPaper", "REG_SZ", 0)
   RegWrite($REG_DESKTOP, "WallpaperStyle", "REG_SZ", $style)
EndIf

   
   DllCall("user32.dll", "int", "SystemParametersInfo", _
         "int", $SPI_SETDESKWALLPAPER, _
         "int", 0, _
         "str", $bmp, _
         "int", BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE))
   Return 0
EndFunc  ;==>_ChangeDestopWallpaper