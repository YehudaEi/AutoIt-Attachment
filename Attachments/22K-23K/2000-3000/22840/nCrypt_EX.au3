#include "nCrypt.au3"
$Crypted = _nCrypt(@ComputerName & ":" & @UserName & ":" & @DesktopDir, @AppDataDir)
$UserID = StringRight(StringLeft(StringMid(StringToBinary($Crypted), 50), 25), 10)
$Decrypted = _nCrypt($Crypted, @AppDataDir)
ConsoleWrite("Cryped:  " & $Crypted&@CRLF)
ConsoleWrite("User ID:  " & $UserID&@CRLF)
ConsoleWrite("Decrypted Data:  " & $Decrypted&@CRLF)