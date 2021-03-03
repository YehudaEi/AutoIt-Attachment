#include <GuiConstants.au3>
#include <Misc.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>

#NoTrayIcon

;tao khoi dong
SoundPlay(@ScriptDir & "\music\Bao Thy - Bao Dem Em Khoc.wav")
$GUIMAIN = GUICreate("Xep Gach by SangProNhat", 166 + 234, 299, -1, -1, $WS_POPUP)
GUISetBkColor(0x000000)
$Img1 = GUICtrlCreatePic(@ScriptDir & "\data\screen1.jpg", 0, 0, 166, 299)
$Img2 = GUICtrlCreatePic(@ScriptDir & "\data\screen2.jpg", 166, 205, 234, 34)
$Img3 = GUICtrlCreatePic(@ScriptDir & "\data\title.jpg", 150, -25, 250, 150)
$Bt1 = GUICtrlCreateButton("", 190, 125, 189, 42, $BS_BITMAP)
GUICtrlSetImage(-1, @ScriptDir & "\data\bt1.bmp")
$Bt2 = GUICtrlCreateButton("", 190, 170, 189, 42, $BS_BITMAP)
GUICtrlSetImage(-1, @ScriptDir & "\data\diemso.bmp")
$Bt3 = GUICtrlCreateButton("", 190, 240, 189, 42, $BS_BITMAP)
GUICtrlSetImage(-1, @ScriptDir & "\data\thoat.bmp")
;------------------
Local $MANGCHINH[10][20][2] ; 10x20
Local $ArrTruyXuat[3][3]
Local $DSPIC_T[4]
Local $COGACH = 0, $BATDAU = 0
Local $bx, $by, $DONE = 0, $RETRAI = 1, $REPHAI = 1
Local $ChoiLai, $TamDung, $DiemSo, $Thoat, $LBD, $LBL, $NAME, $LBT
Local $SCORE = 0, $LINE = 0, $SPEED = 500, $MAU, $LOAI
Local $DownIsDown
For $i = 0 To 9 Step 1
	For $j = 0 To 19 Step 1
		$MANGCHINH[$i][$j][0] = 0
	Next
Next

GUISetState()

While 1
	$MSG = GUIGetMsg()
	If $MSG = $Bt1 Then
		KHOITAO()
		$BATDAU = 1
	ElseIf $MSG = $Bt3 Then
		Exit
	ElseIf $MSG = $Bt2 Then
		$STR = ""
		For $i = 1 To 5 Step 1
			$STR = $STR & IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "TEN", "") & @TAB & IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "Diem", "") & @CRLF
		Next
		MsgBox(0, "Diem cao nhat: ", $STR)
	EndIf
	If $BATDAU = 1 Then
		If $COGACH = 0 Then
			TAOGACH()
			$COGACH = 1
		EndIf
		$RETRAI = 1
		$REPHAI = 1
		$TM = 0
		$SPEED = 500
		$time = TimerInit()
		$LRTimer = TimerInit()
		Do
			If TimerDiff($LRTimer) > 100 And _IsPressed(25) Then
				$LRTimer = TimerInit()
				DC_DK_T()
				If $RETRAI <> 0 Then
					$bx = $bx - 1
					MOVEGACH()
					$TM = $SPEED - TimerDiff($time)
;~ 					ExitLoop
				EndIf
			ElseIf TimerDiff($LRTimer) > 100 And _IsPressed(27) Then
				$LRTimer = TimerInit()
				DC_DK_P()
				If $REPHAI <> 0 Then
					$bx = $bx + 1
					MOVEGACH()
					$TM = $SPEED - TimerDiff($time)
;~ 					ExitLoop
				EndIf
			ElseIf $DownIsDown = 0 And _IsPressed(26) Then
				$DownIsDown = 1
				XOAY()
				MOVEGACH()
				$TM = $SPEED - TimerDiff($time)
;~ 				ExitLoop
			ElseIf _IsPressed(28) Then
				$SPEED = 25
			EndIf
			If Not _IsPressed(26) Then $DownIsDown = 0
			Switch GUIGetMsg()
				Case $ChoiLai
					KHOIDONGLAI()
				Case $TamDung
					Do
						Sleep(10)
					Until GUIGetMsg() = $TamDung
				Case $DiemSo
					$STR = ""
					For $i = 1 To 5 Step 1
						$STR = $STR & IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "TEN", "") & @TAB & IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "Diem", "") & @CRLF
					Next
					MsgBox(0, "Diem cao nhat: ", $STR)
				Case $Thoat
					Exit
			EndSwitch
		Until TimerDiff($time) > $SPEED
;~ 		Sleep($TM)
		$by = $by + 1
		DONE()
		If $DONE = 1 Then
			$k = 0
			For $i = 0 To UBound($ArrTruyXuat, 1) - 1 Step 1
				For $j = 0 To UBound($ArrTruyXuat, 2) - 1 Step 1
					If $ArrTruyXuat[$i][$j] = 1 Then
						$x = $bx + $i
						$y = $by + $j - 1
						$MANGCHINH[$x][$y][0] = 1
						$MANGCHINH[$x][$y][1] = $DSPIC_T[$k]
						$k = $k + 1
					EndIf
				Next
			Next
			$COGACH = 0
			$DONE = 0
		Else
			MOVEGACH()
		EndIf
		GHIDIEM()
	EndIf
WEnd

Func KHOITAO()
	GUIDelete($GUIMAIN)
	GUICtrlDelete($Img1)
	GUICtrlDelete($Img2)
	GUICtrlDelete($Img3)
	GUICtrlDelete($Bt1)
	GUICtrlDelete($Bt2)
	GUICtrlDelete($Bt3)

	$GUIMAIN = GUICreate("Xep Gach by SangProNhat", 600, 500 + 70, -1, -1, $WS_POPUP)

	GUISetBkColor(0x000000)
	$Img1 = GUICtrlCreatePic(@ScriptDir & "\data\left.jpg", 10, 10, 52 / 2, 1100 / 2)
	$Img2 = GUICtrlCreatePic(@ScriptDir & "\data\right.jpg", 10 + 250 + 52 / 2, 10, 48 / 2, 1100 / 2)
	$Img3 = GUICtrlCreatePic(@ScriptDir & "\data\top.jpg", 10, 10, 600 / 2, 25)
	$Img4 = GUICtrlCreatePic(@ScriptDir & "\data\bot.jpg", 10, 10 + 500 + 25, 600 / 2, 25)
	$Img5 = GUICtrlCreatePic(@ScriptDir & "\data\diem.jpg", 400, 150, 133, 57)
	$Img6 = GUICtrlCreatePic(@ScriptDir & "\data\lines.jpg", 400, 150 + 87, 133, 57)

	$ChoiLai = GUICtrlCreateButton("", 370, 150 + 87 * 2, 189, 42, $BS_BITMAP)
	GUICtrlSetImage(-1, @ScriptDir & "\data\again.bmp")
	$TamDung = GUICtrlCreateButton("", 370, 150 + 87 * 2 + 62, 189, 42, $BS_BITMAP)
	GUICtrlSetImage(-1, @ScriptDir & "\data\pause.bmp")
	$DiemSo = GUICtrlCreateButton("", 370, 150 + 87 * 2 + 62 * 2, 189, 42, $BS_BITMAP)
	GUICtrlSetImage(-1, @ScriptDir & "\data\diemso.bmp")
	$Thoat = GUICtrlCreateButton("", 370, 150 + 87 * 2 + 62 * 3, 189, 42, $BS_BITMAP)
	GUICtrlSetImage(-1, @ScriptDir & "\data\thoat.bmp")

	$LBD = GUICtrlCreateLabel("000000", 420, 162, 100, 25, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetColor(-1, 0xffffff)
	GUICtrlSetFont(-1, 20, "Arial Black")

	$LBT = GUICtrlCreateLabel("", 400, 10, 100, 25, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetColor(-1, 0xffffff)
	GUICtrlSetFont(-1, 20, "Arial Black")

	$LBL = GUICtrlCreateLabel("000", 430, 162 + 87, 75, 25, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetColor(-1, 0xffffff)
	GUICtrlSetFont(-1, 20, "Arial Black")

	GUICtrlCreatePic(@ScriptDir & "\data\title.jpg", 360, 40, 200, 100)

	$NAME = InputBox("Yeu cau !!", "Nhap ten vao day de bat dau: ")

	GUICtrlSetData($LBT, $NAME)
	GUISetState()

EndFunc   ;==>KHOITAO


Func TAOGACH()
	;7 loai 1x4,2x2,3x2 có 5
	For $i = 0 To UBound($ArrTruyXuat, 1) - 1 Step 1
		For $j = 0 To UBound($ArrTruyXuat, 2) - 1 Step 1
			$ArrTruyXuat[$i][$j] = 0
		Next
	Next
	$MAU = Random(1, 4, 1)
	$LOAI = Random(1, 7, 1)
	$bx = 4
	$by = 0
	If $LOAI = 1 Then
		ReDim $ArrTruyXuat[1][4]
		For $i = 0 To 3 Step 1
			$ArrTruyXuat[0][$i] = 1
		Next
	ElseIf $LOAI = 2 Then
		ReDim $ArrTruyXuat[2][2]
		$ArrTruyXuat[0][0] = 1
		$ArrTruyXuat[0][1] = 1
		$ArrTruyXuat[1][0] = 1
		$ArrTruyXuat[1][1] = 1
	ElseIf $LOAI = 3 Then
		ReDim $ArrTruyXuat[3][2]
		$ArrTruyXuat[0][0] = 1
		$ArrTruyXuat[1][0] = 1
		$ArrTruyXuat[2][0] = 1
		$ArrTruyXuat[0][1] = 0
		$ArrTruyXuat[1][1] = 0
		$ArrTruyXuat[2][1] = 1
	ElseIf $LOAI = 4 Then
		ReDim $ArrTruyXuat[3][2]
		$ArrTruyXuat[0][0] = 1
		$ArrTruyXuat[1][0] = 1
		$ArrTruyXuat[2][0] = 1
		$ArrTruyXuat[0][1] = 1
		$ArrTruyXuat[1][1] = 0
		$ArrTruyXuat[2][1] = 0
	ElseIf $LOAI = 5 Then
		ReDim $ArrTruyXuat[3][2]
		$ArrTruyXuat[0][0] = 1
		$ArrTruyXuat[1][0] = 1
		$ArrTruyXuat[2][0] = 1
		$ArrTruyXuat[0][1] = 0
		$ArrTruyXuat[1][1] = 1
		$ArrTruyXuat[2][1] = 0
	ElseIf $LOAI = 6 Then
		ReDim $ArrTruyXuat[3][2]
		$ArrTruyXuat[0][0] = 0
		$ArrTruyXuat[1][0] = 1
		$ArrTruyXuat[2][0] = 1
		$ArrTruyXuat[0][1] = 1
		$ArrTruyXuat[1][1] = 1
		$ArrTruyXuat[2][1] = 0
	ElseIf $LOAI = 7 Then
		ReDim $ArrTruyXuat[3][2]
		$ArrTruyXuat[0][0] = 1
		$ArrTruyXuat[1][0] = 1
		$ArrTruyXuat[2][0] = 0
		$ArrTruyXuat[0][1] = 0
		$ArrTruyXuat[1][1] = 1
		$ArrTruyXuat[2][1] = 1
	EndIf

	If $MAU = 1 Then
		$FILE = @ScriptDir & "\data\gachdo.jpg"
	ElseIf $MAU = 2 Then
		$FILE = @ScriptDir & "\data\gachnau.jpg"
	ElseIf $MAU = 3 Then
		$FILE = @ScriptDir & "\data\gachtim.jpg"
	ElseIf $MAU = 4 Then
		$FILE = @ScriptDir & "\data\gachxanh.jpg"
	EndIf

	$k = 0
	For $i = 0 To UBound($ArrTruyXuat, 1) - 1 Step 1
		For $j = 0 To UBound($ArrTruyXuat, 2) - 1 Step 1
			If $ArrTruyXuat[$i][$j] = 1 Then
				If $MANGCHINH[$bx + $i][$by + $j][0] = 1 Then
					GAMEOVER()
					ExitLoop
				EndIf
				$DSPIC_T[$k] = GUICtrlCreatePic($FILE, 25 * ($bx + $i) + 36, ($by + $j) * 25 + 35, 25, 25)
				$k = $k + 1
			EndIf
		Next
	Next


EndFunc   ;==>TAOGACH

Func MOVEGACH()
	$k = 0
	For $i = 0 To UBound($ArrTruyXuat, 1) - 1 Step 1
		For $j = 0 To UBound($ArrTruyXuat, 2) - 1 Step 1
			If $ArrTruyXuat[$i][$j] = 1 Then
				GUICtrlSetPos($DSPIC_T[$k], 25 * ($bx + $i) + 36, ($by + $j) * 25 + 35)
				$k = $k + 1
			EndIf
		Next
	Next
	SoundPlay(@ScriptDir & "\music\start.wav")
EndFunc   ;==>MOVEGACH

Func DONE()
	For $i = 0 To UBound($ArrTruyXuat, 1) - 1 Step 1
		For $j = 0 To UBound($ArrTruyXuat, 2) - 1 Step 1
			If $ArrTruyXuat[$i][$j] = 1 Then
				$x = $bx + $i
				$y = $by + $j
				If $y > 19 Then
					$DONE = 1
				ElseIf $MANGCHINH[$x][$y][0] = 1 Then
					$DONE = 1
				EndIf
			EndIf
		Next
	Next
	SoundPlay(@ScriptDir & "\music\game.wav")
EndFunc   ;==>DONE

Func DC_DK_T()
	For $i = 0 To UBound($ArrTruyXuat, 1) - 1 Step 1
		For $j = 0 To UBound($ArrTruyXuat, 2) - 1 Step 1
			If $ArrTruyXuat[$i][$j] = 1 Then
				$x = $bx + $i - 1
				$y = $by + $j
				If $x < 0 Or $MANGCHINH[$x][$y][0] = 1 Then
					$RETRAI = 0
				EndIf
			EndIf
		Next
	Next
EndFunc   ;==>DC_DK_T

Func DC_DK_P()
	For $i = 0 To UBound($ArrTruyXuat, 1) - 1 Step 1
		For $j = 0 To UBound($ArrTruyXuat, 2) - 1 Step 1
			If $ArrTruyXuat[$i][$j] = 1 Then
				$x = $bx + $i + 1
				$y = $by + $j
				If $x > 9 Or $MANGCHINH[$x][$y][0] = 1 Then
					$REPHAI = 0
				EndIf
			EndIf
		Next
	Next
EndFunc   ;==>DC_DK_P

Func XOAY()
	; xoay 90 do ma tran chieu kim dong Ho
	$OK = 1
	Dim $ARRTAM[UBound($ArrTruyXuat, 2)][UBound($ArrTruyXuat, 1)]
	For $i = 0 To UBound($ArrTruyXuat, 2) - 1 Step 1
		For $j = 0 To UBound($ArrTruyXuat, 1) - 1 Step 1
			$ARRTAM[$i][$j] = $ArrTruyXuat[$j][UBound($ArrTruyXuat, 2) - $i - 1]
		Next
	Next ;khoi tao mang phu
	;	   0 1 2
	;	0  x x x
	;	1  x o o
	;	   0 1
	;	0  x x
	;	1  o x
	;   2  o x
	For $i = 0 To UBound($ARRTAM, 1) - 1 Step 1
		For $j = 0 To UBound($ARRTAM, 2) - 1 Step 1
			If $ARRTAM[$i][$j] = 1 Then
				$x = $bx + $i
				$y = $by + $j
				If $x > 9 Or $y > 19 Or $MANGCHINH[$x][$y][0] = 1 Then
					$OK = 0
				EndIf
			EndIf
		Next
	Next
	If $OK = 1 Then
		ReDim $ArrTruyXuat[UBound($ArrTruyXuat, 2)][UBound($ArrTruyXuat, 1)]
		$ArrTruyXuat = $ARRTAM
	EndIf
EndFunc   ;==>XOAY

Func GHIDIEM()
	Dim $XY[4]
	For $i = 0 To UBound($MANGCHINH, 2) - 1 Step 1
		If CHECK($i) = 1 Then
			For $j = 0 To UBound($MANGCHINH, 1) - 1 Step 1
				Sleep(50)
				GUICtrlDelete($MANGCHINH[$j][$i][1])
			Next
			For $a = $i To 1 Step -1
				For $j = 0 To UBound($MANGCHINH, 1) - 1 Step 1
					$MANGCHINH[$j][$a][0] = $MANGCHINH[$j][$a - 1][0]
					$MANGCHINH[$j][$a][1] = $MANGCHINH[$j][$a - 1][1]
					If $MANGCHINH[$j][$a - 1][1] <> 0 Then
						$XY = ControlGetPos("Xep Gach by SangProNhat", "", $MANGCHINH[$j][$a - 1][1])
						If Not @error Then
							GUICtrlSetPos($MANGCHINH[$j][$a - 1][1], $XY[0], $XY[1] + 25)
						EndIf
					EndIf
				Next
			Next
			TANGDIEM()
			SoundPlay(@ScriptDir & "\music\newalert.wav")
		EndIf
	Next
EndFunc   ;==>GHIDIEM

Func CHECK($h)
	For $m = 0 To UBound($MANGCHINH, 1) - 1
		If $MANGCHINH[$m][$h][0] <> 1 Then
			Return 0
		EndIf
	Next
	Return 1
EndFunc   ;==>CHECK

Func TANGDIEM()
	$SCORE = $SCORE + 10
	$LINE = $LINE + 1
	GUICtrlSetData($LBD, $SCORE)
	GUICtrlSetData($LBL, $LINE)
EndFunc   ;==>TANGDIEM

Func GAMEOVER()
	$CALL = MsgBox(4, "Ban da thua !!!", "Ban co muon choi lai không ?")
	If $CALL = 6 Then
		SAVE()
		KHOIDONGLAI()
	ElseIf $CALL = 7 Then
		SAVE()
		Exit
	EndIf
EndFunc   ;==>GAMEOVER

Func KHOIDONGLAI()
	For $i = 0 To 9 Step 1
		For $j = 0 To 19 Step 1
			$MANGCHINH[$i][$j][0] = 0
			GUICtrlDelete($MANGCHINH[$i][$j][1])
			$MANGCHINH[$i][$j][1] = 0
		Next
	Next
	For $i = 0 To 3 Step 1
		GUICtrlDelete($DSPIC_T[$i])
		$DSPIC_T[$i] = 0
	Next
	ReDim $MANGCHINH[10][20][2] ; 10x20
	ReDim $ArrTruyXuat[3][3]
	ReDim $DSPIC_T[4]
	$COGACH = 0
	$DONE = 0
	GUICtrlSetData($LBD, 0)
	GUICtrlSetData($LBL, 0)
	$SCORE = 0
	$LINE = 0
	$SPEED = 500
	$NAME = InputBox("Yeu cau !!", "Nhap ten vao day de bat dau: ")
	GUICtrlSetData($LBT, $NAME)
EndFunc   ;==>KHOIDONGLAI

Func SAVE()
	$DIEM1 = IniRead(@ScriptDir & "\highscore\score.ini", "HANG 1", "Diem", "")
	$DIEM2 = IniRead(@ScriptDir & "\highscore\score.ini", "HANG 2", "Diem", "")
	$DIEM3 = IniRead(@ScriptDir & "\highscore\score.ini", "HANG 3", "Diem", "")
	$DIEM4 = IniRead(@ScriptDir & "\highscore\score.ini", "HANG 4", "Diem", "")
	$DIEM5 = IniRead(@ScriptDir & "\highscore\score.ini", "HANG 5", "Diem", "")
	If $SCORE > $DIEM1 Then
		For $i = 5 To 2 Step -1
			IniWrite(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "Ten", IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & ($i - 1), "Ten", ""))
			IniWrite(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "Diem", IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & ($i - 1), "Diem", ""))
		Next
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 1", "Ten", $NAME)
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 1", "Diem", $SCORE)
	ElseIf $SCORE > $DIEM2 Then
		For $i = 4 To 2 Step -1
			IniWrite(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "Ten", IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & ($i - 1), "Ten", ""))
			IniWrite(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "Diem", IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & ($i - 1), "Diem", ""))
		Next
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 4", "Ten", $NAME)
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 4", "Diem", $SCORE)
	ElseIf $SCORE > $DIEM3 Then
		For $i = 3 To 2 Step -1
			IniWrite(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "Ten", IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & ($i - 1), "Ten", ""))
			IniWrite(@ScriptDir & "\highscore\score.ini", "HANG " & $i, "Diem", IniRead(@ScriptDir & "\highscore\score.ini", "HANG " & ($i - 1), "Diem", ""))
		Next
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 3", "Ten", $NAME)
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 3", "Diem", $SCORE)
	ElseIf $SCORE > $DIEM4 Then
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 1", "Ten", IniRead(@ScriptDir & "\highscore\score.ini", "HANG 2", "Ten", ""))
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 1", "Diem", IniRead(@ScriptDir & "\highscore\score.ini", "HANG 2", "Diem", ""))
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 2", "Ten", $NAME)
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 2", "Diem", $SCORE)
	ElseIf $SCORE > $DIEM5 Then
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 1", "Ten", $NAME)
		IniWrite(@ScriptDir & "\highscore\score.ini", "HANG 1", "Diem", $SCORE)
	EndIf

EndFunc   ;==>SAVE

