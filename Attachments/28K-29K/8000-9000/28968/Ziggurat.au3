;#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; #VARIABLES# ===============================================================================
Global $s_adZigX[128 + 1]
Global $s_adZigR[128]
_Random_Gaussian_Zig_Init() ;initiate tables
; ===========================================================================================



; #FUNCTION# ;===============================================================================
; Name...........: _Random_Gaussian_Zig_Init
; Description ...: Creates the look-up tables/arrays necessary for ziggurat rejection
; Syntax.........: _Random_Gaussian_Zig_Init()
; Return values .: Success - Returns two look-up arrays
;                  Failure - (under construction)
; Author ........: JURGEN A DOORNIK, Marsaglia and Tsang, AndyBiochem (AutoIt conversion)
; ===========================================================================================
Func _Random_Gaussian_Zig_Init()

	Local $iC = 128
	Local $dR = 3.442619855899
	Local $dV = 9.91256303526217E-3
	Local $i, $f

	$f = Exp(-0.5 * $dR * $dR)
	$s_adZigX[0] = $dV / $f
	$s_adZigX[1] = $dR
	$s_adZigX[$iC] = 0

	For $i = 2 To $iC - 1
		$s_adZigX[$i] = Sqrt(-2 * Log($dV / $s_adZigX[$i - 1] + $f));
		$f = Exp(-0.5 * $s_adZigX[$i] * $s_adZigX[$i]);
	Next

	For $i = 0 To $iC - 1
		$s_adZigR[$i] = $s_adZigX[$i + 1] / $s_adZigX[$i];
	Next

EndFunc   ;==>_Random_Gaussian_Zig_Init

; #FUNCTION# ;===============================================================================
; Name...........: _Random_Gaussian_Zig
; Description ...: Generates a gaussian distributed normal variable.
; Syntax.........: _Random_Gaussian_Zig($iMean,$iSD)
; Parameters ....: $iMean - The mean of the gaussian distribution
;                  $iSD - The standard deviation of the gaussian distribution
; Return values .: Success - Returns a single gaussian random number
;                  Failure - (under construction)
; Author ........: JURGEN A DOORNIK, Marsaglia and Tsang, AndyBiochem (AutoIt conversion)
; ===========================================================================================
Func _Random_Gaussian_Zig($iMean, $iSD)

	Local $i, $x, $u, $f0, $f1, $y, $xOut

	While 1
		$u = 2 * Random() - 1
		$i = Random(0, 128)

		If Abs($u) < $s_adZigR[$i] Then
			$xOut = $u * $s_adZigX[$i]
			ExitLoop
		EndIf

		If $i = 0 Then
			While (-2 * $y) < ($x * $x)
				$x = Log(Random()) / 3.442619855899
				$y = Log(Random())
			WEnd
			If $u < 0 Then
				$xOut = $x - 3.442619855899
				ExitLoop
			EndIf
			$xOut = 3.442619855899 - $x
			ExitLoop
		EndIf

		$x = $u * $s_adZigX[$i]
		$f0 = Exp(-0.5 * ($s_adZigX[$i] * $s_adZigX[$i] - $x * $x))
		$f1 = Exp(-0.5 * ($s_adZigX[$i + 1] * $s_adZigX[$i + 1] - $x * $x))
		If ($f1 + Random() * ($f0 - $f1) < 1.0) Then
			$xOut = $x
			ExitLoop
		EndIf
	WEnd

	$xOut *= $iSD

	Return $iMean + $xOut

EndFunc   ;==>_Random_Gaussian_Zig
