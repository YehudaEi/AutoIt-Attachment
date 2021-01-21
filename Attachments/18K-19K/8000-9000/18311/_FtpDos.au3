;  .........: _FTPDOS :.........
; AutoIt Version: 3.2.10.0
; Description ...: Use FTP Commands With Ms-Dos - Convenient & Result
; Author ........: LlyKil - 14 Years Old


;  .........: _FtpDosSend :.........
; Description        : Send Files
; $yourhost          : Your host
; $YourUser      	 : Host YourUserName
; $yourpassword  	 : Your Password
; $localfile 	     : May be you will understand if you see example :D
; Example        	 : _FtpDosSend("yourhost.com", "YourUser", "YourPassWord", "C:\YourFile.txt")
Func _FtpDosSend($yourhost, $YourUser, $yourpassword, $localfile)
	Opt("WinTitleMatchMode", 4)
	Run("ftp " & $yourhost, "", @SW_HIDE)
	WinWait("classname=ConsoleWindowClass")
	$HWND = WinGetHandle("classname=ConsoleWindowClass")
	ControlSend($HWND, "", "", $YourUser & "{ENTER}")
	ControlSend($HWND, "", "", $yourpassword & "{ENTER}")
	ControlSend($HWND, "", "", "send " & $localfile & "{ENTER}")
	ControlSend($HWND, "", "", "bye{ENTER}")
EndFunc

;  .........: _FtpDosGet :.........
; Description        : Get Files
; $yourhost          : Your host
; $YourUser      	 : Host YourUserName
; $yourpassword  	 : Your Password
; $localfile 	 	 : May be you will understand if you see example :D
; $remotefile    	 : ________________________________________________
; Example        	 : _FtpDosGet("yourhost.com", "YourUser", "YourPassWord", "C:\YourFile.txt", "YourFile.txt")
Func _FtpDosGet($yourhost, $YourUser, $yourpassword, $localfile, $remotefile)
	Opt("WinTitleMatchMode", 4)
	Run("ftp " & $yourhost, "", @SW_HIDE)
	WinWait("classname=ConsoleWindowClass")
	$HWND = WinGetHandle("classname=ConsoleWindowClass")
	ControlSend($HWND, "", "", $YourUser & "{ENTER}")
	ControlSend($HWND, "", "", $yourpassword & "{ENTER}")
	ControlSend($HWND, "", "", "get " & $localfile & " " & $remotefile & "{ENTER}")
	ControlSend($HWND, "", "", "bye{ENTER}")
EndFunc

;  .........: _FtpDosDel :.........
; Description        : Del Files
; $yourhost          : Your host
; $YourUser      	 : Host YourUserName
; $yourpassword  	 : Your Password
; $remotefile        : May be you will understand if you see example :D
; Example       	 : _FtpDosDel("yourhost.com", "YourUser", "YourPassWord", "YourFile.txt")
Func _FtpDosDel($yourhost, $YourUser, $yourpassword, $remotefile)
	Opt("WinTitleMatchMode", 4)
	Run("ftp " & $yourhost, "", @SW_HIDE)
	WinWait("classname=ConsoleWindowClass")
	$HWND = WinGetHandle("classname=ConsoleWindowClass")
	ControlSend($HWND, "", "", $YourUser & "{ENTER}")
	ControlSend($HWND, "", "", $yourpassword & "{ENTER}")
	ControlSend($HWND, "", "", "del " & $remotefile & "{ENTER}")
	ControlSend($HWND, "", "", "bye{ENTER}")
EndFunc

;  .........: _FtpDosRen :.........
; Description        : Rename Files
; $yourhost          : Your host
; $YourUser      	 : Host YourUserName
; $yourpassword  	 : Your Password
; $remotefile    	 : May be you will understand if you see example :D
; $changefilename 	 : Name you want to change
; Example      	     : _FtpDosRen("yourhost.com", "YourUser", "YourPassWord", "YourFile.txt", "NameYouWant.txt")
Func _FtpDosRen($yourhost, $YourUser, $yourpassword, $remotefile, $changefilename)
	Opt("WinTitleMatchMode", 4)
	Run("ftp " & $yourhost, "", @SW_HIDE)
	WinWait("classname=ConsoleWindowClass")
	$HWND = WinGetHandle("classname=ConsoleWindowClass")
	ControlSend($HWND, "", "", $YourUser & "{ENTER}")
	ControlSend($HWND, "", "", $yourpassword & "{ENTER}")
	ControlSend($HWND, "", "", "rename " & $remotefile & " " & $changefilename & "{ENTER}")
	ControlSend($HWND, "", "", "bye{ENTER}")
EndFunc

;  .........: _FtpDosMkDir :.........
; Description        : Make A Folder or Directory
; $yourhost          : Your host
; $YourUser      	 : Host YourUserName
; $yourpassword  	 : Your Password
; $dir               : Folder or Directory
; Example            : _FtpDosMkDir("yourhost.com", "YourUser", "YourPassWord", "YouDir")
Func _FtpDosMkDir($yourhost, $YourUser, $yourpassword, $dir)
	Opt("WinTitleMatchMode", 4)
	Run("ftp " & $yourhost, "", @SW_HIDE)
	WinWait("classname=ConsoleWindowClass")
	$HWND = WinGetHandle("classname=ConsoleWindowClass")
	ControlSend($HWND, "", "", $YourUser & "{ENTER}")
	ControlSend($HWND, "", "", $yourpassword & "{ENTER}")
	ControlSend($HWND, "", "", "mkdir " & $dir & "{ENTER}")
	ControlSend($HWND, "", "", "bye{ENTER}")
EndFunc
