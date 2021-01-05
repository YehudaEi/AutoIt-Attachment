#include <GuiConstants.au3>
#include <INetAdv.au3>
Opt("GUIOnEventMode",1)

Dim $URLInput,$Label_1,$Label_2,$Label_3,$Label_4,$Label_5,$Label_6,$Label_7,$Label_8,$StartBtn,$cleared = 0

GuiCreate("MyGUI", 392, 323,(@DesktopWidth-392)/2, (@DesktopHeight-323)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$URLInput = GUICtrlCreateInput("Input URL here",20,5,225,20)
$BrowseInput = GUICtrlCreateInput("",20,27,150,20,$ES_READONLY)
$BrowseBtn = GUICtrlCreateButton("Browse",175,27,70,20)
GuiCtrlCreateLabel("Active download:", 20, 50, 85, 20)
GuiCtrlCreateLabel("Source URL:", 20, 80, 85, 20)
GuiCtrlCreateLabel("Filename:", 20, 110, 85, 20)
GuiCtrlCreateLabel("Bytes Read:", 20, 140, 85, 20)
GuiCtrlCreateLabel("Bytes per Sec:", 20, 170, 85, 20)
GuiCtrlCreateLabel("Time Left:", 20, 200, 85, 20)
GuiCtrlCreateLabel("Percent:", 20, 230, 85, 20)
GuiCtrlCreateLabel("Total Size:", 20, 260, 85, 20)
$Label_1 = GuiCtrlCreateLabel("", 110, 50, 300, 20)
$Label_2 = GuiCtrlCreateLabel("", 110, 80, 300, 20)
$Label_3 = GuiCtrlCreateLabel("", 110, 110, 300, 20)
$Label_4 = GuiCtrlCreateLabel("", 110, 140, 300, 20)
$Label_5 = GuiCtrlCreateLabel("", 110, 170, 300, 20)
$Label_6 = GuiCtrlCreateLabel("", 110, 200, 300, 20)
$Label_7 = GuiCtrlCreateLabel("", 110, 230, 300, 20)
$Label_8 = GuiCtrlCreateLabel("", 110, 260, 300, 20)
$StartBtn = GUICtrlCreateButton("Start DL",145,290,100,25)

GUICtrlSetOnEvent($BrowseBtn,"_Browse")
GUICtrlSetOnEvent($StartBtn,"_StartDL")
GUISetOnEvent($GUI_EVENT_CLOSE,"_Exit")

GuiSetState()
While 1
    $curInfo = GUIGetCursorInfo()    
    If $curInfo[2] = 1 AND $curInfo[4] = $URLInput AND $cleared = 0 Then
        GUICtrlSetData($URLInput,"")
        $cleared = 1
    EndIf

    If @InetGetActive Then
        GUICtrlSetData($Label_1,"Yes")
        GUICtrlSetData($Label_2,$INetAdvInfo[1])
        GUICtrlSetData($Label_3,$INetAdvInfo[2])
        GUICtrlSetData($Label_4,$INetAdvInfo[3] / 1024 & " Kb")
        GUICtrlSetData($Label_5,$INetAdvInfo[4] / 1024 & " Kb/s")
        GUICtrlSetData($Label_6,$INetAdvInfo[5] & " Seconds left")
        GUICtrlSetData($Label_7,$INetAdvInfo[6] & " %")
        GUICtrlSetData($Label_8,Round($INetAdvInfo[7] / 1024,0) & " Kb")
        Sleep(50)
    ElseIf Not @InetGetActive AND GUICtrlRead($Label_1) = "YES" Then
        GUICtrlSetData($Label_1,"No")
        GUICtrlSetData($Label_2,$INetAdvInfo[1])
        GUICtrlSetData($Label_3,$INetAdvInfo[2])
        GUICtrlSetData($Label_4,Round($INetAdvInfo[7] / 1024,0) & " Kb")
        GUICtrlSetData($Label_5,"0 Kb/s")
        GUICtrlSetData($Label_6,"0 Seconds left")
        GUICtrlSetData($Label_7,"100 %")
        GUICtrlSetData($Label_8,Round($INetAdvInfo[7] / 1024,0) & " Kb")
        Msgbox(0,"Download","Transfer Complete")
    EndIf    
WEnd

Func _Browse()
    $Save = FileSaveDialog( "Choose a name.", @DesktopDir, "All (*.*)" , 3)
    GUICtrlSetData($BrowseInput,$Save)
EndFunc    

Func _StartDL()
    _INetAdvGet (GUICtrlRead($URLInput), GUICtrlRead($BrowseInput), 1)
EndFunc    

Func _Exit()
    Exit
EndFunc  