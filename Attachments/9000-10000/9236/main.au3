; ---------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1
; Author:         Björn Svartengren <svarten@svarten.com>
;
; Script Function:
;	EVE-Online Bot
;
; ---------------------------------------------------------------------------

#include <GUIConstants.au3>
#include <Color.au3>
#include "vars.au3"
#include "gui.au3"

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")

;; -------------------------------------
;; Start Idling 
;; -------------------------------------
$MyBot_Running = 0
MainLoop()

Func _TimeToString($timestamp)
  Local $_time, $_h, $_m, $_s, $_message
  $_time = Round($timestamp / 1000, 0)
  $_h = Int($_time / 3600)
  $_m = Int(($_time - $_h * 3600) / 60)
  $_s = $_time - $_h * 3600 - $_m * 60
  If ($_h > 0) Then
    $_message = StringFormat("%02d:%02d:%02d", $_h, $_m, $_s)
  ElseIf ($_m > 0) Then
    $_message = StringFormat("%02d:%02d", $_m, $_s)
  ElseIf ($_s > 0) Then
    $_message = StringFormat("%02d", $_s)
  Else
    $_message = ""
  EndIf
  Return $_message
EndFunc

Func PrintStatus($sMessage)
  If $sMessage <> $sLastStatus Then
    GUICtrlSetData($MyGUI_StatusLine, "Status: " & $sMessage)
    $sLastStatus = $sMessage
  EndIf
EndFunc

Func DoTimer()
    Local $iTotalTime = 0, $iAvrageTime = 0
    Local $sTotalTime = 0, $sAvrageTime = 0
    Local $_Message = "", $_Pattern = ""
    If ($BotTimer > 0) Then
      $iTotalTime  = TimerDiff($BotTimer)
      $sTotalTime  = _TimeToString($iTotalTime)
    EndIf
    If (GetStatus() = 11) Then
      $iAvrageTime = ($iTotalTime / $BotCycles)
      $sAvrageTime = _TimeToString($iAvrageTime)
    EndIf
      $_Pattern    = "Total Time: %s" & @CRLF & "Cycle: %d" & @CRLF & "Avrage Cycle Time: %s"
      $_Message    = StringFormat($_Pattern, $sTotalTime, $BotCycles, $sAvrageTime)      
    GUICtrlSetData($MyGUI_TimerLine, $_Message)
EndFunc

Func CheckGUI()
    If (@GUI_CTRLID = $GUI_EVENT_CLOSE) Then
      Terminate()
    EndIf
    Select
      Case @GUI_CTRLID = $MyGUI_LasersSlider
        If ($MyBot_Running = 0) Then
          GUICtrlSetData($MyGUI_LasersInput, GUICtrlRead($MyGUI_LasersSlider))
        Else
          GUICtrlSetData($MyGUI_LasersSlider, GUICtrlRead($MyGUI_LasersInput))
        EndIf
      Case @GUI_CTRLID = $MyGUI_LasersInput
        If ($MyBot_Running = 0) Then
          GUICtrlSetData($MyGUI_LasersSlider, GUICtrlRead($MyGUI_LasersInput))
        Else
          GUICtrlSetData($MyGUI_LasersInput, GUICtrlRead($MyGUI_LasersSlider))
        EndIf
      Case @GUI_CTRLID = $MyGUI_MouseInput
        If ($MyBot_Running = 0) Then
          $MouseSpeed = GUICtrlRead($MyGUI_MouseInput)
        Else
          GUICtrlSetData($MyGUI_MouseInput, $MouseSpeed)
        EndIf
      Case @GUI_CTRLID = $MyGUI_StartButton
        WinWait("EVE")
        WinActivate("EVE")
        WinWaitActive("EVE")
        WinMove("EVE", "", 0, 0)
        Sleep(1000) 
        $size = WinGetClientSize("EVE")
        $clientWidth = $size[0]
        $clientHeight = $size[1]
        $MyBot_Running = 1
        $BotTimer = TimerInit()
        SetStatus(1)
      Case @GUI_CTRLID = $MyGUI_StopButton
        $MyBot_Running = 0
        SetStatus(0)
        PrintStatus("Stopped...")
        DoTimer()
        Sleep(500)
      Case @GUI_CTRLID = $MyGUI_HomeButton
        SetStatus(WarpStation())
      Case @GUI_CTRLID = $MyGUI_BeltButton
        SetStatus(WarpBelt())
      Case Else
    EndSelect
EndFunc

Func TogglePause()
    $Paused = NOT $Paused
    $sTemp = $sLastStatus
    While $Paused
        Sleep(100)
        PrintStatus("Script is Paused.")
    WEnd
    PrintStatus($sTemp)
EndFunc

Func Terminate()
  Exit 0
EndFunc

;; -------------------------------------
;; Main Bot Loop
;; -------------------------------------
Func MainLoop()
  PrintStatus("Initilizing...")
  DoTimer()
  Sleep(1000)
  While 1
    If $MyBot_Running = 0 Then
      SetStatus(0)
    EndIf
    DoStatus()
  WEnd
EndFunc

Func DoStatus()
  If (GetStatus() > 0) Then
    DoTimer()
  EndIf
  Select
    Case GetStatus() =  0 ; = Idle
      PrintStatus("Idle.")
    Case GetStatus() =  1 ; = Undocking
      SetStatus(Undock())
    Case GetStatus() =  2 ; = Warping to Belt
      SetStatus(WarpBelt())
    Case GetStatus() =  3 ; = Select Target
      SetStatus(Target())
    Case GetStatus() =  4 ; = Approaching
      SetStatus(Approach())
    Case GetStatus() =  5 ; = Lock Target
      SetStatus(LockTarget())
    Case GetStatus() =  6 ; = Fiering Lasers
      SetStatus(FireLasers())
    Case GetStatus() =  7 ; = Mining
      SetStatus(Mining())
    Case GetStatus() =  8 ; = Warping to Station
      SetStatus(WarpStation())
    Case GetStatus() =  9 ; = Docking
      SetStatus(Dock())
    Case GetStatus() = 10 ; = Unloading
      SetStatus(Unload())
    Case GetStatus() = 11 ; = Cleaning Interface
      SetStatus(CleanUp())
    Case Else
      FixStatus()
  EndSelect
EndFunc

;; -------------------------------------
;; Undock()
;; -------------------------------------
Func Undock()
  PrintStatus("Undocking.")
  MouseClick("left", 19, $clientHeight-4, 1, $MouseSpeed)
  Do
   ; I am looking for the little triangle left of current system name.
   Sleep(100)
  Until PixelGetColor(56, 73) = Dec("E6E6E6") ; 15132390
  Return 2
EndFunc

;; -------------------------------------
;; WarpBelt()
;; -------------------------------------
Func WarpBelt()
  PrintStatus("Warping to Belt " & GUICtrlRead($MyGUI_BeltInput) & ".")
  OpenMainMenu()
  WarpToBelt(GUICtrlRead($MyGUI_BeltInput))
  Do
    Sleep(100)
  Until PixelGetColor($clientWidth/2, $clientHeight-6) > 7700000
  ; Replace this sleep with a WarpFinnish check...
  Sleep(60000)
  WaitFullStop()
  Return 3
EndFunc

;; -------------------------------------
;; Target()
;; -------------------------------------
Func Target()
  PrintStatus("Selecting Target.")
  MouseClick("left", $FirstOverview[0], $FirstOverview[1], 1, $MouseSpeed)
  Sleep(500)
  If (PixelGetColor($ApproachLoc[0], $ApproachLoc[1]) = 0) Then
    Return 3
  EndIf
  Return 4
EndFunc

;; -------------------------------------
;; Approach()
;; -------------------------------------
Func Approach()
   ; Click on the approach button in the overview window.
  If (PixelGetColor($DistandM[0], $DistandM[1]) = 0) Then
    PrintStatus("Approaching.")
    MouseClick("left", $ApproachLoc[0], $ApproachLoc[1], 1, $MouseSpeed)
  EndIf
  Do
    ; Wait for the end of the M in "Distance: X.XXX M" in the Overview Info
  Until PixelGetColor($DistandM[0], $DistandM[1]) > 0
   ; Set speed to 0.0 M/s
  MouseClick("left", $clientWidth/2-43, $clientHeight-24, 1, $MouseSpeed)
  WaitFullStop()
  Return 5
EndFunc

;; -------------------------------------
;; LockTarget()
;; -------------------------------------
Func LockTarget()
  PrintStatus("Locking Target.")
  ; Click on the first button in the Overvire Info Window.
  MouseClick("left", $TargetLoc[0], $TargetLoc[1], 1, $MouseSpeed)
  Do
    ; looking for the Red X in the Lock/Unlock button in Overvire Info Window.
    Sleep(100)
  Until (_ColorGetRed(PixelGetColor($TargetLoc[0], $TargetLoc[1])) > Dec("D0")) 
  Return 6
EndFunc

;; -------------------------------------
;; FireLasers()
;; -------------------------------------
Func FireLasers()
  PrintStatus("Fiering " & GUICtrlRead($MyGUI_LasersInput) & " Lasers")
  Send("{F1}")
  Sleep(100)
  if (GUICtrlRead($MyGUI_LasersInput) > 1) Then
    Send("{F2}")
    Sleep(100)
  EndIf
  if (GUICtrlRead($MyGUI_LasersInput) > 2) Then
    Send("{F3}")
    Sleep(100)
  EndIf
  if (GUICtrlRead($MyGUI_LasersInput) > 3) Then
    Send("{F4}")
    Sleep(100)
  EndIf
  if (GUICtrlRead($MyGUI_LasersInput) > 4) Then
    Send("{F5}")
    Sleep(100)
  EndIf
  if (GUICtrlRead($MyGUI_LasersInput) > 5) Then
    Send("{F6}")
    Sleep(100)
  EndIf
  if (GUICtrlRead($MyGUI_LasersInput) > 6) Then
    Send("{F7}")
    Sleep(100)
  EndIf
  if (GUICtrlRead($MyGUI_LasersInput) > 7) Then
    Send("{F8}")
    Sleep(100)
  EndIf
  Sleep(3000)
  Do
   ; Look at a spot where the 1st mining laser icon will be
   ; at the right of the locked target icon.
   Sleep(100)
  Until (PixelGetColor($FirstLaserIcon[0], $FirstLaserIcon[1]) > 0) 
  Return 7
EndFunc

;; -------------------------------------
;; Mining()
;; -------------------------------------
Func Mining()
  PrintStatus("Mining...")
  MouseMove($clientWidth/2, 100, $MouseSpeed)
  $done = 0
  Do
   If (GUICtrlRead($MyGUI_LasersInput) = 3) Then
     If (PixelGetColor($ThiredLaserIcon[0], $ThiredLaserIcon[1]) = Dec("000000")) Then
       $done = 1
     EndIf
   EndIf
   If (GUICtrlRead($MyGUI_LasersInput) = 2) Then
     If (PixelGetColor($SecondLaserIcon[0], $SecondLaserIcon[1]) = Dec("000000")) Then
       $done = 1
     EndIf
   EndIf
   If (GUICtrlRead($MyGUI_LasersInput) = 1) Then
     If (PixelGetColor($FirstLaserIcon[0], $FirstLaserIcon[1]) = Dec("000000")) Then
       $done = 1
     EndIf
   EndIf
   Sleep(100)
  Until ($done = 1)
  Return 8
EndFunc

;; -------------------------------------
;; WarpStation()
;; -------------------------------------
Func WarpStation()
  PrintStatus("Warping to Station " & GUICtrlRead($MyGUI_StationInput) & ".")
  Sleep(100)
  ; Not using insta waprs, so skipping this stage...
  Return 9
EndFunc

;; -------------------------------------
;; Dock()
;; -------------------------------------
Func Dock()
  PrintStatus("Docking.")
  OpenMainMenu()
  WarpToStation(GUICtrlRead($MyGUI_StationInput))
  Do
   ; looking for the yellowish arrows of the Undock button.
   Sleep(100)
  Until PixelGetColor(22, $clientHeight-2) > 16700000
  Return 10
EndFunc

;; -------------------------------------
;; Unload()
;; -------------------------------------
Func Unload()
  PrintStatus("Unloading.")
  Sleep(1000)
   ; Ok so it wont work if you merged Items/Ships with NeoCom Panel.
  MouseClick("left", 18, 712, 1, $MouseSpeed)

  ;; Open Ships Cargohold
  $posX = $clientWidth / 2
  $posY = $clientHeight / 2
   ; Right-Click on your ship
  MouseClick("right", $posX, $posY, 1, $MouseSpeed)
   ; Click on "open Cargohold"
  MouseClick("left", $posX+50, $posY+75, 1, $MouseSpeed)

  ;; Drag Cargo to Hangar
   ; Drag the first item in Cargohold to the first item in hangar.
  MouseClickDrag("left", $clientWidth-712, $clientHeight-35, $clientWidth-462, $clientHeight-35, 10)
  Return 11
EndFunc

;; -------------------------------------
;; CleanUp()
;; -------------------------------------
Func CleanUp()
  PrintStatus("Cleaning Interface.")
  ; Close the cargohold
  MouseClick("left", $clientWidth-520, $clientHeight-123, 1, $MouseSpeed)
  ; Close the hangar
  MouseClick("left", $clientWidth-268, $clientHeight-123, 1, $MouseSpeed)
  Sleep(500)
  $BotCycles = $BotCycles + 1
  Return 1
EndFunc

;; -------------------------------------
;; FixStatus()
;; -------------------------------------
Func FixStatus()
  PrintStatus("Error - Fixing.")
  ; Not Implemented Yet.
EndFunc

;; -------------------------------------
;; SetStatus()
;; -------------------------------------
Func SetStatus($status)
  $MyBotStatus = $status
EndFunc

;; -------------------------------------
;; GetStatus()
;; -------------------------------------
Func GetStatus()
  Return ($MyBotStatus)
EndFunc

;; -------------------------------------
;; Open Main Menu
;; -------------------------------------
Func OpenMainMenu()
    If (15132390 = PixelGetColor(56, 74)) Then
       ; This is the triangle left of current system name.
      MouseClick("left", 54, 72, 1, $MouseSpeed)
    EndIf
EndFunc

;; -------------------------------------
;; WarpToBelt
;; -------------------------------------
Func WarpToBelt($belt)
  ;; Select Astroid Belts
  MouseClick("left", $MainMenu1[1], $MainMenu1[1], 1, $MouseSpeed)
  ;; Move to the right
  MouseMove($Belt1[0], $Belt1[1]+15, $MouseSpeed)
  ;; Select Belt 1
  MouseClick("left", $Belt1[0], $Belt1[1]+(15*$belt), 1, $MouseSpeed)
  ;; Select Warp to, within 15km
  MouseClick("left", $Belt1Menu1[0], $Belt1Menu1[1]+(15*$belt), 1, $MouseSpeed)
EndFunc

;; -------------------------------------
;; WarpToStation
;; -------------------------------------
Func WarpToStation($station)
  ;; Select Stations
  MouseClick("left", $MainMenu4[0], $MainMenu4[1], 1, $MouseSpeed)
  ;; Select Station 1
  MouseClick("left", $Station1[0], $Station1[1]+15, 1, $MouseSpeed)
  ;; Select Station 1
  MouseClick("left", $Station1[0], $Station1[1]+(15*$station), 1, $MouseSpeed)
  ;; Move to the right...
  MouseMove($Station1Menu1[0], $Station1Menu1[1]+(15*$station), $MouseSpeed)
  ;; Select Dock
  MouseClick("left", $Station1Menu3[0], $Station1Menu3[1]+(15*$station), 1, $MouseSpeed)
EndFunc

Func WaitFullStop()
  Do
   ; Have velocity meter passed midpoint?
  Until PixelGetColor($clientWidth/2, $clientHeight-6) < 10000000
   ; Set speed to 0.0 M/s
  MouseClick("left", $clientWidth/2-43, $clientHeight-24, 1, $MouseSpeed)
EndFunc
