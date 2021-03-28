;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; change log:
; 2014.5.20: Rewrite some functions and remove local virable for this UDF used.
;--------------------------------------------------------------------------------------------------------------------------------------------------------

; ---------------------------------------------------------------------------------------------------------------
; Public Function list:
; Semaphore
; BoundedSemaphore
; SemaphoreAcquire
; SemaphoreRelease
; SemaphoreGetCount
; SemaphoreDestory
;---------------------------------------------------------------------------------------------------------------

#include-once

#include <WinAPI.au3>
#include <Debug.au3>
#include <WinAPIProc.au3>

Local $INT32_MAX_VALUE = 2147483647;, $MAX_VALUE

; create or open a exist, must use this function first. if using same name multiple times, then create multip reference.
; #FUNCTION# ====================================================================================================================
; Name ..........: Semaphore
; Description ...: Create or open a semaphore object
; Syntax ........: Semaphore($semaphoreName[, $iValue = 1])
; Parameters ....: $semaphoreName       - A string value of semaphore object's name 
;                  $iValue              - [optional] An integer value. Default is 1. It represents how many semaphores can be used.
; Return values .: Returns a semaphore object if successd
;                           Failurd:  returns 0 and sets @error to non-zero
;                           @error: ------ 1. $iValue parameter invalid.
;                                        ------ 2. Create or open semaphore failed.
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms682438%28v=vs.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func Semaphore($semaphoreName, $iValue = 1)
	If Not (IsInt($iValue) And $iValue >= 0) Then Return SetError(1, 0, 0)
	Local $hSem = _WinAPI_CreateSemaphore($semaphoreName, $iValue, $INT32_MAX_VALUE)
	If $hSem = 0 Then Return SetError(2, 0, 0) ;; Create or open semaphore failed.
	;$MAX_VALUE = $INT32_MAX_VALUE
	Return $hSem
EndFunc   ;==>Semaphore

; Similar Semaphore function, just has ssemaphore number limition.
; #FUNCTION# ====================================================================================================================
; Name ..........: BoundedSemaphore
; Description ...:  Create or open a semaphore object, but the semaphore has maximum limit. (Actally, the Semaphore function limit is 2147483647)
; Syntax ........: BoundedSemaphore($semaphoreName, $iValue)
; Parameters ....: $semaphoreName      - A string value of semaphore object's name 
;                  $iValue              - Max semaphores number can be used.
; Return values .: Returns a semaphore object if successd.
;                          Failure will return 0 and sets @error to non-zero
;                          @error -------- 1. $iValue parameter error, it must be Int type and large to 0
;                                      -------- 2. Create or open semaphore object failed.
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms682438%28v=vs.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func BoundedSemaphore($semaphoreName, $iValue = 1)
	If Not (IsInt($iValue) And $iValue >= 1) Then Return SetError(1, 0, 0)
	Local $hSem = _WinAPI_CreateSemaphore($semaphoreName, $iValue, $iValue)
	If $hSem = 0 Then Return SetError(2, 0, 0) ;;  Create or open semaphore failed.
	;$MAX_VALUE = $iValue
	Return $hSem
EndFunc   ;==>BoundedSemaphore

; Add semaphore 1
; #FUNCTION# ====================================================================================================================
; Name ..........: SemaphoreAcquire
; Description ...: Get a semaphore, so the current semaphore number will decrease 1.
; Syntax ........: SemaphoreAcquire($hSemaphore[, $TimeOut = -1])
; Parameters ....: $hSemaphore          - A semaphore handle value. It from Semaphore function or BoundedSemaphore function.
;                  $TimeOut             - [optional] An waiting time value. Default is -1, waiting forever. Time unit is millisecond.
; Return values .: When it got semaphore, returns True.
;                           Can't get semaphore, returns False. (Situation includs reach time out or semaphore number limit)
;                           @error ---------- 1. $TimeOut parameter invalid. It must be Int type.
;                                       ---------- 2.  Function error. Maybe the semaphore object is invalid?
;                                       ---------- 3. When try to get a semaphore, system found some process exit and not release semaphore object
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms687032%28v=vs.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func SemaphoreAcquire($hSemaphore, $TimeOut = -1) ;; parameter $hSemaphore returned by Semaphore or BoundedSemaphore function
	If $TimeOut = Default Then $TimeOut = -1;time out is millisecond.
	If Not IsInt($TimeOut) Then SetError(1, 0, False) ;; Parameter invalid.
	Local $iSignal = _WinAPI_WaitForSingleObject($hSemaphore, $TimeOut)
	Switch $iSignal
		Case -1 ; return -1 means function error
			Return SetError(2, -1, False) ;;; return -1 means function error ($hLock is not valid?)
		Case 0
			Return True
		Case 128
			Return SetError(3, 128, False) ;; the process that has gotten lock but exit and no release
		Case 258
			Return False ;; time out
	EndSwitch
EndFunc   ;==>SemaphoreAcquire

; Reduce semaphore 1
; #FUNCTION# ====================================================================================================================
; Name ..........: SemaphoreRelease
; Description ...: Release a semaphore, it will increase 1 for semaphore number. If current semaphore number reachs limit, the function will return fail and not increase 1 for semaphore number
; Syntax ........: SemaphoreRelease($hSemaphore)
; Parameters ....: $hSemaphore          - A semaphore handle value. It from Semaphore function or BoundedSemaphore function.
; Return values .: True if relase successful
;                           If release failure, returns False and sets @error to non-zero
;                           @error ---------- 1. release fail. Perhaps $hSemaphore is invalid or reach semaphore number limit
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms685071%28v=vs.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func SemaphoreRelease($hSemaphore)  ;; parameter $hSemaphore returned by Semaphore or BoundedSemaphore function
  _WinAPI_ReleaseSemaphore($hSemaphore)
  If @error Then Return SetError(1, 0, False)
	Return True
EndFunc   ;==>SemaphoreRelease

; #FUNCTION# ====================================================================================================================
; Name ..........: SemaphoreGetCount
; Description ...: ; Get current how many semaphore can be used. But when you get the result, maybe current actul number has been changed. Becuase get semaphore and release is quite fast.
; Syntax ........: SemaphoreGetCount($hSemaphore)
; Parameters ....: $hSemaphore          - A semaphore handle value. It from Semaphore function or BoundedSemaphore function.
; Return values .: Return semaphore count that can be used.
;                           If function failure, returns -1 and sets @error to non-zero
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms685071%28v=vs.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func SemaphoreGetCount($hSemaphore)  ;; parameter $hSemaphore returned by Semaphore or BoundedSemaphore function
	Local $fResult = SemaphoreAcquire($hSemaphore, 0)
	If @error Then Return SetError(1, 0, -1) ;; Function error. Invalid semaphore object?
	If $fResult = False Then Return 0
	Local $iCount = _WinAPI_ReleaseSemaphore($hSemaphore)
	_Assert(@error = 0)
  $iCount += 1
	Return $iCount
EndFunc   ;==>SemaphoreGetCount

; Close semaphore object.
; #FUNCTION# ====================================================================================================================
; Name ..........: SemaphoreDestory
; Description ...: Close semaphore object.
; Syntax ........: SemaphoreDestory($hSemaphore)
; Parameters ....: $hSemaphore           - A semaphore handle value. It from Semaphore function or BoundedSemaphore function.
; Return values .: True if close successful
;                           False when close failed and sets @error to non-zero
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms724211%28v=vs.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func SemaphoreDestory($hSemaphore)  ;; parameter $hSemaphore returned by Semaphore or BoundedSemaphore function
	If Not _WinAPI_CloseHandle($hSemaphore) Then Return SetError(1, 0, False) ;; Function error. Invalid semaphore object?
	Return True
EndFunc   ;==>SemaphoreDestory
