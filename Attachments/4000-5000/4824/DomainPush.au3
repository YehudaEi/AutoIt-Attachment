;==============================================
;DomainPush.au3
;gspino 01/30/2005
;Use AutoIT to compile
;==============================================
AutoItSetOption ("RunErrorsFatal",1)

$answer = MsgBox(4,"Domain Push Utility", "Leveraging the power of the PSEXEC utility from SysInternals " & @CRLF &  " " & @CRLF & "This script will push install or launch an exe, com or bat file to all or selective computers in a domain.  Run?")
If $answer = 7 Then
    MsgBox(4096, "Script Cancelled", "Script Cancelled, Exiting...",2)
    Exit
Endif

$answer2 = InputBox("Domain Push Utility", " " & @CRLF & "Enter the Master Password to continue", "", "*")
;change PASSWORD in the line below to one of your choice - not case sensitive
If $answer2 <> "PASSWORD" Then
 MsgBox(4096, "Error", "Incorrect password.  Exiting...",2)
 Exit
Endif

$aLoop = 1
While $aLoop = 1
  $text2 = InputBox("Domain Push Utility", " " & @CRLF & "Enter the path and package name." & @CRLF & "" & @CRLF & "Must be an .exe .com or .bat" & @CRLF & "- use unc for network paths.")
  If @error = 1 Then
      MsgBox(4096, "Script Cancelled", "Script Cancelled, Exiting...",2)
      Exit
  ElseIf $text2 = "" OR NOT FileExists($text2) Then 
     MsgBox(4096, "Error", "Missing or incorrect entry, Try again...")
       If StringTrimRight($text2, 3) <> "exe" OR StringTrimRight($text2, 3) <> "com" OR StringTrimRight($text2, 3) <> "bat"  Then
         MsgBox(4096, "Error", "Must be an .exe .com or .bat file, Try again...")
       Endif
  Else
      $aLoop = 0
  Endif
WEnd

$bLoop = 1
While $bLoop = 1    
  $text3 = InputBox("Domain Push Utility"," " & @CRLF &  "Enter a Domain Administrative account name.")
    If @error = 1 Then
      MsgBox(4096, "Script Cancelled", "Script Cancelled, Exiting...",2)
      Exit
    ElseIf $text3 = "" Then
      MsgBox(4096, "Error", "You must enter something, Try again...")
    Else
      $bLoop = 0
    Endif
WEnd

$cLoop = 1
While $cLoop = 1 
 $text4 = InputBox("Domain Push Utility", " " & @CRLF & "Enter the corresponding password.", "", "*")
    If @error = 1 Then
      MsgBox(4096, "Script Cancelled", "Script Cancelled, Exiting...",2)
      Exit
    ElseIf $text4 = "" Then
      MsgBox(4096, "Error", "You must enter something, Try again...")
    Else
      $cLoop = 0
    Endif
WEnd

$answer3 = MsgBox(4,"Domain Push Utility", "Do you want to run the remote process in the System account?")
If $answer3 = 7 Then
  $answer4 = " "
Else
 $answer4 = "-s "
Endif
 
$answer5 = MsgBox(4,"Domain Push Utility", "Is the program already in the remote system's path?")
If $answer5 = 7 Then
  $answer6 = "-c "
Else
 $answer6 = " "
Endif

$answer7 = MsgBox(4,"Domain Push Utility", "Do you want this program to be interactive with the remote desktop?")
If $answer7 = 7 Then
  $answer8 = " "
Else
 $answer8 = "-i "
Endif

$dLoop = 1
While $dLoop = 1  
  $text = InputBox("Domain Push Utility", "Enter the remote pc name, filelist, wildcard (for ALL) or leave blank for local pc" & @CRLF & "[Single pc syntax:  \\smctest]" & @CRLF & "[Filelist syntax: @\\uncpath\list.txt]" & @CRLF & "[Wildcard syntax:  \\* (for ALL pc's in the domain]")
  If @error = 1 Then
      MsgBox(4096, "Script Cancelled", "Script Cancelled, Exiting...",2)
      Exit
  Else 
      If NOT FileExists(@SystemDir & "\psexec.exe") Then
        FileInstall ("c:\public\psexec.exe", @SystemDir & "\psexec.exe" ,0)
      Endif
      RunWait(@ComSpec & " /c " & "psexec " & $text & " -u " & $text3 & " -p " & $text4 & " -d " & $answer8 & $answer6 & $answer4 & $text2, "", @SW_HIDE)
       If @error = 1 Then
         MsgBox(4096, "Domain Push Utility", "Error - Package NOT delivered to  -  " &  $text & "  -  Please check settings...",7)
       Endif 
      If @error = 0 Then
        If $text =  "" then
           $text = "Local Machine"
        Endif
        MsgBox(4096, "Domain Push Utility", "Success - Push initiated on  -  " & $text & "  -",3)
      Endif     
    $dLoop = 0
  Endif
WEnd

;Exit the application
Exit