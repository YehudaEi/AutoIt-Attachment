#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.11.7 (beta)
 Author:         ludocus

 Script Function:
    Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <GUIConstants.au3>
global $mov, $tAlias


$hVideo = GUICreate("Test Video Player", 340, 280)
$hPlay = GUICtrlCreateButton("Play", 10, 255, 60, 20)
$hPause = GUICtrlCreateButton("Pause", 75, 255, 60, 20)
$hLoad = GUICtrlCreateButton("Load", 140, 255, 60, 20)
$position = GUICtrlCreateSlider(205, 255, 130, 20) ; slider to seek position
GUISetState()

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            _MovieClose($mov)
            Exit
		Case $position
			
        Case $hPlay
			 _MoviePlay($mov)
        Case $hPause
            _MoviePause($mov)
        Case $hLoad
            $sFile = FileOpenDialog("Open", "", "All Files (*.*)", 1)
            if not $sFile = '' Then
                $mov = _MovieOpen($sFile, $hVideo, 10, 10, 320, 240 )
            EndIf
    EndSwitch
WEnd



; Script Start - Add your code below here
Func mciSendString($string)
    Local $iRet
    $iRet = DllCall("winmm.dll", "int", "mciSendStringA", "str", $string, "str", "", "int", 65534, "hwnd", 0)
    If Not @error Then Return $iRet[2]
EndFunc   ;==>mciSendString

Func _MovieOpen($pFile, $pHwnd, $pTop, $pLeft, $pWidth, $pHeight, $pAlias='')
    if $pAlias = '' then $pAlias = RandomStr(10)
    mciSendString("close "&$pAlias)
    if Not @error Then
        mciSendString("open " & FileGetShortName($pFile) & " alias "&$pAlias)
        mciSendString("window "&$pAlias&" handle " & Number($pHwnd))
        mciSendString("put "&$pAlias&" destination at "&$pTop&' '&$pLeft&' '&$pWidth&' '&$pHeight)
        return $pAlias
    Else
        return 0
    EndIf
EndFunc

func _MovieClose($hAlias)
    return mciSendString("close "&$hAlias)
EndFunc

func _MoviePause($rAlias)
    return mciSendString("pause "&$rAlias)
EndFunc

func _MovieStop($jAlias)
    return mciSendString("seek " &$jAlias& " to start")
EndFunc


func _MoviePlay($sAlias)
    mciSendString("set Test_Video time format milliseconds")
    If mciSendString("status "&$sAlias&" position") = mciSendString("status "&$sAlias&" length") Then mciSendString("seek "&$sAlias&" to start")
    mciSendString("play "&$sAlias)
    return 1
EndFunc

func _MoviePos($tAlias)
    $sReturn = mciSendString("status "&$tAlias&" position")
    if @error then return 0
    return $sReturn
EndFunc

func _MovieLength($tAlias)
    $tReturn = mciSendString("status "&$tAlias&" length")
    if @error then return 0
    return $tReturn
EndFunc

func _MovieSeek($sSnd_id, $iHour, $iMin, $iSec)
    Local $iMs = 0
    Local $iRet
    mciSendString("set " & FileGetShortName($sSnd_id) & " time format miliseconds")
    $iMs += $iSec * 1000
    $iMs += $iMin * 60 * 1000
    $iMs += $iHour * 60 * 60 * 1000
    $iRet = mciSendString("seek " &$sSnd_id& " to " & $iMs)
    If $iRet = 0 Then
        Return 1
    Else
        Return SetError(1, 0, 0)
    EndIf
EndFunc

func _MovieStatus($kAlias)
    Return mciSendString("status "&$kAlias&" mode")
EndFunc


Func RandomStr($len)
    Local $string
    For $iCurrentPos = 1 To $len
        $string &= Chr(Random(97, 122, 1))
    Next
    Return $string
EndFunc



