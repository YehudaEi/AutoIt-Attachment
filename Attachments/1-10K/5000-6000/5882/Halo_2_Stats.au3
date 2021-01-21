#include <File.au3>
#include <GUIConstants.au3>
#include <GuiListView.au3>

Dim $playlist[8]
Dim $playersIn[16][2]
Dim $players[16][9][6]
$playlist[0] = "Rumble Pit"
$playlist[1] = "Double Team"
$playlist[2] = "Team Slayer"
$playlist[3] = "Team Skirmish"
$playlist[4] = "Team Snipers"
$playlist[5] = "Team Hardcore"
$playlist[6] = "6v6 Team Battle"
$playlist[7] = "Big Team Battle"

$displayed = 0

$version = "0.4"

#region Gui Main
$gui = GUICreate("HaloIt v" & $version, 500, 400)
$top = 5
$left = 5
For $i = 0 To 15
	If $i = 8 Then
		$top = 5
		$left = 200
	EndIf
	$playersIn[$i][0] = GUICtrlCreateInput("", $left, $top, 150, 25)
	GUICtrlCreateLabel($i + 1, $left + 150, $top + 3)
	$playersIn[$i][1] = GUICtrlCreateButton("?", $left + 165, $top)
	GUICtrlSetState($playersIn[$i][1], $GUI_HIDE)
	$top += 25
Next
$left = 5
$top = 215
$go = GUICtrlCreateButton("Get Stats", $left, $top)
$pbarPlayer = GUICtrlCreateProgress($left, $top + 25, 200)
$pbarTotal = GUICtrlCreateProgress($left, $top + 50, 200)
GUICtrlCreateLabel("Current Player", $left + 205, $top + 30)
GUICtrlCreateLabel("Total Players", $left + 205, $top + 55)
$filemenu = GUICtrlCreateMenu("File")
$fileopen = GUICtrlCreateMenuItem("Open", $filemenu)
$filesave = GUICtrlCreateMenuItem("Save", $filemenu)
GUICtrlCreateMenuItem("", $filemenu)
$fileexit = GUICtrlCreateMenuItem("Exit", $filemenu)
$helpmenu = GUICtrlCreateMenu("Help")
$helpabout = GUICtrlCreateMenuItem("About", $helpmenu)
GUISetState()
#endregion

#region Gui Stats
$guistats = GUICreate("Stats for:", 500, 400, -1, -1, -1, -1, $gui)
$left = 5
$top = 5
$list = GUICtrlCreateListView("Playlist|Level|Experience|Played|Won|Win Percent", $left, $top, 490, 300)
$close = GUICtrlCreateButton("Close", $left + 450, $top + 370, 46)
$last = GUICtrlCreateButton("Previous", $left, $top + 305, 60)
$next = GUICtrlCreateButton("Next", $left + 60, $top + 305, 60)
#endregion


While 1
	$msg = GUIGetMsg(1)
	For $i = 0 To 15
		If $msg[0] = $playersIn[$i][1] Then
			DisplayStats($i)
		EndIf
	Next
	Switch ($msg[0])
		Case $GUI_EVENT_CLOSE, $fileexit, $close
			If $msg[1] = $gui Then
				Quit()
			Else
				HideStats()
			EndIf
		Case $go
			GetStats()
		Case $helpabout
			About()
		Case $filesave
			Save()
		Case $fileopen
			Open()
		Case $last
			LastPlayer()
		Case $next
			NextPlayer()
	EndSwitch
WEnd

Func DisplayStats($who)
	If $players[$who][0][0] <> "" Then
		_GuiCtrlListViewDeleteAllItems ($list)
		WinSetTitle("Stats", "", "Stats for: " & $players[$who][0][0])
		For $i = 1 To 8
			$string = $playlist[$i - 1] & "|" & $players[$who][$i][0] & "|" & $players[$who][$i][1] & "|" & $players[$who][$i][2] & "|" & $players[$who][$i][3] & "|" & $players[$who][$i][4]
			GUICtrlCreateListViewItem($string, $list)
		Next
		_GUICtrlListViewSetColumnWidth ($list, 0, $LVSCW_AUTOSIZE)
		GUISetState(@SW_SHOW, $guistats)
		$displayed = $who
	Else
		$displayed += 1
		NextPlayer()
	EndIf
EndFunc   ;==>DisplayStats
Func HideStats()
	_GuiCtrlListViewDeleteAllItems ($list)
	GUISetState(@SW_HIDE, $guistats)
EndFunc   ;==>HideStats
Func NextPlayer()
	If $displayed + 1 > 15 Then
		DisplayStats(0)
	Else
		DisplayStats($displayed + 1)
	EndIf
EndFunc   ;==>NextPlayer
Func LastPlayer()
	If $displayed - 1 < 0 Then
		DisplayStats(15)
	Else
		DisplayStats($displayed - 1)
	EndIf
EndFunc   ;==>LastPlayer
Func Save()
	$log = FileOpen(@ScriptDir & "\HaloIt.txt", 2)
	For $i = 0 To 15
		FileWriteLine($log, GUICtrlRead($playersIn[$i][0]))
	Next
	FileClose($log)
EndFunc   ;==>Save
Func Open()
	$log = FileOpen(@ScriptDir & "\HaloIt.txt", 0)
	For $i = 0 To 15
		$line = FileReadLine($log)
		GUICtrlSetData($playersIn[$i][0], $line)
	Next
	FileClose($log)
EndFunc   ;==>Open
Func AssignStats($num, $playerName, $stats)
	$players[$num][0][0] = $playerName
	$players[$num][1][0] = $stats[0][0]
	$players[$num][1][1] = $stats[0][1]
	$players[$num][1][2] = $stats[0][2]
	$players[$num][1][3] = $stats[0][3]
	$players[$num][1][4] = $stats[0][4]
	
	$players[$num][2][0] = $stats[1][0]
	$players[$num][2][1] = $stats[1][1]
	$players[$num][2][2] = $stats[1][2]
	$players[$num][2][3] = $stats[1][3]
	$players[$num][2][4] = $stats[1][4]
	
	$players[$num][3][0] = $stats[2][0]
	$players[$num][3][1] = $stats[2][1]
	$players[$num][3][2] = $stats[2][2]
	$players[$num][3][3] = $stats[2][3]
	$players[$num][3][4] = $stats[2][4]
	
	$players[$num][4][0] = $stats[3][0]
	$players[$num][4][1] = $stats[3][1]
	$players[$num][4][2] = $stats[3][2]
	$players[$num][4][3] = $stats[3][3]
	$players[$num][4][4] = $stats[3][4]
	
	$players[$num][5][0] = $stats[4][0]
	$players[$num][5][1] = $stats[4][1]
	$players[$num][5][2] = $stats[4][2]
	$players[$num][5][3] = $stats[4][3]
	$players[$num][5][4] = $stats[4][4]
	
	$players[$num][6][0] = $stats[5][0]
	$players[$num][6][1] = $stats[5][1]
	$players[$num][6][2] = $stats[5][2]
	$players[$num][6][3] = $stats[5][3]
	$players[$num][6][4] = $stats[5][4]
	
	$players[$num][7][0] = $stats[6][0]
	$players[$num][7][1] = $stats[6][1]
	$players[$num][7][2] = $stats[6][2]
	$players[$num][7][3] = $stats[6][3]
	$players[$num][7][4] = $stats[6][4]
	
	$players[$num][8][0] = $stats[7][0]
	$players[$num][8][1] = $stats[7][1]
	$players[$num][8][2] = $stats[7][2]
	$players[$num][8][3] = $stats[7][3]
	$players[$num][8][4] = $stats[7][4]
EndFunc   ;==>AssignStats

Func GetStats()
	$playerCount = 0
	GUICtrlSetData($pbarPlayer, 0)
	GUICtrlSetData($pbarTotal, 0)
	For $i = 0 To 15
		If GUICtrlRead($playersIn[$i][0]) <> "" Then
			$playerCount += 1
		EndIf
	Next
	For $i = 0 To $playerCount - 1
		If GUICtrlRead($playersIn[$i][0]) = "" Then
			MsgBox(0, "Error.", "Do not skip any lines!")
			ExitLoop
		EndIf
		$result = GetInfo(GUICtrlRead($playersIn[$i][0]))
		If $result <> 0 Then
			GUICtrlSetBkColor($playersIn[$i][0], 0x00FF00)
			GUICtrlSetState($playersIn[$i][1], $GUI_SHOW)
			GUICtrlSetData($pbarTotal, Int((($i + 1) / $playerCount) * 100))
			AssignStats($i, GUICtrlRead($playersIn[$i][0]), $result)
		EndIf
		If $result = 0 Then
			GUICtrlSetBkColor($playersIn[$i][0], 0xFF0000)
		EndIf
		GUICtrlSetData($pbarPlayer, 100)
	Next
	GUICtrlSetData($pbarPlayer, 0)
	GUICtrlSetData($pbarTotal, 0)
EndFunc   ;==>GetStats

Func GetInfo($name)
	Local $stats[8][5]
	Local $source
	$url = "http://www.bungie.net/Stats/PlayerStats.aspx?player=" & $name
	$file = @ScriptDir & "\" & $name & ".html"
	$size = InetGetSize($url)
	InetGet($url, $file, 0, 1)
	While @InetGetActive
		GUICtrlSetData($pbarPlayer, Int((@InetGetBytesRead / $size) * 100))
	WEnd
	_FileReadToArray($file, $source)
	If ArraySearch($source, "We don't have stats for this player") Then
		FileDelete($file)
		SetError(1)
		Return 0
	EndIf
	For $i = 0 To 7
		$gametype = ArraySearch($source, $playlist[$i])
		If Not StringInStr($source[$gametype + 5], "No Games Played") Then
			$temp = StringSplit($source[$gametype + 4], "<>")
			$level = $temp[5]
			$temp = StringSplit($source[$gametype + 7], '"')
			$exp = ($temp[8] / 50) * 100 & "%"
			$temp = StringSplit($source[$gametype + 14], "	<")
			$played = $temp[10]
			$temp = StringSplit($source[$gametype + 16], "	<")
			$won = $temp[10]
			$winpercent = Round(($won / $played) * 100, 2) & "%"
		Else
			$level = "No Games Played"
			$exp = "---"
			$played = "---"
			$won = "---"
			$winpercent = "---"
		EndIf
		$stats[$i][0] = $level
		$stats[$i][1] = $exp
		$stats[$i][2] = $played
		$stats[$i][3] = $won
		$stats[$i][4] = $winpercent
	Next
	FileDelete($file)
	Return $stats
EndFunc   ;==>GetInfo
Func ArraySearch($array, $what, $start = 0)
	For $i = $start To UBound($array) - 1
		If StringInStr($array[$i], $what) Then
			Return $i
		EndIf
	Next
	Return 0
EndFunc   ;==>ArraySearch
Func Display($what, $title = "")
	MsgBox(0, $title, $what)
EndFunc   ;==>Display
Func Quit()
	Exit
EndFunc   ;==>Quit
Func About()
	MsgBox(0, "About HaloIt", "HaloIt v" & $version & " was made with AutoIt3." & @CRLF & _
			"www.autoitscript.com" & @CRLF & _
			"Created by Sunblood" & @CRLF & _
			"12/27/2005")
EndFunc   ;==>About