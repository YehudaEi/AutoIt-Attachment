;#AutoIt3Wrapper_run_debug_mode=Y
#include <GUIConstants.au3>
#include <Array.au3>
#include <GuiImageList.au3>
#include <WinAPI.au3>
#Include <GuiTreeView.au3>
#Include <Date.AU3>

Global $status
Global $saved
Global $importDelim = "==="
Global $tree_root = ""
Global $ic = ""
Global $fdragging,$adrag,$gui
$treeitem = ""
$count = 0
$textloc = 0
dim $the_text[1][2],$mou_pos[5]

$GUI = GUICreate("EFolders", 800, 815,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

dim $fullfile

$filemenu = GUICtrlCreateMenu ("&File")
$fileitem = GUICtrlCreateMenuitem ("Open",$filemenu)
GUICtrlSetState(-1,$GUI_DEFBUTTON)

$saveitem = GUICtrlCreateMenuitem ("Save",$filemenu)
GUICtrlSetState(-1,$GUI_DISABLE)

$exititem = GUICtrlCreateMenuitem ("Exit",$filemenu)
$recentfilesmenu = GUICtrlCreateMenu ("Recent Files",$filemenu,1)

$separator1 = GUICtrlCreateMenuitem ("",$filemenu,2)    ; create a separator line

$toolmenu = GUICtrlCreateMenu("Tools",-1,1) 
$additem = GUIctrlcreatemenuitem("NewRecord",$toolmenu)
$importitem =  GUICtrlCreateMenuitem ("Import",$toolmenu)

$helpmenu = GUICtrlCreateMenu ("?")
$infoitem = GUICtrlCreateMenuitem ("Info",$helpmenu)

$Treeview = GUICtrlGetHandle(GuiCtrlCreateTreeview(10, 10, 300, 710 , $ws_sizebox + $TVS_HASBUTTONS+ $TVS_HASLINES+$TVS_LINESATROOT+ $TVS_SHOWSELALWAYS + $WS_TABSTOP))
$contextmenu    = GUICtrlCreateContextMenu ($treeview)
$myexport     = GUICtrlCreateMenuitem ("export", $contextmenu)
$Edit_box = GuiCtrlCreateEdit("", 350, 20, 400, 290, $ES_WANTRETURN + $WS_VSCROLL + $WS_HSCROLL + $ES_AUTOVSCROLL + $ES_AUTOHSCROLL +$ES_MULTILINE + $WS_TABSTOP + $ws_sizebox)
$BExit = GuiCtrlCreateButton("Exit", 490, 710, 60, 30)
$BCancel = GuiCtrlCreateButton("Cancel", 320, 710, 60, 30)
$BSaveall = GuiCtrlCreateButton("Save All", 400, 710, 60, 30)
HotKeySet("{F5}", "SendDate")

GUISetState ()
   $hImage = _GUIImageList_Create (16, 16, 5, 3)
    _GUIImageList_AddIcon ($hImage, "shell32.dll", 110)
    _GUIImageList_Add ($hImage, _GUICtrlTreeView_CreateSolidBitMap ($TreeView, 0x0000FF, 16, 16))
	_GUICtrlTreeView_SetNormalImageList ($TreeView, $hImage)

While 1
    $msg = GUIGetMsg()
	
	Select
		case $msg = $fileitem 
			$file =FileOpenDialog("Choose file...","z:\whiznotes\","All (*.*)|Text (*.txt)")
			If @error <> 1 Then GUICtrlCreateMenuitem ($file,$recentfilesmenu)
		case $msg = $importitem	
			$master = "TopOfTree"
			$treeitem =_GUICtrlTreeView_Add ($TreeView, 0, $master, 0,0)
			GUICtrlSetData ($edit_box, $ic )
			$count = 0
			_GUICtrlTreeView_BeginUpdate ($TreeView)
			For $count = 1 to 10
				ReDim $the_text[$count+1][2]
				$the_text[$count][0]="Chile " & string($count)
				$line = $the_text[$count][0]
				_GUICtrlTreeView_AddChild ($treeview, $treeitem, $line, 0,0)
				$ic = "Lots of other test goes here for ediring in the editbox on the right"
			Next
			_GUICtrlTreeView_EndUpdate ($TreeView)
			_GUICtrlTreeView_SelectItem ($TreeView, 0)

;		Case $msg = $NewItem
;		case $msg = $Edit_box

		Case $msg = $GUI_EVENT_CLOSE Or $msg = $BExit or $msg = $BCancel or $msg = $exititem 
			if ($msg = $BExit or $msg = $exititem) and $saved = 1 then
				if msgbox(4,"File not saved","Do you want to save your work ?") then
				EndIf	
			endif	 
			ExitLoop	

		Case $msg=$GUI_EVENT_MOUSEMOVE
                If $fDragging Then DrawDragImage($TreeView, $aDrag)
                
			Case $msg= $GUI_EVENT_PRIMARYDOWN
                Local $hSelected = _GUICtrlTreeView_GetSelection ($TreeView)
                If $hSelected Then
                    $fDragging = True
                    ; Create drag image
                    $aDrag = _GUICtrlTreeView_CreateDragImage ($TreeView, 0)
                    DrawDragImage($TreeView, $aDrag)
                EndIf
                
		Case $msg =$GUI_EVENT_PRIMARYUP
                If $fDragging Then
                    $fDragging = False
                    ; delete image list
                    _GUIImageList_Destroy ($aDrag)
                    _WinAPI_InvalidateRect ($TreeView)
                    _WinAPI_InvalidateRect (HWnd($GUI))
                EndIf

		case  $msg = GUICtrlRead($treeview )
			if(_GUICtrlTreeView_GetParentHandle($treeview)) = 0 then 
				GUICtrlSetData ( $edit_box, "")
				GUISetState()				
				ContinueLoop
			endif	

			if GUICtrlRead($treeview,1) <> "" then
				$t1 = guictrlread($treeview,1)
				ConsoleWrite("T1 = " & $t1 & @crlf)
				For $i = 1 To UBound($the_text)
                    If $the_text[$i][0] = $t1 Then
						ExitLoop
					EndIf
                Next
				ConsoleWrite("The Text =" & $the_text[$i][1] & @crlf)
				GUICtrlSetData ( $edit_box, $the_text[$i][1])
				GUISetState()
			endif

		case $msg = $infoitem
			Msgbox(0,"Info","Only a test...")
			
		case $msg = $myexport
			$t1 = guictrlread($treeview,0)
			consolewrite("Selected:" & 	$t1)
			if $t1 = 0 then ContinueLoop
			msgbox(0,"Context Menu","Context Menu")
			$gotfile = FileOpenDialog("Choose file...","z:\whiznotes\","All (*.*)|Text (*.txt)")
			if @error = 1 then continueLoop
			$filehand = FileOpen($gotfile,2)	
			filewrite($gotfile,$the_text[$t1] & @crlf)			
			FileClose($filehand)	
	EndSelect
	
WEnd
GUIDelete()

Exit
Func Senddate()
	
	send( _NowDate() & " " & _NowTime(4))
endfunc

Func DrawDragImage(ByRef $hControl, ByRef $aDrag)
    Local $tPoint, $hDC
    $hDC = _WinAPI_GetWindowDC ($hControl)
    $tPoint = _WinAPI_GetMousePos (True, $hControl)
    _WinAPI_InvalidateRect ($hControl)
    _GUIImageList_Draw ($aDrag, 0, $hDC, DllStructGetData($tPoint, "X"), DllStructGetData($tPoint, "Y"))
    _WinAPI_ReleaseDC ($hControl, $hDC)
EndFunc   ;==>DrawDragImage

