#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#Include <Constants.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <StaticConstants.au3>
#Include <SendMessage.au3>
#include <Array.au3>
#include <Misc.au3>
#include <foo.au3>
#Include <WinAPI.au3>
; Script Start - Add your code below here

Global $width = 3
global $hight = 3

Global $icon[$width * $hight + 1][3]
Global $num = 1

$gui = guicreate("test",(32 * $width) + (10 * ($width + 1)),(32 * $hight) + (10 * ($hight + 1)),-1,-1,$WS_POPUP, Bitand($WS_EX_ACCEPTFILES,$WS_EX_TOOLWINDOW), WinGetHandle("[CLASS:Progman]"))

For $b = 1 to $hight
	For $a = 1 to $width
		$icon[$num][1] = GUICtrlCreateIcon("1.ico","1.ico", (32 * ($a - 1)) + (10 * $a), (32 * ($b - 1)) + (10 * $b))
		$icon[$num][2] = "none" ;this is the path of the file to be opened
		_icon_get($icon[$num][1],".83m")
		GUICtrlSetTip($icon[$num][1],"Slot " & $num & " is empty. Click to set file")
		$num = $num +1
	Next
Next

$open = FileOpenDialog("Chose File", @DesktopDir, "all files (*.*)")
_icon_get($icon[5][1],$open)
GUICtrlSetTip($icon[5][1],$open)
$icon[5][2] = $open

GUISetState()

;==================================================================================================================
;==================================================================================================================
While 1
	$msg = GUIGetMsg()
    For $i = 1 To ($width * $hight)
        If $msg = $icon[$i][1] Then
			If $icon[$i][2] = "none" Then
				$open = FileOpenDialog("Chose File", @DesktopDir, "all files (*.*)")
				_icon_get($icon[$i][1],$open)
				GUICtrlSetTip($icon[$i][1],$open)
				$icon[$i][2] = $open
			Else
				ShellExecute($icon[$i][2])
			EndIf
		EndIf
	Next
	 If _IsPressed("01") Then _WindowDrag()
WEnd
;==================================================================================================================
;==================================================================================================================

Func _icon_get($ctrl,$pathOFfile)
	$extension = StringSplit($pathOFfile,".")
;~ 	MsgBox(0,"","."&$extension[2]);+++++++++++++++++++++++++++++++++++++    trobleshooting
	$reg = _GetRegDefIcon("."&$extension[2])
	_SetIcon($ctrl, $Reg[0], $Reg[1], 32, 32)
EndFunc
	
func _GetRegDefIcon($Path)    
    const $DF_NAME  = @SystemDir & '\shell32.dll'
    const $DF_INDEX = 0    
    local $filename, $name, $ext, $count, $curver, $defaulticon, $ret[2] = [$DF_NAME, $DF_INDEX]    
    $filename = StringTrimLeft($Path, StringInStr($Path, '\', 0, -1))
    $count = StringInStr($filename, '.', 0, -1)
    if $count > 0 then
        $count = StringLen($filename) - $count + 1
    endif
    $name = StringStripWS(StringTrimRight($filename, $count), 3)
    $ext = StringStripWS(StringRight($filename, $count - 1), 8)
    if StringLen($ext) = 0 then
        return $ret
    endif
    $curver = StringStripWS(RegRead('HKCR\' & RegRead('HKCR\' & '.' & $ext, '') & '\CurVer', ''), 3)
    if (@error) or (StringLen($curver) = 0) then
        $defaulticon =  _WinAPI_ExpandEnvironmentStrings(StringReplace(RegRead('HKCR\' & RegRead('HKCR\' & '.' & $ext, '') & '\DefaultIcon', ''), '''', ''))
    else
        $defaulticon =  _WinAPI_ExpandEnvironmentStrings(StringReplace(RegRead('HKCR\' & $curver & '\DefaultIcon', ''), '''', ''))
    endif
    $count = StringInStr($defaulticon, ',', 0, -1)
    if $count > 0 then
        $count = StringLen($defaulticon) - $count
        $ret[0] = StringStripWS(StringTrimRight($defaulticon, $count + 1), 3)
        if $count > 0 then
            $ret[1] = StringStripWS(StringRight($defaulticon, $count), 8)
        endif
    else
        $ret[0] = StringStripWS(StringTrimRight($defaulticon, $count), 3)
    endif
    if StringLeft($ret[0], 1) = '%' then
        $count = DllCall('shell32.dll', 'int', 'ExtractIcon', 'int', 0, 'str', $Path, 'int', -1)
        if $count[0] = 0 then
            $ret[0] = $DF_NAME
            if StringLower($ext) = 'exe' then
                $ret[1] = 2
            else
                $ret[1] = 0
            endif
        else
            $ret[0] = StringStripWS($Path, 3)
            $ret[1] = 0
        endif
    else
        if (StringLen($ret[0]) > 0) and (StringInStr($ret[0], '\', 0) = 0) then
            $ret[0] = @SystemDir & '\' & $ret[0]
        endif
    endif
    if not FileExists($ret[0]) then
        $ret[0] = $DF_NAME
        $ret[1] = $DF_INDEX
    endif
;   if $ret[1] < 0 then
;      $ret[1] = - $ret[1]
;   else
;      $ret[1] = - $ret[1] - 1
;   endif
    return $ret
endfunc; _GetRegDefIcon

func _SetIcon($controlID, $sIcon, $iIndex, $iWidth, $iHeight)    
    const $STM_SETIMAGE = 0x0172    
    local $hWnd, $hIcon, $Style, $Error = false
    $hWnd = GUICtrlGetHandle($controlID)
    if $hWnd = 0 then
        return SetError(1, 0, 0)
    endif    
    $hIcon = _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)
    if @error then
        return SetError(1, 0, 0)
    endif    
    $Style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
    if @error then
        $Error = 1
    else
        _WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, Hex($SS_ICON)))
        if @error then
            $Error = 1
        else
            _WinAPI_DeleteObject(_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, 0))
            _SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, _WinAPI_CopyIcon($hIcon))
            if @error then
                $Error = 1
            endif
        endif
    endif    
    _WinAPI_DeleteObject($hIcon)    
    return SetError($Error, 0, not $Error)
endfunc; _SetIcon

func _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)
    local $hIcon, $tIcon = DllStructCreate('hwnd'), $tID = DllStructCreate('hwnd')
    local $ret
    $ret = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr', DllStructGetPtr($tIcon), 'ptr', DllStructGetPtr($tID), 'int', 1, 'int', 0)
    if (@error) or ($ret[0] = 0)then
        return SetError(1, 0, 0)
    endif
    $hIcon = DllStructGetData($tIcon, 1)
    if ($hIcon = Ptr(0)) or (not IsPtr($hIcon)) then
        return SetError(1, 0, 0)
    endif    
    return SetError(0, 0, $hIcon)
endfunc; _WinAPI_PrivateExtractIcon

Func _WindowDrag()
    While _IsPressed("01")
        DllCall("user32.dll", "int", "SendMessage", "hWnd", $Gui, "int", $WM_NCLBUTTONDOWN, "int", $HTCAPTION, "int", 0)
    WEnd
EndFunc   ;==>_WindowDrag