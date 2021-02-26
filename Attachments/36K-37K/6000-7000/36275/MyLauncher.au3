;____________________________________________________
;Scripted by dslate69 via http://www.autoitscript.com
;____________________________________________________

;____________________
; Variables
$Button1_Name=("Netflix")
$Button1_Path=('"C:\Program Files\Internet Explorer\iexplore.exe" windowsmediacenterapp:{e6f46126-f8a9-4a97-9159-b70b07890112}\{982ea9d3-915c-4713-a3c8-99a4688b7c59}?EntryPointParameters=')
	
$Button2_Name=("Hulu")
$Button2_Path=("C:\Users\" & @UserName &"\AppData\Local\HuluDesktop\HuluDesktop.exe")
	
$Button3_Name=("Plex")
$Button3_Path=('"C:\MediaCenter\Plex.start.exe"')
	
$Button4_Name=("XBMC")
$Button4_Path=('"C:\MediaCenter\XBMC.start.exe"')

$Button5_Name=("Boxee")
$Button5_Path=('"C:\MediaCenter\Boxee.start.exe"')

$Button6_Name=("KillEmAll")
$Button6_Path=('"C:\MediaCenter\KillEmAll.exe"')

$Button7_Name=("")
$Button7_Path=("")

$Button8_Name=("")
$Button8_Path=("")

$Button9_Name=("")
$Button9_Path=("")

$Gui_Title="MyLauncher"
$Button_Width=275
$Button_Height=70
$Font_Size=("46")
$Font_Weight=("900")
; /Variables

;____________________
; Dependents
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiButton.au3>
#include <Misc.au3>				;Needed by _Singleton
; /Dependents

;____________________
; Main
_Singleton(@ScriptName)			;Keeps more than one instance of script from running
Buttons()
Exit
; /Main

;____________________
; Functions called in Main
;____________________
Func Buttons()

	$X_Coord = 0
	$Y_Coord = 0
	
	Dim $Number_Of_Buttons
	If $Button1_Name <> "" Then $Number_Of_Buttons=$Number_Of_Buttons+1
	If $Button2_Name <> "" Then $Number_Of_Buttons=$Number_Of_Buttons+1
	If $Button3_Name <> "" Then $Number_Of_Buttons=$Number_Of_Buttons+1
	If $Button4_Name <> "" Then $Number_Of_Buttons=$Number_Of_Buttons+1
	If $Button5_Name <> "" Then $Number_Of_Buttons=$Number_Of_Buttons+1
	If $Button6_Name <> "" Then $Number_Of_Buttons=$Number_Of_Buttons+1
	If $Button7_Name <> "" Then $Number_Of_Buttons=$Number_Of_Buttons+1
	If $Button8_Name <> "" Then $Number_Of_Buttons=$Number_Of_Buttons+1
	If $Button9_Name <> "" Then $Number_Of_Buttons=$Number_Of_Buttons+1	
		
	$GuiX=$Button_Width+(0)
	$GuiY=$Button_Height*($Number_Of_Buttons)

	$GUI = GUICreate($Gui_Title, $GuiX, $GuiY, -1,-1,$WS_POPUP,-1)
	GUISetFont ($Font_Size , $Font_Weight)
		
		$Button1 = GUICtrlCreateButton($Button1_Name, $X_Coord, $Y_Coord, $Button_Width, $Button_Height, $BS_ICON,-1)
		$Y_Coord = $Y_Coord+$Button_Height
		$Button2 = GUICtrlCreateButton($Button2_Name, $X_Coord, $Y_Coord, $Button_Width, $Button_Height, $BS_ICON,-1)
		$Y_Coord = $Y_Coord+$Button_Height
		$Button3 = GUICtrlCreateButton($Button3_Name, $X_Coord, $Y_Coord, $Button_Width, $Button_Height, $BS_ICON,-1)
		$Y_Coord = $Y_Coord+$Button_Height
		$Button4 = GUICtrlCreateButton($Button4_Name, $X_Coord, $Y_Coord, $Button_Width, $Button_Height, $BS_ICON,-1)
		$Y_Coord = $Y_Coord+$Button_Height
		$Button5 = GUICtrlCreateButton($Button5_Name, $X_Coord, $Y_Coord, $Button_Width, $Button_Height, $BS_ICON,-1)
		$Y_Coord = $Y_Coord+$Button_Height
		$Button6 = GUICtrlCreateButton($Button6_Name, $X_Coord, $Y_Coord, $Button_Width, $Button_Height, $BS_ICON,-1)
		$Y_Coord = $Y_Coord+$Button_Height
		$Button7 = GUICtrlCreateButton($Button7_Name, $X_Coord, $Y_Coord, $Button_Width, $Button_Height, $BS_ICON,-1)
		$Y_Coord = $Y_Coord+$Button_Height
		$Button8 = GUICtrlCreateButton($Button8_Name, $X_Coord, $Y_Coord, $Button_Width, $Button_Height, $BS_ICON,-1)
		$Y_Coord = $Y_Coord+$Button_Height
		$Button9 = GUICtrlCreateButton($Button9_Name, $X_Coord, $Y_Coord, $Button_Width, $Button_Height, $BS_ICON,-1)
		$Y_Coord = $Y_Coord+$Button_Height

;	Wait for Button Press
	GUISetState()
	;$Button_Focus=_GUICtrlButton_GetFocus($Button1)
	$N=0
	While $N<60		; Times out after :60 Secs
		$Msg = GUIGetMsg()
		If $Msg = $GUI_EVENT_CLOSE Then Exit
			If $Msg = $Button1 Then
				Run ($Button1_Path)
				Exit
			EndIf
			If $Msg = $Button2 Then
				Run ($Button2_Path)
				Exit
			EndIf
			If $Msg = $Button3 Then
				Run ($Button3_Path)
				Exit
			EndIf
			If $Msg = $Button4 Then
				Run ($Button4_Path)
				Exit
			EndIf
			If $Msg = $Button5 Then
				Run ($Button5_Path)
				Exit
			EndIf
			If $Msg = $Button6 Then
				Run ($Button6_Path)
				Exit
			EndIf
			If $Msg = $Button7 Then
				Run ($Button7_Path)
				Exit
			EndIf
			If $Msg = $Button8 Then
				Run ($Button8_Path)
				Exit
			EndIf
			If $Msg = $Button9 Then
				Run ($Button9_Path)
				Exit
			EndIf
				;If $N=0 Then
					;If ProcessExists ("Boxee.exe") Then WinActivate ("Boxee")
					;If ProcessExists ("XBMC.exe") Then WinActivate ("XBMC")			
					;If ProcessExists ("Plex.exe") Then WinActivate ("Plex")			
					;If ProcessExists ($Gui_Title & ".exe") Then WinActivate ($Gui_Title)		
					;If ProcessExists ("HuluDesktop.exe") Then WinActivate ("Hulu Desktop")
				;EndIf	
		Sleep (1000)
		$N=$N+1
	WEnd
EndFunc


