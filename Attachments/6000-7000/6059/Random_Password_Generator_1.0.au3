#include <Array.au3>
opt("trayicondebug", 1)

$x = 26
$pwdlength = InputBox("Password Length","How long do you want your password to be?"&@lf&"Default is 8 max is 32",8)
$z = 11
dim $Lowercase[$x]
dim $Uppercase[$x]
Dim $Password[$pwdlength]
Dim $Numeric[10]
Dim $Special[$z]
DIm $pos[$pwdlength]
Dim $req[4]
$req[0] = "Lowercase"
$req[1] = "Uppercase"
$req[2] = "Numeric"
$req[3] = "Special"


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

$Uppercase_size = Ubound($uppercase)
$Lowercase_size = Ubound($Lowercase)
$numeric_size = Ubound($numeric)
$Special_Size = UBound($Special)

_randompassword()
$rndm_pass =_ArrayToString($Password," ")    ;        convert all elements of the $password Array into a String called $RNDPASS
$rndm_pass = StringReplace($rndm_pass," ","");        Eleminate the spaces from the $rndmpass String
MsgBox(0,"password",$rndm_pass)
exit

Func _randompassword()
For $j = 0 to 3
    $pos[$j] = random(0, $pwdlength -1,1)
    if     isstring($Password[$pos[$j]])= 1 Then
        do
        $pos[$j] = random(0, $pwdlength -1,1)
        until isstring($Password[$pos[$j]])= 0
    endif
        $req_crit=$req[$j];    ex: $reg[$j] = lowercase
        $req_crit_array = eval($req_crit) ;ex; $test = $lowercase
        $password[$pos[$j]] = $req_crit_array[random(0,eval($req_crit&"_Size")-1,1)]
next

For $j = 4 to $pwdlength-1
    $pos[$j] = random(0, $pwdlength -1,1)
    if     isstring($Password[$pos[$j]])= 1 Then
        do
        $pos[$j] = random(0, $pwdlength -1,1)
        until isstring($Password[$pos[$j]])= 0
    endif
    $random_crit = $req[random(0,3,1)]
    $random_crit_array = eval($random_crit)
    $password[$pos[$j]] = $random_crit_array[random(0,eval($random_crit&"_Size")-1,1)]
next

EndFunc

