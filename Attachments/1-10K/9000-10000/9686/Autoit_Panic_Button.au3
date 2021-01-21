HotKeySet("{ESC}", "MinimizeAll")

; monitor for left mouse button is pressed
While 1
  If _IsPressed('01') = 1 Then GetMousePosition()	;"01" is left mouse button
  Sleep(20)
Wend

; minimize all active windows
Func MinimizeAll()
	WinMinimizeAll()
	Opt("WinTitleMatchMode", 2)
	
	WinActivate ( "Internet Explorer","")
	WinSetState ( "Internet Explorer", "", @SW_MAXIMIZE)
EndFunc

; get the current mouse position
Func GetMousePosition()
	$pos = MouseGetPos()
	
	If $pos[0] < 5 then
		MinimizeAll()
	EndIf
EndFunc

; check to see if the left mouse button is pressed. Did not write this function.
Func _IsPressed($hexKey)
  Local $aR, $bO
  
  $hexKey = '0x' & $hexKey
  $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
  If Not @error And BitAND($aR[0], 0x8000) = 0x8000 Then
     $bO = 1
  Else
     $bO = 0
  EndIf
  
  Return $bO
EndFunc 
