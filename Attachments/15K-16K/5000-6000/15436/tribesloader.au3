;Program Information------------------------------------------------------
;
;	Starsiege: Tribes Loader
;		Created by Telanis Blackwood
;
;	Program Function:
;		-Preload background programs, by option, for Tribes
;		-Option to load or not EliteRenegades (for HUD moving, etc.)
;
;-------------------------------------------------------------------------
#include <GUIConstants.au3>
Opt("GUICloseOnESC", 1)

#region Create Window-----------------------------------------------------
$mainwin = GUICreate("Tribes", 99, 72, -1, -1, BitOR($WS_SYSMENU,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS,$DS_MODALFRAME,$DS_SETFOREGROUND), BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
$execute = GUICtrlCreateButton("Start Tribes", 1, 54, 97, 17, $BS_FLAT)
$happycheck = GUICtrlCreateCheckbox("Happy Mod", 1, 0, 97, 17, BitOR($BS_CHECKBOX,$BS_AUTOCHECKBOX,$BS_FLAT,$WS_TABSTOP))
GUICtrlSetState(-1, $GUI_CHECKED)
$skycheck = GUICtrlCreateCheckbox("Animated Sky", 1, 18, 97, 17, BitOR($BS_CHECKBOX,$BS_AUTOCHECKBOX,$BS_FLAT,$WS_TABSTOP))
GUICtrlSetState(-1, $GUI_CHECKED)
$eliterencheck = GUICtrlCreateCheckbox("EliteRenegades", 1, 36, 97, 17, BitOR($BS_CHECKBOX,$BS_AUTOCHECKBOX,$BS_FLAT,$WS_TABSTOP))
GUICtrlSetState(-1, $GUI_CHECKED)
GUISetState(@SW_SHOW)
#endregion----------------------------------------------------------------
#region Primary Loop------------------------------------------------------
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $execute
			_Execute(GUICtrlRead($happycheck), GUICtrlRead($skycheck), GUICtrlRead($eliterencheck))
			Exit
	EndSwitch
WEnd
#endregion----------------------------------------------------------------
Func _Execute($happy, $sky, $eliteren)
	MsgBox(0, "debug", "happy: " & $happy & @CRLF & "sky: " & $sky & @CRLF & "eliteren: " & $eliteren) ;debugging msgbox
	If $happy = 1 Then ;checked
		Run("C:\Program Files\Tribes\hm.exe") ;run Happy Mod FOW remover
	EndIf
	If $sky = 1 Then ;checked
		Run("C:\Program Files\Tribes\animated sky.exe") ;run animated sky subroutine
	EndIf
	If $eliteren = 1 Then ;checked
		Run("C:\Program Files\Tribes\TimeHUD.exe -mod EliteRenegades +exec Renegades.cs +exec serverConfig.cs", "C:\Program Files\Tribes") ;run with EliteRen mod
	Else ;unchecked = 4
		Run("C:\Program Files\Tribes\TimeHUD.exe", "C:\Program Files\Tribes") ;just run the Time HUD subroutine
	EndIf
	;When $eliteren is checked, it means to load the Elite Renegades server-side mod for Tribes.exe, the actual game program.
	;TimeHUD.exe passes any and all cmdline parameters on to Tribes.exe, thus why the EliteRen stuff is in the same shortcut.
	;These are direct copies of working shortcuts on the computer, just hoping to be able to run all three with one program, instead of manually.
	;
	;Yes, I'm lazy. Get over it.
EndFunc