
#include <Constants.au3>
#include <array.au3>
#include <array_ex.au3>

#AutoIt3Wrapper_Add_Constants=n

;--------------------------------------------------------------------------------------------------------------------------------------
;
;	Examples for _ArrayFindAllex
;
;--------------------------------------------------------------------------------------------------------------------------------------

; 1D and 2D array for examples

Local $av1DTestArray[20] = ['Tom', 'Tina', 'Steve', 'Jim', 'Jack', 'Mark', 'Barbara', 'Paul', 'Daniel', 'Michelle', 'Patrick', 'Michael', 'Alfred', 'albert']
Local $av2DTestArray[20][3] = [ _
		['Car', 'Red', 20000], _
		['dog', 'Fido', 'vicar'], _
		['basketball', 'football', 'soccer'], _
		[1, 2, 3], _
		['George', 'Room # 30', 'Math'], _
		['1111 Present Street', 'North Pole', 'Earth'], _
		['Phaw!', 'chortle?', 'gaffaw *'], _
		['pancakes', 'tomatoes', 'carrots'], _
		['car', 'bike', 'skateboard'], _
		['math', 'history', 'biology'] _
		]

; generate table of ascii characters

Local $aTmpASCII[256]
For $1 = 0 To 255
	$aTmpASCII[$1] &= Chr($1)
Next

Local $out_str

; test for common ascii characters at the end of every element in $av2DTestArray - write output to console

For $1 = 33 To 127 - 1
	$Ret = _ArrayFindAllex($av2DTestArray, $aTmpASCII[$1], 3)
	Switch @error
		Case 0
			For $2 = 0 To UBound($Ret) - 1
				$out_str &= StringFormat('Search for [ %-1s ]  Found at element [ %-10s ]   value is [ %-10s ]', $Ret[$2][1], $Ret[$2][0], $Ret[$2][2]) & @LF
			Next
			ConsoleWrite($out_str)
		Case 1
			ConsoleWrite('Input source is not an array' & @LF)
		Case 2
			ConsoleWrite('Search type is invalid' & @LF)
		Case 3
			ConsoleWrite('Case sense is invalid' & @LF)
		Case 4
			ConsoleWrite('Input source is not a 1D or 2D array' & @LF)
		Case 5
			ConsoleWrite('[ ' & $aTmpASCII[$1] & ' ] Not Found' & @LF)
	EndSwitch
Next
ConsoleWrite('!  Test for ASCII chars at the end of 2D array elements' & @LF & $out_str & @LF)

; find all lines in this script that end with the tokens "then", "1" or "@lf"

Local $a10 = StringSplit(FileRead(@ScriptName), @CRLF, 3)
$Ret = _ArrayFindAllex($a10, 'then##1##@lf', 3, -1, '##')
_ArrayDisplay($Ret, 'Script lines ending with "then" or "1" or "@LF')

; find "div" statements in www.autoit.com/forum/

Local $bHTML = InetRead('http://www.autoitscript.com')
If @error <> 0 Then ConsoleWrite('inetread failed' & @LF)
Local $aHTML = StringSplit(BinaryToString($bHTML), @CRLF, 3)
$Ret = _ArrayFindAllex($aHTML, '<div', 0)
Switch @error
	Case 0
		_ArrayDisplay($Ret, '"<div" statements')
	Case 1
		ConsoleWrite('Input source is not an array' & @LF)
	Case 2
		ConsoleWrite('Search type is invalid' & @LF)
	Case 3
		ConsoleWrite('Case sense is invalid' & @LF)
	Case 4
		ConsoleWrite('Input source is not a 1D or 2D array' & @LF)
	Case 5
		ConsoleWrite('[ ' & $aTmpASCII[$1] & ' ] Not Found' & @LF)
EndSwitch

; find elements that contain "Al" (not case sensitive)

$Ret = _ArrayFindAllex($av1DTestArray, 'Al', 0)
_ArrayDisplay($Ret, '"Al" - no casesense')

; find elements that contain "Al" (case sensitive)

$Ret = _ArrayFindAllex($av1DTestArray, 'Al', 0, 1)
_ArrayDisplay($Ret, '"Al" - casesense')

; find elements that contain "car" (not case sensitive)

$Ret = _ArrayFindAllex($av2DTestArray, 'car', 0)
_ArrayDisplay($Ret, '"car" - no casesense')

; find elements that contain "*", "#" or "!"

$Ret = _ArrayFindAllex($av2DTestArray, '*|#|!', 0, -1, '|')
Switch @error
	Case 0
		_ArrayDisplay($Ret, '"*", "#" or "!"')
	Case 1
		ConsoleWrite('Input source is not an array' & @LF)
	Case 2
		ConsoleWrite('Search type is invalid' & @LF)
	Case 3
		ConsoleWrite('Case sense is invalid' & @LF)
	Case 4
		ConsoleWrite('Input source is not a 1D or 2D array' & @LF)
	Case 5
		ConsoleWrite('[ ' & $aTmpASCII[$1] & ' ] Not Found' & @LF)
EndSwitch

; find elements = "xxx"

Local $find_str = 'xxx'
$Ret = _ArrayFindAllex($av2DTestArray, $find_str, 0)
If @error = 5 Then
	MsgBox($mb_ok, '', StringFormat('[ %-3s ] Not Found', $find_str))
Else
	_ArrayDisplay($Ret, 'find "xxx"')
EndIf

; generate 2D array of random numbers (1-100)

Local $a10[100][100], $st
For $1 = 0 To 99
	For $2 = 0 To 99
		$a10[$1][$2] = Random(1, 100, 1)
	Next
Next

; stress test #1 - find elements = 10 in a 100X100 2D array

$st = TimerInit()
$Ret = _ArrayFindAllex($a10, 10)
_ArrayDisplay($Ret, UBound($Ret) & ' matches time=' & Round(TimerDiff($st) / 1000, 3))

; stress test #2 - find elements that contain a "10" in a 100X100 2D array

$st = TimerInit()
$Ret = _ArrayFindAllex($a10, 10, 0)
_ArrayDisplay($Ret, UBound($Ret) & ' matches time=' & Round(TimerDiff($st) / 1000, 3))

; stress test #3 - find elements that contain a "10" or "5" in a 100X100 2D array

$st = TimerInit()
$Ret = _ArrayFindAllex($a10, '10##5', 0, -1, '##')
_ArrayDisplay($Ret, UBound($Ret) & ' matches time=' & Round(TimerDiff($st) / 1000, 3))

;--------------------------------------------------------------------------------------------------------------------------------------
;
;	Example for _ArrayDeleteColumn
;
;--------------------------------------------------------------------------------------------------------------------------------------

Local $aTest[200][15]

For $1 = 0 To UBound($aTest, 1) - 1
	For $2 = 0 To UBound($aTest, 2) - 1
		$aTest[$1][$2] = StringFormat('%04i-%04i', $1, $2)
	Next
Next

_ArrayDisplay($aTest, 'Before')

Local $st = TimerInit()
$aTest = _ArrayDeleteColumn($aTest, '7')
If @error <> 0 Then ConsoleWrite(@error & @LF)
_ArrayDisplay($aTest, 'After - Time to delete column = ' & Round(TimerDiff($st) / 1000, 3))