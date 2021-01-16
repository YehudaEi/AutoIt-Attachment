#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Icon.ico
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GuiListView.au3>
#include <GuiImageList.au3>
Opt("GUIResizeMode",1)

Global Const $uninstallpath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"


#Region ; input gui vars
Global $input, $inputtext, $inputinput, $inputok, $inputcancel
#EndRegion ; input gui vars

#Region ; main gui vars
Global $gui = GUICreate("Uninstall Tool",640,480,-1,-1,0x00CF0000)
Global $list
Global $oldsize
Global $Images = _GUIImageList_Create(16, 16, 5, 3)
Global $uninstall = GUICtrlCreateButton("Run Uninstaller",5,453,100)
Global $rename = GUICtrlCreateButton("Rename Entry",110,453,100)
Global $remove = GUICtrlCreateButton("Remove Entry",220,453,100)
Global $filter = GUICtrlCreateButton("Filter Entries",330,453,100)
Global $refresh = GUICtrlCreateButton("Refresh List",535,453,100)
Global $imenu
Global $iinfo
#EndRegion ; Main gui vars

Global $files[10]
Global $strings[10]
Global $keys[10]
Global $information[10]
Global $file
Global $Space, $Size
Global $filtertext = ""

RePopulate()

GUISetState(@SW_SHOW,$gui)

While 1
	$msg = GUIGetMsg(1)
	If $msg[0]<>0 Then
		Switch $msg[1]
			Case $gui
				MainEvent($msg[0])
			Case $input
				InputEvent($msg[0])
		EndSwitch
	EndIf
	$Size = WinGetPos("Uninstall Tool")
	If Not($Size[2]==$oldsize) Then
		_GUICtrlListView_SetColumnWidth($list,0,$Size[2]-30)
		$oldsize = $Size[2]
	EndIf
	Sleep(3)
WEnd

#Region ; GUI
Func MainEvent($message)
	Switch $message
		Case -3
			Exit
		Case $uninstall
			For $i = 0 To $file-1
				If _GUICtrlListView_GetItemSelected($list,$i) Then
					Run($strings[$i])
					ExitLoop
				EndIf
			Next
		Case $rename
			For $i = 0 To $file-1
				If _GUICtrlListView_GetItemSelected($list,$i) Then
					$Space = InputBox("Rename","Rename Entry",RegRead($uninstallpath&$keys[$i],"DisplayName"),"",300,150)
					If Not(@error) Then
						RegWrite($uninstallpath&$keys[$i],"DisplayName","REG_SZ",$Space)
						_GUICtrlListView_SetItem($list,$Space,$i)
					EndIf
					ExitLoop
				EndIf
			Next
		Case $remove
			For $i = 0 To $file-1
				If _GUICtrlListView_GetItemSelected($list,$i) Then
					$confirmation = MsgBox(3,"Confirm Removal","Are you sure that you want to remove this uninstaller reference?")
					If $confirmation == 6 Then
						RegDelete($uninstallpath&$keys[$i])
						RePopulate()
					EndIf
				EndIf
			Next
		Case $refresh
			RePopulate()
		Case $filter
			InputInit()
		Case $iinfo
			For $i = 0 To $file-1
				If _GUICtrlListView_GetItemSelected($list,$i) Then
					MsgBox(0,"Information",$information[$i])
				EndIf
			Next
		EndSwitch
EndFunc

Func InputEvent($message)
	Switch $message
		Case -3
			InputDenit()
		Case $inputcancel
			InputDenit()
		Case $inputok
			$filtertext = GUICtrlRead($inputinput)
			InputDenit()
			RePopulate()
	EndSwitch
EndFunc

Func InputInit()
	$input = GUICreate("Filter",300,100,-1,-1,0x80C80000)
	$inputtext = GUICtrlCreateLabel("Enter the text to search for:",7,13)
	$inputinput = GUICtrlCreateInput($filtertext,10,40,280)
	$inputok = GUICtrlCreateButton("OK",50,70,75,-1,1)
	$inputcancel = GUICtrlCreateButton("Cancel",175,70,75)
	GUISetState(@SW_SHOW,$input)
EndFunc
Func InputDenit()
	GUISetState(@SW_HIDE,$input)
	WinActivate("Uninstall Tool")
	GUIDelete($input)
EndFunc
#EndRegion
#Region ; Population
Func RePopulate()
	_GUICtrlListView_DeleteAllItems($list)
	_GUICtrlListView_DeleteColumn($list,0)
	GUICtrlDelete($list)
	$list = GuiCtrlCreateListView("",0,0,640,450)
	$imenu = GUICtrlCreateContextMenu($list)
	$iinfo = GUICtrlCreateMenuItem("Information",$imenu)
	$file = 0
	$Images = _GUIImageList_Create(16, 16, 5, 3)
	Populate()
	_GUICtrlListView_AddColumn($list, "Programs To Remove", 120)
	_GUICtrlListView_SetColumnWidth($list,0,615)
	Populate(1)
EndFunc

Func Populate($action = 0)
	Local $path = $uninstallpath
	Local $key, $name, $string, $icon, $iconindex, $temp
	For $i=1 To 999999
		$key = RegEnumKey($path,$i)
		If @error Then ExitLoop
		$name = RegRead($path &$key,"DisplayName")
		If Not(@error) And ($filtertext=="" Or StringInStr($name,$filtertext)>0) Then
			$string = RegRead($path &$key,"UninstallString")
			If Not(@error) Then
				If $action == 1 Then
					$keys[$file] = $key
					$string = ""
					$temp = RegRead($path &$key,"Publisher")
					If Not(@error) And Not($temp=="") Then $string = $string & "Publisher: " & $temp & @CRLF
					$temp = RegRead($path &$key,"DisplayVersion")
					If Not(@error) And Not($temp=="") Then $string = $string & "Version: " & $temp & @CRLF
					$temp = RegRead($path &$key,"InstallDate")
					If Not(@error) And StringLen($temp)==8 Then
						$temp = ToMonth(StringLeft(StringRight($temp,4),2)) & StringRight($temp,2) & ", " & StringLeft($temp,4)
						$string = $string & "Install Date: " & $temp & @CRLF
					EndIf
					$information[$file] = $string
					RowAdd($name, $string)
				Else
					$icon = RegRead($path &$key,"DisplayIcon")
					$iconindex = 0
					$temp = StringSplit($icon,",")
					If $temp[0]==2 Then
						$iconindex = Number($temp[2])
						$icon = $temp[1]
					EndIf
					$icon = StringReplace($icon,"PROGRA~1","Program Files")
					If Not(@error) And FileExists($icon) And IsNumber($iconindex) And $iconindex>=0 Then
						_GUIImageList_AddIcon($Images, $icon, $iconindex)
					Else
						$icon = RegRead($path &$key,"InstallLocation")&"\"
						$iconindex = 0
						Local $first = FileFindFirstFile($icon&"*.exe")
						$icon = $icon & FileFindNextFile($first)
						If Not(@error) Then
							_GUIImageList_AddIcon($Images, $icon, $iconindex)
						Else
							_GUIImageList_AddIcon($Images, @SystemDir & "\Setup.exe", $iconindex)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	If $action == 0 Then
		_GUICtrlListView_SetImageList($list, $Images, 1)
	EndIf
EndFunc

Func RowAdd($text, $string)
	$files[$file] = _GUICtrlListView_AddItem($list,$text,$file)
	$strings[$file] = $string
	$file = $file + 1
	If $file > UBound($files)-1 Then
		ReDim $files[$file+10]
		ReDim $strings[$file+10]
		ReDim $keys[$file+10]
		ReDim $information[$file+10]
	EndIf
EndFunc

Func ToMonth($month)
	If $month == "01" Then Return "January "
	If $month == "02" Then Return "February "
	If $month == "03" Then Return "March "
	If $month == "04" Then Return "April "
	If $month == "05" Then Return "May "
	If $month == "06" Then Return "June "
	If $month == "07" Then Return "July "
	If $month == "08" Then Return "August "
	If $month == "09" Then Return "September "
	If $month == "10" Then Return "October "
	If $month == "11" Then Return "November "
	Return "December "
EndFunc
#EndRegion ; Population