#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include "GDIpProgress.au3"
#include <Process.au3>

$Form1 = GUICreate("Form1", 492, 80, 193, 125)
GUICtrlCreatePic(@ScriptDir & "\1.jpg", 0, 40, 492, 40, $WS_CLIPSIBLINGS)
$Button1 = GUICtrlCreateButton("Start", 208, 8, 75, 25, 0)
$Progress1 = _ProgressCreate(55, 60, 386, 14)
;~ $Run = _RunDOS('innounp.exe -x OrbitSetup.exe -d"App\Ads"')
_ProgressSetText($Progress1, "")
_ProgressSetImages($Progress1, @ScriptDir & "\progress1.bmp", @ScriptDir & "\progress2.bmp")
_ProgressSet($Progress1, 0)
;~ _ProgressSet($Run, 0)
GUISetState(@SW_SHOW)


While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Button1
        For $i = 1 to 100 Step 1
            sleep(100)
		$Run = RunWait('innounp.exe -x OrbitSetup.exe -d"App\"');,'',@SW_HIDE)
;~         _ProgressSet($Progress1, $i)
        _ProgressSet($Run, 100)
        Next
    EndSwitch
WEnd
