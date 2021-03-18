
#NoTrayIcon
#include <Date.au3>
#include <Array.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>

Global $thisfile=@ScriptDir&"\LRShiftWinAct.au3"
Global $logg=@ScriptDir&"\LRShiftWinAct-log1.txt";
;e C:\batch\LRShiftWinAct-log.txt
Global $timestamp=@YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC

Global $testing=False


If $CmdLine[0]<>0 Then
  $testing=False
EndIf

If Not $testing Then
  If $CmdLine[0]<>0 Then
    Msg('"Need 0 params - exiting" "'&$thisfile)
    Exit
  EndIf
Else
  logclear()
EndIf


Global $hDLL = DllOpen("user32.dll")
OnAutoItExitRegister("OnAutoItExit")

Global $objWMIService = ObjGet ( 'winmgmts:\\localhost\root\CIMV2' )
AutoItSetOption("GUICloseOnESC",0)


; trigger
Global $vk_trigger_l=0xA0;left shift
Global $vk_trigger_r=0xA1;right shift
Global $hwnds[10]

Global $oColItems

Global $doexit=False
Global $hGui
Global $btn_w=40
Global $btn_h=40
Global $app_title="Shift Key Window Activator"
Global $app_width=800;$btn_w*13
Global $app_height=$btn_h*10+50
Global $app_x=-1
Global $app_y=-$app_height
Global $app_style=$WS_POPUP
Global $app_ex_style=-1
Global $app_parent=0;WinGetHandle("Start")
Global $in_step=50
Global $out_step=60

Global $app_hidden=1
Global $app_home_y=30

Global $GUIFADE_MAXTRANS = 220

Global $setting=False
Global $set_h
Global $loopct=0

Global $hwnd_c_t=0
Global $hwnd_c_tu=0


;btnh,labelh,winh
;Global $btns[12][4]

;btnh,labelh2,winh
Global $btns[10][4]
Global $lbls[10][4]
Global $lbl2[10][4]

Global $hwnd_c=0

$hGui=makeGui()

Global $c_title=GUICtrlCreateLabel("Jump:0-9,   Delete: Ctrl+0-9,   Add Current: Shift+0-9", 10, 2,$app_width-12,12)
GUICtrlSetColor ( $c_title, 0xFFFFFF )
Global $c_title2=GUICtrlCreateLabel("LShift+RShift: Show App,  Escape/Backspace: Hide App,  Delete: Exit App", 10, 16,$app_width-12,12)
GUICtrlSetColor ( $c_title2, 0xFFFFFF )
Global $c_has=GUICtrlCreateLabel("", 10, 30,$app_width-12,12)
GUICtrlSetColor ( $c_has, 0x9999FF )
Global $start_y=52

makeButtons()
Global $k_esc = GUICtrlCreateDummy()
Global $k_del = GUICtrlCreateDummy()

Global $AK[33][2]=[ _
  ['1',$btns[0][0]] _
  ,['2',$btns[1][0]] _
  ,['3',$btns[2][0]] _
  ,['4',$btns[3][0]] _
  ,['5',$btns[4][0]] _
  ,['6',$btns[5][0]] _
  ,['7',$btns[6][0]] _
  ,['8',$btns[7][0]] _
  ,['9',$btns[8][0]] _
  ,['0',$btns[9][0]] _
  ,['^1',$lbls[0][0]] _
  ,['^2',$lbls[1][0]] _
  ,['^3',$lbls[2][0]] _
  ,['^4',$lbls[3][0]] _
  ,['^5',$lbls[4][0]] _
  ,['^6',$lbls[5][0]] _
  ,['^7',$lbls[6][0]] _
  ,['^8',$lbls[7][0]] _
  ,['^9',$lbls[8][0]] _
  ,['^0',$lbls[9][0]] _
  ,['+1',$lbl2[0][0]] _
  ,['+2',$lbl2[1][0]] _
  ,['+3',$lbl2[2][0]] _
  ,['+4',$lbl2[3][0]] _
  ,['+5',$lbl2[4][0]] _
  ,['+6',$lbl2[5][0]] _
  ,['+7',$lbl2[6][0]] _
  ,['+8',$lbl2[7][0]] _
  ,['+9',$lbl2[8][0]] _
  ,['+0',$lbl2[9][0]] _
  ,['{esc}',$k_esc] _
  ,['{del}',$k_del] _
  ,['{backspace}',$k_esc] _
  ]
GUISetAccelerators($AK)

GUISetBkColor (0x000000, $hGui )

AppAct()
Main()




Func Main()
  Local $msg
  While 1
    $loopct=$loopct+1
    If $doexit Then
      Terminate()
    EndIf
    If $app_hidden Then
      If Mod($loopct,50)==0 Then
        checkHwndCurrent()
        checkMaybeTip()
      EndIf
      If Key2OnlyCheck($vk_trigger_l,$vk_trigger_r,$hDLL) Then
        AppAct()
      Else
        If Mod($loopct,200)==0 Then
          refreshButtons()
        EndIf
      EndIf
    Else
      If WinGetHandle('[active]')<>$hGui Then
        AppHide()
      EndIf
    EndIf
    $msg = GUIGetMsg()
    If False Then
    ElseIf checkHandleSpecial($msg) Then
    ElseIf checkHandleButton($msg) Then
    ElseIf checkHandleLabel($msg) Then
    ElseIf checkHandleLabel2($msg) Then
    EndIf
  WEnd
  Terminate()
EndFunc


Func evtHwndCurrentChg()
  $hwnd_c_t=TimerInit()
  $hwnd_c_tu=0;
EndFunc

; tip windows
Func checkMaybeTip()
  checkMaybeUntipWin()
  checkMaybeTipWin()
EndFunc

Func checkMaybeUntipWin()
  If $hwnd_c_tu==0 Then
    Return
  EndIf
  If TimerDiff($hwnd_c_tu)>4000 Then
    ToolTip('')
    $hwnd_c_tu=0
  EndIf
EndFunc

Func checkMaybeTipWin()
  If $hwnd_c_t==0 Then
    Return
  EndIf
  If TimerDiff($hwnd_c_t)>2000 Then
    maybeTipWin()
    $hwnd_c_t=0
  EndIf
EndFunc

Func maybeTipWin()
  Local $x,$end=9
  For $x=0 To $end
    If $hwnds[$x]==$hwnd_c Then
      tipWinKey($x)
      Return
    EndIf
  Next
EndFunc

Func tipWinKey($x)
  Local $p=WinGetPos($hwnd_c)
  ;ToolTip ( "text" [, x [, y [, "title" [, icon [, options]]]]] )
  Local $xx=$x+1
  If $xx=10 Then
    $xx=0
  EndIf
  ToolTip($xx,$p[0]+10,$p[1]+10,'LR Shift',1,4)
  $hwnd_c_tu=TimerInit()
EndFunc

Func assignHwndCurrent($h)
  $hwnd_c=$h
  evtHwndCurrentChg()
EndFunc

; main handlers
Func checkHwndCurrent()
  Local $hc=WinGetHandle('[active]')
  If $hwnd_c==0 Then
    assignHwndCurrent($hc)
    Return
  EndIf
  If Not IsHWnd($hwnd_c) Then
    assignHwndCurrent($hc)
    evtHwndCurrentChg()
    Return
  EndIf
  If $hc<>$hGui Then
    If $hc<>$hwnd_c Then
      assignHwndCurrent($hc)
      evtHwndCurrentChg()
    EndIf
  EndIf
EndFunc

Func checkHandleSpecial($msg)
  If False Then
  ElseIf $msg==$k_del Then
    Terminate()
  ElseIf $msg==$k_esc Then
    AppHide()
    Return True
  EndIf
  Return False
EndFunc

Func checkHandleButton($msg)
  Local $x,$end=9
  For $x=0 To $end
    If $msg==$btns[$x][0] Then
      handleButton($x)
      Return True
    EndIf
  Next
  Return False
EndFunc

Func checkHandleLabel($msg)
  Local $x,$end=9
  For $x=0 To $end
    If $msg==$lbls[$x][0] Then
      ;Msg('handleLabel:x:'&$x)
      handleLabel($x)
      Return True
    EndIf
  Next
  Return False
EndFunc

Func checkHandleLabel2($msg)
  Local $x,$end=9
  For $x=0 To $end
    If $msg==$lbl2[$x][0] Then
      handleLabel2($x)
      Return True
    EndIf
  Next
  Return False
EndFunc



; form
Func makeGui()
  ;GUICreate ( "title" [, width [, height [, left [, top [, style [, exStyle [, parent]]]]]]] )
  Local $h=GUICreate ($app_title,$app_width,$app_height,$app_x,$app_y,$app_style,$app_ex_style,$app_parent)
  Return $h;
EndFunc

Func makeButtons()
  makeButtonsV()
EndFunc

Func makeButtonsV()
  Local $x=20
  Local $cy=$start_y
  For $i=0 To UBound($btns)-1
    makeButtonV($i,$x,$cy)
    $cy+=$btn_h
  Next
EndFunc

Func makeButtonV($i,$x,$y)
    local $h_b=GUICtrlCreateButton("", $x, $y, $btn_w, $btn_h, $BS_ICON)
    Local $tt=""&($i+1)
    If $i==9 Then
      $tt='0'
    EndIf
    local $h_l=GUICtrlCreateLabel($tt, 5, $y+($btn_h/2)-6)
    local $h_l2=GUICtrlCreateLabel("", $x+$btn_w+2, $y+($btn_h/2)-6,$app_width-42,12)
    $lbl2[$i][0]=$h_l2
    $lbls[$i][0]=$h_l
    GUICtrlSetColor ( $h_l, 0x999999 )
    GUICtrlSetColor ( $h_l2, 0x999999 )
    $btns[$i][0]=$h_b
    $btns[$i][1]=$h_l2
EndFunc
;form commands
Func SetHas($s)
  GUICtrlSetData($c_has,'Current Window: '&$s)
EndFunc

Func Terminate()
  Exit
EndFunc

Func AppHide()
  $app_hidden=1
  ;$setting=False
  SetHas('')
  _CrawlGUIOut()
  refreshButtons()
EndFunc

Func AppAct()
  If $app_hidden==1 Then
    $app_hidden=0
    $set_h=WinGetHandle('[active]')
    SetHas(WinGetTitle($set_h))
    WinActivate($hGui)
    _CrawlGUIIn()
  Else
    GUISetState(@SW_SHOW)
    WinActivate($hGui)
  EndIf
EndFunc

;form events
Func handleLabel($I)
  DelItem($i)
EndFunc

Func handleLabel2($I)
  SetItem($i)
  AppHide()
EndFunc

Func handleButton($I)
  ;Msg('Act :'&$I)
  If Not IsHWnd($hwnds[$i]) Then
    SetItem($i)
  Else
    AppHide()
    ActItem($i)
  EndIf
EndFunc


; items
Func DelItem($i)
  $hwnds[$i]=0
  refreshButtons()
EndFunc

Func SetItem($i)
  $hwnds[$i]=$set_h
  refreshButtons()
EndFunc
Func ActItem($i)
  Local $h=0
  If $hwnds[$i]<>0 Then
    $h=WinActivate($hwnds[$i])
  EndIf
  Return $h
EndFunc

; buttons
Func refreshButtons()
  _GetProcessCollection()
  Local $x
  Local $end=9
  For $x=0 To $end
    updateButton($x)
  Next
EndFunc

Func updateButton($i)
  Local $h=$hwnds[$i]
  If Not IsHWnd($h) Then
    $hwnds[$i]=0
    GUICtrlDeleteImage($btns[$i][0])
    GUICtrlSetData($btns[$i][1],'')
  Else
    Local $fp=_Win2ProcessLocation($h)
    GUICtrlSetImage($btns[$i][0], $fp,1)
    Local $tw=WinGetTitle($h)
    GUICtrlSetData($btns[$i][1], $tw)
  EndIf
EndFunc

;gui animation
Func _CrawlGUIIn()
    Local $hWnd=$hGui
    $iMax=$GUIFADE_MAXTRANS
    ;$GUIFADE_MAXTRANS = $iMax
    WinSetTrans($hWnd, "", 0)
    GUISetState(@SW_SHOW)
    Local $p=WinGetPos($hWnd)
    Local $xx=$p[0]
    Local $yy=$p[1]
    Local $ww=$p[2]
    Local $hh=$p[3]
    Local $yp=($app_home_y-$yy)/($iMax/$in_step)
    Local $delay = 1
    For $i = 1 To $iMax Step $in_step
        WinSetTrans($hWnd, "", $i)
        $yy=$yy+$yp
        If $yy>$app_home_y Then
          $yy=$app_home_y
        EndIf
        ;ToolTip('yy:'&$yy)
        WinMove($hWnd, "", $xx, Int($yy))
        Sleep($delay)
    Next
    WinMove($hWnd, "", $xx, $app_home_y)
EndFunc   ;==>_FadeGUIIn

Func _CrawlGUIOut()
    Local $hWnd=$hGui
    $iMax=255
    Local $delay = 1
    Local $p=WinGetPos($hWnd)
    Local $xx=$p[0]
    Local $yy=$p[1]
    Local $ww=$p[2]
    Local $hh=$p[3]
    Local $yp=($yy-$app_x)/($iMax/$out_step)
    For $i = $GUIFADE_MAXTRANS To 0 Step -$out_step
        WinSetTrans($hWnd, "", $i)
        $yy=$yy-$yp
        If $yy<$app_y Then
          $yy=$app_y
        EndIf
        WinMove($hWnd, "", $xx, Int($yy))
        Sleep($delay)
    Next
    GUISetState(@SW_HIDE)
    WinMove($hWnd, "", $xx, $app_y)
EndFunc


;key state
Func Key2OnlyCheck($iHexKey1,$iHexKey2, $vDLL = 'user32.dll')
	Local $ikey, $ia_R
  Local $iStart=0
  Local $iFinish=255
	For $ikey = $iStart To $iFinish
    $ia_R = DllCall($vDLL, 'int', 'GetAsyncKeyState', 'int', '0x' & Hex($ikey, 2))
		If Not Like2($ikey,$iHexKey1,$iHexKey2) Then
      If @error Then
        Return 0
      Else
		    If BitAND($ia_R[0], 0x8000) = 0x8000 Then Return 0
      EndIf
    Else
      If @error Then
        Return 0
      Else
		    If Not BitAND($ia_R[0], 0x8000) = 0x8000 Then Return 0
      EndIf
    EndIf
	Next
	Return 1
EndFunc

Func Like($iTgtVk,$iSrcVk)
  If $iSrcVk==0xA0 and $iTgtVk==0x10 Then Return 1
  If $iSrcVk==0xA1 and $iTgtVk==0x10 Then Return 1
  If $iSrcVk==0xA2 and $iTgtVk==0x11 Then Return 1
  If $iSrcVk==0xA3 and $iTgtVk==0x11 Then Return 1
  If $iSrcVk==0xA4 and $iTgtVk==0x12 Then Return 1
  If $iSrcVk==0xA5 and $iTgtVk==0x12 Then Return 1
  If $iSrcVk==$iTgtVk Then Return 1
  Return 0
EndFunc

Func Like2($iTgtVk,$iSrcVk1,$iSrcVk2)
  Return (Like($iTgtVk,$iSrcVk1)+Like($iTgtVk,$iSrcVk2))>0
EndFunc

; process path
Func _Win2ProcessLocation($wintitle)
  ;Global $oColItems
    ;if isstring($wintitle) = 0 then return -1
    $wproc = WinGetProcess($wintitle)
    Return _ProcessIdPath($wproc)
EndFunc

Func _ProcessIdPath ( $vPID )
	Local $sNoExePath = ''
	Local $RetErr_ProcessDoesntExist = 1
	Local $RetErr_ProcessPathUnknown = 2
	Local $RetErr_ProcessNotFound = 3
	Local $RetErr_ObjCreateErr = 4
	Local $RetErr_UnknownErr = 5
	If Not ProcessExists ( $vPID )  Then
		SetError ( $RetErr_ProcessDoesntExist )
		Return $sNoExePath
	EndIf
  _GetProcessCollection()
	If IsObj ( $oColItems )  Then
		For $objItem In $oColItems
			If $vPID = $objItem.ProcessId Then
				If $objItem.ExecutablePath = '0' Then
					If FileExists ( @SystemDir & '\' & $objItem.Caption )  Then
						Return @SystemDir & '\' & $objItem.Caption
					Else
						SetError ( $RetErr_ProcessPathUnknown )
						Return $sNoExePath
					EndIf
				Else
					Return $objItem.ExecutablePath
				EndIf
			EndIf
		Next
		SetError ( $RetErr_ProcessNotFound )
		Return $sNoExePath
	Else
		SetError ( $RetErr_ObjCreateErr )
		Return $sNoExePath
	EndIf

	SetError ( $RetErr_UnknownErr )
	Return $sNoExePath
EndFunc  ;==>_ProcessIdPath

Func _GetProcessCollection()
	Local Const $wbemFlagReturnImmediately = 0x10
	Local Const $wbemFlagForwardOnly = 0x20
	$oColItems = $objWMIService.ExecQuery  ( 'SELECT * FROM Win32_Process', 'WQL', $wbemFlagReturnImmediately + $wbemFlagForwardOnly )
  Return $oColItems
EndFunc



;;;;;;functions
Func GUICtrlDeleteImage($iControlID)
    Local Const $IMAGE_ICON = 0x0001
    Local $iReturn = GUICtrlSendMsg($iControlID, $BM_SETIMAGE, $IMAGE_ICON, 0)
    If $iReturn = 0 Then
        $iReturn = GUICtrlSetImage($iControlID, 'shell32.dll', -50)
    EndIf
    Return Number($iReturn > 0)
EndFunc   ;==>GUICtrlDeleteImage

Func Tt($s)
  Tooltip($s)
EndFunc
Func Msg($s)
  MsgBox(0,$thisfile,$s)
EndFunc

Func ts()
  Return @YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC
EndFunc
Func logclear()
  FileDelete($logg)
EndFunc
Func logline($line)
  Local $fh1=FileOpen($logg,1);
  If $fh1<>-1 Then
    FileWriteLine($fh1,$line)
    FileClose($fh1)
  EndIf
EndFunc

