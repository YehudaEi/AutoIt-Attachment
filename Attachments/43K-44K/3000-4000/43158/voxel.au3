$pos1 = StringSplit("2,1,100000", ",", 1)
$pos2 = StringSplit("1,1,150000", ",", 1)

$alltimer = TimerInit()
$all = _allbetween($pos1, $pos2)
$array = StringSplit($all, "|")
$alltime = TimerDiff($alltimer)

$betweentimer = TimerInit()
$isbetween = _Isbetween("0,0,2",$pos1, $pos2)
$betweentime = TimerDiff($betweentimer)

$counttimer = TimerInit()
$count = _countbetween($pos1, $pos2)
$counttime = TimerDiff($counttimer)

$distancetimer = TimerInit()
$distance = _distancebetween($pos1, $pos2)
$distancetime = TimerDiff($distancetimer)

if StringLen($all) > 5000 Then
	$all = stringleft($all, 5000)&'...'
EndIf

MsgBox(0, 'Coordinate Calculations', "All Between: "&$all&@CRLF&"Count: "&$array[0]-1&@CRLF&"Time: "&$alltime&"ms" _
&@CRLF&@CRLF& "Is Between: "&$isbetween&@CRLF&"Time: "&$betweentime&"ms" &@CRLF&@CRLF&"Quick Count: "&$count&@CRLF&"Time: "&$counttime&"ms" _
&@CRLF&@CRLF&"Distance: "&$distance&@CRLF&"Time: "&$distancetime&'ms')

#cs
-------------------------------------------------------------------------
Function: IsBetween

Description: Calculates if the given point is between two defined points

Return: True (1) or False (0)
-------------------------------------------------------------------------
#ce
Func _isbetween($check, $coords1, $coords2)
    $between = StringRegExp(_allbetween($coords1, $coords2), "(.*?)"&$check&"(.*?)", 0)
    Return $between
EndFunc

#cs
-------------------------------------------------------------------------
Function: All Between

Description: Calculates all coordinates(blocks) between two points.

Return: A string(list) containing all locations between two points.
-------------------------------------------------------------------------
#ce
func _allbetween($coords1, $coords2)
	Local $blocks = "", $step[4]

		for $i=1 to 3
			if $coords1[$i] > $coords2[$i] then
			$tmp = $coords1[$i]
			$coords1[$i] = $coords2[$i]
			$coords2[$i] = $tmp
			EndIf
		Next

	for $i1= $coords1[1] to $coords2[1]
		for $i2= $coords1[2] to $coords2[2]
			for $i3= $coords1[3] to $coords2[3]
				$blocks&= $i1&","&$i2&","&$i3&"|"
			Next
		Next
	Next

	Return $blocks
EndFunc

#cs
-------------------------------------------------------------------------
Function: Count Between

Description: Quickly counts the volume(cubed) between two points.

Return: An int representing the volume between two points(cubed).
-------------------------------------------------------------------------
#ce
Func _countbetween($coords1, $coords2)
Local $blocks = ""

for $i=1 to $coords2[0]
    switch StringLeft($coords2[$i],1)
        case "-"
            $blocks += (($coords2[$i])*-1)+$coords1[$i]
        case else
            $blocks += $coords2[$i]-$coords1[$i]
    EndSwitch
Next

Return $blocks+1
EndFunc

#cs
-------------------------------------------------------------------------
Function: Distance Between

Description: Calculates the distance between two points.

Note: Calculates horizontally, vertically, and diagonally

Return: An int or double representing the absolute distance.
-------------------------------------------------------------------------
#ce
Func _distancebetween($coords1, $coords2)
Local $blocks = ""

for $i=1 to $coords2[0]
    switch StringLeft($coords2[$i],1)
        case "-"
            $blocks += ((($coords2[$i])*-1)+$coords1[$i])^2
        case else
            $blocks += ($coords2[$i]-$coords1[$i])^2
    EndSwitch
Next

Return Sqrt($blocks)
EndFunc