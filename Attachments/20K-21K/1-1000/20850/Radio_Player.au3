#include <GUIConstants.au3>
#include <WMMedia.au3>
#include <File.au3>
#include <Constants.au3>
#include <GuiListView.au3>
#include <GUIConstantsEx.au3>

Global Const $WM_NOTIFY = 0x004E
Global $DoubleClicked   = False

Opt("TrayMenuMode",1)
$restore = TrayCreateItem("Restore")
TrayCreateItem("")
$exit = TrayCreateItem("Exit")
TraySetState()
Opt("TrayIconHide", 1)
TraySetClick(8) ; Pressing secondary mouse button

$version = "v1.3" ; Version
$dir = @TempDir ; Radio.ini dir


Global $play, $stop, $add, $addGui
WMStartPlayer()

$hGui = GUICreate("Radio Player "&$version, 380, 320, (@DesktopWidth-380)/2, (@DesktopHeight-320)/2)
$play = GUICtrlCreateButton("Play", 300, 10, 60, 30)
$stop = GUICtrlCreateButton("Stop", 300, 40, 60, 30)
$delete = GUICtrlCreateButton("Delete", 300, 70, 60, 30)
$deleteall = GUICtrlCreateButton("Delete All", 300, 100, 60, 30)

$hListView = GuiCtrlCreateListView("", 10, 10, 250, 130)
_GUICtrlListView_InsertColumn($hListView, 0, "Title", 100)
_GUICtrlListView_InsertColumn($hListView, 1, "URL", 300)

$label = GUICtrlCreateLabel("Playing: ", 10, 150, 370, 20)
GUICtrlCreateLabel("Volume: ", 10, 170, 50, 20)
GUICtrlCreateLabel("-", 58, 165, 20, 20)
GUICtrlSetFont(-1, 15)
$slider = GUICtrlCreateSlider(65, 165, 220, 30)
GUICtrlSetData($slider, 80)
GUICtrlCreateLabel("+", 290, 165, 20, 20)
GUICtrlSetFont(-1, 15)

GUICtrlCreateLabel("Title", 10, 210, 50, 20)
$titleR = GUICtrlCreateInput("", 50, 210, 250, 20)

GUICtrlCreateLabel("URL", 10, 250, 50, 20)
$urlR = GUICtrlCreateInput("", 50, 250, 250, 20)

$add = GUICtrlCreateButton("Add", 10, 280, 60, 30)
$clear = GUICtrlCreateButton("Clear", 80, 280, 60, 30)

GUICtrlCreateLabel("By Gil Hanan", 300, 300, 70, 20)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")


$menu1=GUICtrlCreateContextMenu ($hListView)
$play2=GUICtrlCreateMenuitem("Play" , $menu1)
$delete2=GUICtrlCreateMenuitem("Delete" , $menu1)
$deleteall2=GUICtrlCreateMenuitem("Delete All" , $menu1)



GUISetState()

_Refresh()

Func _Play()
	$iIndex = _GUICtrlListView_GetSelectedIndices($hListView)
	$selected = _GUICtrlListView_SetSelectionMark($hListView, $iIndex)
	$Title = _GUICtrlListView_GetItemText($hListView, $selected, 0)
	$URL = _GUICtrlListView_GetItemText($hListView, $selected, 1)
	
	If $iIndex = "" Then
		MsgBox(64, "Information", "Please select station")
	Else
		If FileExists($dir&"\Link.m3u") Then
			FileDelete($dir&"\Link.m3u")
		EndIf
		
		WMOpenFile($URL)
		WMPlay($URL)
		GUICtrlSetData($label, "Playing: "&$Title)
		WinActivate("Radio By G.H")
	EndIf
EndFunc

Func _Stop()
	WMStop()
	GUICtrlSetData($label, "Playing: ")
EndFunc

Func _Add()
	If GUICtrlRead($urlR) = "" And GUICtrlRead($titleR) = "" Then
		MsgBox(64, "Information", "Please insert URL and Title")
	Else
	
		If GUICtrlRead($urlR) = "" Then
			MsgBox(64, "Information", "Please insert URL")
		Else
		If GUICtrlRead($titleR) = "" Then
			MsgBox(64, "Information", "Please insert Title")
		Else

		If Not FileExists($dir&"\Radio.ini") Then
			$file2 = FileOpen($dir&"\Radio.ini", 1)
			FileClose($file2)
		EndIf
		
		$answer = _Search()
		
		If $answer = 1 Then
			$count = _FileCountLines($dir&"\Radio.ini")

			$file = FileOpen($dir&"\Radio.ini", 1)
			_FileWriteToLine($dir&"\Radio.ini", $count + 1, GUICtrlRead($titleR), 1)
			_FileWriteToLine($dir&"\Radio.ini", $count + 2, GUICtrlRead($urlR), 1)
			FileClose($file)
			_Refresh()
		Else
			MsgBox(64, "Information", "You already insert the URL: "&GUICtrlRead($urlR))
		EndIf
	EndIf
	EndIf
	EndIf
EndFunc

Func _Search()
	$lines = _FileCountLines($dir&"\Radio.ini")
	For $i=2 To $lines Step 2
		If FileReadLine($dir&"\Radio.ini", $i) = GUICtrlRead($urlR) Then
			Return(0)
		EndIf
	Next
	Return(1)
EndFunc

Func _asd()
		
EndFunc


Func _Refresh()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListView))
	If FileExists($dir&"\Radio.ini") Then
		$stations = _FileCountLines($dir&"\Radio.ini")
		$z=0
		For $i=1 To $stations Step 2
			$title = FileReadLine($dir&"\Radio.ini", $i)
			$url = FileReadLine($dir&"\Radio.ini", $i+1)
			_GUICtrlListView_AddItem($hListView, $title)
			_GUICtrlListView_AddSubItem($hListView, $z, $url, 1)
			$z+=1
		Next
	EndIf
EndFunc


Func _Delete()
	$iIndex = _GUICtrlListView_GetSelectedIndices($hListView)
	$selected = _GUICtrlListView_SetSelectionMark($hListView, $iIndex)
	
    If $iIndex = "" Then
        MsgBox(64, "Information", "Please select station")
    Else
		$iIndex = $iIndex*2
		$lines = _FileCountLines($dir&"\Radio.ini")
        $file = FileOpen($dir&"\Radio.ini", 1)  
		
		If $lines <= 2 Then
			_FileWriteToLine($dir&"\Radio.ini", $iIndex+1, "", 1)
			_FileWriteToLine($dir&"\Radio.ini", $iIndex+1, "", 1)	
		Else	
			_FileWriteToLine($dir&"\Radio.ini", $iIndex+1, "", 1)
			_FileWriteToLine($dir&"\Radio.ini", $iIndex+1, "", 1) 
		EndIf
		
        FileClose($file)
        _Refresh()
    EndIf
EndFunc

Func _Delete2()
	$iIndex = _GUICtrlListView_GetSelectedIndices($hListView)
	$selected = _GUICtrlListView_SetSelectionMark($hListView, $iIndex)
	
    If $iIndex = "" Then
        MsgBox(64, "Information", "Please select station")
    Else
			
        $file = FileOpen($dir&"\Radio.ini", 1)       
		_FileWriteToLine($dir&"\Radio.ini", $iIndex+2, "", 1)
        _FileWriteToLine($dir&"\Radio.ini", $iIndex+1, "", 1) 
        FileClose($file)
        _Refresh()
    EndIf
EndFunc


Func _DeleteAll()
    $mbox = MsgBox(3, "Quetion", "You sure u want delete all list?")
    If $mbox = 6 Then
        FileDelete($dir&"\Radio.ini")
        FileOpen($dir&"\Radio.ini", 1)
        FileClose($dir&"\Radio.ini")
        _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListView))
    Else
    EndIf
EndFunc

Func _OnDoubleclick()
	$iIndex = _GUICtrlListView_GetSelectedIndices($hListView)
	$selected = _GUICtrlListView_SetSelectionMark($hListView, $iIndex)
	
	If $iIndex = "" Then
        Return
    Else
		_Play()
	EndIf
EndFunc 

Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
    Local $tagNMHDR, $event, $hwndFrom, $code
    $tagNMHDR = DllStructCreate("int;int;int", $lParam)
    If @error Then Return 0
    $code = DllStructGetData($tagNMHDR, 3)
    If $wParam = $hListView And $code = -3 Then $DoubleClicked = True
    Return $GUI_RUNDEFMSG
EndFunc

While 1	
	WmSetVolume(GUICtrlRead($slider))

	$mMsg = GUIGetMsg()
	$tMsg = TrayGetMsg()
		
	If $DoubleClicked Then
        _Play()
        $DoubleClicked = False
    EndIf	
		
	Select
		Case $mMsg = $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE)
			Opt("TrayIconHide", 0)
		Case $mMsg = $play
			_Play()
		Case $mMsg = $stop
			_Stop()			
		Case $mMsg = $delete
			_Delete()	
		Case $mMsg = $deleteall
			_DeleteAll()	
		Case $mMsg = $add
			_Add()		
		Case $mMsg = $clear
			GUICtrlSetData($titleR, "") 
			GUICtrlSetData($urlR, "")	
		Case $mMsg = $play2
			_Play()			
		Case $mMsg = $delete2
			_Delete()
		Case $mMsg = $deleteall2
			_DeleteAll()
		Case $tMsg = $restore
			GUISetState(@SW_RESTORE)
			GUISetState(@SW_SHOW)
			Opt("TrayIconHide", 1)
		Case $tMsg = $exit
			WMClosePlayer()
			Exit
		Case $tMsg=$TRAY_EVENT_PRIMARYDOWN
			GUISetState(@SW_RESTORE)
			GUISetState(@SW_SHOW)
			Opt("TrayIconHide", 1)
	EndSelect
WEnd