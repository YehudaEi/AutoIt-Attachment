#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=antilock.ico
#AutoIt3Wrapper_Outfile=AntiLock.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=This is a free software created to override the locking of the screen as a resault of group policy and like.
#AutoIt3Wrapper_Res_Description=Anti Screen Lock
#AutoIt3Wrapper_Res_Fileversion=1.0.0.3
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=This software is free for public use.
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
TraySetToolTip ( "Anti Screen Lock" )
Opt ("TrayAutoPause", 0)
While 1
$pos = MouseGetPos()
MouseMove ( @DesktopWidth-10, @DesktopHeight+10, 1 )
MouseMove ($pos[0], $pos[1], 1)
TrayTip ( "Anti Screen Lock", "Anti Screen Lock is Enabled", 10, 1 )
Sleep ( 840000 )
WEnd