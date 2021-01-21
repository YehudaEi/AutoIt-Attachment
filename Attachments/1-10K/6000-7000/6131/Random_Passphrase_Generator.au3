; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------
#include <file.au3>
#include<Array.au3>
opt("trayicondebug", 1)

$x = 26
;~ $pwdlength = InputBox("Password Length","How long do you want your password to be?"&@lf&"Default is 8 max is 32",8)
$pwdlength = 8
$z = 11
dim $Lowercase[$x]
dim $Uppercase[$x]
Dim $Password[$pwdlength]
Dim $Numeric[10]
Dim $Special[$z]
DIm $pos[$pwdlength]
Dim $req[4]
dim $file[4]
for $j = 0 to ($x-1)                         ;        Set Arrayitem = ASCII Char + Array position;;     
    $Lowercase[$j] = chr(97 + $j)
    $uppercase[$j] = chr(65 +$j)
Next

For $j = 0 to 9                                ;        Set Arrayitem = ASCII Char + Array position;;
    $Numeric[$j] = chr(48 + $j)
Next    

For $j = 0 to 10                            ;        Set Arrayitem = ASCII Char + Array position;;
    $special[$j] = chr(33 +$j)
Next
$req[0] = "Lowercase"
$req[1] = "Uppercase"
$req[2] = "Numeric"
$req[3] = "Special"

;~ for $j = 0 to 3
	$j = 0
	$file[$j] = $Req[$j] & ".txt"
	FileOpen($file[$j],0)
	$arraysize = _FileCountLines($file[$j])
	dim $lowercase_file[$arraysize]
;~ 	MsgBox(0,"",$req[$j]& $file[$j])
;~ 	dim ("$" & "
	
;~ 	$test_req = eval($req[$j]& "_file" 
;~ 	dim ("$" &($req[$j]& "_file")[$arraysize]
	_FileReadtoarray($file[$j], $Lowercase_file)
	_ArrayDelete($Lowercase_file, 0)
	_ArrayDelete($Lowercase_file,(UBound($Lowercase_file)-1))
;~ 	_ArrayDisplay($Lowercase_file, "Unsorted Lowercase_file")
	_ArraySort($Lowercase_file)
	_ArrayDisplay($Lowercase_file, "These are the passphrase Items (sorted alphabetically)")

$testString = InputBox("Enter Password","PLease enter your password: ")
$testarray = StringSplit($testString,"")
_ArrayDelete($testarray, 0)
dim $test_result[ubound($testarray)]
_ArrayDisplay($testarray, "")


for $j = 0 to (ubound($testarray) -1)
;~ 	$ele_key2 = _ArraySearch($Lowercase, $testarray[$j]) 
		$ele_key = _ArrayBinarySearch($Lowercase,$testarray[$j])
		$test_result[$j] = $lowercase_file[$ele_key]
;~ 		MsgBox(0,"",$ele_key2)
next
;~ msgbox(0,"",_ArraySearch($Lowercase, $testarray[$j]))
;~ _ArrayDisplay($test_result,"passphrase")
$rndm_pass =_ArrayToString($test_result,";")    ;        convert all elements of the $password Array into a String called $RNDPASS
$rndm_pass = StringReplace($rndm_pass,";","")
msgbox(0,"passphrase",$rndm_pass)
;~ _array

FileClose("lowercase.txt")