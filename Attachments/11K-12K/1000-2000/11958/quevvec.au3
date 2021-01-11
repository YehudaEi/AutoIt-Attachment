#include <GUIConstants.au3>
#include <ModernMenu.au3>
Global $edition = "browser"
Global $currenturl = "browser://start"
Global $currenttitle = "browser://start"
Global $currentstatus = ""

#Region ### START Koda GUI section ### Form=C:\Documents and Settings\pmcallender\My Documents\My AutoIt Scripts\Koda (not au3)\Forms\quevvecbrowser1.kxf
$Form1 = GUICreate("browser://start", 631, 441, 219, 135,BitOR($WS_POPUP,$WS_BORDER,$WS_SIZEBOX))
GUISetBkColor(0xFFFF00)
$Label1 = GUICtrlCreateLabel("Quevvec Browser (browser://start)", 40, 0, 551, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetBkColor(-1, 0xFFD700)
GUICtrlSetResizing(-1,550)
$Label1Context = GUICtrlCreateContextMenu($Label1)
$Maximize = GUICtrlCreateMenuItem("Maximize Window",$Label1,-1,1)
$Label2 = GUICtrlCreateLabel("V", 0, 0, 41, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetResizing(-1,802)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Label3 = GUICtrlCreateLabel("Back", 0, 20, 51, 31, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1,802)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Gobutton = GUICtrlCreateLabel("Go", 610, 50, 21, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetResizing(-1,804)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Label5 = GUICtrlCreateLabel("Sidebar", 0, 70, 141, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetResizing(-1,802)
$SideBar_SearchAsstIE = ObjCreate("Shell.Explorer.2")
$SideBar_SearchAsst = GUICtrlCreateObj($SideBar_SearchAsstIE,0,90,161,351)
GUICtrlSetState($SideBar_SearchAsst,$GUI_HIDE)
GUICtrlSetResizing(-1,354)
$SideBar_SearchAsstIE.navigate2("http://www.google.com/imode")
$SideBar_Favourites = GUICtrlCreateTreeView(0,90,161,351,BitOr($GUI_SS_DEFAULT_TREEVIEW,$WS_BORDER))
GUICtrlSetState($SideBar_Favourites,$GUI_HIDE)
GUICtrlSetResizing(-1,354)
$SideBar_History = GUICtrlCreateTreeView(0,90,161,351,BitOr($GUI_SS_DEFAULT_TREEVIEW,$WS_BORDER))
GUICtrlSetResizing(-1,354)
$Label6 = GUICtrlCreateLabel("URL", 0, 50, 41, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetResizing(-1,802)
$Label7 = GUICtrlCreateLabel("X", 590, 0, 41, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetResizing(-1,804)
$Label8 = GUICtrlCreateLabel("Forward", 50, 20, 51, 31, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetResizing(-1,802)
$Label9 = GUICtrlCreateLabel("Stop", 100, 20, 51, 31, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetResizing(-1,802)
$Label10 = GUICtrlCreateLabel("Refresh", 150, 20, 51, 31, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetResizing(-1,802)
$Label11 = GUICtrlCreateLabel("Home", 200, 20, 51, 31, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetResizing(-1,802)
$URLBox = GUICtrlCreateInput("browser://start", 40, 50, 571, 21, BitOR($ES_AUTOHSCROLL,$WS_BORDER), 0)
GUICtrlSetResizing(-1,512+2+4+32)
;$Label4 = GUICtrlCreateLabel("Sidebar", 0, 90, 161, 351, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
;GUICtrlSetBkColor(-1, 0xFFFF00)
$Label12 = GUICtrlCreateLabel("X", 140, 70, 21, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetResizing(-1,802)
$Label13 = GUICtrlCreateLabel("browser://start", 250, 20, 381, 31, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetBkColor(-1, 0xFFFF00)
GUICtrlSetResizing(-1,2+4+32+512)
$IE = ObjCreate("Shell.Explorer.2")
$Label14 = GUICtrlCreateObj($IE, 160, 70, 471, 371)
GUICtrlSetBkColor(-1, 0xFFFF00)
GUICtrlSetResizing(-1,2+4+64+32)
$Label2context = GUICtrlCreateContextMenu($Label2)
_SetMenuBkColor(0x00FFFF)
_SetMenuIconBkColor(0x00FFFF)
_SetMenuSelectBkColor(0x00D7FF)
_SetMenuSelectRectColor(0x00D7FF)
$MenuItem1 = _GUICtrlCreateODMenu("File", $Label2context)
$MenuItem8 = _GUICtrlCreateODMenuItem("New Page...", $MenuItem1)
$MenuItem9 = _GUICtrlCreateODMenu("Open Page", $MenuItem1)
$MenuItem10 = _GUICtrlCreateODMenuItem("For Viewing...", $MenuItem9)
$MenuItem11 = _GUICtrlCreateODMenuItem("For Editing...", $MenuItem9)
$MenuItem12 = _GUICtrlCreateODMenuItem("Close Page...", $MenuItem1)
$MenuItem13 = _GUICtrlCreateODMenuItem("", $MenuItem1)
$MenuItem14 = _GUICtrlCreateODMenuItem("Print Page...", $MenuItem1)
$MenuItem2 = _GUICtrlCreateODMenu("Edit", $Label2context)
$MenuItem15 = _GUICtrlCreateODMenuItem("Copy", $MenuItem2)
$MenuItem16 = _GUICtrlCreateODMenuItem("Cut", $MenuItem2)
$MenuItem17 = _GUICtrlCreateODMenuItem("Edit", $MenuItem2)
$MenuItem3 = _GUICtrlCreateODMenu("View", $Label2context)
$MenuItem18 = _GUICtrlCreateODMenuItem("Sidebar", $MenuItem3)
GUICtrlSetState($MenuItem18, $GUI_CHECKED)
$MenuItem19 = _GUICtrlCreateODMenuItem("Navigation Bar", $MenuItem3)
GUICtrlSetState($MenuItem19, $GUI_CHECKED)
$MenuItem20 = _GUICtrlCreateODMenuItem("Address Bar", $MenuItem3)
GUICtrlSetState($MenuItem20, $GUI_CHECKED)
$MenuItem21 = _GUICtrlCreateODMenuItem("Titlebar", $MenuItem3)
GUICtrlSetState($MenuItem21, $GUI_CHECKED)
$MenuItem4 = _GUICtrlCreateODMenu("Tools", $Label2context)
$MenuItem22 = _GUICtrlCreateODMenuItem("Options...", $MenuItem4)
$MenuItem23 = _GUICtrlCreateODMenuItem("Quevvec Editor", $MenuItem4)
$MenuItem24 = _GUICtrlCreateODMenuItem("Quevvec Messenger", $MenuItem4)
$MenuItem25 = _GUICtrlCreateODMenuItem("Quevvec To-Do", $MenuItem4)
$MenuItem5 = _GUICtrlCreateODMenu("Sidebar", $Label2context)
$MenuItem26 = _GUICtrlCreateODMenuItem("History", $MenuItem5, '', -1 , 1)
GUICtrlSetState(-1, $GUI_CHECKED)
$MenuItem27 = _GUICtrlCreateODMenuItem("Favourites", $MenuItem5, '', -1 , 1)
$MenuItem28 = _GUICtrlCreateODMenuItem("Search Assistant", $MenuItem5, '', -1 , 1)
$MenuItem6 = _GUICtrlCreateODMenu("Help", $Label2context)
$MenuItem31 = _GUICtrlCreateODMenuItem("Contents...", $MenuItem6)
$MenuItem30 = _GUICtrlCreateODMenuItem("", $MenuItem6)
$MenuItem29 = _GUICtrlCreateODMenuItem("About...", $MenuItem6)
$MenuItem7 = _GUICtrlCreateODMenuItem("Exit", $Label2context)
GUISetState(@SW_SHOW)
_ProcessURL(GUICtrlRead($URLBox))
ObjEvent($IE,"IE")
#EndRegion ### END Koda GUI section ###
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $Label7
			ExitLoop
		Case $Gobutton
			_ProcessURL(GUICtrlRead($URLBox))
		Case $MenuItem7
			ExitLoop
		Case $MenuItem18
			_ToggleSidebar()
		Case $MenuItem26
			_SidebarSet(2)
		Case $MenuItem27
			_SidebarSet(3)
		Case $MenuItem28
			_SidebarSet(4)
		Case $Label3
			$IE.back
		Case $Label11
			$IE.navigate2("browser://start")
		Case $Label10
			$IE.refresh
		Case $Label9
			$IE.cancel
		Case $Label8
			$IE.forward
	EndSwitch
	$mouse = GUIGetCursorInfo()
	If $mouse[2] = True Then
		Switch $mouse[4]
			Case $Label2
				GUICtrlSetBkColor($Label2,0xFFD700)
			Case $Label3
				GUICtrlSetBkColor($Label3,0xFFD700)
			Case $Gobutton
				GUICtrlSetBkColor($Gobutton,0xFFD700)
			Case $Label7
				GUICtrlSetBkColor($Label7,0xFFD700)
			Case $Label8
				GUICtrlSetBkColor($Label8,0xFFD700)
			Case $Label9
				GUICtrlSetBkColor($Label9,0xFFD700)
			Case $Label10
				GUICtrlSetBkColor($Label10,0xFFD700)
			Case $Label11
				GUICtrlSetBkColor($Label11,0xFFD700)
			Case $Label12
				GUICtrlSetBkColor($Label12,0xFFD700)
			Case Else
				;;
		EndSwitch
	Else
		GUICtrlSetBkColor($Label2,0xFFFFFF)
		GUICtrlSetBkColor($Label3,0xFFFFFF)
		GUICtrlSetBkColor($Gobutton,0xFFFFFF)
		GUICtrlSetBkColor($Label7,0xFFFFFF)
		GUICtrlSetBkColor($Label8,0xFFFFFF)
		GUICtrlSetBkColor($Label9,0xFFFFFF)
		GUICtrlSetBkColor($Label10,0xFFFFFF)
		GUICtrlSetBkColor($Label11,0xFFFFFF)
		GUICtrlSetBkColor($Label12,0xFFFFFF)
	EndIf
WEnd
Exit

Func IETitleChange($nt)
	If $nt <> $currenttitle Then
		$currenttitle = $nt
		GUICtrlSetData($Label1,"Quevvec Browser ("&$nt&")")
		GUICtrlSetData($Label13,$nt&$currentstatus)
		WinSetTitle($Form1,"",$nt)
	EndIf
EndFunc

Func IEStatusChange($ns)
	If $ns <> $currentstatus Then
		If $ns = "" Then
			$currentstatus = ""
			GUICtrlSetData($Label13,$currenttitle)
		Else
			$currentstatus = @CRLF&$ns
			GUICtrlSetData($Label13,$currenttitle&$currentstatus)
		EndIf
	EndIf
EndFunc

Func _ToggleSidebar()
	If BitAND(GUICtrlGetState($MenuItem18),$GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($Label5,$GUI_SHOW)
		GUICtrlSetState($Label12,$GUI_SHOW)
		$pos = ControlGetPos($Form1,"",GUICtrlGetHandle($Label14))
		GUICtrlSetPos($Label14,160,70,$pos[2]-70,$pos[3])
		If BitAND(GUICtrlGetState($MenuItem26),$GUI_CHECKED) = $GUI_CHECKED Then
			_SidebarSet(2)
		ElseIf BitAND(GUICtrlGetState($MenuItem27),$GUI_CHECKED) = $GUI_CHECKED Then
			_SidebarSet(3)
		ElseIf BitAND(GUICtrlGetState($MenuItem28),$GUI_CHECKED) = $GUI_CHECKED Then
			_SidebarSet(4)
		EndIf
		GUICtrlSetState($MenuItem18,$GUI_UNCHECKED)
	Else
		GUICtrlSetState($Label5,$GUI_HIDE)
		GUICtrlSetState($Label12,$GUI_HIDE)
		_SidebarSet(1)
		$pos = ControlGetPos($Form1,"",GUICtrlGetHandle($Label14))
		GUICtrlSetPos($Label14,0,70,$pos[2]+70,$pos[3])
		GUICtrlSetState($MenuItem18,$GUI_CHECKED)
	EndIf
EndFunc

Func _SidebarSet($n = 0)
	If $n = 1 Then
		GUICtrlSetState($SideBar_History,$GUI_HIDE)
		GUICtrlSetState($SideBar_Favourites,$GUI_HIDE)
		GUICtrlSetState($SideBar_SearchAsst,$GUI_HIDE)
		GUICtrlSetState($MenuItem26,$GUI_DISABLE+$GUI_UNCHECKED)
		GUICtrlSetState($MenuItem27,$GUI_DISABLE+$GUI_UNCHECKED)
		GUICtrlSetState($MenuItem28,$GUI_DISABLE+$GUI_UNCHECKED)
	ElseIf $n = 2 Then
		GUICtrlSetState($SideBar_History,$GUI_SHOW)
		GUICtrlSetState($SideBar_Favourites,$GUI_HIDE)
		GUICtrlSetState($SideBar_SearchAsst,$GUI_HIDE)
		GUICtrlSetState($MenuItem26,$GUI_ENABLE+$GUI_CHECKED)
		GUICtrlSetState($MenuItem27,$GUI_ENABLE+$GUI_UNCHECKED)
		GUICtrlSetState($MenuItem28,$GUI_ENABLE+$GUI_UNCHECKED)
	ElseIf $n = 3 Then
		GUICtrlSetState($SideBar_History,$GUI_HIDE)
		GUICtrlSetState($SideBar_Favourites,$GUI_SHOW)
		GUICtrlSetState($SideBar_SearchAsst,$GUI_HIDE)
		GUICtrlSetState($MenuItem26,$GUI_ENABLE+$GUI_UNCHECKED)
		GUICtrlSetState($MenuItem27,$GUI_ENABLE+$GUI_CHECKED)
		GUICtrlSetState($MenuItem28,$GUI_ENABLE+$GUI_UNCHECKED)
	ElseIf $n = 4 Then
		GUICtrlSetState($SideBar_History,$GUI_HIDE)
		GUICtrlSetState($SideBar_Favourites,$GUI_HIDE)
		GUICtrlSetState($SideBar_SearchAsst,$GUI_SHOW)
		GUICtrlSetState($MenuItem26,$GUI_ENABLE+$GUI_UNCHECKED)
		GUICtrlSetState($MenuItem27,$GUI_ENABLE+$GUI_UNCHECKED)
		GUICtrlSetState($MenuItem28,$GUI_ENABLE+$GUI_CHECKED)
	EndIf
EndFunc

Func _ProcessURL($url)
	$stringsplit = StringSplit($url,":")
	If $stringsplit[0] = 1 Then
		Select
			Case StringInStr($url,"@")
				_MAILGo("mailto://"&$url)
			Case StringLeft($url,3) = "ftp"
				_FTPGo("ftp://"&$url)
			Case StringLeft($url,3) = "www"
				_HTTPGo("http://"&$url)
			Case Else
				_HTTPGo("http://"&$url)
		EndSelect
	EndIf
	$protocol = $stringsplit[1]
	Switch $protocol
		Case "browser"
			_BROWSERGo($url)
		Case "about"
			_ABOUTGo($url)
		Case "http"
			_HTTPGo($url)
		Case "ftp"
			_FTPGo($url)
		Case "mailto"
			_MAILGo($url)
		Case "file"
			_FILEGo($url)
		Case "todo"
			_TODOGo($url)
		Case "autoit"
			_EasterEgg()
		Case "https"
			_HTTPSGo($url)
		Case Else
			_BlindGo($url)
	EndSwitch
EndFunc

Func _MAILGo($url)
	If $edition = "full" Then
		Run(@AutoItExe&" /mail "&StringReplace(StringReplace($mail,"mailto:",""),"//",""))
	Else
		_BROWSERGo("browser://upgrade/full")
	EndIf
EndFunc

Func _BROWSERGo($url)
	$bit = StringReplace(StringReplace($url,"browser:",""),"//","",1)
	_ProcessURL(Eval(IniRead(@ScriptFullPath&"\protocols\browser.dat",$bit,"/","""about:404""")))
EndFunc

Func _ABOUTGo($url)
	$bit = StringReplace(StringReplace($url,"about:",""),"//","",1)
	If $bit = "404" Then
		$IE.navigate2("about:blank")
		Sleep(500)
		$IE.document.write("<center><b><h2><font face=verdana>The browser can not find the requested page</font></h2></b></center>")
	EndIf
	_ProcessURL(Eval(IniRead(@ScriptFullPath&"\protocols\about.dat",$bit,"/","""about:404""")))
EndFunc

Func _Print()
	$IE.window.print()
EndFunc

Func _OFE()
	If $edition = "full" Then
		Run(@AutoItExe&" /edit """&$IE.location.href&""""
	Else
		_BROWSERGo("browser://upgrade/full")
	EndIf
EndFunc

Func _NewPage()
	If $edition = "full" Then
		Run(@AutoItExe&" /edit about:blank"
	Else
		_BROWSERGo("browser://upgrade/full")
	EndIf
EndFunc

Func _EasterEgg()
$Form2 = GUICreate("", @DesktopWidth, 42, 0, 0, BitOR($WS_POPUP,$WS_BORDER), BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
$Label1 = GUICtrlCreateLabel("Oi! You!", 0, 0, @DesktopWidth, 42, $ES_CENTER)
GUICtrlSetFont(-1, 24, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
Sleep(5000)
GUICtrlSetData($Label1,"Yes! You!")
Sleep(5000)
GUICtrlSetData($Label1,"I'm talking to you!")
Sleep(5000)
GUICtrlSetData($Label1,"Oh yes I am!")
Sleep(5000)
GUICtrlSetData($Label1,"And you can't close me!")
Sleep(5000)
GUICtrlSetData($Label1,"Oh no you can't!")
Sleep(5000)
GUICtrlSetData($Label1,"Cuz I wanna say something to you!")
Sleep(5000)
GUICtrlSetData($Label1,"A")
Sleep(250)
GUICtrlSetData($Label1,"Au")
Sleep(250)
GUICtrlSetData($Label1,"Aut")
Sleep(250)
GUICtrlSetData($Label1,"Auto")
Sleep(250)
GUICtrlSetData($Label1,"AutoI")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt ")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt R")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Ro")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Roc")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rock")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rocks")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rocks!")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rocks!!")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rocks!!!")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rocks!!!!")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rocks!")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rocks!!")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rocks!!!")
Sleep(250)
GUICtrlSetData($Label1,"AutoIt Rocks!!!!")
Sleep(5000)
GUICtrlSetData($Label1,"Now I will close!")
Sleep(5000)
GUIDelete($Form2)
EndFunc

Func _HTTPGo($url)
	$IE.navigate2($url)
EndFunc
Func _HTTPSGo($url)
	$IE.navigate2($url)
EndFunc
Func _FTPGo($url)
EndFunc
Func _FILEGo($url)
	$IE.navigate2($url)
EndFunc
Func _TODOGo($url)
	If $edition = "full" Then
		Run(@AutoItExe&" /todo "&StringReplace(StringReplace($mail,"todo:",""),"//",""))
	Else
		_BROWSERGo("browser://upgrade/full")
	EndIf
EndFunc
Func _BlindGo($url)
	$IE.navigate2($url)
EndFunc