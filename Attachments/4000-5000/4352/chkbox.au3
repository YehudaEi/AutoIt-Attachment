#include <GUIConstants.au3>
Opt("GUICloseOnESC", 1)         ;1=ESC  closes, 0=ESC won't close
Opt("MustDeclareVars", 1)       ;0=no, 1=require pre-declare
Opt("GUIOnEventMode", 1)       	;No messages please.


Dim $chb	; VAR. TO SAVE HANDLE OF THE CHECKBOX
Dim $chb_state	; VAR. TO SAVE ITS STATE
Dim $label	; VAR. TO SAVE HANDLE OF OUR LABEL



GUICreate( "Temp", 200 , 200 )							; MAKE GUI
$chb = GUICtrlCreateCheckBox( "see my state below" , 20 , 20 , 150 , 20 )	; MAKE CHKBOX
$label = GUICtrlCreateLabel( "off" , 20 , 60 , 150 , 20 )			; OUR LABEL TO PUBLISH THE SATE



GUISetOnEvent( $GUI_EVENT_CLOSE , "Quit" )	; MAKE EXIT OPTION
GUISetState( @SW_SHOW )				; SHOW GUI



While 1		; APP. CYCLE

	$chb_state = GUICtrlRead( $chb )	; WE OBTAIN THE STATE HERE
	
	; Please see this state table (you can find the very same in your help-file).
	; I'm listing check-box-related options only:
	; 
	; $GUI_UNCHECKED 	Radio or Checkbox will be unchecked 
	; $GUI_CHECKED 		Radio or Checkbox will be checked 
	; $GUI_INDETERMINATE 	Checkbox having the tristate attribute will be greyed 

	If $chb_state = $GUI_UNCHECKED Then
		GUICtrlSetData($label,"off")
	ElseIf $chb_state = $GUI_CHECKED Then
		GUICtrlSetData($label,"on")
	Else					; (=$GUI_INDETERMINATE)
		GUICtrlSetData($label,"n/a")
	EndIf

	Sleep( 200 )				; CPU SAVE.

WEnd


Exit



Func Quit( )	; CALLED ON ALT+F4 / ESC.
	Exit
EndFunc
