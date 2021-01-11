#cs -------------------------------------------------------------
 AutoIt Version: 3.1.1.0

This is a helper application to assist in obtaining/uploading
files from/to an FTP server the user does not need to know:
the address of the server the username or password

we use different upload and download directories
and different up and download usernames and passwords

demonstrates FTP up and downloads Tooltray Tips

It is limited to up/downloading a single file at a time and will use
the proxy settings set in Internet Explorer. Downloaded files"
will be placed in the folder the program is run from.

Details of actions are logged in the file ftphelperlog.txt

This program does NOT send any information to any other computer
other than the information required to download the requested file
to this PC

Internet Explorer 3 or greater must be installed for this to work.

search for ??? and update the code with the required information

This program throws a FALSE POSITIVE positive in the Symantes products
when compiled with UPX compression. So be sure to de-select the 
"UPX compress .exe stub" option off the compression Menu before
compiling (Still only 384 k in size though)

#ce -------------------------------------------------------------

Global $ServerIP = "127.0.0.1"				; ??? IP address of the server
Global $UploadDir = "/pub/incoming/"		; ??? the directory for the Uploaded Files
Global $DownloadDir = "/pub/outgoing/"		; ??? the directory to place the Downloaded Files
Global $UploadUserName = ""					; ??? Upload username		Check the Init() function
Global $UploadPWD = ""						; ??? Upload Password		Check the Init() function
Global $DownloadUserName = ""				; ??? Download Username		Check the Init() function
Global $DownloadPWD = ""					; ??? Upload Username		Check the Init() function

#include <GUIConstants.au3>
#include <ftp.au3>

$g_szVersion = "FTP Helper 2.4"

Opt("GUIOnEventMode", 1)

If WinExists($g_szVersion) Then Exit ; It's already running
;

$main = GUICreate($g_szVersion, 330, 100) 

$filemenu = GuiCtrlCreateMenu ("File")
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
GUICtrlSetOnEvent($exititem ,"OnExit")

$helpmenu = GuiCtrlCreateMenu ("Help")
$Infoitem = GuiCtrlCreateMenuitem ("Info",$helpmenu)
GUICtrlSetOnEvent($Infoitem ,"OnInfo")

$separator1 = GuiCtrlCreateMenuitem ("",$helpmenu)
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)
GUICtrlSetOnEvent($aboutitem ,"OnAbout")

$FiletoGet = GUICtrlCreateInput ( ""  ,4,2,290,20)

$brbutton = GuiCtrlCreateButton ("...",300,4,20,20)
GUICtrlSetOnEvent($brbutton ,"BrowseOK")

$downbutton = GuiCtrlCreateButton ("DOWN-Load file",10,40,90,30)
GUICtrlSetOnEvent($downbutton ,"DownOK")
GUICtrlSetState($downbutton ,$GUI_DEFBUTTON)

$upbutton = GuiCtrlCreateButton ("UP-Load file",120,40,90,30)
GUICtrlSetOnEvent($upbutton ,"UpOK")

$exitbutton = GuiCtrlCreateButton ("Exit",230,40,90,30)
GUICtrlSetOnEvent($exitbutton ,"OnExit")

; use the current internet explorer proxy settings
FtpSetProxy(0)

$PCLog = FileOpen(@scriptDir & "\ftphelperlog.txt", 1)
FileWriteLine($PCLog, $g_szVersion & " Started at " & @hour & ":" & @Min & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " By " & @username & " From " & @ComputerName)

GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")
GUISetState(@SW_SHOW)  ; display the GUI

Init()

While 1
   Sleep (1000)
WEnd

;--------------- Functions ---------------
Func Init()
	; put some code in here that builds the username and passwords from $chr()  
	; or some other mechanism
	
	; we could have used random numbers with a fixed seed if 
	; Jonathan hadn't implemented the Mersenne Twister random number generator

	$thing = "1q2w3e4r5t6y7u8i9o0pazsxdcfvgbhnjmklA1X2E3C4VR5TGB67HNM789KL01q2w3e4r5t6y7u8i9o0pazsxdcfvgbhnjmklA1X2E3C4VR5TGB67HNM789KL0"
	
	$UploadUserName = ""		
	$UploadPWD = ""			
	$DownloadUserName = ""	
	$DownloadPWD = ""	
	
	For $inx = 8 to 28 step 3
		$UploadUserName = $UploadUserName & StringMid($thing,$inx,1)
	Next

	For $inx = 27 to 98 step 6
		$UploadPWD = $UploadPWD & StringMid($thing,$inx,2)
	Next

	For $inx = 48 to 123 step 9
		$DownloadUserName = $DownloadUserName & StringMid($thing,$inx,1)
	Next

	For $inx = 120 to 10 step -16
		$DownloadPWD = $DownloadPWD & StringMid($thing,$inx,2)
	Next


;~ 	MsgBox(0,$UploadUserName,$UploadPWD )
;~ 	MsgBox(0,$DownloadUserName,$DownloadPWD )
	
EndFunc

;-----------------------------------------
Func DownOK()
$root="@" & $ServerIP & $DownloadDir       
$uid = $DownloadUserName & ":"				
$pwd= $DownloadPWD					

$Filevar = GUICtrlRead($FiletoGet)
$array = StringSplit($Filevar, '/', 1)
$LocalVar = $array[$array[0]]

if Stringlen($Filevar) = 0 then
	   MsgBox(0, "FileName error", "Please specify a file to download")
Else

	FileWriteLine( $PCLog,"Started Downloading " & $LocalVar & " from " & $Filevar & " at " & @hour & ":" & @Min & " on " & @MDAY & "/" & @MON & "/" & @YEAR)

	; disable the OK
	GUICtrlSetState($downbutton,$GUI_DISABLE)
	GUICtrlSetState($upbutton,$GUI_DISABLE)
	GUICtrlSetState($exitbutton,$GUI_DISABLE)

	InetGet("ftp://" & $uid & $pwd & $root & $Filevar, $LocalVar, 1, 1)

	While @InetGetActive
		TrayTip("Downloading " & $LocalVar, " Bytes = " & @InetGetBytesRead, 10, 16)
		Sleep(500)
	Wend
	
	if @InetGetBytesRead = -1 then
		FileWriteLine(  $PCLog, $LocalVar & " NOT downloaded at " & @hour & ":" & @Min & " on " & @MDAY & "/" & @MON & "/" & @YEAR)
		 $LocalVar =  $LocalVar & " NOT " 
	else 
		FileWriteLine(  $PCLog,"Completed download at " & @hour & ":" & @Min & " on " & @MDAY & "/" & @MON & "/" & @YEAR)
	endif

	;Re-enable the OK button
	GUICtrlSetState($downbutton,$GUI_ENABLE)
	GUICtrlSetState($upbutton,$GUI_ENABLE)
	GUICtrlSetState($exitbutton,$GUI_ENABLE)
	
	MsgBox(0, "Download Status", @CRLF & $LocalVar & @CRLF & "Downloaded" & @CRLF & @CRLF & @InetGetBytesRead & " Bytes." & @CRLF)

Endif
    
EndFunc
;-----------------------------------------
Func UpOK()

	$server = $ServerIP				
	$username = $UploadUserName			
	$pass = $UploadPWD					
	
	$l_Flags = 0x08000000
	
	$Filevar = GUICtrlRead($FiletoGet)


	if not StringInStr($Filevar,":\") then
		msgbox(0,"Error:","Please browse to a file to upload using the '...' button on the right")
		return
	endif

	$array = StringSplit($Filevar, '\', 1)
	$LocalVar = $array[$array[0]]
	
	; disable the OK
	GUICtrlSetState($downbutton,$GUI_DISABLE)
	GUICtrlSetState($upbutton,$GUI_DISABLE)
	GUICtrlSetState($exitbutton,$GUI_DISABLE)

	$Open = _FTPOpen('MyFTP Control')
	if @error then
		msgbox(0,"Error:","Failed open FTP port. Please contact the Administrator.")
		Exit
	endif

	$Conn = _FTPConnect($Open, $server, $username, $pass)
	if @error then
		msgbox(0,"Error:","Failed to connect to FTP Server. Please contact the Administrator.")
		Exit
	endif

	$retval = _FTPSetCurrentDir($Conn, $UploadDir)	
	$retval = _FtpPutFile($Conn,$Filevar , $LocalVar)
	
	if @error then
		msgbox(0,"Error:","Failed to upload " & $LocalVar & " to FTP Server. Please contact the Administrator.")
		FileWriteLine(  $PCLog,"Error:","Failed to upload " & $LocalVar & " to FTP Server. Please contact the Administrator.")
		Exit
	else
		msgbox(0,"Success: " & $LocalVar,$Filevar & " uploaded to FTP Server.")
		FileWriteLine(  $PCLog,"Success: " & $LocalVar & $Filevar & " uploaded to FTP Server.")
	endif

	$retval = _FTPClose($Open)

	;Re-enable the OK button
	GUICtrlSetState($downbutton,$GUI_ENABLE)
	GUICtrlSetState($upbutton,$GUI_ENABLE)
	GUICtrlSetState($exitbutton,$GUI_ENABLE)

EndFunc
;-----------------------------------------
Func BrowseOK()

	$dnfile = FileOpenDialog ( "File to Up-load", @ScriptDir & "\", "All (*.*)", 3)
	GUICtrlSetData ( $FiletoGet, $dnfile )

EndFunc
;-----------------------------------------
Func OnExit()
 GUIDelete()
 FileWriteLine($PCLog,$g_szVersion & " Closed at " & @hour & ":" & @Min & " on " & @MDAY & "/" & @MON & "/" & @YEAR)
    Exit
EndFunc

;-----------------------------------------
Func OnAbout()
	Msgbox(0,"About",$g_szVersion & @CRLF & @CRLF & "© Nobody really")
EndFunc

;-----------------------------------------
Func OnInfo()
$msg = $g_szVersion & @CRLF & "© Nobody really" & @CRLF & @CRLF
$msg = $msg & "This is a helper application to assist in obtaining/uploading" & @CRLF
$msg = $msg & "files from/to the the FTP server" & @CRLF & @CRLF
$msg = $msg & "It is limited to up/downloading a single file at a time and will use" & @CRLF
$msg = $msg & "the proxy settings set in Internet Explorer. Downloaded files" & @CRLF 
$msg = $msg & "will be placed in the folder the program is run from." & @CRLF
$msg = $msg & "Details of files downloaded are logged in the file" & @CRLF
$msg = $msg & "ftphelperlog.txt" & @CRLF & @CRLF
$msg = $msg & "This program does NOT send any information to any other computer" & @CRLF 
$msg = $msg & "other than the information required to download the requested file"  & @CRLF
$msg = $msg & "to this PC" & @CRLF & @CRLF
$msg = $msg & "Internet Explorer 3 or greater must be installed for this to work." & @CRLF

	Msgbox(0,"Information",$msg )
EndFunc