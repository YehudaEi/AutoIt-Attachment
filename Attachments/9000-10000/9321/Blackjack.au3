; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author: DiabloTM
;
; Script Function: Just another blackjack game.
;
;			("\(o.O)/")
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>
#NoTrayIcon
Opt("ColorMode", 1)
; == GUI generated with Koda ==
$Form1 = GUICreate("Blackjack", 493, 512, 189, 179)
GUISetBkColor(0x008000)
$btnNew = GUICtrlCreateButton("New Game", 190, 180, 100, 30)
$btnHit = GUICtrlCreateButton("Hit", 190, 230, 50, 30)
$btnStay = GUICtrlCreateButton("Stay", 240, 230, 50, 30)
$score = GUICtrlCreateLabel("", 85, 435, 100, 30, BitOR($SS_CENTER, $WS_BORDER, $SS_SUNKEN))
GUICtrlSetFont(-1, 18)
GUICtrlSetColor(-1, 0xDFD5A2)
$comScore = GUICtrlCreateLabel("", 305, 435, 100, 30, BitOR($SS_CENTER, $WS_BORDER, $SS_SUNKEN))
GUICtrlSetFont(-1, 18)
GUICtrlSetColor(-1, 0xDFD5A2)
$name = GUICtrlCreateLabel("", 160, 32, 110, 105)
GUICtrlSetData($name, IniRead("Blackjack.ini", "Name", "Name", "Player"))
GUICtrlSetFont(-1, 18, 400, 6, "Comic Sans MS")
GUICtrlSetColor(-1, 0x4E13FD)
$computer = GUICtrlCreateLabel("Computer", 330, 32, 110, 105)
GUICtrlSetFont(-1, 18, 400, 6, "Comic Sans MS")
GUICtrlSetColor(-1, 0x39E6EA)
$gamesWon = GUICtrlCreateLabel("0", 190, 70, 110, 105)
GUICtrlSetFont(-1, 18, 400, 2, "Comic Sans MS")
GUICtrlSetColor(-1, 0x4E13FD)
$comGamesWon = GUICtrlCreateLabel("0", 360, 70, 110, 105)
GUICtrlSetFont(-1, 18, 400, 2, "Comic Sans MS")
GUICtrlSetColor(-1, 0x39E6EA)

$hDLL = DllOpen("cards.dll")
$hdc = DllCall("user32.dll", "int", "GetDC", "hwnd", $Form1)
$hdc = $hdc[0]
DllCall($hDLL, "int", "cdtInit", "int_ptr", 0, "int_ptr", 0)
$x = 0
$y = 0

$NoOfCards = 0
$drawn = 0
$ace = 0
Dim $cards[52]
$i = 0
$noGamesWon = 0
Dim $repaint[20][2]

$comNoOfCards = 0
$comDrawn = 0
$comAce = 0
Dim $comCards[52]
$comI = 0
$comNoGamesWon = 0
Dim $comRepaint[20][2]
$comX = 0
$comY = 0

; create memory DC with size = size of client area of main window
Global $client_rect = WinGetClientSize($Form1)
Global $memory_dc = _CreateCompatibleDC($hdc)
Global $memory_bm = _CreateCompatibleBitmap($hdc, $client_rect[0], $client_rect[1])
_SelectObject($memory_dc, $memory_bm)

Global Const $WM_PAINT = 0x000F
GUIRegisterMsg($WM_PAINT, 'MY_WM_PAINT')

GUISetState(@SW_SHOW)

Func MY_WM_PAINT($hwnd, $msg, $wparam, $lparam)
;~  If $hwnd = $Form1 Then
;~         Switch $msg
;~             Case $WM_PAINT
	_RePaint()
;~             Return
;~         EndSwitch
;~  EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT

Func _RePaint()
	; copy content of Window DC to memory DC
	_BitBlt($memory_dc, 0, 0, $client_rect[0], $client_rect[1], $hdc, 0, 0)
	
	; add my painting stuff to content of memory DC
	DllCall($hDLL, "int", "cdtDraw", "int", $memory_dc, "int", 32, "int", 16, "int", 54, "int", 1, "int", 0xffffff)
	DllCall($hDLL, "int", "cdtDraw", "int", $memory_dc, "int", 40, "int", 24, "int", 54, "int", 1, "int", 0xffffff)
	DllCall($hDLL, "int", "cdtDraw", "int", $memory_dc, "int", 48, "int", 32, "int", 54, "int", 1, "int", 0xffffff)
	
	If $x = 0 Then
		;
	Else
		$z = 1
		Do
			If $repaint[$z][0] = 0 Then
				;
			Else
				DllCall($hDLL, "int", "cdtDraw", "int", $memory_dc, "int", $repaint[$z][0], "int", 320, "int", $repaint[$z][1], "int", 0, "int", 0xffffff)
			EndIf
			$z = $z + 1
		Until ($z = $y + 1)
	EndIf
	
	If $comX = 0 Then
		;
	Else
		$comZ = 1
		Do
			If $comRepaint[$comZ][0] = 0 Then
				;
			Else
				DllCall($hDLL, "int", "cdtDraw", "int", $memory_dc, "int", $comRepaint[$comZ][0], "int", 320, "int", $comRepaint[$comZ][1], "int", 0, "int", 0xffffff)
			EndIf
			$comZ = $comZ + 1
		Until ($comZ = $comY + 1)
	EndIf
	
	; copy changed content of memory DC back to Window DC
	_BitBlt($hdc, 0, 0, $client_rect[0], $client_rect[1], $memory_dc, 0, 0)
EndFunc   ;==>_RePaint

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $btnHit
			$y = $y + 1
			GUICtrlSetState($btnNew, $GUI_DISABLE)
			$draw = Random(1, 13, 1)
			$drawCard = $draw * 4 - 1 - Random(0, 3, 1)
			$placing = 50 + ($NoOfCards * 40)
			
			$repaint[$y][0] = $placing
			$repaint[$y][1] = $drawCard
			$x = 1
			
			
			If $draw = 11 Or $draw = 12 Or $draw = 13 Then $draw = 10
			If $draw = 1 Then
				$draw = 11
				$ace = $ace + 1
			EndIf
			
			$NoOfCards = $NoOfCards + 1
			$drawn = $draw + $drawn
			If $drawn > 21 Then
				;Check for aces.
				If $ace > 0 Then
					$drawn = $drawn - 10
					$ace = $ace - 1
					If $drawn > 21 Then
						GUICtrlSetState($btnNew, $GUI_ENABLE)
						GUICtrlSetState($btnHit, $GUI_DISABLE)
						GUICtrlSetState($btnStay, $GUI_DISABLE)
						GUICtrlSetState($name, $GUI_HIDE)
						GUICtrlSetState($computer, $GUI_HIDE)
						GUICtrlSetState($gamesWon, $GUI_HIDE)
						GUICtrlSetState($comGamesWon, $GUI_HIDE)
						$label = GUICtrlCreateLabel("Game over", 180, 60, 600, 120)
						GUICtrlSetFont(-1, 22, 400, 6, "Comic Sans MS")
						
						$comNoGamesWon = $comNoGamesWon + 1
						GUICtrlSetData($comGamesWon, $comNoGamesWon)
					EndIf
				Else
					GUICtrlSetState($btnNew, $GUI_ENABLE)
					GUICtrlSetState($btnHit, $GUI_DISABLE)
					GUICtrlSetState($btnStay, $GUI_DISABLE)
					GUICtrlSetState($name, $GUI_HIDE)
					GUICtrlSetState($computer, $GUI_HIDE)
					GUICtrlSetState($gamesWon, $GUI_HIDE)
					GUICtrlSetState($comGamesWon, $GUI_HIDE)
					$label = GUICtrlCreateLabel("Game over", 180, 60, 600, 120)
					GUICtrlSetFont(-1, 22, 400, 2, "Comic Sans MS")
					
					$comNoGamesWon = $comNoGamesWon + 1
					GUICtrlSetData($comGamesWon, $comNoGamesWon)
				EndIf
			EndIf
			GUICtrlSetData($score, $drawn)
		Case $msg = $btnStay
			Do
				$comY = $comY + 1
				$comDraw = Random(1, 13, 1)
				$comDrawCard = $comDraw * 4 - 1 - Random(0, 3, 1)
				$comPlacing = 270 + ($comNoOfCards * 40)
				
				$comRepaint[$comY][0] = $comPlacing
				$comRepaint[$comY][1] = $comDrawCard
				$comX = 1
				
				
				If $comDraw = 11 Or $comDraw = 12 Or $comDraw = 13 Then $comDraw = 10
				If $comDraw = 1 Then
					$comDraw = 11
					$comAce = $comAce + 1
				EndIf
				
				$comNoOfCards = $comNoOfCards + 1
				$comDrawn = $comDraw + $comDrawn
				If $comDrawn > 21 Then
					;Check for aces.
					If $comAce > 0 Then
						$comDrawn = $comDrawn - 10
						$comAce = $comAce - 1
					EndIf
				EndIf
				GUICtrlSetData($comScore, $comDrawn)
			until (($comDrawn > 16) And ($comDrawn > $drawn) Or ($comDrawn > $drawn))
			If $drawn > $comDrawn Then
				GUICtrlSetState($btnNew, $GUI_ENABLE)
				GUICtrlSetState($btnHit, $GUI_DISABLE)
				GUICtrlSetState($btnStay, $GUI_DISABLE)
				GUICtrlSetState($name, $GUI_HIDE)
				GUICtrlSetState($computer, $GUI_HIDE)
				GUICtrlSetState($gamesWon, $GUI_HIDE)
				GUICtrlSetState($comGamesWon, $GUI_HIDE)
				$label = GUICtrlCreateLabel("You Win", 180, 60, 600, 120)
				GUICtrlSetFont(-1, 22, 400, 2, "Comic Sans MS")
				$noGamesWon = $noGamesWon + 1
				GUICtrlSetData($gamesWon, $noGamesWon)
			ElseIf $drawn = $comDrawn Then
				GUICtrlSetState($btnNew, $GUI_ENABLE)
				GUICtrlSetState($btnHit, $GUI_DISABLE)
				GUICtrlSetState($btnStay, $GUI_DISABLE)
				GUICtrlSetState($name, $GUI_HIDE)
				GUICtrlSetState($computer, $GUI_HIDE)
				GUICtrlSetState($gamesWon, $GUI_HIDE)
				GUICtrlSetState($comGamesWon, $GUI_HIDE)
				$label = GUICtrlCreateLabel("Its a Tie", 180, 60, 600, 120)
				GUICtrlSetFont(-1, 22, 400, 2, "Comic Sans MS")
			ElseIf $comDrawn < 22 Then
				GUICtrlSetState($btnNew, $GUI_ENABLE)
				GUICtrlSetState($btnHit, $GUI_DISABLE)
				GUICtrlSetState($btnStay, $GUI_DISABLE)
				GUICtrlSetState($name, $GUI_HIDE)
				GUICtrlSetState($computer, $GUI_HIDE)
				GUICtrlSetState($gamesWon, $GUI_HIDE)
				GUICtrlSetState($comGamesWon, $GUI_HIDE)
				$label = GUICtrlCreateLabel("You Lose", 180, 60, 600, 120)
				GUICtrlSetFont(-1, 22, 400, 2, "Comic Sans MS")
				$comNoGamesWon = $comNoGamesWon + 1
				GUICtrlSetData($comGamesWon, $comNoGamesWon)
			Else ;com goes bust o.O
				GUICtrlSetState($btnNew, $GUI_ENABLE)
				GUICtrlSetState($btnHit, $GUI_DISABLE)
				GUICtrlSetState($btnStay, $GUI_DISABLE)
				GUICtrlSetState($name, $GUI_HIDE)
				GUICtrlSetState($computer, $GUI_HIDE)
				GUICtrlSetState($gamesWon, $GUI_HIDE)
				GUICtrlSetState($comGamesWon, $GUI_HIDE)
				$label = GUICtrlCreateLabel("You Win", 180, 60, 600, 120)
				GUICtrlSetFont(-1, 22, 400, 2, "Comic Sans MS")
				$noGamesWon = $noGamesWon + 1
				GUICtrlSetData($gamesWon, $noGamesWon)
			EndIf
		Case $msg = $btnNew
			$x = 0
			$y = 0
			$NoOfCards = 0
			$drawn = 0
			$ace = 0
			
			$comX = 0
			$comY = 0
			$comNoOfCards = 0
			$comDrawn = 0
			$comAce = 0
			
			GUICtrlSetState($label, $GUI_HIDE)
			GUICtrlSetState($name, $GUI_SHOW)
			GUICtrlSetState($computer, $GUI_SHOW)
			GUICtrlSetState($gamesWon, $GUI_SHOW)
			GUICtrlSetState($comGamesWon, $GUI_SHOW)
			GUICtrlSetData($score, "")
			GUICtrlSetData($comScore, "")
			GUICtrlSetState($btnHit, $GUI_ENABLE)
			GUICtrlSetState($btnStay, $GUI_ENABLE)
			DllCall("user32.dll", "int", "InvalidateRect", "hwnd", $Form1, "int", 0, "int", 1) ; lpRect=null bErase=True
		Case $msg = $name
			$winmove = WinGetPos("Blackjack")
			$PlayerName = InputBox("Name", "Enter your name", "", " M8", -1, 80, $winmove[0] + 120, $winmove[1] + 210)
			If $PlayerName = "" Then
			Else
				GUICtrlSetData($name, $PlayerName)
				IniWrite("Blackjack.ini", "Name", "Name", $PlayerName)
			EndIf
	EndSelect
	
	If WinActive( "Blackjack") = 0 Then
		WinWaitActive("Blackjack")
		DllCall("user32.dll", "int", "InvalidateRect", "hwnd", $Form1, "int", 0, "int", 1) ; lpRect=null bErase=True
	EndIf
WEnd


Func OnAutoItExit()
	DllCall($hDLL, "none", "cdtTerm")
	DllClose($hDLL)
	DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $Form1, "int", $hdc)
;~ 	DLLCall("user32.dll","int","ReleaseDC","hwnd",$Form1,"int",$memory_dc)
	_DeleteObject($memory_bm)
	_DeleteDC($memory_dc)
EndFunc   ;==>OnAutoItExit 

; == functions from gdi32.au3 ==

Func _CreateCompatibleDC($hdc, $dll_h = 'gdi32.dll')
;~ 	http://msdn.microsoft.com/library/en-us/gdi/devcons_499f.asp
	Local $ret = DllCall($dll_h, 'ptr', 'CreateCompatibleDC', 'ptr', $hdc)
	Return $ret[0]
EndFunc   ;==>_CreateCompatibleDC

Func _CreateCompatibleBitmap($hdc, $w, $h, $dll_h = 'Gdi32.dll')
;~ 	http://msdn.microsoft.com/library/en-us/gdi/bitmaps_1cxc.asp
	Local $ret = DllCall($dll_h, 'ptr', 'CreateCompatibleBitmap', _
			'ptr', $hdc, _
			'int', $w, _
			'int', $h)
	Return $ret[0]
EndFunc   ;==>_CreateCompatibleBitmap

Func _BitBlt($destination_hdc, $destination_x, $destination_y, $destination_width, $destination_height, _
		$source_hdc, $source_x, $source_y, $code = 0xCC0020, $dll_h = 'Gdi32.dll')
;~ 	Const $SRCCOPY = 0xCC0020
;~ 	http://msdn.microsoft.com/library/en-us/gdi/bitmaps_0fzo.asp
	Local $ret = DllCall($dll_h, 'int', 'BitBlt', _
			'ptr', $destination_hdc, _
			'int', $destination_x, _
			'int', $destination_y, _
			'int', $destination_width, _
			'int', $destination_height, _
			'ptr', $source_hdc, _
			'int', $source_x, _
			'int', $source_y, _
			'int', $code)
	Return $ret[0]
EndFunc   ;==>_BitBlt

Func _SelectObject($hdc, $hgdiobj, $dll_h = 'Gdi32.dll')
;~ 	http://msdn.microsoft.com/library/en-us/gdi/devcons_9v3o.asp
	Local $ret = DllCall($dll_h, 'hwnd', 'SelectObject', 'ptr', $hdc, 'hwnd', $hgdiobj)
	Return $ret[0]
EndFunc   ;==>_SelectObject

Func _DeleteObject($hObject, $dll_h = 'Gdi32.dll')
;~ 	http://msdn.microsoft.com/library/en-us/gdi/devcons_1vsk.asp
	Local $ret = DllCall($dll_h, 'int', 'DeleteObject', 'hwnd', $hObject)
	Return $ret[0]
EndFunc   ;==>_DeleteObject

Func _DeleteDC($hdc, $dll_h = 'Gdi32.dll')
;~ 	http://msdn.microsoft.com/library/en-us/gdi/devcons_2p2b.asp
	Local $ret = DllCall($dll_h, 'int', 'DeleteDC', 'ptr', $hdc)
	Return $ret[0]
EndFunc   ;==>_DeleteDC
