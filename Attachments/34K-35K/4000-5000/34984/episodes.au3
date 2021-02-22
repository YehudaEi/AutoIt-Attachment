$g_szVersion = "EpisodesInfo v2"
If WinExists($g_szVersion) Then Exit
AutoItWinSetTitle($g_szVersion)

;New in v2.03
;Does actually insert songs from TVrage now :)

;New in v2.02
;Removes Source: from plot

;New in v2.01
;Supports songs from TVRage also
;Removed a leftover msgbox

;New in v2.00
;Tested on IMDB, TVRage, TV.COM (Non printed episode guide) and Barnes & Noble (Chapters only)
;Added variables instead of having to uncomment lines when inserting GuestStars, Director, Writer & Story from TVRage
;New - Should now handle multiple plotlines from TVRage if they are seperated by an empty line

;New in v1.9
;Will now ,after entering the last data, stop the data entry
;Added further handling of Barnesandnobles
;Added further handling of TVRage

;New in v1.8
;Rewrote handling of Barnesandnobles, will now remove the 0. entries
;Will also work with multidisc scene indexes

;New in v1.7
;Fixed 2 bugs in barnesandnobles support
;There is one last issue with this support, if there is a chapter 0 then it will get truncated by 6 characters, but as this is only used for scene selection
;I can't won't be bothered to fix that a.t.m., you must manually be delete/change title after the script has run.

;New in v1.6
;As requested by drever44 it now supports chapters as found on www.barnesandnobles.com
;To use mark from Scene index to the last chapter

;New in v1.5
;Should support all variations of TVrage episode guides
;Should now also be able to inster the Director, Gueststars & Writer in the plot field if availble in the TVrage episode lists
;Locate the InsertDirector() line, if you remove the semicolon in front it will enter the director on a new line in the Plot field, only works on TVrage
;Locate the InsertGueststar() line, if you remove the semicolon in front it will enter the gueststars on a new line in the Plot field, only works on TVrage
;Locate the InsertWriter() line, if you remove the semicolon in front it will enter the writer on a new line in the Plot field, only works on TVrage

;New in v1.4
;Support for TV.com, changed episode guide style

;New in v1.3
;Support for TV.com, changed episode guide
;Support for Director & Gueststar
;Locate the "if $director <> "" then InsertDirector()" line and remove the semicolon in front it will enter the director on a new line in the Plot field
;Locate the "if $gueststar <> "" then InsertGueststar()" line and remove the semicolon in front it will enter the gueststars on a new line in the Plot field

;New in v 1.2
;It can now parse the airdates from and enter them
;This script will read the Episode title & plot from data copied to the clipboard
;It can use either IMDB, TVRage or TV.com episode listings formatted as follows. Example data from Buffy S1E1
;line 1
;Season 1, Episode 1: Welcome to the Hellmouth
;line 2
;Original Air Date: 10 March 1997
;line 3
;Buffy Summers has just moved to Sunnydale with her mother.
;Any other lines are ignored
;It will also parse the airdate and enter this
;or it can use TVRage episode listings formatted as follows. Example data from Buffy S1E1
;Line 1
;1 :01x01 - Welcome to the Hellmouth (1) (Mar/10/1997)
;Line 2
;In the pilot episode, we find that a young vampire slayer, Buffy Summers, has left her home in LA and has..........
;It will also read the Director & Gueststar data
;Any other lines are ignored
;It will also parse the airdate and enter this
;or it can use TV.com episode listings formatted as follows. Example data from Buffy S1E1
;Line 1
;1. Pilot
;it will search for airdate and the second line after is presumed to be the plot line
;In the pilot episode, we find that a young vampire slayer, Buffy Summers, has left her home in LA and has..........
;It will also read the Director & Gueststar data
;Any other lines are ignored
;It will also parse the airdate and enter this
;Usage:
;Open the Episode window in MovieCollector
;Mark the needed information on IMDB or TVRage and copy to clipboard
;Run this script
;Sit back and relax while the information is copied to MovieCollector

;Feel free to use anything you can

;Henrik Rostoft
;Script made using AutoIt v3 http://www.autoitscript.com/
HotKeySet("{PAUSE}", "Terminate")
Opt("MouseCoordMode", 2)   ; 2 = relative coords to the client area of the active window
Opt("PixelCoordMode", 2)   ; 2 = relative coords to the client area of the defined window
;##################################
; Include
;##################################
#Include<file.au3>
;##################################
; Variables
;##################################
$clipboarddata = ""
dim $clipdata[500]
$y = ""
$x = ""
$file = ""
$Plot = ""
$IsTrue = ""
$TempFile = ""
$ok = ""
$EpisodeTitle = ""
$EpisodeTitleLeft = ""
$Type = ""
$AirDate = ""
$tvrage = ""
$monthletters = ""
$month = ""
$day = ""
$year = ""
$cleanleft = ""
$cleanright = ""
$director = ""
$writer = ""
$gueststar = ""
$story = ""
$temp = ""
$test = ""
$moreplot = ""
$exittvrage = ""
$plotcount = ""
$exitplottvrage  = ""
$songs = ""

;TVRage only (so far)
;Change the value to Yes if the Director should be inserted in plot field
$insertdirector = "No"
;Change the value to Yes if the Guest Starts should be inserted in plot field
$insertgueststars = "No"
;Change the value to Yes if the Writers should be inserted in plot field
$InsertWriter = "No"
;Change the value to Yes if the Story writers should be inserted in plot field
$InsertStory = "No"
;Change the value to Yes if the Songs should be inserted in plot field
$InsertSongs = "Yes"

;Writes contents of clipboard to file
$clipboarddata = ClipGet()
$TempFile = FileOpen("season.txt", 2)
FileWriteLine ($TempFile, $clipboarddata)
FileClose($TempFile)
$file = FileOpen("Season.txt", 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

;Reads full contents of season.txt
$x = 1
While 1
    $line = FileReadLine($file)
    If @error = -1 Then ExitLoop
   $clipdata[$x] = $line
;    MsgBox(0, "Line read:", $line)
   $x = $x + 1
Wend
FileClose($file)

$count = "1"
TestForType()
If $Type = "TVRage" then
   LoopTVRage()
   Elseif $type = "IMDB" Then
      LoopIMDB()
   ElseIf $type = "BANDN" Then
      DoStuffBandN()
   Else
      LoopTVcom()
   EndIf
ExitEntry()
Exit

;Read first line see if it contains Season as the first word
;if yes read the next 2 lines and enter into Episode window
;if no advance one line and repeat
Func LoopIMDB()
while $Count <> $x + 1
   TestForSeasonIMDB()
   if $ok = "Ok" then
      DoStuffIMDB()
   Else
      $count = $count + 1
   EndIf
WEnd
EndFunc

Func LoopTVRage()
while $Count <> $x + 1
   TestForSeasonTVRage()
   if $ok = "Ok" then
      DoStuffTVRage()
   Else
      $count = $count + 1
   EndIf
$director = ""
$writer = ""
$story = ""
$gueststar = ""
$moreplot = ""
$plotcount = ""
$exitplottvrage  = ""
$songs = ""
WEnd
EndFunc

Func DoStuffBandN()
   SkipDiscBandN()
   GetClipdataBandN()
EndFunc

Func DoStuffIMDB()
   GetClipdataIMDB()
   InsertInEpisode()
EndFunc

Func GetClipdataIMDB()
$result = StringInStr($clipdata[$count], ":")
$EpisodeTitle = StringTrimLeft($clipdata[$count], $result +1)
$AirNr = $Count + 1
$PlotNr = $Count + 2
$Airdate = $Clipdata[$AirNr]
$Plot = $Clipdata[$PlotNr]
if stringinstr($plot,": Episode") <> 0 Then
   $plot = ""
EndIf
if stringinstr($plot,", Episode") <> 0 and stringinstr($plot,"Season") <> 0 Then
   $plot = ""
EndIf
$count = $Count + 1
ConvertDateIMDB()
EndFunc

Func DoStuffTVRage()
   GetClipdataTVRage()
   InsertInEpisode()
EndFunc

Func GetClipdataTVRage()
$plot = ""
$tvrage = $clipdata[$count]
ConvertDateTVRage()
$result = StringInStr($clipdata[$count], " - ")
$EpisodeTitleLeft = StringTrimLeft($clipdata[$count], $result +2)
$EpisodeTitle = StringTrimRight($EpisodeTitleLeft,14)

;Find plot
While StringLen($plot) < 2
$PlotNr = $count + 1
$Plot = $clipdata[$PlotNr]
$count = $count + 1
if stringInStr($plot,"View Trailer") <> 0  then
   $plot = ""
EndIf
WEnd
ReadMultiLinePlotTVRage()
CheckForNextEpisodeTVRage()
while $exittvrage <> "Done"
   CheckForNextEpisodeTVRage()
WEnd
EndFunc

Func ReadMultiLinePlotTVRage()
$plotcount = $count + 1
while $exitplottvrage <> "Done"
$temp = $clipdata[$PlotCount]
if StringRegExp($clipdata[$plotCount], '\(.../../....\)') <> 1 Then
      $exitplottvrage = ""
   Else
      $exitplottvrage = "Done"
   endif
if $plotCount = $x + 1 then $exitplottvrage = "Done"
if StringInStr($temp,"Guest Stars:") <> 0 Then
   $gueststar = $temp
   $moreplot = "No"
ElseIf    stringInStr(StringLeft($temp,9),"Director:") <> 0 Then
   $director = $temp
   $moreplot = "No"
ElseIf   stringInStr(StringLeft($temp,7),"Writer:") <> 0 Then
   $writer = $temp
   $moreplot = "No"
ElseIf StringInStr($temp,"Story:") <> 0 Then
   $story = $temp
   $moreplot = "No"
ElseIf StringInStr($temp,"Songs:") <> 0 Then
   $songs = $temp
   $moreplot = "No"
ElseIf StringInStr($temp,"Source:") <> 0 Then
   $moreplot = "No"

ElseIf $temp<>"" And $exitplottvrage <>  "Done" and $moreplot <> "No" then
   $plot = $plot & @CRLF & $temp
else
EndIf
$plotcount = $plotcount + 1
WEnd
EndFunc


Func CheckForNextEpisodeTVRage()
$count = $count + 1
if StringRegExp($clipdata[$count], '\(.../../....\)') <> 1 Then
      $exittvrage = ""
   Else
      $exittvrage = "Done"
   endif
if $Count = $x + 1 then $exittvrage = "Done"
EndFunc

Func TestForSeasonTvRage()
if StringRegExp($clipdata[$count], '\(.../../....\)') <> 1 Then
      $ok = "Next"
      Else
      $ok = "Ok"
   endIf
EndFunc

Func TestForSeasonIMDB()
if StringLeft($clipdata[$count],6) <> "Season" Then
      $ok = "Next"
      Else
      $ok = "Ok"
   endIf
EndFunc

Func TestForType()
if StringRegExp($clipdata[$count], '\(.../../....\)') = 1 Then
      $Type = "TVRage"
   ElseIf StringLeft($clipdata[$count],6) = "Season" and StringInStr($clipdata[$count],"Aired") Then
      $Type = "TVCOM"
   ElseIf StringLeft($clipdata[$count],12) = "Scene Index" Then
      $Type = "BANDN"
   Else
      $Type = "IMDB"
   endIf
EndFunc

Func InsertInEpisode()
WinActivate ("Episode:")
WinWaitActive ("Episode:")
WinMove("Episode","",Default,Default,560,365)
;Click in Episode: Title
MouseClick ("left", 27,31)
send("{HOME}")
Send("+{END}")
send($EpisodeTitle,1)
MouseClick ("left", 28,116)
send("{HOME}")
Send("+{END}")
;Set the keydelay
Opt("SendKeyDelay", 0)
send($Plot,1)
Opt("SendKeyDelay", 5)
if $insertdirector = "Yes" then InsertDirector()
if $InsertGueststars = "Yes" then InsertGueststar()
if $InsertWriter = "Yes" then InsertWriter()
if $InsertStory = "Yes" then InsertStory()
if $InsertSongs = "Yes" then InsertSongs()
InsertDate()
MouseClick ("left", 514,92)
EndFunc

Func InsertDate()
MouseClick ("left", 348,77)
send("{HOME}")
Send("+{END}")
send($year,1)
MouseClick ("left", 404,77)
send("{HOME}")
Send("+{END}")
send($month,1)
MouseClick ("left", 437,77)
send("{HOME}")
Send("+{END}")
send($day,1)
EndFunc

Func InsertDirector()
If $director <> "" then
MouseClick ("left", 28,116)
Send("^{END}")
Send("{ENTER}{ENTER}")
Opt("SendKeyDelay", 0)
send($director,1)
Opt("SendKeyDelay", 5)
EndIf
EndFunc

Func InsertGueststar()
if $gueststar <> "" then
MouseClick ("left", 28,116)
Send("^{END}")
Send("{ENTER}{ENTER}")
Opt("SendKeyDelay", 0)
send($gueststar,1)
Opt("SendKeyDelay", 5)
EndIf
EndFunc

Func InsertWriter()
if $writer <> "" then
MouseClick ("left", 28,116)
Send("^{END}")
Send("{ENTER}{ENTER}")
Opt("SendKeyDelay", 0)
send($writer,1)
Opt("SendKeyDelay", 5)
EndIf
EndFunc


Func InsertStory()
if $story <> "" then
MouseClick ("left", 28,116)
Send("^{END}")
Send("{ENTER}{ENTER}")
Opt("SendKeyDelay", 0)
send($story,1)
Opt("SendKeyDelay", 5)
EndIf
EndFunc

Func InsertSongs()
if $songs <> "" then
MouseClick ("left", 28,116)
Send("^{END}")
Send("{ENTER}{ENTER}")
Opt("SendKeyDelay", 0)
send($songs,1)
Opt("SendKeyDelay", 5)
EndIf
EndFunc

Func ConvertDateTVRage()
$cleanleft = StringTrimLeft($tvrage,StringLen($tvrage)-12)
$cleanright = StringTrimright($cleanleft,StringLen($cleanleft)-11)
$monthletters = StringLeft($cleanleft,3)
$cleanleft = StringTrimLeft($cleanright,4)
$day = StringLeft($cleanleft,2)
$cleanright = StringTrimLeft($cleanleft,3)
$year =  $cleanright
Switch $monthletters
Case "Jan"
   $month = "01"
Case "Feb"
   $month = "02"
Case "Mar"
   $month = "03"
Case "Apr"
   $month = "04"
Case "May"
   $month = "05"
Case "Jun"
   $month = "06"
Case "Jul"
   $month = "07"
Case "Aug"
   $month = "08"
Case "Sep"
   $month = "09"
Case "Oct"
   $month = "10"
Case "Nov"
   $month = "11"
Case "Dec"
   $month = "12"
EndSwitch
EndFunc

Func ConvertDateIMDB()
$year =  StringRight($airdate,4)
$cleanright = StringRight($airdate,StringLen($airdate)-18)
$cleanleft = StringLeft($cleanright,StringLen($cleanright)-5)
$day = StringLeft($cleanleft,2)
$monthletters = StringTrimLeft($cleanleft,   2)
$cleanright = StringLeft($monthletters,1)
if $cleanright = " " Then
   $cleanleft = StringTrimLeft($monthletters,1)
   $monthletters = $cleanleft
EndIf
Switch $monthletters
Case "January"
   $month = "01"
Case "February"
   $month = "02"
Case "March"
   $month = "03"
Case "April"
   $month = "04"
Case "May"
   $month = "05"
Case "June"
   $month = "06"
Case "July"
   $month = "07"
Case "August"
   $month = "08"
Case "September"
   $month = "09"
Case "October"
   $month = "10"
Case "November"
   $month = "11"
Case "December"
   $month = "12"
EndSwitch
EndFunc

Func LoopTVcom()
while $Count <> $x + 1
   TestForSeasonTVcom()
   if $ok = "Ok" then
      DoStuffTVcom()
   Else
      $count = $count + 1
   EndIf
WEnd
EndFunc

Func DoStuffTVcom()
   GetClipdataTVcom()
   InsertInEpisode()
EndFunc

Func GetClipdataTVcom()
;find title
$result = StringInStr($clipdata[$count], ": ")
$EpisodeTitle = ($clipdata[$count+1])
$Plot = $Clipdata[$count+3]
;Old style TVCOM
;~ While StringInStr($clipdata[$count],'Aired') = 0
;~ $count = $count + 1
;~ WEnd
;find airdate
$airdate = StringRight($Clipdata[$count],StringLen($Clipdata[$count])-stringinstr($clipdata[$count],":",0,1))
ConvertDateTVcom()
$count = $count + 1
EndFunc

Func TestForSeasonTVcom()
if StringRegExp(StringLeft($clipdata[$count],6), 'Season') <> 1 Then
      $ok = "Next"
      Else
      $ok = "Ok"
   endIf
EndFunc

;~ ;Oldstyle TVCom date
;~ Func ConvertDateTVcom()
;~ $temp = StringTrimRight($airdate,StringLen($airdate)-(StringInStr($airdate,"/",0,2)+4))
;~ $year =  StringLeft(StringRight($temp,4),4)
;~ $cleanleft = StringTrimLeft(StringTrimright($temp,5),7)
;~ $day = StringTrimLeft($cleanleft,stringinstr($cleanleft,"/",0,1))
;~ $month = StringTrimRight($cleanleft,stringlen($day)+1)
;~ EndFunc

Func ConvertDateTVcom()
;converts month/day/year
$year =  StringRight(StringStripWS ($airdate,8),4)
$day = stringleft(StringTrimleft($airdate,stringinstr($airdate,"/",0,1)),2)
$day = StringReplace($day,"/","")
$month = StringLeft(StringStripWS ($airdate,8),2)
$month = StringReplace($month,"/","")
EndFunc

Func SkipDiscBandN()
$bandn = $clipdata[$count]
While stringInStr(StringLeft($bandn,3),"1. ") <> 1
$PlotNr = $count + 1
$bandn = $clipdata[$PlotNr]
$count = $count + 1
WEnd
EndFunc

Func GetClipdataBandN()
WinActivate ("Episode:")
WinWaitActive ("Episode:")
WinMove("Episode","",Default,Default,560,365)
$bandn = $clipdata[$count]
While $bandn <> ""
$EpisodeTitleLeft = StringRight($bandn,StringLen($bandn)-StringInStr($bandn,". ")-1)
$EpisodeTitle = StringLeft($EpisodeTitleLeft,StringLen($EpisodeTitleLeft)-6)
$PlotNr = $count + 1
$bandn = $clipdata[$PlotNr]
$count = $count + 1
MouseClick ("left", 27,31)
send("{HOME}")
Send("+{END}")
send($EpisodeTitle,1)
MouseClick ("left", 514,92)
if stringInStr(StringLeft($bandn,4),"Side") = 1 Then
   $count = $count+ 1
   $bandn = $clipdata[$count]
EndIf
if stringInStr(StringLeft($bandn,5),"Disc") = 1 then
   $count = $count+ 1
   $bandn = $clipdata[$count]
EndIf
if stringInStr(StringLeft($bandn,3),"0. ") = 1 then
   $count = $count+ 1
   $bandn = $clipdata[$count]
EndIf
WEnd
EndFunc

Func ExitEntry()
   MouseClick ("left", 523,37)
   opt("WinTitleMatchMode",3)
   WinWaitActive ("Collectorz.com Movie Collector 5.6","Are you sure you want to cancel changes made to this item?")
   opt("WinTitleMatchMode",1)
   MouseClick ("left", 108,50)
EndFunc

Func Terminate()
    Exit 0
EndFunc