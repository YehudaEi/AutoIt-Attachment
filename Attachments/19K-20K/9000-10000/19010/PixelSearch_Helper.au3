; ---------------------------------------------
; PixelSearch Helper.
;
; Version    : 1.0
;
; Written by : Jokke 
; Date       : 2008.02.17
; Contact    : joachim.nordvik@gmail.com 
; ---------------------------------------------
#NoTrayIcon
#include <GUIConstants.au3>
#Include <Misc.au3>
#include <GuiListView.au3>
#include <array.au3>

HotKeySet("!c","Color_Set") 

Global $version = "1.0"
Global $wintitle = "Pixel-Search Helper V."&$version 

Dim $GUI,$Left,$Top,$Right,$Bottom 
	
$GUI_MAIN = GUICreate($wintitle,210,300,200,200)
;Color
$color_label   = GUICtrlCreateEdit('Hover mouse over selected color, press Alt+C to set color. Or write hex color into input box.',5,5,200,50,$ES_READONLY)
$color_graphic = GUICtrlCreateGraphic ( 5, 60 , 100 , 50 )
$color_input   = GUICtrlCreateInput("FFFFFF",110,60,95,22)
$color_change  = GUICtrlCreateButton("Set color",110,86,95,22)
GUICtrlSetBkColor($color_graphic,0xffffff)
;Code.
$code_label	   = GUICtrlCreateEdit('Draw search area when you select draw area. Step 1 find start position top-left area press Alt, Step 2 find bottom-right area, press Alt. Done.',5,115,200,60,$ES_READONLY)
$code_button   = GUICtrlCreateButton("Draw Area",5,180,100,22)
Dim $code_array
;Search.
$search_times   = 0
$search_success = 0
$search_label   = GUICtrlCreateEdit('Test a search here, remeber to draw area first. You have tested search '&$search_times&' times this session. Search have succeeded '&$search_success&' times this session.',5,205,200,60,$ES_READONLY)
$search_button  = GUICtrlCreateButton("Test search",5,270,100,22)
;Output Code.
$output_button  = GUICtrlCreateButton("Create code",110,270,97,15) 
;Ontop
$ontop_label = GUICtrlCreateLabel("Keep me on top",112,285) 
$ontop_check = GUICtrlCreateCheckbox("",194,287,12,12)
GUISetState(@SW_SHOW)

GUICtrlSetState($ontop_check,$GUI_CHECKED)
WinSetOnTop($wintitle,"",1)

While 1
	$msg = GUIGetMsg($GUI_MAIN) 
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ontop_check
			If BitAnd(GUICtrlRead($ontop_check),$GUI_CHECKED) = 1 Then
				WinSetOnTop($wintitle,"",1)
			Else
				WinSetOnTop($wintitle,"",0)
			EndIf 
		Case $color_change
			$color = Dec(GUICtrlRead($color_input))
			GUICtrlSetBkColor($color_graphic,$color)
		Case $code_button
			If UBound($code_array) > 0 Then
				GUIDelete($GUI)
				GUIDelete($Top)
				GUIDelete($Left)
				GUIDelete($Right)
				GUIDelete($Bottom)
			EndIf
				
			$code_array = Draw_Area()
		Case $search_button
			If UBound($code_array) > 0 Then  
				TestSearch($code_array,Dec(GUICtrlRead($color_input)))  
			Else
				MsgBox(64,"Error","Remember to draw search area before you test search.",10) 
			EndIf
		Case $output_button
			If UBound($code_array) > 0 Then  
				Create_Code($code_array,Dec(GUICtrlRead($color_input)))
			Else
				MsgBox(64,"Error","Remember to draw search area before you create code.",10) 
			EndIf
	EndSwitch 
WEnd

Func Create_Code($array,$color)
	
	$GUI_Output = GUICreate($wintitle&" generated code.",500,400) 
	
	GUISetFont (9, 400, 0, "Lucida Console") 
	
	$console = GUICtrlCreateEdit("",5,5,490,350) 
	GUICtrlSetData($console,";------------------------------"&@CRLF,1)
	GUICtrlSetData($console,"; "&$wintitle&" generated code."&@CRLF,1) 
	GUICtrlSetData($console,";"&@CRLF,1) 
	GUICtrlSetData($console,"; Version   : "&$version&@CRLF,1)
	GUICtrlSetData($console,"; Generated : "&@HOUR&":"&@MIN&":"&@SEC&" - "&@YEAR&"."&@MON&"."&@MDAY&@CRLF,1)
	GUICtrlSetData($console,";"&@CRLF,1) 
	GUICtrlSetData($console,"; Created by: Joachim Nordvik"&@CRLF,1)
	GUICtrlSetData($console,"; Contact   : Joachim.Nordvik@gmail.com"&@CRLF,1)
	GUICtrlSetData($console,";------------------------------"&@CRLF,1)
	GUICtrlSetData($console,""&@CRLF,1) 
	GUICtrlSetData($console,""&@CRLF,1) 
	GUICtrlSetData($console,""&@CRLF,1)
	GUICtrlSetData($console,"While 1"&@CRLF,1)
	GUICtrlSetData($console,"	$search = PixelSearch("&$array[1]&","&$array[0]&","&$array[2]&","&$array[3]&","&$color&",5)"&@CRLF,1)
	GUICtrlSetData($console,"	If Not @error Then"&@CRLF,1)
	GUICtrlSetData($console,'		;This is where you add your own code.'&@CRLF,1)
	GUICtrlSetData($console,'		ConsoleWrite("Found pixel matching color, X: "&$search[0]&" Y: "&$search[1]&@crlf)'&@CRLF,1)
	GUICtrlSetData($console,'	EndIf'&@CRLF,1)
	GUICtrlSetData($console,'	Sleep(25)'&@CRLF,1) 
	GUICtrlSetData($console,'Wend'&@CRLF,1)
	
	$output_copy = GUICtrlCreateButton("Copy code",5,365,100,22)
	
	GUISetState(@SW_SHOW)
	 
	
	While 1
		$msg2 = GUIGetMsg($GUI_Output)
		Switch $msg2
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $output_copy
				ClipPut(GUICtrlRead($console))
		EndSwitch
	WEnd
	
	GUIDelete($GUI_Output)
	
EndFunc
 
Func TestSearch($array,$color)
	
	MsgBox(0,"Search","Searching for color: "&Hex($color),5)
	   
	$search_times +=1    
	Local $success = 0
	Local $timer[2] = [TimerInit(),2000] ;Test search for 1 secound.
	
	While 1  
		$search = PixelSearch($array[1],$array[0],$array[2],$array[3],$color,10)
		If Not @error Then
			$search_success +=1
			$success = 1 
			ExitLoop
		EndIf 
		
		If TimerDiff($timer[0]) > $timer[1] Then
			ExitLoop
		EndIf
	WEnd
	
	If $success = 1 Then
		MsgBox(0,"Search succeeded.","Found color @ X: "&$search[0]&" Y: "&$search[1],10)
		MouseMove($search[0],$search[1],1)
	Else
		MsgBox(0,"Search failed.","Unable to find color.",10)
	EndIf
	
	GUICtrlSetData($search_label,'Test a search here, remeber to draw area first. You have tested search '&$search_times&' times this session. Search have succeeded '&$search_success&' times this session.')
	
	
EndFunc

Func Draw_Area()
	
	; ---------------------------------------------------------------------
	; Thanks to Manadar who wrote parts of this consept, once upon a time.
	; ---------------------------------------------------------------------
	
	Do
		$pos = MouseGetPos()
		ToolTip("Click Alt to set." & @CRLF & "top: " & $pos[1] & " left: " & $pos[0])
		Sleep(25)
	Until _IsPressed(12)
	ToolTip("")
	
	Local $ScanWidth = 1, $ScanHeight = 1
	Local $positions[4]
	$x = $pos[0]
	$y = $pos[1]
	$GUI = GUICreate("", 0, 0, $x, $y, $WS_POPUP)
	$Top = GUICreate("Top Line", $ScanWidth, 2, $x, $y, $WS_POPUP, -1, $GUI)
	GUISetBkColor(0xFF0000)
	GUISetState()
	$Left = GUICreate("Left Line", 2, $ScanHeight, $x, $y, $WS_POPUP, -1, $GUI)
	GUISetBkColor(0xFF0000)
	GUISetState()
	$Right = GUICreate("Right Line", 2, $ScanHeight, $x + $ScanWidth - 2, $y, $WS_POPUP, -1, $GUI)
	GUISetBkColor(0xFF0000)
	GUISetState()
	$Bottom = GUICreate("Bottom Line", $ScanWidth, 2, $x, $y + $ScanHeight, $WS_POPUP, -1, $GUI)
	GUISetBkColor(0xFF0000)
	GUISetState()
	Sleep(800)
	
	
	Do
		$MousePos = MouseGetPos()
		ToolTip("Click Alt to set." & @CRLF & "bottom: " & $MousePos[1] - $y & " right: " & $MousePos[0] - $x)
		WinMove($Top, "", $x, $y, $ScanWidth, 2)
		WinMove($Left, "", $x, $y, 2, $ScanHeight) 
		WinMove($Right, "", $x + $ScanWidth - 2, $y, 2, $ScanHeight)  
		WinMove($Bottom, "", $x, $y + $ScanHeight, $ScanWidth, 2)
		If Not (($MousePos[0] - $x) <= 0) Then
			$ScanWidth = $MousePos[0] - $x + 1
		EndIf
		If Not (($MousePos[1] - $y) <= 0) Then
			$ScanHeight = $MousePos[1] - $y - 1
		EndIf
	Until _IsPressed(12)
	
	$positions[0] = $y
	$positions[1] = $x
	$positions[2] = $MousePos[0] ; - $y
	$positions[3] = $MousePos[1] ; - $x
	
	ToolTip("")
	

	Return $positions
EndFunc

Func Color_Set()
	$color = PixelGetColor(MouseGetPos(0),MouseGetPos(1))
	GUICtrlSetBkColor($color_graphic,$color)
	$color = Hex($color)
	GUICtrlSetData($color_input,$color)
EndFunc