AutoItSetOption("RunErrorsFatal", 0)
AutoItSetOption("TrayIconDebug", 0)
Opt ("GUIOnEventMode", 1) ; Change to OnEvent mode
#include <GUIConstants.au3>
#include <file.au3>
#include <Array.au3>

Dim $nameArray[1]
Dim $list, $input, $sum
Dim $i = 0
Dim $item = 1

; Gui
$fay = GUICreate("MultiPing", 300, 500)
GUISetOnEvent($Gui_EVENT_CLOSE, "EXITID")
GUICtrlCreateGroup("", 155, 5, 140, 470, $WS_THICKFRAME)
$Aboutmenu = GUICtrlCreateMenu("About")
$Aboutitem = GUICtrlCreateMenuItem("MultiPing", $Aboutmenu)
GUICtrlSetOnEvent(-1, "Ctext")
GUICtrlCreateLabel("Computer Names", 15, 5, 130, 20)
GUICtrlSetFont(-1, 9, 600)
$list = GUICtrlCreateListView("|Computer Names", 5, 25, 145, 450, $LVS_NOCOLUMNHEADER + $LVS_SINGLESEL)
$sum = GUICtrlCreateLabel("No. of PCs = " & UBound($nameArray) - 1, 175, 30, 100, 30)
GUICtrlSetFont(-1, 8.5, 600)

; CONTEXT MENU
$contextMenu = GUICtrlCreateContextMenu()
$AboutContext = GUICtrlCreateMenuItem("About", $contextMenu)
GUICtrlSetOnEvent(-1, "Ctext")
GUICtrlCreateMenuItem("", $contextMenu) ;separator
$ExitContext = GUICtrlCreateMenuItem("Exit", $contextMenu)
GUICtrlSetOnEvent(-1, "Ctext")

; Buttons
$sfile = GUICtrlCreateButton("Select File", 175, 70, 100, 30)
GUICtrlSetOnEvent(-1, "Sfile")
GUICtrlSetTip(-1, "Browse for file containing a list of PCs.")
GUISetState(@SW_SHOW)

$Add = GUICtrlCreateButton("Add", 185, 120, 80, 30)
GUICtrlSetOnEvent(-1, "Add")
GUICtrlSetTip(-1, "Add Computer")
GUISetState(@SW_SHOW)
GUICtrlSetState($Add, $GUI_FOCUS)

$Remove = GUICtrlCreateButton("Remove", 185, 170, 80, 30)
GUICtrlSetOnEvent(-1, "Remove")
GUICtrlSetTip(-1, "Remove Last Computer")
GUISetState(@SW_SHOW)
GUICtrlSetState($Remove, $GUI_DISABLE)

$Clear = GUICtrlCreateButton("Clear All", 185, 220, 80, 30)
GUICtrlSetOnEvent(-1, "Clear")
GUICtrlSetTip(-1, "Clear the whole list of computer names")
GUISetState(@SW_SHOW)
GUICtrlSetState($Clear, $GUI_DISABLE)

$Ping = GUICtrlCreateButton("Ping", 185, 270, 80, 30)
GUICtrlSetOnEvent(-1, "Pings")
GUISetState(@SW_SHOW)
GUICtrlSetState($Ping, $GUI_DISABLE)

$Views = GUICtrlCreateButton("View Successes", 175, 320, 100, 30)
GUICtrlSetOnEvent(-1, "Views")
GUISetState(@SW_SHOW)
GUICtrlSetState($Views, $GUI_DISABLE)

$View = GUICtrlCreateButton("View Failures", 175, 370, 100, 30)
GUICtrlSetOnEvent(-1, "View")
GUICtrlSetTip(-1, "Opens a file containing a list of PCs for which the script failed")
GUISetState(@SW_SHOW)
GUICtrlSetState($View, $GUI_DISABLE)

$Exit = GUICtrlCreateButton("Exit", 185, 420, 80, 30)
GUICtrlSetOnEvent(-1, "ExitID")
GUISetState(@SW_SHOW)

; Function for context menu
Func Ctext()
   Select
      Case @GUI_CtrlId = $ExitContext
         Exit
      Case @GUI_CtrlId = $AboutContext
         MsgBox(262144, "About MultiPing", "MultiPing" & @CRLF & "" & @CRLF & "Version 1.0" & @CRLF & "" & @CRLF & "Written by F" & @CRLF & "" & @CRLF & "Email: ")
      Case @GUI_CtrlId = $Aboutitem
         MsgBox(262144, "About MultiPing", "MultiPing" & @CRLF & "" & @CRLF & "Version 1.0" & @CRLF & "" & @CRLF & "Written by F" & @CRLF & "" & @CRLF & "Email: ")
   EndSelect
EndFunc   ;==>Ctext

; ExitID Function
Func EXITID()
   Select
      Case @GUI_CtrlId = $Gui_EVENT_CLOSE
         Exit
      Case @GUI_CtrlId = $Exit
         Exit
   EndSelect
EndFunc   ;==>EXITID

GUISetState(@SW_SHOW)
While 1
   Sleep(1000)
WEnd
GUIDelete()

Func Add()
   Dim $iInputBoxAnswer
   $iInputBoxAnswer = InputBox("Add Computer", "Type in the computername you want to add.", "", " ", "250", "120", "-1", "-1")
   Select
      Case @error = 0 ;OK - The string returned is valid
         _ArrayInsert($nameArray, $i, $iInputBoxAnswer)
         $item = GUICtrlCreateListViewItem($nameArray[0], $list)
         $item = $item + 1
         GUICtrlSetData($sum, "No. of PCs = " & UBound($nameArray) - 1)
      Case @error = 1 ;The Cancel button was pushed
      Case @error = 3 ;The InputBox failed to open
         
   EndSelect
   GUICtrlSetState($Add, $GUI_ENABLE)
   GUICtrlSetState($Exit, $GUI_ENABLE)
   GUICtrlSetState($sfile, $GUI_ENABLE)
   
   If UBound($nameArray) - 1 <> 0 Then
      GUICtrlSetState($Remove, $GUI_ENABLE)
      GUICtrlSetState($Clear, $GUI_ENABLE)
      GUICtrlSetState($Ping, $GUI_ENABLE)
   Else
      GUICtrlSetState($Remove, $GUI_DISABLE)
      GUICtrlSetState($Clear, $GUI_DISABLE)
      GUICtrlSetState($Ping, $GUI_DISABLE)
      GUICtrlSetState($Views, $GUI_DISABLE)
      GUICtrlSetState($View, $GUI_DISABLE)
   EndIf
   GUICtrlSetState($Add, $GUI_FOCUS)
EndFunc   ;==>Add

Func Remove()
   If UBound($nameArray) - 1 > 0 Then
      If GUICtrlRead($item) = "0" Then
         GUICtrlDelete($item)
         $item = $item - 1
      EndIf
      While StringInStr(GUICtrlRead($item), "No. of PCs =")
         GUICtrlDelete($item)
         $item = $item - 1
      WEnd
      If Not StringInStr(GUICtrlRead($item), "Exit") Then
         GUICtrlDelete($item)
         $item = $item - 1
      EndIf
      _ArrayDelete($nameArray, 0)
      GUICtrlSetData($sum, "No. of PCs = " & UBound($nameArray) - 1)
      If UBound($nameArray) - 1 = 0 Then
         GUICtrlSetState($Remove, $GUI_DISABLE)
         GUICtrlSetState($Clear, $GUI_DISABLE)
         GUICtrlSetState($Views, $GUI_DISABLE)
         GUICtrlSetState($View, $GUI_DISABLE)
         GUICtrlSetState($Ping, $GUI_DISABLE)
      EndIf
      
   Else
      GUICtrlSetState($Remove, $GUI_DISABLE)
      GUICtrlSetState($Clear, $GUI_DISABLE)
      GUICtrlSetState($Views, $GUI_DISABLE)
      GUICtrlSetState($View, $GUI_DISABLE)
      GUICtrlSetState($Ping, $GUI_ENABLE)
      
   EndIf
   
   
EndFunc   ;==>Remove

Func Pings()
   GUICtrlSetState($Add, $GUI_DISABLE)
   GUICtrlSetState($Remove, $GUI_DISABLE)
   GUICtrlSetState($Exit, $GUI_DISABLE)
   GUICtrlSetState($Ping, $GUI_DISABLE)
   GUICtrlSetState($Views, $GUI_DISABLE)
   GUICtrlSetState($View, $GUI_DISABLE)
   GUICtrlSetState($sfile, $GUI_DISABLE)
   GUICtrlSetState($Clear, $GUI_DISABLE)
   
   $max = UBound($nameArray) - 1
   While $max <> 0
      $max = $max - 1
      SplashTextOn("Please wait...", @CRLF & "Pinging " & $nameArray[$max], 200, 70, -1, -1, "", "", 8, 600)
      $var = Ping($nameArray[$max], 5000)
      If $var Then
         $file = FileOpen(@TempDir & "\PingSuccess.txt", 1)
         FileWriteLine($file, $nameArray[$max])
         FileClose($file)
      Else
         $file = FileOpen(@TempDir & "\PingFailure.txt", 1)
         FileWriteLine($file, $nameArray[$max])
         FileClose($file)
      EndIf
   WEnd
   If FileExists(@TempDir & "\PingSuccess.txt") Then GUICtrlSetState($Views, $GUI_ENABLE)
   If FileExists(@TempDir & "\PingFailure.txt") Then GUICtrlSetState($View, $GUI_ENABLE)
   SplashOff()
   MsgBox(262208, "Script Completed", "MultiPing Script completed.")
   GUICtrlSetState($Exit, $GUI_ENABLE)
EndFunc   ;==>Pings

Func Sfile()
   $j = 0
   GUICtrlSetFont(-1, 9, 500)
   GUICtrlSetState($Add, $GUI_DISABLE)
   GUICtrlSetState($Remove, $GUI_DISABLE)
   GUICtrlSetState($Exit, $GUI_DISABLE)
   GUICtrlSetState($Views, $GUI_DISABLE)
   GUICtrlSetState($View, $GUI_DISABLE)
   GUICtrlSetState($Ping, $GUI_DISABLE)
   GUICtrlSetState($sfile, $GUI_DISABLE)
   GUICtrlSetState($Clear, $GUI_DISABLE)
   $fo = FileOpenDialog("Select File", @DesktopDir, "Text files (*.txt)")
   $count = _FileCountLines($fo)
   $fos = FileOpen($fo, 0)
   While $j <> $count
      $l1 = FileReadLine($fos)
      $l = StringStripWS($l1, 8)
      _ArrayInsert($nameArray, $i, $l)
      $item = GUICtrlCreateListViewItem($nameArray[0], $list)
      $item = $item + 1
      $j = $j + 1
   WEnd
   FileClose($fos)
   GUICtrlSetData($sum, "No. of PCs = " & UBound($nameArray) - 1)
   GUICtrlSetState($Add, $GUI_ENABLE)
   GUICtrlSetState($Remove, $GUI_ENABLE)
   GUICtrlSetState($Exit, $GUI_ENABLE)
   GUICtrlSetState($Ping, $GUI_ENABLE)
   GUICtrlSetState($sfile, $GUI_ENABLE)
   GUICtrlSetState($Clear, $GUI_ENABLE)
EndFunc   ;==>Sfile 

Func Views()
   GUICtrlSetState($Add, $GUI_DISABLE)
   GUICtrlSetState($Remove, $GUI_DISABLE)
   GUICtrlSetState($Exit, $GUI_DISABLE)
   GUICtrlSetState($Ping, $GUI_DISABLE)
   GUICtrlSetState($Views, $GUI_DISABLE)
   GUICtrlSetState($View, $GUI_DISABLE)
   GUICtrlSetState($sfile, $GUI_DISABLE)
   GUICtrlSetState($Clear, $GUI_DISABLE)
   MsgBox(262208, "Save File", "Please save the file if you need it for future use." & @CRLF & "It will be deleted after viewing.")
   RunWait("notepad.exe " & @TempDir & "\PingSuccess.txt")
   FileDelete(@TempDir & "\PingSuccess.txt")
   GUICtrlSetState($Exit, $GUI_ENABLE)
   If FileExists(@TempDir & "\PingFailure.txt") Then GUICtrlSetState($View, $GUI_ENABLE)
EndFunc   ;==>Views 


Func View()
   GUICtrlSetState($Add, $GUI_DISABLE)
   GUICtrlSetState($Remove, $GUI_DISABLE)
   GUICtrlSetState($Exit, $GUI_DISABLE)
   GUICtrlSetState($Ping, $GUI_DISABLE)
   GUICtrlSetState($Views, $GUI_DISABLE)
   GUICtrlSetState($View, $GUI_DISABLE)
   GUICtrlSetState($sfile, $GUI_DISABLE)
   GUICtrlSetState($Clear, $GUI_DISABLE)
   MsgBox(262208, "Save File", "Please save the file if you need it for future use." & @CRLF & "It will be deleted after viewing.")
   RunWait("notepad.exe " & @TempDir & "\PingFailure.txt")
   FileDelete(@TempDir & "\PingFailure.txt")
   GUICtrlSetState($Exit, $GUI_ENABLE)
   If FileExists(@TempDir & "\PingSuccess.txt") Then GUICtrlSetState($Views, $GUI_ENABLE)
EndFunc   ;==>View 

Func Clear()
   If GUICtrlRead($item) = "0" Then
      GUICtrlDelete($item)
      $item = $item - 1
   EndIf
   While UBound($nameArray) - 1 > 0
      GUICtrlDelete($item)
      $item = $item - 1
      _ArrayDelete($nameArray, 0)
   WEnd
   GUICtrlSetData($sum, "No. of PCs = " & UBound($nameArray) - 1)
   If UBound($nameArray) - 1 <> 0 Then
      GUICtrlSetState($Remove, $GUI_ENABLE)
      GUICtrlSetState($Clear, $GUI_ENABLE)
      GUICtrlSetState($Views, $GUI_ENABLE)
      GUICtrlSetState($View, $GUI_ENABLE)
      GUICtrlSetState($Ping, $GUI_ENABLE)
   Else
      GUICtrlSetState($Remove, $GUI_DISABLE)
      GUICtrlSetState($Clear, $GUI_DISABLE)
      GUICtrlSetState($Views, $GUI_DISABLE)
      GUICtrlSetState($View, $GUI_DISABLE)
      GUICtrlSetState($Ping, $GUI_DISABLE)
   EndIf
EndFunc   ;==>Clear 