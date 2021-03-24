#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Array.au3>
Opt("TrayIconDebug", 1)


$title = "CyberDebug 0.01"

$inifile = @ScriptDir & "\CyberDebug.ini"
$default = IniRead($inifile,"Data","defaultFile","")

$file = FileOpenDialog($title,@ScriptDir,"AutoIt File (*.au3)",-1,$default)

if $file = "" Then Exit

IniWrite($inifile,"Data","defaultFile",$file)

$sourceraw = FileRead($file)
$source = StringSplit($sourceraw,@CRLF,1)


;****************************************************************
$Form1 = GUICreate($title, 1008, 637, 74, 156)
$List1 = GUICtrlCreateListView("Source", 8, 8, 833, 578)
;~ $List2 = GUICtrlCreateListView("Name|Value", 848, 8, 153, 539)
$List2 = GUICtrlCreateEdit("", 848, 8, 153, 539)
$Button1 = GUICtrlCreateButton("Next line", 64, 600, 175, 25)
$Button2 = GUICtrlCreateButton("next #BKPOINT", 168+100, 600, 175, 25)
$Button3 = GUICtrlCreateButton("go to selected line", 272+200, 600, 175, 25)
$Button4 = GUICtrlCreateButton("go to line ...", 376+300, 600, 175, 25)

$Button5 = GUICtrlCreateButton("Use large window", 888-25, 552, 75+50, 25)
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
	GUICtrlCreateListViewItem($source[$i], StringReplace($List1,@TAB,"         "))
Next


$debFile = _makefile($file,$source)

Run(@AutoItExe & " """ & $debFile & """")

TCPStartup()
$mainsocket = TCPListen("127.0.0.1",3333)

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

					if $VARLARGEMODE = 0 Then
						GUICtrlSetData($List2,$NEW)
					Else
						GUICtrlSetData($varlarge,$NEW)
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
	Switch $nMsg
		Case $Button1
			TCPSend($socket,">>")
		Case $Button2
			if StringInStr($sourceraw,"#BKPOINT") = 0 Then
				MsgBox(0,$title,"No #BKPOINT tag found in code")
			Else
				TCPSend($socket,">BP")
			EndIf
		Case $Button3
			for $i = 0 to _GUICtrlListView_GetItemCount($List1)
;~ 				MsgBox(0,$i,_GUICtrlListView_GetItemCount($List1))
;~ 				Exit
				if _GUICtrlListView_GetItemSelected($List1,$i) = True Then
;~ 					MsgBox(0,$i,_GUICtrlListView_GetItemSelected($List1,$i))
;~ 					MsgBox(0,$i,">BL" & $i+1)
					TCPSend($socket,">BL" & $i+1)
					ExitLoop
				EndIf
			Next
		Case $Button5
			$VARLARGEMODE = 1
			GUICtrlSetData($varlarge, GUICtrlRead($List2))
			GUICtrlSetData($List2, "")

			GUISetState(@SW_SHOW,$varlargegui)
		Case $Button4
			$line = InputBox($title,"Set the debug stop line")
			if $line <> "" Then
				TCPSend($socket,">BL" & $line)
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
	$Pre &= "TCPStartup()" & @CRLF
	$Pre &= "global $DEBUG_socket = -1" & @CRLF
	$Pre &= "Do" & @CRLF
	$Pre &= "	$DEBUG_socket = TCPConnect(""127.0.0.1"",3333)" & @CRLF
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
	$post &= "	TCPSend($DEBUG_socket, "">"" & $DEBUG_lineNumber & ""~"")" & @CRLF
	$post &= "" & @CRLF
	$post &= "if StringInStr($DEBUG_linetext,""#BPOINT"") > 0 OR $BPOLine = $DEBUG_lineNumber then" & @CRLF
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
;~ 	$post &= "msgbox(0,"""",$DEBUG_RCV)" & @CRLF
	$post &= "" & @CRLF
	$post &= "	if $DEBUG_RCV ="">>"" then" & @CRLF
	$post &= "	elseif $DEBUG_RCV ="">BP"" then" & @CRLF
	$post &= "	$BPOINT = 1" & @CRLF
	$post &= "	elseif stringleft($DEBUG_RCV,3) ="">BL"" then" & @CRLF
	$post &= "	$BPOLine = stringtrimleft($DEBUG_RCV,3)" & @CRLF
	$post &= "	$BPOINT = 1" & @CRLF
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
		if StringStripWS($source[$i],8) <> "" AND (StringLeft(StringStripWS($source[$i],8),1) <> ";" OR StringInStr($source[$i],"#BPOINT") >0 )Then
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


