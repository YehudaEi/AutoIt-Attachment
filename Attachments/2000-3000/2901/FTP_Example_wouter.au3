#include "FTP.AU3"
$server = 'x.x.x.x'
$username = 'xxxx'
$pass = 'xxxx'

$Open = _FTPOpen('MyFTP Control')

$Conn = _FTPConnect($Open, $server, $username, $pass)
Msgbox (0,"connexion : ",$Conn)

$x=_sendcommand($Conn,"cwd /webclients/toto/")
Msgbox (0,"essai ftpcommand : ",$x)

$cur=_FtpGetCurrentDirectory($Conn)
Msgbox (0,"cur : ",$cur)

$x=_sendcommand($Conn,"mkd /tutu/")
Msgbox (0,"essai mkd : ",$x)

$make=_FTPMakeDir($Conn, "titi")
Msgbox (0,"make : ",$make)

$Ftpp = _FtpPutFile($Conn, 'c:/toto.txt', '/webclients/ddaf18.agriculture.gouv.fr/titi.txt')
Msgbox (0,"put file : ",$Ftpp)

;$x=_sendcommand($Conn,"stor c:/toto.txt")
;Msgbox (0,"essai command stor : ",$x)

$Ftpc = _FTPClose($Open)