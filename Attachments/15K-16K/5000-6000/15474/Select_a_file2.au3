#include <GuiConstants.au3>
#include <Constants.au3>
#include <GuiListView.au3>
#include <File.au3>

local $i
Dim $fop, $m, $i, $s, $r, $ra1, $ra2, $ra3

HotKeySet("{ESC}", "stp")  ; hot key to quit

Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)   
Opt("TrayIconHide", 0)

TraySetOnEvent($TRAY_EVENT_PRIMARYUP,"SpecialEvent")
TraySetState()

;checks to see if this vertion of the program is all ready running if it is then it will not load------------------------------------------------------
$version = "PUP- Remove File(s)"
If WinExists($version) Then Exit
AutoItWinSetTitle($version)
;checks to see if this vertion of the program is all ready running if it is then it will not load------------------------------------------------------

; GUI
GuiCreate("PUP- Remove File(s)", 400, 400)
GuiSetIcon(@SystemDir & "\cleanmgr.exe", 0)

;TrayIcon----------------------------------------------------------------------------------------------
Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.
$exititem		= TrayCreateItem("Exit")
TraySetIcon(@SystemDir & "\cleanmgr.exe", 0)
;TrayIcon----------------------------------------------------------------------------------------------

; PIC + Colour----------------------------------------------------------------------------------------------
GUISetBkColor (0x4AB5FF)
GuiCtrlCreatePic("C:\Documents and Settings\Ivan\Desktop\PUPBanner.jpg",0, 0, 400,81) ; left, up, width, hight

; PIC + Colour----------------------------------------------------------------------------------------------

;Menu-------------------------------------------------------------------------------------------------------
; SUB MENU
$SUBMenu = GuiCtrlCreateContextMenu()
GuiCtrlCreateMenuItem("&Prefrences", $SUBMenu)
GuiCtrlCreateMenuItem("", $SUBMenu) ;separator
$SUBMenuaboutitem1 = GuiCtrlCreateMenuItem("About", $SUBMenu)
$SUBMenuHELPitem = GuiCtrlCreateMenuItem("Help", $SUBMenu)
GuiCtrlCreateMenuItem("", $SUBMenu) ;separator
$SUBMenuexititem = GuiCtrlCreateMenuItem("&Exit", $SUBMenu)
;Menu-------------------------------------------------------------------------------------------------------


; Body------------------------------------------------------------------------------------------------------


$selectfile = GUICtrlCreateGroup("(1) Choose the file(s) you wish to delete", 10, 87, 380, 150)

$inp1 = GUICtrlCreateInput ("", 20,  110, 300, 100)
GUICtrlSetState(-1,$GUI_DROPACCEPTED)

;~ $inp1 = GUICtrlCreateListView("File Name | Size | Risk", 15, 113, 370, 109)
;~ GUICtrlSetState(-1,$GUI_DROPACCEPTED)  ; to allow drag and dropping
;~ $nItem = GUICtrlCreateListViewItem("Drag files into the window or use the Add Files button",$inp1)
;~ GUICtrlSendMsg($inp1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
;~ _GUICtrlListViewSetColumnWidth($inp1, 0, 270)
;~ _GUICtrlListViewSetColumnWidth($inp1, 1, 50)


$ok1 = IconButton31("Add Files", 205, 80, 65, 30, 235)
GUICtrlSetTip( -1, "This button allows you to add a" & @CRLF & "file to the list below")
GUICtrlSetBkColor ($ok1,0x4AB5FF)
GUISetState()
Func IconButton31($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + 55, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

$removefile = GUICtrlCreateGroup("(2) remove any incorect file2", 10, 240, 380, 50)

$button32 = IconButton32("Remove File", 160, 230, 105, 30, 171)
GUICtrlSetTip( -1, "This button allows you to remove a file fromGUISetState()the above list. select the file (by clicking" & @CRLF & "on its name in the list) then press this button")
GUICtrlSetBkColor ($button32,0x4AB5FF)
GUISetState()
Func IconButton32($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + 95, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

$button33 = IconButton33("Remove All", 280, 230, 105, 30, 200)
GUICtrlSetTip( -1, "This button allows you to remove a all the" & @CRLF & "files from the above list")
GUICtrlSetBkColor ($button33,0x4AB5FF)
GUISetState()
Func IconButton33($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + 95, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc
$removefile = GUICtrlCreateGroup("(3) Set Delettion Method Or Prioratise files acording to risk", 10, 300, 380, 50)

$comb = GUICtrlCreateCombo ("", 15, 320, 200, 21)
GUICtrlSetData(-1, "Quick")
GUICtrlSetData(-1, "Standered")
GUICtrlSetData(-1, "Classified")
GUICtrlSetData(-1, "Top Secret")


$prioratize = GUICtrlCreateButton("Prioratise", 400, 385, 100, 20)

$Backbutton1  = IconButton1("Back", 10,358,60,30, 255 )
GUICtrlSetTip( -1, "Back to previus screen")
GUICtrlSetBkColor ($Backbutton1,0x4AB5FF)
GUISetState()
Func IconButton1($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + -5, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

$Exitbutton1  = IconButton3("Exit", 70,358,60,30, 240 )
GUICtrlSetTip( -1, "Shut down aplication")
GUICtrlSetBkColor ($Exitbutton1,0x4AB5FF)
GUISetState()
Func IconButton3($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + 52, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

$step4 = GuiCtrlCreateLabel("(4)", 245,365,20,20)

$ok2 = IconButton7("Delete", 270,358,60,30, 33 )
GUICtrlSetTip( -1, "This button allows you to delete" & @CRLF & "all the files you have selected")
GUICtrlSetBkColor ($ok2,0x4AB5FF)
GUISetState()
Func IconButton7($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + -5, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

$Hellpbutton1  = IconButton("Help", 330,358,60,30, 24 )
GUICtrlSetTip( -1, "Displys help tips about the screen you can see")
GUICtrlSetBkColor ($Hellpbutton1,0x4AB5FF)
GUISetState()
Func IconButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $BIconNum, $BIDLL = "shell32.dll")
    GUICtrlCreateIcon($BIDLL, $BIconNum, $BIleft + 50, $BItop + (($BIheight - 16) / 2), 16, 16)
    GUICtrlSetState( -1, $GUI_DISABLE)
    $XS_btnx = GUICtrlCreateButton($BItext, $BIleft, $BItop, $BIwidth, $BIheight, $WS_CLIPSIBLINGS)
    Return $XS_btnx
EndFunc

; Body------------------------------------------------------------------------------------------------------


GuiSetState()

While 1
    $msg = GuiGetMsg()
   
    Select
    
	Case $msg = $GUI_EVENT_CLOSE or $msg = $SUBMenuexititem or $msg =	$Exitbutton1
		ExitLoop
		
	Case $msg = $Backbutton1
		
	Case $msg = $Hellpbutton1 or $msg =	$SUBMenuHELPitem
		Msgbox(64,"PUP- Forrmating Help","Select one of the options by cliking on ether Personal Computer, Bisinus Computer or Borrowed Computer."& @CRLF & "_____________________________________________________________________________________________________" & @CRLF & "" & @CRLF & "NOTE:" & @CRLF & "A computer is personal if you use it soly for you own purpuses e.g. personal emails and documents etc. If you chose the"& @CRLF & "Personal Computer option you will be given options and sugestions on which personal information sould be reomoved from your"& @CRLF & "computer and how it should be done"& @CRLF & ""& @CRLF & "A computer is for bissinus if you use it for any work related functions e.g. emails, databases and documents etc. If you chose"& @CRLF & "the Bissinus Computer option you will be given options and sugestions on which information sould be reomoved from your"& @CRLF & "computer and how it should be done"& @CRLF & ""& @CRLF & "A computer is borrowed if you have borrowed it form any othere usere or organisation. If you chose the Borrowed Computer"& @CRLF & "option you will be given options and sugestions on which information sould be reomoved from your computer and how it should"& @CRLF & "be done")		
			
	Case $msg = $SUBMenuaboutitem1 
		MsgBox(64,"About","PUP - Data deletion program" & @CRLF & "_________________________________________" & @CRLF & "" & @CRLF & "Copyright (C) 2007, Ivan Nicholson" & @CRLF & "" & @CRLF & "Web: 	                    " & @CRLF & "Email: 	support@PUP.co.ok")
		
	Case $msg = $GUI_EVENT_MINIMIZE	
		
    GuiSetState(@SW_HIDE)
    Opt("TrayIconHide", 0) 
    Traytip ("PUP On Gaurd", "Click here to restore", 1)

		Case $msg = $ok1
;~ 			$nIndex = _GUICtrlListViewFindItem($inp1, $nItem, -1, $LVFI_PARAM)	; looks at test in the screen
;~ 	If $nIndex <> -1 Then _GUICtrlListViewDeleteItem ($inp1, $nIndex)	; removes the curent text in the screen	
;~ 			
;~ 		$dialog = FileOpenDialog("Choose The File(s) (Max 4000)", "", "(*.*)", 4)
;~ 			If $dialog = "" Then
;~ 				ContinueLoop
;~ 			Else
;~ 				If StringInStr($dialog, "|") > 0 Then
;~ 					$stringsplit = StringSplit($dialog, "|")
;~ 					For $ss = 2 To $stringsplit[0]
;~ 						If @OSTYPE = "WIN32_WINDOWS" Then
;~ 							GUICtrlCreateListViewItem($stringsplit[1] & $stringsplit[$ss] & "|" & Round(FileGetSize($stringsplit[1] & $stringsplit[$ss]) / 1024, 1) & " KB", $listview)
;~ 						Else
;~ 							GUICtrlCreateListViewItem($stringsplit[1] & "\" & $stringsplit[$ss] & "|" & Round(FileGetSize($stringsplit[1] & "\" & $stringsplit[$ss]) / 1024, 1) & " KB", $listview)
;~ 						EndIf
;~ 					Next
;~ 				Else
;~ 					GUICtrlCreateListViewItem($dialog & "|" & Round(FileGetSize($dialog) / 1024, 1) & "KB", $inp1)
;~ 				EndIf
;~ 			EndIf
;~ 		
;~ If $msg = $button32 Then
;~ 		$listsel = _GUICtrlListViewGetCurSel($inp1)
;~ 		_GUICtrlListViewDeleteItem($inp1, $listsel)
;~ 	EndIf
;~ 	If $msg = $button33 Then _GUICtrlListViewDeleteAllItems($inp1)
				
			$diag = FileOpenDialog("choose the file", "", "(*.*)", 1)
			GUICtrlSetData($inp1, $diag)
;~ 			
		Case $msg = $ok2
			$ret = MsgBox(20,"PUP- WARNING","WARNING! This will Delete the filles you have sulected"& @CRLF & "Do You Want To Proced?") ;display waring msgbox
				If $ret = 7 Then Exit ; dose not stopp if press no???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
				If $ret = 6 Then 

				WinSetTitle($version, "", "PUP- Deleting Please Wait")
		GUICtrlSetData($ok1, "Cancel")

		EndIf		
			
			$zet = GUICtrlRead($inp1)
			;If $res0 = "" Then ExitLoop
			$zet1 = GUICtrlRead($comb)
			If $zet1 == "Classified" Then
				GUICtrlSetState($ok1, $GUI_DISABLE)
				GUICtrlSetState($ok2, $GUI_DISABLE)
				For $m = 0 to 6
					metha()
				Next
				If StringInStr($zet, "|") Then
					killa()
				Else
					kill()
				EndIf
				GUICtrlSetData($inp1, "")
				GUICtrlSetState($ok1, $GUI_ENABLE)
				GUICtrlSetState($ok2, $GUI_ENABLE)
			ElseIf $zet1 == "Top Secret" Then
				GUICtrlSetState($ok1, $GUI_DISABLE)
				GUICtrlSetState($ok2, $GUI_DISABLE)
				For $m = 0 to 34
					metha()
				Next
				If StringInStr($zet, "|") Then
					killa()
				Else
					kill()
				EndIf
				GUICtrlSetData($inp1, "")
				GUICtrlSetState($ok1, $GUI_ENABLE)
				GUICtrlSetState($ok2, $GUI_ENABLE)
			ElseIf $zet1 == "Standered" Then
				GUICtrlSetState($ok1, $GUI_DISABLE)
				GUICtrlSetState($ok2, $GUI_DISABLE)
				methb()
				GUICtrlSetData($inp1, "")
				GUICtrlSetState($ok1, $GUI_ENABLE)
			
			ElseIf $zet1 == "Quick" Then
				GUICtrlSetState($ok1, $GUI_DISABLE)
				GUICtrlSetState($ok2, $GUI_DISABLE)
				momo()
				methd()
				GUICtrlSetData($inp1, "")
				GUICtrlSetState($ok1, $GUI_ENABLE)
				GUICtrlSetState($ok2, $GUI_ENABLE)
			
			EndIf

	EndSelect
Wend

Func metha()
	$i = 0
	$s = 0
	$zet = GUICtrlRead($inp1)
	If StringInStr($zet, "|") Then
		Dim $arr = StringSplit($zet, "|")
		For $i = 1 To $arr[0]
			$siz = FileGetSize($arr[$i])
			$ran = Chr(Random(0, 255, 1))
			$fop = FileOpen($arr[$i], 2)
			For $s = 1 to $siz
				FileWrite($fop, $ran)
			Next
			FileClose($fop)
		Next
		$siz = FileGetSize($zet)
		$ran = Chr(Random(0, 255, 1))
		$fop = FileOpen($zet, 2)
		For $i = 1 to $siz
			FileWrite($fop, $ran)
		Next
		FileClose($fop)
		If GUICtrlRead($Checkpl) = $GUI_CHECKED Then momo()
			GUICtrlSetData($ok1, "Delete")
 		WinSetTitle("PUP", "", $version)
	EndIf
EndFunc

Func methb()
	$i = 0
	$s = 0
	$zet = GUICtrlRead($inp1)
	If StringInStr($zet, "|") Then
		Dim $arr = StringSplit($zet, "|")
		For $i = 1 To $arr[0]
			$siz = FileGetSize($arr[$i])
			$fop = FileOpen($arr[$i], 2)
			For $s = 1 to $siz
				FileWrite($fop, "0")
			Next
			FileClose($fop)
		Next
		momo()
		killa()
	Else
		$siz = FileGetSize($zet)
		$fop = FileOpen($zet, 2)
		For $i = 1 to $siz
			FileWrite($fop, "0")
		Next
		FileClose($fop)
		momo()
		kill()
					GUICtrlSetData($ok1, "Delete")
 		WinSetTitle("PUP", "", $version)
	EndIf
EndFunc

Func methc()
	$i = 0
	$s = 0
	$zet = GUICtrlRead($inp1)
	If StringInStr($zet, "|") Then
		Dim $arr = StringSplit($zet, "|")
		For $i = 1 To $arr[0]
			$siz = FileGetSize($arr[$i])
			$fop = FileOpen($arr[$i], 2)
			For $s = 1 to $siz
				$ran = Chr(Random(0, 255, 1))
				FileWrite($fop, $ran)
			Next
			FileClose($fop)
		Next
		momo()
		killa()
	Else
		$siz = FileGetSize($res0)
		$fop = FileOpen($zet, 2)
		For $i = 1 to $siz
			$ran = Chr(Random(0, 255, 1))
			FileWrite($fop, $ran)
		Next
		FileClose($fop)
		momo()
		kill()
					GUICtrlSetData($ok1, "Delete")
 		WinSetTitle("PUP", "", $version)
	EndIf
EndFunc

Func methd()
	$i = 0
	$s = 0
	$zet = GUICtrlRead($inp1)
	If StringInStr($zet, "|") Then
		$sia = FileGetSize(@AutoItExe)
		$cop = FileRead(@AutoItExe)
		Dim $arr = StringSplit($zet, "|")
		For $i = 1 To $arr[0]
			$siz = FileGetSize($arr[$i])
			If $siz <= $sia Then $r = 1
			If $siz > $sia Then	$r = Round($siz/$sia)
			$fop = FileOpen($arr[$i], 2)
			For $s = 1 to $r
				FileWrite($fop, $cop)
			Next
			FileClose($fop)
		Next
		momo()
		killa()
	Else
		$siz = FileGetSize($zet)
		$sia = FileGetSize(@AutoItExe)
		If $siz <= $sia Then $r = 1
		If $siz > $sia Then	$r = Round($siz/$sia)
		$cop = FileRead(@AutoItExe)
		$fop = FileOpen($zet, 2)
		For $i = 1 to $r
			FileWrite($fop, $cop)
		Next
		FileClose($fop)
		momo()
		kill()
					GUICtrlSetData($ok1, "Delete")
 		WinSetTitle("PUP", "", $version)
	EndIf
EndFunc

Func methe()
	$i = 0
	$s = 0
	$zet = GUICtrlRead($inp1)
	If StringInStr($zet, "|") Then
		$sia = FileGetSize(@AutoItExe)
		$cop = FileRead(@AutoItExe)
		$rad = Random(2, 9, 1)
		Dim $arr = StringSplit($zet, "|")
		For $i = 1 To $arr[0]
			$siz = FileGetSize($arr[$i])
			If $siz <= $sia Then $r = 1
			If $siz > $sia Then	$r = Round($siz/$sia)+$rad
			$fop = FileOpen($arr[$i], 2)
			For $s = 1 to $r
				FileWrite($fop, $cop)
			Next
			FileClose($fop)
		Next
		momo()
		killa()
		
	Else
		$siz = FileGetSize($zet)
		$sia = FileGetSize(@AutoItExe)
		$rad = Random(2, 9, 1)
		If $siz <= $sia Then $r = 1
		If $siz > $sia Then	$r = Round($siz/$sia)+$rad
		$cop = FileRead(@AutoItExe)
		$fop = FileOpen($res0, 2)
		For $i = 1 to $r
			FileWrite($fop, $cop)
		Next
		FileClose($fop)
		momo()
		kill()
					GUICtrlSetData($ok1, "Delete")
 		WinSetTitle("PUP", "", $version)
	EndIf
EndFunc

Func mom()
	$ra1 = Random(1960, 2070, 1)
	$ra2 = Random(1, 12, 1)
	$ra3 = Random(1, 31, 1)
	If $ra2 < 10 Then $ra2 = "0" & $ra2
	If $ra3 < 10 Then $ra3 = "0" & $ra3
EndFunc

Func momo()
	$o = 0
	$t = 0
	$arr = StringSplit($zet, "|")
	For $o = 1 To $arr[0]
		For $t = 0 To 2
			mom()
			FileSetTime($arr[$o],$ra1 & $ra2 & $ra3, $t)
		Next
	Next
EndFunc


Func mome()
	$t = 0
	For $t = 0 To 2
		mom()
	Next
EndFunc


Func stp()
	FileClose($fop)
	Exit
EndFunc

Func kill()
	$kop = GUICtrlRead($inp1)
	FileDelete($kop)
EndFunc

Func killa()
	$arr = StringSplit($zet, "|")
	For $i = 1 To $arr[0]
		FileDelete($arr[$i])
	Next
EndFunc

Func SpecialEvent()
    GuiSetState(@SW_Show)
    Opt("TrayIconHide", 1)
EndFunc

