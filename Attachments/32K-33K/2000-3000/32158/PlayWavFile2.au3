#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <WinAPI.au3>
;Multimedia Functions
;http://msdn.microsoft.com/en-us/library/dd743586(v=VS.85).aspx
Global $CharStruct_Of_lpData,$SLoop = 0, $SCountLoop = -1,$hwi,$RegisterProc 
OnAutoItExitRegister("Cleanup")
$hGUI = GUICreate("My Gui",300,200)
GUISetState()
SetBackGroundSound("chimes.wav")
While 1
$GUIMsg = GUIGetMsg()
Switch $GUIMsg
Case $GUI_EVENT_CLOSE
Exit
EndSwitch
WEnd

Func SetBackGroundSound($FileName_Or_CharStruct_Of_WavFile)
$hwi = PlayWavFile($FileName_Or_CharStruct_Of_WavFile,1)
If ($hwi) Then _
GUIRegisterMsg($WM_ACTIVATE,"MSGProc")
Return $hwi
EndFunc

Func MSGProc($hWnd,$Msg,$wParam,$lParam)
$WA = _WinAPI_LoWord($wParam)
Switch $WA
Case 1,2
Restart($hwi)
Case Else
Pause($hwi)
EndSwitch
EndFunc

Func PlayWavFile($FileName_Or_CharStruct_Of_WavFile,$Loop = 0,$CountLoop = -1)
Local $nBytes 
$SLoop = $Loop
if ($SCountLoop = -1 ) Then $SCountLoop = $CountLoop
if IsString($FileName_Or_CharStruct_Of_WavFile) Then
$PtrSize = FileGetSize($FileName_Or_CharStruct_Of_WavFile)
$wavehdr_tag = _
"ptr lpData;" & _
"DWORD dwBufferLength;" & _
"DWORD dwBytesRecorded;" &  _
"DWORD_PTR dwUser;" & _
"DWORD dwFlags;" & _
"DWORD dwLoops;" & _
"ptr lpNext;" & _
"DWORD_PTR reserved"
$WAVEHDR = DllStructCreate($wavehdr_tag)
$CharStruct_Of_lpData = DllStructCreate("char [" & $PtrSize & "]")
$hFile = _WinAPI_CreateFile($FileName_Or_CharStruct_Of_WavFile,2,2)
if Not($hFile) Then Return SetError(1,0,0)
_WinAPI_ReadFile($hFile,DllStructGetPtr($CharStruct_Of_lpData),$PtrSize,$nBytes)
_WinAPI_CloseHandle($hFile)
DllStructSetData($WAVEHDR,"dwBufferLength",$PtrSize)
DllStructSetData($WAVEHDR,"lpData",DllStructGetPtr($CharStruct_Of_lpData) + 44)
DllStructSetData($WAVEHDR,"dwFlags",1 + 2) ;WHDR_DONE + WHDR_PREPARED
DllStructSetData($WAVEHDR,"dwLoops",0) ;The dwLoops clearly does not work / Not used
$pwh = DllStructGetPtr($WAVEHDR)
ElseIf IsDllStruct($FileName_Or_CharStruct_Of_WavFile) Then
$CharStruct_Of_lpData = $FileName_Or_CharStruct_Of_WavFile
$PtrSize = DllStructGetSize($CharStruct_Of_lpData)
$wavehdr_tag = _
"ptr lpData;" & _
"DWORD dwBufferLength;" & _
"DWORD dwBytesRecorded;" &  _
"DWORD_PTR dwUser;" & _
"DWORD dwFlags;" & _
"DWORD dwLoops;" & _
"ptr lpNext;" & _
"DWORD_PTR reserved"
$WAVEHDR = DllStructCreate($wavehdr_tag)
DllStructSetData($WAVEHDR,"dwBufferLength",$PtrSize)
DllStructSetData($WAVEHDR,"lpData",DllStructGetPtr($CharStruct_Of_lpData) + 44)
DllStructSetData($WAVEHDR,"dwFlags",1 + 2) ;WHDR_DONE + WHDR_PREPARED
DllStructSetData($WAVEHDR,"dwLoops",0) ;The dwLoops clearly does not work / Not used
$pwh = DllStructGetPtr($WAVEHDR)
Else
Return SetError(2,0,0)
EndIf
$cbwh = DllStructGetSize($WAVEHDR)
$OFFSET_FORMATTAG = 20
$OFFSET_CHANNELS = 22
$OFFSET_SAMPLESPERSEC = 24
$OFFSET_AVGBYTESPERSEC = 28
$OFFSET_BLOCKALIGN = 32
$OFFSET_BITSPERSAMPLE = 34
$OFFSET_DATA = 44
$TagWAVEFORMATEX = _
"WORD  wFormatTag;" & _
"WORD  nChannels;" & _
"DWORD nSamplesPerSec;" & _
"DWORD nAvgBytesPerSec;" & _
"WORD  nBlockAlign;" & _
"WORD  wBitsPerSample;" & _
"WORD  cbSize"
$WAVEFORMATEX = DllStructCreate($TagWAVEFORMATEX)
$nChannels = DllStructCreate("DWORD",DllStructGetPtr($CharStruct_Of_lpData) + $OFFSET_CHANNELS)
$nSamplesPerSec = DllStructCreate("WORD",DllStructGetPtr($CharStruct_Of_lpData) + $OFFSET_SAMPLESPERSEC)
$nAvgBytesPerSec = DllStructCreate("DWORD",DllStructGetPtr($CharStruct_Of_lpData) + $OFFSET_AVGBYTESPERSEC)
$nBlockAlign = DllStructCreate("WORD",DllStructGetPtr($CharStruct_Of_lpData) + $OFFSET_BLOCKALIGN)
$wBitsPerSample = DllStructCreate("WORD",DllStructGetPtr($CharStruct_Of_lpData) + $OFFSET_BITSPERSAMPLE)
Local $WAVE_FORMAT_PCM = 1
DllStructSetData($WAVEFORMATEX,"wFormatTag",$WAVE_FORMAT_PCM)
DllStructSetData($WAVEFORMATEX,"nChannels",DllStructGetData($nChannels,1))
DllStructSetData($WAVEFORMATEX,"nSamplesPerSec",DllStructGetData($nSamplesPerSec,1))
DllStructSetData($WAVEFORMATEX,"nAvgBytesPerSec",DllStructGetData($nAvgBytesPerSec,1))
DllStructSetData($WAVEFORMATEX,"nBlockAlign", DllStructGetData($nBlockAlign,1))
DllStructSetData($WAVEFORMATEX,"wBitsPerSample",DllStructGetData($wBitsPerSample,1))
DllStructSetData($WAVEFORMATEX,"cbSize",0)
$RegisterProc = DllCallbackRegister("waveOutProc","none","ptr;uint;ptr;ptr;ptr") 
$RegisterProcPtr = DllCallbackGetPtr($RegisterProc)
Local $WAVE_MAPPER = -1
$MMRESULT = DllCall("Winmm.dll","UINT","waveOutOpen","ptr*",0,"UINT",$WAVE_MAPPER, _
"ptr",DllStructGetPtr($WAVEFORMATEX),"ptr",$RegisterProcPtr,"ptr",0,"DWORD",0x00030000) ;0x00030000 CALLBACK_FUNCTION 
If @error Then Return SetError(3,0,0)
if Not ($MMRESULT[0] = 0) Then Return SetError(3,$MMRESULT[0],0)
$hwi = $MMRESULT[1]
$MMRESULT = DllCall("Winmm.dll","int","waveOutWrite","ptr",$hwi,"ptr",$pwh,"UINT",$cbwh)
Sleep(10) ;Must sleep
If @error Then Return SetError(4,0,0)
if Not ($MMRESULT[0] = 0) Then Return SetError(4,$MMRESULT[0],0)
Return SetError(0,0,$hwi)
EndFunc

Func waveOutProc($hwi,$uMsg,$dwInstance,$dwParam1,$dwParam2)
Local _
$MM_WOM_OPEN = 0x3BB , _
$MM_WOM_CLOSE = 0x3BC , _
$MM_WOM_DONE = 0x3BD
Switch $uMsg
Case $MM_WOM_OPEN
Case $MM_WOM_DONE
if $SCountLoop <= -1 Then
if ($SLoop) Then 
AdlibRegister("LOOP",1)
Else
AdlibUnRegister("LOOP")
AdlibRegister("CLOSE",1)
EndIf
Else
if $SCountLoop > 1 And ($SLoop) Then
AdlibRegister("LOOP",1)
$SCountLoop -= 1
Else
AdlibUnRegister("LOOP")
AdlibRegister("CLOSE",1)
EndIf
EndIf
Case $MM_WOM_CLOSE
EndSwitch
EndFunc

Func Reset($hwi)
$MMRESULT = DllCall("Winmm.dll","int","waveOutReset","ptr",$hwi)
if Not ($MMRESULT[0] = 0) Then Return SetError(1,$MMRESULT[0],0)
Return SetError(0,0,1)
EndFunc

Func GetVolume($hwi)
$MMRESULT = DllCall("Winmm.dll","int","waveOutGetVolume","ptr",$hwi,"DWORD*",0)
if Not ($MMRESULT[0] = 0) Then Return SetError(1,$MMRESULT[0],0)
Return SetError(0,0,$MMRESULT[2])
EndFunc

Func SetVolume($hwi,$Volume = 0xFFFF) ;0xFFFF Full
$MMRESULT = DllCall("Winmm.dll","int","waveOutSetVolume","ptr",$hwi,"DWORD",$Volume)
if Not ($MMRESULT[0] = 0) Then Return SetError(1,$MMRESULT[0],0)
Return SetError(0,0,1)
EndFunc

Func Pause($hwi)
$MMRESULT = DllCall("Winmm.dll","int","waveOutPause","ptr",$hwi)
if Not ($MMRESULT[0] = 0) Then Return SetError(1,$MMRESULT[0],0)
Return SetError(0,0,1)
EndFunc

Func Restart($hwi)
$MMRESULT = DllCall("Winmm.dll","int","waveOutRestart","ptr",$hwi)
if Not ($MMRESULT[0] = 0) Then Return SetError(1,$MMRESULT[0],0)
Return SetError(0,0,1)
EndFunc

Func CLOSE()
AdlibUnRegister("CLOSE")
DllCall("Winmm.dll","int","waveOutClose","ptr",$hwi)
$SLoop = 0
$SCountLoop = -1
DllCallbackFree($RegisterProc)
EndFunc

Func BreakLoop()
Global $SLoop = 0 , $SCountLoop = -1
EndFunc

Func LOOP()
AdlibUnRegister("LOOP")
PlayWavFile($CharStruct_Of_lpData,$SLoop,$SCountLoop)
EndFunc

Func Cleanup()
DllCall("Winmm.dll","int","waveOutClose","ptr",$hwi)
DllCallbackFree($RegisterProc)
EndFunc