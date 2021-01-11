#include <GUIConstants.au3>
#include <_IsPressed.au3>
Opt("WinTitleMatchMode", 4)
Global $slider1, $min, $n, $last, $sec

HotKeySet("^+x", "Stop")
HotkeySet("^+z", "Hide")

If @error = 1 Then
  Stop()
EndIf

$Slider = GUICreate("Slide Bar To Choose Time ", 225, 100) ; Slider to start at 0
GUISetBkColor (123)
GuiSetState()

$slider1 = GuiCtrlCreateSlider (10,10,200,20)

GUICtrlSetLimit($slider1,360,0)
$button = GUICtrlCreateButton ("Start Timer",75,70,70,20)
GUISetState()
GUICtrlSetData($slider1,0); Slider to start at 0.

;..................................................................

While 1
    Sleep(10)
    If _IsPressed('0D') = 1 Then Call ("CR") ;1B=enter
        $min = GuiCtrlRead($slider1)
    If $last = $min Then
    Else
    WinSetTitle ( "handle=" & $Slider , "", $min & " Min   Or  " & Round($min/60, 2) &"  Hr To Go" )
        $last = $min
    EndIf

        $n = GUIGetMsg ()
    
    If $n = $button Then
    GuiDelete ()
    Call ("Progress")
    EndIf
Wend

;.................................................................


Func Progress()
$hr = $min/60
$sec = $min * 60
$step = 100 / $sec
ProgressOn("Progress Meter", "ShutDown Time Requested: " & Round($min/60, 1) & " Hours", "0 Mins Gone So Far", -1, -1, 16)
For $i = 0 To 100 Step $step
  $sec = $sec - 1
  $min = round($min - 1/60, 2)
      Sleep(1000)
  If $min > 2 Then
    ProgressSet($i, $min & " minutes left before shutdown." & @CRLF & @CRLF & "Ctl-Sh-x = Abort      Ctl-Sh-z = Show/Hide      © by Kon") 
   Else
    ProgressSet($i, $sec & " seconds left before shutdown." & @CRLF & @CRLF & "Ctl-Sh-x = Abort      Ctl-Sh-z = Show/Hide       © by Kon") 
  EndIf 
Next
Shutdown(9)
Exit
EndFunc;==>Progress


Func Stop()
  Winactivate ("Progress Meter") 
  Exit 0
EndFunc  ;==>Stop


Func CR()
    sleep (100)
   send ("{tab}{left}{tab 2}{enter}")
EndFunc  ;==>CR

Func Hide()
    $state = WinGetState("Progress Meter", "")
    If BitAND($state, 2) Then
        WinSetState("Progress Meter", "", @SW_HIDE)
    Else
        WinSetState("Progress Meter", "", @SW_SHOW)
    EndIf
EndFunc  ;==>Hide