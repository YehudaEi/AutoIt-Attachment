#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#Include <Set Screen Resolution.au3>
#include <ChangeResolutionBack.au3>
Global $Autochecksystem
	$vResBack = _ChangeScreenRes($Desktopwidth, $Desktopheight, $Bitconfig, $iRefreshRate)
If $Autochecksystem = $oldautochecksystem Then
	Exit
Else
	MsgBox (0+64, "Sorry", "During the changing back process, something went wrong. Please use the control panel to set up your resolution configuration.")
EndIf
Exit
	
