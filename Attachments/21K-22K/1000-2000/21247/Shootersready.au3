#include <GUIConstants.au3>


	$Reading = 0.0
	$Result = 0.0
	$Size = 0.0
	$Reading = 0.0	

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("ShootersReady.com Calc by Usmiv4o", 184, 388, 193, 125)
$Up = GUICtrlCreateLabel("Up", 14, 40, 105, 17)
$Rang = GUICtrlCreateLabel("Range", 14, 72, 100, 17)
$Wnd = GUICtrlCreateLabel("Wind", 14, 108, 120, 17)

;$Distance1 = GUICtrlCreateInput("Distance1", 40, 40, 105, 21)
;$Fall1 = GUICtrlCreateInput("Fall1", 40, 72, 105, 21)
;$Wind1 = GUICtrlCreateInput("Input1", 40, 108, 105, 21)
;$Distance2 = GUICtrlCreateInput("Input2", 40, 140, 105, 21)
;$Fall2 = GUICtrlCreateInput("Input1", 40, 177, 105, 21)

$Win = GUICtrlCreateInput("Wind", 42, 212, 105, 21)
$Siz = GUICtrlCreateInput("Size", 42, 244, 105, 21)
$Readin = GUICtrlCreateInput("MillDotReading", 42, 280, 105, 21)

$BTN = GUICtrlCreateButton("C", 120, 320, 49, 25, 0)

;$Wind = GUICtrlCreateLabel("Wind", 24, 360, 29, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###








	$msg = 0
While $msg <> $GUI_EVENT_CLOSE
		$msg = GUIGetMsg()
Select
		
Case $msg = $btn
	Sleep (1000)	
	$inch = 25.4
	$Size = GUICtrlRead($Siz)
	$Reading = GUICtrlRead($Readin)
	$Range = GUICtrlRead($Rang)	
	
	ConsoleWrite ($Size & " Size" & @CRLF)
	ConsoleWrite ($Reading & " Reading " & @CRLF)

	$Result = ($Size * $inch) 
	$Result = ($Result / $Reading)
	;MsgBox(4096, "drag drop file", $Result)
	
	$Result = Round ($Result, 2)
	ConsoleWrite ($Result & " Range [m]" & @CRLF)
	GUICtrlSetData($Rang, "Range " & $Result & " [M]")
	
	;MsgBox(4096, "drag drop file", $Result)
	



	


	$Distance = Round($Result / 100) * 100
	ConsoleWrite ($Distance & " Distance rounded [m]" & @CRLF)
	if $Result > $Distance Then
		$Distance1 = $Distance
		$Distance2 = $Distance + 50	
		ConsoleWrite ($Distance1 & " $Distance1 [M]" & @CRLF)
		ConsoleWrite ($Distance2 & " $Distance2 [M]" & @CRLF)
	Else
		$Distance2 = $Distance
 		$Distance1 = $Distance - 50	
		ConsoleWrite ($Distance1 & " $Distance1 [M]" & @CRLF)
		ConsoleWrite ($Distance2 & " $Distance2 [M]" & @CRLF)		
	EndIf
	
	
	$DistanceDiference =  $Result - $Distance1
	$DistanceDiference = $DistanceDiference / 100
		ConsoleWrite ($DistanceDiference & " DistanceDiference [%]" & @CRLF)	
	
	$Fall1 = IniRead(@ScriptDir & "\SH.ini", $Distance1,  "E", "NotFound")
		ConsoleWrite ($Fall1 & " Fall1 [MOA]" & @CRLF)
	$Fall2 = IniRead(@ScriptDir & "\SH.ini", $Distance2,  "E", "NotFound")
		ConsoleWrite ($Fall2 & " Fall2 [MOA]" & @CRLF)	
		
		


	
	$Fall1Diference = $Fall2 - $Fall1
		ConsoleWrite ($Fall1Diference & " $Fall1Diference [Click]" & @CRLF)		
	$Fall = $Fall1Diference * $DistanceDiference
	$Fall = $Fall1 + $Fall	
		ConsoleWrite ($Fall & " Fall [Click]" & @CRLF)		

	GUICtrlSetData($Up, "Up " & $Fall & "[Cl]") ;Write Fall Corection
	

;WIND
	$Wind = GUICtrlRead($Win)	
		ConsoleWrite ($Wind & " Wind [Inch]" & @CRLF)		
	$Wind1 = IniRead(@ScriptDir & "\SH.ini", $Distance1,  "W", "NotFound")
		ConsoleWrite ($Wind1 & " Wind1 [Inch]" & @CRLF)	
	$Wind2 = IniRead(@ScriptDir & "\SH.ini", $Distance2,  "W", "NotFound")
		ConsoleWrite ($Wind2 & " Wind2 [Inch]" & @CRLF)	
	$WinDiference = $Wind2 - $Wind1
		ConsoleWrite ($WinDiference & " Wind2 - Wind1 [Inch]" & @CRLF)		
		
	;$WindRound = Round($Wind, 2)
	;ConsoleWrite ($Wind & " Wind rounded [Inch]" & @CRLF)
	
		ConsoleWrite ($DistanceDiference & " DistanceDiference [%]" & @CRLF)		
	$WndC = $WinDiference * $DistanceDiference
		ConsoleWrite ($WndC & " WndDif * DistDif [Inch]" & @CRLF)		
	$WndC = $Wind1 + $WndC
		ConsoleWrite ($WndC & " Wnd + Wind1 [Inch]" & @CRLF)

	ConsoleWrite ($Result & " Range [m]" & @CRLF)
	
	$WndC = Round($WndC / $Result, 5)
		;ConsoleWrite ($WndC & " Wnd  / Distance [Inch]" & @CRLF)		
		ConsoleWrite ($WndC & " Wnd Rounded [MOA]" & @CRLF)

	$WndC = $WndC * 10000
		ConsoleWrite ($WndC & " Wnd  [MOA]" & @CRLF)	
	GUICtrlSetData($Wnd, "Wind " & $WndC & " [Click]") ;Write Wind Corection

EndSelect	

WEnd	