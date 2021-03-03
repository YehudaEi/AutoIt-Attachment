#include <Word.au3>
global $Alphabet[4][2]=[["C-11",'Apple'],['C-12',"Banana"],['C-13','Candy'],['C-14','Donut']]
$Fullpath = "C:\Users\andrew\Documents\Test.doc"
$oWordApp = _WordCreate($Fullpath)
$oDoc = _WordDocOpen ($oWordApp, $Fullpath,1)
for $i=0 to UBound($Alphabet,1) -1
	_WordDocFindReplace($oDoc,$Alphabet[$i][0],$Alphabet[$i][1])
Next

;this is a control test
_WordDocFindReplace($oDoc,"C-15","Eggplant")

For $i = 3 to 1 step -1
	ToolTip("Closing in "&$i, 0,0,"Closing")
	Sleep(1000)
Next

for $i=0 to UBound($Alphabet,1) -1
	_WordDocFindReplace($oDoc,$Alphabet[$i][1],$Alphabet[$i][0])
Next
_WordDocFindReplace($oDoc,"Eggplant","C-15")

_WordDocClose($oDoc)
_WordQuit($oWordApp)