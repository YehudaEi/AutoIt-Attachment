#include <GuiConstants.au3>

;by wiredbits 
;Treeview HitTest using arrays...a quicky
;mostly beginer stuff, I need to go and read all of Autoit functions now:P
;using beta version 1.99
;few examples (simple) of  Treeview Hittest
;right mouse button (secondary) selection of Treeview item
;drag and drop child items between parents
;drag file onto treeview and if a hit add to treeview
;context menu cut, copy, paste, and delete a treeview item
;**********************************************************************************************
Const $TVGN_NEXT = 0x1
CONST $TVGN_PREVIOUS=	2
Const $TVGN_CHILD = 0x4
CONST $TVGN_FIRSTVISIBLE =      0x0005
Const $TVGN_CARET = 0x9
Const $TVGN_ROOT=	0
Const $TV_FIRST = 0x1100
Const $TVM_DELETEITEM = ($TV_FIRST + 1)
CONST $TVM_EXPAND=	($TV_FIRST+2)
CONST $TVM_GETNEXTITEM = ($TV_FIRST + 10)
CONST $TVM_SELECTITEM =    ($TV_FIRST + 11)
CONST $TVM_HITTEST=	($TV_FIRST+17)
Const $TVM_SORTCHILDREN = ($TV_FIRST + 19)
CONST $TVM_ENSUREVISIBLE=	($TV_FIRST+20)
CONST $TVM_SETINSERTMARK=       ($TV_FIRST + 26)
CONST $TVM_CREATEDRAGIMAGE=	($TV_FIRST+18) ;i really need to read up on this, might be better than draging a control
CONST $TVGN_DROPHILITE=	8
CONST $TVM_GETBKCOLOR =($TV_FIRST+31)
CONST $TVM_GETTEXTCOLOR= ($TV_FIRST+32)
CONST $TVM_GETITEMSTATE= ($TV_FIRST+39)

CONST $TVE_COLLAPSE=	1
CONST $TVE_EXPAND=	2

CONST $TVGN_PARENT=	3
;*********************************************************************************************
 CONST $TVHT_NOWHERE=1
 CONST $TVHT_ONITEMICON=2
 CONST $TVHT_ONITEMLABEL=4
 CONST $TVHT_ONITEMINDENT=8
 CONST $TVHT_ONITEMBUTTON=16
 CONST $TVHT_ONITEMRIGHT=32
 CONST $TVHT_ONITEMSTATEICON=64
 CONST $TVHT_ABOVE=	256
 CONST $TVHT_BELOW=512
 CONST $TVHT_TORIGHT=	1024
 CONST $TVHT_TOLEFT=	2048
 CONST $TEST=BitOR($TVHT_ONITEMICON,$TVHT_ONITEMLABEL,$TVHT_ONITEMSTATEICON,$TVHT_ONITEMINDENT,$TVHT_ONITEMBUTTON,$TVHT_ONITEMRIGHT)
;**********************************************************************************************
 CONST $WM_VSCROLL =277
 CONST $WM_HSCROLL= 276
 CONST $SBM_GETPOS= 225
 CONST $SB_LINEUP=0
 CONST $SB_LINEDOWN=1
 CONST $SB_LINELEFT=	0
 CONST $SB_LINERIGHT=	1
 CONST $SB_LEFT=6 
 CONST $SB_RIGHT=	7
;******************************************************************************************************
CONST $NUM_PARS=6
CONST $NUM_KIDS=6

CONST $PAR_NUMPARS=	0
CONST $PAR_CTRLID=	1
CONST $PAR_NAME	=	2

CONST $KID_NUMKIDS=	0
CONST $KID_PARID=	1
CONST $KID_PARINDEX=2
CONST $KID_CTRLID=	3
CONST $KID_NAME=	4
;***********************************************************************************************************
CONST $DR_CHECKIFDRAG=	1
CONST $DR_BEGINDRAG=	2
CONST $DR_KILLDRAG=		4
CONST $DR_CHECKSCROLL=	8
CONST $DR_FINISHED=		16
CONST $DR_MONITORDRAG=128
CONST $ED_CUT=1
CONST $ED_COPY=2
;***********************************************************************************************************
Dim $parents[$NUM_PARS][3]
Dim $kids[$NUM_KIDS*$NUM_PARS][5]
$winHandle = GuiCreate("Treeview Hitest Examples", 348, 450, 200, 5, $WS_OVERLAPPEDWINDOW,$WS_EX_ACCEPTFILES) 
GUISetFont(10,400)
$ClassTreeview = GUICtrlCreateTreeView(24, 40, 300, 385)
GUICtrlSetState(-1,$GUI_DROPACCEPTED); to allow drag and dropping
;i remember when i first saw the dummy control...thought i would never use them
;then i saw some examples and thought..dummy...LOL
$dragdummy= GUICtrlCreateDummy()
$finisheddrag= GUICtrlCreateDummy()
$kidDummy= GUICtrlCreateDummy()
$parDummy= GUICtrlCreateDummy()
$parmenu = GUICtrlCreateContextMenu ($parDummy)
$contexPDelete=GUICtrlCreateMenuitem ("Delete", $parmenu)
$contexPPaste=GUICtrlCreateMenuitem ("Paste Item", $parmenu)
GUICtrlCreateMenuitem ("", $parmenu)
$contexPExpand  = GUICtrlCreateMenuitem ("Expand All", $parmenu)
$contexPCollaspe  = GUICtrlCreateMenuitem ("Collapse All", $parmenu)

$kidMenu = GUICtrlCreateContextMenu  ($kidDummy)
$contexCut=GUICtrlCreateMenuitem ("Cut", $kidMenu)
$contexCopy=GUICtrlCreateMenuitem ("Copy", $kidMenu)
$contexPaste=GUICtrlCreateMenuitem ("Paste", $kidMenu)
GUICtrlSetState(-1,$GUI_DISABLE)
$contextDeleteItem=GUICtrlCreateMenuitem ("Delete", $kidMenu)
GuiSetState(@SW_SHOW ,$winhandle)

;should make the following local
$savex=0
$savey=0
$droptime=0
$dropflag=0
$hfromparent=-1
$fromkidID=-1
$editflag=0
$fhandle=0
SetUpTreeview()
 Main()
 Exit
 Func Main()
 Local $i,$x,$id
   While 1
		If HandleMsgs() Then ExitLoop
  WEnd
EndFunc
 Func HandleMsgs()
 Local $admsg,$msg,$hitem,$x
    $admsg = GuiGetMsg(1)
	$msg=$admsg[0]
  Select
	Case $msg=$dragdummy
	  $msg=GUICtrlRead($dragdummy)
	 If $msg=$DR_BEGINDRAG Then
	  TV_BeginDrag($ClassTreeview,$finisheddrag)
	ElseIf $msg=$DR_KILLDRAG Then
	  $dropflag=0
	  $droptime=0
	 EndIf
	Case $msg=$finisheddrag
	  TV_FinishDrag($ClassTreeview,$finisheddrag,$dragdummy)
	  $x=GUICtrlRead($ClassTreeview)
	  If $x=$fromkidID Then $fromkidID=-1
;secondary mouse selection
    Case $msg=$GUI_EVENT_SECONDARYDOWN 
			$savex=$admsg[3]
			$savey=$admsg[4] ;save mouse positions
;force user to click on a treeview item label to get context menu...could give an optional menu if no hit
		$hitem=TV_Hittest($ClassTreeview,$savex,$savey,$TVHT_ONITEMRIGHT,0)
		If $hitem Then
			$x=GUICtrlSendMsg($ClassTreeView,$TVM_GETNEXTITEM,$TVGN_CARET,0) ;get current
			If $x<>$hitem Then GUICtrlSendMsg($ClassTreeView,$TVM_SELECTITEM,$TVGN_CARET,$hitem) ;select hit item if not already
			TV_ShowContextMenu($ClassTreeView,$hitem)
		EndIf
	Case $msg=$GUI_EVENT_MOUSEMOVE
		If BitAND($dropflag,$DR_MONITORDRAG) Then TV_CheckIfDrag($ClassTreeview,$dragdummy)
	 Case $msg=$contexCut
		TV_Cut($ClassTreeView)
	 Case $msg=$contexCopy
		TV_Copy($ClassTreeView)
	 Case $msg=$contexPaste Or $msg=$contexPPaste
		TV_Paste($ClassTreeView,$savex,$savey)
	 Case $msg=$contextDeleteItem Or $msg=$contexPDelete
		TV_DeleteItem($ClassTreeview)
	Case $msg=$contexPCollaspe 
		ExpandCollaspe($TVE_COLLAPSE)
	Case $msg=$contexPExpand 
		ExpandCollaspe($TVE_EXPAND)
	case $msg=$GUI_EVENT_DROPPED
		TV_DropFIle($ClassTreeview)
	Case $msg=$GUI_EVENT_CLOSE 
		Return 1
	Case $msg>$parents[0][$PAR_CTRLID] ;could check if a child ID then set flag 
		$dropflag=BitOR($dropflag,$DR_MONITORDRAG)
  EndSelect
 Return 0
EndFunc

Func TV_BeginDrag($TreeView,$finisheddrag)
 Local $droplabel,$curctrl
	$curctrl=GUICtrlRead($TreeView,1)
	$mouse = GUIGetCursorInfo($winHandle)
   If NOT  @error then 
	$droplabel=	GuiCtrlCreateLabel($curctrl[0],$mouse[0],$mouse[1],200,16,-1) 
;	$droplabel=	GUICtrlCreateIcon("shell32.dll",175,$mouse[0],$mouse[1]) ;you can drag icons too
	TV_DoDrag($TreeView,$droplabel,$finisheddrag)
   EndIf
EndFunc  

Func TV_FinishDrag($TreeView,$finisheddrag,$kill)
 Local $hitem,$curkid,$id,$curparid,$parID,$index,$i
	$hitem=GUICtrlRead($finisheddrag)
	If  $hitem=0 Then Return 0; not a hit
	$curkid=GUICtrlRead($TreeView) ;focus always a kid in this example
	$curparid=GetKidParent($kids,$curkid)
	$parID=GetparentID($parents,$hitem)
	If NOT $parID Then
		$parID=GetKidID($kids,$hitem)
		$parID=GetKidParent($kids,$parID)
	EndIf
	If $parID=$curparid then return 0
	$index=GetKidIndex($kids,$curkid)
	$id=GUICtrlCreateTreeViewItem($kids[$index][$KID_NAME],$parID)
	If $id Then
		GUICtrlDelete($curkid)
		$cnt=$kids[0][0]
		UBArray($kids)
		ARRAYCopy($kids,$index,$cnt) ;could just use current array cell but:P
		$kids[0][0]=$kids[0][0]+1
		$kids[$cnt][$KID_PARID]=$parid
		$kids[$cnt][$KID_CTRLID]=$id
		DeleteArrayItem($kids,$index)
		$kids[0][0]=$cnt
		$hitem=GUICtrlGetHandle($parID)
		GUICtrlSendMsg($TreeView,$TVM_SORTCHILDREN ,0,$hitem) ;wParam (3rd parameter) a bool to recurse or not
		GUICtrlSendMsg($TreeView,$WM_HSCROLL,$SB_LEFT ,0) ;force treeview to left
		GUICtrlSetState($id,$GUI_FOCUS)
	EndIf
	GUICtrlSendToDummy($kill,$DR_KILLDRAG) ;msg received after focus
	return $id
EndFunc

Func TV_CheckIfDrag($TreeView,$dummy)
 Local $hitem
 CONST $DRAGBUTTON=2 ;primary button
 CONST $CTRLID=4
  $mouse = GUIGetCursorInfo($winHandle)
   If NOT  @error then 
	If $mouse[$DRAGBUTTON] And $mouse[$CTRLID] = $TreeView  Then
		if $droptime=0 Then
			$droptime=TimerInit()
		ElseIf TimerDiff($droptime)>70 Then
		$hitem=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_CARET,0)
		$hitem=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem) ;returns 0 if hitem is a parent
			If $hitem Then ;only move a kid
				GUICtrlSendToDummy ($dummy,$DR_BEGINDRAG) 
			EndIf
		EndIf
	Else
		$dropflag=0
		$droptime=0
    EndIf
  EndIf
EndFunc

;drag a control around treeview until primary mouse button is released, if child was draged into
;different parrent group then create new child and delete old child.
;orginally in a msg loop....trying it this way for now
;On Entry: Treeview control ID, control ID to drag 
;On Exit: new child control ID else 0
Func TV_DoDrag($TreeView,$dragctrl,$finisheddrag)
 Local $msg,$i,$x,$curkid,$hscroll,$vscroll,$hitemm,$dtime
 Local $left,$top,$width,$height,$htime,$hlast,$state,$isdrag
 CONST $EXWAIT=800
 CONST $TVIS_EXPANDED=	32
 CONST $DRAGFINISHED=2	;$GUI_EVENT_PRIMARYUP ;could use varables instead then use either button to drag
 $isdrag=1
 $x=ControlGetPos("","",$TreeView)
 If NOT @error Then
  $dtime=0
  $hlast=0
  $left=$x[0]
  $top=$x[1]
  $width=$x[2]
  $height=$x[3]
  $curkid=GUICtrlRead($TreeView,1)
  GUISetState(@SW_LOCK,$winhandle)
	Do
	  sleep(10)	;$amsg=GUIGetMsg()  ;cuts down on cpu cycles
	  $msg = GUIGetCursorInfo($winHandle)
	If NOT @error Then
	  If $dtime=0 And $msg[$DRAGFINISHED]=0 Then $dtime=TimerInit()
	    $vscroll=-1
		$hscroll=-1
		Select
		Case $msg[1]<$top	
			$msg[1]=$top
			$vscroll=$SB_LINEUP 
		Case $msg[1]>$top+$height
			$msg[1]=$top+$height
			$vscroll=$SB_LINEDOWN 
		EndSelect
		Select
		Case $msg[0]<$left ;x
			$hscroll=$SB_LINELEFT
			$msg[0]=$left
		Case $msg[0]>$left+$width
			$hscroll=$SB_LINERIGHT 
			$msg[0]=$left+$width
		EndSelect
		GUISetState(@SW_UNLOCK,$winhandle)
		If $hscroll<>-1 or $vscroll<>-1 Then
			GUICtrlSetState($dragctrl,$GUI_HIDE)
			If $hscroll<>-1 Then  GUICtrlSendMsg($TreeView,$WM_HSCROLL,$hscroll,0)
			If $vscroll<>-1 Then GUICtrlSendMsg($TreeView,$WM_VSCROLL,$vscroll,0) 
			GUICtrlSetState($dragctrl,$GUI_SHOW)
		EndIf
		 GuiCtrlSetPos( $dragctrl, $msg[0],  $msg[1])
		 $hitem=TV_Hittest($Treeview, $msg[0],  $msg[1],$TVHT_ONITEMRIGHT,0)
		 If $hitem=$hlast And $htime=0 Then
			 $htime=TimerInit()
		 ElseIf $hitem=$hlast And TimerDiff($htime)>$EXWAIT Then
			If $hitem Then
			 $state=GUICtrlSendMsg($TreeView,$TVM_GETITEMSTATE,$hitem,$TVIS_EXPANDED)
			  IF NOT GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem) Then	;only send expand if root parent
				IF  NOT BitAND($state,$TVIS_EXPANDED) Then 
					$state= $TVE_EXPAND
				Else
					$state=$TVE_COLLAPSE
				EndIf
				GUICtrlSetState($dragctrl,$GUI_HIDE)
				GUICtrlSendMsg($TreeView,$TVM_EXPAND,$state,$hitem)
				GUICtrlSetState($dragctrl,$GUI_SHOW)
				$htime=0
			 EndIf
			EndIf 
		 EndIf
		 GUISetState(@SW_LOCK,$winhandle) 
		 If $hitem Then
			GUICtrlSendMsg($Treeview,$TVM_SELECTITEM ,$TVGN_DROPHILITE,$hitem)
		 Else
			GUICtrlSendMsg($Treeview,$TVM_SELECTITEM ,$TVGN_DROPHILITE,0)
		EndIf
		If $hitem<>$hlast And $hitem<>0 Then 
			$hlast=$hitem
			$htime=0
		EndIf
		$isdrag=$msg[$DRAGFINISHED]
	 EndIf
	Until NOT $isdrag And TimerDiff($dtime)>30
	GUISetState(@SW_UNLOCK,$winhandle)
	GUICtrlSendMsg($Treeview,$TVM_SELECTITEM ,$TVGN_DROPHILITE,0) ;turn off droplite
	GUICtrlDelete($dragctrl) 
	If IsArray($msg) Then $hitem=TV_Hittest($Treeview, $msg[0],  $msg[1],$TVHT_ONITEMRIGHT,0)
	GUICtrlSendToDummy($finisheddrag,$hitem) ;send control handle to dummy
 EndIf
EndFunc

;On Entry: Treeview control ID
;On Exit: new control ID else 0
Func TV_DropFIle($Treeview)
 Local $mouse,$hitem,$hpar,$id,$cnt,$parid
   $tmp=@GUI_DRAGFILE
;just playing here, do not want path in treeview
   $tmp=Stringmid($tmp, StringInStr($tmp, '\',0, -1)+1,-1)
   If $tmp="" Then  $tmp=@GUI_DRAGFILE ;drive was dropped
;
  $id=0
 GUISetState(@SW_RESTORE ,$winhandle) ;make sure GUI has focus or will get an error
  $mouse = GUIGetCursorInfo($winHandle)
		If NOT  @error Then
			$hitem=TV_Hittest($Treeview,$mouse[0],$mouse[1],$TVHT_ONITEMRIGHT,0)
			If $hitem Then
				$hpar=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem)
				If $hpar=0 Then $hpar=$hitem 
				$parid=GetparentID($parents,$hpar)
				$id=GUICtrlCreateTreeViewItem($tmp,$parid) 
				If $id Then
					$cnt=$kids[0][0]
					UBArray($kids)
					$kids[$cnt][$KID_CTRLID]=$id
					$kids[$cnt][$KID_PARID]=$parid
					$kids[$cnt][$KID_NAME]=$tmp
					$cnt=$cnt+1
					$kids[0][0]=$cnt
					GUICtrlSetState($id,$GUI_FOCUS) ;show new kid and expand parent if not
					GUICtrlSendMsg($TreeView,$TVM_SORTCHILDREN ,0,$hpar) ;wParam (3rd parameter) a bool to recurse or not
					GUICtrlSendMsg($TreeView,$WM_HSCROLL,$SB_LEFT ,0) 
				EndIf
			EndIf
		EndIf
  Return $id
EndFunc

Func TV_ShowContextMenu($Treeview,$hitem)
 Local $hpar
	$hpar=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem)
	If $hitem Then 
		If $fromkidID=-1  Or $hpar=$hfromparent Or $hitem=$hfromparent Then
			GUICtrlSetState($contexPaste,$GUI_DISABLE)
			GUICtrlSetState($contexPPaste,$GUI_DISABLE)
		Else
			GUICtrlSetState($contexPaste,$GUI_ENABLE)
			GUICtrlSetState($contexPPaste,$GUI_ENABLE)
		EndIf
		If $hpar Then 
			 ShowMenu($winHandle,$kidMenu,$Treeview)  
		Else 
			 ShowMenu($winHandle,$parMenu,$Treeview)  
		EndIf	
	EndIf
EndFunc

Func TV_Cut($Treeview)
	TV_SetEdit($Treeview,$ED_CUT)
EndFunc

Func TV_Copy($Treeview)
	TV_SetEdit($Treeview,$ED_COPY)
EndFunc

Func TV_SetEdit($Treeview,$edflag)
 Local $hitem,$hpar
	$fromkidID=-1
	$editflag=0
	$hitem=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_CARET,0)
	$hpar=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem) ;returns 0 if hitem is a parent
	If $hpar Then ; if a parent then hitem is a child...no cut or copying a parent
		$hitem=GUICtrlRead($TreeView)
		$fromkidID=$hitem
		$hfromparent=$hpar
		$editflag=$edflag
	EndIf
EndFunc

;paste item into current parent group
;On Entry: Treeviw control 
;On Exit new item contril ID else 0
Func TV_Paste($Treeview,$x,$y)
 Local $hitem,$hpar,$curkid,$parid,$id,$index
	$id=0
    If $fromkidID=-1 Then Return 0
	$hitem=TV_Hittest($Treeview,$x,$y,$TVHT_ONITEMRIGHT,0)
	If NOT $hitem Then  return 0
	$hpar=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem) 
	If NOT $hpar Then $hpar=$hitem
	$parid=GetparentID($parents,$hpar)
	If $hpar=$hfromparent Then Return 0
	$index=GetKidIndex($kids,$fromkidID)
	$id=GUICtrlCreateTreeViewItem($kids[$index][$KID_NAME],$parid)
	If $id Then	GUICtrlSetState($id,$GUI_FOCUS)
	GUICtrlSendMsg($TreeView,$TVM_SORTCHILDREN ,0,$hpar) 
	$cnt=$kids[0][0]
	 UBArray($kids)
	 ARRAYCopy($kids,$index,$cnt)
	 $kids[0][0]=$kids[0][0]+1
	 $kids[$cnt][$KID_PARID]=$parid
	 $kids[$cnt][$KID_CTRLID]=$id
	If $editflag=$ED_CUT Then 
		GUICtrlDelete($fromkidID)
		DeleteArrayItem($kids,$index)
		$editflag=0
		$fromkidID=-1
	EndIf
	Return $id
EndFunc

Func ExpandCollaspe($state)
 Local $i,$hitem
  For $i=0 To $parents[0][0]-1
	$hitem=GUICtrlGetHandle($parents[$i][$PAR_CTRLID])
	GUICtrlSendMsg($ClassTreeView,$TVM_EXPAND,$state,$hitem)
 Next ;i
 $hitem=GUICtrlSendMsg($ClassTreeView,$TVM_GETNEXTITEM,$TVGN_CARET,0)
 GUICtrlSendMsg($ClassTreeView,$TVM_ENSUREVISIBLE,0,$hitem)
EndFunc

Func ARRAYCopy(ByRef $array,$src,$dest)
 Local $i,$ar_cells,$cnt
  $cnt=$array[0][0] ;preserve count
  $ar_cells=UBound($array,2)
 For $i=1 To $ar_cells-1
	  $array[$dest][$i]=$array[$src][$i]
  Next ;i
  $array[0][0]=$cnt
EndFunc
  
Func UBArray(ByRef $array)
 Local $cells,$ar_cells,$cnt
 CONST $AR_BUMP=10
 CONST $AR_MIN=2
  $cnt=$array[0][0]	
  $cells=UBound($array,1)
  $ar_cells=UBound($array,2)
  If $cnt+$AR_MIN>$cells Then  ReDim $array[$cells+$AR_BUMP][$ar_cells]
EndFunc

;simple move left...slow with big arrays...might try and write node routines
Func DeleteArrayItem(ByRef $array,$index)
 local $i,$x,$ar_cells,$numitems,$cnt
	$cnt=$array[0][0]
 	$ar_cells=UBound($array,2)
	$numcells=UBound($array,1)
	If $numcells <=$cnt Then ReDim $array[$cnt+1][$ar_cells]
 	If $cnt Then
		If $cnt>1 then
			For $i=$index To $cnt-1
				For $x=1 To $ar_cells-1 
					$array[$i][$x]=$array[$i+1][$x]
				Next ;x
			Next ;i
		EndIf
	$cnt=$cnt-1
EndIf
 $array[0][0]=$cnt
EndFunc

;delete current item
Func TV_DeleteItem($Treeview)
 Local $id,$parid,$x,$i	
 $id=GUICtrlRead($TreeView,1)
 If NOT @error Then
 If MsgBox(36,"Delete Item","Delete " &$id[0]&" ?")=7 Then Return
 If $id[1]=$fromkidID Then 
	 $fromkidID=-1
	 GUICtrlSetState($contexPaste,$GUI_DISABLE); to allow drag and dropping
 EndIf	 
 $parid=GetKidParent($kids,$id[1])
 ;the folowing is slow with large arrays but ok for an example
 $x=$id[1]
 If NOT $parid Then
	For $i= $kids[0][0]-1 To 0 Step -1
	 If $x=$kids[$i][$KID_PARID] Then DeleteArrayItem($kids,$i)
	Next ;i
	$i=GetParentIndex($parents,$id[1])
	DeleteArrayItem($parents,$i)
 Else
	$i=GetKidIndex($kids,$id[1])
	DeleteArrayItem($kids,$i)
 EndIf
 EndIf
 GUICtrlDelete($id[1]) 
EndFunc

;just test to see if mouse positions passed will hit a treeview item if it does then set focus 
;On Entry: control id of treeview,  mouse x and y positions to test, and optional exclude hit area and no foucs
;on Eixt:  handle to control if a hit...else 0
;should be easy to modify and use with listviews, which i have yet to play with
Func TV_Hittest($TreeView,$x,$y,$nohit=0,$focus=1)
 Local $i,$hitinfo,$hit,$tpos
 $i=0
 ;get top and left positions of treeview control
 $tpos=ControlGetPos("","",$TreeView)
 If NOT @error Then
	$x=$x-$tpos[0]  ;left offset
	$y=$y-$tpos[1]	;$top offset 
	$hitinfo=DllStructCreate("int;int;uint;uint") ;not sure if uint or ptr should go here...will look it up..32 bits is 32 bits
	If NOT @error Then 
		DllStructSetData($hitinfo,1,$x)
		DllStructSetData($hitinfo,2,$y)
		DllStructSetData($hitinfo,3,0)
		DllStructSetData($hitinfo,4,0)
		GUICtrlSendMsg($TreeView,$TVM_HITTEST,0,DllStructGetPtr($hitinfo))
		$hit=DllStructGetData ($hitinfo,3) ;flags returned
		$i= DllStructGetData ($hitinfo,4) ;handle
		$hitinfo=0	;DllStructDelete($hitinfo) ; seems no DllStructDelete in beta version 1.99
		If BitAND($hit,$nohit) Then Return 0
		If  BitAND($hit,$TEST)=0 Then return 0 
		If $i And $focus<>0 Then GUICtrlSendMsg($TreeView,$TVM_SELECTITEM,$TVGN_CARET,$i) 
	EndIf
 EndIf
 Return $i ;return control handle if any
EndFunc

Func GetKidParent($achild,$kid)
 Local $i
	For $i=0 To $achild[0][0]-1
	  If $achild[$i][$KID_CTRLID]=$kid Then Return $achild[$i][$KID_PARID]
	Next ;i
 return 0
EndFunc

Func GetKidID($achild,$hkid)
 Local $i,$hitem
	For $i= 0 To $achild[0][0]-1
		$hitem=GUICtrlGetHandle($achild[$i][$KID_CTRLID])
		If $hitem=$hkid Then Return $achild[$i][$KID_CTRLID] 
	Next ;
 Return 0
EndFunc

Func GetKidIndex($achild,$kidid)
 Local $i
  For $i=0 To $achild[0][0]-1
	If $achild[$i][$KID_CTRLID]=$kidid Then Return $i
  Next ;i
 Return 0
EndFunc

Func GetParentIndex($achild,$id)
 Local $i
  For $i=0 To $achild[0][0]-1
	If $achild[$i][$PAR_CTRLID]=$id Then Return $i
  Next ;i
 Return 0
EndFunc

Func GetparentID($aparents,$hpar)
 Local $i,$hitem
  For $i=0 To $parents[0][0]-1
	$hitem=GUICtrlGetHandle($aparents[$i][$PAR_CTRLID]) ;could use kid array 
	If $hitem=$hpar Then Return $aparents[$i][$PAR_CTRLID]
	Next ;i
	Return 0
EndFunc

Func SetUpTreeview()
 Local $i,$x,$parent,$kid,$parid,$cnt,$y
  $cnt=0
  $parent="Parent-"
  $kid="Kid-"
  For $i=0 To $NUM_PARS-1
	  $parents[$i][$PAR_NAME]=$parent &$i+1
	  $parid=GUICtrlCreateTreeViewItem($parents[$i][$PAR_NAME], $ClassTreeview)
	  $parents[$i][$PAR_CTRLID]=$parid
	For $x=0 To $NUM_KIDS-1
		$kids[$cnt][$KID_NAME]=$parent&$i+1 & "-" &$kid &$x+1
		$kids[$cnt][$KID_CTRLID]=GUICtrlCreateTreeViewItem($kids[$cnt][$KID_NAME],$parid)
		$kids[$cnt][$KID_PARID]=$parid
		$kids[$cnt][$KID_PARINDEX]=$i
		$cnt=$cnt+1
	Next ;x
Next ;i
	GUICtrlSetState($parid,$GUI_EXPAND)
$parents[0][0]=$i
$kids[0][0]=$cnt
EndFunc

;******************************************************************************************************
;copied from help file, who ever wrote these thanks much!
;modified to suit my needs
;*****************************************************************************************************
;Show a menu in a given GUI window which belongs to a given GUI ctrl
;On Entry: window handle, context menu ID and 
;optional control ID this menu belongs to, if control is not under cursor then exit without calling menu popup
;On Exit: nada
Func ShowMenu($hWnd,$nContextID,$ifunderID=0)
    Local $hMenu = GUICtrlGetHandle($nContextID)
	CONST $TPM_RIGHTBUTTON= 2
	CONST $TPM_NONOTIFY= 128
	CONST $TPM_RETURNCMD =256 ;;returns menu selection (if any) and does not send msg evenet
	GUISetState(@SW_RESTORE,$winhandle) ;in case called then user went outside menu or window area
	$arPos =GUIGetCursorInfo($hWnd) 
	If NOT @error Then
	If $ifunderID And  $arpos[4]<>$ifunderID Then Return
		Local $x = $arPos[0]+8
		Local $y = $arPos[1]+8
		ClientToScreen($hWnd, $x, $y) 
		GUISetState(@SW_LOCK,$winhandle) 
		DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int",0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
		GUISetState(@SW_UNLOCK,$winhandle)
	EndIf
EndFunc

; Convert the client (GUI) coordinates to screen (desktop) coordinates
Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
    Local $stPoint = DllStructCreate("int;int")
    DllStructSetData($stPoint, 1, $x)
    DllStructSetData($stPoint, 2, $y)
    DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))
    $x = DllStructGetData($stPoint, 1)
    $y = DllStructGetData($stPoint, 2)
    ; release Struct not really needed as it is a local 
    $stPoint = 0
EndFunc
