
;***********************
; Dan's Main Menu
; Coded by: Dan
; August 2, 2006
;Find Dan at:
;InvisionFreeSkins.com
;and JavaScriptFreek.com
;***********************

#include <GuiConstants.au3>
#include <Misc.au3>
Global $oRP

		   $name = InputBox("Log In", "Whats Your Name?")

; GUI
GUICreate("Dan's Main Menu", 400, 400)
GUISetIcon(@SystemDir & "\notepad.exe", 0)
$TagsPageC = GUICtrlCreateLabel('Visit Homepage', 5, 200, 100, 15, $SS_CENTER)
GUICtrlSetFont($TagsPageC, 9, 400, 4)
GUICtrlSetColor($TagsPageC, 0x0000ff)
GUICtrlSetCursor($TagsPageC, 0)


; TEXT
GUICtrlCreateLabel("If you have not noticed this already, the thing above this text is a tab. Pretty neat " & @CRLF & "eh? Well not really, but still ! Lalala this is some text. Blah blah I like muffins, and chocolate. Tribe No 1 Fan is a n00b. I like TEXT!" & @CRLF & "" & @CRLF & "-Dan", 10, 250, 400, 100)
$label = GuiCtrlCreateLabel("Logged in as: " &$name, 150, 4, 400, 15)
;GUICtrlSetStyle (-1, $SS_RIGHT )

; MENU
$filemenu = GUICtrlCreateMenu("File")
$fileitem = GUICtrlCreateMenuitem("Open...", $filemenu)
$recentfilesmenu = GUICtrlCreateMenu("Recent Files", $filemenu)
$separator1 = GUICtrlCreateMenuitem("", $filemenu)
$exititem = GUICtrlCreateMenuitem("Exit", $filemenu)
$helpmenu = GUICtrlCreateMenu("About")
$aboutitem = GUICtrlCreateMenuitem("About", $helpmenu)

; PROGRESS BAR
ProgressOn("Progress Meter", "Increments every second", "0 percent")
For $i = 1 To 100 Step 10
    ProgressSet($i, $i & " percent")
Next
ProgressSet(100, "Done", "Complete")
Sleep(500)
ProgressOff()


; TAB
GUICtrlCreateTab(1, 0, 400, 190)
GUICtrlCreateTabItem("Intro")
GUICtrlCreateLabel("Welcome to Dan's Menu Program." & @CRLF & " " & @CRLF & "Of course if you trust me you would be seeing this right now. Because this an " & @CRLF & ".exe file. Not everyone trust's them kind of files as they contain harmful virus. So " & @CRLF & "hats off you too. So, this is like my first favorite program I wrote. Sweet eh? Well " & @CRLF & "not really, but I still like it!", 20, 40, 400, 100)
GUICtrlCreateTabItem("Date")
GUICtrlCreateLabel("Todays date: " & @MON & " " & @WDAY & ", " & @YEAR & " " & @CRLF & "" & @CRLF & "So your name on the computer is: " & @UserName & "" & @CRLF & "" & @CRLF & "Screen resolution: " & @DesktopWidth & "x" & @DesktopHeight & "" & @CRLF & "" & @CRLF & "Operating System Version: " & @OSVersion & " ", 20, 40)
GUICtrlCreateTabItem("Contact")
GUICtrlCreateLabel("Find me at ZetaStyles.com! Username: Dan." & @CRLF & "" & @CRLF & "Got an IM? Want to quickly chat with me?" & @CRLF & "" & @CRLF & "MSN: Hunterz92@yahoo.com" & @CRLF & "" & @CRLF & "AIM: Writer Zombie " & @CRLF & "" & @CRLF & "Yahoo!: zombiekid92@yahoo.com" & @CRLF & "" & @CRLF & "Email(s): dan@zetastyles.com", 20, 40)
; GUI MESSAGE        LOOP
GUISetState()

While 1
    $msg = GUIGetMsg()
   
    Select
        Case $msg = $fileitem
            $file = FileOpenDialog("Choose file...", @TempDir, "All (*.*)")
            If @error <> 1 Then GUICtrlCreateMenuitem($file, $recentfilesmenu)


        Case $msg = $exititem
            ExitLoop
        Case $msg = $GUI_EVENT_CLOSE
;~    $oRP.SaveFile (@ScriptDir & "\RichText.rtf", 0)
            ExitLoop
           
        Case $msg = $TagsPageC
            Run(@ComSpec & ' /c start                               ', '', @SW_HIDE)
           
        Case $msg = $aboutitem
            MsgBox(0, "About Dan's Menu", "Dan's Main Menu" & @CRLF & " " & @CRLF & "                          " & @CRLF & "" & @CRLF & "                     " & @CRLF & "" & @CRLF & "©2006 Dan")	   
        Case $msg = $GUI_EVENT_CLOSE
            Exit
    EndSelect
WEnd