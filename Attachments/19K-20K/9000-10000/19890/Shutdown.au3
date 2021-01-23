#cs
Autoit Version :	v3.2.10.0
Author :			Christophe Savard (France)
Script Function :	Automatic shutdown programm with the possibility for the user to abort the process or confirm (accelerate) the shutdown.
Requirements :		IE5 or later.
#ce

#include <GUIConstants.au3>
Opt("GUICoordMode",0)
Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)

#region Variable declaration
	$Mode = ""
	$Language = "" ; <<<<==== Put here a laguage code (2 Digits e.g : SP for Spain) to force the language and avoid getting default Windows language
	$Delay = 20 ; delay before shutdown in seconds
	$NewDelay = $Delay
	$ShutMode = 1+4+8 ; Shutdown + Force + Powerdown ==> Play with this to choose your own options (see shutdown command help in Autoit help file)
	$Pid = 4 ; Process Id of the process "System" (should be always 4 but verify and change if necessary)
	$GuiWidth = 300
	$GuiHeight = 130
	$GuiTitle = "Shutdown Scheduler"
	$PrgValue = 100
	If Not $Language Then $Language = StringLeft(RegRead("HKEY_CURRENT_USER\Control Panel\International","sLanguage"),2); Default language is the windows default language
#endregion Variable declaration

#region Gui
	$GUI = GUICreate($GuiTitle,$GuiWidth,$GuiHeight)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Abort")
	If $Language = "EN" Then
		$LabelText = "System shut down process is launched..."
	ElseIf $Language = "FR" Then
		$LabelText = "Procédure d'arrêt du système lancée..."
	Else ; Default language if the current language system is not yet supported by the script
		$LabelText = "System shut down process is launched..."
	EndIf
	GUICtrlCreateLabel($LabelText,20,15,StringLen($LabelText)*10,20)
	$Progress = GUICtrlCreateProgress(-1,20,$GuiWidth-40,20,$PBS_SMOOTH )
	GUICtrlSetData($Progress,$PrgValue) ; Sets the progress bar to 100%
	If $Language = "EN" Then
		$RemainLblText = "Remaining time (in seconds) before shut dwon : "
	ElseIf $Language = "FR" Then
		$RemainLblText = "Temps restant (en secondes) avant l'arrêt : "
	Else ; Default language if the current language system is not yet supported by the script
		$RemainLblText = "Remaining time (in seconds) before shut dwon : "
	EndIf	

	$RemainLbl = GUICtrlCreateLabel($RemainLblText & "20",-1,25,StringLen($RemainLblText)*10)
	If $Language = "EN" Then
		$AbortButLen=Stringlen("Abort")*8
		$Abort = GUICtrlCreateButton("Abort",-1,$GuiHeight-100,$AbortButLen,30)
		GUICtrlSetTip ( $Abort, "Click [Abort] to stop the shut down process.", GUICtrlRead($Abort,1),1,1)
	ElseIf $Language = "FR" Then
		$AbortButLen=Stringlen("Interrompre")*8
		$Abort = GUICtrlCreateButton("Interrompre",-1,$GuiHeight-100,$AbortButLen,30)
		GUICtrlSetTip ( $Abort, "Cliquer sur [Interrompre] pour annuler la procédure d'arrêt.", GUICtrlRead($Abort,1),1,1)
	Else ; Default language if the current language system is not yet supported by the script
		$AbortButLen=Stringlen("Abort")*8
		$Abort = GUICtrlCreateButton("Abort",-1,$GuiHeight-100,$AbortButLen,30)
		GUICtrlSetTip ( $Abort, "Click [Abort] to stop the shut down process.", GUICtrlRead($Abort,1),1,1)
	EndIf
	GUICtrlSetOnEvent($Abort,"_Abort")

	If $Language = "EN" Then
		$ConfirmButLen = Stringlen("Shorten")*8
		$Confirm = GUICtrlCreateButton("Shorten",$AbortButLen +15,-1,$ConfirmButLen,30)
		GUICtrlSetTip ( $Confirm, "Click [Shorten] to launch an immediate shut down.", GUICtrlRead($Confirm,1),1,1)
	ElseIf $Language = "FR" Then
		$ConfirmButLen = Stringlen("Abréger")*8
		$Confirm = GUICtrlCreateButton("Abréger",$AbortButLen +15,-1,$ConfirmButLen,30)
		GUICtrlSetTip ( $Confirm, "Cliquer sur [Abréger] pour lancer immédiatement la procédure d'arrêt.", GUICtrlRead($Confirm,1),1,1)
	Else ; Default language if the current language system is not yet supported by the script
		$ConfirmButLen = Stringlen("Shorten")*8
		$Confirm = GUICtrlCreateButton("Shorten",$AbortButLen +15,-1,$ConfirmButLen,30)
		GUICtrlSetTip ( $Confirm, "Click [Shorten] to launch an immediate shut down.", GUICtrlRead($Confirm,1),1,1)
	EndIf
	GUICtrlSetOnEvent($Confirm,"_Shutdown")
	GUISetState(@SW_SHOW)
#endregion Gui

#region functions
	Func _Abort ()
		If $Language = "EN" Then
			GUICtrlSetData($RemainLbl,"Shut down process has been canceled by user !")
			MsgBox(262144+16,$GuiTitle,"Shut down process has been canceled by yourself !",2) ; After 2 seconds msgbox is deleted and script stops
		ElseIf $Language = "FR" Then
			GUICtrlSetData($RemainLbl,"Procédure d'arrêt Interrompue par l'utilisateur !")
			MsgBox(262144+16,$GuiTitle,"Vous venez d'interrompre la procédure d'arrêt !",2) ; After 2 seconds msgbox is deleted and script stops
		Else ; Default language if the current language system is not yet supported by the script
			GUICtrlSetData($RemainLbl,"Shut down process has been canceled by user !")
			MsgBox(262144+16,$GuiTitle,"Shut down process has been canceled by yourself !",2) ; After 2 seconds msgbox is deleted and script stops
		EndIf
		_Quit () ; Exit script
	EndFunc

	Func _Shutdown ($Mode = "")
		$PrgValue=0
		GUICtrlSetData($Progress,$PrgValue)
		GUICtrlSetState($Abort,$GUI_DISABLE) ; Disable buttons as shutdown is started...
		GUICtrlSetState($Confirm,$GUI_DISABLE)
		If $Language = "EN" Then
			GUICtrlSetData($RemainLbl,"Please wait while system's shutting down...")
		ElseIf $Language = "FR" Then
			GUICtrlSetData($RemainLbl,"Veuillez patienter en attendant l'arrêt du système...")
		Else ; Default language if the current language system is not yet supported by the script
			GUICtrlSetData($RemainLbl,"Please wait while system's shutting down...")
		EndIf
		If $Mode = "" Then ; Message only displayed when manually confirmed
			If $Language = "EN" Then
				MsgBox(262144+16,$GuiTitle,"You requested an immediate shut down !",2) ; After 2 seconds msgbox is deleted and shutdown process is started
			ElseIf $Language = "FR" Then
				MsgBox(262144+16,$GuiTitle,"Vous venez de demander un arrêt immédiat !",2) ; After 2 seconds msgbox is deleted and shutdown process is started
			Else ; Default language if the current language system is not yet supported by the script
				MsgBox(262144+16,$GuiTitle,"You requested an immediate shut down !",2) ; After 2 seconds msgbox is deleted and shutdown process is started
			EndIf
		EndIf
		
		Shutdown($ShutMode)
		
		while 1 ; waiting loop
			If ProcessExists($Pid) Then ; Waits for Process "System" to close
				If $PrgValue = 100 then $PrgValue = 0
				$PrgValue=$PrgValue+10
				GUICtrlSetData($Progress,$PrgValue)
			Else ; Process does not exists.. It's time to exit...
				_Quit ()
			EndIf
			Sleep (1000)
		WEnd
	EndFunc

	Func _Quit ()
		Exit
	EndFunc
#endregion functions

While 1
	If GUICtrlRead ($Progress) = 0 Then _Shutdown ("AUTO") ; Delay is over... it's time to shutdown
	Sleep (800)
	$NewDelay = $NewDelay-1 ; Calculates the new value for the remaining time before shutdown
	$PrgValue = ($NewDelay / $Delay) *100
	GUICtrlSetData($Progress,$PrgValue) ; Sets the progress bar to the new value
	GUICtrlSetData($RemainLbl,$RemainLblText & $NewDelay) ; Updates the remaining time in label
WEnd