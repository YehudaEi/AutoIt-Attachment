FileInstall("C:\Documents and Settings\Cyanide Monkey\autoitscripts\exes\autohostGUI.gif", @ScriptDir & "\autohostGUI.gif")
FileInstall("C:\Documents and Settings\Cyanide Monkey\autoitscripts\exes\splash.bmp", @ScriptDir & "\splash.bmp")
FileInstall("C:\Documents and Settings\Cyanide Monkey\autoitscripts\exes\novaworld.gif", @ScriptDir & "\novaworld.gif")
#include <GUIConstants.au3>
#Include <date.au3>
#include <GetIP.au3>
#include <file.au3>

HotKeySet("{ESC}", "Terminate")

;---------------SET GLOBALS---------------
Global $gVersion = "v1.5c"

;Make sure AutoHost is not already open
$gAlreadyOpen = "AutoHost " & $gVersion & " for Delta Force 2 Demo V1.03.04"
If WinExists($gAlreadyOpen) Then Exit ; It's already running
AutoItWinSetTitle($gAlreadyOpen)

;----------GET INFO FORM settings.ini IF THERE------------
Global $gBSSwitch = IniRead(@ScriptDir & "\settings.ini","config","BSswitch","")
Global $gBSPath = IniRead(@ScriptDir & "\settings.ini","config","BSpath","")
Global $gDF2DemoPath = IniRead(@ScriptDir & "\settings.ini","config","DFpath","")
Global $gComKey = IniRead(@ScriptDir & "\settings.ini","config","ComKey","`")
Global $gAHopt1 = IniRead(@ScriptDir & "\settings.ini","config","AHopt1","")
Global $gAHopt2 = IniRead(@ScriptDir & "\settings.ini","config","AHopt2","")
Global $gAHopt3 = IniRead(@ScriptDir & "\settings.ini","config","AHopt3","")
Global $gAHopt4 = IniRead(@ScriptDir & "\settings.ini","config","AHopt4","")
Global $gStartUpPause = IniRead(@ScriptDir & "\settings.ini","config","StartUpPause",2)
Global $gRBSwitch = IniRead(@ScriptDir & "\settings.ini","config","RBSwitch","")
Global $gRBTime = IniRead(@ScriptDir & "\settings.ini","config","RBTime","once a week")
Global $gAHRB = IniRead(@ScriptDir & "\settings.ini","config","AHRB",0)
Global $gStartPause = IniRead(@ScriptDir & "\settings.ini","config","StartPause","10 seconds")
Global $gPromoteSwitch = IniRead(@ScriptDir & "\settings.ini","promote","PromoteSwitch","")
Global $gPromoteText = IniRead(@ScriptDir & "\settings.ini","promote","PromoteText","")
Global $gPromoteTime = IniRead(@ScriptDir & "\settings.ini","promote","PromoteTime","30 Minutes") ; default 30 Minutes
Global $gStatsSwitch = IniRead(@ScriptDir & "\settings.ini","promote","StatsSwitch","")
Global $gStatsTime = IniRead(@ScriptDir & "\settings.ini","promote","StatsTime","30 Minutes") ; default 30 Minutes
Global $gKFNSwitch = IniRead(@ScriptDir & "\settings.ini","promote","KFNSwitch","")
Global $gKFNTime = IniRead(@ScriptDir & "\settings.ini","promote","KFNTime","30 Minutes") ; default 30 Minutes
Global $gPuntCRCSwitch = IniRead(@ScriptDir & "\settings.ini","host","PuntCRCSwitch","") 
Global $gPuntCRCTime = IniRead(@ScriptDir & "\settings.ini","host","PuntCRCTime","30 Minutes") ; default 30 Minutes
Global $gNetDelaySwitch = IniRead(@ScriptDir & "\settings.ini","host","NetDelaySwitch","") 
Global $gNetDelayTime = IniRead(@ScriptDir & "\settings.ini","host","NetDelayTime","30 Minutes") ; default 30 Minutes
Global $gSDMSwitch = IniRead(@ScriptDir & "\settings.ini","host","SDMSwitch","")
Global $gSDMTime = IniRead(@ScriptDir & "\settings.ini","host","SDMTime","30 Minutes") ; default 30 Minutes
Global $gSDMOpt1 = IniRead(@ScriptDir & "\settings.ini","host","SDMopt1","")
Global $gSDMOpt2 = IniRead(@ScriptDir & "\settings.ini","host","SDMopt2","")
Global $gSDMOpt3 = IniRead(@ScriptDir & "\settings.ini","host","SDMopt3","")
Global $gSDMRestarts = IniRead(@ScriptDir & "\settings.ini","host","SDMRestarts",0) ; defualt is unlimited
Global $gIPMSwitch = IniRead(@ScriptDir & "\settings.ini","host","IPMSwitch","")
Global $gSHSSwitch = IniRead(@ScriptDir & "\settings.ini","host","SHSSwitch","")
Global $gSHSTime = IniRead(@ScriptDir & "\settings.ini","host","SHSTime","1 Hour") ; default 1 Hour
Global $gSHSSwitch2 = IniRead(@ScriptDir & "\settings.ini","host","SHSSwitch2","")
Global $gLMSwitch = IniRead(@ScriptDir & "\settings.ini","host","LMSwitch","")

Global $gMaxPlayers = IniRead(@ScriptDir & "\settings.ini","df2demo","MaxPlayers","")
Global $gDriver = IniRead(@ScriptDir & "\settings.ini","df2demo","Driver","")
Global $gResolution = IniRead(@ScriptDir & "\settings.ini","df2demo","Resolution","")
Global $gServerName = IniRead(@ScriptDir & "\settings.ini","df2demo","ServerName","")
Global $gServerType = IniRead(@ScriptDir & "\settings.ini","df2demo","ServerType","Dedicated Server")
Global $gGameType = IniRead(@ScriptDir & "\settings.ini","df2demo","GameType","")
Global $gNoOfTeams = IniRead(@ScriptDir & "\settings.ini","df2demo","NoOfTeams","")
Global $gStartDelay = IniRead(@ScriptDir & "\settings.ini","df2demo","StartDelay","")
Global $gReplay = IniRead(@ScriptDir & "\settings.ini","df2demo","Replay","")
Global $gTimeoutBox = IniRead(@ScriptDir & "\settings.ini","df2demo","TimeoutBox","")
Global $gDestBuild = IniRead(@ScriptDir & "\settings.ini","df2demo","DestBuild","")
Global $gDeathMess = IniRead(@ScriptDir & "\settings.ini","df2demo","DeathMess","")
Global $gTeamLives = IniRead(@ScriptDir & "\settings.ini","df2demo","TeamLives","")
Global $gAttributes = IniRead(@ScriptDir & "\settings.ini","df2demo","Attributes","Standard")
Global $gMapTime = IniRead(@ScriptDir & "\settings.ini","df2demo","MapTime","")
Global $gScoreLimit = IniRead(@ScriptDir & "\settings.ini","df2demo","ScoreLimit","")
Global $gKothTime = IniRead(@ScriptDir & "\settings.ini","df2demo","KothTime","")

Global $DFvar = ""
Global $BSvar = ""
Global $gDStext = "Check your game stats at                         "
Global $gKFNtext = "Download this map from:                             "
Global $gTab = "" 
Global $rs = 0
Global $Bob = 0

Global $Paused

Global $PublicIP = "                                    "

;---- update setting.ini if updated from v1.1 to v1.x 
If StringLeft(($gPromoteTime), 2) < 15 Then
	Global $gPromoteTime = "15 Minutes"
EndIf
If StringLeft(($gStatsTime), 2) < 15 Then
	Global $gStatsTime = "15 Minutes"
EndIf
If StringLeft(($gKFNTime), 2) < 15 Then
	Global $gKFNTime = "15 Minutes"
EndIf

;MsgBox(0,"test", "$gAHopt2 = " & $gAHopt2  & @CRLF & "$gAHopt3 = " & $gAHopt3 & @CRLF & "$gAHRB = " & $gAHRB)

If $gAHopt2 = 1 AND $gAHopt3 = 1 AND $gAHRB = 1 AND $gAHopt4 = 1 Then
	If $gStartUpPause = "" OR $gStartUpPause = 0 Then
		$SUPtime = 1
	EndIf
	If $gStartUpPause = 1 Then
		$SUPtime = 60
	EndIf
	If $gStartUpPause = 2 Then
		$SUPtime = 120
	EndIf
	If $gStartUpPause = 3 Then
		$SUPtime = 180
	EndIf
	If $gStartUpPause = 4 Then
		$SUPtime = 240
	EndIf
	If $gStartUpPause = 4 Then
		$SUPtime = 300
	EndIf
	$ReStart = MsgBox(65, "AutoHost " & $gVersion & "  for Delta Force 2 Demo V1.03.04", "AutoHost will load and start hosting DF2 Demo in " & $gStartUpPause & " minute(s)." & @CRLF & @CRLF & "AutoHost has been configured to automatically load and start a hosting session on computer start up or reboot." & @CRLF & "This " & $gStartUpPause & " minute pause will allow time for your operating system to fully load and net connection to be established." & @CRLF & "To adjust the pause time, or turn off auto load and host on start up, use the config tab in AutoHost." & @CRLF & "Click [OK] to skip pause and launch AutoHost now." & @CRLF & "Click [Cancel] to abort AutoHost start up."  & @CRLF & "Click nothing to let timer start AutoHost as per configuration setting.", $SUPtime)
	If $ReStart = 2 Then
		Exit 0
	EndIf
EndIf

;-------------------------------Splash/Intro Screen ----------------------------------------
$splash = GUICreate("AutoHost " & $gVersion, 395, 200,-1,-1,$WS_BORDER)
GUICtrlCreatePic(@ScriptDir & "\splash.bmp",1,1,393,91)
GUICtrlCreateLabel ("Loading...",5,95,100,20)
GUICtrlCreateLabel ("Looking for Delta Force 2 Demo V1.03.04:",5,110,200,20)
GUICtrlCreateLabel ("checking...",210,110,200,20)
GUICtrlCreateLabel ("Checking Internet Connection...................:",5,125,205,20)
GUICtrlCreateLabel ("checking...",210,125,200,20)
GUICtrlCreateLabel ("Pinging NovaWorld Lobby.........................:",5,140,205,20)
GUICtrlCreateLabel ("checking...",210,140,200,20)
GUISetState()

If FileExists("C:\Program Files\NovaLogic\Delta Force 2 Demo\Df2dem.exe") Then	;default program path
	If $gDF2DemoPath = "" Then
		IniWrite(@ScriptDir & "\settings.ini","config","DFpath", "C:\Program Files\NovaLogic\Delta Force 2 Demo\Df2dem.exe")
		Global $gDF2DemoPath = IniRead(@ScriptDir & "\settings.ini","config","DFpath","")
	EndIf
	sleep(500)
	ControlSetText("AutoHost " & $gVersion, "", "Static4", "OK!")
Else
	sleep(500)
	ControlSetText("AutoHost " & $gVersion, "", "Static4", "NOT FOUND.")
EndIf

;## for testing ##
;$gip = "(no internet connection)"
$gip = "0.0.0.0"
;$ping = 10

$gip = _GetIP()
;$ping = Ping ("64.69.47.142") <- OLD NW LOBBY IP
$ping = Ping ("nw2.novaworld.net")




If $ping = 0 Then
	$ping = "FAILED."
EndIf
If $gip <> "(no internet connection)" Then
	ControlSetText("AutoHost " & $gVersion, "", "Static6", "OK!")
	ControlSetText("AutoHost " & $gVersion, "", "Static8", $ping)
	sleep(1000)
	If WinExists("AutoHost " & $gVersion & " for Delta Force 2 Demo V1.03.04") Then
		GUIDelete($splash)
	EndIf
Else
	ControlSetText("AutoHost " & $gVersion, "", "Static6", "FAILED.")
	ControlSetText("AutoHost " & $gVersion, "", "Static8", "FAILED.")
	sleep(1000)
	If WinExists("AutoHost " & $gVersion & " for Delta Force 2 Demo V1.03.04") Then
		GUIDelete($splash)
	EndIf
EndIf

;----------------------------- Back up df2.cfg ------------------------------
If $gDF2DemoPath <> "" Then
	Global $GcfgPath = StringReplace(IniRead(@ScriptDir & "\settings.ini","config","DFpath",""), "Df2dem.exe", "df2.cfg")
	Global $bkcfgPath = StringReplace(IniRead(@ScriptDir & "\settings.ini","config","DFpath",""), "Df2dem.exe", "df2_bk.cfg")
	If FileExists ($GcfgPath) <> 0 Then
		If FileExists ($bkcfgPath) = 0 Then
			FileCopy($GcfgPath, $bkcfgPath)
		EndIf
	EndIf
ElseIf $gDF2DemoPath = "" Then
	Global $GcfgPath = ""
	Global $bkcfgPath = ""
	MsgBox(48,"AutoHost " & $gVersion,"Cound not find DF2 Demo in default location." & @CRLF & "Please use Configure tab to set location of 'Df2dem.exe' on your computer.")
EndIf

ReadConfig()

#Include <start_hosting.au3>

;-------------------------- MAIN INTERFACE ----------------------------------
Opt("GUIOnEventMode", 1)
If $gip = "(no internet connection)" Then
	$mainwindow = GUICreate("AutoHost " & $gVersion & " for Delta Force 2 Demo V1.03.04 - (No internet connection.)", 600, 400)
ElseIf $gip <> "(no internet connection)" Then
	$mainwindow = GUICreate("AutoHost " & $gVersion & " for Delta Force 2 Demo V1.03.04", 600, 400)
EndIf
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

GUICtrlCreatePic(@ScriptDir & "\autohostGUI.gif",10,355,213,45)
$btn = GUICtrlCreateButton("START HOSTING", 470, 365, 120,-1,$BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent($btn, "AutoHost")

$tab=GUICtrlCreateTab (10,10, 580,345)

;-------------Hosting---------------
$tab0=GUICtrlCreateTabitem ( "Hosting")
	GUICtrlCreateGroup ("      PuntCRC ", 20, 40, 270, 70)
		$PuntCRCSwitch = GUICtrlCreateCheckbox ("", 32, 42, 10, 10)
		GUICtrlSetOnEvent($PuntCRCSwitch, "PuntCRCstate")
		GUICtrlSetState($PuntCRCSwitch,$gPuntCRCSwitch)
		GUICtrlCreateLabel ("Send Command:", 30,60,100,20)
		$PuntCRCText = GUICtrlCreateLabel ("puntcrc", 30,80,50,20)
		If $gPuntCRCSwitch = 4 OR $gPuntCRCSwitch = "" Then
			GUICtrlSetState($PuntCRCText, $GUI_DISABLE)
		EndIf
		GUICtrlCreateLabel ("Send Every...", 200,60,100,20)
		$PuntCRCTime = GUICtrlCreateCombo ("", 200,75,80,80)
		GUICtrlSetData(-1,"1 Minute|2 Minutes|3 Minutes|4 Minutes |5 Minutes|10 Minutes|15 Minutes|20 Minutes|25 Minutes|30 Minutes|35 Minutes|40 Minutes|45 Minutes|50 Minutes|55 Minutes|60 Minutes", $gPuntCRCTime)
		If $gPuntCRCSwitch = 4 OR $gPuntCRCSwitch = "" Then
			GUICtrlSetState($PuntCRCTime, $GUI_DISABLE)
		EndIf
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("      NetDelay ", 310, 40, 270, 70)
		$NetDelaySwitch = GUICtrlCreateCheckbox ("", 322, 42, 10, 10)
		GUICtrlSetOnEvent($NetDelaySwitch, "NetDelaystate")
		GUICtrlSetState($NetDelaySwitch,$gNetDelaySwitch)
		GUICtrlCreateLabel ("Send Command:", 320,60,100,20)
		$NetDelayText = GUICtrlCreateLabel ("netdelay 0", 320,80,50,20)
		If $gNetDelaySwitch = 4 OR $gNetDelaySwitch = "" Then
			GUICtrlSetState($NetDelayText, $GUI_DISABLE)
		EndIf
		GUICtrlCreateLabel ("Send Every...", 490,60,100,20)
		$NetDelayTime = GUICtrlCreateCombo ("", 490,75,80,80)
		GUICtrlSetData(-1,"1 Minute|2 Minutes|3 Minutes|4 Minutes|5 Minutes|10 Minutes|15 Minutes|20 Minutes|25 Minutes|30 Minutes|35 Minutes|40 Minutes|45 Minutes|50 Minutes|55 Minutes|60 Minutes", $gNetDelayTime)
		If $gNetDelaySwitch = 4 OR $gNetDelaySwitch = "" Then
			GUICtrlSetState($NetDelayTime, $GUI_DISABLE)
		EndIf
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("      Sysdump Monitor ", 20, 120, 270, 220)
		$SDMSwitch = GUICtrlCreateCheckbox ("", 32, 122, 10, 10)
		GUICtrlSetOnEvent($SDMSwitch, "SDMstate")
		GUICtrlSetState($SDMSwitch,$gSDMSwitch)
		GUICtrlCreateLabel ("Check for Sysdump Error Every...", 30,142,200,20)
		$SDMTime = GUICtrlCreateCombo ("", 200,137,80,80)
		GUICtrlSetData(-1,"1 Minute|5 Minutes|10 Minutes|15 Minutes|20 Minutes|25 Minutes|30 Minutes|35 Minutes|40 Minutes|45 Minutes|50 Minutes|55 Minutes|60 Minutes", $gSDMTime)
		If $gSDMSwitch = 4 OR $gSDMSwitch = "" Then
			GUICtrlSetState($SDMTime, $GUI_DISABLE)
		EndIf
		GUICtrlCreateLabel ("If Sysdump Error is detected:", 30,170,200,20)
		$SDMopt1 = GUICtrlCreateRadio ("Restart DF2 Demo, restart hosting session.", 30, 185, 250, 20)
		If $gSDMOpt1 = 1 Then
			GUICtrlSetState($SDMopt1,$GUI_CHECKED)
		EndIf
		GUICtrlSetOnEvent($SDMOpt1, "SDMRstate")
		$SDMopt2 = GUICtrlCreateRadio ("Shutdown DF2 Demo.", 30, 202, 200, 20)
		If $gSDMOpt2 = 1 Then
			GUICtrlSetState($SDMopt2,$GUI_CHECKED)
		EndIf
		GUICtrlSetOnEvent($SDMOpt2, "SDMRstate")
		$SDMopt3 = GUICtrlCreateRadio ("Shutdown Computer.", 30, 219, 200, 20)
		If $gSDMOpt3 = 1 Then
			GUICtrlSetState($SDMopt3,$GUI_CHECKED)
		EndIf
		GUICtrlSetOnEvent($SDMOpt3, "SDMRstate")
		If $gSDMSwitch = 4 OR $gSDMSwitch = "" Then
			GUICtrlSetState($SDMopt1, $GUI_DISABLE)
			GUICtrlSetState($SDMopt2, $GUI_DISABLE)
			GUICtrlSetState($SDMopt3, $GUI_DISABLE)
		EndIf
		GUICtrlCreateLabel ("Number of restarts before pausing script :", 30,250,200,20)
		$SDMrestarts = GUICtrlCreateInput ("",230,247, 50, 20)
		GUICtrlSetData($SDMrestarts,$gSDMRestarts)
		$SDMupdown = GUICtrlCreateUpdown($SDMrestarts)
		If $gSDMSwitch = 4 OR $gSDMSwitch = "" Then
			GUICtrlSetState($SDMrestarts,$GUI_DISABLE)
			GUICtrlSetState($SDMupdown,$GUI_DISABLE)
			GUICtrlSetBkColor($SDMrestarts, 0xd4d0c8) ; manually change colour work around (win classic colour)
		Else
			If $gSDMOpt1 = 4 OR $gSDMOpt1 = "" Then
				GUICtrlSetState($SDMrestarts,$GUI_DISABLE)
				GUICtrlSetState($SDMupdown,$GUI_DISABLE)
				GUICtrlSetBkColor($SDMrestarts, 0xd4d0c8) ; manually change colour work around (win classic colour)
			EndIf
		EndIf
		GUICtrlCreateLabel ("(0 = unlimited)", 220,270,70,20)
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("      IP Monitor ", 310, 120, 270, 65)
		$IPMSwitch = GUICtrlCreateCheckbox ("", 322, 122, 10, 10)
		GUICtrlSetOnEvent($IPMSwitch, "IPMstate")
		GUICtrlSetState($IPMSwitch,$gIPMSwitch)
		If GUICtrlRead($IPMSwitch) = 1 Then
			$PublicIP = _GetIP()
		EndIf
		$IPMText1 = GUICtrlCreateLabel("Your current IP Address is: ", 320, 140)
		$IPMText2 = GUICtrlCreateLabel($PublicIP, 450, 140)
		$IPMText3 = GUICtrlCreateLabel("Restart DF2 Demo if IP address dynamically updates.", 320, 160)
		If $gIPMSwitch = 4 OR $gIPMSwitch = "" Then
			GUICtrlSetState($IPMText1, $GUI_DISABLE)
			GUICtrlSetState($IPMText2, $GUI_DISABLE)
			GUICtrlSetState($IPMText3, $GUI_DISABLE)
		EndIf
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("      Lobby Monitor", 310, 195, 270, 65)
		If $gLMSwitch = 1 Then
			$Dping = $ping
		Else
			$Dping = " "
		EndIf
		$LMSwitch = GUICtrlCreateCheckbox("", 322, 197, 10, 10)
		GUICtrlSetOnEvent($LMSwitch, "LMstate")
		GUICtrlSetState($LMSwitch,$gLMSwitch)
		$LMText1 = GUICtrlCreateLabel ("Pinging NovaWorld Lobby:", 320,215,130,20)
		$LMText2 = GUICtrlCreateLabel ($Dping, 450,215,120,20)
		$LMText3 = GUICtrlCreateLabel ("Shutdown DF2 Demo if server lobby goes offline.", 320,235,250,20)
		If $gLMSwitch = 4 OR $gLMSwitch = "" Then
			GUICtrlSetState($LMText1, $GUI_DISABLE)
			GUICtrlSetState($LMText2, $GUI_DISABLE)
			GUICtrlSetState($LMText3, $GUI_DISABLE)
		EndIf
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("      Shutdown", 310, 270, 270, 70)
		$SHSSwitch = GUICtrlCreateCheckbox ("", 322, 272, 10, 10)
		GUICtrlSetOnEvent($SHSSwitch, "SHSstate")
		GUICtrlSetState($SHSSwitch,$gSHSSwitch)
		$SHSText1 = GUICtrlCreateLabel("Shut down hosting session after: ", 320, 290)
		$SHSTime = GUICtrlCreateCombo ("", 490,287,80,80)
		GUICtrlSetData(-1,"1 Hour |5 Hours|10 Hours|15 Hours|20 Hours|25 Hours|30 Hours|35 Hours|40 Hours|45 Hours|50 Hours|55 Hours|60 Hours", $gSHSTime)
		
		$SHSText2 = GUICtrlCreateLabel("Shut down computer after hosting session finshed: ", 320, 315)
		$SHSSwitch2 = GUICtrlCreateCheckbox ("", 560, 317, 10, 10)
		GUICtrlSetState($SHSSwitch2,$gSHSSwitch2)
		
		If $gSHSSwitch = 4 OR $gSHSSwitch = "" Then
			GUICtrlSetState($SHSText1, $GUI_DISABLE)
			GUICtrlSetState($SHSText2, $GUI_DISABLE)
			GUICtrlSetState($SHSTime, $GUI_DISABLE)
			GUICtrlSetState($SHSSwitch2 , $GUI_DISABLE)
		EndIf
		
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
GUICtrlCreateTabitem ("")   ; end tabitem definition

;-------------Promote---------------
$tab1=GUICtrlCreateTabitem ("Promote")
	GUICtrlCreateGroup ("      Promotion Text ", 20, 40, 560, 80)
		$PromoteSwitch = GUICtrlCreateCheckbox ("", 32, 42, 10, 10)
		GUICtrlSetOnEvent($PromoteSwitch, "PMstate")
		GUICtrlSetState($PromoteSwitch,$gPromoteSwitch)
		GUICtrlCreateLabel ("Type the text you want to display: (59 characters max)", 30,60,300,20)
		$PromoteText = GUICtrlCreateInput( "", 30,  80, 420, 20)
		GUICtrlSetLimit(-1,59)
		If $gPromoteSwitch = 4 OR $gPromoteSwitch = "" Then
			GUICtrlSetState($PromoteText, $GUI_DISABLE)
			GUICtrlSetBkColor($PromoteText, 0xd4d0c8) ; manually change colour work around (win classic colour)
		EndIf
		GUICtrlSetState($PromoteText,$GUI_ACCEPTFILES)
		GUICtrlSetData($PromoteText,$gPromoteText)
		GUICtrlCreateLabel ("Display Every...", 480,60,100,20)
		$PromoteTime = GUICtrlCreateCombo ("", 480,80,80,80)
		GUICtrlSetData(-1,"15 Minutes|20 Minutes|25 Minutes|30 Minutes|35 Minutes|40 Minutes|45 Minutes|50 Minutes|55 Minutes|60 Minutes", $gPromoteTime)
		If $gPromoteSwitch = 4 OR $gPromoteSwitch = "" Then
			GUICtrlSetState($PromoteTime, $GUI_DISABLE)
		EndIf
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group

	GUICtrlCreateLabel ("Other DF2 Demo community messages", 20,130,200,20)
	GUICtrlCreateGroup ("      DemoStats ", 20, 150, 560, 60)
		$StatsSwitch = GUICtrlCreateCheckbox ("", 32, 152, 10, 10)
		GUICtrlSetOnEvent($StatsSwitch, "DSstate")
		GUICtrlSetState($StatsSwitch,$gStatsSwitch)
		GUICtrlCreateLabel ("Text Displayed:", 30,170,150,20)
		$DStext = GUICtrlCreateLabel ($gDStext, 30,185,420,20)
		If $gStatsSwitch = 4 OR $gStatsSwitch = "" Then
			GUICtrlSetState($DStext, $GUI_DISABLE)
		EndIf
		GUICtrlCreateLabel ("Display Every...", 480,165,100,20)
		$StatsTime = GUICtrlCreateCombo ("", 480,180,80,80)
		GUICtrlSetData(-1,"15 Minutes|20 Minutes|25 Minutes|30 Minutes|35 Minutes|40 Minutes|45 Minutes|50 Minutes|55 Minutes|60 Minutes", $gStatsTime)
		If $gStatsSwitch = 4 OR $gStatsSwitch = "" Then
			GUICtrlSetState($StatsTime, $GUI_DISABLE)
		EndIf
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("      KFN Map DataBase ", 20, 220, 560, 60)
		$KFNSwitch = GUICtrlCreateCheckbox ("", 32, 222, 10, 10)
		GUICtrlSetOnEvent($KFNSwitch, "KFNstate")
		GUICtrlSetState($KFNSwitch,$gKFNSwitch)
		GUICtrlCreateLabel ("Text Displayed:", 30,240,150,20)
		$KFNtext = GUICtrlCreateLabel ($gKFNtext, 30,255,420,20)
		If $gKFNSwitch = 4 OR $gKFNSwitch = "" Then
			GUICtrlSetState($KFNtext, $GUI_DISABLE)
		EndIf
		GUICtrlCreateLabel ("Display Every...", 480,235,100,20)
		$KFNTime = GUICtrlCreateCombo ("", 480,250,80,80)
		GUICtrlSetData(-1,"15 Minutes|20 Minutes|25 Minutes|30 Minutes|35 Minutes|40 Minutes|45 Minutes|50 Minutes|55 Minutes|60 Minutes", $gKFNTime)
		If $gKFNSwitch = 4 OR $gKFNSwitch = "" Then
			GUICtrlSetState($KFNTime, $GUI_DISABLE)
		EndIf
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
GUICtrlCreateTabitem ("")   ; end tabitem definition

;------------- DF2 Host Options ---------------
$tab2=GUICtrlCreateTabitem ("DF2 Options")

	GUICtrlCreateGroup ("Server Setup ", 20, 40, 260, 300)
		GUICtrlCreateLabel ("Server Name: ", 30,60,70,20)
		$ServerName = GUICtrlCreateInput("", 100, 57, 130, 20)
		GUICtrlSetData($ServerName,$gServerName)
		GUICtrlSetLimit(-1,15)
		GUICtrlCreateLabel ("Server Type: ", 30,88,100,20)
		$ServerType = GUICtrlCreateCombo ("", 100,85,110,80)
		GUICtrlSetData(-1,"Serve and Play|Dedicated Server", $gServerType)
		GUICtrlSetState($ServerType, $GUI_DISABLE)
		GUICtrlCreateLabel ("Game Type: ", 30,118,100,20)
		$GameType = GUICtrlCreateCombo ("", 100,115,130,80)
		GUICtrlSetData(-1,"Cooperative|Deathmatch|Team Deathmatch|King Of The Hill|Team King Of The Hill|Capture The Flag|Team Flagball", $gGameType)
		GUICtrlSetOnEvent($GameType, "KOTHstate")
		GUICtrlCreateLabel ("Replay:", 30,148,90,20)
		$Replay = GUICtrlCreateCombo ("", 100,145,140,80)
		GUICtrlSetData(-1,"No Replay|Selected Map Only|Cycle Through All Maps", $gReplay)
		GUICtrlCreateLabel ("Start Delay:", 30,178,70,20)
		$StartDelay = GUICtrlCreateInput ("",100,175, 50, 20)
		GUICtrlSetData($StartDelay,$gStartDelay)
		$DF2SDupdown = GUICtrlCreateUpdown($StartDelay)
		GUICtrlSetLimit($DF2SDupdown, 100 , 0)
 		GUICtrlCreateLabel ("(minutes)", 160,178,90,20)
		$DeathMess = GUICtrlCreateCheckbox ("Death Messages", 32, 203, 110, 15)
		GUICtrlSetState($DeathMess,$gDeathMess)
		$DestBuild = GUICtrlCreateCheckbox ("Destroyable Buildings", 147, 203, 130, 15)
		GUICtrlSetState($DestBuild,$gDestBuild)
		GUICtrlCreateLabel ("Maximum Players:", 30,228,90,20)
		$MaxPlayers = GUICtrlCreateCombo ("", 120,225,40,80)
		GUICtrlSetData(-1,"1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16", $gMaxPlayers)
		GUICtrlCreateLabel ("Number of Teams: ", 30,257,90,20)
		$NoOfTeams = GUICtrlCreateCombo ("", 120,254,40,80)
		GUICtrlSetData(-1,"2|4", $gNoOfTeams)
		GUICtrlCreateLabel ("Timeout Box:", 30,286,90,20)
		$TimeoutBox = GUICtrlCreateInput ("",120,283, 50, 20)
		GUICtrlSetData($TimeoutBox,$gTimeoutBox)
		$DF2TOupdown = GUICtrlCreateUpdown($TimeoutBox)
		GUICtrlSetLimit($DF2TOupdown, 100 , 0)
 		GUICtrlCreateLabel ("(minutes)", 180,286,90,20)
		GUICtrlCreateLabel ("Team Lives:", 30,313,90,20)
		$TeamLives = GUICtrlCreateInput ("",120,310, 50, 20)
		GUICtrlSetData($TeamLives,$gTeamLives)
		$DF2TLupdown = GUICtrlCreateUpdown($TeamLives)
		GUICtrlSetLimit($DF2TLupdown, 100 , 0)
 		GUICtrlCreateLabel ("(100 = infinite)", 180,313,90,20)
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("Game Attributes ", 300, 40, 280, 135)
		GUICtrlCreateLabel ("Attribute Set:", 310,60,70,20)
		$Attributes = GUICtrlCreateCombo ("", 375,57,65,80)
		GUICtrlSetData(-1,"All On|All Off|Newbie|Standard|Veteran|Alt Set 1|Alt Set 2|Alt Set 3", $gAttributes)
		GUICtrlSetOnEvent($Attributes, "GAstate" )
		GUICtrlCreateLabel ("Tracer.......................: ", 445,60,110,20)
		GUICtrlCreateLabel ("Team Selection.........: ", 445,78,110,20)
		GUICtrlCreateLabel ("Allow Friendly Fire......: ", 445,96,110,20)
		GUICtrlCreateLabel ("Friendly Fire Warning.: ", 445,114,110,20)
		GUICtrlCreateLabel ("Friendly Tags.............: ", 445,132,110,20)
		GUICtrlCreateLabel ("See Team On GPS....: ", 445,150,110,20)
		$GAText1 = GUICtrlCreateLabel ("Yes", 555,60,20,20)
		$GAText2 = GUICtrlCreateLabel ("Yes", 555,78,20,20)
		$GAText3 = GUICtrlCreateLabel ("Yes", 555,96,20,20)
		$GAText4 = GUICtrlCreateLabel ("Yes", 555,114,20,20)
		$GAText5 = GUICtrlCreateLabel ("Yes", 555,132,20,20)
		$GAText6 = GUICtrlCreateLabel ("Yes", 555,150,20,20)
		GAstate()
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("Win Conditions", 300, 185, 280, 95)
		$WCText1 = GUICtrlCreateLabel("Map Time Limit: ", 310, 205)
		$MapTime = GUICtrlCreateInput ("",390,202, 50, 20)
		GUICtrlSetData($MapTime,$gMapTime)
		$DF2MTupdown = GUICtrlCreateUpdown($MapTime)
		GUICtrlSetLimit($DF2MTupdown, 100 , 0)
 		GUICtrlCreateLabel ("(minutes / 100 = infinite)", 450,205,120,20)
		$WCText2 = GUICtrlCreateLabel("Score Limit: ", 310, 230)
		$ScoreLimit = GUICtrlCreateInput ("",390,227, 50, 20)
		GUICtrlSetData($ScoreLimit,$gScoreLimit)
		$DF2SLupdown = GUICtrlCreateUpdown($ScoreLimit)
		GUICtrlSetLimit($DF2SLupdown, 100 , 0)
 		GUICtrlCreateLabel ("(kills / 100 = infinite)", 450,230,120,20)
		$WCText3 = GUICtrlCreateLabel("KOTH Time: ", 310, 255)
		$KothTime = GUICtrlCreateInput ("",390,252, 50, 20)
		GUICtrlSetData($KothTime,$gKothTime)
		$DF2KTupdown = GUICtrlCreateUpdown($KothTime)
		GUICtrlSetLimit($DF2KTupdown, 100 , 0)
 		$explain3 = GUICtrlCreateLabel ("(minutes / 100 = infinite)", 450,255,120,20)
		If GUICtrlRead($GameType) <> "King Of The Hill" AND GUICtrlRead($GameType) <> "Team King Of The Hill" Then
			GUICtrlSetState($WCText3, $GUI_DISABLE)
			GUICtrlSetState($KothTime, $GUI_DISABLE)
			GUICtrlSetState($DF2KTupdown, $GUI_DISABLE)
			GUICtrlSetBkColor($KothTime, 0xd4d0c8) ; manually change colour work around (win classic colour)
			GUICtrlSetState($explain3, $GUI_DISABLE)
		EndIf
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("Game Password", 300, 290, 130, 50)
		$btn3 = GUICtrlCreateButton("Set Password", 315, 310, 100,20)
		GUICtrlSetOnEvent($btn3, "PasswordEnabler")
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("Reset df2.cfg", 450, 290, 130, 50)
		$btn4 = GUICtrlCreateButton("Reset to Default", 465, 310, 100,20)
		GUICtrlSetOnEvent($btn4, "ResetConfig")
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group

GUICtrlCreateTabitem ("")   ; end tabitem definition
 
;---------------- Configure ---------------

$tab3=GUICtrlCreateTabitem ("Configure")
	
	GUICtrlCreateGroup ("DF2 Demo path (Df2dem.exe) ", 20, 40, 560, 60)
		$DFpath = GUICtrlCreateInput("", 30,  65, 430, 20)
		GUICtrlSetData($DFpath,$gDF2DemoPath)
		$DF2btn = GUICtrlCreateButton("Find DF2 Demo", 470, 62, 100)
		GUICtrlSetOnEvent($DF2btn, "FindDF2")
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
		
	GUICtrlCreateGroup ("      DemoStats path (babstats.exe) ", 20, 110, 560, 60)
		$BSSwitch = GUICtrlCreateCheckbox ("", 32, 112, 10, 10)
		GUICtrlSetOnEvent($BSSwitch, "BSstate")
		GUICtrlSetState($BSSwitch,$gBSSwitch)
		$BSpath = GUICtrlCreateInput( "", 30,  135, 430, 20)
		If $gBSSwitch = 4 OR $gBSSwitch = "" Then
			GUICtrlSetState($BSpath, $GUI_DISABLE)
			GUICtrlSetBkColor($BSpath, 0xd4d0c8) ; manually change colour work around (win classic colour)
		EndIf
		GUICtrlSetData($BSpath,$gBSPath)
		$BSbtn = GUICtrlCreateButton("Find DemoStats", 470, 132, 100)
		If $gBSSwitch = 4 OR $gBSSwitch = "" Then
			GUICtrlSetState($BSbtn, $GUI_DISABLE)
		EndIf
		GUICtrlSetOnEvent($BSbtn, "FindBS")
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	GUICtrlCreateGroup ("AutoHost Options ", 20, 180, 280, 100)
		$AHopt1 = GUICtrlCreateCheckbox ("Keep DF2 Demo on top. (active application)", 32, 200, 250, 15)
		GUICtrlSetState($AHopt1,$gAHopt1)
		$AHopt3 = GUICtrlCreateCheckbox ("Load AutoHost on computer start up or restart.", 32, 220, 250, 15)
		GUICtrlSetState($AHopt3,$gAHopt3)
		GUICtrlSetOnEvent($AHopt3, "SetStartUp")
		$AHopt4 = GUICtrlCreateCheckbox ("Enable", 32, 240, 55, 15)
		GUICtrlSetState($AHopt4,$gAHopt4)
		GUICtrlSetOnEvent($AHopt4, "SetAH4State")
		$StartUpPause = GUICtrlCreateInput ("",88,238, 35, 20)
		GUICtrlSetData($StartUpPause,$gStartUpPause)
		$SUPupdown = GUICtrlCreateUpdown($StartUpPause)
		GUICtrlSetLimit($SUPupdown, 5 , 0)
		If $gAHopt4 = 4 OR $gAHopt4 = "" Then
			GUICtrlSetState($StartUpPause, $GUI_DISABLE)
			GUICtrlSetState($SUPupdown, $GUI_DISABLE)
			GUICtrlSetBkColor($StartUpPause, 0xd4d0c8) ; manually change colour work around (win classic colour)
		EndIf
		GUICtrlCreateLabel("minutes pause to allow OS to load.", 125,240,200,20)
		$AHopt2 = GUICtrlCreateCheckbox ("Start hosting when AutoHost loads.", 32, 260, 200, 15)
		GUICtrlSetState($AHopt2,$gAHopt2)
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group	
		
	GUICtrlCreateGroup ("      Restart Server ", 20, 290, 280, 50)
		$RBSwitch = GUICtrlCreateCheckbox ("", 32, 292, 10, 10)
		GUICtrlSetOnEvent($RBSwitch, "RBstate")
		GUICtrlSetState($RBSwitch,$gRBSwitch)
		GUICtrlCreateLabel("Reboot computer every:", 30,313,120,20)
		$RBTime = GUICtrlCreateCombo ("", 150,310,110,80)
		If $gRBSwitch = 4 OR $gRBSwitch = "" Then
			GUICtrlSetState($RBTime, $GUI_DISABLE)
		EndIf
		GUICtrlSetData(-1,"24 hours|Once a week|Once a month", $gRBTime)
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
		
	GUICtrlCreateGroup ("DF2 Demo / AutoHost Config Options ", 320, 180, 260, 75)
		GUICtrlCreateLabel("Set DF2 Demo Command Key:", 330,200,150,20)
		$ComKey = GUICtrlCreateCombo("", 530,197,40,80)
		GUICtrlSetData(-1,"`|'|" & Chr(230), $gComKey)
		GUICtrlSetOnEvent($ComKey, "WriteComKey")
		GUICtrlCreateLabel("DF2 Demo start up pause:", 330,228,130,20)
		$StartPause = GUICtrlCreateCombo("", 490,225,80,80)
		GUICtrlSetData(-1,"10 seconds|15 seconds|20 seconds|30 seconds|60 seconds", $gStartPause)
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	
	GUICtrlCreateGroup ("DF2 Demo Video Options ", 320, 265, 260, 75)
		GUICtrlCreateLabel ("Driver:", 330,288,50,20)
		$Driver = GUICtrlCreateCombo ("", 445,284,125,80)
		GUICtrlSetData(-1,"Fullscreen (software)|Fullscreen (hardware)|Windowed", $gDriver)
		GUICtrlCreateLabel ("Sreen Resolution: ", 330,313,160,20)
		$Resolution = GUICtrlCreateCombo ("", 490,310,80,80)
		GUICtrlSetData(-1,"320 X 240|400 X 300|512 X 384|640 X 480|800 X 600|1024 X 768", $gResolution)
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
GUICtrlCreateTabitem ("")   ; end tabitem definition	

;---------------- NovaWorld Lobby ---------------

$tab4=GUICtrlCreateTabitem ("View Lobby")
;	GUICtrlCreatePic(@ScriptDir & "\novaworld.gif",480,310,100,42)
	Opt("ExpandVarStrings", 1)
    $oIE = ObjCreate("Shell.Explorer.2")
    $GUIActiveX = GUICtrlCreateObj($oIE, 20, 40, 560,270)
	GUICtrlSetStyle($GUIActiveX, $WS_VISIBLE)
	$oIE.navigate("                                           ")
 ;   $oIE = 0
 
	$ping = Ping ("nw2.novaworld.net")
	If $ping = 0 Then
		$ping = "FAILED TO CONNECT!"
	EndIf
	GUICtrlCreateLabel ("Pinging NovaWorld Lobby: " & $ping,20,315,405,20)
	
;	$btn2 = GUICtrlCreateButton("DemoStats Lobby", 155, 320, 120,-1)
;	$btn3 = GUICtrlCreateButton("NovaWorld Lobby", 25, 320, 120,-1)
;	GUICtrlSetOnEvent($btn2, "LoadDemoStats")
;	GUICtrlSetOnEvent($btn3, "LoadNovaWorld")
GUICtrlCreateTabitem ("")   ; end tabitem definition

;---------------- KFN Map Database ---------------

$tab4=GUICtrlCreateTabitem ("D/load Maps")
    Opt("ExpandVarStrings", 1)
    $oIE2 = ObjCreate("Shell.Explorer.2")
    $GUIActiveX = GUICtrlCreateObj($oIE2, 20, 40, 560,300)
	GUICtrlSetStyle($GUIActiveX, $WS_VISIBLE)
    $oIE2.navigate("                                                       ")
    $oIE2 = 0
GUICtrlCreateTabitem ("")  ; end tabitem definition

;---------------- Error Log ---------------

$tab5=GUICtrlCreateTabitem ("Error Log")
	$myedit=GUICtrlCreateEdit(FileRead(@ScriptDir & "\error.log") , 25,40,555,270,$ES_AUTOVSCROLL+$WS_VSCROLL)
	$btn2 = GUICtrlCreateButton("CLEAR LOG", 155, 320, 120,-1)
	$btn3 = GUICtrlCreateButton("REFRESH LOG", 25, 320, 120,-1)
	GUICtrlSetOnEvent($btn2, "ClearLog")
	GUICtrlSetOnEvent($btn3, "RefreshLog")
GUICtrlCreateTabitem ("")   ; end tabitem definition



;$tab6=GUICtrlCreateTabitem ("Shedule")
; one day a shedule thing will go here - or not...
;GUICtrlCreateTabitem ("")   ; end tabitem definition
 
GUICtrlCreateLabel ($gVersion & " // By T!G3R", 225,366,100,20)
GUICtrlCreateLabel ("copyright 2005 (                              )", 225,380,400,20)
If $gDF2DemoPath = "" Then
	GUICtrlSetState($tab3, $GUI_SHOW)
EndIf
GUISetState()

If $gAHopt2 = 1 Then
	AutoHost()
EndIf

While 1
  Sleep(1000)  ; Idle around
WEnd
 
;----------------------- GUI CONTROL FUNCTIONS BELOW ------------------------- 

Func LoadNovaWorld()
	$oIE.navigate("                                           ")
EndFunc

Func LoadDemoStats()
	$oIE.navigate("                                  ")
EndFunc

Func ReadConfig()
; READ SETTINGS FROM df2.cfg FILE
	If $GcfgPath <> "" Then
		Local $nArray
		 _FileReadToArray($GcfgPath, $nArray)
		For $i = 1 To UBound($nArray) - 1
			If StringInStr($nArray[$i], 'game_password') Then
		        $Split = StringSplit($nArray[$i], '=')
				Global $gGamePassword = StringTrimLeft(StringReplace($Split[2],'"',''),1)
		    EndIf
			If StringInStr($nArray[$i], 'red_password') Then
		    	$Split = StringSplit($nArray[$i], '=')
		    	Global $gRedPassword = StringTrimLeft(StringReplace($Split[2],'"',''),1)
		    EndIf
			If StringInStr($nArray[$i], 'blue_password') Then
		    	$Split = StringSplit($nArray[$i], '=')
		    	Global $gBluePassword = StringTrimLeft(StringReplace($Split[2],'"',''),1)
		    EndIf
			If StringInStr($nArray[$i], 'yellow_password') Then
		    	$Split = StringSplit($nArray[$i], '=')
		    	Global $gYellowPassword = StringTrimLeft(StringReplace($Split[2],'"',''),1)
		    EndIf
			If StringInStr($nArray[$i], 'violet_password') Then
		    	$Split = StringSplit($nArray[$i], '=')
		    	Global $gVioletPassword = StringTrimLeft(StringReplace($Split[2],'"',''),1)
		    EndIf
		
			If StringInStr($nArray[$i], 'video_type') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gDriver = StringTrimLeft(StringReplace($Split[2],'"',''),1)
				If $gDriver = 0 Then
					$gDriver = "Windowed"
				EndIf
				If $gDriver = 1 Then
					$gDriver = "Fullscreen (software)"
				EndIf
				If $gDriver = 2 Then
					$gDriver = "Fullscreen (hardware)"
				EndIf
	        EndIf
			If StringInStr($nArray[$i], 'game_res') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gResolution = StringTrimLeft(StringReplace($Split[2],'"',''),1)
				If $gResolution = 1 Then
					$gResolution = "320 X 240"
				EndIf
				If $gResolution = 2 Then
					$gResolution = "400 X 300"
				EndIf
				If $gResolution = 3 Then
					$gResolution = "512 X 384"
				EndIf
				If $gResolution = 4 Then
					$gResolution = "640 X 480"
				EndIf
				If $gResolution = 5 Then
					$gResolution = "800 X 600"
				EndIf
				If $gResolution = 6 Then
					$gResolution = "1024 X 768"
				EndIf
	        EndIf
			If StringInStr($nArray[$i], 'game_name') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gServerName = StringTrimLeft(StringReplace($Split[2],'"',''),1)
	        EndIf
			If StringInStr($nArray[$i], 'mp_gametype') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gGameType = StringTrimLeft(StringReplace($Split[2],'"',''),1)
				If $gGameType = 0 Then
					$gGameType = "Cooperative"
				EndIf
				If $gGameType = 1 Then
					$gGameType = "Deathmatch"
				EndIf
				If $gGameType = 2 Then
					$gGameType = "Team Deathmatch"
				EndIf
				If $gGameType = 3 Then
					$gGameType = "King Of The Hill"
				EndIf
				If $gGameType = 4 Then
					$gGameType = "Team King Of The Hill"
				EndIf
				If $gGameType = 5 Then
					$gGameType = "Capture The Flag"
				EndIf
				If $gGameType = 8 Then
					$gGameType = "Team Flagball"
				EndIf
	        EndIf
	
			If StringInStr($nArray[$i], 'mp_numteams') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gNoOfTeams = StringTrimLeft(StringReplace($Split[2],'"',''),1)
	        EndIf
	
	        If StringInStr($nArray[$i], 'maxplayers') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gMaxPlayers = StringTrimLeft(StringReplace($Split[2],'"',''),1)
	        EndIf
			If StringInStr($nArray[$i], 'startdelay') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gStartDelay = StringTrimLeft(StringReplace($Split[2],'"',''),1)
	        EndIf
			If StringInStr($nArray[$i], 'replay') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gReplay = StringTrimLeft(StringReplace($Split[2],'"',''),1)
				If $gReplay = 0 Then
					$gReplay = "No Replay"
				EndIf
				If $gReplay = 1 Then
					$gReplay = "Selected Map Only"
				EndIf
				If $gReplay = 2 Then
					$gReplay = "Cycle Through All Maps"
				EndIf
	        EndIf
			If StringInStr($nArray[$i], 'timeout') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gTimeoutBox = StringTrimLeft(StringReplace($Split[2],'"',''),1)
	        EndIf
			If StringInStr($nArray[$i], 'destroybuild') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gDestBuild = StringTrimLeft(StringReplace($Split[2],'"',''),1)
				If $gDestBuild = 0 Then
					$gDestBuild = 4
				EndIf
	        EndIf
			If StringInStr($nArray[$i], 'deathmes') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gDeathMess = StringTrimLeft(StringReplace($Split[2],'"',''),1)
				If $gDeathMess = 0 Then
					$gDeathMess = 4
				EndIf
	        EndIf
			If StringInStr($nArray[$i], 'max_team_lives') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gTeamLives = StringTrimLeft(StringReplace($Split[2],'"',''),1)
	        EndIf
			If StringInStr($nArray[$i], 'time_limit') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gMapTime = StringTrimLeft(StringReplace($Split[2],'"',''),1)
	        EndIf
			If StringInStr($nArray[$i], 'max_kills') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gScoreLimit = StringTrimLeft(StringReplace($Split[2],'"',''),1)
	        EndIf
			If StringInStr($nArray[$i], 'koth_limit') Then
	            $Split = StringSplit($nArray[$i], '=')
	            Global $gKothTime = StringTrimLeft(StringReplace($Split[2],'"',''),1)
	        EndIf
		Next
	ElseIf $GcfgPath = "" Then
		MsgBox(48,"AutoHost " & $gVersion,"Cound not find DF2 Demo 'df2.cfg' file in default location." & @CRLF & "Please use Configure tab to set location of 'Df2dem.exe' on your computer.")	
	EndIf
EndFunc

Func ResetConfig()
	FileDelete($GcfgPath)
    FileCopy($bkcfgPath, $GcfgPath)

	ReadConfig()
	GUICtrlSetData($ServerName,$gServerName)
	GUICtrlSetData($ServerType,"|Serve and Play|Dedicated Server", $gServerType)
	GUICtrlSetData($GameType,"|Cooperative|Deathmatch|Team Deathmatch|King Of The Hill|Team King Of The Hill|Capture The Flag|Team Flagball", $gGameType)
	GUICtrlSetData($Replay,"|No Replay|Selected Map Only|Cycle Through All Maps", $gReplay)
	GUICtrlSetData($StartDelay,$gStartDelay)
	GUICtrlSetState($DeathMess,$gDeathMess)
	GUICtrlSetState($DestBuild,$gDestBuild)
	GUICtrlSetData($MaxPlayers,"|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16", $gMaxPlayers)
	GUICtrlSetData($NoOfTeams,"|2|4", $gNoOfTeams)
	GUICtrlSetData($TimeoutBox,$gTimeoutBox)
	GUICtrlSetData($TeamLives,$gTeamLives)
	GUICtrlSetData($MapTime,$gMapTime)
	GUICtrlSetData($ScoreLimit,$gScoreLimit)
	GUICtrlSetData($KothTime,$gKothTime)
	GUICtrlSetData($Driver,"|Fullscreen (software)|Fullscreen (hardware)|Windowed", $gDriver)
	GUICtrlSetData($Resolution,"|320 X 240|400 X 300|512 X 384|640 X 480|800 X 600|1024 X 768", $gResolution)
	
	MsgBox(64,"AutoHost " & $gVersion & " - df2.cfg file restored", "'df2.cfg' file has been restored to original settings.")
EndFunc

Func PasswordEnabler()
	GUICreate("AutoHost " & $gVersion & " - Password Enabler", 300, 260)
	GUISetOnEvent($GUI_EVENT_CLOSE, "ClosePassword")
	GUICtrlCreateGroup ("Game Password", 10, 10, 280, 50)
		Global $gfGamePassword = GUICtrlCreateInput ("",20,30, 250, 20)
		GUICtrlSetData($gfGamePassword,$gGamePassword)
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	GUICtrlCreateGroup ("Team Passwords", 10, 70, 280, 150)
		GUICtrlCreateLabel ("Blue Team:", 20,93,100,20)
		Global $gfBluePassword = GUICtrlCreateInput ("",120,90, 150, 20)
		GUICtrlSetData($gfBluePassword,$gBluePassword)
		GUICtrlCreateLabel ("Red Team:", 20,123,100,20)
		Global $gfRedPassword = GUICtrlCreateInput ("",120,120, 150, 20)
		GUICtrlSetData($gfRedPassword,$gRedPassword)
		GUICtrlCreateLabel ("Yellow Team:", 20,153,100,20)
		Global $gfYellowPassword = GUICtrlCreateInput ("",120,150, 150, 20)
		GUICtrlSetData($gfYellowPassword,$gYellowPassword)
		GUICtrlCreateLabel ("Violet Team:", 20,183,100,20)
		Global $gfVioletPassword = GUICtrlCreateInput ("",120,180, 150, 20)
		GUICtrlSetData($gfVioletPassword,$gVioletPassword)
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	$SPbtn = GUICtrlCreateButton("Set Password", 170, 230, 120,-1,$BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent($SPbtn, "SetPassword")
	$CPbtn = GUICtrlCreateButton("Clear Passwords", 10, 230, 120)
	GUICtrlSetOnEvent($CPbtn, "ClearPassword")
	GUISetState()
EndFunc

Func ClosePassword()
	GUIDelete("AutoHost " & $gVersion & " - Password Enabler")
EndFunc

Func ClearPassword()
	GUICtrlSetData($gfGamePassword,"")
	GUICtrlSetData($gfRedPassword,"")
	GUICtrlSetData($gfBluePassword,"")
	GUICtrlSetData($gfYellowPassword,"")
	GUICtrlSetData($gfVioletPassword,"")
	SetPassword()
EndFunc

Func SetPassword()
	Local $nArray
    Local $NewFile = @ScriptDir & "/TempTest.txt"
    _FileReadToArray($GcfgPath, $nArray)
    _FileCreate($NewFile)
	For $i = 1 To UBound($nArray) - 1
		If StringInStr($nArray[$i], 'game_password') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & '"'& GUICtrlRead($gfGamePassword) & '"')
        EndIf
		If StringInStr($nArray[$i], 'red_password') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & '"'& GUICtrlRead($gfRedPassword) & '"')
        EndIf
		If StringInStr($nArray[$i], 'blue_password') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & '"'& GUICtrlRead($gfBluePassword) & '"')
        EndIf
		If StringInStr($nArray[$i], 'yellow_password') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & '"'& GUICtrlRead($gfYellowPassword) & '"')
        EndIf
		If StringInStr($nArray[$i], 'violet_password') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & '"'& GUICtrlRead($gfVioletPassword) & '"')
        EndIf
        FileWriteLine($NewFile, $nArray[$i])
    Next
    FileDelete($GcfgPath)
    FileMove($NewFile, $GcfgPath)
	$gGamePassword = GUICtrlRead($gfGamePassword)
	$gRedPassword = GUICtrlRead($gfRedPassword)
	$gBluePassword = GUICtrlRead($gfBluePassword)
	$gYellowPassword = GUICtrlRead($gfYellowPassword)
	$gVioletPassword = GUICtrlRead($gfVioletPassword)
	MsgBox(64,"Password Enabler", "Passwords have been set!")
	GUIDelete("AutoHost " & $gVersion & " - Password Enabler")
EndFunc

Func EditDF2cfg()
	If GUICtrlRead($Driver) = "Windowed" Then
		$cfgDriver = 0
	EndIf
	If GUICtrlRead($Driver) = "Fullscreen (software)" Then
		$cfgDriver = 1
	EndIf
	If GUICtrlRead($Driver) = "Fullscreen (hardware)" Then
		$cfgDriver = 2
	EndIf
	If GUICtrlRead($Resolution) = "320 X 240" Then
		$cfgResolution = 1
	EndIf
	If GUICtrlRead($Resolution) = "400 X 300" Then
		$cfgResolution = 2
	EndIf
	If GUICtrlRead($Resolution) = "512 X 384" Then
		$cfgResolution = 3
	EndIf
	If GUICtrlRead($Resolution) = "640 X 480" Then
		$cfgResolution = 4
	EndIf
	If GUICtrlRead($Resolution) = "800 X 600" Then
		$cfgResolution = 5
	EndIf
	If GUICtrlRead($Resolution) = "1024 X 768" Then
		$cfgResolution = 6
	EndIf
	If GUICtrlRead($ServerType) = "Serve and Play" Then
		$cfgServerType = 0
	EndIf
	If GUICtrlRead($ServerType) = "Dedicated Server" Then
		$cfgServerType = 1
	EndIf
	If GUICtrlRead($GameType) = "Cooperative" Then
		$cfgGameType = 0
	EndIf
	If GUICtrlRead($GameType) = "Deathmatch" Then
		$cfgGameType = 1
	EndIf
	If GUICtrlRead($GameType) = "Team Deathmatch" Then
		$cfgGameType = 2
	EndIf
	If GUICtrlRead($GameType) = "King Of The Hill" Then
		$cfgGameType = 3
	EndIf
	If GUICtrlRead($GameType) = "Team King Of The Hill" Then
		$cfgGameType = 4
	EndIf
	If GUICtrlRead($GameType) = "Capture The Flag" Then
		$cfgGameType = 5
	EndIf
	If GUICtrlRead($GameType) = "Team Flagball" Then
		$cfgGameType = 8
	EndIf
	If GUICtrlRead($Replay) = "No Replay" Then
		$cfgReplay = 0
	EndIf
	If GUICtrlRead($Replay) = "Selected Map Only" Then
		$cfgReplay = 1
	EndIf
	If GUICtrlRead($Replay) = "Cycle Through All Maps" Then
		$cfgReplay = 2
	EndIf
	If GUICtrlRead($DestBuild) = 4 Then
		$cfgDestBuild = 0
	Else
		$cfgDestBuild = GUICtrlRead($DestBuild)
	EndIf
	If GUICtrlRead($DeathMess) = 4 Then
		$cfgDeathMess = 0
	Else
		$cfgDeathMess = GUICtrlRead($DeathMess)
	EndIf
	If GUICtrlRead($Attributes) = "All On" Then
		$cfgAttributes = 1673
	EndIf
	If GUICtrlRead($Attributes) = "All Off" Then
		$cfgAttributes = 134
	EndIf
	If GUICtrlRead($Attributes) = "Newbie" Then
		$cfgAttributes = 650
	EndIf
	If GUICtrlRead($Attributes) = "Standard" Then
		$cfgAttributes = 651
	EndIf
	If GUICtrlRead($Attributes) = "Veteran" Then
		$cfgAttributes = 1161
	EndIf
	If GUICtrlRead($Attributes) = "Alt Set 1" Then
		$cfgAttributes = 654
	EndIf
	If GUICtrlRead($Attributes) = "Alt Set 2" Then
		$cfgAttributes = 1152
	EndIf
	If GUICtrlRead($Attributes) = "Alt Set 3" Then
		$cfgAttributes = 131
	EndIf
	
    Local $nArray
    Local $NewFile = @ScriptDir & "/TempTest.txt"
    _FileReadToArray($GcfgPath, $nArray)
    _FileCreate($NewFile)
    For $i = 1 To UBound($nArray) - 1
		If StringInStr($nArray[$i], 'video_type') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & $cfgDriver)
        EndIf
		If StringInStr($nArray[$i], 'game_res') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & $cfgResolution)
        EndIf
		If StringInStr($nArray[$i], 'game_name') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & '"'& GUICtrlRead($ServerName)& '"')
        EndIf
		If StringInStr($nArray[$i], 'dedicated') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & $cfgServerType)
        EndIf
		If StringInStr($nArray[$i], 'mp_gametype') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & $cfgGameType)
        EndIf
		If StringInStr($nArray[$i], 'mp_numteams') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & GUICtrlRead($NoOfTeams))
        EndIf
        If StringInStr($nArray[$i], 'maxplayers') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & GUICtrlRead($MaxPlayers))
        EndIf
		If StringInStr($nArray[$i], 'startdelay') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & GUICtrlRead($StartDelay))
        EndIf
		If StringInStr($nArray[$i], 'replay') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & $cfgReplay)
        EndIf
		If StringInStr($nArray[$i], 'timeout') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & GUICtrlRead($TimeoutBox))
        EndIf
		If StringInStr($nArray[$i], 'destroybuild') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & $cfgDestBuild)
        EndIf
		If StringInStr($nArray[$i], 'deathmes') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & $cfgDeathMess)
        EndIf
		If StringInStr($nArray[$i], 'max_team_lives') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & GUICtrlRead($TeamLives))
        EndIf
		If StringInStr($nArray[$i], 'attributes') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & $cfgAttributes)
        EndIf
		If StringInStr($nArray[$i], 'time_limit') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & GUICtrlRead($MapTime))
        EndIf
		If StringInStr($nArray[$i], 'max_kills') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & GUICtrlRead($ScoreLimit))
        EndIf
		If StringInStr($nArray[$i], 'koth_limit') Then
            $Split = StringSplit($nArray[$i], '=')
            $nArray[$i] = StringReplace($nArray[$i], $Split[2], " " & GUICtrlRead($KothTime))
        EndIf
        FileWriteLine($NewFile, $nArray[$i])
    Next
    FileDelete($GcfgPath)
    FileMove($NewFile, $GcfgPath)
EndFunc    

Func SetStartUp()
	If GUICtrlRead($AHopt3) = 1 Then
		FileCreateShortcut(@ScriptDir & "\autohost.exe", @StartupDir & "\autohost.lnk")
	EndIf
	If GUICtrlRead($AHopt3) = 4 OR GUICtrlRead($AHopt3) = "" Then
		If FileExists(@StartupDir & "\autohost.lnk") Then
			FileDelete(@StartupDir & "\autohost.lnk")
		EndIf
	EndIf
EndFunc

Func GAstate()
	If GUICtrlRead($Attributes) = "All On" Then
		ControlSetText($gAlreadyOpen, "", "Static48", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static49", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static50", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static51", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static52", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static53", "Yes")
	EndIf
	If GUICtrlRead($Attributes) = "All Off" Then
		ControlSetText($gAlreadyOpen, "", "Static48", "No")
		ControlSetText($gAlreadyOpen, "", "Static49", "No")
		ControlSetText($gAlreadyOpen, "", "Static50", "No")
		ControlSetText($gAlreadyOpen, "", "Static51", "No")
		ControlSetText($gAlreadyOpen, "", "Static52", "No")
		ControlSetText($gAlreadyOpen, "", "Static53", "No")
	EndIf
	If GUICtrlRead($Attributes) = "Newbie" Then
		ControlSetText($gAlreadyOpen, "", "Static48", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static49", "No")
		ControlSetText($gAlreadyOpen, "", "Static50", "No")
		ControlSetText($gAlreadyOpen, "", "Static51", "No")
		ControlSetText($gAlreadyOpen, "", "Static52", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static53", "Yes")
	EndIf
	If GUICtrlRead($Attributes) = "Standard" Then
		ControlSetText($gAlreadyOpen, "", "Static48", "No")
		ControlSetText($gAlreadyOpen, "", "Static49", "No")
		ControlSetText($gAlreadyOpen, "", "Static50", "No")
		ControlSetText($gAlreadyOpen, "", "Static51", "No")
		ControlSetText($gAlreadyOpen, "", "Static52", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static53", "Yes")
	EndIf
	If GUICtrlRead($Attributes) = "Veteran" Then
		ControlSetText($gAlreadyOpen, "", "Static48", "No")
		ControlSetText($gAlreadyOpen, "", "Static49", "No")
		ControlSetText($gAlreadyOpen, "", "Static50", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static51", "No")
		ControlSetText($gAlreadyOpen, "", "Static52", "No")
		ControlSetText($gAlreadyOpen, "", "Static53", "No")
	EndIf
	If GUICtrlRead($Attributes) = "Alt Set 1" Then
		ControlSetText($gAlreadyOpen, "", "Static48", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static49", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static50", "No")
		ControlSetText($gAlreadyOpen, "", "Static51", "No")
		ControlSetText($gAlreadyOpen, "", "Static52", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static53", "Yes")
	EndIf
	If GUICtrlRead($Attributes) = "Alt Set 2" Then
		ControlSetText($gAlreadyOpen, "", "Static48", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static49", "No")
		ControlSetText($gAlreadyOpen, "", "Static50", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static51", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static52", "No")
		ControlSetText($gAlreadyOpen, "", "Static53", "No")
	EndIf
	If GUICtrlRead($Attributes) = "Alt Set 3" Then
		ControlSetText($gAlreadyOpen, "", "Static48", "No")
		ControlSetText($gAlreadyOpen, "", "Static49", "No")
		ControlSetText($gAlreadyOpen, "", "Static50", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static51", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static52", "Yes")
		ControlSetText($gAlreadyOpen, "", "Static53", "Yes")
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","df2demo","Attributes",GUICtrlRead($Attributes))
EndFunc

Func KOTHstate()
	If GUICtrlRead($GameType) <> "King Of The Hill" OR GUICtrlRead($GameType) <> "Team King Of The Hill" Then
		GUICtrlSetState($WCText3, $GUI_DISABLE)
		GUICtrlSetState($KothTime, $GUI_DISABLE)
		GUICtrlSetState($DF2KTupdown, $GUI_DISABLE)
		GUICtrlSetBkColor($KothTime, 0xd4d0c8) ; manually change colour work around (win classic colour)
		GUICtrlSetState($explain3, $GUI_DISABLE)
	EndIf
	If GUICtrlRead($GameType) = "King Of The Hill" OR GUICtrlRead($GameType) = "Team King Of The Hill" Then
		GUICtrlSetState($WCText3, $GUI_ENABLE)
		GUICtrlSetState($KothTime, $GUI_ENABLE)
		GUICtrlSetState($DF2KTupdown, $GUI_ENABLE)
		GUICtrlSetBkColor($KothTime, 0xffffff) ; manually change colour work around (win classic colour)
		GUICtrlSetState($explain3, $GUI_ENABLE)
	EndIf
EndFunc

Func WriteComKey()
	IniWrite(@ScriptDir & "\settings.ini","config","ComKey", GUICtrlRead($ComKey))
EndFunc

Func Terminate()
	If WinExists("Delta Force 2, Demo V1.03.04") Then
		Send($gComKey)
	   	Sleep(500)
	   	Send('quit')
	   	Sleep(500)
	   	Send('{ENTER}')
		Sleep(500)
	EndIf
	If WinExists("BAB.stats v1.2 - DF2DEMO v1.03.04") Then
		If FileExists(StringReplace(GUICtrlRead($BSpath), "babstats.exe", "df2demo10304.cfg")) Then
			;BABstats
			ControlClick ( "BAB.stats v1.2 - DF2DEMO v1.03.04", "", "Button11")
		Else
			;DemoStats
			ControlClick ( "BAB.stats v1.2 - DF2DEMO v1.03.04", "", "Button9")
		EndIf
		Sleep(500)
	EndIf
	$ShutDown = MsgBox(17, "AutoHost " & $gVersion, "AutoHost will shut down in 30 seconds.", 30)
	If $ShutDown = 1 OR $ShutDown = -1 Then
		Exit 0
	Else
		Return
	EndIf
EndFunc

Func ClearLog()
	FileDelete(@ScriptDir & "\error.log")
	GUICtrlSetData($myedit, "Error Log Cleared")
EndFunc

Func RefreshLog()
	GUICtrlSetData($myedit, FileRead(@ScriptDir & "\error.log"))
EndFunc

Func LMstate()
	If GUICtrlRead($LMSwitch) = 1 Then
		GUICtrlSetState($LMText1, $GUI_ENABLE)
		GUICtrlSetState($LMText2, $GUI_ENABLE)
		GUICtrlSetState($LMText3, $GUI_ENABLE)
		If $Dping = " " Then
			ControlSetText($gAlreadyOpen, "", "Static16", "checking....")
			$ping = Ping ("nw2.novaworld.net")
			ControlSetText($gAlreadyOpen, "", "Static16", $ping)
		EndIf
	ElseIf GUICtrlRead($LMSwitch) = 4 Then
		GUICtrlSetState($LMText1, $GUI_DISABLE)
		GUICtrlSetState($LMText2, $GUI_DISABLE)
		GUICtrlSetState($LMText3, $GUI_DISABLE)
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","config","LMswitch",GUICtrlRead($LMSwitch))
EndFunc

Func BSstate()
	If GUICtrlRead($BSSwitch) = 1 Then
		GUICtrlSetState($BSbtn, $GUI_ENABLE)
		GUICtrlSetState($BSpath, $GUI_ENABLE)
		GUICtrlSetBkColor($BSpath, 0xffffff) ; manually change colour work around (win classic colour)
	ElseIf GUICtrlRead($BSSwitch) = 4 Then
		GUICtrlSetState($BSbtn, $GUI_DISABLE)
		GUICtrlSetState($BSpath, $GUI_DISABLE)
		GUICtrlSetBkColor($BSpath, 0xd4d0c8) ; manually change colour work around (win classic colour)
		If GUICtrlRead($StatsSwitch) = 1 Then
			GUICtrlSetState($StatsTime, $GUI_DISABLE)
			GUICtrlSetState($DStext, $GUI_DISABLE)
			GUICtrlSetState($StatsSwitch, $GUI_UNCHECKED)
			IniWrite(@ScriptDir & "\settings.ini","promote","StatsSwitch",GUICtrlRead($StatsSwitch))
		EndIf
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","promote","BSswitch",GUICtrlRead($BSSwitch))
EndFunc

Func PMstate()
	If GUICtrlRead($PromoteSwitch) = 1 Then
		GUICtrlSetState($PromoteTime, $GUI_ENABLE)
		GUICtrlSetState($PromoteText, $GUI_ENABLE)
		GUICtrlSetBkColor($PromoteText, 0xffffff) ; manually change colour work around (win classic colour)
	ElseIf GUICtrlRead($PromoteSwitch) = 4 Then
		GUICtrlSetState($PromoteTime, $GUI_DISABLE)
		GUICtrlSetState($PromoteText, $GUI_DISABLE)
		GUICtrlSetBkColor($PromoteText, 0xd4d0c8) ; manually change colour work around (win classic colour)
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","promote","PromoteSwitch",GUICtrlRead($PromoteSwitch))
EndFunc

Func SetAH4state()
	If GUICtrlRead($AHopt4) = 1 Then
		GUICtrlSetState($StartUpPause, $GUI_ENABLE)
		GUICtrlSetState($SUPupdown, $GUI_ENABLE)
		GUICtrlSetBkColor($StartUpPause, 0xffffff) ; manually change colour work around (win classic colour)
	ElseIf GUICtrlRead($AHopt4) = 4 Then
		GUICtrlSetState($StartUpPause, $GUI_DISABLE)
		GUICtrlSetState($SUPupdown, $GUI_DISABLE)
		GUICtrlSetBkColor($StartUpPause, 0xd4d0c8) ; manually change colour work around (win classic colour)
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","config","AHopt4",GUICtrlRead($AHopt4))
EndFunc

Func RBstate()
	If GUICtrlRead($RBSwitch) = 1 Then
		GUICtrlSetState($RBTime, $GUI_ENABLE)
	ElseIf GUICtrlRead($RBSwitch) = 4 Then
		GUICtrlSetState($RBTime, $GUI_DISABLE)
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","config","RBSwitch",GUICtrlRead($RBSwitch))
EndFunc

Func DSstate()
	If GUICtrlRead($BSSwitch) = 4 Then
		If GUICtrlRead($StatsSwitch) = 1 Then
			MsgBox(0,"Configuration Error - AutoHost " & $gVersion, "You can not turn on DemoStats promotion without hosting a stats server." & @CRLF & "Set the BABstats.exe path in the configure panel first.")
		EndIf
		GUICtrlSetState($StatsTime, $GUI_DISABLE)
		GUICtrlSetState($DStext, $GUI_DISABLE)
		GUICtrlSetState($StatsSwitch, $GUI_UNCHECKED)
	Else
		If GUICtrlRead($StatsSwitch) = 1 Then
			GUICtrlSetState($StatsTime, $GUI_ENABLE)
			GUICtrlSetState($DStext, $GUI_ENABLE)
		ElseIf GUICtrlRead($StatsSwitch) = 4 Then
			GUICtrlSetState($StatsTime, $GUI_DISABLE)
			GUICtrlSetState($DStext, $GUI_DISABLE)
		EndIf
		IniWrite(@ScriptDir & "\settings.ini","promote","StatsSwitch",GUICtrlRead($StatsSwitch))
	EndIf
EndFunc

Func KFNstate()
	If GUICtrlRead($KFNSwitch) = 1 Then
		GUICtrlSetState($KFNTime, $GUI_ENABLE)
		GUICtrlSetState($KFNtext, $GUI_ENABLE)
	ElseIf GUICtrlRead($KFNSwitch) = 4 Then
		GUICtrlSetState($KFNTime, $GUI_DISABLE)
		GUICtrlSetState($KFNtext, $GUI_DISABLE)
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","promote","KFNSwitch",GUICtrlRead($KFNSwitch))
EndFunc

Func PuntCRCstate()
	If GUICtrlRead($PuntCRCSwitch) = 1 Then
		GUICtrlSetState($PuntCRCTime, $GUI_ENABLE)
		GUICtrlSetState($PuntCRCText, $GUI_ENABLE)
	ElseIf GUICtrlRead($PuntCRCSwitch) = 4 Then
		GUICtrlSetState($PuntCRCTime, $GUI_DISABLE)
		GUICtrlSetState($PuntCRCText, $GUI_DISABLE)
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","host","PuntCRCSwitch",GUICtrlRead($PuntCRCSwitch))
EndFunc

Func NetDelaystate()
	If GUICtrlRead($NetDelaySwitch) = 1 Then
		GUICtrlSetState($NetDelayTime, $GUI_ENABLE)
		GUICtrlSetState($NetDelayText, $GUI_ENABLE)
	ElseIf GUICtrlRead($NetDelaySwitch) = 4 Then
		GUICtrlSetState($NetDelayTime, $GUI_DISABLE)
		GUICtrlSetState($NetDelayText, $GUI_DISABLE)
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","host","NetDelaySwitch",GUICtrlRead($NetDelaySwitch))
EndFunc

Func SDMstate()
	If GUICtrlRead($SDMSwitch) = 1 Then
		GUICtrlSetState($SDMTime, $GUI_ENABLE)
		GUICtrlSetState($SDMopt1, $GUI_ENABLE)
		GUICtrlSetState($SDMopt2, $GUI_ENABLE)
		GUICtrlSetState($SDMopt3, $GUI_ENABLE)
		If GUICtrlRead($SDMopt1) = 1 Then
			GUICtrlSetState($SDMrestarts,$GUI_ENABLE)
			GUICtrlSetBkColor($SDMrestarts, 0xffffff) ; manually change colour work around (win classic colour)	
			GUICtrlSetState($SDMupdown,$GUI_ENABLE)
		EndIf
	ElseIf GUICtrlRead($SDMSwitch) = 4 Then
		GUICtrlSetState($SDMTime, $GUI_DISABLE)
		GUICtrlSetState($SDMopt1, $GUI_DISABLE)
		GUICtrlSetState($SDMopt2, $GUI_DISABLE)
		GUICtrlSetState($SDMopt3, $GUI_DISABLE)
		GUICtrlSetState($SDMrestarts,$GUI_DISABLE)
		GUICtrlSetState($SDMupdown,$GUI_DISABLE)
		GUICtrlSetBkColor($SDMrestarts, 0xd4d0c8) ; manually change colour work around (win classic colour)	
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","host","SDMSwitch",GUICtrlRead($SDMSwitch))
EndFunc

Func SDMRstate()
	If GUICtrlRead($SDMopt1) = 1 Then
		GUICtrlSetState($SDMrestarts,$GUI_ENABLE)
		GUICtrlSetState($SDMupdown,$GUI_ENABLE)
		GUICtrlSetBkColor($SDMrestarts, 0xffffff) ; manually change colour work around (win classic colour)	
	ElseIf GUICtrlRead($SDMopt1) = 4 Then
		GUICtrlSetState($SDMrestarts,$GUI_DISABLE)
		GUICtrlSetState($SDMupdown,$GUI_DISABLE)	
		GUICtrlSetBkColor($SDMrestarts, 0xd4d0c8) ; manually change colour work around (win classic colour)	
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","host","SDMRestarts",GUICtrlRead($SDMrestarts))
EndFunc

Func IPMstate()
	If GUICtrlRead($IPMSwitch) = 1 Then
		GUICtrlSetState($IPMText1, $GUI_ENABLE)
		GUICtrlSetState($IPMText2, $GUI_ENABLE)
		GUICtrlSetState($IPMText3, $GUI_ENABLE)
	ElseIf GUICtrlRead($IPMSwitch) = 4 Then
		GUICtrlSetState($IPMText1, $GUI_DISABLE)
		GUICtrlSetState($IPMText2, $GUI_DISABLE)
		GUICtrlSetState($IPMText3, $GUI_DISABLE)
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","host","IPMSwitch",GUICtrlRead($IPMSwitch))
	If $PublicIP = "                                    " Then
		$PublicIP = _GetIP()
	EndIf
	ControlSetText($gAlreadyOpen, "", "Static13", $PublicIP)
EndFunc

Func SHSstate()
	If GUICtrlRead($SHSSwitch) = 1 Then
		GUICtrlSetState($SHSText1,$GUI_ENABLE)
		GUICtrlSetState($SHSText2,$GUI_ENABLE)
		GUICtrlSetState($SHSTime,$GUI_ENABLE)
		GUICtrlSetState($SHSSwitch2,$GUI_ENABLE)
	ElseIf GUICtrlRead($SHSSwitch) = 4 Then
		GUICtrlSetState($SHSText1,$GUI_DISABLE)
		GUICtrlSetState($SHSText2,$GUI_DISABLE)
		GUICtrlSetState($SHSTime,$GUI_DISABLE)
		GUICtrlSetState($SHSSwitch2,$GUI_DISABLE)	
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","host","SHSswitch",GUICtrlRead($SHSSwitch))
EndFunc

Func FindDF2()
	$DFvar = FileOpenDialog("Select location of Df2dem.exe","C:","All (*.*)", 1 + 2)
	GUICtrlSetState($DFpath, $GUI_FOCUS)
	GUICtrlSetData($DFpath,$DFvar)
	IniWrite(@ScriptDir & "\settings.ini","config","DFpath", $DFvar)
	Global $gDF2DemoPath = $DFvar
	$cfgPath = StringReplace($DFvar, "Df2dem.exe", "df2.cfg")
	$bkcfgPath = StringReplace($DFvar, "Df2dem.exe", "df2_bk.cfg")
	If FileExists ($cfgPath) <> 0 Then
		If FileExists ($bkcfgPath) = 0 Then
			FileCopy($cfgPath, $bkcfgPath)
		EndIf
	EndIf
EndFunc

Func FindBS()
	$BSvar = FileOpenDialog("Select location of babstats.exe","C:","All (*.*)", 1 + 2)
	GUICtrlSetState($BSpath, $GUI_FOCUS)
	GUICtrlSetData($BSpath,$BSvar)
	IniWrite(@ScriptDir & "\settings.ini","config","BSpath", $BSvar)
EndFunc

Func WriteIni()
	;WRITE CURRENT SETTINGS TO .ini FILE
	IniWrite(@ScriptDir & "\settings.ini","config","BSswitch",GUICtrlRead($BSSwitch))
	If $BSvar <> "" Then
		IniWrite(@ScriptDir & "\settings.ini","config","BSpath", $BSvar)
	Else
		IniWrite(@ScriptDir & "\settings.ini","config","BSpath", GUICtrlRead($BSpath))
	EndIf
	If $DFvar <> "" Then
		IniWrite(@ScriptDir & "\settings.ini","config","DFpath", $DFvar)
	Else
		IniWrite(@ScriptDir & "\settings.ini","config","DFpath", GUICtrlRead($DFpath))
	EndIf
	IniWrite(@ScriptDir & "\settings.ini","config","ComKey", GUICtrlRead($ComKey))
	IniWrite(@ScriptDir & "\settings.ini","config","AHopt1", GUICtrlRead($AHopt1))
	IniWrite(@ScriptDir & "\settings.ini","config","AHopt2", GUICtrlRead($AHopt2))
	IniWrite(@ScriptDir & "\settings.ini","config","AHopt3", GUICtrlRead($AHopt3))
	IniWrite(@ScriptDir & "\settings.ini","config","AHopt4", GUICtrlRead($AHopt4))
	IniWrite(@ScriptDir & "\settings.ini","config","StartUpPause", GUICtrlRead($StartUpPause))
	IniWrite(@ScriptDir & "\settings.ini","config","RBSwitch", GUICtrlRead($RBSwitch))
	IniWrite(@ScriptDir & "\settings.ini","config","RBTime", GUICtrlRead($RBTime))
	IniWrite(@ScriptDir & "\settings.ini","config","StartPause", GUICtrlRead($StartPause))
	IniWrite(@ScriptDir & "\settings.ini","promote","PromoteSwitch",GUICtrlRead($PromoteSwitch))
	IniWrite(@ScriptDir & "\settings.ini","promote","PromoteText",GUICtrlRead($PromoteText))
	IniWrite(@ScriptDir & "\settings.ini","promote","PromoteTime",GUICtrlRead($PromoteTime))
	IniWrite(@ScriptDir & "\settings.ini","promote","StatsSwitch",GUICtrlRead($StatsSwitch))
	IniWrite(@ScriptDir & "\settings.ini","promote","StatsTime",GUICtrlRead($StatsTime))
	IniWrite(@ScriptDir & "\settings.ini","promote","KFNSwitch",GUICtrlRead($KFNSwitch))
	IniWrite(@ScriptDir & "\settings.ini","promote","KFNTime",GUICtrlRead($KFNTime))
	IniWrite(@ScriptDir & "\settings.ini","host","PuntCRCSwitch",GUICtrlRead($PuntCRCSwitch))
	IniWrite(@ScriptDir & "\settings.ini","host","PuntCRCTime",GUICtrlRead($PuntCRCTime))
	IniWrite(@ScriptDir & "\settings.ini","host","NetDelaySwitch",GUICtrlRead($NetDelaySwitch))
	IniWrite(@ScriptDir & "\settings.ini","host","NetDelayTime",GUICtrlRead($NetDelayTime))
	IniWrite(@ScriptDir & "\settings.ini","host","SDMSwitch",GUICtrlRead($SDMSwitch))
	IniWrite(@ScriptDir & "\settings.ini","host","SDMTime",GUICtrlRead($SDMTime))
	IniWrite(@ScriptDir & "\settings.ini","host","SDMopt1",GUICtrlRead($SDMopt1))
	IniWrite(@ScriptDir & "\settings.ini","host","SDMopt2",GUICtrlRead($SDMopt2))
	IniWrite(@ScriptDir & "\settings.ini","host","SDMopt3",GUICtrlRead($SDMopt3))
	IniWrite(@ScriptDir & "\settings.ini","host","SDMRestarts",GUICtrlRead($SDMrestarts))
	IniWrite(@ScriptDir & "\settings.ini","host","IPMSwitch",GUICtrlRead($IPMSwitch))
	IniWrite(@ScriptDir & "\settings.ini","host","SHSswitch",GUICtrlRead($SHSSwitch))
	IniWrite(@ScriptDir & "\settings.ini","host","SHSTime",GUICtrlRead($SHSTime))
	IniWrite(@ScriptDir & "\settings.ini","host","SHSswitch2",GUICtrlRead($SHSSwitch2))
	IniWrite(@ScriptDir & "\settings.ini","host","LMSwitch",GUICtrlRead($LMSwitch))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","Driver",GUICtrlRead($Driver))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","Resolution",GUICtrlRead($Resolution))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","ServerName",GUICtrlRead($ServerName))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","ServerType","Dedicated Server")
	IniWrite(@ScriptDir & "\settings.ini","df2demo","GameType",GUICtrlRead($GameType))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","NoOfTeams",GUICtrlRead($NoOfTeams))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","MaxPlayers",GUICtrlRead($MaxPlayers))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","StartDelay",GUICtrlRead($StartDelay))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","Replay",GUICtrlRead($Replay))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","TimeoutBox",GUICtrlRead($TimeoutBox))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","DestBuild",GUICtrlRead($DestBuild))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","DeathMess",GUICtrlRead($DeathMess))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","TeamLives",GUICtrlRead($TeamLives))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","Attributes",GUICtrlRead($Attributes))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","MapTime",GUICtrlRead($MapTime))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","ScoreLimit",GUICtrlRead($ScoreLimit))
	IniWrite(@ScriptDir & "\settings.ini","df2demo","KothTime",GUICtrlRead($KothTime))
EndFunc

Func SpecialEvents()
    Select
        Case @GUI_CtrlId = $GUI_EVENT_CLOSE
			WriteIni()
			EditDF2cfg()
			$byebye = MsgBox(1, "AutoHost " & $gVersion, "Shut down AutoHost?")
            If $byebye = 1 Then
				Exit
			Else
				Return
			EndIf 
        Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE 
        Case @GUI_CtrlId = $GUI_EVENT_RESTORE 
    EndSelect
EndFunc