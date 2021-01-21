; AutoIt Version: 3.1.1.5 Beta
; Author:  Micha
; Date: 14.03.2005
; Script Function: Alarmtimer & sheduler start applikation or shutdown
; when the gui lost focus it minimize to tray
; ----------------------------------------------------------------------------

; Set Variablen
#include <GUIConstants.au3>
#include <constants.au3>
Opt ("TrayAutoPause", 0)
Opt ("TrayMenuMode", 1)
Opt("GUICloseOnESC", 0)
opt("TrayAutoPause",0)
$WinTitel="MiniAlarm"
$aFlag=0 ;Alarm Timer Flag 0=not activ 
$font="Comic Sans MS"

; -----------------------------------------------------------------------------
; Build GUI 
$guiApp=GUICreate($winTitel, 200, 150)
GUISetFont (14, 400, 0, $font) 
$currTime=GUICtrlCreateLabel(@Hour & ":" & @Min & ":" &@SEC , 30, 10)
$font="Arial"
GUISetFont (8, 400, 0, $font) 
$alarmbutton = GUICtrlCreateButton("Set Alarm Time", 10, 120, 110,20)
$aCombo=GUICtrlCreateCombo ("Alarm", 10,50,110) ; create first item
$alabel1=GUICtrlCreateLabel ("Choose Action", 10,35,120) ;

GUICtrlSetData($aCombo,"Start App|Shutdown PC","Alarm") ; add other item snd set a new default
$Apps = GUICtrlCreateLabel ( "Start @", 10,  90, 145, 100)

GUISetState()
$appState = @SW_SHOW
;GUICtrlSetState($Apps,$GUI_disable) 
;While 1
Do
  $msg = GUIGetMsg()
  $trayMsg    = TrayGetMsg()
		if Not WinActive($winTitel) And $appState = @SW_SHOW Then ;lost focus minimize window
        _ToggleAppState()
		EndIf
   Select
        case $trayMsg = $TRAY_EVENT_PRIMARYDOWN
            _ToggleAppState()
			

		Case $msg = $alarmbutton
      ;MsgBox(0, "GUI Event", "Set Alarm!")
			$varT=InputBox("Set Time", "Set Time 'hh:mm':","00:00")
			if @error then
			MsgBox(64,"Error","Input canceled")
			$aFlag=0
			
			GUICtrlSetState($aCombo,$GUI_Enable) 
			Else
		
			;Check for valid input
				If StringLen($varT)<5 or StringMid($varT, 3, 1)<> ":"then 
					MsgBox(64,"Miniarlam","Incorrect format : 01:05")
			
				$aFlag=0
				Else
				$aFlag=1 ;set timer flag activ
				GUICtrlSetData($alarmbutton, "Alarm at " & $varT)
				GUICtrlSetState($alarmbutton,$GUI_DISABLE) 
				GUICtrlSetState($aCombo,$GUI_DISABLE) 
				EndIf
			EndIf
		;check action to do, read value of combobox
			$ComboValue=GUICtrlRead($aCombo,0)
				Select
					Case $ComboValue="Alarm"
					;do Nothing
					$aFlag=1
					Case $ComboValue="Start App"
					GUISetState($Apps,$GUI_enable)
					$a_apps=FileOpenDialog("Choose Applikation to start at alarmtime",@ProgramFilesDir, "Apps (*.exe;*.cmd)", 1 + 4)
							If @error Then
								MsgBox(4096,"","No App chosen")
								
								$aFlag=0
								$fvar = EnableButtons()
							Else
								
								;MsgBox(4096,"","You chose " & $a_apps)
							GUICtrlSetData($apps,$a_apps)
							GUICtrlSetData($alarmbutton,"Start @ " &$varT)
						
							EndIf
					;MsgBox(0, "GUI Event", $a_apps)
					$aFlag=2
					;enable Input für Applikation
					case $ComboValue="Shutdown PC"
					$aFlag=3
				EndSelect	

	EndSelect

	
		SLEEP(60)
		GuiCtrlSetData($currTime,  @Hour & ":" & @Min & ":" & @Sec)
		if $Aflag >=1 Then
			if @Hour & ":" & @Min = $varT then  
			;Set Action here
			Select
				case $aflag=1
					If FileExists(@ScriptDir & "\alarm.wav") Then
					SoundPlay(@ScriptDir & "\alarm.wav",0)
					Else
					;beep 
					;Send ( "BEL" [, 1] )
					MsgBox(64,$winTitel,"alarm.wav missing in programdir",3)
					EndIf
				$aFlag= 0; Set Timer Flag back to 0
				$fvar = EnableButtons()
				Case $aflag=2
				;Start apps
				Run ( $a_apps )
				;MsgBox(0, "GUI Event", "Start Apps")
				$aflag=0
				$fvar = EnableButtons()
				Case $aflag=3
				;shutdown
				$start=RunWait(@ComSpec & " /c " & 'shutdown -s -t 00', "", @SW_HIDE)
				$aflag=0
				$fvar = EnableButtons()
			EndSelect
		
		
		
		EndIf
	EndIf
until $msg = $GUI_EVENT_CLOSE

;---------------------------------------------------------------
; Userdefined Functions
Func EnableButtons()
			GUICtrlSetState($alarmbutton,$GUI_Enable) 
			GUICtrlSetData($alarmbutton, "Set Alarm Time")
			GUICtrlSetState($aCombo,$GUI_Enable)
			GUICtrlSetData($apps,"Start @")
EndFunc
		
		; User defined function minimize and restore the gui
Func _ToggleAppState()
    if $appState = @SW_HIDE then
        $appState = @SW_SHOW
        GUISetState(@SW_SHOW, $guiApp)
    Else
        $appState = @SW_HIDE
        GUISetState(@SW_HIDE, $guiApp)
    EndIf
EndFunc