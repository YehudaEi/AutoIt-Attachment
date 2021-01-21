; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Setup some useful options that you may want to turn on - see the helpfile for details.

; Expand all types of variables inside strings
;Opt("ExpandEnvStrings", 1)
;Opt("ExpandVarStrings", 1)

; Require that variables are declared (Dim) before use (helps to eliminate silly mistakes)
;Opt("MustDeclareVars", 1)


; ----------------------------------------------------------------------------
; Script Start - Add your code below here
; ----------------------------------------------------------------------------
;Created by the Reaper. 
;Send this baby to your friend for some slight amusement. Always funny the first time around. No real harm done.
;Tested by the Reaper.

AutoItSetOption("TrayIconHide", 1)

InviteFunc()
Func InviteFunc()
   MsgBox(0, "Beginning...", "Welcome to -=Reaper's Box of Fun=-, please press enter.")
   Sleep(1000)
   MsgBox(0, "This one goes out to...", "This one goes out to all those flamers, you guys rock! Please press enter.")
   Sleep(1000)
   MsgBox(0, "The first step of fun...", "Press enter to see me say 'hi'.")
   Run("C:\WINDOWS\Notepad.exe", "C:\WINDOWS")
   Sleep(1000)
   WinActivate("Untitled - Notepad")
   Send("hi")
   Sleep(2000)
   Send("{ENTER}Please don't press anything right now, thanks for your patience...{ENTER}This window will now close.")
   Sleep(5000)
   WinKill("Untitled - Notepad")
EndFunc

InterestingFunc()
Func InterestingFunc()
  MsgBox(0, "Now for a little fun...", "Press enter to have some fun.")
  Sleep(1000)
  MsgBox(0, "Do you know the answer?", "What is the Reaper's first name? Please enter your answer in the next window.")
  Sleep(1000)

   $myname = InputBox("Do you know the answer...", "Do you know the Reaper's first name? One hint: It isn't death. Please enter the correct answer.", "I don't know I'm stupid.") 
  
  If $myname = "Black" Then
     MsgBox(0, "Congratulations!", "You have guessed the Reaper's name. You will not be harmed.")
     Sleep(1000)
     MsgBox(0, "Continued...", "You deserve a little rest, as does your computer; you have 10 seconds to save your work.", 10)
     Sleep(1000)
     MsgBox(0, "Please...", "Send all of your complaints to /dev/null - Reaper")
     TrayTip("Virus Detected!", "Your computer has been infected with a virus called: 'Reaper's Revenge', your system needs to restore.", 10)
     Sleep(10000)
     Shutdown(2)
     TrayTip("...", "Bye!", 5)
  Else
     MsgBox(0, "Very bad...", "You have incorrectly guessed the Reaper's first name. Please press enter to recieve your punishment.")
     Sleep(1000)
     MsgBox(0, "Not good at all...", "You computer is not being infected with a virus...", 5)
     TrayTip("Virus Detected!", "A virus has been detected called 'Reaper's Revenge'. Your system will need to critically rebuild itself.", 10)
     Sleep(10000)
     MsgBox(0, "Please...", "send all of your complaints to /dev/null - Reaper")
     Sleep(1000)
     Shutdown(2)
     TrayTip("...", "Bye!", 5)
  EndIf
EndFunc
  