#include <GuiConstants.au3>


$mainwindow = GuiCreate("lmandag V.1.0 full", 400, 400)

$oobutton = GUICtrlCreateButton ( "Åben din personlige text!", 50, 5, 140, 60, 0x0300)

$Cancel_Btn = GUICtrlCreateButton ( "LUK", 10, 5, 40, 60, 0x0300)

$gembutton = GUICtrlCreateButton ( "GEM", 190, 5, 40, 60, 0x0300)

$dag = GUICtrlCreateCombo ("lmandag", 235, 5, 80, 90) ; create first item
GUICtrlSetData(-1,"ltirsdag|lonsdag|ltorsdag|lfredag") ; add other item snd set a new default

$txt = GuiCtrlCreateEdit("TRYK PÅ: Åben din personlige text!", 10, 110, 380, 280)

; Function to empty a text file
; Author(s) : Groumphy
; Alias of FileOpen Mode 2
Func _EraseContentOfTxtFile($iFile)
; failure = -1
; success = File is empty
    Return FileOpen($iFile, 2)
    FileClose($iFile)
EndFunc

Func _FTPput($s_p_Host, $s_p_PathFile, $s_p_Acc, $s_p_Pwd, $s_p_Cd = '', $i_p_Check = 0, $s_p_Aftp = '')
	
	; Declaring local variables.
	Local $i_p_Return
	
	; Creating a random nummber to minimize the chance of writing to an existing file.
	Local $i_p_Random = Random(100000000, 999999999, 1)
	
	; Creating the file.
	Local $h_p_CmdFile = FileOpen(@TempDir & "\FTPcmds" & $i_p_Random & ".txt", 1)
	
	; Check if wildcards are used.
	If StringInStr($s_p_PathFile, "*") <> 0 Then Local $i_p_Check = 0
	
	; Getting the path and the filename from $s_p_PathFile.
	Local $s_p_Path = StringTrimRight($s_p_PathFile, StringLen($s_p_PathFile) - StringInStr($s_p_PathFile, "\", 0, -1) + 1)
	Local $s_p_File = StringTrimLeft($s_p_PathFile, StringInStr($s_p_PathFile, "\", 0, -1))
	
	; Create an FTP command file if the file is sucsesfully created.
	If $h_p_CmdFile <> -1 Then
		
		; Writing the account and password.
		FileWriteLine($h_p_CmdFile, $s_p_Acc & @CRLF)
		FileWriteLine($h_p_CmdFile, $s_p_Pwd & @CRLF)
		
		; Set the transfermode to binary
		FileWriteLine($h_p_CmdFile, "binary" & @CRLF)
		
		; Additional FTP commands passed to the function are actioned here.
		If $s_p_Aftp <> '' Then FileWriteLine($h_p_CmdFile, $s_p_Aftp & @CRLF)
			
		; Making the destination dir if it doesnot exist
		FileWriteLine($h_p_CmdFile, 'mkdir ' & $s_p_Cd & @CRLF)
		
		; Set the destination dir if one is given. Else 'root' will be used.
		If $s_p_Cd <> '' Then FileWriteLine($h_p_CmdFile, "cd " & $s_p_Cd & @CRLF)
		
		; Set the local directory and send the files.
		FileWriteLine($h_p_CmdFile, "lcd " & $s_p_Path & @CRLF)
		FileWriteLine($h_p_CmdFile, "mput " & $s_p_File & @CRLF)
		
		; If $i_p_Check is set to 1 it will get the transferred file back to a check area so we can confirm it worked.
		If $i_p_Check = 1 Then
			FileWriteLine($h_p_CmdFile, "lcd " & @TempDir & @CRLF)
			FileWriteLine($h_p_CmdFile, "mget " & $s_p_File & @CRLF)
		EndIf
		
		; Closes the FTP connecetion and exits the FTP program.
		FileWriteLine($h_p_CmdFile, "close" & @CRLF)
		FileWriteLine($h_p_CmdFile, "quit" & @CRLF)
		
		; Closes the file.
		FileClose($h_p_CmdFile)
		
	EndIf
	
	; Start FTP with the cmdfile to transfer the file(s) concerned.
	RunWait(@ComSpec & " /c " & 'ftp -v -i -s:' & @TempDir & "\FTPcmds" & $i_p_Random & ".txt " & $s_p_Host, "", @SW_HIDE)
	
	; Setting the return value's.
	If $i_p_Check = 1 And Not FileExists(@TempDir & "\" & $s_p_File) Then
		$i_p_Return = -1
	ElseIf $i_p_Check = 1 And FileExists(@TempDir & "\" & $s_p_File) Then
		$i_p_Return = 1
	Else
		$i_p_Return = 0
	EndIf
	
	; Delete the temp files.
	FileDelete(@TempDir & "\" & $s_p_File)
	FileDelete(@TempDir & "\FTPcmds" & $i_p_Random & ".txt")
	
	; Return the returnvalue.
	Return $i_p_Return
	
EndFunc   ;==>_FTPput




; PROGRESS
GuiCtrlCreateLabel("Fremgang:", 10, 82)
$progress = GuiCtrlCreateProgress(70, 80, 320, 20, 0x01)
GuiCtrlSetData(-1, 00)

;Show window/Make the window visible
GUISetState(@SW_SHOW)

While 1
  ;After every loop check if the user clicked something in the GUI window
   $msg = GUIGetMsg()

   Select
   
     ;Check if user clicked on the close button
      Case $msg = $GUI_EVENT_CLOSE
        ;Exit the script
         Exit
         
     ;Check if user clicked on the "OK" button
      Case $msg = $oobutton
	 	 InetGet("                                   ", "$dag" & ".txt", 1, 0)
		 sleep(2000)
		 $open = FileOpen("$dag" & ".txt", 0)
		 $File_Read = FileRead("$dag" & ".txt", FileGetSize("$dag" & ".txt"))
		 GUICtrlDelete($txt)
	 	 ; EDIT
		 $txt = GuiCtrlCreateEdit($File_Read, 10, 110, 380, 280)
	 	 _EraseContentOfTxtFile("$dag" & ".txt")


 	  	 ;Check if user clicked on the "OK" button
 		      Case $msg = $gembutton
		      $new = ControlGetText("lmandag", "", "Edit1")
	 	      FileWrite("lmandag.txt", $new)
  		      GUICtrlDelete($progress)
		      $progress = GuiCtrlCreateProgress(70, 80, 320, 20, 0x01)
		      GuiCtrlSetData(-1, 50)
		      sleep(500)
		      _FTPput('195.245.210.174', 'lmandag.txt', 'ftp-skjernhs-1go', '*********')
		      MsgBox(64, "INFO", "Filen er nu opdateret")
		      GuiCtrlSetData(-1, 100)
	 	      sleep(1000)
		      GuiCtrlSetData(-1, 00)

     ;Check if user clicked on the "CANCEL" button
      Case $msg = $Cancel_Btn
         Exit

   EndSelect

WEnd

