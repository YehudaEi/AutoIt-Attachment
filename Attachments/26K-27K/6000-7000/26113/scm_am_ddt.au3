;
; AutoIt Version: 3.0
; Language:       English
; Platform:       WinXP
; Author:         Priyanshu Shah
; Date:           8th May,2009

; Script Function:
;   launches and verifies Sunrise Access Manager.
;


; Prompt the user to run the script - use a abort/retry/ignore prompt (4 - see help file)
;MsgBox(4,"Launching Sunrise Access Manager.")


; Launch Sunrise Access Manager
;#include <C:\sample_scripts\globalvar.au3>
#include "C:\sample_scripts\globalvar.au3"
 Run("C:\Program Files\Eclipsys Sunrise\Clinical Manager Client\5.7.1704.0\am.exe")

 
 send("DELETE");
 Sleep(2000) ;
 AutoItSetOption("SendKeyDelay", 400)
 send($uname);
 

 ; Use AutoItSetOption to slow down the typing speed so we can see it :)
 AutoItSetOption("SendKeyDelay", 400)
 send("{TAB}");
 AutoItSetOption("SendKeyDelay", 400)
 send($passwd);
 ;ControlClick("Sunrise","","[CLASS:Button; TEXT:Finish; INSTANCE:2]");
 ControlClick("Sunrise","","[ID:3233]");
 AutoItSetOption("SendKeyDelay", 400)

