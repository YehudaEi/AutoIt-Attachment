#include<factorial.au3>
MsgBox(0, "Factorial UDF", "Factorial Testing")
MsgBox(0, "0!", "Should be 1:" & @CRLF & _MathFactorial(0)) ;0! defined as 1
MsgBox(0, "1!", "Should be 1:" & @CRLF & _MathFactorial(1)) ;1 = 1
MsgBox(0, "2!", "Should be 2:" & @CRLF & _MathFactorial(2)) ;2*1 = 2
MsgBox(0, "3!", "Should be 6:" & @CRLF & _MathFactorial(3)) ;3*2*1 = 6
MsgBox(0, "4!", "Should be 24:" & @CRLF & _MathFactorial(4)) ;4*3*2*1 = 24

MsgBox(0, "Factorial UDF", "Permutation Testing")
MsgBox(0, "1 P 0", "Should be 1:" & @CRLF & _MathPermutation(1, 0)) ;One way to have no output
MsgBox(0, "1 P 1", "Should be 1:" & @CRLF & _MathPermutation(1, 1)) ;One way to have 1 number in order
MsgBox(0, "7 P 3", "Should be 210:" & @CRLF & _MathPermutation(7, 3)) ;210 ways to order 7,6,5
MsgBox(0, "10 P 6", "Should be 151200:" & @CRLF & _MathPermutation(10, 6)) ;151200 ways to order 10,9,8,7,6,5
MsgBox(0, "15 P 3", "Should be 2730" & @CRLF & _MathPermutation(15, 3)) ;2730 ways to order 15,14,13