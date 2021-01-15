;~ Title:Vista Sidebar 
;~ Desc:To Do List
;~ Author:Unknown
;~ Edited By:LuckyMurari holmes.santosh (at) gmail (dot) com 
;~ Thanks To Smashly For many of his ideas and the optimization


#include <GUIConstants.au3>
#include <Misc.au3>
If Not _Singleton("ToDoList") Then Exit
$transspeed=IniRead("settings.ini","transition","speed",10)
$taskspeed=IniRead("settings.ini","newtask","speed",20)
$type=IniRead("settings.ini","transition","type","Slide")
Global $task[(@DesktopHeight/30)+1]
Opt("TrayAutoPause",0)
Opt("TrayMenuMode",1)
Opt("TrayOnEventMode",1)

TrayCreateItem("New Task")
TrayItemSetOnEvent(-1,"NewTask")
TrayCreateItem("Preferences")
TrayItemSetOnEvent(-1,"pref")
TrayCreateItem("")

TrayCreateItem("Close")
TrayItemSetOnEvent(-1,"Term")

Opt("GUIOnEventMode")

Global $i = 0
$state=0
If $type="Slide" Then
$hwnd = GUICreate("To Do",200,@DesktopHeight,@DesktopWidth,0,$WS_POPUP+$WS_DISABLED,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST )
ElseIf $type="Fade" Then
	$hwnd = GUICreate("To Do",200,@DesktopHeight,@DesktopWidth-200,0,$WS_POPUP+$WS_DISABLED,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST )
EndIf
GUISetBkColor(0)

$start = GUICtrlCreateLabel('"To Do"-List',0,0,200,28)
GUICtrlSetFont(-1,18,500)
GUICtrlSetColor(-1,0xFFFFFF)

GUICtrlCreateGraphic(0,28,200,2)
GUICtrlSetBkColor(-1,0xFFFFFF)

GUISetState(@SW_HIDE)
WinSetTrans($hwnd,"",150)

 While 1
	$arr=MouseGetPos()
	If	$arr[0] > @DesktopWidth-10 And $State = 0 Then
GUISetState(@SW_SHOW,$hwnd)
Switch $type
		 Case "Slide"
		 For $i=0 To 200 Step $transspeed
		 WinMove("To Do","",@DesktopWidth-$i,0)
	 Next
	 
 Case "Fade"
	     For $i=0 To 150 Step $transspeed
			
			 WinSetTrans("To Do","",$i)
 Next
EndSwitch
$State=1
 EndIf
		
			
			 If $arr[0] < @DesktopWidth-200 And $State = 1 Then
				 
				 Switch $type
		 Case "Slide"
				 For $i=200 To 0 Step -$transspeed
				 WinMove("To Do","",@DesktopWidth-$i,0)
				 Next
			 Case "Fade"
				  For $i=150 To 0 Step -$transspeed
			 WinSetTrans($hwnd,"",$i)
			 
		 Next
 EndSwitch
 GUISetState(@SW_HIDE,$hwnd)
			 $State=0
			EndIf
	 Sleep(500)
	  
WEnd

Func NewTask()
	If $i>20 Then
		MsgBox(0,"Error","Maximum Number Of Tasks Reached")
		Return
		EndIf
    $a = InputBox('"To Do"-List',"Enter the name of your new task.")
    If @error Then Return
    $i += 1
  $task[$i]=GUICtrlCreateLabel("x " & $a,0,@DesktopHeight,200,28)
    GUICtrlSetColor(-1,0xFFFFFF)
    GUICtrlSetFont(-1,16,450)
	If $state=0 Then show()
    For $x = @DesktopHeight To 30*$i Step -$taskspeed
    Next
    GUICtrlSetPos($task[$i],0,30*$i)
	
	Sleep(500)
	  If $arr[0] < @DesktopWidth-200 And $State = 1 Then
		  
				 Switch $type
		 Case "Slide"
				 For $i=200 To 0 Step -$transspeed
				 WinMove("To Do","",@DesktopWidth-$i,0)
				 Next
			 Case "Fade"
				  For $i=150 To 0 Step -$transspeed
			 WinSetTrans($hwnd,"",$i)
			 
		 Next
 EndSwitch
 GUISetState(@SW_HIDE,$hwnd)
			 $State=0
			 EndIf
	
EndFunc

Func DelTask()
    MsgBox(0,"","")
EndFunc

Func Term()
    Exit
EndFunc
Func show()
	GUISetState(@SW_SHOW,$hwnd)
	Switch $type
		Case "Slide"
	For $i=20 To 200 Step $transspeed
		 WinMove("To Do","",@DesktopWidth-$i,0)
	 Next
	Case "Fade"
	     For $i=0 To 150 Step $transspeed
			
			 WinSetTrans("To Do","",$i)
		 Next
		 EndSwitch
	 $State=1
 EndFunc
 Func pref()
	$pref=GUICreate("Preferences",300,150)
	GUICtrlCreateLabel("Transition Type",30,30)
$ttype=GUICtrlCreateCombo("",150,30)
	GUICtrlSetData($ttype,"Slide|Fade",$type)
	 GUICtrlCreateLabel("Transition Speed",30,60)
	 $tspeed=GUICtrlCreateInput($transspeed,150,60)
	 GUICtrlCreateLabel("New Task Speed",30,90)
	 $taspeed=GUICtrlCreateInput($taskspeed,150,90)
	 $submit=GUICtrlCreateButton("Ok",130,120,40)
	 GUISetState()
	 While 1
		 $msg=GUIGetMsg()
        Switch $msg		
			Case $submit
				$typet=GUICtrlRead($ttype)
			 $speedt=GUICtrlRead($tspeed)
			 If Not ($speedt<100 And $speedt>1) Then
				 MsgBox(0,"Error","Invalid Speed Entered")
				 $speedt=10
				 $speedta=20
			    ContinueCase
			 EndIf
		  
			 $speedta=GUICtrlRead($taspeed)
				If Not ($speedta<100 And $speedta>1) Then
					$speedta=20
					$speedt=10
				 MsgBox(0,"Error","Invalid Speed Entered")
                  ContinueCase			
			  EndIf
			  IniWrite("settings.ini","transition","type",$typet)
			 IniWrite("settings.ini","newtask","speed",$speedta)
			 IniWrite("settings.ini","transition","speed",$speedt)
			 $type=$typet
            $transspeed=$speedt
			$taskspeed=$speedta
			GUIDelete($pref)
			If $type="Fade" Then
				WinMove("To Do","",@DesktopWidth-200,0)
			ElseIf $type="Slide" Then
				MsgBox(0,"","")
				WinMove("To Do","",@DesktopWidth,0)
			EndIf
			$State=0
             ExitLoop			
		 Case $GUI_EVENT_CLOSE
			 GUIDelete($pref)
			 ExitLoop
			 EndSwitch
		 WEnd
		 EndFunc