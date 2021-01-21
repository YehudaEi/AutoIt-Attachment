#include <FTP.au3>; This line includes all the FTP functions you need. Open this file to see which functions contains exactly.

$server = 'ftp.host.com'
$username = 'username'
$pass = 'password'

$Open = _FTPOpen('MyFTP Control')
$Conn = _FTPConnect($Open, $server, $username, $pass)
$Ftpp = _FtpGetFile($Conn, 'folder/filename', 'c:\destination')
$Ftpc = _FTPClose($Open)