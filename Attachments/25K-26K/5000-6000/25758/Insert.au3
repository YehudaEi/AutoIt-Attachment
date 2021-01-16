
; Requires AutoIt v3.0.0.0 or thereabouts

; GUI FUNCTIONS
; Insert(), MainTextEdit()
; FUNCTIONS
; GetInsertDetails()

#include <WinApi.au3>
#include <StructureConstants.au3>
#include <WindowsConstants.au3>
#Include <Color.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>	
#include <Constants.au3>
#include <Misc.au3>
#include <EditConstants.au3>
	
Global $Button_up, $Button_x, $Edit_rit, $Group_rit, $Item_div, $Item_exit, $Menu_cont

Global $album, $artini, $artist, $blank, $cdrear, $cdtitle, $comment, $compilation, $covini
Global $cursor, $form, $i, $id, $Insert, $InsertEdit, $inserttxt, $l, $leftspinetxt, $lsize
Global $media, $n, $num, $recording, $rightspinetxt, $rsize, $text, $time, $track, $ttime
Global $tyear, $update, $x, $y, $year

$covini = @ScriptDir & "\Cover.ini"

If $CmdLine[0] <> 0 Then
	$id = $CmdLine[1]
	$artist = $CmdLine[2]
	$dbase = @ScriptDir & "\Database"
	$artini = $dbase & "\" & $artist & ".ini"
	If FileExists($artini) Then
		$album = IniRead($artini, $id, "title", "")
		$cdtitle = $artist & " - " & $album
		GetInsertDetails()
	Else
		Exit
	EndIf
EndIf

Insert()

Exit

Func Insert()
    Local $hGUI, $hDC
	Local $lRect, $lrotate, $rFont, $RotateMeL
	Local $rRect, $rrotate, $lFont, $RotateMeR

    ; Create GUI
    $hGUI = GUICreate('', 500, 400, -1, -1, $WS_POPUP + $WS_BORDER, $WS_EX_TOPMOST)
	;GUISetBkColor(0xFFFF00, $hGUI)
	
	$Label_dets = GUICtrlCreateLabel("", 20, 0, 460, 400, $SS_CENTER + $SS_NOPREFIX + $SS_SUNKEN)
	GUICtrlSetFont($Label_dets, 8, 600)
	;
	$Menu_cont = GUICtrlCreateContextMenu($Label_dets)
	$Item_exit = GUICtrlCreateMenuitem("Exit", $Menu_cont)
	$Item_div = GUICtrlCreateMenuitem("", $Menu_cont)
	;
	If $cdrear = "" Then $cdrear = "Not Yet Completed!"
	GUICtrlSetData($Label_dets, $cdrear)
	
    GUISetState()
   
    ; Updates the specified rectangle or region in a window's client area
    _WinAPI_RedrawWindow($hGUI)
	
	;$bklblft = GUICtrlCreateLabel("", 0, 0, 20, 400)
	
    ; Create Left RECT-structure, fill data
    $lRect = DllStructCreate($tagRECT)
    DllStructSetData($lRect, 'Left', 2)
    DllStructSetData($lRect, 'Top', 385)
   
    ; Set Left rotation
    $lrotate = 90 *10 ; angle *10
   
    ; Create structure for Left rotate text, fill data
    $RotateMeL = DllStructCreate($tagLOGFONT)
    DllStructSetData($RotateMeL, 'Escapement', $lrotate)
    ;DllStructSetData ($RotateMeL, 'Height', (70 * -3)/_WinAPI_TwipsPerPixelY())
	DllStructSetData($RotateMeL, 'Height', 220/_WinAPI_TwipsPerPixelY())
	DllStructSetData($RotateMeL, 'Weight', 600)
    ;DllStructSetData ($RotateMeL, 'Italic', True)
 ;DllStructSetData ($RotateMeL, 'Underline', True)
 ;DllStructSetData ($RotateMeL, 'StrikeOut', True)
    DllStructSetData($RotateMeL, 'FaceName', 'Courier New')
   
    ; Creates a logical Left font that has specific characteristics
    $lFont = _WinAPI_CreateFontIndirect($RotateMeL)
 	
    ; Create Right RECT-structure, fill data
    $rRect = DllStructCreate($tagRECT)
    DllStructSetData($rRect, 'Left', 498)
    DllStructSetData($rRect, 'Top', 15)
   
    ; Set Right rotation
    $rrotate = 270 *10 ; angle *10
   
    ; Create structure for Right rotate text, fill data
    $RotateMeR = DllStructCreate($tagLOGFONT)
    DllStructSetData($RotateMeR, 'Escapement', $rrotate)
	DllStructSetData($RotateMeR, 'Height', 220/_WinAPI_TwipsPerPixelY())
	DllStructSetData($RotateMeR, 'Weight', 600)
    DllStructSetData($RotateMeR, 'FaceName', 'Courier New')
   
    ; Creates a logical Right font that has specific characteristics
    $rFont = _WinAPI_CreateFontIndirect($RotateMeR)
  
    ; Retrieves a handle of a display device context for the client area a window
    $hDC = _WinAPI_GetDC($hGUI)
   
    ; Set text- and back color
    _WinAPI_SetTextColor($hDC, 0x0000FF) ; Red
   ; _WinAPI_SetTextColor($hDC, 0x000000) ; Black
   ; _WinAPI_SetBkColor ($hDC, 0xFFFF00)
	;_WinAPI_SetBkColor ($hDC, PixelGetColor(250, 350, $hGUI))
;~ 	_WinAPI_SetBkMode($hDC, $TRANSPARENT)
   
	;GUICtrlSetBkColor($bklblft, PixelGetColor(5, 50, $hGUI))
	
	;GUISetBkColor(0xFFFF00, $hGUI)
   
	If $cdtitle = "" Then $cdtitle = 'DEEP PURPLE - Abandon and Perpendicular'
	$leftspinetxt = $cdtitle
	$rightspinetxt = $cdtitle
   
    ; Selects an object into the specified device context
    _WinAPI_SelectObject($hDC, $lFont)
	
    ; Draws formatted text in the specified Left rectangle
    _WinAPI_DrawText($hDC, $leftspinetxt, $lRect, BitOR($DT_NOCLIP, $DT_NOPREFIX, $DT_MODIFYSTRING))
    ;_WinAPI_DrawText($hDC, $leftspinetxt, $lRect, BitOR ($DT_NOCLIP, $DT_NOPREFIX, $DT_SINGLELINE, $DT_MODIFYSTRING))
	;_WinAPI_DrawText($hDC, $leftspinetxt, $lRect, BitOR ($DT_NOPREFIX, $DT_SINGLELINE))
  
    ; Selects an object into the specified device context
    _WinAPI_SelectObject($hDC, $rFont)
	
    ; Draws formatted text in the specified Right rectangle
    _WinAPI_DrawText($hDC, $rightspinetxt, $rRect, BitOR($DT_NOCLIP, $DT_NOPREFIX, $DT_MODIFYSTRING))
    ;_WinAPI_DrawText($hDC, $rightspinetxt, $rRect, BitOR ($DT_NOCLIP, $DT_NOPREFIX, $DT_SINGLELINE, $DT_MODIFYSTRING))
    ;_WinAPI_DrawText($hDC, $rightspinetxt, $rRect, BitOR ($DT_NOPREFIX, $DT_SINGLELINE))
   
    ; Loop until user exits
    While 1
		$cursor = GUIGetCursorInfo($hGUI)
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Item_exit
		;Case $msg = -3
			; QUIT / EXIT / CLOSE
			GUIDelete($hGUI)
			ExitLoop
		Case Else
			$x = $cursor[0]
			$y = $cursor[1]
			If $x > 0 And $x < 500 And $y > 0 And $y < 400 And $cursor[2] = 1 Then
				$blank = ""
				If $x > 0 And $x < 20 And $y > 0 And $y < 400 And $cursor[2] = 1 Then
					; Left spine clicked
					$lsize = StringLen($leftspinetxt)
					For $l = 1 To $lsize
						$blank = $blank & " "
					Next
					Run(@ScriptDir & "\InputOnTop.exe")
					WinSetOnTop($hGUI, "", 0)
					WinSetState($hGUI, "", @SW_DISABLE)
					$text = InputBox("Left Spine Text", "Enter or edit the text to be diplayed on the left CD spine.", $leftspinetxt, "", 350, 120)
					If Not @error Then $leftspinetxt = $text
					WinSetState($hGUI, "", @SW_ENABLE)
					WinSetOnTop($hGUI, "", 1)
					WinActivate($hGUI, "")
					_WinAPI_SelectObject($hDC, $lFont)
					_WinAPI_DrawText($hDC, $blank, $lRect, BitOR($DT_NOCLIP, $DT_NOPREFIX, $DT_MODIFYSTRING))
				ElseIf $x > 480 And $x < 500 And $y > 0 And $y < 400 And $cursor[2] = 1 Then
					; Right spine clicked
					$rsize = StringLen($rightspinetxt)
					For $l = 1 To $rsize
						$blank = $blank & " "
					Next
					Run(@ScriptDir & "\InputOnTop.exe")
					WinSetOnTop($hGUI, "", 0)
					WinSetState($hGUI, "", @SW_DISABLE)
					$text = InputBox("Right Spine Text", "Enter or edit the text to be diplayed on the right CD spine.", $rightspinetxt, "", 350, 120)
					If Not @error Then $rightspinetxt = $text
					WinSetState($hGUI, "", @SW_ENABLE)
					WinSetOnTop($hGUI, "", 1)
					WinActivate($hGUI, "")
					_WinAPI_SelectObject($hDC, $rFont)
					_WinAPI_DrawText($hDC, $blank, $rRect, BitOR($DT_NOCLIP, $DT_NOPREFIX, $DT_MODIFYSTRING))
				ElseIf $x > 20 And $x < 480 And $y > 0 And $y < 400 And $cursor[2] = 1 Then
					$inserttxt = GUICtrlRead($Label_dets)
					WinSetOnTop($hGUI, "", 0)
					WinSetState($hGUI, "", @SW_DISABLE)
					MainTextEdit()
					WinSetState($hGUI, "", @SW_ENABLE)
					WinSetOnTop($hGUI, "", 1)
					If $update = 1 Then GUICtrlSetData($Label_dets, $inserttxt)
				EndIf
				_WinAPI_SelectObject($hDC, $lFont)
				_WinAPI_DrawText($hDC, $leftspinetxt, $lRect, BitOR($DT_NOCLIP, $DT_NOPREFIX, $DT_MODIFYSTRING))
				_WinAPI_SelectObject($hDC, $rFont)
				_WinAPI_DrawText($hDC, $rightspinetxt, $rRect, BitOR($DT_NOCLIP, $DT_NOPREFIX, $DT_MODIFYSTRING))
			EndIf
			;;;
		EndSelect
    WEnd
	;
    ; Clean up resources
    _WinAPI_ReleaseDC($hGUI, $hDC)
	;
EndFunc   ;==>_Main (GUI)


Func MainTextEdit()
	#region --- GuiBuilder code Start ---
	; Script generated by AutoBuilder 0.8 Prototype
	$InsertEdit = GuiCreate("Main Text Edit", 500, 510, -1, -1, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX)
	;
	; CONTROLS
	$Group_rit = GuiCtrlCreateGroup("Rear Insert Text", 10, 10, 480, 430)
	$Edit_rit = GuiCtrlCreateEdit("", 20, 30, 460, 400, $ES_MULTILINE + $ES_WANTRETURN + $ES_CENTER)
	GUICtrlSetFont($Edit_rit, 8, 600)
	;
	$Button_up = GuiCtrlCreateButton("UPDATE", 310, 450, 100, 50)
	GUICtrlSetFont($Button_up, 9, 600)
	;
	$Button_x = GuiCtrlCreateButton("EXIT", 430, 450, 50, 50)
	;
	; SETTINGS
	$inserttxt = StringSplit($inserttxt, Chr(13))
	For $i = 1 To $inserttxt[0]
		If $i < $inserttxt[0] Then
			GUICtrlSetData($Edit_rit, $inserttxt[$i] & @CRLF, 1)
		Else
			GUICtrlSetData($Edit_rit, StringStripWS($inserttxt[$i], 3), 1)
		EndIf
	Next
	
	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_x
			; 
			$update = ""
			GUIDelete($InsertEdit)
			ExitLoop
		Case $msg = $Button_up
			; UPDATE
			$update = 1
			$inserttxt = GUICtrlRead($Edit_rit)
			$inserttxt = StringReplace($inserttxt, @CRLF, Chr(13))
			GUIDelete($Insert)
			ExitLoop
		Case Else
			;;;
		EndSelect
	WEnd
	;
	#endregion --- GuiBuilder generated code End ---
EndFunc ;=> MainTextEdit (GUI)


Func GetInsertDetails()
	$cdrear = $artist & " - " & $album
	$num = IniRead($artini, $id, "numtracks", "")
	For $n = 0 To $num - 1
		$track = IniRead($artini, $id, $n, "")
		$cdrear = $cdrear & Chr(13) & $n + 1 & ". " & $track
		$ttime = IniRead($artini, $id, "tt" & $n, "")
		If $ttime <> "" Then $cdrear = $cdrear & " (" & $ttime & ")"
		$tyear = IniRead($artini, $id, "ty" & $n, "")
		If $tyear <> "" Then $cdrear = $cdrear & " " & $tyear
	Next
	$year = IniRead($artini, $id, "year", "")
	If $year <> "" Then $cdrear = $cdrear & Chr(13) & Chr(13) & "Recorded in " & $year
	$time = IniRead($artini, $id, "time", "")
	If $time <> "" Then $cdrear = $cdrear & Chr(13) & "Total Time = " & $time
	$form = IniRead($artini, $id, "form", "")
	If $form <> "" Then $cdrear = $cdrear & Chr(13) & Chr(13) & $form
	$media = IniRead($artini, $id, "media", "")
	If $media <> "" Then $cdrear = $cdrear & " " & $media
	$compilation = IniRead($artini, $id, "compilation", "")
	If $compilation <> "" Then $cdrear = $cdrear & Chr(13) & Chr(13) & "(" & $compilation & " Compilation)"
	$recording = IniRead($artini, $id, "recording", "")
	If $recording <> "" Then $cdrear = $cdrear & Chr(13) & Chr(13) & $recording & " Recording"
	$comment = IniRead($artini, $id, "comment", "")
	If $comment <> "" Then $cdrear = $cdrear & Chr(13) & Chr(13) & $comment
EndFunc ;=> GetInsertDetails

