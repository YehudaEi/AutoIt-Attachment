#include <HHash.au3>

MsgBox(1, "_GenHHash ()", "Your current computers hash:" & @LF & _GenHHash ())

MsgBox(1, "_CompareHHash()", "Comparing the computers hash against itself, should return 1." & @LF & "Return Value : " & _CompareHHash(_GenHHash()))