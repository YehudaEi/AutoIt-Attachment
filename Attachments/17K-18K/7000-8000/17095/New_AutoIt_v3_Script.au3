#NoTrayIcon
#Include <GuiConstants.au3>
#Include <IE.au3>
#Include <File.au3>
#Include <String.au3>
#Include <GuiEdit.au3>
#Include <Misc.au3>
#Include <Sound.au3>
#Include <Array.au3>

Global $Speech = ObjCreate("SAPI.SpVoice")

Global $HomePage = IniRead(@ScriptDir & "\Reg.ini", "Internet", "Homepage", ""), $StartUpSound = IniRead(@ScriptDir & "\Reg.ini", "MicroOS", "StartSound", "")
Global $ExitSound = IniRead(@ScriptDir & "\Reg.ini", "MicroOS", "ExitSound", ""), $DesktopColor = IniRead(@ScriptDir & "\Reg.ini", "MicroOS", "DesktopColor", "")
Global $StartPass = IniRead(@ScriptDir & "\Reg.ini", "MicroOS", "StartPass", "")

Opt("GuiResizeMode", 1)

$MainGUI = GUICreate("MicroOS", 640, 480, -1, -1, $WS_OverLappedWindow, $WS_MaximizeBox)
$OSMenu = GUICtrlCreateMenu("Start")
$IE = GUICtrlCreateMenuItem("Internet", $OSMenu)
$Separator = GUICtrlCreateMenuItem("", $OSMenu)
$Con = GUICtrlCreateMenuItem("Console", $OSMenu)
$Separator = GUICtrlCreateMenuItem("", $OSMenu)
$Notepad = GUICtrlCreateMenuItem("Notepad", $OSMenu)
$Separator = GUICtrlCreateMenuItem("", $OSMenu)
$Music = GUICtrlCreateMenuItem("Music Player", $OSMenu)
$Separator = GUICtrlCreateMenuItem("", $OSMenu)
$GameMenu = GUICtrlCreateMenu("Games", $OSMenu)
$Excuse = GUICtrlCreateMenuItem("Excuse Maker", $GameMenu)
$Separator = GUICtrlCreateMenuItem("", $GameMenu)
$Quiz = GUICtrlCreateMenuItem("Quiz", $GameMenu)
$Separator = GUICtrlCreateMenuItem("", $OSMenu)
$FileBrowser = GUICtrlCreateMenuItem("File Browser", $OSMenu)
$Separator = GUICtrlCreateMenuItem("", $OSMenu)
$Registry = GUICtrlCreateMenuItem("Registry", $OSMenu)
$Separator = GUICtrlCreateMenuItem("", $OSMenu)
$Lock = GUICtrlCreateMenuItem("Lock", $OSMenu)
$Separator = GUICtrlCreateMenuItem("", $OSMenu)
$Shutdown = GUICtrlCreateMenuItem("Shutdown", $OSMenu)
$AboutMenu = GUICtrlCreateMenu("About")
$About = GUICtrlCreateMenuItem("About", $AboutMenu)

If $DesktopColor = "" Then
    GUISetBkColor(0x969696, $MainGUI)
EndIf

If Not $DesktopColor = "" Then
    GUISetBkColor($DesktopColor, $MainGUI)
EndIf

If Not $StartPass = "" Then
    $StartUpPass = InputBox("MicroOS - Login", "Enter your password to login:", "", "*")
    If $StartUpPass <> $StartPass Then
        MsgBox(16, "MicroOS - Login", "Incorrect.")
        Exit
    EndIf
EndIf

If Not $StartUpSound = "" Then
    SoundPlay($StartUpSound)
EndIf

GUISetState(@SW_SHOW, $MainGUI)

$SYSTEM_POWER_STATUS = DllStructCreate("byte;byte;byte;byte;int;int")

While 1
    DllCall("kernel32.dll", "int", "GetSystemPowerStatus", "ptr", DllStructGetPtr($SYSTEM_POWER_STATUS))
    WinSetTitle($MainGUI, "", "MicroOS - " & @HOUR & ":" & @MIN & ":" & @SEC & " - Battery Status: " & DllStructGetData($SYSTEM_POWER_STATUS, 3) & "% - MicroOS created by Justin Reno 2007.")
    $Msg = GUIGetMsg()
    Switch $Msg
        Case $IE
            _IE()
        Case $Con
            _Con()
        Case $Notepad
            _Notepad()
        Case $Music
            _MusicPlayer()
        Case $Excuse
            _Excuse()
        Case $Quiz
            _Quiz()
        Case $Registry
            _Reg()
        Case $FileBrowser
            _FileBrowser()
        Case $Lock
            _Lock()
        Case $Shutdown
            _Shutdown()
        Case $About
            MsgBox(64, "MicroOS - About", "MicroOS copyright Justin Reno 2007 including all of it's included applications (Internet, Console, Notepad, Music Player, Excuse Maker, Quiz, Registry, File Browser, and Lock). ©")
    EndSwitch
WEnd

Func _IE()
    Opt("GuiResizeMode", 1)
    _IEErrorHandlerRegister()
    $Internet = GUICreate("MicroOS - Internet", 628, 447, -1, -1, $WS_OverLappedWindow, $WS_MaximizeBox)
    $Input1 = GUICtrlCreateInput("", 56, 400, 121, 21)
    $Label1 = GUICtrlCreateLabel("Enter URL:", 0, 408, 57, 17)
    $Go = GUICtrlCreateButton("Go", 184, 400, 75, 25, 0)
    $Stop = GUICtrlCreateButton("Stop", 264, 400, 75, 25, 0)
    $Back = GUICtrlCreateButton("Back", 344, 400, 75, 25, 0)
    $Forward = GUICtrlCreateButton("Forward", 424, 400, 75, 25, 0)
    $Obj1 = ObjCreate("Shell.Explorer.2")
    $Obj1_ctrl = GUICtrlCreateObj($Obj1, 0, 0, 626, 396)
    $File_Menu = GUICtrlCreateMenu("File")
    $Open = GUICtrlCreateMenuItem("Open", $File_Menu)
    $Separator = GUICtrlCreateMenuItem("", $File_Menu)
    $Save = GUICtrlCreateMenuItem("Save", $File_Menu)
    $Separator = GUICtrlCreateMenuItem("", $File_Menu)
    $Print = GUICtrlCreateMenuItem("Print", $File_Menu)
    $Separator = GUICtrlCreateMenuItem("", $File_Menu)
    $Exit = GUICtrlCreateMenuItem("Exit", $File_Menu)
    If $HomePage = "" Then $HomePage = "about:blank"
    _IENavigate($Obj1, $HomePage)
    GUISetState(@SW_SHOW)
    While 1
        $IEMsg = GUIGetMsg()
        Switch $IEMsg
            Case $GUI_EVENT_CLOSE
                GUIDelete($Internet)
                ExitLoop
            Case $Go
                $InputReadURL = GUICtrlRead($Input1)
                _IENavigate($Obj1, $InputReadURL)
            Case $Stop
                _IEAction($Obj1, "stop")
            Case $Back
                _IEAction($Obj1, "back")
            Case $Forward
                _IEAction($Obj1, "forward")
            Case $Open
                $OpenFileDialog = FileOpenDialog("MicroOS - Internet - Open File", @ScriptDir, "HTML Files(*.html)")
                _IENavigate($Obj1, $OpenFileDialog)
            Case $Save
                _IEAction($Obj1, "saveas")
            Case $Print
                _IEAction($Obj1, "print")
            Case $Exit
                GUIDelete($Internet)
                ExitLoop
        EndSwitch
    WEnd
EndFunc   ;==>_IE

Func _Con()
    Opt("GuiResizeMode", 1)
    $Console = GUICreate("MicroOS - Console", 634, 435, -1, -1, $WS_OverLappedWindow, $WS_MaximizeBox)
    $Out = GUICtrlCreateEdit("", 0, 0, 633, 385)
    $Input1 = GUICtrlCreateInput("", 0, 384, 633, 21)
    $Button1 = GUICtrlCreateButton("Send Command", 0, 408, 627, 25, 0)
    GUISetState(@SW_SHOW, $Console)
    While 1
        $CONMsg = GUIGetMsg()
        Switch $CONMsg
            Case $GUI_EVENT_CLOSE
                GUIDelete($Console)
                ExitLoop
            Case $Button1
                $ReadCommand = GUICtrlRead($Input1)
                If $ReadCommand = "Help" Then
                    GUICtrlSetData($Out, "List Of Commands: Help: Shows all the commands; IP: Shows your IP address; CompInfo: Shows stats about your computer; CLS: Clears the console output; Format MicroOS: Resets MicroOS.")
                    GUICtrlSetData($Input1, "")
                EndIf
                If $ReadCommand = "IP" Then
                    $ReadPrevOut = GUICtrlRead($Out)
                    GUICtrlSetData($Out, $ReadPrevOut & "" & @CRLF & @CRLF & @IPAddress1 & "")
                    GUICtrlSetData($Input1, "")
                EndIf
                If $ReadCommand = "CompInfo" Then
                    $ReadPrevOut = GUICtrlRead($Out)
                    GUICtrlSetData($Out, $ReadPrevOut & "" & @CRLF & @CRLF & @ComputerName & @CRLF & @HomeDrive & @CRLF & @IPAddress1 & @CRLF & @OSVersion & @CRLF & @DesktopDir & @CRLF & @ProgramFilesDir & @CRLF & @SystemDir & @CRLF & @TempDir & @CRLF & @UserName & @CRLF & @WindowsDir & "")
                    GUICtrlSetData($Input1, "")
                EndIf
                If $ReadCommand = "CLS" Then
                    GUICtrlSetData($Out, "")
                    GUICtrlSetData($Input1, "")
                EndIf
                If $ReadCommand = "Format MicroOS" Then
                    GUICtrlSetData($Out, "")
                    GUICtrlSetData($Input1, "")
                    FileDelete(@ScriptDir & "\Reg.ini")
                EndIf
        EndSwitch
    WEnd
EndFunc   ;==>_Con

Func _Notepad()
    $Edit = GUICtrlCreateEdit("", 0, 0, 640, 480)
    $File_Menu = GUICtrlCreateMenu("File")
    $New = GUICtrlCreateMenuItem("New", $File_Menu)
    $Open = GUICtrlCreateMenuItem("Open", $File_Menu)
    $Save = GUICtrlCreateMenuItem("Save", $File_Menu)
    $Print = GUICtrlCreateMenuItem("Print", $File_Menu)
    $Separator = GUICtrlCreateMenuItem("", $File_Menu)
    $Exit = GUICtrlCreateMenuItem("Exit", $File_Menu)
    $Edit_Menu = GUICtrlCreateMenu("Edit")
    $ICT = GUICtrlCreateMenuItem("Insert Current Time", $Edit_Menu)
    $Separator = GUICtrlCreateMenuItem("", $Edit_Menu)
    $ReverseText = GUICtrlCreateMenuItem("Reverse Text", $Edit_Menu)
    $Separator = GUICtrlCreateMenuItem("", $Edit_Menu)
    $WordCount = GUICtrlCreateMenuItem("Word Count", $Edit_Menu)
    $Separator = GUICtrlCreateMenuItem("", $Edit_Menu)
    $Copy = GUICtrlCreateMenuItem("Copy", $Edit_Menu)
    $Paste = GUICtrlCreateMenuItem("Paste", $Edit_Menu)
    $Separator = GUICtrlCreateMenuItem("", $Edit_Menu)
    $Undo = GUICtrlCreateMenuItem("Undo", $Edit_Menu)
    $Separator = GUICtrlCreateMenuItem("", $Edit_Menu)
    $Font = GUICtrlCreateMenuItem("Font", $Edit_Menu)
    $Speak_Menu = GUICtrlCreateMenu("Speak")
    $SpeakText = GUICtrlCreateMenuItem("Speak Text", $Speak_Menu)
    $StopSpeakingText = GUICtrlCreateMenuItem("Stop Speaking", $Speak_Menu)
    GUISetState(@SW_SHOW)
    While 1
        $NotepadMsg = GUIGetMsg()
        Switch $NotepadMsg
            Case $New
                GUICtrlSetData($Edit, "")
            Case $Open
                $FileOpenDialog = FileOpenDialog("MicroOS - Notepad - Open File", @DesktopDir, "Text Files(*.txt)")
                $ReadFileOpen = FileRead($FileOpenDialog)
                GUICtrlSetData($Edit, $ReadFileOpen)
            Case $Save
                $FileReadSave = GUICtrlRead($Edit)
                $SaveFileDialog = FileSaveDialog("MicroOS - Notepad - Save File", @DesktopDir, "Text Files(*.txt)")
                FileWrite($SaveFileDialog, $FileReadSave)
            Case $Print
                $EditReadPrint = GUICtrlRead($Edit)
                FileWrite(@TempDir & "\print.txt", $EditReadPrint)
                _FilePrint(@TempDir & "\print.txt")
                FileDelete(@TempDir & "\print.txt")
            Case $Exit
				GUICtrlDelete($Edit)
				GUICtrlDelete($File_Menu)
				GUICtrlDelete($Edit_Menu)
				GUICtrlDelete($Speak_Menu)
            Case $ICT
                ControlSend($Notepad, "", $Edit, "" & @HOUR & ":" & @MIN & ":" & @SEC & "")
            Case $ReverseText
                $EditReadReverse = GUICtrlRead($Edit)
                $Reverse = _StringReverse($EditReadReverse)
                GUICtrlSetData($Edit, $Reverse)
            Case $WordCount
                $EditReadCount = GUICtrlRead($Edit)
                $ReadCountSplit = StringSplit($EditReadCount, " ")
                $WordCount = $ReadCountSplit[0]
                $AllWords = $WordCount
                MsgBox(0, "MicroOS - Notepad - Word Count", "Word Count: " & $AllWords & ".")
            Case $Copy
                $EditReadCopy = GUICtrlRead($Edit)
                ClipPut($EditReadCopy)
            Case $Paste
                $ClipGetCopy = ClipGet()
                $EditReadPaste = GUICtrlRead($Edit)
                GUICtrlSetData($Edit, $EditReadPaste & $ClipGetCopy)
            Case $Undo
                _GUICtrlEditUndo($Edit)
            Case $Font
                $SFont = _ChooseFont()
                $Font = GUICtrlSetFont($Edit, $SFont[3], $SFont[4], $SFont[1], $SFont[2])
                $Color = GUICtrlSetColor($Edit, $SFont[7])
            Case $SpeakText
                $Speech = ObjCreate("SAPI.SpVoice")
                $EditTextRead = GUICtrlRead($Edit)
                $Speech.Speak ($EditTextRead, 1)
            Case $StopSpeakingText
                $Speech = ObjCreate("SAPI.SpVoice")
        EndSwitch
    WEnd
EndFunc   ;==>_Notepad

Func _MusicPlayer()
    Opt("GuiResizeMode", 1)
    Dim $SoundLoad
    $Music = GUICreate("MicroOS - Music Player", 236, 122, -1, -1, $WS_OverLappedWindow, $WS_MaximizeBox)
    $Button1 = GUICtrlCreateButton("Load Song", 0, 0, 75, 25, 0)
    $Button2 = GUICtrlCreateButton("Play Song", 0, 24, 75, 25, 0)
    $Button3 = GUICtrlCreateButton("Pause Sound", 0, 48, 75, 25, 0)
    $Button4 = GUICtrlCreateButton("Resume Song", 0, 72, 75, 25, 0)
    $Button5 = GUICtrlCreateButton("Stop Song", 0, 96, 75, 25, 0)
    $Label1 = GUICtrlCreateLabel("Status:", 80, 0, 57, 57)
    GUISetState(@SW_SHOW)
    While 1
        $MusicMsg = GUIGetMsg()
        Switch $MusicMsg
            Case $GUI_EVENT_CLOSE
                _SoundStop($SoundLoad)
                GUIDelete($Music)
                ExitLoop
            Case $Button1
                $MusicLoadDialog = FileOpenDialog("MicroOS - Music Player - Open File", @DesktopDir, "Music Files(*.mp3;*.wav)")
                $SoundLoad = _SoundOpen($MusicLoadDialog)
                _SoundPlay($SoundLoad)
                GUICtrlSetData($Label1, "Status: Loaded and Playing.")
            Case $Button2
                _SoundPlay($SoundLoad)
                GUICtrlSetData($Label1, "Status: Playing.")
            Case $Button3
                _SoundPause($SoundLoad)
                GUICtrlSetData($Label1, "Status: Pause.")
            Case $Button4
                _SoundResume($SoundLoad)
                GUICtrlSetData($Label1, "Status: Resumed and Playing.")
            Case $Button5
                _SoundStop($SoundLoad)
                GUICtrlSetData($Label1, "Status: Stopped.")
        EndSwitch
    WEnd
EndFunc   ;==>_MusicPlayer

Func _Excuse()
    $Something1 = _ArrayCreate(10, "My Computer", "My cat", "My dog", "My brother", "My sister", "Hitler", "My mom", "My dad", "The Police", "My school")
    $To = _ArrayCreate(9, "ate", "vomited on", "burned", "blew up", "shot", "cut", "washed", "stole", "ran over", "cried", "peed on")
    $Something2 = _ArrayCreate(10, "my homework", "my money", "my house", "my face", "my brother", "my sister", "Hitler", "my mind", "my life", "me")
    Do
        MsgBox(0, "Excuse Maker", $Something1[Random(1, 10, 1) ] & " " & $To[Random(1, 11, 1) ] & " " & $Something2[Random(1, 10, 1) ] & ".")
    Until MsgBox(36, "Excuse Maker", "Make another excuse?") = 7
EndFunc   ;==>_Excuse

Func _Quiz()
    Global $Score = 100
    $Name = InputBox("MicroOS - Quiz", "What is your name?")
    $Gender = InputBox("MicroOS - Quiz", "What is your gender?")
    $Age = InputBox("MicroOS - Quiz", "How old are you?")
    $Color = InputBox("MicroOS - Quiz", "Whats your favorite color?")
    MsgBox(0, "MicroOS - Quiz", "First, some math questions " & $Name & ".")
    $Q1 = InputBox("MicroOS - Quiz", "What is 2+2?")
    $Q2 = InputBox("MicroOS - Quiz", "What is 2*2?")
    $Q3 = InputBox("MicroOS - Quiz", "What is 2 divided by 2?")
    $Q4 = InputBox("MicroOS - Quiz", "What is 5*6")
    $Q5 = InputBox("MicroOS - Quiz", "What is 10 divided by 2?")
    MsgBox(0, "MicroOS - Quiz", "Now some personal questions. Lets see if you remember. This could get interesting...")
    $Q6 = InputBox("MicroOS - Quiz", "What is your name, again?")
    $Q7 = InputBox("MicroOS - Quiz", "What is your gender, again?")
    $Q8 = InputBox("MicroOS - Quiz", "In five years, how old will you be?")
    $Age += 5
    $Q9 = InputBox("MicroOS - Quiz", "What is your favorites color, again?")
    MsgBox(0, "MicroOS - Quiz", "Now, some language questions.")
    $Q10 = InputBox("MicroOS - Quiz", "What is hello in spanish?")
    $Q11 = InputBox("MicroOS - Quiz", "What is bye in spanish?")
    MsgBox(0, "MicroOS - Quiz", "Now, some random questions.")
    $Q12 = InputBox("MicroOS - Quiz", "Type in the number: 102349834.341")
    $Q13 = InputBox("MicroOS - Quiz", "What does pi equal? Only to the 3rd number. (Ex. 5.18)")
    $Q14 = InputBox("MicroOS - Quiz", "What does your start button say?")
    $SButton = ControlGetText("", "Notification Area", "Button1")
    If $Q1 <> "4" Then $Score -= 1
    If $Q2 <> "4" Then $Score -= 1
    If $Q3 <> "1" Then $Score -= 1
    If $Q4 <> "30" Then $Score -= 1
    If $Q5 <> "5" Then $Score -= 1
    If $Q6 <> $Name Then $Score -= 1
    If $Q7 <> $Gender Then $Score -= 1
    If $Q8 <> $Age Then $Score -= 1
    If $Q9 <> $Color Then $Score -= 1
    If $Q10 <> "hola" Then $Score -= 1
    If $Q11 <> "adios" Then $Score -= 1
    If $Q12 <> "102349834.341" Then $Score -= 1
    If $Q13 <> "3.14" Then $Score -= 1
    If $Q14 <> $SButton Then $Score -= 1
    MsgBox(64, "MicroOS - Quiz", "Your Done " & $Name & "! Your score is: " & $Score & "")
EndFunc   ;==>_Quiz

Func _Reg()
    $Registry = GUICreate("MicroOS - Registry Editor", 439, 110)
    $Group1 = GUICtrlCreateGroup("Internet:", 8, 0, 145, 105)
    If $HomePage = "" Then $HomePage = "about:blank"
    $Input1 = GUICtrlCreateInput($HomePage, 16, 40, 121, 21)
    $Label1 = GUICtrlCreateLabel("Home Page:", 16, 24, 63, 17)
    $Button1 = GUICtrlCreateButton("Change", 16, 64, 123, 25, 0)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    $Group2 = GUICtrlCreateGroup("MicroOS", 160, 0, 273, 105)
    $Button2 = GUICtrlCreateButton("Start Up Sound", 168, 24, 83, 25, 0)
    $Button3 = GUICtrlCreateButton("Exit Sound", 168, 56, 83, 25, 0)
    $Button4 = GUICtrlCreateButton("Desktop Background color", 256, 24, 83, 57, $BS_MULTILINE)
    $Button5 = GUICtrlCreateButton("Start Up Password", 344, 24, 83, 57, $BS_MULTILINE)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    GUISetState(@SW_SHOW)
    While 1
        $RegMsg = GUIGetMsg()
        Switch $RegMsg
            Case $GUI_EVENT_CLOSE
                MsgBox(48, "MicroOS - Registry", "MicroOS needs to be restarted for changes to take effect. Please Restart.")
                GUIDelete($Registry)
                Exit
            Case $Button1
                $ReadHomePageInput = GUICtrlRead($Input1)
                IniWrite(@ScriptDir & "\Reg.ini", "Internet", "HomePage", $ReadHomePageInput)
                MsgBox(0, "MicroOS - Registry", "Done.")
            Case $Button2
                $SelectStartSound = FileOpenDialog("MicroOS - Registry - Select Start Up Sound", @DesktopDir, "Sound Files(*.mp3;*.wav)")
                If @Error Then
                    GUIDelete($Registry)
                    ExitLoop
                EndIf
                IniWrite(@ScriptDir & "\Reg.ini", "MicroOS", "StartSound", $SelectStartSound)
                MsgBox(0, "MicroOS - Registry", "Done.")
            Case $Button3
                $SelectExitSound = FileOpenDialog("MicroOS - Registry - Select Exit Sound", @DesktopDir, "Sound Files(*.mp3;*.wav)")
                If @Error Then
                   GUIDelete($Registry)
                   ExitLoop
                EndIf
                IniWrite(@ScriptDir & "\Reg.ini", "MicroOS", "ExitSound", $SelectExitSound)
                MsgBox(0, "MicroOS - Registry", "Done.")
            Case $Button4
                $NewDesktopColor = InputBox("MicroOS - Registry - Desktop Backround Color", "Type in the HEX color for your new backround:")
                IniWrite(@ScriptDir & "\Reg.ini", "MicroOS", "DesktopColor", $NewDesktopColor)
                MsgBox(0, "MicroOS - Registry", "Done.")
            Case $Button5
                $NewStartPass = InputBox("MicroOS - Registry - Start Up Password", "Type in you're new start up password:", "", "*")
                IniWrite(@ScriptDir & "\Reg.ini", "MicroOS", "StartPass", $NewStartPass)
                MsgBox(0, "MicroOS - Registry", "Done.")
        EndSwitch
    WEnd
EndFunc   ;==>_Reg

Func _FileBrowser()
    Opt("GuiResizeMode", 1)
    $FileBrowser = GUICreate("MicroOS - File Browser", 628, 447, -1, -1, $WS_OverLappedWindow, $WS_MaximizeBox)
    $Obj1 = ObjCreate("Shell.Explorer.2")
    $Obj1_ctrl = GUICtrlCreateObj($Obj1, 0, 0, 626, 444)
    $Obj1.Navigate (@DesktopDir)
    GUISetState(@SW_SHOW)
    While 1
        $FBMsg = GUIGetMsg()
        Switch $FBMsg
            Case $GUI_EVENT_CLOSE
                GUIDelete($FileBrowser)
                ExitLoop
        EndSwitch
    WEnd
EndFunc   ;==>_FileBrowser

Func _Lock()
    $Pass = InputBox("MicroOS - Lock", "What password do you want to lock MicroOS with?", "", "*")
    $Lock = GUICreate("MicroOS - Lock - Type your Password to unlock.", 388, 26)
    $Input1 = GUICtrlCreateInput("", 0, 0, 121, 21, $ES_PASSWORD)
    $Ok = GUICtrlCreateButton("Ok", 120, 0, 267, 25, 0)
    GUISetState(@SW_SHOW)
    While 1
        If Not WinActive($Lock) Then WinActivate($Lock)
        $LockMsg = GUIGetMsg()
        Switch $LockMsg
            Case $Ok
                $ReadPasswordField = GUICtrlRead($Input1)
                If $ReadPasswordField <> $Pass Then
                    MsgBox(16, "MicroOS - Lock", "Invalid Password.")
                Else
                    MsgBox(0, "MicroOS - Lock", "Correct.")
                    GUIDelete($Pass)
                    ExitLoop
                EndIf
        EndSwitch
    WEnd
EndFunc   ;==>_Lock

Func _Shutdown()
    If Not $ExitSound = "" Then
        SoundPlay($ExitSound, 1)
    EndIf
    Exit
EndFunc   ;==>_Shutdown