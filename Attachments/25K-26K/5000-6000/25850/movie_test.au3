#cs ----------------------------------------------------------------------------
    
    AutoIt Version: 3.2.11.7 (beta)
    Author: ludocus
    
    Script Function:
    Template AutoIt script.
    
#ce ----------------------------------------------------------------------------

#include <GUIConstants.au3>
;#include "SoundGetSetQuery.au3"

Global $mov, $tAlias, $iLength = 0


$hVideo = GUICreate("Test Video Player", 340, 340)
GUICtrlCreateLabel("", 10, 10, 320, 240)
GUICtrlSetBkColor(-1, 0x000000)
$hPlay = GUICtrlCreateButton("Play", 10, 285, 60, 20)
$hPause = GUICtrlCreateButton("Pause", 75, 285, 60, 20)
$hLoad = GUICtrlCreateButton("Load", 140, 285, 60, 20)
$position = GUICtrlCreateSlider(6, 255, 325, 20) ; slider to seek position
GUICtrlSetLimit(-1, 100)
GUICtrlCreateLabel("Vol", 250, 320)
$volume = GUICtrlCreateSlider(230, 285, 100, 20) ; slider to set volume
GUICtrlSetLimit(-1, 100)
GUICtrlSetData($volume, 100)
;_SoundSetMasterVolume(100)

;; video time
$timeelasped = GUICtrlCreateLabel("0:00", 40, 320, 25, 20)
GUICtrlCreateLabel("/", 80, 320, 10, 20)
$totaltime = GUICtrlCreateLabel("0:00", 100, 320, 25, 20)

; master volume
$mastervol = GUICtrlCreateLabel("100", 270, 320, 25, 20)


GUISetState()

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            _MovieClose($mov)
            Exit
        Case $position ; thanks to @Authenticity
            Local $iPos, $iTotalMs
            
            If $iLength > 0 Then
                $iPos = GUICtrlRead($position)/100
                $iTotalMs = Int($iPos*$iLength)
                _MovieSeek($mov, $iTotalMs)
				_MoviePlay($mov)
		EndIf		
			
            
        Case $hPlay
					
			_MoviePlay($mov)
			
			
		Case $volume
			Local $ivol
			$ivol = GUICtrlRead($volume)
			;_SoundSetMasterVolume($ivol)
			GUICtrlSetData($mastervol, $ivol)
			
		Case $hPause
			
            _MoviePause($mov)

		Case $hLoad
        
		$sFile = FileOpenDialog("Open", "", "All Files (*.*)", 1)
			If $sFile = '' Then
                $iLength = 0
            Else
                $mov = _MovieOpen($sFile, $hVideo, 10, 10, 320, 240)
                $iLength = _MovieLength($mov)
			EndIf
    EndSwitch
WEnd



; Script Start - Add your code below here
Func mciSendString($string)
    Local $iRet
    $iRet = DllCall("winmm.dll", "int", "mciSendStringA", "str", $string, "str", "", "int", 65534, "hwnd", 0)
    If Not @error Then Return $iRet[2]
EndFunc   ;==>mciSendString

Func _MovieOpen($pFile, $pHwnd, $pTop, $pLeft, $pWidth, $pHeight, $pAlias = '')
    If $pAlias = '' Then $pAlias = RandomStr(10)
    mciSendString("close " & $pAlias)
    If Not @error Then
        mciSendString("open " & FileGetShortName($pFile) & " alias " & $pAlias)
        mciSendString("window " & $pAlias & " handle " & Number($pHwnd))
        mciSendString("put " & $pAlias & " destination at " & $pTop & ' ' & $pLeft & ' ' & $pWidth & ' ' & $pHeight)
        Return $pAlias
    Else
        Return 0
    EndIf
EndFunc   ;==>_MovieOpen

Func _MovieClose($hAlias)
    Return mciSendString("close " & $hAlias)
EndFunc   ;==>_MovieClose

Func _MoviePause($rAlias)
    Return mciSendString("pause " & $rAlias)
EndFunc   ;==>_MoviePause

Func _MovieStop($jAlias)
    Return mciSendString("seek " & $jAlias & " to start")
EndFunc   ;==>_MovieStop


Func _MoviePlay($sAlias)
    mciSendString("set Test_Video time format milliseconds")
    If mciSendString("status " & $sAlias & " position") = mciSendString("status " & $sAlias & " length") Then mciSendString("seek " & $sAlias & " to start")
    mciSendString("play " & $sAlias)
    Return 1
EndFunc   ;==>_MoviePlay

Func _MoviePos($tAlias)
    $sReturn = mciSendString("status " & $tAlias & " position")
    If @error Then Return 0
    Return $sReturn
EndFunc   ;==>_MoviePos

Func _MovieLength($tAlias)
    $tReturn = mciSendString("status " & $tAlias & " length")
    If @error Then Return 0
    Return $tReturn
EndFunc   ;==>_MovieLength

Func _MovieSeek($sSnd_id, $iMs)
    Local $iRet
    mciSendString("set " & FileGetShortName($sSnd_id) & " time format miliseconds")
    $iRet = mciSendString("seek " & $sSnd_id & " to " & $iMs)
    If $iRet = 0 Then
        Return 1
    Else
        Return SetError(1, 0, 0)
    EndIf
EndFunc   ;==>_MovieSeek

Func _MovieStatus($kAlias)
    Return mciSendString("status " & $kAlias & " mode")
EndFunc   ;==>_MovieStatus


Func RandomStr($len)
    Local $string
    For $iCurrentPos = 1 To $len
        $string &= Chr(Random(97, 122, 1))
    Next
    Return $string
EndFunc   ;==>RandomStr



