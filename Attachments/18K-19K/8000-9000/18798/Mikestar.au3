;------------------------------------------------------------------
;------------------------------------------------------------------
;~ --------------- Mikestar Background Functions ------------------
;------------------------------------------------------------------
;------------------------------------------------------------------

;#include <MXSelectInputSrc_include.au3>

;--------------------------
$dumCallback = 0
;--------------------------


Func GetAllRecordDevs(ByRef $mixers,ByRef $line)
 Local $i,$hmxobj,$name
  OpenAllMixers($mixers)
  If $mixers[0][0]=0 Then Return False
  For $i=0 To $mixers[0][0]-1
	$hmxobj=$mixers[$i][$MIX_HMXOBJ]
	zeroline($line)
	$line[$dwLineID]=BitOR($i,0xFFFF0000)
	$line[$dwComponentType]=$MIXERLINE_COMPONENTTYPE_DST_WAVEIN
	MixerGetLineInfo($hmxobj,$line,$MIXER_GETLINEINFOF_COMPONENTTYPE)
	If @error Then Return False
	$mixers[$i][$MIX_RECNAME]=$line[$szName] ;wave in ccontrol name
	$mixers[$i][$MIX_CCONNECTIONS]=$line[$cConnections] ;number of destination lines
	$mixers[$i][$MIX_INCCONTROLS]=$line[$cControls]
	$mixers[$i][$MIX_DWLINEID]=$line[$dwLineID]	;line id
	$mixers[$i][$MIX_INCHANNELS]=$line[$cChannels]
	If NOT GetMxCtrlDetails($mixers,$i) Then Return False
	$name=MixerGetDevName($mixers[$i][$MIX_HMXOBJ])
	If @error Then Return False
	$mixers[$i][$MIX_DEVNAME]=$name
	If $mixernames="" Then
		$mixernames=$name
	Else
		$mixernames=$mixernames&"|"&$name
	EndIf
  Next ;i
 Return True
EndFunc

;On Entry: 2 dim array
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

Func GetMxCtrlDetails(ByRef $mixers,$index)
;	ConsoleWrite("GetMxCtrlDetails:$hmxobj = " & $mixers[$index][$MIX_HMXOBJ] & @CRLF)
 Local $mitems,$chans,$hmxobj,$x,$ret
;local structures are nuked on exit...so i have read..LOL
Local $mixercontrol=DllStructCreate( _ 
"dword;" & _ ; DWORD cbStruct; 
"dword;" & _ ;   DWORD dwControlID; 
"dword;" & _ ;   DWORD dwControlType;  
"dword;" & _ ;   DWORD fdwControl;    
"dword;" & _ ;   DWORD cMultipleItems; 
"char[16];" & _ ;szShortName[MIXER_SHORT_NAME_CHARS]; 
"char[64];" & _ ;szName[MIXER_LONG_NAME_CHARS]; 
"dword[6];" & _ ;   DWORD dwReserved[6];
"dword[6]") ;   DWORD dwReserved[6];
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
	DllStructSetData($mixerlinecontrols,$cbStruct,DllStructGetSize($mixerlinecontrols))
	DllStructSetData($mixerlinecontrols,2,$mixers[$index][$MIX_DWLINEID])
	DllStructSetData($mixerlinecontrols,3,$MIXERCONTROL_CONTROLTYPE_MUX)
	DllStructSetData($mixerlinecontrols,4,0)
	DllStructSetData($mixerlinecontrols,5,DllStructGetSize($mixercontrol))
	DllStructSetData($mixerlinecontrols,6,DllStructGetPtr($mixercontrol))
	$ret = DLLCall("winmm.dll","long","mixerGetLineControls","hwnd",$hmxobj,"ptr",DllStructGetPtr($mixerlinecontrols),"long",BitOR($MIXER_OBJECTF_HMIXER,$MIXER_GETLINECONTROLSF_ONEBYTYPE ))
    If @error Then return False
	If $ret[0]<>$MMSYSERR_NOERROR Then
		DllStructSetData($mixerlinecontrols,3,$MIXERCONTROL_CONTROLTYPE_SINGLESELECT)
		$ret = DLLCall("winmm.dll","long","mixerGetLineControls","hwnd",$hmxobj,"ptr",DllStructGetPtr($mixerlinecontrols),"long",BitOR($MIXER_OBJECTF_HMIXER,$MIXER_GETLINECONTROLSF_ONEBYTYPE ))
		If @error Then return False
	EndIf
	If $ret[0]<>$MMSYSERR_NOERROR Then Return False	
	$x=DllStructGetData($mixercontrol,3) ;dwControlType get type of control
	If BitAND($x,$MIXERCONTROL_CT_CLASS_MASK)=$MIXERCONTROL_CT_CLASS_LIST Then
		$chans=$mixers[$index][$MIX_INCHANNELS]
		$x=DllStructGetData($mixercontrol,4) ;fwControl
		If BitAND($x,$MIXERCONTROL_CONTROLF_UNIFORM) Then $chans=1
		$mixers[$index][$MIX_INCHANNELS]=$chans
		$x=DllStructGetData($mixercontrol,4) ;fwControl
		$mitems= 0
		If BitAND($x,$MIXERCONTROL_CONTROLF_MULTIPLE) Then $mitems=DllStructGetData($mixercontrol,5) 
		$mixers[$index][$MIX_INMULTIITEMS]=$mitems
		$mixers[$index][$MIX_INCTRLID]=DllStructGetData($mixercontrol,2)
		If $mitems Then Return True
	EndIf
	Return False
EndFunc

Func MixerGetDevName($uMxId)
 Local $mxcaps,$i
 $mxcaps=DllStructCreate("short;short;dword;char[32];dword;dword")
  $ret = DLLCall("winmm.dll","long","mixerGetDevCaps","int",$uMxId,"ptr",DllStructGetPtr($mxcaps),"int",DllStructGetSize($mxcaps))
 If @error Then 
	 SetError(1)
	 Return False
 EndIf
 If $ret[0]=$MMSYSERR_NOERROR Then Return DllStructGetData($mxcaps,4)
	 SetError(2)
	 return False
 EndFunc
 
 Func mixerGetNumDevs()
 $ret = DLLCall("winmm.dll","long","mixerGetNumDevs")
 If NOT @error Then Return $ret[0]
 SetError(1)
 return False
EndFunc

;On ENtry: mixer id and flag , if no id passed then the preffered id is used (0) ditto for flag
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

Func GetLineConnectionsNames(ByRef $mixers,ByRef $mxInList,$index)
 Local $i,$x,$n,$hmxobj,$ret
 If $mixers[0][0] Then
	$hmxobj=$mixers[$index][$MIX_HMXOBJ]
	$x=0
	
	For $n=0 To  $mixers[$index][$MIX_CCONNECTIONS]-1
		zeroline($mxline)
		$mxline[$dwDestination]=$mixers[$index][$MIX_DWLINEID]
		$mxline[$dwSource]=$n
		$ret=MixerGetLineInfo($hmxobj,$mxline,BitOR($MIXER_OBJECTF_HMIXER,$MIXER_GETLINEINFOF_SOURCE)) ;ask for source lines
			If NOT @error  Then
				$mxInList[$x][$lst_destname]=$mxline[$szName]
				$mxInList[$x][$lst_dwComponentType]=$mxline[$dwComponentType]
				$x=$x+1
				If UBound($mxInList)<$x+1 Then ReDim $mxInList[$x+2][UBound($mxInList,2)]
			Else
				SetError(1)
				Return False
			EndIf
	Next ;n
	$mxInList[0][0]=$x
	
	Return	True
  Else
	SetError(1)
	Return False
  EndIf
EndFunc


Func GetSetLineSrc($mixers, $index, $srcindex, $doset = 1)
;	ConsoleWrite("GetSetLineSrc:$hmxobj = " & $mixers[$index][$MIX_HMXOBJ] & @CRLF)
	; !!! srcindex = Mikroinput ID= 5 / stereoID
	Local $i, $x, $arraysize, $channels, $mtiems
	Const $MIXERCONTROLDETAILS_BOOLEAN_SIZEOF = 4
	Local $mixercontroldetails = DllStructCreate( _
			"dword;" & _	;DWORD cbStruct
			"dword;" & _	;DWORD dwControlID
			"dword;" & _	;DWORD cChannels;
			"dword;" & _	;HWND  hwndOwner  DWORD cMultipleItems;
			"dword;" & _	;DWORD  cbDetails;
			"dword") 	;LPVOID paDetails;
	Local Const $dwControlID = 1
	If @error Then Return False
	$mitems = $mixers[$index][$MIX_INMULTIITEMS]
	$channels = $mixers[$index][$MIX_INCHANNELS]
	$arraysize = $channels * $mixers[$index][$MIX_INMULTIITEMS]
	$srcindex = $mitems - $srcindex ;reverse array index
	; !!! srcindex wird reversed von 5 auf 2
	If $mitems = 0 Then Return False;if no items then no need to display
	;the folowing =array of values, array order is reverse of itmes displayed in treeview
	Local $plistbool = DllStructCreate("dword[" & $arraysize + 1 & "]") ;give me one mroe than needed
	If @error Then Return False
	$hmxobj = $mixers[$index][$MIX_HMXOBJ]
	DllStructSetData($mixercontroldetails, $cbStruct, DllStructGetSize($mixercontroldetails))
	DllStructSetData($mixercontroldetails, 2, $mixers[$index][$MIX_INCTRLID])
	DllStructSetData($mixercontroldetails, 3, $mixers[$index][$MIX_INCHANNELS])
	DllStructSetData($mixercontroldetails, 4, $mixers[$index][$MIX_INMULTIITEMS])
	DllStructSetData($mixercontroldetails, 5, $MIXERCONTROLDETAILS_BOOLEAN_SIZEOF) ;cbDetails to sizeof one bool struct
	DllStructSetData($mixercontroldetails, 6, DllStructGetPtr($plistbool)) ;paDetails set ptr
	$ret = DllCall("winmm.dll", "long", "mixerGetControlDetails", "hwnd", $hmxobj, "ptr", DllStructGetPtr($mixercontroldetails), "long", BitOR($MIXER_OBJECTF_HMIXER, $MIXER_GETCONTROLDETAILSF_VALUE))
;	ConsoleWrite($ret & @CRLF)
	If Not @error Then
		If $ret[0] = $MMSYSERR_NOERROR Then
			For $i = 1 To $mitems Step $channels ;
				If DllStructGetData($plistbool, 1, $i + $channels - 1) <> 0 Then $x = $i
				DllStructSetData($plistbool, 1, 0, $i + $channels - 1)
			Next ;i
			DllStructSetData($plistbool, 1, 1, $srcindex + $channels - 1)
			; !!! mic wird erneut reset von 2 auf 72

			If $doset Then $ret = DllCall("winmm.dll", "long", "mixerSetControlDetails", "hwnd", $hmxobj, "ptr", DllStructGetPtr($mixercontroldetails), "long", BitOR($MIXER_OBJECTF_HMIXER, $MIXER_SETCONTROLDETAILSF_VALUE))
	;		ConsoleWrite($hmxobj & @CRLF)
			If Not @error Then
				If $ret[0] = $MMSYSERR_NOERROR Then Return $mixers[$index][$MIX_INMULTIITEMS] - $x
			EndIf
		EndIf
	EndIf
	Return False
EndFunc   ;==>GetSetLineSrc


Func SetupTreeivew($index)
	If $mxInList[0][0] Then
		For $i = 0 To $mxInList[0][0] - 1 ; The Options are put into the Treeview; Kademlia
			$mxInList[$i][$lst_ctrid] = GUICtrlCreateTreeViewItem($mxInList[$i][$lst_destname], $TV_SelectInput)
	;		ConsoleWrite("loool  " & $mxInList[$i][$lst_destname])
		Next ;i
		$i = GetSetLineSrc($mixers, $index, 0, 0) ;get current input line
		GUICtrlSetState($mxInList[$i][$lst_ctrid], BitOR($GUI_CHECKED, $GUI_FOCUS))
	EndIf
EndFunc   ;==>SetupTreeivew














Func GetMXWaveoutID(ByRef $mixers, $index, $linetype)
	for $i = 0 to 14
		ConsoleWrite("$mixers[1]["&$i&"]=" & $linetype & @CRLF)
	next
	Local $mitems, $chans, $hmxobj, $x, $ret, $lineid
	;local structures are nuked on exit...so i have read..LOL
	Local $mixercontrol = DllStructCreate( _
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
			"dword;" & _ 	;cSteps
			"dword[5]") ;   DWORD dwReserved[6];
	If @error Then Return False
	Local $mixerlinecontrols = DllStructCreate( _
			"dword;" & _ ;	  cbStruct;
			"dword;" & _ ;    DWORD dwLineID;
			"dword;" & _ ;    DWORD dwControlID     DWORD dwControlType;
			"dword;" & _ ;    DWORD  cControls;
			"dword;" & _ ;    DWORD cbmxctrl;
			"ptr") ;    	  LPMIXERCONTROL pamxctrl;
	If @error Then Return False
	$hmxobj = $mixers[$index][$MIX_HMXOBJ]
	zeroline($mxline)
	$mxline[$dwLineID] = BitOR($index, 0xFFFF0000)
	$mxline[$dwComponentType] = $linetype
	MixerGetLineInfo($hmxobj, $mxline, $MIXER_GETLINEINFOF_COMPONENTTYPE)
	$lineid = $mxline[$dwLineID]
	DllStructSetData($mixerlinecontrols, $cbStruct, DllStructGetSize($mixerlinecontrols))
	DllStructSetData($mixerlinecontrols, 2, $lineid)
	DllStructSetData($mixerlinecontrols, 3, $MIXERCONTROL_CONTROLTYPE_VOLUME)
	DllStructSetData($mixerlinecontrols, 4, 1)
	DllStructSetData($mixerlinecontrols, 5, DllStructGetSize($mixercontrol))
	DllStructSetData($mixerlinecontrols, 6, DllStructGetPtr($mixercontrol))
	$ret = DllCall("winmm.dll", "long", "mixerGetLineControls", "hwnd", $hmxobj, "ptr", DllStructGetPtr($mixerlinecontrols), "long", BitOR($MIXER_OBJECTF_HMIXER, $MIXER_GETLINECONTROLSF_ONEBYTYPE))
	If $ret[0] <> $MMSYSERR_NOERROR Then Return False
	$chans = $mxline[$cChannels]
	$x = DllStructGetData($mixercontrol, 4) ;fwControl
	If BitAND($x, $MIXERCONTROL_CONTROLF_UNIFORM) Then $chans = 1
	$mitems = 0
	If BitAND($x, $MIXERCONTROL_CONTROLF_MULTIPLE) Then $mitems = DllStructGetData($mixercontrol, 5)
	$x = DllStructGetData($mixercontrol, 3) ;fwControl
	If BitAND($x, $MIXERCONTROL_CT_CLASS_FADER) Then
		$mixers[$index][$MIX_OUTCHANNELS] = $chans
		$mixers[$index][$MIX_OUTMULTIEMS] = $mitems
		$mixers[$index][$MIX_OUTCTRLID] = DllStructGetData($mixercontrol, 2)
		Return True
	EndIf
	Return False
EndFunc   ;==>GetMXWaveoutID

Func CloseAllMixers($mixers)
	Local $i, $cnt
	$cnt = $mixers[0][0]
	For $i = 0 To $cnt - 1
		MixerClose($mixers[$i][$MIX_HMXOBJ])
	Next ;i
EndFunc   ;==>CloseAllMixers

;On Entry: mixer handle
Func MixerClose($hmxobj)
	$ret = DllCall("winmm.dll", "long", "mixerClose", "long", $hmxobj)
	If Not @error Then Return True
	Return False
EndFunc   ;==>MixerClose

Func MyCallBack($hWndGUI, $MsgID, $WParam, $LParam)
	If $mixers[$curmixer][$MIX_OUTCTRLID] = $LParam Then
		GUICtrlSendToDummy($dumCallback)
	EndIf
	Return 0 ;need to research what value to return:P
EndFunc   ;==>MyCallBack


Func GetSetOutVolume($mixers, $index, $vol = 0, $doset = 1)
	Local $i, $x, $arraysize, $channels, $mtiems
	Const $MIXERCONTROLDETAILS_UNSIGNED_SIZEOF = 4
	Local $mixercontroldetails = DllStructCreate( _
			"dword;" & _	;DWORD cbStruct
			"dword;" & _	;DWORD dwControlID
			"dword;" & _	;DWORD cChannels;
			"dword;" & _	;HWND  hwndOwner  DWORD cMultipleItems;
			"dword;" & _	;DWORD  cbDetails;
			"dword") 	;LPVOID paDetails;
	If @error Then Return False
	$mitems = $mixers[$index][$MIX_OUTMULTIEMS]
	$channels = $mixers[$index][$MIX_OUTCHANNELS]
	$arraysize = $channels
	If $mitems Then $arraysize = $channels * $mitems
	Local $plistbool = DllStructCreate("dword[" & $arraysize + 1 & "]") ;give me one mroe than needed
	If @error Then Return False
	$hmxobj = $mixers[$index][$MIX_HMXOBJ]
	$mxcd = $mixercontroldetails
	DllStructSetData($mxcd, $cbStruct, DllStructGetSize($mxcd))
	DllStructSetData($mxcd, 2, $mixers[$index][$MIX_OUTCTRLID])
	DllStructSetData($mxcd, 3, $mixers[$index][$MIX_OUTCHANNELS])
	DllStructSetData($mxcd, 4, $mixers[$index][$MIX_OUTMULTIEMS])
	DllStructSetData($mxcd, 5, $MIXERCONTROLDETAILS_UNSIGNED_SIZEOF) ;cbDetails to sizeof one unsigned struct
	DllStructSetData($mxcd, 6, DllStructGetPtr($plistbool)) ;paDetails set ptr
	$ret = DllCall("winmm.dll", "long", "mixerGetControlDetails", "hwnd", $hmxobj, "ptr", DllStructGetPtr($mxcd), "long", BitOR($MIXER_OBJECTF_HMIXER, $MIXER_GETCONTROLDETAILSF_VALUE))
	If @error Then Return False
	If $ret[0] = $MMSYSERR_NOERROR Then
		$x = DllStructGetData($plistbool, 1, 1) 	;just return right channel
		For $i = 1 To $arraysize
			DllStructSetData($plistbool, 1, $vol, $i) ;set left right to same value
		Next ;i
		If $doset Then $ret = DllCall("winmm.dll", "long", "mixerSetControlDetails", "hwnd", $hmxobj, "ptr", DllStructGetPtr($mxcd), "long", BitOR($MIXER_OBJECTF_HMIXER, $MIXER_SETCONTROLDETAILSF_VALUE))
		Return $x
	EndIf
	Return False
EndFunc   ;==>GetSetOutVolume