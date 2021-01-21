$key = ""

Dim $Bin
$Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion","DigitalProductID")
    MsgBox(4096, "WinDows Key: " , "PID: " & RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductId") & @CRLF & "Key: " & DecodeProductKey($bin) )


Dim $Bin
$Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration","DigitalProductId")
    MsgBox(4096, "IE Key: " , "PID: " & RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration", "ProductId") & @CRLF & "Key: " & DecodeProductKey($bin) )

For $i= 1 to 10
    $var = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office", $i)
    If @error <> 0 then ExitLoop
	RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\" & $var & "\Registration", 1)
    If @error == 0 then
	$key = $var
	ExitLoop
	EndIf
Next

if $key then
For $i= 1 to 10
    $var = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\" & $key & "\Registration", $i)
    If @error <> 0 then ExitLoop
    $num = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\" & $key & "\Registration\" & $var, "ProductName")
    $num1 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\" & $key & "\Registration\" & $var, "ProductID")
	Dim $Bin
	$Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\" & $key & "\Registration\" & $var,"DigitalProductId")
    MsgBox(4096, "Office:" , $num & " (" & $key & ") " & @CRLF & "PID: " & $num1 & @CRLF & "Key: " & DecodeProductKey($bin) )
Next
Else
MsgBox(16, "", "Not Find any M$ Office in this System :-(")
EndIf

	MsgBox(64, "Info", "That's ALL :-)")

Func DecodeProductKey($BinaryDPID)
   Local $bKey[15]
   Local $sKey[29]
   Local $Digits[24]
   Local $Value = 0
   Local $hi = 0
   local $n = 0
   Local $i = 0
   Local $dlen = 29
   Local $slen = 15
   Local $Result

   $Digits = StringSplit("BCDFGHJKMPQRTVWXY2346789","")

   $binaryDPID = stringmid($binaryDPID,105,30)

   For $i = 1 to 29 step 2
       $bKey[int($i / 2)] = dec(stringmid($binaryDPID,$i,2))
   next

   For $i = $dlen -1 To 0 Step -1
       If Mod(($i + 1), 6) = 0 Then
           $sKey[$i] = "-"
       Else
           $hi = 0
           For $n = $slen -1 To 0 Step -1
               $Value = Bitor(bitshift($hi ,- 8) , $bKey[$n])
               $bKey[$n] = int($Value / 24)
               $hi = mod($Value , 24)
           Next
           $sKey[$i] = $Digits[$hi +1]
       EndIf

   Next
   For $i = 0 To 28
       $Result = $Result & $sKey[$i]
   Next

   Return $Result
EndFunc
