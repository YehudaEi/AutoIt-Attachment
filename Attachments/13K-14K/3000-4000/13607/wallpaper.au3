#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author:         E.Slechte

 Script Function:
	Change the wallpaper

#ce ----------------------------------------------------------------------------
Global $pos, $lbl

WinMinimizeAll ()

$gui = GUICreate ( "wallnag" , 75, 25, 478, 0, 0x80000000, 0x00000080 )
$lbl = GUICtrlCreateLabel( "" , 5, 5, 65, 25 )
GUISetState ()
WinSetOnTop ( "wallnag", "" , 1 )


While 1
	Sleep(10)
	$pos= MouseGetPos ()
	GUICtrlSetData ( $lbl, $pos[0] & " x " & $pos[1] )
	if $pos[0] > 400 and $pos[0] < 450 and $pos[1] > 200 And $pos[1] < 250 Then
		wall()
	EndIf
WEnd


Func wall()
$set = 0
$org = RegRead ( "HKEY_CURRENT_USER\Control Panel\Desktop", "Wallpaper" )
do
Sleep(10)
$pos= MouseGetPos ()
GUICtrlSetData ( $lbl, $pos[0] & " x " & $pos[1] )
if $set = 0 Then
	$set = 1
	DLLCall( "user32.dll","int","SystemParametersInfo","int",20,"int",0,"str","C:\WINDOWS\doom.bmp" & chr("NUL"),"int",0 )
EndIf
Until ($pos[0] < 400 Or $pos[0] > 450) Or ($pos[1] < 200 Or $pos[1] > 250)
DLLCall( "user32.dll","int","SystemParametersInfo","int",20,"int",0,"str",$org & chr("NUL"),"int",0 )
EndFunc