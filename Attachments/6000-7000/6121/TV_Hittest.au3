#include <GuiConstants.au3>

;by wiredbits 
;Treeview HitTest
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
CONST $TVM_GETNEXTITEM = ($TV_FIRST + 10)
Const $TVM_SORTCHILDREN = ($TV_FIRST + 19)
CONST $TVM_SELECTITEM =    ($TV_FIRST + 11)
CONST $TVM_SETINSERTMARK=       ($TV_FIRST + 26)
CONST $TVM_HITTEST=	($TV_FIRST+17)
CONST $TVM_CREATEDRAGIMAGE=	($TV_FIRST+18) ;i really need to read up on this, might be better than draging a control
CONST $TVGN_DROPHILITE=	8
CONST $TVM_GETBKCOLOR =($TV_FIRST+31)
CONST $TVM_GETTEXTCOLOR= ($TV_FIRST+32)
Const $TVM_SETITEM=	($TV_FIRST+13)

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
CONST $DR_MONITORDRAG=	1
CONST $DR_ISDRAG=		2
CONST $DR_CHECKSCROLL=	4
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
$killdrag= GUICtrlCreateDummy()
$kidDummy= GUICtrlCreateDummy()
$parDummy= GUICtrlCreateDummy()
$parmenu = GUICtrlCreateContextMenu ($parDummy)
$contexPDelete=GUICtrlCreateMenuitem ("Delete", $parmenu)
$contexPPaste=GUICtrlCreateMenuitem ("Paste Item", $parmenu)

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
SetUpTreeview()
 Main()
 Exit
 Func Main()
 Local $admsg,$msg,$hitem,$x
While 1
    $admsg = GuiGetMsg(1)
	$msg=$admsg[0]
  Select
	Case $msg=$killdrag
		$droptime=0
		$dropflag=0
;secondary mouse selection
    Case $msg=$GUI_EVENT_SECONDARYDOWN 
			$savex=$admsg[3]
			$savey=$admsg[4] ;save mouse positions
;force user to click on a treeview item label to get context menu...could give an optional menu if no hit
		$hitem=TV_Hittest($ClassTreeview,$savex,$savey,$TVHT_ONITEMRIGHT,0)
		If $hitem Then
			$x=GUICtrlSendMsg($ClassTreeView,$TVM_GETNEXTITEM,$TVGN_CARET,0) ;get current
			If $x<>$hitem Then GUICtrlSendMsg($ClassTreeView,$TVM_SELECTITEM,$TVGN_CARET,$hitem) ;select hit item if not already
			TV_DoContextMenu($ClassTreeView,$hitem)
		EndIf
	Case $msg=$GUI_EVENT_MOUSEMOVE
		If BitAND($dropflag,$DR_MONITORDRAG) Then
			If TV_CheckIfDrag($ClassTreeview) Then
				$hitem=GUICtrlSendMsg($ClassTreeView,$TVM_GETNEXTITEM,$TVGN_CARET,0) ;on return focus is always on child...in this example
				$hitem=GUICtrlSendMsg($ClassTreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem)
				GUICtrlSendMsg($ClassTreeView,$TVM_SORTCHILDREN ,0,$hitem) ;wParam (3rd parameter) a bool to recurse or not
				GUICtrlSendMsg($ClassTreeView,$WM_HSCROLL,$SB_LEFT ,0) ;force treeview to left
			EndIf
		EndIf
	 Case $msg=$contexCut
		TV_Cut($ClassTreeView)
	 Case $msg=$contexCopy
		TV_Copy($ClassTreeView)
	 Case $msg=$contexPaste Or $msg=$contexPPaste
		TV_Paste($ClassTreeView,$savex,$savey)
	 Case $msg=$contextDeleteItem Or $msg=$contexPDelete
		TV_DeleteItem($ClassTreeview)
	case $msg=$GUI_EVENT_DROPPED
		TV_DropFIle($ClassTreeview)
	Case $msg=$GUI_EVENT_CLOSE 
		ExitLoop
	Case $msg>$parents[0][$PAR_CTRLID] ;could check if a child ID then set flag 
		$dropflag=BitOR($dropflag,$DR_MONITORDRAG)
  EndSelect
WEnd
EndFunc

Func TV_DoContextMenu($Treeview,$hitem)
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

Func TV_CheckIfDrag($TreeView)
 Local $id,$hitem,$droplabel=0
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
				$ctrlmsg=GUICtrlRead($TreeView,1)
				$droplabel=	GuiCtrlCreateLabel($ctrlmsg[0],$mouse[0],$mouse[1],200,16,-1) 
;				$droplabel=	GUICtrlCreateIcon("shell32.dll",175,$mouse[0],$mouse[1])
				$id=TV_DoDrag($TreeView,$droplabel)
				GUICtrlDelete($droplabel)
				GUICtrlSendToDummy ($killdrag) ;msg comes after any select item from drag
				Return $id
			EndIf
		EndIf
    EndIf
  EndIf
EndFunc

;drag a control around treeview until primary mouse button is released, if child was draged into
;different parrent group then create new child and delete old child.
;orginally in a msg loop....trying it this way for now
;On Entry: Treeview control ID, control ID to drag 
;On Exit: new child control ID else 0
Func TV_DoDrag($TreeView,$dragctrl)
 Local $msg,$i,$x,$curkid,$hscroll,$vscroll,$hparent,$hitem,$hpar
 Local $left,$top,$width,$height,$dtime,$isdrag
 CONST $DRAGFINISHED=2	;$GUI_EVENT_PRIMARYUP ;could use varables instead then use either button to drag
 $hitem=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_CARET,0)
 $hparent=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem) ;returns 0 if hitem is a parent
 If NOT $hparent Then $hparent=$hitem
 $hitem=0
 $x=ControlGetPos("","",$TreeView)
 If NOT @error Then
  $left=$x[0]
  $top=$x[1]
  $width=$x[2]
  $height=$x[3]
  $curkid=GUICtrlRead($TreeView,1)
  GUISetState(@SW_LOCK,$winhandle)
  $isdrag=1
	Do
	  $amsg=GUIGetMsg()  ;cuts down on cpu cycles
	  $msg = GUIGetCursorInfo($winHandle)
	 If NOT @error Then
	  If $dtime=0 And $msg[$DRAGFINISHED]=0 Then $dtime=TimerInit() ;button release wait time
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
		 GUISetState(@SW_LOCK,$winhandle) ;windows updates scroll values during this unlock
		 $hitem=TV_Hittest($Treeview, $msg[0],  $msg[1],$TVHT_ONITEMRIGHT,0)
		 If $hitem Then
			GUICtrlSendMsg($Treeview,$TVM_SELECTITEM ,$TVGN_DROPHILITE,$hitem)
		 Else
			GUICtrlSendMsg($Treeview,$TVM_SELECTITEM ,$TVGN_DROPHILITE,0)
		EndIf
		$isdrag= $msg[$DRAGFINISHED]
		 If NOT $isdrag  And $droptime=0 then $droptime=TimerInit()
	 EndIf
	Until NOT $isdrag And TimerDiff($dtime)>30
	GUISetState(@SW_UNLOCK,$winhandle)
	GUICtrlSendMsg($Treeview,$TVM_SELECTITEM ,$TVGN_DROPHILITE,0)
	GUICtrlSetState($dragctrl,$GUI_HIDE) 
	$hitem=TV_Hittest($Treeview, $msg[0],  $msg[1],$TVHT_ONITEMRIGHT,0)
	If  $hitem=0 Then Return 0; not a hit
;the folowing does not support sub items...accurately, might play with this later
    $hpar=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem)
	If $hpar=0 Then	$hpar=$hitem
	If $hpar=$hparent Then Return 0;dropped on current parent group
	If ($curkid[1])=$fromkidID Then $fromkidID=-1 ;kill paste
	GUICtrlDelete($curkid[1])
	If $hpar Then GUICtrlSendMsg($TreeView,$TVM_SELECTITEM,$TVGN_CARET,$hpar) ;focus so can get control ID
	$hpar=GUICtrlRead($TreeView) ;get control id
;	$hpar=GetparentID($hpar) ;get parent ID without useing above two lines of code 
;housekeeping: if you are using arrays to track kids and parents adjust here
;as in...delete/add or update arrays
	$hitem=GUICtrlCreateTreeViewItem($curkid[0],$hpar)
	If $hitem Then	GUICtrlSetState($hitem,$GUI_FOCUS)
 EndIf
 Return $hitem ;return new child's control id if any
EndFunc

;On Entry: Treeview control ID
;On Exit: new control ID else 0
Func TV_DropFIle($Treeview)
 Local $mouse,$hitem,$hpar,$id
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
				GUICtrlSendMsg($TreeView,$TVM_SELECTITEM,$TVGN_CARET,$hpar)
				$id=GUICtrlRead($Treeview) 
				$id=GUICtrlCreateTreeViewItem($tmp,$id) 
				If $id Then
					GUICtrlSetState($id,$GUI_FOCUS) ;show new kid and expand parent if not
					GUICtrlSendMsg($TreeView,$TVM_SORTCHILDREN ,0,$hpar) ;wParam (3rd parameter) a bool to recurse or not
					GUICtrlSendMsg($TreeView,$WM_HSCROLL,$SB_LEFT ,0) 
				EndIf
			EndIf
		EndIf
  Return $id
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
 Local $hitem,$hpar,$curkid,$parid,$id
	$id=0
    If $fromkidID=-1 Then Return 0
	$hitem=TV_Hittest($Treeview,$x,$y,$TVHT_ONITEMRIGHT,0)
	If NOT $hitem Then  return 0
	$hpar=GUICtrlSendMsg($TreeView,$TVM_GETNEXTITEM,$TVGN_PARENT,$hitem) 
	If NOT $hpar Then $hpar=$hitem
	If $hpar=$hfromparent Then Return 0
	GUICtrlSendMsg($TreeView,$TVM_SELECTITEM,$TVGN_CARET,$hpar)
	$parid=GUICtrlRead($TreeView) ;get control id
	$curkid=GUICtrlRead($fromkidID,1) ;kid info
	$id=GUICtrlCreateTreeViewItem($curkid[0],$parid)
	If $id Then	GUICtrlSetState($id,$GUI_FOCUS)
	GUICtrlSendMsg($TreeView,$TVM_SORTCHILDREN ,0,$hpar) 
	If $editflag=$ED_CUT Then 
		GUICtrlDelete($fromkidID)
		$editflag=0
		$fromkidID=-1
	EndIf
	Return $id
EndFunc

;delete current item
Func TV_DeleteItem($Treeview)
 Local $id
 $id=GUICtrlRead($TreeView,1)
 If NOT @error Then
 If MsgBox(36,"Delete Item","Delete " &$id[0]&" ?")=7 Then Return
;if tracking with arrays then update here
 If $id[1]=$fromkidID Then 
	 $fromkidID=-1
	 GUICtrlSetState($contexPaste,$GUI_DISABLE); to allow drag and dropping
 EndIf	 
 GUICtrlDelete($id[1]) ;if a parent really should loop through all childern and delete them first:P
 EndIf
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

;return parent control ID that matches handle passed
;On Enry: handle to parent treeviewitem  control
;on Exit: control ID else 0
Func GetparentID($hpar)
 Local $i,$hitem
  For $i=0 To $parents[0][0]-1
	$hitem=GUICtrlGetHandle($parents[$i][$PAR_CTRLID]) ;could use kid array 
	If $hitem=$hpar Then Return $parents[$i][$PAR_CTRLID]
	Next ;i
	Return 0
EndFunc

;fill arrays in case someone wants to play with code
Func SetUpTreeview()
 Local $i,$x,$parent,$kid,$parid,$cnt=0,$y
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
	GUICtrlSetState($parid,$GUI_EXPAND)
Next ;i
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
	CONST $TPM_RETURNCMD =256 ;returns menu selection (if any) and does not send msg evenet
	GUISetState(@SW_RESTORE,$winhandle) ;in case called then user went outside menu or window area
	$arPos =GUIGetCursorInfo($hWnd) 
	If NOT @error Then
	If $ifunderID And  $arpos[4]<>$ifunderID Then Return
		Local $x = $arPos[0]+8
		Local $y = $arPos[1]+8
		ClientToScreen($hWnd, $x, $y) 
		GUISetState(@SW_LOCK,$winhandle) 
		DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int",$TPM_RIGHTBUTTON, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
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
