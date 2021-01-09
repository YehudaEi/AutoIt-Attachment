#include <GUIConstants.au3>
#include <WMMedia.au3>
#include <File.au3>
#include <Constants.au3>

Opt("TrayMenuMode",1)
$restore = TrayCreateItem("Restore")
TrayCreateItem("")
$exit = TrayCreateItem("Exit")
TraySetState()
Opt("TrayIconHide", 1)
TraySetClick(8) ; Pressing secondary mouse button

$version = "v1.2"

Global $play, $stop, $add, $addGui
WMStartPlayer()

If Not FileExists(@ProgramFilesDir&"\Windows Media Player\wmplayer.exe") Then
	MsgBox(16, "Crictal", "Windows Media Player must be installed")
	Exit
EndIf


	
GUICreate("Radio Player "&$version, 380, 320, (@DesktopWidth-380)/2, (@DesktopHeight-320)/2)
$play = GUICtrlCreateButton("Play", 300, 10, 60, 30)
$stop = GUICtrlCreateButton("Stop", 300, 40, 60, 30)
$delete = GUICtrlCreateButton("Delete", 300, 70, 60, 30)
$deleteall = GUICtrlCreateButton("Delete All", 300, 100, 60, 30)
$list = GUICtrlCreateList("", 10, 10, 250, 130)

$label = GUICtrlCreateLabel("Playing: ", 10, 140, 370, 20)
GUICtrlCreateLabel("Volume:  -", 10, 160, 60, 20)
$slider = GUICtrlCreateSlider(70, 155, 220, 30)
GUICtrlSetData($slider, 80)
GUICtrlCreateLabel("+", 290, 160, 10, 20)

GUICtrlCreateLabel("Title", 10, 200, 50, 20)
$titleR = GUICtrlCreateInput("", 50, 200, 250, 20)

GUICtrlCreateLabel("URL", 10, 240, 50, 20)
$urlR = GUICtrlCreateInput("", 50, 240, 250, 20)

$add = GUICtrlCreateButton("Add", 10, 270, 60, 30)
$clear = GUICtrlCreateButton("Clear", 80, 270, 60, 30)

GUICtrlCreateLabel("By Gil Hanan", 300, 300, 70, 20)
GUISetState()

_Refresh()

Func _Play()
	
	If GUICtrlRead($list) = "" Then
		MsgBox(64, "Information", "Please select station")
	Else
		If FileExists(@MyDocumentsDir&"\Link.m3u") Then
			FileDelete(@MyDocumentsDir&"\Link.m3u")
		EndIf
		

		$sum2 = _GetClearTitle()
		$sum = _GetClearURL()
		WMOpenFile($sum)
		WMPlay($sum)
		GUICtrlSetData($label, "Playing: "&$sum2)
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

		
	If	StringInStr(GUICtrlRead($urlR), "~") <> 0 Or StringInStr(GUICtrlRead($titleR), "~") Then
		MsgBox(64, "Information", "Sorry you can't using the char ~")
	Else
		If Not FileExists(@MyDocumentsDir&"\Radio.ini") Then
			$file2 = FileOpen(@MyDocumentsDir&"\Radio.ini", 1)
			FileClose($file2)
		EndIf
		
		$answer = _Search()
		
		If $answer = 1 Then
			$count = _FileCountLines(@MyDocumentsDir&"\Radio.ini")

			$file2 = FileOpen(@MyDocumentsDir&"\Radio.ini", 1)
			_FileWriteToLine(@MyDocumentsDir&"\Radio.ini", $count + 1, GUICtrlRead($titleR), 1)
			_FileWriteToLine(@MyDocumentsDir&"\Radio.ini", $count + 2, GUICtrlRead($urlR), 1)
			FileClose($file2)
			_Refresh()
		Else
			MsgBox(64, "Information", "You already insert the URL: "&GUICtrlRead($urlR))
		EndIf
	EndIf
	EndIf
	EndIf
	EndIf
EndFunc

Func _Search()
	$lines = _FileCountLines(@MyDocumentsDir&"\Radio.ini")
	For $i=2 To $lines Step 2
		If FileReadLine(@MyDocumentsDir&"\Radio.ini", $i) = GUICtrlRead($urlR) Then
			Return(0)
		EndIf
	Next
	Return(1)
EndFunc

Func _Refresh()
	GUICtrlSetData($list, "")
	If FileExists(@MyDocumentsDir&"\Radio.ini") Then
		$stations = _FileCountLines(@MyDocumentsDir&"\Radio.ini")
		
		For $i=1 To $stations Step 2
			$title = FileReadLine(@MyDocumentsDir&"\Radio.ini", $i)
			$url = FileReadLine(@MyDocumentsDir&"\Radio.ini", $i+1)
			GUICtrlSetData($list, $title&" ~ "&$url)
		Next
	EndIf
EndFunc

Func _Delete()
	If GUICtrlRead($list) = "" Then
		MsgBox(64, "Information", "Please select station")
	Else

		$lines = _FileCountLines(@MyDocumentsDir&"\Radio.ini")
		
		$file = FileOpen(@MyDocumentsDir&"\Radio.ini", 1)
		$sum = _GetClearURL()
		
		
		
		For $i=2 to $lines Step 2
		If FileReadLine(@MyDocumentsDir&"\Radio.ini", $i) = $sum Then
				_FileWriteToLine(@MyDocumentsDir&"\Radio.ini", $i-1, "", 1)
				_FileWriteToLine(@MyDocumentsDir&"\Radio.ini", $i-1, "", 1)	
		EndIf
		Next
		FileClose($file)
		_Refresh()
	EndIf
EndFunc

Func _DeleteAll()
	$mbox = MsgBox(3, "Quetion", "You sure u want delete all list?")
	If $mbox = 6 Then
		FileDelete(@MyDocumentsDir&"\Radio.ini")
		FileOpen(@MyDocumentsDir&"\Radio.ini", 1)
		FileClose(@MyDocumentsDir&"\Radio.ini")
		GUICtrlSetData($list, "")
	Else
	EndIf
EndFunc

Func _GetClearURL()
	$sum = GUICtrlRead($list)
	$result = StringInStr($sum, "~")
	$len = StringLen($sum)
	$sum = StringRight($sum, ($len-$result-1))
	Return($sum)
EndFunc

Func _GetClearTitle()
	$sum = GUICtrlRead($list)
	$result = StringInStr($sum, "~")
	$len = StringLen($sum)
	$sum = StringLeft($sum, ($result-1))
	Return($sum)
EndFunc

While 1	
	WmSetVolume(GUICtrlRead($slider))

	$mMsg = GUIGetMsg()
	$tMsg = TrayGetMsg()
		
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
		Case $tMsg = $restore
			GUISetState(@SW_RESTORE)
			GUISetState(@SW_SHOW)
			Opt("TrayIconHide", 1)
		Case $tMsg = $exit
			WMClosePlayer()
			Exit
	EndSelect
WEnd