;; ��������� ����������
Global $use, $pos, $color, $Paused, $color_2, $pos_2, $color_3, $color_4, $pos_3, $pos_4, $move

;; ���� ������ ����� ������
HotKeySet("^d", "GetCor")
HotKeySet("^q", "Quit")

;; ��������������� ����
While 1
	;; ���������, ������ �� ������
	If $use = true Then
		
		;; �������� ��������� ������
		MoveR()
		If $color_2 <> $color_3 Then
			Send(3)
			Send(4)
		Else
			Send(2)
			Send(4)
		EndIf
	EndIf
WEnd

;; ������� 
; �������� ���� � ���������� �������
Func GetCor()
	$pos = MouseGetPos()
	$color = PixelGetColor ( $pos[0] , $pos[1] )
	;MsgBox(0, "!!!", "Color: " & $color & "  Pos: " & $pos[0] & ", " & $pos[1]) 
	$use = true
EndFunc



; ��������� ����� ������� �� ������� ������� ������ �����...
Func MoveR()
	$color_2 = PixelGetColor ( $pos[0] , $pos[1] )
	$pos_2 = $pos[0]
	While $color = $color_2
		$pos_2 = $pos_2 + 1
		$color_2 = PixelGetColor ( $pos_2 , $pos[1] )
	WEnd
	Sleep(3500)
	$color_3 = PixelGetColor ( $pos_2 , $pos[1] )
;MsgBox(0, "!!!", "Color: " & $color_2 & "  Pos: " & $pos_2 & ", " & $pos[1]) 
EndFunc

; ������ ����� �������
Func MoveR_2()
	$color_4 = PixelGetColor ( $pos[0] , $pos[1] )
	$pos_4 = $pos[0]
	While $color = $color_4
		$pos_4 = $pos_4 + 1
		$color_4 = PixelGetColor ( $pos_4 , $pos[1] )
	WEnd
	;MsgBox(0, "!!!", "Color: " & $color_3 & "  Pos: " & $pos_3 & ", " & $pos[1]) 
EndFunc
; ������� �� ���������
Func Quit()
	Exit 0
EndFunc