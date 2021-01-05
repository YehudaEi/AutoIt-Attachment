;==============================================================================
;
; AutoIt Version: 3.0.103
; Language:       English
; Platform:       Win9x / NT
; Author:         MAGS
;
; Script Function:
;	Implementation of Timers for AutoIt.
;
; Usage:
;	1) Call _TimersInitialize() once.
;  2) Call _TimerSet(<timerName>, <timerInterval>, <TimerCallback>) for each timer to define.
;	3) Call _TimerStart(<timerName>) each time the timer must be started.
;	4) Call _TimerStop(<timerName>) each time the timer must be stopped.
;	Other:
;		Call _TimerRemove(<timerName>) to remove a timer.
;		Call _TimersPause() to pause all timers.
;		Call _TimersResume() to resume all timers.
;		Call _isTimerStarted(<timerName>) to query if a timer is started.
;==============================================================================

#include-once

AutoItSetOption("MustDeclareVars", 1)

#include <Array.au3>

;Constants (TODO: Use Const keyword when available)
Global $__TRUE = 1
Global $__FALSE = 0

Global $__CHECK_INTERVAL = 50;Msec.

;Variables
Global $__aTimers = 0;Will be an array with all the timer's data

;==============================================================================
#Region "Public functions"
;==============================================================================

;Initialize Timers.
;Must be called previously to start defining timers.
Func _TimersInitialize()
   
   ;Clear the timers list
   $__aTimers = 0
   
   ;Start the timer manager
   _TimersResume()
   
EndFunc   ;==>_TimersInitialize

;Pause the processing of all timers.
Func _TimersPause()
   AdlibDisable()
EndFunc   ;==>_TimersPause

;Resume the processing of all timers.
Func _TimersResume()
   AdlibEnable("___TimersManager", $__CHECK_INTERVAL)
EndFunc   ;==>_TimersResume

;Set a new timer, providing a meaningfull name, a time lapse (in msec.) and
;the name of the function that will be called at every tick.
Func _TimerSet($timerID, $lapse, $callbackName)
   
   If Not IsArray($__aTimers) Then
      Dim $__aTimers[1]
      $__aTimers[0] = ___TimerData_New($timerID, $lapse, $callbackName, $__FALSE, 0)
   Else
      _ArrayAdd ($__aTimers, ___TimerData_New($timerID, $lapse, $callbackName, $__FALSE, 0))
   EndIf
   
EndFunc   ;==>_TimerSet

;Start a previously defined timer.
Func _TimerStart($timerID)
   
   ;Find the timer
   Dim $i = ___TimerFindIndex($timerID)
   
   If $i >= 0 Then
      ;Start it
      Dim $timerData = $__aTimers[$i]
      ___TimerData_Set($timerData, "Started", $__TRUE)
      ___TimerData_Set($timerData, "LastTick", TimerInit())
      $__aTimers[$i] = $timerData
   Else
      ;ERROR
      ConsoleWrite("_TimerStart: Timer not found: " & $timerID & @LF)
      SetError(1)
   EndIf
   
EndFunc   ;==>_TimerStart

;Check if a timer is started
Func _isTimerStarted($timerID)
   
   ;Find the timer
   Dim $i = ___TimerFindIndex($timerID)
   
   If $i >= 0 Then
      ;Look if started
      Dim $timerData = $__aTimers[$i]
      Dim $running = ___TimerData_Get($timerData, "Started")
      Return $running
   Else
      ;ERROR
      ConsoleWrite("_isTimerStarted: Timer not found: " & $timerID & @LF)
      SetError(1)
      Return $__FALSE
   EndIf
   
EndFunc   ;==>_isTimerStarted

;Stops a timer
Func _TimerStop($timerID)
   
   ;Find the timer
   Dim $i = ___TimerFindIndex($timerID)
   
   If $i >= 0 Then
      ;Stop it
      Dim $timerData = $__aTimers[$i]
      ___TimerData_Set($timerData, "Started", $__FALSE)
      ___TimerData_Set($timerData, "LastTick", 0)
      $__aTimers[$i] = $timerData
   Else
      ;ERROR
      ConsoleWrite("_TimerStop: Timer not found: " & $timerID & @LF)
      SetError(1)
   EndIf
   
EndFunc   ;==>_TimerStop

;Remove (destroy) a timer
Func _TimerRemove($timerID)
   
   ;Find the timer
   Dim $i = ___TimerFindIndex($timerID)
   
   If $i >= 0 Then
      ;Delete it
      _ArrayDelete ($__aTimers, $i)
   Else
      ;ERROR
      ConsoleWrite("_TimerRemove: Timer not found: " & $timerID & @LF)
      SetError(1)
   EndIf
   
EndFunc   ;==>_TimerRemove
#endregion Interface

;==============================================================================
#region "Private functions"
;==============================================================================

;Manager for all the timers.
;This function will be invoked automatically at short intervals and will check all the timers
;for pending ticks, calling the associated callback when necessary.
Func ___TimersManager()
   
   Dim $i
   Dim $timerData
   
   For $i = 0 To UBound($__aTimers) - 1
      ;Get the timerData
      Dim $timerData = $__aTimers[$i]
      
      ;Look if started
      If ___TimerData_Get($timerData, "Started") = $__TRUE Then
         
         ;Look if a new tick is due now
         Dim $lastTick = ___TimerData_Get($timerData, "LastTick")
         Dim $lapse = ___TimerData_Get($timerData, "Lapse")
         
         If TimerDiff($lastTick) >= $lapse Then
            
            ;Initialize last tick to now
            ___TimerData_Set($timerData, "LastTick", TimerInit())
            $__aTimers[$i] = $timerData
            
            ;Perform a tick
            Call(___TimerData_Get($timerData, "CallbackName"))
         EndIf
      EndIf
   Next
   
EndFunc   ;==>___TimersManager

;Modifies a field in $timerData structure
Func ___TimerData_Set(ByRef $timerData, $field, $value)
   
   $field = StringLower($field)
   
   Dim $data = StringSplit($timerData, "|")
   
   Select
      Case $field = "timerid"
         $data[1] = $value
      Case $field = "lapse"
         $data[2] = $value
      Case $field = "callbackname"
         $data[3] = $value
      Case $field = "started"
         $data[4] = $value
      Case $field = "lasttick"
         $data[5] = $value
      Case Else
         ConsoleWrite("___TimerData_Set: Invalid field: " & $field & @LF)
   EndSelect
   
   $timerData = ___TimerData_New($data[1], $data[2], $data[3], $data[4], $data[5])
   
EndFunc   ;==>___TimerData_Set

;Returns a field from $timerData structure
Func ___TimerData_Get($timerData, $field)
   
   $field = StringLower($field)
   
   Dim $data = StringSplit($timerData, "|")
   
   Select
      Case $field = "timerid"
         Return $data[1]
      Case $field = "lapse"
         Return $data[2]
      Case $field = "callbackname"
         Return $data[3]
      Case $field = "started"
         Return $data[4]
      Case $field = "lasttick"
         Return $data[5]
      Case Else
         ConsoleWrite("___TimerData_Get: Invalid field: " & $field & @LF)
   EndSelect
   
EndFunc   ;==>___TimerData_Get

;Returns a new $timerData structure
Func ___TimerData_New($timerID, $lapse, $callbackName, $started, $lastTick)
   Return $timerID & "|" & $lapse & "|" & $callbackName & "|" & $started & "|" & $lastTick
EndFunc   ;==>___TimerData_New

;Finds the timerData with the given timerID
Func ___TimerFind($timerID)
   
   Dim $i
   Dim $timerData
   
   For $i = 0 To UBound($__aTimers) - 1
      Dim $timerData = $__aTimers[$i]
      If ___TimerData_Get($timerData, "TimerID") = $timerID Then
         Return $timerData
      EndIf
   Next
    
   ;Not found
   SetError(1)
   Return ""
   
EndFunc   ;==>___TimerFind

;Finds the index of the timerData with the given timerID
Func ___TimerFindIndex($timerID)
   
   Dim $i
   
   ;Not found
   For $i = 0 To UBound($__aTimers) - 1
      Dim $timerData = $__aTimers[$i]
      If ___TimerData_Get($timerData, "TimerID") = $timerID Then
         Return $i
      EndIf
   Next
   
   ;Not found
   SetError(1)
   Return -1
   
EndFunc   ;==>___TimerFindIndex

#endregion Implementation
