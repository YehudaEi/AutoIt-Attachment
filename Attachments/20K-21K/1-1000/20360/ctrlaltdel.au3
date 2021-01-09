#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=..\cadComics.exe
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include<GUIConstantsEx.au3>
#include<WindowsConstants.au3>

#include<IE.au3>
$type = ""
$nextURL = ""
$prevURL = ""
$img = ""
$guiHeight = 790
$guiwidth = 600
$gui = GUICreate("Ctrl+Alt+Del Online Viewer", $guiwidth, $guiHeight, -1, -1, $WS_SIZEBOX+$WS_MINIMIZEBOX+$WS_CAPTION+$WS_MAXIMIZEBOX)
_IEErrorHandlerRegister()
$oIE = _IECreateEmbedded()
$obj = GUICtrlCreateObj($oIE, 0, 20, $guiwidth, $guiHeight)
GUICtrlSetResizing(-1, $GUI_DOCKTOP)
If Not IsObj($obj) Then
Else
	MsgBox(0, "Error", "Unable Embeded IE object!")
	Exit
EndIf
$back = GUICtrlCreateButton("Previous", 0, 0, 63, 20)
GUICtrlSetResizing(-1, $GUI_DOCKTOP+$GUI_DOCKHEIGHT)
$first = GUICtrlCreateButton("First", 63, 0, 63, 20)
GUICtrlSetResizing(-1, $GUI_DOCKTOP+$GUI_DOCKHEIGHT)
$latest = GUICtrlCreateButton("Latest", 126, 0, 63, 20)
GUICtrlSetResizing(-1, $GUI_DOCKTOP+$GUI_DOCKHEIGHT)
$foward = GUICtrlCreateButton("Next", 189, 0, 63, 20)
GUICtrlSetResizing(-1, $GUI_DOCKTOP+$GUI_DOCKHEIGHT)
$progress = GUICtrlCreateProgress(423, 0, 200, 20)
GUICtrlSetResizing(-1, $GUI_DOCKTOP+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
GUISetState()
GetLatestImg()

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $back
			$type = 1
			NextPrev()
			$type = ""
		Case $first
			GetFirstIMG()
		Case $latest
			GetLatestImg()
		Case $foward
			$type = 0
			NextPrev()
			$type = ""
	EndSwitch
WEnd

Func GetLatestImg()
	$oldimg = $img
	$IMGREG = '(?s)(?i)width="625".*?img.src="/comics/(.*?)">'
	InetGet("                                          ", @TempDir & "\cadtemp.php", 0, 0)
	$nOffset = 1
	$shtml = FileRead(@TempDir & "\cadtemp.php")
	$array = StringRegExp($shtml, $IMGREG, 1, $nOffset)
	If @error = 1 Then
		GUIDelete()
		MsgBox(0, "Error", "Couldn't pull image!")
		Exit
	Else
		$img = $array[0]
		GUICtrlSetState($progress, $GUI_SHOW)
		_IENavigate($oIE, "                                        " & $img, 0)
		While _IEPropertyGet($oIE, "busy") = -1
			For $i = 0 To 100
				GUICtrlSetData($progress, $i)
				Sleep(Int(Random(5, 15)))
			Next
		WEnd
	EndIf
	GUICtrlSetState($progress, $GUI_HIDE)
	
	$array = StringRegExp($shtml, '(?s)(?i)<td.val.*/bg-[0-9].*><a.href="/comic.php\?d=(.*?).><img.src="/.*back[0-9].*"></a>', 1, $nOffset)
	If @error = 1 Then
	Else
		$prevURL = "                                             "&$array[0]
		
		$array = StringRegExp($shtml, '(?s)(?i)<td.val.*/bg-[0-9].*><a.href="/comic.php\?d=(.*?).><img.src="/.*next[0-9].*"></a>', 1, $nOffset)
		If @error = 1 Then
			$nextURL = "                                             "&$oldimg
		Else
			$nextURL = "                                             "&$array[0]
		EndIf
	EndIf
	FileDelete(@TempDir & "\cadtemp.php")
EndFunc   ;==>GetLatestImg

Func GetFirstIMG()
	$oldimg = $img
	$IMGREG = '(?s)(?i)width="625".*?img.src="/comics/(.*?)">'
	InetGet("                                                     ", @TempDir & "\cadtemp.php", 0, 0)
	$nOffset = 1
	$shtml = FileRead(@TempDir & "\cadtemp.php")
	$array = StringRegExp($shtml, $IMGREG, 1, $nOffset)
	If @error = 1 Then
		GUIDelete()
		MsgBox(0, "Error", "Couldn't pull image!")
		Exit
	Else
		$img = $array[0]
		_IENavigate($oIE, "                                        " & $img, 0)
		GUICtrlSetState($progress, $GUI_SHOW)
		While _IEPropertyGet($oIE, "busy") = -1
			For $i = 0 To 100
				GUICtrlSetData($progress, $i)
				Sleep(Int(Random(5, 15)))
			Next
		WEnd
		GUICtrlSetState($progress, $GUI_HIDE)
	EndIf
	$array = StringRegExp($shtml, '(?s)(?i)<td.val.*/bg-[0-9].*><a.href="/comic.php\?d=(.*?).><img.src="/.*back[0-9].*"></a>', 1, $nOffset)
	If @error = 1 Then
	Else
		$prevURL = "                                             "&$array[0]
		$array = StringRegExp($shtml, '(?s)(?i)<td.val.*/bg-[0-9].*><a.href="/comic.php\?d=(.*?).><img.src="/.*next[0-9].*"></a>', 1, $nOffset)
		If @error = 1 Then
			$nextURL = "                                             "&$oldimg
		Else
			$nextURL = "                                             "&$array[0]
		EndIf
	EndIf
	FileDelete(@TempDir & "\cadtemp.php")
EndFunc   ;==>GetFirstIMG



Func NextPrev()
	$oldimg = $img
	ConsoleWrite("================================="&@CRLF&"At NextPrevious Function, Current: "&$img&@CRLF&"Next Day: "&$nextURL&@CRLF&"Previous Day:"&$prevURL & @CRLF)
	$IMGREG = '(?s)(?i)width="625".*?img.src="/comics/(.*?)">'
	If $type = 1 Then InetGet($prevURL, @TempDir & "\cadtemp.php", 0, 0)
	If $type = 0 Then InetGet($nextURL, @TempDir & "\cadtemp.php", 0, 0)
	$nOffset = 1
	$shtml = FileRead(@TempDir & "\cadtemp.php")
	$array = StringRegExp($shtml, $IMGREG, 1, $nOffset)
	If @error = 1 Then
		GUIDelete()
		MsgBox(0, "Error", "Couldn't pull image!")
		Exit
	Else
		$img = $array[0]
		_IENavigate($oIE, "                                        " & $img, 0)
		GUICtrlSetState($progress, $GUI_SHOW)
		While _IEPropertyGet($oIE, "busy") = -1
			For $i = 0 To 100
				GUICtrlSetData($progress, $i)
				Sleep(Int(Random(5, 15)))
			Next
		WEnd
		GUICtrlSetState($progress, $GUI_HIDE)
	EndIf
	$array = StringRegExp($shtml, '(?s)(?i)<td.val.*/bg-[0-9].*><a.href="/comic.php\?d=(.*?).><img.src="/.*back[0-9].*"></a>', 1, $nOffset)
	If @error = 1 Then
	Else
		$prevURL = "                                             "&$array[0]
		$array = StringRegExp($shtml, '(?s)(?i)<td.val.*/bg-[0-9].*><a.href="/comic.php\?d=(.*?).><img.src="/.*next[0-9].*"></a>', 1, $nOffset)
		If @error = 1 Then
			$nextURL = "                                             "&$oldimg
		Else
			$nextURL = "                                             "&$array[0]
			EndIf
	EndIf
	FileDelete(@TempDir & "\cadtemp.php")
	ConsoleWrite("========================="&@CRLF&"Next:"&$nextURL&@CRLF&"Back:"&$prevURL & @CRLF)
EndFunc