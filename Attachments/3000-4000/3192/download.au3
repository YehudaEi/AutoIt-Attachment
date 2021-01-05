#include <GuiConstants.au3>

$prev_wintitle = "Downloading Tool"
$countdown = 0
GuiCreate("Downloading Tool", 400, 160,(@DesktopWidth-392)/2, (@DesktopHeight-238)/2 , $WS_OVERLAPPEDWINDOW + $WS_CLIPSIBLINGS)

$Label_1 = GuiCtrlCreateLabel("Saving To:", 10, 10, 400, 20)
$Label_2 = GuiCtrlCreateLabel("Status:", 10, 30, 400, 20)
$Label_3 = GuiCtrlCreateLabel("URL File:", 10, 50, 400, 20)
$Label_4 = GuiCtrlCreateLabel("Time Left:", 10, 70, 400, 20)
$Label_5 = GuiCtrlCreateLabel("Transfer Rate:", 10, 90, 400, 20)
$Label_6 = GUICtrlCreateLabel("Progress:",10,110,400,20)
$Progress = GuiCtrlCreateProgress(20, 130, 360, 20)

If $CmdLine[0] == 0 Then
	$file = InputBox("Downloading Tool","Enter URL of file to download.",ClipGet())
	$size = InetGetSize($file)
	$kb_size = Round($size / 1024) & ' KB'
	$split_file = StringSplit($file,"/")

	If FileExists($split_file[$split_file[0]]) Then
		$answer = FileSaveDialog("File " & $split_file[$split_file[0]] & " Exists...Save As",@ScriptDir,"All Files (*.*)",18)
		If @error Then Exit
		$saving_to = $answer
	Else
		$saving_to = @ScriptDir & "\" & $split_file[$split_file[0]]
	EndIf
	
	If StringLen($saving_to) > 45 Then
		$saving_to = StringLeft($saving_to,45-3-StringLen($split_file[$split_file[0]])) & "..." & $split_file[$split_file[0]]
	Else
		; Do nothing
	EndIf
	If StringLen($file) > 45 Then
		$url = StringLeft($file,45-3-StringLen($split_file[$split_file[0]])) & "..." & $split_file[$split_file[0]]
	Else
		$url = $file
	EndIf
	GUICtrlSetData($Label_1,"Saving To:" & @TAB & $saving_to)
	GUICtrlSetData($Label_3,"URL File:" & @TAB & $url)
	GuiSetState()
	
	InetGet($file,$split_file[$split_file[0]],0,1)
	$timestamp = TimerInit()
	While 1
		$msg = GuiGetMsg()
		If @InetGetActive Then
			If $countdown == 0 Then
				GUICtrlSetData($Label_2,"Status:" & @TAB & @TAB & "Receiving File...")
				GUICtrlSetData($Label_6,"Progress:" & @TAB & Int(@InetGetBytesRead / $size * 100) & "% (" & Round(@InetGetBytesRead / 1024) & " KB of " & $kb_size & ")")
				$diff = TimerDiff($timestamp)/1000
				GUICtrlSetData($Label_5,"Transfer Rate:" & @TAB & Round(@InetGetBytesRead/1024/$diff) & " KB/Sec")
				GUICtrlSetData($Progress,(@InetGetBytesRead/$size)*100)
				GUICtrlSetData($Label_4,("Time Left:" & @TAB & Round((($size - @InetGetBytesRead)/1024)/(@InetGetBytesRead/1024/$diff)) & " Sec"))
				$wintitle = Round((@InetGetBytesRead/$size)*100) & "%" & $split_file[$split_file[0]] & "-" & "Downloading Tool"
				WinSetTitle($prev_wintitle,"",$wintitle)
				$prev_wintitle = $wintitle
				$countdown = 10
			EndIf
			$countdown -= 1
		Else
			GUICtrlSetData($Label_2,"Status:" & @TAB & "Idle")
			If @InetGetBytesRead == $size Then
				TrayTip("Download Complete", $split_file[$split_file[0]], 2)
				Sleep(2000)
				Exit
			Else
				TrayTip("Download Failed", $split_file[$split_file[0]], 2)
				Sleep(2000)
				Exit
			EndIf
		EndIf
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case Else
				;;;
		EndSelect
	WEnd
	Exit
ElseIf $CmdLine[0] == 1 Then
	$file = $CmdLine[1]
	$size = InetGetSize($file)
	$kb_size = Round($size / 1024) & ' KB'
	$split_file = StringSplit($file,"/")
	
	If FileExists($split_file[$split_file[0]]) Then
		$answer = FileSaveDialog("File " & $split_file[$split_file[0]] & " Exists...Save As",@ScriptDir,"All Files (*.*)",18)
		If @error Then Exit
		$saving_to = $answer
	Else
		$saving_to = @ScriptDir & "\" & $split_file[$split_file[0]]
	EndIf

	If StringLen($saving_to) > 45 Then
		$saving_to = StringLeft($saving_to,45-3-StringLen($split_file[$split_file[0]])) & "..." & $split_file[$split_file[0]]
	Else
		; Do nothing
	EndIf
	If StringLen($file) > 45 Then
		$url = StringLeft($file,45-3-StringLen($split_file[$split_file[0]])) & "..." & $split_file[$split_file[0]]
	Else
		$url = $file
	EndIf
	
	GUICtrlSetData($Label_1,"Saving To:" & @TAB & $saving_to)
	GUICtrlSetData($Label_3,"URL File:" & @TAB & $url)
	GuiSetState()

	InetGet($file,$split_file[$split_file[0]],0,1)
	$timestamp = TimerInit()
	While 1
		$msg = GuiGetMsg()
		If @InetGetActive Then
			If $countdown == 0 Then
				GUICtrlSetData($Label_2,"Status:" & @TAB & @TAB & "Receiving File...")
				GUICtrlSetData($Label_6,"Progress:" & @TAB & Int(@InetGetBytesRead / $size * 100) & "% (" & Round(@InetGetBytesRead / 1024) & " KB of " & $kb_size & ")")
				$diff = TimerDiff($timestamp)/1000
				GUICtrlSetData($Label_5,"Transfer Rate:" & @TAB & Round(@InetGetBytesRead/1024/$diff) & " KB/Sec")
				GUICtrlSetData($Progress,(@InetGetBytesRead/$size)*100)
				GUICtrlSetData($Label_4,("Time Left:" & @TAB & Round((($size - @InetGetBytesRead)/1024)/(@InetGetBytesRead/1024/$diff)) & " Sec"))
				$wintitle = Round((@InetGetBytesRead/$size)*100) & "%" & $split_file[$split_file[0]] & "-" & "Downloading Tool"
				WinSetTitle($prev_wintitle,"",$wintitle)
				$prev_wintitle = $wintitle
				$countdown = 10
			EndIf
			$countdown -= 1
		Else
			If @InetGetBytesRead == $size Then
				TrayTip("Download Complete", $split_file[$split_file[0]], 2)
				Sleep(2000)
				Exit
			Else
				TrayTip("Download Failed", $split_file[$split_file[0]], 2)
				Sleep(2000)
				Exit
			EndIf
		EndIf
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case Else
				;;;
		EndSelect
	WEnd
	Exit
ElseIf $CmdLine[0] == 2 Then
	$file = $CmdLine[1]
	$size = InetGetSize($file)
	$kb_size = Round($size / 1024) & ' KB'
	
	If $CmdLine[2] = "-1" Then				; Prefix
		$prefix = ""
	Else
		$prefix = $CmdLine[2]
	EndIf
	
	$split_file = StringSplit($file,"/")
	
	If FileExists($split_file[$split_file[0]]) Then
		$answer = FileSaveDialog("File " & $split_file[$split_file[0]] & " Exists...Save As",@ScriptDir,"All Files (*.*)",18)
		If @error Then Exit
		$saving_to = $answer
	Else
		$saving_to = @ScriptDir & "\" & $split_file[$split_file[0]]
	EndIf

	If StringLen($saving_to) > 45 Then
		$saving_to = StringLeft($saving_to,45-3-StringLen($split_file[$split_file[0]])) & "..." & $split_file[$split_file[0]]
	Else
		; Do nothing
	EndIf
	If StringLen($file) > 45 Then
		$url = StringLeft($file,45-3-StringLen($split_file[$split_file[0]])) & "..." & $split_file[$split_file[0]]
	Else
		$url = $file
	EndIf
	
	GUICtrlSetData($Label_1,"Saving To:" & @TAB & $saving_to)
	GUICtrlSetData($Label_3,"URL File:" & @TAB & $url)
	GuiSetState()

	InetGet($file,$prefix & $split_file[$split_file[0]],0,1)
	$timestamp = TimerInit()
	While 1
		$msg = GuiGetMsg()
		If @InetGetActive Then
			If $countdown == 0 Then
				GUICtrlSetData($Label_2,"Status:" & @TAB & @TAB & "Receiving File...")
				GUICtrlSetData($Label_6,"Progress:" & @TAB & Int(@InetGetBytesRead / $size * 100) & "% (" & Round(@InetGetBytesRead / 1024) & " KB of " & $kb_size & ")")
				$diff = TimerDiff($timestamp)/1000
				GUICtrlSetData($Label_5,"Transfer Rate:" & @TAB & Round(@InetGetBytesRead/1024/$diff) & " KB/Sec")
				GUICtrlSetData($Progress,(@InetGetBytesRead/$size)*100)
				GUICtrlSetData($Label_4,("Time Left:" & @TAB & Round((($size - @InetGetBytesRead)/1024)/(@InetGetBytesRead/1024/$diff)) & " Sec"))
				$wintitle = Round((@InetGetBytesRead/$size)*100) & "%" & $split_file[$split_file[0]] & "-" & "Downloading Tool"
				WinSetTitle($prev_wintitle,"",$wintitle)
				$prev_wintitle = $wintitle
				$countdown = 10
			EndIf
			$countdown -= 1
		Else
			If @InetGetBytesRead == $size Then
				TrayTip("Download Complete", $prefix & $split_file[$split_file[0]], 2)
				Sleep(2000)
				Exit
			Else
				TrayTip("Download Failed", $prefix & $split_file[$split_file[0]], 2)
				Sleep(2000)
				Exit
			EndIf
		EndIf
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case Else
				;;;
		EndSelect
	WEnd
	Exit
ElseIf $CmdLine[0] == 3 Then
	$file = $CmdLine[1]
	
	If $CmdLine[2] = "-1" Then				; Prefix
		$prefix = ""
	Else
		$prefix = $CmdLine[2]
	EndIf
	
	$size = InetGetSize($file)
	$kb_size = Round($size / 1024) & ' KB'
	$split_file = StringSplit($file,"/")
	If Not FileExists($CmdLine[3]) Then		; Directory
		DirCreate($CmdLine[3])
		$saving_to = $CmdLine[3] & "\" & $split_file[$split_file[0]]
	Else
		If FileExists($CmdLine[3] & "\" & $split_file[$split_file[0]]) Then
			$answer = FileSaveDialog("File " & $split_file[$split_file[0]] & " Exists...Save As",$CmdLine[3],"All Files (*.*)",18)
			If @error Then Exit
			$saving_to = $answer
		Else
			$saving_to = $CmdLine[3] & "\" & $split_file[$split_file[0]]
		EndIf
	EndIf
	FileChangeDir($CmdLine[3])
	
	
	If StringLen($saving_to) > 45 Then
		$saving_to = StringLeft($saving_to,45-3-StringLen($split_file[$split_file[0]])) & "..." & $split_file[$split_file[0]]
	Else
		; Do nothing
	EndIf
	If StringLen($file) > 45 Then
		$url = StringLeft($file,45-3-StringLen($split_file[$split_file[0]])) & "..." & $split_file[$split_file[0]]
	Else
		$url = $file
	EndIf
	GUICtrlSetData($Label_1,"Saving To:" & @TAB & $saving_to)
	GUICtrlSetData($Label_3,"URL File:" & @TAB & $url)
	GuiSetState()

	InetGet($file,$prefix & $split_file[$split_file[0]],0,1)
	$timestamp = TimerInit()
	While 1
		$msg = GuiGetMsg()
		If @InetGetActive Then
			If $countdown == 0 Then
				GUICtrlSetData($Label_2,"Status:" & @TAB & @TAB & "Receiving File...")
				GUICtrlSetData($Label_6,"Progress:" & @TAB & Int(@InetGetBytesRead / $size * 100) & "% (" & Round(@InetGetBytesRead / 1024) & " KB of " & $kb_size & ")")
				$diff = TimerDiff($timestamp)/1000
				GUICtrlSetData($Label_5,"Transfer Rate:" & @TAB & Round(@InetGetBytesRead/1024/$diff) & "KB/Sec")
				GUICtrlSetData($Progress,(@InetGetBytesRead/$size)*100)
				GUICtrlSetData($Label_4,("Time Left:" & @TAB & Round((($size - @InetGetBytesRead)/1024)/(@InetGetBytesRead/1024/$diff)) & " Sec"))
				$wintitle = Round((@InetGetBytesRead/$size)*100) & "%" & $split_file[$split_file[0]] & "-" & "Downloading Tool"
				WinSetTitle($prev_wintitle,"",$wintitle)
				$prev_wintitle = $wintitle
				$countdown = 10
			EndIf
			$countdown -= 1
		Else
			If @InetGetBytesRead == $size Then				
				TrayTip("Download Complete", $prefix & $split_file[$split_file[0]], 2)
				Sleep(2000)
				Exit
			Else
				TrayTip("Download Failed", $prefix & $split_file[$split_file[0]], 2)
				Sleep(2000)
				Exit
			EndIf
		EndIf
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case Else
				;;;
		EndSelect
	WEnd
	Exit
Else
	MsgBox(0,"Testing","Error")
	Exit
EndIf