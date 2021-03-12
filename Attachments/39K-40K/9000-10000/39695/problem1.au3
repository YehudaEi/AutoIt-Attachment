#include	<GuiListView.au3>

;
; Get a handle on the desktop, which is actually a listview control.
;
$hWnd_LV = ControlGetHandle( "Program Manager", "", "[CLASS:SysListView32]" )

For $iconIdx = 0 to _GUICtrlListView_GetItemCount( $hWnd_LV ) - 1
	$iconText = _GUICtrlListView_GetItemText( $hWnd_LV, $iconIdx, 0 ) 
	$aPos = _GUICtrlListView_GetItemPosition( $hWnd_LV, $iconIdx )
	
	$iconX = $aPos[ 0 ]
	$iconY = $aPos[ 1 ]
	
	msgbox( 0, "DEBUG", "Working[" & $iconIdx & "] = '" & $iconText & "' @ (" & $iconX & "," & $iconY & ")", 1 )
next
