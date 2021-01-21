#include-once

;=============================================================================
;
; Function Name:   _GUICtrlCreateTable()
;
; Description:     Creates a table, resembling the html-style
;
; Syntax:          _GUICtrlCreateTable($left, $top, $rows, $cols, $width, $height, [$border])
;
; Parameter(s);        $left = left side of the table
;                    $top = top of the table
;                    $rows = number of rows to be created
;                    $cols = number of columns to be created
;                    $width = width of ONE cell
;                    $height = height of ONE cell
;                    $border = [optional] thickness of the border, default: 1
;
; Return Value(s): array[rows][cols], used to set values with GUICtrlSetData
;
; Note:            do NOT overwrite the returned array[0][0], it contains data for the _GUICtrlTableSpan() function
;
; Author:            rakudave <rakudave@gmx.net>
;=============================================================================


Func _GUICtrlCreateTable($_left, $_top, $_rows, $_cols, $_width, $_height, $_border = 1)
Local $_table[$_rows +1][$_cols +1]
$_table[0][0] = $_left & "|" & $_top & "|" & $_rows & "|" & $_cols & "|" & $_width & "|" & $_height & "|" & $_border
GUICtrlCreateLabel("",$_left,$_top, $_width * $_rows + $_rows * $_border + $_border +2, $_height * $_cols + $_cols * $_border + $_border +2)
If $_border > 0 then GUICtrlSetStyle(-1,$SS_BLACKFRAME)
for $x = 1 to $_rows
    for $y = 1 to $_cols
        GUICtrlCreateLabel("",($x -1) * $_width + $_left + $x * $_border +1,($y -1) * $_height + $_top + $y * $_border +1, $_width, $_height)
        If $_border > 0 then GUICtrlSetStyle(-1,$SS_BLACKFRAME)
        $_table[$x][$y] = GUICtrlCreateLabel("",($x -1) * $_width + $_left + $x * $_border +4,($y -1) * $_height + $_top + $y * $_border +4, $_width -6, $_height -6)
    next
next
return $_table
Endfunc

;=============================================================================
;
; Function Name:   _GUICtrlTableSpan()
;
; Description:     this function is used to unite some cells created by _GUICtrlCreateTable()
;
; Syntax:          _GUICtrlTableSpan($id, $from_row, $from_col, $to_row, $to_col)
;
; Parameter(s);        $id = the parameter returned by _GUICtrlCreateTable()
;                    $from_row = left index of the first cell to unite
;                    $from_col = top index of the first cell
;                    $to_row = left index of the last cell
;                    $to_col = top index of the last cell
;
; Return Value(s): the new parameter of the combined cell
;
; Author:            rakudave <rakudave@gmx.net>
;=============================================================================

Func _GUICtrlTableSpan($_id, $from_row, $from_col, $to_row, $to_col)
$_tabledata = Stringsplit($_id[0][0],"|");$_left, $_top, $_rows, $_cols, $_width, $_height, $_border
for $x = $from_row to $to_row
    for $y = $from_col to $to_col
        GUICtrlDelete($_id[$x][$y])
    next
next
GUICtrlCreateLabel("",$_tabledata[1] + ($from_row - 1) * $_tabledata[5] + $from_row * $_tabledata[7] +1, $_tabledata[2] + ($from_col - 1) * $_tabledata[6] + $from_col * $_tabledata[7] +1,($to_row - $from_row + 1) * $_tabledata[5] + ($to_row -$from_row) * $_tabledata[7],($to_col - $from_col + 1) * $_tabledata[6] + ($to_col - $from_col) * $_tabledata[7])
If $_tabledata[7] > 0 then GUICtrlSetStyle(-1,$SS_BLACKFRAME)
GUICtrlCreateLabel("",$_tabledata[1] + ($from_row - 1) * $_tabledata[5] + $from_row * $_tabledata[7] +2, $_tabledata[2] + ($from_col - 1) * $_tabledata[6] + $from_col * $_tabledata[7] +2,($to_row - $from_row + 1) * $_tabledata[5] + ($to_row -$from_row) * $_tabledata[7] -2,($to_col - $from_col + 1) * $_tabledata[6] + ($to_col - $from_col -1) * $_tabledata[7] + $_tabledata[7] -2)
$_id[$from_row][$from_col] = GUICtrlCreateLabel("",$_tabledata[1] + ($from_row - 1) * $_tabledata[5] + $from_row * $_tabledata[7]  +4, $_tabledata[2] + ($from_col - 1) * $_tabledata[6] + $from_col * $_tabledata[7] + $_tabledata[7] +2,($to_row - $from_row + 1) * $_tabledata[5] + ($to_row -$from_row -1) * $_tabledata[7] -4,($to_col - $from_col + 1) * $_tabledata[6] + ($to_col - $from_col -1) * $_tabledata[7] -4)
return $_id[$from_row][$from_col]
Endfunc