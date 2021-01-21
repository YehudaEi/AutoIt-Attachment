#cs
Made by: Dumbledor

Date:9.2.2008

Version: demo for autoit forum, works only for one city

Purpose: to show people who work on their bots for posible solutions and help others to start studying scripts

Works: Checks every five minutes if is attack coming. If attack is under 5 minutes it starts evading protocol. It sends reifonrcment
	   to chosen city and calls it back under 90s. It has random funtions, so it is not tracable by auto multihunter

includes:
automatic login
gets attack time if there is any
Evade incoming attacks


My functions:
Func TimeToSec ==> Converts time in format 1:23:23 into seconds
Func attacktime ==> Gets attack time from source code
Func Login ==> dont understand it, just using it becouse it is working :( It is login on travian server afcourse.
SendCall ==> Evading function. it sends and calls back soldiers.

SEND ME THANKS ON PM IF YOU USING MY CODE. I WOULD APPRICIATE IT AND KNOW THAT I DID SOMEONE A FAVOUR. :D



Be cool be travian. :D
#ce







#include <IE.au3>
#include <file.au3>
#include <String.au3>

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!DONT FORGET TO CHANGE GLOBAL VARIABLES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Global $Link = "                                            ", $User = "", $Pass = "", $oIE ;==> Your username and pass, link must be in format                               

Global $link1 = "                            " ;==> Link for the place where you send units (in com server rally point --> send troops)
Global $link2 = "                                    " ;==>Link of the rally point
Global $hero = 1 ;==> Set to 1 if you have hero else 0.
Global $aCity = "" ;==> Name of the city you sending reinforcment.
Global $img = "del.gif" ;==> Name of the red X you get to stop building.

$ss= 1 ;Didn t include exit function, so you have to stop script from start line, this keep loop do until working. ;)
$oIE = _IECreate($link, 0, 1)
Login($User, $Pass)
_IEQuit($oIE)

Do
TrayTip("", "Wait...", 1)

$oIE = _IECreate($link, 0, 1)
$test = attacktime()
_IEQuit($oIE)
$test = TimeToSec ($test)
if $test < 600 Then
	if $test > 1 Then
	$test = $test - (10 + Random (0, 20))
	$test = $test* 1000
	ConsoleWrite("Sleeping for:"&$test)
	sleep ($test)

	SendCall ()

EndIf
EndIf
Sleep(240000 + (Random (0, 60) *1000))

until $ss = 0


Func attacktime() ;==> Gets attack time from source code
$oTable = _IETableGetCollection ($oIE,1)
$aTableData = _IETableWriteToArray ($oTable, True)
$i = $aTableData[0][1]
$attack = "» 1"
$AttackTime = "0:00:01"
if $i == $attack Then
	$AttackTime = $aTableData[0][4]
	$AttackTime = StringReplace( $attackTime, " ", "")
    $AttackTime = StringReplace( $attackTime, "h", "")
EndIf
ConsoleWrite("Attack in:"&$attacktime)
Return $AttackTime
EndFunc


Func Login($Username, $Password) ;==> dont understand it, just using it becouse it is working :(
    $oForm = _IEFormGetCollection($oIE, 0)
    $oQuery = _IEFormElementGetCollection($oForm, 2)
    _IEFormElementSetValue($oQuery, $Username)
    $oQuery = _IEFormElementGetCollection($oForm, 3)
    _IEFormElementSetValue($oQuery, $Password)
    _IEFormSubmit($oForm)
EndFunc   ;==>Login


Func TimeToSec($time) ;==> Converts time in format 1:23:23 into seconds
$Temp = StringSplit($time,":")
$seconds = $Temp[1] * 3600 + $Temp[2] * 60 + $Temp[3]
return $seconds
endfunc

Func SendCall() ;==>


$oIE = _IECreate ($link1, 0, 1)
$oLinks = _IELinkGetCollection ($oIE)
$iNumLinks = @extended


$i=16
if $iNumLinks > 16 Then
Do
_IELinkClickByIndex ($oIE, $i)
	$iNumLinks = $iNumLinks - 1
	$i = $i + 1

Until $iNumLinks = 16
EndIf

$oForm = _IEFormGetCollection ($oIE, 0)
$num = 14 + $hero
$oQuery = _IEFormElementGetCollection ($oForm, $num)
_IEFormElementSetValue ($oQuery, $aCity)
_IEFormSubmit ($oForm)
$oForm = _IEFormGetCollection ($oIE, 0)
_IEFormSubmit ($oForm)
_IEQuit($oIE)
Sleep(20000 + Random(0, 20000))
$oIE = _IECreate ($link2)
_IEImgClick ($oIE, $img)
_IEQuit($oIE)
EndFunc
