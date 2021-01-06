; Proof-of-Concept for a net-send-based messenger program
; CyberSlug:  Original code 3 July 2004
; Revised for new GUI syntax 10 December 2004
; Gui Recode to 3.1.1 15 August 2005
; Update with own code by evod510 2005 


#include <GuiConstants.au3>

RunWait("net start messenger","",@SW_HIDE) ;Make sure messenger service is running

Opt("WinWaitDelay", 10)  ;speeds things up a little
$MyGui = GuiCreate("NetSend", 450,359,(@DesktopHeight-392)/2, (@DesktopHeight-359)/2 , 0x04CF0000)
;Controls might have word-wrap and/or read-only styles... maybe also styles to always show scroll bar...

$txt_output = GuiCtrlCreateEdit("", 10, 10, 433, 170, 0x50231904, 0x00000200)
;$txt_input = GuiCtrlCreateEdit("Message goes here.", 10, 230, 370, 70, 0x50231104)

$txt_input = GuiCtrlCreateEdit("Message goes here.", 10, 230, 370, 40, 0x50231104)

GuiCtrlSetState($txt_input, $GUI_FOCUS) ;default control with focus

$button_send = GUICtrlCreateButton("{Enter} == Send", 20, 300, 150, 30)

$checkbox_topmost = GuiCtrlCreateCheckbox("Always On Top", 210, 190, 150, 30, $BS_PUSHLIKE) ;looks like button....
   GuiCtrlSetState($checkbox_topmost, $GUI_CHECKED) ;checkbox will be pushed in by default

$button_sendclear = GUICtrlCreateButton("Clear", 10, 190, 100, 30)
   
;;;;;;;;;;;;;;;;;;;;;;CHECHBOX USERLIST NAME START;;;;;;;;;;;;;;;;;;;;

$checkCN = GUICtrlCreateCheckbox ("jack", 280, 280, 100, 20)
$checkCN2 = GUICtrlCreateCheckbox ("jerry", 385, 320, 100, 20)
$checkCN3 = GUICtrlCreateCheckbox ("shelly", 385, 300, 100, 20)
$checkCN4 = GUICtrlCreateCheckbox ("jones", 280, 300, 100, 20)
$checkCN5 = GUICtrlCreateCheckbox ("noel", 385, 280, 100, 20)
$checkCN6 = GUICtrlCreateCheckbox ("nick", 385, 240, 100, 20)
$checkCN7 = GUICtrlCreateCheckbox ("lyan", 385, 340, 100, 20)
$checkCN8 = GUICtrlCreateCheckbox ("betty", 280, 320, 100, 20)
$checkCN9 = GUICtrlCreateCheckbox ("david", 280, 340, 100, 20)
$checkCN10 = GUICtrlCreateCheckbox ("fisher", 385, 260, 100, 20)
;$MainCheck = GUICtrlCreateCheckbox("Select/Unselect", 390, 130, 120, 20)
;;;;;;;;;;;;;;;;;;;;;;CHECHBOX USERLIST NAME END;;;;;;;;;;;;;;;;;;;;; 

GuiSetState(@SW_SHOW)

GUICtrlSendMsg($txt_input, 0xB1, 0, 99999) ;I want the sample text message to be highlighted upon start

WinSetOnTop($MyGui, "", 1) ;always on top by default...

;MAIN MESSAGE LOOP
While 1
    sleep(5) ;sleep to prevent maxing out the CPU
    ; I want to trap the Enter key (but only when this GUI is active) so that it causes
    ;   the message in the textbox to be send
    If WinActive($MyGui) Then
        HotKeySet("{Enter}", "EnterSends") ;register hotkey when our GUI messenger window is active
    Else
        HotKeySet("{Enter}") ;un-register hotkey otherwise
    EndIf
    
    ; Constantly poll to see if a Net Send Popup has appeared.  If so, grab its contents and close it.
    If WinExists("Messenger Service", "Message from") Then
      Local $i, $t = ""
      $text = StringSplit( StringReplace(WinGetText("Messenger Service","Message from"),@CRLF,@LF) , @LF)
      WinClose("Messenger Service", "Message from")
      
      $sender = StringMid($text[2], 14, StringInStr($text[2]," to ")-14 )
      $t = ""
      For $i = 4 to $text[0]
        $t = $t & $text[$i] & @CRLF
      Next
      $t = StringStripWS($t, 2) ;strip trailing whitespace
      
      ; Display contents from the Popup in the form '<TIME> SENDER: Message'
      
     GUICtrlSetData($txt_output, GUICtrlRead($txt_output) & "<" & @Hour & ":" & @Min & ":" & @Sec & "> " & $sender & ":  " & $t & @CRLF)
   
	  ;ControlFocus($MyGui, "", $txt_input) ;return focus back to the input field
	  ControlFocus($MyGui, "", $txt_input)

      
    If WinActive ( "NetSend") Then
       TrayTip("clears any tray tip","",0)
     Else
     TrayTip("", "NetSend", 5) 
     Sleep(1)
     EndIf     

      
   EndIf
    
    $msg = GuiGetMsg()  ; Get any GUI messag events
   
    Select
    Case $msg = $GUI_EVENT_CLOSE
        Exit
    Case $msg = $button_send
        EnterSends()
    Case $msg = $button_sendclear
        Enterclear()    
    Case $msg = $checkbox_topmost
        If GUICtrlRead($checkbox_topmost) = 1 Then
            WinSetOnTop($MyGui, "", 1) ;checked for 'always on-top' window
        Else
            WinSetOnTop($MyGui, "", 0) ;unchecked for normal window
        EndIf
    EndSelect
WEnd
Exit

Func EnterSends()
    
;;;;;;;;;;;;;;;;;;;;;;CHECHBOX USERLIST START;;;;;;;;     
    $state1 = GUICtrlRead($checkCN)
    $state2 = GUICtrlRead($checkCN2)
    $state3 = GUICtrlRead($checkCN3)
    $state4 = GUICtrlRead($checkCN4)  
    $state5 = GUICtrlRead($checkCN5)
    $state6 = GUICtrlRead($checkCN6)
    $state7 = GUICtrlRead($checkCN7)
	$state8 = GUICtrlRead($checkCN8)  
    $state9 = GUICtrlRead($checkCN9)
    $state10 = GUICtrlRead($checkCN10)
   ;;;;;;;;;;;;;;;;;;;;;;CHECHBOX USERLIST END;;;;;;;;; 

    ControlFocus($MyGui, "", "Edit2")
    If StringStripWS(GUICtrlRead($txt_input), 3) = "" Then Return
    Local $message = """" & GUICtrlRead($txt_input) & """"  ;wrap message in quotes
    Local $message2 = @ComputerName & " : " & GUICtrlRead($txt_input)  ;wrap message in quotes
       
;;;;;;;;;;;;;;;;;;;;;;CHECHBOX USERLIST NAME 2 START;;;;;;;;   
  if $state1 = 1 Then 
     $arg1 = "jack"
     Run('net send ' & $arg1 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg1 = ""
  EndIf
  If $state2 = 1 Then
     $arg2 = "jerry"
     Run('net send ' & $arg2 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg2 = ""
  EndIf
  if $state3 = 1 Then 
     $arg3 = "shelly"
     Run('net send ' & $arg3 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg3 = ""
  EndIf
  If $state4 = 1 Then
     $arg4 = "jones"
     Run('net send ' & $arg4 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg4 = ""
  EndIf
  If $state5 = 1 Then 
     $arg5 = "noel"
     Run('net send ' & $arg5 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg5 = ""
  EndIf
  If $state6 = 1 Then
     $arg6 = "nick"
     Run('net send ' & $arg6 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg6 = ""
  EndIf  
  If $state7 = 1 Then
     $arg7 = "lyan"
     Run('net send ' & $arg7 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg7 = ""
 EndIf 
   If $state8 = 1 Then
     $arg8 = "betty"
     Run('net send ' & $arg7 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg8 = ""
 EndIf 
   If $state9 = 1 Then
     $arg9 = "david"
     Run('net send ' & $arg9 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg9 = ""
 EndIf 
   If $state10 = 1 Then
     $arg10 = "fisher"
     Run('net send ' & $arg10 & ' "' & $message & '"', '', @SW_HIDE)
  Else
     $arg10 = ""
  EndIf 
;;;;;;;;;;;;;;;;;;;;;;CHECHBOX USERLIST NAME 2 END;;;;;;;;; 

    GuiCtrlSetData($txt_output, GUICtrlRead($txt_output) & "<" & @Hour & ":" & @Min & ":" & @Sec & "> " & $message2 & @CRLF)
    GuiCtrlSetData($txt_input, '')  ;clear contents of textbox
 EndFunc
 
 Func Enterclear()
    GuiCtrlSetData($txt_output, '')  ;clear contents of textbox Message Typed and Received, you dont anybody else to read your message!!
 EndFunc