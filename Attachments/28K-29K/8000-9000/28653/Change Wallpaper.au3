Func ChangeWallpaper($FileLong, $State = 3)
	Local $String = $FileLong, $SPI_SETDESKWALLPAPER = 20, $SPIF_UPDATEINIFILE = 1, $SPIF_SENDCHANGE = 2
	Do
		$FileLong = $String
		$String = StringReplace($FileLong, "/", "\")
	Until @extended = 0
	If Not FileExists($FileLong) Then
		SetError(-1)
		Return 0
	EndIf
	If StringRight($FileLong, 3) <> "bmp" Then
		SetError(-2)
		Return 0
	EndIf

	Local $WDir = RegRead('HKLM\Software\Microsoft\Windows\CurrentVersion', 'WallPaperDir')
	$FileShort = StringSplit($FileLong, "\")
	$FileShort = $FileShort[$FileShort[0]]
	If StringInStr($WDir, '%SystemRoot%') <> 0 Then
		$WDir = StringTrimLeft($WDir, 12)
		$WDir = @WindowsDir & $WDir
	EndIf
	FileCopy($FileLong, $WDir, 1); make wallpaper available in desktop properties window
	FileCopy($FileLong, 'C:\Documents and Settings\Owner\Local Settings\Application Data\Microsoft\Wallpaper1.bmp', 1)

	RegWrite('HKCU\Control Panel\Desktop', 'Wallpaper', 'reg_sz', 'C:\Documents and Settings\Owner\Local Settings\Application Data\Microsoft\Wallpaper1.bmp')
	RegWrite('HKCU\Control Panel\Desktop', 'ConvertedWallpaper', 'reg_sz', $WDir & "\" & $FileShort)
	Select
		Case 1; centered
			RegWrite('HKCU\Control Panel\Desktop', 'TileWallpaper', 'reg_sz', '0')
			RegWrite('HKCU\Control Panel\Desktop', 'WallpaperStyle', 'reg_sz', '0')
		Case 2; tiled
			RegWrite('HKCU\Control Panel\Desktop', 'TileWallpaper', 'reg_sz', '1')
			RegWrite('HKCU\Control Panel\Desktop', 'WallpaperStyle', 'reg_sz', '0')
		Case 3; stretched
			RegWrite('HKCU\Control Panel\Desktop', 'TileWallpaper', 'reg_sz', '0')
			RegWrite('HKCU\Control Panel\Desktop', 'WallpaperStyle', 'reg_sz', '2')
		Case Else
	EndSelect

	$Dll = DllCall("user32.dll", "int", "SystemParametersInfo", _
			"int", $SPI_SETDESKWALLPAPER, _
			"int", 0, _
			"str", $FileLong, _
			"int", BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE))
EndFunc   ;==>ChangeWallpaper