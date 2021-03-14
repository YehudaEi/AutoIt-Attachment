#include <FTPEx.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "Toast.au3"
#include "Marquee.au3"

Global $aMarquee[8], $Round
Global $filenme, $filename, $open1
Global $sMsg, $hProgress, $aRet[2]
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Tony's FTP Upload Client", 442, 327, 205, 130)
GUISetBkColor(0x008000)
$Input1 = GUICtrlCreateInput(IniRead("Default.ini", "Login", "Host", "Host") , 16, 72, 401, 21)
GUICtrlSetBkColor(-1, 0xC8C8C8)
GUICtrlSetTip(-1, "Enter Host name or IP")
$Input2 = GUICtrlCreateInput(IniRead("Default.ini", "Login", "User", "User"), 16, 112, 193, 21)
GUICtrlSetBkColor(-1, 0xC8C8C8)
GUICtrlSetTip(-1, "Enter Your Username")
$Input3 = GUICtrlCreateInput(IniRead("Default.ini", "Login", "Pass", "Password"), 224, 112, 193, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
GUICtrlSetBkColor(-1, 0xC8C8C8)
GUICtrlSetTip(-1, "Enter Your Password")
$Label1 = GUICtrlCreateLabel("FTP Upload", 120, 16, 186, 41)
GUICtrlSetFont(-1, 24, 800, 0, "MS Sans Serif")
$Input4 = GUICtrlCreateInput(IniRead("Default.ini", "Login", "Public", "/public_html/"), 16, 152, 193, 21)
GUICtrlSetBkColor(-1, 0xBFCDDB)
GUICtrlSetTip(-1, "Optional")
$Input5 = GUICtrlCreateInput(IniRead("Default.ini", "Login", "Folder", " "), 224, 152, 193, 21)
GUICtrlSetBkColor(-1, 0xBFCDDB)
GUICtrlSetTip(-1, "Optional")
$Button1 = GUICtrlCreateButton("Choose File", 152, 184, 121, 25)
$Upload = GUICtrlCreateButton("Log-IN", 152, 232, 121, 49)
$aMarquee[1] = _GUICtrlMarquee_Init()
_GUICtrlMarquee_SetScroll($aMarquee[1], Default, "alternate", "right", 7)
_GUICtrlMarquee_SetDisplay($aMarquee[1], 1, 0xFF0000, 0xFFFBF0, 12, "times new roman")
_GUICtrlMarquee_Create($aMarquee[1], "Waiting For Task", 40, 296, 353, 21)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		 Case $Upload
			$host = GUICtrlRead ($Input1)
			$user = GUICtrlRead ($Input2)
			$pass = GUICtrlRead ($Input3)
			$public = GUICtrlRead ($Input4)
			$folder = GUICtrlRead ($Input5)
			If $open1 = 0 Then
			   $open = _FTP_Open("MySQL Upload")
			   If $open Then
				  $conn = _FTP_Connect($open, $host, $user, $pass, 0, 21)
				  If $conn Then
					 _GUICtrlMarquee_Reset($aMarquee[1], "Loged-In")
					 $open1 = 1
					 GUICtrlSetData($Upload, "Upload")
				  Else
					 _GUICtrlMarquee_Reset($aMarquee[1], "Log-In Error: 102")
					 FileWriteLine("log.txt", "Error 102: Login Failed")
				  EndIf
			   Else
				  _GUICtrlMarquee_Reset($aMarquee[1], "Error 101: Internet Issues")
				  FileWriteLine("log.txt", "Error 101: Internet Issues")
			   EndIf
			Else 
			   If $filename = "" Then
				  FileWriteLine("log.txt", "Error 100: Retardation")
				  MsgBox(0, "Your Stupid", "You forgot to select a file, Comence facepalming(Error 100)")
			   Else
				  $host = GUICtrlRead ($Input1)
				  $user = GUICtrlRead ($Input2)
				  $pass = GUICtrlRead ($Input3)
				  $public = GUICtrlRead ($Input4)
				  $folder = GUICtrlRead ($Input5)
				  _FileSize_In_MegaBytes($filename)
			   EndIf
			EndIf
		 Case $Button1
			$filename = FileOpenDialog("File Select", @ScriptDir, "Select File ()", 1 + 4 )
			If $filename = "" Then
			Else 
			   GUICtrlSetData($Button1, $filename)
			   _GUICtrlMarquee_Reset($aMarquee[1], "File Selected")
			EndIf
	EndSwitch
WEnd

Func Upload_it()
    $parse = StringSplit($filename, "\")
	$num = $parse[0]
	$filenme = $parse[$num]
		If $conn Then
		   If $Round > 5 Then
			   $sMsg  = "Upload Started" & @CRLF & @CRLF
			   $sMsg &= "Program Hidden until completion" & @CRLF & "Upload Size: " & $Round
			   $aRet = _Toast_Show(0, "Tony's FTP Upload Client", $sMsg, 2)
			   _Toast_Hide()
		    EndIf
			$ftpp = _FTP_FilePut($conn, $filename, $public & $folder & $filenme)
			_GUICtrlMarquee_Reset($aMarquee[1], "Uploading File")
			If $ftpp Then
				_FTP_Close($open)
				$open1 = 0
				GUICtrlSetData($Upload, "Log-IN")
				ClipPut("http://" & $host & $folder & "/" & $filenme)
				_GUICtrlMarquee_Reset($aMarquee[1], "File Uploaded")
				FileWriteLine("log.txt", @MON & "/" & @MDAY & "/" & @YEAR & " " &"http://" & $host & $folder & "/" & $filenme)
				GUISetState(@SW_SHOW)
			 Else
				FileWriteLine("log.txt", "Error 103: Upload Failed")
			    _GUICtrlMarquee_Reset($aMarquee[1], "Upload Error: 103")
			 EndIf
		 EndIf
 EndFunc
 
 

Func _FileSize_In_MegaBytes ($File)
   $MegaByte = ('1048576')
   $FileSizeInBytes = FileGetSize ($File)
   $Equal = $FileSizeInBytes / $MegaByte
   $Round = Round ($Equal, '2')
   If $Round > 5 Then
	  GUISetState(@SW_HIDE)
	  Upload_it()
   Else
	  Upload_it()
   EndIf
EndFunc