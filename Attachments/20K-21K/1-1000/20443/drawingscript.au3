#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <Color.au3>
#include <WinAPI.au3>

Global $threshold
Global $image
Global $width
Global $height
Global $pixels
Global $pathString = "12345678"
Global $scramble = False
Global $rotate = 0
Global $speed


;; Check hotkeys ;;
If (Not HotKeySet ("{F9}", "Nothing")) Then
	MsgBox (16, "Error", "Could not register the F9 hotkey.")
	Exit
EndIf
If (Not HotKeySet ("{F10}", "Nothing")) Then
	MsgBox (16, "Erro", "Could not register the F10 hotkey.")
	Exit
EndIf


;; Image dialog ;;
$imageFile = FileOpenDialog ("Open image", @WorkingDir, "Images (*.jpg;*.jpeg;*.gif;*.png;*.bmp)", 1)
If (@error) Then Exit


;; Options dialog ;;
$optGUI = GUICreate ("Settings", 160, 270, -1, -1, $WS_CAPTION, BitOr ($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUICtrlCreateGroup ("Image processing", 5, 5, 150, 85)
GUICtrlCreateLabel ("Sensitivity (0~255):", 10, 28, 110, 15)
$thresholdInput = GUICtrlCreateInput ("100", 125, 25, 25, 20, $ES_NUMBER)
GUICtrlCreateLabel ("Width (px):", 10, 48, 110, 15)
$widthInput = GUICtrlCreateInput ("100", 125, 45, 25, 20, $ES_NUMBER)
GUICtrlCreateLabel ("Height (px):", 10, 68, 110, 15)
$heightInput = GUICtrlCreateInput ("100", 125, 65, 25, 20, $ES_NUMBER)
GUICtrlCreateGroup ("Drawing pattern", 5, 95, 150, 140)
$horizontalRadio = GUICtrlCreateRadio ("Horizontal", 10, 115, 110, 15)
$verticalRadio = GUICtrlCreateRadio ("Vertical", 10, 135, 110, 15)
$diagonalRadio = GUICtrlCreateRadio ("Diagonal", 10, 155, 110, 15)
$rotateRadio = GUICtrlCreateRadio ("Spiral", 10, 175, 110, 15)
$scrambleRadio = GUICtrlCreateRadio ("Random", 10, 195, 110, 15)
GUICtrlSetState ($diagonalRadio, $GUI_CHECKED)
GUICtrlCreateLabel ("Mouse speed (0~100):", 10, 213, 110, 15)
$speedInput = GUICtrlCreateInput ("0", 125, 210, 25, 20, $ES_NUMBER)
$okBtn = GUICtrlCreateButton ("Ok", 30, 245, 40, 20)
$cancelBtn = GUICtrlCreateButton ("Cancel", 80, 245, 50, 20)
GUISetState ()

While 1
	Switch (GUIGetMsg ())
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cancelBtn
			Exit
		Case $okBtn
			$threshold = GUICtrlRead ($thresholdInput)
			$width = GUICtrlRead ($widthInput)
			$height = GUICtrlRead ($heightInput)
			$speed = GUICtrlRead ($speedInput)
			If	(GUICtrlRead ($horizontalRadio) == $GUI_CHECKED) Then
				$pathString = "45273618"
			ElseIf (GUICtrlRead ($verticalRadio) == $GUI_CHECKED) Then
				$pathString = "27453618"
			ElseIf (GUICtrlRead ($diagonalRadio) == $GUI_CHECKED) Then
				$pathString = "36184527"
			ElseIf (GUICtrlRead ($rotateRadio) == $GUI_CHECKED) Then
				$pathString = "14678532"
				$rotate = 1
			ElseIf (GUICtrlRead ($scrambleRadio) == $GUI_CHECKED) Then
				$scramble = True
			EndIf

			GUIDelete ($optGUI)
			ExitLoop
	EndSwitch
WEnd


;; Processing dialog ;;
$GUI = GUICreate ("Processing image...", $width, $height + 20, -1, -1, $WS_CAPTION, BitOr ($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUISetBkColor (0xffffff)
$imageBox = GUICtrlCreatePic ($imageFile, 0, 0, $width, $height)
$progress = GUICtrlCreateProgress (0, $height, $width, 20)
GUISetState ()

;; Get image pixels ;;
$dc = _WinAPI_GetDC ($GUI)
$memDc = _WinAPI_CreateCompatibleDC ($dc)
$bitmap = _WinAPI_CreateCompatibleBitmap ($dc, $width, $height)
_WinAPI_SelectObject ($memDc, $bitmap)
_WinAPI_BitBlt ($memDc, 0, 0, $width, $height, $dc, 0, 0, $SRCCOPY)
$bits = DllStructCreate ("dword[" & ($width * $height) & "]")
DllCall ("gdi32", "int", "GetBitmapBits", "ptr", $bitmap, "int", ($width * $height * 4), "ptr", DllStructGetPtr ($bits))
GUICtrlDelete ($imageBox)

;; Process the pixels ;;
Dim $pixels[$width][$height]
For $y = 0 To ($height - 1)
	For $x = 0 To ($width - 1)
		$index = ($y * $width) + $x
		$color = DllStructGetData ($bits, 1, $index)

		$red = _ColorGetBlue ($color)
		$green = _ColorGetGreen ($color)
		$blue = _ColorGetRed ($color)
		$shade = ($red + $green + $blue) / 3
		If ($shade > $threshold) Then
			$color = 0xffffff
			$pixels[$x][$y] = 0
		Else
			$color = 0
			$pixels[$x][$y] = 1
		EndIf

		DllStructSetData ($bits, 1, $color, $index)
	Next

	DllCall ("gdi32", "int", "SetBitmapBits", "ptr", $bitmap, "int", ($width * $height * 4), "ptr", DllStructGetPtr ($bits))
	_WinAPI_BitBlt ($dc, 0, 0, $width, $height, $memDc, 0, 0, $SRCCOPY)
	GUICtrlSetData ($progress, ($y * 100) / $height)
Next

_WinAPI_ReleaseDC ($GUI, $dc)
GUIRegisterMsg ($WM_PAINT, "OnPaint")


;; Ready to draw ;;
TrayTip ("Pronto!", "Press F9 para draw. You can press F10 anytime to exit.", 10)
HotKeySet ("{F9}", "Draw")
HotKeySet ("{F10}", "Quit")

While 1
	Sleep (60000)
WEnd


Func OnPaint ($hwndGUI, $msgID, $wParam, $lParam)
	Local $paintStruct = DllStructCreate ("hwnd hdc;int fErase;dword rcPaint[4];int fRestore;int fIncUpdate;byte rgbReserved[32]")

	$dc = DllCall ("user32", "hwnd", "BeginPaint", "hwnd", $hwndGUI, "ptr", DllStructGetPtr ($paintStruct))
	$dc = $dc[0]

	_WinAPI_BitBlt ($dc, 0, 0, $width, $height, $memDc, 0, 0, $SRCCOPY)

	DllCall ("user32", "hwnd", "EndPaint", "hwnd", $hwndGUI, "ptr", DllStructGetPtr ($paintStruct))
	Return $GUI_RUNDEFMSG
EndFunc


Func Draw ()
	$mouseCenter = MouseGetPos ()
	$x0 = $mouseCenter[0] - ($width / 2)
	$y0 = $mouseCenter[1] - ($height / 2)

	;; Move the mouse around the drawing perimeter ;;
	MouseMove ($x0, $y0)
	MouseMove ($x0 + $width, $y0)
	MouseMove ($x0 + $width, $y0 + $height)
	MouseMove ($x0, $y0 + $height)
	MouseMove ($x0, $y0)

	;; Draw all the areas ;;
	$stack = CreateStack (1000)
	For $y = 0 To ($height - 1)
		For $x = 0 To ($width - 1)
			If ($pixels[$x][$y] == 1) Then
				MouseMove ($x + $x0, $y + $y0, $speed)
				MouseDown ("primary")
				DrawArea ($stack, $x, $y, $x0, $y0)
				MouseUp ("primary")
			Else
			EndIf
		Next
	Next

	;; Reset the pixels statuses ;;
	For $y = 0 To ($height - 1) Step 1
		For $x = 0 To ($width - 1) Step 1
			If ($pixels[$x][$y] == 2) Then
				$pixels[$x][$y] = 1
			EndIf
		Next
	Next
EndFunc


Func DrawArea (ByRef $stack, $x, $y, $x0, $y0)
	Local $path[8]
	Local $continue

	$path = MakePath ($pathString)

	While 1
		MouseMove ($x + $x0, $y + $y0, $speed)
		$pixels[$x][$y] = 2

		If ($scramble) Then ScramblePath ($path)
		If ($rotate > 0) Then RotatePath ($path, $rotate)

		;;;;;;;;;;;;;;;;;;;
		;; +---+---+---+ ;;
		;; | 1 | 2 | 3 | ;;
		;; +---+---+---+ ;;
		;; | 4 |   | 5 | ;;
		;; +---+---+---+ ;;
		;; | 6 | 7 | 8 | ;;
		;; +---+---+---+ ;;
		;;;;;;;;;;;;;;;;;;;

		$continue = False
		For $i = 0 To 7
			Switch ($path[$i])
				Case 1
					If (($x > 0) And ($y > 0)) Then
						If ($pixels[$x - 1][$y - 1] == 1) Then
							Push ($stack, $x, $y)
							$x -= 1
							$y -= 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 2
					If ($y > 0) Then
						If ($pixels[$x][$y - 1] == 1) Then
							Push ($stack, $x, $y)
							$y -= 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 3
					If (($x > 0) And ($y < 0)) Then
						If ($pixels[$x + 1][$y - 1] == 1) Then
							Push ($stack, $x, $y)
							$x += 1
							$y -= 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 4
					If ($x > 0) Then
						If ($pixels[$x - 1][$y] == 1) Then
							Push ($stack, $x, $y)
							$x -= 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 5
					If ($x < ($width - 1)) Then
						If ($pixels[$x + 1][$y] == 1) Then
							Push ($stack, $x, $y)
							$x += 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 6
					If (($x < 0) And ($y > 0)) Then
						If ($pixels[$x - 1][$y + 1] == 1) Then
							Push ($stack, $x, $y)
							$x -= 1
							$y += 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 7
					If ($y < ($height - 1)) Then
						If ($pixels[$x][$y + 1] == 1) Then
							Push ($stack, $x, $y)
							$y += 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 8
					If (($x < ($width - 1)) And ($y < ($height - 1))) Then
						If ($pixels[$x + 1][$y + 1] == 1) Then
							Push ($stack, $x, $y)
							$x += 1
							$y += 1
							$continue = True
							ExitLoop
						EndIf
					EndIf
			EndSwitch
		Next
		If ($continue) Then ContinueLoop

		If (Not Pop ($stack, $x, $y)) Then ExitLoop
	WEnd
EndFunc



Func MakePath ($string)
	Return StringSplit ($string, "")
EndFunc


Func ScramblePath (ByRef $path)
	Local $table = "12345678"
	Local $newPath[8]

	For $i = 8 To 1 Step -1
		$next = StringMid ($table, Random (1, $i, 1), 1)
		$newPath[$i - 1] = Number ($next)
		$table = StringReplace ($table, $next, "")
	Next

	$path = $newPath
EndFunc


Func RotatePath (Byref $path, $places)
	If ($places == 0) Then
		Return $path
	Else
		For $i = 1 To Abs ($places)
			$temp = $path[7]
			$path[7] = $path[6]
			$path[6] = $path[5]
			$path[5] = $path[4]
			$path[4] = $path[3]
			$path[3] = $path[2]
			$path[2] = $path[1]
			$path[1] = $path[0]
			$path[0] = $temp
		Next
	EndIf
EndFunc



Func CreateStack ($size)
	Dim $stack[$size + 1][2]
	$stack[0][0] = 0
	$stack[0][1] = $size
	Return $stack
EndFunc


Func Push (ByRef $stack, $x, $y)
	$stack[0][0] += 1
	If ($stack[0][0] > $stack[0][1]) Then
		$stack[0][1] += 1000
		ReDim $stack[$stack[0][1] + 1][2]
	EndIf

	$stack[$stack[0][0]][0] = $x
	$stack[$stack[0][0]][1] = $y
EndFunc


Func Pop (ByRef $stack, ByRef $x, ByRef $y)
	If ($stack[0][0] < 1) Then
		Return False
	EndIf

	$x = $stack[$stack[0][0]][0]
	$y = $stack[$stack[0][0]][1]

	$stack[0][0] -= 1
	Return True
EndFunc


Func Nothing ()
EndFunc

Func Quit ()
	MouseUp ("primary")
	Exit
EndFunc