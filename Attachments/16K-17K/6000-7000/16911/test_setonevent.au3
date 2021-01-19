;#include <_EIPListView_new.au3>
#include-once
#include <GuiConstants.au3>
#include <GuiListview.au3>
#Include <GuiCombo.au3>
#Include <GuiList.au3>

;this is a modified version of my original script.  It creates a popup
;window for the control as a child window to workaround issues related to
;listviews on tabs.
;
; ------------------------------------------------------------------------------
;
; AutoIt Version: 	3.0
; Language: 		English
; Description: Multi-column editable Listview  (EditInPlace)
;					Stephen Podhajecki <gehossafats at netmdc.com/> Gary Frost <gafrost at charter dot net/>
;					pdm for control array concept
;					see http://www.autoitscript.com/forum/index.php?showtopic=42694&st=0&gopid=322551&#entry322551
;==============================================================================
;	######>>> set the type of control for each column <<<######
;	0 = Input/edit  1 = combobox 2 = date control
;	Global $LVcolControl[4]=[0,0,1,2]
;	_InitEditLib();######>>>  add this aftef your ListView <<<######
;	_MonitorEditState($Gui, $editCtrl, $editFlag, $__LISTVIEWCTRL, $LVINFO, $LVcolControl);######>>>  add this in your message loop<<<######
;	_TermEditLib();######>>>  add this after your message loop<<<######
; $__LISTVIEWCTRL = $ListView1 ######>>> Set this to your ListView control <<<######
;==============================================================================
Global  $DebugIt = 0
Global Const $WM_NOTIFY = 0x004E
Global Const $WM_KEYDOWN = 0x0100
Global Const $WM_COMMAND = 0x0111 
Global Const $LBN_SELCHANGE = 1
Global Const $LBN_DBLCLK = 2
Global Const $LBN_SETFOCUS= 4
Global Const $LBN_KILLFOCUS = 5
Global Const $EN_SETFOCUS =0x0100	
Global Const $EN_KILLFOCUS = 0x0200
Global Const $EN_CHANGE =0x0300
Global Const $EN_UPDATE =0x0400

Global Const $DTN_FIRST = -760
Global Const $DTN_DATETIMECHANGE = $DTN_FIRST + 1 ; the systemtime has changed
;~ Global Const $DTN_USERSTRINGA = $DTN_FIRST + 2    ; the user has entered a string
Global Const $DTN_WMKEYDOWNA = $DTN_FIRST + 3     ; modify keydown on app format field (X)
;~ Global Const $DTN_FORMATA = $DTN_FIRST + 4        ; query display for app format field (X)
;~ Global Const $DTN_FORMATQUERYA = $DTN_FIRST + 5   ; query formatting info for app format field (X)
Global Const $DTN_DROPDOWN = $DTN_FIRST + 6       ; MonthCal has dropped down
Global Const $DTN_CLOSEUP = $DTN_FIRST + 7        ; MonthCal is popping up
Global Const $CBN_SELCHANGE         = 1;
Global Const $CBN_DBLCLK            = 2;
Global Const $CBN_SETFOCUS            = 3;
Global Const $CBN_KILLFOCUS         = 4;
Global Const $CBN_EDITCHANGE         = 5;
Global Const $CBN_EDITUPDATE         = 6;
Global Const $CBN_DROPDOWN            = 7;
Global Const $CBN_CLOSEUP            = 8;
Global Const $CBN_SELENDOK            = 9;
Global Const $CBN_SELENDCANCEL         = 10;
  

Global Const $NM_FIRST = 0
Global Const $NM_CLICK   = ($NM_FIRST - 2)
Global Const $NM_DBLCLK  = ($NM_FIRST - 3)
Global Const $NM_RCLICK  = ($NM_FIRST - 5)
Global Const $NM_RDBLCLK = ($NM_FIRST - 6)
Global Const $NM_SETFOCUS = ($NM_FIRST - 7)
Global Const $NM_KILLFOCUS = ($NM_FIRST - 8)

Global Const $LVS_SHAREIMAGELISTS = 0x0040

;~ Global Const $LVM_FIRST = 0x1000
;~ Global Const $LVM_SETIMAGELIST = ($LVM_FIRST + 3)
;~ Global Const $LVM_GETITEM = ($LVM_FIRST + 5)
;~ Global Const $LVM_SETITEM = ($LVM_FIRST + 6)
;~ Global Const $LVM_GETNEXTITEM = ($LVM_FIRST + 12)
;~ Global Const $LVM_ENSUREVISIBLE = ($LVM_FIRST + 19)
;~ Global Const $LVM_SETITEMSTATE = ($LVM_FIRST + 43)
Global Const $LVN_FIRST = -100

Global Const $LVN_ENDLABELEDITA = (-106)
Global Const $LVN_ITEMCHANGING = ($LVN_FIRST - 0)
Global Const $LVN_ITEMCHANGED = ($LVN_FIRST - 1)
Global Const $LVN_INSERTITEM = ($LVN_FIRST - 2)
Global Const $LVN_DELETEITEM = ($LVN_FIRST - 3)
Global Const $LVN_DELETEALLITEMS = ($LVN_FIRST - 4)

Global Const $LVN_COLUMNCLICK = ($LVN_FIRST - 8)
Global Const $LVN_BEGINDRAG = ($LVN_FIRST - 9)
Global Const $LVN_BEGINRDRAG = ($LVN_FIRST - 11)

Global Const $LVN_ODCACHEHINT = ($LVN_FIRST - 13)    
Global Const $LVN_ITEMACTIVATE = ($LVN_FIRST - 14)
Global Const $LVN_ODSTATECHANGED = ($LVN_FIRST - 15)

Global Const $LVN_HOTTRACK = ($LVN_FIRST - 21)

Global Const $LVN_KEYDOWN = ($LVN_FIRST - 55)
Global Const $LVN_MARQUEEBEGIN = ($LVN_FIRST - 56)   


Global $LVCALLBACK = "_CancelEdit"  ; default to cancel edit 
Global $LVCONTEXT = "_CancelEdit"  ; defalut to cancel edit
Global $bCALLBACK = False ;a call-back has been executed.
Global $bCALLBACK_EVENT = False
Global $bLVUPDATEONFOCUSCHANGE = 1 ;save editing if another cell is clicked
Global $bLVDBLCLICK = False;
Global $bLVITEMCHECKED = False;
Global $bLVEDITONDBLCLICK = False ;Must dblclick to edit
Global $bDATECHANGED = False;
Global $LVCHECKEDCNT = 0;
Global $old_col
Global $__LISTVIEWCTRL = -999
Global $Gui, $editFlag
Global $bCanceled = False
Global $editHwnd ;= the Hwnd of the editing control.
Global $editCtrl ;= the CtrlId of the editing control.
;;array dim to number of cols, value of each element determines control.
Global $LVcolControl[1] = [0]  ;0= ignore, 1= edit, 2= combo, 4= calendar, 8 = list, 256 use callback.
Global $LVcolRControl[1] = [0] ;0= ignore, 256 = context callback.
Global $lvControlGui , $lvEdit, $lvCombo, $lvDate , $lvList
Global $LVINFO[11];
Opt("GUICloseOnESC", 0);turn off exit on esc.
;===============================================================================
; Function Name:	_InitEditLib
; Description:		Create the editing controls and registers WM_NOTIFY handler.
; Parameter(s):
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):		Call this BEFORE you create your listview.
;===============================================================================
Func _InitEditLib($lvEditStart="",$lvComboStart="",$lvDataStart="",$lvListStart="",$hParent=0)
	$lvControlGui = GuiCreate("LVCONTROL",0,0,1,1,$WS_POPUP,-1,$hParent)
	$lvEdit = GUICtrlCreateInput($lvEditStart, 0, 0, 1, 1, BitOR($ES_AUTOHSCROLL, $ES_NOHIDESEL, $WS_BORDER), 0)
	GUICtrlSetState($lvEdit, $GUI_HIDE)
	GuiCtrlSetFont($lvEdit,8.5)
	$lvCombo = GUICtrlCreateCombo($lvComboStart, 0, 0, 1, 1,-1,$WS_EX_TOPMOST)
	GUICtrlSetState($lvCombo, $GUI_HIDE)
	$lvDate = GUICtrlCreateDate($lvDataStart,0, 0, 1, 1,BitOR($GUI_SS_DEFAULT_DATE, $DTS_SHORTDATEFORMAT),BitOr($WS_EX_CLIENTEDGE,$WS_EX_TOPMOST ))
	GUICtrlSetState($lvDate, $GUI_HIDE)
	$lvList = GUICtrlCreateList($lvListStart, 0, 0, 1, 1,-1,$WS_EX_TOPMOST)
	GUICtrlSetState($lvList, $GUI_HIDE)
	GuiSetState(@SW_SHOW)
	GUIRegisterMsg($WM_NOTIFY, "WM_Notify_Events")
 	GUIRegisterMsg($WM_COMMAND,"WM_Command_Events")
EndFunc   ;==>_InitEditLib
;===============================================================================
; Function Name:	_TermEditLib
; Description:		Deletes the editing controls and un-registers WM_NOTIFY handler.
; Parameter(s):
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):		Call this when close your gui if switching to another gui.
;===============================================================================
Func _TermEditLib()
	GUICtrlDelete($lvEdit)
	GUICtrlDelete($lvCombo)
	GUICtrlDelete($lvDate)
	GuiCtrlDelete($lvList)
	GUIRegisterMsg($WM_NOTIFY, "")
 	GUIRegisterMsg($WM_COMMAND,"")
EndFunc   ;==>_TermEditLib
;===============================================================================
; Function Name:	ListView_Click
; Description:	Called from WN_NOTIFY event handler.
; Parameter(s):
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):		Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s):
;===============================================================================
Func _ListView_Click()
ConsoleWrite(_DebugHeader("_ListView_Click"))
ConsoleWrite("$editFlag="&$editFlag&@lf)
ConsoleWrite("$bLVUPDATEONFOCUSCHANGE = "&$bLVUPDATEONFOCUSCHANGE &@LF)
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then
		If $DebugIt Then ConsoleWrite(_DebugHeader("_ListView_Click"))
	EndIf
	;----------------------------------------------------------------------------------------------
	If $editFlag = 1 Then
		If $bLVUPDATEONFOCUSCHANGE = True Then
				If $editCtrl = $lvDate Then
					If $bDATECHANGED = False Then 
						_CancelEdit()
						Return
					EndIf
				EndIf
				_LVUpdate($editCtrl, $__LISTVIEWCTRL, $LVINFO[6], $LVINFO[7])
		Else
				_CancelEdit()
			EndIf
	Else
		If $bLVEDITONDBLCLICK = False Then
			sleep(10)
			_InitEdit($LVINFO, $LVcolControl)
		EndIf
	EndIf
EndFunc   ;==>ListView_Click
;===============================================================================
; Function Name:	ListView_RClick
; Description:	Called from WN_NOTIFY event handler.
; Parameter(s):
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):		Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s):
;===============================================================================
Func _ListView_RClick()
	If $editFlag = 1 Then
		Return 0
	Else
		If $LVINFO[0] < 0 Or $LVINFO[1] < 0 Then Return 0
		If $LVcolRControl[$LVINFO[1]] = 256 Then Call($LVCONTEXT,$LVINFO) ;call context call back function.
		_CancelEdit()
	EndIf
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then ConsoleWrite(_DebugHeader("$NM_RCLICK"))
	;----------------------------------------------------------------------------------------------
EndFunc   ;==>ListView_RClick
;===============================================================================
; Function Name:	ListView_DoubleClick
; Description:	Called from WN_NOTIFY event handler.
; Parameter(s):
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):			Initiates the edit process on a DblClick
;===============================================================================
Func _ListView_DoubleClick()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then ConsoleWrite(_DebugHeader("$NM_DBLCLICK"))
	;----------------------------------------------------------------------------------------------
	If $editFlag = 0 Then
		_InitEdit($LVINFO, $LVcolControl)
	Else
		_CancelEdit()
	EndIf
EndFunc   ;==>ListView_DoubleClick
; WM_NOTIFY event handler
;===============================================================================
; Function Name:	_MonitorEditState
; Description:		Handles {enter} {esc} and {f2}
; Parameter(s):	$h_gui			- IN/OUT -
;						$editCtrl		- IN/OUT -
;						$editFlag		- IN/OUT -
;						$__LISTVIEWCTRL	- IN/OUT -
;						$LVINFO	 		- IN/OUT -
;						$LVcolControl	- IN -
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func _MonitorEditState(ByRef $editCtrl, ByRef $editFlag, ByRef $__LISTVIEWCTRL, ByRef $LVINFO)
	Local $pressed = _vKeyCheck()
	If $editFlag And $pressed = 13 Then; pressed enter
		_LVUpdate($editCtrl, $__LISTVIEWCTRL, $LVINFO[0], $LVINFO[1])
	ElseIf $editFlag And $pressed = 27 Then; pressed esc
		_CancelEdit()
	ElseIf Not $editFlag And $pressed = 113 Then; pressed f2
		MouseClick("primary") ;workaround work all the time (if mouse is over the control)
		MouseClick("primary")
	EndIf

;~ 	If $editFlag and $pressed = 01 Then
;~ 		If Not(_HasFocus($editCtrl)) Then 
;~ ;		If $DebugIt Then ConsoleWrite("Control>>"&ControlGetFocus($Gui,"")&@LF)
;~ 				If $bLVUPDATEONFOCUSCHANGE Then
;~ 					_LVUpdate($editCtrl, $__LISTVIEWCTRL, $LVINFO[0], $LVINFO[1])
;~ 				Else
;~ 					_CancelEdit()
;~ 				EndIf
;~ 		EndIf
;~ 	EndIf
EndFunc   ;==>_MonitorEditState
Func Enter()
	; just a dummy function
EndFunc   ;==>Enter
;===============================================================================
; Function Name:	_LVUpdate
; Description:		Put the new data in the Listview
; Parameter(s):	$editCtrl		 - IN/OUT -
;						$__LISTVIEWCTRL	 - IN/OUT -
;						$iRow				 - IN -
;						$iCol				 - IN -
;
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func _LVUpdate(ByRef $editCtrl, ByRef $__LISTVIEWCTRL, $iRow, $iCol)
;	If $DebugIt Then ConsoleWrite("_LVUpdate>>"&@LF)
	if $bCanceled then Return
	Local $newText = GUICtrlRead($editCtrl)
	If $editCtrl = $lvList or $editCtrl = $lvCombo Then
		If $newText <> "" Then
		_GUICtrlListViewSetItemText($__LISTVIEWCTRL, $iRow, $iCol, $newText)
		EndIf
	Else
		_GUICtrlListViewSetItemText($__LISTVIEWCTRL, $iRow, $iCol, $newText)
	EndIf
	$LVINFO[6] = $iRow
	$LVINFO[7] = $iCol
	_CancelEdit()
EndFunc   ;==>_LVUpdate
;===============================================================================
; Function Name:	_GUICtrlListViewGetSubItemRect
; Description:	 Get the bounding rect of a listview item
; Parameter(s):	$h_listview	- IN -
;						$row			- IN -
;						$col		 	- IN -
;						$aRect		- IN/OUT -
;
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func _GUICtrlListViewGetSubItemRect($h_listview, $row, $col, ByRef $aRect)
	Local $rectangle, $rv,$ht[4]
	$rectangle = DllStructCreate("int;int;int;int") ;left, top, right, bottom
	DllStructSetData($rectangle, 1, $LVIR_BOUNDS)
	DllStructSetData($rectangle, 2, $col)
	If IsHWnd($h_listview) Then
		Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listview, "int", $LVM_GETSUBITEMRECT, "int", $row, "ptr", DllStructGetPtr($rectangle))
		$rv = $a_ret[0]
	Else
		$rv = GUICtrlSendMsg($h_listview, $LVM_GETSUBITEMRECT, $row, DllStructGetPtr($rectangle))
	EndIf
		ReDim $aRect[4]
		$aRect = $ht
		$aRect[0] = DllStructGetData($rectangle, 1)
		$aRect[1] = DllStructGetData($rectangle, 2)
		$aRect[2] = DllStructGetData($rectangle, 3)
		$aRect[3] = DllStructGetData($rectangle, 4) - $aRect[1]
	$rectangle = 0
	Sleep(10)
	Return $rv
EndFunc   ;==>_GUICtrlListViewGetSubItemRec
;===============================================================================
; Function Name:	_InitEdit
; Description:		Bring forth the editing control and set focus on it.
; Parameter(s):	$LVINFO		 	- IN -
;						$LVcolControl	- IN -
;
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func _InitEdit($LVINFO, $LVcolControl)
	;ConsoleWrite("_InitEdit>>"&@LF)
	If $bCanceled  Then
		$bCanceled = False
		Return
	EndIf
	if $bCALLBACK Then
		_CancelEdit()
		$bCALLBACK = False
	EndIf
	
	If $editFlag = 1 Then _CancelEdit()
	Local $CtrlType
	If $LVINFO[0] < 0 Or $LVINFO[1] < 0 Then Return 0
	If UBound($LVcolControl) - 1 < $LVINFO[1] Then
		$CtrlType = 0
	Else
		$CtrlType = $LVcolControl[$LVINFO[1]]
	EndIf
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then ConsoleWrite(_DebugHeader("$CtrlType:" & $CtrlType))
	;----------------------------------------------------------------------------------------------
	Switch $CtrlType
		Case 1
			GUICtrlSetData($lvEdit, "")
			$editCtrl = $lvEdit
		Case 2
			$editCtrl = $lvCombo
		Case 4
			$editCtrl = $lvDate
		Case 8
			$editCtrl = $lvList
		Case 256
			$bCALLBACK= True
		Case Else
			Return
	EndSwitch
	If $bCALLBACK Then
		$bCALLBACK = False
		$bCALLBACK_EVENT =True
	Else
		;----------------------------------------------------------------------------------------------
		If $DebugIt Then ConsoleWrite(_DebugHeader("Classname="&_GetClassName($editCtrl)))
		;----------------------------------------------------------------------------------------------
		Local $editCtrlPos = _CalcEditPos($__LISTVIEWCTRL,$LVINFO)
		Local $x1 , $y1
		ClientToScreen($Gui,$x1,$y1)
		WinMove($lvControlGui,"", $editCtrlPos[0]+($x1-1),$editCtrlPos[1]+($y1-1), $editCtrlPos[2],$editCtrlPos[3])
;		GUICtrlSetPos($editCtrl, $editCtrlPos[0],$editCtrlPos[1], $editCtrlPos[2],$editCtrlPos[3])
		GUICtrlSetPos($editCtrl, 0,0, $editCtrlPos[2],$editCtrlPos[3])
		Local $oldText = _GUICtrlListViewGetItemText($__LISTVIEWCTRL, $LVINFO[0], $LVINFO[1])
		If $DebugIt Then ConsoleWrite($oldText&@LF)
		GUICtrlSetState($__LISTVIEWCTRL,$GUI_NOFOCUS)
		If $DebugIt Then ConsoleWrite(_GetClassName($editCtrl)&@LF)
		Switch $editCtrl
			Case $lvList
				If $oldText <> "" Then 	GUICtrlSetData($editCtrl, $oldText)
			Case $lvCombo
				If $oldText <> "" Then
					Local $index = _GUICtrlComboFindString($editCtrl,$oldText)
					If $DebugIt Then ConsoleWrite("index="&@LF)
					If ($index = -1) Then $index = _GUICtrlComboAddString($editCtrl,$oldText)
					_GUICtrlComboSetCurSel($editCtrl,$index)
					GUICtrlSetState($editCtrl,$GUI_ONTOP)
				EndIf
			Case Else	
				GUICtrlSetData($editCtrl, $oldText)
		EndSwitch
		$editFlag = 1
		
		GUICtrlSetState($__LISTVIEWCTRL,$GUI_NOFOCUS)
		If $DebugIt Then ConsoleWrite("Set pos"&@LF)
		WinMove($lvControlGui,"", $editCtrlPos[0]+($x1-1),$editCtrlPos[1]+($y1-1), $editCtrlPos[2]+1,$editCtrlPos[3]+1)
		WinSetOnTop($lvControlGui,"",1)
		GUISetState(@SW_SHOW,$lvControlGui)
;~ 	GUICtrlSetPos($editCtrl, $editCtrlPos[0],$editCtrlPos[1], $editCtrlPos[2],$editCtrlPos[3])
;~ 	GUICtrlSetState($editCtrl, $GUI_SHOW)
		GUICtrlSetPos($editCtrl, 0,0, $editCtrlPos[2],$editCtrlPos[3])
		GUICtrlSetState($editCtrl, $GUI_SHOW)
		GUICtrlSetState($editCtrl, $GUI_FOCUS)
		EndIf
		If $DebugIt Then ConsoleWrite("Leaving _InitEdit()"&@LF)
EndFunc   ;==>_InitEdit
Func _CalcEditPos($nLvCtrl,$aINFO)
	   Local $pos[4]
		Local $ctrlSize = ControlGetPos("","",$nLvCtrl)
		$pos[0] = $aINFO[2]
		$pos[1] = $aINFO[3]+3
		$pos[2] = $aINFO[4]
		$pos[3] = $aINFO[5]-4
		
		If $aINFO[2]+$aINFO[4] > $ctrlSize[2] Then
			$pos[0] = $aINFO[2] - (($aINFO[2]+$aINFO[4])- $ctrlSize[2])
		EndIf
		If $editCtrl = $lvList Then
			;make the list fit inside the ListView.
			Local $initH = (_GUICtrlListCount($lvList)*14.5)*(_GUICtrlListCount($lvList)*14.5 >0)
			Local $y1 = $ctrlSize[3] - $aINFO[3] -21 
			$y1 =  $y1* ($y1>21)
			If $initH < $y1 Then
				$pos[3]= $initH
			Else
				$pos[3] =$y1
			EndIf
			
		EndIf
		If _LvHasCheckStyle($__LISTVIEWCTRL) And $aINFO[1]= 0 And $editCtrl = $lvEdit  Then
			;compensate for check box
			$pos[2] = $aINFO[4]-21
			$pos[0] = $aINFO[2]+21
		EndIf
	Return $pos
EndFunc

;===============================================================================
; Function Name:	_CancelEdit
; Description:		Cancels the editing process, and kills the hot keys.
; Parameter(s):
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func _CancelEdit()
	;ConsoleWrite("_CancelEdit>>"&@LF)
	HotKeySet("{Enter}")
	HotKeySet("{Esc}")
	if $editFlag = 1 then Send("{Enter}");quit edit mode
	$editFlag = 0
	WinSetOnTop($lvControlGui,"",0); remove topmost attrib
	WinMove($lvControlGui,"",1024,768,1,1);move to bottom right corner
	GUISetState(@SW_Hide,$lvControlGui); additionally hide it
	GUICtrlSetState($editCtrl, $GUI_HIDE)
	GUICtrlSetPos($editCtrl, 50,50, 1, 1)
	$bCanceled = True
	$bDATECHANGED = False
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then ConsoleWrite(_DebugHeader("_CancelEdit()"))
	;----------------------------------------------------------------------------------------------
	if Not(WinActive($Gui,"")) Then WinActivate($Gui,"")
EndFunc   ;==>_CancelEdit
;===============================================================================
; Function Name:	_FillLV_Info
; Description:		This fills the passed in array with row col and rect info for
;						used by the editing controls
; Parameter(s):	$__LISTVIEWCTRL	- IN/OUT -
;						$iRow		 		- IN -
;						$iCol		 		- IN -
;						$aLVI		 		- IN/OUT -
;
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func _FillLV_Info(ByRef $nLvCtrl, $iRow, $iCol, ByRef $aLVI,$iFlag = 1)
	If $iFlag Then
		$aLVI[6] = $aLVI[0]	;set old row
		$aLVI[7] = $aLVI[1]	;set old col
		$aLVI[0] = $iRow		;set new row
		$aLVI[1] = $iCol		;set new col
	EndIf
	If $iRow < 0 Or $iCol < 0 Then Return 0
	Local $lvi_rect[4], $pos = ControlGetPos($Gui, "", $nLvCtrl)
	_GUICtrlListViewGetSubItemRect($nLvCtrl, $iRow, $iCol, $lvi_rect)
	$aLVI[2] = $pos[0] + $lvi_rect[0] + 5
	$aLVI[3] = $pos[1] + $lvi_rect[1]
	$aLVI[4] = _GUICtrlListViewGetColumnWidth($nLvCtrl, $iCol) - 4
	$aLVI[5] = $lvi_rect[3] + 5
	Sleep(10)
	Return 1
EndFunc   ;==>_FillLV_Info

;===============================================================================
; Function Name:	WM_Notify_Events
; Description:		Event handler for windows WN_NOTIFY messages
; Parameter(s):	$hWndGUI		 - IN -
;						$MsgID		 - IN -
;						$wParam		 - IN -
;						$lParam		 - IN -
;
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func WM_Notify_Events($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID, $wParam
	Local $tagNMHDR, $pressed,$event, $retval = $GUI_RUNDEFMSG ;, $idFrom
	$tagNMHDR = DllStructCreate("int;int;int", $lParam);NMHDR (hwndFrom, idFrom, code)
	If @error Then
		$tagNMHDR =0
		Return
	EndIf
	;$from = DllStructGetData($tagNMHDR, 1)
	;$idFrom = DllStructGetData($tagNMHDR,2)
	;ConsoleWrite("idFrom="&$idFrom&@LF)
	$event = DllStructGetData($tagNMHDR, 3)
	Select
		Case $wParam = $__LISTVIEWCTRL
			Select
				Case $event = $LVN_ITEMCHANGED
				Local $ckcount = _LvGetCheckedCount($__LISTVIEWCTRL)
					If $LVCHECKEDCNT <> $ckcount Then
						$LVCHECKEDCNT = $ckcount
						$bLVITEMCHECKED = True
						_CancelEdit()
					EndIf

				Case $event = $NM_CLICK
					_LVGetInfo($lParam)
					;scroll column into view.
					Switch $LVINFO[1]
					Case 0
						_GUICtrlListViewScroll ( $__LISTVIEWCTRL, -$LVINFO[4], 0 )
						_FillLV_Info($__LISTVIEWCTRL, $LVINFO[8], $LVINFO[9], $LVINFO,0)
						;_LVGetInfo($lParam)
					Case Else
						Local $ctrlSize = ControlGetPos("","",$__LISTVIEWCTRL)
						If $LVINFO[2]+$LVINFO[4] > $ctrlSize[2] Then
						_GUICtrlListViewScroll ( $__LISTVIEWCTRL, $LVINFO[4], 0 )
						_FillLV_Info($__LISTVIEWCTRL, $LVINFO[8], $LVINFO[9], $LVINFO,0)
						EndIf
					EndSwitch
					if Not $bLVITEMCHECKED Then 
						_ListView_Click()
					EndIf
				$bLVITEMCHECKED = False;
				Case $event = $NM_DBLCLK
					_LVGetInfo($lParam)
					_ListView_DoubleClick()
				Case $event = $NM_RCLICK
					_LVGetInfo($lParam)
					_ListView_RClick()
				Case $event = -180
					If $DebugIt Then ConsoleWrite("LVEVENT=-180"&@LF)
					If $editFlag = 1 Then
						Send("{Esc}")
						_CancelEdit()
						$retval = 0
					EndIf
				Case $event = -181
					If $DebugIt Then ConsoleWrite("LVEVENT=-181"&@LF)
					_FillLV_Info($__LISTVIEWCTRL, $LVINFO[0], $LVINFO[1], $LVINFO,0)
				Case $event= -121
					If $DebugIt Then ConsoleWrite("LVEVENT=-121"&@LF)
					_LVGetInfo($lParam,1)
				Case Else
					If $DebugIt Then ConsoleWrite("LV_EVENT>>"&$event&@LF)
			EndSelect
		Case $lvDate
			Select
				Case $event = $DTN_DROPDOWN
					$bCanceled = False
					$bDATECHANGED = False
				Case $event = $DTN_WMKEYDOWNA
					$pressed = _vKeyCheck()
					If $pressed = 27 Then _CancelEdit()
				Case $event = $DTN_DATETIMECHANGE
					If $DebugIt Then ConsoleWrite("DTN_DATETIMECHANGE"&@LF)					
					If $bDATECHANGED = False Then $bDATECHANGED = True
					$pressed = _vKeyCheck()
					if $pressed = 27 Then
						_CancelEdit()
						$bDATECHANGED = False
					EndIf
				Case $event = $DTN_CLOSEUP
					If $DebugIt Then ConsoleWrite("DTN_CLOSEUP"&@LF)			
					if $bCanceled or ($bDATECHANGED = False) Then 
						Send("{Esc}")
						$bDATECHANGED = False
					Else
;						If $bLVUPDATEONFOCUSCHANGE = True Then
							Send("{Enter}")
							$bDATECHANGED = True
;						Else
;							Send("{Esc}")
;						EndIf
					EndIf
				case $event = -7
					If $DebugIt Then ConsoleWrite("dtn $event="&$event&@LF)
					$bCanceled = False
					$bDATECHANGED = False
				Case $event = -8
					If $DebugIt Then ConsoleWrite("dtn $event="&$event&" , ")
					If $DebugIt Then ConsoleWrite("$bCanceled="&$bCanceled&@LF)
					If $DebugIt Then ConsoleWrite("$bDATECHANGED="&$bDATECHANGED&@LF)
					if $bCanceled = True Then
						;or ($bDATECHANGED = False) Then 
						Send("{Esc}")
						$bDATECHANGED = False
						$bCanceled = False
					Else
						$bDATECHANGED = True
					EndIf
				EndSelect
		Case $MsgID = $WM_KEYDOWN
			;----------------------------------------------------------------------------------------------
			If $DebugIt Then ConsoleWrite(_DebugHeader("Keydown"))
			;----------------------------------------------------------------------------------------------
		Case Else
			If $DebugIt Then ConsoleWrite("WPARAM = "&$wParam&@LF)
					;;uncomment the following line to have the edit _LVUpdate if the mouse moves
			;;off of the listview.
			;If $editFlag And Not(_HasFocus($editCtrl)) Then _LVUpdate($editCtrl, $__LISTVIEWCTRL, $LVINFO[0], $LVINFO[1])
	EndSelect
	$tagNMHDR = 0
	$event = 0
	$lParam = 0
	Return $retval
EndFunc   ;==>WM_Notify_Events
;===============================================================================
; Function Name:	WM_Command_Events
; Description:		Event handler for windows WN_Command messages
; Parameter(s):	$hWndGUI		 - IN -
;						$MsgID		 - IN -
;						$wParam		 - IN -
;						$lParam		 - IN -
;
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func WM_Command_Events($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID, $wParam
	Local $nNotifyCode, $nID,$hCtrl
	Local $retval = $GUI_RUNDEFMSG 
    $nNotifyCode    = BitShift($wParam, 16)
    $nID            = BitAnd($wParam, 0x0000FFFF)
    $hCtrl          = $lParam
	   Switch $nID 
		  Case  $lvList
			Switch $nNotifyCode  
				Case $LBN_DBLCLK
					$bLVDBLCLICK = True
					Send("{Enter}")
					_SendMessage($Gui,$WM_COMMAND,_MakeLong($editCtrl,$LBN_SELCHANGE),$lParam)
					Return $GUI_RUNDEFMSG
				Case $LBN_SELCHANGE
				If $DebugIt Then ConsoleWrite("$LBN_SELCHANGE"&@LF)
					If Not $bLVDBLCLICK Then Return 0 
				Case $LBN_SETFOCUS
					If $DebugIt Then ConsoleWrite("$LBN_SETFOCUS"&@LF)
				Case $LBN_KILLFOCUS
					If $DebugIt Then ConsoleWrite("$LBN_KILLFOCUS"&@LF)	
				Case Else
					If $DebugIt Then ConsoleWrite("ListBox>>"&$nNotifyCode&@LF)
			EndSwitch
		Case $lvCombo
			Switch $nNotifyCode
				Case $CBN_SELCHANGE
					If $DebugIt Then ConsoleWrite("$CBN_SELCHANGE"&@LF)
					Send("{Enter}")
			EndSwitch
		Case Else
			If $DebugIt Then ConsoleWrite("$nId="&$nId&@lf)
	EndSwitch
	If $hCtrl = _GetComboInfo($lvCombo) And $DebugIt Then ConsoleWrite("$MsgID="&$MsgID&@LF)
	If $bCanceled  then
		$bCanceled = 0 
		$retval = 0
	EndIf
					
Return $retval
EndFunc

;===============================================================================
; Function Name	:	_MakeLong
; Description		:	Converts two 16 bit values into on 32 bit value
; Parameter(s)		:	$LoWord		 16bit value 
;						:	$HiWord		 16bit value
; Return Value(s)	:	Long value
; Note(s)			:	
;===============================================================================
Func _MakeLong($LoWord,$HiWord)
  Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc

;===============================================================================
; Function Name	:	_LVGetInfo
; Description		:	
; Parameter(s)		:	$lParam		 Pointer to $tagNMITEMACTIVE struct
;							$iFlag		 Optional value 0 (default)= fill all fields
;																 1 = fill just the latest click location.												 
; Requirement(s)	:	
; Return Value(s)	:	
; User CallTip		:	
; Author(s)			:	
; Note(s)			:	
;===============================================================================
Func _LVGetInfo($lParam,$iFlag =0 )
	Local $tagNMITEMACTIVATE = DllStructCreate("int;int;int;int;int;int;int;int;int", $lParam)
	Local $clicked_row = DllStructGetData($tagNMITEMACTIVATE, 4)
	Local $clicked_col = DllStructGetData($tagNMITEMACTIVATE, 5)
	if $clicked_col < -1 then $clicked_col = -1 
	if $clicked_row < -1 then $clicked_row = -1 
	if $clicked_col > _GUICtrlListViewGetSubItemsCount($__LISTVIEWCTRL) then $clicked_col = -1 
	if $clicked_row > _GUICtrlListViewGetItemCount($__LISTVIEWCTRL) then $clicked_row = -1 
	$tagNMITEMACTIVATE = 0
	if $iFlag =0 then
		_FillLV_Info($__LISTVIEWCTRL, $clicked_row, $clicked_col, $LVINFO)
		$old_col = $clicked_col
	EndIf
		$LVINFO[8] = $clicked_row
		$LVINFO[9] = $clicked_col
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then ConsoleWrite(_DebugHeader("Col:" & $clicked_col))
	If $DebugIt Then ConsoleWrite(_DebugHeader("Row:" & $clicked_row))
	;----------------------------------------------------------------------------------------------

EndFunc


;===============================================================================
; Function Name:	_DebugHeader
; Description:		Gary's console debug header.
; Parameter(s):			$s_text		 - IN -
;
; Requirement(s):
; Return Value(s):
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func _DebugHeader($s_text)
	Return _
			"!===========================================================" & @LF & _
			"+===========================================================" & @LF & _
			"-->" & $s_text & @LF & _
			"+===========================================================" & @LF
		EndFunc   ;==>_DebugHeader
		
;===============================================================================
; Function Name:	_GetClassName
; Description:		get the classname of a ctrl
; Parameter(s):	$nCtrl		 the ctrlId of to get classname for. 
; Requirement(s):		
; Return Value(s):	Classname or 0 on failure
; User CallTip:	
; Author(s):		Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s):			Strips trailing numbers from classname.
;===============================================================================
Func _GetClassName($nCtrl)
	Local $ret, $struct = DllStructCreate("char[128]"),$classname = 0
	$ret = DllCall("user32.dll","int","GetClassName","hwnd",GUICtrlGetHandle($nCtrl),"ptr",DllStructGetPtr($struct),"int",DllStructGetSize($struct))
	If IsArray($ret) Then
		$classname = DllStructGetData($struct,1)
		;ConsoleWrite("Classname="&$classname&@LF)
	EndIf
	$struct =0 
	Return $classname
EndFunc
;===============================================================================
; Function Name:	vKeyCheck  alias for __IsPressedMod
; Description:	Gets a key press
; Parameter(s):			$dll		 - IN/OPTIONAL -
; Requirement(s):
; Return Value(s): Return the key that is pressed or 0
; User CallTip:
; Author(s):
; Note(s):
;===============================================================================
Func _vKeyCheck($dll = "user32.dll")
	Local $aR, $hexKey, $i
	Local $vkeys[4]=[1,13,27,113];leftmouse,enter,esc,f2
	For $i =0 to UBound($vkeys)-1
		$hexKey = '0x'&Hex($vkeys[$i],2)
		$aR = DllCall($dll, "int", "GetAsyncKeyState", "int", $hexKey)
		If $aR[0] <> 0 Then Return $vkeys[$i]
		Sleep(5)
	Next
	Return 0
EndFunc   ;==>__IsPressedMod

;===============================================================================
; Function Name	:	_HasFocus
; Description		:	Return true if control has focus
; Parameter(s)		:	$nCtrl Ctrlid to check
; Return Value(s)	:	True is ctrl has focus, false otherwise.
; User CallTip		:	
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:	
;===============================================================================
Func _HasFocus($nCtrl)
;	If $DebugIt Then ConsoleWrite("_HasFocus>>"&@LF)
Local $hwnd
	if $nCtrl = $lvCombo Then
		$hwnd = _GetComboInfo($nCtrl,0)
	Else
		$hwnd = GUICtrlGetHandle($nCtrl)
	EndIf
	Return ($hwnd = ControlGetHandle($Gui,"",ControlGetFocus($Gui,"")))
EndFunc

;===============================================================================
; Function Name	:	_SetLVCallBack
; Description		:	
; Parameter(s)		:	$CallBack 	Function to use for(primary button) call back defaults to _CancelEdit() 
; Return Value(s)	:	None.
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:	This is used to open other controls and dialogs
;===============================================================================
Func _SetLVCallBack($CallBack = "_CancelEdit")
	If $CallBack <> "" Then $LVCALLBACK = $CallBack
EndFunc
	
;===============================================================================
; Function Name	:	_SetLVContext
; Description		:	
; Description		:	
; Parameter(s)		:	$CallBack 	Function to use for (secondary button) contexts defaults to _CancelEdit() 
; Return Value(s)	:	None.
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:	This is used to open other controls and dialogs (context menus)
;===============================================================================
Func _SetLVContext($Context = "_CancelEdit")
	if $Context <> "" Then $LVCONTEXT = $Context
EndFunc
;===============================================================================
; Function Name	:	_LvHasCheckStyle
; Description		:	
; Parameter(s)		:	$hCtrl		Listview control to check for $LVS_EX_CHECKBOXES style
;
; Requirement(s)	:	
; Return Value(s)	:	
; User CallTip		:	
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:	
;===============================================================================
Func _LvHasCheckStyle($hCtrl)
	Local $style =  _GUICtrlListViewGetExtendedListViewStyle($hCtrl)
	if (BitAnd($style,$LVS_EX_CHECKBOXES) = $LVS_EX_CHECKBOXES) Then Return True
	Return False
EndFunc

;===============================================================================
; Function Name	:	_LvGetCheckedCount
; Description		:	
; Parameter(s)		:	$nCtrl		 Listview control to get checked checkbox count.
;
; Requirement(s)	:	
; Return Value(s)	:	number of checked checkboxes, or zero.
; User CallTip		:	
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:	
;===============================================================================
Func _LvGetCheckedCount($nCtrl)
	if _LvHasCheckStyle($nCtrl) Then
		Local $count =0
		For $x =0 to _GUICtrlListViewGetItemCount($nCtrl)-1
			If _GUICtrlListViewGetCheckedState($nCtrl,$x) Then $count += 1
		Next
		Return $count
	EndIf
	Return 0
EndFunc

;===============================================================================
; Function Name	:	_GetComboInfo
; Description		:	
; Parameter(s)		:	$nCtrl		ComboBox control to get info for
;							$type		 	0= return edit hwnd, 1=  return list hwnd 
;
; Requirement(s)	:	
; Return Value(s)	:	return either the combos edit or list hwnd, or zero otherwise
; User CallTip		:	
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:	
;===============================================================================
Func _GetComboInfo($nCtrl,$type =0)
	;ConsoleWrite(" _GetClassName:"&_GetClassName($nCtrl)&@LF)
	If _GetClassName($nCtrl) <> "ComboBox" Then Return 0
	Local $ret, $cbInfo ,$v_ret
	$cbInfo = DllStructCreate("int;int[4];int[4];int;int;int;int")
	DllStructSetData($cbInfo,1,DllStructGetSize($cbInfo))
	$v_ret = DllCall("user32.dll","int","GetComboBoxInfo","hwnd",GUICtrlGetHandle($nCtrl),"ptr",DllStructGetPtr($cbInfo))
	if IsArray($v_ret) Then 
		if $type = 0 Then
			$ret= DllStructGetData($cbInfo,6);edit handle
			;ConsoleWrite("Text ="&WinGetText($ret)&@LF)
		Elseif $type =1 Then 
			$ret = DllStructGetData($cbInfo,7);list handle
		EndIf
	EndIf
	$cbInfo =0
	Return $ret
EndFunc
Func _InvalidateRect($hWnd)
	Local $v_ret =  DllCall("user32.dll", "int", "InvalidateRect","hwnd",$hWnd,"ptr", 0,"int",1)
	return $v_ret[0]
EndFunc

Func _UpdateWindow($hWnd)
	Local $v_ret = DllCall("user32.dll", "int", "UpdateWindow", "hwnd", $hWnd)
	Return $v_ret[0]
EndFunc  ;==>UpdateWindow
;;;ripped from help file.
; Convert the client (GUI) coordinates to screen (desktop) coordinates
Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")
	DllStructSetData($stPoint, 1, 0)
	DllStructSetData($stPoint, 2, 0)
	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))
	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	; release Struct not really needed as it is a local 
	$stPoint = 0
EndFunc

	
		
	
; end include
#AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7
Global $count = 0
;===============================================================================
; Name        : ListViewEIP
; Description      :  An example of editing a ListView by overlaying editing controls.
;             :
; Requirement(s)    :   _EIPListView.au3
;             :
;                  :
; Author(s)   :    Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)         :
;===============================================================================
Global $Checkbox1, $Checkbox2, $HelpContext, $ListView;,$Status1,$Status2
Opt("GUICloseOnESC", 0);turn off exit on esc.
Opt("GUIOnEventMode", 1)

Func esegui()
    Local $DD, $WW
    For $DD = 0 To _GUICtrlListViewGetItemCount($ListView) - 1
        If _GUICtrlListViewGetCheckedState($ListView, $DD) Then
            $WW = $WW + 1
        EndIf
    Next
    ; se non trovo occorrenze selezionate avviso e continuo loop
    If $WW < 1 Then
        MsgBox(0, "Attenzione!", "Occorre selezionare una occorrenza!")
    Else
        MsgBox(0, "Attenzione!", "OK!")
        ;MsgBox(0,"","Selezionati")
    EndIf
EndFunc   ;==>esegui

_Main()
Func _Main()
    ;   ======>>> set the type of control for each column <<<======
    ;0= ignore, 1= edit, 2= combo, 4= calendar, 256= use callback.
    Global $LVcolControl[11] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1] ;left click actions
    ;0 = ignore, 1= use context callback
    ;Global $LVcolRControl[11]= [256,256,256,0,0,0,0,0,0,0,0] ; right click actions
    Global $LVcolRControl[11] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; right click actions
    _SetLvCallBack ("MyCallBack") ;set callback function
    _SetLvContext ("MyContext") ;set context fuction
    Local $guiw = 750
    Local $guih = 570
    ;Local $deskh= @DesktopHeight - _GetTaskBarHeight()
    ;Local $aWinPos[4]=[(@DesktopWidth-$guiw)/2,($deskh-$guih)/2,750,570]
    $Gui = GUICreate("Allegati", $guiw, $guih, -1, -1);, 424, 280, 200, 110)
    GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")
    $ListView = GUICtrlCreateListView("Edit|Edit1|Edit2|Edit3|Edit4|Edit5|Edit6|Edit7|Edit8|COMBO|Edit9", 3, 250, $guiw - 6, $guih - 300)
    GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
    GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
    _GUICtrlListViewSetColumnWidth($ListView, 0, $LVSCW_AUTOSIZE)
    $__LISTVIEWCTRL = $ListView
    Global $riceviDati = GUICtrlCreateButton("Ricevi", 30, $guih - 40, 100, 25, 0)
    ;GUICtrlSetOnEvent($riceviDati, "riceviDati")
    GUICtrlSetOnEvent($riceviDati, "esegui")
    ;$Checkbox1 = GUICtrlCreateCheckbox("Update On Focus Change", 30, $guih-75, 147, 17)
    ;GUICtrlSetTip($Checkbox1, "Checking this box means that if a cell is being actively edited" & @LF & _
    ;      "and another cell is clicked, the edited cell is updated with the new data." & @LF & _
    ;      "If unchecked, the original data is preserved.")
    ;GUICtrlSetOnEvent($Checkbox1, "SetUpdateOptions")
    ;$Checkbox2 = GUICtrlCreateCheckbox("DblClick to Init Edit ", 30,$guih-50, 147, 17)
    ;GUICtrlSetTip($Checkbox2, "Checking this box means that one must double click the cell to get the edit control.")
    ;GUICtrlSetOnEvent($Checkbox2, "SetUpdateOptions")
    ;Local $Status1 = GUICtrlCreateLabel("", 1, $guih-17, $guiw/2, 17, $SS_SUNKEN)
    ;Local $Status2 = GUICtrlCreateLabel("", ($guiw/2)+2, $guih-17,($guiw/2)-2 , 17, $SS_SUNKEN)
    ; Populate list and make it wide enough to see
    ;======>>>  Populate controls with test data<<<======
    ;GUICtrlSetOnEvent($lvList,"lvListHandler")
    ;GuiCtrlSetData($lvList,"Something|Nothing|Other|Nada|Zip|Ziltch|A Lot|Mucho|Smidge|Pinch"); <<<====== populate list.
    GUICtrlSetOnEvent($__LISTVIEWCTRL, "lvListViewHandler")
    GUICtrlCreateListViewItem("Silvano|test|test1|test2|test3|test4|test5|test6|test7||test9", $ListView)
    Local $c, $campiCombo
    For $i = 1 To 18
        $c = $c & Chr($i + 66) & "|" ; popola combo per esempio
        ;_GUICtrlListViewSetColumnWidth($ListView, $i, $LVSCW_AUTOSIZE)
        GUICtrlCreateListViewItem("Silvano " & $i & "|test|test1|test2|test3|test4|test5|test6|test7||test9", $ListView)
        ;$campiCombo &= $i & "|"
		    GUICtrlSetData($lvCombo, "")
    GUICtrlSetData($lvCombo, "one|two|tree",$i)
    Next
    ;$campiCombo &= "Primo|secondo|terzo|quarto"
    ;silvano comment
    ;$c = StringTrimRight($c, 1)
    ;GUICtrlSetData($lvCombo, $c)
    ; fine silvano comment
    GUICtrlSendMsg($ListView, 0x101E, 0, 200);$listview, LVM_SETCOLUMNWIDTH, 0, resize to widest value
    ;GUICtrlSendMsg($ListView, 0x101E, 1, 100 );$listview, LVM_SETCOLUMNWIDTH, 0, resize to widest value
    ;GUICtrlSendMsg($ListView, 0x101E, 2, 100);$listview, LVM_SETCOLUMNWIDTH, 0, resize to widest value
    ;======>>>  End  Populate  <<<======
    $__LISTVIEWCTRL = $ListView ;<<<====== Set $__LISTVIEWCTRL to the ctrlID of the ListView control
    ;WinSetTrans($Gui,"",0)
    ;WinMove($Gui,"",1,@DesktopHeight)
    GUISetState(@SW_SHOW, $Gui)
   
    ;*************************************************
    ;*************************************************   
    ;*************************************************
    ;---------------------------------------------
    _InitEditLib ("", "", "", "Whatever")
    ;---------------------------------------------
   ; GUICtrlSetData($lvCombo, "")
   ; GUICtrlSetData($lvCombo, $campiCombo, "secondo")
    ;_AnimateWindow($Gui,$aWinPos)
    ;_AnimateWindowEnter($gui)
    ConsoleWrite("Initiate Done." & @LF)
    ;*************************************************
    ;*************************************************   
    ;*************************************************
   
    While 1
        _MonitorEditState ($editCtrl, $editFlag, $__LISTVIEWCTRL, $LVINFO);<<<======  add this in your message loop<<<======
        If $bCALLBACK_EVENT = True Then
            $bCALLBACK_EVENT = False
            Call($LVCALLBACK, $LVINFO)
        EndIf
        ;Local $statMsg1 = StringFormat("Row: %s Col: %s Ckd: %s", $LVINFO[8]&@TAB, $LVINFO[9]&@TAB,$LVCHECKEDCNT)
        ;Local $statMsg2 = StringFormat("Update: %s  DblClick: %s",$bLVUPDATEONFOCUSCHANGE,$bLVEDITONDBLCLICK)
        ;If GUICtrlRead($Status1) <> $statMsg1 Then GUICtrlSetData($Status1, $statMsg1)
        ;If GUICtrlRead($Status2) <> $statMsg2 Then GUICtrlSetData($Status2, $statMsg2)
        Sleep(25)
    WEnd
    _TermEditLib ();<<<====== add this after your message loop<<<======
EndFunc   ;==>_Main
Func _AnimateWindowEnter ($Gui)
    WinMove($Gui, "", 1, 1, 1, 1)
EndFunc   ;==>_AnimateWindowEnter
Func OnExit()
    _TermEditLib ()
    _AnimateWindow($Gui, WinGetPos($Gui), 1)
    Exit
EndFunc   ;==>OnExit
Func SetUpdateOptions()
    $bLVUPDATEONFOCUSCHANGE = (BitAND(GUICtrlRead($Checkbox1), $GUI_CHECKED) = $GUI_CHECKED)
    $bLVEDITONDBLCLICK = (BitAND(GUICtrlRead($Checkbox2), $GUI_CHECKED) = $GUI_CHECKED)
EndFunc   ;==>SetUpdateOptions
Func MyCallBack($aLVINFO)
    _ArrayDisplay($aLVINFO, "LV Info")
    Local $lvProgress = GUICtrlCreateProgress($aLVINFO[2], $aLVINFO[3] + 3, $aLVINFO[4], $aLVINFO[5] - 8)
    For $x = 0 To 100
        GUICtrlSetData($lvProgress, $x)
        Sleep(50)
    Next
    GUICtrlDelete($lvProgress)
    Return 1
EndFunc   ;==>MyCallBack
Func MyContext($aLVINFO)
    Local $ret = 0, $oldText
    ;create context menu on demand.
    ;----------------------------------------------------------------------------------------------
    If $DebugIt Then ConsoleWrite(_DebugHeader (StringFormat("MyContext Row:%d Col:%d", $aLVINFO[0], $aLVINFO[1])))
    ;----------------------------------------------------------------------------------------------
    If ($aLVINFO[0] < 0 Or $aLVINFO[1] < 0) Then Return
    Local $HelpCtx[7]
    $HelpCtx[0] = GUICtrlCreateDummy()
    $HelpCtx[1] = GUICtrlCreateContextMenu($HelpCtx[0])
    $HelpCtx[2] = GUICtrlCreateMenuItem("String Upper", $HelpCtx[1])
    $HelpCtx[3] = GUICtrlCreateMenuItem("", $HelpCtx[1])
    $HelpCtx[4] = GUICtrlCreateMenuItem("String Lower", $HelpCtx[1])
    $HelpCtx[5] = GUICtrlCreateMenuItem("", $HelpCtx[1])
    $HelpCtx[6] = GUICtrlCreateMenuItem("About...", $HelpCtx[1])
    GUISetState(@SW_SHOW)
    Local $hMenu = GUICtrlGetHandle($HelpCtx[1])
    Local $xx, $yy
    ClientToScreen (WinGetHandle($Gui), $xx, $yy)
    Local $ctx = TrackPopupMenu(WinGetHandle($Gui), $hMenu, $xx + $aLVINFO[2], $yy + $aLVINFO[3])
    ;----------------------------------------------------------------------------------------------
    If $DebugIt Then ConsoleWrite(_DebugHeader ("MenuItem=" & $ctx))
    ;----------------------------------------------------------------------------------------------
    ;; do something with the result.
    Switch $ctx
        Case $HelpCtx[2]
            $oldText = _GUICtrlListViewGetItemText($__LISTVIEWCTRL, $aLVINFO[0], $aLVINFO[1])
            $ret = _GUICtrlListViewSetItemText($__LISTVIEWCTRL, $aLVINFO[0], $aLVINFO[1], StringUpper($oldText))
        Case $HelpCtx[4]
            $oldText = _GUICtrlListViewGetItemText($__LISTVIEWCTRL, $aLVINFO[0], $aLVINFO[1])
            $ret = _GUICtrlListViewSetItemText($__LISTVIEWCTRL, $aLVINFO[0], $aLVINFO[1], StringLower($oldText))
        Case $HelpCtx[6]
            MsgBox(266288, "EIP ListView", "Called from context menu.")
    EndSwitch
    ;; clean up the context menu.
    For $x = 0 To UBound($HelpCtx) - 1
        GUICtrlDelete($HelpCtx[$x])
    Next
    Return $ret
EndFunc   ;==>MyContext
;;;ripped from help file.
; Convert the client (GUI) coordinates to screen (desktop) coordinates
;~ Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
;~     Local $stPoint = DllStructCreate("int;int")
;~
;~     DllStructSetData($stPoint, 1, $x)
;~     DllStructSetData($stPoint, 2, $y)
;~     DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))
;~
;~     $x = DllStructGetData($stPoint, 1)
;~     $y = DllStructGetData($stPoint, 2)
;~     ; release Struct not really needed as it is a local
;~     $stPoint = 0
;~ EndFunc
; added TPM_RETURNCMD to uflags to get menu item return value.
; Show at the given coordinates (x, y) the popup menu (hMenu) which belongs to a given GUI window (hWnd)
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
    Local $v_ret = DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0X100, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
    Return $v_ret[0]
EndFunc   ;==>TrackPopupMenu
Func lvListHandler()
    ConsoleWrite("List control handler" & @LF)
    If $bLVDBLCLICK Then
        ConsoleWrite("DblClick" & @LF)
        $bLVDBLCLICK = False
    Else
        ConsoleWrite("Click" & @LF)
    EndIf
EndFunc   ;==>lvListHandler
Func lvListViewHandler()
    ConsoleWrite("lvListViewHandler>>" & @LF)
EndFunc   ;==>lvListViewHandler
Func _AnimateWindow($hWnd, $aPos, $iFlag = 0)
    If $hWnd = 0 Then Return 0
    If IsArray($aPos) Then
        If UBound($aPos) <> 4 Then Return 0
    EndIf
    ;Local $hstep, $wstep,
    Local $tstep, $lstep
    If $iFlag Then
        ;$hstep = $aPos[3] /50
        ;$wstep = $aPos[2]/50
        $tstep = (@DesktopHeight - $aPos[1]) / 50
        $lstep = $aPos[0] / 50
        For $x = 50 To 0 Step - .5
            WinMove($Gui, "", $lstep * $x, @DesktopHeight - ($tstep * $x), $aPos[2] / 4, $aPos[3] / 4)
        Next
    Else
        WinMove($Gui, "", 1, 1, 1, 1)
        ;$hstep = $aPos[3] /50
        ;$wstep = $aPos[2]/50
        $tstep = (@DesktopHeight - $aPos[1]) / 50
        $lstep = $aPos[0] / 50
        For $x = 0 To 50 Step .5
            WinMove($Gui, "", $lstep * $x, @DesktopHeight - ($tstep * $x), $aPos[2] / 4, $aPos[3] / 4)
        Next
        WinMove($Gui, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
    EndIf
    Return
EndFunc   ;==>_AnimateWindow
Func _GetTaskBarHeight()
    Local $oldOpt = Opt("WinTitleMatchMode", 4)
    Local $TrayPos = WinGetPos("classname=Shell_TrayWnd")
    Opt("WinTitleMatchMode", $oldOpt)
    Return $TrayPos[3]
EndFunc   ;==>_GetTaskBarHeight