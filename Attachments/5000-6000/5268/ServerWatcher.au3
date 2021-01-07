;==============================================================
;SERVER WATCHER WRITTEN BY GSPINO 3/24/2005
;==============================================================
;SET OPTIONS AND DECLARE VARIABLES
HotKeySet("^{F2}", "ExitFunc") ; HOT KEY TO EXIT PROGRAM [CTRL- F2]
$HostFile = "Servers.txt"
;==============================================================
$var1 = InputBox("Server Watcher", " Enter Ping Timeout Value in Milliseconds" & @CRLF & "(4000 default without input)" & @CRLF & @CRLF & "NOTE: Ctrl-F2 Hotkey to exit program")
If @error = 1 Then
  MsgBox(0, "User Cancelled", "User cancelled, Exiting Program", 3)
  Exit
EndIf
$var2 = InputBox("Server Watcher", " Enter % CPU Load Threshhold", "80", " M2")
If @error = 1 Then
  MsgBox(0, "User Cancelled", "User cancelled, Exiting Program", 3)
  Exit
EndIf
;==============================================================
;OPEN HOSTS FILE, SERVER.TXT
While 1
  $file = FileOpen($HostFile, 0)
  ;IF SERVERS.TXT FILE IS MISSING FROM PROGRAM DIRECTORY, DISPLAY MESSAGE AND EXIT
  If $file = -1 Then
    MsgBox(16, "Server Watcher", " Sorry can't proceed. " & @CRLF & " The File : ' Servers.txt ' is missing in the application directory ")
    Exit
  EndIf
  ;SEQUENTIALLY READ EACH SERVER NAME AND USE IN ROUTINE
  While 1
    $Host = FileReadLine($file)
    If @error = -1 Then ExitLoop
    ;PING THE SERVER
    $task1 = Ping($Host, $var1)
    ;IF SERVER IS ONLINE, CHECK CPU LOAD
    If Not $task1 Then
      TrayTip("Server Watcher", " No answer from " & $Host & " at : " & @HOUR & ":" & @MIN & ":" & @SEC, 20, 1)
    Else
      $wbemFlagReturnImmediately = 0x10
      $wbemFlagForwardOnly = 0x20
      $colItems = ""
      $strComputer = $Host
      $objWMIService = ObjGet ("winmgmts:\\" & $strComputer & "\root\CIMV2")
      $colItems = $objWMIService.ExecQuery ("SELECT * FROM Win32_Processor", "WQL", _
          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
      If IsObj ($colItems) Then
        For $objItem In $colItems
          If Int($objItem.LoadPercentage) > $var2 Then
            TrayTip("Server Watcher", " CPU Load on " & $strComputer & " at : " & $objItem.LoadPercentage & " %", 20, 1)
          EndIf
        Next
      Else
        MsgBox(0, "WMI Output", "No WMI Objects Found for class: " & "Win32_Processor")
      EndIf
    EndIf
  WEnd
  FileClose($file)
  Sleep(30000)
WEnd
;==============================================================
Func ExitFunc()
  $Answer = MsgBox(4, "Server Watcher", " End the Server Watcher Program? ")
  If $Answer <> 7 Then Exit
EndFunc   ;==>ExitFunc
;==============================================================