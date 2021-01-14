;CyberSlug - 23 March 2005
;
;Viewer for search results
;NOTE:  I do not see an easy way to read the SysHeader32 control....
; If your Windows Search results has different columns, then you would need to change the code below
; Modified by vatobeto 06/10/2007

#include <GUIConstants.au3>

$SearchFileName = FileOpenDialog("Get Name of Search File", @WorkingDir, "Text files (*.txt)")
Dim $filename = $SearchFileName
If $CmdLine[0] > 0 Then $filename = $CmdLine[1]

$GUI = GUICreate("Viewer for Search Results",400, 300, -1, -1, $WS_THICKFRAME)

$listview = GUICtrlCreateListView ("Name|In Folder|Size|Type|Date Modified",0,0,400,280)
$contextMenu = GuiCtrlCreateContextMenu($listview)
$infoitem = GUICtrlCreateMenuitem ("Open containing folder...",$contextMenu)

$file = FileOpen($filename, 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open specified search results file...")
    Exit
EndIf
; Read in lines of text until the EOF is reached
While 1
    $line = FileReadLine($file)
    If @error = -1 Then ExitLoop
    GUICtrlCreateListViewItem(StringReplace($line,@TAB,"|"),$listview)
Wend
FileClose($file)

GUICtrlCreateContextMenu ()

GUISetState()
;;;ControlSend($GUI, "", "SysListView321", "^{NUMPADADD}");doesn't work
WinWaitActive($GUI)
Send("^{NUMPADADD}"); resizes columns to show all items fully


Do
    $msg = GUIGetMsg ()
    If $msg = $infoItem Then
        $data =  StringSplit(GuiCtrlRead(GuiCtrlRead($listview)), "|")
        If UBound($data) >= 2 Then
            Run("explorer /select," & """" & $data[2] & "\" & $data[1] & """")
        EndIf
    EndIf
Until $msg = $GUI_EVENT_CLOSE