; Utilty that utilizes Newton's method to find solutions to equations
; See http://en.wikipedia.org/wiki/Newton%27s_method for an explanation of the math.
; by Diego Hernandez < d (dot) hernandez 0 9 at g mail >


#include <Array.au3>
#include <String.au3>

HotKeySet ("{ESC}", "Terminate") ; press ESC to emergency-exit

Local $expression = InputBox ("Enter equation", "E.g. x^2=16", "x^2=16") ; make sure you use * to multiply
If @error Then Exit

$expression = "&" & $expression & "&"
$right_side = _StringBetween ($expression, "=", "&")
$left_side = _StringBetween ($expression, "&", "=")
$expression = $left_side[0] & " - (" & $right_side[0] & ")" ; one side of the equation is now 0; now apply Newton's method.

Local $x_guesses_array[2] ; every 2000 iterations (this is more than enough in many cases) the program will compare
; the values for the root and if it has converged enough, it will display the answer in a MsgBox.
$x_guess = Number(InputBox ("Enter approximation for root", "Enter a guess reasonably close to the root so Newton's method can converge properly. Thank you!"))
; The program will find the root closest to your initial guess. If it is complex, it will enter into an infinite cycle.
$c = 0

While 1
$x_guess = $x_guess - (_Fx($expression, $x_guess)/_SlopeOfTangent($expression, $x_guess))
; see http://en.wikipedia.org/wiki/Newton%27s_method for an explanation of the math behind Newton's method
$c +=1
If IsInt ($c/1000) = 1 and IsInt ($c/2000) = 0 Then
	$x_guesses_array[0] = $x_guess
	$x_guesses_array[1] = 0
EndIf
If IsInt ($c/2000) Then
	; every 2000 iterations, the program will compare its current x value with the x-value stored from the previous 1000th iteration.
	; if they are close enough, the root has been sufficiently determined. It will ExitLoop and display the root.
	$x_guesses_array[1] = $x_guess
	; _ArrayDisplay ($x_guesses_array)
	If Abs($x_guesses_array[1] - $x_guesses_array[0]) < 0.001 Then ExitLoop
EndIf
If $c >= 10000 Then
	MsgBox (0, "Message", "You have reached a complex root or other weird occurrence. Please try again with a different initial guess. Thank you!")
	Exit ; I have tried to make it user-friendly
EndIf
WEnd

MsgBox (0, "Solution", Round($x_guess, 4))

Func Terminate ()
	Exit
EndFunc

Func _SlopeOfTangent($expr, $at_point, $var = "x", $places=4)
    Local $dx = 0.00000001
    Local $x = $at_point
    Local $y = $x + $dx
    Local $slope = Execute(StringReplace($expr,$var,"$y")) - Execute(StringReplace($expr,$var,"$x"))
    Return Round($slope/$dx,$places)
EndFunc ;_SlopeOfTangent()==>

Func _Fx ($expr, $at_point)
	Return Execute (StringReplace($expr, "x", "$at_point"))
EndFunc
