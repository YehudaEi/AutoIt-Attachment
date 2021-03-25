#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <Misc.au3>


Opt("TrayIconDebug", 1)


$title = "CyberDebug 0.04"

Global $Ip = "127.0.0.1"
Global $port = 3333

$inifile = @ScriptDir & "\CyberDebug.ini"

$default = IniRead($inifile,"Data","defaultFile","")
$Ip = IniRead($inifile,"Data","ipaddressDebugServer",$Ip)
$port = IniRead($inifile,"Data","portaddressDebugServer",$port)
$remoteServer = IniRead($inifile,"Data","remoteServer",0)

$file = FileOpenDialog($title,@ScriptDir,"AutoIt File (*.au3)",-1,$default)

if $file = "" Then Exit

IniWrite($inifile,"Data","defaultFile",$file)
IniWrite($inifile,"Data","ipaddressDebugServer",$Ip)
IniWrite($inifile,"Data","portaddressDebugServer",$port)
IniWrite($inifile,"Data","remoteServer",0)

$sourceraw = FileRead($file)
$source = StringSplit($sourceraw,@CRLF,1)


;****************************************************************
$Form1 = GUICreate($title, 1008, 660, 74, 156)
$List1 = GUICtrlCreateListView("Source", 8, 8, 833, 578)
;~ $List2 = GUICtrlCreateListView("Name|Value", 848, 8, 153, 539)
$List2 = GUICtrlCreateEdit("", 848, 8, 153, 539)
$ButtonPause = GUICtrlCreateButton("Pause (F7)", 5, 600, 60, 25)
;~ GUICtrlSetState($ButtonPause,$GUI_HIDE)


$Group1 = GUICtrlCreateGroup("", 256, 588, 585, 44)

$Button1 = GUICtrlCreateButton("Next line (F8)", 64+10, 600, 155, 25)
$Button2 = GUICtrlCreateButton("next #BKPOINT (F9)", 168+100, 600, 155, 25)
$Button3 = GUICtrlCreateButton("go to selected line (F11)", 272+200, 600, 155, 25)
$Button4 = GUICtrlCreateButton("go to line ...", 376+300, 600, 155, 25)

$Button5 = GUICtrlCreateButton("Use large window", 888-25, 552, 75+50, 25)
$Button6 = GUICtrlCreateButton("Set variable value", 888-25, 552+30, 75+50, 25)
$Button7 = GUICtrlCreateButton("Get variable value", 888-25, 552+30+30, 75+50, 25)

$JumpCheck = GUICtrlCreateCheckbox("Fast jump line (can't stop it)", 275+100+100, 635, 155, 25)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



$varlargegui = GUICreate("VarLarge", 939, 698, 168, 126)
$varlarge = GUICtrlCreateEdit("", 8, 8, 921, 681)

GUISetState(@SW_HIDE,$varlargegui)
#EndRegion ### END Koda GUI section ###

Global $VARLARGEMODE=0


;~ #Region ### START Koda GUI section ### Form=
;~ $Form1 = GUICreate("Form1", 890, 676, 175, 112)
;~ $List1 = GUICtrlCreateListView("Source", 8, 8, 873, 617)
;~ $Button1 = GUICtrlCreateButton("Button1", 80, 632, 49, 25)
;~ GUISetState(@SW_SHOW)
;~ #EndRegion ### END Koda GUI section ###
;****************************************************************



_GUICtrlListView_SetColumnWidth($List1, 0, 800)

for $i = 1 to $source[0]
	GUICtrlCreateListViewItem(StringReplace($source[$i],@TAB,"         "), $List1)
Next


$debFile = _makefile($file,$source)

Run(@AutoItExe & " """ & $debFile & """")

if $remoteServer = 1 Then
	exit
EndIf

TCPStartup()
$mainsocket = TCPListen($Ip,$port)

$socket = -1
Do
	$socket = TCPAccept($mainsocket)
	Sleep(10)
Until $socket <> -1
;~ MsgBox(0,$socket,"SEconnesso",1)

While 1
	$data_FLUX = ""
	$ACNKO = 0
	Do
		$data_FLUX &= TCPRecv($socket,10000)
		if StringRight($data_FLUX,1) = "~" Then
			$ACNKO = 1
		EndIf
	Until $data_FLUX = "" OR $ACNKO = 1

	if @error <> 0 Then Exit

	if $data_FLUX <> "" Then
		$data_ARRAYFLUX = StringSplit($data_FLUX,"~")

		for $idata = 1 to $data_ARRAYFLUX[0]
;~ 			_ArrayDisplay($data_ARRAYFLUX,$idata &"-"&$data_ARRAYFLUX[0])
			$data = $data_ARRAYFLUX[$idata]

			if $data <> "" Then
				WinSetTitle($Form1,"",$title & " - " & $data)
				if StringLeft($data,1) = ">" Then
					$data = StringTrimLeft($data,1)
					_GUICtrlListView_SetItemSelected($List1, Number($data)-1)
					_GUICtrlListView_EnsureVisible($List1, Number($data)-1)
				Elseif StringLeft($data,1) = "!" Then
					MsgBox(0,$title,StringTrimLeft($data,1))
				Elseif StringLeft($data,1) = "#" Then
					$data = StringTrimLeft($data,1)
					$data_array = StringSplit($data,"|")
					$f=0
					if $VARLARGEMODE = 0 Then
						$read = GUICtrlRead($List2)
					Else
						$read = GUICtrlRead($varlarge)
					EndIf
					$old = StringSplit($read,@CRLF,1)
					$NEW = ""
					if $read <> "" Then
						for $ix = 1 to $old[0]
							$singleline = StringSplit($old[$ix],"=")
							if $singleline[0] = 2 Then
								if $singleline[1] = $data_array[1] Then
									$NEW &= $data_array[1] &"="& $data_array[2] & @CRLF
									$f=1
								Else
									$NEW &= $singleline[1] &"="& $singleline[2] & @CRLF
								EndIf
							EndIf
						Next
					EndIf

					if $f = 0 Then
						$NEW &= $data_array[1] &"="& $data_array[2] & @CRLF
					EndIf

					if $NEW <> $read Then
						if $VARLARGEMODE = 0 Then
							GUICtrlSetData($List2,$NEW)
						Else
							GUICtrlSetData($varlarge,$NEW)
						EndIf
					EndIf


					#cs
					$data_array = StringSplit($data,"|")
					$F=0
					for $ivar = 0 to _GUICtrlListView_GetItemCount($List2)
		;~ 				TrayTip("c",$ivar,0)
						$name = _GUICtrlListView_GetItemText($List2,$ivar,0)
						$value = _GUICtrlListView_GetItemText($List2,$ivar,1)

						if $name <> "" Then
							if $name = $data_array[1] Then
								_GUICtrlListView_SetItemText($List2, $ivar, $value,2)
								$F=1
							EndIf
		;~ 					MsgBox(0,"",$name &":" & $value)
						EndIf
					Next
		;~ 			_ArrayDisplay(_GUICtrlListView_GetItemTextArray($List2,1))

					if $F=0 Then
						GUICtrlCreateListViewItem($data, $List2)
					EndIf
					#ce
				EndIf
			EndIf
		Next
	EndIf



	$nMsg = GUIGetMsg()

	If _IsPressed("76") Then
		$nMsg = $ButtonPause
		Do
			Sleep(10)
		Until Not _IsPressed("76")
	Elseif _IsPressed("77") Then
		$nMsg = $Button1
		Do
			Sleep(10)
		Until Not _IsPressed("77")
	Elseif _IsPressed("78") Then
		$nMsg = $Button2
		Do
			Sleep(10)
		Until Not _IsPressed("77")
	Elseif _IsPressed("7A") Then
		$nMsg = $Button3
		Do
			Sleep(10)
		Until Not _IsPressed("7A")
;~ 	Elseif _IsPressed("7A") Then
;~ 		$nMsg = $Button4
;~ 		Sleep(100)
	EndIf


	Switch $nMsg
		Case $ButtonPause
			TCPSend($socket,">???")
		Case $Button1
			TCPSend($socket,">>")
		Case $Button2
			if StringInStr($sourceraw,"#BKPOINT") = 0 Then
				MsgBox(0,$title,"No #BKPOINT tag found in code")
			Else
;~ 				if GUICtrlRead($JumpCheck) = 1 Then

;~ 				Else
					TCPSend($socket,">BP")
;~ 				EndIf
			EndIf
		Case $Button3
			for $i = 0 to _GUICtrlListView_GetItemCount($List1)
;~ 				MsgBox(0,$i,_GUICtrlListView_GetItemCount($List1))
;~ 				Exit
				if _GUICtrlListView_GetItemSelected($List1,$i) = True Then
;~ 					MsgBox(0,$i,_GUICtrlListView_GetItemSelected($List1,$i))
;~ 					MsgBox(0,$i,">BL" & $i+1)

					if GUICtrlRead($JumpCheck) = 1 Then
						TCPSend($socket,">JP" & $i+1)
					Else
						TCPSend($socket,">BL" & $i+1)
					EndIf
					ExitLoop
				EndIf
			Next
		Case $Button6
				$newVar = InputBox($title,"$VARNAME=NEWVALUE","$variable=hello")
				$newVar = StringTrimLeft($newVar,1)
				$newVar = StringReplace($newVar,"=","|")
				TCPSend($socket,">VN" & $newVar)
		Case $Button7
				$newVar = InputBox($title,"Query $var value","$variable")
				TCPSend($socket,">VG???" & $newVar)
		Case $Button5
			$VARLARGEMODE = 1
			GUICtrlSetData($varlarge, GUICtrlRead($List2))
			GUICtrlSetData($List2, "")

			GUISetState(@SW_SHOW,$varlargegui)
			WinSetOnTop($varlargegui,"",1)
		Case $Button4
			$line = InputBox($title,"Set the debug stop line")
			if $line <> "" Then
				if GUICtrlRead($JumpCheck) = 1 Then
					TCPSend($socket,">JP" & $i+1)
				Else
					TCPSend($socket,">BL" & $line)
				EndIf
			EndIf
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd




Func _makefile($file, $source)
;~ 	TCPStartup()

;~ 	$socket = -1
;~ 	Do
;~ 		$socket = TCPConnect("127.0.0.1",3333)
;~ 	Until $socket <> -1


	$Pre = ";*****{}{}{}{}{}AUTOGENERATE DEBUG CODE{}{}{}{}{}*****" & @CRLF
	$Pre &= "Opt(""TrayIconDebug"", 1)" & @CRLF
	$Pre &= "$BPOINT=0" & @CRLF
	$Pre &= "$BPOLine=0" & @CRLF
	$Pre &= "$DEBUG_JUMP_LINE=0" & @CRLF
	$Pre &= "TCPStartup()" & @CRLF
	$Pre &= "global $DEBUG_socket = -1" & @CRLF
	$Pre &= "Do" & @CRLF
	$Pre &= "	$DEBUG_socket = TCPConnect(""" & $Ip & """," & $port & ")" & @CRLF
	$Pre &= "Until $DEBUG_socket <> -1" & @CRLF

;~ 	Func _debug($DEBUG_lineNumber,$DEBUG_linetext)
;~ 		TCPSend($DEBUG_socket, ">" & $DEBUG_lineNumber)
;~ 		Do
;~ 			Sleep(10)
;~ 		Until TCPRecv($DEBUG_socket,10000) = ">>"
;~ 	EndFunc

;~ #BPOINT

	$post = "TCPCloseSocket($DEBUG_socket)" & @CRLF & @CRLF
	$post &= "Func _debug($DEBUG_lineNumber,$DEBUG_linetext)" & @CRLF & @CRLF
;~ $post &= "	MsgBox(0,'',$DEBUG_JUMP_LINE)" & @CRLF
	$post &= "	if $DEBUG_JUMP_LINE = 0 OR $DEBUG_lineNumber = $DEBUG_JUMP_LINE then" & @CRLF
	$post &= "		$DEBUG_JUMP_LINE = 0" & @CRLF
	$post &= "	else" & @CRLF
	$post &= "		return 0" & @CRLF
	$post &= "	endif" & @CRLF
;~ $post &= "	MsgBox(0,'','TCP')" & @CRLF
	$post &= "	" & @CRLF
	$post &= "	TCPSend($DEBUG_socket, "">"" & $DEBUG_lineNumber & ""~"")" & @CRLF
	$post &= "" & @CRLF
	$post &= "if StringInStr($DEBUG_linetext,""#BPOINT"") > 0 OR $BPOLine = $DEBUG_lineNumber OR StringInStr(TCPRecv($DEBUG_socket,10),""???"") > 0 then" & @CRLF
	$post &= "$BPOINT = 0" & @CRLF
	$post &= "$BPOLine=0" & @CRLF
	$post &= "endif" & @CRLF
	$post &= "if $BPOINT = 0 then" & @CRLF
	$post &= "	Do" & @CRLF
	$post &= "	Sleep(10)" & @CRLF
	$post &= "	$DEBUG_RCV = TCPRecv($DEBUG_socket,10000)" & @CRLF
	$post &= "	if @error <> 0 then exit" & @CRLF
	$post &= "	Until  $DEBUG_RCV <> """"" & @CRLF
	$post &= "" & @CRLF
;~ $post &= "msgbox(0,"""",$DEBUG_RCV)" & @CRLF
	$post &= "" & @CRLF
	$post &= "	if $DEBUG_RCV ="">>"" then" & @CRLF
	$post &= "	elseif stringleft($DEBUG_RCV,3) ="">JP"" then" & @CRLF
	$post &= "		$DEBUG_JUMP_LINE = stringtrimleft($DEBUG_RCV,3)" & @CRLF
;~ $post &= "	MsgBox(0,'',$DEBUG_JUMP_LINE)" & @CRLF
	$post &= "	elseif $DEBUG_RCV ="">BP"" then" & @CRLF
	$post &= "		$BPOINT = 1" & @CRLF
	$post &= "	elseif stringleft($DEBUG_RCV,3) ="">VN"" then" & @CRLF
	$post &= "		$DEBUG_RCV = stringtrimleft($DEBUG_RCV,3)" & @CRLF
	$post &= "		$DEBUG_RCV_A = stringsplit($DEBUG_RCV,""|"")" & @CRLF
	$post &= "		Assign($DEBUG_RCV_A[1], $DEBUG_RCV_A[2])" & @CRLF
	$post &= "	elseif stringleft($DEBUG_RCV,3) ="">BL"" then" & @CRLF
	$post &= "		$BPOLine = stringtrimleft($DEBUG_RCV,3)" & @CRLF
	$post &= "		$BPOINT = 1" & @CRLF
	$post &= "	elseif stringleft($DEBUG_RCV,6) ="">VG???"" then" & @CRLF
	$post &= "		$DEBUG_RCV = stringtrimleft($DEBUG_RCV,6)" & @CRLF
;~ 	$post &= "		$DEBUG_RCV = '12345678'" & @CRLF
;~ 	$post &= "		msgbox(0,'|' & $DEBUG_RCV & '|',Eval(stringtrimleft($DEBUG_RCV,1)))" & @CRLF
	$post &= "		TCPSend($DEBUG_socket, ""!"" & Eval(stringtrimleft($DEBUG_RCV,1)) & ""~"")" & @CRLF
	$post &= "	endif" & @CRLF
	$post &= "endif" & @CRLF
	$post &= "" & @CRLF
	$post &= "EndFunc" & @CRLF & @CRLF
	$post &= "Func _debugVAR($DEBUG_varName,$DEBUG_varValue)" & @CRLF & @CRLF
	$post &= "	TCPSend($DEBUG_socket, ""#"" & $DEBUG_varName & ""|"" & $DEBUG_varValue & ""~"")" & @CRLF
;~ 	$post &= "	Do" & @CRLF
;~ 	$post &= "	Sleep(10)" & @CRLF
;~ 	$post &= "	Until TCPRecv($DEBUG_socket,10000) = "">>""" & @CRLF
	$post &= "EndFunc" & @CRLF

	$newFile = $Pre
	for $i = 1 to $source[0]
		if StringStripWS($source[$i],8) = "" OR StringRight(StringStripWS($source[$i],8),1) = "_" OR StringLeft(StringStripWS($source[$i],8),1) = ";" OR StringRight(StringStripWS($source[$i-1],8),1) = "_" Then
			$newFile &= $source[$i] & @CRLF
		ElseIf StringInStr($source[$i],"#BKPOINT") > 0 Then
			$newFile &= $source[$i] & @CRLF
		Else
			$newFile &= "_debug(" & $i & ", """ & StringReplace($source[$i],"""","""""") & """)" & @CRLF
			$newFile &= $source[$i] & @CRLF
			$newfile &= _varsearch($source[$i])
		EndIf
	Next
	$newFile &= $post

	$debugfile = $file & ".debug.au3"

	if FileExists($debugfile) Then
		if StringInStr(FileRead($debugfile),";*****{}{}{}{}{}AUTOGENERATE DEBUG CODE{}{}{}{}{}*****") = 0 Then
			MsgBox(48,$title,"I can't delete " & @CRLF & """" & $debugfile & """" & @CRLF & " delete manually if you are sure.")
			Exit
		Else
			FileDelete($debugfile)
		EndIf
	EndIf

	FileWrite($debugfile,$newFile)

	Return $debugfile
EndFunc

Func _varsearch($code)
	$varlist = ""
	$codeA = StringSplit($code,"")

	$CHAR = ""
	$OLDCHAR = ""
	$AT=0
	For $ic = 1 to $codeA[0]
		if $codeA[$ic] = "$" Then
			$varlist &=$codeA[$ic]
			$AT=1
		EndIf

;~ 		MsgBox(0,$codeA[$ic] & "(" & $AT & ")",$code)
		if $AT=1 Then
;~ 			MsgBox(0,$codeA[0] & "(" & $AT & ")",$code)
			if Asc($codeA[$ic]) >= 48 AND  Asc($codeA[$ic]) <= 57 Then
				$varlist &=$codeA[$ic]
			ElseIf Asc($codeA[$ic]) >= 65 AND  Asc($codeA[$ic]) <= 90 Then
					$varlist &=$codeA[$ic]
			ElseIf Asc($codeA[$ic]) >= 97 AND  Asc($codeA[$ic]) <= 122 Then
				$varlist &=$codeA[$ic]
			Elseif Asc($codeA[$ic]) = 95 Then
				$varlist &=$codeA[$ic]
			Elseif $codeA[$ic] = "$" Then
;~ 				$varlist &=$codeA[$ic]
			Else
				$AT = 0
			EndIf
;~ 			$varlist &=$codeA[$ic]

		Else
			$AT =0
		EndIf
	Next

	If $varlist = "" Then
		Return ""
	EndIf

	$varlist_array = StringSplit(StringTrimLeft($varlist,1),"$")
	$pexcode = ""
	for $iv = 1 to $varlist_array[0]
		if $varlist_array[$iv] <> "" Then
			$pexcode &= "_debugVAR(""$" & $varlist_array[$iv] & """, $" & $varlist_array[$iv] & ")" & @CRLF
		EndIf
	Next


;~ 	MsgBox(0,"",$pexcode)
;~ 	MsgBox(0,$varlist & "(" & $AT & ")",$code)
	Return $pexcode
EndFunc


