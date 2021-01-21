#include <GUIConstants.au3>
#include <Array.au3>
;#include <GuiCombo.au3>
opt("GUIOnEventMode", 1)
opt("TrayMenuMode", 1)
Global Const $RegHome = "HKCU\Software\Internet Radio\"
Global $popAdd
Global $hwndActive
Global Const $CB_RESETCONTENT = 0x14B
$oMyError = ObjEvent("AutoIt.Error", "Quit")
$oMediaplayer = ObjCreate("WMPlayer.OCX.7")
If Not IsObj($oMediaplayer) Then Exit
$oMediaplayer.Enabled = True
$oMediaplayer.WindowlessVideo = True
$oMediaPlayer.UImode = "invisible"
$oMediaPlayControl = $oMediaPlayer.Controls
$oMediaPlaySettings = $oMediaPlayer.Settings
;Load skin
Dim $s_TempFile
$bmp = _TempFile()
;FileInstall("..\Images\gui_2.bmp", $bmp) ;images directory
FileInstall("gui_2.bmp", $bmp)
$bmp2 = $bmp
$caption = "Online Radio Jukebox"
$gui = GUICreate("Online Radio Jukebox", 230, 150, -1, -1, $WS_POPUP + $WS_SYSMENU + $WS_MINIMIZEBOX, $WS_EX_LAYERED)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
$caption = GUICtrlCreateLabel($caption, 12, 4, 180, 14)
GUICtrlSetStyle($caption, -1, $WS_EX_TRANSPARENT)
GUICtrlSetStyle($caption, $DS_SETFOREGROUND)
GUICtrlSetFont($caption, 9, 400, -1, "Arial Bold")
GUICtrlSetColor($caption, 0xffd700)
GUICtrlSetOnEvent($caption, "_Drag")
$min = GUICtrlCreateLabel("", 198, 4, 11, 11)
GUICtrlSetOnEvent($min, "Minimize")
GUICtrlSetTip($min, "Minimize")
$close = GUICtrlCreateLabel("", 210, 4, 11, 11)
GUICtrlSetOnEvent($close, "Close")
GUICtrlSetTip($close, "Close")
$combo_name = GUICtrlCreateCombo("Choose your RadioStation", 13, 30, 153, 20)
GUICtrlSetOnEvent(-1, "ComboEvent")
GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
;original line
;GuiCtrlSetData($combo_name, "Real Rock 101.1|Studio Brussel|Donna|Q-Music|4Fm|Contact|C-Dance|TopRadio|SkyRadio|Tmf|Noordzee|Veronica|BNN-Fm|Be-One|Oradio|Colorado")
;read from ini line.
GUICtrlSetData($combo_name, ReadStation())
$Volume = GUICtrlCreateSlider(13, 77, 152, 20)
GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
$VolLevel = $oMediaPlaySettings.Volume
GUICtrlSetData(-1, $VolLevel)
GUICtrlSetOnEvent(-1, "SliderEvent")
GUICtrlCreateLabel("Volume", 73, 62, 40, 20)
GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
GUICtrlSetColor(-1, 0xff)
$Play = GUICtrlCreateButton("Play", 175, 30, 45, 22)
GUICtrlSetStyle($Play, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Play, "Play")
$Stop = GUICtrlCreateButton("Stop", 175, 55, 45, 22)
GUICtrlSetStyle($Stop, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Stop, "Stop")
$Load = GUICtrlCreateButton("Load", 175, 80, 45, 22)
GUICtrlSetStyle($Load, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Load, "Load")
$Add = GUICtrlCreateButton("Add", 50, 105, 45, 22)
GUICtrlSetStyle($Add, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Add, "Add")
$Delete = GUICtrlCreateButton("Delete", 105, 105, 45, 22)
GUICtrlSetStyle($Delete, -1, $WS_EX_TRANSPARENT)
GUICtrlSetOnEvent($Delete, "Delete")
$pic = GUICtrlCreatePic($bmp, 0, 0, 230, 150)
GUICtrlSetOnEvent($pic, "_Drag")
$contextmenu = GUICtrlCreateContextMenu($pic)
$min_item = GUICtrlCreateMenuItem("Min", $contextmenu)
GUICtrlSetOnEvent($min_item, "Minimize")
$close_item = GUICtrlCreateMenuItem("Close", $contextmenu)
GUICtrlSetOnEvent($close_item, "Close")
GUICtrlCreateMenuItem("", $contextmenu)
$about_item = GUICtrlCreateMenuItem("About", $contextmenu)
GUICtrlSetOnEvent($about_item, "About")
$add_item = GUICtrlCreateMenuItem("Add", $contextmenu)
GUICtrlSetOnEvent($add_item, "Add")
$del_item = GUICtrlCreateMenuItem("Delete", $contextmenu)
GUICtrlSetOnEvent($add_item, "Delete")
;set variable for drag func.
$hwndActive = $gui
GUISetState(@SW_SHOW)
While 1
	Sleep(1000)
WEnd
; user function here.
Func About()
	GUISetState(@SW_HIDE)
	SplashTextOn("About", "Online Radio Jukebox" & @CRLF & "Made with Autoit" & @CRLF & "Listen to Online Radio" & @CRLF & "Play your mp3/wma" & @CRLF & "Boenders Jos" & @CRLF & "Enhancements by Stephen Podhajecki", 190, 160, -1, -1, 1, "", 12)
	Sleep(10000)
	SplashOff()
	GUISetState(@SW_SHOW)
EndFunc   ;==>About
Func Close()
	GUISetState(@SW_HIDE)
	FileDelete($bmp)
	Exit
EndFunc   ;==>Close
Func Minimize()
	GUISetState(@SW_MINIMIZE)
EndFunc   ;==>Minimize
Func _TempFile()
	Local $s_TempName
	Do
		$s_TempName = "~"
		While StringLen($s_TempName) < 7
			$s_TempName = $s_TempName & Chr(Round(Random(65, 90), 0))
		WEnd
		$s_TempName = @TempDir & "\" & $s_TempName & ".tmp"
	Until Not FileExists($s_TempName)
	Return ($s_TempName)
EndFunc   ;==>_TempFile
Func _Drag()
	DllCall("user32.dll", "int", "ReleaseCapture")
	;modified to use global variable to handle more than 1 window. Replaced $gui with global $hwndActive
	DllCall("user32.dll", "int", "SendMessage", "hWnd", $hwndActive, "int", 0xA1, "int", 2, "int", 0)
EndFunc   ;==>_Drag
Func Play()
	$oMediaPlayControl.Play
EndFunc   ;==>Play
Func Stop()
	$oMediaPlayControl.Stop
EndFunc   ;==>Stop
Func Load()
	$media = FileOpenDialog("Offline Radio Jukebox", " {20D04FE0-3AEA-1069-A2D8-08002B30309D} ", "Media (*.wma;*.mp3)", 1)
	$oMediaPlayer.URL = $media
EndFunc   ;==>Load
;Func for adding a url to ini file
Func Add()
	GUISetState(@SW_DISABLE, $gui)
	Popup_Edit("ADD")
	ResetMain()
EndFunc   ;==>Add
;func for deleteing an entry in the ini file.
Func Delete()
	GUISetState(@SW_DISABLE, $gui)
	Popup_Edit("DEL")
	ResetMain()
EndFunc   ;==>Delete
;Function for exiting the app
Func ExitEvent()
	Exit
EndFunc   ;==>ExitEvent
;Close last GUI window
Func OnClose()
	GUIDelete()
EndFunc   ;==>OnClose
;event function modified to use ini file
Func ComboEvent()
	$Radio = GUICtrlRead($combo_name)
	;this line reads the ini file.
	;$oMediaPlayer.URL = IniRead(@ScriptDir & "\orj.ini", $Radio, "URL", "")
	$oMediaPlayer.URL = RegRead($RegHome & "\Streams", GUICtrlRead($combo_name))
EndFunc   ;==>ComboEvent
Func SliderEvent()
	If GUICtrlRead($Volume) <> $VolLevel Then
		$oMediaPlaySettings.Volume = GUICtrlRead($Volume)
		$VolLevel = GUICtrlRead($Volume)
	EndIf
EndFunc   ;==>SliderEvent
; read the ini file and add to combo box.
Func ReadStation ()
	#cs
	If FileExists(@ScriptDir & "\orj.ini") Then
		$aCombo_List = IniReadSectionNames(@ScriptDir & "\orj.ini")
		;build string for combobox, start at [1] because [0] contains count.
		$sCombo_Stations = _ArrayToString($aCombo_List, "|", 1, "")
		Return $sCombo_Stations
	Else
		MsgBox(4096, "Error", "Could not locate config file.", 0)
		Exit
	EndIf
	#ce
	Local $aCombo_List[1], $instance = 1
	While 1
		Local $regreturn = RegEnumVal($RegHome & "\Streams", $instance)
		If @error <> 0 Then ExitLoop
		ReDim $aCombo_List[(Ubound($aCombo_List) + 1)]
		$aCombo_List[0] = UBound($aCombo_List) - 1
		$aCombo_List[(UBound($aCombo_List) - 1)] = $regreturn
	WEnd
	Return _ArrayToString($aCombo_List, "|", 1, '')
EndFunc   ;==>ReadStation
;write station to inifile.
Func WriteStation($sRadio, $sURL)
	RegWrite($RegHome & "\Streams", $sRadio, "REG_SZ", $sURL)
	;IniWrite(@ScriptDir & "\orj.ini", $sRadio, "URL", $sURL)
EndFunc   ;==>WriteStation
;change gui back and reload combo box
Func ResetMain()
	GUISetState(@SW_ENABLE, $gui)
	opt("GUIOnEventMode", 1)
	GUISetState(@SW_SHOW)
	$hwndActive = $gui
	GUICtrlSendMsg($combo_name, $CB_RESETCONTENT, 0, 0)
	ControlSetText("Online Radio Jukebox", "", $combo_name, "Choose your RadioStation")
	GUICtrlSetData($combo_name, ReadStation())
EndFunc   ;==>ResetMain
opt("OnExitFunc", "End")
HotKeySet("{MEDIA_STOP}", "Stop")
HotKeySet("{MEDIA_PLAY_PAUSE}", "Play")
HotKeySet("{F9}", "End")
AdlibEnable("ReduceMemory", 5000)
Func ReduceMemory($i_PID = -1)
	Local $ai_R = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	Return $ai_R[0]
EndFunc   ;==>_ReduceMemory
Func End()
	AdlibDisable()
	Exit
EndFunc   ;==>End
; this function handles add and delete based on the value passed to it.
Func Popup_Edit($orjcmd)  ;; valid commands are "ADD" and "DEL"
	;change to message mode so gui can be closed.  I couldn't get this qui to work in event mode.
	opt("GUIOnEventMode", 0)
	$popAdd = GUICreate("Online Radio Jukebox", 300, 150, (@DesktopWidth - 300) / 2, (@DesktopHeight - 150) / 2, $WS_POPUP + $WS_SYSMENU + $WS_MINIMIZEBOX, $WS_EX_LAYERED)
	$caption2 = GUICtrlCreateLabel("Online Radio Jukebox", 12, 4, 180, 14)
	GUICtrlSetStyle($caption2, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetStyle($caption2, $DS_SETFOREGROUND)
	GUICtrlSetFont($caption2, 9, 400, -1, "Arial Bold")
	GUICtrlSetColor($caption2, 0xffd700)
	$close2 = GUICtrlCreateLabel("", 281, 4, 11, 11)
	GUICtrlSetTip($close2, "Close")
	; setup buttons based on the command.
	If $orjcmd = "ADD" Then
		$lAddURL = GUICtrlCreateLabel("Add Url", 115, 25, 40, 20)
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetColor(-1, 0xff)
		$lName = GUICtrlCreateLabel("Name", 10, 40, 40, 20)
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetColor(-1, 0xff)
		$iStation_Name = GUICtrlCreateInput("", 50, 40, 230, 20)
		GUICtrlSetTip($iStation_Name, "Enter the station name.")
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		$lURL = GUICtrlCreateLabel("URL", 10, 70, 30, 20)
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetColor(-1, 0xff)
		$iStation_URL = GUICtrlCreateInput("", 50, 70, 230, 20)
		GUICtrlSetTip($iStation_URL, "Enter the full URL.")
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		$btnOK = GUICtrlCreateButton("OK", 50, 110, 90, 30)
		GUICtrlSetStyle($btnOK, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetState($btnOK, $GUI_DISABLE)
	Else
		$lDelete = GUICtrlCreateLabel("Delete Url", 110, 25, 80, 20)
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetColor(-1, 0xff)
		$lName = GUICtrlCreateLabel("Name", 10, 40, 40, 20)
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetColor(-1, 0xff)
		$combo_Station = GUICtrlCreateCombo("Choose Station To Remove", 50, 40, 230, 20)
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetData($combo_Station, ReadStation())
		$lURL = GUICtrlCreateLabel("URL", 10, 70, 30, 20)
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetColor(-1, 0xff)
		$lStation_URL = GUICtrlCreateLabel("", 50, 70, 230, 25, $SS_SUNKEN)
		GUICtrlSetStyle(-1, -1, $WS_EX_TRANSPARENT)
		$btnDel = GUICtrlCreateButton("Delete", 50, 110, 90, 30)
		GUICtrlSetStyle($btnDel, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetState($btnDel, $GUI_DISABLE)
	EndIf
	$btnCANCEL = GUICtrlCreateButton("Cancel/Exit", 160, 110, 90, 30)
	GUICtrlSetStyle($btnCANCEL, -1, $WS_EX_TRANSPARENT)
	$pic2 = GUICtrlCreatePic($bmp2, 0, 0, 300, 150)
	$hwndActive = $popAdd
	GUISetState()
	While 1
		$msg2 = GUIGetMsg()
		Select
			; both commands common gui buttons and events
			Case $msg2 = $btnCANCEL Or $msg2 = $GUI_EVENT_CLOSE Or $msg2 = $close2
				ExitLoop
			Case $msg2 = $caption2 Or $msg2 = $pic2
				_Drag()
			Case Else
				;Buttons ADD and Delete are only created when respective command is called.
				;So we need to test for command in order to prevent error;
				If $orjcmd = "ADD"Then
					;keep Ok button disabled until both boxes have data.
					If GUICtrlRead($iStation_Name) <> "" And GUICtrlRead($iStation_URL) <> "" Then
						If GUICtrlGetState($btnOK) <> $GUI_ENABLE + $GUI_SHOW Then GUICtrlSetState($btnOK, $GUI_ENABLE)
					Else
						;If either box is empty then keep ok disabled
						If GUICtrlGetState($btnOK) <> $GUI_DISABLE + $GUI_SHOW Then GUICtrlSetState($btnOK, $GUI_DISABLE)
					EndIf
					;for Add command buttons
					Select
						Case $msg2 = $btnOK
							WriteStation(GUICtrlRead($iStation_Name), GUICtrlRead($iStation_URL))
							GUICtrlSetData($iStation_Name, "")
							GUICtrlSetData($iStation_URL, "")
							GUICtrlSetState($btnOK, $GUI_DISABLE)
					EndSelect
				Else
					If $orjcmd = "DEL" Then
						; Keep delete key of until a station is selected
						If GUICtrlRead($lStation_URL) = "" And GUICtrlGetState($btnDel) <> $GUI_DISABLE + $GUI_SHOW Then
							GUICtrlSetState($btnDel, $GUI_DISABLE)
						ElseIf GUICtrlRead($lStation_URL) <> "" And GUICtrlGetState($btnDel) <> $GUI_ENABLE + $GUI_SHOW Then
							GUICtrlSetState($btnDel, $GUI_ENABLE)
						EndIf
						;for Delete commamd buttons
						Select
							Case $msg2 = $combo_Station
								;GUICtrlSetData($lStation_URL, IniRead(@ScriptDir & "\orj.ini", GUICtrlRead($combo_Station), "URL", ""))
								GUICtrlSetData($lStation_URL, RegRead($RegHome & "\Streams", GUICtrlRead($combo_Station)))
							Case $msg2 = $btnDel
								;IniDelete(@ScriptDir & "\orj.ini", GUICtrlRead($combo_Station))
								RegDelete("HKCU\Software\Internet_Radio\Streams", GUICtrlRead($combo_Station))
								GUICtrlSendMsg($combo_Station, $CB_RESETCONTENT, 0, 0)
								GUICtrlSetData($combo_Station, ReadStation())
								GUICtrlSetData($lStation_URL, "")
						EndSelect
					EndIf
				EndIf
		EndSelect
	WEnd
	;kill the gui and return to main.
	GUIDelete($popAdd)
EndFunc   ;==>Popup_Edit