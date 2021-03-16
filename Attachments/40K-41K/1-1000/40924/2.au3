#include "_TFTP.au3"

$start = _TFTP_Register()
$rrq = _TFTP_RRQ(@IPAddress1, "69", "tftpd32.exe", @ScriptDir)
ConsoleWrite($TFTPErr &@CR & $WSAErr & @CR & @error)
$stop = _TFTP_UnRegister()
