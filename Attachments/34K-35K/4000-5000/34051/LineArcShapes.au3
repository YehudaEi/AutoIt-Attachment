

;error arc2stinnerpatherror1.lcf because there is a very short line at th ejunc of a corner and line length is less than margin. To cope with this I need to detect th eproblem then try th eprevious line.
;It won't be a problem when I can radius any corner, removing lines in betwen if needed so that no internal radius is too small fo rth etool to reach.
;:All external corners should have a radius added in the paralle path.
; File LineArcShapes.au3
;functions to use and manipulate shapes consisting of straight lines and arcs in a shape array as defined below
#include-once
#include <array.au3>
Opt("MustDeclareVars", 1)
;version 1.1, 2nd May
;            fix problem with parallel copy st line to arc in some cases
;
;1.2 4th May change unsafe code in _Shape_CreateRegPoly
;1.3 8th May add func _AngleSweep to calc difference btetween 2 angles. Eg 0 to 360 is not 360 it's 0
;           and used it in _Shape_CreateParallelCopy. That removed a bug
;            Correct bug in _Shape_CreateParallelCopy which affected path round corner of some straight lines
; 1.31 9th May reverted to previous method in parallel copy for arc to stLine
; 1.32 22nd May fix bug in _AngleBetweenStLines Error was in testing equality of 2 reaql numbers instead of checking if they
;                were within $ShapeTOLERANCE



;======== shape array is a 2D array with $LINECOLS columns and n+1 rows where n is the number of lines making the shape
;the first element [0][0] contains the number of lines in the shape.
;                  [0][1] shape is closed
;                  [0][2] reserved for shape has path set, 0 = no, 1 = cw, 2 = ccw
;                  [0][3] reserved
;                  [0][4] reserved
;                  [n][5] reserved
;                  [n][6] reserved
;Each row contains the definition of the line
;[n][0] = 1 for a straight line, 2 for an arc
;for straight lines
;               [n][1] to [n][4] are startx,starty,endx, endy coords
;               [n][5]   reserved for line angle
;for arcs
;            [n][1], [n][2] = x,y centre of the arc
;                    [n][3] = radius
;                    [n][4] = start angle
;                    [n][5] = sweep angle. (End angle = start angle + sweep angle.)
;
;for straight lines or arcs
;                    [n][6] = For the use of the user. Example use = a set of line types for drawing the line
;                                 so 0 = normal, 1 = selected, 2 = closest, 4 = rubberband.


;function list
;   _Shape_LoadFromFile
;   _Shape_SaveToFile
;  `_Shape_CreateRegPoly
;   _Shape_Draw - draws the shape
;   _Shape_CreateParallelCopy makes a parallel smaller or larger copy. Usefule for the path of a routing tool.
;   _Shape_GetArea gets the area of the shape. Internal use, simplified so arcs are replaced by chords in the calculation - only used to determine rotation of lines
;   _Shape_GetStLineAngle
;   _Shape_IsPointInside
;   _Shape_ReverseDirection
;   _Shape_SetPath   - intended for internal use sets all lines so that each continues from the previous so the shape can be draw or cut in one contiuous movement.
;   _Shape_SortClockWise sorts direction of lines cw or ccw;
;   _Shape_Rotate
;   _Shape_Shift
;   _Shape_GetExtents - gets the minimum bounding rectangle
;   _Shape_DistToStLine
;   _Shape_DistToArc
;   _Shape_MirrorVert
;   _Shape_MirrorHor
;   _Shape_GetNearestPt  - find nearest point on the shape to a point
;   _Shape_MakeCornerSharp - removes a chamfer or radius between two straight lines
;   _Shape_MakeRadiusCorner - only between 2 straight lines at moment
;   _Shape_RemoveLine - internal use unless you know what you're doing
;   _Shape_ChamferCorner   - only between 2 straight lines
;   _Shape_ChangeChamferBetweenLines xxxxxxxxxxx not needed, just sharpen corner then chamfer
;   _Shape_ChangeRadiusBetweenLines ditto I think
;   _Shape_SplitStLine
;   _Shape_StLineLength
;   _Shape_InsertStLine
;   _Shape_MoveStStJuncABs
;   _Shape_MergeStSt
;   _Shape_Arc2StLine
;   _Shape_StLineToArc half done; arc height ok, by radius to do
;   _Shape_StLineToVee
;   _Shape_changeStLineAngle

; +lots more to do, eg
;   _Shape_MoveStStJuncRel

;   _Shape_Roundcorner for any mix of st line and arc; (st to stline done so far)
;
;

; plus other minor supporting functions below

;  _AngleBetweenStLines
;  _SweepVia - calculate the sweep to get from angle A to B passing angle C
;  _DistToStLine
;  _NearestPtOnLine
;  _RotatePointFromPoint
;  _LineLength
;  _AngleFromPts
;  _GetArcAngle
;  _GetParallelStLines
;  _IsPtLeftOfLine -
;  _IsPtInArc      - does a horizontal line drawn from the point to the right cut through the arc once only.
;  _OneIsSameAngle  - is A same as B or C. Not so obvious when A = 476, B = 42, C = -64
;  _SetAngle       - make angle >= 0, < 360
;  _AngleInRange   - is an angle in the range A to A + sweep
;  _ArcFrom3Pts   - gets the arc centre and radius for the arc which passes through 3 pts
;  _IntersectionLineLine
;  _AngleSweep
Const $mgdebug = 0
Global Const $pi = 4 * ATan(1)
Global Const $Rad2Deg = 180 / $pi
Global Const $Deg2Rad = $pi / 180
Const $PREC = 10 ; the default precision
Const $ShapeTOLERANCE = 0.0001
Global $GCDrawStLine = '';the user defined function for drawing a straight line
Global $GCDrawArc = ''; the user defined function for drawing an arc
Global Const $LINECOLS = 7; the number of elements for each line

Func _Shape_SetStLineAngle(ByRef $aP, $iLine, $angle, $iPt)

    Local $fixedEnd, $next, $prev, $tx, $ty, $newend, $changeLine
    mgConsoleWrite("setstline2angle params = " & $iLine & ', ' & $angle & ', ' & $iPt & @CRLF)
    $angle = 360 - $angle
    If $iLine > 1 Then
        $prev = $iLine - 1
    Else
        $prev = $aP[0][0]
    EndIf

    If $iLine < $aP[0][0] Then
        $next = $iLine + 1
    Else
        $next = 1
    EndIf


    If $iLine = $iPt Then
        $fixedEnd = 0;start
        $changeLine = $next
    ElseIf $iPt = $prev Then
        $fixedEnd = 2;
        $changeLine = $prev
    Else
        Return -2;point not an end of line
    EndIf
    mgConsoleWrite("we must change to end of adjacent line " & $changeLine & @CRLF)
    If $aP[$changeLine][0] <> 1 Then Return -3;can only adjust moved end along a straight line.

    ;calc points at an angle from the fixed end. Make line 100 long
    $tx = $aP[$iLine][$fixedEnd + 1] + 100 * _cosD($angle)
    $ty = $aP[$iLine][$fixedEnd + 2] + 100 * _sinD($angle)

    $newend = _IntersectionLineLine($aP[$iLine][$fixedEnd + 1], $aP[$iLine][$fixedEnd + 2], $tx, $ty, $aP[$changeLine][1], $aP[$changeLine][2], $aP[$changeLine][3], $aP[$changeLine][4])
    mgConsoleWrite("new ends at " & $newend[0] & ', ' & $newend[1] & @CRLF)
    ;new end must be within ends of changeline
    mgConsoleWrite("changeline = " & $changeLine & @CRLF)
    ; If $newend[0] < $aP[$changeLine][1] Or $newend[0] > $aP[$changeLine][3] Then Return -4

    ; If $newend[1] < $aP[$changeLine][2] Or $newend[1] > $aP[$changeLine][4] Then Return -5

    If $changeLine = $next Then ;we change the start of chageline
        $aP[$changeLine][1] = $newend[0]
        $aP[$changeLine][2] = $newend[1]
    Else ;we change the end of prev
        $aP[$changeLine][3] = $newend[0]
        $aP[$changeLine][4] = $newend[1]
    EndIf

    ;now change moved end of line
    $aP[$iLine][2 - $fixedEnd + 1] = $newend[0]
    $aP[$iLine][2 - $fixedEnd + 2] = $newend[1]


    ;if the changed line is zero length then we must delete it
    If Abs(Abs($aP[$changeLine][1]) - Abs($aP[$changeLine][3])) < 0.0001 And Abs(Abs($aP[$changeLine][2]) - Abs($aP[$changeLine][4])) < 0.00001 Then
        $aP = _Shape_RemoveLine($aP, $changeLine)
    EndIf



EndFunc   ;==>_Shape_SetStLineAngle



;====================  _Shape_CreateRegPoly  =============================
;returns a shape array containing a polygon with $iFaces sides and each side of length $Length
; The polygon will be centred at 0,0!
Func _Shape_CreateRegPoly($iFaces, $Length)
    Local $aP[$iFaces + 1][$LINECOLS], $angle, $bangle, $spoke, $n, $start

    If $iFaces < 3 Then Return -1;

    ;calc angle from each half side to centre
    $angle = $pi / $iFaces

    ;calc angles at face ends to centre
    $bangle = $pi / 4 - $angle

    ;length of line from centre to a corner
    $spoke = $Length / (2 * Sin($angle))

    $start = $pi / 2 - $angle
    For $n = 1 To $iFaces - 1
        $aP[$n][0] = 1
        mgConsoleWrite(($n * $angle * 2 + $start) * $Rad2Deg & @CRLF)
        $aP[$n][3] = $spoke * Cos($n * $angle * 2 + $start)
        $aP[$n][4] = $spoke * Sin($n * $angle * 2 + $start)
        $aP[$n + 1][1] = $aP[$n][3]
        $aP[$n + 1][2] = $aP[$n][4]
    Next
    ;now deal with last line and start of first line

    mgConsoleWrite(($iFaces * $angle * 2 + $start) * $Rad2Deg & @CRLF)
    $aP[$iFaces][0] = 1
    $aP[$iFaces][3] = $spoke * Cos($iFaces * $angle * 2 + $start)
    $aP[$iFaces][4] = $spoke * Sin($iFaces * $angle * 2 + $start)
    $aP[1][1] = $aP[$iFaces][3]
    $aP[1][2] = $aP[$iFaces][4]

    $aP[0][0] = $iFaces

    Return $aP
EndFunc   ;==>_Shape_CreateRegPoly

;================ _Shape_ShiftLine ====================================
;shifts a st line to a parralel position $dist away
; in the direct of point $markerx, $markery adding connect straight lines each end
;not complete.If there are already legs then this funct doesn't allow for them yet.
Func _Shape_ShiftLine(ByRef $aP, $i, $dist, $markerx, $markery)
    Local $nearMark, $angle

    $nearMark = _NearestPtOnLine($markerx, $markery, $aP[$i][1], $aP[$i][2], $aP[$i][3], $aP[$i][4])

    ;the angle of the legs from the st line
    $angle = _AngleFromPts($nearMark[0], $nearMark[1], $markerx, $markery)

    ;insert a copy of the line after the present pos
    _Shape_InsertStLine($aP, $i, $aP[$i][1], $aP[$i][2], $aP[$i][3], $aP[$i][4])

    ;now insert a leg after that
    _Shape_InsertStLine($aP, $i + 1, $aP[$i][3] + $dist * _cosD($angle), $aP[$i][4] + $dist * _sinD($angle), $aP[$i][3], $aP[$i][4])

    ;now change the ends of line $i
    $aP[$i][3] = $aP[$i][1] + $dist * _cosD($angle)
    $aP[$i][4] = $aP[$i][2] + $dist * _sinD($angle)

    ;now correct line $i = 1
    $aP[$i + 1][1] = $aP[$i][3]
    $aP[$i + 1][2] = $aP[$i][4]
    $aP[$i + 1][3] = $aP[$i + 2][1]
    $aP[$i + 1][4] = $aP[$i + 2][2]


EndFunc   ;==>_Shape_ShiftLine

;========================== _SHape_ArcToStLine  =======================
;Replace line $i in shape array $aP with a straight line

Func _Shape_Arc2StLine(ByRef $aP, $i)
    Local $stx, $sty, $endx, $endy
    If $i < 1 Or $i > $aP[0][0] Then Return -1;no such line

    If $aP[$i][0] = 1 Then Return;already done

    $stx = $aP[$i][1] + $aP[$i][3] * _cosD($aP[$i][4])
    $sty = $aP[$i][2] + $aP[$i][3] * _sinD($aP[$i][4])
    $endx = $aP[$i][1] + $aP[$i][3] * _cosD($aP[$i][4] + $aP[$i][5])
    $endy = $aP[$i][2] + $aP[$i][3] * _sinD($aP[$i][4] + $aP[$i][5])
    mgConsoleWrite($stx & ', ' & $sty & ', ' & $endx & ', ' & $endy & @CRLF)
    $aP[$i][0] = 1
    $aP[$i][1] = $stx
    $aP[$i][2] = $sty
    $aP[$i][3] = $endx
    $aP[$i][4] = $endy

EndFunc   ;==>_Shape_Arc2StLine

;============== _Shape_StLineToArc ==========================================
;converts a straightline to an arc
;the ends of the st line become the start and end of the arc.
;If $lengthType = 0 then the arc reaches $length away from the line
;if $lengthType = 1 then $length is the radius.
;The marker is a point which indicates which side of the line to draw the arc.
Func _Shape_StLineToArc(ByRef $aOldP, $line, $Length, $lengthType, $markerx, $markery)
    Local $Arc, $Alpha, $nearMark, $Rad, $midx, $midy, $topx, $topy
    Local $aP = $aOldP, $temp, $h, $linelen, $arcHt

    If $aP[$line][0] <> 1 Then Return -1;not a straight line
    mgConsoleWrite("line type is ok" & @CRLF)
    ;cal angle from marker to line at rt angles
    $nearMark = _NearestPtOnLine($markerx, $markery, $aP[$line][1], $aP[$line][2], $aP[$line][3], $aP[$line][4])
    $Alpha = _AngleFromPts($nearMark[0], $nearMark[1], $markerx, $markery)


    If $lengthType = 0 Then; $length is the ht of arc from st line

        $arcHt = $Length
    Else ;length is the radius

        ; first check line is not too long
        $linelen = _LineLength($aP[$line][1], $aP[$line][2], $aP[$line][3], $aP[$line][4])
        If $linelen > $Length * 2 Then Return -2

        ;ht to st line from arc centre is
        $h = Sqrt($Length * $Length - $linelen * $linelen / 4)

        $arcHt = $Length - $h
    EndIf

    $midx = ($aP[$line][1] + $aP[$line][3]) / 2
    $midy = ($aP[$line][2] + $aP[$line][4]) / 2
    ;try then test and if need change by 180
    $topx = $midx + $arcHt * _cosD($Alpha)
    $topy = $midy + $arcHt * _sinD($Alpha)
    mgConsoleWrite("mid = " & ', ' & $midx & ', ' & $midy & ', ' & "top = " & ', ' & $topx & ', ' & $topy & @CRLF)
    $temp = _AngleFromPts($midx, $midy, $topx, $topy)
    mgConsoleWrite("AtLineToArc alpha = " & $Alpha & ", first guess = " & $temp & @CRLF)
    If Abs($temp - $Alpha) > 0.001 Then
        $topx = $midx * 2 - $topx
        $topy = $midy * 2 - $topy;assuming *2 faster than _cosD
    EndIf

    mgConsoleWrite("Send pars to arcfrom3pts " & $aP[$line][1] & ', ' & $aP[$line][2] & ', ' & $topx & ', ' & $topy & ', ' & $aP[$line][3] & ', ' & $aP[$line][4] & @CRLF)
    $Arc = _ArcFrom3Pts($aP[$line][1], $aP[$line][2], $topx, $topy, $aP[$line][3], $aP[$line][4])
    mgConsoleWrite("arc cx,cy, rad5 = " & $Arc[0] & ', ' & $Arc[1] & ', ' & $Arc[2] & $Arc[3] & ', ' & $Arc[4] & @CRLF)

    $aP[$line][0] = 2;arc
    $aP[$line][1] = $Arc[0]
    $aP[$line][2] = $Arc[1]
    $aP[$line][3] = $Arc[2]
    $aP[$line][4] = _AngleFromPts($Arc[0], $Arc[1], $aOldP[$line][1], $aOldP[$line][2])
    $aP[$line][5] = _SweepVia($aP[$line][4], _AngleFromPts($Arc[0], $Arc[1], $aOldP[$line][3], $aOldP[$line][4]), $Alpha)
    mgConsoleWrite("sweep says" & $aP[$line][5] & @CRLF)
    $aOldP = $aP

EndFunc   ;==>_Shape_StLineToArc


;============== _Shape_StLineToVee ==========================================
;converts a straightline to a V
;the ends of the st line become the start and end of the arc.
;The arc reaches $length away from the line
;The marker is a point which indicates which side of the line to draw the V.
Func _Shape_StLineToVee(ByRef $aOldP, $line, $Length, $markerx, $markery)
    Local $Arc, $Alpha, $nearMark, $Rad, $midx, $midy, $topx, $topy
    Local $aP = $aOldP, $temp

    If $aP[$line][0] <> 1 Then Return -1;not a straight line

    mgConsoleWrite("line type is ok" & @CRLF)
    ;cal angle from marker to line at rt angles
    $nearMark = _NearestPtOnLine($markerx, $markery, $aP[$line][1], $aP[$line][2], $aP[$line][3], $aP[$line][4])
    $Alpha = _AngleFromPts($nearMark[0], $nearMark[1], $markerx, $markery)



    $midx = ($aP[$line][1] + $aP[$line][3]) / 2
    $midy = ($aP[$line][2] + $aP[$line][4]) / 2
    ;try then test and if need change by 180
    $topx = $midx + $Length * _cosD($Alpha)
    $topy = $midy + $Length * _sinD($Alpha)
    _Shape_InsertStLine($aP, $line, $topx, $topy, $aP[$line][3], $aP[$line][4])


    $aP[$line][3] = $topx
    $aP[$line][4] = $topy

    $aOldP = $aP

EndFunc   ;==>_Shape_StLineToVee

;================= _Shape_MergeStSt ============================================
; convert 2 joining straight lines into one                            			;
;Parameters																		;
;            $aP the shape array												;
;            $pt the point at the junction of the 2 straight lines				;
;																				;
; Returns 0 on success															;
;         -1 if there is no such point											;
;         -2 if the point is not at the junction of 2 straight lines			;
;																				;
; NB the shape must be sorted or this function might produce unexpected results	;

Func _Shape_MergeStSt(ByRef $aP, $pt)
    Local $next
    If $pt < 1 Or $pt > $aP[0][0] Then Return -1;no such point



    If $pt = $aP[0][0] Then
        $next = 1
    Else
        $next = $pt + 1
    EndIf

    If $aP[$pt][0] <> 1 Or $aP[$next][0] <> 1 Then Return -2

    ;move end of line $pt to end of line next
    $aP[$pt][3] = $aP[$next][3]
    $aP[$pt][4] = $aP[$next][4]

    $aP = _Shape_RemoveLine($aP, $next)

    Return 0;ok

EndFunc   ;==>_Shape_MergeStSt


Func _Shape_SaveToFile($aP, $sFullPath, $sRef = 'No Ref.')
    Local $hF, $stextLine
    $hF = FileOpen($sFullPath, 2)
    FileWriteLine($hF, $sFullPath)
    FileWriteLine($hF, "[1:ENCLOSED SHAPE. Reference = " & $sRef & "]")
    For $n = 0 To $aP[0][0]
        $stextLine = ''
        For $k = 0 To UBound($aP, 2) - 1
            $stextLine &= $aP[$n][$k] & ', '
        Next

        FileWriteLine($hF, $stextLine)
    Next

    FileClose($hF)
EndFunc   ;==>_Shape_SaveToFile

Func _Shape_LoadFromFile($sFullPath)
    Local $aL, $n, $type, $sL, $aE, $Res[1][7], $iR, $k, $j

    $aL = StringSplit(FileRead($sFullPath), @CRLF, 1 + 2)
    If UBound($aL) < 3 Then Return -1

    $n = -1

    Do ;read lines from file till we get to a header
        $n += 1
        If $n >= UBound($aL) Then Return -2
        ; mgConsoleWrite($aL[$n] & @CRLF)
    Until StringInStr($aL[$n], "[1:ENCLOSED SHAPE") Or StringInStr($aL[$n], "[2:OPEN LINES") Or StringInStr($aL[$n], "[3:GROUP")
    ;allow for any number of shapes, any number of sets of lines any number of groups

    $type = Int(StringTrimLeft($aL[$n], 1))
    ;mgConsoleWrite($type & @CRLF)
    Switch $type
        Case 1;only type so far

            $n += 1
            $sL = $aL[$n]
            $aE = StringSplit($aL[$n], ',', 2)
            ReDim $Res[$aE[0] + 1][$LINECOLS]
            For $k = 0 To $aE[0]
                ; mgConsoleWrite("line " & $n + $k & " = " & $aL[$n + $k] & @CRLF)
                $aE = StringSplit($aL[$n + $k], ',', 2)
                For $j = 0 To $LINECOLS - 1
                    $Res[$k][$j] = Number($aE[$j])
                Next
            Next
            ;_arraydisplay($res)

    EndSwitch
    Return $Res
EndFunc   ;==>_Shape_LoadFromFile

;===================== _Shape_RemoveLine =================================
;shape might no longer be closed after this function!
;But you could move the start of one line to the strat of the previous then remove the previous and it will still be closed
;You can close an open shape with _Shape_SortClockWise
Func _Shape_RemoveLine($aP, $i)
    Local $n, $k

    If $i < 1 Or $i > $aP[0][0] Then Return SetError(-1, -1, $aP); no such line

    For $n = $i To $aP[0][0] - 1
        For $k = 0 To 5
            $aP[$n][$k] = $aP[$n + 1][$k]
        Next
    Next

    $aP[0][0] -= 1

    ReDim $aP[$aP[0][0] + 1][$LINECOLS]

    Return $aP

EndFunc   ;==>_Shape_RemoveLine

Func _Shape_MakeCornerSharp(ByRef $aP, $lA, $lB, $lC = 0)
    Local $aC, $A, $B, $Res, $swap, $ll[3], $n, $temp, $Corner

    ;mgConsoleWrite("Sharp pars = " & $lA & ', ' & $lB & ', ' & $lC & @CRLF)

    $aC = $aP;copy of shape to work on
    $ll[0] = $lA
    $ll[2] = $lB
    $ll[1] = $lC
    If $ll[1] = 0 Then $ll[1] = $ll[0]

    ;make numbers consecutive if pos. This method has the silly result of turning 1,2,3 into 3,4,5 for a triangle shape
    ;but this will be rare and the extra logic won't really be worth it
    ;If $lC <> 0 Then;we have three lines and the 2 outside ones will be joined and the middle one deleted
    ;are the lines connected?

    ;lines might be last,1,2 or last-1,last,1
    mgConsoleWrite("before renumber lines are " & $ll[0] & ', ' & $ll[1] & ', ' & $ll[2] & @CRLF)
    If $ll[0] >= $aC[0][0] - 1 Then
        If $ll[1] < 3 Then $ll[1] += $aC[0][0]
        If $ll[2] < 3 Then $ll[2] += $aC[0][0]
    ElseIf $ll[1] >= $aC[0][0] - 1 Then
        If $ll[0] < 3 Then $ll[0] += $aC[0][0]
        If $ll[2] < 3 Then $ll[2] += $aC[0][0]
    ElseIf $ll[2] >= $aC[0][0] - 1 Then
        If $ll[1] < 3 Then $ll[1] += $aC[0][0]
        If $ll[0] < 3 Then $ll[0] += $aC[0][0]
    EndIf

    #cs
        For $n = 0 To 2
        If $ll[$n] = 1 Then $ll[$n] += $aC[0][0]
        Next
    #ce

    mgConsoleWrite("before sort lines are " & $ll[0] & ', ' & $ll[1] & ', ' & $ll[2] & @CRLF)
    Do
        ;mgConsoleWrite("sorting" & @CRLF)
        $swap = False
        For $n = 0 To 1
            If $ll[$n] > $ll[$n + 1] Then
                $swap = True
                $temp = $ll[$n]
                $ll[$n] = $ll[$n + 1]
                $ll[$n + 1] = $temp
            EndIf
        Next


    Until $swap = False

    mgConsoleWrite("after sort lines are " & $ll[0] & ', ' & $ll[1] & ', ' & $ll[2] & @CRLF)

    If $ll[2] - $ll[0] <> 2 Then
        mgConsoleWrite("Error lines are " & $ll[0] & ', ' & $ll[1] & ', ' & $ll[2] & @CRLF)
        Return -1;3 lines not in sequence
    EndIf


    ;so now we should have 3 lines but th emiddle one will be a duplicate if $C = 0
    If $lC = 0 Then $ll[1] = $ll[0] + 1
    ;put back to correct line numbers
    For $n = 0 To 2
        $ll[$n] = Mod($ll[$n] - 1, $aC[0][0]) + 1
        ;mgConsoleWrite("$ll[" & $n & "] = " & $ll[$n] & @CRLF)
    Next
    ;mgConsoleWrite($ll[0] & ', ' & $ll[1] & ', ' & $ll[2] & @CRLF)
    If $aC[$ll[0]][0] <> 1 Or $aC[$ll[2]][0] <> 1 Then Return -3;must only be straight lines to be joined

    $Corner = _IntersectionLineLine($aC[$ll[0]][1], $aC[$ll[0]][2], $aC[$ll[0]][3], $aC[$ll[0]][4], $aC[$ll[2]][1], $aC[$ll[2]][2], $aC[$ll[2]][3], $aC[$ll[2]][4])
 if Not isarray($corner) then return - 2; lines never meet
    ;find which end of $ll[0] and $ll[2] to move to corner
    For $n = 0 To 2 Step 2
        If _LineLength($Corner[0], $Corner[1], $aC[$ll[$n]][1], $aC[$ll[$n]][2]) > _LineLength($Corner[0], $Corner[1], $aC[$ll[$n]][3], $aC[$ll[$n]][4]) Then
            ;if contact of arc is beyond end of line away from intersection then can't fit
            $aC[$ll[$n]][3] = $Corner[0]
            $aC[$ll[$n]][4] = $Corner[1]
        Else
            $aC[$ll[$n]][1] = $Corner[0]
            $aC[$ll[$n]][2] = $Corner[1]
        EndIf
    Next


    $aC = _Shape_RemoveLine($aC, $ll[1])

    $aP = $aC

EndFunc   ;==>_Shape_MakeCornerSharp

;################### _Shape_ChamferCorner #############################
;# converts two straight lines to 2 straight lines with a line between them
;The lines $lA and $lB must be adjacent lines in the shape.
;The ends of the lines furthest away from the intersection must be far enough away from the intersection to fit the new line.
;The ends of the lines nearest the intersection will be moved to the point of contact with the new line.
;The number of lines in the shape will be changed by this function and any reference to line numbers
;might no longer be correct.
;Returns  0 on success and the shape array is changed
;        -1 if either line is not a straight line
;        -2 if lines are not adjacent
;        -3 if $lA is too short to fit the chamfer
;        -4 if $lB is too short to fit the chamfer
;        -5 if the angle between the lines is 0 or 180
;#######################################################################
Func _Shape_ChamferCorner(ByRef $aP, $lA, $lB, $DistA, $DistB)
    Local $temp, $Alpha, $beta, $sweepab, $TouchA, $TouchB, $Corner, $h, $CAx, $CAy, $CBx, $CBy
    Local $EndAchange, $EndBchange, $n, $j

    ;I want the lines in the correct order
    If ($lA > $lB And not ($lA = $aP[0][0] And $lB = 1)) Or _
            ($lA = 1 And $lB = $aP[0][0]) Then
        $temp = $lA
        $lA = $lB
        $lB = $temp
        $temp = $DistA
        $DistA = $DistB
        $DistB = $temp
    EndIf

    If $lA > $aP[0][0] Then Return -6
    If $lB > $aP[0][0] Then Return -7

    ;only deals with adjacent lines so
    If $aP[$lA][0] <> 1 Or $aP[$lB][0] <> 1 Then Return -1; must be straight lines

    If $lB - $lA <> 1 And not ($lB = 1 And $lA = $aP[0][0]) Then Return -2; must be adjacent
    ; mgConsoleWrite($aP[$lA][1] & ', ' & $aP[$lA][2] & ', ' & $aP[$lA][3] & ', ' & $aP[$lA][4] & ', ' & $aP[$lB][1] & ', ' & $aP[$lB][2] & ', ' & $aP[$lB][3] & ', ' & $aP[$lB][4] & @CRLF)
    $Corner = _IntersectionLineLine($aP[$lA][1], $aP[$lA][2], $aP[$lA][3], $aP[$lA][4], $aP[$lB][1], $aP[$lB][2], $aP[$lB][3], $aP[$lB][4])
    mgConsoleWrite("corner of intersection is at " & $Corner[0] & ', ' & $Corner[1] & @CRLF)
    $sweepab = _AngleBetweenStLines($aP[$lA][3], $aP[$lA][4], $aP[$lA][1], $aP[$lA][2], $aP[$lB][1], $aP[$lB][2], $aP[$lB][3], $aP[$lB][4])
    mgConsoleWrite("angle between = " & $sweepab & @CRLF)
    If $sweepab = 0 Or $sweepab = 180 Then Return -5


    ;angle of line A
    ;mgConsoleWrite("159<--------------------------" & @CRLF)
    $Alpha = _AngleFromPts($aP[$lA][3], $aP[$lA][4], $aP[$lA][1], $aP[$lA][2])
    mgConsoleWrite("alpha = " & $Alpha & @CRLF)
    ;calc new coords for end of line A

    $CAx = $Corner[0] + $DistA * _cosD($Alpha)
    $CAy = $Corner[1] + $DistA * _sinD($Alpha)
    ; mgConsoleWrite("cAx, cAy = " & $CAx & ', ' & $CAy & @CRLF)

    ;find far end of line A
    If _LineLength($Corner[0], $Corner[1], $aP[$lA][1], $aP[$lA][2]) > _LineLength($Corner[0], $Corner[1], $aP[$lA][3], $aP[$lA][4]) Then
        ;if contact of arc is beyond end of line away from intersection then can't fit
        If $DistA > _LineLength($Corner[0], $Corner[1], $aP[$lA][1], $aP[$lA][2]) Then Return -3

        $EndAchange = 2
    Else
        If $DistA > _LineLength($Corner[0], $Corner[1], $aP[$lA][3], $aP[$lA][4]) Then Return -3

        $EndAchange = 0
    EndIf


    $Alpha = _AngleFromPts($aP[$lB][1], $aP[$lB][2], $aP[$lB][3], $aP[$lB][4])
    ; mgConsoleWrite("alpha = " & $alpha & @CRLF)
    ;calc new coords for end of line A

    $CBx = $Corner[0] + $DistB * _cosD($Alpha)
    $CBy = $Corner[1] + $DistB * _sinD($Alpha)
    mgConsoleWrite("cxb, cby = " & $CBx & ', ' & $CBy & @CRLF)
    ;now set line B
    If _LineLength($Corner[0], $Corner[1], $aP[$lB][1], $aP[$lB][2]) > _LineLength($Corner[0], $Corner[1], $aP[$lB][3], $aP[$lB][4]) Then
        ;if contact of arc is beyond end of line away from intersection then can't fit
        If $DistB > _LineLength($Corner[0], $Corner[1], $aP[$lB][1], $aP[$lB][2]) Then Return -4
        $EndBchange = 2
    Else
        If $DistB > _LineLength($Corner[0], $Corner[1], $aP[$lB][3], $aP[$lB][4]) Then Return -4
        $EndBchange = 0
    EndIf

    ;all fits so adjust line ends
    $aP[$lA][1 + $EndAchange] = $CAx
    $aP[$lA][2 + $EndAchange] = $CAy

    $aP[$lB][1 + $EndBchange] = $CBx
    $aP[$lB][2 + $EndBchange] = $CBy

    ;calc circle info
    ;first insert a new line into shape
    _Shape_InsertStLine($aP, $lA, $CAx, $CAy, $CBx, $CBy);after line $lA

    Return 0;succes

EndFunc   ;==>_Shape_ChamferCorner

;============ _Shape_InsertStLine ====================
;insert a straight line into array $aP after line $i
;returns the new position created
Func _Shape_InsertStLine(ByRef $aP, $i, $x1, $y1, $x2, $y2)
    Local $insertpos
    ReDim $aP[$aP[0][0] + 2][$LINECOLS]
    mgConsoleWrite("shape insertstline params = " & $i & ', ' & $x1 & ', ' & $y1 & ', ' & $x2 & ', ' & $y2 & @CRLF)
    If $i = $aP[0][0] Then
        $insertpos = $aP[0][0] + 1;we will add new line at end
        ReDim $aP[$insertpos + 1][$LINECOLS]
    Else
        $insertpos = $i + 1;$lines $i + 1 and above will be shifted up and the chamfer line will be in position $lB
        For $n = $aP[0][0] To $i + 1 Step -1
            For $j = 0 To $LINECOLS - 1
                $aP[$n + 1][$j] = $aP[$n][$j]
            Next
        Next
    EndIf

    $aP[$insertpos][0] = 1
    $aP[$insertpos][1] = $x1
    $aP[$insertpos][2] = $y1
    $aP[$insertpos][3] = $x2
    $aP[$insertpos][4] = $y2
    $aP[$insertpos][5] = 0

    $aP[0][0] += 1;we have 1 extra line now

    Return $insertpos
EndFunc   ;==>_Shape_InsertStLine

Func _Shape_MoveStStJuncABs(ByRef $aP, $pt, $newx, $newy)
    Local $next
    $aP[$pt][3] = $newx
    $aP[$pt][4] = $newy

    If $pt = $aP[0][0] Then
        $next = 1
    Else
        $next = $pt + 1
    EndIf

    $aP[$pt][3] = $newx
    $aP[$pt][4] = $newy

    $aP[$next][1] = $newx
    $aP[$next][2] = $newy

EndFunc   ;==>_Shape_MoveStStJuncABs


;============== _ArcFrom3Pts =========================
; finds the centre and radius of the arc which passes
;  through the three points A,B and C
;
; Returns a 1D array with 3 elements [0] = Centre X
;                                    [1] = Centre Y
;                                    [2] = Radius
;Use _SweepVia to find start angle and sweep
;=======================================================
Func _ArcFrom3Pts($Ax, $Ay, $Bx, $By, $Cx, $Cy)
    Local $mA, $kA, $mB, $kB
    Local $Rx, $Ry, $Rad, $Result[5]

    ;line at 90deg to AB : y=mx+k
    If $Ay = $By Then
        $Rx = ($Ax + $Bx) / 2
    ElseIf $Ax = $Bx Then
        $Ry = ($Ay + $By) / 2
    Else
        $mA = -1 * ($Ax - $Bx) / ($Ay - $By)
        $kA = ($Ay + $By) / 2 - $mA * ($Ax + $Bx) / 2
    EndIf

    If $Cy = $By Then
        $Rx = ($Cx + $Bx) / 2
    ElseIf $Cx = $Bx Then
        $Ry = ($Cy + $By) / 2
    Else
        $mB = -1 * ($Cx - $Bx) / ($Cy - $By)
        $kB = ($Cy + $By) / 2 - $mB * ($Cx + $Bx) / 2
    EndIf

    If $Rx == '' And $Ry == '' Then
        ;at jn $mA*X + kA = $mB*X + kB
        $Rx = ($kB - $kA) / ($mA - $mB)
        $Ry = $mA * $Rx + $kA
    ElseIf $mA == '' And IsNumber($mB) Then
        If $Ry == '' Then
            $Ry = $mB * $Rx + $kB
        Else
            $Rx = ($Ry - $kB) / $mB
        EndIf
    Else
        If $Ry == '' Then
            $Ry = $mA * $Rx + $kA
        Else
            $Rx = ($Ry - $kA) / $mA
        EndIf
    EndIf

    $Rad = _LineLength($Ax, $Ay, $Rx, $Ry)

    $Result[0] = $Rx
    $Result[1] = $Ry
    $Result[2] = $Rad
    Return $Result

    ;mgConsoleWrite($Rx & ', ' & $Ry & ', ' & $Rad & @CRLF)
EndFunc   ;==>_ArcFrom3Pts



;=============== _Shape_ChangeRadiusBetweenLines ==============================
;Changes the radius of an arc betwen 2 straight lines
;If the lines either side are not straight lines then returns -1 and the shape is not modified.
;if the modification cannot be made it returns the result of _Shape_MakeRadiusCorner
Func _Shape_ChangeRadiusBetweenLines(ByRef $aP, $i, $Rad)
    Local $aC, $A, $B, $Res

    $aC = $aP
    If $i = 1 Then
        $A = $aP[0][0];the line before the arc
    Else
        $A = $i - 1
    EndIf

    ;$B = $i
    ;$B = $i
    ;If $B = $aP[0][0] Then $B = 1

    If $i = $aP[0][0] Then
        $B = 1
    Else
        $B = $i + 1
    EndIf


    If $aP[$A][0] <> 1 Or $aP[$B][0] <> 1 Then Return -1;must only be straight lines either side of arc

    $aC = _Shape_RemoveLine($aC, $i)

    $Res = _Shape_MakeRadiusCorner($aC, $A, $B, $Rad)

    If $Res = 0 Then
        $aP = $aC
    Else
        Return $Res
    EndIf

EndFunc   ;==>_Shape_ChangeRadiusBetweenLines

;################### _Shape_MakeRadiusCorner #############################
;# converts two straight lines to 2 straight lines with an arc between them
;The lines $lA and $lB must be adjacent lines in the shape.
;The ends of the lines furthest away from the intersection must be far enough away from the intersection to fit the arc.
;The ends of the lines nearest the intersection will be moved to the point of contact at a tangent with the arc.
;The number of lines in the shape will be changed by this function and any reference to line numbers
;might no longer be correct.
;Returns  0 on success and the shape array is changed
;        -1 if either line is not a straight line
;        -2 if lines are not adjacent
;        -3 if $lA is too short to fit the arc
;        -4 if $lB is too short to fit the arc
;        -5 if the angle between the lines is 0 or 180
;        -6 line a does not exist
;        -7 line B does not exist
;#######################################################################
Func _Shape_MakeRadiusCorner(ByRef $aP, $lA, $lB, $Rad)
    Local $temp, $Alpha, $beta, $sweepab, $TouchA, $TouchB, $Corner, $h, $Cx, $Cy
    Local $EndAchange, $EndBchange, $ARcN, $n, $j, $temp2, $insideA, $farA

    ;I want the lines in the correct order A,B in the direction the lines are arranged aroung the shape cw or ccw
    If ($lA > $lB And not ($lA = $aP[0][0] And $lB = 1)) Or _
            ($lA = 1 And $lB = $aP[0][0]) Then
        $temp = $lA
        $lA = $lB
        $lB = $temp
    EndIf

    If $lA > $aP[0][0] Then Return -6
    If $lB > $aP[0][0] Then Return -7
	mgconsolewrite("line a = No. " & $lA & ", line b = No. " & $lB & @CRLF)


    If $aP[$lA][0] <> 1 Or $aP[$lB][0] <> 1 Then Return -1; must be straight lines

    ;only deals with adjacent lines so
    If $lB - $lA <> 1 And not ($lB = 1 And $lA = $aP[0][0]) Then Return -2; must be adjacent
    ;mgConsoleWrite($aP[$lA][1] & ', ' & $aP[$lA][2] & ', ' & $aP[$lA][3] & ', ' & $aP[$lA][4] & ', ' & $aP[$lB][1] & ', ' & $aP[$lB][2] & ', ' & $aP[$lB][3] & ', ' & $aP[$lB][4] & @CRLF)
    ;mgConsoleWrite("line a = " & $lA & ", line b = " & $lb & @CRLF)
    $Corner = _IntersectionLineLine($aP[$lA][1], $aP[$lA][2], $aP[$lA][3], $aP[$lA][4], $aP[$lB][1], $aP[$lB][2], $aP[$lB][3], $aP[$lB][4])
    mgConsoleWrite("end meet at" & $aP[$lA][3] & ', ' & $aP[$lA][4] & ', ' & "or using other line = " & $aP[$lB][1] & ', ' & $aP[$lB][2] & @CRLF)
    mgConsoleWrite("corner of intersection is at " & $Corner[0] & ', ' & $Corner[1] & @CRLF)
    $sweepab = _AngleBetweenStLines($aP[$lA][3], $aP[$lA][4], $aP[$lA][1], $aP[$lA][2], $aP[$lB][1], $aP[$lB][2], $aP[$lB][3], $aP[$lB][4])
    mgConsoleWrite("angle between = " & $sweepab & @CRLF)
    If $sweepab = 0 Or $sweepab = 180 Then Return -5

    ;calc centre of circle
    ;angle of line A
    ;mgConsoleWrite("159<--------------------------" & @CRLF)
    ;$Alpha = _AngleFromPts($aP[$lA][1], $aP[$lA][2], $aP[$lA][3], $aP[$lA][4]);assumes path set
    $Alpha = _AngleFromPts($aP[$lA][3], $aP[$lA][4], $aP[$lA][1], $aP[$lA][2]);assumes path set then this is angle away from junction
    mgConsoleWrite("alpha = " & $Alpha & ", beta = "  & _AngleFromPts($aP[$lb][1], $aP[$lb][2], $aP[$lb][3], $aP[$lb][4])& @CRLF)
    ;dist from corner to arc centre
    $h = Abs($Rad / _sinD(Abs($sweepab) / 2))
    ;mgConsoleWrite("$Corner[0] = " & $h & @CRLF)

    ;we don't know if h should be +ve or -ve so try positive  first
    $temp = $Alpha + $sweepab / 2
    $Cx = $Corner[0] + $h * _cosD(_SetAngle($temp))
    ; $temp = $Alpha + $sweepab / 2
    $Cy = $Corner[1] + $h * _sinD(_SetAngle($temp))
    mgConsoleWrite("cx, cy = " & $Cx & ', ' & $Cy & @CRLF)
    ;mgConsoleWrite("166<--------------------------" & @CRLF)
    ;where does arc meet line A
    $TouchA = _NearestPtOnLine($Cx, $Cy, $aP[$lA][1], $aP[$lA][2], $aP[$lA][3], $aP[$lA][4])
    ;mgConsoleWrite("373:TouchA[0] = " & $toucha[0] & "TouchA[1] = " & $toucha[1] & @CRLF)
    #region Is $TouchA within the corner and far end of A
    ;first find which end of A is the far end
    $EndAchange = 0
    $farA = 3

    If _LineLength($Corner[0], $Corner[1], $aP[$lA][1], $aP[$lA][2]) > _LineLength($Corner[0], $Corner[1], $aP[$lA][3], $aP[$lA][4]) Then
        $EndAchange = 2
        $farA = 1
    EndIf

    #cs
        $insideA = True
        If $aP[$lA][1] <> $aP[$lA][3] Then ;if line is not vertical
        If $TouchA[0] < min($Corner[0], $aP[$lA][$farA]) Or $TouchA[0] > max($Corner[0], $aP[$lA][$farA]) Then $insideA = False
        Else ;check the y coords insteadIf $TouchA[0] < min($aP[$lA][1], $aP[$lA][3]) Or $TouchA[0] > max($aP[$lA][1], $aP[$lA][3]) Then $insideA = False
        If $TouchA[1] < min($Corner[1], $aP[$lA][$farA + 1]) Or $TouchA[1] > max($Corner[1], $aP[$lA][$farA + 1]) Then $insideA = False
        EndIf
    #ce
#cs 22 may
    ;have we got the right side for the arc centre?
    if ($TouchA[0] - $Corner[0] < 0) <> ($aP[$lA][$farA] - $Corner[0] < 0) Or _
            ($TouchA[1] - $Corner[1] < 0) <> ($aP[$lA][$farA + 1] - $Corner[1] < 0) Then;$h should be -ve
        $Cx = $Corner[0] - $h * _cosD($Alpha + $sweepab / 2)
        $Cy = $Corner[1] - $h * _sinD($Alpha + $sweepab / 2)
        $TouchA = _NearestPtOnLine($Cx, $Cy, $aP[$lA][1], $aP[$lA][2], $aP[$lA][3], $aP[$lA][4])
    EndIf
#ce 22 may
    ;make sure the line is not too short to fit the arc so
    $insideA = True
    If $aP[$lA][1] <> $aP[$lA][3] Then ;if line is not vertical
        If $TouchA[0] < min($Corner[0], $aP[$lA][$farA]) Or $TouchA[0] > max($Corner[0], $aP[$lA][$farA]) Then $insideA = False
    Else ;check the y coords insteadIf $TouchA[0] < min($aP[$lA][1], $aP[$lA][3]) Or $TouchA[0] > max($aP[$lA][1], $aP[$lA][3]) Then $insideA = False
        If $TouchA[1] < min($Corner[1], $aP[$lA][$farA + 1]) Or $TouchA[1] > max($Corner[1], $aP[$lA][$farA + 1]) Then $insideA = False
    EndIf
    If $insideA = False Then Return -3


    ;find far end of line A


    ;if contact of arc is beyond end of line away from intersection then can't fit
    If _linelength($Corner[0], $Corner[1], $TouchA[0], $TouchA[1]) > _LineLength($Corner[0], $Corner[1], $aP[$lA][$farA], $aP[$lA][$farA + 1]) Then Return -31



    ;now set line B
    $TouchB = _NearestPtOnLine($Cx, $Cy, $aP[$lB][1], $aP[$lB][2], $aP[$lB][3], $aP[$lB][4])
    ;mgConsoleWrite("388:TouchB[0] = " & $touchB[0] & "TouchB[1] = " & $touchb[1] & @CRLF)
    $temp = _LineLength($Corner[0], $Corner[1], $aP[$lB][1], $aP[$lB][2])
    $temp2 = _LineLength($Corner[0], $Corner[1], $aP[$lB][3], $aP[$lB][4])
    ;mgConsoleWrite("length to end1 of line a = " & $temp & @CRLF)
    ;mgConsoleWrite("length to ther end = " & $temp2 & @CRLF)
    If $temp > _LineLength($Corner[0], $Corner[1], $aP[$lB][3], $aP[$lB][4]) Then
        ;if contact of arc is beyond end of line away from intersection then can't fit
        If _linelength($Corner[0], $Corner[1], $TouchB[0], $TouchB[1]) > $temp Then Return -4
        $EndBchange = 2
    Else
        If _linelength($Corner[0], $Corner[1], $TouchB[0], $TouchB[1]) > _LineLength($Corner[0], $Corner[1], $aP[$lB][3], $aP[$lB][4]) Then Return -4

        $EndBchange = 0
    EndIf

    ;all fits so adjust line ends
    $aP[$lA][1 + $EndAchange] = $TouchA[0]
    $aP[$lA][2 + $EndAchange] = $TouchA[1]

    $aP[$lB][1 + $EndBchange] = $TouchB[0]
    $aP[$lB][2 + $EndBchange] = $TouchB[1]

    ;calc circle info
    ;first insert a new line into shape
    ReDim $aP[$aP[0][0] + 2][$LINECOLS]

    If $lA = $aP[0][0] Then
        $ARcN = $aP[0][0] + 1
    Else
        $ARcN = $lB;$lines Lb and above will be shifted up and the arc will be in position $lB
        For $n = $aP[0][0] To $lB Step -1
            For $j = 0 To 5
                $aP[$n + 1][$j] = $aP[$n][$j]
            Next
        Next
    EndIf
    ;mgConsoleWrite("215<--------------------------" & @CRLF)
    $aP[$ARcN][0] = 2
    $aP[$ARcN][1] = $Cx
    $aP[$ARcN][2] = $Cy
    $aP[$ARcN][3] = $Rad
    ;mgConsoleWrite($Cx & ', ' & $Cy & ', ' & $TouchA[0] & ', ' & $TouchA[1] & @CRLF)
    $aP[$ARcN][4] = _AngleFromPts($Cx, $Cy, $TouchA[0], $TouchA[1])
    ;mgConsoleWrite("221<--------------------------" & @CRLF)
    $aP[$ARcN][5] = _SweepVia($aP[$ARcN][4], _AngleFromPts($Cx, $Cy, $TouchB[0], $TouchB[1]), _AngleFromPts($Cx, $Cy, $Corner[0], $Corner[1]))

    $aP[0][0] += 1;we have 1 extra line now

    Return 0;succes

EndFunc   ;==>_Shape_MakeRadiusCorner

;======= _Shape_CreateParallelCopy ===================
;creates a copy parallel to $aLines inside or out
;$aLines must be a shape array
;assumes the margin is less than the radius of the smallest internal arc
;returns an array of the new shape
;if margin is > 0 then inner copy
;if $margin < 0 then outer copy
;NB if the shape is not closed or if consecutive lines do not meet then this func will not create
;  the shape copy and returns the first line number found which doesn't meet the next times -1.
;Version 2 - Corrected error in joining straight lines to arcs incorrectly when the straight line is not at a tangent to the arc
;prev version in baks as LineArcShapes_old1.au3"
;RETURNS - on success the line array for the parallel path with @error = 0
;        - on failure because the path cannot be made a 1D array with the line numbers which cannot be reached by the tool,
;          @extended = the number of problem lines and @error = -1
;         Sharp internal straight line corners cannot be reached by a round tool but these are not counted as error lines provided the tool can at least touch
;         each of the two sides.
; Author martin
;Problem to overcome  [Planed solutions see LinearCShapes.txt (Not public)]
;1)when the raius of the tool is the same as the raius of the internal corner this function should cope with it but at the moment it fails because I haven't
; got a way to deal with a radius of zero yet.
;2)the parallel path to joining lines could never join and so finding the cross-over points as is done here can fail. The solutions are in my head.
;

Func _Shape_CreateParallelCopy($aLines, $margin)
    Local $aNewLines[UBound($aLines, 1)][$LINECOLS];the new array for the parallel copy
    Local $n, $posx, $posy, $use, $Alpha, $x1, $y1, $langle1, $langle2
    Local $beta, $halfAngle, $it, $SplitAng, $Junction[4], $posends[2], $marginC
    Local $plines, $isin, $dist, $xy, $newRad, $newRad2, $bpos1, $bpos2, $ccDist, $f
    Local $angleBetween, $halfway, $startAngle, $endAngle, $CorrectAngle
    Local $Errorlines[$aLines[0][0]], $errorLineCount = 0
    Local $cond1, $cond2, $cond3, $temp

    ;we move round the shape changing the end point of a line and the start point of the next. That will cause a problem when the first line is an arc
    ;because we change the end angle befor we change the start angle. So we have to be aware of dealing with the first line when we deal with the last.

    ;see if there are any arcs with a rad which equals the tool rad (This is a temp fix)
    For $n = 1 To UBound($aLines) - 1
        If $aLines[$n][0] = 2 Then
            _SetAngle($aLines[$n][4]);shouldn't be needed but untill I track down which operation is setting values like 673 occasionally it will stay
            If Round(_Shape_GetNewRadius($aLines, $n, $margin), 3) = 0 Then
                If $margin > 0 Then;temp fiddle because my machine will not be this accurate and it won't matter
                    $margin -= 0.01;my router will only need an accuracy of +/- 0.2 mm so no one will notice!
                Else
                    $margin += 0.01
                EndIf
                ExitLoop
            EndIf
        EndIf

    Next


    $aNewLines[0][0] = $aLines[0][0]
    For $n = 1 To UBound($aLines) - 1
        ; mgConsoleWrite("line " & $n & "  =============================================================================================== line " & $n & @CRLF)
        ;mgConsoleWrite("process line " & $n & " for margin = " & $margin & @CRLF)
        Switch $aLines[$n][0] ;line type
            Case 1;straight line
                $aNewLines[$n][0] = 1
                ;which is the next line
                If $n < $aLines[0][0] Then
                    $it = $n + 1
                Else
                    $it = 1;
                EndIf

                ;if the start of line is already too close to next line then we cannot make path
                If $n > 1 Then;we have already set the start of this line when we did the last
                    $cond1 = Abs(_Shape_DistToLine($aNewLines[$n][1], $aNewLines[$n][2], $aLines, $it) - Abs($margin)) < 0.001
                    $cond2 = _Shape_IsPointInside($aNewLines[$n][1], $aNewLines[$n][2], $aLines, True) <> ($margin > 0)
                    If $cond1 Or $cond2 Then
                        $Errorlines[$errorLineCount] = $n
                        $errorLineCount += 1
                        _ArrayDisplay($aLines)
                        mgConsoleWrite("dist from end of line " & $n & " to line " & $it & " = " & _Shape_DistToLine($aNewLines[$n][1], $aNewLines[$n][2], $aLines, $it) & @CRLF)
                        mgConsoleWrite("start of line inside shape = " & _Shape_IsPointInside($aNewLines[$n][1], $aNewLines[$n][2], $aLines) & @CRLF)
                        mgConsoleWrite("774:Doesn't fit at line " & $n & ". " & $cond1 & ', ' & $cond2 & @CRLF)
                    EndIf

                EndIf

                ;check that start of next line is same as end of this one
                If $aLines[$it][0] = 2 Then;if an arc
                    $Junction[2] = $aLines[$it][1] + $aLines[$it][3] * Cos($aLines[$it][4] * $Deg2Rad)
                    ;mgConsoleWrite("jn 2 x = " & $Junction[2] & @CRLF)
                Else
                    $Junction[2] = $aLines[$it][1]
                EndIf

                If Abs($Junction[2] - $aLines[$n][3]) > 0.01 Then

                    ;_ArrayDisplay($aLines, "fail at 192")
                    Return -$n;end of $n line not same as start of next line
                EndIf


                If $aLines[$it][0] = 2 Then
                    $Junction[3] = $aLines[$it][2] + $aLines[$it][3] * Sin($aLines[$it][4] / $Rad2Deg)

                Else
                    $Junction[3] = $aLines[$it][2]
                EndIf

                If Abs($Junction[3] - $aLines[$n][4]) > 0.01 Then
                    ;mgConsoleWrite("Error 189" & ', ' & $Junction[3] & " <> " & $aLines[$n][4] & " line " & $n & @CRLF)
                    _ArrayDisplay($aLines, "line end error? 201")
                    Return -$n
                EndIf


                If $aLines[$it][0] = 2 Then;if next line is an arc
                    ; mgConsoleWrite("next line is No. " & $it & " (arc)" & @CRLF)
                    $aNewLines[$it][1] = $aLines[$it][1]
                    $aNewLines[$it][2] = $aLines[$it][2]
                    $plines = _GetParallelStLines($aLines[$n][1], $aLines[$n][2], $aLines[$n][3], $aLines[$n][4], $margin)
                    ;try one end point and see if it is inside or outside the shape

                    ;use the mid point of the line because for sharp angles points either side the end of a line could both be inside ot both outside
                    $isin = _Shape_IsPointInside(($plines[0] + $plines[2]) / 2, ($plines[1] + $plines[3]) / 2, $aLines)
                    ; mgConsoleWrite("149: " & ($plines[0] + $plines[2]) / 2 & ', ' & ($plines[1] + $plines[3]) / 2 & " isin = " & $isin & @CRLF)
                    ;calc the dist from arc centre to the parallel line
                    ;first get nearest pt (rather than get distanceto line) because then we can get angle to nearest pt
                    If $isin = ($margin > 0) Then
                        $xy = _NearestPtOnLine($aLines[$it][1], $aLines[$it][2], $plines[0], $plines[1], $plines[2], $plines[3])
                        ;$aNewLines[$n][3] = $plines[2]
                        ;$aNewLines[$n][4] = $plines[3]
                    Else
                        $xy = _NearestPtOnLine($aLines[$it][1], $aLines[$it][2], $plines[4], $plines[5], $plines[6], $plines[7])
                        ;$aNewLines[$n][3] = $plines[6]
                        ;  $aNewLines[$n][4] = $plines[7]
                    EndIf
                    $dist = _LineLength($aLines[$it][1], $aLines[$it][2], $xy[0], $xy[1])

                    $dist = Round($dist, $PREC)
                    ; mgConsoleWrite("164: dist = " & $dist & @CRLF)
                    ;calc angle between line from centre of arc to point on arc where line crosses, and the line at rt angles to the chosen parallel st line
                    ;is the margin inside the arc or outside? So try a point halfway round arc at R - margin
                    $isin = _Shape_IsPointInside($aLines[$it][1] + ($aLines[$it][3] + $margin) * Cos(($aLines[$it][4] + $aLines[$it][5] / 2) * $Deg2Rad), _
                            $aLines[$it][2] + ($aLines[$it][3] + $margin) * Sin(($aLines[$it][4] + $aLines[$it][5] / 2) * $Deg2Rad), $aLines)
                    ;mgConsoleWrite("line " & $n & "isin R+M = " & $isin & ', margin = ' & $margin & @CRLF)
                    If ($isin = ($margin > 0)) Then
                        ;mgConsoleWrite("167: " & $aLines[$it][3] & ', ' & $margin & @CRLF)
                        $newRad = Round($aLines[$it][3] + $margin, $PREC)
                    Else
                        $newRad = Round($aLines[$it][3] - $margin, $PREC)

                    EndIf
                    ;mgConsoleWrite("dist, newrad = " & $dist & ', ' & $newRad & @CRLF)

                    If $newRad = 0 Then
                        $aNewLines[$it][3] = 0
                    Else

                        $Alpha = _ACosRound($dist, $newRad)

                        ;angle from centre to cross-over pt is either + or - alpha
                        $bpos1 = _AngleFromPts($aLines[$it][1], $aLines[$it][2], $xy[0], $xy[1]) - $Alpha * $Rad2Deg
                        _SetAngle($bpos1)
                        $bpos2 = $bpos1 + $Alpha * 2 * $Rad2Deg
                        _SetAngle($bpos2)
                        $temp = $aLines[$it][4]
                        _SetAngle($temp)
                        ;I think the correct new start angle will be the one nearer to the old start angle
                        If _Anglesweep($temp, $bpos1) < _AngleSweep($temp, $bpos2) Then
                            $beta = $bpos1
                        Else
                            $beta = $bpos2
                        EndIf
                        ;end of last line is at the crossover pt
                        $aNewLines[$n][3] = $aLines[$it][1] + $newRad * Cos($beta * $Deg2Rad)
                        $aNewLines[$n][4] = $aLines[$it][2] + $newRad * Sin($beta * $Deg2Rad)

                        $aNewLines[$it][3] = $newRad

                        ;get old end angle of next line in case $it = 1 because we must then make sure that the end angle is kept the same
                        $endAngle = $aLines[1][4] + $aNewLines[1][5]

                        $aNewLines[$it][4] = $beta;start angle. Sweep is calculated when we deal with this line
                        If $it = 1 Then ;we must correct the sweep to get back to the same end angle
                            ; mgConsoleWrite("end angle of line 1 first set to " & $endAngle & @CRLF)
                            $aNewLines[$it][5] = $endAngle - $aNewLines[$it][4]
                            ;mgConsoleWrite("end angle of line 1 now set to " & $aNewLines[$it][5] & @CRLF)
                        EndIf
                    EndIf

                Else;it's a st line next ie $aLines[$it][0] = 1
                    ;this whole else section needs to be rewritten. Try shape preroundedCorners with 20mm dia tool and solid plate style

                    $langle1 = _Shape_GetStLineAngle($aLines, $n, 1);array lines, line $n, end

                    $langle2 = _Shape_GetStLineAngle($aLines, $it, 0);lines, n+1,start

                    $SplitAng = ($langle1 + $langle2) / 2;NB this coud be 180 out

                    ;calc margin pts
                    $marginC = $margin / _SinD(-$langle1 + $SplitAng);the margin dist to corner#
                    $posends[0] = $Junction[2] + $marginC * _CosD($SplitAng)
                    $posends[1] = $Junction[3] + $marginC * _SinD($SplitAng)
                    If _Shape_IsPointInside($posends[0], $posends[1], $aLines) <> ($margin > 0) Then
                        $posends[0] = $Junction[2] - $marginC * _CosD($SplitAng)
                        $posends[1] = $Junction[3] - $marginC * _SinD($SplitAng)
                    EndIf

                    $aNewLines[$n][3] = $posends[0]
                    $aNewLines[$n][4] = $posends[1]

                    ; st line set new start pts for next line
                    $aNewLines[$it][1] = $posends[0]
                    $aNewLines[$it][2] = $posends[1]

                EndIf

                If $it = 1 Then;we have changed the start of line 1 so now we can check it is ok with line 2
                    If _Shape_DistToLine($aNewLines[$it][1], $aNewLines[$it][2], $aLines, 2) < Abs($margin) Or _
                            _Shape_IsPointInside($aNewLines[$it][1], $aNewLines[$it][2], $aLines) <> $margin > 0 Then
                        ; mgConsoleWrite("225:Doesn't fit at line 1" & @CRLF)
                        $Errorlines[$errorLineCount] = $it
                        $errorLineCount += 1
                    EndIf
                EndIf
                ;_ArrayDisplay($aNewLines)
            Case 2 ; arc

                $aNewLines[$n][0] = 2
                $aNewLines[$n][1] = $aLines[$n][1];same arc centre
                $aNewLines[$n][2] = $aLines[$n][2]
                ;$aNewLines[$n][4] = $aLines[$n][4]

                ;which is the next line
                If $n < $aLines[0][0] Then
                    $it = $n + 1
                Else
                    $it = 1;
                EndIf


                If $n > 1 Then ;check the start of this line isn't too close to next, or join isn't wrong side
                    If _Shape_DistToLine($aNewLines[$n][1] + $aNewLines[$n][3] * Cos($aNewLines[$n][4] / $Rad2Deg), $aNewLines[$n][2] + $aNewLines[$n][3] * Sin($aNewLines[$n][4] / $Rad2Deg), _
                            $aLines, $it) < Abs($margin) Or _
                            _Shape_IsPointInside($aNewLines[$n][1] + $aNewLines[$n][3] * Cos($aNewLines[$n][4] / $Rad2Deg), _
                            $aNewLines[$n][2] + $aNewLines[$n][3] * Sin($aNewLines[$n][4] / $Rad2Deg), $aLines) <> ($margin > 0) Then
                        ; mgConsoleWrite("263:Cannot fit at arc line " & $n & @CRLF)
                        $Errorlines[$errorLineCount] = $n
                        $errorLineCount += 1
                    EndIf
                EndIf
                #region check line ends meet
                ;get end coords of arc
                $Junction[0] = $aLines[$n][1] + $aLines[$n][3] * Cos(($aLines[$n][4] + $aLines[$n][5]) / $Rad2Deg)
                $Junction[1] = $aLines[$n][2] + $aLines[$n][3] * Sin(($aLines[$n][4] + $aLines[$n][5]) / $Rad2Deg)
                ;check that start of next line is same as end of this one
                If $aLines[$it][0] = 2 Then
                    $Junction[2] = $aLines[$it][1] + $aLines[$it][3] * Cos($aLines[$it][4] / $Rad2Deg)
                Else
                    $Junction[2] = $aLines[$it][1]
                EndIf
                If Abs($Junction[2] - $Junction[0]) > 0.01 Then
                    ;mgConsoleWrite("Error 240.  " & $Junction[2] & "<>" & $Junction[0] & 'at line ' & $n & @CRLF)
                    ;_ArrayDisplay($aLines, "fail at 257")
                    Return -$n;end of $n line not same as start of next line
                EndIf

                If $aLines[$it][0] = 2 Then
                    $Junction[3] = $aLines[$it][2] + $aLines[$it][3] * Sin($aLines[$it][4] / $Rad2Deg)
                Else
                    $Junction[3] = $aLines[$it][2]
                EndIf
                If Abs($Junction[3] - $Junction[1]) > 0.01 Then
                    ; mgConsoleWrite("Error 244, line " & $n & '  ' & $Junction[3] & '<>' & $Junction[1] & @CRLF)
                    ;_ArrayDisplay($aLines, "fail at 267")
                    Return -$n;end of $n line not same as start of next line

                EndIf

                #endregion check line ends meet
                ;now we know lines join ok
                ;find new radius

                ;is the margin inside the arc or outside? So try a point halfway round arc at R + margin
                $halfway = ($aLines[$n][4] + $aLines[$n][5] / 2) * $Deg2Rad
                $isin = _Shape_IsPointInside($aLines[$n][1] + ($aLines[$n][3] + $margin) * Cos($halfway), _
                        $aLines[$n][2] + ($aLines[$n][3] + $margin) * Sin($halfway), $aLines)
                If ($isin = ($margin > 0)) Then
                    $newRad = Round($aLines[$n][3] + $margin, $PREC)
                Else
                    $newRad = Round($aLines[$n][3] - $margin, $PREC)
                EndIf
                $aNewLines[$n][3] = $newRad

                If $newRad < 0 Then
                    mgConsoleWrite("318:Cannot fit at too small an arc line " & $n & @CRLF)
                    $Errorlines[$errorLineCount] = $n
                    $errorLineCount += 1
                EndIf

                If $aLines[$it][0] = 2 Then ; if another arc follows

                    ;now same with next line
                    ; $newRad2 = _SHape_GetNewRad(
                    $halfway = ($aLines[$it][4] + $aLines[$it][5] / 2) * $Deg2Rad
                    $isin = _Shape_IsPointInside($aLines[$it][1] + ($aLines[$it][3] + $margin) * Cos($halfway), _
                            $aLines[$it][2] + ($aLines[$it][3] + $margin) * Sin($halfway), $aLines)
                    If ($isin = ($margin > 0)) Then
                        $newRad2 = Round($aLines[$it][3] + $margin, $PREC)
                    Else
                        $newRad2 = Round($aLines[$it][3] - $margin, $PREC)
                    EndIf

                    $aNewLines[$it][3] = $newRad2

                    ;calc dist between arc centres

                    $ccDist = _LineLength($aLines[$n][1], $aLines[$n][2], $aLines[$it][1], $aLines[$it][2])
                    ;in the triangle ccDist, newrad, newrad2 we drop a line from joint of rads to ccdist at 90 to ccdist. The new line is h and the triangles are
                    ;newrad,h,f  and newrad2,h,(ccdist-f)
                    $f = ($newRad ^ 2 - $newRad2 ^ 2 + $ccDist ^ 2) / (2 * $ccDist)
                    ;so end angle for line $n is line angle ccdist +/- angle between ccdist and newrad
                    $angleBetween = _ACosRound($f, $newRad) * $Rad2Deg
                    $langle1 = _AngleFromPts($aLines[$n][1], $aLines[$n][2], $aLines[$it][1], $aLines[$it][2]) - $angleBetween
                    $langle2 = $langle1 + 2 * $angleBetween
                    _setAngle($langle1)
                    _SetAngle($langle2)
                    ;assume correct end angl is one nearest old end angle
                    ; mgConsoleWrite("angle1 = " & $langle1 & ", langle2 = " & $langle2 & @CRLF)
                    If _AngleSweep($aLines[$n][4] + $aLines[$n][5], $langle1) < _AngleSweep($aLines[$n][4] + $aLines[$n][5], $langle2) Then
                        $CorrectAngle = $langle1
                        ;mgConsoleWrite("chose 1" & @CRLF)
                    Else
                        $CorrectAngle = $langle2
                        ;mgConsoleWrite("chose 2" & @CRLF)
                    EndIf
                    ;try new approach to get correct sweep direction
                    If $n = 1 Then ;the start angle won't be set untill we do the last line
                        $aNewLines[$n][5] = _SweepVia($aLines[$n][4], $CorrectAngle, $aLines[$n][4] + $aLines[$n][5] / 2)
                    Else;the start angle was calculated when we did the previous line
                        $aNewLines[$n][5] = _SweepVia($aNewLines[$n][4], $CorrectAngle, $aLines[$n][4] + $aLines[$n][5] / 2)
                    EndIf
                    ;mgConsoleWrite("sweep said " & $aNewLines[$n][5] & @CRLF)
                    ; end of new approach - seems to work ok so make it into a func _SetSweepVia


                    ;If ($aNewLines[$n][5] > 0) <> ($aLines[$n][5] > 0) then $aNewLines[$n][5] *= -1

                    ;so start angle for line $it is line angle ccdist +/- angle between ccdist and newrad2
                    $angleBetween = _ACosRound(($ccDist - $f), $newRad2) * $Rad2Deg
                    $langle1 = _AngleFromPts($aLines[$it][1], $aLines[$it][2], $aLines[$n][1], $aLines[$n][2]) - $angleBetween
                    $langle2 = $langle1 + 2 * $angleBetween
                    _setAngle($langle1)
                    _SetAngle($langle2)
                    ;assume correct start angl is one nearest old start angle
                    ;$startAngle = $aLines[$N][4] + $aNewLines[$n][5];for line 1 in case $it = 1

                    If _AngleSweep($aLines[$it][4], $langle1) < _AngleSweep($aLines[$it][4], $langle2) Then
                        $aNewLines[$it][4] = $langle1; - $aLines[1][4]
                    Else
                        $aNewLines[$it][4] = $langle2; - $aLines[1][4]
                    EndIf

                    If $it = 1 Then ;we must correct the sweep to get back to the same end angle
                        $aNewLines[$it][5] = $endAngle - $aNewLines[$it][4]
                    EndIf
                Else ;it's a st line

                    ;get angle of line $it
                    ; $angle = _AngleFromPts($aLines[$it][1], $aLines[$it][2], $aLines[$it][3], $aLines[$it][4])

                    ;first get new st line
                    $plines = _GetParallelStLines($aLines[$it][1], $aLines[$it][2], $aLines[$it][3], $aLines[$it][4], $margin)
                    ;try one mid point and see if it is inside or outside the shape

                    ;use the mid point of the line because for sharp angles points either side the end of a line could both be inside ot both outside
                    $isin = _Shape_IsPointInside(($plines[0] + $plines[2]) / 2, ($plines[1] + $plines[3]) / 2, $aLines)
                    ;		if $it =
                    ;calc the dist from arc centre to the parallel line
                    ;first get nearest pt (rather than get distance to line) because then we can get angle to nearest pt

                    If $isin = ($margin > 0) Then
                        $xy = _NearestPtOnLine($aLines[$n][1], $aLines[$n][2], $plines[0], $plines[1], $plines[2], $plines[3])
                        ;$aNewLines[$n][3] = $plines[2]
                        ;$aNewLines[$n][4] = $plines[3]
                    Else
                        $xy = _NearestPtOnLine($aLines[$n][1], $aLines[$n][2], $plines[4], $plines[5], $plines[6], $plines[7])
                        ;$aNewLines[$n][3] = $plines[6]
                        ;  $aNewLines[$n][4] = $plines[7]
                    EndIf

                    ;get closest distance to line
                    ; $dist = _DistToStLine($aLines[$n][1], $aLines[$n][2], $aLines[$it][1], $aLines[$it][2], $aLines[$it][3], $aLines[$it][4])
                    $dist = _LineLength($xy[0], $xy[1], $aLines[$n][1], $aLines[$n][2])
                    ;already got new radius of arc for line $n

                    ; If $dist > $newRad Then mgConsoleWrite("line " & $n & ", next line nearest pt is at dist " & $dist & @CRLF)

                    ;get angle between line from arc centre to position where line crosses arc and the line from arc centre and the nearest pt on the st line
                    $angleBetween = _ACosRound(Round($dist, 10), $newRad) * $Rad2Deg
                    ; mgConsoleWrite("angle centre arc to next st line is " & $angleBetween & @CRLF)
                    ; $xy = _NearestPtOnLine($aLines[$n][1], $aLines[$n][2], $aLines[$it][1], $aLines[$it][2], $aLines[$it][3], $aLines[$it][4])
                    $langle1 = _AngleFromPts($aLines[$n][1], $aLines[$n][2], $xy[0], $xy[1]) - $angleBetween
                    $langle2 = $langle1 + 2 * $angleBetween
                   ; If $n = 1 Then mgConsoleWrite("pos angles are  " & $langle1 & ', ' & $langle2 & @CRLF)
                    _SetAngle($langle1)
                    _SetAngle($langle2)
                    $temp = $aLines[$n][4] + $aLines[$n][5];end angle of arc
                    ;_setAngle($temp);no need because _AngleSweep takes care of it
                    ;assume correct end angl is one nearest old end angle
                    ;if $n = 11 then mgConsoleWrite("end angle = " & $temp & ", choose from " & $langle1 & ', ' & $langle2 & @CRLF)

                    If _AngleSweep($temp, $langle1) < _AngleSweep($temp, $langle2) Then
                        $CorrectAngle = $langle1
                    Else
                        $CorrectAngle = $langle2
                    EndIf
					;ConsoleWrite("chose angle " & $CorrectAngle & " as closest to " & $ & @CRLF)

                    ;now we have start and end angles but do we go cw or ccw?
                    ;Well we know that the sweep must go through the angle in the middel of the original arc so use _angleVia
                    ;mgConsoleWrite("431:" & $aNewLines[$n][4] & ', ' & $CorrectAngle & ', ' & $aLines[$n][4] + $aLines[$n][5] / 2 & @CRLF)
                    If $n = 1 Then
                        $aNewLines[$n][5] = _SweepVia($aLines[$n][4], $CorrectAngle, $aLines[$n][4] + $aLines[$n][5] / 2)
                    Else
                        $aNewLines[$n][5] = _SweepVia($aNewLines[$n][4], $CorrectAngle, $aNewLines[$n][4] + $aLines[$n][5] / 2)
                    EndIf
                    If $n = 1 Then mgConsoleWrite("first time the end angle of line 1 is set to " & $aNewLines[$n][5] & @CRLF)
                    ;mgConsoleWrite("433:" & @CRLF)

                    ;If $aLines[$n][5] < 0  and $aNewLines[$n][5] > 0 Then $aNewLines[$n][5] -= 360
                    ;If $aLines[$n][5] > 0  and $aNewLines[$n][5] < 0 Then $aNewLines[$n][5] += 360

                    If $n = 1 Then;then start of line hasn't been calculated yet
                        $temp = $aLines[$n][4]
                    Else
                        $temp = $aNewLines[$n][4]
                    EndIf

                    $aNewLines[$it][1] = $aNewLines[$n][1] + $aNewLines[$n][3] * _CosD($temp + $aNewLines[$n][5])
                    $aNewLines[$it][2] = $aNewLines[$n][2] + $aNewLines[$n][3] * _SinD($temp + $aNewLines[$n][5])
                    ; mgConsoleWrite("440:" & @CRLF)
                EndIf
                ;mgConsoleWrite("487:" & @CRLF)

                If $errorLineCount = 0 Or $Errorlines[$errorLineCount - 1] <> 1 Then
                    If $it = 1 Then ;check the start of this line isn't now too close to next, that next rad isn't too small and joint is correct side is line
                        If _Shape_DistToLine($aNewLines[$it][1] + $aNewLines[$n][3] * Cos($aNewLines[$it][4] / $Rad2Deg), $aNewLines[$n][2] + $aNewLines[$it][3] * Sin($aNewLines[$it][4] / $Rad2Deg), _
                                $aLines, 2) < Abs($margin) Or $aNewLines[$it][3] < 0 Or _
                                _Shape_IsPointInside($aNewLines[$it][1] + $aNewLines[$n][3] * Cos($aNewLines[$it][4] / $Rad2Deg), $aNewLines[$n][2] + $aNewLines[$it][3] * Sin($aNewLines[$it][4] / $Rad2Deg), $aLines) _
                                 <> $margin > 0 Then
                            mgConsoleWrite("479:Cannot fit at line 1" & @CRLF)
                            $Errorlines[$errorLineCount] = $it
                            $errorLineCount += 1
                        EndIf
                    EndIf
                EndIf
                ; EndIf
        EndSwitch
        ;_ArrayDisplay($aNewLines)
    Next
    ;_ArrayDisplay($aNewLines, "parallel copy")

    If $errorLineCount > 0 Then
        SetError(-1, $errorLineCount, $Errorlines)
    EndIf

    Return $aNewLines

EndFunc   ;==>_Shape_CreateParallelCopy



; ==================== _IntersectionLineLine =====================================
;Returns an array of 2 elements giving the point of intersection
Func _IntersectionLineLine($Ax1, $Ay1, $Ax2, $Ay2, $Bx1, $By1, $Bx2, $By2)

    Local $Res[2], $mA, $kA, $mB, $kB, $x1, $x2, $y1, $y2
    Local $useA, $useB

    ;parallel lines don't meet
    If _AngleFromPts($Ax1, $Ay1, $Ax2, $Ay2) = _AngleFromPts($Bx1, $By1, $Bx2, $By2) Then Return 0

    ;using y = m*x + k
    If Abs($Ax2 - $Ax1) < $ShapeTOLERANCE Then
        $x1 = $Ax1
        mgConsoleWrite("linje a is vertical" & @CRLF)
    ElseIf $Ay2 = $Ay1 Then
        $y1 = $Ay1
    Else
        $mA = ($Ay2 - $Ay1) / ($Ax2 - $Ax1)
        $kA = $Ay1 - $mA * $Ax1
    EndIf

    If Abs($Bx2 - $Bx1) < $ShapeTOLERANCE Then
        $x2 = $Bx1
    ElseIf $By2 = $By1 Then
        $y2 = $By1
    Else
        $mB = ($By2 - $By1) / ($Bx2 - $Bx1)
        $kB = $By1 - $mB * $Bx1
        mgConsoleWrite("$mB, $kb = " & $mB & ', ' & $kB & @CRLF)
    EndIf


    ;at intersection $ma*$x + $kA = $mB*$x + $kB
    If IsNumber($x1) Then ;vertical line
        $Res[0] = $x1
        If IsNumber($y2) Then ;horizontal line
            $Res[1] = $y2

        Else
            $Res[1] = $mB * $x1 + $kB
            mgConsoleWrite("y pt = " & $Res[1] & @CRLF)
        EndIf
        Return $Res
    EndIf

    If IsNumber($y1) Then ;horizontal line
        $Res[1] = $y1
        If IsNumber($x2) Then ;vertical line
            $Res[0] = $x2
        Else
            $Res[0] = ($y1 - $kB) / $mB
        EndIf
        Return $Res
    EndIf

    If IsNumber($x2) Then ;vertical line
        $Res[0] = $x2
        $Res[1] = $mA * $x2 + $kA
        Return $Res
    EndIf

    If IsNumber($y2) Then ;horizontal line
        $Res[1] = $y2
        $Res[0] = ($y2 - $kA) / $mA
        Return $Res
    EndIf

    ;neither line is horizontal nor vertical
    $Res[0] = ($kB - $kA) / ($mA - $mB)
    $Res[1] = $mA * $Res[0] + $kA


    Return $Res

EndFunc   ;==>_IntersectionLineLine

;##################### _AngleBetweenStLines ############################################
;returns the angle between 2 lines but assuming that the angle of each line is the angle from
;x1,y1 to x2,y2. For example, if you want the angle between 2 lines which join at point Ptx,Pty then
;ensure that $Ax1,$Ay1 = Ptx,Pty and $Bx1,$By1 = Ptx,Pty

;example of use - to find the line between 2 others on which to centre a circle to make a radiused corner.
;Parameters $Ax1,$Ay1 the start of line 1 etc
;           $mode the return type.
;                if $mode = 0 then the result is always +ve.
;                if $mode = 1 (default) the result is the sweep from line A to line B
;If $mode = 1 and the lines are 180 degrees apart then the result is +180
Func _AngleBetweenStLines($Ax1, $Ay1, $Ax2, $Ay2, $Bx1, $By1, $Bx2, $By2, $mode = 1)
    Local $AngA, $AngB, $Between, $AB, $t1, $t2

    If $Ax1 = $Ax2 And $Ay1 = $Ay2 Then Return SetError(1, 0, '#.IND')
    If $Bx1 = $Bx2 And $By1 = $By2 Then Return SetError(2, 0, '#.IND')

    $AngA = _AngleFromPts($Ax1, $Ay1, $Ax2, $Ay2)

    $AngB = _AngleFromPts($Bx1, $By1, $Bx2, $By2)
    mgConsoleWrite("angles a, b = " & $AngA & ', ' & $AngB & @CRLF)

    $Between = Abs($AngB - $AngA)


    If $Between = 180 Then Return 180

    If $Between > 180 Then $Between = 360 - $Between
mgConsoleWrite("between angle = " & $between & @CRLF)
    If $mode <> 1 Then Return $Between

    $AB = $AngA + $Between
    mgConsoleWrite("will set $AB" & @CRLF)
	$t1 = _setangle($AB)
	$t2 = _SetAngle($AngB)
	mgconsolewrite("t1, t2 = " & $t1 & ', ' & $t2 & @CRLF)
    If abs(_SetAngle($AB)- _setangle($AngB)) <  $ShapeTOLERANCE Then Return $Between
    Return -$Between

EndFunc   ;==>_AngleBetweenStLines

;gets the minimum sweep from $AngA to $AngB
;if $mode = 0 then result is always +ve.
;if mode <> 0 then sweep is $AngB - $AngA
;$AngA, $AngB in degrees
;Result in degrees
Func _AngleSweep($AngA, $AngB, $mode = 0)
    Local $AB, $Between
    _SetAngle($AngA)
    _SetAngle($AngB)
    $Between = Abs($AngB - $AngA)

    If $Between = 180 Then Return 180

    If $Between > 180 Then $Between = 360 - $Between

    If $mode = 0 Then Return $Between

    $AB = $AngA + $Between
    ;mgConsoleWrite("will set $AB" & @CRLF)
    If _SetAngle($AB) = $AngB Then Return $Between
    Return -$Between

EndFunc   ;==>_AngleSweep



;================== _SweepVia ============================
;gets the correct sweep based on startAngle, EndAngle and some angle which must be 'passed' as we go from start to end.
;Returns the sweep in degrees
Func _SweepVia($startAngle, $endAngle, $ViaAngle)

    Local $Guess
    mgConsoleWrite("sweepvia given " & ', ' & $startAngle & ', ' & $endAngle & ', ' & $ViaAngle & @CRLF)
    mgConsoleWrite("stAng, EndAng, Via" & $startAngle & ', ' & $endAngle & ', ' & $ViaAngle & @CRLF)
    _setAngle($startAngle)
    _setAngle($endAngle)
    _SetAngle($ViaAngle)

    mgConsoleWrite("sweepvia set angles now " & ', ' & $startAngle & ', ' & $endAngle & ', ' & $ViaAngle & @CRLF)

    $Guess = $endAngle - $startAngle

    If $Guess = 0 Then Return SHowans(0, 360);not sure what else I can conclude but when I get problems I will know

    If _AngleInRange($ViaAngle, $startAngle, $Guess, False) Then Return showans(1, $Guess)

    ;$Guess was wrong so we were going round arc in wrong direction
    If $Guess > 0 Then
        Return showans(2, $Guess - 360);
    Else
        Return showans(3, $Guess + 360)
    EndIf


EndFunc   ;==>_SweepVia

Func showans($try, $A)
    ;mgConsoleWrite("stage = " & $try & ', ' & " ans = " & $a & @CRLF)
    Return $A
EndFunc   ;==>showans



;======================= _Shape_GetNewRadius =========================
;gets the new radius when a margin is given for a new shape. The radius could be smaller or larger
;depending on whether the arc is convex or concave and whether the margin is inside or outside
;Parameters
;          $aL the shape array
;          $n  the line number
;         $margin the margin
;          $precision the number of decimal places to round the result to.
; Returns the required radius
Func _Shape_GetNewRadius($aLines, $n, $margin, $precision = $PREC)
    Local $isin

    $isin = _Shape_IsPointInside($aLines[$n][1] + ($aLines[$n][3] + $margin) * Cos(($aLines[$n][4] + $aLines[$n][5] / 2) * $Deg2Rad), _
            $aLines[$n][2] + ($aLines[$n][3] + $margin) * Sin(($aLines[$n][4] + $aLines[$n][5] / 2) * $Deg2Rad), $aLines)
    If ($isin = ($margin > 0)) Then
        Return Round($aLines[$n][3] + $margin, $precision)
    Else
        Return Round($aLines[$n][3] - $margin, $precision)
    EndIf

EndFunc   ;==>_Shape_GetNewRadius






;========== _Shape_MirrorHor =========================
;returns a shape reflected left to right and in the same extents as the line array $aP
;Author: martin
Func _Shape_MirrorHor($aP)
    Local $n, $aM, $temp, $e1, $e2, $xShift
    $aM = $aP

    For $n = 1 To $aP[0][0]
        Switch $aP[$n][0]
            Case 1

                $aM[$n][1] *= -1
                $aM[$n][3] *= -1
            Case 2
                $aM[$n][1] *= -1
                $aM[$n][4] = 180 - $aM[$n][4]
                $aM[$n][5] *= -1
        EndSwitch
    Next
    $e1 = _Shape_GetExtents($aP)
    $e2 = _Shape_GetExtents($aM)

    $xShift = $e1[0] - $e2[0]
    For $n = 1 To $aP[0][0]
        Switch $aP[$n][0]
            Case 1

                $aM[$n][1] += $xShift
                $aM[$n][3] += $xShift
            Case 2
                $aM[$n][1] += $xShift
        EndSwitch
    Next
    Return $aM
EndFunc   ;==>_Shape_MirrorHor

;========== _Shape_MirrorVert =========================
;returns a shape reflected top to bottom and in the same extents as the line array $aP
;Author: martin
Func _Shape_MirrorVert($aP)
    Local $n, $aM, $temp, $e1, $e2, $yShift
    $aM = $aP

    For $n = 1 To $aP[0][0]
        Switch $aP[$n][0]
            Case 1
                $aM[$n][2] *= -1
                $aM[$n][4] *= -1
            Case 2
                $aM[$n][2] *= -1
                $aM[$n][4] = 360 - $aM[$n][4]
                $aM[$n][5] *= -1
        EndSwitch
    Next
    $e1 = _Shape_GetExtents($aP)
    $e2 = _Shape_GetExtents($aM)

    $yShift = $e1[1] - $e2[1]
    For $n = 1 To $aP[0][0]
        Switch $aP[$n][0]
            Case 1
                $aM[$n][2] += $yShift
                $aM[$n][4] += $yShift
            Case 2
                $aM[$n][2] += $yShift
        EndSwitch
    Next
    Return $aM
EndFunc   ;==>_Shape_MirrorVert

Func _Shape_Draw($aP, $aStLineParams, $aArcParams)

    If Not IsArray($aP) Then Return
    For $j = 1 To $aP[0][0]
        Switch $aP[$j][0]
            Case 1
                _Shape_DrawStLine($aP, $j, $aStLineParams)

            Case 2
                _Shape_DrawArc($aP, $j, $aArcParams)
        EndSwitch
    Next

EndFunc   ;==>_Shape_Draw

Func _Shape_Shift(ByRef $aP, $x, $y)
    Local $n

    For $n = 1 To $aP[0][0]

        Switch $aP[$n][0]
            Case 1
                $aP[$n][1] += $x
                $aP[$n][2] += $y
                $aP[$n][3] += $x
                $aP[$n][4] += $y
            Case 2
                $aP[$n][1] += $x
                $aP[$n][2] += $y
        EndSwitch

    Next


EndFunc   ;==>_Shape_Shift

;============== _Shape_DistToLine ========================
Func _Shape_DistToLine($xp, $yp, $aP, $n)
    If $aP[$n][0] = 1 Then
        Return _Shape_DistToStLine($xp, $yp, $aP, $n)
    EndIf
    Return _Shape_DistToArc($xp, $yp, $aP, $n)
EndFunc   ;==>_Shape_DistToLine

;============== _Shape_DistToStLine ========================
;returns the distance from point $Pt to the  straight line AB
Func _Shape_DistToStLine($xp, $yp, $aP, $n)
    If $aP[$n][0] <> 1 Then
        mgConsoleWrite("not a straight line" & @CRLF)
        Return SetError(-1, 0, 0)
    EndIf
    Return _DistToStLine($xp, $yp, $aP[$n][1], $aP[$n][2], $aP[$n][3], $aP[$n][4])

EndFunc   ;==>_Shape_DistToStLine

;================ _DistToStLine ==================
;returns the distance from point $Pt to the nearest point in the straight line AB
Func _DistToStLine($Ptx, $Pty, $Ax, $Ay, $Bx, $By)
    Local $slope, $n, $dist, $m1, $m2, $k1, $k2, $xy
    ;$slope = _AngleFromPts($Ax, $Ay, $Bx, $By)

    $xy = _NearestPtOnLine($Ptx, $Pty, $Ax, $Ay, $Bx, $By)


    If $xy[0] > max($Ax, $Bx) Or $xy[0] < min($Ax, $Bx) Or _
            $xy[1] > max($Ay, $By) Or $xy[1] < Min($Ay, $By) Then;crossover is not between A and B

        Return Min(_LineLength($Ptx, $Pty, $Ax, $Ay), _LineLength($Ptx, $Pty, $Bx, $By))

    Else
        Return _LineLength($Ptx, $Pty, $xy[0], $xy[1])
    EndIf

EndFunc   ;==>_DistToStLine


;==================== _NearestPtOnLine ========================
;return 2 element array of nearest pt on line AB to Ptx,Pty
;the returned pt might not be actually within the ends of the line AB, but it will be
; in line with those pts.
Func _NearestPtOnLine($Ptx, $Pty, $Ax, $Ay, $Bx, $By)
    Local $xy[2], $k1, $k2, $m1, $m2

    If Abs($Ax - $Bx) < 0.0001 Then
        $xy[0] = $Ax
        $xy[1] = $Pty
    ElseIf Abs($Ay - $By) < 0.0001 Then
        $xy[0] = $Ptx
        $xy[1] = $Ay
    Else

        $m1 = ($By - $Ay) / ($Bx - $Ax)
        $m2 = -1 / $m1

        $k1 = $Ay - $m1 * $Ax

        $k2 = $Pty - $m2 * $Ptx

        ;when lines cross
        ;$m1*X +$k1 = x*$m2 + $k2
        ;so
        $xy[0] = ($k1 - $k2) / ($m2 - $m1)
        $xy[1] = $m2 * $xy[0] + $k2
    EndIf

    Return $xy
EndFunc   ;==>_NearestPtOnLine


;======== _Shape_DistToArc ================
;returns shortest distance from point $Ax, $Ay to the arc line $i in line array $aP
Func _Shape_DistToArc($Ax, $Ay, $aP, $i)
    Local $n, $Angle1, $distToC, $Pt1[2], $Pt2[2]

    If $Ax = $aP[$i][1] And $Ay = $aP[$i][2] Then Return $aP[$i][3];if pt is arc centre then return radius

    $distToC = _LineLength($Ax, $Ay, $aP[$i][1], $aP[$i][2])
    $Angle1 = _AngleFromPts($aP[$i][1], $aP[$i][2], $Ax, $Ay)
    If _AngleInRange($Angle1, $aP[$i][4], $aP[$i][5], False) Then Return Abs($distToC - $aP[$i][3])

    $Pt1[0] = $aP[$i][1] + $aP[$i][3] * Cos($aP[$i][4] * $Deg2Rad)
    $Pt1[1] = $aP[$i][2] + $aP[$i][3] * Sin($aP[$i][4] * $Deg2Rad)

    $Pt2[0] = $aP[$i][1] + $aP[$i][3] * Cos(($aP[$i][4] + $aP[$i][5]) * $Deg2Rad)
    $Pt2[1] = $aP[$i][2] + $aP[$i][3] * Sin(($aP[$i][4] + $aP[$i][5]) * $Deg2Rad)

    Return min(_LineLength($Ax, $Ay, $Pt1[0], $Pt1[1]), _LineLength($Ax, $Ay, $Pt2[0], $Pt2[1]))


EndFunc   ;==>_Shape_DistToArc


;========== _Shape_GetExtents ====================
;Parameter $aP the line array for the shape
; Returns an array with 4 elements
;                         [0],[1] = min x and min Y values
;                         [2],[3] = max X and max Y values
;  Author martin
Func _Shape_GetExtents($aP)
    Local $n, $maxX = -(10 ^ 8), $maxY = -(10 ^ 8), $minX = 10 ^ 8, $MinY = 10 ^ 8, $Res[4], $temp
    If Not IsArray($aP) Then Return

    For $n = 1 To $aP[0][0]

        Switch $aP[$n][0]
            Case 1
                $temp = Max($aP[$n][1], $aP[$n][3])
                $maxX = Max($maxX, $temp)
                $temp = Min($aP[$n][1], $aP[$n][3])
                $minX = Min($minX, $temp)

                $temp = Max($aP[$n][2], $aP[$n][4])
                $maxY = Max($maxY, $temp)

                $temp = Min($aP[$n][2], $aP[$n][4])
                $MinY = Min($MinY, $temp)
            Case 2;<error here sometimes. Draws curve ok but extents are wrong?? Need an example because I can't produce an error now. Myabe some change I made has fixed it.
                If _AngleInRange(0, $aP[$n][4], $aP[$n][5], False) Then
                    $maxX = Max($maxX, $aP[$n][1] + $aP[$n][3]);centre x + radius
                Else
                    $temp = Max($aP[$n][1] + $aP[$n][3] * Cos($aP[$n][4] * $Deg2Rad), _
                            $aP[$n][1] + $aP[$n][3] * Cos(($aP[$n][4] + $aP[$n][5]) * $Deg2Rad))
                    $maxX = Max($maxX, $temp)
                EndIf

                If _AngleInRange(180, $aP[$n][4], $aP[$n][5], False) Then
                    $minX = Min($minX, $aP[$n][1] - $aP[$n][3]);centre x - radius
                Else
                    $temp = Min($aP[$n][1] + $aP[$n][3] * Cos($aP[$n][4] * $Deg2Rad), _
                            $aP[$n][1] + $aP[$n][3] * Cos(($aP[$n][4] + $aP[$n][5]) * $Deg2Rad))
                    $minX = Min($minX, $temp)
                EndIf

                If _AngleInRange(90, $aP[$n][4], $aP[$n][5], False) Then
                    $maxY = Max($maxY, $aP[$n][2] + $aP[$n][3]);centre y + radius
                Else
                    $temp = Max($aP[$n][2] + $aP[$n][3] * Sin($aP[$n][4] * $Deg2Rad), _
                            $aP[$n][2] + $aP[$n][3] * Sin(($aP[$n][4] + $aP[$n][5]) * $Deg2Rad))
                    $maxY = Max($maxY, $temp)
                EndIf

                If _AngleInRange(270, $aP[$n][4], $aP[$n][5], False) Then
                    $MinY = Min($MinY, $aP[$n][2] - $aP[$n][3]);centre x + radius
                Else
                    $temp = Min($aP[$n][2] + $aP[$n][3] * Sin($aP[$n][4] * $Deg2Rad), _
                            $aP[$n][2] + $aP[$n][3] * Sin(($aP[$n][4] + $aP[$n][5]) * $Deg2Rad))
                    $MinY = Min($MinY, $temp)
                EndIf

        EndSwitch

    Next

    $Res[0] = $minX
    $Res[1] = $MinY
    $Res[2] = $maxX
    $Res[3] = $maxY

    Return $Res

EndFunc   ;==>_Shape_GetExtents

;=========== _Shape_Rotate =================
; Parameters
;    $aP the line array for the shape
;    $Cx, $Cy the point about which to rotate
;     $alpha  the angle to rotate in degrees
;    $CornerFit the way to shift the shape after rotating
;               0 means no shift
;               1 means set shape so that extents are set to the same top left as the original
;               2 to top right
;               3 to bottom right
;               4 to bottom left
;if $cornerFit = 0 then the values of Cx and Cy do not affect the result so you can just use 0,0
;
;Returns the line array for the rotated shape

Func _Shape_Rotate($aP, $Cx, $Cy, $Alpha, $CornerFit = 0)
    Local $n, $e1, $e2, $xShift, $yShift

    $e1 = _Shape_GetExtents($aP)

    If _SetAngle($Alpha) = 0 Then Return $aP

    For $n = 1 To $aP[0][0]

        Switch $aP[$n][0]
            Case 1
                _RotatePointFromPoint($aP[$n][1], $aP[$n][2], $Cx, $Cy, $Alpha)
                _RotatePointFromPoint($aP[$n][3], $aP[$n][4], $Cx, $Cy, $Alpha)
            Case 2
                _RotatePointFromPoint($aP[$n][1], $aP[$n][2], $Cx, $Cy, $Alpha)
                $aP[$n][4] += $Alpha
        EndSwitch

    Next

    ;get new extents
    $e2 = _Shape_GetExtents($aP)

    Switch $CornerFit
        Case 0
            Return $aP
        Case 1
            $xShift = $e1[0] - $e2[0]
            $yShift = $e1[1] - $e2[1]
        Case 2
            $xShift = $e1[2] - $e2[2]
            $yShift = $e1[1] - $e2[1]
        Case 3
            $xShift = $e1[2] - $e2[2]
            $yShift = $e1[3] - $e2[3]
        Case 4
            $xShift = $e1[0] - $e2[0]
            $yShift = $e1[3] - $e2[3]
    EndSwitch

    For $n = 1 To $aP[0][0]
        Switch $aP[$n][0]
            Case 1
                $aP[$n][1] += $xShift
                $aP[$n][3] += $xShift
                $aP[$n][2] += $yShift
                $aP[$n][4] += $yShift
            Case 2
                $aP[$n][1] += $xShift
                $aP[$n][2] += $yShift
        EndSwitch
    Next

    Return $aP
EndFunc   ;==>_Shape_Rotate

;======== _RotatePointFromPoint ===================
;Parameters:
;         $Ax, $Ay the point to be rotated
;         $Cx, $Cy the point about which to rotate
;         $Angle the angle to rotate.
;Returns ''
;
Func _RotatePointFromPoint(ByRef $Ax, ByRef $Ay, $Cx, $Cy, $angle)
    Local $ang1, $ang2rad, $Radius

    ;calc angle of line CA
    $ang1 = _AngleFromPts($Cx, $Cy, $Ax, $Ay)
    ;calc new angle
    $ang2rad = ($ang1 + $angle) * $Deg2Rad

    $Radius = _LineLength($Cx, $Cy, $Ax, $Ay)

    ;Calculate the new coords for A
    $Ax = $Radius * Cos($ang2rad) + $Cx
    $Ay = $Radius * Sin($ang2rad) + $Cy
EndFunc   ;==>_RotatePointFromPoint




;========= _Shape_GetStLineAngle
;needs func _AngleFromPts
Func _Shape_GetStLineAngle($aLines, $i, $Way)
    If $aLines[$i][0] <> 1 Then
        MsgBox(262144, "ERROR in _Shape_GetStLineAngle", "line is not a straight line")
        Return SetError(-1, 0, 0)
    EndIf
    If $Way = 0 Then
        Return _AngleFromPts($aLines[$i][1], $aLines[$i][2], $aLines[$i][3], $aLines[$i][4])
    Else
        Return _AngleFromPts($aLines[$i][3], $aLines[$i][4], $aLines[$i][1], $aLines[$i][2])
    EndIf

EndFunc   ;==>_Shape_GetStLineAngle

;================ _Shape_SplitStLine =================
;inserts a new line lenth $dist and reduces the line $i y $Dist.
;if the $pt is at the start of the line then the new line is inserted before $i,
; otherwise is is inserted afetr $i
;the lines in the array $aLines must have been sorted and in order - see _Shape_setPath
Func _Shape_SplitStLine(ByRef $aLines, $i, $pt, $dist)
    Local $Way, $RefEnd, $NonRefEnd, $len, $newx, $newy, $insertpos
    Local $oldx, $oldy

    If $i < 1 Or $i > $aLines[0][0] Then Return -1;no such line
    If $aLines[$i][0] <> 1 Then Return -2 ;must be a straight line

    $insertpos = $pt

    ;check pt is one end of the line
    If $pt <> $i And $pt < $i - 1 Then
        If $i = 1 And $pt <> $aLines[0][0] Then Return -3;point is not one end of line $i
    EndIf

    $Way = +1;pt is start of line $i
    $RefEnd = 1
    $NonRefEnd = 3
    If $pt = $i Then
        $Way = 1;pt is at end of line $i
        $RefEnd = 3
        $NonRefEnd = 1
    EndIf

    $len = _Shape_StLineLength($aLines, $i)
    mgConsoleWrite("way = " & $Way & ",  refend = " & $RefEnd & @CRLF)
    $newx = $aLines[$i][$RefEnd] + ($aLines[$i][$NonRefEnd] - $aLines[$i][$RefEnd]) * $Way * $dist / $len
    $newy = $aLines[$i][$RefEnd + 1] + ($aLines[$i][$NonRefEnd + 1] - $aLines[$i][$RefEnd + 1]) * $Way * $dist / $len

    ;length of line $i



    $oldx = $aLines[$i][$RefEnd];need because_Shape_InsertStLine can move the position of line $i
    $oldy = $aLines[$i][$RefEnd + 1]

    ;modify line $i
    $aLines[$i][$RefEnd] = $newx
    $aLines[$i][$RefEnd + 1] = $newy

    If $RefEnd = 1 Then
        _Shape_InsertStLine($aLines, $insertpos, $oldx, $oldy, $newx, $newy)
    Else
        _Shape_InsertStLine($aLines, $insertpos, $newx, $newy, $oldx, $oldy)
    EndIf




EndFunc   ;==>_Shape_SplitStLine


Func _Shape_IsPointInside($Px, $Py, $aP, $cw = False)
    Local $Res = 0, $j
    ; mgConsoleWrite("px, Py = " & $Px & ', ' & $Py & @CRLF)
    For $j = 1 To $aP[0][0]
        ;If $j = 10 Then ;to bedug a single line
        Switch $aP[$j][0]
            Case 1
                If _IsPtLeftOfLine($Px, $Py, $aP[$j][1], $aP[$j][2], $aP[$j][3], $aP[$j][4]) Then
                    ;If $cw Then mgConsoleWrite("-" & $Px & ', ' & $Py & " Is left of line " & $j & @CRLF)
                    $Res += 1
                    ;Else
                    ;If $cw Then mgConsoleWrite("-" & $Px & ', ' & $Py & " not left of line " & $j & @CRLF)
                EndIf
            Case 2
                If _IsPtInArc($Px, $Py, $aP[$j][1], $aP[$j][2], $aP[$j][3], $aP[$j][4], $aP[$j][5]) Then
                    ;If $cw Then mgConsoleWrite("-" & $Px & ', ' & $Py & " is inside arc " & $j & @CRLF)
                    $Res += 1
                    ; Else
                    ;   If $cw Then mgConsoleWrite("-" & $Px & ', ' & $Py & " not inside arc " & $j & @CRLF)
                EndIf
        EndSwitch
        ;EndIf
    Next

    Return Mod($Res, 2) = 1

EndFunc   ;==>_Shape_IsPointInside

;============== _Shape_GetNearestJoint ===============================================
; returns the Point number where line 1 to line 2 is joint 1, etc
;           and the x,y coords. Info returned in a 1D array with 3 elements
;           [0] = line number associated with the point. If the end of a line then the line number.
;                 if the point is at th ejunction of 2 lines then it is always the line first in the shape.
;                 if there is no previous line then the value is -1 * line number.
;           [1] = x coord
;           [2] = y coord
;           [3] = dist to joint
;           [4] = point type, 0 = end of line, 1 = centre of arc
;                 0 = end of line (default)
;                 1 = centre of arc
;Assumes lines are in sequence and in correct direction.
;        If not in correct direct and order, or unknown, then use _Shape_SetPath first
;=====================================================================================
Func _Shape_GetNearestJoint($aPt, $aP)
    Local $temp, $Res[5], $xp, $yp

    $Res[3] = 10 ^ 8
    $Res[4] = 0 ;default to end of line

    If Not IsArray($aP) Or Not IsArray($aPt) Then Return $Res

    For $n = 1 To $aP[0][0]
        Switch $aP[$n][0];the line type
            Case 1
                $temp = _LineLength($aPt[0], $aPt[1], $aP[$n][3], $aP[$n][4]);[$n][1], $aP[$n][2], $aP[$n][3], $aP[$n][4])
                If $temp < $Res[3] Then
                    $Res[3] = $temp
                    $Res[1] = $aP[$n][3]
                    $Res[2] = $aP[$n][4]
                    $Res[0] = $n
                    $Res[4] = 0
                EndIf

            Case 2
                $xp = $aP[$n][1] + $aP[$n][3] * _cosD($aP[$n][4] + $aP[$n][5])
                $yp = $aP[$n][2] + $aP[$n][3] * _sinD($aP[$n][4] + $aP[$n][5])
                $temp = _LineLength($aPt[0], $aPt[1], $xp, $yp)
                If $temp < $Res[3] Then
                    $Res[3] = $temp
                    $Res[0] = $n
                    $Res[1] = $xp
                    $Res[2] = $yp
                    $Res[4] = 0
                EndIf

                ;also check arc centres
                $xp = $aP[$n][1]
                $yp = $aP[$n][2]
                $temp = _LineLength($aPt[0], $aPt[1], $xp, $yp)
                If $temp < $Res[3] Then
                    $Res[3] = $temp
                    $Res[0] = $n
                    $Res[1] = $xp
                    $Res[2] = $yp
                    $Res[4] = 1
                EndIf

        EndSwitch
    Next

    Return $Res

EndFunc   ;==>_Shape_GetNearestJoint

;================== _Shape_GetNearestPt ============
;get nearesy pt in shape array $aP to the point $aPt
Func _Shape_GetNearestPt($aPt, $aP)
    Local $nearest = 10 ^ 8, $temp, $closeLine = 0, $Res[2]
    If Not IsArray($aP) Or Not IsArray($aPt) Then Return $Res
    For $n = 1 To $aP[0][0]
        Switch $aP[$n][0]
            Case 1
                $temp = _Shape_DistToStLine($aPt[0], $aPt[1], $aP, $n);[$n][1], $aP[$n][2], $aP[$n][3], $aP[$n][4])
                If $temp < $nearest Then
                    $nearest = $temp
                    $closeLine = $n
                EndIf

            Case 2
                $temp = _Shape_DistToArc($aPt[0], $aPt[1], $aP, $n)
                If $temp < $nearest Then
                    $nearest = $temp
                    $closeLine = $n
                EndIf
        EndSwitch


    Next
    $Res[0] = $closeLine
    $Res[1] = $nearest
    Return $Res

EndFunc   ;==>_Shape_GetNearestPt


;============ _Shape_SortClockWise ========================
; Parameters:
;          $aP        = the lines array
;          $Direction = if true then sorts cw, else ccw
;          $Close     = if True a missing line needed to close the shape will be added
; Returns On Success:  1 and the array $aP sorted as requested.
;         On Failure: -1 if more than two lines join at a point
;                     -3 if more than one line needed to close the shape
; if a line is not connected as part of an enclosed shape then it is removed from the returned array
; Not done, maybe will not be done = If the poly is not closed then if $Close is true it will be closed, otherwise it will return -2
; INFO: for grinding or routing external edges (assumuning the tool rotates cw) it is best to go cw, and for internal edges go ccw.
; For cutting grooves or slots equal to the tool diameter it makes no difference.

Func _Shape_SortClockWise(ByRef $aP, $fDirection = True, $fClose = True)
    Local $n, $j, $k, $tied, $aEnds, $fClosed = False, $area
    Local $aTidy[2][4], $TidyCount, $temp

    $aEnds = $aP;the end points will already be correct for straight lines though maybe not in correct order.
    ReDim $aEnds[UBound($aP)][7]

    ; _ArrayDisplay($aP)

    ;get all the arc end points
    For $n = 1 To $aP[0][0]
        $aEnds[$n][5] = 0;no matching end cw
        $aEnds[$n][6] = 0;no matching end ccw

        If $aP[$n][0] = 2 Then;arc
            $aEnds[$n][1] = $aP[$n][1] + $aP[$n][3] * Cos($aP[$n][4] / $Rad2Deg)
            $aEnds[$n][2] = $aP[$n][2] + $aP[$n][3] * Sin($aP[$n][4] / $Rad2Deg)
            $aEnds[$n][3] = $aP[$n][1] + $aP[$n][3] * Cos(($aP[$n][4] + $aP[$n][5]) / $Rad2Deg)
            $aEnds[$n][4] = $aP[$n][2] + $aP[$n][3] * Sin(($aP[$n][4] + $aP[$n][5]) / $Rad2Deg)
        EndIf

    Next
    ;_ArrayDisplay($aEnds, "all endpoints. 736")
    $tied = 0;number of ends tied together
    For $n = 1 To $aEnds[0][0] - 1
        For $j = $n + 1 To $aEnds[0][0]
            For $k = 1 To 3 Step 2;for each x and y coord in $aP line
                If Abs($aEnds[$n][1] - $aEnds[$j][$k]) < 0.01 And Abs($aEnds[$n][2] - $aEnds[$j][$k + 1]) < 0.01 Then
                    If $aEnds[$n][5] <> 0 Then
                        _ArrayDisplay($aEnds, "Problem = Line 745")
                        Return -1
                    EndIf
                    $aEnds[$n][5] = $j
                    $aEnds[$j][5 + ($k - 1) / 2] = $n
                    $tied += 1
                EndIf

                If Abs($aEnds[$n][3] - $aEnds[$j][$k]) < 0.01 And Abs($aEnds[$n][4] - $aEnds[$j][$k + 1]) < 0.01 Then
                    If $aEnds[$n][6] <> 0 Then
                        _ArrayDisplay($aEnds, "Problem = Line 756")
                        Return -1
                    EndIf
                    $aEnds[$n][6] = $j
                    $aEnds[$j][5 + ($k - 1) / 2] = $n
                    $tied += 1
                EndIf

            Next

        Next

    Next

    If $tied < $aEnds[0][0] Then; poly not closed
        If $fClose Then
            If $tied < $aEnds - 1 Then Return -3;too many loose ends
            $TidyCount = 0
            For $n = 1 To $aEnds[0][0]
                If $aEnds[$n][5] = 0 Then;this is one unmatched end
                    $aTidy[$TidyCount][0] = $aEnds[$n][1]
                    $aTidy[$TidyCount][1] = $aEnds[$n][2]
                    $aTidy[$TidyCount][2] = $n ;the line number
                    $aTidy[$TidyCount][3] = 0 ;the end type
                    $TidyCount += 1
                EndIf

                If $aEnds[$n][6] = 0 Then;this is one unmatched end
                    $aTidy[$TidyCount][0] = $aEnds[$n][3]
                    $aTidy[$TidyCount][1] = $aEnds[$n][4]
                    $aTidy[$TidyCount][2] = $n ;the line number
                    $aTidy[$TidyCount][3] = 1 ;the end type
                    $TidyCount += 1
                EndIf
                If $TidyCount = 2 Then ExitLoop
            Next

            If $TidyCount = 2 Then ;if we succeeded
                ReDim $aP[UBound($aP) + 1][$LINECOLS]
                ReDim $aEnds[UBound($aEnds) + 1][7]
                $aP[0][0] += 1
                $temp = UBound($aP) - 1
                $aP[$temp][0] = 1;st line
                $aP[$temp][1] = $aTidy[0][0]
                $aP[$temp][2] = $aTidy[0][1]
                $aEnds[$temp][5] = $aTidy[0][2]
                $aEnds[$aTidy[0][2]][5 + $aTidy[0][3]] = $temp


                $aP[$temp][3] = $aTidy[1][0]
                $aP[$temp][4] = $aTidy[1][1]

                $aEnds[$temp][6] = $aTidy[1][2]
                $aEnds[$aTidy[1][2]][5 + $aTidy[1][3]] = $temp

                $aEnds[0][0] += 1
                $aEnds[$temp][0] = 1;st line
                $aEnds[$temp][1] = $aTidy[0][0]
                $aEnds[$temp][2] = $aTidy[0][1]
                $aEnds[$temp][3] = $aTidy[1][0]
                $aEnds[$temp][4] = $aTidy[1][1]

            EndIf
            ;_ArrayDisplay($aP, "all ends tied? 846")
            ;_ArrayDisplay($aEnds, "all ends tied? 847")
            ;find ends not connected
            ;draw a line between them
            ;add the line to the array
        EndIf
    EndIf
    ;now the lines might not be in the correct order and they might not all be in the same direction.
    ;but $aEnds tells us how they link together.
    ; _arraydisplay($aP,"before set path")
    _Shape_SetPath($aP, $aEnds);set the lines so they form a continuous path, might be cw or ccw
    ;_arraydisplay($aP, "after set path")
    $area = _Shape_GetArea($aEnds, False, True)
    If $fDirection <> $area > 0 Then
        _Shape_ReverseDirection($aP)
    EndIf
    ;_ArrayDisplay($ap,"should be in order cw or not")
    Return 1;sorted cw/ccw ok
EndFunc   ;==>_Shape_SortClockWise


;=========== _Shape_SetPath ========================
;sets the line array so that each line has a start which matches the end of the previous line
;Parameters $aP - the array of lines
;           $aLinks - the array of all the end points, actually all arcs converted to chords
;                     and straight lines left as in $aP
Func _Shape_SetPath(ByRef $aP, $aLinks)
    Local $aNew = $aP, $relink = $aLinks
    Local $j, $k, $temp, $prev, $inext, $antePrev

    ; _ArrayDisplay($aNew, "old arrangement. 850")
    ; _ArrayDisplay($aLinks,"old links 875")
    ;rearrange to lines so they are in order
    $prev = 1; previous line was 1
    $antePrev = -1
    ; $inext = $aLinks[1][6];choose the line which connects to the end of the first one
    For $j = 2 To $aP[0][0];just to count the number of times we do this
        ;the next line is one of the lines connected to the start or the end of the previous line
        $inext = $aLinks[$prev][6];choose the line which connects to the end of the first one
        If $inext = $antePrev Then
            $inext = $aLinks[$prev][5]
        EndIf

        For $k = 0 To 5
            $aNew[$j][$k] = $aP[$inext][$k]
        Next
        For $k = 0 To 6
            $relink[$j][$k] = $aLinks[$inext][$k]
        Next
        $antePrev = $prev
        $prev = $inext
    Next

    ;$aP = $aNew
    ;_arraydisplay($anew,"958: after sorting ointo order?")
    For $j = 2 To $aP[0][0]

        If Abs($relink[$j][1] - $relink[$j - 1][3]) > 0.001 Or _
                Abs($relink[$j][2] - $relink[$j - 1][4]) > 0.001 Then; we must reverse this line
            If $aNew[$j][0] = 1 Then;st line
                $temp = $aNew[$j][1]
                $aNew[$j][1] = $aNew[$j][3]
                $aNew[$j][3] = $temp
                $temp = $aNew[$j][2]
                $aNew[$j][2] = $aNew[$j][4]
                $aNew[$j][4] = $temp
                For $k = 1 To 4
                    $relink[$j][$k] = $aNew[$j][$k]
                Next

            Else;we must reverse this arc
                $aNew[$j][4] += $aNew[$j][5]
                _SetAngle($aNew[$j][4])
                $aNew[$j][5] *= -1

                $temp = $relink[$j][1]
                $relink[$j][1] = $relink[$j][3]
                $relink[$j][3] = $temp
                $temp = $relink[$j][2]
                $relink[$j][2] = $relink[$j][4]
                $relink[$j][4] = $temp
            EndIf

            $temp = $relink[$j][5]
            $relink[$j][5] = $relink[$j][6]
            $relink[$j][6] = $temp
            ;  _ArrayDisplay($aNew, "part new arrangement. 031")
            ;_ArrayDisplay($relink, "part new link. 932")
        EndIf
    Next
    $aP = $aNew
    ;;_ArrayDisplay($relink, "all the ends sorted to be in same direction?895")


EndFunc   ;==>_Shape_SetPath

;============ _Shape_ReverseDirection ==============
;reverses the direction of the the lines in a shape array $A, and
; If $ReversLines is True then the direction of each line is also reversed so
;        the path around the shape will remain continuous
Func _Shape_ReverseDirection(ByRef $A, $fReverseLines = True)
    Local $aRev[UBound($A, 1)][6], $j, $k, $temp

    For $j = 1 To $A[0][0]
        For $k = 0 To 5
            $aRev[$j][$k] = $A[$A[0][0] - $j + 1][$k]
        Next
    Next

    ;_ArrayDisplay($aRev, "reversed line order but not directions")

    If Not $fReverseLines Then
        $A = $aRev
        Return
    EndIf

    For $j = 1 To $A[0][0]
        If $aRev[$j][0] = 1 Then
            $temp = $aRev[$j][1]
            $aRev[$j][1] = $aRev[$j][3]
            $aRev[$j][3] = $temp

            $temp = $aRev[$j][2]
            $aRev[$j][2] = $aRev[$j][4]
            $aRev[$j][4] = $temp
        Else;it's an arc
            $aRev[$j][4] += $aRev[$j][5]
            _setAngle($aRev[$j][4])
            $aRev[$j][5] *= -1
        EndIf
    Next
    ;_ArrayDisplay($aRev)
    $A = $aRev

EndFunc   ;==>_Shape_ReverseDirection


;=========================== _Shape_GetArea ================================
;the points of the polygon must in order either clockwise or counter clockwise
;To understand why it works- Imagine vertical lines dropped to some imaginary horizontal line say the where y < than the minimum of the polygon,
;calculate the area under each line forming a trapezium. The area is (Bx - Ax) * (By - Ay) /2 + (Bx - Ax)* Ay.
; = Bx*By/2 -Bx*Ay/2 -Ax*By/2 + Ax*Ay/2 + Bx*Ay - Ax*Ay = Bx*By/2 +Bx*Ay/2 -Ax*By/2 -Ax*Ay/2. The BxBy/2 will be eliminated by the calculation
; for the next line (B to C) and so on until the last line comes back to A and we eliminate the Ax*Ay/2.
;So we are left with Bx*Ay/2 -Ax*By/2 + Bx*Cy/2 - By*Cx/2 ...
; ( The lines pointing in a different direction form oposite sign areas and so take away leaving the area of the polygon.)

;Parameters: $aPoints - the lines array to make the shape
;            $fMakePositive - if True then the result is positive
;                             if False then result is positive if points are arranged clockwise, negative if ccw
;            $fCutCorners is True then the area will be calculated as though the arcs were all straight lines.
;                       $fCutCorners = False not dealt with yet! May not be done since I only use this func to find out
;                                      if the lines are arranged cw or ccw
;Author  Martin. Based on code by Malkey whose area calculation was the first time I had seen the technique. see http://www.autoitscript.com/forum/topic/89034-check-if-a-point-is-within-various-defined-closed-shapes/page__view__findpost__p__880389
;
Func _Shape_GetArea($aPoints, $fMakePositive = False, $fCutCorners = True)
    ; must change this func to suit shapes with arcs
    Local $Med, $j
    Local $size = $aPoints[0][0], $aEnds[4]

    For $n = 1 To $size

        If $aPoints[$n][0] = 2 Then;arc
            $aEnds[0] = $aPoints[$n][1] + $aPoints[$n][3] * Cos($aPoints[$n][4] / $Rad2Deg)
            $aEnds[1] = $aPoints[$n][2] + $aPoints[$n][3] * Sin($aPoints[$n][4] / $Rad2Deg)
            $aEnds[2] = $aPoints[$n][1] + $aPoints[$n][3] * Cos(($aPoints[$n][4] + $aPoints[$n][5]) / $Rad2Deg)
            $aEnds[3] = $aPoints[$n][2] + $aPoints[$n][3] * Sin(($aPoints[$n][4] + $aPoints[$n][5]) / $Rad2Deg)
            For $j = 0 To 3
                $aPoints[$n][$j + 1] = $aEnds[$j]
            Next

        EndIf

        $Med += $aPoints[$n][2] * $aPoints[$n][3] - $aPoints[$n][1] * $aPoints[$n][4]
    Next

    If $aPoints[$size][3] <> $aPoints[1][0] Or $aPoints[$size][4] <> $aPoints[1][1] Then
        $Med += $aPoints[$size][4] * $aPoints[1][1] - $aPoints[$size][3] * $aPoints[1][2]
    EndIf

    ;the area will be +ve or -ve depending on whether the points are arranged cw or ccw
    If $fMakePositive Then
        Return Abs($Med / 2)
    Else
        Return $Med / 2
    EndIf

EndFunc   ;==>_Shape_GetArea

Func _Shape_StLineLength($aLines, $i)

    If $aLines[$i][0] <> 1 Then Return SetError(1, 0, 0)

    Return _LineLength($aLines[$i][1], $aLines[$i][2], $aLines[$i][3], $aLines[$i][4])

EndFunc   ;==>_Shape_StLineLength



;=========== _LineLength =================
;returns the length of a straight line from Ax,Ay to Bx,By
Func _LineLength($Ax, $Ay, $Bx, $By)

    Return Sqrt(($Ax - $Bx) ^ 2 + ($Ay - $By) ^ 2)

EndFunc   ;==>_LineLength


;============== _AngleFromPts ===============
;get the angle of the line.
;The centre of the imagined circle is $Ax, $Ay
;Returns the angle in degrees
; Author martin
Func _AngleFromPts($Ax, $Ay, $Bx, $By)
    Local $ang

    If $Ax = $Bx Then
        If $By > $Ay Then Return 90
        Return 270
    EndIf

    If $Ay = $By Then
        If $Bx > $Ax Then Return 0
        Return 180
    EndIf

    $ang = ATan(($By - $Ay) / ($Bx - $Ax)) * $Rad2Deg
    If $ang < 0 Then $ang = 180 + $ang

    If $By < $Ay Then $ang += 180
    Return _SetAngle($ang)

EndFunc   ;==>_AngleFromPts

#cs
    Func _Shape_GetLineAngle($aL, $i);?????????????
    Local $Res

    If $aL[$i][1] = $aL[$i][3] Then;vertical
    If $aL[$i][2] < $aL[$i][4] Then
    Return $Rad2Deg * $pi / 2
    Else
    Return $Rad2Deg * 3 * $pi / 2
    EndIf
    EndIf

    If $aL[$i][2] = $aL[$i][4] Then;horizontal
    If $aL[$i][1] < $aL[$i][3] Then
    Return 0
    Else
    Return $Rad2Deg * $pi / 2
    EndIf
    EndIf

    If $aL[$i][2] < $aL[$i][4] Then
    Return $Rad2Deg * ATan(($aL[$i][4] - $aL[$i][2]) / ($aL[$i][3] - $aL[$i][2]))
    Else
    Return 180 + $Rad2Deg * ATan(($aL[$i][4] - $aL[$i][2]) / ($aL[$i][3] - $aL[$i][2]))
    EndIf

    EndFunc   ;==>_GetLineAngle
#ce
;=========== _GetArcAngle ==================
;get the angle tangent to the start or end of the arc
;parameters
;      $aL the array of lines
;      $e the line number
;      $aEnd: 0 = start, 1 = end
;returns the angle from the start in the direction of the sweep,
;        or at the end in the opposite direction to the sweep
;NB the line array must have been arranged to have the lines in order
;   and all in the same direction around the shape using _Shape_SetPath
;   or the results will possibly be useless.
; Author martin
Func _GetArcAngle($aL, $i, $aEnd);
    Local $Res
    If $aEnd = 0 Then;start
        $Res = $aL[$i][4]
        If $aL[$i][5] > 0 Then
            Return $Res + 90
        Else
            Return $Res - 90
        EndIf
    Else;end of arc
        $Res = $aL[$i][4] + $aL[$i][5]
        If $aL[$i][5] > 0 Then
            Return $Res - 90
        Else
            Return $Res + 90
        EndIf
    EndIf

EndFunc   ;==>_GetArcAngle

;=========== _GetParallelStLines ======================
;returns an array containing the end points for 2 parallel lines to $x1, $y1 to $x2, $y2
; the lines are either side of the given line displaced by a distance $gap measured at right angles to the line.
;by martin
Func _GetParallelStLines($x1, $y1, $x2, $y2, $gap)
    Local $slope, $Alpha, $beta, $n
    Dim $Res[8]

    ;get angle of line in radians
    $Alpha = ATan(($y2 - $y1) / ($x2 - $x1))

    ;calc startx,y and end x,y for one parallel line
    $Res[0] = $x1 + $gap * Sin($Alpha)
    $Res[1] = $y1 - $gap * Cos($Alpha)
    $Res[2] = $x2 + $gap * Sin($Alpha)
    $Res[3] = $y2 - $gap * Cos($Alpha)

    ;calc startx,y and end x,y for other parallel line
    $Res[4] = $x1 - $gap * Sin($Alpha)
    $Res[5] = $y1 + $gap * Cos($Alpha)
    $Res[6] = $x2 - $gap * Sin($Alpha)
    $Res[7] = $y2 + $gap * Cos($Alpha)

    Return $Res

EndFunc   ;==>_GetParallelStLines


Func _Shape_RegisterDrawStLine($sFuncName)
    $GCDrawStLine = $sFuncName
EndFunc   ;==>_Shape_RegisterDrawStLine

Func _Shape_RegisterDrawArc($sFuncName)
    $GCDrawArc = $sFuncName

EndFunc   ;==>_Shape_RegisterDrawArc



Func _Shape_DrawStLine($aK, $i, $aParams = 0)
    If $GCDrawStLine = '' Then Return -1

    Call($GCDrawStLine, $aK[$i][1], $aK[$i][2], $aK[$i][3], $aK[$i][4], $aParams)

EndFunc   ;==>_Shape_DrawStLine



Func _Shape_DrawArc($aM, $i, $aParams = 0)

    If $GCDrawArc = '' Then Return -1

    Call($GCDrawArc, $aM[$i][1], $aM[$i][2], $aM[$i][3], $aM[$i][4], $aM[$i][5], $aParams)

EndFunc   ;==>_Shape_DrawArc


Func _Shape_MakeRect($iWid, $iHt, $iX, $iY)
    Local $aRect[5][$LINECOLS], $n
    $aRect[0][0] = 4
    For $n = 1 To 4
        $aRect[$n][0] = 1
    Next

    $aRect[1][1] = $iX
    $aRect[1][2] = $iY
    $aRect[1][3] = $iX + $iWid
    $aRect[1][4] = $iY

    $aRect[2][1] = $iX + $iWid
    $aRect[2][2] = $iY
    $aRect[2][3] = $iX + $iWid
    $aRect[2][4] = $iY + $iHt

    $aRect[3][1] = $iX + $iWid
    $aRect[3][2] = $iY + $iHt
    $aRect[3][3] = $iX
    $aRect[3][4] = $iY + $iHt

    $aRect[4][1] = $iX
    $aRect[4][2] = $iY + $iHt
    $aRect[4][3] = $iX
    $aRect[4][4] = $iY

    Return $aRect
EndFunc   ;==>_Shape_MakeRect



; ============ _IsPtLeftOfLine =========================
; Returns whether a point is to th eleft of a straight line or not
;martin but modified from code and ideas by malkey
Func _IsPtLeftOfLine($Rx, $Ry, $x1, $y1, $x2, $y2)
    $Rx = Round($Rx, $PREC)
    $Ry = Round($Ry, $PREC)
    $y1 = Round($y1, $PREC)
    $y2 = Round($y2, $PREC)
    $x1 = Round($x1, $PREC)
    $x2 = Round($x2, $PREC)
    ;mgConsoleWrite("max of " & $y1 & ', ' & $y2 & " is " & max($y1,$y2) & @CRLF)
    ;mgConsoleWrite("min of " & $y1 & ', ' & $y2 & " is " & min($y1,$y2) & @CRLF)
    If $Ry >= Max($y1, $y2) Or $Ry < Min($y1, $y2) or ($y1 = $y2) Then
        ;mgConsoleWrite("$Ry >= Max($y1, $y2)2 is " & execute($Ry >= Max($y1, $y2)) & @CRLF)
        ; mgConsoleWrite("$Ry < Min($y1, $y2) is " & execute($Ry < Min($y1, $y2)) & @CRLF)
        ;mgConsoleWrite($rx & ', ' & $ry & " is not left of line from " & $y1 & ' to ' & $y2 & @CRLF)
        Return False
    EndIf

    Return $Rx < ($Ry - $y1) * ($x2 - $x1) / ($y2 - $y1) + $x1

EndFunc   ;==>_IsPtLeftOfLine


;is pt in arc
;Parameters $xPt, $yPt the coords of the point
;           $xR, $yR the centre of the arc
;           $Rad the arc radius
;           $StAngle, $EndAngle the start and end anglke in degrees
;Only deals with circular arcs though same approach can be used with elliptical arcs.
;The arc is drawn from start angle to start angle plus sweep
;Returns True if a horizontal line draw from the point to the right cuts the arc
;         once. If the horizontal line hits an end of the arc then it returns true only if that end is a top. A top end means
;         the arc moves down away from that end.
;         If the horizontal line is a tangent to the arc then it returns false.
;Author - martin
;version 3
Func _IsPtInArc($xPt, $yPt, $xR, $yR, $Rad, $StAngle, $Sw)
    Local $endAngle, $Alpha1, $Alpha2, $Result1 = False, $Result2 = False
    Local $Way = 1, $Atemp, $beta, $j, $Result


    ;check obvious cases
    If $xPt - $xR > $Rad Then Return False
    If Abs($yPt - $yR) > $Rad Then Return False

    ;find the angle to the point where horizontal line cuts the circle from centre of circle
    ; $beta = _ASinRound(Abs($yPt - $yR), $Rad)
    $beta = ASin(Abs($yPt - $yR) / $Rad)
    $Alpha1 = $beta * $Rad2Deg
    Select
        Case $yPt > $yR
            $Alpha2 = 180 - $Alpha1
        Case $yPt <= $yR
            $Alpha2 = 180 + $Alpha1
            $Alpha1 = 360 - $Alpha1
    EndSelect

    $Result1 = _AngleInRange($Alpha1, $StAngle, $Sw) And ($Rad * Abs(Cos($beta)) + $xR) > $xPt
    ;mgConsoleWrite("is " & $Alpha1 & " in range " & $StAngle & " to " & $StAngle + $Sw & " = " & $Result1 & @CRLF)

    ;if alpha2 is 90 or 270 then alpha1 is as well and we mustn't count the same point twice if it's the end of the arc
    ;but we only have to check 270 because 90 is the top which is always false if it's an end of the arc
    If $Alpha2 = 270 And _OneIsSameAngle($StAngle, $StAngle + $Sw, 270) Then
        $Result2 = False
    Else
        $Result2 = _AngleInRange($Alpha2, $StAngle, $Sw) And (-$Rad * Abs(Cos($beta)) + $xR) > $xPt
        ;mgConsoleWrite("1547:result2 = " & $Result2 & @CRLF)
    EndIf

    $Result = BitXOR($Result1, $Result2) = 1
    ;mgConsoleWrite("bitor(" & $Result1 & ', ' & $Result2 & ") = " & $Result & @CRLF)
    Return $Result
EndFunc   ;==>_IsPtInArc

;==== _OneIsSameAngle =============
;detrmines if only one of 2 angle is the same as a third
;by martin
Func _OneIsSameAngle($A, $B, $C)
    _SetAngle($A)
    _SetAngle($B)
    _SetAngle($C)

    Return BitXOR(($A = $C), ($B = $C))

EndFunc   ;==>_OneIsSameAngle

;============= SetAngle =====================
;converts the angle to be in range 0 to < 360
Func _SetAngle(ByRef $aS)
    While $aS < 0
        $aS += 360
    WEnd

    While $aS >= 360
        $aS -= 360
    WEnd

    Return $aS
EndFunc   ;==>_SetAngle

;========== _AngleInRange =====================
; is $ang in range $startA to $startA + $sweepA
;if $ExcludeTops is True (default) then a value of $ang equal to the start or the end angle is excluded
;from the match, ie returns false, if that end is higher than the next point to it on the arc.
;V2 11 April 2011 Added $ExcludeTops parameter.
;moved logic to detct tops to after finding if the angle was included or not
Func _AngleInRange($ang, $startA, $sweepA, $ExcludeTops = True)
    Local $S1, $e1, $temp
    Local $aa, $bb, $Result

    If $sweepA >= 360 Then Return True

    $aa = $startA
    _SetAngle($aa)

    $bb = $startA + $sweepA
    _SetAngle($bb)


    If $sweepA < 0 Then
        $S1 = $startA + $sweepA
        $e1 = $startA
    Else
        $S1 = $startA
        $e1 = $startA + $sweepA
    EndIf

    While $S1 < 0
        $S1 += 360
        $e1 += 360
    WEnd

    While $ang < $S1
        $ang += 360
    WEnd

    While $ang > $e1
        $ang -= 360
    WEnd


    If $ang < $S1 Or $ang > $e1 Then Return False;$ang is not in the range


    ;set $ang again before we start comparing it
    _SetAngle($ang)

    If $ExcludeTops Then
        If $ang = $aa Then;check if start is a top or bottom type of end
            If $sweepA > 0 Then
                return ($ang >= 270 And $ang <= 360) Or ($ang >= 0 And $ang < 90)
            EndIf
            If $sweepA < 0 Then
                Return $ang > 90 And $ang <= 270
            EndIf

        EndIf

        If $ang = $bb Then; is end a top or bottom type
            If $sweepA < 0 Then
                return ($ang >= 270 And $ang <= 360) Or ($ang >= 0 And $ang < 90)
            EndIf
            If $sweepA > 0 Then
                Return $ang > 90 And $ang <= 270
            EndIf

        EndIf
    EndIf
    Return True
EndFunc   ;==>_AngleInRange
#endregion Is $TouchA within the corner and far end of A

Func _sinD($ang)
    _SetAngle($ang)
    Return Sin($ang * $Deg2Rad)
EndFunc   ;==>_sinD

Func _cosD($ang)
    _SetAngle($ang)
    Return Cos($ang * $Deg2Rad)
EndFunc   ;==>_cosD

Func _tanD($ang)
    _SetAngle($ang)
    Return Tan($ang * $Deg2Rad)
EndFunc   ;==>_tanD

Func _asinD($Val)
    Return ASin($Val) * $Rad2Deg
EndFunc   ;==>_asinD

Func _acosD($Val)
    Return ACos($Val) * $Rad2Deg
EndFunc   ;==>_acosD

Func _atanD($Val)
    Return ATan($Val) * $Rad2Deg
EndFunc   ;==>_atanD

Func Max($A, $B)
    $A = Number($A)
    $B = Number($B)
    If $A >= $B Then Return $A
    Return $B
EndFunc   ;==>Max

Func Min($A, $B)
    $A = Number($A)
    $B = Number($B)
    If $A >= $B Then Return $B
    Return $A
EndFunc   ;==>Min


; Returns an array containing the x, y position of the centroid of a polygon.
;by Malkey
Func _CentroidPoly($aPoints)
    Local $Med, $aRet[2], $MedX, $MedY, $area
    For $n = 1 To UBound($aPoints) - 2
        $MedX += ($aPoints[$n][0] + $aPoints[$n + 1][0]) * ($aPoints[$n][0] * $aPoints[$n + 1][1] - _
                $aPoints[$n + 1][0] * $aPoints[$n][1])
        $MedY += ($aPoints[$n][1] + $aPoints[$n + 1][1]) * ($aPoints[$n][0] * $aPoints[$n + 1][1] - _
                $aPoints[$n + 1][0] * $aPoints[$n][1])
    Next
    $area = _Shape_GetArea($aPoints)
    $aRet[0] = $MedX / ($area * 6)
    $aRet[1] = $MedY / ($area * 6)
    Return $aRet
EndFunc   ;==>_CentroidPoly

Func _ACosRound($A, $B)
    Return ACos(Round($A, $PREC) / Round($B, $PREC))

EndFunc   ;==>_ACosRound

Func _ASinRound($A, $B)
    Return ASin(Round($A, $PREC) / Round($B, $PREC))
EndFunc   ;==>_ASinRound
#cs  mental doodles


    ;------------ _SetPolyPointsCW -(neatenPolyPoints?) don't know what to call it yet--------------------
    ;arranges the lines in a polyLineARc into order and the direction specified by $ClockWise (True or False)
    ;If $MinInternalCornerRad is > 0 then internal corners wil be modified as needed to have the set radius.
    ;If $MinExternalCornerRad is > 0 then external corners wil be modified as needed to have the set radius.
    ;If $RemoveCrosOvers is True then lines which cross over will be cut back to the intersection. This is done before $CloseGaps is applied.
    ;if $CloseGaps is true then the end of an unconnected line will be joined to the end of the nearest different unconnected line.
    ;	NB This feature is only intended to close polys or to fill in small but unintended gaps. If the gaps are large and there are
    ;      several then the result might not be what was wanted.
    ;      If $RemoveCrossovers is False then $CloseGaps will join the ends of crossed-over lines. This might not be what was intended.

    Func _SetPolyPointsCW($aP, $ClockWise, $MinInternalCornerRad = 0, $MinExternalCornerRad = 0, $RemoveCrosOvers = True, $CloseGaps = True)

    EndFunc   ;==>_SetPolyPointsCW
#ce

Func mgConsoleWrite($s)
    If $mgdebug Then ConsoleWrite($s & @CRLF)
EndFunc   ;==>mgConsoleWrite