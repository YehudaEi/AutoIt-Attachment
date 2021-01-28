;#NoTrayIcon
$full_text=""
$summ_time=""
$crlf=@crlf
$DesktopWidth=@DesktopWidth
$DesktopHeight=@DesktopHeight
If $CmdLine[0] > 0 Then
	$begin=TimerInit()
	For $i=1 to $CmdLine[0]
		If FileExists($CmdLine[$i]) Then $full_text&=Generating($CmdLine[$i])
	Next
	Clipput($full_text)
Else
	While 1
		$file = FileOpenDialog("Choose File of registry", "", "Registry Files (*.reg)",7)
		If @error Then Exit
		If $file <> "" Then ExitLoop
	WEnd
	$begin=TimerInit()

	$arr_files=StringSplit($file,"|",1)
	If $arr_files[0]>1 Then
		For $i=2 to $arr_files[0]
			$full_text&=Generating($arr_files[1] & "\" & $arr_files[$i])
		Next
	Else
		$full_text=Generating($file)
	EndIf
	
	ClipPut($full_text)
EndIf
;MsgBox(0,"",TimerDiff($begin))
;MsgBox(0,"",$summ_time)

Func Generating($file)
	$arr_reg = StringSplit(FileRead($file), $crlf, 1)
	$text = ""
	$filename=StringRegExpReplace($file,".+\\","")
	If StringInStr($arr_reg[1], "Windows Registry Editor Version") = 0 Then
		MsgBox(16, "Error","File: " & $filename & $crlf & "This type not supported!")
		Exit
	EndIf
	$timer=TimerInit()
	For $i = 2 To $arr_reg[0]
		$t_reg_path = StringRegExp($arr_reg[$i], "\A\h*\[(.+)\]\h*\Z", 1)
		If Not @error Then
			$reg_path = StringReplace($t_reg_path[0], '"', '""')
			ContinueLoop
		EndIf
		$value = StringRegExp($arr_reg[$i], '\h*"(.+?)"\h*=\h*(.+)\h*', 3)
		If @error Then
			$value = StringRegExp($arr_reg[$i], '\h*(@)\h*=\h*(.+)\h*', 3)
			If @error Then ContinueLoop
			$value[0]=""
		Endif

		$value[0] = StringReplace($value[0], '\"', '""')
		$value[1] = StringRegExpReplace($value[1], "\\\Z", "")
		$extended = @extended
		$w_value = StringRegExp($value[1], '\A"(.*)"', 1)
		If Not @error Then
			$type = "REG_SZ"
			$w_value = $w_value[0]
		Else
			$w_value = StringRegExp($value[1], "(.+):(.*)", 3)
			If @error Then ContinueLoop

			Switch $w_value[0]
				Case "dword"
					$type = "REG_DWORD"
				Case "hex"
					$type = "REG_BINARY"
				Case "hex(7)"
					$type = "REG_MULTI_SZ"
				Case "hex(2)"
					$type = "REG_EXPAND_SZ"
				Case Else
					ContinueLoop
			EndSwitch
			$w_value=$w_value[1]
		EndIf

		If $extended > 0 Then
			$i += 1
			While 1
				$t_value = StringRegExp($arr_reg[$i], "\h*(.+)\h*", 1)
				$t_value = StringRegExpReplace($t_value[0], "\\\Z", "")
				$extended = @extended
				$w_value &= $t_value
				If $extended = 0 Then ExitLoop
				$i += 1
			WEnd
		EndIf		

		Switch $type
			Case "REG_SZ"
				$w_value = '"' & StringReplace($w_value, '\"', '""') & '"'
			Case "REG_DWORD"
				$w_value='"0x' & $w_value & '"'
			Case "REG_BINARY"
				If $w_value="" Then
					$w_value='""'
				Else
					$w_value = '"0x' & StringReplace($w_value, ",", "") & '"'
				Endif
			Case "REG_MULTI_SZ"
				$w_value = StringRegExpReplace(StringReplace($w_value, ",", ""), "00000000\Z", "")
				If $w_value="0000" OR $w_value="" Then
					$w_value='""'
				Else
					$w_value = StringReplace(BinaryToString("0x" & $w_value, 2), '"', '""')
					$o_value = $w_value
					$w_value = '"' & StringReplace($w_value, Chr(0), '" & Chr(10) & "') & '"'
					If StringLeft($o_value, 1) = Chr(0) Then $w_value = StringTrimLeft($w_value, 5)
					If StringRight($o_value, 1) = Chr(0) Then $w_value = StringTrimRight($w_value, 5)
				Endif
			Case "REG_EXPAND_SZ"				
				$w_value = StringRegExpReplace(StringReplace($w_value, ",", ""), "0000\Z", "")				
				$w_value = StringReplace(BinaryToString("0x" & $w_value, 2), '"', '""')
				$w_value = '"' & $w_value & '"'				
		EndSwitch

		$text &= 'RegWrite("' & $reg_path & '", "' & $value[0] & '", "' & $type & '", ' & $w_value & ')' & $crlf
		
		If TimerDiff($timer)>200 Then
			$timer=TimerInit()
			Tooltip("File: " & $filename & $crlf & "RegToAu3: " & Round($i/$arr_reg[0]*100) & "% completed",$DesktopWidth/2,$DesktopHeight-60,"",0,2)
		Endif		
	Next
	return $text
EndFunc   ;==>Generating
