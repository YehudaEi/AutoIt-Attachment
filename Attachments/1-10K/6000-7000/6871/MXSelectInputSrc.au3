;by wiredbits
;Selects inputline to record off of
;my system has two sounds cards and all went well with both
;need to clean up a few things and add comments....well maybe..Grin
#include <GUIConstants.au3>
#include <MXSelectInputSrc_include.au3>
$trayicon="start.ico"

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
If GetAllRecordDevs($mixers,$mxline) Then GetLineConnectionsNames($mixers,$mxInList,$curmixer)
OpenSelectInputSrcWND()
While 1
	$admsg = GuiGetMsg(1)
	$msg=$admsg[0]
	Select
	Case $FormSelectInput<>0 And $admsg[1]=$FormSelectInput And $msg = $GUI_EVENT_CLOSE 
		GUIDelete($FormSelectInput)
		$FormSelectInput=0
		ExitLoop
	Case $admsg[1]=$FormSelectInput
		FormSelectInputMsgs($msg)
	EndSelect
WEnd
CloseAllMixers($mixers)

Func FormSelectInputMsgs($msg)
 Local $cnt,$i,$x,$id,$src,$tmp,$state
  $cnt=$mxInList[0][0]
  If $cnt Then
	Select
	Case $msg=$CMB_DevName
		$tmp=GUICtrlRead($CMB_DevName)
		$x=-1
		For $i=0 To $mixers[0][0]-1
			If $tmp=$mixers[$i][$MIX_DEVNAME] Then
				$x=$i
				ExitLoop
			EndIf
		Next ;$i
		If $x<>-1 and $x<>$curmixer Then
			$curmixer=$x
			GUICtrlDelete($TV_SelectInput)
			$TV_SelectInput = GUICtrlCreateTreeView(32, 104, 241, 273,BitOR($TVS_HASBUTTONS,  $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS,$TVS_CHECKBOXES),$WS_EX_CLIENTEDGE)
			GetLineConnectionsNames($mixers,$mxInList,$curmixer)
			SetupTreeivew($x)
		EndIf
	Case $msg>=$mxInList[0][$lst_ctrid] And $msg<=$mxInList[$cnt-1][$lst_ctrid]
		$id=GUICtrlRead($TV_SelectInput)
		For $i=0 To $cnt-1
			If $id=$mxInList[$i][$lst_ctrid] Then $src=$i
			GUICtrlSetState($mxInList[$i][$lst_ctrid],$GUI_UNCHECKED)
		Next ;i
		GUICtrlSetState($id,$GUI_CHECKED)
		$i=GetSetLineSrc($mixers,$curmixer,0,0)
		If $i<>$src  Then $lastlinesrc=GetSetLineSrc($mixers,$curmixer,$src)
	EndSelect
  EndIf
EndFunc

Func OpenSelectInputSrcWND()
 If $FormSelectInput=0 Then
;Generated with Form Designer preview
$FormSelectInput = GUICreate("Please Select Input Line", 304, 432, 286, 157)
GUISetFont(10, 400, 0, "MS Sans Serif")
GUISetIcon (@ScriptDir &  "\"& $trayicon,0)
$CMB_DevName=GUICtrlCreateCombo("", 32, 64, 241, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel("Available Input lines", 76, 29, 170, 20)
GUICtrlSetFont(-1, 10, 800, 2, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000080)
$TV_SelectInput = GUICtrlCreateTreeView(32, 104, 241, 273,BitOR($TVS_HASBUTTONS,  $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS,$TVS_CHECKBOXES),$WS_EX_CLIENTEDGE)
GUICtrlSetData($CMB_DevName,$mixernames)
GUICtrlSetData($CMB_DevName,$mixers[$curmixer][$MIX_DEVNAME])
SetupTreeivew($curmixer)
GUISetState(@SW_SHOW,$FormSelectInput)
EndIf
EndFunc

Func SetupTreeivew($index)
 local $i,$id
  If $mxInList[0][0] Then
	For $i=0 To $mxInList[0][0]-1
		$mxInList[$i][$lst_ctrid]=GUICtrlCreateTreeViewItem($mxInList[$i][$lst_destname],$TV_SelectInput)
	Next ;i
	$i=GetSetLineSrc($mixers,$index,0,0) ;get current input line
	GUICtrlSetState($mxInList[$i][$lst_ctrid],BitOR($GUI_CHECKED,$GUI_FOCUS))
 EndIf
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
		If NOT @error Then
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

Func GetSetLineSrc($mixers,$index,$srcindex,$doset=1)	
 Local $i,$x,$arraysize,$channels,$mtiems
 CONST $MIXERCONTROLDETAILS_BOOLEAN_SIZEOF=4
 Local $mixercontroldetails=DllStructCreate( _
"dword;" & _	;DWORD cbStruct
"dword;" & _	;DWORD dwControlID
"dword;" & _	;DWORD cChannels;
"dword;" & _	;HWND  hwndOwner  DWORD cMultipleItems; 
"dword;" & _	;DWORD  cbDetails; 
"dword")		;LPVOID paDetails;
Local CONST $dwControlID=1
  If @error Then Return False
 $mitems=$mixers[$index][$MIX_INMULTIITEMS]
 $channels=$mixers[$index][$MIX_INCHANNELS]
 $arraysize=$channels*$mixers[$index][$MIX_INMULTIITEMS]
 $srcindex=$mitems-$srcindex ;reverse array index
 If $mitems=0 Then  	 Return False;if no items then no need to display
;the folowing =array of values, array order is reverse of itmes displayed in treeview
 Local $plistbool=DllStructCreate("dword["&$arraysize+1 &"]") ;give me one mroe than needed
	If @error Then Return False
	$hmxobj=$mixers[$index][$MIX_HMXOBJ]
	DllStructSetData($mixercontroldetails,$cbStruct,DllStructGetSize($mixercontroldetails))
	DllStructSetData($mixercontroldetails,2,$mixers[$index][$MIX_INCTRLID]) 
	DllStructSetData($mixercontroldetails,3,$mixers[$index][$MIX_INCHANNELS])
	DllStructSetData($mixercontroldetails,4,$mixers[$index][$MIX_INMULTIITEMS])
	DllStructSetData($mixercontroldetails,5,$MIXERCONTROLDETAILS_BOOLEAN_SIZEOF) ;cbDetails to sizeof one bool struct
	DllStructSetData($mixercontroldetails,6,DllStructGetPtr($plistbool)) ;paDetails set ptr
	$ret = DLLCall("winmm.dll","long","mixerGetControlDetails","hwnd",$hmxobj,"ptr",DllStructGetPtr($mixercontroldetails),"long",BitOR($MIXER_OBJECTF_HMIXER,$MIXER_GETCONTROLDETAILSF_VALUE))
	If NOT @error Then
		If $ret[0]=$MMSYSERR_NOERROR Then
			For $i= 1 To $mitems Step $channels ;
				If DllStructGetData($plistbool,1,$i+$channels-1)<>0 then $x=$i
				DllStructSetData($plistbool,1,0,$i+$channels-1)
			Next ;i
			DllStructSetData($plistbool,1,1,$srcindex+$channels-1)
			If $doset Then $ret = DLLCall("winmm.dll","long","mixerSetControlDetails","hwnd",$hmxobj,"ptr",DllStructGetPtr($mixercontroldetails),"long",BitOR($MIXER_OBJECTF_HMIXER,$MIXER_SETCONTROLDETAILSF_VALUE))
			If NOT @error Then
				If $ret[0] =$MMSYSERR_NOERROR Then return $mixers[$index][$MIX_INMULTIITEMS]- $x
			EndIf
		EndIf
	EndIf
	Return False
EndFunc

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

Func GetMxCtrlDetails(ByRef $mixers,$index)
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
 
;On Entry: handle to mixer an ID is mapped to
;On Exit: ID or 0 if fails
Func MixerGetID($hmxobj)
 Local $x,$puMxId
 	$puMxId=DllStructCreate("udword") ;since a local will be deleted on exit of function
	DllStructSetData($puMxId,1,0)
	$ret = DLLCall("winmm.dll","long","mixerGetID","hwnd",$hmxobj,"ptr",DllStructGetPtr($puMxId),"int",$MIXER_OBJECTF_HMIXER)
	If @error Or $ret[0]<>$MMSYSERR_NOERROR Then
		SetError(1)
		Return False
	EndIf
	Return DllStructGetData($puMxId,1)
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
