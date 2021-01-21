
;by wiredbits
;first run at doing a volume control for mixer
;my system has two sounds cards and all went well with both
#include <GUIConstants.au3>
#include <MXSelectInputSrc_include.au3>
;default mixer is always 0 (so far) which is last audio device installed or prefered deviced selected by user
$curmixer=0
 CONST $MM_MIXM_CONTROL_CHANGE= 0x3D1
 CONST $CALLBACK_WINDOW =0x10000
 OpenAllMixers($mixers)
 If @error Then Exit
 GetMXWaveoutID($mixers,$curmixer,$MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT)
;Generated with Form Designer preview
$Form1 = GUICreate("Mixer Volume", 437, 197, 270, 282)
GUISetFont(10, 400, 0, "MS Sans Serif")
$Group1 = GUICtrlCreateGroup("Volume", 56, 24, 313, 137)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$SL_WaveOut = GUICtrlCreateSlider(72, 64, 270, 29)
GUICtrlCreateLabel(" Volume", 144, 43, 53, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$LB_vol=GUICtrlCreateLabel("0", 208, 43, 50, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$RAD_MasterVol = GUICtrlCreateRadio("Master Volume", 96, 128, 113, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$RAD_WaveOut = GUICtrlCreateRadio("Wave Out", 248, 128, 105, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
$dumCallback=GUICtrlCreateDummy ()
 Main()
 CloseAllMixers($mixers)
 Exit
Func Main()
 Local $mxvol,$msg,$admsg,$wo,$hmxobj,$x,$savevolume
 GUIRegisterMsg ($MM_MIXM_CONTROL_CHANGE,"MyCallBack")  ;cool commnad! first time plaing with it.
 $hmxobj=MixerOpen($curmixer,$Form1,$MM_MIXM_CONTROL_CHANGE,BitOR($CALLBACK_WINDOW,$MIXER_OBJECTF_MIXER) )
 $mxvol=GetSetOutVolume($mixers,$curmixer,0,0)
 $savevolume=$mxvol
 GUICtrlSetData($SL_WaveOut,BitAND($mxvol/ 0xFFFF * 100,0xffff))
 GUICtrlSetData($LB_vol,BitAND($mxvol/ 0xFFFF * 100,0xffff))
 $wo=GUICtrlRead($SL_WaveOut)
While 1
	$admsg = GuiGetMsg(1)
	$msg=$admsg[0]
;might be more accurate if use steps from control but this suits my needs
	If GUICtrlRead($SL_WaveOut)<>$wo Then
		$wo=GUICtrlRead($SL_WaveOut)
		GUICtrlSetData($LB_vol,$wo)
		$x=mod($wo*0xffff,100)
		$wo=BitAND($wo*0xffff/100,0xffff)
		$wo=$wo+$x
		GetSetOutVolume($mixers,$curmixer,$wo) ;this will also trigger callback routine
		$wo=GUICtrlRead($SL_WaveOut)
	EndIf
	Select
	Case $msg=$RAD_MasterVol  ;could have just made two sliders for this example but i only need one.
		GetSetOutVolume($mixers,$curmixer,$savevolume)
		GetMXWaveoutID($mixers,$curmixer,$MIXERLINE_COMPONENTTYPE_DST_SPEAKERS)
		$savevolume=GetSetOutVolume($mixers,$curmixer,0,0)
		$mxvol=$savevolume
		GUICtrlSetData($SL_WaveOut,BitAND($mxvol/ 0xFFFF * 100,0xffff))
		GUICtrlSetData($LB_vol,BitAND($mxvol/ 0xFFFF * 100,0xffff))
	Case $msg=$RAD_WaveOut
		GetSetOutVolume($mixers,$curmixer,$savevolume)
		GetMXWaveoutID($mixers,$curmixer,$MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT)
		$savevolume=GetSetOutVolume($mixers,$curmixer,0,0)
		$mxvol=$savevolume
		GUICtrlSetData($SL_WaveOut,BitAND($mxvol/ 0xFFFF * 100,0xffff))
		GUICtrlSetData($LB_vol,BitAND($mxvol/ 0xFFFF * 100,0xffff))
	Case $msg=$dumCallback
		$x=GetSetOutVolume($mixers,$curmixer,0,0)
		If $x<>$mxvol Then
			$mxvol=$x
			GUICtrlSetData($SL_WaveOut,BitAND($mxvol/ 0xFFFF * 100,0xffff))
			GUICtrlSetData($LB_vol,BitAND($mxvol/ 0xFFFF * 100,0xffff))
		EndIf
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	EndSelect
WEnd
 GUIDelete($Form1)
 GetSetOutVolume($mixers,$curmixer,$savevolume)
 MixerClose($hmxobj)
EndFunc


Func GetSetOutVolume($mixers,$index,$vol=0,$doset=1)	
 Local $i,$x,$arraysize,$channels,$mtiems
 CONST $MIXERCONTROLDETAILS_UNSIGNED_SIZEOF=4
 Local $mixercontroldetails=DllStructCreate( _
"dword;" & _	;DWORD cbStruct
"dword;" & _	;DWORD dwControlID
"dword;" & _	;DWORD cChannels;
"dword;" & _	;HWND  hwndOwner  DWORD cMultipleItems; 
"dword;" & _	;DWORD  cbDetails; 
"dword")		;LPVOID paDetails;
  If @error Then Return False
 $mitems=$mixers[$index][$MIX_OUTMULTIEMS]
 $channels=$mixers[$index][$MIX_OUTCHANNELS]
 $arraysize=$channels
 If $mitems Then $arraysize=$channels*$mitems
 Local $plistbool=DllStructCreate("dword["&$arraysize+1 &"]") ;give me one mroe than needed
	If @error Then Return False
	$hmxobj=$mixers[$index][$MIX_HMXOBJ]
	$mxcd=$mixercontroldetails
	DllStructSetData($mxcd,$cbStruct,DllStructGetSize($mxcd))
	DllStructSetData($mxcd,2,$mixers[$index][$MIX_OUTCTRLID]) 
	DllStructSetData($mxcd,3,$mixers[$index][$MIX_OUTCHANNELS])
	DllStructSetData($mxcd,4,$mixers[$index][$MIX_OUTMULTIEMS])
	DllStructSetData($mxcd,5,$MIXERCONTROLDETAILS_UNSIGNED_SIZEOF) ;cbDetails to sizeof one unsigned struct
	DllStructSetData($mxcd,6,DllStructGetPtr($plistbool)) ;paDetails set ptr
	$ret = DLLCall("winmm.dll","long","mixerGetControlDetails","hwnd",$hmxobj,"ptr",DllStructGetPtr($mxcd),"long",BitOR($MIXER_OBJECTF_HMIXER,$MIXER_GETCONTROLDETAILSF_VALUE))
    If @error Then Return False
	If $ret[0]=$MMSYSERR_NOERROR Then
		$x=DllStructGetData($plistbool,1,1)	;just return right channel
		For $i= 1 To $arraysize 
			DllStructSetData($plistbool,1,$vol,$i) ;set left right to same value
		Next ;i
		If $doset Then $ret = DLLCall("winmm.dll","long","mixerSetControlDetails","hwnd",$hmxobj,"ptr",DllStructGetPtr($mxcd),"long",BitOR($MIXER_OBJECTF_HMIXER,$MIXER_SETCONTROLDETAILSF_VALUE))
		Return $x
	EndIf
Return False
EndFunc

Func MyCallBack($hWndGUI, $MsgID, $WParam, $LParam)
  If $mixers[$curmixer][$MIX_OUTCTRLID]=$LParam Then
	 GUICtrlSendToDummy($dumCallback)
  EndIf
 Return 0 ;need to research what value to return:P
EndFunc

Func GetMXWaveoutID(ByRef $mixers,$index,$linetype)
 Local $mitems,$chans,$hmxobj,$x,$ret,$lineid
;local structures are nuked on exit...so i have read..LOL
Local $mixercontrol=DllStructCreate( _ 
"dword;" & _ ; DWORD cbStruct; 
"dword;" & _ ;   DWORD dwControlID; 
"dword;" & _ ;   DWORD dwControlType;  
"dword;" & _ ;   DWORD fdwControl;    
"dword;" & _ ;   DWORD cMultipleItems; 
"char[16];" & _ ;szShortName[MIXER_SHORT_NAME_CHARS]; 
"char[64];" & _ ;szName[MIXER_LONG_NAME_CHARS]; 
"dword;" & _	;lMinimum
"dword;" & _	;lMaximum
"dword[4];" & _ ;dwReserved[4];
"dword;"  & _ 	;cSteps
"dword[5]") ;   DWORD dwReserved[6];
   If @error Then return False
Local $mixerlinecontrols=DllStructCreate( _
"dword;"& _ ;	  cbStruct; 
"dword;" & _ ;    DWORD dwLineID; 
"dword;" & _ ;    DWORD dwControlID     DWORD dwControlType;
"dword;" & _ ;    DWORD  cControls;  
"dword;" & _ ;    DWORD cbmxctrl; 
"ptr") ;    	  LPMIXERCONTROL pamxctrl; 
    If @error Then return False
	$hmxobj=$mixers[$index][$MIX_HMXOBJ]
	zeroline($mxline)
	$mxline[$dwLineID]=BitOR($index,0xFFFF0000)
	$mxline[$dwComponentType]=$linetype
	MixerGetLineInfo($hmxobj,$mxline,$MIXER_GETLINEINFOF_COMPONENTTYPE)
	$lineid=$mxline[$dwLineID]	
	DllStructSetData($mixerlinecontrols,$cbStruct,DllStructGetSize($mixerlinecontrols))
	DllStructSetData($mixerlinecontrols,2,$lineid)
	DllStructSetData($mixerlinecontrols,3,$MIXERCONTROL_CONTROLTYPE_VOLUME )
	DllStructSetData($mixerlinecontrols,4,1)
	DllStructSetData($mixerlinecontrols,5,DllStructGetSize($mixercontrol))
	DllStructSetData($mixerlinecontrols,6,DllStructGetPtr($mixercontrol))
	$ret = DLLCall("winmm.dll","long","mixerGetLineControls","hwnd",$hmxobj,"ptr",DllStructGetPtr($mixerlinecontrols),"long",BitOR($MIXER_OBJECTF_HMIXER,$MIXER_GETLINECONTROLSF_ONEBYTYPE ))
	If $ret[0]<>$MMSYSERR_NOERROR Then Return False	
	$chans=$mxline[$cChannels]
	$x=DllStructGetData($mixercontrol,4) ;fwControl
	If BitAND($x,$MIXERCONTROL_CONTROLF_UNIFORM) Then $chans=1
	$mitems= 0
	If BitAND($x,$MIXERCONTROL_CONTROLF_MULTIPLE) Then $mitems=DllStructGetData($mixercontrol,5) 
	$x=DllStructGetData($mixercontrol,3) ;fwControl
	If BitAND($x,$MIXERCONTROL_CT_CLASS_FADER ) Then
		$mixers[$index][$MIX_OUTCHANNELS]=$chans
		$mixers[$index][$MIX_OUTMULTIEMS]=$mitems
		$mixers[$index][$MIX_OUTCTRLID]=DllStructGetData($mixercontrol,2)
		Return True
	EndIf
	Return False
EndFunc

Func zeroline(ByRef $line)
 local $i
  For $i=0 To UBound($line)-1
	  $line[$i]=0
  Next ;i
EndFunc

Func MixerGetLineInfo($hmxobj,ByRef $line,$flag)
 Local $mixerline= DllStructCreate("dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;char[16];char[64];dword;dword;short;short;dword;char[32]")
  If @error Then
	 SetError(1)
	 Return False
  EndIf
 Local $i
 For $i=1 To UBound($line)-1
	DllStructSetData($mixerline,$i,$line[$i])
 Next ;i
 DllStructSetData($mixerline,$cbStruct,DllStructGetSize($mixerline))
 $ret = DLLCall("winmm.dll","long","mixerGetLineInfo","hwnd",$hmxobj,"ptr",DllStructGetPtr($mixerline),"int", $flag)
  If @error Then
	 SetError(1)
	 Return False
  EndIf
 for $i=1 To $szMPname
 $line[$i]=DllStructGetData($mixerline,$i)
 Next ;i
 If $ret[0]=$MMSYSERR_NOERROR Then Return True
 SetError(1)
 Return False
EndFunc

;On Exit: MIX_HMXOBJ set to return value from mixeropn...check for @error
Func OpenAllMixers(ByRef $mixers)
 Local $i,$mxnumdevs,$hmxobj
  $mxnumdevs=mixerGetNumDevs()
  If $mxnumdevs Then
	ReDim $mixers[$mxnumdevs+1][$AMIX_SIZEOF]
	For $i=0 To $mxnumdevs-1
		$hmxobj=mixerOpen($i,0,0,$MIXER_OBJECTF_MIXER)
		If @error Then 
			SetError(1)
			Return False
		EndIf
	$mixers[$i][$MIX_HMXOBJ]=$hmxobj
	Next ;i
  EndIf
  $mixers[0][0]=$mxnumdevs
EndFunc

;On ENtry: mixer id and flag(s) , if no id passed then the preffered id is used (0) ditto for flag
;on exit: mixer handle
Func MixerOpen($uMxid=0,$hwnd=0,$instance=0,$fdwOpen=0)
 Local $x,$h_struct
	$h_struct=DllStructCreate("udword") ;since a local will be deleted on exit of function
	If @error Then
		SetError(1)
		Return False
	EndIf
	$ret = DLLCall("winmm.dll","long","mixerOpen","ptr",DllStructGetPtr($h_struct),"int",$uMxid,"int",$hwnd,"int",$instance,"int",$fdwOpen)
	If NOT @error 	 Then 
		If $ret[0]<>$MMSYSERR_NOERROR Then Return -1
		$x=DllStructGetData($h_struct,1)
		Return $x
	EndIf
	SetError(1)
 return False
EndFunc

Func  CloseAllMixers($mixers)
 Local $i,$cnt
  $cnt=$mixers[0][0]
	For $i= 0 To $cnt-1
		MixerClose($mixers[$i][$MIX_HMXOBJ])
	Next ;i
EndFunc

;On Entry: mixer handle
Func MixerClose($hmxobj)
	$ret = DLLCall("winmm.dll","long","mixerClose","long",$hmxobj)
 If NOT @error Then Return True
 return False
EndFunc

Func mixerGetNumDevs()
 $ret = DLLCall("winmm.dll","long","mixerGetNumDevs")
 If NOT @error Then Return $ret[0]
 SetError(1)
 return False
EndFunc


