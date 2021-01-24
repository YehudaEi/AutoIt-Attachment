#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         TheMadman

 Script Function:
	Multi Processing

#ce ----------------------------------------------------------------------------

#include<task.au3>
_TASK_PARENT_POLL_CHILD("data");function to recv data from kids

$ss=StringSplit("gui",",");;function array "func1 param1 param 2 ... param n,func 2 p1 p2 ... pn ,...,func n)
_task_add($ss) ;; spawn child 1 with 1 function,no params
Sleep(5000)


Func data($P_INDEX , $P_DATA) ;; recv data from kid
	If StringLeft($P_DATA,3)="gui" Then;; did that brat create the gui :)? if yes then carry on
		$P_DATA=StringTrimLeft($P_DATA,3)
		$ss=StringSplit("settext "&$P_DATA&" child|2|set|the|text...",",")
		Sleep(3000)
		$lol=_task_add($ss);; child 2 func:settext(), 3 params :gui controlid text(no spaces, use | for space)
		Sleep(3000)
		$data=StringSplit($P_DATA," ")
		$ss=StringSplit("mvw "&$data[1]&" "&Random(1,@DesktopWidth/2,1)&" "&Random(1,@DesktopHeight/2,1)&",settext "&$P_DATA&" and|child|3|moved|the|window|xD",",")
		
		_task_add($ss);; child 3 func:mvw, 3 params : gui, x, y
		_parent_send_child($T_CHILD[1] , "do sleepexit 2000 done exit")
	Else
		ConsoleWrite("CHILD:"&$P_INDEX&">"&$P_DATA & @CRLF);data from brats xD
	EndIf
EndFunc

Func gui() ;; func to create a gui
	$gui=GUICreate("dad is a lamer^^")
	$butt=GUICtrlCreateButton("child 1 created the button",0,0,200,40)
	GUISetState()
	_task_send_to_parent("gui"&$gui &" "&$butt);; tell that that i made za gui
	Sleep(10000)
EndFunc
Func sleepexit($time)
	Exit Sleep($time)
EndFunc
Func settext($gui,$cid,$data);;func to set the data of a given control
	$l=ControlSetText(HWnd($gui) , "" , "[ID:"&$cid&"]" ,StringReplace($data,"|" , " "))
EndFunc

Func mvw($gui,$x,$y);; move a window
	WinMove(HWnd($gui),"" , $x,$y)
EndFunc