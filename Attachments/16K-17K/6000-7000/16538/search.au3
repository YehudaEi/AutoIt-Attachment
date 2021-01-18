#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.6.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include<File.au3>
#include<GuiConstants.au3>
#include<Array.au3>
$state=1
Global $nr=0
$search="*.*"
$folder=@DesktopDir
$files_folders=0
$gui=GUICreate("Search" , 260 , 100 ,Random(@DesktopWidth/7 , @DesktopWidth/3,1) ,Random(@DesktopHeight/7 , @DesktopHeight/3,1),-1,$WS_EX_TOOLWINDOW)
$input=GUICtrlCreateInput("" , 1 , 1 , 200 ,20)
$browse=GUICtrlCreateButton("Browse" , 202 , 1,55,95)
$searcz=GUICtrlCreateButton("Search" ,60 , 60,100,40,$BS_DEFPUSHBUTTON )
$s_fi=GUICtrlCreateRadio("Files" , 1 , 22)
$s_fo=GUICtrlCreateRadio("Folders" , 42 , 22)
$s_f=GUICtrlCreateRadio("Files and folders" , 103,22)
GUISetState()
While 1
	Sleep(1)
	$msg=GUIGetMsg()
	Switch $msg
		Case $browse
			browse()
		Case $searcz
			Global $found[1]
			changestate()
			search()
			GUICtrlSetState($input , $GUI_FOCUS)
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func all($k)
	Dim $folders=_FileListToArray($k,"*.*",2)
	If Not @error Then 
		If $folders[0]<>0 Then 
			For $i=1 To $folders[0]
				ToolTip($k ,0 ,0)
				all($k&$folders[$i]&"\")
			Next
		EndIf
	EndIf
	Dim $files=_FileListToArray($k,$search ,$files_folders)
	If Not @error Then
		If $files[0]<>0 Then
			For $j=1 To $files[0]
				$dir=$k
				$print=$dir&"\"&$files[$j]
				_ArrayAdd($found,$print)
			Next
		EndIf
	EndIf
EndFunc
Func browse()
	$file=FileSelectFolder("Choose folder" , "",2,"")
	If Not @error Then
		$folder=$file
	EndIf
EndFunc
Func search()
	If BitAND(GUICtrlRead($s_fi), $GUI_CHECKED) = $GUI_CHECKED Then $files_folders=1
	If BitAND(GUICtrlRead($s_fo), $GUI_CHECKED) = $GUI_CHECKED Then $files_folders=2
	If BitAND(GUICtrlRead($s_f), $GUI_CHECKED) = $GUI_CHECKED Then $files_folders=0
	If $search="" Then $search="*.*"
	$string=StringSplit(GUICtrlRead($input),".")
	$search=""
	If @error<>1 Then
		For $j=1 To $string[0]-1
			$search=$search&"*"&$string[$j];&"*"
		Next
		$search=$search&"."&$string[$string[0]]&"*"
	Else
		$search="*"&GUICtrlRead($input)&"*"
	EndIf
	all($folder)
	ToolTip("")
	_ArrayDisplay($found)
	changestate()
EndFunc
Func changestate()
	If $state=0 Then 
		$state=1
	Else
		$state=0
	EndIf
	If $state=0 Then
		GUICtrlSetState($browse , $GUI_DISABLE)
		GUICtrlSetState($searcz , $GUI_DISABLE)
		GUICtrlSetState($input , $GUI_DISABLE)
		GUICtrlSetState($s_f , $GUI_DISABLE)
		GUICtrlSetState($s_fo , $GUI_DISABLE)
		GUICtrlSetState($s_fi , $GUI_DISABLE)
	Else
		GUICtrlSetState($browse , $GUI_ENABLE)
		GUICtrlSetState($searcz , $GUI_ENABLE)
		GUICtrlSetState($input , $GUI_ENABLE)
		GUICtrlSetState($s_f , $GUI_ENABLE)
		GUICtrlSetState($s_fo , $GUI_ENABLE)
		GUICtrlSetState($s_fi , $GUI_ENABLE)
	EndIf
EndFunc

		
		