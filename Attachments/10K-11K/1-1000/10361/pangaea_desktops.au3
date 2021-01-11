#include <GUIConstants.au3>
#Include <Constants.au3>
#NoTrayIcon
Opt("TrayMenuMode",1)

FileDelete(@tempdir & "\pangaeadesktops.ini")
HotKeySet("#{ESC}","_panic")
HotKeySet("#{LEFT}","_prevdesk")
HotKeySet("#{RIGHT}","_nextdesk")
HotKeySet("^#{LEFT}","_movetoprev")
HotKeySet("^#{RIGHT}","_movetonext")
HotKeySet("#{DOWN}", "_QuickSelect")

Global $activedesk = 1,$winlist[500],$hwnd,$textwin,$texton = 0,$texttime,$desktopitem, $inaction = 0

_winget()

$desktopitem = TrayCreateItem("Desktop " & $activedesk)
TrayItemSetState(-1,$TRAY_DISABLE)
TrayCreateItem("")
$nextitem = TrayCreateItem("Next desktop	    win + right")
$previtem = TrayCreateItem("Prev desktop	    win + left")
TrayCreateItem("")
$tonextitem = TrayCreateItem("Move to next desktop	   ctrl + win + right")
$toprevitem = TrayCreateItem("Move to prev desktop	   ctrl + win + left")
TrayCreateItem("")
$displayall = TrayCreateItem("Quick Desktop Select	    win + down")
TrayCreateItem("")
$aboutitem = TrayCreateItem("About")
$exititem  = TrayCreateItem("Exit	    win + esc")

TraySetState()

While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = $nextitem
			_nextdesk()
		Case $msg = $previtem
			_prevdesk()
		Case $msg = $tonextitem
			_movetonext()
		Case $msg = $toprevitem
			_movetoprev()
		Case $msg = $displayall
			_QuickSelect()
		Case $msg = $aboutitem
			Msgbox(64,"About:","Pangaea Desktops" & @crlf & "by Rakudave, Pangaea WorX 2006" & @crlf & @crlf & "www.pangaeaworx.ch.vu")
		Case $msg = $exititem
			_panic()
	EndSelect
	If $texton = 1 then
		If TimerDiff($texttime) > 2000 Then _text2()
	Endif
WEnd

Func _showwins()
	$var = IniReadSection(@tempdir & "\pangaeadesktops.ini", $activedesk)
	If @error Then 
		return
	Else
		For $x = 1 To $var[0][0]
			WinSetState($var[($var[0][0] +1) -$x][0],"",@SW_SHOW)
		Next
	EndIf
EndFunc   ;==>_showwins

Func _hidewins()
	$var = IniReadSection(@tempdir & "\pangaeadesktops.ini", $activedesk)
	If @error Then 
		return
	Else
		For $x = 1 To $var[0][0]
			WinSetState($var[($var[0][0] +1) -$x][0],"",@SW_HIDE)
		Next
	EndIf
EndFunc   ;==>_hidewins

Func _QuickSelect()
	If $inaction = 1 Then Return
	$inaction = 1
	For $i = 1 To 4
		If $activedesk = $i Then
			DllCall("captdll.dll", "int", "CaptureScreen", "str", @tempdir & "\pangaeaprtsc" & $i & ".jpg", "int", 85)
		Else
			_hidewins()
			$olddesk = $activedesk
			$activedesk = $i
			_showwins()
			DllCall("captdll.dll", "int", "CaptureScreen", "str", @tempdir & "\pangaeaprtsc" & $i & ".jpg", "int", 85)
			_hidewins()
			$activedesk = $olddesk
			_showwins()
		EndIf
	Next
	$hwnd = GUICreate("AnimatedWindow",@desktopwidth,@desktopheight,0,0,$WS_POPUP,$WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	$one = GUICtrlCreatePic(@tempdir & "\pangaeaprtsc1.jpg",0,0,@DesktopWidth/2,@DesktopHeight/2)
	$two = GUICtrlCreatePic(@tempdir & "\pangaeaprtsc2.jpg",@DesktopWidth/2,0,@DesktopWidth/2,@DesktopHeight/2)
	$three = GUICtrlCreatePic(@tempdir & "\pangaeaprtsc3.jpg",0,@DesktopHeight/2,@DesktopWidth/2,@DesktopHeight/2)
	$four = GUICtrlCreatePic(@tempdir & "\pangaeaprtsc4.jpg",@DesktopWidth/2,@DesktopHeight/2,@DesktopWidth/2,@DesktopHeight/2)
	GUISetState()
	While 1
		Switch GUIGetMsg()
			Case $one
				GUIDelete()
				_hidewins()
				$activedesk = 1
				_showwins()
				ExitLoop
			Case $two
				GUIDelete()
				_hidewins()
				$activedesk = 2
				_showwins()
				ExitLoop
			Case $three
				GUIDelete()
				_hidewins()
				$activedesk = 3
				_showwins()
				ExitLoop
			Case $four
				GUIDelete()
				_hidewins()
				$activedesk = 4
				_showwins()
				ExitLoop
		EndSwitch
	WEnd
	$inaction = 0
EndFunc   ;==>QuickSelect

Func _nextdesk()
	If $inaction = 1 then return
	$inaction = 1
	If $texton = 1 Then _text2()
	_winget()
	_animate1("r")
	_hidewins()
	$activedesk = $activedesk + 1
	If $activedesk = 5 Then $activedesk = 1
	_showwins()
	_animate2()
	$inaction = 0
	_text1()
EndFunc   ;==>_nextdesk

Func _prevdesk()
	If $inaction = 1 then return
	$inaction = 1
	If $texton = 1 Then _text2()
	_winget()
	_animate1("l")
	_hidewins()
	$activedesk = $activedesk - 1
	If $activedesk = 0 Then $activedesk = 4
	_showwins()
	_animate3()
	$inaction = 0
	_text1()
EndFunc   ;==>_prevdesk

Func _movetonext()
	If $inaction = 1 then return
	$inaction = 1
	_winget()
	IniDelete (@tempdir & "\pangaeadesktops.ini",$activedesk,$winlist[1])
	$activedesk = $activedesk + 1
	If $activedesk = 5 Then $activedesk = 1
	Iniwrite(@tempdir & "\pangaeadesktops.ini",$activedesk,$winlist[1],"moved")
	$activedesk = $activedesk - 1
	If $activedesk = 0 Then $activedesk = 4
	WinSetState($winlist[1],"",@SW_HIDE)
	$inaction = 0
	_nextdesk()
EndFunc   ;==>_movetonext

Func _movetoprev()
	If $inaction = 1 then return
	$inaction = 1
	_winget()
	IniDelete (@tempdir & "\pangaeadesktops.ini",$activedesk,$winlist[1])
	$activedesk = $activedesk - 1
	If $activedesk = 0 Then $activedesk = 4
	Iniwrite(@tempdir & "\pangaeadesktops.ini",$activedesk,$winlist[1],"moved")
	$activedesk = $activedesk + 1
	If $activedesk = 5 Then $activedesk = 1
	WinSetState($winlist[1],"",@SW_HIDE)
	$inaction = 0
	_prevdesk()
EndFunc   ;==>_movetoprev

Func _winget()
	$y = 0
	$var = WinList()
	IniDelete(@tempdir & "\pangaeadesktops.ini",$activedesk)
	For $x = 1 to $var[0][0]
		If $var[$x][0] <> "" AND IsVisible($var[$x][1]) AND $var[$x][0] <> "Program Manager" AND $var[$x][0] <> "Desktop 1" AND $var[$x][0] <> "Desktop 2" AND $var[$x][0] <> "Desktop 3" AND $var[$x][0] <> "Desktop 4" Then
			Iniwrite(@tempdir & "\pangaeadesktops.ini",$activedesk,$var[$x][0],$var[$x][1])
			$y = $y + 1
			$winlist[$y] = $var[$x][0]
		EndIf
	Next
	$winlist[0] = $y
EndFunc   ;==>_winget

Func _panic()
	for $y = 1 to 4
		$var = IniReadSection(@tempdir & "\pangaeadesktops.ini", $y)
		If @error = 0 then
			For $x = 1 To $var[0][0]
				WinSetState($var[($var[0][0] +1) -$x][0],"",@SW_SHOW)
			Next
		EndIf
	next
	FileDelete(@tempdir & "\pangaeadesktops.ini")
	FileDelete(@tempdir & "\pangaeaprtsc.jpg")
	FileDelete(@tempdir & "\pangaeaprtsc1.jpg")
	FileDelete(@tempdir & "\pangaeaprtsc2.jpg")
	FileDelete(@tempdir & "\pangaeaprtsc3.jpg")
	FileDelete(@tempdir & "\pangaeaprtsc4.jpg")
	exit
EndFunc   ;==>_panic

Func _animate1($direction)
	If $direction ="r" Then
		$activedesktemp = $activedesk + 1
		If $activedesktemp = 5 Then $activedesktemp = 1
	ElseIf $direction = "l" Then
		$activedesktemp = $activedesk - 1
		If $activedesktemp = 0 Then $activedesktemp = 4
	EndIf
	DllCall("captdll.dll", "int", "CaptureScreen", "str", @tempdir & "\pangaeaprtsc.jpg", "int", 85)
	DllCall("captdll.dll", "int", "CaptureScreen", "str", @tempdir & "\pangaeaprtsc" & $activedesktemp & ".jpg", "int", 85)
	$hwnd = GUICreate("AnimatedWindow",@desktopwidth,@desktopheight,0,0,$WS_POPUP,$WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	GUICtrlCreatePic(@tempdir & "\pangaeaprtsc.jpg",0,0,@desktopwidth,@desktopheight)
	GUISetState()
EndFunc   ;==>_animate1

Func _animate2()
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 500, "long", 0x00050002);slide out to left
	GUIDelete($hwnd)
EndFunc   ;==>_animate2

Func _animate3()
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 500, "long", 0x00050001);slide out to right
	GUIDelete($hwnd)
EndFunc   ;==>_animate3

Func _text1()
	$text = "Desktop " & $activedesk
	TrayItemSetText($desktopitem,$text)
	$textwin = TextWindow($text,600,40,"",-1,10,10,0xFF0000)
	GUISetState()
	$texton = 1
	$texttime = TimerInit()
EndFunc   ;==>_text1

Func _text2()
	GUIDelete($textwin)
	$texton = 0
EndFunc   ;==>_text2

Func OnAutoItExit()
	_panic()
EndFunc   ;==>OnAutoItExit

Func IsVisible($handle)
	If BitAnd(WinGetState($handle),2) Then 
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible

Func TextWindow($zText,$width,$height,$font="Microsoft Sans Serif",$weight=1000,$x=-1,$y=-1,$color=-1)
	Local Const $ANSI_CHARSET = 0
	Local Const $OUT_CHARACTER_PRECIS = 2
	Local Const $CLIP_DEFAULT_PRECIS = 0
	Local Const $PROOF_QUALITY = 2
	Local Const $FIXED_PITCH = 1
	Local Const $RGN_XOR = 3
	
	If $font = "" Then $font = "Microsoft Sans Serif"
	If $weight = -1 Then $weight = 1000
	Local $gui = GUICreate("Text Window",$width,$height,$x,$y,$WS_POPUP,$WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	If $color <> -1 Then GUISetBkColor($color)
	Local $hDC= DLLCall("user32.dll","int","GetDC","hwnd",$gui)
	Local $hMyFont = DLLCall("gdi32.dll","hwnd","CreateFont","int",$height, _
			"int",0,"int",0,"int",0,"int",1000,"int",0, _
			"int",0,"int",0,"int",$ANSI_CHARSET, _
			"int",$OUT_CHARACTER_PRECIS,"int",$CLIP_DEFAULT_PRECIS, _
			"int",$PROOF_QUALITY,"int",$FIXED_PITCH,"str",$font )
	Local $hOldFont = DLLCall("gdi32.dll","hwnd","SelectObject","int",$hDC[0], _
			"hwnd",$hMyFont[0])
	DLLCall("gdi32.dll","int","BeginPath","int",$hDC[0])
	DLLCall("gdi32.dll","int","TextOut","int",$hDC[0],"int",0,"int",0, _
			"str",$zText,"int",StringLen($zText))
	DLLCall("gdi32.dll","int","EndPath","int",$hDC[0])
	Local $hRgn1 = DLLCall("gdi32.dll","hwnd","PathToRegion","int",$hDC[0])
	Local $rc = DLLStructCreate("int;int;int;int")
	DLLCall("gdi32.dll","int","GetRgnBox","hwnd",$hRgn1[0], _
			"ptr",DllStructGetPtr($rc))
	Local $hRgn2 = DLLCall("gdi32.dll","hwnd","CreateRectRgnIndirect", _
			"ptr",DllStructGetPtr($rc))
	DLLCall("gdi32.dll","int","CombineRgn","hwnd",$hRgn2[0],"hwnd",$hRgn2[0], _
			"hwnd",$hRgn1[0],"int",$RGN_XOR)
	DLLCall("gdi32.dll","int","DeleteObject","hwnd",$hRgn1[0])
	DLLCall("user32.dll","int","ReleaseDC","hwnd",$gui,"int",$hDC[0])
	DLLCall("user32.dll","int","SetWindowRgn","hwnd",$gui,"hwnd",$hRgn2[0],"int",1)
	DLLCall("gdi32.dll","int","SelectObject","int",$hDC[0],"hwnd",$hOldFont[0])
	Return $gui
EndFunc   ;==>TextWindow