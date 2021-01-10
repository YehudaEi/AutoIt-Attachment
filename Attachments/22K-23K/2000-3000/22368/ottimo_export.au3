;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Dave Beanland
;
; Script Function:
;   converts a biesse file to Gabbiani format using Ottimo v7.57


; Prompt the user to run the script - use a Yes/No prompt (4 - see help file)
$answer = MsgBox(4, "AutoIt Example (English Only)", "are you fully trained in using this program?")


; Check the user's answer to the prompt (see the help file for MsgBox return values)
; If "No" was clicked (7) then exit the script
If $answer = 7 Then
    MsgBox(0, "AutoIt", "OK.  Bye!")
    Exit
EndIf


; Open DOS prompt & then copy files from network drive to local import folder
; Run("C:\WINDOWS\system32\cmd.exe")
; WinWaitActive("C:\WINDOWS\system32\cmd.exe")
; sleep(2000)
; select jobs from main menu
Send("!j")
; arrow down 2 and then select the import menu
Send("{down 2}")
Send("{ENTER}")

; arrow down & select "from cpout" format
Send("{down 5}")
Send("{ENTER}")

; tab down 6 times & select the first file in the list by sending space & then enter
Send("{tab 6}")
Send("{space}")
Send("{ENTER}")
; sleep(1000)

; send "f8" to pick export * then tab 4 times to the "ok" box & then enter
Send("{f8}")
Send("{tab 4}")
; sleep(1000)
Send("{ENTER}")
 sleep(500)

; ask the user if the file appeared to save the program ok
$answer = MsgBox(4, "AutoIt Example (English Only)", "did the file export ok & without errors? if so I will now delete that file")


; now select cancel and then enter to close the dialog box
Send("{tab}")
Send("{ENTER}")
; sleep(2000)

; close the diaglog box with ctrl & f4
Send("^{f4}")
; and then don't save with a alt + N
Send("!n")




; Check the user's answer to the prompt (see the help file for MsgBox return values)
; If "No" was clicked (7) then exit the script
If $answer = 7 Then
    MsgBox(0, "AutoIt", "I'll stop now & let you sort it- OK  Bye!")
    Exit
EndIf


; now delete the first file on the list if all has gone well
Send("!j")
; Send("!i")
Send("{down 2}")
Send("{ENTER}")


Send("{down 5}")
Send("{ENTER}")

Send("{tab 6}")
Send("{space}")


Exit

