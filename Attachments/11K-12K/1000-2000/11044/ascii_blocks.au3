#NoTrayIcon
#include <GUIConstants.au3>

#region Graphics Table
Dim $aTable[96] = [ _
	0x0000000, _ ;  => 00000 00000 00000 00000 00000
	0x0210802, _ ;! => 00010 00010 00010 00000 00010
	0x0A50000, _ ;" => 01010 01010 00000 00000 00000
	0x0AFABEA, _ ;# => 01010 11111 01010 11111 01010
	0x07618AE, _ ;$ => 00111 01100 00110 00101 01110
	0x19D1173, _ ;% => 11001 11010 00100 01011 10011
	0x06415CD, _ ;& => 00110 01000 00101 01110 01101
	0x0420000, _ ;' => 00100 00100 00000 00000 00000
	0x0221082, _ ;( => 00010 00100 00100 00100 00010
	0x0821088, _ ;) => 01000 00100 00100 00100 01000
	0x04ABAA4, _ ;* => 00100 10101 01110 10101 00100
	0x0427C84, _ ;+ => 00100 00100 11111 00100 00100
	0x0000088, _ ;, => 00000 00000 00000 00100 01000
	0x0007C00, _ ;- => 00000 00000 11111 00000 00000
	0x0000004, _ ;& => 00000 00000 00000 00000 00100
	0x0111110, _ ;/ => 00001 00010 00100 01000 10000
	0x064A526, _ ;0 => 00110 01001 01001 01001 00110
	0x0230847, _ ;1 => 00010 00110 00010 00010 00111
	0x0E0990F, _ ;2 => 01110 00001 00110 01000 01111
	0x0E0B82E, _ ;3 => 01110 00001 01110 00001 01110
	0x0A529E2, _ ;4 => 01010 01010 01010 01111 00010
	0x0F4382E, _ ;5 => 01111 01000 01110 00001 01110
	0x0643926, _ ;6 => 00110 01000 01110 01001 00110
	0x0F08884, _ ;7 => 01111 00001 00010 00100 00100
	0x0649926, _ ;8 => 00110 01001 00110 01001 00110
	0x0649C26, _ ;9 => 00110 01001 00111 00001 00110
	0x0040100, _ ;: => 00000 01000 00000 01000 00000
	0x0020088, _ ;; => 00000 00100 00000 00100 01000
	0x0111041, _ ;< => 00001 00010 00100 00010 00001
	0x00781E0, _ ;= => 00000 01111 00000 01111 00000
	0x0820888, _ ;> => 01000 00100 00010 00100 01000
	0x0228804, _ ;? => 00010 00101 00010 00000 00100
	0x0EBE6EE, _ ;@ => 01110 10111 11001 10111 01110
	0x064BD29, _ ;A => 00110 01001 01111 01001 01001
	0x0E4B92E, _ ;B => 01110 01001 01110 01001 01110
	0x064A126, _ ;C => 00110 01001 01000 01001 00110
	0x0E4A52E, _ ;D => 01110 01001 01001 01001 01110
	0x0F43D0F, _ ;E => 01111 01000 01111 01000 01111
	0x0F43D08, _ ;F => 01111 01000 01111 01000 01000
	0x0742D26, _ ;G => 00111 01000 01011 01001 00110
	0x094BD29, _ ;H => 01001 01001 01111 01001 01001
	0x0210842, _ ;I => 00010 00010 00010 00010 00010
	0x0108526, _ ;J => 00001 00001 00001 01001 00110
	0x0953149, _ ;K => 01001 01010 01100 01010 01001
	0x084210F, _ ;L => 01000 01000 01000 01000 01111
	0x11DD631, _ ;M => 10001 11011 10101 10001 10001
	0x11CD671, _ ;N => 10001 11001 10101 10011 10001
	0x064A526, _ ;O => 00110 01001 01001 01001 00110
	0x0E4B908, _ ;P => 01110 01001 01110 01000 01000
	0x064A567, _ ;Q => 00110 01001 01001 01011 00111
	0x0E4B949, _ ;R => 01110 01001 01110 01010 01001
	0x074182E, _ ;S => 00111 01000 00110 00001 01110
	0x0710842, _ ;T => 00111 00010 00010 00010 00010
	0x094A526, _ ;U => 01001 01001 01001 01001 00110
	0x118A944, _ ;V => 10001 10001 01010 01010 00100
	0x11AD6AA, _ ;W => 10001 10101 10101 10101 01010
	0x1151151, _ ;X => 10001 01010 00100 01010 10001
	0x1151084, _ ;Y => 10001 01010 00100 00100 00100
	0x0F0888F, _ ;Z => 01111 00001 00010 00100 01111
	0x0621086, _ ;[ => 00110 00100 00100 00100 00110
	0x1041041, _ ;\ => 10000 01000 00100 00010 00001
	0x0610846, _ ;] => 00110 00010 00010 00010 00010
	0x0454400, _ ;^ => 00100 01010 10001 00000 00000
	0x000000F, _ ;_ => 00000 00000 00000 00000 01111
	0x0420000, _ ;' => 00100 00100 00000 00000 00000
	0x0609D27, _ ;a => 00110 00001 00111 01001 00111
	0x084392E, _ ;b => 01000 01000 01110 01001 01110
	0x003A107, _ ;c => 00000 00111 01000 01000 00111
	0x0109D27, _ ;d => 00001 00001 00111 01001 00111
	0x064BD06, _ ;e => 00110 01001 01111 01000 00110
	0x0321884, _ ;f => 00011 00100 00110 00100 00100
	0x0749C26, _ ;g => 00111 01001 00111 00001 00110
	0x0843929, _ ;h => 01000 01000 01110 01001 01001
	0x0200842, _ ;i => 00010 00000 00010 00010 00010
	0x0200946, _ ;j => 00010 00000 00010 01010 00110
	0x04214C5, _ ;k => 00100 00100 00101 00110 00101
	0x0610847, _ ;l => 00110 00010 00010 00010 00111
	0x00556B5, _ ;m => 00000 01010 10101 10101 10101
	0x0032529, _ ;n => 00000 00110 01001 01001 01001
	0x0032526, _ ;o => 00000 00110 01001 01001 00110
	0x064B908, _ ;p => 00110 01001 01110 01000 01000
	0x0649C21, _ ;q => 00110 01001 00111 00001 00001
	0x0032108, _ ;r => 00000 00110 01000 01000 01000
	0x0320826, _ ;s => 00011 00100 00010 00001 00110
	0x0238843, _ ;t => 00010 00111 00010 00010 00011
	0x004A527, _ ;u => 00000 01001 01001 01001 00111
	0x008C544, _ ;v => 00000 10001 10001 01010 00100
	0x008D6AA, _ ;w => 00000 10001 10101 10101 01010
	0x0049929, _ ;x => 00000 01001 00110 01001 01001
	0x004A4CC, _ ;y => 00000 01001 01001 00110 01100
	0x0078D8F, _ ;z => 00000 01111 00011 01100 01111
	0x0311043, _ ;{ => 00011 00010 00100 00010 00011
	0x0210842, _ ;| => 00010 00010 00010 00010 00010
	0x0C2088C, _ ;} => 01100 00100 00010 00100 01100
	0x0045440, _ ;~ => 00000 01000 10101 00010 00000
	0x0F4A52F  _ ; => 01111 01001 01001 01001 01111
]
#endregion

#region GUI
$GUI = GUICreate("ASCII Blocks", 400, 245)
GUICtrlCreateLabel("Text:", 10, 13, 30, 15)
$TextInput = GUICtrlCreateInput("", 45, 10, 345, 20)
GUICtrlCreateLabel("Border: ", 10, 38, 35, 15)
$BorderCombo = GUICtrlCreateCombo("", 45, 35, 40, 20)
GUICtrlCreateLabel("Block: ", 90, 38, 30, 15)
$BlockCombo = GUICtrlCreateCombo("", 125, 35, 40, 20)
GUICtrlCreateLabel("Shade: ", 170, 38, 35, 15)
$ShadeCombo = GUICtrlCreateCombo("", 210, 35, 40, 20)
GUICtrlCreateLabel("Format: ", 260, 38, 40, 15)
$FormatCombo = GUICtrlCreateCombo("", 305, 35, 85, 20)
GUICtrlSetData($BorderCombo, "0|1|2", "2")
GUICtrlSetData($BlockCombo, "0|1|2|3|4", "4")
GUICtrlSetData($ShadeCombo, "0|1|2|3|4", "1")
GUICtrlSetData($FormatCombo, "ANSI|Unicode", "Unicode")
$Edit = GUICtrlCreateEdit("", 10, 65, 380, 135, BitOr($WS_HSCROLL, $ES_READONLY))
GUICtrlSetFont($Edit, 12, 400, -1, "Terminal")
$GenerateButton = GUICtrlCreateButton("Generate", 10, 205, 95, 30)
$CopyButton = GUICtrlCreateButton("Copy", 105, 205, 95, 30)
$SaveButton = GUICtrlCreateButton("Save", 200, 205, 95, 30)
$ExitButton = GUICtrlCreateButton("Exit", 295, 205, 95, 30)
GUICtrlSetState($TextInput, $GUI_FOCUS)
GUISetState()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ExitButton
			Exit
		Case $GenerateButton
			GUICtrlSetData ($Edit, CreateBlock(GUICtrlRead($TextInput), GUICtrlRead($BorderCombo), GUICtrlRead($BlockCombo), GUICtrlRead($ShadeCombo)))
		Case $CopyButton
			_BlockToClip ()
		Case $SaveButton
			_SaveBlock ()
	EndSwitch
WEnd
#endregion

#region GUI functions
Func _SaveBlock ()
	If GUICtrlRead($FormatCombo) = "ANSI" Then
		$szFileName = FileSaveDialog("ASCII Blocks", "", "NFO (*.nfo)|Texto (*.txt)", 16, "AsciiBlock.nfo")
		If @error Then Return 0
		_BlockToFile ($szFileName)
	Else
		$szFileName = FileSaveDialog("ASCII Blocks", "", "TXT (*.txt)|NFO (*.nfo)", 16, "AsciiBlock.txt")
		If @error Then Return 0
		_BlockToFileW ($szFileName)
	EndIf
EndFunc
Func _BlockToFile ($szFileName)
	Local $szText = GUICtrlRead($TextInput)
	Local $iBorder = GUICtrlRead($BorderCombo)
	Local $iBlock = GUICtrlRead($BlockCombo)
	Local $iShade = GUICtrlRead($ShadeCombo)
	Local $hFile = FileOpen ($szFileName, 2)
	If $hFile = -1 Then Return 0
	FileWrite ($hFile, CreateBlock ($szText, $iBorder, $iBlock, $iShade))
	FileClose ($hFile)
EndFunc
Func _BlockToFileW ($szFileName)
	Local $szText = GUICtrlRead($TextInput)
	Local $iBorder = GUICtrlRead($BorderCombo)
	Local $iBlock = GUICtrlRead($BlockCombo)
	Local $iShade = GUICtrlRead($ShadeCombo)
	Local $stFinal = CreateBlockW ($szText, $iBorder, $iBlock, $iShade)
	Local $hFile = DllCall ("msvcrt.dll", "long", "fopen", "str", $szFileName, "str", "wb+")
	If Not $hFile[0] Then Return 0
	DllCall ("msvcrt.dll", "long", "fprintf", "long", $hFile[0], "str", "%c%c", "short", 0xFF, "short", 0xFE)
	DllCall ("msvcrt.dll", "long", "fwrite", "ptr", DllStructGetPtr($stFinal), "long", 1, "long", DllStructGetSize($stFinal), "long", $hFile[0])
	DllCall ("msvcrt.dll", "long", "fclose", "long", $hFile[0])
EndFunc
Func _BlockToClip ()
	Local $szText = GUICtrlRead($TextInput)
	Local $iBorder = GUICtrlRead($BorderCombo)
	Local $iBlock = GUICtrlRead($BlockCombo)
	Local $iShade = GUICtrlRead($ShadeCombo)
	If GUICtrlRead($FormatCombo) = "ANSI" Then
		ClipPut (CreateBlock ($szText, $iBorder, $iBlock, $iShade))
	Else
		_ClipPutW (CreateBlockW ($szText, $iBorder, $iBlock, $iShade))
	EndIf
EndFunc
#endregion

#region Core functions
Func CreateBlock ($szLine, $iBorder, $iBlock, $iShade)
	Local Const $ATOP_LEFT1 = 0xDA
	Local Const $ATOP_LEFT2 = 0xC9
	Local Const $ATOP_RIGHT1 = 0xBF
	Local Const $ATOP_RIGHT2 = 0xBB
	Local Const $ABOTTOM_LEFT1 = 0xC0
	Local Const $ABOTTOM_LEFT2 = 0xC8
	Local Const $ABOTTOM_RIGHT1 = 0xD9
	Local Const $ABOTTOM_RIGHT2 = 0xBC
	Local Const $AHORIZONTAL_BAR1 = 0xC4
	Local Const $AHORIZONTAL_BAR2 = 0xCD
	Local Const $AVERTICAL_BAR1 = 0xB3
	Local Const $AVERTICAL_BAR2 = 0xBA
	Local Const $ABLOCK0 = 0xFF
	Local Const $ABLOCK1 = 0xB0
	Local Const $ABLOCK2 = 0xB1
	Local Const $ABLOCK3 = 0xB2
	Local Const $ABLOCK4 = 0xDB
	
	$iLength = StringLen($szLine)
	$szFinal = ""

	;First line
	If ($iBorder == 1) Then $szFinal &= Chr($ATOP_LEFT1)
	If ($iBorder == 2) Then $szFinal &= Chr($ATOP_LEFT2)
	For $i = 1 To ($iLength*5)
		If ($iBorder == 1) Then $szFinal &= Chr($AHORIZONTAL_BAR1)
		If ($iBorder == 2) Then $szFinal &= Chr($AHORIZONTAL_BAR2)
	Next
	If ($iBorder == 1) Then $szFinal &= Chr($ATOP_RIGHT1)
	If ($iBorder == 2) Then $szFinal &= Chr($ATOP_RIGHT2)
	$szFinal &= @CRLF;

	For $j = 1 To 5
		If ($iBorder == 1) Then $szFinal &= Chr($AVERTICAL_BAR1)
		If ($iBorder == 2) Then $szFinal &= Chr($AVERTICAL_BAR2)
		
		For $i = 1 To $iLength
			$iNowLetter = 95
			If (Asc(StringMid($szLine, $i, 1)) < 128) Then
				$iNowLetter = Asc(StringMid($szLine, $i, 1)) - 32
			EndIf
			$iNowRow = BitAND(BitShIft($aTable[$iNowLetter], 20-(($j-1)*5)), 0x1F)
			
			For $k = 0 To 4
				If (BitAND(BitShIft($iNowRow, (4-$k)), 0x01) == 1) Then
					If ($iBlock == 0) Then $szFinal &= Chr($ABLOCK0)
					If ($iBlock == 1) Then $szFinal &= Chr($ABLOCK1)
					If ($iBlock == 2) Then $szFinal &= Chr($ABLOCK2)
					If ($iBlock == 3) Then $szFinal &= Chr($ABLOCK3)
					If ($iBlock == 4) Then $szFinal &= Chr($ABLOCK4)
				Else
					If ($iShade == 0) Then $szFinal &= Chr($ABLOCK0)
					If ($iShade == 1) Then $szFinal &= Chr($ABLOCK1)
					If ($iShade == 2) Then $szFinal &= Chr($ABLOCK2)
					If ($iShade == 3) Then $szFinal &= Chr($ABLOCK3)
					If ($iShade == 4) Then $szFinal &= Chr($ABLOCK4)
				EndIf
			Next
		Next
		If ($iBorder == 1) Then $szFinal &= Chr($AVERTICAL_BAR1)
		If ($iBorder == 2) Then $szFinal &= Chr($AVERTICAL_BAR2)

		;End each line with CRLF
		$szFinal &= @CRLF
	Next

	;Last line
	If ($iBorder == 1) Then $szFinal &= Chr($ABOTTOM_LEFT1)
	If ($iBorder == 2) Then $szFinal &= Chr($ABOTTOM_LEFT2)
	For $i = 1 To ($iLength*5)
		If ($iBorder == 1) Then $szFinal &= Chr($AHORIZONTAL_BAR1)
		If ($iBorder == 2) Then $szFinal &= Chr($AHORIZONTAL_BAR2)
	Next
	If ($iBorder == 1) Then $szFinal &= Chr($ABOTTOM_RIGHT1)
	If ($iBorder == 2) Then $szFinal &= Chr($ABOTTOM_RIGHT2)

	Return $szFinal
EndFunc
Func CreateBlockW ($szLine, $iBorder, $iBlock, $iShade)
	Local Const $WTOP_LEFT1 = 0x250C
	Local Const $WTOP_LEFT2 = 0x2554
	Local Const $WTOP_RIGHT1 = 0x2510
	Local Const $WTOP_RIGHT2 = 0x2557
	Local Const $WBOTTOM_LEFT1 = 0x2514
	Local Const $WBOTTOM_LEFT2 = 0x255A
	Local Const $WBOTTOM_RIGHT1 = 0x2518
	Local Const $WBOTTOM_RIGHT2 = 0x255D
	Local Const $WHORIZONTAL_BAR1 = 0x2500
	Local Const $WHORIZONTAL_BAR2 = 0x2550
	Local Const $WVERTICAL_BAR1 = 0x2502
	Local Const $WVERTICAL_BAR2 = 0x2551
	Local Const $WBLOCK0 = 0x00A0
	Local Const $WBLOCK1 = 0x2591
	Local Const $WBLOCK2 = 0x2592
	Local Const $WBLOCK3 = 0x2593
	Local Const $WBLOCK4 = 0x2588
	
	$iLength = StringLen($szLine)
	$iFinalSize = ($iLength+1)*7*5
	$szFinal = DllStructCreate("ushort[" & $iFinalSize & "]")
	$iCount = 1

	;First line
	If ($iBorder == 1) Then
		DllStructSetData ($szFinal, 1, $WTOP_LEFT1, $iCount)
		$iCount += 1
	ElseIf ($iBorder == 2) Then
		DllStructSetData ($szFinal, 1, $WTOP_LEFT2, $iCount)
		$iCount += 1
	EndIf
	For $i = 1 To ($iLength*5)
		If ($iBorder == 1) Then
			DllStructSetData ($szFinal, 1, $WHORIZONTAL_BAR1, $iCount)
			$iCount += 1
		ElseIf ($iBorder == 2) Then
			DllStructSetData ($szFinal, 1, $WHORIZONTAL_BAR2, $iCount)
			$iCount += 1
		EndIf
	Next
	If ($iBorder == 1) Then
		DllStructSetData ($szFinal, 1, $WTOP_RIGHT1, $iCount)
		$iCount += 1
	ElseIf ($iBorder == 2) Then
		DllStructSetData ($szFinal, 1, $WTOP_RIGHT2, $iCount)
		$iCount += 1
	EndIf
	DllStructSetData ($szFinal, 1, Asc(@CR), $iCount)
	$iCount += 1
	DllStructSetData ($szFinal, 1, Asc(@LF), $iCount)
	$iCount += 1
	
	For $j = 1 To 5
		If ($iBorder == 1) Then
			DllStructSetData ($szFinal, 1, $WVERTICAL_BAR1, $iCount)
			$iCount += 1
		ElseIf ($iBorder == 2) Then
			DllStructSetData ($szFinal, 1, $WVERTICAL_BAR2, $iCount)
			$iCount += 1
		EndIf
		
		For $i = 1 To $iLength
			$iNowLetter = 95
			If (Asc(StringMid($szLine, $i, 1)) < 128) Then
				$iNowLetter = Asc(StringMid($szLine, $i, 1)) - 32
			EndIf
			$iNowRow = BitAND(BitShIft($aTable[$iNowLetter], 20-(($j-1)*5)), 0x1F)
			
			For $k = 0 To 4
				If (BitAND(BitShIft($iNowRow, (4-$k)), 0x01) == 1) Then
					If ($iBlock == 0) Then DllStructSetData ($szFinal, 1, $WBLOCK0, $iCount)
					If ($iBlock == 1) Then DllStructSetData ($szFinal, 1, $WBLOCK1, $iCount)
					If ($iBlock == 2) Then DllStructSetData ($szFinal, 1, $WBLOCK2, $iCount)
					If ($iBlock == 3) Then DllStructSetData ($szFinal, 1, $WBLOCK3, $iCount)
					If ($iBlock == 4) Then DllStructSetData ($szFinal, 1, $WBLOCK4, $iCount)
					$iCount += 1
				Else
					If ($iShade == 0) Then DllStructSetData ($szFinal, 1, $WBLOCK0, $iCount)
					If ($iShade == 1) Then DllStructSetData ($szFinal, 1, $WBLOCK1, $iCount)
					If ($iShade == 2) Then DllStructSetData ($szFinal, 1, $WBLOCK2, $iCount)
					If ($iShade == 3) Then DllStructSetData ($szFinal, 1, $WBLOCK3, $iCount)
					If ($iShade == 4) Then DllStructSetData ($szFinal, 1, $WBLOCK4, $iCount)
					$iCount += 1
				EndIf
			Next
		Next
		If ($iBorder == 1) Then
			DllStructSetData ($szFinal, 1, $WVERTICAL_BAR1, $iCount)
			$iCount += 1
		ElseIf ($iBorder == 2) Then
			DllStructSetData ($szFinal, 1, $WVERTICAL_BAR2, $iCount)
			$iCount += 1
		EndIf

		;End each line with CRLF
		DllStructSetData ($szFinal, 1, Asc(@CR), $iCount)
		$iCount += 1
		DllStructSetData ($szFinal, 1, Asc(@LF), $iCount)
		$iCount += 1
	Next

	;Last line
	If ($iBorder == 1) Then
		DllStructSetData ($szFinal, 1, $WBOTTOM_LEFT1, $iCount)
		$iCount += 1
	ElseIf ($iBorder == 2) Then
		DllStructSetData ($szFinal, 1, $WBOTTOM_LEFT2, $iCount)
		$iCount += 1
	EndIf
	For $i = 1 To ($iLength*5)
		If ($iBorder == 1) Then
			DllStructSetData ($szFinal, 1, $WHORIZONTAL_BAR1, $iCount)
			$iCount += 1
		ElseIf ($iBorder == 2) Then
			DllStructSetData ($szFinal, 1, $WHORIZONTAL_BAR2, $iCount)
			$iCount += 1
		EndIf
	Next
	If ($iBorder == 1) Then
		DllStructSetData ($szFinal, 1, $WBOTTOM_RIGHT1, $iCount)
		$iCount += 1
	ElseIf ($iBorder == 2) Then
		DllStructSetData ($szFinal, 1, $WBOTTOM_RIGHT2, $iCount)
		$iCount += 1
	EndIf
	
	Return $szFinal
EndFunc
Func _ClipPutW ($szStruct)
	Local Const $GMEM_MOVEABLE = 0x02
	Local Const $CF_UNICODETEXT = 0x0D
	Local $hClipMem = DllCall ("KERNEL32.dll", "hwnd", "GlobalAlloc", "int", $GMEM_MOVEABLE, "long", DllStructGetSize($szStruct))
	Local $pClipMem = DllCall ("KERNEL32.dll", "ptr", "GlobalLock", "hwnd", $hClipMem[0])
	DllCall ("msvcrt.dll", "ptr", "memcpy", "ptr", $pClipMem[0], "ptr", DllStructGetPtr($szStruct), "long", DllStructGetSize($szStruct))
	DllCall ("KERNEL32.dll", "int", "GlobalUnlock", "hwnd", $hClipMem[0])
	DllCall ("user32.dll", "int", "OpenClipboard", "hwnd", 0)
	DllCall ("user32.dll", "int", "EmptyClipboard")
	DllCall ("user32.dll", "int", "SetClipboardData", "int", $CF_UNICODETEXT, "ptr", $hClipMem[0])
	DllCall ("user32.dll", "int", "CloseClipboard")
EndFunc
#endregion