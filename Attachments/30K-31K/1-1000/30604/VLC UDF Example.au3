#include <GUIConstants.au3>
#include <VLC.au3>
#include <SliderConstants.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiSlider.au3>

Const $ini_filename = @ScriptDir & "\VLC UDF Example.ini"
Dim $msg, $state = 0
Global $position_slider_drag = False, $vlc1, $position_slider, $user_stop = False, $main_gui, $video_path_input

_VLCErrorHandlerRegister()

; Setup Main GUI
$main_gui = GUICreate("VLC UDF Example", 800, 600, -1, -1)
GUICtrlCreateLabel("Video Path", 10, 10, 60, 20)
$video_path_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "videopath", ""), 70, 10, 600, 20)
$video_path_button = GUICtrlCreateButton("Select (Insert)", 700, 10, 80, 20)
$vlc1 = _GUICtrlVLC_Create(0, 50, 800, 450)

if $vlc1 = False then
	
	msgbox(0, "VLC UDF Example",	"_GUICtrlVLC_Create failed." & @CRLF & _
									"The most likely cause is that you don't have VLC installed." & @CRLF & _
									"Make sure VLC, and the ActiveX component, is installed.")
	Exit
EndIf

$position_slider = GUICtrlCreateSlider(0, 500, 800, 30, $TBS_NOTICKS)
$backward_button = GUICtrlCreateButton("Rewind (Arrow Left)", 10, 535, 120, 20)
GUICtrlSetState($backward_button, $GUI_DISABLE)
$pause_button = GUICtrlCreateButton("Pause (Space)", 160, 535, 80, 20)
GUICtrlSetState($pause_button, $GUI_DISABLE)
$stop_button = GUICtrlCreateButton("Stop", 280, 535, 80, 20)
GUICtrlSetState($stop_button, $GUI_DISABLE)
$play_button = GUICtrlCreateButton("Play", 415, 535, 80, 20)
GUICtrlSetState($play_button, $GUI_DISABLE)
$close_button = GUICtrlCreateButton("Close (Esc)", 550, 535, 80, 20)
$forward_button = GUICtrlCreateButton("FForward (Arrow Right)", 670, 535, 120, 20)
GUICtrlSetState($forward_button, $GUI_DISABLE)
GUICtrlCreateLabel("Video Status", 10, 565, 80, 20)
$status_input = GUICtrlCreateInput("", 75, 565, 20, 20)
GUICtrlCreateLabel("Volume (F6 && F7)", 310, 565, 80, 20)
$volume_slider = GUICtrlCreateSlider(390, 560, 250, 30)
GUICtrlSetLimit($volume_slider, 200)
GUICtrlSetData($volume_slider, _GUICtrlVLC_GetVolume($vlc1))
$volume_up = GUICtrlCreateDummy()
$volume_down = GUICtrlCreateDummy()
$mute_button = GUICtrlCreateButton("Mute (F8)", 670, 565, 120, 20)
dim $main_gui_accel[8][2]=[["{ESC}", $close_button], ["{RIGHT}", $forward_button], ["{LEFT}", $backward_button], [" ", $pause_button], ["{INSERT}", $video_path_button], ["{F6}", $volume_down], ["{F7}", $volume_up], ["{F8}", $mute_button]]

; Show Main GUI
GUISetState(@SW_SHOW)
GUISetAccelerators($main_gui_accel)

; Load last video played
if StringLen(GUICtrlRead($video_path_input)) > 0 Then UpdateGUIAndPlay(GUICtrlRead($video_path_input))

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

if StringLen(GUICtrlRead($video_path_input)) > 0 Then $state = _GUICtrlVLC_GetState($vlc1)

if $state = 3 Then GUICtrlSetState($play_button, $GUI_DISABLE)

; Main Loop
while 1

	; Get the video state
	if StringLen(GUICtrlRead($video_path_input)) > 0 Then
		
		$state = _GUICtrlVLC_GetState($vlc1)
		GUICtrlSetData($status_input, $state)
	EndIf
	
	; Loop a finished video
	if $state = 6 and $user_stop = False Then UpdateGUIAndPlay()
	
	; Update the video position slider
	if ($state = 3 or $state = 4) and $position_slider_drag = False Then
		
		GUICtrlSetData($position_slider, (_GUICtrlVLC_GetTime($vlc1) / 1000))
		$position_slider_drag = False
	EndIf

	if $msg = $volume_slider Then
		
		_GUICtrlVLC_SetVolume($vlc1, GUICtrlRead($volume_slider))
	EndIf

	if $msg = $volume_down Then
		
		$new_vol = _GUICtrlVLC_GetVolume($vlc1) - 10
		
		if $new_vol < 0 then $new_vol = 0
		
		_GUICtrlVLC_SetVolume($vlc1, $new_vol)
		GUICtrlSetData($volume_slider, $new_vol)
	EndIf

	if $msg = $volume_up Then
		
		$new_vol = _GUICtrlVLC_GetVolume($vlc1) + 10
		
		if $new_vol > 200 then $new_vol = 200
		
		_GUICtrlVLC_SetVolume($vlc1, $new_vol)
		GUICtrlSetData($volume_slider, $new_vol)
	EndIf

	if $msg = $mute_button Then
		
		if _GUICtrlVLC_GetMute($vlc1) = True Then
			
			_GUICtrlVLC_SetMute($vlc1, False)
		Else
			
			_GUICtrlVLC_SetMute($vlc1, True)
		EndIf
	EndIf

	if $msg = $video_path_button Then
		
		$video_path = FileOpenDialog("VLC UDF Example - Select Video", "C:\", "Videos (*.avi;*.flv;*.mp4)", 3)
		
		if StringLen($video_path) > 0 Then UpdateGUIAndPlay($video_path)
	EndIf	
	
	if $msg = $forward_button Then
	
		_GUICtrlVLC_SeekRelative($vlc1, 5000)
	EndIf

	If $msg = $backward_button Then
	
		_GUICtrlVLC_SeekRelative($vlc1, -5000)
	EndIf

	if $msg = $pause_button Then
			
		_GUICtrlVLC_Pause($vlc1)
	EndIf

	if $msg = $stop_button Then
			
			_GUICtrlVLC_Stop($vlc1)
			$user_stop = True
			GUICtrlSetState($backward_button, $GUI_DISABLE)
			GUICtrlSetState($forward_button, $GUI_DISABLE)
			GUICtrlSetState($pause_button, $GUI_DISABLE)
			GUICtrlSetState($stop_button, $GUI_DISABLE)
			GUICtrlSetState($play_button, $GUI_ENABLE)
	EndIf

	if $msg = $play_button Then
			
			$user_stop = False
			$vlc1.playlist.play()
			GUICtrlSetState($backward_button, $GUI_ENABLE)
			GUICtrlSetState($forward_button, $GUI_ENABLE)
			GUICtrlSetState($pause_button, $GUI_ENABLE)
			GUICtrlSetState($stop_button, $GUI_ENABLE)
			GUICtrlSetState($play_button, $GUI_DISABLE)
	EndIf

	If $msg = $GUI_EVENT_CLOSE or $msg = $close_button Then
		
		IniWrite($ini_filename, "Main", "videopath", GUICtrlRead($video_path_input))
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
WEnd

Func UpdateGUIAndPlay($path = "")
	
		GUICtrlSetState($play_button, $GUI_DISABLE)
		
		if StringLen($path) > 0 Then
			
			GUICtrlSetData($video_path_input, $path)
			_GUICtrlVLC_Clear($vlc1)
			_GUICtrlVLC_Play($vlc1, _GUICtrlVLC_Add($vlc1, GUICtrlRead($video_path_input)))
		Else
		
			_GUICtrlVLC_Play($vlc1, 0)
		EndIf
		
		While _GUICtrlVLC_GetState($vlc1) <> 3
		WEnd

		GUICtrlSetLimit($position_slider, (_GUICtrlVLC_GetLength($vlc1) / 1000))
		GUICtrlSetData($position_slider, 0)
		$position_slider_drag = False
		GUICtrlSetState($backward_button, $GUI_ENABLE)
		GUICtrlSetState($forward_button, $GUI_ENABLE)
		GUICtrlSetState($pause_button, $GUI_ENABLE)
		GUICtrlSetState($stop_button, $GUI_ENABLE)
		GUICtrlSetState($play_button, $GUI_DISABLE)
EndFunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndSlider
	$hWndSlider = $position_slider
	If Not IsHWnd($position_slider) Then $hWndSlider = GUICtrlGetHandle($position_slider)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndSlider
			
			Switch $iCode

				case $NM_CUSTOMDRAW
					
					$position_slider_drag = True
				
				Case $NM_RELEASEDCAPTURE

					_GUICtrlVLC_SeekAbsolute($vlc1, (GUICtrlRead($position_slider) * 1000))
					$position_slider_drag = False
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc
