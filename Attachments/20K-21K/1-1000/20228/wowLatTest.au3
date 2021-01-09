#include<EditConstants.au3>
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include<GUIConstantsEx.au3>
#include<Array.au3>
#cs
	World of Warcraft Latentency Checker, zackrspv, May 14, 2008
	
	Autoit Version:  Current production version: 3.2.10.0
	Will NOT work in Beta, as the _ArraySort() beta
	function is too flakey, imho, to use.
	
	Purpose:  Used to check which server is responding the fastest to you
	
	Method:  Uses UDP to send test data (PING) to the server in the list
	and then return either a 0 or a 4 (4 means server online)
	If a 0 is returned, server marked offline, else speed of
	connection to server is saved in array
	
	Reasoning:  While TCP connections are nice, sometimes speed is what
	you need to test for closest server.  And, while UDP
	is universally known as Unreliable Data Packet
	you can usually get a good response by waiting on the recieve port
	to be closed by the server.
	
	Success Rate:  I have tested this with over 50 permutations, and
	about 95% of the time, it comes back with a server
	in my timezone or on the data center that is closest
	to me.
	
	You can verify at:                                                    
	Cross reference your fastest server listing in
	this program, with where the server is located on
	that webpage.  Keep in mind, you may get an
	Estern Time Zone Server or an Austrialian ET Server
	but you are located in the Pacific Time Zone; the
	reason for this is that the DataCenter the server
	is located on, is probably closer to you.
		
#ce

If Not FileExists(@ScriptDir & "\servers.txt") Then BuildList()

;- Define Constants
Local $port = 3724 ;- UDP port used for WoW ingame voice
Local $nOffset = 1
Local $count = 0 ;- Defines line count as 0
Local $k = 0
Local $pass = 0
Local $Servers = ""
Local $average = ""

;- Build UI
$Form1 = GUICreate("WoW Lat Test", 406, 132)
$go = GUICtrlCreateButton("Start Server Tests", 60, 50, 300, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$go2 = GUICtrlCreateButton("Redo Server Tests", 60, 90, 300, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_HIDE)
$Group1 = GUICtrlCreateGroup("Status", 10, 2, 385, 127)
GUICtrlSetState(-1, $GUI_HIDE)
$FastList = GUICtrlCreateEdit("", 267, 12, 124, 60, $ES_READONLY)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_HIDE)
$Progress1 = GUICtrlCreateProgress(36, 102, 334, 17)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$ProcStep = GUICtrlCreateLabel("Process Step: ", 16, 20, 245, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$ProcServer = GUICtrlCreateLabel("Processing Server: ", 18, 64, 245, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$FastestServer = GUICtrlCreateLabel("", 30, 18, 235, 70)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$FSTime = GUICtrlCreateLabel("", 187, 18, 65, 24)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE 
			Exit
		Case $go
		GUICtrlSetState($Group1, $GUI_SHOW)
		GUICtrlSetState($go, $GUI_HIDE)
		GUICtrlSetState($ProcStep, $GUI_SHOW)
		GUICtrlSetState($FastList, $GUI_SHOW)
		CountLines() ;- Find out how many servers exist in the file
		Dim $average[3][3] ;- Create Average Array, will process tests 3 times, fastest are stored in this array
		Dim $Servers[$count][4] ;- Create Servers array
		BuildArray() ;- Builds the array
		For $k = 0 To 2 ;- Process test 3 times
			$pass = $k + 1 ;- Proper # of pass
			TCPTest() ;- Do test
		Next
		_ArraySort($average, 0, 0, 0, 2, 1) ;- Sort Average Array w/ fastest at the top
		Done() ;- Display Fastest
		GUICtrlSetState($go2, $GUI_SHOW)
	Case $go2
		GUICtrlSetState($FastestServer, $GUI_HIDE)
		GUICtrlSetState($FSTime, $GUI_HIDE)
		GUICtrlSetState($Group1, $GUI_SHOW)
		GUICtrlSetState($go2, $GUI_HIDE)
		GUICtrlSetState($ProcStep, $GUI_SHOW)
		GUICtrlSetState($FastList, $GUI_SHOW)
		GUICtrlSetData($FastList, "")
		ReDim $average[3][3] ;- Create Average Array, will process tests 3 times, fastest are stored in this array
		For $k = 0 To 2 ;- Process test 3 times
			$pass = $k + 1 ;- Proper # of pass
			TCPTest() ;- Do test
		Next
		_ArraySort($average, 0, 0, 0, 2, 1) ;- Sort Average Array w/ fastest at the top
		Done() ;- Display Fastest
		GUICtrlSetState($go2, $GUI_SHOW)
	EndSwitch
WEnd

Func BuildArray() ;-  Creates the Servers Array
	GUICtrlSetData($ProcStep, "Process Step:  Building Array of Servers...")
	$file = FileOpen(@ScriptDir & "\servers.txt", 0)
	For $i = 0 To UBound($Servers) - 1
		$RawData = FileReadLine($file)
		$dataArray = StringRegExp($RawData, '(?s)(?i)(.*?)\s-\s(.*?)\s-\s(.*?)\Z', 1, $nOffset) ;- Format is IP_ADDRESS - SERVER_NAME
		If @error = 0 Then
			$Servers[$i][0] = $dataArray[0]
			$Servers[$i][1] = $dataArray[1]
			$Servers[$i][3] = $dataArray[2]
		ElseIf @error = 1 Then
			ExitLoop
		ElseIf @error = 2 Then
			ExitLoop
		EndIf
	Next
	FileClose($file)
EndFunc   ;==>BuildArray

Func CountLines() ;- Counts how many servers in servers.txt
	GUICtrlSetData($ProcStep, "Process Step:  Enumerating Servers...")
	$file = FileOpen(@ScriptDir & "\servers.txt", 0)
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		$count = $count + 1
	WEnd
	FileClose($file)
EndFunc   ;==>CountLines

Func TCPTest() ;- Actually performs the UDP test
	GUICtrlSetData($ProcStep, "Process Step:  Testing Servers.  Pass #: " & $pass)
	GUICtrlSetState($ProcServer, $GUI_SHOW)
	GUICtrlSetState($Progress1, $GUI_SHOW)
	UDPStartup() ;- Startup the UDP handlers
	For $i = 0 To UBound($Servers) - 1
		$at = $count - $i ;- Subtract current step from overall total servers
		$at = $at / $count ;- Divide them to find average
		$at = ((1 + Int($at * 100)) - 100) * - 1 ;- Calculate the current step
		GUICtrlSetData($Progress1, $at) ;- Update progress bar
		GUICtrlSetData($ProcServer, "Testing Server:  " & $Servers[$i][0]) ;- Update server information
		$sock = UDPOpen($Servers[$i][1], $port) ;- Create the UDP connection to the server
		If @error <> 0 Then ;- If the UDP port cannot be open, mark the server as Offlie
			$Servers[$i][2] = "Offline"
		Else
			$start = TimerInit() ;- Begin the timer
			$data = UDPSend($sock, "PING") ;- Send data to the UDP server
			$recv = UDPRecv($sock, 1024) ;- Wait for port to be closed
			If $data = 0 Then ;- If data is not returned
				$Servers[$i][2] = "Offline" ;- mark offline
			Else
				$end = TimerDiff($start) ;- Calculate difference
				If $end < 0 Then $end = $end + $end
				$Servers[$i][2] = $end ;- populate time into server array
			EndIf
		EndIf
		UDPCloseSocket($sock) ;- close the UDP connection
	Next
	UDPShutdown() ;- Shutdown the UDP handlers
	GUICtrlSetState($ProcServer, $GUI_HIDE)
	GUICtrlSetState($ProcStep, "Process Step: Sorting Servers...")
	_ArraySort($Servers, 0, 0, 0, 3, 2) ;- sort the array based on speed, each successive test, #2 and #3 will test based on speed
	$average[$k][0] = $Servers[0][0]
	$average[$k][1] = $Servers[0][2]
	$average[$k][2] = $Servers[0][3]
	If $average[$k][2] = "Boston" Then 
		$code = "BO"
	ElseIf $average[$k][2] = "Los Angeles" Then
		$code = "LA"
	ElseIf $average[$k][2] = "Dallas" Then
		$code = "DA"
	ElseIf $average[$k][2] = "Seattle" Then
		$code = "SE"
	EndIf
	GUICtrlSetData($FastList, $code&": "&$average[$k][0]&@CRLF, GUICtrlRead($FastList))
EndFunc   ;==>TCPTest

Func Done() ;- Display the fastest server.
	GUICtrlSetState($ProcStep, $GUI_HIDE)
	GUICtrlSetState($ProcServer, $GUI_HIDE)
	GUICtrlSetState($Progress1, $GUI_HIDE)
	GUICtrlSetState($FastestServer, $GUI_SHOW)
	GUICtrlSetData($FastestServer, "Fastest Server: " & @CRLF & $average[0][0]&@CRLF&$average[0][2])
	GUICtrlSetState($FSTime, $GUI_SHOW)
	GUICtrlSetData($FSTime, Round($Servers[0][2],2) & " ms")
EndFunc   ;==>Done

Func BuildList() ;- builds the servers.txt file, accurate as of May 13, 2008
	$file = FileOpen(@ScriptDir & "\servers.txt", 2)
	FileWrite($file, "Aegwynn - 12.129.225.125 - Los Angeles" & @CRLF)
	FileWrite($file, "Aerie Peak - 206.17.111.82 -  Boston" & @CRLF)
	FileWrite($file, "Agamaggan - 63.241.255.14 - Dallas" & @CRLF)
	FileWrite($file, "Aggramar - 206.16.235.120 - Dallas" & @CRLF)
	FileWrite($file, "Akama - 12.129.225.23 - Los Angeles" & @CRLF)
	FileWrite($file, "Alexstrasza - 63.241.255.82 - Dallas" & @CRLF)
	FileWrite($file, "Alleria - 63.241.255.77 - Dallas" & @CRLF)
	FileWrite($file, "Altar of Storms - 206.17.111.35 - Boston" & @CRLF)
	FileWrite($file, "Alterac Mountains - 206.17.111.103 - Boston" & @CRLF)
	FileWrite($file, "Aman'Thul - 12.129.225.8 - Los Angeles" & @CRLF)
	FileWrite($file, "Andorhal - 206.17.111.4 - Boston" & @CRLF)
	FileWrite($file, "Anetheron - 206.17.111.49 - Boston" & @CRLF)
	FileWrite($file, "Antonidas - 72.5.213.61 - Seattle" & @CRLF)
	FileWrite($file, "Anub'arak - 72.5.213.113 - Seattle" & @CRLF)
	FileWrite($file, "Anvilmar - 206.17.111.126 - Boston" & @CRLF)
	FileWrite($file, "Arathor - 12.129.233.37 - Los Angeles" & @CRLF)
	FileWrite($file, "Archimonde - 206.17.111.7 - Boston" & @CRLF)
	FileWrite($file, "Area 52 - 206.16.147.46 - Boston" & @CRLF)
	FileWrite($file, "Argent Dawn - 206.16.235.80 - Dallas" & @CRLF)
	FileWrite($file, "Arthas - 206.16.235.69 - Dallas" & @CRLF)
	FileWrite($file, "Arygos - 206.17.111.81 - Boston" & @CRLF)
	FileWrite($file, "Auchindoun - 206.16.147.59 - Boston" & @CRLF)
	FileWrite($file, "Azgalor - 206.16.235.98 - Dallas" & @CRLF)
	FileWrite($file, "Azjol-Nerub - 12.129.233.103 - Los Angeles" & @CRLF)
	FileWrite($file, "Azshara - 63.241.255.98 - Dallas" & @CRLF)
	FileWrite($file, "Azuremyst - 206.16.147.49 - Boston" & @CRLF)
	FileWrite($file, "Baelgun - 63.241.255.5 - Dallas" & @CRLF)
	FileWrite($file, "Balnazzar - 63.241.255.13 - Dallas" & @CRLF)
	FileWrite($file, "Barthilas - 12.129.225.61 - Los Angeles" & @CRLF)
	FileWrite($file, "Black Dragonflight - 206.17.111.21 - Boston" & @CRLF)
	FileWrite($file, "Blackhand - 63.241.255.8 - Dallas" & @CRLF)
	FileWrite($file, "Blackrock - 12.129.225.21 - Los Angeles" & @CRLF)
	FileWrite($file, "Blackwater Raiders - 72.5.213.94 - Seattle" & @CRLF)
	FileWrite($file, "Blackwing Lair - 206.17.111.115 - Boston" & @CRLF)
	FileWrite($file, "Bladefist - 72.5.213.95 - Seattle" & @CRLF)
	FileWrite($file, "Blade's Edge - 206.16.147.69 - Boston" & @CRLF)
	FileWrite($file, "Bleeding Hollow - 206.16.235.43 - Dallas" & @CRLF)
	FileWrite($file, "Blood Furnace - 206.16.147.65 - Boston" & @CRLF)
	FileWrite($file, "Bloodhoof - 206.16.235.34 - Dallas" & @CRLF)
	FileWrite($file, "Bloodscalp - 12.129.233.7 - Los Angeles" & @CRLF)
	FileWrite($file, "Bonechewer - 12.129.233.13 - Los Angeles" & @CRLF)
	FileWrite($file, "Boulderfist - 12.129.233.47 - Los Angeles" & @CRLF)
	FileWrite($file, "Bronzebeard - 12.129.233.46 - Los Angeles" & @CRLF)
	FileWrite($file, "Burning Blade - 206.16.235.68 - Dallas" & @CRLF)
	FileWrite($file, "Burning Legion - 206.16.235.64 - Dallas" & @CRLF)
	FileWrite($file, "Cenarion Circle - 72.5.213.115 - Seattle" & @CRLF)
	FileWrite($file, "Cenarius - 72.5.213.52 - Seattle" & @CRLF)
	FileWrite($file, "Cho'gall - 63.241.255.101 - Dallas" & @CRLF)
	FileWrite($file, "Chromaggus - 12.129.225.22 - Los Angeles" & @CRLF)
	FileWrite($file, "Coilfang - 206.16.147.56 - Boston" & @CRLF)
	FileWrite($file, "Crushridge - 12.129.233.52 - Los Angeles" & @CRLF)
	FileWrite($file, "Daggerspine - 12.129.233.88 - Los Angeles" & @CRLF)
	FileWrite($file, "Dalaran - 206.17.111.111 - Boston" & @CRLF)
	FileWrite($file, "Dalvengyr - 206.17.111.36 - Boston" & @CRLF)
	FileWrite($file, "Dark Iron - 63.241.255.67 - Dallas" & @CRLF)
	FileWrite($file, "Darkspear - 12.129.233.12 - Los Angeles" & @CRLF)
	FileWrite($file, "Darrowmere - 72.5.213.114 - Seattle" & @CRLF)
	FileWrite($file, "Dath'Remar - 12.129.225.73 - Los Angeles" & @CRLF)
	FileWrite($file, "Deathwing - 206.17.111.83 - Boston" & @CRLF)
	FileWrite($file, "Demon Soul - 206.17.111.127 - Boston" & @CRLF)
	FileWrite($file, "Dentarg - 206.17.111.125 - Boston" & @CRLF)
	FileWrite($file, "Destromath - 63.241.255.102 - Dallas" & @CRLF)
	FileWrite($file, "Dethecus - 63.241.255.97 - Dallas" & @CRLF)
	FileWrite($file, "Detheroc - 63.241.255.66 - Dallas" & @CRLF)
	FileWrite($file, "Doomhammer - 206.17.111.90 - Boston" & @CRLF)
	FileWrite($file, "Draenor - 12.129.233.33 - Los Angeles" & @CRLF)
	FileWrite($file, "Dragonblight - 12.129.233.17 - Los Angeles" & @CRLF)
	FileWrite($file, "Dragonmaw - 12.129.233.94 - Los Angeles" & @CRLF)
	FileWrite($file, "Draka - 12.129.225.19 - Los Angeles" & @CRLF)
	FileWrite($file, "Drak'thul - 12.129.225.105 - Los Angeles" & @CRLF)
	FileWrite($file, "Drenden - 72.5.213.100 - Seattle" & @CRLF)
	FileWrite($file, "Dunemaul - 12.129.233.23 - Los Angeles" & @CRLF)
	FileWrite($file, "Durotan - 206.16.235.55 - Dallas" & @CRLF)
	FileWrite($file, "Duskwood - 206.17.111.45 - Boston" & @CRLF)
	FileWrite($file, "Earthen Ring - 206.16.235.63 - Dallas" & @CRLF)
	FileWrite($file, "Echo Isles - 72.5.213.125 - Seattle" & @CRLF)
	FileWrite($file, "Eitrigg - 12.129.225.126 - Los Angeles" & @CRLF)
	FileWrite($file, "Eldre'Thalas - 12.129.233.48 - Los Angeles" & @CRLF)
	FileWrite($file, "Elune - 206.16.235.36 - Seattle" & @CRLF)
	FileWrite($file, "Emerald Dream - 63.241.255.83 - Dallas" & @CRLF)
	FileWrite($file, "Eonar - 206.16.235.6 - Dallas" & @CRLF)
	FileWrite($file, "Eredar - 206.16.235.89 - Dallas" & @CRLF)
	FileWrite($file, "Executus - 206.17.111.121 - Boston" & @CRLF)
	FileWrite($file, "Exodar - 206.16.147.100 - Boston" & @CRLF)
	FileWrite($file, "Farstriders - 72.5.213.101 - Seattle" & @CRLF)
	FileWrite($file, "Feathermoon - 12.129.233.96 - Los Angeles" & @CRLF)
	FileWrite($file, "Fenris - 72.5.213.120 - Seattle" & @CRLF)
	FileWrite($file, "Firetree - 12.129.233.25 - Los Angeles" & @CRLF)
	FileWrite($file, "Frostmane - 12.129.233.53 - Los Angeles" & @CRLF)
	FileWrite($file, "Frostmourne - 12.129.225.107 - Los Angeles" & @CRLF)
	FileWrite($file, "Frostwolf - 12.129.225.127 - Los Angeles" & @CRLF)
	FileWrite($file, "Garithos - 12.129.225.14 - Los Angeles" & @CRLF)
	FileWrite($file, "Garona - 63.241.255.12 - Dallas" & @CRLF)
	FileWrite($file, "Gilneas - 206.16.235.100 - Dallas" & @CRLF)
	FileWrite($file, "Gnomeregan - 206.17.111.32 - Boston" & @CRLF)
	FileWrite($file, "Gorefiend - 206.16.235.24 - Dallas" & @CRLF)
	FileWrite($file, "Gorgonnash - 63.241.255.84 - Dallas" & @CRLF)
	FileWrite($file, "Greymane - 63.241.255.56 - Dallas" & @CRLF)
	FileWrite($file, "Gul'dan - 63.241.255.120 - Dallas" & @CRLF)
	FileWrite($file, "Gurubashi - 12.129.233.24 - Los Angeles" & @CRLF)
	FileWrite($file, "Hakkar - 12.129.225.15 - Los Angeles" & @CRLF)
	FileWrite($file, "Haomarush - 206.17.111.37 - Boston" & @CRLF)
	FileWrite($file, "Hellscream - 63.241.255.55 - Dallas" & @CRLF)
	FileWrite($file, "Hydraxis - 72.5.213.43 - Seattle" & @CRLF)
	FileWrite($file, "Hyjal - 72.5.213.8 - Seattle" & @CRLF)
	FileWrite($file, "Icecrown - 206.17.111.120 - Boston" & @CRLF)
	FileWrite($file, "Illidan - 63.241.255.110 - Dallas" & @CRLF)
	FileWrite($file, "Jaedenar - 206.17.111.114 - Boston" & @CRLF)
	FileWrite($file, "Jubei'Thos - 12.129.225.103 - Los Angeles" & @CRLF)
	FileWrite($file, "Kael'thas - 63.241.255.113 - Dallas" & @CRLF)
	FileWrite($file, "Kalecgos - 63.241.255.81 - Dallas" & @CRLF)
	FileWrite($file, "Kargath - 206.16.235.118 - Dallas" & @CRLF)
	FileWrite($file, "Kel'Thuzad - 206.17.111.41 - Boston" & @CRLF)
	FileWrite($file, "Khadgar - 206.17.111.55 - Boston" & @CRLF)
	FileWrite($file, "Khaz Modan - 12.129.225.13 - Los Angeles" & @CRLF)
	FileWrite($file, "Khaz'goroth - 12.129.225.123 - Los Angeles" & @CRLF)
	FileWrite($file, "Kil'jaeden - 12.129.225.112 - Los Angeles" & @CRLF)
	FileWrite($file, "Kilrogg - 12.129.225.26 - Los Angeles" & @CRLF)
	FileWrite($file, "Kirin Tor - 63.241.255.27 - Dallas" & @CRLF)
	FileWrite($file, "Korgath - 12.129.225.11 - Los Angeles" & @CRLF)
	FileWrite($file, "Korialstrasz - 72.5.213.97 - Seattle" & @CRLF)
	FileWrite($file, "Kul Tiras - 12.129.225.9 - Los Angeles" & @CRLF)
	FileWrite($file, "Laughing Skull - 206.16.235.31 - Dallas" & @CRLF)
	FileWrite($file, "Lethon - 206.17.111.99 - Boston" & @CRLF)
	FileWrite($file, "Lightbringer - 72.5.213.58 - Seattle" & @CRLF)
	FileWrite($file, "Lightninghoof - 63.241.255.100 - Dallas" & @CRLF)
	FileWrite($file, "Lightning's Blade - 206.16.235.33 - Dallas" & @CRLF)
	FileWrite($file, "Llane - 206.16.235.99 - Dallas" & @CRLF)
	FileWrite($file, "Lothar - 206.16.235.1 - Dallas" & @CRLF)
	FileWrite($file, "Madoran - 206.16.235.113 - Dallas" & @CRLF)
	FileWrite($file, "Maelstrom - 63.241.255.88 - Dallas" & @CRLF)
	FileWrite($file, "Magtheridon - 206.16.235.8 - Dallas" & @CRLF)
	FileWrite($file, "Maiev - 72.5.213.98 - Seattle" & @CRLF)
	FileWrite($file, "Malfurion - 63.241.255.45 - Dallas" & @CRLF)
	FileWrite($file, "Mal'Ganis - 206.17.111.43 - Boston" & @CRLF)
	FileWrite($file, "Malorne - 12.129.225.2 - Los Angeles" & @CRLF)
	FileWrite($file, "Malygos - 206.16.235.71 - Dallas" & @CRLF)
	FileWrite($file, "Mannoroth - 206.16.235.92 - Dallas" & @CRLF)
	FileWrite($file, "Medivh - 206.16.235.85 - Dallas" & @CRLF)
	FileWrite($file, "Misha - 72.5.213.9 - Seattle" & @CRLF)
	FileWrite($file, "Mok'Nathal - 72.5.213.117 - Seattle" & @CRLF)
	FileWrite($file, "Moon Guard - 72.5.213.62 - Seattle" & @CRLF)
	FileWrite($file, "Moonrunner - 63.241.255.9 - Dallas" & @CRLF)
	FileWrite($file, "Mug'thol - 12.129.225.6 - Los Angeles" & @CRLF)
	FileWrite($file, "Muradin - 12.129.225.3 - Los Angeles" & @CRLF)
	FileWrite($file, "Nagrand - 12.129.225.43 - Los Angeles" & @CRLF)
	FileWrite($file, "Nathrezim - 12.129.233.5 - Los Angeles" & @CRLF)
	FileWrite($file, "Nazgrel - 72.5.213.118 - Seattle" & @CRLF)
	FileWrite($file, "Nazjatar - 63.241.255.10 - Dallas" & @CRLF)
	FileWrite($file, "Ner'zhul - 12.129.225.16 - Los Angeles" & @CRLF)
	FileWrite($file, "Nordrassil - 72.5.213.54 - Seattle" & @CRLF)
	FileWrite($file, "Norgannon - 206.17.111.88 - Boston" & @CRLF)
	FileWrite($file, "Onyxia - 206.17.111.1 - Boston" & @CRLF)
	FileWrite($file, "Perenolde - 12.129.233.42 - Los Angeles" & @CRLF)
	FileWrite($file, "Proudmoore - 12.129.225.18 - Los Angeles" & @CRLF)
	FileWrite($file, "Quel'dorei - 72.5.213.99 - Seattle" & @CRLF)
	FileWrite($file, "Ravencrest - 63.241.255.23 - Dallas" & @CRLF)
	FileWrite($file, "Ravenholdt - 72.5.213.96 - Seattle" & @CRLF)
	FileWrite($file, "Rexxar - 12.129.225.5 - Los Angeles" & @CRLF)
	FileWrite($file, "Rivendare - 72.5.213.55 - Seattle" & @CRLF)
	FileWrite($file, "Runetotem - 12.129.225.1 - Los Angeles" & @CRLF)
	FileWrite($file, "Sargeras - 63.241.255.89 - Dallas" & @CRLF)
	FileWrite($file, "Scarlet Crusade - 12.129.233.72 - Los Angeles" & @CRLF)
	FileWrite($file, "Scilla - 206.17.111.22 - Boston" & @CRLF)
	FileWrite($file, "Sen'jin - 12.129.225.80 - Los Angeles" & @CRLF)
	FileWrite($file, "Sentinels - 206.17.111.10 - Boston" & @CRLF)
	FileWrite($file, "Shadow Council - 12.129.233.20 - Los Angeles" & @CRLF)
	FileWrite($file, "Shadowmoon - 206.16.235.57 - Dallas" & @CRLF)
	FileWrite($file, "Shadowsong - 12.129.233.97 - Los Angeles" & @CRLF)
	FileWrite($file, "Shandris - 72.5.213.69 - Seattle" & @CRLF)
	FileWrite($file, "Shattered Halls - 206.16.147.109 - Boston" & @CRLF)
	FileWrite($file, "Shattered Hand - 206.16.235.110 - Dallas" & @CRLF)
	FileWrite($file, "Shu'halo - 72.5.213.83 - Seattle" & @CRLF)
	FileWrite($file, "Silver Hand - 12.129.225.114 - Los Angeles" & @CRLF)
	FileWrite($file, "Silvermoon - 12.129.233.40 - Los angeles" & @CRLF)
	FileWrite($file, "Sisters of Elune - 72.5.213.102 - Seattle" & @CRLF)
	FileWrite($file, "Skullcrusher - 206.16.235.122 - Dallas" & @CRLF)
	FileWrite($file, "Skywall - 12.129.233.128 - Los Angeles" & @CRLF)
	FileWrite($file, "Smolderthorn - 12.129.233.21 - Los Angeles" & @CRLF)
	FileWrite($file, "Spinebreaker - 63.241.255.52 - Dallas" & @CRLF)
	FileWrite($file, "Spirestone - 12.129.233.4 - Los Angeles" & @CRLF)
	FileWrite($file, "Staghelm - 63.241.255.48 - Dallas" & @CRLF)
	FileWrite($file, "Steamwheedle Cartel - 206.17.111.42 - Boston" & @CRLF)
	FileWrite($file, "Stonemaul - 12.129.233.22 - Los Angeles" & @CRLF)
	FileWrite($file, "Stormrage - 206.16.235.117 - Dallas" & @CRLF)
	FileWrite($file, "Stormreaver - 63.241.255.90 - Dallas" & @CRLF)
	FileWrite($file, "Stormscale - 12.129.233.90 - Los Angeles" & @CRLF)
	FileWrite($file, "Suramar - 12.129.233.2 - Los Angeles" & @CRLF)
	FileWrite($file, "Tanaris - 206.17.111.3 - Boston" & @CRLF)
	FileWrite($file, "Terenas - 12.129.233.89 - Los Angeles" & @CRLF)
	FileWrite($file, "Terokkar - 206.16.147.70 - Boston" & @CRLF)
	FileWrite($file, "Thaurissan - 12.129.225.82 - Los Angeles" & @CRLF)
	FileWrite($file, "The Forgotten Coast - 72.5.213.127 - Seattle" & @CRLF)
	FileWrite($file, "The Scryers - 206.16.147.76 - Boston" & @CRLF)
	FileWrite($file, "The Underbog - 206.16.147.43 - Boston" & @CRLF)
	FileWrite($file, "The Venture Co - 206.17.111.119 - Boston" & @CRLF)
	FileWrite($file, "Thorium Brotherhood - 12.129.225.4 - Los Angeles" & @CRLF)
	FileWrite($file, "Thrall - 206.17.111.100 - Boston" & @CRLF)
	FileWrite($file, "Thunderhorn - 206.16.235.125 - Dallas" & @CRLF)
	FileWrite($file, "Thunderlord - 206.16.235.11 - Dallas" & @CRLF)
	FileWrite($file, "Tichondrius - 12.129.225.41 - Los Angeles" & @CRLF)
	FileWrite($file, "Tortheldrin - 72.5.213.36 - Seattle" & @CRLF)
	FileWrite($file, "Trollbane - 206.16.235.97 - Dallas" & @CRLF)
	FileWrite($file, "Turalyon - 206.17.111.87 - Boston" & @CRLF)
	FileWrite($file, "Twisting Nether - 63.241.255.7 - Dallas" & @CRLF)
	FileWrite($file, "Uldaman - 206.17.111.48 - Boston" & @CRLF)
	FileWrite($file, "Uldum - 12.129.233.6 - Los Angeles" & @CRLF)
	FileWrite($file, "Undermine - 206.17.111.124 - Boston" & @CRLF)
	FileWrite($file, "Ursin - 63.241.255.80 - Dallas" & @CRLF)
	FileWrite($file, "Uther - 72.5.213.44 - Seattle" & @CRLF)
	FileWrite($file, "Vashj - 72.5.213.85 - Seattle" & @CRLF)
	FileWrite($file, "Vek'nilash - 12.129.225.10 - Los Angeles" & @CRLF)
	FileWrite($file, "Velen - 206.16.147.98 - Boston" & @CRLF)
	FileWrite($file, "Warsong - 206.16.235.108 - Dallas" & @CRLF)
	FileWrite($file, "Whisperwind - 63.241.255.123 - Dallas" & @CRLF)
	FileWrite($file, "Wildhammer - 63.241.255.128 - Dallas" & @CRLF)
	FileWrite($file, "Windrunner - 12.129.233.11 - Los Angeles" & @CRLF)
	FileWrite($file, "Ysera - 206.17.111.8 - Boston" & @CRLF)
	FileWrite($file, "Ysondre - 206.17.111.56 - Boston" & @CRLF)
	FileWrite($file, "Zangarmarsh - 206.16.147.74 - Boston" & @CRLF)
	FileWrite($file, "Zul'jin - 206.16.235.112 - Dallas" & @CRLF)
	FileWrite($file, "Zuluhed - 206.17.111.128 - Boston")
	FileClose($file)
EndFunc   ;==>BuildList