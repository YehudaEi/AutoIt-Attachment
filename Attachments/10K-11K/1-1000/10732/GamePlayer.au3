#include <GUIConstants.au3>
#include <GuiList.au3>
#include <IE.au3>

Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode", 4)

Global $sHTML, $oFrame

_IEErrorHandlerRegister()
$oIE = _IECreateEmbedded()

$Taskbar = WinGetPos("classname=Shell_TrayWnd")
$DesktopHeight = $Taskbar[1] - 32
$DesktopWidth = @DesktopWidth - 6

$Form1 = GUICreate("AForm1", $DesktopWidth, $DesktopHeight, 0, 0)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
$GUIObj = GUICtrlCreateObj($oIE, 170, 10, $DesktopWidth - 180, $DesktopHeight - 20)
$List1 = GUICtrlCreateList("", 10, $DesktopHeight - 240, 150, 200, BitOR($LBS_SORT, $LBS_STANDARD, $WS_VSCROLL, $WS_BORDER))
$Button1 = GUICtrlCreateButton("Play Now!", 10, $DesktopHeight - 40, 90, 30)
GUICtrlSetOnEvent(-1, "_Launch")
$Label2 = GUICtrlCreateLabel("Game List", 10, $DesktopHeight - 270, 150, 25, $SS_CENTER)
GUICtrlSetFont(-1, 12, 800, 0, "Comic Sans MS")

_Populate()
_SetupIE()

GUISetState(@SW_SHOW)

While 1
	Sleep(100)
WEnd

Func _Populate()
	$aGames = IniReadSection("games.ini", "GAMES")
	For $i = 1 To $aGames[0][0]
		_GUICtrlListAddItem($List1, $aGames[$i][0])
	Next
EndFunc   ;==>_Populate

Func _SetupIE()
	_IENavigate($oIE, "about:blank")
	$sHTML = ""
	$sHTML &= '<html>' & @CRLF
	$sHTML &= '<body bgcolor="#C0C0C0">' & @CRLF
	$sHTML &= '<table border="0" width="100%" height="100%" id="table1">' & @CRLF
	$sHTML &= '	<tr>' & @CRLF
	$sHTML &= '		<td align="center">' & @CRLF
	$sHTML &= '		<p align="center"><iframe name="I1" src="about:blank" scrolling="no" border="0" frameborder="0" height="400" width="600">' & @CRLF
	$sHTML &= '		</iframe></td></p>' & @CRLF
	$sHTML &= '	</tr>' & @CRLF
	$sHTML &= '</table>' & @CRLF
	$sHTML &= '</body>' & @CRLF
	$sHTML &= '</html>' & @CRLF
	_IEDocWriteHTML($oIE, $sHTML)
	_IEAction($oIE, "refresh")
	$oFrame = _IEGetObjByName($oIE, "I1")
EndFunc   ;==>_SetupIE

Func _Launch()
	$i_Name = _GUICtrlListSelectedIndex($List1)
	If $i_Name = $LB_ERR Then
		MsgBox(48, "Error", "You must first select a game.")
		Return 0
	EndIf
	$s_Name = _GUICtrlListGetText($List1, $i_Name)
	$s_Info = IniRead("games.ini", "GAMES", $s_Name, "")
	If $s_Info = "" Then
		MsgBox(48, "Error", "Selected game not found.")
		Return 0
	EndIf
	
	_SetupIE()
	
	$aInfo = StringSplit($s_Info, ",")
	$oFrame.width = $aInfo[2]
	$oFrame.height = $aInfo[3]
	$oFrame.navigate ($aInfo[1])
EndFunc   ;==>_Launch

Func _Exit()
	Exit
EndFunc   ;==>_Exit