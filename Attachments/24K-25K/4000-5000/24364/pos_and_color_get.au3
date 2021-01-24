#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <Timers.au3>

Opt("GUIResizeMode", $GUI_DOCKALL)

filewrite("points and colors.txt", @CRLF & "Start session: " & @MON & " / " & @MDAY & " / " & @HOUR & ":" & @MIN & ", " & @SEC & " sec" & @CRLF & @CRLF)

Global $starttime = _Timer_Init()
Global $msg

  $gui = GUICreate("pos and color get", 221, 60, 0, -21, -1)
  GUISetBkColor(0x000000)

  $pos = MouseGetPos()                      
  $color = PixelGetColor($pos[0], $pos[1])  
  $cursorID = MouseGetCursor()
  $check2 = false  

  $button_1 = GUICtrlCreateButton("copy (F2)", 3, 18, 61, 21, 0)
  $button_2 = GUICtrlCreateButton("copy (F3)", 80, 18, 61, 21, 0)
  $button_3 = GUICtrlCreateButton("copy (F4)", 157, 18, 61, 21, 0)

  $pos_XY = GUICtrlCreateLabel("Coord: " & $pos[0] & ", " & $pos[1], 0, 0, 91,15)
  GUICtrlSetColor(-1,0x00ffff)
  $color_Hex = GUICtrlCreateLabel("Color: " & Hex($color,6), 81, 0, 141,15) 
  GUICtrlSetColor(-1,0x00ffff)       
  $cursID = GUICtrlCreateLabel("Cursor: " & $CursorID, 167, 0, 61,15)
  GUICtrlSetColor(-1,0x00ffff)
  
  $Slider11 = GUICtrlCreateSlider(3, 98, 215, 31)
  GUICtrlSetLimit(-1, 255 , 55)
  GUICtrlSetData(-1,250)
  GUICtrlSetBkColor(-1,0x000000)
  $Slider1value = GUICtrlRead($slider11)
  
  $check = GUICtrlCreateCheckbox("", 16, 62, 15)
  GUICtrlCreateLabel("include sleep() times between gets", 30,60)
  GUICtrlSetColor(-1, 0x00FFff)
  
  
  $Expand_Button = GUICtrlCreateButton("Options", 3, 40, 215, 15)

  GUISetState()
  
  HotKeySet("{F2}","copy1")
  HotKeySet("{F3}","copy2")
  HotKeySet("{F4}","copy3")
  
main();this runs main function.
  
func copy1()
	if $check2 = true then
		$time = round(_Timer_Diff($starttime),0)
		filewrite("points and colors.txt","sleep(" & $time & ")" & @CRLF)
		$starttime = _Timer_Init()
		filewrite("points and colors.txt",$pos[0] & ", " & $pos[1]& @CRLF)
	Else
	filewrite("points and colors.txt",$pos[0] & ", " & $pos[1]& @CRLF)
	EndIf
endfunc

func copy2()
		if $check2 = true then
		$time = round(_Timer_Diff($starttime),0)
		filewrite("points and colors.txt","sleep(" & $time & ")" & @CRLF)
		$starttime = _Timer_Init()
	filewrite("points and colors.txt","0x" &Hex($color,6) & @CRLF)
	Else
	filewrite("points and colors.txt","0x" &Hex($color,6) & @CRLF)
	EndIf
endfunc

func copy3()
		if $check2 = true then
		$time = round(_Timer_Diff($starttime),0)
		filewrite("points and colors.txt","sleep(" & $time & ")" & @CRLF)
		$starttime = _Timer_Init()
	filewrite("points and colors.txt","cursor " &$cursorID & @CRLF) 
	Else
	filewrite("points and colors.txt","cursor " &$cursorID & @CRLF) 
	EndIf
endfunc

func main()
  Do
    $msg = GUIGetMsg()
        
    get_data()
        
    Switch $msg
        Case $button_1
            ClipPut($pos[0] & ", " & $pos[1]) 
		  
        Case $button_2
            ClipPut(Hex($color,6))
		  
        Case $button_3
            ClipPut($cursorID)
			
		case $check
			if $check2 = True then
				$check2 = false
			Else
				$check2 = true
			EndIf
			
		Case $Expand_Button
			Local $Height, $ButtonText
			$GuiPos = WinGetPos($Gui)
			If $GuiPos[3] < 88 + 81 Then
				$Height = 88 + 81
				$ButtonText = "Close"
			Else
				$Height = 88
				$ButtonText = "Options"
			EndIf
			GUICtrlSetData($Expand_Button, $ButtonText)
			WinMove($Gui, "", $GuiPos[0], $GuiPos[1], $GuiPos[2], $Height)
			
		Case $Slider11
			$Slider1value = GUICtrlRead($slider11)
			WinSetTrans("pos and color get","",$slider1value)
      EndSwitch
    
    sleep(10)
    WinSetOnTop($gui, 0, 1)
    Until $msg = $GUI_EVENT_CLOSE
    GUIDelete()
filewrite("points and colors.txt", @CRLF & "End session: " & @MON & " / " & @MDAY & " / " & @HOUR & ":" & @MIN & ", " & @SEC & " sec" & @CRLF)
endfunc

;a function to update the data if the new data is different.
Func get_data() 
    $pos2 = MouseGetPos()
    $color2 = PixelGetColor($pos2[0], $pos2[1])
    $cursorID2 = MouseGetCursor()
    
    If($pos[0] <> $pos2[0] or $pos[1] <> $pos2[1]) Then
      $pos = $pos2    
      GUICtrlSetData($pos_XY, "Coord: " & $pos[0] & ", " & $pos[1])
    EndIf
    
    If($color <> $color2) Then
		$color = $color2    
		GUICtrlSetData($color_Hex, "Color: " & Hex($color,6))
		if $color = 0x000000 Then
			$color2 = 0xffffff
		Else
			$color2 = $color
		endif
	  GUICtrlSetBkColor($button_1, $color2)
	  GUICtrlSetBkColor($button_2, $color2)
	  GUICtrlSetBkColor($button_3, $color2)
	  GUICtrlSetBkColor($Expand_Button, $color2)
    EndIf
  
    If($cursorID <> $cursorID2) Then
      $cursorID = $cursorID2        
      GUICtrlSetData($cursID, "Cursor: " & $cursorID)
    EndIf

EndFunc 