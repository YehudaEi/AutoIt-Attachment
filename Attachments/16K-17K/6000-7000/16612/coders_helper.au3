#cs
Programmer's Helper -- By Matt of Rsforums.org
Find Pixel Hex colors, x,y coordinates, and a handy calculator.
#ce
#include <GUIConstants.au3>

#region GUI
GUICreate("Coder's Helper",300,250)
GUISetBkColor(0x000000)

$input_1 = GuiCtrlCreateInput("", 55, 10, 235, 35,$ES_READONLY)
$clear = GuiCtrlCreateButton("AC", 10, 13, 30, 30)
GUICtrlCreateLabel(" Ctrl + Z" & @CRLF & "to update:",3,60)
GUICtrlSetFont(-1, 8, 400, 0, "@Arial Unicode MS")
GUICtrlSetColor(-1, 0xFFFFFF) 
GUICtrlSetBkColor(-1, 0x000000) 
GUICtrlCreateLabel("Hex Color:",3,90)
GUICtrlSetFont(-1, 8, 400, 0, "@Arial Unicode MS") 
GUICtrlSetColor(-1, 0xFFFFFF) 
GUICtrlSetBkColor(-1, 0x000000) 
$input_pixel = GuiCtrlCreateInput("", 2, 105, 50, 20,$ES_READONLY)
GUICtrlCreateLabel(" Ctrl + X" & @CRLF & "to update:",3,135)
GUICtrlSetFont(-1, 8, 400, 0, "@Arial Unicode MS") 
GUICtrlSetColor(-1, 0xFFFFFF) 
GUICtrlSetBkColor(-1, 0x000000) 
GUICtrlCreateLabel("X Coord:",5,165)
GUICtrlSetFont(-1, 8, 400, 0, "@Arial Unicode MS") 
GUICtrlSetColor(-1, 0xFFFFFF) 
GUICtrlSetBkColor(-1, 0x000000)
$input_x = GuiCtrlCreateInput("", 5, 180, 40, 20,$ES_READONLY)
GUICtrlCreateLabel("Y Coord:",5,200)
GUICtrlSetFont(-1, 8, 400, 0, "@Arial Unicode MS") 
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
$input_y = GuiCtrlCreateInput("", 5, 215, 40, 20,$ES_READONLY)
$1 = GuiCtrlCreateButton("1", 55, 55, 40, 40)
$2 = GuiCtrlCreateButton("2", 100, 55, 40, 40)
$3 = GuiCtrlCreateButton("3", 145, 55, 40, 40)
$4 = GuiCtrlCreateButton("4", 55, 105, 40, 40)
$5 = GuiCtrlCreateButton("5", 100, 105, 40, 40)
$6 = GuiCtrlCreateButton("6", 145, 105, 40, 40)
$7 = GuiCtrlCreateButton("7", 55, 155, 40, 40)
$8 = GuiCtrlCreateButton("8", 100, 155, 40, 40)
$9 = GuiCtrlCreateButton("9", 145, 155, 40, 40)
$0 = GuiCtrlCreateButton("0", 55, 205, 40, 40)
$solve = GuiCtrlCreateButton("=", 100, 205, 85,40)
$cos = GuiCtrlCreateButton("Cos", 200, 55, 40, 40)
$tan = GuiCtrlCreateButton("Tan", 250, 55, 40, 40)
$sin = GuiCtrlCreateButton("Sin", 200, 105, 40, 40)
$sqrt = GuiCtrlCreateButton("Sqrt", 250, 105, 40, 40)
$divide = GuiCtrlCreateButton("÷", 200, 155, 40, 40)
$multiply = GuiCtrlCreateButton("x", 250, 155, 40, 40)
$add = GuiCtrlCreateButton("+", 200, 205, 40, 40)
$subtract = GuiCtrlCreateButton("-", 250, 205, 40, 40)
HotKeySet("^x", "Coords")
HotKeySet("^z", "Pixel")
#endregion

GuiSetState()

#region Globals
Global 	$pi = 3.14159265358979
Global  $degToRad = $pi / 180
Global  $operator = 0
#endregion

#region Loop
While 1
	$msg = GUIGetMsg()
	Select
		
	Case $msg = $1
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '1')
	
	Case $msg = $2
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '2')
	
	Case $msg = $3
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '3')
		
	Case $msg = $4
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '4')
		
	Case $msg = $5		
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '5')
		
	Case $msg = $6
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '6')
		
	Case $msg = $7
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '7')
		
	Case $msg = $8
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '8')
	
	Case $msg = $9
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '9')
		
	Case $msg = $0 
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '0')
		
	Case $msg = $clear
		GUICtrlSetData($input_1,"")
	
		
	Case $msg = $add ;addition
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '+')
		$operator = 1
		
	Case $msg = $sin ;sine	
		$answer_problem = GUICtrlRead($input_1)
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '_sin')
		$operator = 2
		
	Case $msg = $tan ;tangent
		$answer_problem = GUICtrlRead($input_1)
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '_tan')
		$operator = 3
		
	Case $msg = $cos ;cosine
		$answer_problem = GUICtrlRead($input_1)
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '_cos')
		$operator = 4
		
	Case $msg = $subtract ;subtract
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '-')
		$operator = 5
		
	Case $msg = $divide ;division
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '/')
		$operator = 6
		
	Case $msg = $multiply ;multiplication
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '*')
		$operator = 7
		
	Case $msg = $sqrt ;Square Root
		$answer_problem = GUICtrlRead($input_1)
		GUICtrlSetData($Input_1, GUICtrlRead($Input_1) & '_Square Root')
		$operator = 8
			
	
	Case $msg = $solve ;==> When '=' is clicked, the problem is solved here
		
		If $operator = 1 Then
		Solve()
		
		ElseIf $operator = 2 Then
		$answer_problem = Sin($answer_problem * $degToRad)
		SendToGUI()
		
		ElseIf $operator = 3 Then
		$answer_problem = Tan($answer_problem * $degToRad)
		SendToGUI()
		
		ElseIf $operator = 4 Then
		$answer_problem = Cos($answer_problem * $degToRad)
		SendToGUI()

		ElseIf $operator = 5 Then
		Solve()
		
		Elseif $operator = 6 Then
		Solve()
		
		Elseif $operator = 7 Then
		Solve()
		
		ElseIf $operator = 8 Then
		$answer_problem = Sqrt($answer_problem)
		SendToGUI()

	EndIf

	Case $msg = $GUI_EVENT_CLOSE ;==> Closes the program if x button is clicked
            Exit

	EndSelect
WEnd
#endregion

#region Functions
Func Solve()
		$answer_problem = GUICtrlRead($input_1)
		$answer2 = String($answer_problem)
		$result = Execute($answer2)
		GUICtrlSetData($input_1,"")
		GUICtrlSetData($input_1,$result)
EndFunc
	
Func SendToGUI()
		GUICtrlSetData($input_1,"")
		GUICtrlSetData($input_1,$answer_problem)
EndFunc

Func Coords()
	$coord = MouseGetPos()
	GUICtrlSetData($input_x,$coord[0])
	GUICtrlSetData($input_y,$coord[1])
EndFunc

Func Pixel()
	$xy = MouseGetPos()
	$x = $xy[0]
	$y = $xy[1]
	$pixel = PixelGetColor($x,$y)
	$pixel = Hex($pixel)
	GUICtrlSetData($input_pixel,$pixel)
EndFunc
#endregion
