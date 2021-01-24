
Global $Paused

HotKeySet("+.", "ShowMessage")  ;Shift + . - it deactivates the program


$pass=InputBox ( "Motion Detector", "Please enter the password" , "" , "*")
if $pass="mypass" then ;you can edit the password as per your needs.
sleep (1000)

$checksum = PixelChecksum(0,0,1024,768)


While $checksum = PixelChecksum(0,0,1024,768)
  Sleep(100)

WEnd


SplashTextOn("Motion Detector", "You have gained an unauthorized access...turning the PC off for security reasons... - Motion Detector by SHAARAD DALVI", -1, -1, -1, -1, 4, "", 24)
Sleep(3000)
SplashOff()


$hour=@HOUR
$minute=@MIN
$second=@SEC
$day=@MDAY
$month=@MON
$year=@YEAR
FileOpen ( "Motion Detected.txt", 2 )
FileWriteLine("Motion Detected.txt","PC was handled by someone :" & $day & "/" & $month & "/" & $year & "     " & $hour & ":" & $minute & ":" & $second)
FileClose("Motion Detected.txt")



Dim $primary
Dim $secondary

$k = RegRead("HKEY_CURRENT_USER\Control Panel\Mouse", "SwapMouseButtons")


If $k = 1 Then
    $primary = "right"
    $secondary = "left"
Else
    $primary = "left"
    $secondary = "right"
EndIf
send ("{LWIN}")
send ("uuuuuuuuu")
Exit

Else
msgbox (64, "Motion Detector","Invalid Password....Abort....",5)
Exit
endif


While 1
    Sleep(100)
WEnd

Func ShowMessage()
    MsgBox(64,"Motion Detector","Motion Detector aborted....")
	Exit
EndFunc
