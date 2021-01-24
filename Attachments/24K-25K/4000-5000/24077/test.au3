$INI = "test.ini"
;$Ini = "C:\SomePath\SomeFile.ini"
$aSecs = IniReadSectionNames($Ini)
$Main = GUICreate("Test GUI")
$Lv = GUICtrlCreateListView("Section|Key|Value",10,10,300, 300)
For $I = 1 To Ubound($aSecs) -1
   $aVals = IniReadSection($Ini, $aSecs[$I])
   For $X = 1 To Ubound($aVals) -1
      $sVal = $aSecs[$i] & "|" & $aVals[$x][0] & "|" & $aVals[$x][1]
      GUICtrlCreateListViewItem($sVal, $Lv)
   Next
Next
GUISetState()
While 1
   If GUIGetMsg() = -3 Then Exit
Wend