#include <Array.au3>
#Include <Date.au3>
Opt("TrayIconDebug",1) 
Opt("TCPTimeout",20000)
TCPStartup()
$gateway="10.0.0.138"
$n=58
$intruder=""
$x=@DesktopWidth/2
$y=5
$servertime=""
$recv ="Locating Time Server. . ."
while @error =0
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if $n=60 Then
	ToolTip($Status&"  "&StringLeft($Torrentcache,5)&@cr&"Free Ram: "&Int($mem[2]/1024)&" MB"&@CR&"Temp Space: "&$Temp&" MB"&@CR&"C ("&$spacec&") D ("&$spaced&") E ("&$spacee&")"&@CR&"F ("&$spacef&") G ("&$spaceg&") H ("&$spaceh&") MB"&@CR&"IE.D. :"&$IeD&" Est.T :"&$Iet&@CR&"DA:"&$dapcomp&"(MB) "&$dapSpeed&"(Kb/s)"&@CR&"Mov: "&$timeM&$timeV,$x,$y,"Checking Internet Time.",$icon)
	 $n=0
 $socket = TCPConnect('129.6.15.28', 37)
        While $recv <> ""
            $recv = TCPRecv($socket, 512)
            If $recv <> '' Then
                $servertime = _DateAdd('s', Asc(StringMid($recv, 1, 1)) * 256 ^ 3 + Asc(StringMid($recv, 2, 1)) * 256 ^ 2 _
                         + Asc(StringMid($recv, 3, 1)) * 256 + Asc(StringMid($recv, 4, 1)), '1900/01/01 02:00:00')
			ExitLoop
					 EndIf
		WEnd
				 
EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	$n=$n+1
AutoItSetOption("WinTitleMatchMode", 4)
$Torrent=WinGetTitle("classname=µTorrent4823DF041B09","")
$Status=StringLeft($Torrent,15)
$Torrentcache=ControlGetText("classname=µTorrent4823DF041B09","",69)
$mem=0
$mem = MemGetStats()
$Router=ping($gateway,1000)
if $Router=0 then 
	$Router="Offline"
	;TrayTip("Router State","Router Gone Offline",5,3)
	$icon=3
$Title="Offline "&$Status
	TraySetIcon ("offline.ico")
EndIf

if $Router=2 then 
	$Router="Offline"
;	TrayTip("Router State","Router Gone Offline",5,3)
TraySetIcon ("offline.ico")
$icon=3
$Title="Offline "&$Status
EndIf

if $Router = 1 then 
TraySetIcon ("right.ico")
$icon=0
$Title=""
EndIf
$IeD=ControlGetText("classname=#32770","",4368)
$Iet=StringLeft(ControlGetText("classname=#32770","",4357),13)
if $IeD="" and $Iet ="" then 
	$IeD=WinGetTitle("classname=MozillaUIWindowClass")
	if StringLen ( $IeD ) > 25 then $IeD=""
	if StringLen ( $IeD ) < 25 then $IeD=StringLeft($IeD,3)
	$Iet =""
EndIf



if $Router=1 then 
	$Router="Online"	
	$Title=$intruder
	$icon=1
EndIf
$timeM=ControlGetText("classname=MediaPlayerClassicW","",130)
$timeV=StatusbarGetText("classname=wxWindowClassNR","",1)
$spaceC =Int(DriveSpaceFree( "c:\" ))
$spaced =Int(DriveSpaceFree( "d:\" ))
$spacee =Int(DriveSpaceFree( "e:\" ))
$spacef =Int(DriveSpaceFree( "f:\" ))
$spaceg =Int(DriveSpaceFree( "g:\" ))
$spaceh =Int(DriveSpaceFree( "h:\" ))
if $spaceC < 50 then FileDelete("C:\Documents and Settings\Family\Local Settings\Temp\*.wav")
	
If $Status="" then $Status="T. Not Started"
if $timeM="" and $timeV="" Then $timeM="No Media"
$sizebye=DirGetSize(@TempDir, 0)+DirGetSize(@UserProfileDir&"\Local Settings\Temporary Internet Files\Content.IE5", 0)+DirGetSize(@WindowsDir&"\prefetch", 0)
$val=($sizebye/1024)/1024
$temp = Int($val)
$dapSfull=ControlGetText("classname=#32770","",1008)
$dapcfull=ControlGetText("classname=#32770","",1004)
$dapcomp=StringLeft($dapcfull,6)
$dapSpeed=StringLeft($dapSfull,5)
$intruder=FileGetSize("G:\shred\intrded.exe")
if $intruder=0 then $intruder=$servertime
if $intruder > 0 then 
	$intruder="We Have an Intruder.!"
	$icon=2
EndIf

;~ $win=ControlListView ("classname=µTorrent4823DF041B09", "", $list, "GetText", 0, 5)
;~ $win2=ControlListView ("classname=µTorrent4823DF041B09", "", $list, "GetText", 0, 2)
;~ $ivan=ControlListView ("classname=µTorrent4823DF041B09", "", $list, "GetText", 1, 5)
;~ $ivan2=ControlListView ("classname=µTorrent4823DF041B09", "", $list, "GetText", 1, 2)
;MsgBox(0,"",$win)
;ToolTip("DieHard  : "&$win&"     "&$win2&"   "&@CR&$ivan&"   "&$ivan2,850,550,"")
;"T. Stat: "&$Status&@CR&
;&@CR&"Net state: "&$Router
ToolTip($Status&"  "&StringLeft($Torrentcache,5)&@cr&"Free Ram: "&Int($mem[2]/1024)&" MB"&@CR&"Temp Space: "&$Temp&" MB"&@CR&"C ("&$spacec&") D ("&$spaced&") E ("&$spacee&")"&@CR&"F ("&$spacef&") G ("&$spaceg&") H ("&$spaceh&") MB"&@CR&"IE.D. :"&$IeD&" Est.T :"&$Iet&@CR&"DA:"&$dapcomp&"(MB) "&$dapSpeed&"(Kb/s)"&@CR&"Mov: "&$timeM&$timeV,$x,$y,$Title,$icon)
FileWriteLine("g:\downloads\grc\status.txt",$Title&"     "&$Status&@CRLF&$Torrentcache&@CRLF&"Free Ram: "&Int($mem[2]/1024)&" MB"&@CRLF&"Temp Space: "&$Temp&" MB"&@CRLF&"C ("&$spacec&") D ("&$spaced&") E ("&$spacee&")"&@CRLF&"F ("&$spacef&") G ("&$spaceg&") H ("&$spaceh&") MB"&@CRLF&"IE.D. :"&$IeD&" Est.T :"&$Iet&@CRLF&"DA:"&$dapcomp&"(MB) "&$dapSpeed&"(Kb/s)"&@CRLF&"Mov: "&$timeM&$timeV)
FileWriteLine("g:\downloads\grc\status.txt"," - - - - - - - - -"&@HOUR&" : "&@MIN)
$logsize=FileGetSize("g:\downloads\grc\status.txt")
if $logsize> 50000 then FileDelete("g:\downloads\grc\status.txt")
$x=FileReadLine("positions.txt",1)
$y=FileReadLine("positions.txt",2)
sleep(1000)
WEnd
