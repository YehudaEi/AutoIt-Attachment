;***********************************************
; Tools for hash lists
; Alpha .01 
;
; Author: Damon Hombs
;***********************************************


func _HashCreate()
	local $hash[1][2]
	$hash[0][0] = 0
	return $hash
EndFunc


func _HashUBound(byref $hash)
	return $hash[0][0]
EndFunc


func _HashAdd(byref $hash, $key, $val)
	local $u
	$hash[0][0] = $hash[0][0]+1
	$u = $hash[0][0]
		
	redim $hash[$u+1][2]
	$hash[$u][0] = $key
	$hash[$u][1] = $val
	
	return $hash
EndFunc


func _HashDelete(byref $hash, $key)
	local $loca
	local $i
	local $c
	local $u
	local $nf

	$key = stringupper($key)
	
	$u = $hash[0][0]-1
	
	if $u = -1 Then												;nothing to delete, hash empty
		;seterror(1)
		return 1
	EndIf
	
	
	if $u = 0 Then												;if this is the last value in hash to delete
		if $key = stringupper($hash[1][0]) Then
			dim $nhash[1][2]
			$hash[0][0] = 0
			return ""
		Else
			;seterror(2)											;hash key not found!
			return 2
		endif
	Else
		dim $nhash[$u][2]
		$nhash[0][0] = $u
	endIf
		
	
	$c = 1														;counter for new hash
	$f = 0														;not found flag
	
	for $i = 1 to $u
				
		if $key <> stringupper($hash[$i][0]) Then
			
			if $i = $u Then
				ExitLoop
			endif
			
			$nhash[$c][0] = $hash[$i][0]
			$nhash[$c][1] = $hash[$i][1]
			$c = $c + 1			
		Else
			$f = 1
		endif
	Next

	if $f = 1 Then												;hash found and deleted
		$hash = $nhash	
	Else
		;seterror(2)											;hash key not found
		return 2
	EndIf
EndFunc


func _HashKeyByIndex(byref $hash, $i)
	if $i > $hash[0][0] Then
		return ""
	Else
		return $hash[$i][0]
	EndIf
endfunc


func _HashValByIndex(byref $hash, $i)
	if $i > $hash[0][0] Then
		return ""
	Else
		return $hash[$i][1]
	EndIf
Endfunc


func _HashVal(byref $hash, $key)
	local $loca
	local $i
	local $val
	$val = ""
	$key = stringupper($key)
	for $i = 0 to ubound($hash,1)-1
		if $key = stringupper($hash[$i][0]) Then
			
			$val = $hash[$i][1]
			return $val
		endif
	Next
	;seterror(1)												;key not found
	return ""
EndFunc