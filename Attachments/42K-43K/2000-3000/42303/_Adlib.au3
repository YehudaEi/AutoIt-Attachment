#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#cs
    ;#=#INDEX#===================================================#
    ;#  Title .........: _Adlib.au3
    ;#  Description ...: Enhanced Adlib functionality, enables multiple adlib instances, function parameters, limited adlibs, and adlib pausing
    ;#  Date ..........: 6.11.08
    ;#  Version .......: 1.0
    ;#  Author ........: jennico (jennicoattminusonlinedotde)
    ;#  Main Functions : _AdlibEnable ( "function" [, time [, count [, param]]] )
    ;#           				_AdlibDisable ( $al_ID = 0 )
    ;#          			 	_AdlibPause ( $al_ID = 0 )
    ;#           				_AdlibResume ( $al_ID = 0 )
    ;#           				_AdlibMainFreq ( )
    ;#           				_AdlibFreq ( $al_ID )
    ;#           				_AdlibFunc ( $al_ID )
    ;#           				_AdlibID ( $func )
    ;#           				_AdlibParams ( $al_ID )
    ;#           				_AdlibActive ( $al_ID = 0 )
    ;#  Subfunctions ..: __AdlibAdd ( $al_ID [, $time] )
    ;#           				__AdlibMain ( )
    ;#           				__AdlibKill ( )
    ;#           				__Euclid ( $a, $b )
    ;#===========================================================#
#ce

#include-once

#Region;--------------------------Global declarations

__AdlibKill()
Global $al_timer = TimerInit()
Global $al_func[1], $al_time[1], $al_current[1], _
                $al_next[1], $al_param[1], $al_count[1]
#EndRegion;--------------------------Global declarations
#region;--------------------------Main Functions
#region;--------_AdlibEnable

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibEnable ( "function" [, time [, count [, param]]] )
    ;#  Description....: Enables Multi Adlib functionality and starts a new adlib instance.
    ;#  Parameters.....: function = The name of the adlib function to call.
    ;#           				time [optional] = frequency how often in milliseconds (> 0) to call the function. Default is 250 ms.
    ;#           				count [optional] = how many times (> 0) the function shall be call. Default is -1 (=continuous).
    ;#           				param [optional] = parameter or array of parameters passed to "function".
    ;#  Return Value ..: Returns Adlib-ID to be used in the other functions
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: When using _AdlibEnable, the built-in AdlibEnable and AdlibDisable MUST not be used at the same time.
    ;#           "function" has to be passed without parentheses.
    ;#           When using count, the adlib instance will be stopped after count times and the Adlib_ID will be invalid.
    ;#           To pass multiple parameters to function, pass a 1-based array. Element 0 is used internally and will be overwritten.
    ;#           For an example on multiple arrays, refer to Function "Call" in help file.
    ;#           A hint : If param is declared globally it can be updated dynamically.
    ;#           To skip one parameter, use "-1".
    ;#           Theoretical limit of Alib instances is 15,999,999.
    ;#       Every 250 ms (or time ms) the specified "function" is called.
    ;#           The adlib function should be kept simple as it is executed often and during this time the main script is paused.
    ;#           Also, the time parameter should be used carefully to avoid CPU load.
    ;#           If a previously registered function is passed, the adlib frequency will be updated and the
	;#					 corresponding already existing Adlib-ID will be returned.
    ;#           Thus it is not possible to call the same function twice.
    ;#           Important recommendation:
    ;#           If possible, please use round (multiples of each others) time frequencies to avoid CPU load .
	;#					 The main calling frequency of multiple adlibs is their greatest common divisor.
    ;#           E.g. for two adlib instances, better choose 100 and 50 (main=50) for time than 99 and 51 (main=3).
    ;#           If you choose two primes instead, the main frequency will be 1 ms and your CPU will be locked.
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibDisable, _AdlibPause, _AdlibResume
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibEnable($func, $time = 250, $count = -1, $param = "")
    If $time <= 0 Then $time = 250
    If $count = 0 Then $count = -1
    For $al_ID = 1 To $al_func[0]
        If $al_func[$al_ID] = $func Then ExitLoop
    Next
    If $al_ID > $al_func[0] Then
        ReDim $al_func[$al_ID + 1], $al_time[$al_ID + 1], $al_current[$al_ID + 1], _
                $al_next[$al_ID + 1], $al_param[$al_ID + 1], $al_count[$al_ID + 1]
        If IsArray($param) Then $param[0] = "CallArgArray"
        $al_func[0] = $al_ID
        $al_func[$al_ID] = $func
    EndIf
    $al_count[$al_ID] = $count
    $al_param[$al_ID] = $param
    $al_current[$al_ID] = $time
    __AdlibAdd($al_ID, $time)
    Return $al_ID
EndFunc   ;==>_AdlibEnable

#EndRegion;--------_AdlibEnable
#region;--------_AdlibDisable

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibDisable ( $al_ID = 0 )
    ;#  Description....: Stops specified adlib instance or disables entire adlib functionality.
    ;#  Parameters.....: $al_ID [optional] = The Adlib-ID returned by a previous _AdlibEnable call.
    ;#           				If omitted or 0, all instances will be stopped and adlib functionality disabled.
    ;#  Return Value ..: Success: Returns 1
    ;#           				Failure: Returns 0 if Adlib-ID is not valid (<0, not defined or stopped before).
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: NOT the same as AdlibDisable, do not use it when you use (Multi) _Adlib !
    ;#       						 Instead of the Adlib-ID, the function name can be passed as an argument,
		;#									 if the name is not valid, 0 will be the return value.
    ;#           					When passing the Adlib-ID, make sure that it is a number !
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibEnable, _AdlibPause, _AdlibResume
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibDisable($al_ID = 0);noch fehler in count !
    If IsInt($al_ID) = 0 Then
        $al_ID = _AdlibID($al_ID)
        If $al_ID = 0 Then Return 0
    EndIf
    If $al_ID > $al_func[0] Or $al_ID < 0 Then Return 0
    If $al_ID = 0 Then
        __AdlibKill()
        Return 1
    EndIf
    $al_next[$al_ID] = 0
    $al_count[$al_ID] = 0
    $al_current[$al_ID] = 0
    $al_param[$al_ID] = ""
    $al_func[$al_ID] = ""
    __AdlibAdd($al_ID, 0)
    Return 1
EndFunc   ;==>_AdlibDisable

#EndRegion;--------_AdlibDisable
#region;--------_AdlibPause

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibPause ( $al_ID = 0 )
    ;#  Description....: Pauses specified or all adlib instance(s).
    ;#  Parameters.....: $al_ID = The Adlib-ID returned by a previous _AdlibEnable call.
    ;#  Return Value ..: Success: Returns 1
    ;#           				 Failure: Returns 0 if Adlib-ID is not valid (<0, not defined or stopped before).
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: If $al_ID omitted or 0, all instances will be paused.
    ;#                   Main frequency will not be updated on _AdlibPause.
    ;#       						 Instead of the Adlib-ID, the function name can be passed as an argument.
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibEnable, _AdlibDisable, _AdlibResume, _AdlibActive
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibPause($al_ID)
    If IsInt($al_ID) = 0 Then $al_ID = _AdlibID($al_ID)
    If $al_ID > $al_func[0] Or $al_ID < 0 Then Return 0
    If $al_ID = 0 Then
        For $i = 1 To $al_func[0]
            $al_current[$i] = 0
        Next
        Return 1
    EndIf
    $al_current[$al_ID] = 0
    Return 1
EndFunc   ;==>_AdlibPause

#EndRegion;--------_AdlibPause
#region;--------_AdlibResume

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibResume ( $al_ID = 0 )
    ;#  Description....: Resumes specified or all (paused) adlib instance(s).
    ;#  Parameters.....: $al_ID = The Adlib-ID returned by a previous _AdlibEnable call.
    ;#  Return Value ..: Success: Returns 1
    ;#           Failure: Returns 0 if Adlib-ID is not valid (<0, not defined or stopped before).
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: If $al_ID omitted or 0, all instances will be resumed.
    ;#                   Instead of the Adlib-ID, the function name can be passed as an argument.
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibEnable, _AdlibDisable, _AdlibPause
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibResume($al_ID = 0)
    If IsInt($al_ID) = 0 Then $al_ID = _AdlibID($al_ID)
    If $al_ID > $al_func[0] Or $al_ID < 0 Then Return 0
    If $al_ID = 0 Then
        For $i = 1 To $al_func[0]
            $al_current[$i] = $al_time[$i]
            $al_next[$i] = TimerDiff($al_timer) + $al_time[$i] - _
                    Mod(TimerDiff($al_timer), $al_time[$i])
        Next
        Return 1
    EndIf
    $al_current[$al_ID] = $al_time[$al_ID]
    $al_next[$al_ID] = TimerDiff($al_timer) + $al_time[$al_ID] - _
            Mod(TimerDiff($al_timer), $al_time[$al_ID])
    Return 1
EndFunc   ;==>_AdlibResume

#EndRegion;--------_AdlibResume
#region;--------_AdlibMainFreq

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibMainFreq ( )
    ;#  Description....: Returns the current main (overall) adlib frequency.
    ;#  Parameters.....: none
    ;#  Return Value ..: Success: the current main (overall) adlib frequency in ms. Minimum is 1.
    ;#           Failure: Returns 0 if Multi adlib functionality is disabled.
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: Designed to observe and prevent CPU load. Highest possible load is on 1.
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibEnable, _AdlibDisable, _AdlibPause, _AdlibResume, _AdlibFreq, _AdlibFunc, _AdlibParams, _AdlibActive
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibMainFreq()
    If $al_func[0] = 0 Then Return 0
    Local $t
    For $i = 1 To $al_func[0]
        If $al_func[$i] Then
            $t = $al_time[$i]
            For $al_ID = $i + 1 To $al_func[0]
                If $al_current[$al_ID] Then $t = __Euclid($t, $al_time[$al_ID])
            Next
            Return $t
        EndIf
    Next
    __AdlibKill()
EndFunc   ;==>_AdlibMainFreq

#EndRegion;--------_AdlibMainFreq
#region;--------_AdlibFreq

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibFreq ( $al_ID )
    ;#  Description....: Returns the specified adlib frequency.
    ;#  Parameters.....: $al_ID = The Adlib-ID returned by a previous _AdlibEnable call.
    ;#  Return Value ..: Success: Returns the specified adlib frequency in ms.
    ;#           Failure: Returns 0 if Adlib-ID is not valid (0, not defined or stopped before).
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: Instead of the Adlib-ID, the function name can be passed as an argument.
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibEnable, _AdlibDisable, _AdlibPause, _AdlibResume, _AdlibMainFreq, _AdlibFunc, _AdlibID, _AdlibParams, _AdlibActive
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibFreq($al_ID)
    If IsInt($al_ID) = 0 Then $al_ID = _AdlibID($al_ID)
    If $al_ID > $al_func[0] Then Return 0
    Return $al_time[$al_ID]
EndFunc   ;==>_AdlibFreq

#EndRegion;--------_AdlibFreq
#region;--------_AdlibFunc

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibFunc ( $al_ID )
    ;#  Description....: Returns the specified adlib function name.
    ;#  Parameters.....: $al_ID = The Adlib-ID returned by a previous _AdlibEnable call.
    ;#  Return Value ..: Success: Returns the specified adlib function name.
    ;#           Failure: Returns "" (blank string) if Adlib-ID is not valid (not defined or stopped before).
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: If Sal_ID = 0 then the number of _Adlib instances (incl. stopped and paused) is returned.
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibEnable, _AdlibDisable, _AdlibPause, _AdlibResume, _AdlibMainFreq, _AdlibFreq, _AdlibID, _AdlibParams, _AdlibActive
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibFunc($al_ID)
    If $al_ID > $al_func[0] Then Return ""
    Return $al_func[$al_ID]
EndFunc   ;==>_AdlibFunc

#EndRegion;--------_AdlibFunc
#region;--------_AdlibID

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibID ( $func )
    ;#  Description....: Returns the Adlib-ID specified by passed function name.
    ;#  Parameters.....: $func = The function name registered in a previous _AdlibEnable call.
    ;#  Return Value ..: Success: Returns the Adlib-ID.
    ;#           Failure: Returns 0 if specified function is not registered in previous _AdlibEnable call.
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: none
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibEnable, _AdlibDisable, _AdlibPause, _AdlibResume, _AdlibMainFreq, _AdlibFreq, _AdlibFunc, _AdlibParams, _AdlibActive
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibID($func)
    For $al_ID = 1 To $al_func[0]
        If $al_func[$al_ID] = $func Then Return $al_ID
    Next
EndFunc   ;==>_AdlibID

#EndRegion;--------_AdlibID
#region;--------_AdlibParams

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibParams ( $al_ID )
    ;#  Description....: Returns an array of parameters and stats of the specified Adlib-ID.
    ;#  Parameters.....: $al_ID = The Adlib-ID returned by a previous _AdlibEnable call.
    ;#  Return Value ..: Success: Returns a 0 based 6 element array.
    ;#           				 Failure: Returns "" (blank string) if Adlib-ID is not valid (not defined or = 0).
    ;#  Author ........: jennico
    ;#  Date ..........: 5.11.08
    ;#  Remarks .......: The returned array contains:
    ;#           Array[0] = (More or less) proper function name incl. parenthesis and parameters (if given and not an array).
    ;#           Array[1] = current instance Status: 1 for active, 0 for stopped, 2 for paused.
    ;#           Array[2] = the corresponding function name ("" (blank) if instance is stopped).
    ;#           Array[3] = the corresponding frequency (0 if instance is stopped).
    ;#           Array[4] = (> 0) amount of times the corresponding function has been called.
    ;#                			(< 0) If count was specified, element contains the count left.
    ;#                			(= 0) Instance has been stopped.
    ;#           Array[5] = corresponding function parameters (can be an array itself) ("" (blank) if instance is stopped).
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibEnable, _AdlibDisable, _AdlibPause, _AdlibResume, _AdlibMainFreq, _AdlibFreq, _AdlibFunc, _AdlibID, _AdlibActive
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibParams($al_ID)
    If $al_ID > $al_func[0] Or $al_ID = 0 Then Return ""
    Local $ret[6]
    $ret[1] = 1
    If $al_func[$al_ID] = "" Then $ret[1] = 0
    If $al_current[$al_ID] = 0 Then $ret[1] = 2
    $ret[2] = $al_func[$al_ID]
    $ret[3] = $al_time[$al_ID]
    $ret[4] = $al_count[$al_ID] * - 1
    If $ret[4] < 0 Then $ret[3] += 1
    If $al_func[$al_ID] = "" Then $ret[4] = 0
    $ret[5] = $al_param[$al_ID]
    $ret[0] = $ret[2] & "(" & $ret[3] & "," & $ret[4] & "," & $ret[5] & ")"
    Return $ret
EndFunc   ;==>_AdlibParams

#EndRegion;--------_AdlibParams
#region;--------_AdlibActive

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: _AdlibActive ( $al_ID = 0 )
    ;#  Description....: Checks if _Adlib instance is active / paused. Or: Retrieves all active _Adlib instances.
    ;#  Parameters.....: $al_ID [optional] = The Adlib-ID returned by a previous _AdlibEnable call.
    ;#  Return Value ..: Success: Returns 1 if instance is active, 0 if stopped, and 2 if paused.
    ;#                 	 If parameter omitted or = 0 : Returns a 0 based array containing all active _Adlib instances.
    ;#           				 Failure: Returns -1 and sets @error to 1 if Adlib-ID is not valid.
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: If parameter omitted or = 0 :
    ;#                   Array[0] contains total numbers, elements 1 - Array[0] the active Adlib_IDs.
    ;#           @extended contains the number of paused _Adlib instances. Paused instances are active, too.
    ;#  Related........: AdlibEnable, AdlibDisable, Call, _AdlibEnable, _AdlibDisable, _AdlibPause, _AdlibResume, _AdlibMainFreq, _AdlibFreq, _AdlibFunc, _AdlibParams, _AdlibParams
    ;#  Example........: yes
    ;#===========================================================#
#ce

Func _AdlibActive($al_ID = 0)
    If $al_ID > $al_func[0] Then Return SetError(1, 0, -1)
    If $al_ID Then
        Local $ret = 0
        If $al_func[$al_ID] Then
            $ret = 1
            If $al_current[$al_ID] = 0 Then $ret = 2
        EndIf
        Return $ret
    EndIf
    Local $ret1 = "", $ret2 = 0
    For $al_ID = 1 To $al_func[0]
        If $al_func[$al_ID] Then
            $ret1 &= $al_ID & "*"
            If $al_current[$al_ID] = 0 Then $ret2 += 1
        EndIf
    Next
    Return SetExtended($ret2, StringSplit(StringTrimRight($ret1, 1), "*"))
EndFunc   ;==>_AdlibActive

#EndRegion;--------_AdlibActive
#EndRegion;--------------------------Main Functions
#Region;--------------------------Internal Functions

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: __AdlibAdd ( $al_ID [, $time] )
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: internal use only
    ;#  Example........: no
    ;#===========================================================#
#ce

Func __AdlibAdd($al_ID, $time)
    $al_time[$al_ID] = $time
    Local $t = _AdlibMainFreq()
    If $t = 0 Then Return
    If $time Then $al_next[$al_ID] = TimerDiff($al_timer) + $time
    AdlibRegister("__AdlibMain", $t)
EndFunc   ;==>__AdlibAdd

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: __AdlibMain ( )
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: internal use only
    ;#  Example........: no
    ;#===========================================================#
#ce

Func __AdlibMain()
    For $al_ID = 1 To $al_func[0]
        If $al_current[$al_ID] And TimerDiff($al_timer) >= $al_next[$al_ID] Then
            If $al_param[$al_ID] Then
                Call($al_func[$al_ID], $al_param[$al_ID])
            Else
                Call($al_func[$al_ID])
            EndIf
            $al_count[$al_ID] -= 1
            $al_next[$al_ID] += $al_time[$al_ID]
            If $al_count[$al_ID] = 0 Then _AdlibDisable($al_ID)
        EndIf
    Next
EndFunc   ;==>__AdlibMain

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: __AdlibKill ( )
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: internal use only
    ;#  Example........: no
    ;#===========================================================#
#ce

Func __AdlibKill()
    Global $al_func[1] = [0], $al_time[1] = [0], $al_current[1] = [0], _
            $al_next[1] = [0], $al_param[1] = [0], $al_count[1] = [0]
EndFunc   ;==>__AdlibKill

#cs
    ;#=#Function#================================================#
    ;#  Name ..........: __Euclid ( $a, $b )
    ;#  Description....: Calculates the Greatest Common Divisor
    ;#  Parameters.....: $a = 1st Integer
    ;#           				 $b = 2nd Integer
    ;#  Return Value ..: Returns GCD
    ;#  Author ........: jennico
    ;#  Date ..........: 4.11.08
    ;#  Remarks .......: internal use only
    ;#           				 taken from _Primes.au3
    ;#  Example........: no
    ;#===========================================================#
#ce

Func __Euclid($a, $b)
    If $b = 0 Then Return $a
    Return __Euclid($b, Mod($a, $b))
EndFunc   ;==>__Euclid

#EndRegion;--------------------------Internal Functions