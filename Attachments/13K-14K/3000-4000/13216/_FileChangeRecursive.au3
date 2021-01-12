#include <File.au3>
#include <Array.au3>


Global $__glb_FileChangeRecursive_current_recurse_level = 0

;#============================================================================
;#== Author: Kurt (aka /dev/null)
;#==
;#== _FileChangeRecursive($sSearchPath, $sSearchPattern,$sWorkerFunction,$p1="__NO_PARAM__",$p2="__NO_PARAM__",$p3="__NO_PARAM__",$p4="__NO_PARAM__",$p5="__NO_PARAM__")
;#== 
;#==
;#== Search a file pattern recursive and calls a worker function for each file.
;#==
;#== Operation:
;#==
;#== The funnction walks recursivly, starting at the search path $sSearchPath, and
;#== searches the files that match the search pattern $sSearchPattern. If the 
;#== pattern is found, the worker function is called with the filepath as first 
;#== parameter and probably more parameters, depending if those are given to 
;#== this function ($p1, $p2, ..., $p5). If the 
;#==
;#==
;#== Parameters:
;#==
;#== 	$sSearchPath		the directory where to start the recursive search
;#==	$sSearchPattern		the file search pattern
;#==	$iMaxRecurseLevel	the maximum recursion level. 
;#==							0 = don't walk into sub dirs
;#==							1 = walk into 1 level of sub dirs
;#==	$sWorkerFunction	the name of the worker function. THIS FUNCTION MUST 
;#==						EXIST, OTHERWISE this function will throw an error
;#==	$p1,$p2,...,$p5		the optional parameters for the worker function
;#==
;#==
;#== Debugging:
;#==
;#==	If the the global variable $__glb_FileChangeRecursive_debug_file is set
;#==	the 
;#==
;#==
;#== Return Value(s):
;#==	On Success 		Returns the number of found files
;#==
;#==	On Failure 		-1 		if _FileListToArray() throws an error
;#==							
;#==							@error		@error of _FileListToArray
;#==
;#==					-2 		if the worker function does not exist or
;#==							the number of parameters for the worker is
;#==							wrong
;#==							
;#==							@error		1
;#==							
;#==					-3 		if the worker function returns a value OTHER
;#==							than 0 (the default), we will stop the operation
;#==							and pass the error state of the worker up
;#==							
;#==							@error 		@error of the worker function
;#==							@extended 	return code of the worker function
;#==
;#============================================================================

func _FileChangeRecursive($sSearchPath, $sSearchPattern,$iMaxRecurseLevel,$sWorkerFunction,$p1="__NP__",$p2="__NP__",$p3="__NP__",$p4="__NP__",$p5="__NP__")
	
	Local $nFilesFound = 0
	Local $debug_prefix = "_FileChangeRecursive: "
	
	
	;#=========================================================================
	;#== If the max recursion level < 0 (e.g. -1) then, we set an insane high
	;#== value for $iMaxRecurseLevel.
	;#=========================================================================
	If $iMaxRecurseLevel < 0 Then
		$iMaxRecurseLevel = 0xFFFFFFF
	EndIf
	
	;#=========================================================================
	;#== If the global debug variable is set and contains a string, the
	;#== file name of a debug file, then print debug messages. 
	;#== ATTENTION: Please no "comments" about the global debug variable
	;#== i designed it loke this, as don't want a debug function parameter!!!
	;#=========================================================================
	If IsDeclared("__glb_FileChangeRecursive_debug_file") then 
		Local $debug_file = Eval("__glb_FileChangeRecursive_debug_file")
		Local $debug_msg = $debug_prefix & " Function: " & $sWorkerFunction & _ 
		      " Search Pattern: " & $sSearchPattern & _
			  " Parameter: " & $p1 & "," & $p2 & "," & $p3 & "," & $p4 & "," & $p5 & _
			  " Search Path: " & $sSearchPath & @CRLF
		
		Local $retcode = _FileWriteLog($debug_file,$debug_msg)
		If $retcode = 0 Then MsgBox(0,"DEBUGGING FATAL ERROR","_FileWriteLog Error code: " & @error)
	EndIf

	;#=========================================================================
	;#== get all FILES in the given Path $sSearchPath. If there is an error with 
	;#== _FileListToArray, pass @error and @extended up and return -1 
	;#=========================================================================
	Local $files = _FileListToArray($sSearchPath,$sSearchPattern,1)
	if @error > 0 and @error < 4 then 
		SetError(@error,@extended)
		return -1
	EndIf
	
	;#=========================================================================
	;#== get all DIRECTORIES in the given Path $sSearchPath. If there is an error with 
	;#== _FileListToArray, pass @error and @extended up and return -1 
	;#=========================================================================
	Local $dirs = _FileListToArray($sSearchPath,"*",2)
	if @error > 0 and @error <4 then
		SetError(@error,@extended)
		return -1
	EndIf
	
	;#=========================================================================
	;#== If there were FILES found, process them, by calling the worker function
	;#== with the appropriate number of parameters.
	;#=========================================================================
	if IsArray($files) then
		for $n = 1 to $files[0]

			;#=================================================================
			;#== If global DEBUG variable is set
			;#=================================================================
			If IsDeclared("__glb_FileChangeRecursive_debug_file") then 
				Local $debug_file = Eval("__glb_FileChangeRecursive_debug_file")
				Local $debug_msg = $debug_prefix & " File: " & _
								   $sSearchPath & "\" & $files[$n] & @CRLF
		    
				Local $retcode = _FileWriteLog($debug_file,$debug_msg)
				If $retcode = 0 Then MsgBox(0,"DEBUGGING FATAL ERROR","_FileWriteLog Error code: " & @error)
			EndIf

			;#=================================================================
			;#== WARNING: Don't move these variable declarations. They are here
			;#== by purpose!! We need them to delete and recreate the parameter
			;#== call array
			;#=================================================================
			;Local $call_array = 0 					; delete the param call array
			Local $call_array[2] = ["CallArgArray",""] ; recreate it as array!
			Local $call_array_entries = 0		; number of array entries will
												; be reset in every loop iteration!!
			
			;#=================================================================
			;#== If there are NO parameters for the the worker function,
			;#== except the file path of course!
			;#=================================================================
			If $p1 = "__NP__" Then
				
				$retval = Call($sWorkerFunction,$sSearchPath & "\" & $files[$n])

				;#=============================================================				
				;#== If @error is set, then there is a problem with call()
				;#== Either the worker function name is wrong, or the number
				;#== of parameters is wrong. We cannot tell which one, as Call()
				;#== sets @error to 1 in both cases !!
				;#=============================================================
				If @error = 1 Then
					SetError(1,@extended)
					return -2
				EndIf
				
				;#=============================================================				
				;#== If the return value is different from 0 (the default For
				;#== any function in AutoIT !) then we assume the worker 
				;#== function returned some error code which we have to pass up!
				;#== If so, we preserver @error (from the worker funtion) and
				;#== set @extended to the return value of the worker function, 
				;#== then we return -3 to flag the worker function error
				;#=============================================================
				If $retval <> 0 Then
					SetError(@error,$retval)
					return -3
				EndIf
				
			;#=================================================================
			;#== If DO have parameters for the the worker function,
			;#== additional to the file path of course! Figure out how many
			;#== parameters are set, by checking the default value of $p1,..,$p5
			;#== Also build the parameter call array for call()
			;#=================================================================
			Else
				If $p1 <> "__NP__" then
						_ArrayAdd($call_array,$p1)
						$call_array_entries += 1
				EndIf
				If $p2 <> "__NP__" then
						_ArrayAdd($call_array,$p2)
						$call_array_entries += 1
				EndIf
				If $p3 <> "__NP__" then
						_ArrayAdd($call_array,$p3)
						$call_array_entries += 1
				EndIf
				If $p4 <> "__NP__" then
						_ArrayAdd($call_array,$p4)
						$call_array_entries += 1
				EndIf
				If $p5 <> "__NP__" then
						_ArrayAdd($call_array,$p5)
						$call_array_entries += 1
				EndIf
			
				;#=============================================================				
				;#== finalize the param call array with the file path and call
				;#== the worker function
				;#=============================================================
				$call_array[1] = $sSearchPath & "\" & $files[$n]
				$retval = Call($sWorkerFunction,$call_array)
				;_ArrayDisplay($call_array,"")
				;#=============================================================				
				;#== If @error is set, then there is a problem with call()
				;#== Either the worker function name is wrong, or the number
				;#== of parameters is wrong. We cannot tell which one, as Call()
				;#== sets @error to 1 in both cases !!
				;#=============================================================
				If @error = 1 Then
					SetError(1,@extended)
					return -2
				EndIf
				
				;#=============================================================				
				;#== If the return value is different from 0 (the default For
				;#== any function in AutoIT !) then we assume the worker function
				;#== returned some error code which we have to pass up!
				;#== If so, we preserver @error (from the worker funtion) and
				;#== set @extended to the return value of the worker function, 
				;#== then we return -3 to flag the worker function error
				;#=============================================================
				If $retval <> 0 Then
					SetError(@error,$retval)
					return -3
				EndIf
			EndIf
			
			$nFilesFound += 1
		next
	endif

	;#=========================================================================
	;#== Now recursively walk through all directories
	;#=========================================================================
	if IsArray($dirs) then
		for $n = 1 to $dirs[0]

			;#=================================================================
			;#== If global DEBUG variable is set
			;#=================================================================
			If IsDeclared("__glb_FileChangeRecursive_debug_file") then 
				Local $debug_file = Eval("__glb_FileChangeRecursive_debug_file")
				Local $debug_msg = $debug_prefix & " Dir:  " & _
								   $sSearchPath & "\" & $dirs[$n] & _ 
								   " Recurse: " & $__glb_FileChangeRecursive_current_recurse_level & @CRLF
		    
				Local $retcode = _FileWriteLog($debug_file,$debug_msg)
				If $retcode = 0 Then MsgBox(0,"DEBUGGING FATAL ERROR","_FileWriteLog Error code: " & @error)
			EndIf

			$__glb_FileChangeRecursive_current_recurse_level += 1
			if $__glb_FileChangeRecursive_current_recurse_level <= $iMaxRecurseLevel then
				$retval = _FileChangeRecursive($sSearchPath & "\" & $dirs[$n], $sSearchPattern,$iMaxRecurseLevel,$sWorkerFunction,$p1,$p2,$p3,$p4,$p5)
				$__glb_FileChangeRecursive_current_recurse_level -= 1
			
				;#=================================================================
				;#== If there was no error, just add the found number of files
				;#=================================================================
				if $retval >= 0 then 
					$nFilesFound += $retval
			
				;#=================================================================
				;#== If there was ANY error, pass it up, icluding @error and 
				;#== @extended
				;#=================================================================
				else
					SetError(@error,@extended)
					return $retval
				EndIf
			Else
				$__glb_FileChangeRecursive_current_recurse_level -= 1
			EndIf
		next
	endif
	
	;#=========================================================================
	;#== That's it. Return the number of files found.
	;#=========================================================================
	return $nFilesFound
endfunc