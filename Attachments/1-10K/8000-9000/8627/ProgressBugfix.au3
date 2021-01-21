
#include <Guiconstants.au3>
$Show_dialogs=1
;Generate progress dialog
;Dialog 2
	
;English
$DialogTitle="My Patch Installer"
$Msg_text="Checking for new updates for this computer."
$Tag_text="You do not need to wait while this process runs and may minimize this window if desired."

	$Progress_Handle=GuiCreate($DialogTitle, 400, 150,(@DesktopWidth-400)/2, (@DesktopHeight-150)/2 , $WS_EX_WINDOWEDGE + $WS_MINIMIZEBOX + $WS_SYSMENU + $WS_CAPTION)
	$Progress_1 = GuiCtrlCreateProgress(60, 60, 270, 20)
	$Label_2 = GuiCtrlCreateLabel($Msg_text, 40, 20, 270, 60)
	$Label_4 = GuiCtrlCreateLabel("", 320, 20, 60, 60)
	$Label_3 = GuiCtrlCreateLabel($Tag_text, 40, 100, 330, 60)
	GuiSetState()
	ProgressUpdate($Label_2,$Msg_text,$Label_4,"",$Progress_1,0)
	
	
	
	Sleep(2000)
	


Func ProgressUpdate($Label_1,$Data_1,$Label_2,$Data_2,$Progress_3,$Data_3)
	If $Show_dialogs=1 Then
		GUICtrlSetData($Label_1,$Data_1)	;Update the message on the progress screen
		GUICtrlSetData($Label_2,$Data_2)	;Update the message on the progress screen
		GUICtrlSetData($Progress_3,$Data_3)	;Update the progress.
	EndIf
EndFunc

