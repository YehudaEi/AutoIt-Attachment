;~ Title:Vista Sidebar 
;~ Desc:To Do List
;~ Author:Unknown
;~ Edited By:LuckyMurari holmes.santosh (at) gmail (dot) com


#include <GUIConstants.au3>
#include <Misc.au3>
If Not _Singleton("ToDoList") Then Exit

Opt("TrayAutoPause",0)
Opt("TrayMenuMode",1)
Opt("TrayOnEventMode",1)

TrayCreateItem("New Task")
TrayItemSetOnEvent(-1,"NewTask")

TrayCreateItem("")

TrayCreateItem("Close")
TrayItemSetOnEvent(-1,"Term")

Opt("GUIOnEventMode")

Global $i = 0

$hwnd = GUICreate("To Do",200,600,@DesktopWidth,0,$WS_POPUP+$WS_DISABLED,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST )
GUISetBkColor(0)

$start = GUICtrlCreateLabel('"To Do"-List',0,0,200,28)
GUICtrlSetFont(-1,18,500)
GUICtrlSetColor(-1,0xFFFFFF)

GUICtrlCreateGraphic(0,28,200,2)
GUICtrlSetBkColor(-1,0xFFFFFF)

GUISetState(@SW_SHOWNA)
WinSetTrans($hwnd,"",150)

 While 1
	$arr=MouseGetPos()
     If $arr[0] > @DesktopWidth-10 Then
		 For $i=20 To 200 Step 20
		 WinMove("To Do","",@DesktopWidth-$i,0)
		 Next
		 While 1
			 $arr=MouseGetPos()
			 If $arr[0] < @DesktopWidth-200 Then
				 For $i=200 To 0 Step -20
				 WinMove("To Do","",@DesktopWidth-$i,0)
				 Next
			 ExitLoop
			 EndIf
		 WEnd
		 EndIf
	 Sleep(500)
	  
WEnd

Func NewTask()
    $a = InputBox('"To Do"-List',"Enter the name of your new task.")
    If @error Then Return
    $i += 1
    GUICtrlCreateLabel("x " & $a,0,600,200,28)
    GUICtrlSetOnEvent(-1,"DelTask")
    GUICtrlSetColor(-1,0xFFFFFF)
    GUICtrlSetFont(-1,16,450)
	show()
    For $x = 600 To 30*$i Step -12
        GUICtrlSetPos(-1,0,$x)
        Sleep(1)
    Next
    GUICtrlSetPos(-1,0,30*$i)
	Sleep(500)
	 For $i=200 To 0 Step -20
				 WinMove("To Do","",@DesktopWidth-$i,0)
				 Next
	
EndFunc

Func DelTask()
    MsgBox(0x1, "", "Task delete: " & @GUI_CTRLID)
EndFunc

Func Term()
    Exit
EndFunc
Func show()
	For $i=20 To 200 Step 20
		 WinMove("To Do","",@DesktopWidth-$i,0)
	 Next
	; $arr=MouseGetPos()
	; MouseMove(@DesktopWidth,$arr[1])
	 EndFunc