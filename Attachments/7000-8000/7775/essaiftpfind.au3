#include <ftp.au3>
dim $dl_file

$server = 'ftp.symantec.com'
$username = 'anonymous'
$pass = 'anonymous@test.de'

$Open = _FTPOpen('MyFTP Control')
If @error Then Failed("Open")
$Conn = _FTPConnect($Open, $server, $username, $pass)
If @error Then Failed("Connect")

Dim $Handle
Dim $DllRect

$FileInfo = _FtpFileFindFirst($Conn, '/public/english_us_canada/antivirus_definitions/norton_antivirus/*i32.exe*', $Handle, $DllRect)
If $FileInfo[0] Then
   Do
;~        MsgBox(0, "Find", $FileInfo[1] & @CR & $FileInfo[2] & @CR & $FileInfo[3] & @CR & $FileInfo[4] & @CR & $FileInfo[5] & @CR & $FileInfo[6] & @CR & $FileInfo[7] & @CR & $FileInfo[8] & @CR & $FileInfo[9] & @CR & $FileInfo[10])
       $dl_file = $FileInfo[10]
       $FileInfo = _FtpFileFindNext($Handle, $DllRect)
       
   Until Not $FileInfo[0]
   
    
EndIf


_FtpFileFindClose($Handle, $DllRect)
MsgBox(0,"FTP File", "téléchargé : " & $dl_file)
ProgressOn('Downloading', '')

$tmp = $username & ":" & $pass & "@" & $server & "/public/english_us_canada/antivirus_definitions/norton_antivirus/" & $dl_file
MsgBox(0,"ok",$tmp)
Local $netDnFileSize = InetGetSize($tmp)
MsgBox(0,"ok",$netDnFileSize)
;$Ftpg = _FTPGetFile($Conn, "/public/english_us_canada/antivirus_definitions/norton_antivirus/" & $dl_file,"c:\" & $dl_file)
InetGet($tmp,"c:\")

While @InetGetActive
    ProgressSet((@InetGetBytesRead / $netDnFileSize) * 100, '', 'Update' & "  " & Round((@InetGetBytesRead / $netDnFileSize) * 100) & '% Done')
    Sleep(250)
Wend
ProgressOff()





$Ftpc = _FTPClose($Open)
If @error Then Failed("Close")

Exit

Func Failed($F)
   MsgBox(0, "FTP", "Failed on: " & $F)
   Exit 1
EndFunc
