#include <GUIConstants.au3>
#Include <GuiTab.au3>

Dim $AppName = StringMid(@ScriptName,1,StringLen(@ScriptName) - 4)
Dim $font="Courier New"
Dim $fontSize = 9
Dim $fontWeight = 400
Dim $InputChrWidth = 8
Dim $LabelChrWidth = 7
Dim $Button_width = 75
Dim $Button_height = 20
Dim $Border_spacing = 3
Dim $Menu_height = 20
Dim $Display_width = 600
Dim $Number_of_Rows = 14
Dim $RowHeight = 20
Dim $Tabs_Tab_Height = 20
Dim $Display_height = $Menu_height + $Border_spacing + $Tabs_Tab_Height + $Border_spacing + ($Number_of_Rows * $RowHeight) +$Border_spacing + $Button_height + $Border_spacing + $Border_spacing + $Button_height + $Border_spacing;400

Dim $package[100][100]

Dim $FileWriteMode = 2
Dim $packages_information
Dim $TabControl[100][100]
Dim $TabControlType[100][100]

Dim $display
Dim $Button_width
Dim $Button_height
Dim $Border_spacing
Dim $Menu_height
Dim $Menu_height
Dim $cancel_Button
Dim $Save_Button
Dim $new_Button
Dim $exititem
Dim $saveitem
Dim $fileitem
Dim $Tabs
Dim $Tab[100]
Dim $TabName[100]
Dim $package_name[100]
Dim $package_desc[100]
Dim $code_value[100]
Dim $path_value[100]
Dim $version_value[100]
Dim $desc_value[100]
Dim $iter_value[100]
Dim $data_source_files_value[100]
Dim $stage_url_value[100]
Dim $dev_url_value[100]
Dim $prod_url_value[100]
Dim $url_last_part_value[100]
Dim $lastCarfile_v2_value[100]
Dim $lastCarfile_v3_value[100]
Dim $lastCarfile_value[100]
Dim $update_button[100]
Dim $copy_button[100]
Dim $delete_button[100]

$oRP = ObjCreate("RICHTEXT.RichtextCtrl.1")

$FilePath = @ScriptDir
$FileName = "channel.xml"


Display($AppName)

	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $cancel_Button Or $msg = $exititem Or $msg = $GUI_EVENT_CLOSE
				Exit
			Case $msg = $Save_Button Or $msg = $saveitem
				Create_SaveFileArray()
				GUICtrlSetState($saveitem,$GUI_DISABLE)
				GUICtrlSetState($save_Button,$GUI_DISABLE)
			Case $msg = $fileitem
				$FileName = FileOpenDialog("Choose a file.","","XML (*.xml)|All (*.*)",1+2)
				If $FileName <> "" Then
					Process_File($FileName)
					GUICtrlSetState($new_Button,$GUI_ENABLE)
				EndIf
			Case $msg == $update_button[_GUICtrlTabGetCurFocus($Tabs)] 
					GUICtrlSetState($saveitem,$GUI_ENABLE)
					GUICtrlSetState($save_Button,$GUI_ENABLE)
					If $TabName[_GUICtrlTabGetCurFocus($Tabs)] <> GUICtrlRead($TabControl[_GUICtrlTabGetCurFocus($Tabs)+1][2]) Then
						GUICtrlSetData($Tab[_GUICtrlTabGetCurFocus($Tabs)],GUICtrlRead($TabControl[_GUICtrlTabGetCurFocus($Tabs)+1][2])) 
						$TabName[_GUICtrlTabGetCurFocus($Tabs)] = GUICtrlRead($TabControl[_GUICtrlTabGetCurFocus($Tabs)+1][2])
					EndIf
				Case $msg == $copy_button[_GUICtrlTabGetCurFocus($Tabs)]
					$Tab[_GUICtrlTabGetItemCount($Tabs)] = GUICtrlCreateTabitem($TabName[_GUICtrlTabGetCurFocus($Tabs)] & " - COPY")
					$TabName[_GUICtrlTabGetItemCount($Tabs)] = $TabName[_GUICtrlTabGetCurFocus($Tabs)] & " - COPY"
				Case $msg == $delete_button[_GUICtrlTabGetCurFocus($Tabs)]
					$TabName[_GUICtrlTabGetCurFocus($Tabs)] = "DELETED"
					
					; ********** This is one of the refresh problems 
					GUICtrlSetData($Tab[_GUICtrlTabGetCurFocus($Tabs)],$TabName[_GUICtrlTabGetCurFocus($Tabs)])
					
					;If _GUICtrlTabGetCurFocus($Tabs) < _GUICtrlTabGetItemCount($Tabs) Then
						_GUICtrlTabSetCurSel($Tabs, $Tab[_GUICtrlTabGetCurFocus($Tabs)]+1)
						_GUICtrlTabSetCurFocus($Tabs, $Tab[_GUICtrlTabGetCurFocus($Tabs)]+1)
						
						;_GUICtrlTabSetCurSel($Tabs, $Tab[_GUICtrlTabGetCurFocus($Tabs)]-1)
					;Else
					;	_GUICtrlTabSetCurSel($Tabs, $Tab[_GUICtrlTabGetCurFocus($Tabs)]-1)
					;	_GUICtrlTabSetCurSel($Tabs, $Tab[_GUICtrlTabGetCurFocus($Tabs)]+1)
					;EndIf
					
					; ********** This is one of the refresh problems
					
					GUICtrlSetState($saveitem,$GUI_ENABLE)
					GUICtrlSetState($save_Button,$GUI_ENABLE)
		EndSelect
	WEnd
Terminate()

Func Process_File($FileName)
	$channel_array = OpenFile($FileName)
	If UBound($channel_array) > 0 Then
		$x_1 = 0
		$x_3 = 1
		
		$size = WinGetClientSize($display) ; $array[0] = Width of window's client area, $array[1] = Height of window's client area 
		$Tab_Count = 0
		$Tab_left = 1
		$Tab_top = 0
		$Tab_width = $size[0]; - 1
		$Tab_height = $size[1] - $Button_height - ($Border_spacing*2)
		$Tab_style = -1
		$Tab_exStyle = -1
		
		$RICHTEXTBox_Left = $Tab_left
		$RICHTEXTBox_Top = $Tab_top + 20
		$RICHTEXTBox_Width = $Tab_width
		$RICHTEXTBox_Height = $Tab_height - $Menu_height
		
		$Tabs = GUICtrlCreateTab($Tab_left,$Tab_top,$Tab_width,$Tab_height,$Tab_style,$Tab_exStyle)
		While $x_1 < UBound($channel_array) - 1
			$x_2 = 1
			$TabControlCount = 1
			If StringInStr($channel_array[$x_1],"<packages") > 0 Then 
				$packages_information = $channel_array[$x_1]
				$Tab[$Tab_Count] = GUICtrlCreateTabitem("channel.xml info")
				$RTmsg = $channel_array[$x_1]
				RichTextBox($RTmsg,$RICHTEXTBox_Left,$RICHTEXTBox_Top,$RICHTEXTBox_Width,$RICHTEXTBox_Height,$Tab_Count)
				$Tab_Count = $Tab_Count + 1
			ElseIf StringInStr($channel_array[$x_1],"<package ") > 0 Then
				$Tab_Name = StringMid($channel_array[$x_1],StringInStr($channel_array[$x_1],chr(34)) + 1,StringInStr($channel_array[$x_1],chr(34),0,2) - StringInStr($channel_array[$x_1],chr(34),0,1) - 1)
				$Tab[$Tab_Count] = GUICtrlCreateTabitem($Tab_Name)
				$TabName[$Tab_Count] = $Tab_Name
				$Tab_Count = $Tab_Count + 1
				While StringInStr($channel_array[$x_1],"</package>") = 0
					$package[_GUICtrlTabGetItemCount($Tabs)][$x_2] = $channel_array[$x_1]
					$ParsedNode = ParseNode($channel_array[$x_1])
					$LeftStart = 0 
					For $x_4 = 1 To UBound($ParsedNode)-1
						If StringMid($ParsedNode[$x_4],1,1) = chr(34) Then
							;input
							$InputText = StringMid($ParsedNode[$x_4],2,StringLen($ParsedNode[$x_4])-2)
							$InputLeft = $LeftStart
							$InputTop = $Tab_top+($RowHeight*$x_2)+4
							If StringLen($InputText) < 4 Then
								$InputWidth = (StringLen($InputText)+2)*$InputChrWidth
							Else
								$InputWidth = StringLen($InputText)*$InputChrWidth
							EndIf
							If ($InputWidth+$LeftStart) > $Tab_width Then $InputWidth = $Tab_width - $LeftStart - 20
							$InputHeight = $RowHeight-3
							$InputStyle = -1
							$InputExStyle = -1
							$TabControl[_GUICtrlTabGetItemCount($Tabs)][$TabControlCount] = GUICtrlCreateInput($InputText,$InputLeft,$InputTop,$InputWidth,$InputHeight,$InputStyle,$InputExStyle)
							$TabControlType[_GUICtrlTabGetItemCount($Tabs)][$TabControlCount] = "INPUT"
							;MsgBox(0,"",_GUICtrlTabGetItemCount($Tabs) & " : " & $x_2 & @LF & GUICtrlRead($TabControl[_GUICtrlTabGetItemCount($Tabs)][$x_2]))
							GUICtrlSetFont (-1,$fontSize, $fontWeight, -1, $font)
							GUICtrlSetTip(-1,_GUICtrlTabGetItemCount($Tabs)-1 & " : " & $TabControlCount)
							$LeftStart = $InputLeft + $InputWidth
						Else
							;description
							$LabelText = $ParsedNode[$x_4]
							$LabelLeft = $LeftStart
							$LabelTop = $Tab_top+($RowHeight*$x_2)+5
							$LabelWidth = StringLen($LabelText)*$LabelChrWidth
							$LabelHeight = $RowHeight
							$LabelStyle = -1
							$LabelExStyle = -1	
							If $LabelLeft+$LabelWidth > $Tab_width Then $LabelLeft = $Tab_width - ($LabelWidth + 5)
							$TabControl[_GUICtrlTabGetItemCount($Tabs)][$TabControlCount] = GUICtrlCreateLabel($LabelText,$LabelLeft,$LabelTop,$LabelWidth,$LabelHeight,$LabelStyle,$LabelExStyle)
							$TabControlType[_GUICtrlTabGetItemCount($Tabs)][$TabControlCount] = ""
							;MsgBox(0,"",_GUICtrlTabGetItemCount($Tabs) & " : " & $x_2 & @LF & GUICtrlRead($TabControl[_GUICtrlTabGetItemCount($Tabs)][$x_2]))
							GUICtrlSetFont (-1,$fontSize, $fontWeight, -1, $font)
							GUICtrlSetTip(-1,_GUICtrlTabGetItemCount($Tabs)-1 & " : " & $TabControlCount)
							$LeftStart = $LabelLeft + $LabelWidth
						EndIf
						$TabControlCount = $TabControlCount + 1
					Next		
					$x_2 = $x_2 + 1
					$x_1 = $x_1 + 1
				WEnd
				If StringInStr($channel_array[$x_1],"</package>") > 0 Then
					$package[_GUICtrlTabGetItemCount($Tabs)][$x_2] = $channel_array[$x_1]
					$update_width = 75
					$update_left = (($Tab_width-4)/4) + (($Tab_width-4)/2) - ($update_width / 2)
					$update_top = $Tab_top+($RowHeight*($Number_of_Rows+1))+$Border_spacing
					$update_height = 20
					$update_style = -1
					$update_exStyle = -1
					$update_button[_GUICtrlTabGetItemCount($Tabs)-1] = GUICtrlCreateButton("Update",$update_left,$update_top,$update_width,$update_height,$update_style,$update_exStyle)
					$copy_left = (($Tab_width-4)/2) - (($Tab_width-4)/4) - ($update_width/2)
					$copy_button[_GUICtrlTabGetItemCount($Tabs)-1] = GUICtrlCreateButton("Copy",$copy_left,$update_top,$update_width,$update_height,$update_style,$update_exStyle)
					$delete_left = (($Tab_width-4)/2) - ($update_width/2)
					$delete_button[_GUICtrlTabGetItemCount($Tabs)-1] = GUICtrlCreateButton("Delete",$delete_left,$update_top,$update_width,$update_height,$update_style,$update_exStyle)

					$package[_GUICtrlTabGetItemCount($Tabs)][$x_2] = $channel_array[$x_1]
					$package[_GUICtrlTabGetItemCount($Tabs)][0] = $x_2
					$TabControl[_GUICtrlTabGetItemCount($Tabs)][$TabControlCount] = GUICtrlCreateLabel($channel_array[$x_1],0,-20,-1,-1,-1,-1)
					$TabControlType[_GUICtrlTabGetItemCount($Tabs)][$TabControlCount] = ""
					GUICtrlSetState($TabControl[_GUICtrlTabGetItemCount($Tabs)][$TabControlCount],$GUI_DISABLE+$GUI_HIDE)
					$x_2 = $x_2 + 1
					$TabControlCount = $TabControlCount + 1
				EndIf
			EndIf
			
			$package[_GUICtrlTabGetCurSel($Tabs)][0] = $x_2
			$x_3 = $x_3 + 1
			$x_1 = $x_1 + 1
			
			$TabControl[_GUICtrlTabGetItemCount($Tabs)][0] = $TabControlCount
		WEnd
	EndIf
EndFunc

Func ParseNode($NodeName)
	$Node_Part = StringSplit($NodeName,chr(34))
	$msg = ""
	For $x_4 = 1 To UBound($Node_Part)-1
		If StringIsInt($x_4/2) Then
			$Node_Part[$x_4] = 	chr(34) & $Node_Part[$x_4] & chr(34)
		EndIf
	Next
	Return $Node_Part
EndFunc


Func Create_SaveFileArray()
	Dim $SaveFileArray[1000]
	$SaveFileArray[1] = $packages_information
	$x_1 = 1
	$x_3 = 2
	While $x_1 < _GUICtrlTabGetItemCount($Tabs) + 1
		;MsgBox(0,"",$TabName[$x_1])
		If $TabName[$x_1] <> "DELETED" Then
			$x_2 = 1
			While $x_2 < $TabControl[$x_1][0]
				If StringInStr(GUICtrlRead($TabControl[$x_1][$x_2]),">") > 0 Then
					$SaveFileArray[$x_3] = $SaveFileArray[$x_3] & GUICtrlRead($TabControl[$x_1][$x_2])
					$x_3 = $x_3 + 1
				Else
					If $TabControlType[$x_1][$x_2] = "INPUT" Then
						$SaveFileArray[$x_3] = $SaveFileArray[$x_3] & chr(34) & GUICtrlRead($TabControl[$x_1][$x_2]) & chr(34)
					Else
						$SaveFileArray[$x_3] = $SaveFileArray[$x_3] & GUICtrlRead($TabControl[$x_1][$x_2])
					EndIf			
				EndIf
				$x_2 = $x_2 + 1
			WEnd
		EndIf
		$x_1 = $x_1 + 1
	WEnd
	$SaveFileArray[$x_3] = "</packages>"
	$SaveFileArray[0] = $x_3
	
	$filePath = @ScriptDir
	$FileName = "channel.txt"
	
	$mode = 2
	SaveFile($filePath,$FileName,$mode,$SaveFileArray)
EndFunc

Terminate()


Func Display($AppName)
	$Display_left = -1
	$Display_top = -1
	$Display_style = -1
	$Display_exStyle = -1
	$display = GUICreate($AppName,$Display_width,$Display_height,$Display_left,$Display_top,$Display_style,$Display_exStyle)
	;GUISetFont(9, 400, -1, $font)
	$cancel_width = $Button_width 
	$cancel_left = ($Display_width/4) + ($Display_width/2) - ($cancel_width/2)
	$cancel_height = $Button_height
	$cancel_top = $Display_height - $Border_spacing - $cancel_height - $Menu_height
	$cancel_style = -1
	$cancel_exStyle = -1
	$cancel_Button = GUICtrlCreateButton("&Cancel",$cancel_left,$cancel_top,$cancel_width,$cancel_height,$cancel_style,$cancel_exStyle)
	
	$save_width = $Button_width 
	$save_left = ($Display_width/2) - ($Display_width/4) - ($save_width/2)
	$save_height = $Button_height
	$save_top = $Display_height - $Border_spacing - $save_height - $Menu_height
	$save_style = -1
	$save_exStyle = -1
	$save_Button = GUICtrlCreateButton("&Save",$save_left,$save_top,$save_width,$save_height,$save_style,$save_exStyle)
	GUICtrlSetState($save_Button,$GUI_DISABLE)

	$new_width = $Button_width 
	$new_left = ($Display_width/2) - ($new_width/2)
	$new_height = $Button_height
	$new_top = $Display_height - $Border_spacing - $new_height - $Menu_height
	$new_style = -1
	$new_exStyle = -1
	$new_Button = GUICtrlCreateButton("&New",$new_left,$new_top,$new_width,$new_height,$new_style,$new_exStyle)
	GUICtrlSetState($new_Button,$GUI_DISABLE)
	
	$filemenu = GUICtrlCreateMenu("&File")
		$fileitem = GUICtrlCreateMenuitem ("&Open",$filemenu)
		$saveitem = GUICtrlCreateMenuitem ("&Save",$filemenu)
		GUICtrlSetState($saveitem,$GUI_DISABLE)
		$exititem = GUICtrlCreateMenuitem ("&Exit",$filemenu)
	$helpmenu = GUICtrlCreateMenu ("&Help")
		$infoitem = GUICtrlCreateMenuitem ("&Info",$helpmenu)

	GUISetState(@SW_SHOW,$display)
EndFunc

Func Terminate()
	Exit
EndFunc

Func OpenFile($FileName)
	Dim $OpenFileArray[9999]
	
	If $FileName = "" Then
		$FilePath = @ScriptDir
		$FileName = StringMid(@ScriptName,1,stringlen(@ScriptName) - 3) & "ini"
	EndIf
	
	
	$file = FileOpen($FileName, 0)
	; Check if file opened for reading OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf

	; Read in lines of text until the EOF is reached
	$x_1 = 0
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		$OpenFileArray[$x_1] = $line
		$x_1 = $x_1 + 1
	Wend
	ReDim $OpenFileArray[$x_1]
	;$OpenFileArray[0] = $x_1
	FileClose($file)
	Return $OpenFileArray
EndFunc

Func SaveFile($filePath,$FileName,$FileWriteMode,$SaveFileArray)
	$file = FileOpen($FilePath & "\" & $FileName,$FileWriteMode)
	#comments-start
		$mode
		0 = Read mode
		1 = Write mode (append to end of file)
		2 = Write mode (erase previous contents)
		4 = Read raw mode
		8 = Create directory structure if it doesn't exist
	#comments-end
		; Check if file opened for writing OK
		If $file = -1 Then
			MsgBox(0, "Error", "Unable to open file.")
			Exit
		EndIf
		$x_1 = 1
		While $x_1 <= $SaveFileArray[0]
			FileWriteLine($file, $SaveFileArray[$x_1])
			$x_1 = $x_1 + 1
		WEnd
	FileClose($file)
EndFunc
	
Func RichTextBox($msg,$RICHTEXTBox_Left,$RICHTEXTBox_Top,$RICHTEXTBox_Width,$RICHTEXTBox_Height,$count)
	Dim $GUIActiveX[100]
	$GUIActiveX[$count] = GUICtrlCreateObj($oRP,$RICHTEXTBox_Left,$RICHTEXTBox_Top,$RICHTEXTBox_Width,$RICHTEXTBox_Height)
	GUICtrlSetPos($GUIActiveX[$count],$RICHTEXTBox_Left,$RICHTEXTBox_Top,$RICHTEXTBox_Width,$RICHTEXTBox_Height)
	With $oRP; Object tag pool
		.OLEDrag()
		.Font = 'Arial'
		.text = $msg
	EndWith
EndFunc