#include-once
#include <GUIConstants.au3>

;~ struct TBBUTTON
;~ {
;~ 	Global Const $iBitmap;
;~ 	Global Const $idCommand;
;~ 	BYTE fsState;
;~ 	BYTE fsStyle;
;~ 	BYTE bReserved[2];
;~ 	DWORD dwData;
;~ 	Global Const $iString;
;~ }

;~ struct TBADDBITMAP
;~ {
;~ 	HINSTANCE hInst;
;~ 	UGlobal Const $nID;
;~ }

Global Const $ILC_MASK				= 0x0001
Global Const $ILC_COLOR32			= 0x0020
Global $iMenuItems = -1

Global $TBBUTTON = DllStructCreate("int;int;byte;byte;byte;dword;int")
Global $TBADDBITMAP = DllStructCreate("int;uint")
; Create an image list for saving/drawing toolbar icons
Global $hToolBarImageList = ImageList_Create(16, 16, BitOr($ILC_MASK, $ILC_COLOR32), 0, 1)

;Global Const $WM_USER = 0x400

Global Const $HINST_COMMCTRL = -1
Global Const $IDB_STD_SMALL_COLOR = 0

; ToolBar standard buttons
Global Const $STD_CUT = 0
Global Const $STD_COPY = 1
Global Const $STD_PASTE = 2
Global Const $STD_UNDO = 3
Global Const $STD_REDOW = 4
Global Const $STD_DELETE = 5
Global Const $STD_FILENEW = 6
Global Const $STD_FILEOPEN = 7
Global Const $STD_FILESAVE = 8
Global Const $STD_PRINTPRE = 9
Global Const $STD_PROPERTIES = 10
Global Const $STD_HELP = 11
Global Const $STD_FIND = 12
Global Const $STD_REPLACE = 13
Global Const $STD_PRINT = 14

Global Const $VIEW_LARGEICONS = 0
Global Const $VIEW_SMALLICONS = 1
Global Const $VIEW_LIST = 2
Global Const $VIEW_DETAILS = 3
Global Const $VIEW_SORTNAME = 4
Global Const $VIEW_SORTSIZE = 5
Global Const $VIEW_SORTDATE = 6
Global Const $VIEW_SORTTYPE = 7
Global Const $VIEW_PARENTFOLDER = 8
Global Const $VIEW_NETCONNECT = 9
Global Const $VIEW_NETDISCONNECT = 10
Global Const $VIEW_NEWFOLDER = 11

; ToolBar States
Global Const $TBSTATE_CHECKED = 1
Global Const $TBSTATE_PRESSED = 2
Global Const $TBSTATE_ENABLED = 4
Global Const $TBSTATE_HIDDEN = 8
Global Const $TBSTATE_INDETERMINATE = 16
Global Const $TBSTATE_WRAP = 32

; Toolbar Styles
Global Const $TBSTYLE_BUTTON = 0
Global Const $TBSTYLE_SEP = 1
Global Const $TBSTYLE_CHECK = 2
Global Const $TBSTYLE_GROUP = 4
Global Const $TBSTYLE_CHECKGROUP = BitOR($TBSTYLE_GROUP, $TBSTYLE_CHECK)
Global Const $TBSTYLE_DROPDOWN = 8
Global Const $TBSTYLE_AUTOSIZE = 16
Global Const $TBSTYLE_NOPREFIX = 32
Global Const $TBSTYLE_TOOLTIPS = 256
Global Const $TBSTYLE_WRAPABLE = 512
Global Const $TBSTYLE_ALTDRAG = 1024
Global Const $TBSTYLE_FLAT = 2048
Global Const $TBSTYLE_LIST = 4096
Global Const $TBSTYLE_CUSTOMERASE = 8192
Global Const $TBSTYLE_REGISTERDROP = 0x4000
Global Const $TBSTYLE_TRANSPARENT = 0x8000
Global Const $TBSTYLE_EX_DRAWDDARROWS = 0x00000001
Global Const $TBSTYLE_EX_MIXEDBUTTONS = 8
Global Const $TBSTYLE_EX_HIDECLIPPEDBUTTONS = 16
Global Const $TBSTYLE_EX_DOUBLEBUFFER = 0x80

; Toolbar messages
Global Const $TB_ENABLEBUTTON			= ($WM_USER + 1)
Global Const $TB_CHECKBUTTON			= ($WM_USER + 2)
Global Const $TB_PRESSBUTTON			= ($WM_USER + 3)
Global Const $TB_HIDEBUTTON				= ($WM_USER + 4)
Global Const $TB_INDETERMINATE			= ($WM_USER + 5)
Global Const $TB_MARKBUTTON = ($WM_USER + 6)
Global Const $TB_ISBUTTONENABLED		= ($WM_USER + 9)
Global Const $TB_ISBUTTONCHECKED		= ($WM_USER + 10)
Global Const $TB_ISBUTTONPRESSED		= ($WM_USER + 11)
Global Const $TB_ISBUTTONHIDDEN			= ($WM_USER + 12)
Global Const $TB_ISBUTTONINDETERMINATE	= ($WM_USER + 13)
Global Const $TB_ISBUTTONHIGHLIGHTED	= ($WM_USER + 14)
Global Const $TB_SETSTATE				= ($WM_USER + 17)
Global Const $TB_GETSTATE				= ($WM_USER + 18)
Global Const $TB_ADDBITMAP				= ($WM_USER + 19)
Global Const $TB_ADDBUTTONSA			= ($WM_USER + 20)
Global Const $TB_INSERTBUTTONA			= ($WM_USER + 21)
Global Const $TB_ADDBUTTONS				= ($WM_USER + 20)
Global Const $TB_INSERTBUTTON			= ($WM_USER + 21)
Global Const $TB_DELETEBUTTON			= ($WM_USER + 22)
Global Const $TB_GETBUTTON				= ($WM_USER + 23)
Global Const $TB_BUTTONCOUNT			= ($WM_USER + 24)
Global Const $TB_COMMANDTOINDEX			= ($WM_USER + 25)
Global Const $TB_SAVERESTOREA			= ($WM_USER + 26)
Global Const $TB_SAVERESTOREW			= ($WM_USER + 76)
Global Const $TB_CUSTOMIZE				= ($WM_USER + 27)
Global Const $TB_ADDSTRINGA				= ($WM_USER + 28)
Global Const $TB_ADDSTRINGW				= ($WM_USER + 77)
Global Const $TB_GETITEMRECT			= ($WM_USER + 29)
Global Const $TB_BUTTONSTRUCTSIZE		= ($WM_USER + 30)
Global Const $TB_SETBUTTONSIZE			= ($WM_USER + 31)
Global Const $TB_SETBITMAPSIZE			= ($WM_USER + 32)
Global Const $TB_AUTOSIZE				= ($WM_USER + 33)
Global Const $TB_GETTOOLTIPS			= ($WM_USER + 35)
Global Const $TB_SETTOOLTIPS			= ($WM_USER + 36)
Global Const $TB_SETPARENT				= ($WM_USER + 37)
Global Const $TB_SETROWS				= ($WM_USER + 39)
Global Const $TB_GETROWS				= ($WM_USER + 40)
Global Const $TB_GETBITMAPFLAGS			= ($WM_USER + 41)
Global Const $TB_SETCMDID				= ($WM_USER + 42)
Global Const $TB_CHANGEBITMAP			= ($WM_USER + 43)
Global Const $TB_GETBITMAP				= ($WM_USER + 44)
Global Const $TB_GETBUTTONTEXTA			= ($WM_USER + 45)
Global Const $TB_GETBUTTONTEXTW			= ($WM_USER + 75)
Global Const $TB_REPLACEBITMAP			= ($WM_USER + 46)
Global Const $TB_SETINDENT				= ($WM_USER + 47)
Global Const $TB_SETIMAGELIST			= ($WM_USER + 48)
Global Const $TB_GETIMAGELIST			= ($WM_USER + 49)
Global Const $TB_LOADIMAGES				= ($WM_USER + 50)
Global Const $TB_GETRECT				= ($WM_USER + 51)
Global Const $TB_SETHOTIMAGELIST		= ($WM_USER + 52)
Global Const $TB_GETHOTIMAGELIST		= ($WM_USER + 53)
Global Const $TB_SETDISABLEDIMAGELIST = ($WM_USER + 54)
Global Const $TB_GETDISABLEDIMAGELIST	= ($WM_USER + 55)
Global Const $TB_SETSTYLE				= ($WM_USER + 56)
Global Const $TB_GETSTYLE				= ($WM_USER + 57)
Global Const $TB_GETBUTTONSIZE			= ($WM_USER + 58)
Global Const $TB_SETBUTTONWIDTH			= ($WM_USER + 59)
Global Const $TB_SETMAXTEXTROWS			= ($WM_USER + 60)
Global Const $TB_GETTEXTROWS			= ($WM_USER + 61)
Global Const $TB_GETOBJECT				= ($WM_USER + 62)
Global Const $TB_GETBUTTONINFOW			= ($WM_USER + 63)
Global Const $TB_SETBUTTONINFOW			= ($WM_USER + 64)
Global Const $TB_GETBUTTONINFOA			= ($WM_USER + 65)
Global Const $TB_SETBUTTONINFOA			= ($WM_USER + 66)
Global Const $TB_INSERTBUTTONW			= ($WM_USER + 67)
Global Const $TB_ADDBUTTONSW			= ($WM_USER + 68)
Global Const $TB_HITTEST				= ($WM_USER + 69)
Global Const $TB_SETDRAWTEXTFLAGS		= ($WM_USER + 70)
Global Const $TB_GETHOTITEM				= ($WM_USER + 71)
Global Const $TB_SETHOTITEM				= ($WM_USER + 72)
Global Const $TB_SETANCHORHIGHLIGHT		= ($WM_USER + 73)
Global Const $TB_GETANCHORHIGHLIGHT		= ($WM_USER + 74)
Global Const $TB_MAPACCELERATORA		= ($WM_USER + 78)
Global Const $TB_GETINSERTMARK			= ($WM_USER + 79)
Global Const $TB_SETINSERTMARK			= ($WM_USER + 80)
Global Const $TB_INSERTMARKHITTEST		= ($WM_USER + 81)
Global Const $TB_MOVEBUTTON				= ($WM_USER + 82)
Global Const $TB_GETMAXSIZE				= ($WM_USER + 83)
Global Const $TB_SETEXTENDEDSTYLE		= ($WM_USER + 84)
Global Const $TB_GETEXTENDEDSTYLE		= ($WM_USER + 85)
Global Const $TB_GETPADDING				= ($WM_USER + 86)
Global Const $TB_SETPADDING				= ($WM_USER + 87)
Global Const $TB_SETINSERTMARKCOLOR		= ($WM_USER + 88)
Global Const $TB_GETINSERTMARKCOLOR		= ($WM_USER + 89)
Global Const $TB_MAPACCELERATORW		= ($WM_USER + 90)
Global Const $TB_GETSTRINGW				= ($WM_USER + 91)
Global Const $TB_GETSTRINGA				= ($WM_USER + 92)

; Cleanup
Func OnAutoItExit()
	ImageList_Destroy($hToolBarImageList)
	$arMenuItems = 0
EndFunc

;===============================================================================
;
; Description:      _GuiCtrlToolBarCreate
; Parameter(s):     $h_Gui			-	Handle to parent window
;					$v_styles		-	styles to apply to the tool bar (Optional) for multiple styles bitor them.
;					$v_exstyles		-	extended styles to apply to the tool bar (Optional) for multiple styles bitor them.
; Requirement:
; Return Value(s):   Returns hWhnd if successful, or 0 with error set to 1 otherwise.
; User CallTip:      _GuiCtrlToolBarCreate($h_Gui, [, $v_styles = ""][, $v_exstyles = ""]) Creates ToolBar.
; Author(s):         tonedeaf
; Note(s):
;===============================================================================
Func _GuiCtrlToolBarCreate($h_Gui, $v_styles = "", $v_exstyles = "")
	Local $h_ToolBar, $style
	
	If Not IsHWnd($h_Gui) Then $h_Gui = HWnd($h_Gui)
	$style = BitOR($WS_CHILD, $WS_VISIBLE)
	If $v_styles <> "" Then $style = BitOR($style, $v_styles)
	
	$h_ToolBar = DllCall("user32.dll", "long", "CreateWindowEx", "long", $v_exstyles, _
			"str", "ToolbarWindow32", "str", "", _
			"long", $style, "long", 0, "long", 0, "long", 0, "long", 0, _
			"hwnd", $h_Gui, "long", 0, "hwnd", $h_Gui, "long", 0)
	
	If Not @error Then
		DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_ToolBar[0], "int", $TB_BUTTONSTRUCTSIZE, "int", DllStructGetSize($TBBUTTON), "int", 0)
		Return $h_ToolBar[0]
	Else
		SetError(1)
	EndIf
	
	Return 0
EndFunc   ;==>_GuiCtrlToolBarCreate

;===============================================================================
;
; Description:      _GuiCtrlToolBarAddStandardButton
; Parameter(s):     $h_ToolBar			-	Handle of the toolbar
;					$iStdButtonType	-	Index of a standard button type present in comctl32.dll
;					(Standard button types listed under Toolbar standard buttons constants in declarations above)
; Requirement:
; Return Value(s):   Returns TRUE if successful, or 0 with error set to 1 or 2.
; User CallTip:      _GuiCtrlToolBarAddStandardButton($h_ToolBar, $iStdButtonType) Adds a standard ToolBar button
; Author(s):         tonedeaf
; Note(s):			Use this function to add predefined button types defined in commctl32.dll
;===============================================================================
Func _GuiCtrlToolBarAddStandardButton($h_ToolBar, $idControl, $iStdButtonType)
	DllStructSetData($TBADDBITMAP, 1, $HINST_COMMCTRL)
	DllStructSetData($TBADDBITMAP, 2, $IDB_STD_SMALL_COLOR)
	
	DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_ToolBar, "int", $TB_ADDBITMAP, "int", 0, "int", DllStructGetPtr($TBADDBITMAP))
	If @error Then
		SetError(1)
		Return 0
	EndIf
	
	DllStructSetData($TBBUTTON, 1, $iStdButtonType)
	DllStructSetData($TBBUTTON, 2, $idControl)
	DllStructSetData($TBBUTTON, 3, $TBSTATE_ENABLED)
	DllStructSetData($TBBUTTON, 4, $TBSTYLE_BUTTON)
	DllStructSetData($TBBUTTON, 5, 0)
	DllStructSetData($TBBUTTON, 6, 0)
	DllStructSetData($TBBUTTON, 7, 0)
	
	DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_ToolBar, "int", $TB_ADDBUTTONS, "int", 1, "int", DllStructGetPtr($TBBUTTON))
	If @error Then
		SetError(2)
		Return 0
	Else
		Return 1
	EndIf
	
EndFunc   ;==>_GuiCtrlToolBarAddStandardButton

Func _GuiCtrlToolBarAddButton($h_ToolBar, $idControl, $sIconFile, $iIconID)
	DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_ToolBar, "int", $TB_SETIMAGELIST, "int", 0, "int", $hToolBarImageList)
	If @error Then
		SetError(1)
		Return 0
	EndIf
	
	$iMenuItems = $iMenuItems + 1
	AddToolbarIcon($sIconFile, $iIconID)
	
	DllStructSetData($TBBUTTON, 1, $iMenuItems)
	DllStructSetData($TBBUTTON, 2, $idControl)
	DllStructSetData($TBBUTTON, 3, $TBSTATE_ENABLED)
	DllStructSetData($TBBUTTON, 4, $TBSTYLE_BUTTON)
	DllStructSetData($TBBUTTON, 5, 0)
	DllStructSetData($TBBUTTON, 6, 0)
	DllStructSetData($TBBUTTON, 7, 0)
	
	DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_ToolBar, "int", $TB_ADDBUTTONS, "int", 1, "int", DllStructGetPtr($TBBUTTON))
	If @error Then
		SetError(2)
		Return 0
	Else
		Return 1
	EndIf
	
EndFunc   ;==>_GuiCtrlToolBarAddButton

;===============================================================================
;
; Description:      _GuiCtrlToolBarAddSeparator
; Parameter(s):     $h_ToolBar			-	Handle of the toolbar
; Requirement:
; Return Value(s):   Returns TRUE if successful, or 0 with error set to 1.
; User CallTip:      _GuiCtrlToolBarAddSeparator($h_ToolBar) Adds a separator between Toolbar buttons
; Author(s):         tonedeaf
; Note(s):			Use this function to add a separator between toolbar buttons
;===============================================================================
Func _GuiCtrlToolBarAddSeparator($h_ToolBar)
	DllStructSetData($TBBUTTON, 1, 0)
	DllStructSetData($TBBUTTON, 2, 0)
	DllStructSetData($TBBUTTON, 3, $TBSTATE_ENABLED)
	DllStructSetData($TBBUTTON, 4, $TBSTYLE_SEP)
	
	DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_ToolBar, "int", $TB_ADDBUTTONS, "int", 1, "int", DllStructGetPtr($TBBUTTON))
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_GuiCtrlToolBarAddSeparator


; Following functions create/delete an imagelist and add icons to imagelist
; Author -: Holger

Func AddToolbarIcon($sIconFile, $nIconID)
	Local $stIcon = DllStructCreate('int')
	
	$nCount = ExtractIconEx($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1)
	
	$nIndex = -1
	
	If $nCount > 0 Then
		$hIcon	= DllStructGetData($stIcon, 1)
		$nIndex	= ImageList_AddIcon($hToolBarImageList, $hIcon)
		DestroyIcon($hIcon)
	EndIf
	
	$stIcon = 0
	
	Return $nIndex
EndFunc

Func ImageList_Create($nImageWidth, $nImageHeight, $nFlags, $nInitial, $nGrow)
	Local $hImageList = DllCall('comctl32.dll', 'hwnd', 'ImageList_Create', _
														'int', $nImageWidth, _
														'int', $nImageHeight, _
														'int', $nFlags, _
														'int', $nInitial, _
														'int', $nGrow)
	Return $hImageList[0]
EndFunc


Func ImageList_AddIcon($hIml, $hIcon)
	Local $nIndex = DllCall('comctl32.dll', 'int', 'ImageList_AddIcon', _
													'hwnd', $hIml, _
													'hwnd', $hIcon)
	Return $nIndex[0]
EndFunc


Func ImageList_Destroy($hIml)
	Local $bResult = DllCall('comctl32.dll', 'int', 'ImageList_Destroy', _
													'hwnd', $hIml)
	Return $bResult[0]
EndFunc

Func ExtractIconEx($sIconFile, $nIconID, $ptrIconLarge, $ptrIconSmall, $nIcons)
	Local $nCount = DllCall('shell32.dll', 'int', 'ExtractIconEx', _
												'str', $sIconFile, _
												'int', $nIconID, _
												'ptr', $ptrIconLarge, _
												'ptr', $ptrIconSmall, _
												'int', $nIcons)
	Return $nCount[0]
EndFunc

Func DestroyIcon($hIcon)
	Local $bResult = DllCall('user32.dll', 'int', 'DestroyIcon', _
												'hwnd', $hIcon)
	Return $bResult[0]
EndFunc