#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#Include <WinAPI.au3>
#include <ChangeResolution.au3>
;-------------Hot Keys--------------
HotKeySet("{ESC}", "Terminate")
HotKeySet("{C}", "ChangeResToStart")
;------------Old Co-ordinates--------------
$Loop = 1
$Desktopwin = _WinAPI_GetDesktopWindow()
$Desktopheight = _WinAPI_GetClientWidth($Desktopwin);old
$Desktopwidth = _WinAPI_GetClientHeight($Desktopwin);old
$Bitconfig = PixelChecksum(0,0,$Desktopwidth,$Desktopheight);old
$oldautochecksystem = $Desktopheight+$Desktopwidth+$Bitconfig
Global $Changeit
Const $x1 = " by "
Const $x2 = " at "
;-------------New Co-ordinates------
$iWidth = 1080
$iHeight = 1024
$iBitsPP = 32
$iRefreshRate = 30
;-----------Run Test----------------
Func ChangeResToStart()
	MsgBox (0+64, "Screen Resolution Problem", "We have tested your system and your current screen resolution value is: "&$Desktopheight&$x1&$Desktopwidth&$x2&$Bitconfig)
	$Changeit = MsgBox (4+64, "Change of Screen Resolution", "This current screen resolution is too low to run the program effectively, would you like the macrolism software to change it?. All changes will be reversed before exit")
	SplashTextOn ("Now Changing", "Macrolism is now changing your screen resolution, this will happen in 5 seconds and only take a momement, please look away from your screen", 300, 200, 500, 500)
	Sleep (5000)
	$vRes = _ChangeScreenRes($iWidth, $iHeight, $iBitsPP, $iRefreshRate)
If @error Then
    MsgBox(262160, "ERROR", "Unable to change screen - check parameters and then restart.")
EndIf
Exit
EndFunc
Func Terminate()
	Exit
	EndFunc
If $Desktopheight+$Desktopwidth = 2304 then
	Exit
Else 
	ChangeResToStart()
	Endif
If $Changeit = 7 Then
	MsgBox (0+64, "Very well", "Please do not say I did not warn you. If your screen resolution is the incorrect size, this tutorial will not function properly. The application will now continue, press 'C' if you wish to change your decision, if not please click OK or wait 10 seconds", 10)
Else
	MsgBox (0+64, "Thank You!", "Your screen resolution will now be changed. It will be changed back again at the end of each tutorial to it's forner state.")
	ChangeResToStart()
EndIf
Exit