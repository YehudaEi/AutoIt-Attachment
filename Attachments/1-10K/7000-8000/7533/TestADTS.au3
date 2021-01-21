#include "ArrayToDisplayString.au3"

;Handles up to a 4-dimensional array of any size
;1-Dimensional Test
Dim $test1[2]
$test1[0] = "test1"
$test1[1] = "test2"
MsgBox(0,"", _ArrayToDisplayString($test1))
MsgBox(0,"", _ArrayToDisplayString($test1, 1))

;2-Dimensional Test
Dim $test2[2][2]
$test2[0][0] = "test1"
$test2[0][1] = "test2"
$test2[1][0] = "test3"
$test2[1][1] = "test4"
MsgBox(0,"", _ArrayToDisplayString($test2))
MsgBox(0,"", _ArrayToDisplayString($test2, 1))

;3-Dimensional Test
Dim $test3[2][2][2]
$test3[0][0][0] = "test1"
$test3[0][0][1] = "test2"
$test3[0][1][0] = "test3"
$test3[0][1][1] = "test4"
$test3[1][0][0] = "test5"
$test3[1][0][1] = "test6"
$test3[1][1][0] = "test7"
$test3[1][1][1] = "test8"
MsgBox(0,"", _ArrayToDisplayString($test3))
MsgBox(0,"", _ArrayToDisplayString($test3, 1))

;4-Dimensional Test
Dim $test4[2][2][2][2]
$test4[0][0][0][0] = "test1"
$test4[0][0][0][1] = "test2"
$test4[0][0][1][0] = "test3"
$test4[0][0][1][1] = "test4"
$test4[0][1][0][0] = "test5"
$test4[0][1][0][1] = "test6"
$test4[0][1][1][0] = "test7"
$test4[0][1][1][1] = "test8"
$test4[1][0][0][0] = "test9"
$test4[1][0][0][1] = "test10"
$test4[1][0][1][0] = "test11"
$test4[1][0][1][1] = "test12"
$test4[1][1][0][0] = "test13"
$test4[1][1][0][1] = "test14"
$test4[1][1][1][0] = "test15"
$test4[1][1][1][1] = "test16"
MsgBox(0,"", _ArrayToDisplayString($test4))
MsgBox(0,"", _ArrayToDisplayString($test4, 1))

;Also handles nested arrays!
;Nested Array Test
Dim $nested[2]
Dim $subtest1[2][2][2]
$subtest1[0][0][0] = "test1"
$subtest1[0][0][1] = "test2"
$subtest1[0][1][0] = "test3"
$subtest1[0][1][1] = "test4"
$subtest1[1][0][0] = "test5"
$subtest1[1][0][1] = "test6"
$subtest1[1][1][0] = "test7"
$subtest1[1][1][1] = "test8"
Dim $subtest2[2][2][2]
$subtest2[0][0][0] = "test9"
$subtest2[0][0][1] = "test10"
$subtest2[0][1][0] = "test11"
$subtest2[0][1][1] = "test12"
$subtest2[1][0][0] = "test13"
$subtest2[1][0][1] = "test14"
$subtest2[1][1][0] = "test15"
$subtest2[1][1][1] = "test16"
$nested[0] = $subtest1
$nested[1] = $subtest2
MsgBox(0,"", _ArrayToDisplayString($nested))
MsgBox(0,"", _ArrayToDisplayString($nested, 1))