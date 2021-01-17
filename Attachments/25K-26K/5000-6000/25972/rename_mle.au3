#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <File.au3>


Opt('MustDeclareVars', 1)

Example()

Func Example()
	Local $Rename_Parter, $Rename_ens_Parter,$Rename_flanger, $Rename_ens_flanger, $Afslut_rename_programmet,$type,$projekt_nr,$rende_nr,$syrefast, $msg, $sidste_nr
	GUICreate("Blücher rename",700, 500) ; will create a dialog box that when displayed is centered

	Opt("GUICoordMode", 2)
	$Rename_Parter = GUICtrlCreateButton("Rename Parter", 10, 100, 165, 30, 0)
	$Rename_ens_Parter = GUICtrlCreateButton("Rename ens Parter", -165, 10, 165, 30, 0)
	$Rename_flanger = GUICtrlCreateButton("Rename flanger",  15, -70, 165, 30, 0)
	$Rename_ens_flanger = GUICtrlCreateButton("Rename ens flanger", -165, 10, 165, 30, 0)
	$Afslut_rename_programmet = GUICtrlCreateButton("Afslut rename programmet", 120, 267, 165, 41, 0)
	GUICtrlCreateLabel("Indtast type:", -630, -450)
	$type= GUICtrlCreateInput("", -165, -15, 165, 20)
	GUICtrlCreateLabel("Indtast projekt_nr:", 15, -40)
	$projekt_nr= GUICtrlCreateInput("", -165,0, 165, 20)
	GUICtrlCreateLabel("Indtast rende_nr:", 15, -40)
	$rende_nr= GUICtrlCreateInput("", -165,0, 165, 20)
	$syrefast = GUICtrlCreateCheckbox("Maker ved syrefast", 28, -20, 161, 15)
	GUICtrlCreateLabel("Indtast ens løbenr:", -350, 60)
	$sidste_nr= GUICtrlCreateInput("", -165,0, 165, 20)
	

	GUISetState()      ; will display an  dialog box with 2 button

	; Run the GUI until the dialog is closed
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $Afslut_rename_programmet
				exit   
				
			Case $msg = $Rename_Parter
					FileOpen("X:\TSA\Special\programmer\rename_mle\rename_mle.txt", 2)
					FileWriteLine("X:\TSA\Special\programmer\rename_mle\rename_mle.txt", $projekt_nr)
					FileClose("X:\TSA\Special\programmer\rename_mle\rename_mle.txt")
					MsgBox(4096, "drag drop file", GUICtrlRead($projekt_nr)) 
			
			Case $msg = $Rename_ens_Parter
				MsgBox(4096, "drag drop file", GUICtrlRead($projekt_nr)) 
			
			
		EndSelect
	WEnd
	
	
EndFunc   ;==>Example


