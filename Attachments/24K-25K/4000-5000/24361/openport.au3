#include <IE.au3>
#include <GUIConstants.au3>
Opt("TrayIconDebug", 1)	

	
;~ #include <WindowsConstants.au3>
;~ #include <Constants.au3>
;~ #include <GuiConstantsEx.au3>
;~ #include <EditConstants.au3>
;~ #include <StaticConstants.au3>
;~ #include <Misc.au3>
;~ #include <Process.au3>

Global $PortFileName = @ScriptDir & "\PortFileName.txt"
Global $title ="PortTracker v0.1"
Global $portfile


if FileExists($PortFileName) = 0 OR MsgBox(260, $title, "Do you like refresh porttype file from internet?") = 6 Then
;~ 	MsgBox(0,"","ACUMBA!")
;~ ElseIf  Then
	if _refresh() = 0 Then
		MsgBox(0,$title, "No update")
	Else
		MsgBox(0,$title, "Updated")
	EndIf
	
EndIf

TrayTip($title, "Load network data",5)
Global $PROGRAM = _loadProgram($PortFileName)
$data = _getPort()
$dataold = $data
TrayTip("", "",5)
_GUI($data)

Exit


;~ While 1
;~ 	Sleep(20000)
;~ 	$data = _getPort()
;~ 	$return = StringSplit($data, @CRLF)
;~ 	$returnOld = StringSplit($dataold, @CRLF)
;~ 	
;~ 	$new = ""
;~ 	for $k =1 to $return[0]
;~ 		
;~ 		if StringInStr($dataold, $return[$k]) = 0 Then
;~ 			$new &= @CRLF & $return[$k]
;~ 		EndIf
;~ 	Next
;~ 	
;~ 	
;~ 	$down = ""
;~ 	for $p =1 to $returnOld[0]
;~ 		
;~ 		if StringInStr($data, $returnOld[$p]) = 0 Then
;~ 			$down &= @CRLF & $returnOld[$p]
;~ 		EndIf
;~ 	Next
;~ 	
;~ 	if $new <> "" Then
;~ 		MsgBox(0,"",$new)
;~ 	EndIf
;~ 	
;~ 	if $down <> "" Then
;~ 		MsgBox(0,"",$down)
;~ 	EndIf
;~ 	
;~ WEnd

Exit



Func _getPort()
	$tComSpeacfile = @TempDir & "\" & TimerInit() & ".fdsf"
	RunWait(@ComSpec & " /c """ & @ScriptDir & "\tcpvcon.exe"" -c > " & $tComSpeacfile , @ScriptDir, @SW_HIDE)

	$return = FileRead($tComSpeacfile)

	FileDelete($tComSpeacfile)

;~ 	Dim $returnProcessNet[1][6]
;~ 	$returnProcessNet[0][0] = 0

;~ 	MsgBox(0,"",$return)
;~ 	ClipPut($return)
	
	Return $return
EndFunc

Func _getProgramDescription($port, $type)
	For $i=1 to $PROGRAM[0][0]
		if $port = $PROGRAM[$i][0] AND StringInStr($PROGRAM[$i][1], $type) > 0 Then
			Return $PROGRAM[$i][2]
		EndIf
	Next
	
	Return $port & " (" & $type & ")"
EndFunc

Func _loadProgram($sourceFile)
	Dim $arraytemp[1][3]
	$arraytemp[0][0] = 0
	
	
	$file = FileOpen($sourceFile, 0)

	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		$tempD = StringSplit($line, "~")
		$arraytemp[0][0] += 1
		ReDim $arraytemp[$arraytemp[0][0]+1][3]
		$arraytemp[$arraytemp[0][0]][0] = $tempD[1]
		$arraytemp[$arraytemp[0][0]][1] = $tempD[2]
		$arraytemp[$arraytemp[0][0]][2] = $tempD[3]
	Wend

	FileClose($file)

	Return $arraytemp
EndFunc

Func _gui($process)
;~ 	$portfile

	#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate($title, 893, 562, 129, 125)
	$ListView1 = GUICtrlCreateListView("Process name|Process Pid|Local address|Remote address|Protocoll|Source|Destination", 10, 10, 871, 511)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	$return = StringSplit($process, @CRLF)
	$proc = StringSplit($portfile, @CRLF)
	
	
		
		
;~ 	MsgBox(0,$return[0],$return[1])
	for $i = 1 to $return[0]
		$tRet = StringSplit($return[$i], ",")
		
		if $tRet[0] > 5 Then
			$porsor = StringSplit($tRet[5],":")
			$pordes = StringSplit($tRet[6],":")
		
		
			for $j = 1 to $proc[0]
				$tPro = StringSplit($proc[$j], "~")
				if $tPro[0] > 1 Then
					if $tPro[1] = $tRet[1] AND $tPro[1] = $pordes[2] Then
						$sorDesc = $tPro[4]
					EndIf
					
					if $tPro[1] = $porsor[2] Then
						
					EndIf
				EndIf
			Next
			$tport = StringSplit($tRet[5], ":")
			$portLocal = $tport[2]
			$tport = StringSplit($tRet[6], ":")
			$portRemote = $tport[2]
			$item1 = GUICtrlCreateListViewItem($tRet[2] & "|" & $tRet[3] & "|" & $tRet[5] & "|" & $tRet[6] & "|" & $tRet[1] & "|" & _getProgramDescription($portLocal,$tRet[1]) & "|" & _getProgramDescription($portRemote,$tRet[1]), $listview1)
		EndIf
	Next
;~ 	$item1 = GUICtrlCreateListViewItem("item2|col22|col23", $listview)
	
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
;~ 			Case $ListView1
;~ 				MsgBox(0,"",GUICtrlRead($ListView1))
				Case $GUI_EVENT_CLOSE
					GUIDelete($Form1)
				ExitLoop

		EndSwitch
	WEnd

	
EndFunc
 
Func _refresh()
	$oie =_IECreate("http://en.wikipedia.org/wiki/Port_number", 0,0)
	$portSour = _IEBodyReadText($oie)
	_IEQuit($oie)
	
	$portfilet = ""
	$PorArS = StringSplit($portSour, @CRLF)
	for $i = 1 to $PorArS[0]
		if (StringInStr($PorArS[$i], "TCP") > 0 OR StringInStr($PorArS[$i], "UDP") > 0) AND StringInStr($PorArS[$i], "/") > 0 AND (StringInStr($PorArS[$i], "Unofficial") > 0 OR StringInStr($PorArS[$i], "Official")) Then
	;~ 		MsgBox(0,"",$PorArS[$i])
			$temp = StringSplit($PorArS[$i], "/")
			$port = $temp[1]
			if StringMid($temp[2], 4,1) = "," Then
				$protocol = "TCP,UDP"
			ElseIf StringMid($temp[2], 1,3) = "TCP" Then
				$protocol = "TCP"
			ElseIf StringMid($temp[2], 1,3) = "TCP" Then
				$protocol = "UDP"
			EndIf
			
			if StringInStr($temp[2], "Unofficial",1) > 0 Then
				$type = "Unofficial"
			Elseif StringInStr($temp[2], "Official",1) > 0 Then
				$type = "Official"
			EndIf
			
			$description = StringMid($temp[2], StringLen($protocol)+1, StringLen($temp[2]) - StringLen($protocol) - StringLen($type))
	;~ 		MsgBox(0,"",$port & @CRLF & $protocol & @CRLF & $description & @CRLF & $type)
			$portfilet &= $port & "~" & $protocol & "~" & $description & "~" & $type & @CRLF
		EndIf
	Next
	
	if $portfilet <> FileRead($PortFileName) Then
		$portfile = $portfilet
		$fh = FileOpen($PortFileName, 2)
		FileWrite($fh, $portfile)
		FileClose($fh)
		Return 1
	Else
		Return 0
	EndIf

EndFunc