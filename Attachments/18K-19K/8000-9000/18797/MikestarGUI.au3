;by wiredbits
;first run at doing a volume control for mixer
;my system has two sounds cards and all went well with both
#include <GUIConstants.au3>
#include <MXSelectInputSrc_include.au3>
#include <Mikestar.au3>
;default mixer is always 0 (so far) which is last audio device installed or prefered deviced selected by user
$mixernames=""
$FormSelectInput =0
$TV_SelectInput = 0
$CMB_DevName=0
$CKB_EnableLinefocus =0
$test=0
;default mixer is always 0 (so far) which is last audio device installed or prefered deviced selected by user
$defaultmixer=0
$lastlinesrc=-1
$curmixer=$defaultmixer 
Const $MM_MIXM_CONTROL_CHANGE = 0x3D1
Const $CALLBACK_WINDOW = 0x10000

;-------------------------------------
$SL_WaveOut = 0
$SL_MicIN = 0
$SL_MicOut = 0
$SL_StereoMix = 0
$dumCallback = 0
;-------------------------------------


;OpenAllMixers($mixers)
;If @error Then Exit

If GetAllRecordDevs($mixers,$mxline) Then GetLineConnectionsNames($mixers,$mxInList,$curmixer)



CreateGui()
Main()
CloseAllMixers($mixers)


Func Main()
	Local $mxvol, $msg, $admsg, $wo, $hmxobj, $x, $savevolume
;	GUIRegisterMsg($MM_MIXM_CONTROL_CHANGE, "MyCallBack")  ;cool commnad! first time plaing with it.
	$hmxobj = MixerOpen($curmixer, $FormSelectInput, $MM_MIXM_CONTROL_CHANGE, BitOR($CALLBACK_WINDOW, $MIXER_OBJECTF_MIXER))
	
	ConsoleWrite("#####WAVEOUT#####:" & @CRLF)
	GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT)
	$SL_WaveOut_vol = GetSetOutVolume($mixers, $curmixer, 0, 0)
	GUICtrlSetData($SL_WaveOut, 100-BitAND($SL_WaveOut_vol / 0xFFFF * 100, 0xffff))
	ConsoleWrite("#####MICOUT#####:" & @CRLF)
	GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE)
	$SL_MicOut_vol = GetSetOutVolume($mixers, $curmixer, 0, 0)
	GUICtrlSetData($SL_MicOut, 100-BitAND($SL_MicOut_vol / 0xFFFF * 100, 0xffff))
	ConsoleWrite("#####MICIN#####:" & @CRLF)
	GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_DST_VOICEIN)
	$SL_MicIn_vol = GetSetOutVolume($mixers, $curmixer, 0, 0)
	GUICtrlSetData($SL_MicIn, 100-BitAND($SL_MicIn_vol / 0xFFFF * 100, 0xffff))
	ConsoleWrite("#####STEREOMIX#####:" & @CRLF)
	GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_DST_SPEAKERS)
	$SL_StereoMix_vol = GetSetOutVolume($mixers, $curmixer, 0, 0)
	GUICtrlSetData($SL_StereoMix, 100-BitAND($SL_StereoMix_vol / 0xFFFF * 100, 0xffff))	
	
	$wo1 = 100-GUICtrlRead($SL_WaveOut)
	$wo2 = 100-GUICtrlRead($SL_MicOut)
	$wo3 = 100-GUICtrlRead($SL_MicIn)
	$wo4 = 100-GUICtrlRead($SL_StereoMix)
	While 1
		$admsg = GUIGetMsg(1)
		$msg = $admsg[0]
		;might be more accurate if use steps from control but this suits my needs
		If 100-GUICtrlRead($SL_WaveOut) <> $wo1 Then
			GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT)
			$wo1 = 100-GUICtrlRead($SL_WaveOut)
;			GUICtrlSetData($LB_vol, $wo)
			$x = Mod($wo1 * 0xffff, 100)
			$wo1 = BitAND($wo1 * 0xffff / 100, 0xffff)
			$wo1 = $wo1 + $x
			GetSetOutVolume($mixers, $curmixer, $wo1) ;this will also trigger callback routine
			$wo1 = 100-GUICtrlRead($SL_WaveOut)
		EndIf
		If 100-GUICtrlRead($SL_MicOut) <> $wo2 Then
			GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE)
			$wo2 = 100-GUICtrlRead($SL_MicOut)
;			GUICtrlSetData($LB_vol, $wo)
			$x = Mod($wo2 * 0xffff, 100)
			$wo2 = BitAND($wo2 * 0xffff / 100, 0xffff)
			$wo2 = $wo2 + $x
			GetSetOutVolume($mixers, $curmixer, $wo2) ;this will also trigger callback routine
			$wo2 = 100-GUICtrlRead($SL_MicOut)
		EndIf
		If 100-GUICtrlRead($SL_MicIn) <> $wo3 Then
			GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_DST_VOICEIN)
			$wo3 = 100-GUICtrlRead($SL_MicIn)
;			GUICtrlSetData($LB_vol, $wo)
			$x = Mod($wo3 * 0xffff, 100)
			$wo3 = BitAND($wo3 * 0xffff / 100, 0xffff)
			$wo3 = $wo3 + $x
			GetSetOutVolume($mixers, $curmixer, $wo3) ;this will also trigger callback routine
			$wo3 = 100-GUICtrlRead($SL_MicIn)
		EndIf
		If 100-GUICtrlRead($SL_StereoMix) <> $wo4 Then
			GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_DST_SPEAKERS)
			$wo4 = 100-GUICtrlRead($SL_StereoMix)
;			GUICtrlSetData($LB_vol, $wo)
			$x = Mod($wo4 * 0xffff, 100)
			$wo4 = BitAND($wo4 * 0xffff / 100, 0xffff)
			$wo4 = $wo4 + $x
			GetSetOutVolume($mixers, $curmixer, $wo4) ;this will also trigger callback routine
			$wo4 = 100-GUICtrlRead($SL_StereoMix)
		EndIf
		Select

			Case $FormSelectInput<>0 And $admsg[1]=$FormSelectInput And $msg = $GUI_EVENT_CLOSE 
				GUIDelete($FormSelectInput)
				$FormSelectInput=0
				ExitLoop
			Case $admsg[1]=$FormSelectInput
				FormSelectInputMsgs($msg)
			Case $msg = $GUI_EVENT_CLOSE
				ConsoleWrite("EXITBUTTON")
				ExitLoop

		EndSelect
	WEnd
	GUIDelete($FormSelectInput)
	
;~ 	Programm exits - lets restor the Settings from the start.
	GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT)
	GetSetOutVolume($mixers, $curmixer, $SL_WaveOut_vol)
	GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE)
	GetSetOutVolume($mixers, $curmixer, $SL_MicOut_vol)
	GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_DST_SPEAKERS)
	GetSetOutVolume($mixers, $curmixer, $SL_StereoMix_vol)
	GetMXWaveoutID($mixers, $curmixer, $MIXERLINE_COMPONENTTYPE_DST_VOICEIN)
	GetSetOutVolume($mixers, $curmixer, $SL_MicIn_vol)

	MixerClose($hmxobj)
EndFunc   ;==>Main



Func CreateGui()
	
		;Generated with Form Designer preview
		$FormSelectInput = GUICreate("Mikestar", 400, 450, 286, 157)
		GUISetFont(10, 400, 0, "MS Sans Serif")
		$CMB_DevName=GUICtrlCreateCombo("", 100, 5, 215, 24)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		GUICtrlCreateLabel("Soundkarte:", 5, 7, 95, 20)
		GUICtrlSetFont(-1, 10, 800, 1, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x000080)
		GUICtrlCreateLabel("SoundInput:", 15, 45, 95, 20)
		GUICtrlSetFont(-1, 10, 800, 1, "MS Sans Serif")
		$TV_SelectInput = GUICtrlCreateTreeView(5, 65, 150, 203,BitOR($TVS_HASBUTTONS,  $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS,$TVS_CHECKBOXES),$WS_EX_CLIENTEDGE)
		GUICtrlCreateLabel("SoundOutput:", 215, 45, 95, 20)
		GUICtrlSetFont(-1, 10, 800, 1, "MS Sans Serif")
		$TV_SelectOutput = GUICtrlCreateTreeView(200, 65, 150, 203,BitOR($TVS_HASBUTTONS,  $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS,$TVS_CHECKBOXES),$WS_EX_CLIENTEDGE)
		GUICtrlSetData($CMB_DevName,$mixernames)
		GUICtrlSetData($CMB_DevName,$mixers[$curmixer][$MIX_DEVNAME])
;		SetupTreeivew($curmixer)
		;-------------------------------------------------------------------------
		GuiCtrlCreateGraphic(6-1, 35, 400-5-5,3 )
		GUICtrlSetColor(-1,0x000000)
		GUICtrlSetBkColor(-1,0x000000)  ; Black
		;-------------------------------------------------------------------------
		GuiCtrlCreateGraphic((375/2)-1-2, 35, 4,450-35-2 )
		GUICtrlSetColor(-1,0x000000)
		GUICtrlSetBkColor(-1,0x000000)  ; Black
		;-------------------------------------------------------------------------
		$Group1 = GUICtrlCreateGroup("Mic In", 5, 270, 80, 125)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		$SL_MicIn = GUICtrlCreateSlider(21, 285, 45, 100,$TBS_VERT + $TBS_BOTH + $TBS_AUTOTICKS)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		;-------------------------------------------------------------------------
		$Group2 = GUICtrlCreateGroup("Mic Out", 5+1*(80+10), 270, 80, 125)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		$SL_MicOut = GUICtrlCreateSlider(21+1*(80+10), 285, 45, 100,$TBS_VERT + $TBS_BOTH + $TBS_AUTOTICKS)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		;-------------------------------------------------------------------------
		$Group3 = GUICtrlCreateGroup("Stereo Mix", 5+2*(80+10), 270, 80, 125)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		$SL_StereoMix = GUICtrlCreateSlider(21+2*(80+10), 285, 45, 100,$TBS_VERT + $TBS_BOTH + $TBS_AUTOTICKS)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		;-------------------------------------------------------------------------
		$Group4 = GUICtrlCreateGroup("WaveOut", 5+3*(80+10), 270, 80, 125)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		$SL_WaveOut = GUICtrlCreateSlider(21+3*(80+10), 285, 45, 100,$TBS_VERT + $TBS_BOTH + $TBS_AUTOTICKS)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		;-------------------------------------------------------------------------
		$filemenu = GUICtrlCreateMenu ("&File")    ; basic menu
		$save = GUICtrlCreateMenuitem ("Save",$filemenu)
		$load = GUICtrlCreateMenuitem ("Load",$filemenu)
		SetupTreeivew($curmixer)
	;	ConsoleWrite("$curmixer= " & $curmixer)
		$dumCallback = GUICtrlCreateDummy() 										; ??? ------------------------------------------------------
		GUISetState(@SW_SHOW,$FormSelectInput)
EndFunc


Func FormSelectInputMsgs($msg)
	Local $cnt, $i, $x, $id, $src, $tmp, $state
	
	$cnt = $mxInList[0][0]
	If $cnt Then
	
		Select
			Case $msg = $CMB_DevName
				ConsoleWrite("r222222222222222ofl = " & $msg)
				$tmp = GUICtrlRead($CMB_DevName)
				
				$x = -1
				For $i = 0 To $mixers[0][0] - 1
					If $tmp = $mixers[$i][$MIX_DEVNAME] Then
						$x = $i
						ExitLoop
					EndIf
				Next ;$i
				If $x <> -1 And $x <> $curmixer Then
					$curmixer = $x
					GUICtrlDelete($TV_SelectInput)
					$TV_SelectInput = GUICtrlCreateTreeView(32, 104, 241, 273, BitOR($TVS_HASBUTTONS, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES), $WS_EX_CLIENTEDGE)
					GetLineConnectionsNames($mixers, $mxInList, $curmixer)
					SetupTreeivew($x)

				EndIf
			Case $msg >= $mxInList[0][$lst_ctrid] And $msg <= $mxInList[$cnt - 1][$lst_ctrid]
				$id = GUICtrlRead($TV_SelectInput)
				For $i = 0 To $cnt - 1
					If $id = $mxInList[$i][$lst_ctrid] Then $src = $i
					GUICtrlSetState($mxInList[$i][$lst_ctrid], $GUI_UNCHECKED)
				Next ;i
				GUICtrlSetState($id, $GUI_CHECKED)
				$i = GetSetLineSrc($mixers, $curmixer, 0, 0)
				If $i <> $src Then $lastlinesrc = GetSetLineSrc($mixers, $curmixer, $src)
				
		EndSelect
	EndIf
EndFunc   ;==>FormSelectInputMsgs







