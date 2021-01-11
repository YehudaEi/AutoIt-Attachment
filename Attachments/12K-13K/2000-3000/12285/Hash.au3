#include-once

;--------------------------------------------------------------------------------
;AutoIt Version: 3x
;Language:       English
;Platform:       All
;Author:         mrider
;    
;Script Function:
;    Creates a simple hash function.  This hash is best suited for small data
;    sets - because the algorithm searches through the arrays looking for
;    a matching key, then returns the value found there.
;    
;    Naming conventions used in this code:
;    $_HashG_xxx = Global variable.
;    $_HashC_xxx = Constant.
;    _HashF_xxx  = Function
;    Avoid this name patern if you wish to avoid name collisions.
;    
;NOTES:
;    This code is VERY brute force.  This script can grab lots of memory
;    and can bring a computer to its knees in short order if there is a problem
;    such as uncontrolled recursion.  It will also cause problems with really
;    large datasets.
;
;THANKS:
;    Many thanks to ezzetabi - without whom the sorting function would CERTAINLY
;    have crashed with a stack overflow error.
;--------------------------------------------------------------------------------

;Constants
Const $_HashC_NoError = 0;
Const $_HashC_NotInitialized = 1;
Const $_HashC_InvalidPointer = 2;
Const $_HashC_KeyNotFound = 4;
Const $_HashC_UnknownError = 1024;
Const $_HashC_Ascending = 0;
Const $_HashC_Descending = 1;


;Global variables
Global $_HashG_initSize = 10;
Global $_HashG_resizeAdder = 5;
Global $_HashG_container = 0;
Global $_HashG_lastPointer = 0;


;--------------------------------------------------------------------------------
;Function Name:  _HashFKillAll()
;
;Description:    Destroys all hash entries and returns hash to unitialized state.
;
;Parameter(s):   none
;
;Returns:        nothing
;--------------------------------------------------------------------------------
Func _HashF_KillAll()
    $_HashG_Container = 0;
    $_HashG_lastPointer = 0;
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_NewInstance()
;
;Description:    Creates a pointer to a new hash.
;
;Parameter(s):   none
;
;Returns:        A pointer to the new hash, suitable for all functions which
;                require a pointer.
;--------------------------------------------------------------------------------
Func _HashF_NewInstance()
    ;NOTE: There're two overhead entries - the zero'th element of each hash.
    ;Element $_HashG_container[?][0][0] = pointer to last element in hash.
    ;Element $_HashG_container[?][0][1] = external hash pointer (see "$ptr")
    If ( $_HashG_container == 0 ) Then
        Dim $_HashG_container[1][$_HashG_initSize + 1][2]
    Else
        Local $numHashes = UBound( $_HashG_container, 1 );
        Local $numElements = UBound( $_HashG_container, 2 );
        ReDim $_HashG_container[$numHashes + 1][$numElements][2];
        $_HashG_lastPointer = $_HashG_lastPointer + 1;
    EndIf
    $_HashG_container[UBound($_HashG_container,1) - 1][0][0] = 0;
    $_HashG_container[UBound($_HashG_container,1) - 1][0][1] = $_HashG_lastPointer;
    
    Return $_HashG_lastPointer;
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Put($key, $val [,$ptr])
;
;Description:    Puts a value in the hash.  Creates a space for the value if
;                the key does not already exist, overwrites the value if it does.
;                
;                $ptr is not necessary in cases where only one hash set exists.
;
;Parameter(s):   $key - the key to the value
;                $value - the value associated with the key
;                [$ptr] - pointer to a hash (optional).
;
;Returns:        Nothing
;--------------------------------------------------------------------------------
Func _HashF_Put( $key, $val, $ptr = 0 )
    Local $err = _HashF_ValidatePtr( $ptr );
    If ( $err <> 0 ) Then
        SetError( $err );
        Return;
    EndIf
    
    ;Get the index to our pointer
    Local $index = _HashF_FindIndex( $ptr );
    
    ;Try easy thing first - see if there are no elements in hash
    If ( $_HashG_container[$index][0][0] == 0 ) Then
        $_HashG_container[$index][1][0] = $key;
        $_HashG_container[$index][1][1] = $val;
        $_HashG_container[$index][0][0] = 1;
        Return;
    EndIf
    
    ;Check to see if key already exists
    Local $keyIndex = _HashF_FindKey( $index, $key );
    If ( $keyIndex <> -1 ) Then
        $_HashG_container[$index][$keyIndex][1] = $val;
        Return;
    EndIf
    
    ;If we're here, we're adding a new key
    
    ;Check to see if hash is full
    If ( $_HashG_container[$index][0][0] == UBound( $_HashG_container, 2) - 1 ) Then
        _HashF_Grow();
    EndIf
    
    ;Add key and value to hash - "$lastVal" is the pointer to the last value
    Local $lastValPtr = $_HashG_container[$index][0][0] + 1;
    $_HashG_container[$index][$lastValPtr][0] = $key;
    $_HashG_container[$index][$lastValPtr][1] = $val;
    $_HashG_container[$index][0][0] = $lastValPtr;
    Return;
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Get( $key [,$ptr] )
;
;Description:    Looks in the hash pointed to by $ptr, and finds the value
;                associated with the key provided.  Returns the value "0" and
;                sets @ERROR value to bitwise map if a problem is encountered.
;                See the constants above.
;                
;                $ptr is not necessary in cases where only one hash set exists.
;
;Parameter(s):   $key - key to the a value
;                [$ptr] - pointer to a hash (optional).
;
;Returns:        The value associated with the key (if any)
;--------------------------------------------------------------------------------
Func _HashF_Get( $key, $ptr = 0 )
    Local $err = _HashF_ValidatePtr( $ptr );
    If ( $err <> 0 ) Then
        SetError( $err );
        Return( 0 );
    EndIf
    
    Local $index = _HashF_FindIndex( $ptr );
    Local $keyIndex = _HashF_FindKey( $index, $key );
    If ( $keyIndex == -1 ) Then
        SetError( $_HashC_KeyNotFound );
        Return( 0 );
    Else
        SetError( $_HashC_NoError );
        Return( $_HashG_container[$index][$keyIndex][1] );
    EndIf
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_RemoveHash( $ptr )
;
;Description:    Removes an entire hash
;                
;Parameter(s):   $ptr the pointer to the hash to remove
;
;Returns:        nothing - (note: fails silently if $ptr is invalid)
;--------------------------------------------------------------------------------
Func _HashF_RemoveHash( $ptr )
    Local $index = _HashF_FindIndex( $ptr );
    If ( $index == -1 ) Then
        Return;
    Else
        If ( ( UBound( $_HashG_container, 1 ) - 1 ) == 0 ) Then
            _HashF_KillAll();
            _HashF_NewInstance();
        Else
            If ( $index < Ubound( $_HashG_container, 2 ) ) Then
                Local $lastIndex = Ubound( $_HashG_container, 1 ) - 1;
                For $i = 0 to Ubound( $_HashG_container, 2 ) - 1
                    $_HashG_container[$index][$i][0] = $_HashG_container[$lastIndex][$i][0];
                    $_HashG_container[$index][$i][1] = $_HashG_container[$lastIndex][$i][1];
                Next
            EndIf
            ReDim $_HashG_container[UBound( $_HashG_container, 1 ) - 1][Ubound($_HashG_container, 2 ) - 1][2];
        EndIf
    EndIf
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_RemovePair( $key [,$ptr] )
;
;Description:    Removes a key value pair from the indicated hash
;                
;Parameter(s):   $key - key to the a value
;                [$ptr] - pointer to a hash (optional).
;                
;Returns:        nothing - (Note: fails silently if $key or $ptr is invalid)
;--------------------------------------------------------------------------------
Func _HashF_RemovePair( $key, $ptr = 0 )
    Local $index = _HashF_FindIndex( $ptr );
    If ( $index == -1 ) Then
        Return;
    EndIf
    
    Local $keyIndex = _HashF_FindKey( $index, $key );
    Local $lastIndex = Ubound( $_HashG_container, 2 ) - 1;
    If ( $_HashG_container[$index][$keyIndex][0] == 0 ) Then
        Return;
    EndIf
    
    If ( $keyIndex == $lastIndex ) Then
        $_HashG_container[$index][$keyIndex][0] = 0;
        $_HashG_container[$index][$keyIndex][1] = 0;
    Else
        For $i = $keyIndex to ( $lastIndex - 1 )
            $_HashG_container[$index][$i][0] = $_HashG_container[$index][$i + 1][0];
            $_HashG_container[$index][$i][1] = $_HashG_container[$index][$i + 1][1];
        Next
    EndIf
    $_HashG_container[$index][0][0] = $_HashG_container[$index][0][0] - 1;
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Grow( [$adder] )
;
;Description:    Increases the size of the hash by the amount in $adder.
;                The default resize value is used if $adder is not supplied, or
;                if the value supplied is invalid.
;                
;                This method is called automatically when an element is added
;                to a hash which is full.  If needed, it can also be called by
;                hand just before adding a large number of elements.
;
;Parameter(s):   [$adder] - the number of empty slots to add to the hash
;
;Returns:        The number of slots in the new hash
;
;See Also:       _HashF_DefaultResizeAmt
;--------------------------------------------------------------------------------
Func _HashF_Grow( $adder = 0 )
    ;Make sure adder is a number - and is greater than zero
    $adder = $adder + 0;
    If ( $adder < 1 ) Then $adder = $_HashG_resizeAdder;
    
    ;Figure out old hash
    Local $oldSize = UBound( $_HashG_container, 2 );
    Local $numHashes = UBound( $_HashG_container, 1 );
    Local $newSize = $oldSize + $adder;
    
    ;Resize
    ReDim $_HashG_container[$numHashes][$newSize + 1][2];
    
    Return( $newSize )
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Shrink
;
;Description:    Decreases the size of the hash container.  Useful for times 
;                where one wants to reduce memory usage after removing a large
;                number of elements.
;                
;                There are two possibilities for the amount to shrink: 
;                0) Shrink to the next larger even size after the amount
;                    of elements in the largest hash - DEFAULT
;                
;                1) Shrink to (num elements)
;
;Parameter(s):   [$shrinkType] - choice 0 or 1 
;
;Returns:        nothing
;
;See Also:       _HashF_DefaultResizeAmt
;--------------------------------------------------------------------------------
Func _HashF_Shrink( $shrinkType = 0 )
    ;Get shrink type
    If ( ( $shrinkType <> 0 ) AND ( $shrinkType <> 1 ) ) Then 
        $shrinkType = 0;
    EndIf
    
    ;Get new size
    Local $newSize = 0;
    Local $largest = 0;
    For $i = 0 To UBound( $_HashG_container, 1 ) - 1
        If ( $_HashG_container[$i][0][0] > $largest ) Then
            $largest = $_HashG_container[$i][0][0];
        EndIf
    Next
    
    ;Add empty spaces at end if needed
    If ( $shrinkType == 0 ) Then
        $newSize = ( int( $largest / $_HashG_initSize ) * $_HashG_initSize ) + $_HashG_initSize + 1;
    Else
        $newSize = $largest + 1;
    EndIf
    
    ;Shrink the container
    Local $numHashes = UBound( $_HashG_container, 1 );
    ReDim $_HashG_container[$numHashes][$newSize][2];
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_DefaultResizeAmt
;
;Description:    Changes the default amount (5) of additional slots added to the
;                hash whenever it is necessary to grow the hash.  Normally this
;                isn't needed, but it can add a bit of a performance boost if
;                items are added in known size groups.  For example, if items
;                are found in groups of ten, then setting the resize amount to
;                ten will guarantee that enough slots to hold a group is added
;                at each automatic resize.
;                
;                Note that a large number will reduce the number of times that
;                the hash is resized, but will increase memory usage - and
;                vice versa.
;
;Parameter(s):   $amt - the amount to adjust (must be greater than zero)
;
;Returns:        Nothing
;--------------------------------------------------------------------------------
Func _HashF_DefaultResizeAmt ( $amt )
    $amt = $amt + 0;
    If ( $amt > 0 ) Then 
        $_HashG_resizeAdder = $amt;
    EndIf
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_KeyPairCount
;
;Description:    Simple method to get the number of elements in the hash.  Will
;                return -1 and sets @ERROR to bitwise map of problem if an
;                invalid pointer is supplied.
;
;                NOTE: This method returns -1 rather than 0 in the event of a
;                problem because 0 is a perfectly legitimate answer.
;
;Parameter(s):   [$ptr] - Pointer to a hash (optional)
;
;Returns:        The number of key->value pairs currently in the hash.
;--------------------------------------------------------------------------------
Func _HashF_KeyPairCount ( $ptr = 0 )
    Local $err = _HashF_ValidatePtr( $ptr );
    If ( $err <> 0 ) Then
        SetError( $err );
        Return( -1 );
    EndIf
    
    Local $index = _HashF_FindIndex( $ptr );
    Return( $_HashG_container[$index][0][0] );
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Keys
;
;Description:    Simple method to get a list of keys in the hash - $array[0]
;                contains the number of elements in the array.  Will return
;                a one dimensional array with the value "0" in the zero'th
;                element if the hash is empty.  Will return a one dimensional
;                array with the value -1 in the zero'th element if the pointer
;                is invalid.
;                
;                Example:
;                $array[0] = 7  : 7 keys in hash $array[1] -> $array[7] = keys
;                $array[0] = 0  : no keys in hash
;                $array[0] = -1 : pointer passed was invalid
;
;Parameter(s):   [$ptr] - Pointer to a hash (optional)
;
;Returns:        A one dimensional array of the keys.
;--------------------------------------------------------------------------------
Func _HashF_Keys( $ptr = 0 )
    Return _HashF_Stuff( $ptr, 0 );
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Values
;
;Description:    Simple method to get a list of values in the hash - $array[0]
;                contains the number of elements in the array.  Will return
;                a one dimensional array with the value "0" in the zero'th
;                element if the hash is empty.  Will return a one dimensional
;                array with the value -1 in the zero'th element if the pointer
;                is invalid.
;                
;                Example:
;                $array[0] = 7  : 7 vals in hash $array[1] -> $array[7] = vals
;                $array[0] = 0  : no vals in hash
;                $array[0] = -1 : pointer passed was invalid
;
;Parameter(s):   [$ptr] - Pointer to a hash (optional)

;Returns:        A one dimensional array of the values.
;--------------------------------------------------------------------------------
Func _HashF_Values( $ptr = 0 )
    Return _HashF_Stuff( $ptr, 1 );
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Entries
;
;Description:    Returns the key->value pairs in the hash pointed to by $ptr.
;                Follows same basic rules as _HashF_Keys and _HashF_Values as 
;                regards the overhead entries in the hashes, except that both
;                zero'th elements contain the overhead information.
;                
;                Example use:
;                <code>
;                _HashF_Put( "a", "A" );
;                _HashF_put( "b", "B" );
;                $array = _HashF_Entries();
;                
;                This produces the following result:
;                $array[0][0] contains 2
;                $array[0][1] contains 2
;                $array[1][0] contains "a"
;                $array[1][1] contains "A"
;                $array[2][0] contains "b"
;                $array[2][1] contains "B"
;                
;
;Parameter(s):   [$ptr] - Pointer to a hash (optional)
;
;Returns:        A two dimensional array with the keys and values.
;--------------------------------------------------------------------------------
Func _HashF_Entries( $ptr = 0 )
    Local $keys = _HashF_Stuff( $ptr, 0 );
    Local $vals = _HashF_Stuff( $ptr, 1 );
    Local $retVal[1][2];
    
    If ( ( UBound( $keys ) <> UBound( $vals ) ) Or ( $keys[0] <> $vals[0] ) ) Then
        ;Something is FUBAR
        MsgBox( 8208, "Hash Entries Error", "Fatal error encountered in hash" );
        $retVal[0][0] = -1;
        $retVal[0][1] = -1;
        SetError( $_HashC_UnknownError );
        Return( $retVal );
    EndIf
    
    ReDim $retVal[UBound( $keys )][2];
    For $i = 0 To $keys[0]
        $retVal[$i][0] = $keys[$i];
        $retVal[$i][1] = $vals[$i];
    Next
    Return( $retVal );
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_ValidatePtr
;
;Description:    A simple method to ensure a hash pointer is valid.
;
;Parameter(s):   $ptr - the pointer to test
;
;Returns:        0 if pointer is valid - or a bit map of problems encountered.
;--------------------------------------------------------------------------------
Func _HashF_ValidatePtr( $ptr )
    If ( $_HashG_container == 0 ) Then
        Return( $_HashC_NotInitialized );
    EndIf
    
    Local $tester = $ptr + 0;
    If ( ( $tester <> $ptr ) Or ( $ptr < 0 ) ) Then 
        Return( $_HashC_InvalidPointer )
    EndIf
    
    Local $index = _HashF_FindIndex( $ptr );
    If( $index == -1 ) Then
        Return( $_HashC_InvalidPointer )
    Else
        Return (0);
    EndIf
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_SortKeysAsc
;
;Description:    Sorts the hash - in place - by key in ascending order.
;
;Parameter(s):   [$ptr] - Pointer to a hash (optional)
;
;Returns:        Nothing.
;--------------------------------------------------------------------------------
Func _HashF_SortKeysAsc( $ptr = 0 )
    Local $err = _HashF_ValidatePtr( $ptr );
    If( $err <> 0 ) Then
        SetError( $err );
        Return;
    EndIf
    Local $index = _HashF_FindIndex( $ptr );
    
    ; "0" means sort by key
    _HashF_Sort( $index, $_HashC_Ascending, 0 );
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_SortKeysDesc
;
;Description:    Sorts the hash - in place - by key in descending order.
;
;Parameter(s):   [$ptr] - Pointer to a hash (optional)
;
;Returns:        Nothing.
;--------------------------------------------------------------------------------
Func _HashF_SortKeysDesc( $ptr = 0 )
    Local $err = _HashF_ValidatePtr( $ptr );
    If( $err <> 0 ) Then
        SetError( $err );
        Return;
    EndIf
    Local $index = _HashF_FindIndex( $ptr );
    
    ; "0" means sort by key
    _HashF_Sort( $index, $_HashC_Descending, 0 );
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_SortValsAsc
;
;Description:    Sorts the hash - in place - by value in ascending order.
;
;Parameter(s):   [$ptr] - Pointer to a hash (optional)
;
;Returns:        Nothing.
;--------------------------------------------------------------------------------
Func _HashF_SortValsAsc( $ptr = 0 )
    Local $err = _HashF_ValidatePtr( $ptr );
    If( $err <> 0 ) Then
        SetError( $err );
        Return;
    EndIf
    Local $index = _HashF_FindIndex( $ptr );
    
    ; "1" means sort by value
    _HashF_Sort( $index, $_HashC_Ascending, 1 );
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_SortValsDesc
;
;Description:    Sorts the hash - in place - by value in descending order.
;
;Parameter(s):   [$ptr] - Pointer to a hash (optional)
;
;Returns:        Nothing.
;--------------------------------------------------------------------------------
Func _HashF_SortValsDesc( $ptr = 0 )
    Local $err = _HashF_ValidatePtr( $ptr );
    If( $err <> 0 ) Then
        SetError( $err );
        Return;
    EndIf
    Local $index = _HashF_FindIndex( $ptr );
    
    ; "1" means sort by value
    _HashF_Sort( $index, $_HashC_Descending, 1 );
EndFunc


;     PRIVATE STUFF - DON'T USE!! 

;--------------------------------------------------------------------------------
;Function Name:  _HashF_FindIndex
;
;Description:    A simple method that finds the hash within the list of hashes.
;
;Parameter(s):   $ptr - the pointer to test
;
;Returns:        The index of the pointer, or -1 if pointer invalid
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;--------------------------------------------------------------------------------
Func _HashF_FindIndex( $ptr )
    For $i = 0 To UBound( $_HashG_container, 1 ) - 1
        If ( $ptr == $_HashG_container[$i][0][1] ) Then
            Return($i);
        EndIf
    Next
    Return(-1)
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_FindKey
;
;Description:    A simple method to find a key in a hash.  Note: The index is not
;                necessarily the same as the pointer.
;
;Parameter(s):   $index - the index number to the hash
;
;Returns:        -1 if pointer is valid
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;--------------------------------------------------------------------------------
Func _HashF_FindKey( $index, $key )
    For $i = 1 To $_HashG_container[$index][0][0]
        If ( $_HashG_container[$index][$i][0] == $key ) Then
            Return($i);
        EndIf
    Next
    Return(-1);
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Stuff
;
;Description:    Returns either the keys or values associated with a hash.
;
;Parameter(s):   [$ptr] - Pointer to a hash (optional)
;
;Returns:        A one dimensional array of the values.
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;--------------------------------------------------------------------------------
Func _HashF_Stuff( $ptr, $type )
    Local $retVal[1];
    $retVal[0] = 0;
    Local $err = _HashF_ValidatePtr( $ptr );
    If ( $err <> 0 ) Then
        SetError( $err );
        $retVal[0] = -1;
        Return( $retVal );
    EndIf
    
    Local $index = _HashF_FindIndex( $ptr );
    Local $count = $_HashG_container[$index][0][0];
    If ( $count > 0 ) Then
        ReDim $retVal[$count + 1];
        $retVal[0] = $count;
        For $i = 1 To $count
            $retVal[$i] = $_HashG_container[$index][$i][$type];
        Next
    EndIf
    Return ( $retVal );
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Sort
;
;Description:    Entry point for sorting the hash.  Sorts the hash in place.
;                NOTE: Uses a bubble sort if the hash is sufficiently small.
;
;Parameter(s):   [$index] - Pointer to a hash (optional)
;                [$sort] - Sort direction 0=Ascending (default) 1=Descending
;                [$keyVal] - Sort by key or value 0=key (default) 1=value
;
;Returns:        Nothing.
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;--------------------------------------------------------------------------------
Func _HashF_Sort( $index = 0, $sort = 0, $keyVal = 0 )
    If (( $keyVal <> 0 ) And ( $keyVal <> 1 )) Then
        $keyVal = 0;
    EndIf
    If (( $sort <> $_HashC_Ascending ) And ( $sort <> $_HashC_Descending )) Then
        $sort = $_HashC_Ascending;
    EndIf
    
    If( $_HashG_container[$index][0][0] < 5 ) Then
        _HashF_BubbleSort( $index, $sort, $keyVal );
        Return;
    EndIf
    
    Local $sorted = 1;
    Local $a, $b;
    For $i = 1 To ( $_HashG_container[$index][0][0] - 1 )
        $a = $_HashG_container[$index][$i  ][$keyVal];
        $b = $_HashG_container[$index][$i+1][$keyVal];
        If ((( $sort == $_HashC_Ascending  ) And ( $a > $b ) ) Or (( $sort == $_HashC_Descending ) And ( $a < $b ) )     )  Then
            $sorted = 0;
            $i = UBound( $_HashG_container, 2 );
        EndIf
    Next
    If ( $sorted ) Then
        Return;
    EndIf
    
    _HashF_Shuffle( $index ); //Surprisingly a shuffled array sorts fastest
    _HashF_QuickSort( $index, $sort, $keyVal );
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_QuickSort
;
;Description:    Entry point for a Quick Sort.
;
;Parameter(s):   $index - Pointer to a hash
;                $keyVal - Sort by key or value 0=key 1=value
;                $left - the left boundary of the current sort
;                $right - the right boundary of the current sort
;
;Returns:        Nothing.
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;
;THANKS:
;    Many thanks to ezzetabi - without whom the sorting function would CERTAINLY
;    have crashed with a stack overflow error.
;--------------------------------------------------------------------------------
Func _HashF_QuickSort( $index, $sort, $keyVal )
    Local $pointer, $pivot;
    Local $left = 1;
    Local $right = $_HashG_container[$index][0][0];
    Local $stack[(Int(Log($right - $left) / Log(2)) * 2 + 2)];
    Local $stackPointer = 0;
    
    While ( 1 )
        While $left < $right
            $pivot = $left - 1;
            For $pointer = $left To ($right - 1)
                Local $a = $_HashG_container[$index][$pointer][$keyVal];
                Local $b = $_HashG_container[$index][$right][$keyVal];
                If ( (( $sort = 0 ) And ( $a < $b )) Or (( $sort = 1 ) And ( $a > $b ))      ) Then
                    $pivot = $pivot + 1;
                    _HashF_SwapElements ( $index, $pivot, $pointer );
                EndIf
            Next
            $pivot = $pivot + 1;
            _HashF_SwapElements ( $index, $pivot, $right );
            
            If ( ( $right - $pivot ) > ( $pivot - $left ) ) Then
                _HashF_StackPush( ($pivot + 1), $stack, $stackPointer );
                _HashF_StackPush( $right, $stack, $stackPointer );
                $right = $pivot - 1;
            Else
                _HashF_StackPush( $left, $stack, $stackPointer );
                _HashF_StackPush( $pivot-1, $stack, $stackPointer );
                $left = $pivot + 1;
            EndIf
        WEnd
        
        $right = _HashF_StackPop( $stack, $stackPointer );
        If ( @error ) Then ExitLoop;
        $left = _HashF_StackPop( $stack, $stackPointer );
    WEnd
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_Shuffle
;
;Description:    Shuffles the elements in the hash.  Surprisingly, a completely
;                random array is sorted fastest.  A completely sorted array is
;                the slowest sort, and the time taken to sort decreases as the
;                array degrades from almost sorted to completely random.  This
;                function isn't totally necessary for small arrays - but it sure
;                helps on big arrays.
;
;Parameter(s):   $index - Pointer to a hash
;
;Returns:        The pivot point of the next sort.
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;--------------------------------------------------------------------------------
Func _HashF_Shuffle( $index )
    For $i = 2 To ( $_HashG_container[$index][0][0] - 1 )
        Local $right = Random( 2, ( $_HashG_container[$index][0][0] - 1 ), 1 );
        _HashF_SwapElements ( $index, 1, $right )
    Next
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_BubbleSort
;
;Description:    Entry point for sorting the hash.  Sorts the hash in place.
;                NOTE: This method is used when the hash is sufficiently small.
;
;Parameter(s):   $index - Pointer to a hash
;                [$sort] - Sort direction 0=Ascending (default) 1=Descending
;                [$keyVal] - Sort by key or value 0=key (default) 1=value
;
;Returns:        Nothing.
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;--------------------------------------------------------------------------------
Func _HashF_BubbleSort( $index, $sort = 0, $keyVal = 0 )
    If ( $_HashG_container[$index][0][0] < 2 ) Then
        Return;
    EndIf
    
    If (( $keyVal <> 0 ) And ( $keyVal <> 1 )) Then
        $keyVal = 0;
    EndIf
    If (( $sort <> $_HashC_Ascending ) And ( $sort <> $_HashC_Descending )) Then
        $sort = $_HashC_Ascending;
    EndIf
    
    Local $sorting = 1;
    Local $a, $b;
	Local $rightBoundary = 0;
    While ( $sorting )
        $sorting = 0;
        For $i = 1 to ( $_HashG_container[$index][0][0] - 1 )
            $a = $_HashG_container[$index][$i  ][$keyVal];
            $b = $_HashG_container[$index][$i+1][$keyVal];
            If ((( $sort == $_HashC_Ascending  ) And ( $a > $b ) ) Or (( $sort == $_HashC_Descending ) And ( $a < $b ) )     )  Then
                _HashF_SwapElements( $index, $i, ($i + 1) );
                $sorting = 1;
            EndIf
        Next
        $rightBoundary = $rightBoundary - 1;
    Wend
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_SwapElements
;
;Description:    Swaps two elements in the hash.
;
;Parameter(s):   $hashPtr - Pointer to a hash
;                $lIndex - the index of the left element to swap
;                $rIndex - the index of the right element to swap
;
;Returns:        Nothing.
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;--------------------------------------------------------------------------------
Func _HashF_SwapElements ( $hashPtr, $lIndex, $rIndex )
    If ( $lIndex == $rIndex ) Then Return
    Local $tempKeyHolder                    = $_HashG_container[$hashPtr][$lIndex][0];
    Local $tempValHolder                    = $_HashG_container[$hashPtr][$lIndex][1];
    $_HashG_container[$hashPtr][$lIndex][0] = $_HashG_container[$hashPtr][$rIndex][0];
    $_HashG_container[$hashPtr][$lIndex][1] = $_HashG_container[$hashPtr][$rIndex][1];
    $_HashG_container[$hashPtr][$rIndex][0] = $tempKeyHolder;
    $_HashG_container[$hashPtr][$rIndex][1] = $tempValHolder;
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_StackPush
;
;Description:    Pushes a value onto the stack.
;
;Parameter(s):   $val - the value to push onto the stack
;                $stack - a reference to the stack
;                $stackPointer - a pointer to the current position in the stack
;
;Returns:        Nothing.
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;
;THANKS:
;    Many thanks to ezzetabi - without whom the sorting function would CERTAINLY
;    have crashed with a stack overflow error.
;--------------------------------------------------------------------------------
Func _HashF_StackPush( $val, ByRef $stack, ByRef $stackPointer )
    $stack[$stackPointer] = $val;
    $stackPointer = $stackPointer + 1;
EndFunc


;--------------------------------------------------------------------------------
;Function Name:  _HashF_StackPop
;
;Description:    Pops a value off the stack.  Sets error to 1 if the stack is
;                empty.
;
;Parameter(s):   $stack - a reference to the stack
;                $stackPointer - a pointer to the current position in the stack
;
;Returns:        The value found at the pointer.
;
;NOTE: This would be a private method if AutoIt used encapsulation.  Use this
;method at your own risk!!
;
;THANKS:
;    Many thanks to ezzetabi - without whom the sorting function would CERTAINLY
;    have crashed with a stack overflow error.
;--------------------------------------------------------------------------------
Func _HashF_StackPop( ByRef $stack, ByRef $stackPointer )
    If ( $stackPointer == 0 ) Then
        SetError( 1 );
        Return;
    EndIf
    $stackPointer = $stackPointer - 1;
    Return $stack[$stackPointer];
EndFunc
