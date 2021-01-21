#include <GUIConstants.au3>
#include <GUIList.au3>
#include <GuiListView.au3>

init()

SplashImageOn("","images\olhideout.bmp",250,135,"-1","-1",3)
#cs
InetGet($url&"/ver.ini",$mainDir&"\ver.ini",1,1)
$version = IniRead($mainDir&"\ver.ini","version","version","Error")
if $version > $localVersion or not FileExists($mainDir&"\maplist.ini") Then
asktoUpdate()
Else
FileDelete($mainDir&"\ver.ini")
EndIf
#ce
sleep(1500)
SplashOff()


$MainWin = GuiCreate("Gunslinger Map Downloader", 640, 390,(@DesktopWidth-640)/2, (@DesktopHeight-480)/2,BitOr($WS_OVERLAPPEDWINDOW, $WS_SIZEBOX))

if not FileExists($mainDir&"\maplist.ini") then
	noMapList()
EndIf

dim $lstMaps
dim $DLWin
dim $GetInfo
dim $screenDL
dim $numMaps
dim $selScreen
dim $btn_Download
dim $selZip
dim $zipDL
dim $cancelButton
dim $mainDir
dim $quitDL
dim $lblNum
dim $chkUpdate

GUICtrlCreatePic("images\olhideout.bmp",500,10,100,54)


$btnUpdate = GUICtrlCreateButton("Check for updates",(640/2)-47,10,110)
$btnRandom = GUICtrlCreateButton("Select Random Map",(640/2)-47,40,110)
$btnInfo = GUICtrlCreateButton("Get Map Info",(640/2)-140,360,110)
$btnDL = GUICtrlCreateButton("Download Map",(640/2)+10,360,110)
$btnSearch = GUICtrlCreateButton("Search",165,40,52,22,$BS_DEFPUSHBUTTON)

$inputSearch = GUICtrlCreateInput("",50,37,100,20)

$lblSearch = GUICtrlCreateLabel("Search: ",10,40)
genList()
$lblNum = GUICtrlCreateLabel("There are currently "&$numMaps&" maps to choose from",5,5,250,30)
_GUICtrlListViewSetColumnWidth ($lstMaps, 0, 35)
_GUICtrlListViewSetColumnWidth ($lstMaps, 1, 125)
_GUICtrlListViewSetColumnWidth ($lstMaps, 2, 100)
_GUICtrlListViewSetColumnWidth ($lstMaps, 3, 100)
_GUICtrlListViewSetColumnWidth ($lstMaps, 4, 275)

GuiSetState()

Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount ($lstMaps) ]

While 1

	$msg = GuiGetMsg(1)
	
	if $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $MainWin then
		if $optionDelShots = 1 Then 
			FileDelete($shotsDir&"\*")
		EndIf
	ExitLoop
	EndIf
	
	If $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $GetInfo Then GUIDelete($GetInfo)
	
	if $msg[1]=$GetInfo and $msg[0]=$btn_Download then getMap($selZip)
	
	if $msg[1]=$screenDL and $msg[0]=$GUI_EVENT_CLOSE then GUIDelete($screenDL)
	
	if $msg[1]=$chkUpdate and $msg[0]=$GUI_EVENT_CLOSE then GUIDelete($chkUpdate)

				
	Select	
	case $msg[0] = $lstMaps
		_GUICtrlListViewSort($lstMaps, $B_DESCENDING, GUICtrlGetState($lstMaps))
	
case $msg[0] = $btnUpdate
	init()
	$chkUpdate = GUICreate("Checking for Updates",255,80,((@DesktopWidth-640)/2)+175, ((@DesktopHeight-480)/2)+100,$WS_CAPTION,$MainWin)
	GUICtrlCreateIcon("images\globe.ico",-1,5,10)
	$chkStatus = GUICtrlCreateLabel("Checking for Updates",50,25,250)
	GUISetState()
		InetGet($url&"/ver.ini",$mainDir&"\ver.ini",1)
	$version = IniRead($mainDir&"\ver.ini","version","version","Error")
		if $version > $localVersion or not FileExists($mainDir&"\maplist.ini") Then
			GUICtrlSetData($chkStatus,"An Update was Found. Downloading Now...")
			;asktoUpdate()
			FileDelete($mainDir&"\maplist.ini")
			InetGet($url&"/maplist.ini",$mainDir&"\maplist.ini")
			FileDelete($mainDir&"\ver.ini")
			IniWrite($mainDir&"\mapget.ini","updates","version",$version)
			;MsgBox(64,"Update Has Been Downloaded","Your MapList File has Been Updated.")			
			GUICtrlSetData($chkStatus,"Your Maplist has been updated")
			sleep(1200)
			GUIDelete($chkUpdate)
			genList()
		Else
			GUICtrlSetData($chkStatus,"No Update Found at this time.")
			;MsgBox(64,"No Updates Found","No Updates Were Found at This Time. Please Try Again Later")
			FileDelete($mainDir&"\ver.ini")
			sleep(1200)
			GUIDelete($chkUpdate)
		EndIf

	case $msg[0] = $btnSearch
		search()

	case $msg[0] = $btnInfo
		$a = _GUICtrlListViewGetCurSel($lstMaps)+1
		$b = GUICtrlRead(GUICtrlRead($lstMaps))
		if not $a = "" then
		infoWindow($b)
		EndIf
	case $msg[0] = $btnDL
		
		$d = _GUICtrlListViewGetCurSel($lstMaps)+1
		$e = GUICtrlRead(GUICtrlRead($lstMaps))
		if $e < 10 then $f = StringLeft($e,1)
		if $e > 9 and $e < 100 then $f = StringLeft($e,2)
		if $e > 99 and $e < 1000 then $f = StringLeft($e,3)
	
		
		if not $d = "" Then
		dlMap($f)
		EndIf
	
	case $msg[0]=$btnRandom
		$r = Random(1,$numMaps,1)
			_GUICtrlListViewSetItemSelState($lstMaps,$r-1,1)
			$r1 = _GUICtrlListViewGetCurSel($lstMaps)
			$r2 = GUICtrlRead(Guictrlread($lstmaps))
			if $r2 < 10 then $r3 = StringLeft($r2,1)
			if $r2 > 0 and $r2 < 100 then $r3 = StringLeft($r2,2)
			if $r2 > 99 and $r2 < 1000 then $r3 = StringLeft($r2,3)
		infoWindow($r2)
	Case Else
		;;;
	EndSelect
WEnd
Exit

Func asktoUpdate()
	#cs
	$updateAnswer = MsgBox(36,"Update Found","There is an update available. Do you wish to download the update?")
	Select
		Case $updateAnswer = 6 ;Yes
			FileDelete($mainDir&"\maplist.ini")
			InetGet($url&"/maplist.ini",$mainDir&"\maplist.ini")
			FileDelete($mainDir&"\ver.ini")
			IniWrite($mainDir&"\mapget.ini","updates","version",$version)
			MsgBox(64,"Update Has Been Downloaded","Your MapList File has Been Updated.")
	
		Case $updateAnswer = 7
			FileDelete($mainDir&"\ver.ini")
	
	EndSelect
	#ce
	Return
EndFunc

Func noMapList()
	MsgBox(48,"No Map List Found","A Map List Database has not been found on this machine. It will be downloaded from The Outlaws Hideout now.")
	InetGet($url&"/maplist.ini",$mainDir&"\maplist.ini")
	Return
EndFunc

Func genList()
	GUICtrlDelete($lstMaps)
	;$lblNum = GUICtrlCreateLabel("There are currently "&$numMaps&" maps to choose from",5,5,250,30)
	global $lstMaps = GUICtrlCreateListView("No.|Map Name|Filename|Filesize|Author",50,80,550,230,-1)
	global $numMaps = IniRead($mainDir&"\maplist.ini","version","numMaps","Error")
	GUICtrlSetData($lblNum,"There are currently "&$numMaps&" maps to choose from")
	for $i = 1 to $numMaps step 1
		global $listZips = IniRead($mainDir&"\maplist.ini","zips",$i,"Error")
		global $listSize = iniread($mainDir&"\maplist.ini","filesize",$i,"Error")
		global $listNames = IniRead($mainDir&"\maplist.ini","mapnames",$i,"Error")
		global $listAuthors = IniRead($mainDir&"\maplist.ini","author",$i,"Error")
		global $mapList = GUICtrlCreateListViewItem($i&"|"&$listNames&"|"&$listZips&"|"&$listSize&"|"&$listAuthors,$lstMaps)
	Next
	Return
EndFunc

Func dlMap($d)
	
	$dZip = IniRead($mainDir&"\maplist.ini","zips",$d,"Error")
	getMap($dZip)
	Return
EndFunc

func infoWindow($b2)
		if $b2 < 10 then $c = StringLeft($b2,1)
		if $b2 > 9 and $b2 < 100 then $c = StringLeft($b2,2)
		if $b2 > 99 and $b2 < 1000 then $c = StringLeft($b2,3)
		
		$selMapName = IniRead($mainDir&"\maplist.ini","mapnames",$c,"Error")
		$selZip = IniRead($mainDir&"\maplist.ini","zips",$c,"Error")
		$selSize = IniRead($mainDir&"\maplist.ini","filesize",$c,"Error")
		$selModes = IniRead($mainDir&"\maplist.ini","modes",$c,"Error")
		$selAuthor = IniRead($mainDir&"\maplist.ini","author",$c,"Error")
		$selScreen =  IniRead($mainDir&"\maplist.ini","screenshots",$c,"Error")
		$selInfo = IniRead($mainDir&"\maplist.ini","mapinfo",$c,"Error")

		
		if not FileExists($shotsDir&"\"&$selScreen) Then downloadScreenshot($selScreen)
		;$getScreen = InetGet("                                 "&$selScreen,$shotsDir&"\"&$selScreen)

		
		$GetInfo=GUICreate($selMapName&" by "&$selAuthor,512,630,-1,-1,-1,$MainWin)
		$center = (512/2)-180
		;GUISetBkColor(0x000000,-1)
		GUICtrlCreatePic("images\back.jpg",0,0,512,630)
		GUICtrlSetState(-1,$GUI_DISABLE)
		GUICtrlCreatePic($shotsDir&"\"&$selScreen,(512/2)-200,5,400,300)
		$btn_Download = GUICtrlCreateButton("Download Map",215,580,100,30,$BS_FLAT)
		$txtColor = "0xffe600"
		$font = "Arial Bold"
		$fSize="10"

		
		$lbl_MapName=GUICtrlCreateLabel("Map Name: "&$selMapName,$center,320,400)
		GUICtrlSetFont(-1,$fSize,-1,-1,$font)
		$lbl_Zip=GuiCtrlcreatelabel("Filename: "&$selZip,$center,350,400)
		GUICtrlSetFont(-1,$fSize,-1,-1,$font)
		$lbl_Size=guictrlcreatelabel("Filesize: "&$selSize,$center,380,400)
		GUICtrlSetFont(-1,$fSize,-1,-1,$font)
		$lbl_Modes=GUICtrlCreateLabel("Gametypes: "&$selModes,$center,410,400)
		GUICtrlSetFont(-1,$fSize,-1,-1,$font)
		$lbl_Author=GUICtrlCreateLabel("Map Author: "&$selAuthor,$center,440,400,60)
		GUICtrlSetFont(-1,$fSize,-1,-1,$font)
		$lbl_Info=GUICtrlCreateLabel("Notes: "&$selInfo,$center,470,400,500)
		GUICtrlSetFont(-1,$fSize,-1,-1,$font)
		GUICtrlSetColor($lbl_MapName,$txtColor)
		GUICtrlSetColor($lbl_Zip,$txtColor)
		GUICtrlSetColor($lbl_Size,$txtColor)
		GUICtrlSetColor($lbl_Author,$txtColor)
		GUICtrlSetColor($lbl_Info,$txtColor)
		GUICtrlSetColor($lbl_Modes,$txtColor)
		GUISetState()
		
		
			$SMsg = guigetmsg()
				if $Smsg=$GUI_EVENT_CLOSE then 

				GUIDelete($GetInfo)
				EndIf
	
		Return
EndFunc

Func downloadScreenshot($selScreen)
	$screenDL = GUICreate("Downloading Screenshot",392,150,-1,-1,-1,$MainWin)
	GUICtrlCreatePic("images\shots.bmp",0,0,392,150)
	GuiCtrlSetState(-1,$GUI_DISABLE)
	#region --- Start Defining GUI Controls ---
	$status= GuiCtrlCreateLabel("Retrieving Screenshot: "&$selScreen, 10, 10, 375, 30)
	GUICtrlSetFont(-1,12,420,2,"Comic Sans MS")
	GUICtrlSetColor(-1,0x1d9de7)
	$progressbar1 = GuiCtrlCreateProgress(20, 40, 350, 30)
	;GUICtrlSetColor(-1,0x000000)
	GUISetState(@SW_SHOW,$screenDL)
	
	#endregion --- End of GUI Controls ---
	$screenSize = InetGetSize("                             "&$selScreen)
	
	InetGet("                                 "&$selScreen,$shotsDir&"\"&$selScreen,1,1)


while @InetGetActive
	
$p = INT( (@InetGetBytesRead/$screenSize) * 100)
	GUICtrlSetData ($progressbar1,$p)
	if @InetGetBytesRead >= $screenSize Then
		sleep(500)
		GUIDelete($screenDL)
		sleep(1000)
		Return
	
	EndIf
	
WEnd
Return
EndFunc

func getMap($dZip)
	
	$zipDL = GUICreate("Downloading Map",392,150,-1,-1,$WS_CAPTION,$MainWin)
	$p = ""
	GUICtrlCreatePic("images/mapGet.bmp",0,0,392,150)
	GuiCtrlSetState(-1,$GUI_DISABLE)
	$quitDL = GuiCtrlCreateButton("Cancel", 140, 90, 80, 25)
	$status= GuiCtrlCreateLabel("Downloading "&$dZip, 10, 10, 375, 30)
	$lblP = GUICtrlCreateLabel($p&" Complete",10,120)
	GUICtrlSetFont($status,14,600,2,"Arial")
	GUICtrlSetColor($status,0xff0000)
	
	GUICtrlSetFont($lblP,10,400,2,"Arial")
	GUICtrlSetColor($lblP,0xff0000)
	
	$progressbar2 = GuiCtrlCreateProgress(20, 40, 350, 30)
	
	
	GUISetState()
	

	$zipSize = InetGetSize("                          "&$dZip)
	
	if not FileExists($MapsDir&"\"&$dZip) Then
		InetGet("                              "&$dZip,$MapsDir&"\"&$dZip,1,1)
	Else
	$iMsgBoxAnswer = MsgBox(324,"File Already Exists","It Appears That You Have Already Downloaded This Map... Delete the Existing File and Download Again?")
	Select
	Case $iMsgBoxAnswer = 6 ;Yes
		FileDelete($MapsDir&"\"&$dZip)
		InetGet("                              "&$dZip,$MapsDir&"\"&$dZip,1,1)
	Case $iMsgBoxAnswer = 7 ;No	
		GUIDelete($zipDL)
		EndSelect
	EndIf
		

while @InetGetActive
		$Dmsg = GUIGetMsg(1)
		if $Dmsg[1]=$zipDL  and $Dmsg[0]=$quitDL  Then
		InetGet("abort")
		FileDelete($MapsDir&"\"&$dZip)
		GUIDelete($zipDL)
	EndIf
$p = (@InetGetBytesRead / $zipSize) * 100	
GuiCtrlSetData($progressbar2, $p)

	if @InetGetBytesRead = $zipSize Then
		sleep(500)
		if @OSTYPE = "WIN32_NT" Then
		TrayTip("Gotter Done","Your map has finished Downloading",4,1)
		SoundPlay("chaching.wav")
	
	Else
	MsgBox(64,"Gotter Done","Your map has finished downloading",4)

	EndIf
		GUIDelete($zipDL)
		Run(@comspec & " /c start " & $MapsDir&"\"&$dZip, "", @SW_HIDE)
Return	
	EndIf

WEnd

EndFunc

func search()
		if not GUICtrlRead($inputSearch) = "" Then
		$searchItem = GUICtrlRead($inputSearch)
		;For $z = 0 To _GUICtrlListViewGetItemCount($lstMaps) - 1 step 1
		for $z = 0 to $numMaps step 1
		$Search = _GUICtrlListViewGetItemText($lstMaps, $z, 1)
		
		If $Search = $searchItem Then
			$b3=_GUICtrlListViewSetItemSelState($lstMaps,$z,1)
			;$b4 = _GUICtrlListViewGetCurSel($lstMaps)+1
			$b4 = GUICtrlRead(GUICtrlRead($lstMaps))
			infoWindow($b4)
		EndIf
		Next	
	EndIf
EndFunc

func init()
	global $url="                     "

	global $localVersion=IniRead(@WORKINGDIR&"\mapget.ini","updates","version","Error reading Config file")
	global $firstRun=IniRead(@WORKINGDIR&"\mapget.ini","updates","firstrun","Error reading Config file") ;1 is yes 0 is no

	global $mainDir = IniRead(@WORKINGDIR&"\mapget.ini","Directories","Install","Error reading Config file") ;Where the program is running from
	global $shotsDir = IniRead(@WORKINGDIR&"\mapget.ini","Directories","Screens","Error reading Config file");Where the screenshots are downloaded to
	global $MapsDir = IniRead(@WORKINGDIR&"\mapget.ini","Directories","Maps","Error reading Config file") ;Where the maps are downloaded to
 
	global $optionDelShots = IniRead(@WORKINGDIR&"\mapget.ini","Options","Del_Screens","Error reading Config file") ;0 = Do not delete screenshots. Keep them on HD after downloading and viewing
Return
EndFunc

