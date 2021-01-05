#include <Array.au3>
#include <GuiConstants.au3>
#include <GUIListView.au3>

GuiCreate("Downloader", 720, 553,(@DesktopWidth-720)/2, (@DesktopHeight-553)/2)

$Group_2 = GuiCtrlCreateGroup("Destination Folder", 10, 460, 700, 80)
$Current_Directory_Radio = GuiCtrlCreateRadio("Current Directory", 20, 480, 300, 20)
GUICtrlSetState(-1,$GUI_CHECKED)
$Custom_Folder_Radio = GuiCtrlCreateRadio("Custom Folder", 20, 510, 120, 20)
$Custom_Folder_Combo = GUICtrlCreateCombo(@ScriptDir, 140, 505, 450, 25)
GuiCtrlSetState(-1,$GUI_DISABLE)
$Browse_Button = GuiCtrlCreateButton("Browse", 610, 505, 90, 25)
GUICtrlSetState(-1,$GUI_DISABLE)
$Group_1 = GuiCtrlCreateGroup("Filter", 10, 410, 700, 50)
$Radio_7 = GuiCtrlCreateRadio("Show All", 20, 430, 80, 20)
GUICtrlSetState(-1,$GUI_CHECKED)
$Radio_8 = GuiCtrlCreateRadio("Show Images", 130, 430, 130, 20)
$Radio_9 = GuiCtrlCreateRadio("Show Movies", 260, 430, 120, 20)
$Radio_10 = GuiCtrlCreateRadio("Custom Filter:", 390, 430, 100, 20)
$Download_Button = GuiCtrlCreateButton("Download Now", 520, 385, 190, 25)
$Select_Deselect_Checkbox = GuiCtrlCreateCheckbox("Select/Deselect All", 10, 380, 190, 30)
$ListView = GUICtrlCreateListView("DL?(ext)|URL|TYPE", 10, 10, 700, 370,$LVS_REPORT,$LVS_EX_FULLROWSELECT + $LVS_EX_CHECKBOXES + $LVS_EX_GRIDLINES)
$label = GUICtrlCreateLabel("Prefix",500,480,70,25)
$input_prefix = GUICtrlCreateInput("",550,475,150,25)
$custom_input = GUICtrlCreateInput("jpg|jpeg|mpg|mpeg|pdf",500,425,200,25)
$cancel_button = GUICtrlCreateButton("Cancel",410,385,90,25)
$updown_label = GUICtrlCreateLabel("Max Simultaneous DLs",200,390,145,25)
$updown_input = GUICtrlCreateInput("2", 350, 385, 40, 25)
$updown = GUICtrlCreateUpdown($updown_input)

$msg_old = $Radio_7				; Initially, download function will show all

HotKeySet("^x", "Terminate") ;CONTROL-x
HotKeySet("^d", "Download") ;CONTROL-d
$prefix = ""
;;;; Body of program would go here ;;;;
While 1
    Sleep(100)
WEnd
;;;;;;;;

Func Terminate()
    Exit
EndFunc

Func Download()
	
	$title = WinGetTitle("")

	$s_URL = ControlGetText ($title, "", "Edit1" )
	If @error Then
		MsgBox(4096,"Downloader","Error: Internet Explorer Browser Not Found!")
		Return
	ElseIf Not (StringLeft($s_URL, 7) = 'http://') AND Not (StringLeft($s_URL, 8) = 'https://') Then
		MsgBox(4096,"Downloader","Error: Not a valid web site")
		Return
	EndIf
	
	Local $s_temp = '', $v_HTTP, $s_HTTP

	;object
	$v_HTTP = ObjCreate ("winhttp.winhttprequest.5.1")
	
	;on com error set to @error to 1
	If @error Then
		SetError(1)
		return 0
	EndIf
	
	;send the request
	$v_HTTP.open ("GET", $s_URL)
	$v_HTTP.send ()
	
	;return the response
	$v_HTTP = $v_HTTP.Responsetext

;	return $v_HTTP

	;regexp it
	$v_HTTP = StringRegExp($v_HTTP, '(?i)<a(.*?)>', 3)
	
	If Not IsArray($v_HTTP) Then
		MsgBox(4096,"Downloader","Error: No hyperlinks found!")
		return 0
	EndIf
	
	;loop and add for each find
	For $i = 0 to UBound($v_HTTP) - 1
		
		;regexp it again
		$s_HTTP = StringRegExp($v_HTTP[$i], '(?i)href="(.*?)"', 3)
		
		;check if matched
		If @extended <> 1 Then ContinueLoop
		
		;add
		$s_temp &= $s_HTTP[0] & '|{)*&%'
		
	Next
	
	;make an array from the temp
	$v_HTTP = StringSplit(StringTrimRight($s_temp, StringLen('|{)*&%')), '|{)*&%', 1)
	
	;get the url and alter it so we can use it as a prefix location
	$s_URL = StringLeft($s_URL, StringInStr($s_URL, '/', 0, -1)-1)
	
	;loop till all is prefix'd
	For $i = 1 To $v_HTTP[0]
		
		;if external do nothing
		If StringLeft($v_HTTP[$i], 7) = 'http://' OR StringLeft($v_HTTP[$i], 8) = 'https://' Then ContinueLoop
		
		;if respective of the location add a '/' if not yet present
		If StringLeft($v_HTTP[$i], 1) <> '/' Then $v_HTTP[$i] = '/' & $v_HTTP[$i]
			
		;add the prefix
		$v_HTTP[$i] = $s_URL & $v_HTTP[$i]
		
	Next
	
	;if no images are found set @error to 2
	If $v_HTTP[1] = $s_URL & '/' Then
		SetError(2)
		return 0
	EndIf
	
	GUISetState(@SW_SHOW)

	ControlClick("Downloader","",$msg_old)

	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE
			_GUICtrlListViewDeleteAllItems($ListView)
			GUICtrlSetData($input_prefix,"")
			GUICtrlSetData($Custom_Folder_Combo,@ScriptDir)
			If GUICtrlRead($Radio_7) == $GUI_CHECKED Then
				$msg_old = $Radio_7
			ElseIf GUICtrlRead($Radio_8) == $GUI_CHECKED Then
				$msg_old = $Radio_8
			ElseIf GUICtrlRead($Radio_9) == $GUI_CHECKED Then
				$msg_old = $Radio_9
			ElseIf GUICtrlRead($Radio_10) == $GUI_CHECKED Then
				$msg_old = $Radio_10
			Else
				MsgBox(0,"Testing","Error: GUI_EVENT_CLOSE")
			EndIf
			GUICtrlSetData($Custom_Folder_Combo,@ScriptDir,@ScriptDir)
			ExitLoop
		Case $msg = $cancel_button
			_GUICtrlListViewDeleteAllItems($ListView)
			GUICtrlSetData($input_prefix,"")
			GUICtrlSetData($Custom_Folder_Combo,@ScriptDir)
			If GUICtrlRead($Radio_7) == $GUI_CHECKED Then
				$msg_old = $Radio_7
			ElseIf GUICtrlRead($Radio_8) == $GUI_CHECKED Then
				$msg_old = $Radio_8
			ElseIf GUICtrlRead($Radio_9) == $GUI_CHECKED Then
				$msg_old = $Radio_9
			ElseIf GUICtrlRead($Radio_10) == $GUI_CHECKED Then
				$msg_old = $Radio_10
			Else
				MsgBox(0,"Testing","Error: CANCEL")
			EndIf
			GUICtrlSetData($Custom_Folder_Combo,@ScriptDir,@ScriptDir)
			ExitLoop			
		Case $msg = $Select_Deselect_Checkbox
			$checked = GUICtrlRead($Select_Deselect_Checkbox)
				If $checked == $GUI_UNCHECKED Then
					For $i = 0 To $v_HTTP[0] - 1
						_GUICtrlListViewSetCheckState($ListView, $i, 0)
					Next
				Else
					For $i = 0 To $v_HTTP[0] - 1
						_GUICtrlListViewSetCheckState($ListView, $i, 1)
					Next
				EndIf			
		Case $msg = $Radio_8					;; Show images only
			_GUICtrlListViewDeleteAllItems($ListView)
			$count = 0
			For $i = 1 To $v_HTTP[0]
				$right = StringRight($v_HTTP[$i],4)
				Select
					Case $right = ".jpg"
						$text = "JPG"
						$type = "Picture"
						GUICtrlCreateListViewItem($text & "|" & $v_HTTP[$i] & "|" & $type,$ListView)
						$count += 1
					Case $right = "jpeg"
						$text = "JPEG"
						$type = "Picture"
						GUICtrlCreateListViewItem($text & "|" & $v_HTTP[$i] & "|" & $type,$ListView)
						$count += 1
					Case $right = ".bmp"
						$text = "BMP"
						$type = "Picture"
						GUICtrlCreateListViewItem($text & "|" & $v_HTTP[$i] & "|" & $type,$ListView)
						$count += 1
					Case Else
						; Do nothing
				EndSelect
			Next
			For $i = 0 To $v_HTTP[0] - 1
				_GUICtrlListViewSetCheckState($ListView, $i, 1)
			Next
			GUICtrlSetState($Select_Deselect_Checkbox,$GUI_CHECKED)
		Case $msg = $Radio_7					;; Show all
			_GUICtrlListViewDeleteAllItems($ListView)
			$count = 0
			For $i = 1 To $v_HTTP[0]
				$right = StringRight($v_HTTP[$i],4)
				Select
					Case $right = ".jpg"
						$text = "JPG"
						$type = "Picture"
					Case $right = "jpeg"
						$text = "JPEG"
						$type = "Picture"
					Case $right = ".bmp"
						$text = "BMP"
						$type = "Picture"
					Case $right = ".mpg"
						$text = "MPG"
						$type = "Movie"
					Case $right = "mpeg"
						$text = "MPEG"
						$type = "Movie"
					Case $right = ".wmv"
						$text = "WMV"
						$type = "Movie"
					Case $right = ".mp3"
						$text = "MP3"
						$type = "Audio"
					Case $right = "html"
						$text = "HTML"
						$type = "HTML Document"
					Case $right = ".htm"
						$text = "HTML"
						$type = "HTML Document"
					Case Else
						$text = "???"
						$type = "???"
				EndSelect
				GUICtrlCreateListViewItem($text & "|" & $v_HTTP[$i] & "|" & $type,$ListView)
				$count += 1
			Next
			For $i = 0 To $v_HTTP[0] - 1
				_GUICtrlListViewSetCheckState($ListView, $i, 1)
			Next
			GUICtrlSetState($Select_Deselect_Checkbox,$GUI_CHECKED)
		Case $msg = $Radio_9					;; Show movies only
			_GUICtrlListViewDeleteAllItems($ListView)
			$count = 0
			For $i = 1 To $v_HTTP[0]
			$right = StringRight($v_HTTP[$i],4)
			Select
				Case $right = ".mpg"
					$text = "MPG"
					$type = "Movie"
					GUICtrlCreateListViewItem($text & "|" & $v_HTTP[$i] & "|" & $type,$ListView)
					$count += 1
				Case $right = "mpeg"
					$text = "MPEG"
					$type = "Movie"
					GUICtrlCreateListViewItem($text & "|" & $v_HTTP[$i] & "|" & $type,$ListView)
					$count += 1
				Case $right = ".wmv"
					$text = "WMV"
					$type = "Movie"
					GUICtrlCreateListViewItem($text & "|" & $v_HTTP[$i] & "|" & $type,$ListView)
					$count += 1
				Case Else
					; Do nothing
			EndSelect
			Next
			For $i = 0 To $v_HTTP[0] - 1
				_GUICtrlListViewSetCheckState($ListView, $i, 1)
			Next
			GUICtrlSetState($Select_Deselect_Checkbox,$GUI_CHECKED)
		Case $msg = $Radio_10					;; Custom only
			$input = GUICtrlRead($custom_input)
			If StringIsSpace($input) OR $input = "" Then
				ContinueLoop
			Else
				$split_string = StringSplit($input,"|")
				_GUICtrlListViewDeleteAllItems($ListView)
				$count = 0
				
				For $i = 1 To $v_HTTP[0]
					$right = StringRight($v_HTTP[$i],4)
					For $j = 1 To $split_string[0]
						If $right = StringRight($split_string[$j],4) Or $right = "." & StringRight($split_string[$j],3) Then
							Select
								Case $right = ".mpg"
									$type = "Movie"
								Case $right = "mpeg"
									$type = "Movie"
								Case $right = ".jpg"
									$type = "Picture"
								Case $right = "jpeg"
									$type = "Picture"
								Case $right = ".bmp"
									$type = "Picture"
								Case $right = ".wmv"
									$type = "Movie"
								Case $right = ".pdf"
									$type = "Adobe Acrobat Document"
								Case $right = ".doc"
									$type = "Microsoft Word Document"
								Case $right = "html"
									$type = "HTML Document"
								Case $right = ".htm"
									$type = "HTML Document"
								Case Else
									$type = "???"
							EndSelect
							$text = StringUpper($split_string[$j])
							GUICtrlCreateListViewItem($text & "|" & $v_HTTP[$i] & "|" & $type,$ListView)
							$count += 1
						EndIf
					Next
				Next
				For $i = 0 To $count - 1
					_GUICtrlListViewSetCheckState($ListView, $i, 1)
				Next
				GUICtrlSetState($Select_Deselect_Checkbox,$GUI_CHECKED)
			EndIf
		Case $msg = $Current_Directory_Radio
			GUICtrlSetState($Custom_Folder_Combo,$GUI_DISABLE)
			GUICtrlSetState($Browse_Button,$GUI_DISABLE)			
		Case $msg = $Custom_Folder_Radio
			GUICtrlSetState($Custom_Folder_Combo,$GUI_ENABLE)
			GUICtrlSetState($Browse_Button,$GUI_ENABLE)
		Case $msg = $Browse_Button
			$selected = FileSelectFolder("Select Destination Folder","")
			If $selected = "" OR @error Then
				ContinueLoop
			EndIf
			GUICtrlSetData($Custom_Folder_Combo,$selected,$selected)
		Case $msg = $Download_Button
			$prefix = GUICtrlRead($input_prefix)
			If $prefix = "" OR StringIsSpace($prefix) Then
				$prefix = -1
			EndIf
			$checked = GUICtrlRead($Custom_Folder_Radio)
			If $checked == $GUI_UNCHECKED Then
				$dir = ""
			Else
				$read = GUICtrlRead($Custom_Folder_Combo)
				If StringIsSpace($read) OR $read == "" Then
					MsgBox(4096,"Downloader","Error: Please enter or select destination directory!")
					ContinueLoop
				Else
					If StringRight($read,1) == "\" Then
						$read = StringTrimRight($read,1)
					EndIf
					$dir = '"' & $read & '"'
				EndIf
			EndIf
			
			$udinput = GUICtrlRead($updown_input)
			If StringIsSpace($udinput) OR $udinput == "" OR Not StringIsAlNum($udinput) Then
				MsgBox(4096,"Downloader","Error: Please enter a number in for maximum simultaneous downloads!")
				ContinueLoop
			EndIf
			
			$subcounter = 0
			$download_string = ""
			For $i = 0 To $count - 1
				If _GUICtrlListViewGetCheckedState($ListView, $i) Then
					If $subcounter = 0 Then
						$download_string = _GUICtrlListViewGetItemText($ListView,$i,1)
						$subcounter += 1
					Else
						$download_string = $download_string & "|" & _GUICtrlListViewGetItemText($ListView,$i,1)
					EndIf
				EndIf
			Next
			
			$listview_split = StringSplit($download_string,"|")

			Dim $ProcArray[$udinput]
			$subcounter = 0
			
			For $i = 1 To $listview_split[0]
				If $subcounter < $udinput Then
					$ProcArray[$subcounter] = Run('download.exe ' & $listview_split[$i] & " " & $prefix & " " & $dir, "", @SW_HIDE)
					$subcounter += 1
				Else
					While 1
						For $j = 0 To $udinput - 1
							If ProcessExists($ProcArray[$j]) == 0 Then
								$ProcArray[$j] = Run('download.exe ' & $listview_split[$i] & " " & $prefix & " " & $dir, "", @SW_HIDE)
								ExitLoop 2
							EndIf
						Next
						Sleep(100)
					WEnd
				EndIf
			Next
			_GUICtrlListViewDeleteAllItems($ListView)
			ExitLoop
		Case Else
			;;;
		EndSelect
	WEnd
	GUISetState(@SW_HIDE)
EndFunc