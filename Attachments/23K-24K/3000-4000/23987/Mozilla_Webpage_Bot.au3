#cs ------------------------
$a is sleep after tab open
$b is loop timeout
$c is number of arrays "starts with 0 i.e. last number +1"
$x (1st screeb) is horz = 11
$y (1st screen) is vert = vert rez -13
1 start bar + -34
additional bars + -30
x2 (2nd screen) is 1st screen rez +11
y2 (2nd screen) is vert rules above
used var = $a $b $c $t $t2 $x $y $x2 $y2 $ar $dif $net 
$var $var2 $begin $title $hListView $classDetails 
$02s,e,f $12s,e,f $22s,e,f
$loadsc,d,l $runc,d,l $asecc,d,l $tmbc,d,l $ambc,d,l $aksecc,d,l
#ce ------------------------
#include <Array.au3>
#include <GuiListView.au3>
#include <GuiConstantsEx.au3>
autoitsetoption ( "SendKeyDelay", 50 )
$a=100
$b=120000
$c=2
$x=11
$y=787
$x2=1291
$y2=755
$ar=0

$begin=TimerInit()
Run("C:\WINDOWS\system32\taskmgr.exe") 
WinWait("Windows Task Manager")

$title="Windows Task Manager"
$classDetails="SysListView321"
$02s=ControlListView($title,"",$classDetails, "GetText",0,2)
$12s=ControlListView($title,"",$classDetails, "GetText",1,2)
$22s=ControlListView($title,"",$classDetails, "GetText",2,2)

Local $Array[$c]

$Array[0]="www.comics.com/think/{ENTER}"
$Array[1]="www.comics.com/andy_singer/{ENTER}"

Run("C:\Program Files\Mozilla Firefox\firefox.exe") 
WinWait("Mozilla Firefox")
$t=TimerInit()
Do
sleep(250)
$t2=TimerDiff($t)
$var=PixelGetColor($x,$y)
$var2=PixelGetColor($x2,$y2)
Until $var=0x40408f OR $var2=0x40408f OR $t2>$b

Do
	send ( "^t" )
	WinWait("Mozilla Firefox")
	Sleep ($a)
	send ($Array[$ar])
	$ar=$ar+1
	$t=TimerInit()	
	do
	sleep (250)
	$t2 = TimerDiff($t)
	$var=PixelGetColor($x,$y)
	$var2=PixelGetColor($x2,$y2)
	Until $var=0x40408f OR $var2=0x40408f OR $t2>$b
Until $ar=$c

$02e=ControlListView($title,"",$classDetails, "GetText",0,2)
$12e=ControlListView($title,"",$classDetails, "GetText",1,2)
$22e=ControlListView($title,"",$classDetails, "GetText",2,2)

$02s=StringRegExpReplace($02s, ",", "")
$12s=StringRegExpReplace($12s, ",", "")
$22s=StringRegExpReplace($22s, ",", "")
$02e=StringRegExpReplace($02e, ",", "")
$12e=StringRegExpReplace($12e, ",", "")
$22e=StringRegExpReplace($22e, ",", "")

$02f=$02e-$02s
$12f=$12e-$12s
$22f=$22e-$22s

$net=$02f
If $net=0 Then $net=$12f
If $net=0 Then $net=$22f
$dif = TimerDiff($begin)

ProcessClose ( "taskmgr.exe")

$loadsc=($ar+1)
$loadsl=IniRead("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$loadsc", "key", "NotFound")
$loadsd="="
If $loadsc>$loadsl Then $loadsd=">"
If $loadsc<$loadsl Then $loadsd="<"

$runc=(round ($dif/60000,2))
$runl=IniRead("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$runc", "key", "NotFound")
$rund="="
If $runc>$runl Then $rund=">"
If $runc<$runl Then $rund="<"

$asecc=(round ($dif/1000/($ar+1),2))
$asecl=IniRead("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$asecc", "key", "NotFound")
$asecd="="
If $asecc>$asecl Then $asecd=">"
If $asecc<$asecl Then $asecd="<"

$tmbc=(round ($net/1048576,2))
$tmbl=IniRead("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$tmbc", "key", "NotFound")
$tmbd="="
If $tmbc>$tmbl Then $tmbd=">"
If $tmbc<$tmbl Then $tmbd="<"

$ambc=(round ($net/1048576/($ar+1),2))
$ambl=IniRead("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$ambc", "key", "NotFound")
$ambd="="
If $ambc>$ambl Then $ambd=">"
If $ambc<$ambl Then $ambd="<"

$aksecc=(round ($net/1024/($dif/1000),2))
$aksecl=IniRead("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$aksecc", "key", "NotFound")
$aksecd="="
If $aksecc>$aksecl Then $aksecd=">"
If $aksecc<$aksecl Then $aksecd="<"

IniWrite("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$loadsc", "key", $loadsc)
IniWrite("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$runc", "key", $runc)
IniWrite("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$asecc", "key", $asecc)
IniWrite("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$tmbc", "key", $tmbc)
IniWrite("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$ambc", "key", $ambc)
IniWrite("c:\0 Backup\Auto Script Writer\bots\stats.ini", "$aksecc", "key", $aksecc)

_Main()

Func _Main()
    Local $hListView
    
    GUICreate("End Stats", 240, 200)
    $hListView = GUICtrlCreateListView("", 2, 2, 230, 168)
    GUISetState()
    _GUICtrlListView_InsertColumn($hListView, 0, "Item", 105)
    _GUICtrlListView_InsertColumn($hListView, 1, "Value", 50)
	_GUICtrlListView_InsertColumn($hListView, 2, "", 20)
	_GUICtrlListView_InsertColumn($hListView, 3, "Last", 50)
	
    _GUICtrlListView_AddItem($hListView, "Loads", 0)
    _GUICtrlListView_AddSubItem($hListView, 0, $loadsc, 1)
	_GUICtrlListView_AddSubItem($hListView, 0, $loadsd, 2)
	_GUICtrlListView_AddSubItem($hListView, 0, $loadsl, 3)

    _GUICtrlListView_AddItem($hListView, "Runtime Min", 1)
    _GUICtrlListView_AddSubItem($hListView, 1, $runc, 1)
	_GUICtrlListView_AddSubItem($hListView, 1, $rund, 2)
	_GUICtrlListView_AddSubItem($hListView, 1, $runl, 3)

	_GUICtrlListView_AddItem($hListView, "Average Sec", 2)
    _GUICtrlListView_AddSubItem($hListView, 2, $asecc, 1)
    _GUICtrlListView_AddSubItem($hListView, 2, $asecd, 2)
    _GUICtrlListView_AddSubItem($hListView, 2, $asecl, 3)

	_GUICtrlListView_AddItem($hListView, "Total MB", 3)
    _GUICtrlListView_AddSubItem($hListView, 3, $tmbc, 1)
    _GUICtrlListView_AddSubItem($hListView, 3, $tmbd, 2)
    _GUICtrlListView_AddSubItem($hListView, 3, $tmbl, 3)

	_GUICtrlListView_AddItem($hListView, "Average MB", 4)
    _GUICtrlListView_AddSubItem($hListView, 4, $ambc, 1)
    _GUICtrlListView_AddSubItem($hListView, 4, $ambd, 2)
    _GUICtrlListView_AddSubItem($hListView, 4, $ambl, 3)

	_GUICtrlListView_AddItem($hListView, "Average Kb/Sec", 5)
    _GUICtrlListView_AddSubItem($hListView, 5, $aksecc, 1)
    _GUICtrlListView_AddSubItem($hListView, 5, $aksecd, 2)
    _GUICtrlListView_AddSubItem($hListView, 5, $aksecl, 3)
	
    Do
    Until GUIGetMsg() = $GUI_EVENT_CLOSE
    GUIDelete()
EndFunc  
