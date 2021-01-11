#include <GuiConstants.au3>
#include <array.au3>
#include <file.au3>
#include "ftp.au3"

$mainwindow = GuiCreate("Secret L-Upl v.1", 400, 160)

$oobutton = GUICtrlCreateButton ( "Choose file", 20, 5, 180, 60, 0x0300)

$gembutton = GUICtrlCreateButton ( "Save / Upload", 200, 5, 180, 40, 0x0300)

GuiCtrlCreateLabel("-.-", 205, 45, 180, 20)

GuiCtrlCreateLabel("File name:", 10, 80)

$label = GuiCtrlCreateLabel("No file choosen", 55, 80, 345, 40)

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
				$navn = FileOpenDialog ("Choose file:", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "(*.*)")
				If @error Then ContinueLoop
				GUICtrlSetData($label, $navn)

    $username = 'Username'
    $pass = 'Password'
    $server = 'IP/Hostname'
    
    Global $INTERNET_FLAG_PASSIVE = 0x08000000
    Global $FTP_TRANSFER_TYPE_UNKNOWN = 0x00000000
    Global $FTP_TRANSFER_TYPE_ASCII = 0x00000001
    Global $FTP_TRANSFER_TYPE_BINARY = 0x00000002

 	  	 ;Check if user clicked on the "OK" button
	 Case $msg = $gembutton
			Dim $szDrive, $szDir, $szFName, $szExt
			$TestPath = _PathSplit($navn, $szDrive, $szDir, $szFName, $szExt)
			GUICtrlSetData($label, $szFName& $szExt & "Is now being uploaded")
			$Open = _FTPOpen('MyFTP')
		    $Conn = _FTPConnect($Open, $server, $username, $pass, 21, 1, $INTERNET_FLAG_PASSIVE)
			$Ftpp = _FtpPutFile($Conn, $navn, $szFName& $szExt, $FTP_TRANSFER_TYPE_BINARY)
			$Ftpc = _FTPClose($Open)

   EndSelect

WEnd

