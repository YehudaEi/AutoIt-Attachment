;; Very "proof of Concept" for a Tetris. (Sample)
;;--- Josbe (jzcript at yahoo dot com) ---Oct.05/2004

#include "GUIConstants.au3"

$win = GUICreate("Test: tetris", 200, 200)
Dim $Blk[3][3]
Dim $BlkPos[3][3]
$ub = UBound($Blk) / 2
$speed = 6

GUICtrlCreateLabel("", 50, 0, 110, 200, $SS_SUNKEN)
GUICtrlSetBkColor(-1, 0x000000)

For $x = 0 To 2
   $PosXInit = 90 + ($x * 10)
   For $y = 0 To 2 
      $PosYInit= ($y * 10)
      $Blk[$x][$y] = GUICtrlCreateLabel("", $PosXInit, $PosYInit, 10, 10, $SS_ETCHEDFRAME)
      GUICtrlSetBkColor(-1, 0x55FF00)
      If ($x = 2 And $y = 2) OR ($x = 2 And $y = 1) OR ($x = 0 And $y = 1) OR ($x = 0 And $y = 2) Then GUICtrlSetState(-1, $GUI_HIDE)
      $blkPos[$x][$y] = $PosXInit & "|" & $PosYInit
   Next
Next

$posMode = 1

HotKeySet("{UP}", "_movUP")
HotKeySet("{DOWN}", "_movDOWN")
HotKeySet("{LEFT}", "_movLEFT")
HotKeySet("{RIGHT}", "_movRIGHT")
HotKeySet("{SPACE}", "_movFALL")
GUISetState()
$myTimer = TimerInit()

While 1
   
   If TimerDiff($myTimer) >=  ($speed * 100) Then
      _movDOWN()
      $myTimer = TimerInit()
   EndIf
   $msg = GUIGetMsg(1)
   
   Select
      Case $GUI_EVENT_CLOSE = $msg[0]
         ExitLoop
         
   EndSelect
Wend
Exit

Func _movUP()
   ; Patterns for "T" piece
   Select
      Case $posMode = 1
         $ptt = "0|1|0|0|1|0|1|1|1"
         $posMode = 2
         
      Case $posMode = 2
         $ptt = "0|0|1|1|1|1|0|0|1"   
         $posMode = 3
         
      Case $posMode = 3
         $ptt = "1|1|1|0|1|0|0|1|0"   
         $posMode = 4
         
      Case $posMode = 4
         $ptt = "1|0|0|1|1|1|1|0|0"   
         $posMode = 1
         
   EndSelect
   
   $patt = StringSplit($ptt, "|")
   
   $dd = 0
   For $x = 0 To 2
      For $y = 0 To 2
         $dd = $dd + 1
         $stt = $patt[$dd]
         If $stt = 0 Then
            $mySta = $GUI_HIDE
         Else
            $mySta = $GUI_SHOW
         EndIf
         GUICtrlSetState($Blk[$x][$y], $mySta)
      Next
   Next
EndFunc

Func _movDOWN()
   $blkpy = StringSplit($BlkPos[0][2], "|")
   If ($blkpy[2] <= 180) Then
      For $x = 0 To 2
         For $y = 0 To 2
            $posxy = StringSplit($BlkPos[$x][$y], "|")
            GUICtrlSetPos($Blk[$x][$y], $posxy[1], $posxy[2] + 10, 10, 10)
            $BlkPos[$x][$y] = $posxy[1] & "|" & $posxy[2] + 10
         Next
      Next
   EndIf
EndFunc

Func _movLEFT()
   $blkpx = StringSplit($BlkPos[0][2], "|")
   If ($blkpx[1] >= 60) Then
      
      For $x = 0 To 2
         For $y = 0 To 2
            $posxy = StringSplit($BlkPos[$x][$y], "|")
            GUICtrlSetPos($Blk[$x][$y], $posxy[1] - 10, $posxy[2], 10, 10)
            $BlkPos[$x][$y] = $posxy[1] - 10 & "|" & $posxy[2]
         Next
      Next
   EndIf
EndFunc

Func _movRIGHT()
   $blkpx = StringSplit($BlkPos[0][2], "|")
   If ($blkpx[1] <= 120) Then
      For $x = 0 To 2
         For $y = 0 To 2
            $posxy = StringSplit($BlkPos[$x][$y], "|")
            GUICtrlSetPos($Blk[$x][$y], $posxy[1] + 10, $posxy[2], 10, 10)
            $BlkPos[$x][$y] = $posxy[1] + 10 & "|" & $posxy[2]
         Next
      Next
   EndIf
EndFunc

Func _movFALL()
   $ypos = StringSplit($BlkPos[0][2], "|")
   $bpos = 188 - $ypos[2]
   For $x = 0 To 2
      For $y = 0 To 2
         $posxy = StringSplit($BlkPos[$x][$y], "|")
         GUICtrlSetPos($Blk[$x][$y], $posxy[1], $posxy[2] + $bpos, 10, 10)
         $BlkPos[$x][$y] = $posxy[1] & "|" & $posxy[2] + $bpos
      Next
   Next
EndFunc