#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiButton.au3>
#include <GuiEdit.au3>
#include <Inet.au3>
#include <File.au3>
#include <Array.au3>
#include <GUIComboBox.au3>
#include<Process.au3>
#include <Date.au3>
AutoItSetOption ( "TrayIconHide" , 1)
HotKeySet("^{F10}", "show")
HotKeySet("^{F11}", "hide")  

Global $sCOMErrMsg=""
Global $settings
 _FileReadToArray("settings.cfg",$settings)
$oCOMError = ObjEvent("AutoIt.Error","_COMErrHandler")
$PublicIP = _GetIP()
$Form1 = GUICreate("Auto SQL DATABASE Backup By KMET@", 800, 600, 339, 93)
 GUISetFont(12)
 GUISetState(@SW_SHOW)
 
$labelserv = GUICtrlCreateLabel("Server:",10,6,90,25)
$inpserv = GUICtrlCreateInput("localhost",10,25,150,22)
$labelusr = GUICtrlCreateLabel("SQL USER:",10,50,110,22)
$inpusr = GUICtrlCreateInput("sa",10,70,150,22)
$labelpass = GUICtrlCreateLabel("Password:",10,95,110,22)
$inppass = GUICtrlCreateInput("sa",10,115,150,22,BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
_GUICtrlEdit_SetPasswordChar($inppass, "*")
$labeldbr = GUICtrlCreateLabel("Database for backup:",10,140,200,20)
$labeldbr1 = GUICtrlCreateLabel("Database for restore:",10,185,200,20)
$labelip1 = GUICtrlCreateLabel("Your externel IP: "&$PublicIP,405,23,220,30)
$labelip2 = GUICtrlCreateLabel("Your Local IP: "&@IPAddress1,405,54,280,30)
$BtnQ7 = GUICtrlCreateButton("Backup from a Server in LAN",165,54,240,30,$BS_LEFT)
$BtnQ8 = GUICtrlCreateButton("Restore to a Server in LAN",165,85,240,30,$BS_LEFT)
$BtnQ6 = GUICtrlCreateButton("Database List",165,116,240,30,$BS_LEFT)
$BtnQ3 = GUICtrlCreateButton("Test connection",165,23,240,30,$bs_left)
$btnQ4 = GUICtrlCreateButton("Exit",650,10,140,30)
$btnQ5 = GUICtrlCreateButton("About",650,41,140,30)
$labelauto = GUICtrlCreateLabel("Automatic backup settings:",10,230,320,20)
$labelservauto = GUICtrlCreateLabel("Server:",10,260,90,25)
$inpservauto = GUICtrlCreateInput($settings[1],10,286,150,22)
$labeldbauto = GUICtrlCreateLabel("Database:",10,309,110,22)
$inpdbauto = GUICtrlCreateInput($settings[4],10,332,150,22)
$labelusrauto = GUICtrlCreateLabel("SQL USER:",10,355,110,22)
$inpusrauto = GUICtrlCreateInput($settings[2],10,378,150,22)
$labelpassauto = GUICtrlCreateLabel("Password:",10,401,110,22)
$inppassauto = GUICtrlCreateInput($settings[3],10,423,150,22,BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
$labelhourauto = GUICtrlCreateLabel("Hour for auto backup:",10,446,200,22)
$inphourauto = GUICtrlCreateInput($settings[6],10,469,150,22)
$labelarchauto = GUICtrlCreateLabel("On/Off auto backup:",10,492,200,22)
$inparchauto = GUICtrlCreateInput($settings[5],10,515,150,22)
$savebtn = GUICtrlCreateButton("Save settings for auto backup",10,538,300,40)
$handle = WinGetHandle($Form1)
$fdrive = "D:\SQL_BACKUP"

 
global $inpdbr =  GUICtrlCreateCombo ("",10,160,200,20)
global $inpdbr1 =  GUICtrlCreateCombo ("",10,205,200,20)


	
Func show()
	 GUISetState(@SW_SHOW,$handle)
EndFunc

Func hide()
	GUISetState(@SW_HIDE,$handle)
EndFunc


Func dblist()
	call("servcheck")
	$sServer = GUICtrlRead($inpserv)
	$sDatabase = 'master'
	$sUsername = GUICtrlRead($inpusr) 
	$sPassword = _GUICtrlEdit_GetText($inppass)
		
	
    If $sPassword = "" Then
	MsgBox(16,"Warning!!!","Please type password.")
	Else
	$sDriver = "{SQL Server}"
	$conn = ObjCreate("ADODB.Connection")
	$DSN =("DRIVER=" & $sDriver & ";SERVER=" & $sServer & ";DATABASE=" & $sDatabase & ";UID=" & $sUsername & ";PWD=" & $sPassword & ";")
	$conn.open($DSN)
	If @error Then
    MsgBox(16,"Warning!!!","No connection with selected Database.")
	Else
   	$rs = ObjCreate( "ADODB.RecordSet" )
	$rs.open("SELECT name as db FROM master.dbo.sysdatabases WHERE name NOT IN ('master','model','msdb','tempdb')", $conn)
		global $inpdbr =  GUICtrlCreateCombo ("",10,160,200,20)

	
	 While Not $rs.EOF
         
               _GUICtrlComboBox_InsertString($inpdbr, $rs.Fields("db").Value)
            $rs.MoveNext
        WEnd
	
   	$rs.close
	$conn.close
	EndIf
	EndIf
	
	$FileList=_FileListToArray($fdrive &"\","*.bak",1)
	
	global $inpdbr1 =  GUICtrlCreateCombo ("",10,205,200,20)
	Local $iMax = UBound($FileList)
    For $i = 1 to $iMax -1
        _GUICtrlComboBox_InsertString($inpdbr1, StringTrimRight($FileList[$i],4))
    Next
	
	EndFunc

Func _COMErrHandler()
   $sCOMErrMsg=hex($oCOMError.number,8) & ":" & $oCOMError.description
   SetError(1)              
Endfunc

While sleep(500)
	$msg = GUIGetMsg()
        If $msg = $GUI_EVENT_CLOSE Then 
		_RunDos("net share backup /delete") 
		ExitLoop 
		EndIf
		Events()
		$a =_NowTime()
	if $settings[5] = 1 and  $a = $settings[6] Then
	Call ("autobackup")
	EndIf
WEnd

	Func Events()
	Opt("GUIOnEventMode",1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "exitt")
	GUICtrlSetOnEvent($BtnQ3 ,"servcheck")
	GUICtrlSetOnEvent($BtnQ4 ,"exitt")
	GUICtrlSetOnEvent($BtnQ5 ,"about_program")
	GUICtrlSetOnEvent($BtnQ6 ,"dblist")
	GUICtrlSetOnEvent($BtnQ7 ,"netbackup")
	GUICtrlSetOnEvent($BtnQ8 ,"netrestore")
	GUICtrlSetOnEvent($savebtn ,"autobackupsettings")
	EndFunc

	Func about_program()
		MsgBox(64,"About","In the settings.cfg."&@LF&"Row 1: Server address."&@LF&"ROW 2: SQL USER."&@LF&"ROW 3: SQL PASSWORD."&@LF&"ROW 4: Database for autobackup."&@LF&"ROW 5: Auto backup ON = 1; OFF = 0."&@LF&"ROW 6: Hour for auto backup."&@LF&@lf&"Autor: Emil Kmetski"&@LF&"Email: ekmetski@gmail.com"&@LF&"Version: 1.6.0")
	EndFunc
	
	Func exitt()
	$rc = _RunDos("net share backup /delete")
	Exit
	EndFunc

	Func autobackupsettings()
	
	$settings[1] = GUICtrlRead($inpservauto)
	$settings[2] = GUICtrlRead($inpusrauto)
	$settings[3] = _GUICtrlEdit_GetText($inppassauto)
	$settings[4] = GUICtrlRead($inpdbauto)
	$settings[5] = GUICtrlRead($inparchauto)
	$settings[6] = GUICtrlRead($inphourauto)
	_FileWriteFromArray("settings.cfg",$settings,1)
		
	EndFunc
	
	
	func servcheck()
	
	TCPStartUp()
	Opt("TCPTimeout",10000) 
	$sServer = TCPNameToIP(GUICtrlRead($inpserv))
	$socket = TCPConnect($sServer, 1433)
	If $socket = -1 Then
		MsgBox(16,"Warning!!!!","No connection to the SERVER: "& $sServer&@lf&"Check your LAN network."&@lf&"Check Firewall TCP port 1433 allow connections.")
		
	Else
		MsgBox(64,"Info","You have a connection!!!")
	EndIf
	$sDatabase = 'master'
	$sUsername = GUICtrlRead($inpusr) 
	$sPassword = _GUICtrlEdit_GetText($inppass)
	
	$sDriver = "{SQL Server}"
	If $sPassword = "" Then
		MsgBox(16,"Warning!!!","Please type password.")
		Else
	$conn = ObjCreate("ADODB.Connection")
	$DSN =("DRIVER=" & $sDriver & ";SERVER=" & $sServer & ";DATABASE=" & $sDatabase & ";UID=" & $sUsername & ";PWD=" & $sPassword & ";")
	$conn.open($DSN)
	If @error Then
    MsgBox(16,"Warning!!!","No connection with selected Database.")
	Else
    MsgBox(64,"Info", "Connected to: "&$sDatabase&"")
	$conn.close
    EndIf
	EndIf
	   
	_GUICtrlComboBox_Destroy($inpdbr)
	_GUICtrlComboBox_Destroy($inpdbr1)
	    
EndFunc

func netbackup()
    $pcname = @ComputerName
	$sServer = GUICtrlRead($inpserv)
	$sDatabase = 'master'
	$sUsername = GUICtrlRead($inpusr) 
	$sPassword = _GUICtrlEdit_GetText($inppass)
	$sdbback = GUICtrlRead($inpdbr)
	$fdrive = "D:\SQL_BACKUP"
	$rc = _RunDos("net share backup="&$fdrive&" /unlimited")
	
    If $sPassword = "" Then
	MsgBox(16,"Warning!!!","Please type password.")
	Else
	$sDriver = "{SQL Server}"
	$conn = ObjCreate("ADODB.Connection")
	$DSN =("DRIVER=" & $sDriver & ";SERVER=" & $sServer & ";DATABASE=" & $sDatabase & ";UID=" & $sUsername & ";PWD=" & $sPassword & ";")
	$conn.open($DSN)
	If @error Then
    MsgBox(16,"Warning!!!","No connection with selected Database.")
    Else
	$rs = ObjCreate( "ADODB.RecordSet" )
	traytip("Info","Backup in proccess.",10)
	$rs.open("BACKUP DATABASE ["&$sdbback&"] TO  DISK = N'"&"\\"&$pcname&"\backup\"& $sdbback & ".bak' WITH NOFORMAT, INIT,  NAME = N'" & $sdbback & "-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10", $conn)
		
   	$rs.close
	$conn.close
	traytip("Info","Backup completed.",10)
	EndIf
	EndIf
		
EndFunc


func netrestore()
	
	$pcname = @ComputerName
	$sServer = GUICtrlRead($inpserv)
	$sDatabase = 'master'
	$sUsername = GUICtrlRead($inpusr) 
	$sPassword = _GUICtrlEdit_GetText($inppass)
	$sdbrestore = GUICtrlRead($inpdbr1)
	$fdrive = "D:\SQL_BACKUP"
	$rc = _RunDos("net share backup="&$fdrive&" /unlimited")
	
		
	If FileExists(""& $fdrive&"\"&$sdbrestore &".bak") Then
    traytip("Info","The backup exists, preparing for restore.",3)	
    
	If $sPassword = "" Then
	MsgBox(16,"Warning!!!","Please type password.")
	Else
	$sDriver = "{SQL Server}"
	$conn = ObjCreate("ADODB.Connection")
	$DSN =("DRIVER=" & $sDriver & ";SERVER=" & $sServer & ";DATABASE=" & $sDatabase & ";UID=" & $sUsername & ";PWD=" & $sPassword & ";")
	$conn.open($DSN)
	If @error Then
    MsgBox(16,"Warning!!!","No connection with selected Database.")
	Else
   	$rs = ObjCreate( "ADODB.RecordSet" )
	$rs.open("RESTORE DATABASE "& $sdbrestore &" FROM DISK = '"&"\\"&$pcname&"\backup\"&$sdbrestore & ".bak' WITH REPLACE", $conn)
    			
   	$rs.close
	$conn.close
	traytip("Info","Restore of backup complete.",10)	
	EndIf
	EndIf
	
	Else
		MsgBox(16,"Error", "The backup file does not exist!!!")
	EndIf
		
	EndFunc
	
func autobackup()
	$tt = _Now()
	$tt1 = stringmid($tt,1,2)
	$tt2 = stringmid($tt,4,2)
	$tt3 = stringmid($tt,7,4)
	$tt4 = stringmid($tt,12,2)
	$tt5 = stringmid($tt,15,2)
	$rtt = "_"&$tt1&"_"&$tt2&"_"&$tt3&"_"&$tt4&"_"&$tt5
	
    $pcname = @ComputerName
	$sServer = $settings[1]
	$sDatabase = 'master'
	$sUsername = $settings[2] 
	$sPassword = $settings[3] 
	$sdbback = $settings[4]
	$fdrive = "D:\SQL_BACKUP"
	$rc = _RunDos("net share backup="&$fdrive&" /unlimited")
	
	
    If $sPassword = "" Then
	MsgBox(16,"Warning!!!","Please type password.")
	Else
	$sDriver = "{SQL Server}"
	$conn = ObjCreate("ADODB.Connection")
	$DSN =("DRIVER=" & $sDriver & ";SERVER=" & $sServer & ";DATABASE=" & $sDatabase & ";UID=" & $sUsername & ";PWD=" & $sPassword & ";")
	$conn.open($DSN)
	If @error Then
    MsgBox(16,"Warning!!!","No connection with selected Database.")
    Else
	$rs = ObjCreate( "ADODB.RecordSet" )
	traytip("Info","Backup in process.",10)
	$rs.open("BACKUP DATABASE ["&$sdbback&"] TO  DISK = N'"&"\\"&$pcname&"\backup\"& $sdbback&$rtt&".bak' WITH NOFORMAT, INIT,  NAME = N'" & $sdbback & "-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10", $conn)
   	$rs.close
	$conn.close
	traytip("Info","Backup Completed.",10)
	
	EndIf
	EndIf
		
EndFunc

	
		

