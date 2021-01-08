#include <String.au3>

Func Bin( $dec )
	;check to see if the number is 0, if it is return 0
    If $dec = 0 Then Return "0"  
	
    ;used to determine whether the number is negative or not we convert the absolute 
	;value of the dec num to binary then reapply neg sign at the end
	$neg = Abs( $dec ) / $dec
    $dec *= $neg

    ;convert the integegral part of the number to binary
    $integral = int_bin( Int( $dec ) )
    
    ;convert the decimal part of the number to binary
    $decimal = dec_bin( $dec - Int( $dec ) )
	
	;assemble the binary number result from the integral and decimal pieces
	Return StringTrimRight( $neg * 1, 1 ) & $integral & $decimal
EndFunc

;this function converts the decimal part of the given number to binary

Func dec_bin( $dec_part )
    Local $binary = ""
    
    If $dec_part = 0 Then Return ""
	
	$binary &= "."
    
    While $dec_part <> 0
        $dec_part *= 2
        
        If $dec_part >= 1 Then
            $binary = $binary & "1"
            $dec_part -= 1
        Else
            $binary = $binary & "0"
        EndIf
    WEnd
    
    Return $binary
    
EndFunc

;this function converts the integer part of the given number to binary

Func int_bin( $int_part )
	Local $binary = ""
    
    If $int_part = 0 Then Return "0"
    
    While $int_part <> 0
        If Mod( $int_part, 2 ) = 0 Then
            $binary = $binary & "0"
        Else
            $binary = $binary & "1"
            $int_part -= 1
        EndIf
        $int_part = Int( $int_part / 2 )        
    Wend
    
    Return _StringReverse( $binary )
EndFunc