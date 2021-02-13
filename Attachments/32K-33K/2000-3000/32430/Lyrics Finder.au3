OnAutoItExitRegister("_exit")
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <INet.au3>

Global $lyricData[2],$lyricOBJ

$Form1 = GUICreate("Lyric Finder", 625, 443, 294, 186)
$Edit1 = GUICtrlCreateEdit("", 272, 96, 337, 289,BitOR($ES_CENTER,$ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetFont(-1, 13, 800, 0, "vernada")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetLimit(-1, 35)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH)
GUICtrlSetData(-1, "")
$Pic1 = GUICtrlCreatePic("", 8, 96, 249, 289, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Label2 = GUICtrlCreateLabel("Song name:", 28, 32, 61, 17)
$Label3 = GUICtrlCreateLabel("Artist name:", 28, 56, 56, 17)
$songInput = GUICtrlCreateInput("", 88, 32, 249, 21)
$ArtistInput = GUICtrlCreateInput("", 88, 56, 249, 21)
$Button1 = GUICtrlCreateButton("Search", 344, 24, 105, 57, $WS_GROUP)
$Button2 = GUICtrlCreateButton("Exit", 464, 24, 105, 57, $WS_GROUP)
$Label4 = GUICtrlCreateLabel("By Foxhound. Lyric data provided through Chart Lyrics API. ", 64, 416, 400, 17)
GUISetState(@SW_SHOW)
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
    Case $GUI_EVENT_CLOSE
        Exit
Case $Button2
    Exit
Case $Button1
    ;array 0 = lyrics
    ;array 1 = Album Art
    $a= GUICtrlRead($ArtistInput)
    $s= GUICtrlRead($songInput)
    $rawData = getLyrics($a,$s)
FileDelete(@TempDir&"\CoverData.jpg")
InetGet($rawData[1],@TempDir&"\coverData.jpg")
GUICtrlSetData($Edit1,$rawData[0])
GUICtrlSetImage($Pic1,@TempDir&"\coverData.jpg")
EndSwitch
WEnd

Func getLyrics($a="",$s="")

$lyricURL = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist="&$a&"&song="&$s&"- CHART LYRICS API"
$data = _INetGetSource($lyricURL)
$lyricData[0] = _StringBetween2($data,"<Lyric>","</Lyric>")
$lyricData[1] = _StringBetween2($data,"<LyricCovertArtUrl>","</LyricCovertArtUrl>")
if StringLen($lyricData[0]) == 0 Then $lyricData[0] = "Lyrics not found. "
Return($lyricData)
EndFunc

Func _StringBetween2($s, $from, $to)
    ;This helpful function taken from: http://www.autoitscript.com/forum/index.php?sho wtopic=89554
    $x = StringInStr($s, $from) + StringLen($from)
    $y = StringInStr(StringTrimLeft($s, $x), $to)
    Return StringMid($s, $x, $y)
EndFunc

Func _exit()
    FileDelete(@TempDir&"\CoverData.jpg")
    Exit
EndFunc