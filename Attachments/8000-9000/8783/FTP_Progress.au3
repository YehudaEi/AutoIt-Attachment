#include <GuiConstants.au3>
#include <ftp.au3>

$server = 'ftp.symantec.com'
$username = 'anonymous'
$pass = 'pass'
$ftp_dir = '/public/english_us_canada/antivirus_definitions/norton_antivirus/'
$ftp_file_mask = '*i32.exe*'
$target_dir = 'c:\'

; Note: this should be in support, i just noticed it wasn't
$DownloadNow = MsgBox(4,"Downloader","Soll das Norton Update jetzt heruntergeladen werden ?")
If $DownloadNow = 6 Then
    Download();you don't need to use call
Else
    ; Msgbox(0,"Downloader","Es wird nicht nach einem Update gesucht.")
    ; Run("OldFile.exe",2)
EndIf

Func Download()
		; ---- Sucht nach der aktuellen Datei ----
		; wird mittels FTP3.au gemacht.
		; - FTP.au3 Init -
		$Open = _FTPOpen('MyFTP Control')
		If @error Then Failed("Open")
		$Conn = _FTPConnect($Open, $server, $username, $pass)
		If @error Then Failed("Connect")

		Dim $Handle
		Dim $DllRect
		
		$FileInfo = _FtpFileFindFirst($Conn, $ftp_dir & $ftp_file_mask, $Handle, $DllRect)
		If $FileInfo[0] Then
		   Do
		;~        MsgBox(0, "Find", $FileInfo[1] & @CR & $FileInfo[2] & @CR & $FileInfo[3] & @CR & $FileInfo[4] & @CR & $FileInfo[5] & @CR & $FileInfo[6] & @CR & $FileInfo[7] & @CR & $FileInfo[8] & @CR & $FileInfo[9] & @CR & $FileInfo[10])
		       $dl_file = $FileInfo[10]
		       $FileInfo = _FtpFileFindNext($Handle, $DllRect)
		       
		   Until Not $FileInfo[0]    
		EndIf
		_FtpFileFindClose($Handle, $DllRect)
		
		; - FTP Verbindung schließen -
		_FTPClose($Open)
		;---------------------------------
		
		; - ftp-Connect-String bauen
		;MsgBox(0,"FTP File", "Lade runter: " & $dl_file)
		$ftp_conn_string = "ftp://" & $username & ":" & $pass & "@" & $server & $ftp_dir & $dl_file

		

    ;you must set progress on before loop
    ProgressOn("Download " & $dl_file,"", "", -1, -1, 16)
    
    InetGet($ftp_conn_string, $target_dir & $dl_file, 1, 1)
    
    ; need to divide by 1048576 also, variables that don't change should be outside loop
    $FileSize = InetGetSize($ftp_conn_string, )/1048576
    While @InetGetActive
        $filedownload = round(@InetGetBytesRead/1048576, 2)
        $Percent = Round(($filedownload/$FileSize)*100);need to mutliply by 10 to get percentage
        ProgressSet($Percent,"Downloaded - " & $filedownload & " Mb")
				TrayTip("Downloading...", "Downloaded = " & $filedownload & " Mb", 10, 16)
        Sleep(250)
    Wend
    ProgressOff()
EndFunc ;==>Download
