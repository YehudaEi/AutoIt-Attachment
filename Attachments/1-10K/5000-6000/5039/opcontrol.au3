#include <GUIConstants.au3>


; HANDLE THE TCP/IP CONNECTION
TCPStartup()
$ipAddress = String(InputBox("Poltergeist Control","Enter ip address to haunt:",@IPAddress1))
If $ipAddress = "" Then $ipAddress = @IPAddress1
$portAddress = 666

$connectedSocket = TCPConnect($ipAddress, $portAddress)
If @error Or $connectedSocket < 1 THEN
  MsgBox(0, "GUI Event", "Could not connect to IP: " & $ipAddress & " and PORT: " & $portAddress)
  EXIT
endIf


; SET UP THE MAIN GUI
GUICreate("OfficePoltergeist Control", 400, 350)
GUICtrlCreateLabel("OfficePoltergeist v1.1" & @CRLF & "                            ", 30, 10, 300, 30)
GUICtrlCreateLabel("Destination IP address:", 30, 50)
$ipDestination = GUICtrlCreateInput ( @IPAddress1, 30, 65, 210, 20)
$openCloseCDSoundButton = GUICtrlCreateButton("Open/Close CD", 250, 62, 120)

GUICtrlCreateLabel("Send a sound:", 30, 90)
$soundComboMenu = GUICtrlCreateCombo ("laugh", 30,105, 150) ; create first item
GUICtrlSetData($soundComboMenu,"howl|labsound|moan|psycho|scream|thunder|wind") ; add other item snd set a new default

$sendSoundButton = GUICtrlCreateButton("Send Sound", 250, 103, 120)

GUICtrlCreateLabel("Send text to keyboard:", 30, 130)
$keyboardText = GUICtrlCreateInput ( "redrum", 30, 145, 210, 20)
$sendKeyboardButton = GUICtrlCreateButton("Send Text", 250, 143, 120)

GUICtrlCreateLabel("Show alert box:", 30, 170)
$alertBoxText = GUICtrlCreateInput ( "pwn3d!", 30, 185, 210, 20)
$alertBoxButton = GUICtrlCreateButton("Send Message", 250, 183, 120)

GUICtrlCreateLabel("Monitor effects:", 30, 210)
$screenFlickerButton = GUICtrlCreateButton("Screen Flicker", 30, 225, 90)
$windowShakeButton = GUICtrlCreateButton("Window Shake", 120, 225, 90)
$moveLeftButton = GUICtrlCreateButton("Move Left", 30, 250, 90)
$moveRightButton = GUICtrlCreateButton("Move Right", 120, 250, 90)

$shutdownClientButton = GUICtrlCreateButton("Shutdown Server", 250, 305, 120)


GUISetState(@SW_SHOW)

; ... AND HERE'S THE MAIN LOOP
$repeatEndlessly = "yes"
While $repeatEndlessly = "yes"
  $msg = GUIGetMsg()
  
  $portAddress = 13013
  $ipAddress = GUICtrlRead($ipDestination);
  
  ; HANDLE COMMANDS
  Select
    Case $msg = $sendSoundButton
      $msg = "SOUNDSEND:" & GUICtrlRead($soundComboMenu)
      TCPSend($connectedSocket,$msg)
    
    Case $msg = $sendKeyboardButton
      $msg = "KEYBOARDSEND:" & GUICtrlRead($keyboardText)
      TCPSend($connectedSocket,$msg)
      
    Case $msg = $alertBoxButton
      $msg = "ALERTBOX:" & GUICtrlRead($alertBoxText)
      TCPSend($connectedSocket,$msg)
    
    Case $msg = $openCloseCDSoundButton
      $msg = "OPENCLOSECD:"
      TCPSend($connectedSocket,$msg)
      
    Case $msg = $screenFlickerButton
      $msg = "SCREENFLICKER:"
      TCPSend($connectedSocket,$msg)
    
    Case $msg = $windowShakeButton
      $msg = "WINDOWSHAKE:"
      TCPSend($connectedSocket,$msg)

    Case $msg = $shutdownClientButton
      $msg = "EXIT:"
      TCPSend($connectedSocket,$msg)
    
    Case $msg = $moveLeftButton
      $msg = "MOVELEFT:"
      TCPSend($connectedSocket,$msg)

    Case $msg = $moveRightButton
      $msg = "MOVERIGHT:"
      TCPSend($connectedSocket,$msg)
    
    Case $msg = $GUI_EVENT_CLOSE
      ExitLoop
  EndSelect
WEnd 
; END OF THE LOOP

TCPShutdown()
; SHUT'ER DOWN
