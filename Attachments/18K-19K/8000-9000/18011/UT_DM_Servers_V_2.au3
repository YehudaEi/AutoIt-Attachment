#include <File.au3>
AutoItSetOption("TrayIconDebug", 1)
;Mutators
;Class name  						Game type  
;BonusPack.MutCrateCombo  			Bonus Combos  
;Onslaught.MutBigWheels  			BigWheels  
;Onslaught.MutLightweightVehicles  	Lightweight Vehicles  
;Onslaught.MutOnslaughtWeapons  	Onslaught Weapons  
;Onslaught.MutWheeledVehicleStunts  Stunt Vehicles  
;OnslaughtFull.MutVehicleArena  	Vehicle Arena  
;UTClassic.MutUTClassic  			UT Classic  
;UTClassic.MutUseLightning  		Lightning Guns  
;UTClassic.MutUseSniper  			Sniper Rifles  
;UTV2004s.utvMutator  				UTV2004S  
;UnrealGame.MutBerserk  			Super Berserk  
;UnrealGame.MutBigHead  			BigHead  
;UnrealGame.MutGameSpeed  			Game Speed  
;UnrealGame.MutLowGrav  			LowGrav  
;UnrealGame.MutMovementModifier  	Air Control  
;XGame.MutFastWeapSwitch  			UT2003 Style  
;XGame.MutInstaGib  				InstaGib  
;XGame.MutNoAdrenaline  			No Adrenaline  
;XGame.MutQuadJump  				QuadJump  
;XGame.MutRegen  					Regeneration  
;XGame.MutSlomoDeath  				Slow Motion Corpses  
;XGame.MutSpeciesStats  			Species Statistics  
;XGame.MutUDamageReward  			UDamage Reward  
;XGame.MutVampire  					Vampire  
;XGame.MutZoomInstagib  			Zoom InstaGib  
;XWeapons.MutArena  				Arena  
;XWeapons.MutNoSuperWeapon  		No SuperWeapons  

;These mutators were included with the official bonuspacks. 
;OnslaughtBP.MutBonusVehicles  (replaces some vehicles of retail Onslaught maps with the ones in the bonus pack) 

;Game Types-------------------------------------------------------------------
;ONS-Torlan?game=Onslaught.ONSOnslaughtGame			;Onslaught
;DM-Rankin?game=XGame.xTeamGame						;Team Deathmatch
;AS-MotherShip?game=UT2k4Assault.ASGameInfo			;Assault
;CTF-FaceClassic?game=XGame.xCTFGame				;Capture the Flag
;BR-Serenity?game=XGame.xBombingRun					;Bombing Run
;DM-Rankin?game=XGame.xDeathMatch					;Deathmatch
;DM-Deck17?game=BonusPack.xMutantGame				;Mutant
;DM-Antalus?game=SkaarjPack.Invasion				;Invasion
;DM-Morpheus3?game=BonusPack.xLastManStandingGame	;Last man standing

;Demo Recording
;?Demorec=nameofdemo (place this in the command line and change the name to whatever you like)

;Mutators---------------------------------------------------------------------
$Mute01 = "BonusPack.MutCrateCombo"  			;Bonus Combos  
$Mute02 = "Onslaught.MutBigWheels"     			;BigWheels  
$Mute03 = "Onslaught.MutLightweightVehicles"  	;Lightweight Vehicles  
$Mute04 = "Onslaught.MutOnslaughtWeapons"  		;Onslaught Weapons  
$Mute05 = "Onslaught.MutWheeledVehicleStunts"  	;Stunt Vehicles  
$Mute06 = "OnslaughtFull.MutVehicleArena"  		;Vehicle Arena  
$Mute07 = "UTClassic.MutUTClassic"  			;UT Classic  
$Mute08 = "UTClassic.MutUseLightning"  			;Lightning Guns  
$Mute09 = "UTClassic.MutUseSniper"  			;Sniper Rifles  
$Mute10 = "UTV2004s.utvMutator"  				;UTV2004S  
$Mute11 = "UnrealGame.MutBerserk"  				;Super Berserk  
$Mute12 = "UnrealGame.MutBigHead"  				;BigHead  
$Mute13 = "UnrealGame.MutGameSpeed"  			;Game Speed  
$Mute14 = "UnrealGame.MutLowGrav"  				;LowGrav  
$Mute15 = "UnrealGame.MutMovementModifier"  	;Air Control  
$Mute16 = "XGame.MutFastWeapSwitch"  			;UT2003 Style  
$Mute17 = "XGame.MutInstaGib"  					;InstaGib  
$Mute18 = "XGame.MutNoAdrenaline"  				;No Adrenaline  
$Mute19 = "XGame.MutQuadJump"  					;QuadJump  
$Mute20 = "XGame.MutRegen"  					;Regeneration  
$Mute21 = "XGame.MutSlomoDeath"  				;Slow Motion Corpses  
$Mute22 = "XGame.MutSpeciesStats"  				;Species Statistics  
$Mute23 = "XGame.MutUDamageReward"  			;UDamage Reward  
$Mute24 = "XGame.MutVampire"  					;Vampire  
$Mute25 = "XGame.MutZoomInstagib"  				;Zoom InstaGib  
$Mute26 = "XWeapons.MutArena"  					;Arena  
$Mute27 = "XWeapons.MutNoSuperWeapon"  			;No SuperWeapons  
$Mute28 = "OnslaughtBP.MutBonusVehicles"  		;replaces some vehicles of retail Onslaught maps with the ones in the bonus pack

;General---------------------------------------------------------------------
$AdminPass = "L00sher!"
$MaxPlayer1 = "16"
$MaxPlayer2 = "32"
$Server1a = "UT2004 DM Server 01"
$Server1b = "DM Server 01"
$Server2a = "UT2004 DM Server 02"
$Server2b = "DM Server 02"
$Server3a = "UT2004 DM Server 03"
$Server3b = "DM Server 03"

;Server01--------------------------------------------------------------------
$SIP01 = "192.168.100.25"
$Port01 = "7004"
$WebAdminPort01 = "83"
$WEBIP01 = "                         "

;Server02--------------------------------------------------------------------
$SIP02 = "192.168.100.25"
$Port02 = "7005"
$WebAdminPort02 = "84"
$WEBIP02 = "                         "

;Server03--------------------------------------------------------------------
$SIP03 = "192.168.100.25"
$Port03 = "7006"
$WebAdminPort03 = "85"
$WEBIP03 = "                         "

;Run DM Server01---------------------------------------------------------------------------
_FileWritetoLine ("dmserver01.ini","297","ServerName=" & $Server1a ,"1")
_FileWritetoLine ("dmserver01.ini","298","ShortName=" & $Server1b,"1")
_FileWritetoLine ("dmserver01.ini","528","MaxPlayers=" & $MaxPlayer2 ,"1")
_FileWritetoLine ("dmserver01.ini","506","ListenPort=" & $WebAdminPort01,"1")
;_FileWritetoLine ("dmserver01.ini","989","bRestartServerOnPortSwap=False" ,"1")
_FileWritetoLine ("dmserver01.ini","13","Port=" & $Port01,"1")
_FileWritetoLine ("dmserver01.ini","521","AdminPassword=" & $AdminPass ,"1")
_FileWritetoLine ("dmserver01.ini","600","bForceRespawn=True" ,"1")
Run ("ucc server DM-Rankin?game=XGame.xDeathMatch?Mutator=BonusPack.MutCrateCombo,UnrealGame.MutBigHead,UnrealGame.MutLowGrav,XGame.MutQuadJump ini=dmserver01.ini log=server.log -lanplay copy server.log servercrash.log multihome=" & $SIP01)
Sleep(2000)
WinSetTitle( "C:\Game_Servers\DedicatedServer3369-BonusPack\System\ucc.exe", "", "Deathmatch01" )
;Sleep (5000)
WinWait( "Deathmatch01", "" )
Sleep( 1000 )

;Open DM Server 01 Admin page---------------------------------------------------------------------------
Run ( "C:\Program Files\Internet Explorer\iexplore.exe", "")
WinWait ( "Internet Explorer Enhanced Security Configuration is enabled - Windows Internet Explorer", "" )
WinActivate ( "Internet Explorer Enhanced Security Configuration is enabled - Windows Internet Explorer", "" )
ControlSend ( "Internet Explorer Enhanced Security Configuration is enabled - Windows Internet Explorer", "", "Edit1", $WEBIP01 & "{Enter}" ) 
WinWait ( "Connect to " & $SIP01, "" )
WinActivate ( "Connect to " & $SIP01, "" )
ControlSend ( "Connect to " & $SIP01, "", "Edit2", "admin" & "{Enter}" )
;ControlSend ( "Connect to " & $SIP01, "", "Edit3", "L00sher!" & "{Enter}" )
Send( "{Enter}" )
WinWait( "UT2004 DM Server 01 - Unreal Tournament 2004 - Web Admin - Windows Internet Explorer", "" )

;Run DM Server02---------------------------------------------------------------------------
_FileWritetoLine ("dmserver02.ini","297","ServerName=" & $Server2a ,"1")
_FileWritetoLine ("dmserver02.ini","298","ShortName=" & $Server2b,"1")
_FileWritetoLine ("dmserver02.ini","528","MaxPlayers=" & $MaxPlayer2 ,"1")
_FileWritetoLine ("dmserver02.ini","506","ListenPort=" & $WebAdminPort02,"1")
;_FileWritetoLine ("dmserver02.ini","989","bRestartServerOnPortSwap=False" ,"1")
_FileWritetoLine ("dmserver02.ini","13","Port=" & $Port02,"1")
_FileWritetoLine ("dmserver02.ini","521","AdminPassword=" & $AdminPass ,"1")
_FileWritetoLine ("dmserver02.ini","600","bForceRespawn=True" ,"1")
Run ("ucc server DM-Rankin?game=XGame.xDeathMatch?Mutator=BonusPack.MutCrateCombo,UnrealGame.MutBigHead,UnrealGame.MutLowGrav,XGame.MutQuadJump ini=dmserver02.ini log=server.log -lanplay copy server.log servercrash.log multihome=" & $SIP02)
Sleep(2000)
WinSetTitle( "C:\Game_Servers\DedicatedServer3369-BonusPack\System\ucc.exe", "", "Deathmatch02" )
;Sleep (5000)
WinWait( "Deathmatch02", "" )
Sleep( 1000 )

;Open DM Server 02 Admin page---------------------------------------------------------------------------
WinWait ( "UT2004 DM Server 01 - Unreal Tournament 2004 - Web Admin - Windows Internet Explorer", "" )
WinActivate ( "UT2004 DM Server 01 - Unreal Tournament 2004 - Web Admin - Windows Internet Explorer", "" )
Send ( "^t" )
WinWait ( "Welcome to Tabbed Browsing - Windows Internet Explorer", "" )
WinActivate ( "Welcome to Tabbed Browsing - Windows Internet Explorer", "" )
Sleep(500)
ControlSend ( "Welcome to Tabbed Browsing - Windows Internet Explorer", "", "Edit1", $WEBIP02 & "{Enter}" ) 
WinWait ( "Connect to " & $SIP02, "" )
WinActivate ( "Connect to " & $SIP02, "" )
ControlSend ( "Connect to " & $SIP02, "", "Edit2", "admin" & "{Enter}" )
;ControlSend ( "Connect to " & $SIP01, "", "Edit3", "L00sher!" & "{Enter}" )
Send( "{Enter}" )

;Run DM Server03---------------------------------------------------------------------------
;_FileWritetoLine ("dmserver03.ini","297","ServerName=" & $Server3a ,"1")
;_FileWritetoLine ("dmserver03.ini","298","ShortName=" & $Server3b,"1")
;_FileWritetoLine ("dmserver03.ini","528","MaxPlayers=" & $MaxPlayer2 ,"1")
;_FileWritetoLine ("dmserver03.ini","506","ListenPort=" & $WebAdminPort03,"1")
;_FileWritetoLine ("dmserver03.ini","989","bRestartServerOnPortSwap=False" ,"1")
;_FileWritetoLine ("dmserver03.ini","13","Port=" & $Port03,"1")
;_FileWritetoLine ("dmserver03.ini","521","AdminPassword=" & $AdminPass ,"1")
;_FileWritetoLine ("dmserver03.ini","600","bForceRespawn=True" ,"1")
;Run ("ucc server DM-Rankin?game=XGame.xDeathMatch ini=dmserver03.ini log=server.log -lanplay copy server.log servercrash.log" multihome=" & $SIP03)
;Sleep(2000)
;WinSetTitle( "C:\Game_Servers\DedicatedServer3369-BonusPack\System\ucc.exe", "", "Deathmatch03" )
;Sleep (5000)

;Open DM Server 03 Admin page---------------------------------------------------------------------------
;WinWait ( "UT2004 DM Server 01 - Unreal Tournament 2004 - Web Admin - Windows Internet Explorer", "" )
;WinActivate ( "UT2004 DM Server 01 - Unreal Tournament 2004 - Web Admin - Windows Internet Explorer", "" )
;Send ( "^t" )
;WinWait ( "Welcome to Tabbed Browsing - Windows Internet Explorer", "" )
;WinActivate ( "Welcome to Tabbed Browsing - Windows Internet Explorer", "" )
;Sleep(500)
;ControlSend ( "Welcome to Tabbed Browsing - Windows Internet Explorer", "", "Edit1", $WEBIP03 & "{Enter}" ) 
;WinWait ( "Connect to " & $SIP03, "" )
;WinActivate ( "Connect " & $SIP03, "" )
;ControlSend ( "Connect to " & $SIP03, "", "Edit2", "admin" & "{Enter}" )
;ControlSend ( "Connect to " & $SIP01, "", "Edit3", "L00sher!" & "{Enter}" )
;Send( "{Enter}" )