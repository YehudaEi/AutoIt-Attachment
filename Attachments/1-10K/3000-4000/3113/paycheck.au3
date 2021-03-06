#include <GuiConstants.au3>
#include<GUIList.au3>
#include<date.au3>
#include <Array.au3>
$iniexists = IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Wage", "0")
If $iniexists = 0 Then
  IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Wage", "0")
  IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Dollar Value", "0")
  IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Percent", "0")
  IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Percentdollar", "0")
  IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Dollarpercent", "0")
  IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Timeandahalf", "0")
  IniWrite(@ScriptDir & "\Paycheck.ini", "Grand Total", "Grand Total Hours", "0")
  IniWrite(@ScriptDir & "\Paycheck.ini", "Grand Total", "Grand Total", "0")
EndIf
GUICreate("Paycheck Tracker v1.0", 339, 210, (@DesktopWidth - 339) / 2, (@DesktopHeight - 210) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$clearok = 0
$paycheckhours = 0
$grandtotal = IniRead(@ScriptDir & "\Paycheck.ini", "Grand Total", "Grand Total", "0")
$grandtotalhours = IniRead(@ScriptDir & "\Paycheck.ini", "Grand Total", "Grand Total Hours", "0")
$Update = GUICtrlCreateButton("Update", 20, 50, 80, 20)
$ViewPaycheck = GUICtrlCreateButton("View Paycheck", 130, 50, 80, 20)
$NewPaycheck = GUICtrlCreateButton("New Paycheck", 130, 90, 80, 20)
$Options = GUICtrlCreateButton("Options", 20, 90, 80, 20)
$ReviewHours = GUICtrlCreateButton("Review Hours", 240, 50, 80, 20)
$About = GUICtrlCreateButton("About", 240, 90, 80, 20)
$Exit = GUICtrlCreateButton("Exit", 240, 180, 80, 20)
$Label_8 = GUICtrlCreateLabel("Paycheck Tracker", 0, 0, 340, 40)
GUICtrlSetFont(-1, 25, "", "", "Dragonwick")
$Label_9 = GUICtrlCreateLabel("Press [Update] to add more hours that you have worked.  Press [Options] to set your wage and deductions.", 30, 130, 280, 30)
GUISetState()
While 1
  $msg = GUIGetMsg()
  Select
    Case $msg = $Update
      $updategui = GUICreate("Update", 219, 331, (@DesktopWidth - 219) / 2, (@DesktopHeight - 228) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
      $updatelabel = GUICtrlCreateLabel("Update", 0, 0, 220, 50, $SS_CENTER)
      GUICtrlSetFont(-1, 30, "", "", "Dragonwick")
      $cancel = GUICtrlCreateButton("Cancel", 130, 255, 60, 20)
      $update2 = GUICtrlCreateButton("Update", 30, 255, 60, 20)
      $updateDate = GUICtrlCreateMonthCal ("", 15, 70, 186, 163)
      $hoursworked = GUICtrlCreateInput("0.00", 115, 233, 80, 20)
      $Label_8 = GUICtrlCreateLabel("Select the date you worked", 50, 50, 140, 20)
      $Label_9 = GUICtrlCreateLabel("Hours Worked*", 35, 238, 80, 15)
      $Label_10 = GUICtrlCreateLabel("*Enter the hours in decimal form.  Ex: 7 hours and 15 min. should be typed as 7.25  . To find the decimal you take the minutes you worked and divide them by 60.   15/60=25.", 3, 275, 220, 60)
      GUISetState()
      While 1
        $msg = GUIGetMsg()
        Select
          Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
          Case $msg = $cancel
            ExitLoop
          Case $msg = $update2
            IniWrite(@ScriptDir & "\Paycheck.ini", "Current Paycheck", GUICtrlRead($updateDate), GUICtrlRead($hoursworked))
            ExitLoop
            ;;;
        EndSelect
      WEnd
      GUIDelete("Update")
    Case $msg = $ViewPaycheck
      $paychecktotal = 0
      $readhours = IniReadSection(@ScriptDir & "\Paycheck.ini", "Current Paycheck")
      If @error Then
        MsgBox(4096, "", "No hours means no cash.")
      Else
        For $i = 1 To $readhours[0][0]
          If IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Timeandahalf", "0") = 1 And $readhours[$i][1] > 8 Then
            $readhours[$i][1] = $readhours[$i][1]+ (1.5* ($readhours[$i][1] - 8))
          EndIf
          $paychecktotal = $paychecktotal + $readhours[$i][1]
        Next
        $paychecktotal = $paychecktotal * IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Wage", "0.00")
        If IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Percentdollar", "0") = 1 Then
          $paychecktotal = $paychecktotal- (IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Percent", "0") * .01 * $paychecktotal) - IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Dollar Value", "0.00")
        ElseIf IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Dollarpercent", "0") = 1 Then
          $paychecktotal = $paychecktotal - IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Dollar Value", "0.00")
          $paychecktotal = $paychecktotal- (IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Percent", "0") * .01 * $paychecktotal)
        EndIf
        MsgBox(0, "", "$" & Round($paychecktotal, 2) & " made during this paycheck.")
      EndIf
    Case $msg = $NewPaycheck
      $iMsgBoxAnswer = MsgBox(52, "New Paycheck?", "Are you sure you want to clear the current paycheck and start a new one?")
      Select
        Case $iMsgBoxAnswer = 6 ;Yes
          $paychecktotal = 0
          $readhours = IniReadSection(@ScriptDir & "\Paycheck.ini", "Current Paycheck")
          If @error Then
            MsgBox(4096, "", "Error occured, probably no INI file.")
          Else
            For $i = 1 To $readhours[0][0]
              $paycheckhours = $paycheckhours + $readhours[$i][1]
              If IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Timeandahalf", "0") = 1 And $readhours[$i][1] > 8 Then
                $readhours[$i][1] = $readhours[$i][1]+ (1.5* ($readhours[$i][1] - 8))
              EndIf
              IniWrite(@ScriptDir & "\Paycheck.ini", "All Paychecks", $readhours[$i][0], $readhours[$i][1])
              $paychecktotal = $paychecktotal + $readhours[$i][1]
              IniDelete(@ScriptDir & "\Paycheck.ini", "Current Paycheck", $readhours[$i][0])
            Next
            $paychecktotal = $paychecktotal * IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Wage", "0.00")
            If IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Percentdollar", "0") = 1 Then
              $paychecktotal = $paychecktotal- (IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Percent", "0") * .01 * $paychecktotal) - IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Dollar Value", "0.00")
            ElseIf IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Dollarpercent", "0") = 1 Then
              $paychecktotal = $paychecktotal - IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Dollar Value", "0.00")
              $paychecktotal = $paychecktotal- (IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Percent", "0") * .01 * $paychecktotal)
            EndIf
            Round($paychecktotal, 2)
            $grandtotal = $grandtotal + $paychecktotal
            $grandtotalhours = $grandtotalhours + $paycheckhours
            IniWrite(@ScriptDir & "\Paycheck.ini", "Grand Total", "Grand Total Hours", $grandtotalhours)
            IniWrite(@ScriptDir & "\Paycheck.ini", "Grand Total", "Grand Total", $grandtotal)
          EndIf
        Case $iMsgBoxAnswer = 7 ;No
          ExitLoop
      EndSelect
    Case $msg = $Options;done
      GUICreate("Options", 240, 268, (@DesktopWidth - 240) / 2, (@DesktopHeight - 268) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
      $OptionsLabel = GUICtrlCreateLabel("Options", 0, 0, 240, 90)
      GUICtrlSetFont(-1, 38, "", "", "Dragonwick")
      $WageLabel = GUICtrlCreateLabel("Wage", 0, 90, 40, 20)
      $WageInput = GUICtrlCreateInput(IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Wage", "0.00"), 40, 90, 60, 20)
      $DollarvalLabel = GUICtrlCreateLabel("Dollar Value", 10, 140, 60, 20)
      $Deductgroup = GUICtrlCreateGroup("Deductions", 0, 120, 140, 110)
      $DollarvalInput = GUICtrlCreateInput(IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Dollar Value", "0.00"), 70, 140, 60, 20)
      $PercentLabel = GUICtrlCreateLabel("Percent", 10, 160, 60, 20)
      $PercentInput = GUICtrlCreateInput(IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Percent", "0"), 70, 160, 60, 20)
      $PercentRadio = GUICtrlCreateRadio("Percent then dollar.", 10, 180, 120, 20)
      If IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Percentdollar", "0") = 1 Then	GUICtrlSetState (-1, $GUI_CHECKED)
      $DollarRadio = GUICtrlCreateRadio("Dollar then percent.", 10, 200, 120, 20)
      If IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Dollarpercent", "0") = 1 Then	GUICtrlSetState (-1, $GUI_CHECKED)
      $Checkbox = GUICtrlCreateCheckbox("Time and a half after 8 hours.", 40, 230, 160, 20)
      If IniRead(@ScriptDir & "\Paycheck.ini", "Options", "Timeandahalf", "0") = 1 Then	GUICtrlSetState (-1, $GUI_CHECKED)
      $Accept = GUICtrlCreateButton("Accept", 150, 130, 80, 30)
      $OptionsCancel = GUICtrlCreateButton("Cancel", 150, 190, 80, 30)
      GUISetState()
      While 1
        $msg = GUIGetMsg()
        Select
          Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
          Case $msg = $Accept
            If GUICtrlRead($Checkbox) = 1 Then
              $taah = 1
            Else
              $taah = 0
            EndIf
            If GUICtrlRead($PercentRadio) = 1 Then
              $pd = 1
              $dp = 0
            Else
              $dp = 1
              $pd = 0
            EndIf
            IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Wage", GUICtrlRead($WageInput))
            IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Dollar Value", GUICtrlRead($DollarvalInput))
            IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Percent", GUICtrlRead($PercentInput))
            IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Percentdollar", $pd)
            IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Dollarpercent", $dp)
            IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Timeandahalf", $taah)
            ExitLoop
          Case $msg = $OptionsCancel
            ExitLoop
        EndSelect
      WEnd
      GUIDelete("Options")
    Case $msg = $ReviewHours
      GUICreate("Review Hours", 390, 341, (@DesktopWidth - 390) / 2, (@DesktopHeight - 341) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
      $alldays = GUICtrlCreateList("", 190, 55, 200, 274, $LBS_DISABLENOSCROLL + $WS_VSCROLL + $LBS_NOTIFY)
      $RHDate = GUICtrlCreateMonthCal ("", 0, 55, 186, 158)
      GUICtrlSetData(-1, _NowDate())
      $RHLabel2 = GUICtrlCreateLabel("Review Hours", 0, 0, 190, 50, $SS_CENTER)
      GUICtrlSetFont(-1, 20, "", "", "Dragonwick")
      $RHOK = GUICtrlCreateButton("OK", 10, 220, 90, 30)
      $RHTotalearned = GUICtrlCreateButton("Total Earned", 50, 260, 90, 30)
      $RHClearall = GUICtrlCreateButton("Clear all", 90, 300, 90, 30)
      $madethisday = IniRead(@ScriptDir & "\Paycheck.ini", "Current Paycheck", _NowDate(), "0") + IniRead(@ScriptDir & "\Paycheck.ini", "All Paychecks", _NowDate(), "0")
      $RHLabel = GUICtrlCreateLabel("$" & $madethisday & " made on this day.  Press [Ok] to return to the main menu.", 190, 0, 200, 50)
      GUISetState()
      $allhours = IniReadSection(@ScriptDir & "\Paycheck.ini", "All Paychecks")
      If @error Then
        MsgBox(4096, "", "No hours means no cash.")
        $nohours = 1
      Else
        $nohours = 0
        For $i = 1 To $allhours[0][0]
          GUICtrlSetData($alldays, _DateTimeFormat($allhours[$i][0], 1), _DateTimeFormat($allhours[1][0], 1))
        Next
        GUICtrlSetData($RHDate, $allhours[1][0])
        $firstselect = _DateTimeFormat($allhours[1][0], 1)
        GUICtrlSetData($RHLabel, "You worked " & IniRead(@ScriptDir & "\Paycheck.ini", "All Paychecks", GUICtrlRead($RHDate), "0") & " hours this day.    Press [Ok] to return to the main menu.")
      EndIf
      While 1
        $msg = GUIGetMsg()
        Select
          Case $nohours = 1
            ExitLoop
          Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
          Case $msg = $RHOK
            If $clearok = 1 Then
              IniDelete(@ScriptDir & "\Paycheck.ini", "Options")
              IniDelete(@ScriptDir & "\Paycheck.ini", "Current Paycheck")
              IniDelete(@ScriptDir & "\Paycheck.ini", "Grand Total")
              IniDelete(@ScriptDir & "\Paycheck.ini", "All Paychecks")
              IniWrite(@ScriptDir & "\Paycheck.ini", "Options", "Wage", "0.00")
              IniWrite(@ScriptDir & "\Paycheck.ini", "Grand Total", "Grand Total Hours", "0")
              IniWrite(@ScriptDir & "\Paycheck.ini", "Grand Total", "Grand Total", "0")
              _GUICtrlListClear ($alldays)
              $clearok = 0
            Else
              ExitLoop
            EndIf
          Case $msg = $RHTotalearned
            $clearok = 0
            GUICtrlSetData($RHLabel, "You have earned a grand total of $" & IniRead(@ScriptDir & "\Paycheck.ini", "Grand Total", "Grand Total", "0") & " since your first entry, excluding this paycheck.    Press [Ok] to return to the main menu.")
          Case $msg = $RHClearall
            GUICtrlSetData($RHLabel, "If you are sure that you want to clear ALL data, press [Ok].                                        If you don't want to, click a button or date other than [Ok].")
            $clearok = 1
          Case Else
            $too = _DateTimeFormat(GUICtrlRead($RHDate), 1)
            If GUICtrlRead($alldays) = $too Then
            Else
              If GUICtrlRead($alldays) = $firstselect Then
                $clearok = 0
                $ret = _GUICtrlListSelectString ($alldays, $too)
                If ($ret == $LB_ERR) Then
                Else
                  $firstselect = $too
                  GUICtrlSetData($RHLabel, "You worked " & IniRead(@ScriptDir & "\Paycheck.ini", "All Paychecks", GUICtrlRead($RHDate), "0") & " hours this day.    Press [Ok] to return to the main menu.")
                EndIf
              Else
                $clearok = 0
                $firstselect = GUICtrlRead($alldays)
                $YYYY = StringRight($firstselect, 4)
                $DD = StringTrimRight($firstselect, 6)
                $DD = StringRight($DD, 2)
                If StringInStr($firstselect, "January") Then $MM = "01"
                If StringInStr($firstselect, "February") Then $MM = "02"
                If StringInStr($firstselect, "March") Then $MM = "03"
                If StringInStr($firstselect, "April") Then $MM = "04"
                If StringInStr($firstselect, "May") Then $MM = "05"
                If StringInStr($firstselect, "June") Then $MM = "06"
                If StringInStr($firstselect, "July") Then $MM = "07"
                If StringInStr($firstselect, "August") Then $MM = "08"
                If StringInStr($firstselect, "September") Then $MM = "09"
                If StringInStr($firstselect, "October") Then $MM = "10"
                If StringInStr($firstselect, "November") Then $MM = "11"
                If StringInStr($firstselect, "December") Then $MM = "12"
                $YYYYMMDD = $YYYY & "/" & $MM & "/" & $DD
                GUICtrlSetData($RHDate, $YYYYMMDD)
                GUICtrlSetData($RHLabel, "You worked " & IniRead(@ScriptDir & "\Paycheck.ini", "All Paychecks", $YYYYMMDD, "0") & " hours this day.    Press [Ok] to return to the main menu.")
              EndIf
            EndIf
        EndSelect
      WEnd
      GUIDelete("Review Hours")
    Case $msg = $About;finished
      MsgBox(64, "About Paycheck Tracker", "Paycheck Tracker v1.0" & @CRLF & "By Kolin Paulk    June 26, 2005")
    Case $msg = $Exit;finished
      ExitLoop
    Case $msg = $GUI_EVENT_CLOSE
      ExitLoop
    Case Else
      ;;;
  EndSelect
WEnd
Exit