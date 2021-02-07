#include <array.au3>
#include "mysql.au3"
#include <Crypt.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Constants.au3>
#include <IE.au3>
#include <File.au3>
#include <ListviewConstants.au3>
#include <ListboxConstants.au3>
#Include <GuiListView.au3>
#include <Timers.au3>
#include <INet.au3>
#include <GuiImageList.au3>
#include <String.au3>
#Include <Date.au3>
#include <StaticConstants.au3>
#include <GuiStatusBar.au3>
#Include <GuiEdit.au3>
#include <sqlite.au3>
#include <sqlite.dll.au3>
#include <WinAPI.au3>
#NoTrayIcon
 _sqliteload()
FileInstall( "C:\xampp\htdocs\mobdata\Edits\test.bmp", @ScriptDir & "\search.bmp", 1 )
Global $combousr, $switchaccview, $radbull, $radrank, $bkcolor = IniRead(@scriptdir & "\mobdata.ini", "all", "bgcolor", "000000"), $textcolor = IniRead(@scriptdir & "\mobdata.ini", "all", "textcolor", "FFFFFF"), $group, $whoson, $cmbbfinf, $cmbbf, $cmbcash, $cmbcashinf
Global $cmbemailinf, $array, $cmbpassinf,$cmbinloginf,$cmbranginf,$cmbbulletsinf, $cmbcrewinf, $cmbpayedinf, $cmbhide, $loginie, $loginss, $cmbemail,$cmbpass,$cmbrang,$cmbbullets,$cmbinlog,$cmbpayed,$cmbcrew,$cmbhide,$cmbhidin, $loginconst, $usrnameinf, $usrname, $usruserlevel, $usruserlevelinf, $usrgroupp
Global $aantalacc, $aantalgf, $aantalboss, $aantallb, $aantalas, $aantalhi, $aantalap, $aantalbac, $aantalll, $aantalcash, $comboips, $modata, $setred, $bkreversecolor, $textreversecolor, $mainchat, $topic, $lal, $messages, $oIE, $forumyo, $logincm, $hStatus, $filteroff, $combojan, $userss, $savebut, $passbut, $delbut
;connect

$strbk = StringSplit($bkcolor, "",1)
$strtext = StringSplit($textcolor, "",1)
$textreversecolor = "0x" & $strtext[5] & $strtext[6]& $strtext[3]& $strtext[4]& $strtext[1]& $strtext[2] 
$bkreversecolor = "0x" & $strbk[5] & $strbk[6]& $strbk[3]& $strbk[4]& $strbk[1]& $strbk[2] 
$bkcolor = "0x" & $bkcolor
$textcolor = "0x" & $textcolor

_MySQL_InitLibrary()
If @error Then Exit MsgBox(16, '', "could not init MySQL")
$MysqlConn = _MySQL_Init()
$connected = _MySQL_Real_Connect($MysqlConn, "myserver(A)", "user", "*******", "mobdata", 3306)
If $connected = 0 Then Exit MsgBox(16, 'Connection Error', _MySQL_Error($MysqlConn))
$ver = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Mobdata", "Version")
If $ver <> "3.5.1" Then
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Mobdata", "Version")
RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Mobdata", "Version", "REG_SZ", "3.5.1")
$ver = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Mobdata", "Version")
EndIf
_Checkip()
If _Versioncheck() <> $ver Then
	$ques = MsgBox(36,"Update", "There is an update, do you want to update? If you press yes, be shure you close all programs of mobdata.")
	If $ques = 7 Then
	ElseIf $ques = 6 Then
	Run( @scriptdir & "\update.exe" )
	Exit 0
	EndIf

EndIf

Func _sqliteload()
	If FileExists(@scriptdir & "\pidhandler.db") Then FileDelete(@scriptdir & "\pidhandler.db")
		If Not FileExists( @SystemDir & "\sqlite3.dll") Then
		MsgBox(16,"Fail", "sqlite3.dll doesn't exists, please download sqlite3.dll through google, and place it at " & @SystemDir & "\." )
		Else
		_SQLite_Startup(@SystemDir & "\sqlite3.dll")
		_SQLite_Open(@ScriptDir &"\pidhandler.db")
		_SQLite_Exec(-1,"CREATE TABLE tblpid (a INTEGER PRIMARY KEY,pid TEXT,userid INTEGER,fillpassid INTEGER);")
		_SQLite_Close(-1)
		_SQLite_Shutdown()
		EndIf
EndFunc

Func _Versioncheck()
	$query = "SELECT * FROM version"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf
$res = _MySQL_Store_Result($MysqlConn)
$arr = _MySQL_Fetch_Result_StringArray($res)
Return $arr[1][0]
EndFunc

Func _Checkip()
	$query = "SELECT * FROM iptable WHERE ip='" & _GetIP() & "' LIMIT 1"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf

$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
If $rows = 0 Then
	MsgBox(16,"Fail", "Your Ip-adres doesn't have rights to this DB. Contact your admin to get that rights. Your ip: " & _GetIP() & " and is now putted into your clipboard.")
	ClipPut(_GetIp())
	Exit 0
ElseIf $rows = 1 Then
$array = _MySQL_Fetch_Result_StringArray($res)


Return $array
EndIf
EndFunc

Func _Inlogcheck($username, $password)
_Crypt_Startup()
$passcheck = _Crypt_HashData($password,$CALG_MD5)
_Crypt_Shutdown()
$query = "SELECT * FROM users WHERE name='" & $username & "' And pass='" & $passcheck & "' LIMIT 1"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf

$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
If $rows = 0 Then
	MsgBox(16,"Faal", "Je hebt je gegevens verkeerd ingevuld, kut!")
ElseIf $rows = 1 Then
$array = _MySQL_Fetch_Result_StringArray($res)
$nowtime = @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR &":"& @MIN &":"& @SEC
;2010-05-04 18:15:19
$query = "INSERT INTO `mobdata`.`logs` (`logid`, `ip`, `userid`, `datum`, `inout`) VALUES (NULL, '"& _GetIP() &"', '"& $array[1][0]&"', '"&$nowtime&"', '0')";
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf

Return $array
EndIf
EndFunc

Func _Whoonline()
	$query = "SELECT `name` FROM `users` WHERE `online`=1"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf
$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
If $rows = 0 Then
	$arr = "Nobody?:P"
Else
$name = _MySQL_Fetch_Result_StringArray($res)
$i = 1
$arr = ""
While $i <= $rows
	If $i = $rows Then
	$arr &= $name[$i][0]
	Else
	$arr &= $name[$i][0] & ", "
	EndIf
	$i = $i + 1
WEnd
EndIf
Return $arr
EndFunc

Func _Defineinfnumbshit()
	If FileExists(@scriptdir & "\users.dat") Then
	FileDelete( @scriptdir & "\users.dat")
	EndIf
	_FileCreate(@scriptdir & "\users.dat")
	$query = "SELECT `userid`,`name`  FROM `users`"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf
$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
If $rows = 0 Then
	FileWriteLine( @ScriptDir & "\users.dat", "Nobody")
Else
$name = _MySQL_Fetch_Result_StringArray($res)
$i = 1
While $i <= $rows
	_FileWriteToLine( @ScriptDir & "\users.dat", $i, $name[$i][1] & "	"& $name[$i][0], 1)
	$i = $i + 1
WEnd
EndIf
EndFunc

Func _Numbinf($numb)
Dim $blazer, $name
	_FileReadToArray( @scriptdir & "\users.dat", $blazer)
	$i = 1
	While $i <= $blazer[0]
		$hao = StringSplit($blazer[$i], "	", 1)
	If $hao[2] = $numb Then
		$name = $hao[1]
		ExitLoop
	EndIf
	$i = $i + 1
	WEnd
Return $name
EndFunc

Func _Infnumb($numb)
	Dim $blazer, $name
	_FileReadToArray( @scriptdir & "\users.dat", $blazer)
	$i = 1
	While $i <= $blazer[0]
		$hao = StringSplit($blazer[$i], "	", 1)
	If $hao[1] = $numb Then
		$name = $hao[2]
		ExitLoop
	EndIf
	$i = $i + 1
	WEnd
Return $name
EndFunc

Func _Login()
$inichknp = IniRead( @scriptdir & "\mobdata.ini", "all", "rememberpass", 0)
$iniuser = IniRead( @scriptdir & "\mobdata.ini", "all", "name", "")
$inipass = IniRead( @scriptdir & "\mobdata.ini", "all", "pass", "")
GUICreate("Login", 250,130, -1, -1, $WS_POPUPWINDOW)	
GUISetBkColor($bkcolor)
GUICtrlSetDefColor( $textcolor)


$chknp = GUICtrlCreateCheckbox( " ", 10, 70)
GUICtrlCreateLabel( "Remember blabla", 35, 74)
$ok = GUICtrlCreateButton( "OK", 10, 100)
GUICtrlSetColor(-1,0x000000)
GUICtrlCreateLabel("Loginname", 10, 10)
GUICtrlCreateLabel("Password", 10, 40)

$name = GUICtrlCreateInput( $iniuser, 100, 10, 100, -1)
GUICtrlSetColor(-1,0x000000)
$pass = GUICtrlCreateInput( $inipass, 100, 40, 100, -1, $ES_PASSWORD)
GUICtrlSetColor(-1,0x000000)

If $inichknp = 1 Then
GUICtrlSetState( $chknp, $GUI_CHECKED )
Else
GUICtrlSetState( $chknp, $GUI_UNCHECKED )
EndIf
GUISetState(@SW_SHOW)
Send("{tab}")
While 1
        $msg = GUIGetMsg()
		Select
		Case $msg = $ok
		$testa = GUICtrlRead($chknp)
		$ntest = GUICtrlRead($name)
		$ptest = GUICtrlRead($pass)
		
		$arruser = _Inlogcheck($ntest, $ptest)
		If $arruser = 0 Then
		Exit 0 
		Else
		If $testa = $GUI_CHECKED Then
		IniWrite( @scriptdir & "\mobdata.ini", "all", "name", $ntest)
		IniWrite( @scriptdir & "\mobdata.ini", "all", "pass", $ptest)
		IniWrite( @scriptdir & "\mobdata.ini", "all", "rememberpass", 1)
		Else
		IniDelete( @scriptdir & "\mobdata.ini", "all", "name")
		IniDelete( @scriptdir & "\mobdata.ini", "all", "pass")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "rememberpass", 0)
		EndIf
		
		ExitLoop
		EndIf
		
		EndSelect
    WEnd
    GUIDelete()
	Return $arruser
EndFunc

Func _Firstrun()

EndFunc

Func _YourAcc($arruser)
Local $accounts[2][15]
$trer = GUICtrlRead($switchaccview)
If $trer = "" Then $trer = "Your accounts"
$query = ""
If $trer = "Your accounts" Then
$query = "SELECT * FROM `fillpass` WHERE `userid`='"& $arruser[1][0] & "'"
ElseIf $trer = "All accounts" Then
$query = "SELECT * FROM `fillpass`"
Else
$trarar = StringReplace( $trer, "'s accounts", "")
$numbo = _Infnumb($trarar)
$query = "SELECT * FROM `fillpass` WHERE `userid`='"& $numbo & "'"
EndIf
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf

$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
If $rows = 0 Then
	$accounts[0][0] = 1
	$accounts[1][0] = 1
	$accounts[1][1] = "Nobody"
	$accounts[1][2] = "hebt"
	$accounts[1][3] = "nog"
	$accounts[1][4] = "geen"
	$accounts[1][5] = "accounts"
	$accounts[1][6] = "in"
	$accounts[1][7] = "de"
	$accounts[1][8] = "data"
	$accounts[1][9] = "1"
	$accounts[1][10] = $arruser[1][0]
	$accounts[1][11] = ""
	$accounts[1][12] = ""
	$accounts[1][13] = ""
	$accounts[1][14] = ""
	Return $accounts
Else
$rray = _MySQL_Fetch_Result_StringArray($res)
$rray[0][0] = $rows
Return $rray
EndIf
EndFunc

Func _refreshdata()
	_Checkip()
	GUICtrlSetState($filteroff, $GUI_HIDE)
	$sql = "UPDATE `users` SET `online` =  '1' WHERE name='" & $loginconst[1][1] & "'"
		$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql) 

		If $mysql_bool = $MYSQL_SUCCESS Then
		Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
		EndIf
	If WinExists("Error:") Then Send("{enter}")
		
		_GUICtrlListView_DeleteAllItems($combousr)
		_GUICtrlListView_RemoveAllGroups($combousr)
		
		
				
		$array = _Youracc($loginconst)
		$p = 0
		$rows = $array[0][0]
		$k = 0
While $p < $rows
			$p = $p + 1
			;MsgBox(16,"test i en user", $p & $array[$p][1]) 
			If $array[$p][9] = 0 Then
			$h = 0
			Else
			$h = 1
			EndIf
			If $h = 0 Then
			;	MsgBox(16,"test h en user", $h & $array[$p][1])
			If GUICtrlRead($cmbemailinf) = $array[$p][1] Then
			$k = 1
			EndIf
			
			$name = _Numbinf($array[$p][3])
			
			_GUICtrlListView_AddItem($combousr, $name, 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][13], 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][1], 2)
			;_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][2], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][4], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][6], 4)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][5], 5)
			;
			Else
			;MsgBox(16,"test h en user", $h & $array[$p][1])
			$name = _Numbinf($array[$p][3])
			_GUICtrlListView_AddItem($combousr, $name, 0)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][13], 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][1], 2)
			;_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][2], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][4], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][6], 4)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][5], 5)
			If $k = 1 Then
			GUICtrlSetState($loginie, $GUI_HIDE)
			GUICtrlSetState($loginss, $GUI_HIDE)
			EndIf
			;
			EndIf

			
		WEnd
		
				
				
			$p = 0
			;$array = _Youracc($loginconst)
			$rows = $array[0][0]
			$k = 0
			
			$a = 0
			$b = 0
			$c = 0
			$d = 0
			$e = 0
			$f = 0
			$g = 0
			$l = 0
			$m = 0
		_GUICtrlListView_EnableGroupView($combousr)
		$bullets = GUICtrlRead($radbull)
		If $bullets = $GUI_CHECKED Then
		_GUICtrlListView_InsertGroup($combousr, 1, 1, "40k+")
		_GUICtrlListView_SetGroupInfo($combousr, 1, "40k+", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 2, 2, "20k-40k")
				_GUICtrlListView_SetGroupInfo($combousr, 2, "20k-40k", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 3, 3, "10k-20k")
				_GUICtrlListView_SetGroupInfo($combousr, 3, "10k-20k", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 4, 4, "5k-10k")
				_GUICtrlListView_SetGroupInfo($combousr, 4, "5k-10k", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 5, 5, "5k-nothing")
				_GUICtrlListView_SetGroupInfo($combousr, 5, "5k-nothing", 1, $LVGS_COLLAPSIBLE)
		
		While $p < $rows
			$p = $p + 1
			;MsgBox(16,"test i en user", $p & $array[$p][1]) 
			If $array[$p][9] = 0 Then
			$h = 0
			Else
			$h = 1
			EndIf
			
			;	MsgBox(16,"test h en user", $h & $array[$p][1])
			If GUICtrlRead($cmbemailinf) = $array[$p][1] Then
			$k = 1
			EndIf
			
			;$name = _Numbinf($array[$p][3])
			
			
			Select
			Case $array[$p][6] > 40000
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 1)

			Case $array[$p][6] <= 40000 And $array[$p][6] > 20000
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 2)
			Case $array[$p][6] <= 20000 And $array[$p][6] > 10000			
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 3)
			Case $array[$p][6] <= 10000 And $array[$p][6] > 5000
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 4)
			Case $array[$p][6] <= 5000
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 5)
			EndSelect


			
		WEnd
		Else
		
		
		_GUICtrlListView_InsertGroup($combousr, 1, 1, "Godfather/Godmother")
		_GUICtrlListView_SetGroupInfo($combousr, 1, "Godfather/Godmother", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 2, 2, "Boss/Bossin")
				_GUICtrlListView_SetGroupInfo($combousr, 2, "Boss/Bossin", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 3, 3, "Local Boss/Local Bossin")
				_GUICtrlListView_SetGroupInfo($combousr, 3, "Local Boss/Local Bossin", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 4, 4, "Assassin")
				_GUICtrlListView_SetGroupInfo($combousr, 4, "Assassin", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 5, 5, "Hitman/Hitwoman")
				_GUICtrlListView_SetGroupInfo($combousr, 5, "Hitman/Hitwoman", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 6, 6, "Apprentice/Adult Lady")
				_GUICtrlListView_SetGroupInfo($combousr, 6, "Apprentice/Adult Lady", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 7, 7, "Low Life/Young Woman")
				_GUICtrlListView_SetGroupInfo($combousr, 7, "Low Life/Young Woman", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 8, 8, "Bacteria")
				_GUICtrlListView_SetGroupInfo($combousr, 8, "Bacteria", 1, $LVGS_COLLAPSIBLE)

		
		While $p < $rows
			$p = $p + 1
			;MsgBox(16,"test i en user", $p & $array[$p][1]) 
			If $array[$p][9] = 0 Then
			$h = 0
			Else
			$h = 1
			EndIf
			If GUICtrlRead($cmbemailinf) = $array[$p][1] Then
			$k = 1
			EndIf
			
			;$name = _Numbinf($array[$p][3])
			
			
			Select
			Case $array[$p][5] = "Godfather" Or $array[$p][5] = "Godmother"
				If $a = 0 Then
				
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 1)
				$a = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 1)
				EndIf
			Case $array[$p][5] = "Boss" Or $array[$p][5] = "Bossin"
				If $b = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 2)
				$b = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 2)
				EndIf
			Case $array[$p][5] = "Local Boss" Or $array[$p][5] = "Local Bossin"
				If $c = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 3)
				$c = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 3)
				EndIf
			Case $array[$p][5] = "Assassin"
				If $d = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 4)
				$d = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 4)
				EndIf
			Case $array[$p][5] = "Hitman" Or $array[$p][5] = "Hitwoman"
				If $e = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 5)
				$e = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 5)
				EndIf
			Case $array[$p][5] = "Apprentice" Or $array[$p][5] = "Adult Lady"
				If $f = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 6)
				$f = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 6)
				EndIf
			Case $array[$p][5] = "Low Life" Or $array[$p][5] = "Young Woman"
				If $g = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 7)
				$g = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 7)
				EndIf
			Case $array[$p][5] = "Bacteria"
				If $l = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 8)
				$l = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 8)
				EndIf
			EndSelect

			
		WEnd
		EndIf

			If $k = 0 Then
		GUICtrlSetState( $cmbemail, $GUI_HIDE)
		GUICtrlSetState( $cmbpass, $GUI_HIDE)
		GUICtrlSetState( $cmbrang, $GUI_HIDE)
		GUICtrlSetState( $cmbbullets, $GUI_HIDE)
		GUICtrlSetState( $cmbinlog, $GUI_HIDE)
		GUICtrlSetState( $cmbpayed, $GUI_HIDE)
		GUICtrlSetState( $cmbcrew, $GUI_HIDE)
		GUICtrlSetState( $cmbbf, $GUI_HIDE)
		GUICtrlSetState( $cmbbfinf, $GUI_HIDE)
		GUICtrlSetState( $cmbcash, $GUI_HIDE)
		GUICtrlSetState( $cmbcashinf, $GUI_HIDE)
		GUICtrlSetState( $cmbhide, $GUI_HIDE)
		GUICtrlSetState( $cmbhidin, $GUI_HIDE)
		GUICtrlSetState( $loginie, $GUI_HIDE)
		GUICtrlSetState( $loginss, $GUI_HIDE)
		GUICtrlSetState( $logincm, $GUI_HIDE)

		GUICtrlSetState( $cmbemailinf, $GUI_HIDE)
		GUICtrlSetState( $cmbpassinf, $GUI_HIDE)
		GUICtrlSetState( $cmbranginf, $GUI_HIDE)
		GUICtrlSetState( $cmbbulletsinf, $GUI_HIDE)
		GUICtrlSetState( $cmbinloginf, $GUI_HIDE)
		GUICtrlSetState( $cmbpayedinf, $GUI_HIDE)
		GUICtrlSetState( $cmbcrewinf, $GUI_HIDE)
		GUICtrlSetState( $group, $GUI_HIDE)
		EndIf
_Updatestats()
EndFunc

Func _Allacc()
Local $accounts[2][11]

$query = "SELECT * FROM `fillpass`"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf

$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
If $rows = 0 Then
	$accounts[0][0] = 1
	$accounts[1][0] = 1
	$accounts[1][1] = "Nobody"
	$accounts[1][2] = "hebt"
	$accounts[1][3] = "nog"
	$accounts[1][4] = "geen"
	$accounts[1][5] = "accounts"
	$accounts[1][6] = "in"
	$accounts[1][7] = "de"
	$accounts[1][8] = "data"
	$accounts[1][9] = "1"
	$accounts[1][10] = $arruser[1][0]
	Return $accounts
Else
$rray = _MySQL_Fetch_Result_StringArray($res)
$rray[0][0] = $rows
Return $rray
EndIf
EndFunc

Func _Updatestats()
	Dim $arraa[9], $testar
	
	
	$raantalacc = 0
	$raantalgf = 0
	$raantalboss = 0
	$raantallb = 0
	$raantalas = 0
	$raantalhi = 0
	$raantalap = 0
	$raantalbac = 0
	$raantalll = 0
	$rcash = 0
	$hoi = _Allacc()
	$i = 0
	$rows = $hoi[0][0]
	
	
	While $i < $rows
			$i = $i + 1
			$raantalacc = $raantalacc + 1
			;MsgBox(16,"test i en user", $i & $array[$i][1]) 
			$rcash = $rcash + $hoi[$i][12]
			Select
			Case $hoi[$i][5] = "Godfather" Or $hoi[$i][5] = "Godmother"
				$raantalgf = $raantalgf + 1
			Case $hoi[$i][5] = "Boss" Or $hoi[$i][5] = "Bossin"
				$raantalboss = $raantalboss + 1
			Case $hoi[$i][5] = "Local Boss" Or $hoi[$i][5] = "Local Bossin"
				$raantallb = $raantallb + 1
			Case $hoi[$i][5] = "Assassin"
				$raantalas = $raantalas + 1
			Case $hoi[$i][5] = "Hitman" Or $hoi[$i][5] = "Hitwoman"
				$raantalhi = $raantalhi + 1
			Case $hoi[$i][5] = "Apprentice" Or $hoi[$i][5] = "Adult Lady"
				$raantalap = $raantalap + 1
			Case $hoi[$i][5] = "Low Life" Or $hoi[$i][5] = "Young Woman"
				$raantalll = $raantalll + 1
			Case $hoi[$i][5] = "Bacteria"
				$raantalbac = $raantalbac + 1
			EndSelect			
		WEnd
	
	GUICtrlSetData($aantalacc, "Accounts = "&$raantalacc)
	GUICtrlSetData($aantalgf, "Godfathers = "&$raantalgf)
	GUICtrlSetData($aantalboss, "Bosses = "&$raantalboss)
	GUICtrlSetData($aantallb, "Local Bosses = "&$raantallb)
	GUICtrlSetData($aantalas, "Assassins = "&$raantalas)
	GUICtrlSetData($aantalhi, "Hitmans = "&$raantalhi)
	GUICtrlSetData($aantalap, "Apprentices = "&$raantalap)
	GUICtrlSetData($aantalll, "Low Lifes = "&$raantalll)
	GUICtrlSetData($aantalbac, "Bacterias = "&$raantalbac)
	$testar = StringSplit($rcash, "")
	$ach = ""
	$y = 1
	$a = $testar[0]
	For $y = 1 To $testar[0] Step 1
	If $a = 3 And $testar[0] <> 3 Then
	$ach &= "." & $testar[$y] 
	ElseIf $a = 6 And $testar[0] <> 6 Then
	$ach &= "." & $testar[$y] 
	ElseIf $a = 9 And $testar[0] <> 9 Then
	$ach &= "." & $testar[$y] 
	ElseIf $a = 12 And $testar[0] <> 12 Then
	$ach &= "." & $testar[$y] 
	Else
	$ach &= $testar[$y]
	EndIf
	$a = $a - 1
	Next
	GUICtrlSetData($aantalcash, "Total Cash = €"&$ach & ",-")
	GUICtrlSetData($whoson, "Now online: " & _Whoonline())
EndFunc

Func _Inttocash($numb)
			$testar = StringSplit($numb, "")
			$ach = ""
			$y = 1
			$a = $testar[0]
			For $y = 1 To $testar[0] Step 1
			If $a = 3 And $testar[0] <> 3 Then
			$ach &= "." & $testar[$y] 
			ElseIf $a = 6 And $testar[0] <> 6 Then
			$ach &= "." & $testar[$y] 
			ElseIf $a = 9 And $testar[0] <> 9 Then
			$ach &= "." & $testar[$y] 
			ElseIf $a = 12 And $testar[0] <> 12 Then
			$ach &= "." & $testar[$y] 
			Else
			$ach &= $testar[$y]
			EndIf
			$a = $a - 1
			Next
			$ach = "€" & $ach & ",-"
		return $ach
EndFunc

Func _refreshdataNODB()
	_GUICtrlListView_DeleteAllItems($combousr)
		_GUICtrlListView_RemoveAllGroups($combousr)
		
		
				
		
		$p = 0
		$rows = $array[0][0]
		$k = 0
While $p < $rows
			$p = $p + 1
			;MsgBox(16,"test i en user", $p & $array[$p][1]) 
			If $array[$p][9] = 0 Then
			$h = 0
			Else
			$h = 1
			EndIf
			If $h = 0 Then
			;	MsgBox(16,"test h en user", $h & $array[$p][1])
			If GUICtrlRead($cmbemailinf) = $array[$p][1] Then
			$k = 1
			EndIf
			
			$name = _Numbinf($array[$p][3])
			
			_GUICtrlListView_AddItem($combousr, $name, 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][13], 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][1], 2)
			;_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][2], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][4], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][6], 4)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][5], 5)
			;
			Else
			;MsgBox(16,"test h en user", $h & $array[$p][1])
			$name = _Numbinf($array[$p][3])
			_GUICtrlListView_AddItem($combousr, $name, 0)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][13], 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][1], 2)
			;_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][2], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][4], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][6], 4)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][5], 5)
			;
			If $k = 1 Then
			GUICtrlSetState($loginie, $GUI_HIDE)
			GUICtrlSetState($loginss, $GUI_HIDE)
			EndIf
			EndIf

			
		WEnd
		
				
				
			$p = 0
			;$array = _Youracc($loginconst)
			$rows = $array[0][0]
			$k = 0
			
			$a = 0
			$b = 0
			$c = 0
			$d = 0
			$e = 0
			$f = 0
			$g = 0
			$l = 0
			$m = 0
		_GUICtrlListView_EnableGroupView($combousr)
		$bullets = GUICtrlRead($radbull)
		If $bullets = $GUI_CHECKED Then
		_GUICtrlListView_InsertGroup($combousr, 1, 1, "40k+")
		_GUICtrlListView_SetGroupInfo($combousr, 1, "40k+", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 2, 2, "20k-40k")
				_GUICtrlListView_SetGroupInfo($combousr, 2, "20k-40k", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 3, 3, "10k-20k")
				_GUICtrlListView_SetGroupInfo($combousr, 3, "10k-20k", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 4, 4, "5k-10k")
				_GUICtrlListView_SetGroupInfo($combousr, 4, "5k-10k", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 5, 5, "5k-nothing")
				_GUICtrlListView_SetGroupInfo($combousr, 5, "5k-nothing", 1, $LVGS_COLLAPSIBLE)
		
		While $p < $rows
			$p = $p + 1
			;MsgBox(16,"test i en user", $p & $array[$p][1]) 
			If $array[$p][9] = 0 Then
			$h = 0
			Else
			$h = 1
			EndIf
			If GUICtrlRead($cmbemailinf) = $array[$p][1] Then
			$k = 1
			EndIf
			
			;$name = _Numbinf($array[$p][3])
			
			
			Select
			Case $array[$p][6] > 40000
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 1)

			Case $array[$p][6] <= 40000 And $array[$p][6] > 20000
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 2)
			Case $array[$p][6] <= 20000 And $array[$p][6] > 10000			
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 3)
			Case $array[$p][6] <= 10000 And $array[$p][6] > 5000
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 4)
			Case $array[$p][6] <= 5000
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 5)
			EndSelect

			
		WEnd
		Else
		
		
		_GUICtrlListView_InsertGroup($combousr, 1, 1, "Godfather/Godmother")
		_GUICtrlListView_SetGroupInfo($combousr, 1, "Godfather/Godmother", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 2, 2, "Boss/Bossin")
				_GUICtrlListView_SetGroupInfo($combousr, 2, "Boss/Bossin", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 3, 3, "Local Boss/Local Bossin")
				_GUICtrlListView_SetGroupInfo($combousr, 3, "Local Boss/Local Bossin", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 4, 4, "Assassin")
				_GUICtrlListView_SetGroupInfo($combousr, 4, "Assassin", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 5, 5, "Hitman/Hitwoman")
				_GUICtrlListView_SetGroupInfo($combousr, 5, "Hitman/Hitwoman", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 6, 6, "Apprentice/Adult Lady")
				_GUICtrlListView_SetGroupInfo($combousr, 6, "Apprentice/Adult Lady", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 7, 7, "Low Life/Young Woman")
				_GUICtrlListView_SetGroupInfo($combousr, 7, "Low Life/Young Woman", 1, $LVGS_COLLAPSIBLE)
				_GUICtrlListView_InsertGroup($combousr, 8, 8, "Bacteria")
				_GUICtrlListView_SetGroupInfo($combousr, 8, "Bacteria", 1, $LVGS_COLLAPSIBLE)
		
		While $p < $rows
			$p = $p + 1
			;MsgBox(16,"test i en user", $p & $array[$p][1]) 
			If $array[$p][9] = 0 Then
			$h = 0
			Else
			$h = 1
			EndIf
			If GUICtrlRead($cmbemailinf) = $array[$p][1] Then
			$k = 1
			EndIf
			
			;$name = _Numbinf($array[$p][3])
			
			
			Select
			Case $array[$p][5] = "Godfather" Or $array[$p][5] = "Godmother"
				If $a = 0 Then
				
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 1)
				$a = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 1)
				EndIf
			Case $array[$p][5] = "Boss" Or $array[$p][5] = "Bossin"
				If $b = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 2)
				$b = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 2)
				EndIf
			Case $array[$p][5] = "Local Boss" Or $array[$p][5] = "Local Bossin"
				If $c = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 3)
				$c = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 3)
				EndIf
			Case $array[$p][5] = "Assassin"
				If $d = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 4)
				$d = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 4)
				EndIf
			Case $array[$p][5] = "Hitman" Or $array[$p][5] = "Hitwoman"
				If $e = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 5)
				$e = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 5)
				EndIf
			Case $array[$p][5] = "Apprentice" Or $array[$p][5] = "Adult Lady"
				If $f = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 6)
				$f = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 6)
				EndIf
			Case $array[$p][5] = "Low Life" Or $array[$p][5] = "Young Woman"
				If $g = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 7)
				$g = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 7)
				EndIf
			Case $array[$p][5] = "Bacteria"
				If $l = 0 Then
				
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 8)
				$l = 1
				Else
				_GUICtrlListView_SetItemGroupID($combousr, $p - 1, 8)
				EndIf
			EndSelect
			;

			
		WEnd
		EndIf

			If $k = 0 Then
		GUICtrlSetState( $cmbemail, $GUI_HIDE)
		GUICtrlSetState( $cmbpass, $GUI_HIDE)
		GUICtrlSetState( $cmbrang, $GUI_HIDE)
		GUICtrlSetState( $cmbbullets, $GUI_HIDE)
		GUICtrlSetState( $cmbinlog, $GUI_HIDE)
		GUICtrlSetState( $cmbpayed, $GUI_HIDE)
		GUICtrlSetState( $cmbcrew, $GUI_HIDE)
		GUICtrlSetState( $cmbbf, $GUI_HIDE)
		GUICtrlSetState( $cmbbfinf, $GUI_HIDE)
		GUICtrlSetState( $cmbcash, $GUI_HIDE)
		GUICtrlSetState( $cmbcashinf, $GUI_HIDE)
		GUICtrlSetState( $cmbhide, $GUI_HIDE)
		GUICtrlSetState( $cmbhidin, $GUI_HIDE)
		GUICtrlSetState( $loginie, $GUI_HIDE)
		GUICtrlSetState( $loginss, $GUI_HIDE)
		GUICtrlSetState( $logincm, $GUI_HIDE)

		GUICtrlSetState( $cmbemailinf, $GUI_HIDE)
		GUICtrlSetState( $cmbpassinf, $GUI_HIDE)
		GUICtrlSetState( $cmbranginf, $GUI_HIDE)
		GUICtrlSetState( $cmbbulletsinf, $GUI_HIDE)
		GUICtrlSetState( $cmbinloginf, $GUI_HIDE)
		GUICtrlSetState( $cmbpayedinf, $GUI_HIDE)
		GUICtrlSetState( $cmbcrewinf, $GUI_HIDE)
		GUICtrlSetState( $group, $GUI_HIDE)
		EndIf
EndFunc

Func _NewUser($loginconst)

GUICreate("Fill in the login", 250,130, -1, -1, $WS_POPUPWINDOW)	
$ok = GUICtrlCreateButton( "OK", 10, 100)
GUICtrlSetColor(-1,0x000000)
GUICtrlCreateLabel("E-mail", 10, 10)
GUICtrlCreateLabel("Password", 10, 40)

$name = GUICtrlCreateInput( "", 100, 10, 100, -1)
GUICtrlSetColor(-1,0x000000)
$pass = GUICtrlCreateInput( "", 100, 40, 100, -1, $ES_PASSWORD)
GUICtrlSetColor(-1,0x000000)
GUISetState(@SW_SHOW)
Send("{tab}")
While 1
        $msg = GUIGetMsg()
		Select
		Case $msg = $ok
		$ntest = GUICtrlRead($name)
		$ptest = GUICtrlRead($pass)
		ExitLoop
		EndSelect
    WEnd
    GUIDelete()
$oIE = _IECreate( "http://www.mobstar.cc")
$oForm = _IEFormGetObjByName ($oIE, "login")
$o_login = _IEFormElementGetObjByName ($oForm, "email")
$o_password = _IEFormElementGetObjByName ($oForm, "password")
$username = $ntest
$password = $ptest
_IEFormElementSetValue ($o_login, $username)
_IEFormElementSetValue ($o_password, $password)
_IEFormSubmit ($oForm)
ToolTip("please fill in the code", 0,0)
WinWaitActive("Mobstar mafia game")
sleep(1000)
$oFramemain = _IEFrameGetObjByName ($oIE, "MainFrame")
$oFramemenu = _IEFrameGetObjByName ($oIE, "MenuFrame")
$test = _IEBodyReadText( $oFramemain)
If $test = "0" Then 
MsgBox(16,"Error", "maybe your internet is to slow")
ToolTip("")
Else
ToolTip("")
$strs1 = StringSplit($test,"Rank - ", 1)
$strsa = StringSplit($strs1[1], "€ ", 1)
$strsb = StringReplace($strsa[2], ",","")
$strs2 = StringSplit($strs1[2], "Weapon", 1)
$strs3 = StringSplit($strs2[2], '(',1)
$strs4 = StringSplit($strs3[2], ")",1)
$strs5 = StringSplit($strs4[2], "Crew - ",1)

$strs6 = StringSplit($strs5[2], "Bulletfactory -",1)
$strs9 = StringSplit($strs6[2], "Ship", 1)
$strs7 = StringSplit($strs6[2], "Welcome to Mobstar, ",1)
$strs8 = StringSplit($strs7[2], @CRLF,1)
$rank = $strs2[1]
$bullets = $strs4[1]
$crew = $strs6[1]
$chrname = $strs8[1]
$bf = $strs9[1]
$cash = $strsb
If $bf <> " None" Then
	$bf = 1
Else
$bf = 0
EndIf
_IENavigate( $oIE, "http://web3.mobstar.cc/mobstar/money/stockmarket.php")
$payedtest = _IEBodyReadText( $oIE)
$payebas = StringSplit($payedtest, "The Stock Market is only available for paying members.", 1)
If $payebas[0] = 1 Then
$payed = 1
Else
$payed = 0
EndIf
EndIf
;in de database test op bestaat al en update
$query = "SELECT * FROM fillpass WHERE username='" & $username & "' LIMIT 1"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf

$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
$rowwie = _MySQL_Fetch_Row_StringArray($res)
If $rows = 1 Then
	MsgBox(16,"Faal", "Gebruiker bestaat al, maar wordt eventueel geupdate.")
EndIf
If $rows = 0 Then
$sql = "INSERT INTO `fillpass` (`fillpassid`, `username`, `password`, `userid`, `inlogname`, `rank`, `bullets`, `payed`, `crew`, `bf`, `cash`) VALUES (NULL, '" & $username & "', '" & $password & "', '" & $loginconst[1][0] & "', '" & $chrname & "', '" & $rank & "', '" & $bullets & "', '" & $payed & "', '" & $crew & "', '" & $bf & "', '"&$cash&"')"
Elseif $rows = 1 Then
$sql = "UPDATE `fillpass` SET `username` = '" & $username & "', `password` = '" & $password & "', `inlogname` = '" & $chrname & "', `rank` = '" & $rank & "', `bullets` = '" & $bullets & "', `payed` = '" & $payed & "', `crew` = '" & $crew & "', `bf` = '" & $bf & "', `cash` = '"&$cash&"' WHERE `fillpass`.`fillpassid` = "& $rowwie[0]&" LIMIT 1"
EndIf
$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf
MsgBox(0,"Yeah!", "done", 5)
_IEQuit($oIE)
EndFunc

Func _Makeaccview()
	$query = "SELECT `name` FROM `users`"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf

$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
If $rows = 0 Then
	$test = "Nobody"
	Return $test
ElseIf $rows = 1 Then
$name = _MySQL_Fetch_Result_StringArray($res)
Else
$name = _MySQL_Fetch_Result_StringArray($res)
$e = 0
While $e < $rows
$e = $e + 1
If $name[$e][0] <> $loginconst[1][1] Then
GUICtrlSetData( $switchaccview, $name[$e][0] & "'s accounts")
EndIf
WEnd
EndIf
EndFunc

Func _Passupdate($loginconst)
	GUICreate("Password update", 250,130, -1, -1, $WS_POPUPWINDOW)	
GUISetBkColor($bkcolor)
GUICtrlSetDefColor( $textcolor)


$ok = GUICtrlCreateButton( "OK", 10, 100)
GUICtrlSetColor(-1,0x000000)
$cc = GUICtrlCreateButton( "Cancel", 60, 100)
GUICtrlSetColor(-1,0x000000)
GUICtrlCreateLabel("Old password", 10, 10)
GUICtrlCreateLabel("New password", 10, 40)

$name = GUICtrlCreateInput( "", 100, 10, 100, -1, $ES_PASSWORD)
GUICtrlSetColor(-1,0x000000)
$pass = GUICtrlCreateInput( "", 100, 40, 100, -1, $ES_PASSWORD)
GUICtrlSetColor(-1,0x000000)
GUISetState(@SW_SHOW)
Send("{tab}")
While 1
        $msg = GUIGetMsg()
		Select
		Case $msg = $cc
			ExitLoop
		Case $msg = $ok
		$ntest = GUICtrlRead($name)
		$ptest = GUICtrlRead($pass)
		
		$arruser = _Inlogcheck($loginconst[1][1], $ntest)
		If $arruser = 0 Then
		MsgBox(16,"Error", "Old password isn't good")
		Else
		If $ptest = "" Then
			MsgBox(16,"Error", "New password is empty")
		Else
		_Crypt_Startup()
		$passcheck = _Crypt_HashData($ptest,$CALG_MD5)
		_Crypt_Shutdown()
		$query = "UPDATE `users` SET `pass` = '" & $passcheck & "' WHERE `users`.`userid` = '" & $loginconst[1][0] & "' LIMIT 1"
		$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)
		If $mysql_bool = $MYSQL_SUCCESS Then
		Else
		$errno = _MySQL_errno($MysqlConn)
		MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
		EndIf
		EndIf
		IniWrite( @scriptdir & "\mobdata.ini", "all", "pass", $ptest)
		MsgBox(0,"Done", ":)")
		ExitLoop
		EndIf
		EndSelect
    WEnd
    GUIDelete()
EndFunc

Func _Settings()
	GUICreate("Settings", 370,260, -1, -1, $WS_POPUPWINDOW)	
GUISetBkColor($bkcolor)
GUICtrlSetDefColor( $textcolor)


$ok = GUICtrlCreateButton( "OK", 10, 230)
GUICtrlSetColor(-1,0x000000)
$cc = GUICtrlCreateButton( "Cancel", 60, 230)
GUICtrlSetColor(-1,0x000000)
GUICtrlCreateLabel("Auto-refresh(seconds)", 10, 10)
$chkbox = GUICtrlCreateCheckbox(" ", 10, 40)
GUICtrlCreateLabel("Always update the account you log in", 35, 44)
GUICtrlCreateLabel("Select your color:", 30, 70)
$white = GUICtrlCreateButton("white", 10, 100)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$green = GUICtrlCreateButton("green", 70, 100)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0x00FF00)
$yellow = GUICtrlCreateButton("yellow", 130, 100)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFFF00)
$red = GUICtrlCreateButton("red", 190, 100)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFF0000)
$pink = GUICtrlCreateButton("pink", 250, 100)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFF9999)
$orange = GUICtrlCreateButton("orange", 310, 100)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFF9900)
$lgreen = GUICtrlCreateButton("lightgreen", 70, 130)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xccFFcc)
$lyellow = GUICtrlCreateButton("lightyellow", 130, 130)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFFFcc)
$lred = GUICtrlCreateButton("lightred", 190, 130)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFcccc)
$lpink = GUICtrlCreateButton("lightpink", 250, 130)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFeeee)
$lorange = GUICtrlCreateButton("lightorange", 310, 130)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFee99)
$default = GUICtrlCreateButton("default", 10, 130)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
$changess = GUICtrlCreateButton("Change SS-location", 10, 160)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$changecm = GUICtrlCreateButton("Change CM-location", 10, 190)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$ssdir = IniRead( @scriptdir & "\mobdata.ini", "all", "shizzlescript", "")
$cmdir = IniRead( @scriptdir & "\mobdata.ini", "all", "cmscript", "")
$ssinp = GUICtrlCreateInput($ssdir, 140, 160, 200,20)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$cminp = GUICtrlCreateInput($cmdir, 140, 190, 200,20)
GUICtrlSetColor(-1,0x000000)
GUICtrlSetBkColor(-1, 0xFFFFFF)

$inchkb = IniRead( @scriptdir & "\mobdata.ini", "all", "alwaysup", 0)
If $inchkb = 1 Then GUICtrlSetState($chkbox, $GUI_CHECKED)
$autoupdate = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000) /1000
If $autoupdate > 30 Or $autoupdate < 15 Then
MsgBox(16,"Dumbass!", "Don't mess with mobdata.ini, I ain't stupid.", 3)
IniWrite(@scriptdir & "\mobdata.ini", "all", "update", 30000)
$autoupdate = 30
EndIf
$update = GUICtrlCreateSlider (120,10,200,-1)
GUICtrlSetLimit( -1, 30, 15)
GUICtrlSetData($update, $autoupdate)

$autxt = GUICtrlCreateInput($autoupdate, 330, 10, 30, 20, $ES_READONLY)
GUICtrlSetColor($autxt,0x000000)

;$pass = GUICtrlCreateInput( "", 100, 40, 100, -1, $ES_PASSWORD)
GUICtrlSetColor(-1,0x000000)
GUISetState(@SW_SHOW)
Send("{tab}")
While 1
        $msg = GUIGetMsg()
		Select
		Case $msg = $cc
			$updatechk = "cancel"
			ExitLoop
		Case $msg = $ok
		$updatechk = GUICtrlRead($update) * 1000
		$chkj = GUICtrlRead($chkbox)
		IniWrite( @scriptdir & "\mobdata.ini", "all", "update", $updatechk)
		If $chkj = $GUI_CHECKED Then
		IniWrite( @scriptdir & "\mobdata.ini", "all", "alwaysup", 1)
		Else
		IniWrite( @scriptdir & "\mobdata.ini", "all", "alwaysup", 0)
		EndIf
		MsgBox(0,"Done", ":)")
		ExitLoop
		
		Case $msg = $update
		$bl = GUICtrlRead($update)
		GUICtrlSetData( $autxt, $bl) 
	
		Case $msg = $white
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "FFFFFF")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xFFFFFF"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $green
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "00FF00")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0x00FF00"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $default
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "000000")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "FFFFFF")
		$bkcolor = "0x242424"
		$textcolor = "0xFFFFFF"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $yellow
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "FFFF00")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xFFFF00"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $red
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "FF0000")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xFF0000"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $pink
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "FF9999")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xFF9999"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $orange
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "FF9900")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xFF9900"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $lgreen
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "ccFFcc")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xccFFcc"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $lyellow 
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "FFFFcc")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xFFFFcc"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $lred
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "FFcccc")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xFFcccc"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $lpink
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "FFeeee")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xFFeeee"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $lorange
		IniWrite( @scriptdir & "\mobdata.ini", "all", "bgcolor", "FFeecc")
		IniWrite( @scriptdir & "\mobdata.ini", "all", "textcolor", "000000")
		$bkcolor = "0xFFeecc"
		$textcolor = "0x000000"
		$updatechk = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
		ExitLoop
		Case $msg = $changecm
		$var = FileOpenDialog("Change Crazy-mans location", @mydocumentsdir, "Crazy Man(CrazyMan.exe)")
		If @error Then
		MsgBox(4096,"","No File chosen")
		Else
		$var = StringReplace($var, "|", @CRLF)
		IniWrite( @scriptdir & "\mobdata.ini", "all", "cmscript", $var)
		EndIf

		Case $msg = $changess
		$var = FileOpenDialog("Change Crazy-mans location", @mydocumentsdir, "Crazy Man(CrazyMan.exe)")
		If @error Then
		MsgBox(4096,"","No File chosen")
		Else
		$var = StringReplace($var, "|", @CRLF)
		IniWrite( @scriptdir & "\mobdata.ini", "all", "cmscript", $var)
		EndIf
		EndSelect
	WEnd
    GUIDelete()
	Return $updatechk
EndFunc

Func _Allips()
	$query = "SELECT * FROM `iptable`"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf
$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
If $rows = 0 Then
	$arr = "No ip's?"
Else
$arr = _MySQL_Fetch_Result_StringArray($res)
$arr[0][1] = $rows
EndIf
Return $arr
EndFunc

Func _Manageips()
	$guimips = GUICreate("Manage Ip's", 400,300, -1, -1, -1, -1, $modata)
	GUISetBkColor($bkcolor)
	GUICtrlSetDefColor($textcolor)
	$lola = _Allips()
	If $lola = "No ip's?" Then
		MsgBox(16,"Fail", "No ip's found")
	Else
	
	$comboips = GUICtrlCreateListView("", 190, 10, 204, 280,-1,$LVS_EX_FULLROWSELECT + $LVS_EX_DOUBLEBUFFER)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, $textcolor)
_GUICtrlListView_InsertColumn($comboips, 0, "Ip", 80)
_GUICtrlListView_InsertColumn($comboips, 1, "Comments", 118)
$i = 0
While $i < $lola[0][1]
	$i = $i + 1
	GUICtrlCreateListViewItem($lola[$i][1] & "|" & $lola[$i][2], $comboips)
	;_GUICtrlListView_AddSubItem($comboips, $i-1,$lola[$i][2], 1)

WEnd
	$new = GUICtrlCreateButton("New ip", 10, 10)
	GUICtrlSetColor(-1, 0x000000)
	$edit = GUICtrlCreateButton("Edit selected", 10, 40)
	GUICtrlSetColor(-1, 0x000000)
	$delete = GUICtrlCreateButton("Delete selected", 10, 70)
	GUICtrlSetColor(-1, 0x000000)
	$lblip = GUICtrlCreateLabel("Ip:", 20, 150)
	GUICtrlSetState($lblip, $GUI_HIDE)
	$lblcomments = GUICtrlCreateLabel("Comments:", 20,180)
	GUICtrlSetState($lblcomments, $GUI_HIDE)
	$editip = GUICtrlCreateInput("", 80, 150, 100, 20)
	GUICtrlSetState($editip, $GUI_HIDE)
	$editcom = GUICtrlCreateInput("", 80, 180, 100, 20)
	GUICtrlSetState($editcom, $GUI_HIDE)
	$save = GUICtrlCreateButton("Save", 20, 210)
	GUICtrlSetState($save, $GUI_HIDE)
	$add = GUICtrlCreateButton("Add", 20, 210)
	GUICtrlSetState($add, $GUI_HIDE)
	$groupp = GUICtrlCreateGroup( "Ip-Info", 10, 130, 180, 150)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($groupp), "wstr", "", "wstr", "")
	GUICtrlSetColor( -1, $textcolor)
	GUICtrlSetState($groupp, $GUI_HIDE)
	GUISetState(@SW_SHOW)
	EndIf
	While 1
	;	If WinActive("Mobdatacenter - Account management") Then
	;		WinActivate("Manage Ip's")
	;		WinFlash ("Manage Ip's")
	;	EndIf
		$msg = GUIGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $lola = "No ip's?"
			ExitLoop
		Case $msg = $new
			;nieuwe maken
			GUICtrlSetState($lblip, $GUI_SHOW)
			GUICtrlSetState($lblcomments, $GUI_SHOW)
			GUICtrlSetState($editip, $GUI_SHOW)
			GUICtrlSetState($editcom, $GUI_SHOW)
			GUICtrlSetState($save, $GUI_HIDE)
			GUICtrlSetState($add, $GUI_SHOW)
			GUICtrlSetState($groupp, $GUI_SHOW)
			GUICtrlSetData($editip, "")
			GUICtrlSetData($editcom, "")
		Case $msg = $edit
			$test = GUICtrlRead(GUICtrlRead($comboips))
			If StringSplit($test,"|", 1) = @error Then
				$test = 1
			EndIf
			If $test = 1 Then
			MsgBox(16,"Fail", "You didn't select an IP")
			Else
			
			$ipsshit = StringSplit($test,"|", 1) 
			GUICtrlSetState($lblip, $GUI_SHOW)
			GUICtrlSetState($lblcomments, $GUI_SHOW)
			GUICtrlSetState($editip, $GUI_SHOW)
			GUICtrlSetState($editcom, $GUI_SHOW)
			GUICtrlSetState($save, $GUI_SHOW)
			GUICtrlSetState($add, $GUI_HIDE)
			GUICtrlSetState($groupp, $GUI_SHOW)
			GUICtrlSetData($editip, $ipsshit[1])
			GUICtrlSetData($editcom, $ipsshit[2])
			EndIf
		Case $msg = $delete
			$test = GUICtrlRead(GUICtrlRead($comboips))
			If StringSplit($test,"|", 1) = @error Then
				$test = 1
			EndIf
			If $test = 1 Then
			MsgBox(16,"Fail", "You didn't select an IP")
			Else
			$ipsshit = StringSplit($test,"|", 1) 
			$ques = MsgBox(36, "Confirm", "Do you really want to delete ip: '" & $ipsshit[1] & "' with comments: '" & $ipsshit[2] & "'.") 
			If $ques = 6 Then
			;delete
			$sql = "DELETE FROM `mobdata`.`iptable` WHERE `iptable`.`ip` = '" & $ipsshit[1] & "'"
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql) 

			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
			EndIf
			ElseIf $ques = 7 Then
			EndIf
			_GUICtrlListView_DeleteAllItems($comboips)
			$lola = _Allips()
			$i = 0
			While $i < $lola[0][1]
			$i = $i + 1
			GUICtrlCreateListViewItem($lola[$i][1] & "|" & $lola[$i][2], $comboips)

			WEnd
			EndIf
		Case $msg = $save
			$newip = GUICtrlRead($editip)
			$newcomments = GUICtrlRead($editcom)
			If $newip = "" Or $newcomments = "" Then
			MsgBox(16, "Fail", "You didn't fill in all of the fields.")
			Else
			$sql = "UPDATE `mobdata`.`iptable` SET `ip` = '" & $newip &"', `comments` = '"&$newcomments&"' WHERE `iptable`.`ip` = '" & $ipsshit[1] & "'"
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql) 

			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
			EndIf
			GUICtrlSetState($lblip, $GUI_HIDE)
			GUICtrlSetState($lblcomments, $GUI_HIDE)
			GUICtrlSetState($editip, $GUI_HIDE)
			GUICtrlSetState($editcom, $GUI_HIDE)
			GUICtrlSetState($save, $GUI_HIDE)
			GUICtrlSetState($groupp, $GUI_HIDE)
			_GUICtrlListView_DeleteAllItems($comboips)
			$lola = _Allips()
			$i = 0
			While $i < $lola[0][1]
			$i = $i + 1
			GUICtrlCreateListViewItem($lola[$i][1] & "|" & $lola[$i][2], $comboips)

			WEnd
			EndIf
		Case $msg = $add
			$newip = GUICtrlRead($editip)
			$newcomments = GUICtrlRead($editcom)
			If $newip = "" Or $newcomments = "" Then
			MsgBox(16, "Fail", "You didn't fill in all of the fields.")
			Else
			$sql = "INSERT INTO `mobdata`.`iptable` (`ipid` ,`ip` ,`comments`)VALUES (NULL , '"& $newip &"', '"&$newcomments&"')"
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql) 

			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
			EndIf
			GUICtrlSetState($lblip, $GUI_HIDE)
			GUICtrlSetState($lblcomments, $GUI_HIDE)
			GUICtrlSetState($editip, $GUI_HIDE)
			GUICtrlSetState($editcom, $GUI_HIDE)
			GUICtrlSetState($add, $GUI_HIDE)
			GUICtrlSetState($save, $GUI_HIDE)
			GUICtrlSetState($groupp, $GUI_HIDE)
			_GUICtrlListView_DeleteAllItems($comboips)
			$lola = _Allips()
			$i = 0
			While $i < $lola[0][1]
			$i = $i + 1
			GUICtrlCreateListViewItem($lola[$i][1] & "|" & $lola[$i][2], $comboips)

			WEnd
			EndIf
		EndSelect
	WEnd
	GUIDelete($guimips)
EndFunc

$loginconst = _Login()

		$sql = "UPDATE `users` SET `online` =  '1' WHERE name='" & $loginconst[1][1] & "'"
		$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql) 

		If $mysql_bool = $MYSQL_SUCCESS Then
		Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
		EndIf

If IniRead( @scriptdir & "\mobdata.ini", "all", "firstrun", 0) = 0 Then
_Firstrun()
IniWrite( @scriptdir & "\mobdata.ini", "all", "firstrun", 1)
EndIf
$ssdir = IniRead( @scriptdir & "\mobdata.ini", "all", "shizzlescript", "")

Func _Gforum()
	$guigforum = GUICreate("General Forum", 800,600, -1,-1,-1,-1, $modata)
	FileInstall("C:\xampp\htdocs\mobdata\Edits\ftp\style.css", @ScriptDir & "\style.css")
	$oIE = ObjCreate("Shell.Explorer.1")
	$messages = GUICtrlCreateObj($oIE, 0,0, 800, 600)
	$oIE.navigate("http://localhost/mobdata/edits/index.php?pw=" & $loginconst[1][2] & "&nm=" & $loginconst[1][1]& "&user=" & $loginconst[1][3]& "&userid=" & $loginconst[1][0] &"&topic=2")
	GUISetState(@SW_SHOW, $guigforum)
	While 1
		$msg = GUIGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		EndSelect
	WEnd
	GUIDelete($guigforum)
EndFunc

Func _Alllogs()
	$query = "SELECT * FROM `logs` ORDER BY `datum` DESC"
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf
$res = _MySQL_Store_Result($MysqlConn)
$rows = _MySQL_Num_Rows($res)
If $rows = 0 Then
	$arr = "No logs?"
Else
$arr = _MySQL_Fetch_Result_StringArray($res)
$arr[0][1] = $rows
EndIf
Return $arr
EndFunc

Func _Ulogs()
	$ulogs = GUICreate("User Logs", 800,600, -1,-1,-1,-1, $modata)
	$lola = _Alllogs()
	If $lola = "No logs?" Then
		MsgBox(16,"Fail", "No logs found")
	Else
	
	$logss = GUICtrlCreateList("", 10, 10, 780, 580, $LBS_NOSEL + $WS_VSCROLL)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, $textcolor)
	$i = 0
	While $i < $lola[0][1]
	$i = $i + 1
	If $lola[$i][4] = 0 Then
	GUICtrlSetData($logss, _Numbinf($lola[$i][2]) & " logged in on " & $lola[$i][3] & ", @IP " & $lola[$i][1])
	ElseIf $lola[$i][4] = 1 Then
	GUICtrlSetData($logss, _Numbinf($lola[$i][2]) & " logged out on " & $lola[$i][3] & ", @IP " & $lola[$i][1])
	EndIf
	;_GUICtrlListView_AddSubItem($comboips, $i-1,$lola[$i][2], 1)
	WEnd
	EndIf
	GUISetState(@SW_SHOW, $ulogs)
	 While 1
        $msg = GUIGetMsg()

        If $msg = $GUI_EVENT_CLOSE Then ExitLoop
    WEnd
    GUIDelete($ulogs)

EndFunc

Func _Manusers()
	If $loginconst[1][3] = "4" Then
	$query = "SELECT * FROM users WHERE `userlevel` BETWEEN 0 AND 4"
	Else
	$query = "SELECT * FROM users WHERE `userlevel` BETWEEN 0 AND 2"
	EndIf
$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

If $mysql_bool = $MYSQL_SUCCESS Then
Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
EndIf
$res = _MySQL_Store_Result($MysqlConn)
$userss = _MySQL_Fetch_Result_StringArray($res)
$rows = _MySQL_Num_Rows($res)
$userss[0][0] = $rows

$manu = GUICreate("Manage Users", 800, 600)
GUISetBkColor($bkcolor, $manu)
GUICtrlSetDefColor($textcolor, $manu)
$usrgroupp = GUICtrlCreateGroup("User information", 10, 10, 200, 90)
GUICtrlSetState(-1, $GUI_HIDE)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($usrgroupp), "wstr", "", "wstr", "")
$usrname = GUICtrlCreateLabel("Name:", 20, 30)
GUICtrlSetState(-1, $GUI_HIDE)
$usruserlevel = GUICtrlCreateLabel("Userlevel:", 20, 60)
GUICtrlSetState(-1, $GUI_HIDE)
$usrnameinf = GUICtrlCreateInput("", 100, 30, 100, 20)
GUICtrlSetColor( -1, 0x000000)
GUICtrlSetState(-1, $GUI_HIDE)
_GUICtrlEdit_SetReadOnly($usrnameinf, True)
$usruserlevelinf = GUICtrlCreateCombo("member", 100, 60, 100, 20)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetColor( -1, 0x000000)
If $loginconst[1][3] = "4" Then
GUICtrlSetData(-1, "member+|moderator|admin|admin+")
Else
GUICtrlSetData(-1, "member+|moderator")
EndIf
$savebut = GUICtrlCreateButton("Save", 10, 110)
GUICtrlSetColor( -1, 0x000000)
GUICtrlSetState(-1, $GUI_HIDE)
$passbut = GUICtrlCreateButton("Reset Password", 60, 110)
GUICtrlSetColor( -1, 0x000000)
GUICtrlSetState(-1, $GUI_HIDE)
$delbut = GUICtrlCreateButton("Delete user", 10, 140)
GUICtrlSetColor( -1, 0x000000)
GUICtrlSetState(-1, $GUI_HIDE)
$newbut = GUICtrlCreateButton("New user", 10, 560)
GUICtrlSetColor( -1, 0x000000)
$combojan = _GUICtrlListView_Create($manu,"", 280, 10, 500, 580)
_GUICtrlListView_SetExtendedListViewStyle($combojan, $LVS_EX_FULLROWSELECT + $LVS_EX_DOUBLEBUFFER)
_GUICtrlListView_SetView($combojan, 0)
_GUICtrlListView_SetBkColor($combojan, $bkreversecolor)
_GUICtrlListView_SetTextBkColor($combojan, $bkreversecolor)
_GUICtrlListView_SetTextColor($combojan, $textreversecolor)
_GUICtrlListView_InsertColumn($combojan, 0, "Name", 80)
_GUICtrlListView_InsertColumn($combojan, 1, "Userlevel", 200)
$p = 0
$r = 1
While $p < $rows
	$p = $p + 1
	If $userss[$p][1] = $loginconst[1][1] Then
	$r = 0
	Else
	_GUICtrlListView_AddItem($combojan, $userss[$p][1], 1)
	If $userss[$p][3] = 0 Then
	$userlef = "member"
	ElseIf $userss[$p][3] = 1 Then
	$userlef = "member+"
	ElseIf $userss[$p][3] = 2 Then
	$userlef = "moderator"
	ElseIf $userss[$p][3] = 3 Then
	$userlef = "admin"
	ElseIf $userss[$p][3] = 4 Then
	$userlef = "admin+"
EndIf
	_GUICtrlListView_AddSubItem($combojan, $p + $r - 2,$userlef, 1)
	EndIf
WEnd
GUISetState(@SW_SHOW, $manu)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFYUSERS")
$s = False
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop	
		Case $msg = $newbut
			$s = True
			_GUICtrlEdit_SetReadOnly($usrnameinf, False)
			GUICtrlSetState( $usrnameinf, $GUI_SHOW)
			GUICtrlSetState( $usrnameinf, $GUI_FOCUS)
			GUICtrlSetData( $usrnameinf, "")
			GUICtrlSetData( $usruserlevelinf, "member")
			GUICtrlSetState( $usruserlevelinf, $GUI_SHOW)
			GUICtrlSetState( $usruserlevel, $GUI_SHOW)
			GUICtrlSetState( $usrname, $GUI_SHOW)
			GUICtrlSetState( $usrgroupp, $GUI_SHOW)
			GUICtrlSetState( $savebut, $GUI_SHOW)
			GUICtrlSetState( $passbut, $GUI_HIDE)
			GUICtrlSetState( $delbut, $GUI_HIDE)
		Case $msg = $savebut
			$userlefa = GUICtrlRead($usruserlevelinf)
			If $userlefa <> "" Then
			If $userlefa = "member" Then
			$ursu = 0
			ElseIf $userlefa = "member+" Then
			$ursu = 1
			ElseIf $userlefa = "moderator" Then
			$ursu = 2
			ElseIf $userlefa = "admin" Then
			$ursu = 3
			ElseIf $userlefa = "admin+" Then
			$ursu = 4
			EndIf
			If $s = False Then
			$query = "UPDATE `mobdata`.`users` SET `userlevel` =  '"&$ursu&"' WHERE `users`.`name` ='" & GUICtrlRead($usrnameinf) & "'"
			ElseIf $s = True Then
			$query = "INSERT INTO `users` (`userid`, `name`, `pass`, `userlevel`, `online`, `db`, `offline`) VALUES('NULL', '" & GUICtrlRead($usrnameinf) & "', '0x288116504F5E303E4BE4FF1765B81F5D', '"&$ursu&"', 0, 0, 0)"
			$s = False
			_GUICtrlEdit_SetReadOnly($usrnameinf, True)
			EndIf
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
			EndIf
			_GUICtrlListView_DeleteAllItems($combojan)
			$query = "SELECT * FROM users"
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
			EndIf
			$res = _MySQL_Store_Result($MysqlConn)
			$userss = _MySQL_Fetch_Result_StringArray($res)
			$rows = _MySQL_Num_Rows($res)
			$userss[0][0] = $rows
			$p = 0
			While $p < $rows
			$p = $p + 1
			_GUICtrlListView_AddItem($combojan, $userss[$p][1], 1)
			If $userss[$p][3] = 0 Then
			$userlef = "member"
			ElseIf $userss[$p][3] = 1 Then
			$userlef = "member+"
			ElseIf $userss[$p][3] = 2 Then
			$userlef = "moderator"
			ElseIf $userss[$p][3] = 3 Then
			$userlef = "admin"
			ElseIf $userss[$p][3] = 4 Then
			$userlef = "admin+"
			EndIf
			_GUICtrlListView_AddSubItem($combojan, $p - 1,$userlef, 1)
			WEnd
			GUICtrlSetState( $usrnameinf, $GUI_HIDE)
			GUICtrlSetState( $usruserlevelinf, $GUI_HIDE)
			GUICtrlSetState( $usruserlevel, $GUI_HIDE)
			GUICtrlSetState( $usrname, $GUI_HIDE)
			GUICtrlSetState( $usrgroupp, $GUI_HIDE)
			GUICtrlSetState( $savebut, $GUI_HIDE)
			GUICtrlSetState( $passbut, $GUI_HIDE)
			GUICtrlSetState( $delbut, $GUI_HIDE)
			Else
			MsgBox(16, "Fail", "You didn't type a name:O")
			EndIf
		Case $msg = $passbut
			$box = MsgBox(36,"Reset...", "Do you really want to reset " & GUICtrlRead($usrnameinf) & ' to "Welkom01"?')
			If $box = 6 Then
			$query = "UPDATE `mobdata`.`users` SET `pass` =  '0x288116504F5E303E4BE4FF1765B81F5D' WHERE `users`.`name` ='" & GUICtrlRead($usrnameinf) & "'"
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
				EndIf
			Else
			EndIf
		Case $msg = $delbut
			$box = MsgBox(36,"Delete...", "Do you really want to Delete " & GUICtrlRead($usrnameinf) & '?')
			If $box = 6 Then
			$query = "DELETE FROM `mobdata`.`users` WHERE `users`.`name` ='" & GUICtrlRead($usrnameinf) & "'"
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
				EndIf
			Else
			EndIf
			_GUICtrlListView_DeleteAllItems($combojan)
			$query = "SELECT * FROM users"
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
			EndIf
			$res = _MySQL_Store_Result($MysqlConn)
			$userss = _MySQL_Fetch_Result_StringArray($res)
			$rows = _MySQL_Num_Rows($res)
			$userss[0][0] = $rows
			$p = 0
			While $p < $rows
			$p = $p + 1
			_GUICtrlListView_AddItem($combojan, $userss[$p][1], 1)
			If $userss[$p][3] = 0 Then
			$userlef = "member"
			ElseIf $userss[$p][3] = 1 Then
			$userlef = "member+"
			ElseIf $userss[$p][3] = 2 Then
			$userlef = "moderator"
			ElseIf $userss[$p][3] = 3 Then
			$userlef = "admin"
			EndIf
			_GUICtrlListView_AddSubItem($combojan, $p - 1,$userlef, 1)
			WEnd
			GUICtrlSetState( $usrnameinf, $GUI_HIDE)
			GUICtrlSetState( $usruserlevelinf, $GUI_HIDE)
			GUICtrlSetState( $usruserlevel, $GUI_HIDE)
			GUICtrlSetState( $usrname, $GUI_HIDE)
			GUICtrlSetState( $usrgroupp, $GUI_HIDE)
			GUICtrlSetState( $savebut, $GUI_HIDE)
			GUICtrlSetState( $passbut, $GUI_HIDE)
			GUICtrlSetState( $delbut, $GUI_HIDE)
	EndSelect
WEnd
GUIDelete($manu)
GUISetState(@SW_SHOW, $modata)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
EndFunc

Func _MobdataYourAcc()

$modata = GUICreate("Mobdatacenter - Account management", @DesktopWidth -20,@DesktopHeight - 70,10, 4)

_Defineinfnumbshit()
GUISetBkColor($bkcolor, $modata)
GUICtrlSetDefColor( $textcolor)



GUICtrlCreateLabel("You're logged in as " & $loginconst[1][1],10, 10)
$gro = GUICtrlCreateGroup( "", 300, 0, 200, 38)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($gro), "wstr", "", "wstr", "")
GUICtrlSetColor( -1, $textcolor)
$radrank = GUICtrlCreateRadio(" ", 310, 11)
GUICtrlCreateLabel("Rank", 330,15)

GUICtrlSetState($radrank, $GUI_CHECKED)
$radbull = GUICtrlCreateRadio(" ", 390, 11)
GUICtrlCreateLabel("Bullets", 410,15)

$switchaccview = GUICtrlCreateCombo("", 10, 40, 130)
;GUICtrlSetData( $switchaccview, "extra")
$combousr = _GUICtrlListView_Create($modata,"", 300, 40, @DesktopWidth - 330, @DesktopHeight - 180)
_GUICtrlListView_SetExtendedListViewStyle($combousr, $LVS_EX_FULLROWSELECT + $LVS_EX_DOUBLEBUFFER + $LVS_EX_SUBITEMIMAGES)
$hImage = _GUIImageList_Create()
_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($combousr, 0xFF0000, 16, 16))
    _GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($combousr, 0x00FF00, 16, 16))
    _GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($combousr, 0x0000FF, 16, 16))
    _GUICtrlListView_SetImageList($combousr, $hImage, 1)

_GUICtrlListView_SetView($combousr, 0)
_GUICtrlListView_SetBkColor($combousr, $bkreversecolor)
_GUICtrlListView_SetTextBkColor($combousr, $bkreversecolor)
_GUICtrlListView_SetTextColor($combousr, $textreversecolor)
_GUICtrlListView_InsertColumn($combousr, 0, "Owner", 80)
_GUICtrlListView_InsertColumn($combousr, 1, "Purpose", 200)
_GUICtrlListView_InsertColumn($combousr, 2, "Email", 100)
;_GUICtrlListView_InsertColumn($combousr, 3, "Password", 100)
_GUICtrlListView_InsertColumn($combousr, 3, "Name", 100)
_GUICtrlListView_InsertColumn($combousr, 4, "Bullets", 50)
_GUICtrlListView_InsertColumn($combousr, 5, "Rank", 90)

;GUICtrlSetColor($combousr, 0x000000)

$array = _YourAcc($loginconst)
If $array = "You don't have any accounts yet" Then
$cmbodata = $array
Else

GUICtrlSetData( $switchaccview, "Your accounts|All accounts", "Your accounts")
GUICtrlSetColor(-1, 0x000000)
$aantalacc = GUICtrlCreateLabel("", 20, 500, 100, 20)
$aantalgf = GUICtrlCreateLabel("", 20, 520, 100, 20)
$aantalboss = GUICtrlCreateLabel("", 20, 540, 100, 20)
$aantallb = GUICtrlCreateLabel("", 20, 560, 100, 20)
$aantalas = GUICtrlCreateLabel("", 20, 580, 100, 20)
$aantalhi = GUICtrlCreateLabel("", 140, 500, 100, 20)
$aantalap = GUICtrlCreateLabel("", 140, 520, 100, 20)
$aantalll = GUICtrlCreateLabel("", 140, 540, 100, 20)
$aantalbac = GUICtrlCreateLabel("", 140, 560, 100, 20)
$aantalcash = GUICtrlCreateLabel("", 20, 580, 200, 20)
_Makeaccview()
_refreshdata()
$group = GUICtrlCreateGroup("Info selected account", 10,100,290,320)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($group), "wstr", "", "wstr", "")
GUICtrlSetColor( -1, $textcolor)
$cmbemail = GUICtrlCreateLabel( "E-mail:", 20, 120)
$cmbpass = GUICtrlCreateLabel( "Password:", 20, 140)
$cmbinlog = GUICtrlCreateLabel( "Loginname:", 20, 160)
$cmbrang = GUICtrlCreateLabel( "Rang:", 20, 180)
$cmbbullets = GUICtrlCreateLabel( "Bullets:", 20, 200)
$cmbpayed = GUICtrlCreateLabel( "Payed:", 20, 220)
$cmbcrew = GUICtrlCreateLabel( "Crew:", 20, 240)
$cmbbf = GUICtrlCreateLabel("Bulletfactory:", 20, 260)
$cmbcash = GUICtrlCreateLabel("Cash:", 20, 280)
$cmbhide = GUICtrlCreateCheckbox( " ", 20, 300)
$cmbhidin = GUICtrlCreateLabel( "Hide", 45, 304, 200,20)


$cmbemailinf = GUICtrlCreateLabel( $array[1][1], 100, 120, 180, 20)
$cmbpassinf = GUICtrlCreateLabel( $array[1][2], 100, 140, 180, 20)
$cmbinloginf = GUICtrlCreateLabel( $array[1][4], 100, 160, 180, 20)
$cmbranginf = GUICtrlCreateLabel( $array[1][5], 100, 180, 180, 20)
$cmbbulletsinf = GUICtrlCreateLabel( $array[1][6], 100, 200, 180, 20)
If $array[1][11] = 1 Then
$cmbbfinf = GUICtrlCreateLabel( "yes", 100, 260, 180, 20)
Else
$cmbbfinf = GUICtrlCreateLabel( "no", 100, 260, 180, 20)
EndIf
$cmbcashinf = GUICtrlCreateLabel(_Inttocash($array[1][12]),100,280,180,20)

If $array[1][7] = 0 Then
$cmbpayedinf = GUICtrlCreateLabel( "no", 100, 220, 180, 20)
ElseIf $array[1][7] = 1 Then
$cmbpayedinf = GUICtrlCreateLabel( "yes", 100, 220, 180, 20)
EndIf
If $array[1][9] = 0 Then
			GUICtrlSetState($cmbhide, $GUI_UNCHECKED)
			ElseIf $array[1][9] = 1 Then
			GUICtrlSetState($cmbhide, $GUI_CHECKED)
			EndIf

EndIf
$cmbcrewinf = GUICtrlCreateLabel( $array[1][8], 100, 240, 180, 20)

GUICtrlCreateEdit("", 506,6,140, 28, $ES_READONLY)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, $GUI_DISABLE)
$searchacc = GUICtrlCreateInput( "", 510, 10, 100,20)
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$searchbut = GUICtrlCreatePic( @scriptdir & "\search.bmp", 620, 10, 16, 16, $SS_NOTIFY)

$filteroff = GUICtrlCreateButton("Filter off", 660, 10)
;guictrlset
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState($filteroff, $GUI_HIDE)

$staa = GUICtrlCreateGroup("Statistics", 10, 480, 250, 150)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($staa), "wstr", "", "wstr", "")
GUICtrlSetColor( -1, $textcolor)

;GUICtrlCreateGroup("", 510, 0, 300, 38)
;local $aParts[3] = [100, 175, -1]


;$whoson = GUICtrlCreateLabel("Now online: " & _Whoonline(), 520,14, 287,20)
$loginie = GUICtrlCreateButton("Login @IE", 20, 325)
GUICtrlSetColor(-1, 0x000000)
$loginss = GUICtrlCreateButton("Login @Shizzlescript", 20, 355)
GUICtrlSetColor(-1, 0x000000)
$logincm = GUICtrlCreateButton("Login @Crazyman", 20, 385)
GUICtrlSetColor(-1, 0x000000)

$newusr = GUICtrlCreateButton( "New account", 10, 70 )
GUICtrlSetColor(-1, 0x000000)
;$batchscript = GUICtrlCreateButton("Select accounts to script", @DesktopWidth - 200, 10)

GUICtrlSetState( $cmbemail, $GUI_HIDE)
GUICtrlSetState( $cmbpass, $GUI_HIDE)
GUICtrlSetState( $cmbrang, $GUI_HIDE)
GUICtrlSetState( $cmbbullets, $GUI_HIDE)
GUICtrlSetState( $cmbinlog, $GUI_HIDE)
GUICtrlSetState( $cmbpayed, $GUI_HIDE)
GUICtrlSetState( $cmbcrew, $GUI_HIDE)
GUICtrlSetState( $cmbcash, $GUI_HIDE)
GUICtrlSetState( $cmbcashinf, $GUI_HIDE)
GUICtrlSetState( $cmbbfinf, $GUI_HIDE)
GUICtrlSetState( $cmbbf, $GUI_HIDE)
GUICtrlSetState( $cmbhide, $GUI_HIDE)
GUICtrlSetState( $cmbhidin, $GUI_HIDE)
GUICtrlSetState( $loginie, $GUI_HIDE)
GUICtrlSetState( $logincm, $GUI_HIDE)
GUICtrlSetState( $loginss, $GUI_HIDE)
GUICtrlSetState( $group, $GUI_HIDE)

GUICtrlSetState( $cmbemailinf, $GUI_HIDE)
GUICtrlSetState( $cmbpassinf, $GUI_HIDE)
GUICtrlSetState( $cmbranginf, $GUI_HIDE)
GUICtrlSetState( $cmbbulletsinf, $GUI_HIDE)
GUICtrlSetState( $cmbinloginf, $GUI_HIDE)
GUICtrlSetState( $cmbpayedinf, $GUI_HIDE)
GUICtrlSetState( $cmbcrewinf, $GUI_HIDE)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

;menu
$mainmenu = GUICtrlCreateMenu ("&Main Menu")
$main = GUICtrlCreateMenuItem( "Main", $mainmenu)
$search = GUICtrlCreateMenuItem( "Search", $mainmenu)
$personotes = GUICtrlCreateMenuItem( "Personal Notes", $mainmenu)
$accmenu = GUICtrlCreateMenu ("&Accounts Menu")
$allacc = GUICtrlCreateMenuItem( "All Accounts", $accmenu)
$stocklist = GUICtrlCreateMenuItem( "Stock List", $accmenu)
$bfholders = GUICtrlCreateMenuItem( "BF holders", $accmenu)
$moneyacc = GUICtrlCreateMenuItem( "Money Accounts", $accmenu)
$killeracc = GUICtrlCreateMenuItem( "Killer Accounts", $accmenu)
$crewacc = GUICtrlCreateMenuItem( "Crew Accounts", $accmenu)
$commumenu = GUICtrlCreateMenu ("&Communications")
$gforum = GUICtrlCreateMenuItem( "General Forum", $commumenu)

If $loginconst[1][3] = "3" Or $loginconst[1][3] = "4" Then
$test = $GUI_ENABLE
ElseIf $loginconst[1][3] = "2" Then
$test = $GUI_ENABLE
Else
$test = $GUI_DISABLE
EndIf

$aforum = GUICtrlCreateMenuItem( "HD/Admin Forum", $commumenu)
GUICtrlSetState(-1, $test)

$inbox = GUICtrlCreateMenuItem( "Inbox", $commumenu)
$nmessage = GUICtrlCreateMenuItem( "New message", $commumenu)

If $loginconst[1][3] = "3" or $loginconst[1][3] = "4" Then
$testa = $GUI_ENABLE
Else
$testa = $GUI_DISABLE
EndIf

$adminmenu = GUICtrlCreateMenu ("Adm&inistrator Menu")
GUICtrlSetState(-1, $testa)
$gopts = GUICtrlCreateMenuItem( "General Options", $adminmenu)
GUICtrlSetState(-1, $testa)
$ulogs = GUICtrlCreateMenuItem( "User Logs", $adminmenu)
GUICtrlSetState(-1, $testa)
$managemain = GUICtrlCreateMenuItem( "Manage Main", $adminmenu)
GUICtrlSetState(-1, $testa)
$manageusers = GUICtrlCreateMenuItem( "Manage Users", $adminmenu)
GUICtrlSetState(-1, $testa)
$manageips = GUICtrlCreateMenuItem( "Manage Ip's", $adminmenu)
GUICtrlSetState(-1, $testa)

$hDummy= GUICtrlCreateDummy()
Dim $AccelKeys[1][2]=[["{ENTER}", $hDummy]]
GUISetAccelerators($AccelKeys)


$mscripts = GUICtrlCreateMenu ("&Scripts")
$batchss = GUICtrlCreateMenuItem( "Users to Shizzle Script", $mscripts)
$yourset = GUICtrlCreateMenu ("&Your Settings")
$passupdate = GUICtrlCreateMenuItem( "Change password", $yourset)
$settings = GUICtrlCreateMenuItem( "Other Settings", $yourset)
$hStatus = _GUICtrlStatusBar_Create($modata)
Local $aParts[1] = [10000]
_GUICtrlStatusBar_SetParts($hStatus,$aParts)
_GUICtrlStatusBar_SetText($hStatus, "Now online: " & _Whoonline())
_GUICtrlStatusBar_SetMinHeight($hStatus, 20)
GUISetState(@SW_SHOW, $modata)
$autoupdate = IniRead( @scriptdir & "\mobdata.ini", "all", "update", 30000)
AdlibRegister( "_refreshdata", $autoupdate)
While 1
		$msg = GUIGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $passupdate
			_passupdate($loginconst)
		Case $msg = $switchaccview
			AdlibUnRegister("_refreshdata")
			AdlibRegister( "_refreshdata", $autoupdate)
			_refreshdata()
		Case $msg = $newusr
			_NewUser($loginconst)
			$array = _YourAcc($loginconst)
			_refreshdata()
		Case $msg = $loginie
			$i = _GETI()
			GUICtrlSetState($cmbhide, $GUI_CHECKED)
			$username = GUICtrlRead($cmbemailinf)
			$password = GUICtrlRead($cmbpassinf)
			_FileCreate(@scriptdir & "\logindinges.txt")
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 1, $username, 1)
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 2, $password, 1)
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 3, $array[$i][0], 1)
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 4, $loginconst[1][0], 1)
			ShellExecute( @scriptdir & "\IEdeamon.exe")
			$checkie = GUICtrlRead( $cmbhide)
			If $checkie = $GUI_CHECKED Then
			$sql = "UPDATE `fillpass` SET `hide` = '1',hidebyuser = '"&$loginconst[1][0]&"' WHERE `fillpass`.`fillpassid` = '" & $array[$i][0] & "' LIMIT 1"
			GUICtrlSetState($loginie, $GUI_HIDE)
			GUICtrlSetState($loginss, $GUI_HIDE)
			GUICtrlSetState($logincm, $GUI_HIDE)
			GUICtrlSetData($cmbhidin, "Unhide, now hiden by " & $loginconst[1][1])
			$name = _Numbinf($array[$i][3])
			_GUICtrlListView_SetItem($combousr, $name, $setred, 0, 0)
			$array[$i][9] = 1
			Else
			$sql = "UPDATE `fillpass` SET `hide` = '0',hidebyuser = '0' WHERE `fillpass`.`fillpassid` = '" & $array[$i][0] & "' LIMIT 1"
			GUICtrlSetState($loginie, $GUI_SHOW)
			GUICtrlSetState($loginss, $GUI_SHOW)
			GUICtrlSetState($logincm, $GUI_SHOW)
			GUICtrlSetData($cmbhidin, "Hide")
			$name = _Numbinf($array[$i][3])
			_GUICtrlListView_SetItem($combousr, $name, $setred, 0, 1)
			$array[$i][9] = 0
			EndIf
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql)
	
			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
			EndIf
			;_refreshdata()
			
		Case $msg = $logincm
			$i = _GETI()
			GUICtrlSetState($cmbhide, $GUI_CHECKED)
			$username = GUICtrlRead($cmbemailinf)
			$password = GUICtrlRead($cmbpassinf)
			_FileCreate(@scriptdir & "\logindinges.txt")
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 1, $username, 1)
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 2, $password, 1)
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 3, $array[$i][0], 1)
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 4, $loginconst[1][0], 1)
			Run(@scriptdir & "\CMdeamon.exe")
			$checkie = GUICtrlRead( $cmbhide)
			If $checkie = $GUI_CHECKED Then
			$sql = "UPDATE `fillpass` SET `hide` = '1',hidebyuser = '"&$loginconst[1][0]&"' WHERE `fillpass`.`fillpassid` = '" & $array[$i][0] & "' LIMIT 1"
			GUICtrlSetState($loginie, $GUI_HIDE)
			GUICtrlSetState($loginss, $GUI_HIDE)
			GUICtrlSetState($logincm, $GUI_HIDE)
			GUICtrlSetData($cmbhidin, "Unhide, now hiden by " & $loginconst[1][1])
			$name = _Numbinf($array[$i][3])
			_GUICtrlListView_SetItem($combousr, $name, $setred, 0, 0)
			$array[$i][9] = 1
			Else
			$sql = "UPDATE `fillpass` SET `hide` = '0',hidebyuser = '0' WHERE `fillpass`.`fillpassid` = '" & $array[$i][0] & "' LIMIT 1"
			GUICtrlSetState($loginie, $GUI_SHOW)
			GUICtrlSetState($loginss, $GUI_SHOW)
			GUICtrlSetState($logincm, $GUI_SHOW)
			GUICtrlSetData($cmbhidin, "Hide")
			$name = _Numbinf($array[$i][3])
			_GUICtrlListView_SetItem($combousr, $name, $setred, 0, 1)
			$array[$i][9] = 0
			EndIf
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql)
	
			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
			EndIf
		Case $msg = $loginss
			$i = _GETI()
			GUICtrlSetState($cmbhide, $GUI_CHECKED)
			$username = GUICtrlRead($cmbemailinf)
			$password = GUICtrlRead($cmbpassinf)
			_FileCreate(@scriptdir & "\logindinges.txt")
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 1, $username, 1)
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 2, $password, 1)
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 3, $array[$i][0], 1)
			_FileWriteToLine( @scriptdir & "\logindinges.txt", 4, $loginconst[1][0], 1)
			ShellExecute( @scriptdir & "\SSdeamon.exe")
			$checkie = GUICtrlRead( $cmbhide)
			If $checkie = $GUI_CHECKED Then
			$sql = "UPDATE `fillpass` SET `hide` = '1',hidebyuser = '"&$loginconst[1][0]&"' WHERE `fillpass`.`fillpassid` = '" & $array[$i][0] & "' LIMIT 1"
			GUICtrlSetState($loginie, $GUI_HIDE)
			GUICtrlSetState($logincm, $GUI_HIDE)
			GUICtrlSetState($loginss, $GUI_HIDE)
			GUICtrlSetData($cmbhidin, "Unhide, now hiden by " & $loginconst[1][1])
			$name = _Numbinf($array[$i][3])
			_GUICtrlListView_SetItem($combousr, $name, $setred, 0, 0)
			$array[$i][9] = 1
			Else
			$sql = "UPDATE `fillpass` SET `hide` = '0',hidebyuser = '0' WHERE `fillpass`.`fillpassid` = '" & $array[$i][0] & "' LIMIT 1"
			GUICtrlSetState($loginie, $GUI_SHOW)
			GUICtrlSetState($loginss, $GUI_SHOW)
			GUICtrlSetState($logincm, $GUI_SHOW)
			GUICtrlSetData($cmbhidin, "Hide")
			$name = _Numbinf($array[$i][3])
			_GUICtrlListView_SetItem($combousr, $name, $setred, 0, 1)
			$array[$i][9] = 0
			EndIf
			$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql)
	
			If $mysql_bool = $MYSQL_SUCCESS Then
			Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
			EndIf
			;_refreshdata()
		Case $msg = $cmbhide
		$i = _GETI()
		$checkie = GUICtrlRead( $cmbhide)
		If $checkie = $GUI_CHECKED Then
			$sql = "UPDATE `fillpass` SET `hide` = '1',hidebyuser = '"&$loginconst[1][0]&"' WHERE `fillpass`.`fillpassid` = '" & $array[$i][0] & "' LIMIT 1"
			GUICtrlSetState($loginie, $GUI_HIDE)
			GUICtrlSetState($loginss, $GUI_HIDE)
			GUICtrlSetState($logincm, $GUI_HIDE)
			GUICtrlSetData($cmbhidin, "Unhide, now hiden by " & $loginconst[1][1])
			$name = _Numbinf($array[$i][3])
			_GUICtrlListView_SetItem($combousr, $name, $setred, 0, 0)
			$array[$i][9] = 1
			Else
			$sql = "UPDATE `fillpass` SET `hide` = '0',hidebyuser = '0' WHERE `fillpass`.`fillpassid` = '" & $array[$i][0] & "' LIMIT 1"
			GUICtrlSetState($loginie, $GUI_SHOW)
			GUICtrlSetState($loginss, $GUI_SHOW)
			GUICtrlSetState($logincm, $GUI_SHOW)
			GUICtrlSetData($cmbhidin, "Hide")
			$name = _Numbinf($array[$i][3])
			_GUICtrlListView_SetItem($combousr, $name, $setred, 0, 1)
			$array[$i][9] = 0
			EndIf
		$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql)

		If $mysql_bool = $MYSQL_SUCCESS Then
		Else
		$errno = _MySQL_errno($MysqlConn)
		MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
		EndIf
		
		Case $msg = $settings
		$time = _Settings()
		If $time = "cancel" Then
		Else
		$bkcolor = IniRead(@scriptdir & "\mobdata.ini", "all", "bgcolor", "242424")
		$textcolor = IniRead(@scriptdir & "\mobdata.ini", "all", "textcolor", "FFFFFF")	
		$textreversecolor = "0x" & _StringReverse($textcolor)
		$bkreversecolor = "0x" & _StringReverse($bkcolor)
		$bkcolor = "0x" & $bkcolor
		$textcolor = "0x" & $textcolor	
		GUIDelete($modata)
		_Mobdatayouracc()
		ExitLoop
		EndIf
		Case $msg = $radrank
		_refreshdataNODB()
		Case $msg = $radbull
		_refreshdataNODB()
		Case $msg = $gforum
		_Gforum()
		Case $msg = $manageips
		_Manageips()
		Case $msg = $ulogs
		_Ulogs()
		Case $msg = $manageusers
		GUISetState( @SW_HIDE, $modata)
		_Manusers()
		Case $msg = $hDummy
		 If _WinAPI_GetFocus() = GUICtrlGetHandle($searchacc) Then
		AdlibUnRegister("_refreshdata")
		$chk = GUICtrlRead ($searchacc)
		If $chk = "" Then
			MsgBox(16, "Blank", "The text you typed in is blank, don't push enter when you're not ready for it:')")
		Else
		;MsgBox(0,"test", $chk & $loginconst[1][0])
		$sql = "SELECT * FROM `mobdata`.`fillpass` WHERE (`username` REGEXP '"&$chk&"' OR `inlogname` REGEXP '"&$chk&"' OR `rank` REGEXP '"&$chk&"' OR `crew`REGEXP '"&$chk&"' OR `purpose` REGEXP '"&$chk&"')"
		$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql) 

		If $mysql_bool = $MYSQL_SUCCESS Then
		Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
		EndIf
		$res = _MySQL_Store_Result($MysqlConn)
		$rows = _MySQL_Num_Rows($res)
		If $rows = 0 Then
		MsgBox(16, "Not Found", "Bummer, the piece of crap you typed in doesn't match anything:(")
		Else
		$rray = _MySQL_Fetch_Result_StringArray($res)
		_GUICtrlListView_DeleteAllItems($combousr)
		_GUICtrlListView_RemoveAllGroups($combousr)
		
		;_ArrayDisplay($rray)
				
		
		$p = 0
		$k = 0
		_GUICtrlListView_EnableGroupView($combousr, False)
While $p < $rows
			$p = $p + 1
			;MsgBox(16,"test i en user", $p & $array[$p][1]) 
			If $rray[$p][9] = 0 Then
			$h = 0
			Else
			$h = 1
			EndIf
			If $h = 0 Then
				;MsgBox(16,"test h en user", $h & $array[$p][1])
			If GUICtrlRead($cmbemailinf) = $rray[$p][1] Then
			$k = 1
			EndIf
			
			$name = _Numbinf($rray[$p][3])
			
			_GUICtrlListView_AddItem($combousr, $name, 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][13], 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][1], 2)
			;_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][2], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][4], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][6], 4)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][5], 5)
			;
			Else
			;MsgBox(16,"test h en user", $h & $array[$p][1])
			$name = _Numbinf($rray[$p][3])
			_GUICtrlListView_AddItem($combousr, $name, 0)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][13], 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][1], 2)
			;_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][2], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][4], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][6], 4)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][5], 5)
			;
			EndIf
			If $k = 0 Then
		GUICtrlSetState( $cmbemail, $GUI_HIDE)
		GUICtrlSetState( $cmbpass, $GUI_HIDE)
		GUICtrlSetState( $cmbrang, $GUI_HIDE)
		GUICtrlSetState( $cmbbullets, $GUI_HIDE)
		GUICtrlSetState( $cmbinlog, $GUI_HIDE)
		GUICtrlSetState( $cmbpayed, $GUI_HIDE)
		GUICtrlSetState( $cmbcrew, $GUI_HIDE)
		GUICtrlSetState( $cmbbf, $GUI_HIDE)
		GUICtrlSetState( $cmbbfinf, $GUI_HIDE)
		GUICtrlSetState( $cmbcash, $GUI_HIDE)
		GUICtrlSetState( $cmbcashinf, $GUI_HIDE)
		GUICtrlSetState( $cmbhide, $GUI_HIDE)
		GUICtrlSetState( $cmbhidin, $GUI_HIDE)
		GUICtrlSetState( $loginie, $GUI_HIDE)
		GUICtrlSetState( $loginss, $GUI_HIDE)
		GUICtrlSetState( $logincm, $GUI_HIDE)

		GUICtrlSetState( $cmbemailinf, $GUI_HIDE)
		GUICtrlSetState( $cmbpassinf, $GUI_HIDE)
		GUICtrlSetState( $cmbranginf, $GUI_HIDE)
		GUICtrlSetState( $cmbbulletsinf, $GUI_HIDE)
		GUICtrlSetState( $cmbinloginf, $GUI_HIDE)
		GUICtrlSetState( $cmbpayedinf, $GUI_HIDE)
		GUICtrlSetState( $cmbcrewinf, $GUI_HIDE)
		GUICtrlSetState( $group, $GUI_HIDE)
		EndIf
			
		WEnd
		GUICtrlSetState($filteroff, $GUI_SHOW)
		$logos = 2
		EndIf
		EndIf
		EndIf
	Case $msg = $searchbut
		AdlibUnRegister("_refreshdata")
		$chk = GUICtrlRead ($searchacc)
		If $chk = "" Then
			MsgBox(16, "Blank", "The text you typed in is blank, don't push enter when you're not ready for it:')")
		Else
		;MsgBox(0,"test", $chk & $loginconst[1][0])
		$sql = "SELECT * FROM `mobdata`.`fillpass` WHERE (`username` REGEXP '"&$chk&"' OR `inlogname` REGEXP '"&$chk&"' OR `rank` REGEXP '"&$chk&"' OR `crew`REGEXP '"&$chk&"' OR `purpose` REGEXP '"&$chk&"')"
		$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql) 

		If $mysql_bool = $MYSQL_SUCCESS Then
		Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
		EndIf
		$res = _MySQL_Store_Result($MysqlConn)
		$rows = _MySQL_Num_Rows($res)
		If $rows = 0 Then
		MsgBox(16, "Not Found", "Bummer, the piece of crap you typed in doesn't match anything:(")
		Else
		$rray = _MySQL_Fetch_Result_StringArray($res)
		_GUICtrlListView_DeleteAllItems($combousr)
		_GUICtrlListView_RemoveAllGroups($combousr)
		
		;_ArrayDisplay($rray)
				
		
		$p = 0
		$k = 0
		_GUICtrlListView_EnableGroupView($combousr, False)
While $p < $rows
			$p = $p + 1
			;MsgBox(16,"test i en user", $p & $array[$p][1]) 
			If $rray[$p][9] = 0 Then
			$h = 0
			Else
			$h = 1
			EndIf
			If $h = 0 Then
				;MsgBox(16,"test h en user", $h & $array[$p][1])
			If GUICtrlRead($cmbemailinf) = $rray[$p][1] Then
			$k = 1
			EndIf
			
			$name = _Numbinf($rray[$p][3])
			
			_GUICtrlListView_AddItem($combousr, $name, 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][13], 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][1], 2)
			;_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][2], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][4], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][6], 4)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][5], 5)
			;
			Else
			;MsgBox(16,"test h en user", $h & $array[$p][1])
			$name = _Numbinf($rray[$p][3])
			_GUICtrlListView_AddItem($combousr, $name, 0)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][13], 1)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][1], 2)
			;_GUICtrlListView_AddSubItem($combousr, $p - 1,$array[$p][2], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][4], 3)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][6], 4)
			_GUICtrlListView_AddSubItem($combousr, $p - 1,$rray[$p][5], 5)
			;
			EndIf
			If $k = 0 Then
		GUICtrlSetState( $cmbemail, $GUI_HIDE)
		GUICtrlSetState( $cmbpass, $GUI_HIDE)
		GUICtrlSetState( $cmbrang, $GUI_HIDE)
		GUICtrlSetState( $cmbbullets, $GUI_HIDE)
		GUICtrlSetState( $cmbinlog, $GUI_HIDE)
		GUICtrlSetState( $cmbpayed, $GUI_HIDE)
		GUICtrlSetState( $cmbcrew, $GUI_HIDE)
		GUICtrlSetState( $cmbbf, $GUI_HIDE)
		GUICtrlSetState( $cmbbfinf, $GUI_HIDE)
		GUICtrlSetState( $cmbcash, $GUI_HIDE)
		GUICtrlSetState( $cmbcashinf, $GUI_HIDE)
		GUICtrlSetState( $cmbhide, $GUI_HIDE)
		GUICtrlSetState( $cmbhidin, $GUI_HIDE)
		GUICtrlSetState( $loginie, $GUI_HIDE)
		GUICtrlSetState( $loginss, $GUI_HIDE)
		GUICtrlSetState( $logincm, $GUI_HIDE)

		GUICtrlSetState( $cmbemailinf, $GUI_HIDE)
		GUICtrlSetState( $cmbpassinf, $GUI_HIDE)
		GUICtrlSetState( $cmbranginf, $GUI_HIDE)
		GUICtrlSetState( $cmbbulletsinf, $GUI_HIDE)
		GUICtrlSetState( $cmbinloginf, $GUI_HIDE)
		GUICtrlSetState( $cmbpayedinf, $GUI_HIDE)
		GUICtrlSetState( $cmbcrewinf, $GUI_HIDE)
		GUICtrlSetState( $group, $GUI_HIDE)
		EndIf
			
		WEnd
		GUICtrlSetState($filteroff, $GUI_SHOW)
		$logos = 2
		EndIf
		EndIf
	Case $msg = $filteroff
		AdlibRegister( "_refreshdata", $autoupdate)
		GUICtrlSetData($searchacc, "")
		GUICtrlSetState($filteroff, $GUI_HIDE)
		_refreshdata()
		EndSelect
    WEnd
	$sql = "UPDATE `users` SET `online` =  '0' WHERE name='" & $loginconst[1][1] & "'"
		$mysql_bool = _MySQL_Real_Query($MysqlConn, $sql) 

		If $mysql_bool = $MYSQL_SUCCESS Then
		Else
			$errno = _MySQL_errno($MysqlConn)
			MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
		EndIf
	$nowtime = @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR &":"& @MIN &":"& @SEC
	$query = "INSERT INTO `mobdata`.`logs` (`logid`, `ip`, `userid`, `datum`, `inout`) VALUES (NULL, '"& _GetIP() &"', '"& $loginconst[1][0]&"', '"&$nowtime&"', '1')";
	$mysql_bool = _MySQL_Real_Query($MysqlConn, $query)

	If $mysql_bool = $MYSQL_SUCCESS Then
	Else
    $errno = _MySQL_errno($MysqlConn)
    MsgBox(16,"Error:",$errno & @LF & _MySQL_error($MysqlConn))
	EndIf
    GUIDelete()
	Exit 0
EndFunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

    Local $hWndFrom, $iCode, $tNMHDR, $hWndListView
    $hWndListView = $combousr
    If Not IsHWnd($combousr) Then $hWndListView = GUICtrlGetHandle($combousr)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
		
		
        Case $hWndListView
            Switch $iCode

                Case $LVN_ITEMACTIVATE  ; Sent by a list-view control when the user double-clicks an item with the left mouse button
                   Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)

                   $Index = DllStructGetData($tInfo, "Index")

                   $subitemNR = DllStructGetData($tInfo, "SubItem")


                   ; make sure user clicks on the listview & only the activate
                   If $Index <> -1 Then

                       ; col1 ITem index
                        $item = StringSplit(_GUICtrlListView_GetItemTextString($combousr, $Index), "|")
						$item = $item[3]
						$i = 0
						While $i < $array[0][0]
						$i = $i + 1
						$lollie = $array[$i][1]
						If $lollie = $item Then ExitLoop
						WEnd	
						$p = $i
						$setred = $Index
						GUICtrlSetData($cmbemailinf, $array[$p][1])
						GUICtrlSetData($cmbpassinf, $array[$p][2])
						GUICtrlSetData($cmbinloginf, $array[$p][4])
						GUICtrlSetData($cmbranginf, $array[$p][5])
						GUICtrlSetData($cmbbulletsinf, $array[$p][6])
						GUICtrlSetData($cmbcrewinf, $array[$p][8])
						If $array[$p][7] = 0 Then
						GUICtrlSetData($cmbpayedinf, "no")
						ElseIf $array[$p][7] = 1 Then
						GUICtrlSetData($cmbpayedinf, "yes")
						EndIf
			
						If $array[$p][9] = 0 Then
						GUICtrlSetState($cmbhide, $GUI_UNCHECKED)
						GUICtrlSetData($cmbhidin, "Hide")
						ElseIf $array[$p][9] = 1 Then
						GUICtrlSetState($cmbhide, $GUI_CHECKED)
						GUICtrlSetData($cmbhidin, "Unhide, now hiden by " & _Numbinf($array[$p][10]))
						EndIf
						If $array[$p][11] = 1 Then
						GUICtrlSetData($cmbbfinf, "yes")
						Else
						GUICtrlSetData($cmbbfinf,"no")
						EndIf
						$ach = _Inttocash($array[$p][12])
						GUICtrlSetData($cmbcashinf,$ach)
						
			
						GUICtrlSetState( $cmbemail, $GUI_SHOW)
						GUICtrlSetState( $cmbpass, $GUI_SHOW)
						GUICtrlSetState( $cmbrang, $GUI_SHOW)
						GUICtrlSetState( $cmbbullets, $GUI_SHOW)
						GUICtrlSetState( $cmbinlog, $GUI_SHOW)
						GUICtrlSetState( $cmbpayed, $GUI_SHOW)
						GUICtrlSetState( $cmbcrew, $GUI_SHOW)
						GUICtrlSetState( $cmbhide, $GUI_SHOW)
						GUICtrlSetState( $cmbhidin, $GUI_SHOW)
						GUICtrlSetState( $cmbcash, $GUI_SHOW)
						GUICtrlSetState( $cmbcashinf, $GUI_SHOW)
						GUICtrlSetState( $cmbbfinf, $GUI_SHOW)
						GUICtrlSetState( $cmbbf, $GUI_SHOW)
						GUICtrlSetState( $group, $GUI_SHOW)

						GUICtrlSetState( $cmbemailinf, $GUI_SHOW)
						GUICtrlSetState( $cmbpassinf, $GUI_HIDE)
						GUICtrlSetState( $cmbranginf, $GUI_SHOW)
						GUICtrlSetState( $cmbbulletsinf, $GUI_SHOW)
						GUICtrlSetState( $cmbinloginf, $GUI_SHOW)
						GUICtrlSetState( $cmbpayedinf, $GUI_SHOW)
						GUICtrlSetState( $cmbcrewinf, $GUI_SHOW)
						If $array[$p][9] = 0 Then
						GUICtrlSetState( $loginie, $GUI_SHOW)
						GUICtrlSetState( $loginss, $GUI_SHOW)
						GUICtrlSetState( $logincm, $GUI_SHOW)
						ElseIf $array[$p][9] = 1 Then
						GUICtrlSetState( $loginie, $GUI_HIDE)
						GUICtrlSetState( $loginss, $GUI_HIDE)
						GUICtrlSetState( $logincm, $GUI_HIDE)
						EndIf
						
						EndIf

            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc

Func WM_NOTIFYUSERS($hWnd, $iMsg, $iwParam, $ilParam)

    Local $hWndFrom, $iCode, $tNMHDR, $hWndListView
    $hWndListView = $combojan
    If Not IsHWnd($combojan) Then $hWndListView = GUICtrlGetHandle($combojan)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
		
		
        Case $hWndListView
            Switch $iCode

                Case $LVN_ITEMACTIVATE  ; Sent by a list-view control when the user double-clicks an item with the left mouse button
                   Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)

                   $Index = DllStructGetData($tInfo, "Index")

                   $subitemNR = DllStructGetData($tInfo, "SubItem")


                   ; make sure user clicks on the listview & only the activate
                   If $Index <> -1 Then

                       ; col1 ITem index
                        $item = StringSplit(_GUICtrlListView_GetItemTextString($combojan, $Index), "|")
						$item = $item[1]
						$i = 0
						While $i < $userss[0][0]
						$i = $i + 1
						$lollie = $userss[$i][1]
						If $lollie = $item Then ExitLoop
						WEnd	
						$p = $i
						GUICtrlSetData($usrnameinf, $userss[$p][1])
						If $userss[$p][3] = 0 Then
	$userlef = "member"
ElseIf $userss[$p][3] = 1 Then
	$userlef = "member+"
ElseIf $userss[$p][3] = 2 Then
	$userlef = "moderator"
ElseIf $userss[$p][3] = 3 Then
	$userlef = "admin"
ElseIf $userss[$p][3] = 4 Then
	$userlef = "admin+"
	EndIf
						GUICtrlSetData($usruserlevelinf, $userlef)
						
						GUICtrlSetState( $usrnameinf, $GUI_SHOW)
						GUICtrlSetState( $usruserlevelinf, $GUI_SHOW)
						GUICtrlSetState( $usruserlevel, $GUI_SHOW)
						GUICtrlSetState( $usrname, $GUI_SHOW)
						GUICtrlSetState( $usrgroupp, $GUI_SHOW)
						GUICtrlSetState( $savebut, $GUI_SHOW)
						GUICtrlSetState( $passbut, $GUI_SHOW)
						GUICtrlSetState( $delbut, $GUI_SHOW)
						
						EndIf

            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc

Func _GETI()
						$item = guictrlread($cmbemailinf)
						$i = 0
						If $item = "hidden" Then
						Else
						While $i < $array[0][0]
						$i = $i + 1
						$lollie = $array[$i][1]
						If $lollie = $item Then ExitLoop
						WEnd	
					EndIf
					Return $i
					EndFunc
_MobdataYourAcc()