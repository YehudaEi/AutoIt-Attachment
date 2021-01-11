#region Version and Author(s)...And CREDITS!!
#cs -------Version and Author Data------------------------------------------------------------------
	; ***************************************************
	; ****DragList.au3***********************************
	; ************Author: Quaizywabbit*******************
	; *Credits: Many thanks to GaFrost, PaulIA, Jpm, Valik, and Smoke_N
	; ***************************************************
	;Changes in this version: Initial
#ce ;-------------------------------------------------------------------------------------------------
#endregion
#region Includes
#include-once
#include "guiconstants.au3"
#include "guilist.au3"
;#include <Misc.au3>
#endregion
#region Constants
;'Windows API Constants
Global Const $DRAGLISTMSGSTRING = "commctrl_DragListMsg" 
Global Const $DL_BEGINDRAG = ($WM_USER + 133)
Global Const $DL_DRAGGING = ($WM_USER + 134)
Global Const $DL_DROPPED = ($WM_USER + 135)
Global Const $DL_CANCELDRAG = ($WM_USER + 136)
#endregion
#region Variables
Dim $dragIdx, $dragIdto, $dragging, $dl_itemtext, $cursor_old = 2;<<arrow cursor
#endregion
#region Func's
#region _MakeDraglist()
;===============================================================================
;
; Function Name:  _MakeDraglist()  
; Description:    converts a single selection listbox into a drag listbox
;                 registers window message for Draglist
;                 registers DragListHandler function to process Draglist events
; Parameter(s):   $window =  either: handle to Parent window containing the listbox or
;                                    handle to Listbox control 
;                 $text = Parent window text - (see ControlGetHandle() in Help file)
;                 $controlid = controlid returned from GuiCtrlCreateList()
;
; Requirement(s):   
; Return Value(s):  On Success -  listbox will be converted for use as Drag Listbox
;                   On Failure: 
; Author(s):        Quaizywabbit
;
;===============================================================================
Func _Makedraglist($window, $text = 0, $controlid = 0)
	Local $hWnd
	If Not ($controlid = 0) Then
		$hWnd = ControlGetHandle($window, $text, $controlid)
	Else
		$hwnd = $window
	EndIf
	Local $r = DllCall("comctl32.dll", "int", "MakeDragList","hwnd",$hwnd)
	$draglistmessage = DllCall("user32.dll", "int", "RegisterWindowMessage", "str", $DRAGLISTMSGSTRING)
	$x = GUIRegisterMsg(($draglistmessage[0]), "_DraglistHandler")
	Return $r[0]
EndFunc
#endregion
#region _LBItemFromPt()
;===============================================================================
;
; Function Name:   _LBItemFromPt() 
; Description:     gets the item index from mouse coordinates 
; Parameter(s):   $Hlb = handle to drag listbox  
;                 $Point = Point structure containing current mouse position
;                 $autoscroll = boolean flag 1 = yes scroll contents
;                                            0 = no do not scroll
; Requirement(s):   
; Return Value(s):  On Success -  the index to the Draglist item if within Listbox client area or
;                                 scrolls the listbox when outside the client area and autoscroll is enabled
;                   On Failure: 
; Author(s):        Quaizywabbit
;
;===============================================================================
Func _LBItemFromPt( $Hlb, $Point, $autoscroll = 1)
	$x=DllStructGetData($Point, 1)
	$y=DllStructGetData($Point, 2)
	$r = DllCall("comctl32.dll", "int", "LBItemFromPt", "hwnd", $Hlb, "int", $x, "int", $y,  "int", $autoscroll)
	Return $r[0]
EndFunc
#endregion
#region _DrawInsert()
;===============================================================================
;
; Function Name: _DrawInsert()   
; Description:  draws insert icon at specified list index    
; Parameter(s):    $hwnd = handle to parent window
;                  $Hlb  = handle to drag listbox
;                  $nItem = item index
; Requirement(s):   
; Return Value(s):  On Success -  
;                   On Failure: 
; Author(s):        Quaizywabbit
;
;===============================================================================
Func _DrawInsert( $hwnd, $Hlb, $nItem)
	$r = DllCall("comctl32.dll", "int", "DrawInsert", "hwnd", $hwnd, "hwnd", $Hlb, "int", $nItem)
	Return $r[0]
EndFunc
#endregion
#region _ResetScreen()
;===============================================================================
;
; Function Name:  _ResetScreen()  
; Description:  forces window to redraw(update)    
; Parameter(s):   $TargethWnd = handle to window/control to update  
;
; Requirement(s):   
; Return Value(s):  On Success -  
;                   On Failure: 
; Author(s):        Quaizywabbit
;
;===============================================================================
Func _ResetScreen($TargethWnd)
	Const $SWP_NOMOVE = 0x0002, $SWP_NOSIZE = 0x0001, $SWP_NOZORDER = 0x0004, $SWP_FRAMECHANGED = 0x0020 ;from Winuser.h
	DllCall("user32.dll", "long", "SetWindowPos", "hwnd", $TargethWnd, "hwnd", $TargethWnd, _
			"int", 0, "int", 0, "int", 0, "int", 0, _
			"long", BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOZORDER, $SWP_FRAMECHANGED))
		EndFunc
#endregion
#region _DraglistItemLock()
;===============================================================================
;
; Function Name:  _DraglistItemLock()  
; Description:    disallows drag of specific items in draglist  
; Parameter(s):   $Hlb = handle to Drag Listbox 
;                 $list = comma separated list of item indexes: 
;                  ie. " 0,4,11" <first, 5th, and 12th items won't be draggable, and can't be replaced by other drag moves                       
;
; Requirement(s):   
; Return Value(s):  On Success -  
;                   On Failure: 
; Author(s):        Quaizywabbit
;
;===============================================================================
Func _DraglistItemLock($Hlb,$list)
	;todo
EndFunc
#endregion
#region _DraglistHandler()
;===============================================================================
;
; Function Name: _DraglistHandler()   
; Description:   this handles the logic for dragging items in the draglist 
; Parameter(s):   none -- called by MakeDraglist()  
;
; Requirement(s):   
; Return Value(s):  On Success -  
;                   On Failure: 
; Author(s):        Quaizywabbit
; Notes:            You can modify this logic to suit your application
;                   This is the bare minimums to make the draglist function as expected
;===============================================================================
Func _DraglistHandler($hwnd, $msg, $wParam, $lParam)

	$nID = BitAND($wParam, 0x0000FFFF)
	Local $DraglistInfo = DllStructCreate("uint;hwnd;int;int",$lParam)
	$nNotifyCode = (DllStructGetData($DraglistInfo,1))
	$Hlb = "0x" & Hex(DllStructGetData($DraglistInfo, 2))
	$Point = DllStructCreate("int;int")
	DllStructSetData($Point,1, DllStructGetData($DraglistInfo, 3))
	DllStructSetData($Point,2, DllStructGetData($DraglistInfo, 4))
	
	Select
		Case $nNotifyCode = $DL_BEGINDRAG
			$dragIdx = _LBItemFromPt($Hlb, $Point); get the item we want to drag 
			_ResetScreen($Hlb)
			GUICtrlSetCursor($nID, 0); set 'hand' cursor
			$dragging = False
			; use conditional statements returning true to allow item drag for some items, or false to disallow.
			;if $dragIdx = 0 then return False  ;<<this would disallow the first item from being dragged.
			Return True; need to add logic to check "Locked item list" to disallow drag
		Case $nNotifyCode = $DL_CANCELDRAG
			_ResetScreen($Hlb)
			_DrawInsert($hwnd, $Hlb, -1)
			GUICtrlSetCursor($nID, $cursor_old); back to arrow
			$dragging = False
		Case $nNotifyCode = $DL_DRAGGING
			$dragIdto = _LBItemFromPt($Hlb, $Point)
			_DrawInsert($hwnd, $Hlb, $dragIdto)
			$dragging = True
		Case $nNotifyCode = $DL_DROPPED
			$dragIdto = _LBItemFromPt($Hlb, $Point)
			If $dragging = True And $dragIdto <> -1 Then; need to add logic to check "Locked item list" to disallow drop.
				$dl_itemtext = _GUICtrlListGetText($nID, $dragIdx)
				_GUICtrlListDeleteItem($nID, $dragIdx)
				_GUICtrlListInsertItem($nID,$dl_itemtext,$dragIdto)
				_GUICtrlListSelectIndex($nID, $dragIdto)
				_DrawInsert($hwnd, $Hlb, -1)
			EndIf
			GUICtrlSetCursor($nID, $cursor_old); back to arrow
		Case Else
			Return $GUI_RUNDEFMSG
	EndSelect



EndFunc
#endregion