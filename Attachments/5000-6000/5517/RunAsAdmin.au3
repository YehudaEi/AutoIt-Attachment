;#############################################################################
;# RunAsAdmin
;# version 0.0.2
;# installed on COMPUTER at YYYY.MM.DD HH.MM.SS 
;#############################################################################
;# Run a program or command as Administrator (or other User)
;# all settings are stored in an INI file
;# the INI can be set as commandline parameter /ini:<INI-File>
;# the default INI is RunAsAdmin.ini
;# if the INI is not found, it will be create
;# if there is no path set in <INI-File> it will be created 
;# in the path of the choosen program
;#############################################################################
;# (c) GST Informationsmanagement GmbH #    www.gst-im.de    #  perl@gst-im.de
;#############################################################################
;# created by Nathan von Alemann at 2005.10.23    
;# last modified (Version, YYYY.MM.DD, AUTHOR, what)
;# 0.0.2, 20051024  , NvA, /ini: and /? as commandline parameter
;#############################################################################
#include <string.au3>

; if /ini: set als commandline parameter
if ($CmdLine[0] > 0) Then
   For $i = 1 to $CmdLine[0]
      if StringInStr($CmdLine[$i], "/ini:") Then
         $iniFile = StringMid($CmdLine[$i], 6)
      Elseif StringInStr($CmdLine[$i], "/?") Then
         MsgBox(0,"Help","Run a program or command as Administrator (or other User) - _
                  All settings are stored in an INI file. _
                  The INI can be set as commandline parameter /ini:<INI-File> _
                  The default INI is RunAsAdmin.ini - _
                  If the INI is not found, it will be created. - _
                  If there is no path set in <INI-File> it will be created _
                  in the path of the choosen program.")
         Exit
      EndIf
   Next
; default settings for ini   
Else
   $iniFile = @ScriptDir & "\RunAsAdmin.ini"
EndIf


; get settings from ini
If FileExists($iniFile) Then
   $program = IniRead($iniFile, "RunAsAdmin", "Program", "NotFound")
   $user = IniRead($iniFile, "RunAsAdmin", "User", "NotFound")
   $password = IniRead($iniFile, "RunAsAdmin", "Password", "NotFound")
; ask settings if ini not exists
Else
   $program = FileOpenDialog("Program", "C:\", "All (*.*)" , 1)
   IniWrite ($iniFile, "RunAsAdmin", "Program", $program)
   $user = InputBox("User", "With what user you want to run it?", "Administrator", "", -1, -1, 0, 0)
   IniWrite ($iniFile, "RunAsAdmin", "User", $user)
   $password = InputBox("Password", "Please fill in the Password for local User: "&$user, "", "*", -1, -1, 0, 0)
   ; cryp passwd
   $password = _StringEncrypt (1, $password, "cFt6&zHn")
   IniWrite ($iniFile, "RunAsAdmin", "Password", $password)
EndIf 

if ($program = "") OR ($user="") OR ($password="") Then
  MsgBox(0,"Warning!", "Settings in "&@ScriptDir&" are not guilty! Please check "&$inifile)
   Exit
EndIf

; decrypt passwd
$password = _StringEncrypt (0, $password, "cFt6&zHn")

; set given user's permissions
RunAsSet($user, @Computername, $password)

Run($program)

; Reset user's permissions
RunAsSet()

Exit
