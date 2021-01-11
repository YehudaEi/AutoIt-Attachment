$fileopen = FileOpenDialog("Encriptor",@WorkingDir,"Mikidutza's crypting (*.mKd)")
$file = FileOpen($fileopen, 0)

Opt("TrayIconDebug",1)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf
   
SplashTextOn("Decrypting...","Please wait"&@CRLF&"Decrypting file...",150,50)
    $read = FileRead($file)
    If @error = -1 Then Exit
	$a = StringReplace($read,"'           '","a","",1)
	$b = StringReplace($a,"'            '","b","",1)
	$c = StringReplace($b,"'             '","c","",1)
	$d = StringReplace($c,"'              '","d","",1)
	$e = StringReplace($d,"'               '","e","",1)
	$f = StringReplace($e,"'                '","f","",1)
	$g = StringReplace($f,"'                 '","g","",1)
	$h = StringReplace($g,"'                  '","h","",1)
	$i = StringReplace($h,"'                   '","i","",1)
	$j = StringReplace($i,"'                    '","j","",1)
	$k = StringReplace($j,"'                     '","k","",1)
	$l = StringReplace($k,"'                      '","l","",1)
	$m = StringReplace($l,"'                       '","m","",1)
	$n = StringReplace($m,"'                        '","n","",1)
	$o = StringReplace($n,"'                         '","o","",1)
	$p = StringReplace($o,"'                          '","p","",1)
	$q = StringReplace($p,"'                           '","q","",1)
	$r = StringReplace($q,"'                            '","r","",1)
	$s = StringReplace($r,"'                             '","s","",1)
	$t = StringReplace($s,"'                              '","t","",1)
	$u = StringReplace($t,"'                               '","u","",1)
	$v = StringReplace($u,"'                                '","v","",1)
	$x = StringReplace($v,"'                                 '","x","",1)
	$y = StringReplace($x,"'                                  '","y","",1)
	$w = StringReplace($y,"'                                   '","w","",1)
	$z = StringReplace($w,"'                                    '","z","",1)
	$1 = StringReplace($z,"' '","1","",1)
	$2 = StringReplace($1,"'  '","2","",1)
	$3 = StringReplace($2,"'   '","3","",1)
	$4 = StringReplace($3,"'    '","4","",1)
	$5 = StringReplace($4,"'     '","5","",1)
	$6 = StringReplace($5,"'      '","6","",1)
	$7 = StringReplace($6,"'       '","7","",1)
	$8 = StringReplace($7,"'        '","8","",1)
	$9 = StringReplace($8,"'         '","9","",1)
	$0 = StringReplace($9,"'          '","0","",1)
	$ap = StringReplace($0,"'                                     '","'","",1)

	SplashOff()


	$sav = FileSaveDialog("Where do you want to save the dincrypted file?",@DesktopDir,"All type (*.*)",16)
	FileWrite($sav,$ap)


FileClose($file)