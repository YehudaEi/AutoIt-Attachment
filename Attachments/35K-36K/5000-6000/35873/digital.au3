#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=C:\AutoIt3\Aut2Exe\Icons\SETUP09.ICO
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <GDIPlus.au3>
#Include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>


Global Const $tagBITMAP = 'long bmType;long bmWidth;long bmHeight;long bmWidthBytes;ushort bmPlanes;ushort bmBitsPixel;ptr bmBits;'

Global $fDragging
$State = Default
Global Const $SC_DRAGMOVE = 0xF012
Global $count

Global $1st_Pos
Global $2th_Pos


Global $bIsDebugPrint = 1

Global $Nevi
FileInstall('.\cal1.png',@ScriptDir & '\cal1.png',1)
FileInstall('.\cal2.png',@ScriptDir & '\cal2.png',1)

_GDIPlus_Startup()
; 배경으로 쓸그림
$hBackground1 = _GDIPlus_ImageLoadFromFile(@ScriptDir & '\cal1.png')
$hBackground2 = _GDIPlus_ImageLoadFromFile(@ScriptDir & '\cal2.png')

; 투명 캘리퍼스 앞부분
;$hForm1 = GUICreate('', 236, 181, -1, -1, $WS_POPUPWINDOW, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST))
$ParentForm = GUICreate('', 236+1000, 181, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
GUISetState()

$hForm1 =  GUICreate("", 236, 181, 0 , 0,          $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $ParentForm)

; 투명 캘리퍼스 앞부분 화면에 출력
Normal($hForm1,$hBackground1)

GUISetState()


$Get_hForm_Pos = WinGetPos ($hForm1 )
;투명 캘리퍼스 뒷부분
$hForm2 = GUICreate('', 197, 181, 14,0   ,$WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $hForm1)
;~ WinSetOnTop($hForm2,'',1)
Normal($hForm2,$hBackground2)
GUISetState()


; 카운트출력 폼
$Label_GUI =  GUICreate("", 120, 30, 43 , 42,          $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $hForm2)
GUISetBkColor(0x003842, $Label_GUI)
$count = GUICtrlCreateLabel('000',0, 0,58,18)
GUICtrlSetColor(-1,0x666666)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetFont(-1, 10, 800, 0, "굴림체")
 $exit = GUICtrlCreateLabel('X',0, 28,10,10)
GUICtrlSetColor(-1,0xFF0000)
GUICtrlSetBkColor(-1,-2)
 GUICtrlSetFont(-1, 10, 800, 0, "굴림체")
_WinAPI_SetLayeredWindowAttributes($Label_GUI, 0x003842, 255)
GUISetState()
; 카운트출력 폼

GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
HotKeySet("{ESC}",'_exit_')
GUIRegisterMsg($WM_WINDOWPOSCHANGING, "WM_WINDOWPOSCHANGING")

While 1
   _ReduceMemory(@AutoItPID)
    $aMsg = GUIGetMsg(1)
    Switch $aMsg[1]
        Case $hForm1
            Switch $aMsg[0]
                Case $GUI_EVENT_CLOSE
                    Exit
            EndSwitch
        Case $hForm2
            Switch $aMsg[0]
                Case $GUI_EVENT_PRIMARYDOWN
                _SendMessage($hForm2, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0)
               Case $GUI_EVENT_PRIMARYUP
       		        $aMain_Pos = WinGetPos($hForm1)   ; 캘리퍼스 앞부분의 현재 좌표를 구해온다.
					$sMain_Pos =  WinGetPos($hForm2)  ; 캘리퍼스 뒷부분의 현재 좌표를 구해온다.
					$sZero_Point = $aMain_Pos[0] + 14   ; 캘리퍼스 뒷부분의 가이드 시작부분
					 $head = $aMain_Pos[0] + 34
					 $body =    $sMain_Pos[0]  + 20
					 $Nevi  = $body - $head
				     GUICtrlSetData($count,$Nevi)
                    	DebugPrint( ' 마우스뗄데 1_x: ' & 	$aMain_Pos[0]  & '  2_x: '  &  $sMain_Pos[0]  & '  Sp:'  &  $Nevi      )
			  Case $exit
			       _exit_()
			EndSwitch
    EndSwitch
   $1st_Get_Pos = WinGetPos($hForm1)
   If $1st_Pos <> $1st_Get_Pos[0] Then
        WinMove($hForm2,'',$1st_Get_Pos[0] + $Nevi,$1st_Get_Pos[1])
        DebugPrint( ' 움직일때 1_x: ' & 	$1st_Get_Pos[0]  & '  2_x: '  &  $1st_Get_Pos[0] + $Nevi  & '  Sp:'  &  $Nevi      )
   EndIf
WEnd
_GDIPlus_Shutdown()

Func _exit_()
Exit
EndFunc


Func WM_WINDOWPOSCHANGING($hWnd, $Msg, $wParam, $lParam)
                 ; 마우스가 눌려있을때만.......
    If $hWnd = $hForm2 Then
		$aMain_Pos = WinGetPos($hForm1)   ; 캘리퍼스 앞부분의 현재 좌표를 구해온다.
		Local $iY = $aMain_Pos[1]  ; Y Pos
        Local $iX_Min = $aMain_Pos[0]  +15  ;+ $iBorder + 10      ;X Pos
        Local $iX_Max = $aMain_Pos[0]  +1300          ;+ $iBorder + 510  ;X Pos

        Local $stWinPos = DllStructCreate("uint;uint;int;int;int;int;uint", $lParam)
        Local $iLeft = DllStructGetData($stWinPos, 3)
        Local $iTop = DllStructGetData($stWinPos, 4)
        Local $iWidth = DllStructGetData($stWinPos, 5)
        Local $iHeight = DllStructGetData($stWinPos, 6)
		If $iLeft < $iX_Min Then DllStructSetData($stWinPos, 3, $iX_Min)
        If $iLeft > $iX_Max Then DllStructSetData($stWinPos, 3, $iX_Max)
        If $iTop <> $iY Then DllStructSetData($stWinPos, 4, $iY)
		$aMain_Pos = WinGetPos($hForm1)   ; 캘리퍼스 앞부분의 현재 좌표를 구해온다.
        $sMain_Pos =  WinGetPos($hForm2)  ; 캘리퍼스 뒷부분의 현재 좌표를 구해온다.
	    $sZero_Point = $aMain_Pos[0] + 14   ; 캘리퍼스 뒷부분의 가이드 시작부분
        $head = $aMain_Pos[0] + 34
        $body =    $sMain_Pos[0]  + 20
        $Nevi  = $body - $head
        $2th_Pos = $sMain_Pos[0]-$sZero_Point
        $1st_Pos = $aMain_Pos[0]
    EndIf
EndFunc

Func DebugPrint($debugString)
  If $bIsDebugPrint <> 0 Then DllCall("kernel32.dll", "none", "OutputDebugString", "str", $debugString)
EndFunc


Func _ReduceMemory($i_PID = -1)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory



Func Normal($pForm,$hBackPic)
  Local $hGraphic, $hImage

    $hImage = _GDIPlus_ImageClone($hBackPic)   ; 배경png를 이미지로 복사해온다
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)  ; 작업에 필요한 빈도화지를 메모리에 준비한다.
    _WinAPI_UpdateLayeredWindowEx($pForm, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage), 255, 1)
	_GDIPlus_GraphicsSetSmoothingMode($hGraphic, 4)

	;      자신이 사용한 빈도화지 결과물을 지운다...메모리가 많다면 안지워도 무방
    _GDIPlus_GraphicsDispose($hGraphic)
    ;      자신이 복사해온 배경이미지를 지운다....메모리가 많은 부자라면 안지워도 무방.
    _GDIPlus_ImageDispose($hImage)
EndFunc


Func _exit_2()
    Exit
EndFunc

Func _GDIPlus_ImageClone($hImage)
    ;   복사해야할 배경그림을 포인터로 보내고 그 포인터 주소값을 구해온다.
    Local $aResult = DllCall($ghGDIPDll, 'uint', 'GdipCloneImage', 'ptr', $hImage, 'ptr*', 0)
    If @error Then
        ;  포인터 주소값의 반환이 실패라면 에러메시지로 리턴
        Return SetError(1, 0, 0)
    Else
        If $aResult[0] Then
            ;  받은 포인터 주소값의  배열 변수중 첫번째 값만 온다면 에러를 반환한다.
            Return SetError($aResult[0], 0, 0)
        EndIf
    EndIf
    ;     포인터 주소값을 리턴한다.
    Return $aResult[2]
EndFunc   ;==>_GDIPlus_ImageClone

Func _WinAPI_UpdateLayeredWindowEx($hWnd, $hBitmap, $iOpacity = 255, $fDelete = 0)
    Local $Ret, $tSIZE, $tPOINT, $tBLENDFUNCTION, $hDC, $hDestDC, $hDestSv
    $Ret = DllCall('user32.dll', 'hwnd', 'GetDC', 'hwnd', $hWnd)
    $hDC = $Ret[0]
    $Ret = DllCall('gdi32.dll', 'hwnd', 'CreateCompatibleDC', 'hwnd', $hDC)
    $hDestDC = $Ret[0]
    $Ret = DllCall('gdi32.dll', 'hwnd', 'SelectObject', 'hwnd', $hDestDC, 'ptr', $hBitmap)
    $hDestSv = $Ret[0]
    $tSIZE = _WinAPI_GetBitmapDimension($hBitmap)
    $tPOINT = DllStructCreate($tagPOINT)
    $tBLENDFUNCTION = DllStructCreate($tagBLENDFUNCTION)
    DllStructSetData($tBLENDFUNCTION, 'Alpha', $iOpacity)
    DllStructSetData($tBLENDFUNCTION, 'Format', 1)
    $Ret = DllCall('user32.dll', 'int', 'UpdateLayeredWindow', 'hwnd', $hWnd, 'hwnd', $hDC, 'ptr', 0, 'ptr', DllStructGetPtr($tSIZE), 'hwnd', $hDestDC, 'ptr', DllStructGetPtr($tPOINT), 'dword', 0, 'ptr', DllStructGetPtr($tBLENDFUNCTION), 'dword', 0x02)
    DllCall('user32.dll', 'int', 'ReleaseDC', 'hwnd', $hWnd, 'hwnd', $hDC)
    DllCall('gdi32.dll', 'ptr', 'SelectObject', 'hwnd', $hDestDC, 'ptr', $hDestSv)
    DllCall('gdi32.dll', 'int', 'DeleteDC', 'hwnd', $hDestDC)
    If Not $Ret[0] Then
        Return SetError(1, 0, 0)
    EndIf
    If $fDelete Then
        _WinAPI_DeleteObject($hBitmap)
    EndIf
    Return 1
EndFunc   ;==>_WinAPI_UpdateLayeredWindowEx

Func _WinAPI_GetBitmapDimension($hBitmap)

    Local $tObj = DllStructCreate($tagBITMAP)
    Local $Ret = DllCall('gdi32.dll', 'int', 'GetObject', 'int', $hBitmap, 'int', DllStructGetSize($tObj), 'ptr', DllStructGetPtr($tObj))

    If (@error) Or (Not $Ret[0]) Then
        Return SetError(1, 0, 0)
    EndIf

    Local $tSIZE = DllStructCreate($tagSIZE)

    DllStructSetData($tSIZE, 1, DllStructGetData($tObj, 'bmWidth'))
    DllStructSetData($tSIZE, 2, DllStructGetData($tObj, 'bmHeight'))

    Return $tSIZE
EndFunc   ;==>_WinAPI_GetBitmapDimension


Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
	If ($hWnd = $hForm1) And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
;	If ($hWnd = $hForm2) And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
EndFunc   ;==>WM_NCHITTEST
