#include <SQLite.dll.au3>
#include <SQLite.au3>
#include <GUIConstants.au3>
#include <GUIEdit.au3>
#include <GUICombo.au3>
#include <Misc.au3>

Opt("GUIOnEventMode",1)
Global $VisVillages,$aResult,$iRows,$iCols,$Villages,$ContextMenu,$ContextMenuItem,$CurrX,$CurrY,$File,$FileP,$LFileP,$HotkeyMode=1,$Navigating=1
Global $BkColors[6]=["",0xBBBBBB,0xFFBBBB,0x99BBFF,0xBBFFBB,0x000000]
Global $TribeNames[6]=["","Romans","Teutons","Gauls","Nature","Natar"]

$FindFile=FileFindFirstFile(@MyDocumentsDir&"\*.sql")
FileClose($FindFile)
If $FindFile=-1 Then
	Switch MsgBox(35,"SQL file not found","There doesn't appear to be any SQL dump files in your Documents; would you like to download one now?"&@CRLF&@CRLF&"(Clicking no will allow you to browse for another location)")
		Case 2
			Exit
		Case 7
			$LocalSqlFilePath=FileOpenDialog("Select File","","SQL files (*.sql)")
			If @error Then Exit
			If StringLeft(FileGetTime($LocalSqlFilePath,0,1),8) <> @YEAR&@MON&@MDAY Then
				AskUpdateDB()
			Else
				$LocalSqlFile=FileOpen($LocalSqlFilePath,0)
			EndIf
		Case 6
			DlOpenFile()
	EndSwitch
Else
	$LocalSqlFilePath=FileOpenDialog("Select File","","SQL files (*.sql)")
	If @error Then
		If MsgBox(36,"Download file?","Do you want to download a dump from another server?") = 6 Then
			DlOpenFile()
		Else
			Exit
		EndIf
	Else
		If StringLeft(FileGetTime($LocalSqlFilePath,0,1),8) <> @YEAR&@MON&@MDAY Then
			AskUpdateDB()
		Else
			$LocalSqlFile=FileOpen($LocalSqlFilePath,0)
		EndIf
	EndIf
EndIf

Func AskUpdateDB()
	If MsgBox(36,"Update information?","The selected database information is probably not current, would you like to download an updated version?") = 6 Then
		$LocalDbFilePath=StringReplace($LocalSqlFilePath,".sql",".db")
		_SQLite_Startup()
		_SQLite_Open($LocalDbFilePath)
		If _SQLite_GetTable2d(-1,"SELECT * from `info` WHERE `name`='dumpPath'",$aResult,$iRows,$iCols) <> $SQLite_OK OR $iRows <> 1 Then
			_SQLite_Display2DResult($aResult)
			MsgBox(16,"Error","Unknown download path- using old data")
			$LocalSqlFile=FileOpen($LocalSqlFilePath,0)
		Else
			GUICreate("Downloading Travian dump",250,100,-1,-1,0x80800000)
			GUISetBkColor(0xE1EED3)
			GUICtrlCreateLabel("Downloading "&$aResult[1][1],0,10,250,25,0x1)
			GUICtrlCreateLabel("Please wait...",0,35,250,30,0x1)
			GUISetState()
			If InetGet($aResult[1][1],$LocalSqlFilePath,1)=0 Then
				MsgBox(16,"Error","There was a problem downloading "&$aResult[1][1]&@CRLF&@CRLF&"This program will now exit.")
				Exit
			EndIf
			GUIDelete()
		EndIf
		_SQLite_Close()
		_SQLite_Shutdown()
	Else
		$LocalSqlFile=FileOpen($LocalSqlFilePath,0)
	EndIf
EndFunc

Func DlOpenFile()
	While 1
		$ServerPath=InputBox("Server address","Please enter the server address you wish to map:","http://s1.travian.com")
		If @error OR $ServerPath="" Then Exit
		If NOT StringInStr($ServerPath,"://") Then $ServerPath="http://"&$ServerPath
		If StringInStr($ServerPath,".",0,3)=0 AND StringInStr($ServerPath,".",0,2) <> 0 Then ExitLoop
		MsgBox(16,"Error","Please just provide the server address (for instance, nothing after .com)")
	WEnd
	If StringTrimLeft($ServerPath,StringInStr($ServerPath,".",0,2))="de" OR StringTrimLeft($ServerPath,StringInStr($ServerPath,".",0,2))="org" Then
		Local $SQLname="/karte.sql"
	Else
		Local $SQLname="/map.sql"
	EndIf
	GUICreate("Downloading Travian dump",250,100,-1,-1,0x80800000)
	GUISetBkColor(0xE1EED3)
	GUICtrlCreateLabel("Downloading "&$ServerPath&$SQLname,0,10,250,25,0x1)
	GUICtrlCreateLabel("Please wait...",0,35,250,30,0x1)
	GUISetState()
	If InetGet($ServerPath&$SQLname,@MyDocumentsDir&"\"&StringReplace(StringReplace($ServerPath,"http://",""),".","")&".sql",1)=0 Then
		MsgBox(16,"Error","There was a problem downloading "&$ServerPath&$SQLname&@CRLF&@CRLF&"This program will now exit.")
		Exit
	EndIf
	GUIDelete()
	Sleep(500)
	$LocalSqlFilePath=@MyDocumentsDir&"\"&StringReplace(StringReplace($ServerPath,"http://",""),".","")&".sql"
	$LocalSqlFile=FileOpen($LocalSqlFilePath,0)
	If @error Then
		MsgBox(16,"Error","There was a problem downloading "&$ServerPath&$SQLname&@CRLF&@CRLF&"This program will now exit.")
		Exit
	EndIf
	FileClose($LocalSqlFile)
	_SQLite_Startup()
	_SQLite_Open(StringReplace($LocalSqlFilePath,".sql",".db"))
	_SQLite_Exec(-1,"CREATE TABLE IF NOT EXISTS `info` (`name` UNIQUE,`value`)")
	_SQLite_Exec(-1,"INSERT OR ABORT INTO `info` VALUES('dumpPath','"&$ServerPath&$SQLname&"')")
	_SQLite_Close()
	_SQLite_Shutdown()
EndFunc

_SQLite_Startup()
$PersistentDB=_SQLite_Open(StringReplace($LocalSqlFilePath,".sql",".db"))
_SQLite_Exec($PersistentDB,"CREATE TABLE IF NOT EXISTS `info` (`name` UNIQUE,`value`)")
_SQLite_Exec($PersistentDB,"CREATE TABLE IF NOT EXISTS `Favorites` (`x`,`y`,`name`)")
_SQLite_Exec($PersistentDB,"CREATE TABLE IF NOT EXISTS `FriendlyPlayers` (`pid` UNIQUE,`type`)")
_SQLite_Exec($PersistentDB,"CREATE TABLE IF NOT EXISTS `FriendlyAlliances` (`aid` UNIQUE,`type`)")
_SQLite_Exec($PersistentDB,"CREATE TABLE IF NOT EXISTS `EnemyPlayers` (`pid` UNIQUE,`type`)")
_SQLite_Exec($PersistentDB,"CREATE TABLE IF NOT EXISTS `EnemyAlliances` (`aid` UNIQUE,`type`)")
_SQLite_Exec($PersistentDB,"CREATE TABLE IF NOT EXISTS `VillageNotes` (`vid` UNIQUE,`note`)")
_SQLite_Exec($PersistentDB,"CREATE TABLE IF NOT EXISTS `PlayerNotes` (`pid` UNIQUE,`note`)")
_SQLite_Exec($PersistentDB,"CREATE TABLE IF NOT EXISTS `AllianceNotes` (`aid` UNIQUE,`note`)")

$MemDB=_SQLite_Open()
_SQLite_Exec($MemDB,"CREATE TABLE `x_world` (`id`,`x`,`y`,`tid`,`vid`,`village`,`uid`,`player`,`aid`,`alliance`,`population`)")
$FileContents=FileRead($LocalSqlFilePath)
$FileContents=StringSplit($FileContents,@LF,1)

$LoadingGUI=GUICreate("Loading Travian Database...",250,100,-1,-1,0x80800000)
GUISetBkColor(0xE1EED3)
GUICtrlCreateLabel("Travian 13² && database",0,10,250,25,0x1)
GUICtrlSetFont(-1,12,700)
GUICtrlCreateLabel("by james3mg: thanks to the AutoIt Team!",0,35,250,30,0x1)
GUICtrlCreateLabel("Loading: please wait",0,60,250,20,0x1)
$ProgressBar=GUICtrlCreateLabel("",0,85,1,2)
GUICtrlSetBkColor(-1,0x0000BB)
GUISetState()
For $i=1 To $FileContents[0]
	_SQLite_Exec($MemDB,$FileContents[$i])
	If StringRight($i,3)="000" OR StringRight($i,3)="500" Then GUICtrlSetPos($ProgressBar,0,85,Round(($i/$FileContents[0])*250),2)
Next

WritePics()

GUIDelete($LoadingGUI)

$MapGUI=GUICreate("Travian 13x13 map",600,680)
GUISetBkColor(0xE1EED3)

GUICtrlCreateLabel("",15,0,1,585)
GUICtrlSetBkColor(-1,0x71D000)
For $i=1 To 12
	GUICtrlCreateLabel("",$i*45+15,0,1,585)
	If $i=3 OR $i=10 Then
		GUICtrlSetBkColor(-1,0x007700)
	Else
		GUICtrlSetBkColor(-1,0x71D000)
	EndIf
	GUICtrlCreateLabel("",15,$i*45,585,1)
	If $i=3 OR $i=10 Then
		GUICtrlSetBkColor(-1,0x007700)
	Else
		GUICtrlSetBkColor(-1,0x71D000)
	EndIf
Next
GUICtrlCreateLabel("",15,13*45,585,1)
GUICtrlSetBkColor(-1,0x71D000)

GUICtrlCreateLabel("",284,269,46,2)
GUICtrlSetBkColor(-1,0x990000)
GUICtrlCreateLabel("",284,315,46,2)
GUICtrlSetBkColor(-1,0x990000)
GUICtrlCreateLabel("",284,269,2,46)
GUICtrlSetBkColor(-1,0x990000)
GUICtrlCreateLabel("",330,270,2,46)
GUICtrlSetBkColor(-1,0x990000)

Global $CoordLabels[26]
For $i=0 To 12
	$CoordLabels[$i]=GUICtrlCreateLabel("",0,$i*45+12,25,20)
	GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
Next
For $i=13 To 25
	$CoordLabels[$i]=GUICtrlCreateLabel("",($i-12)*45-10,586,25,20)
	GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
Next

GUICtrlCreateLabel("Find Player",5,610,125,20)
$PlayerCombo=GUICtrlCreateCombo("Populating...",5,630,125,20,$GUI_SS_DEFAULT_COMBO+$CBS_SORT)
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlSetOnEvent(-1,"ListPlayerVillages")

$VillageList=GUICtrlCreateList("",135,600,100,80)
GUICtrlSetOnEvent(-1,"ClickPlayerVillage")

GUICtrlCreateLabel("X",250,610,50,20)
GUICtrlCreateLabel("Y",310,610,50,20)
$XInput=GUICtrlCreateInput("0",250,630,50,20,0x2080)
$YInput=GUICtrlCreateInput("0",310,630,50,20,0x2080)

$UpButton=GUICtrlCreateButton("N",420,610,20,20)
$LeftButton=GUICtrlCreateButton("W",400,630,20,20)
$RightButton=GUICtrlCreateButton("E",440,630,20,20)
$DownButton=GUICtrlCreateButton("S",420,650,20,20)

GUICtrlCreateLabel("Saved Views:",480,610,110,20)
$FavoritesList=GUICtrlCreateCombo("",480,630,110,20,0x3)
GUICtrlSetOnEvent(-1,"GotoView")

_SQLite_GetTable2d($PersistentDB,"Select * from info where name = 'x_start' UNION Select * from info where name = 'y_start' ORDER BY name",$aResult,$iRows,$iCols)
If $iRows < 2 Then
	SetMap(-6,-6,0)
Else
	SetMap($aResult[1][1],$aResult[2][1],0)
EndIf
PopulateFavorites()

GUISetState()
GUISetOnEvent(-3,"Exiter")
GUICtrlSetState($XInput,$GUI_FOCUS)

_SQLite_GetTable2d($MemDB,"SELECT DISTINCT `player` FROM `x_world`",$aResult,$iRows,$iCols)
$PlayerString="| "
For $i=1 To $iRows
	$PlayerString&="|"&$aResult[$i][0]
Next
GUICtrlSetData($PlayerCombo,$PlayerString)
GUICtrlSetState($PlayerCombo,$GUI_ENABLE)
ShowCenteredPlayer()
$Navigating=0

If HotKeySet("{UP}","GoNorth")<>1 Then $HotkeyMode=0
If HotKeySet("{DOWN}","GoSouth")<>1 Then $HotkeyMode=0
If HotKeySet("{LEFT}","GoWest")<>1 Then $HotkeyMode=0
If HotKeySet("{Right}","GoEast")<>1 Then $HotkeyMode=0

If $HotkeyMode=0 Then
	HotKeySet("{UP}")
	HotKeySet("{DOWN}")
	HotKeySet("{LEFT}")
	HotKeySet("{RIGHT}")
	TrayTip("Warning","Another program has registered the arrow hotkeys; you can't use the arrow keys for navigation until they're released",10)
EndIf

GUIRegisterMsg(0x0086,"WinActivated")

GUICtrlSetOnEvent($UpButton,"GoNorth")
GUICtrlSetOnEvent($DownButton,"GoSouth")
GUICtrlSetOnEvent($LeftButton,"GoWest")
GUICtrlSetOnEvent($RightButton,"GoEast")

While 1
	If (_GUICtrlEditGetModify($XInput) OR _GUICtrlEditGetModify($YInput)) AND $Navigating=0 Then SetMap(GUICtrlRead($XInput)-6,GUICtrlRead($YInput)-6)
	Sleep(150)
WEnd

#Region navigation
Func GoNorth()
	If $Navigating Then Return
	$Navigating=1
	If _IsPressed("10") Then
		SetMap($CurrX,$CurrY+7)
	Else
		SetMap($CurrX,$CurrY+1)
	EndIf
	$Navigating=0
EndFunc

Func GoSouth()
	If $Navigating Then Return
	$Navigating=1
	If _IsPressed("10") Then
		SetMap($CurrX,$CurrY-7)
	Else
		SetMap($CurrX,$CurrY-1)
	EndIf
	$Navigating=0
EndFunc

Func GoEast()
	If $Navigating Then Return
	$Navigating=1
	If _IsPressed("10") Then
		SetMap($CurrX+7,$CurrY)
	Else
		SetMap($CurrX+1,$CurrY)
	EndIf
	$Navigating=0
EndFunc

Func GoWest()
	If $Navigating Then Return
	$Navigating=1
	If _IsPressed("10") Then
		SetMap($CurrX-7,$CurrY)
	Else
		SetMap($CurrX-1,$CurrY)
	EndIf
	$Navigating=0
EndFunc

Func WinActivated($hWndGUI,$MsgID,$WParam,$LParam)
	If $WParam=1 AND $hWndGUI=$MapGUI Then
		Sleep(50)
		Local $NewHotkeyMode=1
		If HotKeySet("{Up}","GoNorth")<>1 Then $NewHotkeyMode=0
		If HotKeySet("{Down}","GoSouth")<>1 Then $NewHotkeyMode=0
		If HotKeySet("{Left}","GoWest")<>1 Then $NewHotkeyMode=0
		If HotKeySet("{Right}","GoEast")<>1 Then $NewHotkeyMode=0
		If $NewHotkeyMode=0 Then
			HotKeySet("{Up}")
			HotKeySet("{Down}")
			HotKeySet("{Left}")
			HotKeySet("{Right}")
		EndIf
		If $NewHotkeyMode=1 AND $HotkeyMode=0 Then TrayTip("Hotkey Information","The arrow hotkeys have been released by the other program; you can use the arrow keys to navigate in the map again",10)
		If $NewHotkeyMode=0 AND $HotkeyMode=1 Then TrayTip("Warning","Another program has stolen the arrow hotkeys while the game was paused; you can't use the arrow keys for navigation until they're released",10)
		$HotkeyMode=$NewHotkeyMode
	Else
		GUISetState($GUI_SHOW,$hWndGUI)
		HotKeySet("{Right}")
		HotKeySet("{Up}")
		HotKeySet("{Left}")
		HotKeySet("{Down}")
	EndIf
EndFunc
#EndRegion navigation

#cs
	0	id 			Number of the field, starts in the top left corner at the coordinate (-400|400) and ends in the bottom right corner at (400|-400) 
	1	x			X-Coordinate 
	2	y			y-Coordinate 
	3	tid			The tribe number. 1 = Roman, 2 = Teuton, 3 = Gaul, 4 = Nature and 5 = Natars 
	4	vid			Village number 
	5	village		Village name 
	6	uid			Player number also known as User-ID 
	7	player		Player name 
	8	aid			Alliance number 
	9	alliance	Alliance name 
	10	population	The village's number of inhabitants 
#ce
Func SetMap($_x=-6,$_y=-6,$_ShowPlayer=1)
	Global $CurrX=$_x
	Global $CurrY=$_y
	_GUICtrlEditSetModify($XInput,0)
	_GUICtrlEditSetModify($YInput,0)
	GUICtrlSetData($XInput,$CurrX+6)
	GUICtrlSetData($YInput,$CurrY+6)
	For $i=0 To 12
		GUICtrlSetData($CoordLabels[$i],($_y+12)-$i)
	Next
	For $i=13 To 25
		GUICtrlSetData($CoordLabels[$i],$_x+$i-13)
	Next
	If UBound($Villages) > 0 Then
		For $i=0 To UBound($Villages)-1
			For $n=0 To 11
				GUICtrlDelete($ContextMenuItem[$i][$n])
			Next
			GUICtrlDelete($ContextMenu[$i])
			GUICtrlDelete($Villages[$i])
		Next
	EndIf
	_SQLite_GetTable2d($MemDB,"Select * from `x_world` where x >= "&$_x&" AND x < "&$_x+13&" AND y >= "&$_y&" AND y < "&$_y+13,$VisVillages,$iRows,$iCols)
	If $iRows=0 Then Return
	$Villages=0
	Global $Villages[$iRows]
	$ContextMenu=0
	Global $ContextMenu[$iRows]
	$ContextMenuItem=0
	Global $ContextMenuItem[$iRows][12]
	For $i=1 To $iRows
		
		Local $TipStr="Village: "&$VisVillages[$i][5]&@CRLF&"Player: "&$VisVillages[$i][7]&@CRLF&"Tribe: "&$TribeNames[$VisVillages[$i][3]]&@CRLF&"Alliance: "&$VisVillages[$i][9]&@CRLF&"Pop: "&$VisVillages[$i][10]
		_SQLite_GetTable2d($PersistentDB,"SELECT `note` FROM `VillageNotes` WHERE `vid`="&_SQLite_Escape($VisVillages[$i][4]),$aResult,$iRows,$iCols)
		If $iRows > 0 Then $TipStr&=@CRLF&@CRLF&"Village notes:"&@CRLF&$aResult[1][0]
		_SQLite_GetTable2d($PersistentDB,"SELECT `note` FROM `PlayerNotes` WHERE `pid`="&_SQLite_Escape($VisVillages[$i][6]),$aResult,$iRows,$iCols)
		If $iRows > 0 Then $TipStr&=@CRLF&@CRLF&"Player notes:"&@CRLF&$aResult[1][0]
		_SQLite_GetTable2d($PersistentDB,"SELECT `note` FROM `AllianceNotes` WHERE `aid`="&_SQLite_Escape($VisVillages[$i][8]),$aResult,$iRows,$iCols)
		If $iRows > 0 Then $TipStr&=@CRLF&@CRLF&"Alliance notes:"&@CRLF&$aResult[1][0]
		
		Switch $VisVillages[$i][10]
			Case 0 to 99
				$FirstPicNum=0
			Case 100 to 249
				$FirstPicNum=1
			Case 250 to 499
				$FirstPicNum=2
			Case Else
				$FirstPicNum=3
		EndSwitch
		Select
			Case _SQLite_GetTable2d($PersistentDB,"SELECT * FROM `info` WHERE `name`='self'",$aResult,$iRows,$iCols) = $SQLite_OK AND $iRows > 0 AND $VisVillages[$i][6] = $aResult[1][1]
				$SecondPicNum=0
			Case _SQLite_GetTable2d($PersistentDB,"SELECT * FROM `info` WHERE `name`='self'",$aResult,$iRows,$iCols) = $SQLite_OK AND $iRows > 0 AND _SQLite_GetTable2d($MemDB,"SELECT * FROM `x_world` WHERE `uid`="&$aResult[1][1],$aResult,$iRows,$iCols) = $SQLite_OK AND $iRows>0 AND $aResult[1][8] = $VisVillages[$i][8] AND $aResult[1][8] <> 0
				$SecondPicNum=3
			Case _SQLite_GetTable2d($PersistentDB,"SELECT * FROM `FriendlyPlayers` WHERE `pid`='"&$VisVillages[$i][6]&"'",$aResult,$iRows,$iCols) = $SQLite_OK AND $iRows>0
				$SecondPicNum=1
				$TipStr&=@CRLF&@CRLF&"Friendly Player: "&$aResult[1][1]
			Case _SQLite_GetTable2d($PersistentDB,"SELECT * FROM `EnemyPlayers` WHERE `pid`='"&$VisVillages[$i][6]&"'",$aResult,$iRows,$iCols) = $SQLite_OK AND $iRows>0
				$SecondPicNum=2
				$TipStr&=@CRLF&@CRLF&"Enemy Player: "&$aResult[1][1]
			Case _SQLite_GetTable2d($PersistentDB,"SELECT * FROM `FriendlyAlliances` WHERE `aid`='"&$VisVillages[$i][8]&"'",$aResult,$iRows,$iCols) = $SQLite_OK AND $iRows>0
				$SecondPicNum=1
				$TipStr&=@CRLF&@CRLF&"Friendly Alliance: "&$aResult[1][1]
			Case _SQLite_GetTable2d($PersistentDB,"SELECT * FROM `EnemyAlliances` WHERE `aid`='"&$VisVillages[$i][8]&"'",$aResult,$iRows,$iCols) = $SQLite_OK AND $iRows>0
				$SecondPicNum=2
				$TipStr&=@CRLF&@CRLF&"Enemy Alliance: "&$aResult[1][1]
			Case Else
				$SecondPicNum=4
		EndSelect
		
		$Villages[$i-1]=GUICtrlCreatePic(@TempDir&"\c"&$FirstPicNum&$SecondPicNum&".bmp",($VisVillages[$i][1]-$_x)*45+17,540-($VisVillages[$i][2]-$_y)*45+2,41,41,0x300)
		GUICtrlSetState(-1,$GUI_SHOW)
		GUICtrlSetBkColor(-1,$BkColors[$VisVillages[$i][3]])
		GUICtrlSetOnEvent(-1,"CenterOnClicked")
		
		GUICtrlSetTip(-1,$TipStr)
		
		$ContextMenu[$i-1] = GUICtrlCreateContextMenu($Villages[$i-1])
		$ContextMenuItem[$i-1][0]=GUICtrlCreateMenuItem("Set Starting Location",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][1]=GUICtrlCreateMenuItem("This is me",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][2]=GUICtrlCreateMEnuItem("Save view",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][10]=GUICtrlCreateMenuItem("",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][3]=GUICtrlCreateMenuItem("Mark player as friendly",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][4]=GUICtrlCreateMenuItem("Mark alliance as friendly",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][5]=GUICtrlCreateMenuItem("Mark player as enemy",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][6]=GUICtrlCreateMenuItem("Mark alliance as enemy",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][11]=GUICtrlCreateMenuItem("",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][7]=GUICtrlCreateMenuItem("Attach a note to this village",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][8]=GUICtrlCreateMenuItem("Attach a note to this player",$ContextMenu[$i-1])
		$ContextMenuItem[$i-1][9]=GUICtrlCreateMenuItem("Attach a note to this alliance",$ContextMenu[$i-1])
		For $n=0 To 8
			GUICtrlSetOnEvent($ContextMenuItem[$i-1][$n],"ContextMenu")
		Next
	Next
	If $_ShowPlayer=1 Then ShowCenteredPlayer()
EndFunc

Func ContextMenu()
	For $i=1 To UBound($ContextMenuItem)
		For $n=0 To 8
			If $ContextMenuItem[$i-1][$n] = @GUI_CTRLID Then ExitLoop 2
		Next
	Next
	Switch $n
		Case 0
			;add starting values to info table
			_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `info` VALUES('x_start','"&$VisVillages[$i][1]-6&"')")
			_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `info` VALUES('y_start','"&$VisVillages[$i][2]-6&"')")
			MsgBox(0,"Done","The map will start centered on "&$VisVillages[$i][5]&" from now on")
		Case 1
			;add pid to self value in info table
			_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `info` VALUES('self','"&$VisVillages[$i][6]&"')")
			MsgBox(0,"Done","Villages belonging to "&$VisVillages[$i][7]&" will be treated as your own")
			SetMap($CurrX,$CurrY)
		Case 2
			;add location to favorites table
			$temp=InputBox("Name this entry","Please give a name to this saved view")
			If NOT @error AND $temp <> "" Then
				_SQLite_Exec($PersistentDB,"INSERT into `Favorites` VALUES('"&$CurrX&"','"&$CurrY&"',"&_SQLite_Escape($temp)&")")
				MsgBox(0,"Done","This view has been added to your saved views")
			EndIf
			PopulateFavorites()
		Case 3
			;add pid to friendly player table
			_SQLite_GetTable2d($PersistentDB,"SELECT `type` FROM `FriendlyPlayers` WHERE `pid` = '"&$VisVillages[$i][6]&"'",$aResult,$iRows,$iCols)
			If $iRows > 0 Then
				$temp=$aResult[1][0]
			Else
				$temp=""
			EndIf
			$temp=InputBox("Type of friendly player","What kind of friendly player is this?"&@CRLF&@CRLF&"Personal NAP, Alliance NAP or Personal Confed"&@CRLF&"are good examples of what to put here",$temp)
			If NOT @error AND $temp <> "" Then
				_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `FriendlyPlayers` VALUES('"&$VisVillages[$i][6]&"',"&_SQLite_Escape($temp)&")")
				MsgBox(0,"Done","Villages belonging to "&$VisVillages[$i][7]&" will be treated as friendly")
			Else
				_SQLite_Exec($PersistentDB,"DELETE FROM `FriendlyPlayers` WHERE `pid` = '"&$VisVillages[$i][6]&"'")
				MsgBox(0,"Deleted","This player has been removed from your list of friendly players")
			EndIf
			SetMap($CurrX,$CurrY)
		Case 4
			;add aid to friendly alliance table
			_SQLite_GetTable2d($PersistentDB,"SELECT `type` FROM `FriendlyAlliances` WHERE `aid` = '"&$VisVillages[$i][8]&"'",$aResult,$iRows,$iCols)
			If $iRows > 0 Then
				$temp=$aResult[1][0]
			Else
				$temp=""
			EndIf
			$temp=InputBox("Type of friendly alliance","What kind of friendly alliance is this?"&@CRLF&@CRLF&"NAP, Confed or Wing"&@CRLF&"are good examples of what to put here",$Temp)
			If NOT @error AND $temp <> "" Then
				_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `FriendlyAlliances` VALUES('"&$VisVillages[$i][8]&"',"&_SQLite_Escape($temp)&")")
				MsgBox(0,"Done","Players belonging to "&$VisVillages[$i][9]&" will be treated as friendly")
			Else
				_SQLite_Exec($PersistentDB,"DELETE FROM `FriendlyAlliances` WHERE `aid` = '"&$VisVillages[$i][8]&"'")
				MsgBox(0,"Deleted","This alliances has been removed from your list of friendly alliances")
			EndIf
			SetMap($CurrX,$CurrY)
		Case 5
			;add pid to enemy player table
			_SQLite_GetTable2d($PersistentDB,"SELECT `type` FROM `EnemyPlayers` WHERE `pid` = '"&$VisVillages[$i][6]&"'",$aResult,$iRows,$iCols)
			If $iRows > 0 Then
				$temp=$aResult[1][0]
			Else
				$temp=""
			EndIf
			$temp=InputBox("Type of enemy player","What kind of enemy player is this?"&@CRLF&@CRLF&"Farm, 0-pop or troop denial"&@CRLF&"are good examples of what to put here",$temp)
			If NOT @error AND $temp <> "" Then
				_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `EnemyPlayers` VALUES('"&$VisVillages[$i][6]&"',"&_SQLite_Escape($temp)&")")
				MsgBox(0,"Done","Villages belonging to "&$VisVillages[$i][7]&" will be treated as an enemy")
			Else
				_SQLite_Exec($PersistentDB,"DELETE FROM `EnemyPlayers` WHERE `pid` = '"&$VisVillages[$i][6]&"'")
				MsgBox(0,"Deleted","This player has been removed from your list of enemies")
			EndIf
			SetMap($CurrX,$CurrY)
		Case 6
			;add aid to enemy alliance table
			_SQLite_GetTable2d($PersistentDB,"SELECT `type` FROM `EnemyAlliances` WHERE `aid` = '"&$VisVillages[$i][8]&"'",$aResult,$iRows,$iCols)
			If $iRows > 0 Then
				$temp=$aResult[1][0]
			Else
				$temp=""
			EndIf
			$temp=InputBox("Type of enemy alliance","What kind of enemy alliance is this?"&@CRLF&@CRLF&"War, defensive or invaders"&@CRLF&"are good examples of what to put here",$Temp)
			If NOT @error AND $temp <> "" Then
				_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `EnemyAlliances` VALUES('"&$VisVillages[$i][8]&"',"&_SQLite_Escape($temp)&")")
				MsgBox(0,"Done","Players belonging to "&$VisVillages[$i][9]&" will be treated as enemies")
			Else
				_SQLite_Exec($PersistentDB,"DELETE FROM `EnemyAlliances` WHERE `pid` = '"&$VisVillages[$i][8]&"'")
				MsgBox(0,"Deleted","This alliance has been removed from your list of enemies")
			EndIf
			SetMap($CurrX,$CurrY)
		Case 7
			;add note to this vid
			_SQLite_GetTable2d($PersistentDB,"SELECT `note` FROM `VillageNotes` WHERE `vid` = '"&$VisVillages[$i][4]&"'",$aResult,$iRows,$iCols)
			If $iRows > 0 Then
				$temp=$aResult[1][0]
			Else
				$temp=""
			EndIf
			$temp=InputBox("Note","Please type the note you wish to attach to this VILLAGE below:",$temp)
			If NOT @error AND $temp <> "" Then
				_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `VillageNotes` VALUES('"&$VisVillages[$i][4]&"',"&_SQLite_Escape($temp)&")")
				MsgBox(0,"Done","Note has been attached to "&$VisVillages[$i][5])
			Else
				_SQLite_Exec($PersistentDB,"DELETE FROM `VillageNotes` WHERE `vid` = '"&$VisVillages[$i][4]&"'")
				MsgBox(0,"Deleted","Note has been removed from "&$VisVillages[$i][5])
			EndIf
			SetMap($CurrX,$CurrY)
		Case 8
			;add note to this pid
			_SQLite_GetTable2d($PersistentDB,"SELECT `note` FROM `PlayerNotes` WHERE `pid` = '"&$VisVillages[$i][6]&"'",$aResult,$iRows,$iCols)
			If $iRows > 0 Then
				$temp=$aResult[1][0]
			Else
				$temp=""
			EndIf
			$temp=InputBox("Note","Please type the note you wish to attach to all this player's villages below:",$temp)
			If NOT @error AND $temp <> "" Then
				_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `PlayerNotes` VALUES('"&$VisVillages[$i][6]&"',"&_SQLite_Escape($temp)&")")
				MsgBox(0,"Done","Note has been attached to all villages owned by "&$VisVillages[$i][7])
			Else
				_SQLite_Exec($PersistentDB,"DELETE FROM `PlayerNotes` WHERE `pid` = '"&$VisVillages[$i][6]&"'")
				MsgBox(0,"Deleted","Note has been removed from "&$VisVillages[$i][7])
			EndIf
			SetMap($CurrX,$CurrY)
		Case 9
			;add note to this aid
			_SQLite_GetTable2d($PersistentDB,"SELECT `note` FROM `AllianceNotes` WHERE `aid` = '"&$VisVillages[$i][8]&"'",$aResult,$iRows,$iCols)
			If $iRows > 0 Then
				$temp=$aResult[1][0]
			Else
				$temp=""
			EndIf
			$temp=InputBox("Note","Please type the note you wish to attach to members of this ALLIANCE below:",$Temp)
			If NOT @error AND $temp <> "" Then
				_SQLite_Exec($PersistentDB,"INSERT OR REPLACE into `AllianceNotes` VALUES('"&$VisVillages[$i][8]&"',"&_SQLite_Escape($temp)&")")
				MsgBox(0,"Done","Note has been attached to "&$VisVillages[$i][9])
			Else
				_SQLite_Exec($PersistentDB,"DELETE FROM `AllianceNotes` WHERE `aid` = '"&$VisVillages[$i][8]&"'")
				MsgBox(0,"Deleted","Note has been removed from members of the alliance "&$VisVillages[$i][9])
			EndIf
			SetMap($CurrX,$CurrY)
	EndSwitch
EndFunc

Func PopulateFavorites()
	_SQLite_GetTable2d($PersistentDB,"Select * from `Favorites`",$aResult,$iRows,$iCols)
	$FavoriteString="|"
	For $i=1 To $iRows
		$FavoriteString&="|"&$aResult[$i][2]
	Next
	GUICtrlSetData($FavoritesList,$FavoriteString)
EndFunc

Func GotoView()
	If $Navigating Then Return
	$Navigating =1
	Local $ViewName=GUICtrlRead(@GUI_CtrlId)
	_SQLite_GetTable2d($PersistentDB,"SELECT * FROM `Favorites` WHERE `name` = "&_SQLite_Escape(GUICtrlRead(@GUI_CTRLID)),$aResult,$iRows,$iCols)
	If $iRows > 0 Then SetMap($aResult[1][0],$aResult[1][1])
	PopulateFavorites()
	$Navigating =0
EndFunc

Func ListPlayerVillages()
	Local $lResult, $lRows, $lCols
	GUICtrlSetData($VillageList,"")
	If GUICtrlRead($PlayerCombo) = "" Then Return
	_SQLite_GetTable2d($MemDB,"SELECT `village` from `x_world` where `player` = "&_SQLite_Escape(GUICtrlRead($PlayerCombo)),$lResult,$lRows,$lCols)
	Local $VillageString="|"
	For $i=1 To $lRows
		$VillageString&=$lResult[$i][0]&"|"
	Next
	GUICtrlSetData($VillageList,$VillageString)
EndFunc

Func ClickPlayerVillage()
	If $Navigating Then Return
	$Navigating=1
	_SQLite_GetTable2d($MemDB,"SELECT `x`,`y`,`player`,`village` from `x_world` where `player` = "&_SQLite_Escape(GUICtrlRead($PlayerCombo))&" AND `village` = "&_SQLite_Escape(GUICtrlRead($VillageList)),$aResult,$iRows,$iCols)
	If $iRows > 0 Then SetMap($aResult[1][0]-6,$aResult[1][1]-6)
	$Navigating=0
EndFunc

Func ShowCenteredPlayer()
	_SQLite_GetTable2d($MemDB,"Select `player`,`village` from `x_world` where x="&$CurrX+6&" AND y="&$CurrY+6,$aResult,$iRows,$iCols)
	If $iRows > 0 Then
		_GUICtrlComboSetCurSel($PlayerCombo,_GUICtrlComboFindString($PlayerCombo,$aResult[1][0],1))
		ListPlayerVillages()
		GUICtrlSetData($VillageList,$aResult[1][1])
	Else
		_GUICtrlComboSelectString($PlayerCombo,-1," ")
		GUICtrlSetData($VillageList,"")
	EndIf
EndFunc

Func CenterOnClicked()
	If $Navigating Then Return
	$Navigating=1
	For $i=1 To UBound($Villages)
		If $Villages[$i-1]=@GUI_CtrlId Then ExitLoop
	Next
	SetMap($VisVillages[$i][1]-6,$VisVillages[$i][2]-6)
	$Navigating=0
EndFunc

Func Exiter()
	_SQLite_Close($MemDB)
	_SQLite_Close($PersistentDB)
	_SQLite_Shutdown()
	Exit
EndFunc

Func WritePics() ; Dont Tidy me!
	If NOT FileExists(@TempDir&"\c00.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c00.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF000B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADA0B0B0000000B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADBDBDBDBDADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADAD3DBDBDAAFA77CAEAEA17C7CA8D3DBDBD3DADADADADADADADADADADADADADA0000000B0BDADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA0000000B0BDADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA0000000B0BDADADADADADADADBD3D3F7CBA07C7CA1A7A07C7C7CCCD3D3AEAEDADADADADADADADADADADA0B0B000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADA0B0B000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADA0B0B000000DADADADADADADADADB84AEAFAFD3D0D0F4F4F4F4D0A0A8F7FDAEAEAEAEDBDADADADADADADADADA0B0B000000DADADADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADADADA0000000B0BDADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADA"
		$sData&="DADA0000000B0BDADADADADADADBAEA7A8A1A0A0CAD0D2FDFDFDFDFDFDF7AEAFAEAEDBDADADADADADADADADADADA0000000B0BDADADADADAAEDAD385A8A8A1A0A0A0CCF7F7F7D3F7FDFDAEAFAE84DBDADADADADADADADADADADA0000000B0BDADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADA0B0B000000DADADADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADA0B0B000000DADADADADADADADAAEA17CA8D0F4D0CACCA8A8CCA1A1A8A17CF7D3DBDADADADADADADADADADADA0B0B000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADA0B0B000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADADADA0000000B0BDADADADADADADADA8584CBCBA8D3A8D0F4F4D0D0A0A8DBDAD3DADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADAD3D3D3D3AEAFD3D3DADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0B0000000B0BDADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0B000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c01.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c01.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF0065656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADA656500000065656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADBDBDBDBDADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADADADA0000006565DADADADADADADADAD3DBDBDAAFA77CAEAEA17C7CA8D3DBDBD3DADADADADADADADADADADADADADA0000006565DADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA0000006565DADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA0000006565DADADADADADADADBD3D3F7CBA07C7CA1A7A07C7C7CCCD3D3AEAEDADADADADADADADADADADA6565000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADA6565000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADA6565000000DADADADADADADADADB84AEAFAFD3D0D0F4F4F4F4D0A0A8F7FDAEAEAEAEDBDADADADADADADADADA6565000000DADADADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADADADA0000006565DADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADA"
		$sData&="DADA0000006565DADADADADADADBAEA7A8A1A0A0CAD0D2FDFDFDFDFDFDF7AEAFAEAEDBDADADADADADADADADADADA0000006565DADADADADAAEDAD385A8A8A1A0A0A0CCF7F7F7D3F7FDFDAEAFAE84DBDADADADADADADADADADADA0000006565DADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADA6565000000DADADADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADA6565000000DADADADADADADADAAEA17CA8D0F4D0CACCA8A8CCA1A1A8A17CF7D3DBDADADADADADADADADADADA6565000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADA6565000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADADADA0000006565DADADADADADADADA8584CBCBA8D3A8D0F4F4D0D0A0A8DBDAD3DADADADADADADADADADADADADADA0000006565DADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA0000006565DADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADAD3D3D3D3AEAFD3D3DADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA656565650000006565DADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c02.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c02.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00E3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADAE3E3000000E3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADBDBDBDBDADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADAD3DBDBDAAFA77CAEAEA17C7CA8D3DBDBD3DADADADADADADADADADADADADADA000000E3E3DADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA000000E3E3DADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA000000E3E3DADADADADADADADBD3D3F7CBA07C7CA1A7A07C7C7CCCD3D3AEAEDADADADADADADADADADADAE3E3000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADAE3E3000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADAE3E3000000DADADADADADADADADB84AEAFAFD3D0D0F4F4F4F4D0A0A8F7FDAEAEAEAEDBDADADADADADADADADAE3E3000000DADADADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADADADA000000E3E3DADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADA"
		$sData&="DADA000000E3E3DADADADADADADBAEA7A8A1A0A0CAD0D2FDFDFDFDFDFDF7AEAFAEAEDBDADADADADADADADADADADA000000E3E3DADADADADAAEDAD385A8A8A1A0A0A0CCF7F7F7D3F7FDFDAEAFAE84DBDADADADADADADADADADADA000000E3E3DADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADAE3E3000000DADADADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADAE3E3000000DADADADADADADADAAEA17CA8D0F4D0CACCA8A8CCA1A1A8A17CF7D3DBDADADADADADADADADADADAE3E3000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADAE3E3000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADADADA000000E3E3DADADADADADADADA8584CBCBA8D3A8D0F4F4D0D0A0A8DBDAD3DADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADAD3D3D3D3AEAFD3D3DADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3000000E3E3DADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c03.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c03.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF005D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADA5D5D0000005D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADBDBDBDBDADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADAD3DBDBDAAFA77CAEAEA17C7CA8D3DBDBD3DADADADADADADADADADADADADADA0000005D5DDADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA0000005D5DDADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA0000005D5DDADADADADADADADBD3D3F7CBA07C7CA1A7A07C7C7CCCD3D3AEAEDADADADADADADADADADADA5D5D000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADA5D5D000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADA5D5D000000DADADADADADADADADB84AEAFAFD3D0D0F4F4F4F4D0A0A8F7FDAEAEAEAEDBDADADADADADADADADA5D5D000000DADADADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADADADA0000005D5DDADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADA"
		$sData&="DADA0000005D5DDADADADADADADBAEA7A8A1A0A0CAD0D2FDFDFDFDFDFDF7AEAFAEAEDBDADADADADADADADADADADA0000005D5DDADADADADAAEDAD385A8A8A1A0A0A0CCF7F7F7D3F7FDFDAEAFAE84DBDADADADADADADADADADADA0000005D5DDADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADA5D5D000000DADADADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADA5D5D000000DADADADADADADADAAEA17CA8D0F4D0CACCA8A8CCA1A1A8A17CF7D3DBDADADADADADADADADADADA5D5D000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADA5D5D000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADADADA0000005D5DDADADADADADADADA8584CBCBA8D3A8D0F4F4D0D0A0A8DBDAD3DADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADAD3D3D3D3AEAFD3D3DADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5D0000005D5DDADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5D000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c04.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c04.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00CECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADACECE000000CECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADBDBDBDBDADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADBDBD3AED3AFCCA8DADBDBDBDADADADADADADADADADADADADADADADA000000CECEDADADADADADADADAD3DBDBDAAFA77CAEAEA17C7CA8D3DBDBD3DADADADADADADADADADADADADADA000000CECEDADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA000000CECEDADADADADADADAD3FDF7A78484A1A784A1A07C7C7CCAA8D3D3DADADADADADADADADADADADADADA000000CECEDADADADADADADADBD3D3F7CBA07C7CA1A7A07C7C7CCCD3D3AEAEDADADADADADADADADADADACECE000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADACECE000000DADADADADADADADADBDA84D3D3D3A1A0CAD0F4D0A07C7CF7FDAFAEAFAEDADADADADADADADADADACECE000000DADADADADADADADADB84AEAFAFD3D0D0F4F4F4F4D0A0A8F7FDAEAEAEAEDBDADADADADADADADADACECE000000DADADADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADADADA000000CECEDADADADADADADB84A7A1A1CACAF4F4F4D0CBF7F7F7F7F7AEAFAEAEDBDADADADADADADADADA"
		$sData&="DADA000000CECEDADADADADADADBAEA7A8A1A0A0CAD0D2FDFDFDFDFDFDF7AEAFAEAEDBDADADADADADADADADADADA000000CECEDADADADADAAEDAD385A8A8A1A0A0A0CCF7F7F7D3F7FDFDAEAFAE84DBDADADADADADADADADADADA000000CECEDADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADACECE000000DADADADADADADADAAF8585A8D3D3A1A1CCD3D3D3A87CA1D3FDD3AEAEDBDADADADADADADADADADACECE000000DADADADADADADADAAEA17CA8D0F4D0CACCA8A8CCA1A1A8A17CF7D3DBDADADADADADADADADADADACECE000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADACECE000000DADADADADADADADADA85A1CAF4F4F4CAA0CBD0F4D0A1A1A1A8DAFDD3DADADADADADADADADADADADADA000000CECEDADADADADADADADA8584CBCBA8D3A8D0F4F4D0D0A0A8DBDAD3DADADADADADADADADADADADADADA000000CECEDADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADAAEA8D3D3D3AFD0D0A8A7A1AEAEAEDADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADAD3D3D3D3AEAFD3D3DADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECE000000CECEDADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECE000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c10.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c10.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF000B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADA0B0B0000000B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADBDADADAB0B0B0B0D3D3B0DADADBDADADADADADADADADADADADA0B0B000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADA0B0B000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADADADA0000000B0BDADADADADADADAD3FDD3AE83AEAEA7A77DA8D37DA07C7CA7AFD3FDDADADADADADADADADADADADA0000000B0BDADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA0000000B0BDADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA0000000B0BDADADADADADADAD3AEAFD3FDD3AFAFA7CACAF4F4CA7C7CA8D3A7CBAEAFDADADADADADADADA0B0B000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADA0B0B000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADA0B0B000000DADADADADADADADAA8A7A7CAF4CA7DA87D7DA7CACACAD3D3AEA9A8A0A0A7A7AFDBDADADADADADA0B0B000000DADADADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADADADA0000000B0BDADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADA"
		$sData&="DADA0000000B0BDADADADADADADAAEAECAF4A8CBA7A8D3FDFDFDFDFDA97DA8D1D1A7AEAEAEDBDADADADADADADADA0000000B0BDADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADADADA0000000B0BDADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADA0B0B000000DADADADADADADADADADAAEAE7CD3D3A7A7D3D3D3D3D3A8A8A8A8CAD1AEAEAEDBD4DADADADADADA0B0B000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADA0B0B000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADA0B0B000000DADADADADADADADADAAEDAA97DD3D3D3A7A77DD2D1CA7DA8A9A77CA8FDD3DADADADADADADADADADADA0000000B0BDADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA0000000B0BDADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA0000000B0BDADADADADADADADADAD3A7F4F4CAA8A7D1F4F4F4F4CA7DD3D4DADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0B0000000B0BDADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0B000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c11.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c11.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF0065656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADA656500000065656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADBDADADAB0B0B0B0D3D3B0DADADBDADADADADADADADADADADADA6565000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADA6565000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADADADA0000006565DADADADADADADAD3FDD3AE83AEAEA7A77DA8D37DA07C7CA7AFD3FDDADADADADADADADADADADADA0000006565DADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA0000006565DADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA0000006565DADADADADADADAD3AEAFD3FDD3AFAFA7CACAF4F4CA7C7CA8D3A7CBAEAFDADADADADADADADA6565000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADA6565000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADA6565000000DADADADADADADADAA8A7A7CAF4CA7DA87D7DA7CACACAD3D3AEA9A8A0A0A7A7AFDBDADADADADADA6565000000DADADADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADADADA0000006565DADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADA"
		$sData&="DADA0000006565DADADADADADADAAEAECAF4A8CBA7A8D3FDFDFDFDFDA97DA8D1D1A7AEAEAEDBDADADADADADADADA0000006565DADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADADADA0000006565DADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADA6565000000DADADADADADADADADADAAEAE7CD3D3A7A7D3D3D3D3D3A8A8A8A8CAD1AEAEAEDBD4DADADADADADA6565000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADA6565000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADA6565000000DADADADADADADADADAAEDAA97DD3D3D3A7A77DD2D1CA7DA8A9A77CA8FDD3DADADADADADADADADADADA0000006565DADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA0000006565DADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA0000006565DADADADADADADADADAD3A7F4F4CAA8A7D1F4F4F4F4CA7DD3D4DADADADADADADADADADADADADADA0000006565DADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA656565650000006565DADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c12.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c12.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00E3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADAE3E3000000E3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADBDADADAB0B0B0B0D3D3B0DADADBDADADADADADADADADADADADAE3E3000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADAE3E3000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADADADA000000E3E3DADADADADADADAD3FDD3AE83AEAEA7A77DA8D37DA07C7CA7AFD3FDDADADADADADADADADADADADA000000E3E3DADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA000000E3E3DADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA000000E3E3DADADADADADADAD3AEAFD3FDD3AFAFA7CACAF4F4CA7C7CA8D3A7CBAEAFDADADADADADADADAE3E3000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADAE3E3000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADAE3E3000000DADADADADADADADAA8A7A7CAF4CA7DA87D7DA7CACACAD3D3AEA9A8A0A0A7A7AFDBDADADADADADAE3E3000000DADADADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADADADA000000E3E3DADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADA"
		$sData&="DADA000000E3E3DADADADADADADAAEAECAF4A8CBA7A8D3FDFDFDFDFDA97DA8D1D1A7AEAEAEDBDADADADADADADADA000000E3E3DADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADADADA000000E3E3DADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADAE3E3000000DADADADADADADADADADAAEAE7CD3D3A7A7D3D3D3D3D3A8A8A8A8CAD1AEAEAEDBD4DADADADADADAE3E3000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADAE3E3000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADAE3E3000000DADADADADADADADADAAEDAA97DD3D3D3A7A77DD2D1CA7DA8A9A77CA8FDD3DADADADADADADADADADADA000000E3E3DADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA000000E3E3DADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA000000E3E3DADADADADADADADADAD3A7F4F4CAA8A7D1F4F4F4F4CA7DD3D4DADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3000000E3E3DADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c13.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c13.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF005D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADA5D5D0000005D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADBDADADAB0B0B0B0D3D3B0DADADBDADADADADADADADADADADADA5D5D000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADA5D5D000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADADADA0000005D5DDADADADADADADAD3FDD3AE83AEAEA7A77DA8D37DA07C7CA7AFD3FDDADADADADADADADADADADADA0000005D5DDADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA0000005D5DDADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA0000005D5DDADADADADADADAD3AEAFD3FDD3AFAFA7CACAF4F4CA7C7CA8D3A7CBAEAFDADADADADADADADA5D5D000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADA5D5D000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADA5D5D000000DADADADADADADADAA8A7A7CAF4CA7DA87D7DA7CACACAD3D3AEA9A8A0A0A7A7AFDBDADADADADADA5D5D000000DADADADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADADADA0000005D5DDADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADA"
		$sData&="DADA0000005D5DDADADADADADADAAEAECAF4A8CBA7A8D3FDFDFDFDFDA97DA8D1D1A7AEAEAEDBDADADADADADADADA0000005D5DDADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADADADA0000005D5DDADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADA5D5D000000DADADADADADADADADADAAEAE7CD3D3A7A7D3D3D3D3D3A8A8A8A8CAD1AEAEAEDBD4DADADADADADA5D5D000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADA5D5D000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADA5D5D000000DADADADADADADADADAAEDAA97DD3D3D3A7A77DD2D1CA7DA8A9A77CA8FDD3DADADADADADADADADADADA0000005D5DDADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA0000005D5DDADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA0000005D5DDADADADADADADADADAD3A7F4F4CAA8A7D1F4F4F4F4CA7DD3D4DADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5D0000005D5DDADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5D000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c14.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c14.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00CECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADACECE000000CECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADBDADBDADADBDBDBDADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADBDADADAB0B0B0B0D3D3B0DADADBDADADADADADADADADADADADACECE000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADACECE000000DADADADADADADADADADAD3DAB0AEAEAEAEAEA7A8AF83A07DA8A8AFD3D3DADADADADADADADADADADADA000000CECEDADADADADADADAD3FDD3AE83AEAEA7A77DA8D37DA07C7CA7AFD3FDDADADADADADADADADADADADA000000CECEDADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA000000CECEDADADADADADAB0DAD3D3FDAFAEAEA7A07CA0A0A7A07C7CA8D3FDAED3DADADADADADADADADADADA000000CECEDADADADADADADAD3AEAFD3FDD3AFAFA7CACAF4F4CA7C7CA8D3A7CBAEAFDADADADADADADADACECE000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADACECE000000DADADADADADADAD3DAA8A8A97DA87DA87DA0F4F4F4CAA7A0A7A87DA7CA7C7CD3DADADADADADADACECE000000DADADADADADADADAA8A7A7CAF4CA7DA87D7DA7CACACAD3D3AEA9A8A0A0A7A7AFDBDADADADADADACECE000000DADADADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADADADA000000CECEDADADADADADBD3A7CAF4F4F4CAD3D3D3D3FDFDD3FDD3A9A9A8A87CA0AEAEDBDADADADADADA"
		$sData&="DADA000000CECEDADADADADADADAAEAECAF4A8CBA7A8D3FDFDFDFDFDA97DA8D1D1A7AEAEAEDBDADADADADADADADA000000CECEDADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADADADA000000CECEDADADADADAB0DBAEAEA77CA8A8A0A0A7FDFDFDFDFDA87DA7F4F4CAAEAEAEDBDADADADADADACECE000000DADADADADADADADADADAAEAE7CD3D3A7A7D3D3D3D3D3A8A8A8A8CAD1AEAEAEDBD4DADADADADADACECE000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADACECE000000DADADADADADADADAAEDADAAEA8D3D3D3A8D2A8D37DA8A87D7D7D7DA8D3D3DBDADADADADADADADACECE000000DADADADADADADADADAAEDAA97DD3D3D3A7A77DD2D1CA7DA8A9A77CA8FDD3DADADADADADADADADADADA000000CECEDADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA000000CECEDADADADADADADADAAED3A7D1D1D1A7A0F4F4F4F4CA7D7DA7D3DBDADADADADADADADADADADADADA000000CECEDADADADADADADADADAD3A7F4F4CAA8A7D1F4F4F4F4CA7DD3D4DADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADAD3D3D3D3D3AFF4F4CBA9D3DADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECE000000CECEDADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECE000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c20.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c20.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF000B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADA0B0B0000000B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADBDBDBDBDBDBDBDBDBDADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA0000000B0BDADADADADADADADADADA7EA9A8A8CCCCA9A9A9A9A9A9D3D3A907DADBDADADADADADADADADADADA0000000B0BDADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADA0B0B000000DADADADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADA0B0B000000DADADADADADADADAD3AFA9A8A77DAEAEA7A0A07DAFAFAFAFAFAFA9D3A8D2A7A7DADADADADADADA0B0B000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADA0B0B000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADADADA0000000B0BDADADADADA07A9D3D3D3CAD0F4F4F4CAA0CC7D7D0707A77D07D3FED307A6CAA707DADADADADADA0000000B0BDADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA0000000B0BDADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA0000000B0BDADADA07A8AFD3D9DADAFEF4F4D2FED3D3FED307A7A007A9CCD307D3CCA0A0CAA7AFDADADA0B0B000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADA0B0B000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADA0B0B000000DADADADADBA908AF84AFAFFEFEFED3D3A7D2FEFEA7A0A0A07DF7D37E7EA7F4F4D0D9D3A8DADADA0B0B000000DADADADADBA908D3D3DAFED2A7A8CCA7A7A7A7A7FEFEF7CCD3D37EA807D0F4F4A7D9D3A9DADADADADA0000000B0BDADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADA"
		$sData&="DADA0000000B0BDADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADADADA0000000B0BDADADA07AFD3D3D9D3D2CAD0F4F4D0A6D2D3FED3D3D3D3FEFEAEF7A97DD3CAA07DA9DADADADADA0000000B0BDADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADA0B0B000000DADADADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADA0B0B000000DADADADADADA07A9AFAFA8A87DA7D2AFAFD3CAA7A7F4D0A7A7CC7DA9AFD3A9D3D3CCA8DBDADADA0B0B000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADA0B0B000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADADADA0000000B0BDADADADADADADAA7D2D3CACACCA9AFD3AEA7D0F4F4F4D0A7D3D3D3AFCAF4F4DADADADADADADADA0000000B0BDADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA0000000B0BDADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA0000000B0BDADADADADADADA7DCCD2D3A8D3D3A9A9AFAFAFAEAFA884AEA8A8A908DADADADADADADADADA0B0B000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADAD9D9D9D9D4D4AFAEDADADADADADADADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000000B0BDADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0B0000000B0BDADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0B000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c21.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c21.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF0065656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADA656500000065656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADBDBDBDBDBDBDBDBDBDADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA0000006565DADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA0000006565DADADADADADADADADADA7EA9A8A8CCCCA9A9A9A9A9A9D3D3A907DADBDADADADADADADADADADADA0000006565DADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADA6565000000DADADADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADA6565000000DADADADADADADADAD3AFA9A8A77DAEAEA7A0A07DAFAFAFAFAFAFA9D3A8D2A7A7DADADADADADADA6565000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADA6565000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADADADA0000006565DADADADADA07A9D3D3D3CAD0F4F4F4CAA0CC7D7D0707A77D07D3FED307A6CAA707DADADADADADA0000006565DADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA0000006565DADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA0000006565DADADA07A8AFD3D9DADAFEF4F4D2FED3D3FED307A7A007A9CCD307D3CCA0A0CAA7AFDADADA6565000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADA6565000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADA6565000000DADADADADBA908AF84AFAFFEFEFED3D3A7D2FEFEA7A0A0A07DF7D37E7EA7F4F4D0D9D3A8DADADA6565000000DADADADADBA908D3D3DAFED2A7A8CCA7A7A7A7A7FEFEF7CCD3D37EA807D0F4F4A7D9D3A9DADADADADA0000006565DADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADA"
		$sData&="DADA0000006565DADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADADADA0000006565DADADA07AFD3D3D9D3D2CAD0F4F4D0A6D2D3FED3D3D3D3FEFEAEF7A97DD3CAA07DA9DADADADADA0000006565DADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADA6565000000DADADADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADA6565000000DADADADADADA07A9AFAFA8A87DA7D2AFAFD3CAA7A7F4D0A7A7CC7DA9AFD3A9D3D3CCA8DBDADADA6565000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADA6565000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADADADA0000006565DADADADADADADAA7D2D3CACACCA9AFD3AEA7D0F4F4F4D0A7D3D3D3AFCAF4F4DADADADADADADADA0000006565DADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA0000006565DADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA0000006565DADADADADADADA7DCCD2D3A8D3D3A9A9AFAFAFAEAFA884AEA8A8A908DADADADADADADADADA6565000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADA6565000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADAD9D9D9D9D4D4AFAEDADADADADADADADADADADADADADADADADA6565000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000006565DADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA656565650000006565DADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c22.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c22.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00E3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADAE3E3000000E3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADBDBDBDBDBDBDBDBDBDADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA000000E3E3DADADADADADADADADADA7EA9A8A8CCCCA9A9A9A9A9A9D3D3A907DADBDADADADADADADADADADADA000000E3E3DADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADAE3E3000000DADADADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADAE3E3000000DADADADADADADADAD3AFA9A8A77DAEAEA7A0A07DAFAFAFAFAFAFA9D3A8D2A7A7DADADADADADADAE3E3000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADAE3E3000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADADADA000000E3E3DADADADADA07A9D3D3D3CAD0F4F4F4CAA0CC7D7D0707A77D07D3FED307A6CAA707DADADADADADA000000E3E3DADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA000000E3E3DADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA000000E3E3DADADA07A8AFD3D9DADAFEF4F4D2FED3D3FED307A7A007A9CCD307D3CCA0A0CAA7AFDADADAE3E3000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADAE3E3000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADAE3E3000000DADADADADBA908AF84AFAFFEFEFED3D3A7D2FEFEA7A0A0A07DF7D37E7EA7F4F4D0D9D3A8DADADAE3E3000000DADADADADBA908D3D3DAFED2A7A8CCA7A7A7A7A7FEFEF7CCD3D37EA807D0F4F4A7D9D3A9DADADADADA000000E3E3DADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADA"
		$sData&="DADA000000E3E3DADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADADADA000000E3E3DADADA07AFD3D3D9D3D2CAD0F4F4D0A6D2D3FED3D3D3D3FEFEAEF7A97DD3CAA07DA9DADADADADA000000E3E3DADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADAE3E3000000DADADADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADAE3E3000000DADADADADADA07A9AFAFA8A87DA7D2AFAFD3CAA7A7F4D0A7A7CC7DA9AFD3A9D3D3CCA8DBDADADAE3E3000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADAE3E3000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADADADA000000E3E3DADADADADADADAA7D2D3CACACCA9AFD3AEA7D0F4F4F4D0A7D3D3D3AFCAF4F4DADADADADADADADA000000E3E3DADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA000000E3E3DADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA000000E3E3DADADADADADADA7DCCD2D3A8D3D3A9A9AFAFAFAEAFA884AEA8A8A908DADADADADADADADADAE3E3000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADAD9D9D9D9D4D4AFAEDADADADADADADADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000E3E3DADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3000000E3E3DADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c23.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c23.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF005D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADA5D5D0000005D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADBDBDBDBDBDBDBDBDBDADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA0000005D5DDADADADADADADADADADA7EA9A8A8CCCCA9A9A9A9A9A9D3D3A907DADBDADADADADADADADADADADA0000005D5DDADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADA5D5D000000DADADADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADA5D5D000000DADADADADADADADAD3AFA9A8A77DAEAEA7A0A07DAFAFAFAFAFAFA9D3A8D2A7A7DADADADADADADA5D5D000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADA5D5D000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADADADA0000005D5DDADADADADA07A9D3D3D3CAD0F4F4F4CAA0CC7D7D0707A77D07D3FED307A6CAA707DADADADADADA0000005D5DDADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA0000005D5DDADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA0000005D5DDADADA07A8AFD3D9DADAFEF4F4D2FED3D3FED307A7A007A9CCD307D3CCA0A0CAA7AFDADADA5D5D000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADA5D5D000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADA5D5D000000DADADADADBA908AF84AFAFFEFEFED3D3A7D2FEFEA7A0A0A07DF7D37E7EA7F4F4D0D9D3A8DADADA5D5D000000DADADADADBA908D3D3DAFED2A7A8CCA7A7A7A7A7FEFEF7CCD3D37EA807D0F4F4A7D9D3A9DADADADADA0000005D5DDADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADA"
		$sData&="DADA0000005D5DDADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADADADA0000005D5DDADADA07AFD3D3D9D3D2CAD0F4F4D0A6D2D3FED3D3D3D3FEFEAEF7A97DD3CAA07DA9DADADADADA0000005D5DDADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADA5D5D000000DADADADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADA5D5D000000DADADADADADA07A9AFAFA8A87DA7D2AFAFD3CAA7A7F4D0A7A7CC7DA9AFD3A9D3D3CCA8DBDADADA5D5D000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADA5D5D000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADADADA0000005D5DDADADADADADADAA7D2D3CACACCA9AFD3AEA7D0F4F4F4D0A7D3D3D3AFCAF4F4DADADADADADADADA0000005D5DDADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA0000005D5DDADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA0000005D5DDADADADADADADA7DCCD2D3A8D3D3A9A9AFAFAFAEAFA884AEA8A8A908DADADADADADADADADA5D5D000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADAD9D9D9D9D4D4AFAEDADADADADADADADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0000005D5DDADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5D0000005D5DDADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5D000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c24.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c24.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00CECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADACECE000000CECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADBDBDBDBDBDBDBDBDBDADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADBDAD4AF0707077E7E7E0707DADBDBDADADADADADADADADADADADADA000000CECEDADADADADADADADADADA7EA9A8A8CCCCA9A9A9A9A9A9D3D3A907DADBDADADADADADADADADADADA000000CECEDADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADACECE000000DADADADADADADADADAD507A90707A7AEA7A67D7EAED3D3D3AFAFA807A907D5DADADADADADADADACECE000000DADADADADADADADAD3AFA9A8A77DAEAEA7A0A07DAFAFAFAFAFAFA9D3A8D2A7A7DADADADADADADACECE000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADACECE000000DADADADADADADAD3A8D3D3A87DA0A6CACAA0A07D7E7E077DA8A8D3FEFED3FE7EA9DADADADADADADADA000000CECEDADADADADA07A9D3D3D3CAD0F4F4F4CAA0CC7D7D0707A77D07D3FED307A6CAA707DADADADADADA000000CECEDADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA000000CECEDADADADB07A9AFD3DAFED2D0F4D0A7D3AF087D7D07A0A0A0A7D3A7A7A7CACAA0A7D5DADADADADA000000CECEDADADA07A8AFD3D9DADAFEF4F4D2FED3D3FED307A7A007A9CCD307D3CCA0A0CAA7AFDADADACECE000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADACECE000000DADADADADBA9AFAEAEAFAFFEF7FEFED3FEFEFEFEA7A7A0A0A7D2D30707A9D2D27DA7D3A8DADADACECE000000DADADADADBA908AF84AFAFFEFEFED3D3A7D2FEFEA7A0A0A07DF7D37E7EA7F4F4D0D9D3A8DADADACECE000000DADADADADBA908D3D3DAFED2A7A8CCA7A7A7A7A7FEFEF7CCD3D37EA807D0F4F4A7D9D3A9DADADADADA000000CECEDADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADA"
		$sData&="DADA000000CECEDADADBAF08D3D3DAAECACAF4F4F4A6A7A67DD3FEFEFEFEFED384AFD3A7A7A8A8AFA9DADADADADA000000CECEDADADA07AFD3D3D9D3D2CAD0F4F4D0A6D2D3FED3D3D3D3FEFEAEF7A97DD3CAA07DA9DADADADADA000000CECEDADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADACECE000000DADADADADAD5A9AFD3D3D9D9A9F4F4F4A7F4D2D3D3A8A8A77DA9D3FEF7A87DD3A7A0CA08DADADACECE000000DADADADADADA07A9AFAFA8A87DA7D2AFAFD3CAA7A7F4D0A7A7CC7DA9AFD3A9D3D3CCA8DBDADADACECE000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADACECE000000DADADADADADADA07A97DCCD2A6A0AFAFD3A9A6D0F4F4F4CAA7A6A7AFD3077ED3D3D3D5DADADADADADA000000CECEDADADADADADADAA7D2D3CACACCA9AFD3AEA7D0F4F4F4D0A7D3D3D3AFCAF4F4DADADADADADADADA000000CECEDADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA000000CECEDADADADADADAD307D3D3D3D3AFAFD3D3D3AFA7D0A707D0A7AFAFAFA9D0F4DADADADADADADADADA000000CECEDADADADADADADA7DCCD2D3A8D3D3A9A9AFAFAFAEAFA884AEA8A8A908DADADADADADADADADACECE000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADACECE000000DADADADADADADADADADADAF4F4A90808AFA9A9A9A9A9A9A9AFAFDADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADAD9D9D9D9D4D4AFAEDADADADADADADADADADADADADADADADADACECE000000DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA000000CECEDADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECE000000CECEDADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECE000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c30.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c30.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF000B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADA0B0B0000000B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADA0B0B000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADA0B0B000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADA0B0B000000DADADADADADADADADAD4D3D3D3A8A8A8A8A8A9A9AFAFAFAFA8A8A808D4DADADADADADADADADADADADA0000000B0BDADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA0000000B0BDADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA0000000B0BDADADADAAFA8A8A9D4D4A8A808A1A07DA8A8077D07A97DA8A808D3AFAFA8A8D3DADADADADADADA0000000B0BDADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADA0B0B000000DADADADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADA0B0B000000DADADADADAA8D3D3D3A8A0A0A0A6CACAA0A0A1FED3A1A0A8A1BEBECBD3FEFED3D3D27DA8DADADA0B0B000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADA0B0B000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADADADA0000000B0BDAAFA8D3A9A8AFD3CBCBD0F4D0CAD3FEFEFED3A8A1BEBEA8D2D3D3AFAFA8A0A6CAA8AFAFDADADA0000000B0BD4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA0000000B0BD4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA0000000B0B08A8A87D7DA1A17DA8A8FEFEFEFED37DA6CABEBEA8F7A8D3D30707A8A8F5F5CBDADAD4D4080B0B000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A808080B0B000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A808080B0B000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A80B0B000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A8DADA0000000B0BA9D4AFA0A0A1CBA8D3D3D3A8A8CCA1A8D3D3F7FED3FEFED3AF0884AEAED37DA6CABEBEA8A8"
		$sData&="DADA0000000B0B0808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA0000000B0B0808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA0000000B0BD4A8A8A8A8A1A8D3CBCBA6F4F4F4CAA1D2FED3AFD3A8A8D3D3D384FEFEAFA1F4A8F4CCAF080B0B000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D40B0B000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D40B0B000000DADADAD4A8CBD0D0D3D3A9A9D3F7F584AFFEA1CBA8F4D0A1A8CBA0D3D3FEFEA8A8D3A8CBA8A9D40B0B000000DADADADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA0000000B0BDADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA0000000B0BDADADAD4A87DCBD3A0A0A0FEFED3AFAF08A8D1F4F4F4D0A807A1AFAFAF07A1D3D3A808DADADADA0000000B0BDADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADADADA0000000B0BDADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADA0B0B000000DADADADADADAD4A9D3D3D3D3FEFEA9A9A9A8077DA8A9D3DAD3AF84A1A88484AFCCF4DADADADADA0B0B000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADA0B0B000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADA0B0B000000DADADADADADADADAF4F4F4F4A8A9A8A0F4F4D1A8A8AFA8A8A8845E5E5EDADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA0000000B0BDADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA0000000B0BDADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0B0000000B0BDADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0BDADADADA0B0B0B0B000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c31.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c31.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF0065656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADA656500000065656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADA6565000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADA6565000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADA6565000000DADADADADADADADADAD4D3D3D3A8A8A8A8A8A9A9AFAFAFAFA8A8A808D4DADADADADADADADADADADADA0000006565DADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA0000006565DADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA0000006565DADADADAAFA8A8A9D4D4A8A808A1A07DA8A8077D07A97DA8A808D3AFAFA8A8D3DADADADADADADA0000006565DADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADA6565000000DADADADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADA6565000000DADADADADAA8D3D3D3A8A0A0A0A6CACAA0A0A1FED3A1A0A8A1BEBECBD3FEFED3D3D27DA8DADADA6565000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADA6565000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADADADA0000006565DAAFA8D3A9A8AFD3CBCBD0F4D0CAD3FEFEFED3A8A1BEBEA8D2D3D3AFAFA8A0A6CAA8AFAFDADADA0000006565D4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA0000006565D4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA000000656508A8A87D7DA1A17DA8A8FEFEFEFED37DA6CABEBEA8F7A8D3D30707A8A8F5F5CBDADAD4D4086565000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A808086565000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A808086565000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A86565000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A8DADA0000006565A9D4AFA0A0A1CBA8D3D3D3A8A8CCA1A8D3D3F7FED3FEFED3AF0884AEAED37DA6CABEBEA8A8"
		$sData&="DADA00000065650808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA00000065650808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA0000006565D4A8A8A8A8A1A8D3CBCBA6F4F4F4CAA1D2FED3AFD3A8A8D3D3D384FEFEAFA1F4A8F4CCAF086565000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D46565000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D46565000000DADADAD4A8CBD0D0D3D3A9A9D3F7F584AFFEA1CBA8F4D0A1A8CBA0D3D3FEFEA8A8D3A8CBA8A9D46565000000DADADADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA0000006565DADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA0000006565DADADAD4A87DCBD3A0A0A0FEFED3AFAF08A8D1F4F4F4D0A807A1AFAFAF07A1D3D3A808DADADADA0000006565DADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADADADA0000006565DADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADA6565000000DADADADADADAD4A9D3D3D3D3FEFEA9A9A9A8077DA8A9D3DAD3AF84A1A88484AFCCF4DADADADADA6565000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADA6565000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADA6565000000DADADADADADADADAF4F4F4F4A8A9A8A0F4F4D1A8A8AFA8A8A8845E5E5EDADADADADADADADADADADADA0000006565DADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA0000006565DADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA0000006565DADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA656565650000006565DADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565DADADADA65656565000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c32.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c32.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00E3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADAE3E3000000E3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADAE3E3000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADAE3E3000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADAE3E3000000DADADADADADADADADAD4D3D3D3A8A8A8A8A8A9A9AFAFAFAFA8A8A808D4DADADADADADADADADADADADA000000E3E3DADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA000000E3E3DADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA000000E3E3DADADADAAFA8A8A9D4D4A8A808A1A07DA8A8077D07A97DA8A808D3AFAFA8A8D3DADADADADADADA000000E3E3DADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADAE3E3000000DADADADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADAE3E3000000DADADADADAA8D3D3D3A8A0A0A0A6CACAA0A0A1FED3A1A0A8A1BEBECBD3FEFED3D3D27DA8DADADAE3E3000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADAE3E3000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADADADA000000E3E3DAAFA8D3A9A8AFD3CBCBD0F4D0CAD3FEFEFED3A8A1BEBEA8D2D3D3AFAFA8A0A6CAA8AFAFDADADA000000E3E3D4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA000000E3E3D4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA000000E3E308A8A87D7DA1A17DA8A8FEFEFEFED37DA6CABEBEA8F7A8D3D30707A8A8F5F5CBDADAD4D408E3E3000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A80808E3E3000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A80808E3E3000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A8E3E3000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A8DADA000000E3E3A9D4AFA0A0A1CBA8D3D3D3A8A8CCA1A8D3D3F7FED3FEFED3AF0884AEAED37DA6CABEBEA8A8"
		$sData&="DADA000000E3E30808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA000000E3E30808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA000000E3E3D4A8A8A8A8A1A8D3CBCBA6F4F4F4CAA1D2FED3AFD3A8A8D3D3D384FEFEAFA1F4A8F4CCAF08E3E3000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D4E3E3000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D4E3E3000000DADADAD4A8CBD0D0D3D3A9A9D3F7F584AFFEA1CBA8F4D0A1A8CBA0D3D3FEFEA8A8D3A8CBA8A9D4E3E3000000DADADADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA000000E3E3DADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA000000E3E3DADADAD4A87DCBD3A0A0A0FEFED3AFAF08A8D1F4F4F4D0A807A1AFAFAF07A1D3D3A808DADADADA000000E3E3DADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADADADA000000E3E3DADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADAE3E3000000DADADADADADAD4A9D3D3D3D3FEFEA9A9A9A8077DA8A9D3DAD3AF84A1A88484AFCCF4DADADADADAE3E3000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADAE3E3000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADAE3E3000000DADADADADADADADAF4F4F4F4A8A9A8A0F4F4D1A8A8AFA8A8A8845E5E5EDADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA000000E3E3DADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA000000E3E3DADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3000000E3E3DADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3DADADADAE3E3E3E3000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c33.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c33.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF005D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADA5D5D0000005D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADA5D5D000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADA5D5D000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADA5D5D000000DADADADADADADADADAD4D3D3D3A8A8A8A8A8A9A9AFAFAFAFA8A8A808D4DADADADADADADADADADADADA0000005D5DDADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA0000005D5DDADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA0000005D5DDADADADAAFA8A8A9D4D4A8A808A1A07DA8A8077D07A97DA8A808D3AFAFA8A8D3DADADADADADADA0000005D5DDADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADA5D5D000000DADADADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADA5D5D000000DADADADADAA8D3D3D3A8A0A0A0A6CACAA0A0A1FED3A1A0A8A1BEBECBD3FEFED3D3D27DA8DADADA5D5D000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADA5D5D000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADADADA0000005D5DDAAFA8D3A9A8AFD3CBCBD0F4D0CAD3FEFEFED3A8A1BEBEA8D2D3D3AFAFA8A0A6CAA8AFAFDADADA0000005D5DD4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA0000005D5DD4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA0000005D5D08A8A87D7DA1A17DA8A8FEFEFEFED37DA6CABEBEA8F7A8D3D30707A8A8F5F5CBDADAD4D4085D5D000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A808085D5D000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A808085D5D000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A85D5D000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A8DADA0000005D5DA9D4AFA0A0A1CBA8D3D3D3A8A8CCA1A8D3D3F7FED3FEFED3AF0884AEAED37DA6CABEBEA8A8"
		$sData&="DADA0000005D5D0808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA0000005D5D0808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA0000005D5DD4A8A8A8A8A1A8D3CBCBA6F4F4F4CAA1D2FED3AFD3A8A8D3D3D384FEFEAFA1F4A8F4CCAF085D5D000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D45D5D000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D45D5D000000DADADAD4A8CBD0D0D3D3A9A9D3F7F584AFFEA1CBA8F4D0A1A8CBA0D3D3FEFEA8A8D3A8CBA8A9D45D5D000000DADADADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA0000005D5DDADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA0000005D5DDADADAD4A87DCBD3A0A0A0FEFED3AFAF08A8D1F4F4F4D0A807A1AFAFAF07A1D3D3A808DADADADA0000005D5DDADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADADADA0000005D5DDADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADA5D5D000000DADADADADADAD4A9D3D3D3D3FEFEA9A9A9A8077DA8A9D3DAD3AF84A1A88484AFCCF4DADADADADA5D5D000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADA5D5D000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADA5D5D000000DADADADADADADADAF4F4F4F4A8A9A8A0F4F4D1A8A8AFA8A8A8845E5E5EDADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA0000005D5DDADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA0000005D5DDADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5D0000005D5DDADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5DDADADADA5D5D5D5D000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
	If NOT FileExists(@TempDir&"\c34.bmp") Then
		Local $tempFile=FileOpen(@TempDir&"\c34.bmp",2)
		Local $sData=""
		$sData&="424D420B0000000000003604000028000000290000002900000001000800000000000C070000C40E0000C40E000000000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000330000006600000099000000CC000000FF00000000330000333300006633000099330000CC330000FF33000000660000336600006666000099660000CC660000FF66000000990000339900006699000099990000CC990000FF99000000CC000033CC000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00330000333300333333006633330099333300CC333300FF33330000663300336633006666330099663300CC663300FF66330000993300339933006699330099993300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC330000FF330033FF330066FF330099FF3300CCFF3300FFFF330000006600330066006600660099006600CC006600FF00660000336600333366006633660099336600CC336600FF33660000666600336666006666660099666600CC666600FF66660000996600339966006699660099996600CC996600FF99660000CC660033CC660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00990000339900333399006633990099339900CC339900FF33990000669900336699006666990099669900CC669900FF66990000999900339999006699990099999900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CCCC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FFCC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCCFF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00CECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADACECE000000CECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADACECE000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADACECE000000DADADADADADADADADADADADADAD4D4D3D3AFD3AFA8A808D4D4D4DAD4DADADADADADADADADADADACECE000000DADADADADADADADADAD4D3D3D3A8A8A8A8A8A9A9AFAFAFAFA8A8A808D4DADADADADADADADADADADADA000000CECEDADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA000000CECEDADADADADADAD4A8A8A8A8A8D3A8A8A9D3D3080808AF080808AFA8A8A808D4DADADADADADADADA000000CECEDADADADAAFA8A8A9D4D4A8A808A1A07DA8A8077D07A97DA8A808D3AFAFA8A8D3DADADADADADADA000000CECEDADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADACECE000000DADADADADADAA8A808A8A8A87DA8A9A1A0A07D08AF7D7DA8A8A1A1A8D3FEFED3FEFED3DADADADACECE000000DADADADADAA8D3D3D3A8A0A0A0A6CACAA0A0A1FED3A1A0A8A1BEBECBD3FEFED3D3D27DA8DADADACECE000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADACECE000000DADADADAA884DAFEFEFED1D1CAF4F4F4CAA0CCFED3D3A8A1BEA8A8CCD3D3D3A8CACAA0A1A8DADADADA000000CECEDAAFA8D3A9A8AFD3CBCBD0F4D0CAD3FEFEFED3A8A1BEBEA8D2D3D3AFAFA8A0A6CAA8AFAFDADADA000000CECED4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA000000CECED4A8A8A8A8A8A87DFEFEF4F5F7D3FED3A8CBBEA8A0BEBEA1FED3A9AFAFA8CBA0A1AFDAD3DADADA000000CECE08A8A87D7DA1A17DA8A8FEFEFEFED37DA6CABEBEA8F7A8D3D30707A8A8F5F5CBDADAD4D408CECE000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A80808CECE000000DADAA908A1CBA6A6CBA8A8A8DADADAD3D3A6D0D0CAF4FEFED3D3A9077DA1A1D0D0D1A807A80808CECE000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A8CECE000000DADAA8D3A0A6A0A6A0A1D3D3DAD3A8A8D3D3D3A8F4F5D3FEFED3A8AF07CBCBD1CBA8CBBECBA8A8DADA000000CECEA9D4AFA0A0A1CBA8D3D3D3A8A8CCA1A8D3D3F7FED3FEFED3AF0884AEAED37DA6CABEBEA8A8"
		$sData&="DADA000000CECE0808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA000000CECE0808DAAF08A9AFD3A6A6CBD1F4CAA1A8A0FEFEFEFEFEFEFED3847DA8A8D3A6CAD0CACBAF08DADA000000CECED4A8A8A8A8A1A8D3CBCBA6F4F4F4CAA1D2FED3AFD3A8A8D3D3D384FEFEAFA1F4A8F4CCAF08CECE000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D4CECE000000DADAD4A8A8CBCABEA8AFD3D3A8D1D0D1D0D0FED3A8A8A8A87DA8A8D30FFEFEA8A0D3A8A6CCA8D4CECE000000DADADAD4A8CBD0D0D3D3A9A9D3F7F584AFFEA1CBA8F4D0A1A8CBA0D3D3FEFEA8A8D3A8CBA8A9D4CECE000000DADADADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA000000CECEDADA08A8A9A8A8A8A1A1D3FEFED3FED3CBA6F4F4F4CAA1A1A808DAD3D3A8A8D3D3AFA8D4DADADA000000CECEDADADAD4A87DCBD3A0A0A0FEFED3AFAF08A8D1F4F4F4D0A807A1AFAFAF07A1D3D3A808DADADADA000000CECEDADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADADADA000000CECEDADADADAD4A1CCD3CBCBCAFED3AFA908A8A9CCD0CCA8A8A8A8A6A8A9A9A8D0F4F4DADADADACECE000000DADADADADADAD4A9D3D3D3D3FEFEA9A9A9A8077DA8A9D3DAD3AF84A1A88484AFCCF4DADADADADACECE000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADACECE000000DADADADADADADA7DA8D3D3D3A8AF0807A8A107A9A9D4DAD4AE5E5E5E5E5E5EA9D4DADADADADADACECE000000DADADADADADADADAF4F4F4F4A8A9A8A0F4F4D1A8A8AFA8A8A8845E5E5EDADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA000000CECEDADADADADADADADADADADADADAA0CAF4F5D308080808D4D4D4DADADADADADADADADADADADADADA000000CECEDADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECE000000CECEDADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECEDADADADACECECECE000000"
		FileWrite($tempFile, Binary("0x" & $sData))
		FileClose($tempFile)
	EndIf
EndFunc