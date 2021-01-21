#include"Array 2.au3"

Global $testArray[3][5][2][7]

For $z = 0 To 2
	For $y = 0 To 4
		For $x = 0 To 1
			For $w = 0 To 6
				$testArray[$z][$y][$x][$w] = $z+$y+$x+$w
			Next
		Next
	Next
Next

_ArrayShowMultiDim($testArray,"The original array")

MsgBox(0,"Was '3' Found?",_ArraySearchMultiDim($testArray,3,"[1,2][-1][0][2,4]",False))

_ArrayShowMultiDim(_ArraySearchMultiDim($testArray,3,"[1,2][-1][0][2,4]"),"Search for the number 3")

MsgBox(0,"Was '5' Found?",_ArraySearchMultiDim($testArray,5,"[1,2][-1][0][2,4]",False))

_ArrayShowMultiDim(_ArraySearchMultiDim($testArray,5,"[-1][-1][0][2,5]"),"Search for the number 5")

MsgBox(0,"The highest value",_ArrayMaxMultiDim($testArray,False))

_ArrayShowMultiDim(_ArrayMaxMultiDim($testArray),"The highest value(s)")

_ArrayShowMultiDim(_ArrayMinMultiDim($testArray),"The lowest value(s)")

_ArrayShowMultiDim(_ArraySplitMultiDim($testArray),"The 1-dimensional version")