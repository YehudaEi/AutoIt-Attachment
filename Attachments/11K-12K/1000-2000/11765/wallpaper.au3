Dim $picture
Dim $err

$picture = ""
$err = RegWrite( "HKEY_CURRENT_USER\Control Panel\Desktop", "WallpaperStyle", "REG_SZ", "2" )
$err += RegWrite( "HKEY_CURRENT_USER\Control Panel\Desktop", "TileWallpaper", "REG_SZ", "0" )
$err = DllCall( "User32.dll", "int", "SystemParametersInfo", "int", 20, "int", 0, "string", $picture, "int", 0x02 )