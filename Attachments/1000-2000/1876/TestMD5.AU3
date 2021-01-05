#include "MD5.AU3"

$sDigest = md5("a")
ConsoleWrite( "MD5(""a"")" & @CRLF )
ConsoleWrite( "   Expected: 0cc175b9c0f1b6a831c399e269772661" & @CRLF )
ConsoleWrite( "   Actual: " & $sDigest & @CRLF )

$sDigest = md5("abc")
ConsoleWrite( "MD5(""abc"")" & @CRLF )
ConsoleWrite( "   Expected: 900150983cd24fb0d6963f7d28e17f72" & @CRLF )
ConsoleWrite( "   Actual: " & $sDigest & @CRLF )

$sDigest = md5("message digest")
ConsoleWrite( "MD5(""message digest"")" & @CRLF )
ConsoleWrite( "   Expected: f96b697d7cb7938d525a2f31aaf161d0" & @CRLF )
ConsoleWrite( "   Actual: " & $sDigest & @CRLF )

$sDigest = md5("abcdefghijklmnopqrstuvwxyz")
ConsoleWrite( "MD5(""abcdefghijklmnopqrstuvwxyz"")" & @CRLF )
ConsoleWrite( "   Expected: c3fcd3d76192e4007dfb496cca67e13b" & @CRLF )
ConsoleWrite( "   Actual: " & $sDigest & @CRLF )

$sDigest = md5("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
ConsoleWrite( "MD5(""ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"")" & @CRLF )
ConsoleWrite( "   Expected: d174ab98d277d9f5a5611c2c9f419d9f" & @CRLF )
ConsoleWrite( "   Actual: " & $sDigest & @CRLF )

$sDigest = md5("12345678901234567890123456789012345678901234567890123456789012345678901234567890")
ConsoleWrite( "MD5(""12345678901234567890123456789012345678901234567890123456789012345678901234567890"")" & @CRLF )
ConsoleWrite( "   Expected: 57edf4a22be3c955ac49da2e2107b67a" & @CRLF )
ConsoleWrite( "   Actual: " & $sDigest & @CRLF )
