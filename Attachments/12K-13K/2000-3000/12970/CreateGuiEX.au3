#include-once
#include <GUIConstants.au3>
#Include <Constants.au3>

Global $hHiddenWindow, $hWindow

; ====================================================================================================
; Description ..: Creates a GUI without a taskbar icon
;
; Parameters ...: $Title			- The title of the dialog box.
;                 $Width			- [optional] The width of the window.
;                 $Height			- [optional] The height of the window.
;                 $Left				- [optional] The left side of the dialog box. By default (-1), the window is centered. If defined, top must also be defined.
;                 $Top				- [optional] The top of the dialog box. Default (-1) is centered
;                 $Style			- [optional] defines the style of the window. See GUI Control Styles Appendix.
;												 Use -1 for the default style which includes a combination of $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU styles.
;												 Some styles are always included: $WS_CLIPSIBLINGS, and $WS_SYSMENU if $WS_MAXIMIZEBOX or $WS_SIZEBOX is specified.
;                 $exStyle			- [optional] defines the extended style of the window. See the Extended Style Table below. -1 is the default.
;
; Return values : $hWindow 			- Returns a windows handle.
;
; Author .......: Sibilant
;
; Notes ........: This function creates a child of an invisible window giving the illusion that the 
;                 newly created child window does not have an icon in the taskbar.
; ====================================================================================================
Func GUICreateEX ( $Title = "" , $Width = -1 , $Height = -1 , $Left = -1 , $Top = -1 , $Style = -1 , $exStyle = -1)
	If $hHiddenWindow Then
		$hWindow = GUICreate ( $Title , $Width , $Height , $Left , $Top , $Style , $exStyle , $hHiddenWindow )
	Else
		CreateParent ()
		$hWindow = GUICreate ( $Title , $Width , $Height , $Left , $Top , $Style , $exStyle , $hHiddenWindow )
	EndIf
	
	If @error Then
		Return 0
	Else
		Return $hWindow
	EndIf
EndFunc

; ====================================================================================================
; Description ..: Creates the invisible parent
;
; Parameters ...: None
;
; Return values : None
;
; Author .......: Sibilant
;
; Notes ........: The function creates an invisible parent window giving the illusion that the newly 
;                 created child window does not have an icon in the taskbar.
; ====================================================================================================
Func CreateParent ()
	$hHiddenWindow = GUICreate( "" , 0 , 0 , 0 , 0 , 0 )
	GUISetState( @SW_HIDE , $hHiddenWindow )
EndFunc
