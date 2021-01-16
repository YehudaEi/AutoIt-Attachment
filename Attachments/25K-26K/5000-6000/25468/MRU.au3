#Region Header

#cs

	Title:			Most Recently Used (MRU) List Automation UDF Library for AutoIt3
	Filename:		MRU.au3
	Description:	A collection of functions for working with lists of MRU
					(see 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\OpenWithList' for example)
	Author:			Yashied
	Version:		1.3
	Requirements:	AutoIt v3.3 +, Developed/Tested on WindowsXP Pro Service Pack 2
	Uses:			Memory.au3
	Notes:			-

	Available functions:

	_MRU_Create
	_MRU_Release
	_MRU_GetSize
	_MRU_SetSize
	_MRU_GetItem
	_MRU_GetItemCount
	_MRU_AddItem
	_MRU_AddArray
	_MRU_DeleteItem
	_MRU_SearchItem
	_MRU_Reset
	_MRU_GetAsArray
	_MRU_GetAsString
	_MRU_RegAssign
	_MRU_RegRead
	_MRU_RegWrite
	
	Example1:

		#Include <MRU.au3>

		const $RegKey = 'HKLM\SOFTWARE\Test\MRU'

		local $i, $Mru, $Array

		$Mru = _MRU_Create()

		_MRU_AddItem($Mru, 'Item 4')
		_MRU_AddItem($Mru, 'Item 3')
		_MRU_AddItem($Mru, 'Item 2')
		_MRU_AddItem($Mru, 'Item 1')
		MsgBox(0, '', _MRU_GetAsString($Mru, '|'))
		_MRU_SetSize($Mru, 2)
		$Array = _MRU_GetAsArray($Mru)
		for $i = 1 to $Array[0]
			MsgBox(0, '', $Array[$i])
		next
		_MRU_RegWrite($Mru, $RegKey)
		
		_MRU_Release($Mru)

	Example2:

		#Include <GUIComboBox.au3>
		#Include <GUIConstantsEx.au3>
		#Include <WindowsConstants.au3>

		#Include <MRU.au3>

		const $RegKey = 'HKLM\SOFTWARE\Test\MRU'

		local $ButtonOk, $Combo, $Msg, $Mru

		$Mru = _MRU_Create($RegKey)

		GUICreate('Test', 400, 88)
		$Combo = GUICtrlCreateCombo('', 20, 20, 360, 21)
		GUICtrlSetData(-1, _MRU_GetAsString($Mru, '|'), _MRU_GetItem($Mru, 1))
		$ButtonOk = GUICtrlCreateButton('OK', 165, 58, 70, 21)
		GUISetState()

		GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')

		do
			$Msg = GUIGetMsg()
			if $Msg = $ButtonOk then
				_MRU_AddItem($Mru, GUICtrlRead($Combo))
				_MRU_RegWrite($Mru)
			endif
		until ($Msg = $ButtonOk) or ($Msg = $GUI_EVENT_CLOSE)

		_MRU_Release($Mru)

		func WM_COMMAND($hWnd, $msgID, $wParam, $lParam)

			switch $lParam
				case GUICtrlGetHandle($Combo)
					if BitShift($wParam, 0x10) = $CBN_EDITCHANGE then
						_GUICtrlComboBox_AutoComplete($Combo)
					endif
				case else

			endswitch

			return $GUI_RUNDEFMSG
		endfunc; WM_COMMAND

#ce

#Include-once

#Include <Memory.au3>

#EndRegion Header

#Region Local Variables and Constants

dim $idList[1][6] = [[0]]

#cs

DO NOT USE THIS ARRAY IN THE SCRIPT, INTERNAL USE ONLY!

$idList[0][0]   - Count item of array
	   [0][1-5] - Don`t used

$idList[i][0]   - The control identifier of the MRU list (1, 2, etc.)
	   [i][1]   - Size in words (each unicode character requires 2 bytes of memory) of allocated memory block.
	   [i][2]   - Handle to the allocated memory block (returned by _MemGlobalAlloc())
	   [i][3]   - Maximum length of the MRU (see _MRU_Create())
	   [i][4]   - The registry key where is located the MRU list (see _MRU_Create())
	   [i][5]   - Reserved

#ce

#EndRegion Local Variables and Constants

#Region Public Functions

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_Create
; Description:		Creates an empty MRU list.
; Syntax			_MRU_Create ( [$sRegKey [, $iSize]] )
; Parameter(s):		$sRegKey - [optional] The registry key where is located the MRU list. If MRU control created is successful,
;							   _MRU_RegRead() function will be called. If $sRegKey is empty, you need to specify the value when calling
;							   _MRU_RegRead() and _MRU_RegWrite() functions.
;
;					$iSize   - [optional] The size of the MRU list in the number of items. The maximum value - 26 (default).
; Return Value(s):	Success: Returns the identifier (controlID) of the new MRU list.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			MRU list must be created by _MRU_Create() before use this list and calling other functions. When the list
;					will no longer need to destroy it by _MRU_Release(). _MRU_Create() function created MRU lists in the heap and
;					do not need to destroy them before the end of the script.
;====================================================================================================================================

func _MRU_Create($sRegKey = '', $iSize = 26)
	
	local $i, $s, $b
	local $hMem, $pMem
	local $MruID
	
	if ($iSize < 0) or ($iSize > 26) then
		return SetError(1, 0, 0)
	endif
	$hMem = _MemGlobalAlloc(2)
	if $hMem = 0 then
		return SetError(1, 0, 0)
	endif
	$pMem = _MemGlobalLock($hMem)
	if $pMem = 0 then
		_MemGlobalFree($hMem)
		return SetError(1, 0, 0)
	endif
	$MruID = 1
	do
		$b = 1
		for $i = 1 to $idList[0][0]
			if $idList[$i][0] = $MruID then
				$MruId += 1
				$b = 0
				exitloop
			endif
		next
	until $b
	$idList[0][0] += 1
	redim $idList[$idList[0][0] + 1][6]
	$idList[$idList[0][0]][0] = $MruID
	$idList[$idList[0][0]][1] = 1
	$idList[$idList[0][0]][2] = $hMem
	$idList[$idList[0][0]][3] = $iSize
	$idList[$idList[0][0]][4] = StringStripWS($sRegKey, 3)
	$idList[$idList[0][0]][5] = 0
	$s = DllStructCreate('ushort[1]', $pMem)
	DllStructSetData($s, 1, 0, 1)
	_MemGlobalUnlock($hMem)
	_MRU_RegRead($MruID, $idList[$idList[0][0]][4])
	return SetError(0, 0, $MruID)
endfunc; _MRU_Create

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_Release
; Description:		Deletes an MRU control.
; Syntax			_MRU_Release ( $MruID )
; Parameter(s):		$MruID - The control identifier (controlID) as returned by _MRU_Create() function.
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MRU_Release($MruID)

	local $i, $j, $k

	$i = _Index($MruID)
	if $i = 0 then
		return SetError(1, 0, 0)
	endif
	if not _MemGlobalFree($idList[$i][2]) then
		return SetError(1, 0, 0)
	endif
	for $j = $i to $idList[0][0] - 1
		for $k = 0 to 5
			$idList[$j][$k] = $idList[$j + 1][$k]
		next
	next
	$idList[0][0] -= 1
	redim $idList[$idList[0][0] + 1][6]
	return SetError(0, 0, 1)
endfunc; _MRU_Release

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_GetSize
; Description:		Returns a size of the MRU list.
; Syntax			_MRU_GetSize ( $MruID )
; Parameter(s):		$MruID - The control identifier (controlID) as returned by _MRU_Create() function.
; Return Value(s):	Success: Returns the size of the MRU list in the number of items.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MRU_GetSize($MruID)
	
	local $i

	$i = _Index($MruID)
	if $i = 0 then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, $idList[$i][3])
endfunc; _MRU_GetSize

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_SetSize
; Description:		Sets a size of the MRU list.
; Syntax			_MRU_SetSize ( $MruID, $iSize )
; Parameter(s):		$MruID - The control identifier (controlID) as returned by _MRU_Create() function.
;					$iSize - The size of the MRU list in the number of items. The maximum value - 26.
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			If the number of items contained in the MRU list greater than the size, the list will be cut off from the
;					bottom up to the current size.
;====================================================================================================================================

func _MRU_SetSize($MruID, $iSize)
	
	local $i, $j, $n, $b, $c
	local $MruArray
	
	$i = _Index($MruID)
	if ($i = 0) or ($iSize < 0) or ($iSize > 26) then
		return SetError(1, 0, 0)
	endif
	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, 0)
	endif
	$n = StringLen($MruArray[0])
	if $iSize < $n then
		do
			$c = StringRight($MruArray[0], 1)
			for $j = Asc($c) - 96 to $n - 1
				$MruArray[$j] = $MruArray[$j + 1]
			next
			$MruArray[0] = StringTrimRight($MruArray[0], 1)
			$n -= 1
			for $j = 1 to $n
				$b = StringLeft(StringTrimLeft($MruArray[0], $j - 1), 1)
				if $b > $c then
					$MruArray[0] = StringReplace($MruArray[0], $j, Chr(Asc($b) - 1), 1)
				endif
			next
		until $n = $iSize
		_Array2Mem($MruID, $MruArray)
		if @error then
			return SetError(1, 0, 0)
		endif
	endif
	$idList[$i][3] = $iSize
	return SetError(0, 0, 1)
endfunc; _MRU_SetSize

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_GetItem
; Description:		Returns an item from the MRU list.
; Syntax			_MRU_GetItem ( $MruID, $iIndex )
; Parameter(s):		$MruID  - The control identifier (controlID) as returned by _MRU_Create() function.
;					$iIndex - Number of the item in the MRU list.
; Return Value(s):	Success: Returns a string containing the desired item from the MRU list.
;					Failure: Returns "" and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MRU_GetItem($MruID, $iIndex)
	
	local $MruArray

	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, '')
	endif
	if $iIndex > StringLen($MruArray[0]) then
		return SetError(1, 0, '')
	endif
	return SetError(0, 0, $MruArray[Asc(StringLeft(StringTrimLeft($MruArray[0], $iIndex - 1), 1)) - 96])
endfunc; _MRU_GetItem

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_GetItemCount
; Description:		Returns a number of items in the MRU list.
; Syntax			_MRU_GetItemCount ( $MruID )
; Parameter(s):		$MruID - The control identifier (controlID) as returned by _MRU_Create() function.
; Return Value(s):	Success: Returns the number of items in the MRU list.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MRU_GetItemCount($MruID)
	
	local $MruArray

	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, StringLen($MruArray[0]))
endfunc; _MRU_GetItemCount

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_AddItem
; Description:		Adds an item to the MRU list.
; Syntax			_MRU_AddItem ( $MruID, $sItem )
; Parameter(s):		$MruID - The control identifier (controlID) as returned by _MRU_Create() function.
;					$sItem - Item to be added as a string.
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			Add items is always placed in the first position list. If the number of items contained in the MRU list
;					will be greater than its size, the last element will be removed. If the item already exists in the MRU list,
;					it will be moved to first position.
;====================================================================================================================================

func _MRU_AddItem($MruID, $sItem)
	
	local $i, $j, $n, $next = true
	local $MruArray
	
	$i = _Index($MruID)
	if $i = 0 then
		return SetError(1, 0, 0)
	endif
	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, 0)
	endif
	$n = StringLen($MruArray[0])
	for $j = 1 to $n
		if $MruArray[$j] = $sItem then
			$MruArray[0] = Chr(96 + $j) & StringReplace($MruArray[0], Chr(96 + $j), '')
			$next = 0
			exitloop
		endif
	next
	if $next then
		if $n = $idList[$i][3] then
			$MruArray[Asc(StringRight($MruArray[0], 1)) - 96] = $sItem
			$MruArray[0] = StringRight($MruArray[0], 1) & StringTrimRight($MruArray[0], 1)
		else
			redim $MruArray[$n + 2]
			$MruArray[$n + 1] = $sItem
			$MruArray[0] = Chr(97 + $n) & $MruArray[0]
		endif
	endif
	_Array2Mem($MruID, $MruArray)
	if @error then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, 1)
endfunc; _MRU_AddItem

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_AddArray
; Description:		Adds an array containing the items to the MRU list.
; Syntax			_MRU_AddArray ( $MruID, $ArrayIn )
; Parameter(s):		$MruID   - The control identifier (controlID) as returned by _MRU_Create() function.
;					$ArrayIn - Add an array containing string. The first element has index 0 in the array.
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			Function works as _MRU_AddItem(), only for the array. Adding to the MRU list starts from the last element of the array.
;					If successful, the top element of the array will be the first in the MRU list etc.
;====================================================================================================================================

func _MRU_AddArray($MruID, ByRef $ArrayIn)
	
	local $i, $j, $k, $l, $p, $dub, $ArrayOut[1] = [0]
	local $MruArray
	
	$i = _Index($MruID)
	if $i = 0 then
		return SetError(1, 0, 0)
	endif
	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, 0)
	endif
	for $j = 1 to UBound($ArrayIn)
		if $ArrayOut[0] = $idList[$i][3] then
			exitloop
		endif
		$dub = 0
		for $l = 1 to $ArrayOut[0]
			if $ArrayOut[$l] = $ArrayIn[$j - 1] then
				$dub = 1
				exitloop
			endif
		next
		if not $dub then
			$ArrayOut[0] += 1
			redim $ArrayOut[$ArrayOut[0] + 1]
			$ArrayOut[$ArrayOut[0]] = $ArrayIn[$j - 1]
		endif
	next
	if $ArrayOut[0] < $idList[$i][3] then
		$n = StringLen($MruArray[0])
		$k = $ArrayOut[0]
		for $j = 1 to $n
			if $ArrayOut[0] = $idList[$i][3] then
				exitloop
			endif
			$p = $MruArray[Asc(StringLeft(StringTrimLeft($MruArray[0], $j - 1), 1)) - 96]
			$dub = 0
			for $l = 1 to $k
				if $ArrayOut[$l] = $p then
					$dub = 1
					exitloop
				endif
			next
			if not $dub then
				$ArrayOut[0] += 1
				redim $ArrayOut[$ArrayOut[0] + 1]
				$ArrayOut[$ArrayOut[0]] = $p
			endif
		next
	endif
	redim $MruArray[$ArrayOut[0] + 1]
	$MruArray[0] = ''
	for $j = 1 to $ArrayOut[0]
		$MruArray[$j] = $ArrayOut[$j]
		$MruArray[0] &= Chr(96 + $j)
	next
	_Array2Mem($MruID, $MruArray)
	if @error then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, 1)
endfunc; _MRU_AddArray

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_DeleteItem
; Description:		Deletes an item from the MRU list.
; Syntax			_MRU_DeleteItem ( $MruID, $iIndex )
; Parameter(s):		$MruID  - The control identifier (controlID) as returned by _MRU_Create() function.
;					$iIndex - Number of the item in the MRU list.
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MRU_DeleteItem($MruID, $iIndex)
	
	local $j, $n, $b, $c
	local $MruArray
	
	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, 0)
	endif
	$n = StringLen($MruArray[0])
	if $iIndex > $n then
		return SetError(1, 0, 0)
	endif
	$c = StringLeft(StringTrimLeft($MruArray[0], $iIndex - 1), 1)
	for $j = Asc($c) - 96 to $n - 1
		$MruArray[$j] = $MruArray[$j + 1]
	next
	$MruArray[0] = StringReplace($MruArray[0], $c, '')
	for $j = 1 to $n - 1
		$b = StringLeft(StringTrimLeft($MruArray[0], $j - 1), 1)
		if $b > $c then
			$MruArray[0] = StringReplace($MruArray[0], $j, Chr(Asc($b) - 1), 1)
		endif
	next
	_Array2Mem($MruID, $MruArray)
	if @error then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, 1)
endfunc; _MRU_DeleteItem

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_SearchItem
; Description:		Searches an item in the MRU list.
; Syntax			_MRU_SearchItem ( $MruID, $sItem [, $iFlag] )
; Parameter(s):		$MruID - The control identifier (controlID) as returned by _MRU_Create() function.
;					$sItem - Item to be found as a string.
;					$iFlag - [optional] Flag to indicate if the operations should be case sensitive.
;							 0 - not case sensitive, using the user's locale (default)
;							 1 - case sensitive
;							 2 - not case sensitive, using a basic/faster comparison
;
; Return Value(s):	Success: Returns the index of item in the MRU list. (0 - specified element is not found)
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MRU_SearchItem($MruID, $sItem, $iFlag = 0)
	
	local $j, $k, $n
	local $MruArray
	
	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, 0)
	endif
	$n = StringLen($MruArray[0])
	for $j = 1 to $n
		$k = Asc(StringLeft(StringTrimLeft($MruArray[0], $j - 1), 1)) - 96
		if (StringInStr($MruArray[$k], $sItem, $iFlag) = 1) and (StringLen($MruArray[$k]) = StringLen($sItem)) then
			return SetError(0, 0, $j)
		endif
	next
	return SetError(0, 0, 0)
endfunc; _MRU_SearchItem

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_Reset
; Description:		Removes all items from the MRU list.
; Syntax			_MRU_Clear ( $MruID )
; Parameter(s):		$MruID - The control identifier (controlID) as returned by _MRU_Create() function.
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MRU_Reset($MruID)
	
	local $MruArray
	
	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, 0)
	endif
	$MruArray[0] = ''
	_Array2Mem($MruID, $MruArray)
	if @error then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, 1)
endfunc; _MRU_Reset

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_GetAsArray
; Description:		Returns an array of items of the MRU list.
; Syntax			_MRU_GetAsArray ( $MruID )
; Parameter(s):		$MruID - The control identifier (controlID) as returned by _MRU_Create() function.
; Return Value(s):	Success: Returns an array of items of the MRU list. Element in the array with the index 1 is the first
;							 item in the MRU list etc. Value in the array of index 0 contains the number of items in the MRU list.
;							 If the MRU list is empty, the function returns an empty array ($ArrayOut[0] = 0).
;
;					Failure: Returns an empty array ($ArrayOut[0] = 0) and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			Array returned by this function is not suitable for the _MRU_AddArray() function (use _ArrayDelete($ArrayOut, 0)).
;====================================================================================================================================

func _MRU_GetAsArray($MruID)
	
	local $j, $ArrayOut[1] = [0]
	local $MruArray
	
	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, $ArrayOut)
	endif
	$ArrayOut[0] = StringLen($MruArray[0])
	redim $ArrayOut[$ArrayOut[0] + 1]
	for $j = 1 to $ArrayOut[0]
		$ArrayOut[$j] = $MruArray[Asc(StringLeft(StringTrimLeft($MruArray[0], $j - 1), 1)) - 96]
	next
	return SetError(0, 0, $ArrayOut)
endfunc; _MRU_GetAsArray

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_GetAsString
; Description:		Returns a string containing the items from the MRU list.
; Syntax			_MRU_GetAsString ( $MruID, $sSeparator )
; Parameter(s):		$MruID      - The control identifier (controlID) as returned by _MRU_Create() function.
;					$sSeparator - Separating characters.
; Return Value(s):	Success: Returns a string containing of a combination of the items from the MRU list and separating characters.
;							 ("Item1" & $sSeparator & "Item2" & $sSeparator & etc)
;
;					Failure: Returns "" and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			Function can be useful when working with a ComboBox control.
;====================================================================================================================================

func _MRU_GetAsString($MruID, $sSeparator)
	
	local $j, $n, $str = ''
	local $MruArray
	
	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, '')
	endif
	$n = StringLen($MruArray[0])
	for $j = 1 to $n
		$str &= $MruArray[Asc(StringLeft(StringTrimLeft($MruArray[0], $j - 1), 1)) - 96]
		if $j < $n then
			$str &= $sSeparator
		endif
	next
	return SetError(0, 0, $str)
endfunc; _MRU_GetAsString

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_RegAssign
; Description:		Assigns an MRU list with the specified registry key.
; Syntax			_MRU_RegRead ( $MruID [, $sRegKey] )
; Parameter(s):		$MruID   - The control identifier (controlID) as returned by _MRU_Create() function.
;					$sRegKey - The registry key to assign. (see _MRU_Create())
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			-
;====================================================================================================================================

func _MRU_RegAssign($MruID, $sRegKey)
	
	local $i

	$i = _Index($MruID)
	if $i = 0 then
		return SetError(1, 0, 0)
	endif
	$idList[$i][4] = StringStripWS($sRegKey, 3)
	return SetError(0, 0, 1)
endfunc; _MRU_RegAssign

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_RegRead
; Description:		Reads an MRU list from the registry.
; Syntax			_MRU_RegRead ( $MruID [, $sRegKey] )
; Parameter(s):		$MruID   - The control identifier (controlID) as returned by _MRU_Create() function.
;					$sRegKey - [optional] The registry key to read. If $sRegKey is empty (default), value will be taken from the
;							   _MRU_Create() or _MRU_RegAssign() function.
;
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			Function does not add items as _MRU_AddArray(). If the MRU list contains elements, they will be overwritten.
;====================================================================================================================================

func _MRU_RegRead($MruID, $sRegKey = '')

	local $i, $j, $k, $l, $n = 0, $c, $p, $t, $dub
	
	dim $MruArray[1] = ['']

	$i = _Index($MruID)
	if $i = 0 then
		return SetError(1, 0, 0)
	endif
	if StringStripWS($sRegKey, 3) = '' then
		$sRegKey = $idList[$i][4]
	endif
	$t = StringLower(RegRead($sRegKey, 'MRUList'))
	if not @error then
		$n = StringLen($t)
		if $n > 0 then
			$k = 1
			for $j = 1 to $n
				if $k > $idList[$i][3] then
					exitloop
				endif
				$c = StringLeft(StringTrimLeft($t, $j - 1), 1)
				if StringIsASCII($c) then
					$p = RegRead($sRegKey, $c)
					if not @error then
						$dub = 0
						for $l = 1 to $k - 1
							if $p = $MruArray[$l] then
								$dub = 1
								exitloop
							endif
						next
						if not $dub then
							redim $MruArray[$k + 1]
							$MruArray[$k] = $p
							$MruArray[0] &= Chr(96 + $k)
							$k += 1
						endif
					endif
				endif
			next
		endif
	endif
	_Array2Mem($MruID, $MruArray)
	if @error then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, 1)
endfunc; _MRU_RegRead

; #FUNCTION# ========================================================================================================================
; Function Name:	_MRU_RegWrite
; Description:		Writes an MRU list in the registry.
; Syntax			_MRU_RegWrite ( $MruID [, $sRegKey] )
; Parameter(s):		$MruID   - The control identifier (controlID) as returned by _MRU_Create() function.
;					$sRegKey - [optional] The registry key to write to. If $sRegKey is empty, value will be taken from the _MRU_Create() or
;							   _MRU_RegAssign() function. If no other parameters are specified this key will simply be created.
;
; Return Value(s):	Success: Returns 1.
;					Failure: Returns 0 and sets the @error flag to non-zero.
; Author(s):		Yashied
; Note(s):			Before the function to write MRU list in the registry, the registry key will be deleted!
;====================================================================================================================================

func _MRU_RegWrite($MruID, $sRegKey = '')
	
	local $i, $j, $n
	local $MruArray
	
	$i = _Index($MruID)
	if $i = 0 then
		return SetError(1, 0, 0)
	endif
	if StringStripWS($sRegKey, 3) = '' then
		$sRegKey = $idList[$i][4]
	endif
	$MruArray = _Mem2Array($MruID)
	if @error then
		return SetError(1, 0, 0)
	endif
	if RegDelete($sRegKey) = 2 then
		return SetError(1, 0, 0)
	endif
	$n = StringLen($MruArray[0])
	for $j = 1 to $n
		RegWrite($sRegKey, Chr(96 + $j), 'REG_SZ', $MruArray[$j])
	next
	RegWrite($sRegKey, 'MRUList', 'REG_SZ', $MruArray[0])
	return SetError(0, 0, 1)
endfunc; _MRU_RegWrite

#EndRegion Public Functions

#Region Internal Functions

func _Index($MruID)
	
	local $i
	
	for $i = 1 to $idList[0][0]
		if $idList[$i][0] = $MruID then
			return SetError(0, 0, $i)
		endif
	next
	return SetError(1, 0, 0)
endfunc; _Index

func _Array2Mem($MruID, ByRef $MruArray)
	
	local $i, $j, $k, $l, $n, $b, $s, $size
	local $pMem
	
	$i = _Index($MruID)
	if $i = 0 then
		return SetError(1, 0, 0)
	endif
	
	$n = StringLen($MruArray[0])
	$size = $n + 1
	for $j = 1 to $n
		$size += StringLen($MruArray[$j]) + 1
	next
	if not _MemGlobalFree($idList[$i][2]) then
		return SetError(1, 0, 0)
	endif
	$idList[$i][1] = 0
	$idList[$i][2] = _MemGlobalAlloc($size * 2)
	if $idList[$i][2] = 0 then
		return SetError(1, 0, 0)
	endif
	$pMem = _MemGlobalLock($idList[$i][2])
	if $pMem = 0 then
		_MemGlobalFree($idList[$i][2])
		$idList[$i][2] = 0
		return SetError(1, 0, 0)
	endif
	$s = DllStructCreate('ushort[' & $size & ']', $pMem)
	$b = 1
	for $j = 0 to $n
		$l = StringLen($MruArray[$j])
		for $k = 1 to $l
			DllStructSetData($s, 1, AscW(StringLeft(StringTrimLeft($MruArray[$j], $k - 1), 1)), $b)
			$b += 1
		next
		DllStructSetData($s, 1, 0, $b)
		$b += 1
	next
	_MemGlobalUnlock($idList[$i][2])
	$idList[$i][1] = $size
	return SetError(0, 0, 1)
endfunc; _Array2Mem

func _Mem2Array($MruID)
	
	local $i, $j, $b, $r, $s, $t
	local $pMem

	dim $MruArray[1] = ['']
	
	$i = _Index($MruID)
	if $i = 0 then
		return SetError(1, 0, 0)
	endif
	
	$pMem = _MemGlobalLock($idList[$i][2])
	if $pMem = 0 then
		return SetError(1, 0, 0)
	endif
	$s = DllStructCreate('ushort[' & $idList[$i][1] & ']', $pMem)
	$r = 0
	for $j = 1 to $idList[$i][1]
		$b = DllStructGetData($s, 1, $j)
		if $b = 0 then
			$r += 1
			if $j < $idList[$i][1] then
				redim $MruArray[$r + 1]
				$MruArray[$r] = ''
			endif
			continueloop
		endif
		$MruArray[$r] &= ChrW($b)
	next
	_MemGlobalUnlock($idList[$i][2])
	return SetError(0, 0, $MruArray)
endfunc; _Mem2Array

#EndRegion Internal Functions
