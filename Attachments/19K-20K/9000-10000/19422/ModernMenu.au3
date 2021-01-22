#include-once

;********************************************************************
; CommCtrl.h - constants
;********************************************************************

If Not IsDeclared("ILC_MASK")				Then Global Const $ILC_MASK = 0x0001
If Not IsDeclared("ILC_COLOR32")			Then Global Const $ILC_COLOR32 = 0x0020

If Not IsDeclared("ILD_TRANSPARENT")		Then Global Const $ILD_TRANSPARENT = 0x0001
If Not IsDeclared("ILD_BLEND")				Then Global Const $ILD_BLEND = 0x0004


;********************************************************************
; WinGDI.h - constants
;********************************************************************

If Not IsDeclared("SRCCOPY")				Then Global Const $SRCCOPY = 0x00CC0020


;********************************************************************
; WinUser.h- - constants
;********************************************************************

If Not IsDeclared("WM_DRAWITEM")			Then Global Const $WM_DRAWITEM = 0x002B
If Not IsDeclared("WM_MEASUREITEM")			Then Global Const $WM_MEASUREITEM = 0x002C
If Not IsDeclared("WM_SETTINGCHANGE")		Then Global Const $WM_SETTINGCHANGE = 0x001A
If Not IsDeclared("WM_USER")				Then Global Const $WM_USER = 0x0400
If Not IsDeclared("WM_TIMER")				Then Global Const $WM_TIMER = 0x0113 

If Not IsDeclared("MF_BYCOMMAND")			Then Global Const $MF_BYCOMMAND = 0x00000000
If Not IsDeclared("MF_POPUP")				Then Global Const $MF_POPUP = 0x00000010
If Not IsDeclared("MF_OWNERDRAW")			Then Global Const $MF_OWNERDRAW = 0x00000100
If Not IsDeclared("MF_SEPARATOR")			Then Global Const $MF_SEPARATOR = 0x00000800
If Not IsDeclared("MF_DEFAULT")				Then Global Const $MF_DEFAULT = 0x00001000

If Not IsDeclared("SM_CXSMICON")			Then Global Const $SM_CXSMICON = 49
If Not IsDeclared("SM_CXMENUCHECK")			Then Global Const $SM_CXMENUCHECK = 71

If Not IsDeclared("ODT_MENU")				Then Global Const $ODT_MENU = 1

If Not IsDeclared("ODS_SELECTED")			Then Global Const $ODS_SELECTED = 0x0001
If Not IsDeclared("ODS_GRAYED")				Then Global Const $ODS_GRAYED = 0x0002
If Not IsDeclared("ODS_DISABLED")			Then Global Const $ODS_DISABLED = 0x0004
If Not IsDeclared("ODS_CHECKED")			Then Global Const $ODS_CHECKED = 0x0008
If Not IsDeclared("ODS_DEFAULT")			Then Global Const $ODS_DEFAULT = 0x0020
If Not IsDeclared("ODS_NOACCEL")			Then Global Const $ODS_NOACCEL = 0x0100

If Not IsDeclared("DT_VCENTER")				Then Global Const $DT_VCENTER = 0x00000004
If Not IsDeclared("DT_SINGLELINE")			Then Global Const $DT_SINGLELINE = 0x00000020
If Not IsDeclared("DT_NOCLIP")				Then Global Const $DT_NOCLIP = 0x00000100

If Not IsDeclared("COLOR_MENU")				Then Global Const $COLOR_MENU = 4
If Not IsDeclared("COLOR_MENUTEXT")			Then Global Const $COLOR_MENUTEXT = 7
If Not IsDeclared("COLOR_HIGHLIGHT")		Then Global Const $COLOR_HIGHLIGHT = 13
If Not IsDeclared("COLOR_HIGHLIGHTTEXT")	Then Global Const $COLOR_HIGHLIGHTTEXT = 14
If Not IsDeclared("COLOR_GRAYTEXT")			Then Global Const $COLOR_GRAYTEXT = 17
If Not IsDeclared("CLR_NONE")				Then Global Const $CLR_NONE = 0xFFFFFFFF

If Not IsDeclared("BF_TOP")					Then Global Const $BF_TOP = 0x0002

If Not IsDeclared("EDGE_ETCHED")			Then Global Const $EDGE_ETCHED = 0x0006

If Not IsDeclared("DFC_MENU")				Then Global Const $DFC_MENU = 2

If Not IsDeclared("DFCS_MENUCHECK")			Then Global Const $DFCS_MENUCHECK = 0x0001
If Not IsDeclared("DFCS_MENUBULLET")		Then Global Const $DFCS_MENUBULLET = 0x0002

If Not IsDeclared("SPI_GETNONCLIENTMETRICS")	Then Global Const $SPI_GETNONCLIENTMETRICS = 0x0029
If Not IsDeclared("SPI_SETNONCLIENTMETRICS")	Then Global Const $SPI_SETNONCLIENTMETRICS = 0x002A

Global $sLOGFONT						=	"int;" & _ ; Height
											"int;" & _ ; Average width
											"int;" & _ ; Excapement
											"int;" & _ ; Orientation
											"int;" & _ ; Weight
											"byte;" & _ ; Italic
											"byte;" & _ ; Underline
											"byte;" & _ ; Strikeout
											"byte;" & _ ; Charset
											"byte;" & _ ; Outprecision
											"byte;" & _ ; Clipprecision
											"byte;" & _ ; Quality
											"byte;" & _ ; Pitch & Family
											"wchar[32]" ; Font name
												
Global Const $sNONCLIENTMETRICS			=	"uint;" & _ ; Struct size
											"int;" & _ ;
											"int;" & _ ;
											"int;" & _ ;
											"int;" & _ ;
											"int;" & _ ;
											$sLOGFONT & ";" & _ ; Caption LogFont structure
											"int;" & _ ;
											"int;" & _ ;
											$sLOGFONT & ";" & _ ; Small caption LogFont structure
											"int;" & _ ;
											"int;" & _ ;
											$sLOGFONT & ";" & _ ; Menu LogFont structure
											$sLOGFONT & ";" & _ ; Statusbar LogFont structure
											$sLOGFONT ; Message box LogFont structure


;**********************************************************************
; NotifyIconData struct
;**********************************************************************
Global $sNOTIFYICONDATAW					=	"dword;" & _ ; Struct size
												"hwnd;" & _ ; Callback window handle
												"uint;" & _ ; Icon ID
												"uint;" & _ ; Flags
												"uint;" & _ ; Callback message ID
												"hwnd;" ; Icon handle

Switch @OSVersion
	Case "WIN_95", "WIN_98", "WIN_NT4"
		$sNOTIFYICONDATAW &= "wchar[64]" ; ToolTip text
		
	Case Else
		$sNOTIFYICONDATAW &= "wchar[128];" & _ ; ToolTip text
							"dword;" & _ ; Icon state
							"dword;" & _ ; Icon state mask
							"wchar[256];" & _ ; Balloon ToolTip text
							"uint;" & _ ; Timeout / Version -> NIM_SETVERSION values 0, 3, 4
							"wchar[64];" & _ ; Balloon ToolTip title text
							"dword" ; Balloon ToolTip info flags
EndSwitch


;**********************************************************************
; Notify icon constants
;**********************************************************************
If Not IsDeclared("NIN_SELECT")				Then Global Const $NIN_SELECT = $WM_USER + 0
If Not IsDeclared("NINF_KEY")				Then Global Const $NINF_KEY = 0x1
If Not IsDeclared("NIN_KEYSELECT")			Then Global Const $NIN_KEYSELECT = BitOr($NIN_SELECT, $NINF_KEY)
If Not IsDeclared("NIN_BALLOONSHOW")		Then Global Const $NIN_BALLOONSHOW = $WM_USER + 2
If Not IsDeclared("NIN_BALLOONHIDE")		Then Global Const $NIN_BALLOONHIDE = $WM_USER + 3
If Not IsDeclared("NIN_BALLOONTIMEOUT")		Then Global Const $NIN_BALLOONTIMEOUT = $WM_USER + 4
If Not IsDeclared("NIN_BALLOONUSERCLICK")	Then Global Const $NIN_BALLOONUSERCLICK = $WM_USER + 5
If Not IsDeclared("NIN_POPUPOPEN")			Then Global Const $NIN_POPUPOPEN = $WM_USER + 6
If Not IsDeclared("NIN_POPUPCLOSE")			Then Global Const $NIN_POPUPCLOSE = $WM_USER + 7

If Not IsDeclared("NIM_ADD")				Then Global Const $NIM_ADD = 0x00000000
If Not IsDeclared("NIM_MODIFY")				Then Global Const $NIM_MODIFY = 0x00000001
If Not IsDeclared("NIM_DELETE")				Then Global Const $NIM_DELETE = 0x00000002
If Not IsDeclared("NIM_SETFOCUS")			Then Global Const $NIM_SETFOCUS = 0x00000003
If Not IsDeclared("NIM_SETVERSION")			Then Global Const $NIM_SETVERSION = 0x00000004

If Not IsDeclared("NIF_MESSAGE")			Then Global Const $NIF_MESSAGE = 0x00000001
If Not IsDeclared("NIF_ICON")				Then Global Const $NIF_ICON = 0x00000002
If Not IsDeclared("NIF_TIP")				Then Global Const $NIF_TIP = 0x00000004
If Not IsDeclared("NIF_STATE")				Then Global Const $NIF_STATE = 0x00000008
If Not IsDeclared("NIF_INFO")				Then Global Const $NIF_INFO = 0x00000010
If Not IsDeclared("NIF_REALTIME")			Then Global Const $NIF_REALTIME = 0x00000040
If Not IsDeclared("NIF_SHOWTIP")			Then Global Const $NIF_SHOWTIP = 0x00000080

If Not IsDeclared("NIS_HIDDEN")				Then Global Const $NIS_HIDDEN = 0x00000001
If Not IsDeclared("NIS_SHAREDICON")			Then Global Const $NIS_SHAREDICON = 0x00000002

If Not IsDeclared("NIIF_NONE")				Then Global Const $NIIF_NONE = 0x00000000
If Not IsDeclared("NIIF_INFO")				Then Global Const $NIIF_INFO = 0x00000001
If Not IsDeclared("NIIF_WARNING")			Then Global Const $NIIF_WARNING = 0x00000002
If Not IsDeclared("NIIF_ERROR")				Then Global Const $NIIF_ERROR = 0x00000003
If Not IsDeclared("NIIF_USER")				Then Global Const $NIIF_USER = 0x00000004
If Not IsDeclared("NIIF_ICON_MASK")			Then Global Const $NIIF_ICON_MASK = 0x0000000F
If Not IsDeclared("NIIF_NOSOUND")			Then Global Const $NIIF_NOSOUND = 0x00000010
If Not IsDeclared("NIIF_LARGE_ICON")		Then Global Const $NIIF_LARGE_ICON = 0x00000020


;**********************************************************************
; Constants for LoadIcon()
;**********************************************************************
If Not IsDeclared("IDI_APPLICATION")		Then Global Const $IDI_APPLICATION = 32512
If Not IsDeclared("IDI_HAND")				Then Global Const $IDI_HAND = 32513
If Not IsDeclared("IDI_QUESTION")			Then Global Const $IDI_QUESTION = 32514
If Not IsDeclared("IDI_EXCLAMATION")		Then Global Const $IDI_EXCLAMATION = 32515
If Not IsDeclared("IDI_ASTERISK")			Then Global Const $IDI_ASTERISK = 32516
If Not IsDeclared("IDI_WINLOGO")			Then Global Const $IDI_WINLOGO = 32517


;**********************************************************************
; Mouse constants
;**********************************************************************
If Not IsDeclared("WM_MOUSEMOVE")			Then Global Const $WM_MOUSEMOVE = 0x0200
If Not IsDeclared("WM_LBUTTONDOWN")			Then Global Const $WM_LBUTTONDOWN = 0x0201
If Not IsDeclared("WM_LBUTTONUP")			Then Global Const $WM_LBUTTONUP = 0x0202
If Not IsDeclared("WM_LBUTTONDBLCLK")		Then Global Const $WM_LBUTTONDBLCLK = 0x0203
If Not IsDeclared("WM_RBUTTONDOWN")			Then Global Const $WM_RBUTTONDOWN = 0x0204
If Not IsDeclared("WM_RBUTTONUP")			Then Global Const $WM_RBUTTONUP = 0x0205
If Not IsDeclared("WM_RBUTTONDBLCLK")		Then Global Const $WM_RBUTTONDBLCLK = 0x0206
If Not IsDeclared("WM_MBUTTONDOWN")			Then Global Const $WM_MBUTTONDOWN = 0x0207
If Not IsDeclared("WM_MBUTTONUP")			Then Global Const $WM_MBUTTONUP = 0x0208
If Not IsDeclared("WM_MBUTTONDBLCLK")		Then Global Const $WM_MBUTTONDBLCLK = 0x0209

												
;********************************************************************
; Main Creation Part
;********************************************************************
Global $hComctl32Dll				= DllOpen("comctl32.dll")
Global $hGdi32Dll					= DllOpen("gdi32.dll")
Global $hShell32Dll					= DllOpen("shell32.dll")
Global $hUser32Dll					= DllOpen("user32.dll")

Global $bUseAdvMenu					= TRUE
Global $bUseAdvTrayMenu				= TRUE

; Set default color values if not given
Global $nMenuBkClr					= 0xFFFFFF
Global $nMenuIconBkClr				= 0xD1D8DB
Global $nMenuSelectBkClr			= 0xD2BDB6
Global $nMenuSelectRectClr			= 0x854240
Global $nMenuSelectTextClr			= 0x000000
Global $nMenuTextClr				= 0x000000

Global $nTrayBkClr					= 0xFFFFFF
Global $nTrayIconBkClr				= 0xD1D8DB
Global $nTraySelectBkClr			= 0xD2BDB6
Global $nTraySelectRectClr			= 0x854240
Global $nTraySelectTextClr			= 0x000000
Global $nTrayTextClr				= 0x000000
			
; Store here the ID/Text/IconIndex/ParentMenu/Tray/SelIconIndex/IsMenu
Global $arMenuItems[1][8]
$arMenuItems[0][0] = 0
Global $nMenuItemsRedim				= 10

; Create a usable font for using in ownerdrawn menus
Global $hMenuFont					= 0
_CreateMenuFont($hMenuFont)

; Create an image list for saving/drawing our menu icons
Global $hMenuImageList	= ImageList_Create(16, 16, BitOr($ILC_MASK, $ILC_COLOR32), 0, 1)

Global $hBlankIcon					= 0

; Store here the NotifyID/TrayIcon/Menu/Click/ToolTip/Callback/OnlyMsg/Flash/FlashBlank
Global $TRAYNOTIFYIDS[1][9]
$TRAYNOTIFYIDS[0][0] = 0
Global $TRAYMSGWND					= 0
Global $TRAYNOTIFYID				= -1
Global $TRAYLASTID					= -1
Global $MENULASTITEM				= -1
Global $TRAYTIPMSG					= $WM_USER + 1 ; This message ID will be used in a GUIRegisterMsg() procdure
Global $FLASHTIMERID				= 3
Global $FLASHTIMEOUT				= 750
Global $sDefaultTT					= "AutoIt - " & @ScriptName

GUIRegisterMsg($WM_DRAWITEM, "WM_DRAWITEM")
GUIRegisterMsg($WM_MEASUREITEM, "WM_MEASUREITEM")
GUIRegisterMsg($TRAYTIPMSG, "_TrayWndProc")
GUIRegisterMsg($WM_SETTINGCHANGE, "WM_SETTINGCHANGE")
GUIRegisterMsg($WM_TIMER, "WM_TIMER")

; Cleanup
Func OnAutoItExit()
	ImageList_Destroy($hMenuImageList)
	DeleteObject($hMenuFont)
	
	DllClose($hComctl32Dll)
	DllClose($hGdi32Dll)
	DllClose($hShell32Dll)
	DllClose($hUser32Dll)
	
	$arMenuItems	= 0
	$TRAYNOTIFYIDS	= 0
EndFunc


;********************************************************************
; Define the colors for the menu/selection bar
;********************************************************************
Func _SetMenuBkColor($nColor)
	$nMenuBkClr				= $nColor
EndFunc

Func _SetMenuIconBkColor($nColor)
	$nMenuIconBkClr			= $nColor
EndFunc

Func _SetMenuSelectBkColor($nColor)
	$nMenuSelectBkClr		= $nColor
EndFunc

Func _SetMenuSelectRectColor($nColor)
	$nMenuSelectRectClr		= $nColor
EndFunc

Func _SetMenuSelectTextColor($nColor)
	$nMenuSelectTextClr		= $nColor
EndFunc

Func _SetMenuTextColor($nColor)
	$nMenuTextClr			= $nColor
EndFunc

Func _SetTrayBkColor($nColor)
	$nTrayBkClr				= $nColor
EndFunc

Func _SetTrayIconBkColor($nColor)
	$nTrayIconBkClr			= $nColor
EndFunc

Func _SetTraySelectBkColor($nColor)
	$nTraySelectBkClr		= $nColor
EndFunc

Func _SetTraySelectRectColor($nColor)
	$nTraySelectRectClr		= $nColor
EndFunc

Func _SetTraySelectTextColor($nColor)
	$nTraySelectTextClr		= $nColor
EndFunc

Func _SetTrayTextColor($nColor)
	$nTrayTextClr			= $nColor
EndFunc

Func _SetFlashTimeOut($nTime = 750)
	$FLASHTIMEOUT = $nTime
	If $FLASHTIMEOUT < 50 Then $FLASHTIMEOUT = 50
EndFunc


;**********************************************************************
; Get the icon ID like in newer Autoit versions
;**********************************************************************
Func _GetIconID($nID, $sFile)
	If StringRight($sFile, 4) = ".exe" Then
		If $nID < 0 Then
			$nID = - ($nID + 1)
		ElseIf $nID > 0 Then
			$nID = - $nID
		EndIf
	ElseIf StringRight($sFile, 4) = ".icl" And $nID < 0 Then
		$nID = - ($nID + 1)
	Else
		If $nID > 0 Then
			$nID = - $nID
		ElseIf $nID < 0 Then
			$nID = - ($nID + 1)
		EndIf
	EndIf
		
	Return $nID
EndFunc


;**********************************************************************
; Main functions:
;**********************************************************************
Func _TrayWndProc($hWnd, $Msg, $wParam, $lParam)
	If $hWnd = $TRAYMSGWND Then
		_TrayNotifyIcon($hWnd, $Msg, $wParam, $lParam)
	EndIf
EndFunc


Func _TrayNotifyIcon($hWnd, $Msg, $wParam, $lParam)
	Local $nClick = 0
	Local $nID = $wParam
	
	If $TRAYNOTIFYIDS[$nID][5] <> "" And _
		($TRAYNOTIFYIDS[$nID][6] = 0 Or _
		$TRAYNOTIFYIDS[$nID][6] = $lParam) Then
		Call($TRAYNOTIFYIDS[$nID][5], $nID, $lParam)
	EndIf
	
	Switch $lParam
		Case $WM_LBUTTONDOWN
			$nClick = 1
		case $WM_LBUTTONUP
			$nClick = 2
		case $WM_LBUTTONDBLCLK
			$nClick = 4
		case $WM_RBUTTONDOWN
			$nClick = 8
		case $WM_RBUTTONUP
			$nClick = 16
		case $WM_RBUTTONDBLCLK
			$nClick = 32
		case $WM_MOUSEMOVE
			$nClick = 64
	EndSwitch

	If BitAnd($nClick, $TRAYNOTIFYIDS[$nID][3]) And $TRAYNOTIFYIDS[$nID][2] > 0 Then
		Local $hMenu = GUICtrlGetHandle($TRAYNOTIFYIDS[$nID][2])
		If $hMenu <> 0 Then
			Local $stPoint = DllStructCreate("int;int")
			GetCursorPos(DllStructGetPtr($stPoint))
			
			SetForegroundWindow($hWnd)
		
			TrackPopupMenuEx($hMenu, 0, DllStructGetData($stPoint, 1), DllStructGetData($stPoint, 2), $hWnd, 0)
							
			PostMessage($hWnd, 0, 0, 0)
		EndIf
	EndIf
EndFunc


;**********************************************************************
; Create a new tray notify ID
;**********************************************************************
Func _GetNewTrayIndex()
	Local $i = 1, $bFreeFound = FALSE
	
	For $i = 1 To $TRAYNOTIFYIDS[0][0]
		If $TRAYNOTIFYIDS[$i][0] = 0 Then
			$bFreeFound = TRUE
			ExitLoop
		EndIf
	Next
	
	If Not $bFreeFound Then
		$TRAYNOTIFYIDS[0][0] += 1
		Local $nSize = UBound($TRAYNOTIFYIDS)

		If $TRAYNOTIFYIDS[0][0] > $nSize - 10 Then _
			Redim $TRAYNOTIFYIDS[$nSize + 10][9]
		$i = $TRAYNOTIFYIDS[0][0]
	EndIf
	
	Return $i
EndFunc


;********************************************************************
; Change the menu item icon
;********************************************************************
Func _TrayItemSetIcon($nMenuID, $sIconFile = "", $nIconID = -1)
	If $nMenuID = -1 Then $nMenuID = $MENULASTITEM
	If $nMenuID <= 0 Then Return 0
	
	$nIconID = _GetIconID($nIconID, $sIconFile)
	
	Local $i, $sText = "", $hMenu = 0
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			$sText = $arMenuItems[$i][1]
			$hMenu = $arMenuItems[$i][3]
			
			If $sIconFile = "" And $nIconID = -1 Then
				$arMenuItems[$i][2] = -1
				_SetOwnerDrawn($hMenu, $nMenuID, $sText, FALSE)
				GUICtrlSetData($nMenuID, $sText)
			Else
				If $sIconFile <> "" Then
					$arMenuItems[$i][2] = _AddMenuIcon($sIconFile, $nIconID)
				Else
					$arMenuItems[$i][2] = -1
				EndIf
				_SetOwnerDrawn($hMenu, $nMenuID, $sText)
			EndIf
						
			Return 1
		EndIf
	Next
	
	Return 0
EndFunc


;********************************************************************
; Set the selected menu item icon
;********************************************************************
Func _TrayItemSetSelIcon($nMenuID, $sIconFile = "", $nIconID = -1)
	If $nMenuID = -1 Then $nMenuID = $MENULASTITEM
	If $nMenuID <= 0 Then Return 0
	
	$nIconID = _GetIconID($nIconID, $sIconFile)
	
	Local $i, $sText = "", $hMenu = 0
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			$sText = $arMenuItems[$i][1]
			$hMenu = $arMenuItems[$i][3]
			
			If $sIconFile = "" And $nIconID = -1 Then
				$arMenuItems[$i][6] = -1
				_SetOwnerDrawn($hMenu, $nMenuID, $sText, FALSE)
				GUICtrlSetData($nMenuID, $sText)
			Else
				If $sIconFile <> "" Then
					$arMenuItems[$i][6] = _AddMenuIcon($sIconFile, $nIconID)
				Else
					$arMenuItems[$i][6] = -1
				EndIf
				_SetOwnerDrawn($hMenu, $nMenuID, $sText)
			EndIf
						
			Return 1
		EndIf
	Next
	
	Return 0
EndFunc


;********************************************************************
; Set the text of an menu item
;********************************************************************
Func _TrayItemSetText($nMenuID = -1, $sText = "")
	If $nMenuID = -1 Then $nMenuID = $MENULASTITEM
	If $nMenuID <= 0 Then Return 0
	
	Local $i
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			$arMenuItems[$i][1] = $sText
			_SetOwnerDrawn($arMenuItems[$i][3], $nMenuID, $sText, FALSE)
			GUICtrlSetData($nMenuID, $sText)
			_SetOwnerDrawn($arMenuItems[$i][3], $nMenuID, $sText)
			Return 1
		EndIf
	Next
	
	Return 0
EndFunc


;**********************************************************************
; _TrayIconCreate([ToolTip [, IconFile [, IconID]]])
;**********************************************************************
Func _TrayIconCreate($sToolTip = "", $sIconFile = @AutoItExe, $nIconID = 0, $sCallback = "", $nMsg = 0, $hIcon = 0)
	If $sToolTip = "" Then $sToolTip = $sDefaultTT
	
	$nIconID = _GetIconID($nIconID, $sIconFile)
		
	If $sIconFile = "" Then
		If $hIcon = 0 Then
			If $nIconID = 0 Then
				$sIconFile = @AutoItExe
			Else
				$hIcon = LoadIcon(0, $nIconID)
			EndIf
		EndIf
	EndIf
	
	If $sIconFile <> "" Then
		Local $stIcon = DllStructCreate("hwnd")
		If ExtractIconEx($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1) > 0 Then
			$hIcon = DllStructGetData($stIcon, 1)
		Else
			$hIcon = LoadIcon(0, 32516)
		EndIf
	EndIf
	
	If $TRAYMSGWND = 0 Then
		$TRAYMSGWND = GUICreate("", 1, 1, 9999, 9999, -1, 0x00000080)
		GUISetState()
		ShowWindow($TRAYMSGWND, @SW_HIDE)
	EndIf
	
	Local $nNID = _GetNewTrayIndex()
	If $nNID = 0 Then
		DestroyIcon($hIcon)
		Return 0
	EndIf
	
	$TRAYNOTIFYIDS[$nNID][0] = $nNID
	$TRAYNOTIFYIDS[$nNID][1] = $hIcon
	$TRAYNOTIFYIDS[$nNID][2] = 0
	$TRAYNOTIFYIDS[$nNID][3] = 9
	$TRAYNOTIFYIDS[$nNID][4] = $sToolTip
	$TRAYNOTIFYIDS[$nNID][5] = $sCallback
	$TRAYNOTIFYIDS[$nNID][6] = $nMsg
	$TRAYNOTIFYIDS[$nNID][7] = FALSE
	$TRAYNOTIFYIDS[$nNID][8] = FALSE
		
	$TRAYLASTID = $nNID
	
	Return $nNID
EndFunc


;**********************************************************************
; _TrayIconDelete($NotificationID)
;**********************************************************************
Func _TrayIconDelete($nID)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0
	
	Local $stNID = DllStructCreate($sNOTIFYICONDATAW)
	
	DllStructSetData($stNID, 1, DllStructGetSize($stNID))
	DllStructSetData($stNID, 2, $TRAYMSGWND)
	DllStructSetData($stNID, 3, $nID)
	
	Local $nResult = 0

	Local $i
	For $i = 1 To $TRAYNOTIFYIDS[0][0]
		If $nID = $TRAYNOTIFYIDS[$i][0] Then
			Local $stNID = DllStructCreate($sNOTIFYICONDATAW)
	
			DllStructSetData($stNID, 1, DllStructGetSize($stNID))
			DllStructSetData($stNID, 2, $TRAYMSGWND)
			DllStructSetData($stNID, 3, $nID)
	
			$nResult = Shell_NotifyIcon($NIM_DELETE, DllStructGetPtr($stNID))
			
			DestroyIcon($TRAYNOTIFYIDS[$i][1])
			$TRAYNOTIFYIDS[$i][8] = FALSE
			$TRAYNOTIFYIDS[$i][7] = FALSE
			$TRAYNOTIFYIDS[$i][6] = 0
			$TRAYNOTIFYIDS[$i][5] = ""
			$TRAYNOTIFYIDS[$i][4] = ""
			$TRAYNOTIFYIDS[$i][3] = 0
			
			If $TRAYNOTIFYIDS[$i][2] <> 0 Then GUIDelete($TRAYNOTIFYIDS[$i][2])
			
			$TRAYNOTIFYIDS[$i][2] = 0
			$TRAYNOTIFYIDS[$i][1] = 0
			$TRAYNOTIFYIDS[$i][0] = 0
			
			ExitLoop
		EndIf
	Next
	
	Return $nResult
EndFunc


;**********************************************************************
; _TrayIconSetState($NotificationID, $NewState)
;**********************************************************************
Func _TrayIconSetState($nID = -1, $nState = 1)
	If $nState = 0 Then Return 1 ; No change
	
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0
	
	Local $i, $nResult = 0, $bFound = FALSE

	For $i = 1 To $TRAYNOTIFYIDS[0][0]
		If $nID = $TRAYNOTIFYIDS[$i][0] Then
			$bFound = TRUE
			ExitLoop
		EndIf
	Next
		
	If Not $bFound Then Return 0

	Local $stNID = DllStructCreate($sNOTIFYICONDATAW)

	If BitAnd($nState, 1) Then
		DllStructSetData($stNID, 1, DllStructGetSize($stNID))
		DllStructSetData($stNID, 2, $TRAYMSGWND)
		DllStructSetData($stNID, 3, $nID)
		DllStructSetData($stNID, 4, BitOr($NIF_ICON, $NIF_MESSAGE))
		DllStructSetData($stNID, 5, $TRAYTIPMSG)
		DllStructSetData($stNID, 6, $TRAYNOTIFYIDS[$nID][1])

		$nResult = Shell_NotifyIcon($NIM_ADD, DllStructGetPtr($stNID))
		If $nResult Then _TrayIconSetToolTip($nID, $TRAYNOTIFYIDS[$nID][4])
	ElseIf BitAnd($nState, 2) Then
		DllStructSetData($stNID, 1, DllStructGetSize($stNID))
		DllStructSetData($stNID, 2, $TRAYMSGWND)
		DllStructSetData($stNID, 3, $nID)
		
		$nResult = Shell_NotifyIcon($NIM_DELETE, DllStructGetPtr($stNID))
	EndIf
	
	If BitAnd($nState, 4) Then
		If Not $TRAYNOTIFYIDS[$nID][7] Then
			If $hBlankIcon = 0 Then _CreateBlankIcon()
			If $hBlankIcon <> 0 Then
				SetTimer($TRAYMSGWND, $FLASHTIMERID, $FLASHTIMEOUT, 0)
				$TRAYNOTIFYIDS[$nID][7] = TRUE
			EndIf
		EndIf
	ElseIf BitAnd($nState, 8) Then
		KillTimer($TRAYMSGWND, $FLASHTIMERID)

		DllStructSetData($stNID, 1, DllStructGetSize($stNID))
		DllStructSetData($stNID, 2, $TRAYMSGWND)
		DllStructSetData($stNID, 3, $nID)
		DllStructSetData($stNID, 4, $NIF_ICON)
		DllStructSetData($stNID, 6, $TRAYNOTIFYIDS[$nID][1])
		
		$nResult = Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))
		
		$TRAYNOTIFYIDS[$nID][7] = FALSE
		$TRAYNOTIFYIDS[$nID][8] = FALSE
	EndIf
	
	Return $nResult
EndFunc


;**********************************************************************
; _TrayIconSetIcon($NotificationID, IconFile [, IconID])
;**********************************************************************
Func _TrayIconSetIcon($nID = -1, $sIconFile = @AutoItExe, $nIconID = 0)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0
	
	$nIconID = _GetIconID($nIconID, $sIconFile)
	
	Local $hIcon = 0
	
	If $sIconFile = "" Then
		If $nIconID = 0 Then
			$sIconFile = @AutoItExe
		Else
			$hIcon = LoadIcon(0, $nIconID)
		EndIf
	EndIf
	
	If $sIconFile <> "" Then
		Local $stIcon = DllStructCreate("hwnd")
		
		If ExtractIconEx($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1) > 0 Then
			$hIcon = DllStructGetData($stIcon, 1)
		Else
			$hIcon = LoadIcon(0, 32516)
		EndIf
	EndIf
	
	Local $stNID	= DllStructCreate($sNOTIFYICONDATAW)
	DllStructSetData($stNID, 1, DllStructGetSize($stNID))
	DllStructSetData($stNID, 2, $TRAYMSGWND)
	DllStructSetData($stNID, 3, $nID)
	DllStructSetData($stNID, 4, $NIF_ICON)
	DllStructSetData($stNID, 6, $hIcon)

	DestroyIcon($TRAYNOTIFYIDS[$nID][1])
	
	Local $nResult = Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))
	If $nResult Then
		$TRAYNOTIFYIDS[$nID][1] = $hIcon
	Else
		DestroyIcon($hIcon)
		$TRAYNOTIFYIDS[$nID][1] = 0
	EndIf
	
	Return $nResult
EndFunc


;**********************************************************************
; _TrayIconSetToolTip($NotificationID, $sToolTip)
;**********************************************************************
Func _TrayIconSetToolTip($nID = -1, $sToolTip = $sDefaultTT)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0
	
	Local $stNID	= DllStructCreate($sNOTIFYICONDATAW)
	DllStructSetData($stNID, 1, DllStructGetSize($stNID))
	DllStructSetData($stNID, 2, $TRAYMSGWND)
	DllStructSetData($stNID, 3, $nID)
	DllStructSetData($stNID, 4, $NIF_TIP)
	DllStructSetData($stNID, 7, $sToolTip)

	Return Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))
EndFunc


;**********************************************************************
; _TrayGetMenuHandle($NotificationID)
;**********************************************************************
Func _TrayGetMenuHandle($nID)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0
	
	Return $TRAYNOTIFYIDS[$nID][2]
EndFunc


;**********************************************************************
; Return a free index in the item array or create a new index
;**********************************************************************
Func _GetNewItemIndex()
	Local $i = 0, $bFreeFound = FALSE
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = 0 Then
			$bFreeFound = TRUE
			ExitLoop
		EndIf
	Next

	If Not $bFreeFound Then
		$arMenuItems[0][0] += 1
		Local $nSize = UBound($arMenuItems)

		If $arMenuItems[0][0] > $nSize - $nMenuItemsRedim Then _
			Redim $arMenuItems[$nSize + $nMenuItemsRedim][8]
		$i = $arMenuItems[0][0]
	EndIf
	
	Return $i
EndFunc


;**********************************************************************
; Create a (context) menu for a tray notify ID
;**********************************************************************
Func _TrayCreateMenu($nID, $sText, $nMenuID = 0, $nMenuEntry = -1)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0

	If $TRAYNOTIFYIDS[$nID][2] = 0 Then
		Local $nDummy = GUICtrlCreateDummy()
		Local $nContext = GUICtrlCreateContextMenu($nDummy)
		
		$TRAYNOTIFYIDS[$nID][2] = $nContext
	EndIf

	If $nMenuID = 0 Then $nMenuID = $TRAYNOTIFYIDS[$nID][2]
	
	Local $nMenu = GUICtrlCreateMenu($sText, $nMenuID, $nMenuEntry)
	
	If $nMenu > 0 Then
		Local $nIdx = _GetNewItemIndex()
		If $nIdx = 0 Then Return 0

		$MENULASTITEM = $nMenu
						
		Local $hMenu = GUICtrlGetHandle($nMenuID)
		
		$arMenuItems[$nIdx][0] = $nMenu
		$arMenuItems[$nIdx][1] = $sText
		$arMenuItems[$nIdx][2] = -1
		$arMenuItems[$nIdx][3] = $hMenu
		$arMenuItems[$nIdx][4] = 0
		$arMenuItems[$nIdx][5] = TRUE
		$arMenuItems[$nIdx][6] = -1
		$arMenuItems[$nIdx][7] = TRUE
	EndIf
	
	Return $nMenu
EndFunc


;**********************************************************************
; Create a menuitem for a tray notify ID
;**********************************************************************
Func _TrayCreateItem($nID, $sText, $nMenuID = 0, $nMenuEntry = -1, $bRadio = 0)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0

	If $TRAYNOTIFYIDS[$nID][2] = 0 Then
		Local $nDummy = GUICtrlCreateDummy()
		Local $nContext = GUICtrlCreateContextMenu($nDummy)
		
		$TRAYNOTIFYIDS[$nID][2] = $nContext
	EndIf

	If $nMenuID = 0 Then $nMenuID = $TRAYNOTIFYIDS[$nID][2]
	
	Local $nMenuItem = GUICtrlCreateMenuItem($sText, $nMenuID, $nMenuEntry, $bRadio)
	
	If $nMenuItem > 0 Then
		Local $nIdx = _GetNewItemIndex()
		If $nIdx = 0 Then Return 0
	
		$MENULASTITEM = $nMenuItem
		
		Local $hMenu = GUICtrlGetHandle($nMenuID)
		
		$arMenuItems[$nIdx][0] = $nMenuItem
		$arMenuItems[$nIdx][1] = $sText
		$arMenuItems[$nIdx][2] = -1
		$arMenuItems[$nIdx][3] = $hMenu
		$arMenuItems[$nIdx][4] = $bRadio
		$arMenuItems[$nIdx][5] = TRUE
		$arMenuItems[$nIdx][6] = -1
		$arMenuItems[$nIdx][7] = FALSE
	EndIf
	
	Return $nMenuItem
EndFunc


;**********************************************************************
; Delete a menu (item)
;**********************************************************************
Func _GUICtrlODMenuItemDelete($nID)
	Return _TrayDeleteItem($nID)
EndFunc


Func _TrayDeleteItem($nID)
	Local $i, $k, $nResult = 0, $bFound = FALSE
	
	Local $hMenu = GUICtrlGetHandle($nID)
	Local $bIsMenu = FALSE
	If $hMenu <> 0 Then $bIsMenu = TRUE
		
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nID Or $bIsMenu Then
			If $bIsMenu Then
				For $k = 1 To $arMenuItems[0][0]
					If $arMenuItems[$k][3] = $hMenu And _
						$k <> $i Then _TrayDeleteItem($arMenuItems[$k][0])					
				Next
			EndIf
		EndIf
		
		If $arMenuItems[$i][0] = $nID Then
			If GUICtrlDelete($nID) Then
				$arMenuItems[$i][0] = 0
				$arMenuItems[$i][1] = ""
				$arMenuItems[$i][2] = -1
				$arMenuItems[$i][3] = 0
				$arMenuItems[$i][4] = 0
				$arMenuItems[$i][5] = FALSE
				$arMenuItems[$i][6] = -1
				$arMenuItems[$i][7] = FALSE
				
				$nResult = 1
				$bFound = TRUE
			EndIf
			
			ExitLoop
		EndIf
	Next
	
	If Not $bFound Then GUICtrlDelete($nID)
	
	Return $nResult
EndFunc


;**********************************************************************
; Sets the possible clicks
;**********************************************************************
Func _TrayIconSetClick($nID, $nClicks)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0
	
	$TRAYNOTIFYIDS[$nID][3] = $nClicks
EndFunc


;**********************************************************************
; TrayTip()
;**********************************************************************
Func _TrayTip($nID, $sTitle, $sText, $nTimeOut = 10, $nInfoFlags = 0)
	If @OSType <> "WIN32_NT" Then Return 0
	If @OSVersion = "WIN_NT4" Then Return 0

	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0
	
	Local $stNID = DllStructCreate($sNOTIFYICONDATAW)

	DllStructSetData($stNID, 1, DllStructGetSize($stNID))
	DllStructSetData($stNID, 2, $TRAYMSGWND)
	DllStructSetData($stNID, 3, $nID)
	DllStructSetData($stNID, 4, $NIF_INFO)
	DllStructSetData($stNID, 10, $sText)
	DllStructSetData($stNID, 11, $nTimeOut * 1000)
	DllStructSetData($stNID, 12, $sTitle)
	DllStructSetData($stNID, 13, $nInfoFlags)
	
 	Local $nResult = Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))

 	Return $nResult
EndFunc


;********************************************************************
; WM_MEASURE procedure
;********************************************************************
Func WM_MEASUREITEM($hWnd, $Msg, $wParam, $lParam)
	Local $nResult = FALSE
	
	Local $stMeasureItem = DllStructCreate("uint;uint;uint;uint;uint;dword", $lParam)
	
	If DllStructGetData($stMeasureItem, 1) = $ODT_MENU Then
		
		Local $nIconSize	= 0
		Local $nCheckX		= 0
		Local $nSpace		= 2
		
		_GetMenuInfos($nIconSize, $nCheckX)
		
		If $nIconSize < $nCheckX Then $nIconSize = $nCheckX
		
		Local $nMenuItemID	= DllStructGetData($stMeasureItem, 3)
		
		Local $hDC			= GetDC($hWnd)
				
		Local $hMenu		= _GetMenuHandle($nMenuItemID)

		Local $nState		= GetMenuState($hMenu, $nMenuItemID, $MF_BYCOMMAND)
		
		; Reassign the current menu font to the menuitem
		Local $hMFont		= 0
		Local $bBoldFont	= FALSE
		
		If BitAnd($nState, $MF_DEFAULT) And Not BitAnd($nState, $MF_POPUP) Then
			_CreateMenuFont($hMFont, TRUE)
			$bBoldFont	= TRUE
		Else
			$hMFont = $hMenuFont
		EndIf
		
		Local $hFont		= SelectObject($hDC, $hMFont)
				
		Local $sText		= _GetMenuText($nMenuItemID)
		
		Local $stSize		= DllStructCreate("int;int")
		
		Local $nMaxTextWidth	= 0
		Local $nMaxTextAccWidth	= 0
		
		_GetMenuMaxTextWidth($hDC, $hMenu, $nMaxTextWidth, $nMaxTextAccWidth)
		If $nMaxTextAccWidth > 0 Then $nMaxTextAccWidth += 4
		
		Local $nHeight		= 2 * $nSpace + $nIconSize
		Local $nWidth		= 0
	
		; Set a default separator height
		If $sText = "" Then
			$nHeight = 4
		Else
			$nWidth	= 6 * $nSpace + 2 * $nIconSize + $nMaxTextWidth + $nMaxTextAccWidth
			
			; Maybe this differs - have no emulator here at the moment
			If @OSVersion <> "WIN_98" And @OSVersion <> "WIN_ME" Then 
				$nWidth = $nWidth - $nCheckX + 1
			EndIf
		EndIf

		DllStructSetData($stMeasureItem, 4, $nWidth)	; ItemWidth
		DllStructSetData($stMeasureItem, 5, $nHeight)	; ItemHeight

		SelectObject($hDC, $hFont)
		If $bBoldFont Then DeleteObject($hMFont)
		
		$stMenuLogFont = 0
		
		ReleaseDC($hWnd, $hDC)
		$nResult = TRUE
	EndIf

	$stMeasureItem	= 0

	Return $nResult
EndFunc


;********************************************************************
; WM_DRAWITEM procedure
;********************************************************************

Func WM_DRAWITEM($hWnd, $Msg, $wParam, $lParam)
	Local $nResult		= FALSE
	
	Local $stDrawItem	= DllStructCreate("uint;uint;uint;uint;uint;dword;dword;int[4];dword", $lParam)
	
	If DllStructGetData($stDrawItem, 1) = $ODT_MENU Then
		Local $nMenuItemID	= DllStructGetData($stDrawItem, 3)
		Local $nState		= DllStructGetData($stDrawItem, 5)
		Local $hMenu		= DllStructGetData($stDrawItem, 6)
		Local $hDC			= DllStructGetData($stDrawItem, 7)
		
		Local $bChecked		= BitAnd($nState, $ODS_CHECKED)
		Local $bGrayed		= BitAnd($nState, $ODS_GRAYED)
		Local $bSelected	= BitAnd($nState, $ODS_SELECTED)
		Local $bDefault		= BitAnd($nState, $ODS_DEFAULT)
		Local $bNoAcc		= BitAnd($nState, $ODS_NOACCEL)
		Local $bIsRadio		= _GetMenuIsRadio($nMenuItemID)
		Local $arIR[4]
		$arIR[0]			= DllStructGetData($stDrawItem, 8, 1)
		$arIR[1]			= DllStructGetData($stDrawItem, 8, 2)
		$arIR[2]			= DllStructGetData($stDrawItem, 8, 3)
		$arIR[3]			= DllStructGetData($stDrawItem, 8, 4)

		Local $stItemRect	= DllStructCreate("int;int;int;int")
		_SetItemRect($stItemRect, $arIR[0], $arIR[1], $arIR[2], $arIR[3])
		
		; Set default menu values if info function fails
		Local $nIconSize	= 16
		Local $nCheckX		= 16
		Local $nSpace		= 2

		_GetMenuInfos($nIconSize, $nCheckX)

		Local $nMBkClr			= $nMenuBkClr
		Local $nMIconBkClr		= $nMenuIconBkClr
		Local $nMSelectBkClr	= $nMenuSelectBkClr
		Local $nMSelectRectClr	= $nMenuSelectRectClr
		Local $nMSelectTextClr	= $nMenuSelectTextClr
		Local $nMTextClr		= $nMenuTextClr
		
		Local $bIsTrayItem		= _IsTrayItem($nMenuItemID)
		If $bIsTrayItem Then
			$nMBkClr			= $nTrayBkClr
			$nMIconBkClr		= $nTrayIconBkClr
			$nMSelectBkClr		= $nTraySelectBkClr
			$nMSelectRectClr	= $nTraySelectRectClr
			$nMSelectTextClr	= $nTraySelectTextClr
			$nMTextClr			= $nTrayTextClr
		EndIf
		
		; Select our at beginning selfcreated menu font into the item device context
		Local $hMFont		= 0
		Local $bBoldFont	= FALSE
		
		If $bDefault Then
			_CreateMenuFont($hMFont, TRUE)
			$bBoldFont = TRUE
		Else
			$hMFont = $hMenuFont
		EndIf
		
		Local $hFont		= SelectObject($hDC, $hMFont)
		Local $hBrush		= 0
		Local $nClrSel		= 0
		Local $hBorderBrush	= 0
		
		; Only show a menu bar when the item is enabled
		If $bSelected Then ;And Not $bGrayed Then
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				$hBorderBrush	= CreateSolidBrush($nMSelectRectClr)
				If $bGrayed Then
					$hBrush		= CreateSolidBrush($nMBkClr)
					$nClrSel	= $nMBkClr
				Else
					$hBrush		= CreateSolidBrush($nMSelectBkClr) ; BGR color value
					$nClrSel	= $nMSelectBkClr
				EndIf
				
			Else
				$hBrush			= GetSysColorBrush($COLOR_HIGHLIGHT)
				$nClrSel		= GetSysColor($COLOR_HIGHLIGHT)
			EndIf
		Else
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				$hBrush			= CreateSolidBrush($nMBkClr)
				$nClrSel		= $nMBkClr
			Else
				$hBrush			= GetSysColorBrush($COLOR_MENU)
				$nClrSel		= GetSysColor($COLOR_MENU)
			EndIf
		EndIf
		
		Local $nClrTxt		= 0
		
		If $bSelected And Not $bGrayed Then
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				$nClrTxt	= SetTextColor($hDC, $nMSelectTextClr)
			Else
				$nClrTxt	= SetTextColor($hDC, GetSysColor($COLOR_HIGHLIGHTTEXT))
			EndIf
		ElseIf $bGrayed Then
			$nClrTxt		= SetTextColor($hDC, GetSysColor($COLOR_GRAYTEXT))
		Else
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				$nClrTxt	= SetTextColor($hDC, $nMTextClr)
			Else
				$nClrTxt	= SetTextColor($hDC, GetSysColor($COLOR_MENUTEXT))
			EndIf
		EndIf	
		
		Local $nClrBk		= SetBkColor($hDC, $nClrSel)
		Local $hOldBrush	= SelectObject($hDC, $hBrush)
		
		FillRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
		SelectObject($hDC, $hOldBrush)
		DeleteObject($hBrush)

		If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
			; Create a small gray edge
			If Not $bSelected Or $bGrayed Then
				; Reassign the item rect
				_SetItemRect($stItemRect, $arIR[0], $arIR[1], $arIR[0] + 2 * $nSpace + $nIconSize + 1, $arIR[3])
						
				$hBrush	= CreateSolidBrush($nMIconBkClr)
				
				$hOldBrush = SelectObject($hDC, $hBrush);
				
				FillRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
	
				SelectObject($hDC, $hOldBrush)
				DeleteObject($hBrush)
			EndIf
		EndIf

		If $bChecked Then
			_SetItemRect($stItemRect, $arIR[0] + 1, $arIR[1] + 1, $arIR[0] + $nIconSize + $nSpace + 1, $arIR[1] + $nIconSize + $nSpace + 1)
			
			If $bSelected Then
				If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
					$hBrush		= CreateSolidBrush($nMSelectBkClr)
				Else
					$hBrush		= GetSysColorBrush($COLOR_HIGHLIGHT)
				EndIf	
			Else
				If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
					$hBrush		= CreateSolidBrush($nMBkClr)
				Else
					$hBrush		= GetSysColorBrush($COLOR_MENU)
				EndIf
			EndIf
			
			$hOldBrush	= SelectObject($hDC, $hBrush)
			FillRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
			SelectObject($hDC, $hOldBrush)
			DeleteObject($hBrush)

			; Create a checkmark/bullet for the checked/radio items
			Local $hDCBitmap	= CreateCompatibleDC($hDC)
			Local $hbmpCheck	= CreateBitmap($nIconSize, $nIconSize, 1, 1, 0)
			Local $hbmpOld		= SelectObject($hDCBitmap, $hbmpCheck)
		
			Local $x = DllStructGetData($stItemRect, 1) + ($nIconSize + $nSpace - $nCheckX) / 2
			Local $y = DllStructGetData($stItemRect, 2) + ($nIconSize + $nSpace - $nCheckX) / 2 - $nSpace
			
			_SetItemRect($stItemRect, 0, 0, $nIconSize, $nIconSize)
				
			Local $nCtrlStyle = $DFCS_MENUCHECK
			
			If $bIsRadio Then $nCtrlStyle = $DFCS_MENUBULLET
			
			DrawFrameControl($hDCBitmap, DllStructGetPtr($stItemRect), $DFC_MENU, $nCtrlStyle)
			
			BitBlt($hDC, $x, $y + 1, $nCheckX, $nCheckX, $hDCBitmap, 0, 0, $SRCCOPY)
			
			Local $hOldBitBrush	= SelectObject($hDCBitmap, $hBrush)
			FillRect($hDCBitmap, DllStructGetPtr($stItemRect), $hBrush)
			
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				_SetItemRect($stItemRect, $arIR[0] + 1, $arIR[1] + 1, $arIR[0] + $nIconSize + $nSpace + 1, $arIR[1] + $nIconSize + $nSpace + 1)
				$hBrush	= CreateSolidBrush($nMSelectRectClr)					
				$hOldBrush	= SelectObject($hDC, $hBrush)
				FrameRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
				SelectObject($hDC, $hOldBrush)
				DeleteObject($hBrush)
			EndIf
			
			SelectObject($hDCBitmap, $hbmpOld)
			DeleteObject($hbmpCheck)
			DeleteDC($hDCBitmap)
		EndIf		

		; Reassign the item rect
		_SetItemRect($stItemRect, $arIR[0], $arIR[1], $arIR[2], $arIR[3])

		If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
			;If $bSelected And Not $bGrayed Then
			If $bSelected Then ; Show also a rect around a disabled item
				$hOldBrush	= SelectObject($hDC, $hBorderBrush)
				FrameRect($hDC, DllStructGetPtr($stItemRect), $hBorderBrush)
				SelectObject($hDC, $hOldBrush)
				DeleteObject($hBorderBrush)		
			EndIf
		EndIf

		Local $sText	= _GetMenuText($nMenuItemID)
		If $bNoAcc Then $sText = StringReplace($sText, "&", "")
		
		Local $nWidth			= 0
				
		Local $sAcc		= ""
		Local $arText	= StringSplit($sText, @Tab)
		Local $bTab		= FALSE
		
		If IsArray($arText) And $arText[0] > 1 Then
			$sText	= $arText[1]
			$sAcc	= $arText[2]
			$bTab	= TRUE
		EndIf
		
		Local $stText	= 0
		Local $nLen		= StringLen($sText)
				
		$stText = DllStructCreate("wchar[" & $nLen + 1 & "]")
		DllStructSetData($stText, 1, $sText)
						
		Local $nSaveLeft	= DllStructGetData($stItemRect, 1)
		Local $nLeft		= $nSaveLeft
		$nLeft += $nSpace		; Left border
		$nLeft += $nSpace		; Space after gray border
		$nLeft += $nIconSize	; Icon width
		$nLeft += $nSpace + 2	; Right after the icon
		
		DllStructSetData($stItemRect, 1, $nLeft)
		
		Local $nFlags		= BitOr($DT_NOCLIP, $DT_SINGLELINE, $DT_VCENTER)
		
		DrawText($hDC, DllStructGetPtr($stText), $nLen, DllStructGetPtr($stItemRect), $nFlags)
		
		; Draw accelerator text
		If $bTab Then
			Local $nMaxTextWidth	= 0
			Local $nMaxTextAccWidth	= 0
			
			_GetMenuMaxTextWidth($hDC, $hMenu, $nMaxTextWidth, $nMaxTextAccWidth)
			If $nMaxTextAccWidth > 0 Then $nMaxTextAccWidth += 4
			
			$nWidth	= 6 * $nSpace + 2 * $nIconSize + $nMaxTextWidth
				
			; Maybe this differs - have no emulator here at the moment
			If @OSVersion <> "WIN_98" And @OSVersion <> "WIN_ME" Then 
				$nWidth = $nWidth - $nCheckX + 1
			EndIf
			
			$nLen		= StringLen($sAcc)
			$stText = DllStructCreate("wchar[" & $nLen + 1 & "]")
			DllStructSetData($stText, 1, $sAcc)
			
			; Set rect for acc text
			_SetItemRect($stItemRect, $arIR[0] + $nWidth, $arIR[1], $arIR[0] + $nWidth + $nMaxTextAccWidth, $arIR[3])
			
			DrawText($hDC, DllStructGetPtr($stText), $nLen, DllStructGetPtr($stItemRect), $nFlags)
			
			; Reset rect values
			_SetItemRect($stItemRect, $arIR[0], $arIR[1], $arIR[2], $arIR[3])
		EndIf
		
		Local $nNoSelIconIndex = -1
		Local $nSelIconIndex = -1
				
		_GetMenuIconIndex($nMenuItemID, $nNoSelIconIndex, $nSelIconIndex)		
		
		Local $nIconIndex = $nNoSelIconIndex
		If $bSelected And $nSelIconIndex > -1 Then $nIconIndex = $nSelIconIndex
	
		If $nIconIndex > -1 Then
			If Not $bChecked Then
				If $bGrayed Then
					; An easy way to draw something that looks deactivated
					ImageList_DrawEx($hMenuImageList, _
									$nIconIndex, _
									$hDC, _
									$nSpace, _
									DllStructGetData($stItemRect, 2) + 2, _
									0, _
									0, _
									$CLR_NONE, _
									$CLR_NONE, _
									BitOr($ILD_BLEND, $ILD_TRANSPARENT))
				Else
					; Draw the icon "normal"
					ImageList_Draw($hMenuImageList, _
								$nIconIndex, _
								$hDC, _
								$nSpace, _
								DllStructGetData($stItemRect, 2) + 2, _
								$ILD_TRANSPARENT)
				EndIf
			EndIf
		EndIf

		DllStructSetData($stItemRect, 1, $nSaveLeft)
		
		; Draw a "line" for a separator item
		If StringLen($sText) = 0 Then
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				DllStructSetData($stItemRect, 1, DllStructGetData($stItemRect, 1) + 4 * $nSpace + $nIconSize)
			Else
				DllStructSetData($stItemRect, 1, DllStructGetData($stItemRect, 1))
			EndIf
			DllStructSetData($stItemRect, 2, DllStructGetData($stItemRect, 2) + 1)
			DllStructSetData($stItemRect, 4, DllStructGetData($stItemRect, 1) + 2)
			DrawEdge($hDC, DllStructGetPtr($stItemRect), $EDGE_ETCHED, $BF_TOP)
		EndIf
		
		$stText		= 0
		$stRect		= 0
		$stItemRect	= 0

		SelectObject($hDC, $hFont)
		If $bBoldFont Then DeleteObject($hMFont)
		
		$stMenuLogFont = 0
		
		SetTextColor($hDC, $nClrTxt)
		SetBkColor($hDC, $nClrBk)

		$nResult = TRUE
	EndIf
	
	$stDrawItem	= 0
	
	Return $nResult	
EndFunc


;********************************************************************
; Sets 4 values to a itemrect struct 
;********************************************************************
Func _SetItemRect(ByRef $stStruct, $p1, $p2, $p3, $p4)
	DllStructSetData($stStruct, 1, $p1)
	DllStructSetData($stStruct, 2, $p2)
	DllStructSetData($stStruct, 3, $p3)
	DllStructSetData($stStruct, 4, $p4)
EndFunc


;********************************************************************
; WM_SETTINGCHANGE procedure
;********************************************************************
Func WM_SETTINGCHANGE($hWnd, $Msg, $wParam, $lParam)
	If $wParam = $SPI_SETNONCLIENTMETRICS Then _CreateMenuFont($hMenuFont)
EndFunc


;********************************************************************
; WM_TIMER procedure
;********************************************************************
Func WM_TIMER($hWnd, $Msg, $wParam, $lParam)
	Local $nID = Number($wParam)

	If $TRAYNOTIFYIDS[$nID][0] > 0 Then
		If $TRAYNOTIFYIDS[$nID][7] Then
			Local $stNID	= DllStructCreate($sNOTIFYICONDATAW)
			DllStructSetData($stNID, 1, DllStructGetSize($stNID))
			DllStructSetData($stNID, 2, $TRAYMSGWND)
			DllStructSetData($stNID, 3, $nID)
			DllStructSetData($stNID, 4, $NIF_ICON)
			
			If $TRAYNOTIFYIDS[$nID][8] Then
				DllStructSetData($stNID, 6, $hBlankIcon)
				$TRAYNOTIFYIDS[$nID][8] = FALSE
			Else
				DllStructSetData($stNID, 6, $TRAYNOTIFYIDS[$nID][1])
				$TRAYNOTIFYIDS[$nID][8] = TRUE
			EndIf
			
			Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))
		EndIf
	EndIf

	KillTimer($TRAYMSGWND, $FLASHTIMERID)
	SetTimer($TRAYMSGWND, $FLASHTIMERID, $FLASHTIMEOUT, 0)	
EndFunc


;********************************************************************
; Create a menu item and set its style to OwnerDrawn
;********************************************************************
Func _GUICtrlCreateODMenuItem($sMenuItemText, $nParentMenu, $sIconFile = "", $nIconID = 0, $bRadio = 0)
	Local $nMenuItem	= GUICtrlCreateMenuItem($sMenuItemText, $nParentMenu, -1, $bRadio)
	
	$nIconID = _GetIconID($nIconID, $sIconFile)
	
	If $nMenuItem > 0 Then
		Local $nIdx = _GetNewItemIndex()
		If $nIdx = 0 Then Return 0

		$MENULASTITEM = $nMenuItem
						
		Local $hMenu		= GUICtrlGetHandle($nParentMenu)
		
		$arMenuItems[$nIdx][0] = $nMenuItem
		$arMenuItems[$nIdx][1] = $sMenuItemText
		$arMenuItems[$nIdx][2] = _AddMenuIcon($sIconFile, $nIconID)
		$arMenuItems[$nIdx][3] = $hMenu
		$arMenuItems[$nIdx][4] = $bRadio
		$arMenuItems[$nIdx][5] = FALSE
		$arMenuItems[$nIdx][6] = -1
		$arMenuItems[$nIdx][7] = FALSE
		
		_SetOwnerDrawn($hMenu, $nMenuItem, $sMenuItemText)
	EndIf
		
	Return $nMenuItem
EndFunc


;********************************************************************
; Create a menu and set its style to OwnerDrawn
;********************************************************************
Func _GUICtrlCreateODMenu($sText, $nParentMenu, $sIconFile = "", $nIconID = 0)
	Local $nMenu	= GUICtrlCreateMenu($sText, $nParentMenu)
	
	$nIconID = _GetIconID($nIconID, $sIconFile)
	
	If $nMenu > 0 Then
		Local $nIdx = _GetNewItemIndex()
		If $nIdx = 0 Then Return 0
		
		$MENULASTITEM = $nMenu
		
		Local $hMenu	= GUICtrlGetHandle($nParentMenu)
		
		$arMenuItems[$nIdx][0] = $nMenu
		$arMenuItems[$nIdx][1] = $sText
		$arMenuItems[$nIdx][2] = _AddMenuIcon($sIconFile, $nIconID)
		$arMenuItems[$nIdx][3] = $hMenu
		$arMenuItems[$nIdx][4] = 0
		$arMenuItems[$nIdx][5] = FALSE
		$arMenuItems[$nIdx][6] = -1
		$arMenuItems[$nIdx][7] = TRUE
		
		_SetOwnerDrawn($hMenu, $nMenu, $sText)
	EndIf
	
	Return $nMenu
EndFunc


;********************************************************************
; Set the text of an menu item
;********************************************************************
Func _GUICtrlODMenuItemSetText($nMenuID, $sText)
	If $nMenuID = -1 Then $nMenuID = $MENULASTITEM
	If $nMenuID <= 0 Then Return 0
	
	Local $i
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			$arMenuItems[$i][1] = $sText
			_SetOwnerDrawn($arMenuItems[$i][3], $nMenuID, $sText, FALSE)
			GUICtrlSetData($nMenuID, $sText)
			_SetOwnerDrawn($arMenuItems[$i][3], $nMenuID, $sText)
			Return 1
		EndIf
	Next
EndFunc


;********************************************************************
; Set the icon of an menu item
;********************************************************************
Func _GUICtrlODMenuItemSetIcon($nMenuID, $sIconFile = "", $nIconID = 0)
	If $nMenuID = -1 Then $nMenuID = $MENULASTITEM
	If $nMenuID <= 0 Then Return 0
	
	$nIconID = _GetIconID($nIconID, $sIconFile)
	
	Local $i	
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			If $sIconFile = "" Then
				$arMenuItems[$i][2] = -1
			Else
				If $arMenuItems[$i][2] = -1 Then
					$arMenuItems[$i][2] = _AddMenuIcon($sIconFile, $nIconID)
				Else
					_ReplaceMenuIcon($sIconFile, $nIconID, $arMenuItems[$i][2])
				EndIf
			EndIf
			
			Return 1
		EndIf
	Next
	
	Return 0
EndFunc


;********************************************************************
; Set the selected icon of an menu item
;********************************************************************
Func _GUICtrlODMenuItemSetSelIcon($nMenuID, $sIconFile = "", $nIconID = 0)
	If $nMenuID = -1 Then $nMenuID = $MENULASTITEM
	If $nMenuID <= 0 Then Return 0
	
	$nIconID = _GetIconID($nIconID, $sIconFile)
	
	Local $i	
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			If $sIconFile = "" Then
				$arMenuItems[$i][6] = -1
			Else
				If $arMenuItems[$i][6] = -1 Then
					$arMenuItems[$i][6] = _AddMenuIcon($sIconFile, $nIconID)
				Else
					_ReplaceMenuIcon($sIconFile, $nIconID, $arMenuItems[$i][6])
				EndIf
			EndIf
			
			Return 1
		EndIf
	Next
	
	Return 0
EndFunc


;********************************************************************
; Add an icon to our menu image list
;********************************************************************
Func _AddMenuIcon($sIconFile, $nIconID)
	Local $stIcon	= DllStructCreate("hwnd")
	
	Local $nCount	= ExtractIconEx($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1)
	
	Local $nIndex	= -1
	
	If $nCount > 0 Then
		$hIcon	= DllStructGetData($stIcon, 1)
		$nIndex	= ImageList_AddIcon($hMenuImageList, $hIcon)
		DestroyIcon($hIcon)
	EndIf
	
	$stIcon = 0
	
	Return $nIndex
EndFunc


;********************************************************************
; Replace an icon in our menu image list
;********************************************************************
Func _ReplaceMenuIcon($sIconFile, $nIconID, $nReplaceIndex)
	If $nReplaceIndex < 0 Then Return -1
	
	Local $stIcon	= DllStructCreate("hwnd")
	
	Local $nCount	= ExtractIconEx($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1)
	
	Local $nIndex	= -1
	
	If $nCount > 0 Then
		$hIcon	= DllStructGetData($stIcon, 1)
		ImageList_ReplaceIcon($hMenuImageList, $nReplaceIndex, $hIcon)
		DestroyIcon($hIcon)
	EndIf
	
	$stIcon = 0
	
	Return 1
EndFunc


;********************************************************************
; Get the parent menu handle for a menu item
;********************************************************************
Func _GetMenuHandle($nMenuItemID)
	Local $i, $hMenu = 0
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$hMenu = $arMenuItems[$i][3]
			ExitLoop
		EndIf
	Next
	
	Return $hMenu
EndFunc


;********************************************************************
; Get the index of a menu item in our store
;********************************************************************
Func _GetMenuIndex($hMenu, $nMenuItemID)
	Local $nIndex	= -1
	Local $nCount	= GetMenuItemCount($hMenu)
	Local $nPos, $nID
	
	For $nPos = 0 To $nCount[0] - 1
		$nID = GetMenuItemID($hMenu, $nPos)
		If $nID = $nMenuItemID Then
			$nIndex = $nPos
			ExitLoop
		EndIf
	Next
	
	Return $nIndex
EndFunc


;********************************************************************
; Get the menu item text
;********************************************************************
Func _GetMenuText($nMenuItemID)
	Local $i, $sText = ""
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$sText = $arMenuItems[$i][1]
			ExitLoop
		EndIf
	Next
	
	Return $sText			
EndFunc


;********************************************************************
; Get the maximum text width in a menu
;********************************************************************
Func _GetMenuMaxTextWidth($hDC, $hMenu, ByRef $nMaxWidth, ByRef $nMaxAccWidth)
	Local $i, $stSize, $stText, $nLen, $nAccLen
	Local $nWidth		= 0
	Local $nAccWidth	= 0
	Local $arString
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][3] = $hMenu Then
			$arString = StringSplit($arMenuItems[$i][1], @Tab)
			If Not IsArray($arString) Then ContinueLoop
			
			If $arString[0] > 1 Then
				$nLen	= StringLen($arString[2])
				$stSize	= DllStructCreate("int;int")
				
				$stText = DllStructCreate("wchar[" & $nLen + 1 & "]")
				DllStructSetData($stText, 1, $arString[2])
				
				GetTextExtentPoint32($hDC, DllStructGetPtr($stText), $nLen, DllStructGetPtr($stSize))
				
				$nAccWidth = DllStructGetData($stSize, 1)
				$stText	= 0
				$stSize	= 0
				
				If $nAccWidth > $nMaxAccWidth Then $nMaxAccWidth = $nAccWidth			
			EndIf
			
			$nLen	= StringLen($arString[1])
			$stSize	= DllStructCreate("int;int")
			
			$stText = DllStructCreate("wchar[" & $nLen + 1 & "]")
			DllStructSetData($stText, 1, $arString[1])
			
			GetTextExtentPoint32($hDC, DllStructGetPtr($stText), $nLen, DllStructGetPtr($stSize))
					
			$nWidth = DllStructGetData($stSize, 1)
			$stText	= 0
			$stSize	= 0
			
			If $nWidth > $nMaxWidth Then $nMaxWidth = $nWidth
		EndIf
	Next
EndFunc


;********************************************************************
; Get the index of an icon from our store
;********************************************************************
Func _GetMenuIsRadio($nMenuItemID)
	Local $i, $bRadio = 0
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$bRadio = $arMenuItems[$i][4]
			ExitLoop
		EndIf
	Next
	
	Return $bRadio			
EndFunc


;********************************************************************
; Get the index of an icon from our store
;********************************************************************
Func _GetMenuIconIndex($nMenuItemID, ByRef $nIconIndex, ByRef $nSelIconIndex)
	Local $i
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$nIconIndex = $arMenuItems[$i][2]
			$nSelIconIndex = $arMenuItems[$i][6]
			ExitLoop
		EndIf
	Next
EndFunc


;********************************************************************
; Check if the item is from a tray menu
;********************************************************************
Func _IsTrayItem($nMenuItemID)
	Local $i, $bTray = FALSE
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$bTray = $arMenuItems[$i][5]
			ExitLoop
		EndIf
	Next
	
	Return $bTray			
EndFunc


;********************************************************************
; Get some system menu constants
;********************************************************************
Func _GetMenuInfos(ByRef $nS, ByRef $nX)
	$nS	= GetSystemMetrics($SM_CXSMICON)
	$nX	= GetSystemMetrics($SM_CXMENUCHECK)
EndFunc


;********************************************************************
; Convert a normal menu item to an ownerdrawn menu item
;********************************************************************
Func _SetOwnerDrawn($hMenu, $MenuItemID, $sText, $bOwnerDrawn = TRUE)
	Local $stItemData = 0, $nLen
	
	If $bOwnerDrawn Then
		$stItemData = DllStructcreate("int")
		DllStructSetData($stItemData, 1, $MenuItemID)
	Else
		$nLen = StringLen($sText)
		$stItemData = DllStructcreate("wchar[" & $nLen + 1 & "]")
		DllStructSetData($stItemData, 1, $sText)
	EndIf
	
	Local $nFlags = $MF_BYCOMMAND
	If $bOwnerDrawn Then $nFlags = BitOr($nFlags, $MF_OWNERDRAW)
	
	If StringLen($sText) = 0 Then $nFlags = BitOr($nFlags, $MF_SEPARATOR)
	
	ModifyMenu($hMenu, $MenuItemID, $nFlags, $MenuItemID, DllStructGetPtr($stItemData))
EndFunc


;********************************************************************
; Get the default menu font
;********************************************************************
Func _CreateMenuFont(ByRef $hFont, $bBold = FALSE)
	Local $stNCM = DllStructCreate($sNONCLIENTMETRICS)
	DllStructSetData($stNCM, 1, DllStructGetSize($stNCM))
	
	If SystemParametersInfo($SPI_GETNONCLIENTMETRICS, DllStructGetSize($stNCM), DllStructGetPtr($stNCM), 0) Then
		Local $stMenuLogFont = DllStructCreate($sLOGFONT)
		
		Local $i			
		For $i = 1 To 14
			DllStructSetData($stMenuLogFont, $i, DllStructGetData($stNCM, $i + 38))
		Next
		
		If $bBold Then DllStructSetData($stMenuLogFont, 5, 700)
		
		If $hFont > 0 Then DeleteObject($hFont)
				
		$hFont = CreateFontIndirect(DllStructGetPtr($stMenuLogFont))
		If $hFont = 0 Then $hFont = _CreateMenuFontByName("MS Sans Serif")
	EndIf
EndFunc


Func _CreateMenuFontByName($sFontName, $nHeight = 8, $nWidth = 400)
	Local $stFontName = DllStructCreate("char[260]")
	DllStructSetData($stFontName, 1, $sFontName)
	
	Local $hDC		= GetDC(0) ; Get the Desktops DC
	Local $nPixel	= GetDeviceCaps($hDC, 90)
	
	$nHeight	= 0 - MulDiv($nHeight, $nPixel, 72)
		
	ReleaseDC(0, $hDC)
	
	Local $hFont = CreateFont($nHeight, _
								0, _
								0, _
								0, _
								$nWidth, _
								0, _
								0, _
								0, _
								0, _
								0, _
								0, _
								0, _
								0, _
								DllStructGetPtr($stFontName))

	$stFontName = 0
	
	Return $hFont
EndFunc


;********************************************************************
; Create a blank icon for flash functionality
;********************************************************************
Func _CreateBlankIcon()
	If $hBlankIcon = 0 Then
		If @OSVersion = "WIN_VISTA" Or @OSVersion = "WIN_2008" Then
			Local $stIcon = DllStructCreate("hwnd")
			
			If ExtractIconEx("shell32.dll", 50, 0, DllStructGetPtr($stIcon), 1) Then _
				$hBlankIcon = DllStructGetData($stIcon, 1)
		Else
			Local $stAndMask = DllStructCreate("byte[64]")
			memset(DllStructGetPtr($stAndMask), 0xFF, 64)

        	Local $stXorMask = DllStructCreate("byte[64]")
			memset(DllStructGetPtr($stXorMask), 0x0, 64)
	
			$hBlankIcon = CreateIcon(0, 16, 16, 1, 1, DllStructGetPtr($stAndMask), DllStructGetPtr($stXorMask))
		EndIf
	EndIf
	
	Return $hBlankIcon
EndFunc


;********************************************************************
; CommCtrl.h - functions
;********************************************************************
Func ImageList_Create($nImageWidth, $nImageHeight, $nFlags, $nInitial, $nGrow)
	Local $hImageList = DllCall($hComctl32Dll, "hwnd", "ImageList_Create", _
														"int", $nImageWidth, _
														"int", $nImageHeight, _
														"int", $nFlags, _
														"int", $nInitial, _
														"int", $nGrow)
	Return $hImageList[0]
EndFunc


Func ImageList_AddIcon($hIml, $hIcon)
	Local $nIndex = DllCall($hComctl32Dll, "int", "ImageList_AddIcon", _
													"hwnd", $hIml, _
													"hwnd", $hIcon)
	Return $nIndex[0]
EndFunc


Func ImageList_Destroy($hIml)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_Destroy", _
													"hwnd", $hIml)
	Return $bResult[0]
EndFunc


Func ImageList_Draw($hIml, $nIndex, $hDC, $nX, $nY, $nStyle)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_Draw", _
													"hwnd", $hIml, _
													"int", $nIndex, _
													"hwnd", $hDC, _
													"int", $nX, _
													"int", $nY, _
													"int", $nStyle)
	Return $bResult[0]
EndFunc


Func ImageList_DrawEx($hIml, $nIndex, $hDC, $nX, $nY, $nDx, $nDy, $nBkClr, $nFgClr, $nStyle)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_DrawEx", _
													"hwnd", $hIml, _
													"int", $nIndex, _
													"hwnd", $hDC, _
													"int", $nX, _
													"int", $nY, _
													"int", $nDx, _
													"int", $nDy, _
													"int", $nBkClr, _
													"int", $nFgClr, _
													"int", $nStyle)
	Return $bResult[0]
EndFunc


Func ImageList_ReplaceIcon($hIml, $nIndex, $hIcon)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_ReplaceIcon", _
													"hwnd", $hIml, _
													"int", $nIndex, _
													"hwnd", $hIcon)
	Return $bResult[0]
EndFunc


;********************************************************************
; ShellApi.h - functions
;********************************************************************
Func ExtractIconEx($sIconFile, $nIconID, $ptrIconLarge, $ptrIconSmall, $nIcons)
	Local $nCount = DllCall($hShell32Dll, "int", "ExtractIconEx", _
												"str", $sIconFile, _
												"int", $nIconID, _
												"ptr", $ptrIconLarge, _
												"ptr", $ptrIconSmall, _
												"int", $nIcons)
	Return $nCount[0]
EndFunc


Func Shell_NotifyIcon($nMessage, $pNID)
	Local $nResult = DllCall($hShell32Dll, "int", "Shell_NotifyIconW", _
													"int", $nMessage, _
													"ptr", $pNID)
	Return $nResult[0]
EndFunc


;********************************************************************
; WinBase.h - functions
;********************************************************************
Func MulDiv($nInt1, $nInt2, $nInt3)
	$nResult = DllCall("kernel32.dll", "int", "MulDiv", _
											"int", $nInt1, _
											"int", $nInt2, _
											"int", $nInt3)
	Return $nResult[0]
EndFunc


;********************************************************************
; WinGDI.h - functions
;********************************************************************
Func SelectObject($hDC, $hObj)
	Local $hOldObj = DllCall($hGdi32Dll, "int", "SelectObject", _
												"hwnd", $hDC, _
												"hwnd", $hObj)
	Return $hOldObj[0]
EndFunc


Func DeleteObject($hObj)
	Local $bResult = DllCall($hGdi32Dll, "int", "DeleteObject", _
												"hwnd", $hObj)
	Return $bResult[0]
EndFunc


Func CreateFont($nHeight, $nWidth, $nEscape, $nOrientn, $fnWeight, $bItalic, $bUnderline, $bStrikeout, $nCharset, $nOutputPrec, $nClipPrec, $nQuality, $nPitch, $ptrFontName)
	Local $hFont = DllCall($hGdi32Dll, "hwnd", "CreateFont", _
												"int", $nHeight, _
												"int", $nWidth, _
												"int", $nEscape, _
												"int", $nOrientn, _
												"int", $fnWeight, _
												"long", $bItalic, _
												"long", $bUnderline, _
												"long", $bStrikeout, _
												"long", $nCharset, _
												"long", $nOutputPrec, _
												"long", $nClipPrec, _
												"long", $nQuality, _
												"long", $nPitch, _
												"ptr", $ptrFontName)
	Return $hFont[0]
EndFunc


Func CreateFontIndirect($pLogFont)
	Local $hFont = DllCall($hGdi32Dll, "hwnd", "CreateFontIndirectW", _
												"ptr", $pLogFont)
	Return $hFont[0]
EndFunc


Func GetTextExtentPoint32($hDC, $ptrText, $nTextLength, $ptrSize)
	Local $bResult = DllCall($hGdi32Dll, "int", "GetTextExtentPoint32W", _
												"hwnd" ,$hDC, _
												"ptr", $ptrText, _
												"int", $nTextLength, _
												"ptr", $ptrSize)
	Return $bResult[0]
EndFunc


Func SetBkColor($hDC, $nColor)
	Local $nOldColor = DllCall($hGdi32Dll, "int", "SetBkColor", _
												"hwnd", $hDC, _
												"int", $nColor)
	Return $nOldColor[0]
EndFunc


Func SetTextColor($hDC, $nColor)
	Local $nOldColor = DllCall($hGdi32Dll, "int", "SetTextColor", _
												"hwnd", $hDC, _
												"int", $nColor)
	Return $nOldColor[0]
EndFunc


Func CreateSolidBrush($nColor)
	Local $hBrush = DllCall($hGdi32Dll, "int", "CreateSolidBrush", _
												"int", $nColor)
	Return $hBrush[0]
EndFunc


Func GetDeviceCaps($hDC, $nIndex)
	Local $nResult = DllCall($hGdi32Dll, "int", "GetDeviceCaps", _
												"hwnd", $hDC, _
												"int", $nIndex)
	Return $nResult[0]
EndFunc


Func CreateCompatibleDC($hDC)
	Local $hCompDC = DllCall($hGdi32Dll, "hwnd", "CreateCompatibleDC", _
												"hwnd", $hDC)
	Return $hCompDC[0]
EndFunc


Func DeleteDC($hDC)
	Local $bResult = DllCall($hGdi32Dll, "int", "DeleteDC", _
												"hwnd", $hDC)
	Return $bResult[0]
EndFunc


Func CreateBitmap($nWidth, $nHeight, $nCPlanes, $nCBitsPerPixel, $ptrCData)
	Local $hBitmap = DllCall($hGdi32Dll, "hwnd", "CreateBitmap", _
												"int", $nWidth, _
												"int", $nHeight, _
												"int", $nCPlanes, _
												"int", $nCBitsPerPixel, _
												"ptr", $ptrCData)
	Return $hBitmap[0]
EndFunc


Func BitBlt($hDCDest, $nXDest, $nYDest, $nWidth, $nHeight, $hDCSrc, $nXSrc, $nYSrc, $nOpCode)
	Local $bResult = DllCall($hGdi32Dll, "int", "BitBlt", _
												"hwnd", $hDCDest, _
												"int", $nXDest, _
												"int", $nYDest, _
												"int", $nWidth, _
												"int", $nHeight, _
												"hwnd", $hDCSrc, _
												"int", $nXSrc, _
												"int", $nYSrc, _
												"long", $nOpCode)
	Return $bResult[0]
EndFunc


;********************************************************************
; WinUser.h - functions
;********************************************************************
Func GetDC($hWnd)
	Local $hDC = DllCall($hUser32Dll, "int", "GetDC", _
											"hwnd", $hWnd)
	Return $hDC[0]
EndFunc


Func ReleaseDC($hWnd, $hDC)
	Local $bResult = DllCall($hUser32Dll, "int", "ReleaseDC", _
												"hwnd", $hWnd, _
												"hwnd", $hDC)
	Return $bResult[0]
EndFunc


Func GetSysColor($nIndex)
	Local $nColor = DllCall($hUser32Dll, "int", "GetSysColor", _
												"int", $nIndex)
	Return $nColor[0]
EndFunc


Func GetSysColorBrush($nIndex)
	Local $hBrush = DllCall($hUser32Dll, "hwnd", "GetSysColorBrush", _
												"int", $nIndex)
	Return $hBrush[0]
EndFunc


Func LoadIcon($hInstance, $nIcon)
	Local $hIcon = DllCall($hUser32Dll, "hwnd", "LoadIcon", _
												"hwnd", $hInstance, _
												"int", $nIcon)
	Return $hIcon[0]
EndFunc


Func DestroyIcon($hIcon)
	Local $bResult = DllCall($hUser32Dll, "int", "DestroyIcon", _
												"hwnd", $hIcon)
	Return $bResult[0]
EndFunc


Func CreateIcon($hInstance, $nWidth, $nHeight, $nPlanes, $nBitsPixel, $pAndBits, $pXorBits)
	Local $hResult = DllCall($hUser32Dll, "hwnd", "CreateIcon", _
													"hwnd", $hInstance, _
													"int", $nWidth, _
													"int", $nHeight, _
													"byte", $nPlanes, _
													"byte", $nBitsPixel, _
													"ptr", $pAndBits, _
													"ptr", $pXorBits)
	Return $hResult[0]
EndFunc


Func GetSystemMetrics($nIndex)
	Local $nResult = DllCall($hUser32Dll, "int", "GetSystemMetrics", _
												"int", $nIndex)
	Return $nResult[0]
EndFunc


Func DrawText($hDC, $ptrText, $nLenText, $ptrRect, $nFlags)
	Local $nHeight = DllCall($hUser32Dll, "int", "DrawTextW", _
												"hwnd", $hDC, _
												"ptr", $ptrText, _
												"int", $nLenText, _
												"ptr", $ptrRect, _
												"int", $nFlags)
	Return $nHeight[0]
EndFunc


Func GetMenuItemCount($hMenu)
	Local $nCount = DllCall($hUser32Dll, "int", "GetMenuItemCount", _
												"hwnd", $hMenu)
	Return $nCount[0]
EndFunc


Func GetMenuItemID($hMenu, $nPos)
	Local $nID = DllCall($hUser32Dll, "int", "GetMenuItemID", _
											"hwnd", $hMenu, _
											"int", $nPos)
	Return $nID[0]
EndFunc


Func GetMenuState($hMenu, $nID, $nFlags)
	Local $nState = DllCall($hUser32Dll, "int", "GetMenuState", _
												"hwnd", $hMenu, _
												"int", $nID, _
												"int", $nFlags)
	Return $nState[0]
EndFunc

											
Func ModifyMenu($hMenu, $nID, $nFlags, $nNewID, $ptrItemData)
	Local $bResult = DllCall($hUser32Dll, "int", "ModifyMenu", _
												"hwnd", $hMenu, _
												"int", $nID, _
												"int", $nFlags, _
												"int", $nNewID, _
												"ptr", $ptrItemData)
	Return $bResult[0]
EndFunc


Func FillRect($hDC, $ptrRect, $hBrush)
	Local $bResult = DllCall($hUser32Dll, "int", "FillRect", _
												"hwnd", $hDC, _
												"ptr", $ptrRect, _
												"hwnd", $hBrush)
	Return $bResult[0]
EndFunc


Func DrawEdge($hDC, $ptrRect, $nEdgeType, $nBorderFlag)
	Local $bResult = DllCall($hUser32Dll, "int", "DrawEdge", _
												"hwnd", $hDC, _
												"ptr", $ptrRect, _
												"int", $nEdgeType, _
												"int", $nBorderFlag)
	Return $bResult[0]
EndFunc


Func FrameRect($hDC, $ptrRect, $hBrush)
	Local $bResult = DllCall($hUser32Dll, "int", "FrameRect", _
												"hwnd", $hDC, _
												"ptr", $ptrRect, _
												"hwnd", $hBrush)
	Return $bResult[0]
EndFunc


Func DrawFrameControl($hDC, $ptrRect, $nType, $nState)
	Local $bResult = DllCall($hUser32Dll, "int", "DrawFrameControl", _
												"hwnd", $hDC, _
												"ptr", $ptrRect, _
												"int", $nType, _
												"int", $nState)
	Return $bResult[0]
EndFunc


Func SystemParametersInfo($nAction, $nParam, $pParam, $nWinini)
	Local $nResult = DllCall($hUser32Dll, "int", "SystemParametersInfoW", _
												"uint", $nAction, _
												"uint", $nParam, _
												"ptr", $pParam, _
												"uint", $nWinini)
	Return $nResult[0]
EndFunc


Func GetCursorPos($pPoint)
	$nResult = DllCall($hUser32Dll, "hwnd", "GetCursorPos", _
											"ptr", $pPoint)
	Return $nResult[0]
EndFunc


Func SetForegroundWindow($hWnd)
	$nResult = DllCall($hUser32Dll, "int", "SetForegroundWindow", _
											"hwnd", $hWnd)
	Return $nResult[0]
EndFunc


Func TrackPopupMenuEx($hMenu, $nFlags, $nX, $nY, $hWnd, $pParams)
    Local $nResult = DllCall($hUser32Dll, "int", "TrackPopupMenuEx", _
    												"hwnd", $hMenu, _
    												"uint", $nFlags, _
    												"int", $nX, _
    												"int", $nY, _
    												"hwnd", $hWnd, _
    												"ptr", $pParams)    
    Return $nResult[0]
EndFunc


Func PostMessage($hWnd, $nMsg, $wParam, $lParam)
    Local $nResult = DllCall($hUser32Dll, "int", "PostMessage", _
    												"hwnd", $hWnd, _
    												"uint", $nMsg, _
    												"dword", $wParam, _
    												"dword", $lParam)
    Return $nResult[0]
EndFunc


Func ShowWindow($hWnd, $nState)
	DllCall($hUser32Dll, "int", "ShowWindow", _
								"hwnd", $hWnd, _
								"int", $nState)
EndFunc


Func SetTimer($hWnd, $nID, $nTimeOut, $pFunc)
	Local $nResult = DllCall($hUser32Dll, "uint", "SetTimer", _
													"hwnd", $hWnd, _
													"uint", $nID, _
													"uint", $nTimeOut, _
													"ptr", $pFunc)
	Return $nResult[0]
EndFunc


Func KillTimer($hWnd, $nID)
	Local $nResult = DllCall($hUser32Dll, "int", "KillTimer", _
													"hwnd", $hWnd, _
													"uint", $nID)
	Return $nResult[0]
EndFunc


Func memset($pDest, $nChr, $nCount)
	Local $pResult = DllCall("msvcrt.dll", "ptr:cdecl", "memset", _
														"ptr", $pDest, _
														"int", $nChr, _
														"int", $nCount)
	Return $pResult[0]
EndFunc
