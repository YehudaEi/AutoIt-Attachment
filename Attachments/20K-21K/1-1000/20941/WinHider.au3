#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icoontjes\ICO\VistaICO_Toolbar_Icons\Window.ico
#AutoIt3Wrapper_outfile=WinHider.exe
#AutoIt3Wrapper_Res_Comment=Created by ludocus
#AutoIt3Wrapper_Res_Description=Hide windows..
#AutoIt3Wrapper_Res_Fileversion=1.000
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <ScreenCapture.au3>
#include <WindowsConstants.au3>
#include <File.au3>
;HotKeySet('^f', '_space')
$showallonexit=true
$pass = 'winhiderbyludocus'
Func _GetVisibleWins()
$list = WinList()
$sReturn = ''
For $i=1 to $list[0][0]
	if _IsVisible($list[$i][0]) and $list[$i][0] <> 'Program Manager' and $list[$i][0] <> '' then 
	    if $sReturn = '' then 
			$sReturn=$list[$i][0]
		Else
			$sReturn &=@CRLF&$list[$i][0]
		EndIf
	EndIf
Next
return $sReturn
EndFunc

Func _GetHiddenWins()
$list = WinList()
$sReturn = ''
For $i=1 to $list[0][0]
	if BitAND(WiNGetState($list[$i][0]), 5) and $list[$i][0] <> '' then
	if $sReturn = '' then 
		$sReturn=$list[$i][0]
	Else
		$sReturn &=@CRLF&$list[$i][0]
	EndIf
	EndIf
Next
return $sReturn
EndFunc

Opt('TrayOnEventMode', 1)
Opt('TrayMenuMode', 1)
if $showallonexit=true then Opt('OnExitFunc', '_exx')
global $1, $2, $3, $4
HotKeySet('{ESC}', '_exit')
$DarkLayer=''
$scount = 0
_SetHotKeys(true)

Func _exx()
	_showalllog()
	Exit
EndFunc


Func _SetHotKeys($sVar)
	if $sVar = true then
	    HotKeySet('^{ENTER}', '_show')
        HotKeySet('^{space}', '_hidewin')
        HotKeySet('^1', '_showwin1')
        HotKeySet('^2', '_showwin2')
        HotKeySet('^3', '_showwin3')
        HotKeySet('^4', '_showwin4')
	Else
		HotKeySet('^{ENTER}')
        HotKeySet('^{space}')
        HotKeySet('^1')
        HotKeySet('^2')
        HotKeySet('^3')
        HotKeySet('^4')
	EndIf
EndFunc
$menu = TrayCreateMenu('Show')
$menu2 = TrayCreateMenu('Close')
$w1 = TrayCreateItem('close win 1', $menu2)
TrayItemSetOnEvent(-1, '_closewin1')
$w2 = TrayCreateItem('close win 2', $menu2)
TrayItemSetOnEvent(-1, '_closewin2')
$w3 = TrayCreateItem('close win 3', $menu2)
TrayItemSetOnEvent(-1, '_closewin3')
$w4 = TrayCreateItem('close win 4', $menu2)
TrayItemSetOnEvent(-1, '_closewin4')
$w1 = TrayCreateItem('show win 1', $menu)
TrayItemSetOnEvent(-1, '_showwin1')
$w2 = TrayCreateItem('show win 2', $menu)
TrayItemSetOnEvent(-1, '_showwin2')
$w3 = TrayCreateItem('show win 3', $menu)
TrayItemSetOnEvent(-1, '_showwin3')
$w4 = TrayCreateItem('show win 4', $menu)
TrayItemSetOnEvent(-1, '_showwin4')
$all = TrayCreateItem('Show all wins')
TrayItemSetOnEvent(-1, '_showalllog')
$exit = TrayCreateItem('exit')
TrayItemSetOnEvent(-1, '_exit')
if not FileExists(@TempDir&'\scr') then DirCreate(@TempDir&'\scr')
$scrfile1 = @TempDir&'\scr\1.bmp'
$scrfile2 = @TempDir&'\scr\2.bmp'
$scrfile3 = @TempDir&'\scr\3.bmp'
$scrfile4 = @TempDir&'\scr\4.bmp'
$temp = @TempDir&'\scr\temp.bmp'
$log = @TempDir&'\scr\log.txt'
if FileExists($log) then FileDelete($log)
_FileCreate($log)
if not FileExists($temp) then FileCopy(@DesktopDir&'\temp.bmp', $temp)
_DeleteSrcFiles(4)
$scr = 1
$hiddencount = 0
global $hiddenwins[200]
While 1
	sleep(100)
	$win = WinGetTitle('')
	$pos = WinGetPos($win)
WEnd

Func _CloseWin1()
	WinKill($hiddenwins[1])
	$hiddenwins[1]=''
	$hiddencount = $hiddencount - 1
EndFunc

Func _CheckWins($sWin)
	For $i = 1 to 4
		if $hiddenwins[$i]=$sWin then return 1
	Next
	return 0
EndFunc


Func _CloseWin2()
	WinKill($hiddenwins[2])
	$hiddenwins[2]=''
	$hiddencount = $hiddencount - 1
EndFunc

Func _closewin3()
	WinKill($hiddenwins[3])
	$hiddenwins[3]=''
	$hiddencount = $hiddencount - 1
EndFunc

Func _CloseWin4()
	WinClose($hiddenwins[4])
	$hiddenwins[4]=''
	$hiddencount = $hiddencount - 1
EndFunc


Func _ScrCreate($num, $pos)
    if $num = 1 then _ScreenCapture_Capture($scrfile1, $pos[0], $pos[1], $pos[0]+$pos[2], $pos[1]+$pos[3], false)
	if $num = 2 then _ScreenCapture_Capture($scrfile2, $pos[0], $pos[1], $pos[0]+$pos[2], $pos[1]+$pos[3], false)
	if $num = 3 then _ScreenCapture_Capture($scrfile3, $pos[0], $pos[1], $pos[0]+$pos[2], $pos[1]+$pos[3], false)
	if $num = 4 then _ScreenCapture_Capture($scrfile4, $pos[0], $pos[1], $pos[0]+$pos[2], $pos[1]+$pos[3], false)
EndFunc

Func _ScrDelete($num)
	if $num = 1 then FileDelete($scrfile1)
	if $num = 2 then FileDelete($scrfile2)
	if $num = 3 then FileDelete($scrfile3)
	if $num = 4 then FileDelete($scrfile4)
EndFunc

Func _hidewin()
	if _CheckWins($win) then 
		msgbox(16, 'Error!', 'there is already a win with that title hidden..'&@CRLF&'Please unhide that win and then try again'&@CRLF&'Win name: '&$win&@CRLF&'Press: CTRL+'&_GetCorrectNum($win)&' to show it..')
		return 0
	EndIf
	$hiddencount = $hiddencount + 1
	$scount = $scount+ 1
	_ScrCreate($hiddencount, WinGetPos($win))
	$hiddenwins[$hiddencount]=$win
	WinSetState($win, '',  @SW_HIDE)
	_LogWrite($win, _LogCountLines()+1)
EndFunc

Func _LogWrite($sText, $sLine=1)
	_FileWriteToLine($log, $sLine, $sText, 1)
EndFunc

Func _LogCountLines()
	Return _FileCountLines($log)
EndFunc


Func _showwin1()
	if $hiddencount = 0 then return -1
	_ScrDelete(1)
	WinSetState($hiddenwins[1], '', @SW_SHOW)
	$hiddenwins[1]=''
	$hiddencount = $hiddencount - 1
	$scount = $scount - 1
EndFunc

Func _showwin2()
	if $hiddencount = 0 then return -1
	_ScrDelete(2)
	WinSetState($hiddenwins[2], '', @SW_SHOW)
	$hiddenwins[2]=''
	$hiddencount = $hiddencount - 1
	$scount = $scount - 1
EndFunc

Func _showall()
	For $i=1 to 4
		if $hiddenwins[$i] <> '' then WinSetState($hiddenwins[$i], '', @SW_SHOW)
		$hiddenwins[$i]=''
	Next
	$hiddencount=0
	$scount = 0
EndFunc

Func _LogReadLine($iLine=1)
	$file = FileOpen($log, 0)
	if $file = -1 then return -1
	$line = FileReadLine($file, $iLine)
	FileCLose($file)
	return $line
EndFunc

Func _showallLog()
	$hidden = _GetHiddenWins()
	$lap = StringSplit($hidden, @CRLF, 1)
	For $p = 1 to _LogCountLines()
	    For $i = 1 to $lap[0]
			$line = _LogReadLine($p)
		    if $lap[$i] = $line Then WinSetState($line, '', @SW_SHOW)
		Next
	Next
EndFunc


Func _showwin3()
	if $hiddencount = 0 then return -1
	_ScrDelete(3)
	WinSetState($hiddenwins[3], '', @SW_SHOW)
	$hiddenwins[3]=''
	$hiddencount = $hiddencount - 1
	$scount = $scount - 1
EndFunc

Func _showwin4()
	if $hiddencount = 0 then return -1
	_ScrDelete(4)
	WinSetState($hiddenwins[4], '', @SW_SHOW)
	$hiddenwins[4]=''
	$hiddencount = $hiddencount - 1
	$scount = $scount - 1
EndFunc
Func _SetPics($num)
	if $num = 4 then
	    $1 = GUICtrlCreatePic($temp, 0, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	    $2 = GUICtrlCreatePic($temp, (@DesktopWidth/2)+20, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	    $3 = GUICtrlCreatePic($temp, 0, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
		$4 = GUICtrlCreatePic($temp, (@DesktopWidth/2)+20, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
    ElseIf $num = 3 Then
	    $2 = GUICtrlCreatePic($temp, (@DesktopWidth/2)+20, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	    $3 = GUICtrlCreatePic($temp, 0, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
		$4 = GUICtrlCreatePic($temp, (@DesktopWidth/2)+20, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	ElseIf $num = 2 Then
		$3 = GUICtrlCreatePic($temp, 0, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
		$4 = GUICtrlCreatePic($temp, (@DesktopWidth/2)+20, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	ElseIf $num = 1 Then
	    $4 = GUICtrlCreatePic($temp, (@DesktopWidth/2)+20, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	EndIf
EndFunc

Func _show()
_SetHotKeys(false)
;$Layer = GUICreate("WinHider..",@DesktopWidth,@DesktopHeight,0,0,0x80000000,0x00000008+$WS_EX_TOOLWINDOW)
;GUISetBkColor(0x000000)
;WinSetTrans($Layer,"",200)
$DarkLayer = GUICreate('WinHider..', @DesktopWidth, @DesktopHeight, 0, 0, 0x80000000, 0x00000008+$WS_EX_TOOLWINDOW)
global $p1 = false, $p2 = false, $p3 = false, $p4 = false
global $c1, $c2, $c3, $c4
$thewins = _GetWins()
$split = StringSplit($thewins[1], $pass, 1)
$split1 = StringSplit($thewins[2], $pass, 1)
$split2 = StringSplit($thewins[3], $pass, 1)
$split3 = StringSplit($thewins[4], $pass, 1)
if $thewins[0] = 1 Then
	$p1 = True
	$1 = GUICtrlCreatePic($split[1], 0, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split[2])
	$c100 = GUICtrlCreateContextMenu($1)
	$c1 = GUICtrlCreateMenuItem('Close this win..', $c100)
	_SetPics(3)
ElseIf $thewins[0] = 2 Then
	$p1 = True
	$p2 = True
	$1 = GUICtrlCreatePic($split[1], 0, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split[2])
	$c200 = GUICtrlCreateContextMenu($1)
	$c1 = GUICtrlCreateMenuItem('Close this win..', $c200)
	$2 = GUICtrlCreatePic($split1[1], (@DesktopWidth/2)+20, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split1[2])
	$c201 = GUICtrlCreateContextMenu($2)
	$c2 = GUICtrlCreateMenuItem('Close this win..', $c201)
	_SetPics(2)
ElseIf $thewins[0] = 3 Then
	$p1 = True
	$p2 = True
	$p3 = True
	$1 = GUICtrlCreatePic($split[1], 0, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split[2])
	$c300 = GUICtrlCreateContextMenu($1)
	$c1 = GUICtrlCreateMenuItem('Close this win..', $c300)
	$2 = GUICtrlCreatePic($split1[1], (@DesktopWidth/2)+20, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split1[2])
	$c301 = GUICtrlCreateContextMenu($2)
	$c2 = GUICtrlCreateMenuItem('Close this win..', $c301)
	$3 = GUICtrlCreatePic($split2[1], 0, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split2[2])
	$c302 = GUICtrlCreateContextMenu($3)
	$c3 = GUICtrlCreateMenuItem('Close this win..', $c302)
	_SetPics(1)
ElseIf $thewins[0] = 4 Then
	$p1 = True
	$p2 = True
	$p3 = True
	$p4 = True
	$1 = GUICtrlCreatePic($split[1], 0, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split[2])
	$c400 = GUICtrlCreateContextMenu($1)
	$c1 = GUICtrlCreateMenuItem('Close this win..', $c400)
	$2 = GUICtrlCreatePic($split1[1], (@DesktopWidth/2)+20, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split1[2])
	$c401 = GUICtrlCreateContextMenu($2)
	$c2 = GUICtrlCreateMenuItem('Close this win..', $c401)
	$3 = GUICtrlCreatePic($split2[1], 0, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split2[2])
	$c402 = GUICtrlCreateContextMenu($3)
	$c3 = GUICtrlCreateMenuItem('Close this win..', $c402)
	$4 = GUICtrlCreatePic($split3[1], (@DesktopWidth/2)+20, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	GUICtrlSetTip(-1, $split3[2])
	$c403 = GUICtrlCreateContextMenu($4)
	$c4 = GUICtrlCreateMenuItem('Close this win..', $c403)
Else
	_SetPics(4)
EndIf
HotKeySet('^{BACKSPACE}', '_hide')
GUISetState()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $1
			if $p1 = true then
				_Exitloop(1, $split)
				ExitLoop
			EndIf
			
		Case $2
			if $p2 = true then
				_Exitloop(2, $split1)
				ExitLoop
			EndIf
			
		Case $3
			if $p3 = true then
				_Exitloop(3, $split2)
				ExitLoop
			EndIf
		Case $4
			if $p4 = true then
				_Exitloop(4, $split3)
				ExitLoop
			EndIf
			
		Case $c1
			if $p1 = True then _Close(_GetCorrectNum($split[2]))
			
		Case $c2
			if $p2 = True then _Close(_GetCorrectNum($split1[2]))
			
		Case $c3
			if $p3 = True then _Close(_GetCorrectNum($split2[2]))
			
		Case $c4
			if $p4 = True then _Close(_GetCorrectNum($split3[2]))
			
	EndSwitch
	
WEnd
EndFunc
Func _Close($nNum)
	if $nNum = 1 then 
	    _CloseWin1()
		GUICtrlDelete($1)
		$p1 = False
		$1 = GUICtrlCreatePic($temp, 0, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	ElseIf $nNum = 2 then 
		_CloseWin2()
		GUICtrlDelete($2)
		$p2 = False
		$2 = GUICtrlCreatePic($temp, (@DesktopWidth/2)+20, 0, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	ElseIf $nNum = 3 then 
		_CloseWin3()
		GUICtrlDelete($3)
		$p3 = False
		$3 = GUICtrlCreatePic($temp, 0, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	ElseIf $nNum = 4 then 
		_CloseWin4()
		GUICtrlDelete($4)
		$p4 = False
		$4 = GUICtrlCreatePic($temp, (@DesktopWidth/2)+20, (@DesktopHeight/2)+20, (@DesktopWidth/2)-20, (@DesktopHeight/2)-40)
	EndIf
EndFunc


Func _GetWins()
	global $sReturn[5]
	For $i = 1 to 4
		if $hiddenwins[$i] <> '' Then 
		   $sReturn[0] = $sReturn[0]+1
		   $sReturn[$sReturn[0]]=_GetCorrectFile($i)&$pass&$hiddenwins[$i]
	    EndIf
	Next
    return $sReturn
EndFunc

Func _GetCorrectNum($sWin)
	For $i = 1 to 4
		if $hiddenwins[$i] = $sWin then exitloop
	Next
	return $i
EndFunc

Func _GetCorrectFile($nCount)
	if $nCount = 1 then $return = $scrfile1
	if $nCount = 2 then $return = $scrfile2
	if $nCount = 3 then $return = $scrfile3
	if $nCount = 4 then $return = $scrfile4
	if $nCount > 4 or $nCount < 1 then $return = -1
	return $return
EndFunc


Func _Exitloop($count, $sWin)
	GUIDelete($DarkLayer)
	WinSetState($sWin[2], '', @SW_SHOW)
	_ScrDelete($sWin[1])
	$hiddenwins[_GetCorrectNum($sWin[2])]=''
	$hiddencount = $hiddencount - 1
	$scount = $scount - 1
	_SetHotKeys(True)
EndFunc

Func _hide()
	_SetHotKeys(True)
	HotKeySet('^{BACKSPACE}')
	GUIDelete($DarkLayer)
	While 1
		sleep(100)
	    $win = WinGetTitle('')
	    $pos = WinGetPos($win)
	WEnd
EndFunc

Func _space()
	msgbox(32, 'result:', $hiddencount&' + '&$scount)
EndFunc


Func _GUICtrlSetTrans($iCtrlID,$iTrans=254)
    
    Local $pHwnd, $nHwnd, $aPos, $a
    
    $hWnd = GUICtrlGetHandle($iCtrlID);Get the control handle
    If $hWnd = 0 then Return SetError(1,1,0)
    $pHwnd = DllCall("User32.dll", "hwnd", "GetParent", "hwnd", $hWnd);Get the parent Gui Handle
    If $pHwnd[0] = 0 then Return SetError(1,2,0)
    $aPos = ControlGetPos($pHwnd[0],"",$hWnd);Get the current pos of the control
    If @error then Return SetError(1,3,0)
    $nHwnd = GUICreate("", $aPos[2], $aPos[3], $aPos[0], $aPos[1], 0x80000000, 0x00080000 + 0x00000040, $pHwnd[0]);greate a gui in the position of the control
    If $nHwnd = 0 then Return SetError(1,4,0)
    $a = DllCall("User32.dll", "hwnd", "SetParent", "hwnd", $hWnd, "hwnd", $nHwnd);change the parent of the control to the new gui
    If $a[0] = 0 then Return SetError(1,5,0)
    If NOT ControlMove($nHwnd,'',$hWnd,0,0) then Return SetError(1,6,-1);Move the control to 0,0 of the newly created child gui
    GUISetState(@SW_Show,$nHwnd);show the new child gui
    WinSetTrans($nHwnd,"",$iTrans);set the transparency
    If @error then Return SetError(1,7,0)
    GUISwitch($pHwnd[0]);switch back to the parent Gui
    
    Return $nHwnd;Return the handle for the new Child gui
    
EndFunc

Func _DeleteSrcFiles($count)
	Switch $count
		case 1
			FileDelete($scrfile1)
			
		Case 2
			FileDelete($scrfile1)
			FileDelete($scrfile2)
			
		Case 3
			FileDelete($scrfile1)
			FileDelete($scrfile2)
			FileDelete($scrfile3)
			
		Case 4
			FileDelete($scrfile1)
			FileDelete($scrfile2)
			FileDelete($scrfile3)
			FileDelete($scrfile4)
	EndSwitch
EndFunc

Func _exit()
	exit
EndFunc

Func _GUISetControlsVisible($hWnd)
    Local $aClassList, $aM_Mask, $aCtrlPos, $aMask
   
    $aClassList = StringSplit(_WinGetClassListEx($hWnd), @LF)
    $aM_Mask = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", 0, "long", 0, "long", 0, "long", 0)
   
    For $i = 1 To UBound($aClassList) - 1
        $aCtrlPos = ControlGetPos($hWnd, '', $aClassList[$i])
        If Not IsArray($aCtrlPos) Then ContinueLoop
       
        $aMask = DllCall("gdi32.dll", "long", "CreateRectRgn", _
            "long", $aCtrlPos[0], _
            "long", $aCtrlPos[1], _
            "long", $aCtrlPos[0] + $aCtrlPos[2], _
            "long", $aCtrlPos[1] + $aCtrlPos[3])
        DllCall("gdi32.dll", "long", "CombineRgn", "long", $aM_Mask[0], "long", $aMask[0], "long", $aM_Mask[0], "int", 2)
    Next
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $hWnd, "long", $aM_Mask[0], "int", 1)
EndFunc

Func _WinGetClassListEx($sTitle)
    Local $sClassList = WinGetClassList($sTitle)
    Local $aClassList = StringSplit($sClassList, @LF)
    Local $sRetClassList = "", $sHold_List = "|"
    Local $aiInHold, $iInHold
   
    For $i = 1 To UBound($aClassList) - 1
        If $aClassList[$i] = "" Then ContinueLoop
       
        If StringRegExp($sHold_List, "\|" & $aClassList[$i] & "~(\d+)\|") Then
            $aiInHold = StringRegExp($sHold_List, ".*\|" & $aClassList[$i] & "~(\d+)\|.*", 1)
            $iInHold = Number($aiInHold[UBound($aiInHold)-1])
           
            If $iInHold = 0 Then $iInHold += 1
           
            $aClassList[$i] &= "~" & $iInHold + 1
            $sHold_List &= $aClassList[$i] & "|"
           
            $sRetClassList &= $aClassList[$i] & @LF
        Else
            $aClassList[$i] &= "~1"
            $sHold_List &= $aClassList[$i] & "|"
            $sRetClassList &= $aClassList[$i] & @LF
        EndIf
    Next
   
    Return StringReplace(StringStripWS($sRetClassList, 3), "~", "")
EndFunc

Func _IsVisible($sWin, $sText='')
	if BitAnd(WinGetState($sWin, $sText), 2) then return 1
	return 0
EndFunc



