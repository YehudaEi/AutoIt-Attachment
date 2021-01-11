#include <GUIConstants.au3>
GUICreate("Photo Resizing - Michael McFarland", 460, 160, -1, -1)
$Filename = "C:\Documents and Settings\test\My Documents\My Pictures\Resizing"
Global $StartIndex = 0, $iCntRow, $iCntCol, $iCurIndex
GuiCtrlCreateLabel("Insert how many pictures you want resized and then insert the percentage of the new picture compared to the old picture. You can also chose which folder the program gets pictures from.", 10, 5, 445, 30 )
$numpic = GuiCtrlCreateInput("", 60, 75, 28, 20)
	GuiCtrlCreateLabel("# of pictures", 93, 78)
$percent = GuiCtrlCreateInput("50", 60, 115, 28, 20)
	GuiCtrlCreateLabel("% scaled", 93, 118)
$exit = GuiCtrlCreateButton("Exit", 235, 110, 90, 30)
$ok = GuiCtrlCreateButton("OK", 350, 110, 90, 30)
$File = GUICtrlCreateEdit($Filename, 10,  45, 410, 16, $ES_READONLY, $WS_EX_STATICEDGE)
$FileSel = GUICtrlCreateButton("...", 420,  45, 27, 16)
$count = 1
Global $StartIndex = 0, $iCntRow, $iCntCol, $iCurIndex
GUISetState(@SW_Show)

While 1
    $Msg = GUIGetMsg()
   ; Code below will check if the file is dropped (or selected)
    $CurFilename = GUICtrlRead($File) 
    If $CurFilename <> $Filename Then
        $StartIndex = 0
        $Filename = $CurFilename
    Endif
   ; Main "Select" statement that handles other events
    Select
        Case $Msg = $FileSel
            $Folderpath = FileSelectFolder("Choose a folder.", "") ;= FileOpenDialog("Select file:", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "All folders (*.*)")
            If @error Then ContinueLoop
            GUICtrlSetData($File, $Folderpath); GUI will be updated at next iteration
        Case $Msg = $GUI_EVENT_CLOSE
            Exit
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $exit
			Exit
	Endselect
	If $msg = $ok then
			OpenMyPics()
			Do
				ResizePicture()
				$count = $count + 1
			Until $count > GUICtrlRead($Numpic)
			Exit
		Endif
Wend

	Func OpenMyPics()
		Send("#r")
		Sleep(500)
		Send(GuiCtrlRead($File))
		Send("{enter}")
		Send("!vd")
		Sleep(10000)
		Send("{down}")
		Send("{up}")
	EndFunc
	
	Func ResizePicture()
		Send("{enter}")
		Sleep(1200) 
		Send("{alt}")
		Send("!is")
		Sleep(600)
		Send(GuiCtrlRead($Percent))
		Sleep(100)
		Send("{tab}")
		Send(GuiCtrlRead($Percent))
		Sleep(100)
		Send("{enter}")
		Sleep(500)
		Send("!fs")
		Send("{enter}")
		Sleep(100)
		Send("!fx")
		Sleep(500)
		Send("{down}")
	Endfunc
	
	