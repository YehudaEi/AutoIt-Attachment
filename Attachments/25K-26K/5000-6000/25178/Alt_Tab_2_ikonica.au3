#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <ScreenCapture.au3>
#include <StructureConstants.au3>
#Include <Misc.au3>
#Include <Array.au3>
#include <EditConstants.au3>
#include <Math.au3>
#include <StaticConstants.au3>

Opt("OnExitFunc", "endscript")

;~ HotKeySet("!{TAB}", "_nothing")
HotKeySet("{ESC}", "_izlaz") ;exit

Global Const $VK_TAB = 0x09
Global Const $VK_Tilda = 0xC0

Global $HOTKEY = $VK_Tilda ;can be switched back to $VK_TAB

Global $lock_tab = False, $changes = false, $alt_down_right = false, $alt_down_left = False, $win_hwnd_count = 0, $size_x, $size_y
Global $current_windows, $new_handle, $win_hwnd_count_x = 0
Global $fill_color = "000000";"EBE9EE"
;~ Global $general_icon
dim $new_handle_x[9]

; ==================================================================================================
; Global Device-Drive Mapping array & state of array (for internal use)
; ==================================================================================================

Global $_aINTDeviceToDriveMapArray
Global $_bINTDeviceToDriveMapInit=False

$hHookProc = DllCallbackRegister("_KeyboardProc", "long", "int;wparam;lparam")
$hHookKeyboard = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hHookProc), _WinAPI_GetModuleHandle(0), 0)

$Form0 = GUICreate("Form1", 400, 300, -1, -1)		
GUISetState(@SW_HIDE, $form0)

$form2 = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_TOPMOST, $form0)
GUISetBkColor(0, $form2)
WinSetTrans($form2, "", 150)
GUISetState(@SW_HIDE, $form2)

$form12 = GUICreate("base", 500, 440, @DesktopWidth/2-250, @DesktopHeight/2-250, $WS_POPUP, $WS_EX_TOPMOST, $Form0)
_GuiRoundCorners($form12, 5, 5, 15, 15)
GUISetBkColor(0)
$label_form2 = GUICtrlCreateLabel("", 5, 340, 490, 39, $ES_CENTER)
GUICtrlSetFont(-1, 12, 800, 2, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)

$gui_graph = GUICtrlCreateGraphic(228-150, 384, 44, 44)
GUICtrlSetColor($gui_graph, 0x007CB9)

GUISetState(@SW_HIDE, $form12)

$form9 = GUICreate("shader", 207-150, 32, @DesktopWidth/2-233, @DesktopHeight/2+140, $WS_POPUP, $WS_EX_TOPMOST, $form12)
GUISetBkColor(0)
WinSetTrans($form9, "", 200)
GUISetState(@SW_HIDE, $form9)

$form8 = GUICreate("shader2", 207+150, 32, @DesktopWidth/2+26-150, @DesktopHeight/2+140, $WS_POPUP, $WS_EX_TOPMOST, $form12)
GUISetBkColor(0)
WinSetTrans($form8, "", 200)
GUISetState(@SW_HIDE, $form8)

$Form1 = GUICreate("win picture", 400, 300, @DesktopWidth/2-200, @DesktopHeight/2-220, $WS_POPUP, $WS_EX_TOPMOST, $form12)
_GDIPlus_Startup()
$hGraphic_x = _GDIPlus_GraphicsCreateFromHWND ($Form1)
$fix_image = GUICtrlCreatePic("", @DesktopWidth/2-200, @DesktopHeight/2-220, 400, 300)
GUICtrlSetState($fix_image, $GUI_HIDE)
GUISetBkColor(0x000000, $Form1)
GUISetState(@SW_HIDE, $form1)

$form_icons = guicreate("icons", 466, 32, @DesktopWidth/2-233, @DesktopHeight/2+140, $WS_POPUP, $WS_EX_TOPMOST, $form12)
$hGraphic_icons = _GDIPlus_GraphicsCreateFromHWND ($form_icons)
GUISetBkColor(0)
GUISetState(@SW_HIDE, $form_icons)

_GuiSetDropShadow($Form0, true)

AdlibEnable("test",500)
Func test()
    $lock_tab = False
EndFunc

;~ AdlibEnable("myadlib", 10) ; turn this line to make it work in real time, but it's bugged

;~ func _nothing()
;~ 	;yawn...
;~ EndFunc

func _izlaz()
	Exit
EndFunc

func _ScreenShot_of_a_window($i_win_handle, $iW, $iH, $h_which_graphic, $i_slide)
    Local $hDC = _WinAPI_GetWindowDC($i_win_handle)
    Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC)
    Local $hWinPos = WinGetPos($i_win_handle)
	if @error then return -1
    Local $hBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $hWinPos[2], $hWinPos[3])
    _WinAPI_SelectObject($hMemDC, $hBitmap)
	_WinAPI_BitBlt($hMemDC, 0, 0, $hWinPos[2], $hWinPos[3], $hDC, 0, 0, $CAPTUREBLT+$SRCCOPY)
    _PrintWindow($i_win_handle, $hMemDC)
    _WinAPI_DeleteDC($hMemDC)
    _WinAPI_ReleaseDC($i_win_handle, $hDC)
    _SavehBitmapEx($hBitmap, $iW, $iH, $h_which_graphic, $i_slide)
    _WinAPI_DeleteObject($hBitmap)
EndFunc

Func _SavehBitmapEx($hBitmap,$iWidth,$iHeight, $h_which_graphic, $i_slide)
    $bitmap=_GDIPlus_BitmapCreateFromHBITMAP($hbitmap)
    $graphics=_GDIPlus_ImageGetGraphicsContext($bitmap)
    $resizedbitmap=_GDIPlus_BitmapCreateFromGraphics($iWidth,$iHeight,$graphics)
    $graphics2=_GDIPlus_ImageGetGraphicsContext($resizedbitmap)
	_GDIPLUS_GraphicsSetInterpolationMode($graphics2, 2)
    _GDIPlus_GraphicsDrawImageRect($graphics2,$bitmap,0,0,$iWidth,$iHeight)
	$hBrush = _GDIPlus_BrushCreateSolid ("0xFF" & $fill_color)
	Local $i_count = 0
	Local $final_destination = 0, $reduced_height = 0
	Local $fill_up = 0, $fill_up_h = 0
	if $iWidth <> 400 Then
		$final_destination = 200-$iWidth/2
		$fill_up = 1
	EndIf
	if $iHeight <> 300 Then
		$reduced_height = 150-$iHeight/2
		$fill_up_h = 1
	EndIf
	if $i_slide = True Then
		for $i = $iWidth to $final_destination step -50
			_GDIPlus_GraphicsFillRect($h_which_graphic, $i, -1, 50, $reduced_height+2, $hBrush) ;iznad
			_GDIPlus_GraphicsFillRect($h_which_graphic, $i, $iHeight+$reduced_height-1, 51, 303-$iHeight-$reduced_height, $hBrush) ;ispod
			_GDIPlus_GraphicsDrawImage ($h_which_graphic, $resizedbitmap, $i, $reduced_height) ;slika
			_GDIPlus_GraphicsFillRect($h_which_graphic, $i+$iWidth, 0, 50, 300, $hBrush) ;iza
			$i_count = $i
			Sleep(1)
		Next
		if $i_count <> $final_destination Then
			_GDIPlus_GraphicsDrawImage ($h_which_graphic, $resizedbitmap, $final_destination, 0) ;slika
			_GDIPlus_GraphicsFillRect($h_which_graphic, $iWidth+$final_destination-1, 0, 400, 300, $hBrush)
		EndIf
		if $fill_up = 1 Then
			for $i = $final_destination-50 to 0 Step -50
				_GDIPlus_GraphicsFillRect($h_which_graphic, $i, 0, 50, 300, $hBrush)
				$i_count = $i
				Sleep(1)
			Next
		EndIf
		if $i_count <> $final_destination Then _GDIPlus_GraphicsFillRect($h_which_graphic, 0, 0, $final_destination, 300, $hBrush)
	Else
		_GDIPlus_GraphicsDrawImage ($h_which_graphic, $resizedbitmap, $final_destination, $reduced_height)
	EndIf
    _GDIPlus_GraphicsDispose($graphics)
    _GDIPlus_GraphicsDispose($graphics2)
	_GDIPlus_BrushDispose($hBrush)
    _GDIPlus_BitmapDispose($bitmap)
    _GDIPlus_BitmapDispose($resizedbitmap)
EndFunc

Func _GDIPLUS_GraphicsSetInterpolationMode($hGraphics, $iMode)
    DllCall($ghGDIPDll, "int", "GdipSetInterpolationMode", "hwnd", $hGraphics,"int",$iMode)
EndFunc  ;==>_GDIPLUS_GraphicsSetInterpolationMode

Func _PrintWindow($hWnd, $hMemDC, $iFlag = 0)
    $aRet = DllCall("User32.dll", "int", "PrintWindow", _
                                         "hwnd", $hWnd, _
                                         "ptr", $hMemDC, _
                                         "uint", $iFlag)
    Return $aRet[0]
EndFunc   ;==>_PrintWindow

func myadlib()
	if $changes = true Then
		_ScreenShot_of_a_window($new_handle, 400, 300, $hGraphic_x, False)
	EndIf
EndFunc

func _set_icon($control_id, $window_handle)
    If Not WinExists($window_handle) Then Return SetError(1, 0, 0)
    Local $GCL_HICONSM = -34
    Local $GCL_HICON = -14
	Local $general_icon = DllCall("user32.dll", "int", "GetClassLong", "hwnd", $window_handle, "int", $GCL_HICON)
    If $general_icon[0] = 0 Then
        $general_icon = DllCall("user32.dll", "int", "GetClassLong", "hwnd", $window_handle, "int", $GCL_HICONSM)
    EndIf
	if $general_icon[0] <> 0 Then
		$pBitmap = DllCall($ghGDIPDll,"int","GdipCreateBitmapFromHICON", "ptr",$general_icon[0], "int*",0)
		_GDIPlus_GraphicsDrawImageRect($hGraphic_icons, $pBitmap[2], $control_id*50+17, 0, 32, 32)
		_WinAPI_DestroyIcon($general_icon[0])
		_GDIPlus_ImageDispose($pBitmap[2])
	Else
		Local $path = _WinAPI_ProcessGetPathname(WinGetProcess($window_handle))
		Local $icon_exists = _GetIconCount($path)
		if $icon_exists <> 0 then
			Local $Ret = DllCall("shell32","long","ExtractAssociatedIcon","int",0,"str",$path,"int*",(-1*(-1))-1)
			$pBitmap = DllCall($ghGDIPDll,"int","GdipCreateBitmapFromHICON", "ptr",$ret[0], "int*",0)
			_GDIPlus_GraphicsDrawImageRect($hGraphic_icons, $pBitmap[2], $control_id*50+17, 0, 32, 32)		
			_GDIPlus_ImageDispose($pBitmap[2])
			_WinAPI_DestroyIcon($Ret[0])
		Else
			Local $Ret = DllCall("shell32","long","ExtractAssociatedIcon","int",0,"str","shell32.dll","int*",(-1*(-3))-1)
			$pBitmap = DllCall($ghGDIPDll,"int","GdipCreateBitmapFromHICON", "ptr",$ret[0], "int*",0)
			_GDIPlus_GraphicsDrawImageRect($hGraphic_icons, $pBitmap[2], $control_id*50+17, 0, 32, 32)		
			_GDIPlus_ImageDispose($pBitmap[2])
			_WinAPI_DestroyIcon($Ret[0])
		EndIf
	EndIf
EndFunc

Func _KeyboardProc($nCode, $wParam, $lParam)
    If $nCode < 0 Then Return _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
    Switch $wParam
        Case $WM_KEYDOWN, $WM_SYSKEYDOWN
            Local $tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
            Local $vKode = DllStructGetData($tKEYHOOKS, "vkCode")
            Local $iFlags = DllStructGetData($tKEYHOOKS, "flags")
			Switch $iFlags
				Case 33
					if $alt_down_left = false then $alt_down_right = True
				case 32
					if $alt_down_right = false then $alt_down_left = True
			EndSwitch
            Switch $vKode
				Case $HOTKEY
                    If BitAND($iFlags, $LLKHF_ALTDOWN) Then
						if $lock_tab = false then
							$current_windows = _WinGetAltTabWinList("","",True)
							if $current_windows[0][0] <= 1 then ContinueCase
							if @error then ContinueCase
							;=======================
							_GDIPlus_GraphicsClear($hGraphic_icons)
							
							$win_hwnd_count += 1
							if $win_hwnd_count = $current_windows[0][0]+1 then $win_hwnd_count = 1
							$new_handle = WinGetHandle($current_windows[$win_hwnd_count][1])
							$new_handle_x[1] = $new_handle
							GUICtrlSetData($label_form2, WinGetTitle($new_handle))
							
							;======================
							
							Local $last_count = $current_windows[0][0]-1-1
							if $last_count > 8-1 then $last_count = 8-1
							
							for $i = 1 to $last_count
								$win_hwnd_count_x = $win_hwnd_count+$i
								if $win_hwnd_count_x = $current_windows[0][0]+1 then
									$win_hwnd_count_x = 1
								ElseIf  $win_hwnd_count_x > $current_windows[0][0]+1 Then
									$win_hwnd_count_x = ($win_hwnd_count_x)-(Int($win_hwnd_count_x/($current_windows[0][0]+1)))*($current_windows[0][0])
									if $win_hwnd_count_x = $current_windows[0][0]+1 then $win_hwnd_count_x = 1
								endif
								$new_handle_x[$i+1] = WinGetHandle($current_windows[$win_hwnd_count_x][1])
							Next
							
							Local $hwnd_count_previous = $win_hwnd_count-1
							if $hwnd_count_previous = 0 then $hwnd_count_previous = $current_windows[0][0]
							$new_handle_x[0] = WinGetHandle($current_windows[$hwnd_count_previous][1])
							
							;=======================
							Local $odnos_x = 400/_WinAPI_GetWindowWidth($new_handle)
							Local $odnos_y = 300/_WinAPI_GetWindowHeight($new_handle)
							Local $ratio = _Min($odnos_x, $odnos_y)
							$size_x = Int($ratio*_WinAPI_GetWindowWidth($new_handle))+1
							if $size_x > 400 then $size_x = 400
							$size_y = Int($ratio*_WinAPI_GetWindowHeight($new_handle))+1
							if $size_y > 300 then $size_y = 300

							Local $get_win_state = WinGetState($form1)
							if NOT BitAnd($get_win_state, 2) Then
								GUISetState(@SW_SHOWNOACTIVATE, $form2)
								GUISetState(@SW_DISABLE, $Form2)
								GUISetState(@SW_SHOWNOACTIVATE, $Form12)
								GUISetState(@SW_DISABLE, $Form12)
								GUISetState(@SW_SHOWNOACTIVATE, $Form8)
								GUISetState(@SW_DISABLE, $Form8)
								GUISetState(@SW_SHOWNOACTIVATE, $Form9)
								GUISetState(@SW_DISABLE, $Form9)
								GUISetState(@SW_SHOWNOACTIVATE, $Form1)
								GUISetState(@SW_DISABLE, $Form1)
								GUISetState(@SW_SHOWNOACTIVATE, $form_icons)
								GUISetState(@SW_DISABLE, $form_icons)
								WinSetOnTop($form2, "", 1)
								WinSetOnTop($form12, "", 1)
								WinSetOnTop($form_icons, "", 1)
								WinSetOnTop($form8, "", 1)
								WinSetOnTop($form9, "", 1)
								WinSetOnTop($form1, "", 1)
								for $i = 1 to $last_count+1
									_set_icon($i, $new_handle_x[$i])
								Next
								_set_icon(0, $new_handle_x[0])
								_ScreenShot_of_a_window($new_handle, $size_x, $size_y, $hGraphic_x, False)
							else
								for $i = 1 to $last_count+1
									_set_icon($i, $new_handle_x[$i])
								Next
								_set_icon(0, $new_handle_x[0])
;~ 								_GDIPlus_GraphicsClear($hGraphic_x) ;Turn these 2 lines instead of the _ScreenShot_of_a_window bellow to make pictures switch without slide, it'll eliminate detecting win's default alt+tab
;~ 								_ScreenShot_of_a_window($new_handle, $size_x, $size_y, $hGraphic_x, False)
								_ScreenShot_of_a_window($new_handle, $size_x, $size_y, $hGraphic_x, True)
							EndIf
							$lock_tab = true
							$changes = true
						EndIf
                        Return -1
                    Else
                        Return _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
                    EndIf
			EndSwitch
		case $WM_KEYUP, $WM_SYSKEYUP
			Local $tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
            Local $vKode = DllStructGetData($tKEYHOOKS, "vkCode")
            Local $iFlags = DllStructGetData($tKEYHOOKS, "flags")
			Switch $iFlags
				Case 129
					if DllStructGetData($tKEYHOOKS, "scanCode") = 56 and DllStructGetData($tKEYHOOKS, "vkCode") = 165 and $changes = true and $alt_down_right = True then
						send("{CTRLDOWN}{ALTDOWN}{SHIFTDOWN}")
						Send("{CTRLUP}{ALTUP}{SHIFTUP}")
						GUISetState(@SW_HIDE, $form2)
						GUISetState(@SW_HIDE, $Form1)
						GUISetState(@SW_HIDE, $Form12)
						GUISetState(@SW_HIDE, $form_icons)
						GUISetState(@SW_HIDE, $Form8)
						GUISetState(@SW_HIDE, $Form9)
						WinActivate($new_handle)
						$win_hwnd_count = 1
						$changes = false
						$alt_down_right = False
					EndIf
				case 128
					if DllStructGetData($tKEYHOOKS, "scanCode") = 56 and DllStructGetData($tKEYHOOKS, "vkCode") = 164 and $changes = true and $alt_down_left = True then
						send("{CTRLDOWN}{ALTDOWN}{SHIFTDOWN}")
						Send("{CTRLUP}{ALTUP}{SHIFTUP}")
						GUISetState(@SW_HIDE, $form2)
						GUISetState(@SW_HIDE, $Form1)
						GUISetState(@SW_HIDE, $Form12)
						GUISetState(@SW_HIDE, $form_icons)
						GUISetState(@SW_HIDE, $Form8)
						GUISetState(@SW_HIDE, $Form9)
						WinActivate($new_handle)
						$win_hwnd_count = 1
						$changes = False
						$alt_down_left = False
					EndIf
			EndSwitch
            Switch $vKode
				Case $HOTKEY
                    If BitAND($iFlags, $LLKHF_ALTDOWN) Then
						if $lock_tab = true then
							$lock_tab = False
						EndIf
                        Return -1
                    Else
                        Return _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
                    EndIf
			EndSwitch
    EndSwitch
   
    Return _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
EndFunc   ;==>_KeyboardProc

; ===============================================================================================
; Func _WinGetAltTabWinList($sTitle="",$sText="",$bGetClassName=False)
;
; Returns list of visible Alt-Tab-able windows.
;
; $sTitle = (optional) Title of window, or window handle to send to initial WinList() call
; $sText = (optional) Visible text in window, same as WinList() call
; $bGetClassName = If True, a 3rd column will be created in the array containing the Window's class name
;
; Returns:
;   Success: An array of Windows in the same style as WinList, bottom element [0][0] = count,
;      with an optional 3rd column (depending on 3rd parameter)
;   Failure: A 1-element array same as WinList, with [0][0] = 0, and @error set
;      @error = 0 = WinList returned matches, but nothing matched Alt-Tab-able windows
;      @error = 1 = WinList return no matches
;      @error = 2 = DLLOpen failed
;
; Author: Authenticity, *very* slight modifications by Ascend4nt
; Original post @ http://www.autoitscript.com/forum/index.ph...st&p=648588
; ===============================================================================================

Func _WinGetAltTabWinList($sTitle="",$sText="",$bGetClassName=False)
    Dim $aReturnWinList[1][2]=[[0,0]],$aWinList

    ; Since passing an empty string or 'Default' keyword for 1st parameter
    ; causes WinList to return incorrect results, we test first
    If $sTitle<>"" Then
        $aWinList=WinList($sTitle,$sText)
    Else
        $aWinList=WinList()
    EndIf

    ; Check to see if any Windows matched, given the parameters. If not, return empty list
    If $aWinList[0][0]=0 Then Return SetError(1,0,$aReturnWinList)

    ; Open the DLL for faster calls.
    Local $hUser32 = DllOpen('user32.dll')
    If $hUser32==-1 Then Return SetError(2,0,$aReturnWinList)
   
    ; Does the caller want the Class name also?
    If $bGetClassName Then
        ; Set initial dimensions to match WinList's, +1 column
        Dim $aReturnWinList[$aWinList[0][0]+1][3]
    Else
        ; Set initial dimensions to match WinList's
        Dim $aReturnWinList[$aWinList[0][0]+1][2]
    EndIf
    ; Set the initial count to 0
    $aReturnWinList[0][0] = 0

    For $i = 1 To $aWinList[0][0]     
        ; If it's visible and *not* $GWL_EXSTYLE = WS_EX_TOOLWINDOW
        ;   (i.e. not a non-Alt-Tab-able window), then add it to the list
        If BitAND(WinGetState($aWinList[$i][1]), 2) AND _
                Not BitAND(_INT_GetWindowLong($aWinList[$i][1],0xFFFFFFEC,$hUser32), 0x80) AND _
				$aWinList[$i][1] <> WinGetHandle($Form2) AND $aWinList[$i][1] <> WinGetHandle($Form1) AND _
				$aWinList[$i][1] <> WinGetHandle($Form12) AND $aWinList[$i][1] <> WinGetHandle($Form8) AND _
				$aWinList[$i][1] <> WinGetHandle($Form9) AND $aWinList[$i][1] <> WinGetHandle($form_icons) Then
            $aReturnWinList[0][0]+=1
            $aReturnWinList[$aReturnWinList[0][0]][0]=$aWinList[$i][0]
            $aReturnWinList[$aReturnWinList[0][0]][1]=$aWinList[$i][1]
            If $bGetClassName Then $aReturnWinList[$aReturnWinList[0][0]][2]=_INT_GetClassName($aWinList[$i][1],$hUser32)
        EndIf
    Next
    ; Close DLL handle
    DllClose($hUser32)
    ; Redimension array to results size
    If $bGetClassName Then
        ReDim $aReturnWinList[$aReturnWinList[0][0]+1][3]
    Else
        ReDim $aReturnWinList[$aReturnWinList[0][0]+1][2]
    EndIf
    Return $aReturnWinList
EndFunc

; Basically the same as _WinAPI_GetWindowLong() standard UDF, but w/error checking+handle option

Func _INT_GetWindowLong($hWnd, $iIndex, $hUser = 'user32.dll')
    Local $aRet = DllCall($hUser, 'int', 'GetWindowLong', 'hwnd', $hWnd, 'int', $iIndex)
    If Not @error Then Return $aRet[0]
    Return SetError(-1, 0, -1)
EndFunc

; _WinAPI_GetClassName() standard UDF function, but w/error checking+handle option

Func _INT_GetClassName($hWnd,$hUser='user32.dll')
    Local $aResult
    If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
    $aResult = DllCall($hUser, "int", "GetClassName", "hwnd", $hWnd, "str", "", "int", 4096)
    If @error Or Not IsArray($aResult) Then Return SetError(@error,0,"")
    Return $aResult[2]
EndFunc

Func _GetIconCount($sFilename)
    Local $iCount= DllCall("Shell32", "int", "ExtractIconEx", "str", $sFilename, "int", -1, "ptr", 0, "ptr", 0, "int", 1)
    If not @error Then Return $iCount[0]
    Return 0
EndFunc

; ==================================================================================================
; Func _WinAPI_ProcessGetPathname($vProcessID,$bResetDriveMap=False)
;
; Alternative to _WinAPI_ProcessGetFileName (when called with a 'True' secondary parameter),
;   this works on WinXP+ and Win2003+ x64 OS's whereas the former 'full path' option does not.
;
; NOTE that because of the return type of the DLL call GetProcessImageFileName, there needs to be a translation.
;   This is handled by 'internal' functions in this source file which utilizes the QueryDosDevice call.
;
; ADDITIONAL NOTE: Certain processes require elevated privileges. See 'Privilege.au3' at:
;   http://www.autoitscript.com/forum/index.php?showtopic=75250&st=0&p=545798&#entry545798
;
; $vProcessID = process name (explorer.exe) or ID #
; $bResetDriveMap = If True, the Drive map array is reset. This is normally only set once, and automatically
;      reset if a match wasn't found. However, to force a remap, set this to True.
;
; Returns:
;   Success: Full pathname of process
;   Failure: "", with @error set
;      @error = 1 if invalid process name, or path not found
;      @error = 2 if DLL call failure
;      @error = 3 = Couldn't obtain Process handle
;      @error = 4 = GetProcessImageFileName returned a 0 for filename-length
;      @error = 5 if DriveGetDrive("ALL") call failure (only on 1st initialization)
;
; Author: Ascend4nt
; ==================================================================================================

Func _WinAPI_ProcessGetPathname($vProcessID,$bResetDriveMap=False)
    ; Not a Process ID? Must be a Process Name
    If Not IsNumber($vProcessID) Then
        $vProcessID=ProcessExists($vProcessID)
        ; Process Name not found (or invalid parameter?)
        If $vProcessID==0 Then Return SetError(1,0,"")
    EndIf
    Local $sImageFilename,$stImageFilename,$aRet,$tErr
    ; Get process handle (lod3n)
    ; Open Process handle (PROCESS_QUERY_INFORMATION 0x400 +PROCESS_VM_READ 0x10) @http://msdn.microsoft.com/en-us/library/ms684880(VS.85).aspx
    Local $hProcess = DllCall('kernel32.dll','ptr', 'OpenProcess','int', 0x410,'int', 0,'int', $vProcessID)
    If @error Then Return SetError(2,0,"")
    If Not $hProcess[0] Then Return SetError(3,0,"")
   
    $stImageFilename=DllStructCreate("wchar[32767]")
    $aRet=DllCall(@SystemDir & "\Psapi.dll","dword","GetProcessImageFileNameW","ptr",$hProcess[0],"ptr", _
        DllStructGetPtr($stImageFilename),"ulong",32767)
       
    If @error Then
        $tErr=2
    ElseIf Not $aRet[0] Then
        $tErr=4
    Else
        $tErr=0
    EndIf
    ; Close process
    DllCall('kernel32.dll','ptr', 'CloseHandle','ptr', $hProcess[0])
    ; Error above?
    If $tErr Then Return SetError($tErr,0,"")
    ; Grab device\filename
    $sImageFilename=DllStructGetData($stImageFilename,1)
    ; DLLStructDelete()
    $stImageFilename=0
    Return _INT_TranslateDeviceFilename($sImageFilename,$bResetDriveMap)
EndFunc

; ==================================================================================================
; Func _INT_BuildDeviceToDriveXlateArray()
;
; Internal function used to build the Device-Drive Map Array (using all available drives)
;   It calls DriveGetDrive("ALL") to get all drives, then uses the DLL call QueryDosDevice to get device names
;   The importance of this is in translating returns from GetProcessImageFileName DLL calls, which is the only
;   reliable way to get paths for processes on X64 OS's (x32 OS can use GetModuleFileNameEx)
;
; Returns: True if successfull, False if error with @error = 5 if DriveGetDrive() failure, @error=2 if DLL call error
; ==================================================================================================

Func _INT_BuildDeviceToDriveXlateArray()
    If $_bINTDeviceToDriveMapInit Then Return True
   
    Local $aRet,$aDriveArray=DriveGetDrive("ALL")
    If @error Then Return SetError(5,0,0)
   
    Local $stDriveName,$stReturnBuffer
   
    Dim $_aINTDeviceToDriveMapArray[$aDriveArray[0]][2]

    $stDriveName=DllStructCreate("wchar[3]")
    $stReturnBuffer=DllStructCreate("wchar[100]")   ; 100 is overkill, but I don't know the max device name currently
   
    For $i=1 To $aDriveArray[0]
        ; Put the drive letter in the array and in the structure (uppercase is part preference, & generally expected)
        $_aINTDeviceToDriveMapArray[$i-1][0]=StringUpper($aDriveArray[$i])
        DllStructSetData($stDriveName,1,$_aINTDeviceToDriveMapArray[$i-1][0])
        ; Get \Device\HarddiskVolume1, \Device\CdRom0, \Device\Floppy0 etc
        $aRet=DllCall("Kernel32.dll","dword","QueryDosDeviceW","ptr",DllStructGetPtr($stDriveName), _
            "ptr",DllStructGetPtr($stReturnBuffer),"ulong",200) 
        If @error Then
            ;ConsoleWrite("ERROR:" & _WinAPI_GetLastErrorMessage() & @CRLF)
            $_aINTDeviceToDriveMapArray=0
            Return SetError(2,0,False)
        EndIf
        ; Set the device name
        $_aINTDeviceToDriveMapArray[$i-1][1]=DllStructGetData($stReturnBuffer,1)
        ;ConsoleWrite("Drive-" & $aDriveArray[$i] & ",upper-" & $_aINTDeviceToDriveMapArray[$i-1][0] & ",Device:" & $_aINTDeviceToDriveMapArray[$i-1][1] & @CRLF)
    Next
    ;DLLStructDelete()'s
    $stDriveName=0
    $stReturnBuffer=0
    $_bINTDeviceToDriveMapInit=True
    Return True 
EndFunc

; ==================================================================================================
; Func _INT_TranslateDeviceFilename(Const ByRef $sImageFilename,$bResetDriveMap)
;
; Internal function used to translate strings returned from GetProcessImageFileName DLL calls to actual hard paths
;
; Returns: String if successfull, False if not found (caller issue usually), @error=1 = not a string, or not found
; ==================================================================================================

Func _INT_TranslateDeviceFilename(Const ByRef $sImageFilename,$bResetDriveMap)
    If Not IsString($sImageFilename) Or $sImageFilename="" Then Return SetError(1,0,"")
    If $bResetDriveMap Then $_bINTDeviceToDriveMapInit=False
    If Not (_INT_BuildDeviceToDriveXlateArray()) Then Return SetError(@error,0,"")
   
    For $i2=1 to 2
        For $i=0 to UBound($_aINTDeviceToDriveMapArray)-1
            If StringInStr($sImageFilename,$_aINTDeviceToDriveMapArray[$i][1])==1 Then _
                Return StringReplace($sImageFilename,$_aINTDeviceToDriveMapArray[$i][1],$_aINTDeviceToDriveMapArray[$i][0])
        Next
        ; Already reset the drive map? No use continuing
        If $bResetDriveMap Then Return SetError(1,0,"")
        ; Reset the drive map since there was no matches
        $_bINTDeviceToDriveMapInit=False
        If Not (_INT_BuildDeviceToDriveXlateArray()) Then Return SetError(@error,0,"")
        ; Flag this for next run (so it returns before trying to rebuild again)
        $bResetDriveMap=True
        ; Cycle through once more
    Next
    ; Actually shouldn't get here..
    Return SetError(1,0,"")
EndFunc

func endscript()
	send("{CTRLDOWN}{ALTDOWN}{SHIFTDOWN}")
	Send("{CTRLUP}{ALTUP}{SHIFTUP}")
	_GDIPlus_GraphicsDispose($hGraphic_x)
	_GDIPlus_GraphicsDispose($hGraphic_icons)
	_GDIPlus_Shutdown()
    DllCallbackFree($hHookProc)
    _WinAPI_UnhookWindowsHookEx($hHookKeyboard)
EndFunc

While 1
	if NOT _IsPressed("12") AND BitAnd(WinGetState($form1), 2) AND BitAnd(WinGetState($form2), 2) then
		send("{CTRLDOWN}{ALTDOWN}{SHIFTDOWN}")
		Send("{CTRLUP}{ALTUP}{SHIFTUP}")
		GUISetState(@SW_HIDE, $form2)
		GUISetState(@SW_HIDE, $Form1)
		GUISetState(@SW_HIDE, $Form12)
		GUISetState(@SW_HIDE, $form_icons)
		GUISetState(@SW_HIDE, $Form8)
		GUISetState(@SW_HIDE, $Form9)
		$win_hwnd_count = 1
		$changes = False
		$alt_down_left = False
		$alt_down_right = False
	EndIf
	Sleep(100)
WEnd

;#FUNCTION#========================================================================================
; Name...........: _GuiSetDropShadow
; Description ...: Sets the drop shadow effect on forms and dialogs for current process
; Syntax.........: _GuiSetDropShadow($hwnd, $fDisrespectUser = True)
; Parameters ....: $hWnd                   - Handle to parent form or child dialog (GuiCreate(), MsgBox(), FileOpenDialog(), etc.)
;                         $fDisrespectUser    - True: (Default) - set system option for drop shadow if disabled by user
;                                                      - False:             - do not set system option for drop shadow if disabled by user
; Return values .: Success      - 1
;                         Failure         - 0       - @error set and @extended set to point of failure
; Author(s) ........: rover, (lod3n, Rasim for Get/SetClassLong, Kip - RegisterclassEx() for drop shadow idea, ProgAndy - xMsgBox hook)
; Remarks .......: Note: drop shadow is lost if parent form clicked on (If MsgBox created with parent handle)
;                                 hiding, then restoring MsgBox to foreground or moving MsgBox off of form restores drop shadow.
;                                 use 262144 or 4096 flags with MsgBox if using with hParent handle to prevent loss of drop shadow if parent clicked on.
;                                 this behaviour is apparently by design.
;+
;                  Minimum Operating Systems: Windows XP
; Related .......:
; Link ..........; @@MsdnLink@@ SetClassLong Function
; Example .......; Yes
; ===================================================================================================
Func _GuiSetDropShadow($hwnd, $fDisrespectUser = True)
    If Not IsHWnd($hwnd) Then Return SetError(1, 1, 0)
   
    ;check if hWnd is from current process
    Local $aResult = DllCall("User32.dll", "int", "GetWindowThreadProcessId", "hwnd", $hwnd, "int*", 0)
    If @error Or $aResult[2] <> @AutoItPID Then Return SetError(@error, 2, 0)
   
    If Not IsDeclared("SPI_GETDROPSHADOW") Then Local Const $SPI_GETDROPSHADOW = 0x1024
    If Not IsDeclared("SPI_SETDROPSHADOW") Then Local Const $SPI_SETDROPSHADOW = 0x1025
    If Not IsDeclared("CS_DROPSHADOW") Then Local Const $CS_DROPSHADOW = 0x00020000
    If Not IsDeclared("GCL_STYLE") Then Local Const $GCL_STYLE = -26
   
    $aResult = DllCall("user32.dll", "int", "SystemParametersInfo", "int", $SPI_GETDROPSHADOW, "int", 0, "int*", 0, "int", 0)
    Local $iErr = @error
    If $iErr Or Not IsArray($aResult) Then Return SetError($iErr, 3, 0)
   
    ;if 'Show shadows under menus' option not set, try activating it.
    If Not $aResult[3] And $fDisrespectUser Then
    ;turn on drop shadows
        $aResult = DllCall("user32.dll", "int", "SystemParametersInfo", "int", $SPI_SETDROPSHADOW, "int", 0, "int", True, "int", 0)
        $iErr = @error
        If $iErr Or Not IsArray($aResult) Or $aResult[0] <> 1 Then Return SetError($iErr, 4, 0)
    EndIf
   
    ;get styles from WndClassEx struct
    $aResult = DllCall("user32.dll", "dword", "GetClassLong", "hwnd", $hwnd, "int", $GCL_STYLE)
    $iErr = @error
    If $iErr Or Not IsArray($aResult) Or Not $aResult[0] Then Return SetError($iErr, 5, 0)
    Local $OldStyle = $aResult[0]

    ;add drop shadow style to styles
    Local $Style = BitOR($OldStyle, $CS_DROPSHADOW)
   
    If StringRight(@OSArch, 2) == "64" Then
        ;if 64 bit windows (NOT TESTED)
        ;see MSDN SetClassLong remarks
        ;$aResult = DllCall("user32.dll", "ulong_ptr", "SetClassLongPtr", "hwnd", $hWnd, "int", $GCL_STYLE, "long_ptr", $Style)
        ;$iErr = @error
        ;If $iErr Or Not IsArray($aResult) Or Not $aResult[0] Then Return SetError($iErr, 6, 0)
    Else
        $aResult = DllCall("user32.dll", "dword", "SetClassLong", "hwnd", $hwnd, "int", $GCL_STYLE, "long", $Style)
        $iErr = @error
        If $iErr Or Not IsArray($aResult) Or Not $aResult[0] Then Return SetError($iErr, 7, 0)
        If $aResult[0] = $OldStyle Then Return SetError($iErr, 0, 1)
        Return SetError($iErr, 8, 0)
    EndIf
EndFunc  ;==>_GuiSetDropShadow

Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x3, $i_y3, $up_side = 0);==>_GuiRoundCorners
   Dim $pos, $ret, $ret2
   $pos = WinGetPos($h_win)
   if $up_side = 0 Then
	   $ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long",  $i_x1, "long", $i_y1, "long", $pos[2], "long", $pos[3], "long", $i_x3,  "long", $i_y3)
   Else
	   $ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long",  $i_x1, "long", $i_y1, "long", $pos[2], "long", $pos[3], "long", $i_x3,  "long", $i_y3)
   EndIf
   If $ret[0] Then
      $ret2 = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $ret[0], "int", 1)
      If $ret2[0] Then
         Return 1
      Else
         Return 0
      EndIf
   Else
      Return 0
   EndIf
EndFunc;==>_GuiRoundCorners