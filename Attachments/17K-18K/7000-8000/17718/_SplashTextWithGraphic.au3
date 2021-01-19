#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.8.1
 Author:         Chris Lambert

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include-once
#include <GuiConstants.au3>
; Script Start - Add your code below here
Global  $Splash_Gui_Main

;===============================================================================
;
; Function Name:    _SplashTextWithGraphicOn
; Description:      Creates a splash text window with graphic
; Syntax:           _SplashTextWithGraphicOn($vWinTitle="",$vText="",$iWidth=500,$iHeight=400,$iXPos=-1,$iYPos=-1,$vGraphic="",$iLogo_XPos=0,$iLogo_YPos=0,$iLogo_Width=0,$iLogo_Height=0,$iOpt = 0,$vFontName = "",$iFontSz = 12,$iFontWt = 400)
;                   Call _splashTextWithGraphicOFF() to turn off splash window
;
; Parameter(s):     $vWinTitle (Optional)      = Title for splash window.
;                   $vText (Optional)     	   = Text for splash window.
;                   $iWidth (Optional)     	   = Width of window in pixels. (default 500)
;                   $iHeight (Optional)        = Height of window in pixels. (default 400)
;                   $iXPos  (Optional)         = Position from left (in pixels) of splash window. (default is centered)
;                   $iYPos (Optional)          = Position from top (in pixels) of splash window. (default is centered)
;                   $vGraphic (Optional)       = Graphic to use in Splash window.
;					$iLogo_XPos (Optional)     = Left position of top left corner of the graphic inside the splash window
;					$iLogo_YPos (Optional)     = Top position of top left corner of the graphic inside the splash window
;                   $iLogo_Width (Optional)    = Width to display the graphic
;                   $iLogo_Height (Optional)   = Height to display the graphic
;                   $iOpt (Optional)           = Option see list below
;                                              [optional] Add them up - default is 'center justified/always on top/with title'
;                                              0 = Center justified/always on top/with title (default)
;                                              1 = Thin bordered titleless window
;                                              2 = Without "always on top" attribute
;                                              4 = Left justified text
;                                              8 = Right justified text
;                                              16 = Windows can be moved
;                                              32 = Centered vertically text
;                   $vFontName (Optional)      = Font to use. (OS default GUI font is used if the font is "" or is not found)
;                   $iFontSz (Optional)        = Font size. (default is 12; standard sizes are 6 8 9 10 11 12 14 16 18 20 22 24 26 28 36 48 72)
;                   $iFontWt (Optional)        = Font weight (0 - 1000, default = 400 = normal). A value > 1000 is treated as zero.
;
; Requirement(s):   None
;
; Return Value(s):  On Success - Returns 0
;                   On Failure - Returns an Error code based on the first error from left to right of syntax
;                   Window handle is stored in $Splash_Gui_Main
;					error Codes
;0 					No Error
;1 					GuiWidth is not numeric
;2 					GuiHeight is not numeric
;3 					GuiXpos is not numeric
;4 					GuiYpos is not numeric
;5 					Graphic does not exist
;6 					GraphicXpos is not numeric
;7 					GraphicYpos is not numeric
;8 					GraphicWidth is not numeric
;9 					GraphicHeight is not numeric
;10 				Font size is not numeric
;11 				Font Weight is not numeric
;12 				Font Weight is greater than 1000
;13 				Font Weight is less than 0
; Author(s):        Chris Lambert (ChrisL) (WM_NCHITTEST() and _API_DefWindowProc() was found on a post by Martin on Autoit Forms!)
; Note(s):          Based on SplashTextOn() and SplashImageOn()
;===============================================================================

Func _SplashTextWithGraphicOn($vWinTitle="",$vText="",$iWidth=500,$iHeight=400,$iXPos=-1,$iYPos=-1,$vGraphic="",$iLogo_XPos=0,$iLogo_YPos=0,$iLogo_Width=0,$iLogo_Height=0,$iOpt = 0,$vFontName = "",$iFontSz = 12,$iFontWt = 400)

DIM Const $WM_ENTERSIZEMOVE = 0x231
DIM Const $WM_EXITSIZEMOVE = 0x232
DIM Const $WM_NCHITTEST = 0x0084
Local $Ret = 0

	If $iFontWt < 0  then 
		$iFontWt = 0
		$Ret = 13
	EndIf
	
	If $iFontWt > 1000  then
		$iFontWt = 1000
		$Ret = 12
	EndIf
	
	If NOT Int($iFontWt) then 
		$iFontWt=400
		$Ret = 11
	EndIf
	
	If NOT Int($iFontSz)  then
		$iFontSz=12
		$Ret = 10
	EndIf
	
	If NOT StringIsDigit($iLogo_Height)  then
		$iLogo_Height = 0
		$Ret = 9
	EndIf
	
	If NOT StringIsDigit($iLogo_Width)  then
		$iLogo_Width = 0
		$Ret = 8
	Endif
	
	If NOT Int($iLogo_YPos)  then
		$iLogo_YPos=0
		$Ret = 7
	EndIf
	
	If NOT Int($iLogo_XPos) then
		$iLogo_XPos=0
		$Ret = 6
	Endif
	If $vGraphic <> ""  then
		If NOT FileExists($vGraphic) then $Ret = 5
	EndIf
		
	If NOT Int($iYPos) then
		$iYPos=-1
		$Ret = 4
	EndIf
	
	If NOT Int($iXpos) then
		$iXPos=-1
		$Ret = 3
	Endif
	
	If NOT Int($iHeight)  then
		$iHeight=400
		$Ret = 2
	EndIf
	
	If NOT Int($iWidth) then
		$iWidth=500
		$Ret = 1
	EndIf

	If BitAnd($iOpt,1) then 
		$Splash_Gui_Main = GuiCreate($vWinTitle,$iWidth,$iHeight,$iXPos,$iYPos, BitOr ($WS_POPUP,$WS_BORDER))
	Else
		$Splash_Gui_Main = GuiCreate($vWinTitle,$iWidth,$iHeight,$iXPos,$iYPos,BitOr($WS_CAPTION, $WS_POPUP))
	EndIf

	If $vGraphic <> "" and FileExists($vGraphic) then 
		$pic = GuiCtrlCreatePic($vGraphic,$iLogo_XPos,$iLogo_YPos,$iLogo_Width,$iLogo_Height)
		GuiCtrlSetState(-1,$GUI_DISABLE)
	EndIf

	$edit = GuiCtrlCreateLabel($vText,0,0,$iWidth,$iHeight,$SS_CENTER,$WS_EX_TRANSPARENT )
	GuiCtrlSetFont(-1,$iFontSz,$iFontWt,-1,$vFontName)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	If NOT BitAnd($iOpt,2) then 
		WinSetOnTop($Splash_Gui_Main,"",1)
	EndIf

	If  BitAnd($iOpt,4) then 
		GUICtrlSetStyle($edit,$SS_LEFT)
	EndIf

	If BitAnd($iOpt,8) then 
		GUICtrlSetStyle($edit,$SS_RIGHT )
	EndIf

	If BitAnd($iOpt,32) then 
		GUICtrlSetStyle($edit,$SS_CENTERIMAGE)
	EndIf

		GuiSetState()
		
	If NOT BitAnd($iOpt,16) then 
		GUIRegisterMsg($WM_NCHITTEST,"WM_NCHITTEST")
	EndIf
	
SetError($ret)
Return $Ret

EndFunc


Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
	
	If Not IsDeclared("WM_NCHITTEST") then 
		Local $WM_NCHITTEST ;Just to keep Au3Check happy!
		Return
	EndIf
	
    If $hWnd = $Splash_Gui_Main And $iMsg = $WM_NCHITTEST Then
     $id = _API_DefWindowProc($hWnd, $iMsg, $iwParam, $ilParam)
     If $id = 2 Then;if it is the title handle
       Return 1;return the client handle
   Else
       Return $id;return the real handle
   EndIf
   EndIf
          
EndFunc
   
Func _API_DefWindowProc($hWnd, $iMsg, $iwParam, $ilParam)
  Local $aResult
  $aResult = DllCall("User32.dll", "int", "DefWindowProc", "hwnd", $hWnd, "int", $iMsg, "int", $iwParam, "int", $ilParam)
  Return $aResult[0]
EndFunc

Func _SplashTextWithGraphicOFF()
	IF WinExists($Splash_Gui_Main) then GuiDelete($Splash_Gui_Main)
	$Splash_Gui_Main = ""
EndFunc