; Proof-of-Concept for a net-send-based messenger program
; CyberSlug:  Original code 3 July 2004
; Revised for new GUI syntax 10 December 2004

#cs -- example text from a popup window
<OK
Message from TECRAGUMP to TECRAGUMP on 7/3/2004 11:07:38 PM

sample_message_foo
>
#ce

#include <GuiConstants.au3>

;A pipe-separated list of the computer names (recipients) you want available in the combo box....
Global $computerList = @ComputerName & "|computerTwo|computerThree|"  ;keep the trailing pipe character!

RunWait("net start messenger","",@SW_HIDE) ;Make sure messenger service is running

Opt("WinWaitDelay", 10)  ;speeds things up a little
$MyGui = GuiCreate("NetSend Messenger...", 392,359,(@DesktopHeight-392)/2, (@DesktopHeight-359)/2 , 0x04CF0000)

;Controls might have word-wrap and/or read-only styles... maybe also styles to always show scroll bar...
$txt_output = GuiCtrlCreateEdit("", 10, 10, 370, 170, 0x50231904, 0x00000200)
$txt_input = GuiCtrlCreateEdit("Message goes here.", 10, 230, 370, 70, 0x50231104)
   GuiCtrlSetState($txt_input, $GUI_FOCUS) ;default control with focus
$button_send = GUICtrlCreateButton("{Enter} == Send", 10, 320, 150, 30)
$checkbox_topmost = GuiCtrlCreateCheckbox("Always On Top", 210, 190, 150, 30, $BS_PUSHLIKE) ;looks like button....
   GuiCtrlSetState($checkbox_topmost, $GUI_CHECKED) ;checkbox will be pushed in by default
$combo_recipients = GUICtrlCreateCombo("", 170, 320, 210, 250)
   ; All the StringLeft(...StringInStr...)) stuff just obtains the first item from the $computerList
   GuiCtrlSetData($combo_recipients, $computerList, StringLeft($computerList,StringInStr($computerList,"|")-1))
   GuiCtrlSetResizing($combo_recipients, 576)  ;prevent combo from disappearing when GUI is resized

GuiSetState(@SW_SHOW)
GuiSendMsg($txt_input, 0xB1, 0, 99999) ;I want the sample text message to be highlighted upon start

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
      GuiCtrlSetData($txt_output, GuiRead($txt_output) & "<" & @Hour & ":" & @Min & ":" & @Sec & "> " & $sender & ":  " & $t & @CRLF)
      ControlFocus($MyGui, "", $txt_input) ;return focus back to the input field
    EndIf
    
    $msg = GuiGetMsg()  ; Get any GUI messag events
    Select
    Case $msg = $GUI_EVENT_CLOSE
        Exit
    Case $msg = $button_send
        EnterSends()
    Case $msg = $checkbox_topmost
        If GuiRead($checkbox_topmost) = 1 Then
            WinSetOnTop($MyGui, "", 1) ;checked for 'always on-top' window
        Else
            WinSetOnTop($MyGui, "", 0) ;unchecked for normal window
        EndIf
    EndSelect
WEnd
Exit

; Function that actually sends the message to the recipient
Func EnterSends()
    ControlFocus($MyGui, "", "Edit2")
    If StringStripWS(GuiRead($txt_input), 3) = "" Then Return
    
    Local $message = """" & GuiRead($txt_input) & """"  ;wrap message in quotes
    Local $recipient = GuiRead($combo_recipients) ;recipient is the selected combo box item
    Run('net send ' & $recipient & ' "' & $message & '"', '', @SW_HIDE) ;SEND!!!
    GuiCtrlSetData($txt_input, '')  ;clear contents of textbox
EndFunc