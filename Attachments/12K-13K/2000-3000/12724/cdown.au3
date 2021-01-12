#NoTrayIcon
#include <GUIConstants.au3>
#include <date.au3>
#include <array.au3>
Const $DTM_SETFORMAT = 0x1005
Dim $dtStyle = "yyyy/MM/dd HH:mm:ss"
Dim $isRunning = False
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=c:\documents and settings\ariel\my documents\frmcountdown.kxf
$frmCountDown = GUICreate("CountDown", 603, 141, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_SYSMENU, $WS_DLGFRAME, $WS_GROUP, $DS_MODALFRAME), BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "frmCountDownClose")
$grpCountTo = GUICtrlCreateGroup("Countdown To...", 8, 8, 225, 49, $BS_CENTER)
$dtToDate = GUICtrlCreateDate(IniRead("cdown.settings.ini", "MAIN", "TARGET_DATE", "2012/05/15 00:00:00"), 14, 25, 209, 25, $WS_TABSTOP)
GUICtrlSendMsg($dtToDate, $DTM_SETFORMAT, 0, $dtStyle)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$cmdStart = GUICtrlCreateButton("&Start", 8, 64, 225, 57, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "cmdStartClick")
$lblOut = GUICtrlCreateLabel("", 237, 8, 350, 114)
GUICtrlSetFont(-1, 12, 400, 0, "Lucida Console")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
If IniRead("cdown.settings.ini", "MAIN", "RUNNING", "False") = "True" Then cmdStartClick()
While 1
  Sleep(100)
WEnd
Func cmdStartClick()
  If $isRunning Then
    AdlibDisable()
    GUICtrlSetState($dtToDate, $GUI_ENABLE)
    GUICtrlSetData($cmdStart, "&Start")
  Else
    AdlibEnable("updateLabel", 1000)
    GUICtrlSetState($dtToDate, $GUI_DISABLE)
    GUICtrlSetData($cmdStart, "&Stop")
  EndIf
  $isRunning = Not $isRunning
EndFunc   ;==>cmdStartClick
Func frmCountDownClose()
  AdlibDisable()
  IniWrite("cdown.settings.ini", "MAIN", "TARGET_DATE", GUICtrlRead($dtToDate))
  IniWrite("cdown.settings.ini", "MAIN", "RUNNING", $isRunning)
  Exit
EndFunc   ;==>frmCountDownClose
Func updateLabel()
  Dim $rem
  Dim $iterator
  Dim $lblContent
  Dim $verify_Now = _NowCalc()
  Dim $verify_Now_ARY = StringSplit($verify_Now, " :/")
  Dim $verify_End = GUICtrlRead($dtToDate)
  Dim $verify_End_ARY = StringSplit($verify_End, " :/")
  Dim $cDate[6]
  Dim $eDate[6]
  Dim $rDate[6]
  _ArrayDelete($verify_Now_ARY, 0)
  _ArrayPush($cDate, $verify_Now_ARY)
  _ArrayDelete($verify_End_ARY, 0)
  _ArrayPush($eDate, $verify_End_ARY)
  $lblContent = "Time Remaining Until " & $verify_End & " : "
  $rem = _DateDiff("S", $verify_Now, $verify_End)
  If $rem > 0 Then
    For $iterator = 0 To 5
      _ArrayPush($rDate, _ArrayPop($eDate) - _ArrayPop($cDate), 1)
    Next
    For $iterator = 5 To 1 Step - 1
      If $rDate[$iterator] < 0 Then
        $rDate[$iterator - 1] -= 1
        If $iterator = 5 Then
          $rDate[$iterator] += 60
        ElseIf $iterator = 4 Then
          $rDate[$iterator] += 60
        ElseIf $iterator = 3 Then
          $rDate[$iterator] += 24
        ElseIf $iterator = 2 Then
          $rDate[$iterator] += 30
        ElseIf $iterator = 1 Then
          $rDate[$iterator] += 12
        EndIf
      EndIf
    Next
    Dim $dateparts = 0
    If $rDate[0] > 0 Then
      If $dateparts = 0 Then
        $lblContent = $lblContent & @CRLF
      Else
        $lblContent = $lblContent & ", "
      EndIf
      $dateparts = $dateparts + 1
      $lblContent = $lblContent & $rDate[0] & " Year"
      If $rDate[0] > 1 Then $lblContent = $lblContent & "s"
    EndIf
    If $rDate[1] > 0 Then
      If $dateparts = 0 Then
        $lblContent = $lblContent & @CRLF
      Else
        $lblContent = $lblContent & ", "
      EndIf
      $dateparts = $dateparts + 1
      $lblContent = $lblContent & $rDate[1] & " Month"
      If $rDate[1] > 1 Then $lblContent = $lblContent & "s"
    EndIf
    If $rDate[2] > 0 Then
      If $dateparts = 0 Then
        $lblContent = $lblContent & @CRLF
      Else
        $lblContent = $lblContent & ", "
      EndIf
      $dateparts = $dateparts + 1
      $lblContent = $lblContent & $rDate[2] & " Day"
      If $rDate[2] > 1 Then $lblContent = $lblContent & "s"
    EndIf
    If $rDate[3] > 0 Then
      If $dateparts = 0 Then
        $lblContent = $lblContent & @CRLF
      Else
        $lblContent = $lblContent & ", "
      EndIf
      $dateparts = $dateparts + 1
      $lblContent = $lblContent & $rDate[3] & " Hour"
      If $rDate[3] > 1 Then $lblContent = $lblContent & "s"
    EndIf
    If $rDate[4] > 0 Then
      If $dateparts = 0 Then
        $lblContent = $lblContent & @CRLF
      Else
        $lblContent = $lblContent & ", "
      EndIf
      $dateparts = $dateparts + 1
      $lblContent = $lblContent & $rDate[4] & " Minute"
      If $rDate[4] > 1 Then $lblContent = $lblContent & "s"
    EndIf
    If $rDate[5] > 0 Then
      If $dateparts = 0 Then
        $lblContent = $lblContent & @CRLF
      Else
        $lblContent = $lblContent & ", "
      EndIf
      $dateparts = $dateparts + 1
      $lblContent = $lblContent & $rDate[5] & " Second"
      If $rDate[5] > 1 Then $lblContent = $lblContent & "s"
    EndIf
    Dim $lastPos = StringInStr($lblContent, ",", 0, -1)
    $lblContent = StringLeft($lblContent, $lastPos) & " and" & StringRight($lblContent, StringLen($lblContent) - $lastPos)
    If $dateparts < 3 Then $lblContent = StringReplace($lblContent, ",", "")
  Else
    $lblContent = $eDate & " has already passed..."
    $isRunning = False
    AdlibDisable()
  EndIf
  GUICtrlSetData($lblOut, $lblContent)
EndFunc   ;==>updateLabel