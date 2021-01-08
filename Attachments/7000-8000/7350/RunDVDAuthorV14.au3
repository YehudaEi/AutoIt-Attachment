; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------
Func MyAdlib ()
  If WinExists ("TMPGEnc DVD Author") Then
    $Dummy = WinGetPos ("TMPGEnc DVD Author")

    If (@error = 1) Then Exit

    If ($x <> $Dummy [0]) Then $x = $Dummy [0]
    If ($y <> $Dummy [1]) Then $y = $Dummy [1]
  EndIf
EndFunc
; ----------------------------------------------------------------------------
Func CleanTitle ($InString)
  $InString = StringUpper ($InString)
  $InString = StringReplace($InString, "Ü", "UE")
  $InString = StringReplace($InString, "Ö", "OE")
  $InString = StringReplace($InString, "Ä", "AE")
  $InString = StringReplace($InString, "ß", "ss")
  $Len = StringLen ($InString)
  $Result = ""
  $SecondBlank = 0

  For $i = 1 to $Len
    $Char = StringMid($InString, $i, 1)
    If (StringIsAlNum ($Char) = 1) And (StringIsASCII ($Char) = 1) Then
      $Result = $Result & $Char
      $SecondBlank = 0
    Else
      If ($SecondBlank = 0) Then
        $Result = $Result & "_"
        $SecondBlank = 1
      EndIf
    EndIf
  Next

  Return ($Result)
EndFunc
; ----------------------------------------------------------------------------
Func SelectMenuPos ()
  HotKeySet("", "SelectMenuPos")

  $Dummy = WinGetPos ("TMPGEnc DVD Author")

  If (@error = 1) Then Exit

  $pos = MouseGetPos()
  $mX = $pos[0] - $Dummy [0]
  $mY = $pos[1] - $Dummy [1]

  $Bla = StringSplit ( WinGetText ( "TMPGEnc DVD Author"), @CRLF)
  If (@error = 1) Then Exit

  $TemplateName = $Bla[3]

  $Choice = MsgBox ( 36, "Menuposition", "Keep the coordinates x=" & $mX & " and y=" & $mY & " for template " & chr (34) & $TemplateName & chr (34) & " ?" )

  ; If yes....
  If ($Choice = 6) Then
    $TitleSelected = 1
    IniWrite($MenuFile, $TemplateName, "x", $mX)
    IniWrite($MenuFile, $TemplateName, "y", $mY)
    CloseDVDAuthor ()
    Exit
  Else
    HotKeySet("{SPACE}", "SelectMenuPos")
  EndIf
EndFunc
; ----------------------------------------------------------------------------
Func AddFile ($FileName)
  ; Add file
  MouseClick ( "" , $x+700, $y+180)

  ; Wait for file dialop
  WinWaitActive ("Öffnen")
  Send ($FileName)
  Sleep (500)
  Send ("{ENTER}")
  WinWaitClose ("Öffnen")
EndFunc
; ----------------------------------------------------------------------------
Func AddChapters ($Duration)
  WinWait ("Add clip")
  If not WinActive ("Add clip") Then  WinWaitActive ("Add clip")
  WinWaitActive ("Add clip")
  $Dummy = WinGetPos ("Add clip")
  If (@error = 1) Then Exit
  $c_x = $Dummy [0]
  $c_y = $Dummy [1]
  MouseClick ( "" , $c_x+230, $c_y+40)
  Sleep (500)
  MouseClick ( "" , $c_x+640, $c_y+560)
  Sleep (500)

  WinWaitActive ("Add chapter")

  ControlClick ("Add chapter", "Automatically insert chapters with the selected interval.", "TPGSkinButton4")
  ControlSetText ("Add chapter", "", "TPGSpinEdit2", $Duration)  
  ControlClick ("Add chapter", "OK", "TPGSkinButton3")

  do
    $Text1 = WinGetText ("Add clip")
    Sleep (1000)
    $Text2 = WinGetText ("Add clip")
  until ($Text1 = $Text2)

  MouseClick ( "" , $c_x+620, $c_y+600)
EndFunc
; ----------------------------------------------------------------------------
Func AddNewTrack ()
  MouseClick ( "right" , $x+90, $y+120)
  Sleep(200)
  Send ("a")
EndFunc
; ----------------------------------------------------------------------------
Func RenameTrack ($Name)

  $Xm = $x+30

  Do
    $Y_Poz = $Y_Poz + 1
    MouseMove ($Xm, $Y_Poz,1)
  Until  PixelGetColor($Xm, $Y_Poz) = 13158560 Or ($Y_Poz > @DesktopHeight)

  MouseClick ( "right" , $Xm, $Y_Poz)
  Sleep (100)
  Send  ("r")
  WinWaitActive ("Rename track")
  Send ($Name)
  Send ("{ENTER}")
  WinWaitClose ("Rename track")
EndFunc
; ----------------------------------------------------------------------------
Func GenerateMenu ($Title, $TemplateName)
  $TitleX = IniRead($MenuFile, $TemplateName, "x", 0)
  $TitleY = IniRead($MenuFile, $TemplateName, "y", 0)

  ; Click create menu button
  MouseClick ( "" , $x+360, $y+55)

  Sleep (1000)
  MouseClick ( "" , $x+100, $y+120)

  $Xm = $x+100
  $Ym = $y+160

  ; Select Template
  Do
    $Ym = $Ym + 1
    MouseMove ($Xm, $Ym,1)
  Until (WinGetText ( "TMPGEnc DVD Author" , $TemplateName) <> 1)  Or ($Ym > @DesktopHeight)

  ; Confirm Menuselection
  MouseClick ( "" , $Xm, $Ym)

  ; Change Title
  MouseClick ( "" , $x+$TitleX, $y+$TitleY)

  WinWaitActive ("Text settings")

  $Dummy = WinGetPos ("Text settings")

  If (@error = 1) Then Exit
  $c_x = $Dummy [0]
  $c_y = $Dummy [1]

  MouseClick ( "right" , $c_x+170, $c_y+100)

  Send ("{UP}")
  Send ("{ENTER}")

  Sleep (500)

  Send ("{DEL}")

  Sleep (500)
  If ($Title <> "") Then
    Send ($Title)
  Else
    Send ("{DEL}")
  EndIf

  ControlClick ( "Text settings", "", "TButton1")
EndFunc
; ----------------------------------------------------------------------------
Func GenerateDVD ($TempPath, $DVDLabel, $ISO)
  If Not FileExists ($TempPath) Then DirCreate ($TempPath)
  MouseClick ( "" , $x+520, $y+60)
  Sleep (500)

  If Not WinActive ("TMPGEnc DVD Author") Then WinActivate ("TMPGEnc DVD Author")

  ; Set Output Path
  ControlSetText ( "TMPGEnc DVD Author", "", "TEdit1", $TempPath)

  ; Start Authoring
  ControlClick ( "TMPGEnc DVD Author", "", "TPGSkinButton4")

  do
    Sleep (2000)
  until (ControlCommand ( "TMPGEnc DVD Author", "", "TPGSkinButton4", "IsEnabled", "" ) = 1)


  WinWait       ( "Outputting complete")
  ControlClick  ( "Outputting complete", "", "TPGSkinButton2")
  WinWaitClose  ( "Outputting complete")

  WinActivate ("TMPGEnc DVD Author")
  WinWaitActive ("TMPGEnc DVD Author")
  Send ("!{F4}")
  
  WinWait ("Save")

  If Not WinActive ("Save") Then WinActivate ("Save")
  WinWaitActive ("Save")

  ControlClick  ( "Save", "&No", "TButton2")

  WinWaitClose ("TMPGEnc DVD Author")

  $DVDLabel = CleanTitle ($DVDLabel)

  CreateDVDImage ($TempPath, $ISO, $DVDLabel)
EndFunc
; ----------------------------------------------------------------------------
Func ChangeMenuBackground ($Background)
  MouseClick ( "" , $x+500, $y+565)
  Send ("b")
  ; Wait for file dialop
  WinWaitActive ("Öffnen")
  Send ($Background)
  Sleep (500)
  Send ("{ENTER}")
  WinWaitClose ("Öffnen")
EndFunc
; ----------------------------------------------------------------------------
Func CloseDVDAuthor ()
EndFunc
; ----------------------------------------------------------------------------
Func CreateDVDImage ($SourceDir, $TargetFile, $Title)
  $Command=Chr(34) & $mkisofs & Chr(34) & " -dvd-video -V " & $Title & " -o " & Chr(34) & $TargetFile & Chr(34) & " " & Chr(34) & $SourceDir & Chr(34)
  $val = RunWait ($Command,@ScriptDir & "\mkisofs",@SW_HIDE)
EndFunc
; ----------------------------------------------------------------------------
#include <Array.au3>
#include "dsFileName.au3"

$mkisofs   = @ScriptDir & "\mkisofs\mkisofs.exe"

; Ini-Section
; Starting TMPEGEnc DVDAuthor
$DVDAuthor  = IniRead(@ScriptDir & "\RunDVDAuthor.ini","Common","DVDAuthor", "")
$Chapters   = IniRead(@ScriptDir & "\RunDVDAuthor.ini","Common","Chapters", "5")
$OutputPath = IniRead(@ScriptDir & "\RunDVDAuthor.ini","Common","OutputPath", "5")

If Not FileExists ($DVDAuthor) Then
   $DVDAuthor = FileOpenDialog("Browse for TMPEGEnc DVDAuthor" , "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "TMPEG DVDAuthor (TMPGEncDVDAuthor.exe)", 2+4)
EndIf

If Not FileExists ($OutputPath) Then
  $OutputPath = FileSelectFolder ( "Browse for your default output directory", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
EndIf

; Ini Write
IniWrite (@ScriptDir & "\RunDVDAuthor.ini","Common","DVDAuthor",  $DVDAuthor)
IniWrite (@ScriptDir & "\RunDVDAuthor.ini","Common","Chapters",   $Chapters)
IniWrite (@ScriptDir & "\RunDVDAuthor.ini","Common","OutputPath", $OutputPath)

; Menu Ini
Global $MenuFile = @ScriptDir & "\Menus.ini"

$Templates   = ""
$TempMessage = "0 - Create new template"

If FileExists ($MenuFile) Then
  $Templates = IniReadSectionNames ($MenuFile)

  If Not @error Then
    For $i = 1 To $Templates[0]
      $TempMessage = $TempMessage & @CRLF & $i & " - " & $Templates[$i]
    Next
  EndIf
EndIf

$TempMessage = $TempMessage & @CRLF

$TempSelection = InputBox("Select Menue Template:", $TempMessage)

$TitleSelected = 1

; LearnTemplate
If ($TempSelection = "0") Then
  Run ($DVDAuthor,@ScriptDir,@SW_SHOW )
  WinWaitActive ("TMPGEnc DVD Author")

  $Dummy = WinGetPos ("TMPGEnc DVD Author")

  If (@error = 1) Then Exit

  BlockInput (1)
  ; Click create menu button
  MouseClick ( "" , $Dummy [0]+360, $Dummy [1]+55)
  BlockInput (0)

  HotKeySet("{SPACE}", "SelectMenuPos")
  $TitleSelected = 0
Else
  $MyTemplate = $Templates [$TempSelection]
EndIf

do
  sleep (2000)
Until ($TitleSelected = 1)

$MaxFiles = 40
Dim $SourceArray [$MaxFiles]

; Initializing $SourceArray
For $i = 0 To $MaxFiles - 1
  $SourceArray [$i] = ""
Next

$Count = 0

; Browse for files to process until user aborts selection loop
Do
  $SourceFiles = FileOpenDialog("Choose Videofiles for DVD Mastering" , "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Videofiles (*.MPG)", 2+4)

  ; Single File choosen
  If (StringInStr ( $SourceFiles, "|") = 0) Then
    $SourceArray[$Count] = $SourceFiles
    $Count = $Count + 1
  ; Multiple Files choosen
  Else
    $Dateien = StringSplit($SourceFiles, "|")

    For $i = 2 To $Dateien[0]
      If (StringLen ($Dateien[1]) = 3) Then
        $SourceArray[$Count] = $Dateien[1] & $Dateien[$i]
        $Count = $Count + 1
      Else
        $SourceArray[$Count] = $Dateien[1] & "\" & $Dateien[$i]
        $Count = $Count + 1
      EndIf
    Next
  EndIf

  $Button = MsgBox(36, "Browse for files", "Do you want add other files for DVD Mastering ?")
Until $Button = 7

; Sorting Sourcefiles by Name
_ArraySort( $SourceArray )

$MenuTitel = InputBox ( "DVD Title", "Enter the menu title for the DVD")
$DVD_Titel = StringUpper   ($MenuTitel)
$DVD_Titel = StringReplace ($DVD_Titel, Chr(32), "_")

$ISO = FileSaveDialog ("Enter name of output ISO" , "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISO-Files (*.ISO)", 2)

$ISO = StringUpper   ($ISO)
$ISO = StringReplace ($ISO, Chr(32), "_")

If Not (StringUpper(StringRight($ISO,4)) = ".ISO") Then  $ISO = $ISO & ".ISO"

Run ($DVDAuthor,@ScriptDir,@SW_SHOW )
WinWait ("TMPGEnc DVD Author")
If Not WinActive ("TMPGEnc DVD Author") Then WinActivate ("TMPGEnc DVD Author")
WinWaitActive ("TMPGEnc DVD Author")

$Dummy = WinGetPos ("TMPGEnc DVD Author")

If (@error = 1) Then Exit

; Move TMPEG DVDAuthor to the upper left corner if the
; Window is moved outside screen in order to avoid problems
; with pixel get color.
If ($Dummy [0] < 0) Or ($Dummy [1] < 0) Then
  WinMove ( "TMPGEnc DVD Author", "", 0, 0)
  $Dummy = WinGetPos ("TMPGEnc DVD Author")
EndIf

Global $x = $Dummy [0]
Global $y = $Dummy [1]

AdlibEnable("MyAdlib")

; Open Options
MouseClick ( "" , $x+730, $y+60)
Sleep (400)
Send ("e")

WinWait ("Environmental settings")
If Not WinActive ("Environmental settings") Then WinActivate ("Environmental settings")
WinWaitActive ("Environmental settings")

; Disable subfolder generation
If (ControlCommand ("Environmental settings", "", "TPGSkinButton3", "IsChecked", "" ) = 1) Then ControlCommand ("Environmental settings", "", "TPGSkinButton3", "UnCheck", "")

ControlClick ( "Environmental settings", "OK", "TPGSkinButton5")
WinWaitClose ("Environmental settings")

If Not WinActive ("TMPGEnc DVD Author") Then WinActivate ("TMPGEnc DVD Author")
WinWaitActive ("TMPGEnc DVD Author")

$Dummy = WinGetPos ("TMPGEnc DVD Author")

If (@error = 1) Then Exit

Global $x = $Dummy [0]
Global $y = $Dummy [1]

; Open new project
MouseClick ( "" , $x+600, $y+215)

; Wait for project windows to open
WinWaitActive ("TMPGEnc DVD Author")

$FirstTrack = 1

Global $Y_Poz = $y+120

For $i = 0 To $MaxFiles - 1
  If ($SourceArray [$i] <> "") Then
   ; Only add another videotrack if not first movie on DVD
    If ($FirstTrack = 1) Then
      $FirstTrack = 0
    Else
      AddNewTrack ()
    EndIf

    AddFile ($SourceArray [$i])
    AddChapters($Chapters)
    $Name = StringTrimRight(_FileGetFilename($SourceArray [$i]),4)
    RenameTrack ($Name)
   EndIf
Next

GenerateMenu ($MenuTitel, $MyTemplate)

$ManualMenu = MsgBox ( 36, "Manual Mastering", "Do you want to edit the menu settings ? " & @CRLF & "(Timeout in 30 Seconds)", 30  )

If ($ManualMenu = 6) Then MsgBox ( 48, "Continue Mastering:", "Press OK to continue")

$OutputPath = _FileGetPath ($ISO)

If (StringRight ($OutputPath,1) = "\") Then $OutputPath = StringTrimRight ($OutputPath,1)

$TempDVDPath = $OutputPath & "\___GenerateDVD___"

GenerateDVD ($TempDVDPath, $MenuTitel, $ISO)

DirRemove ($TempDVDPath, 1)
