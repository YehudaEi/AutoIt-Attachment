
$file = FileOpen("operation.txt", 1)


for $i = 1 To 100 Step 1
$Line1 = "Autoit BitAND ==> " & BitAND($i , $i + 5) & " FuncBit_AND ==> "  & Bit_AND($i, $i + 5) & _
"  NO ==> ( " & $i & " , " & $i + 5 & " )" 
$Line2 = "Autoit BitAND ==> " & BitAND(- $i , - ($i + 5)) & " FuncBit_AND ==> "  & Bit_AND(- $i, - ($i + 5)) & _
"  NO ==> ( " & - $i & " , " & - ($i + 5) & " )" 
$Line3 = "Autoit BitAND ==> " & BitAND($i , - ($i + 5)) & " FuncBit_AND ==> "  & Bit_AND($i, - ($i + 5)) & _
"  NO ==> ( " &  $i & " , " & - ($i + 5) & " )" 
$Line4 = "Autoit BitAND ==> " & BitAND(- $i , ($i + 5)) & " FuncBit_AND ==> "  & Bit_AND(- $i,  ($i + 5)) & _
"  NO ==> ( " & - $i & " , " &  ($i + 5) & " )" 

FileWriteLine($file,$Line1)
FileWriteLine($file,$Line2)
FileWriteLine($file,$Line3)
FileWriteLine($file,$Line4)

$Line1 = "Autoit BitOR ==> " & BitOR($i , $i + 5) & " FuncBit_OR ==> "  & Bit_OR($i, $i + 5) & _
"  NO ==> ( " & $i & " , " & $i + 5 & " )" 
$Line2 = "Autoit BitOR ==> " & BitOR(- $i , - ($i + 5)) & " FuncBit_OR ==> "  & Bit_OR(- $i, - ($i + 5)) & _
"  NO ==> ( " & - $i & " , " & - ($i + 5) & " )" 
$Line3 = "Autoit BitOR ==> " & BitOR($i , - ($i + 5)) & " FuncBit_OR ==> "  & Bit_OR($i, - ($i + 5)) & _
"  NO ==> ( " &  $i & " , " & - ($i + 5) & " )" 
$Line4 = "Autoit BitOR ==> " & BitOR(- $i , ($i + 5)) & " FuncBit_OR ==> "  & Bit_OR(- $i,  ($i + 5)) & _
"  NO ==> ( " & - $i & " , " &  ($i + 5) & " )" 

FileWriteLine($file,$Line1)
FileWriteLine($file,$Line2)
FileWriteLine($file,$Line3)
FileWriteLine($file,$Line4)

$Line1 = "Autoit BitXOR ==> " & BitXOR($i , $i + 5) & " FuncBit_XOR ==> "  & Bit_XOR($i, $i + 5) & _
"  NO ==> ( " & $i & " , " & $i + 5 & " )" 
$Line2 = "Autoit BitXOR ==> " & BitXOR(- $i , - ($i + 5)) & " FuncBit_XOR ==> "  & Bit_XOR(- $i, - ($i + 5)) & _
"  NO ==> ( " & - $i & " , " & - ($i + 5) & " )" 
$Line3 = "Autoit BitXOR ==> " & BitXOR($i , - ($i + 5)) & " FuncBit_XOR ==> "  & Bit_XOR($i, - ($i + 5)) & _
"  NO ==> ( " &  $i & " , " & - ($i + 5) & " )" 
$Line4 = "Autoit BitXOR ==> " & BitXOR(- $i , ($i + 5)) & " FuncBit_XOR ==> "  & Bit_XOR(- $i,  ($i + 5)) & _
"  NO ==> ( " & - $i & " , " &  ($i + 5) & " )" 

FileWriteLine($file,$Line1)
FileWriteLine($file,$Line2)
FileWriteLine($file,$Line3)
FileWriteLine($file,$Line4)
Next




Func Bit_AND($value1, $value2 , $value = '')
$BOOL =  IsNumber($value) Or StringStripWS($value, 8) = '' 
if IsNumber($value1) And IsNumber($value2) And ($BOOL) Then
Dim $TXT = "" ,$TXT2 = ""

$A = Twos($value1) ; convert Form Tens To Twos
$B = Twos($value2) ; convert Form Tens To Twos

If StringLen($A) > StringLen($B) Then
For $I = 1 To StringLen($A) - StringLen($B) Step 1
Select
Case $value2 >= 0 ; + value2 Or value2 = 0
$B = "0" & $B
Case $value2 < 0 ; - value2
$B = "1" & $B
EndSelect
Next
ElseIf StringLen($B) > StringLen($A) Then
For $I = 1 To StringLen($B) - StringLen($A) Step 1
Select
Case $value1 >= 0 ; + value1 Or value1 = 0
$A =  "0" & $A
Case $value1 < 0 ; - value2
$A = "1" & $A
EndSelect
Next
EndIf

$A = StringSplit($A,"")
$B = StringSplit($B,"")

for $I = $A[0] To 1 Step -1
Select 
Case $value1 < 0 And $value2 < 0
;Case operation ==> (-,-)
; $TXT = IsInt($C) & $TXT ; convert Form Tens (+A - 1) = -A To Twos + A with Out sign bit Look Func Twos
Select
Case $A[$i] & $B[$i] = '11'
$TXT = '0'
Case $A[$i] & $B[$i] = '00'
$TXT = '1'
Case $A[$i] & $B[$i] = '10'
$TXT = '1'
Case $A[$i] & $B[$i] = '01'
$TXT = '1'
EndSelect
Case Else 
;Case operation ==> (-,+) Or (+,-) Or (+,+) No sign bit Or sign bit = 0
Select
Case $A[$i] & $B[$i] = '11'
$TXT = '1'
Case $A[$i] & $B[$i] = '00'
$TXT = '0'
Case $A[$i] & $B[$i] = '10'
$TXT = '0'
Case $A[$i] & $B[$i] = '01'
$TXT = '0'
EndSelect
EndSelect
$TXT2 = $TXT & $TXT2
Next
$E = StringSplit($TXT2,"")
Select
Case StringStripWS($value, 8) = ''
If ($value1 < 0 And $value2 < 0) Then ; sign bit bitwise And (signbit ,signbit) / (1 And 1) = 1
Return (- (Tens($E) + 1))  ; convert From Twos To Tens And Add 1 For sign bit
Else
Return Tens($E) ; convert From Twos To Tens 
EndIf
Case StringStripWS($value, 8) <> ''
If ($value1 < 0 And $value2 < 0) Then ; sign bit bitwise And (signbit ,signbit) / (1 And 1) = 1
$A = (- (Tens($E) + 1)) ;; convert From Twos To Tens And Add 1 For sign bit
Else
$A = (Tens($E)) ; convert From Twos To Tens  // No sign bit Or sign bit = 0
EndIf
Bit_AND($A, $value,"")
EndSelect
Else
Return ""
EndIf
EndFunc


Func Bit_OR($value1, $value2 , $value = '')
$BOOL =  IsNumber($value) Or StringStripWS($value, 8) = '' 
if IsNumber($value1) And IsNumber($value2) And ($BOOL) Then
Dim $TXT = "" ,$TXT2 = ""

$A = Twos($value1) ; convert Form Tens To Twos
$B = Twos($value2) ; convert Form Tens To Twos

If StringLen($A) > StringLen($B) Then
For $I = 1 To StringLen($A) - StringLen($B) Step 1
Select
Case $value2 >= 0 ; + value2 Or value2 = 0
$B = "0" & $B
Case $value2 < 0 ; - value2
$B = "1" & $B
EndSelect
Next
ElseIf StringLen($B) > StringLen($A) Then
For $I = 1 To StringLen($B) - StringLen($A) Step 1
Select
Case $value1 >= 0 ; + value1 Or value1 = 0
$A =  "0" & $A
Case $value1 < 0 ; - value2
$A = "1" & $A
EndSelect
Next
EndIf
$A = StringSplit($A,"")
$B = StringSplit($B,"")
for $I = $A[0] To 1 Step -1
Select 
Case ($value1 < 0 And $value2 >= 0) Or ($value2 < 0 And $value1 >= 0) Or ($value1 < 0 And $value2 < 0) 
;Case operation ==> (-,+) Or (+,-) Or (-,-)
; $TXT = IsInt($C) & $TXT ; convert Form Tens (+A - 1) = -A To Twos + A with Out sign bit Look Func Twos
Select
Case $A[$i] & $B[$i] = '11'
$TXT = '0'
Case $A[$i] & $B[$i] = '00'
$TXT = '1'
Case $A[$i] & $B[$i] = '10'
$TXT = '0'
Case $A[$i] & $B[$i] = '01'
$TXT = '0'
EndSelect
Case Else ;operation ==> (+,+) No sign bit 
Select
Case $A[$i] & $B[$i] = '11'
$TXT = '1'
Case $A[$i] & $B[$i] = '00'
$TXT = '0'
Case $A[$i] & $B[$i] = '10'
$TXT = '1'
Case $A[$i] & $B[$i] = '01'
$TXT = '1'
EndSelect
EndSelect
$TXT2 = $TXT & $TXT2
Next
$E = StringSplit($TXT2,"")
Select
Case StringStripWS($value, 8) = ''
If ($value1 < 0 And $value2 >= 0) Or ($value2 < 0 And $value1 >= 0) Or ($value1 < 0 And $value2 < 0) Then 
; sign bit bitwise OR (signbit OR Number) (Number OR signbit) (signbit OR signbit) / (1 OR  1) = 1 / (1 OR  0) = 1 (0 OR  1) = 1 
; $TXT = IsInt($C) & $TXT ; convert Form Tens (+A - 1) = -A To Twos + A with Out sign bit Look Func Twos
Return (- (Tens($E) + 1)) ; convert From Twos To Tens And Add 1 For sign bit
Else
Return Tens($E) ; convert From Twos To Tens // No sign bit Or sign bit = 0
EndIf
Case StringStripWS($value, 8) <> ''
if ($value1 < 0 And $value2 >= 0) Or ($value2 < 0 And $value1 >= 0) Or ($value1 < 0 And $value2 < 0) Then 
; sign bit bitwise OR (signbit OR Number) (Number OR signbit) (signbit ,signbit) / (1 OR  1) = 1 / (1 OR  0) = 1 (0 OR  1) = 1 / (0 OR  0) = 1
; $TXT = IsInt($C) & $TXT ; convert Form Tens (+A - 1) = -A To Twos + A with Out sign bit Look Func Twos
$A = (- (Tens($E) + 1)) ; convert From Twos To Tens And Add 1 For sign bit
Else
$A = (Tens($E)) ; convert From Twos To Tens //No sign bit 
EndIf
Bit_OR($A, $value,"")
EndSelect
Else
Return ""
EndIf
EndFunc




Func Bit_XOR($value1, $value2 , $value = '')
$BOOL =  IsNumber($value) Or StringStripWS($value, 8) = '' 
if IsNumber($value1) And IsNumber($value2) And ($BOOL) Then
Dim $TXT = "" ,$TXT2 = ""

$A = Twos($value1) ; convert Form Tens To Twos
$B = Twos($value2) ; convert Form Tens To Twos

If StringLen($A) > StringLen($B) Then
For $I = 1 To StringLen($A) - StringLen($B) Step 1
Select
Case $value2 >= 0 ; + value2 Or value2 = 0
$B = "0" & $B
Case $value2 < 0 ; - value2
$B = "1" & $B
EndSelect
Next
ElseIf StringLen($B) > StringLen($A) Then
For $I = 1 To StringLen($B) - StringLen($A) Step 1
Select
Case $value1 >= 0 ; + value1 Or value1 = 0
$A =  "0" & $A
Case $value1 < 0 ; - value2
$A = "1" & $A
EndSelect
Next
EndIf

$A = StringSplit($A,"")
$B = StringSplit($B,"")

for $I = $A[0] To 1 Step -1
Select 
Case ($value1 < 0 And $value2 > 0) Or ($value2 < 0 And $value1 > 0)
;Case operation ==> (-,+) Or (+,-) 
; $TXT = IsInt($C) & $TXT ; convert Form Tens (+A - 1) = -A To Twos + A with Out sign bit Look Func Twos
Select
Case $A[$i] & $B[$i] = '11'
$TXT = '1'
Case $A[$i] & $B[$i] = '00'
$TXT = '1'
Case $A[$i] & $B[$i] = '10'
$TXT = '0'
Case $A[$i] & $B[$i] = '01'
$TXT = '0'
EndSelect
Case Else ;operation ==> (+,+) (-,-) // No sign bit Or sign bit = 0
Select
Case $A[$i] & $B[$i] = '11'
$TXT = '0'
Case $A[$i] & $B[$i] = '00'
$TXT = '0'
Case $A[$i] & $B[$i] = '10'
$TXT = '1'
Case $A[$i] & $B[$i] = '01'
$TXT = '1'
EndSelect
EndSelect
$TXT2 = $TXT & $TXT2
Next
$E = StringSplit($TXT2,"")
Select
Case StringStripWS($value, 8) = ''
If ($value1 < 0 And $value2 > 0) Or ($value2 < 0 And $value1 > 0) Then 
; sign bit bitwise exclusive OR (signbit XOR Number) (Number XOR signbit)  (1 XOR 0) = 1 (0 XOR 1) = 1 
; $TXT = IsInt($C) & $TXT ; convert Form Tens (+A - 1) = -A To Twos + A with Out sign bit Look Func Twos
Return (- (Tens($E) + 1)) ; convert From Twos To Tens And Add 1 For sign bit
Else
Return Tens($E)
EndIf
Case StringStripWS($value, 8) <> ''
If  ($value1 < 0 And $value2 > 0) Or ($value2 < 0 And $value1 > 0) Then 
; sign bit bitwise exclusive OR (signbit XOR Number) (Number XOR signbit)  (1 XOR 0) = 1 (0 XOR 1) = 1 
; $TXT = IsInt($C) & $TXT ; convert Form Tens (+A - 1) = -A To Twos + A with Out sign bit Look Func Twos
$A = (- (Tens($E) + 1)) ; convert From Twos To Tens And Add 1 For sign bit
Else
$A = (Tens($E)) ; convert From Twos To Tens //No sign bit Or sign bit = 0
EndIf
Bit_XOR($A, $value,"")
EndSelect
Else
Return ""
EndIf
EndFunc


Func Twos($A) ; convert Form Tens To Twos 
$C = $A
if($A < 0) Then $C = (abs($A) - 1) ; -A = (+A - 1) Look bitwise NOT
$TXT = ""
Do
$C = (int($C) / 2) ; / int($C)
if($A < 0) Then ; if -A
$TXT = IsInt($C) & $TXT ; convert Form Tens (+A - 1) = -A To Twos + A with Out sign bit
ElseIf ($A >= 0) Then ; ElseIf + A Or 0
$TXT = IsFloat($C) & $TXT ; convert Form +A To Twos +A
EndIf
Until(Int($C) < 1)
Return $TXT
EndFunc


Func Tens($B) ; convert From Twos To Tens
$D =0
$C =0
for $I = $B[0] To 1 Step -1
$D += ($B[$I] * POW(2 , $C)) ; convert From Twos To Tens
$C +=1 
Next
Return $D
EndFunc

Func POW($X , $Y)
$Z = 1
For $I = 1 To $Y  Step 1
$Z *= $X
Next
Return $Z
EndFunc


